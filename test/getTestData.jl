# For generating test data
# using Primes

function getTestDataLinearInts(dataLength)
    firstN = Array{Int64,1}(undef, dataLength)
    for ii in 1:dataLength
        firstN[ii] = ii
    end
    return firstN
end
function getTestDataRandomInts(dataLength)
    firstNrand = Array{Int64,1}(undef, dataLength+1)
    randDiff = Array{Int64,1}(undef, dataLength)
    firstNrand[1] = rand(1:dataLength)
    for ii in 1:dataLength
        firstNrand[ii+1] = rand(1:dataLength)
        randDiff[ii] = firstNrand[ii+1] - firstNrand[ii]
    end
    return randDiff
end
function getTestDataLinearFloats(dataLength)
    firstN = Array{Float32,1}(undef, dataLength)
    startN = 5.0
    lastN = 10.0
    dataRange = lastN - startN;
    dataStep = dataRange/(dataLength-1)
    firstN[1] = startN
    for ii in 2:dataLength
        firstN[ii] = firstN[ii-1] + dataStep
    end
    return firstN
end
