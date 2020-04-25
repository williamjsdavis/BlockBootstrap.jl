# Types of algorithms
abstract type samplingAlgorithm end
abstract type naiveSamplingAlgorithm <: samplingAlgorithm end
struct naiveSampler <: naiveSamplingAlgorithm
    handle::Function
end

# Sampler objects
MBBsampler = naiveSampler(MBBsample)
NBBsampler = naiveSampler(NBBsample)
CBBsampler = naiveSampler(CBBsample)
