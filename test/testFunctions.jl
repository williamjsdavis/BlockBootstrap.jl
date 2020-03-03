# Testing functions
function testAllData(Ndata, blockLength, Nblocks, NbootstrapReplicates)
    # Testing different data sources

    @testset "Linear integers" begin
        testDataLinearInts = getTestDataLinearInts(Ndata);
        testAllMethods(testDataLinearInts, blockLength, Nblocks, NbootstrapReplicates)
    end

    @testset "Random integers" begin
        testDataPrimeInts = getTestDataPrimeInts(Ndata);
        testAllMethods(testDataPrimeInts, blockLength, Nblocks, NbootstrapReplicates)
    end

    @testset "Linear floats  " begin
        testDataLinearFloats = getTestDataLinearFloats(Ndata);
        testAllMethods(testDataLinearFloats, blockLength, Nblocks, NbootstrapReplicates)
    end

end
function testAllMethods(testData, blockLength, Nblocks, NbootstrapReplicates)
    @testset "All" begin
        blockBootstrapTest(MBBsample, testData, blockLength, Nblocks, NbootstrapReplicates)
        blockBootstrapTest(NBBsample, testData, blockLength, Nblocks, NbootstrapReplicates)
        blockBootstrapTest(CBBsample, testData, blockLength, Nblocks, NbootstrapReplicates)
    end
end
function blockBootstrapTest(functionHandle, testData, blockLength, Nblocks, NbootstrapReplicates)

    testDataType = typeof(testData[1]);
    bootDataLength = blockLength * Nblocks;

    # Define bootstrap tests
    handleStringIn = string(typeof(functionHandle).name.mt.name);
    stringToPrint = "Testing function " * handleStringIn;

    @testset "$stringToPrint" begin

        resampleIndexBB, resampleDataBB = functionHandle(testData, blockLength, Nblocks, NbootstrapReplicates);

        @testset "Output size" begin
            @test size(resampleIndexBB) == (NbootstrapReplicates,)
            @test size(resampleDataBB) == (NbootstrapReplicates,)
            @test all(x->x==(bootDataLength,), size.(resampleIndexBB))
            @test all(x->x==(bootDataLength,), size.(resampleDataBB))
        end
        @testset "Output type" begin
            @test all(x->x<:Array, typeof.(resampleIndexBB))
            @test all(x->x<:Array, typeof.(resampleDataBB))
            @test typeof(resampleIndexBB[1][1]) <: Unsigned
            @test typeof(resampleDataBB[1][1]) <: Real
            @test resampleDataBB[1][1] isa testDataType
        end
    end
end
