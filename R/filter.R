#' .filterGRanges
#'
#' This function takes a named list of 2 (coverage and features) and filters
#' out the features which are not strictly contained within the coverage track.
#'
#' @param l named list of 2 (coverage and features)
#' @return named list of 2 (coverage and features)
#'
#' @importFrom methods as
#' @importFrom GenomicRanges reduce
#' @importFrom IRanges subsetByOverlaps

.filterGRanges <- function(l) {
    covered_genome <- GenomicRanges::reduce(as(l[['coverage']], 'GRanges'))
    n_feats <- length(l[['features']])
    l[['features']] <- IRanges::subsetByOverlaps(l[['features']], covered_genome, type = "within")
    message(length(l[['features']]), ' features retained out of ', n_feats)
    return(l)
}
