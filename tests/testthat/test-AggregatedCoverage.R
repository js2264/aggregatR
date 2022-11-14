test_that("AggregatedCoverage works", {
    files <- data.frame(file = c(
        system.file('extdata', 'Scc1-calibrated_rep1.bw', package = 'aggregatR'),
        system.file('extdata', 'Scc1-calibrated_rep2.bw', package = 'aggregatR')
    ))
    data(Scc1_peaks, package = 'aggregatR')
    AC <- AggregatedCoverage(Scc1_peaks, files)
    expect_s4_class(AC, 'AggregatedCoverage')
})
