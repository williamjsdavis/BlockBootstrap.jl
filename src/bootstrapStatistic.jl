# Pass samples to statistic
function bootstrapStatistic(data::Array{<:Real,1}, statisticHandle::Function, bootstrapSampleHandle::Function, blockLength::Integer, NbootstrapReplicates::Integer)
        # Bootstrap a statistic
        fullDataEstimate = statisticHandle(data);
        estimateType = typeof(fullDataEstimate);

        # Default number of blocks
        Ndata = length(data);
        Nblocks = ceil(Int, Ndata/blockLength);

        resampleIndexBB, resampleDataBB = bootstrapSampleHandle(data, blockLength, Nblocks, NbootstrapReplicates);

        replicateEstimate = Vector{estimateType}(undef, NbootstrapReplicates);
        for ii in 1:NbootstrapReplicates
                replicateEstimate[ii] = statisticHandle(resampleDataBB[ii]);
        end
        return fullDataEstimate, replicateEstimate, resampleIndexBB, resampleDataBB
end
