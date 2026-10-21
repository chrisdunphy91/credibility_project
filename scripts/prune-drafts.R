# scripts/prune-drafts.R — Quarto post-render step (see _quarto.yml).
#
# Quarto replaces a `draft: true` page with an empty stub but still copies the
# resources it declares, so a draft claim's unverified studies.csv would be
# downloadable. This deletes the output folder of every draft claim.

suppressPackageStartupMessages(library(yaml))

out_dir <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", "_site")

is_draft <- function(qmd) {
  lines <- readLines(qmd, warn = FALSE, encoding = "UTF-8")
  delim <- which(trimws(lines) == "---")
  if (length(delim) < 2 || delim[1] != 1) return(FALSE)
  isTRUE(yaml.load(paste(lines[(delim[1] + 1):(delim[2] - 1)], collapse = "\n"))$draft)
}

dirs <- list.dirs("claims", recursive = FALSE)
dirs <- dirs[!grepl("^[_.]", basename(dirs)) & file.exists(file.path(dirs, "index.qmd"))]

for (d in dirs) {
  target <- file.path(out_dir, "claims", basename(d))
  if (is_draft(file.path(d, "index.qmd")) && dir.exists(target)) {
    unlink(target, recursive = TRUE)
    cat(sprintf("prune-drafts.R: removed %s (draft: true)\n", target))
  }
}
