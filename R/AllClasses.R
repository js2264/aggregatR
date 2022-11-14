#' AggregatedCoverage class
#'
#' This class is based on the `SummarizedExperiment` class. It implements
#' bigwig file import over a set of `GRanges` of interest and computes
#' three metrics: 1) mean coverage, 2) lower confidence interval (CI) and 3)
#' upper CI boundaries. It stores these metrics in a rectangular assay, where
#' rows represent distance to the center of `GRanges` of interest, and columns
#' correspond to individual bigwig coverage tracks
#'
#' @importFrom SummarizedExperiment SummarizedExperiment
#' @export

methods::setClass("AggregatedCoverage", contains = c("SummarizedExperiment"))

#' AggregatedCoverage constructor
#'
#' @param granges Genomic loci of interest provided as a `GRanges` object.
#'   All the loci should have the same width.
#' @param colData Data frame with a `file` column, containing the path
#'   to individual `bigwig` files. Additional metadata columns can be provided.
#' @return an `AggregatedCoverage` object
#'
#' @export
#'
#' @examples
#' files <- data.frame(file = c(
#'   system.file('extdata', 'Scc1-calibrated_rep1.bw', package = 'aggregatR'),
#'   system.file('extdata', 'Scc1-calibrated_rep2.bw', package = 'aggregatR')
#' ))
#' data(Scc1_peaks)
#' AC <- AggregatedCoverage(Scc1_peaks, files)
#' AC

AggregatedCoverage <- function(granges, colData) {

    # Check width of input GRanges
    width_gr <- .check_widths(granges)

    # Import each bigwig and compute stats
    l_cvgs <- lapply(seq_len(nrow(colData)), function(K){
        message("Parsing sample ", K, "/", nrow(colData))
        file <- colData[K, 'file']
        .parseBigWig(file, granges)
    })

    # Prepare rowData
    rowData <- .prepareRowData(width_gr)

    # Create an `AggregatedCoverage` object
    AC <- methods::new(
        "AggregatedCoverage",
        SummarizedExperiment::SummarizedExperiment(
            rowData = rowData,
            colData = colData,
            assays = list(
                'mean' = do.call(cbind, lapply(l_cvgs, '[[', 'score')),
                'lowCI' = do.call(cbind, lapply(l_cvgs, '[[', 'ci_low')),
                'highCI' = do.call(cbind, lapply(l_cvgs, '[[', 'ci_high'))
            )
        )
    )
    return(AC)
}
