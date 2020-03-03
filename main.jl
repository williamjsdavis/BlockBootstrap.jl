## Main script
using Plots
using Statistics
include("test/getTestData.jl")
include("src/bootstrapSampling.jl")
include("src/bootstrapStatistic.jl")

# Get test data
n = 55;
index = 1:n;
testData = getTestDataLinearFloats(n);

# Resample test data
# MBBsample(data, blockLength, Nblocks, NbootstrapReplicates)
Random.seed!(1234)
resampleIndexMBB, resampleDataMBB = MBBsample(testData, 10, 5, 2);

# Plot data
plt1 = plot(testData);
plot!(resampleDataMBB[1]);
plot!(resampleDataMBB[2]);
display(plt1);

# Bootstrap Statistic
# E.g. mean
statisticHandle = mean;

# bootstrapStatistic(data, statisticHandle, bootstrapSampleHandle, blockLength, Nblocks, NbootstrapReplicates)
fullDataEstimate, replicateEstimate = bootstrapStatistic(testData, statisticHandle, MBBsample, 10, 5, 200);

plt2 = plot(replicateEstimate);
plot!(fullDataEstimate*ones(size(replicateEstimate)));
display(plt2);
