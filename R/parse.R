#' .parseBigWig
#'
#' Internal parsing function
#'
#' @param file Path to a `bigwig` file
#' @param granges `GRanges` object
#' @return Data frame with columns containing average coverage and its lower and upper CI
#'   boundaries around the center of `GRanges` provided as input.

.parseBigWig <- function(file, granges) {
    cov <- rtracklayer::import.bw(file, as = "Rle")
    l <- .filterGRanges(list(coverage = cov, features = granges))
    sub_granges <- l[['features']]
    cov[sub_granges] |>
        as.matrix() |>
        t() |>
        as.data.frame() |>
        dplyr::mutate(pos = seq(-unique(width(sub_granges))/2, unique(width(sub_granges))/2-1, by = 1)) |>
        tidyr::pivot_longer(-pos, names_to = 'idx', values_to = 'cov') |>
        dplyr::group_by(pos) |>
        dplyr::summarize(
            score = mean(cov, na.rm = TRUE),
            median = median(cov, na.rm = TRUE),
            sd = sd(cov, na.rm = TRUE),
            count = dplyr::n()
        ) |>
        dplyr::mutate(
            se = sd/sqrt(count),
            ci_low = score - qt(1 - (0.05 / 2), count - 1) * se,
            ci_high = score + qt(1 - (0.05 / 2), count - 1) * se
        )
}
