# Pass samples to statistic
function bootstrapStatistic(data, statisticHandle, bootstrapSampleHandle, blockLength, Nblocks, NbootstrapReplicates)
        # Bootstrap a statistic
        fullDataEstimate = statisticHandle(testData);
        estimateType = typeof(fullDataEstimate);

        resampleIndexBB, resampleDataBB = bootstrapSampleHandle(testData, blockLength, Nblocks, NbootstrapReplicates);

        replicateEstimate = Vector{estimateType}(undef, NbootstrapReplicates);
        for ii in 1:NbootstrapReplicates
                replicateEstimate[ii] = statisticHandle(resampleDataBB[ii]);
        end
        return fullDataEstimate, replicateEstimate, resampleIndexBB, resampleDataBB
end
