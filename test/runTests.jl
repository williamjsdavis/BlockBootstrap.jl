# Unit testing
using Test
using Random
include("getTestData.jl")
include("testFunctions.jl")
include("../src/bootstrapSampling.jl")

function main()
    # Test settings
    blockLength = 10;
    Nblocks = 5;
    NbootstrapReplicates = 2;
    Ndata = 500;

    # Testing
    println("Starting Bootstrap tests")

    testAllData(Ndata, blockLength, Nblocks, NbootstrapReplicates)

    println("Tests finished")
end

main()
