#' AggregateCoverage method for plot generic
#'
#' This plot method is designed for `AggregatedCoverage` objects. It returns a
#' `ggplot` plot which can be further customized using `ggplot2` functions.
#'
#' @param x an AggregatedCoverage object
#' @return a ggplot2 plot
#'
#' @import ggplot2
#' @export
#'
#' @examples
#' files <- data.frame(file = c(
#'   system.file('extdata', 'Scc1-calibrated_rep1.bw', package = 'aggregatR'),
#'   system.file('extdata', 'Scc1-calibrated_rep2.bw', package = 'aggregatR')
#' ))
#' data(Scc1_peaks)
#' AC <- AggregatedCoverage(Scc1_peaks, files)
#' plot(AC)

setMethod("plot", "AggregatedCoverage", function(x) {
    df <- lapply(seq_len(ncol(x)), function(K) {
        data.frame(
            file = SummarizedExperiment::colData(x)$file[K],
            K = K,
            pos = SummarizedExperiment::rowData(x)$pos,
            mean = SummarizedExperiment::assay(x, 'mean')[, K],
            lowCI = SummarizedExperiment::assay(x, 'lowCI')[, K],
            highCI = SummarizedExperiment::assay(x, 'highCI')[, K]
        )
    }) |> dplyr::bind_rows()
    ggplot(df, mapping = aes(
        x = pos, y = mean, ymin = lowCI, ymax = highCI,
        col = basename(file), fill = basename(file)
    )) +
        geom_line() +
        geom_ribbon(col = NA, alpha = 0.2)
})
