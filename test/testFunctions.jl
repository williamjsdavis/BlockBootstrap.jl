# Testing functions
function testAllCases()
    # Test different settings
    #testAllData(Ndata, blockLength, Nblocks, NbootstrapReplicates)
    smallTest()
    mediumTest()
    #bigTest()
end
function smallTest()
    # Small test
    blockLength = 10;
    Nblocks = 5;
    NbootstrapReplicates = 2;
    Ndata = 500;
    @testset "Small test     " begin
        testAllData(Ndata, blockLength, Nblocks, NbootstrapReplicates)
    end
end
function mediumTest()
    # Medium test
    blockLength = 40;
    Nblocks = 10;
    NbootstrapReplicates = 400;
    Ndata = 5000;
    @testset "Medium test    " begin
        testAllData(Ndata, blockLength, Nblocks, NbootstrapReplicates)
    end
end
function bigTest()
    # Big test
    blockLength = 500;
    Nblocks = 100;
    NbootstrapReplicates = 10000;
    Ndata = 50000;
    @testset "Big test       " begin
        testAllData(Ndata, blockLength, Nblocks, NbootstrapReplicates)
    end
end
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
    @testset "Method type" begin
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
    stringToPrint = "Sampling function " * handleStringIn;

    @testset "$stringToPrint" begin
        # Set the seed
        Random.seed!(1234)

        # Resample
        resampleIndexBB, resampleDataBB = functionHandle(testData, blockLength, Nblocks, NbootstrapReplicates);

        # Get previous value
        savedIndex = savedTestOutputs(NbootstrapReplicates, handleStringIn);

        # Tests
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
        @testset "Output value" begin
            @test resampleIndexBB[1][1] == savedIndex
        end
    end
end
function savedTestOutputs(testSize,methodType)
    # Hardcoded test results for validation
    if methodType == "MBBsample" || methodType == "CBBsample"
        out = 237;
    else
        if testSize == 2
            out = 41;
        elseif testSize == 400
            out = 281;
        end
    end
end
