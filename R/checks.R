#' .check_widths
#'
#' Internal check function
#'
#' @param granges `GRanges` object
#' @return width of the elements within the provided `GRanges` object

.check_widths <- function(granges) {
    if (length(unique(GenomicRanges::width(granges))) != 1) {
        stop("The provided GRanges should all have the same width.")
    }
    else {
        return(GenomicRanges::width(granges[1]))
    }
}
