## Main script
using Plots

# Get test data
include("test/getTestData.jl")
n = 55;
index = 1:n;
testData = getTestDataPrimeInts(n);
#println(testData)
plt1 = plot(testData);
display(plt1);

# Resample test data
include("src/bootstrapSampling.jl")

# MBBsample(data, blockLength, Nblocks, NbootstrapReplicates)
Random.seed!(1234)
resampleIndexMBB, resampleDataMBB = MBBsample(testData, 10, 5, 2);

plt2 = plot(index);
plot!(resampleIndexMBB[1]);
plot!(resampleIndexMBB[2]);
display(plt2);

plt3 = plot(testData);
plot!(resampleDataMBB[1]);
plot!(resampleDataMBB[2]);
display(plt3);

# NBBsample(data, blockLength, NbootstrapReplicates)
Random.seed!(1234)
resampleIndexNBB, resampleDataNBB = NBBsample(testData, 10, 5, 2);

plt4 = plot(index);
plot!(resampleIndexNBB[1]);
plot!(resampleIndexNBB[2]);
display(plt4);

plt5 = plot(testData);
plot!(resampleDataNBB[1]);
plot!(resampleDataNBB[2]);
display(plt5);

# CBBsample(data, blockLength, Nblocks, NbootstrapReplicates)
Random.seed!(1234)
resampleIndexCBB, resampleDataCBB = CBBsample(testData, 10, 5, 2);

plt6 = plot(index);
plot!(resampleIndexCBB[1]);
plot!(resampleIndexCBB[2]);
display(plt6);

plt7 = plot(testData);
plot!(resampleDataCBB[1]);
plot!(resampleDataCBB[2]);
display(plt7);
