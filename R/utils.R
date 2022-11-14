#' .prepareRowData
#'
#' Internal utils function
#'
#' @param width a single numeric value corresponding to the width of `GRanges`
#'   used in the parent function.
#' @return `data.frame` with a single `pos` column indicating the distance to
#'   the center of `GRanges` width.

.prepareRowData <- function(width) {
    data.frame(
        pos = seq(-width/2, width/2-1, by = 1)
    )
}
