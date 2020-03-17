# BlockBootstrap.jl
Statistical block bootstrap library for Julia. Created by William Davis and Maggie Avery.

`BlockBootstrap.jl` is a Julia package for calculating and bootstrapping uncertainties statistics on time-series data.

# Theory

The theory used in this package is based off the book “Resampling methods for dependent data” by S.N. Lahiri, 2003, Springer.

Details of theory to be added.

# Using the package
There are many notebook example of how to use the package in the `./notebooks/` directory. 

### Short example
This example is mostly from `./notebooks/BootstrapSDE.ipynb`. For a time-series observation, such as a realization of the Ornstein-Uhlenbeck stochastic differential equation,

![equation](https://latex.codecogs.com/gif.latex?du&space;=&space;-\alpha&space;u&space;dt&space;&plus;&space;\beta&space;dW_t.)

This solution will look something like the figure below.

<img src="/figures/SDEsolution.png" height="400"/>

Say we want to estimate the parameter ![equation](https://latex.codecogs.com/gif.latex?\alpha) from the realization, and we also want to find the incertainties on that estimation. Define a function handle that returns the statistic of choice (in this example it is `slopeStatisticSet()`, and pass it to the block bootstrapping function `bootstrapStatistic()`.

```Julia
## Calculate the statistic and bootstrap the uncertainties
# Settings
inputData = U;
statisticHandle = slopeStatisticSet;
bootstrapSampleHandle = CBBsample;
blockLength = 1500;
NbootstrapReplicates = 200;

fullDataEstimate, replicateEstimate, resampleIndexBB, resampleDataBB = bootstrapStatistic(
    inputData, statisticHandle, bootstrapSampleHandle, blockLength, NbootstrapReplicates);
```

Settings are defined as functions to the argument `bootstrapStatistic()`, see the header of the function for descriptions. The output `resampleIndexBB` shows how the time indices have been resampled, e.g. see the figure below.

<img src="/figures/MBBindices.png" height="400"/>

The output `fullDataEstimate` is the estimate of the statistics, and `replicateEstimate` is a vector of the statistics for bootstrap replicants, e.g. see the figure below.

<img src="/figures/bootstrapDriftSlope.png" height="400"/>

# TODOs

- [ ] Add more resampling methods.
- [ ] Add more tests for n-dimensional statistics.
- [ ] Resampling scheme for n-dimensional statistics (i.e. Blocks-of-blocks, Politis and Romano, 1992)?
- [ ] Benchmark performance.

# Changelog

- Version 0.9 - Introduced version Maggie and I made for group meetings.

# References

- Lahiri, S. K., & Lahiri, S. N. (2003). Resampling Methods for Dependent Data. Springer Science & Business Media.
- Politis, D. N., & Romano, J. P. (1992). A general resampling scheme for triangular arrays of α-mixing random variables with application to the problem of spectral density estimation. The Annals of Statistics, 1985-2007.
