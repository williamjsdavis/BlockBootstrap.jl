function bootstrapStatistic(data, chosenStatistic, Nresample)
    # Resamples and funs statistic on each sample

    Ndata = length(xSample);

    randomDraw() = rand(1:Ndata, Ndata, 1)

    #Single bootstrap
    indices, estimatedParameterBootstrap = singleSample(data, randomDraw, chosenStatistic);

    println(string(estimatedParameterBootstrap))

    # Multiple bootstrap samples
    parameterVector = Vector{Float64}(undef,Nresample);
    indicesVector = Vector{Any}(undef,Nresample);
    for n in 1:Nresample
        indicesVector[n], parameterVector[n] = singleSample(data, randomDraw, chosenStatistic);
    end

    return (indicesVector, parameterVector);
end
function singleSample(data, randomDraw, chosenStatistic)
    # Single bootstrap sample
    indices = randomDraw();
    bootstrapSample = data[indices];
    estimatedParameterBootstrap = chosenStatistic(bootstrapSample);
    return (indices, estimatedParameterBootstrap)
end
