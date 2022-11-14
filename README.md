# aggregatR

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of aggregatR is to implement the `AggregateCoverage` S4 class in Bioconductor. This class standardizes the computation of average coverage of 
bigwig files across a number of genomic loci of same width and implements a plotting method to easily generate aggregate coverage plots for multiple bigwig files. 

## Installation

You can install the development version of aggregatR like so:

``` r
remotes::install_github('js2264/aggregatR')
```

`aggregatR` package is currently under submission to be integrated in Bioconductor. Once available there, the release version of this package can 
be installed like so: 

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
BiocManager::install('aggregatR')
```

## Example

``` r
library(GenomicRanges)
library(aggregatR)
library(ggplot2)
files <- data.frame(file = c(
    system.file('extdata', 'Scc1-calibrated_rep1.bw', package = 'aggregatR'),
    system.file('extdata', 'Scc1-calibrated_rep2.bw', package = 'aggregatR')
))
data(Scc1_peaks)
AC <- AggregatedCoverage(Scc1_peaks, files)
plot(AC) + 
    ggtitle('Average coverage of Scc1 ChIP-seq tracks over Scc1 peaks') + 
    labs(x = 'Distance to center of Scc1 peaks', y = 'Scc1 score', fill = 'file', col = 'file') +
    theme_bw()
```

