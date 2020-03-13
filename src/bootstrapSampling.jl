# Bootstrap sampling functions
using Random

function MBBsample(data::Array{<:Real,1}, blockLength::Integer, Nblocks::Integer, NbootstrapReplicates::Integer)
    # Moving Block Bootstrap
    # X = data
    # n = Ndata
    # l = blockLength
    # k = Nblocks
    # B = NbootstrapReplicates
    # m = bootDataLength
    Ndata = length(data);
    NpossibleBlocks = Ndata - blockLength + 1;
    bootDataLength = Nblocks*blockLength;
    possibleIndex = collect(1:NpossibleBlocks);

    resampleIndex, resampleData = multipleSample(data, possibleIndex, NbootstrapReplicates, blockLength, Nblocks, bootDataLength, Ndata);

    return resampleIndex, resampleData
end
function NBBsample(data::Array{<:Real,1}, blockLength::Integer, Nblocks::Integer, NbootstrapReplicates::Integer)
    # Nonoverlapping Block Bootstrap
    # X = data
    # n = Ndata
    # l = blockLength
    # b = Nblocks
    # B = NbootstrapReplicates
    # m = bootDataLength
    Ndata = length(data);
    #Nblocks = floor(Int, Ndata/blockLength);
    NpossibleBlocks = Ndata;
    bootDataLength = Nblocks*blockLength;
    possibleIndex = collect(1:blockLength:bootDataLength);

    resampleIndex, resampleData = multipleSample(data, possibleIndex, NbootstrapReplicates, blockLength, Nblocks, bootDataLength, Ndata);
    return resampleIndex, resampleData
end
function CBBsample(data::Array{<:Real,1}, blockLength::Integer, Nblocks::Integer, NbootstrapReplicates::Integer)
    # Circular Block Bootstrap
    # X = data
    # n = Ndata
    # l = blockLength
    # k = Nblocks
    # B = NbootstrapReplicates
    # m = bootDataLength
    Ndata = length(data);
    NpossibleBlocks = Ndata;
    bootDataLength = Nblocks*blockLength;
    possibleIndex = collect(1:Ndata);

    resampleIndex, resampleData = multipleSample(data, possibleIndex, NbootstrapReplicates, blockLength, Nblocks, bootDataLength, Ndata);
    return resampleIndex, resampleData
end
function multipleSample(data::Array{<:Real,1}, possibleIndex::Array{<:Int,1}, NbootstrapReplicates::Integer, blockLength::Integer, Nblocks::Integer, bootDataLength::Integer, Ndata::Integer)
    # Multiple block bootstrap sample
    # X = data
    # n = Ndata
    # l = blockLength
    # b = Nblocks
    # B = NbootstrapReplicates
    # m = bootDataLength

    resampleIndex = Vector{Any}(undef,NbootstrapReplicates);
    resampleData = Vector{Any}(undef,NbootstrapReplicates);
    for ii in 1:NbootstrapReplicates
        resampleIndex[ii] = singleSampleIndex(bootDataLength, Nblocks, blockLength, possibleIndex, Ndata);
        resampleData[ii] = data[resampleIndex[ii]];
    end
    return resampleIndex, resampleData
end
function singleSampleIndex(bootDataLength::Integer, Nblocks::Integer, blockLength::Integer, possibleIndex::Array{<:Int,1}, Ndata::Integer)
    # Single bootsrap sample
    # X = data
    # n = Ndata
    # l = blockLength
    # b = Nblocks
    # B = NbootstrapReplicates
    # m = bootDataLength
    resampleIndex = Vector{UInt32}(undef, bootDataLength);

    randomDraw = rand(possibleIndex, Nblocks, 1);

    for ii in 1:Nblocks
        startIndex = (ii-1)*blockLength+1;
        lastIndex = ii*blockLength;
        inIndex = UnitRange{Int}(randomDraw[ii], randomDraw[ii]+blockLength-1);
        modIndex = mod1.(inIndex, Ndata);
        resampleIndex[startIndex:lastIndex] = modIndex;
    end

    return resampleIndex
end
