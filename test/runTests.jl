# Unit testing
#=
TODO: Add more comparison tests?
TODO: Add bootstrapStatistic tests for p-dimensional statistics
TODO: Add comparison tests for statistics?
=#
using Test
using Random
using StatsBase
include("getTestData.jl")
include("testFunctions.jl")
include("../src/bootstrapSampling.jl")
include("../src/bootstrapStatistic.jl")

function main()
    # Testing
    println("Starting Bootstrap tests")

    testAllCases()

    println("Tests finished")
end

main()
