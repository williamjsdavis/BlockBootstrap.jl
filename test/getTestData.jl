# For generating test data
using Primes

function getTestDataLinearInts(dataLength)
    firstN = Array{Int64,1}(undef, dataLength);
    for ii in 1:dataLength
        firstN[ii] = ii;
    end
    return firstN
end
function getTestDataPrimeInts(dataLength)
    firstNprimes = Array{Int64,1}(undef, dataLength+1);
    primeDiff = Array{Int64,1}(undef, dataLength);
    firstNprimes[1] = prime(1);
    for ii in 1:dataLength
        firstNprimes[ii+1] = prime(ii+1);
        primeDiff[ii] = firstNprimes[ii+1] - firstNprimes[ii];
    end
    return primeDiff
end
function getTestDataLinearFloats(dataLength)
    firstN = Array{Float32,1}(undef, dataLength);
    startN = 5.0;
    lastN = 10.0;
    dataRange = lastN - startN;
    dataStep = dataRange/(dataLength-1);
    firstN[1] = startN;
    for ii in 2:dataLength
        firstN[ii] = firstN[ii-1] + dataStep;
    end
    return firstN
end
