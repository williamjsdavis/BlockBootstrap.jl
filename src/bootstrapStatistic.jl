struct bootstrapResult
        fullDataEstimate
        replicateEstimate
        resampleIndexBB
        resampleDataBB
end
function bootstrapStatistic(data::Array{<:Real,1}, statisticHandle::Function, sampler::samplingAlgorithm, blockLength::Integer, NbootstrapReplicates::Integer)
        # Bootstrap a statistic
        fullDataEstimate = statisticHandle(data)
        estimateType = typeof(fullDataEstimate)

        # Default number of blocks
        Ndata = length(data)
        Nblocks = ceil(Int, Ndata/blockLength)

        # Sampling
        bootstrapSampleHandle = sampler.handle
        resampleIndexBB, resampleDataBB = bootstrapSampleHandle(data, blockLength, Nblocks, NbootstrapReplicates)

        # Statistic on samples
        replicateEstimate = Vector{estimateType}(undef, NbootstrapReplicates)
        for ii in 1:NbootstrapReplicates
                replicateEstimate[ii] = statisticHandle(resampleDataBB[ii])
        end

        bootstrapResultOut = bootstrapResult(fullDataEstimate, replicateEstimate, resampleIndexBB, resampleDataBB)

        return bootstrapResultOut
end
