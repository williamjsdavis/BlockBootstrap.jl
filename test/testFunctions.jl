# Testing functions
function testAllCases()
    @testset "All tests      " begin
        smallTest()
        #mediumTest()
        #bigTest()
    end
end
function smallTest()
    blockLength = 10
    Nblocks = 5
    NbootstrapReplicates = 2
    Ndata = 500
    statisticHandle = mean
    @testset "Small test     " begin
        testAllData(Ndata, statisticHandle, blockLength, Nblocks, NbootstrapReplicates)
    end
end
function mediumTest()
    blockLength = 40
    Nblocks = 10
    NbootstrapReplicates = 400
    Ndata = 5000
    statisticHandle = mean
    @testset "Medium test    " begin
        testAllData(Ndata, statisticHandle, blockLength, Nblocks, NbootstrapReplicates)
    end
end
function bigTest()
    blockLength = 500
    Nblocks = 100
    NbootstrapReplicates = 10000
    Ndata = 50000
    statisticHandle = mean
    @testset "Big test       " begin
        testAllData(Ndata, statisticHandle, blockLength, Nblocks, NbootstrapReplicates)
    end
end
function testAllData(Ndata, statisticHandle, blockLength, Nblocks, NbootstrapReplicates)
    # Testing different data sources
    @testset "Linear integers" begin
        testDataLinearInts = getTestDataLinearInts(Ndata)
        allTestTypes(testDataLinearInts, statisticHandle, blockLength, Nblocks, NbootstrapReplicates)
    end
    @testset "Random integers" begin
        testDataRandomInts = getTestDataRandomInts(Ndata)
        allTestTypes(testDataRandomInts, statisticHandle, blockLength, Nblocks, NbootstrapReplicates)
    end
    @testset "Linear floats  " begin
        testDataLinearFloats = getTestDataLinearFloats(Ndata)
        allTestTypes(testDataLinearFloats, statisticHandle, blockLength, Nblocks, NbootstrapReplicates)
    end
end
function allTestTypes(testData, statisticHandle, blockLength, Nblocks, NbootstrapReplicates)
    @testset "Sampling tests" begin
        testAllSamplingMethods(testData, blockLength, Nblocks, NbootstrapReplicates)
    end
    @testset "Statistic tests" begin
        testAllStatisticMethods(testData, statisticHandle, blockLength, NbootstrapReplicates)
    end
end
function testAllSamplingMethods(testData, blockLength, Nblocks, NbootstrapReplicates)
    @testset "Sampling method type" begin
        samplingTest(MBBsampler, testData, blockLength, Nblocks, NbootstrapReplicates)
        samplingTest(NBBsampler, testData, blockLength, Nblocks, NbootstrapReplicates)
        samplingTest(CBBsampler, testData, blockLength, Nblocks, NbootstrapReplicates)
    end
end
function testAllStatisticMethods(testData, statisticHandle, blockLength, NbootstrapReplicates)
    @testset "Statistic method type" begin
        statisticTest(MBBsampler, testData, statisticHandle, blockLength, NbootstrapReplicates)
        statisticTest(NBBsampler, testData, statisticHandle, blockLength, NbootstrapReplicates)
        statisticTest(CBBsampler, testData, statisticHandle, blockLength, NbootstrapReplicates)
    end
end
function statisticTest(sampler, testData, statisticHandle, blockLength, NbootstrapReplicates)
    # Testing statistics functions
    dataLength = length(testData)

    # Define bootstrap tests
    samplingFunctionHandle = sampler.handle
    handleStringIn = string(typeof(samplingFunctionHandle).name.mt.name)
    stringToPrint = "Sampling function " * handleStringIn

    @testset "$stringToPrint" begin
        # Set the seed
        Random.seed!(1)

        # Bootstrap the data
        bootstrapResult = bootstrapStatistic(testData, statisticHandle, sampler, blockLength, NbootstrapReplicates)
        fullDataEstimate = bootstrapResult.fullDataEstimate
        replicateEstimate = bootstrapResult.replicateEstimate
        resampleIndexBB = bootstrapResult.resampleIndexBB
        resampleDataBB = bootstrapResult.resampleDataBB

        # Tests
        @testset "Output size" begin
            @test size(replicateEstimate) == (NbootstrapReplicates,)
            @test size(resampleIndexBB) == (NbootstrapReplicates,)
            @test all(x->x==(dataLength,), size.(resampleIndexBB))
            @test size(resampleDataBB) == (NbootstrapReplicates,)
            @test all(x->x==(dataLength,), size.(resampleDataBB))
        end
        @testset "Output type" begin
            @test typeof(fullDataEstimate) <: Number
            @test typeof(replicateEstimate) <: Array
            @test all(x->x==typeof(fullDataEstimate), typeof.(replicateEstimate))
        end
    end

end
function samplingTest(sampler, testData, blockLength, Nblocks, NbootstrapReplicates)
    # Testing sampling functions
    testDataType = typeof(testData[1])
    bootDataLength = blockLength * Nblocks

    # Define bootstrap tests
    samplingFunctionHandle = sampler.handle
    handleStringIn = string(typeof(samplingFunctionHandle).name.mt.name)
    stringToPrint = "Sampling function " * handleStringIn

    @testset "$stringToPrint" begin
        # Set the seed
        Random.seed!(1)

        # Resample
        resampleIndexBB, resampleDataBB = samplingFunctionHandle(testData, blockLength, Nblocks, NbootstrapReplicates)

        # Get previous value
        savedIndex = savedTestOutputs(NbootstrapReplicates, handleStringIn)

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
            @test typeof(resampleIndexBB[1][1]) <: Integer
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
        out = 37; # 237
    else
        if testSize == 2
            out = 1; # 41
        elseif testSize == 400
            out = 281; # 281
        end
    end
end
