## Main script
using Plots
using Statistics
include("test/getTestData.jl")
include("src/bootstrapSampling.jl")
include("src/bootstrapStatistic.jl")

# Get test data
n = 50;
index = 1:n;
testData = getTestDataPrimeInts(n);

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

# Statistical estimate
theoryEstimate = std(testData)/sqrt(n);

# bootstrapStatistic(data, statisticHandle, bootstrapSampleHandle, blockLength, Nblocks, NbootstrapReplicates)
fullDataEstimate, replicateEstimate, resampleIndexBB, resampleDataBB = bootstrapStatistic(testData, statisticHandle, MBBsample, 1, 200);

plt2 = plot(replicateEstimate);
plot!(fullDataEstimate*ones(size(replicateEstimate)));
display(plt2);

# Statistics
bootEstSdotM = std(replicateEstimate);
println(bootEstSdotM)
println(theoryEstimate)

# Plot resampled indexes
plt3 = plot(index);
plot!(resampleIndexBB[1]);
plot!(resampleIndexBB[2]);
display(plt3);
