# Unit testing
#=
TODO: Add comparison tests
TODO: Add bootstrapStatistic tests
=#
using Test
using Random
include("getTestData.jl")
include("testFunctions.jl")
include("../src/bootstrapSampling.jl")

function main()
    # Testing
    println("Starting Bootstrap tests")

    testAllCases()

    println("Tests finished")
end

main()
