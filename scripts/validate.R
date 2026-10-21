# scripts/validate.R — Quarto pre-render step (see _quarto.yml).
#
# Checks every claims/<id>/claim.yml against the publication checklist in
# docs/protocol.md §17 and fails the build if anything required is missing or
# still a template placeholder. Skips claims/_template/ and any claim whose
# index.qmd front matter has `draft: true` (Quarto leaves drafts off the site).
#
# This script only checks that fields are present and take allowed values. It
# never computes or proposes a verdict, tier, or certainty grade.
#
# Run by hand: Rscript scripts/validate.R   (from the project root)

suppressPackageStartupMessages(library(yaml))

claims_dir   <- "claims"
template_dir <- file.path(claims_dir, "_template")

VERDICTS  <- c("Supported", "Not supported", "Mixed", "Cannot be graded")
CERTAINTY <- c("High", "Moderate", "Low", "Very low")
SCORES    <- c("Strong", "Partial", "Weak")
CRITERIA  <- c("Number and quality of causal studies",
               "Consistency of direction",
               "Consistency of magnitude",
               "External validity to current policy",
               "Recency and publication status")
RATIONALE_WORDS <- c(150, 300)   # protocol §10.3

# All-caps tokens that are real words, not placeholders. Extend as needed.
ACRONYMS <- c("OSF", "NBER", "CEPR", "IZA", "IMF", "SSRN", "OECD", "PECOS", "GRADE",
              "RCT", "DID", "IV", "RD", "FE", "COI", "CSV", "URL", "DOI", "AI",
              "US", "USA", "UK", "EU", "CBO", "BLS", "BEA", "CPS", "ACS", "ICE", "DHS",
              "SNAP", "TANF", "EITC", "CHIP", "ACA", "CMS", "HUD", "LIHTC", "NAFTA",
              "USMCA", "WTO", "GDP", "CPI", "COVID", "COVID-19", "PCE", "FRED")

# Template values that are legitimate as-is in a finished claim.
DEFAULTS_OK <- c("The Credibility Project", "v0.1", "High", "Medium", "Low", "OSF",
                 "signed commit", "none", "none declared", "per protocol §5.4",
                 "per protocol §6.1", "2000–present", "monthly", "quarterly",
                 "OpenAlex", "NBER", "SSRN", "EconLit", "Jobs", "Main", "1.0",
                 "Page created under Protocol v0.1.", "~100%", "S01, S02, S03",
                 "Lead reviewer", "Second reviewer", "Adversarial reader", CRITERIA)

`%||%` <- function(a, b) if (is.null(a)) b else a

# ---- helpers ---------------------------------------------------------------

# One message per field: a placeholder found first is not reported again as "missing".
errors <- character(0)
err <- function(file, path, msg) {
  key <- sprintf("%s: %s: ", file, path)
  if (!any(startsWith(errors, key))) errors <<- c(errors, paste0(key, msg))
}

is_blank <- function(x) {
  is.null(x) || length(x) == 0 || all(is.na(x)) ||
    (is.character(x) && all(trimws(x) == ""))
}

is_date <- function(x) {
  is.character(x) && length(x) == 1 && grepl("^\\d{4}-\\d{2}-\\d{2}$", x) &&
    !is.na(as.Date(x, format = "%Y-%m-%d", optional = TRUE))
}

word_count <- function(x) length(strsplit(trimws(x), "\\s+")[[1]])

# Flatten a parsed YAML tree into named string leaves ("a.b[2].c" = value).
leaves <- function(x, path = "") {
  if (is.list(x)) {
    nms <- names(x)
    out <- list()
    for (i in seq_along(x)) {
      sub <- if (is.null(nms) || nms[i] == "") sprintf("%s[%d]", path, i)
             else if (path == "") nms[i] else paste0(path, ".", nms[i])
      out <- c(out, leaves(x[[i]], sub))
    }
    out
  } else if (is.character(x)) {
    setNames(as.list(x), rep(path, length(x)))
  } else list()
}

# Return a reason if a string looks like an unfilled placeholder, else NULL.
placeholder_reason <- function(s) {
  if (grepl("PLACEHOLDER", s, fixed = TRUE)) return("still PLACEHOLDER")
  if (grepl("YYYY", s, fixed = TRUE))        return("contains YYYY")
  if (grepl("[VERIFY]", s, fixed = TRUE))    return("contains [VERIFY]")
  # Bracketed text is a placeholder unless it is a row cite [S03], a citation
  # [@key], or the text of a markdown link [text](url).
  m <- gregexpr("\\[[^]]*\\](?!\\()", s, perl = TRUE)
  for (b in regmatches(s, m)[[1]]) {
    inner <- substr(b, 2, nchar(b) - 1)
    if (!grepl("^(S\\d{2,}([,;] ?S\\d{2,})*|@.*)$", inner)) return(sprintf("bracketed placeholder %s", b))
  }
  # ALL-CAPS placeholders: CLAIM-ID, NAME, PAGE URL ONCE PUBLISHED.
  m <- gregexpr("(?<![A-Za-z0-9])[A-Z][A-Z0-9]*(?:-[A-Z0-9]+)*(?![A-Za-z0-9])", s, perl = TRUE)
  toks <- regmatches(s, m)[[1]]
  toks <- toks[nchar(gsub("[^A-Z]", "", toks)) >= 2 & !(toks %in% ACRONYMS)]
  if (any(grepl("-", toks)))           return(sprintf("ALL-CAPS placeholder %s", toks[grepl("-", toks)][1]))
  if (any(nchar(toks) >= 4))           return(sprintf("ALL-CAPS placeholder %s", toks[nchar(toks) >= 4][1]))
  if (length(toks) >= 2 && grepl(paste0(toks[1], "\\s+", toks[2]), s)) {
    return(sprintf("ALL-CAPS placeholder \"%s %s\"", toks[1], toks[2]))
  }
  NULL
}

front_matter <- function(qmd) {
  lines <- readLines(qmd, warn = FALSE, encoding = "UTF-8")
  delim <- which(trimws(lines) == "---")
  if (length(delim) < 2 || delim[1] != 1) return(list())
  yaml.load(paste(lines[(delim[1] + 1):(delim[2] - 1)], collapse = "\n")) %||% list()
}

# ---- template reference values ---------------------------------------------

template      <- read_yaml(file.path(template_dir, "claim.yml"))
template_text <- setdiff(unique(unlist(leaves(template))), c(DEFAULTS_OK, ""))
studies_cols  <- names(read.csv(file.path(template_dir, "studies.csv"),
                                check.names = FALSE, nrows = 1))

# ---- per-claim checks ------------------------------------------------------

check_claim <- function(dir) {
  slug <- basename(dir)
  f    <- file.path(dir, "claim.yml")
  qmd  <- file.path(dir, "index.qmd")

  if (!file.exists(qmd)) { err(qmd, "-", "missing"); return(invisible()) }
  fm <- front_matter(qmd)

  claim <- tryCatch(read_yaml(f), error = function(e) { err(f, "-", conditionMessage(e)); NULL })
  if (is.null(claim)) return(invisible())

  # Placeholders anywhere in the file.
  lv <- leaves(claim)
  for (i in seq_along(lv)) {
    s <- lv[[i]]
    why <- placeholder_reason(s)
    if (is.null(why) && s %in% template_text) why <- "unchanged template text"
    if (!is.null(why)) err(f, names(lv)[i], why)
  }

  # Top-level required fields.
  if (is_blank(claim$id)) err(f, "id", "missing")
  else if (!identical(claim$id, slug)) err(f, "id", sprintf("'%s' does not match folder name '%s'", claim$id, slug))
  if (is_blank(claim$protocol_version)) err(f, "protocol_version", "missing")
  if (!is_date(claim$last_updated)) err(f, "last_updated", "missing or not a YYYY-MM-DD date")
  if (is_blank(claim$topic)) err(f, "topic", "missing")
  else {
    if (!file.exists(file.path("topics", paste0(claim$topic, ".qmd"))))
      err(f, "topic", sprintf("no topics/%s.qmd", claim$topic))
    if (!(claim$topic %in% unlist(fm$categories)))
      err(qmd, "categories", sprintf("must include the claim's topic '%s'", claim$topic))
  }

  # Public claim (protocol §3.1).
  pc <- claim$public_claim
  if (is_blank(pc$verbatim)) err(f, "public_claim.verbatim", "missing")
  inst <- pc$instances %||% list()
  if (length(inst) < 2) err(f, "public_claim.instances", sprintf("need at least 2, found %d", length(inst)))
  for (i in seq_along(inst)) {
    for (k in c("speaker", "url")) if (is_blank(inst[[i]][[k]]))
      err(f, sprintf("public_claim.instances[%d].%s", i, k), "missing")
    if (!is_date(inst[[i]]$date)) err(f, sprintf("public_claim.instances[%d].date", i), "missing or not a date")
  }

  # Tested statements and verdicts (protocol §3.2, §10).
  ts <- claim$tested_statements %||% list()
  if (length(ts) == 0) err(f, "tested_statements", "need at least one")
  for (i in seq_along(ts)) for (k in c("scope", "pecos"))
    if (is_blank(ts[[i]][[k]])) err(f, sprintf("tested_statements[%d].%s", i, k), "missing")
  scopes <- unlist(lapply(ts, `[[`, "scope"))

  vs <- claim$verdicts %||% list()
  vscopes <- unlist(lapply(vs, `[[`, "scope"))
  if (!setequal(scopes, vscopes) || anyDuplicated(vscopes))
    err(f, "verdicts", sprintf("scopes [%s] must match tested_statements scopes [%s], one verdict each",
                               paste(vscopes, collapse = ", "), paste(scopes, collapse = ", ")))
  for (i in seq_along(vs)) {
    v <- vs[[i]]; p <- sprintf("verdicts[%d]", i)
    if (!isTRUE(v$verdict %in% VERDICTS))
      err(f, paste0(p, ".verdict"), sprintf("must be one of: %s", paste(VERDICTS, collapse = " / ")))
    if (is_blank(v$statement)) err(f, paste0(p, ".statement"), "missing")
    gradeable <- !identical(v$verdict, "Cannot be graded")
    if ((gradeable || !is.null(v$certainty)) && !isTRUE(v$certainty %in% CERTAINTY))
      err(f, paste0(p, ".certainty"), sprintf("must be one of: %s", paste(CERTAINTY, collapse = " / ")))
  }

  # Certainty criteria: five rows per scope (protocol §11).
  cs <- claim$certainty_scores %||% list()
  for (s in vscopes) {
    rows <- Filter(function(r) identical(r$scope, s), cs)
    crit <- unlist(lapply(rows, `[[`, "criterion"))
    if (length(rows) != 5 || !setequal(crit, CRITERIA) || anyDuplicated(crit))
      err(f, sprintf("certainty_scores[%s]", s), sprintf("scope '%s' needs exactly one row for each of the five criteria; found %d row(s)%s",
                                         s, length(rows),
                                         if (length(setdiff(CRITERIA, crit))) paste0(", missing: ", paste(setdiff(CRITERIA, crit), collapse = "; ")) else ""))
  }
  for (i in seq_along(cs)) {
    r <- cs[[i]]; p <- sprintf("certainty_scores[%d]", i)
    if (!isTRUE(r$scope %in% vscopes)) err(f, paste0(p, ".scope"), sprintf("'%s' is not a verdict scope", r$scope %||% ""))
    if (!isTRUE(r$score %in% SCORES)) err(f, paste0(p, ".score"), "must be Strong / Partial / Weak")
    if (is_blank(r$reason)) err(f, paste0(p, ".reason"), "missing")
  }

  # Reviewers: a Lead and a Second, each with a rationale (protocol §10.3, §13.1).
  rv <- claim$reviewers %||% list()
  for (role in c("Lead reviewer", "Second reviewer")) {
    hits <- Filter(function(r) identical(r$role, role), rv)
    if (length(hits) != 1) { err(f, sprintf("reviewers[%s]", role), sprintf("need exactly one '%s', found %d", role, length(hits))); next }
    r <- hits[[1]]
    for (k in c("name", "affiliation", "coi"))
      if (is_blank(r[[k]])) err(f, sprintf("reviewers[%s].%s", role, k), "missing")
    if (is_blank(r$rationale)) err(f, sprintf("reviewers[%s].rationale", role), "missing")
    else {
      n <- word_count(r$rationale)
      if (n < RATIONALE_WORDS[1] || n > RATIONALE_WORDS[2])
        err(f, sprintf("reviewers[%s].rationale", role), sprintf("%d words; protocol §10.3 requires 150–300", n))
    }
  }

  # Methods.
  m <- claim$methods
  if (is_blank(m$registration$url)) err(f, "methods.registration.url", "missing")
  if (!is_date(m$registration$date)) err(f, "methods.registration.date", "missing or not a date")
  for (k in c("records", "deduplicated", "full_text", "included")) {
    x <- m$screening[[k]]
    if (!(is.numeric(x) && length(x) == 1 && x >= 0 && x == round(x)))
      err(f, paste0("methods.screening.", k), "must be a non-negative integer")
  }

  # Changelog.
  cl <- claim$changelog %||% list()
  if (length(cl) == 0) err(f, "changelog", "need at least one entry")
  for (i in seq_along(cl)) {
    if (!is_date(cl[[i]]$date)) err(f, sprintf("changelog[%d].date", i), "missing or not a date")
    for (k in c("version", "note")) if (is_blank(cl[[i]][[k]]))
      err(f, sprintf("changelog[%d].%s", i, k), "missing")
  }

  # Bibliography named in the front matter must exist.
  if (!is.null(fm$bibliography) && !file.exists(file.path(dir, fm$bibliography)))
    err(qmd, "bibliography", sprintf("%s not found", fm$bibliography))

  # Leftover template prompts in the page prose: two or more ALL-CAPS words in a
  # row (OPEN QUESTION, LINKS OR "None yet."), outside code chunks.
  body <- readLines(qmd, warn = FALSE, encoding = "UTF-8")
  in_chunk <- cumsum(grepl("^```", body)) %% 2 == 1
  for (h in which(!in_chunk)) {
    runs <- regmatches(body[h], gregexpr("(?<![A-Za-z])[A-Z][A-Z'’-]+(?:[ ,]+[A-Z][A-Z'’-]+)+(?![a-z])",
                                         body[h], perl = TRUE))[[1]]
    runs <- Filter(function(r) !all(strsplit(r, "[ ,]+")[[1]] %in% ACRONYMS), runs)
    if (length(runs)) err(qmd, sprintf("line %d", h), sprintf("template prompt left in: %s", substr(runs[1], 1, 60)))
  }

  # Study table: fixed columns (protocol App. B), every row verified (gate 4).
  sf <- file.path(dir, "studies.csv")
  if (!file.exists(sf)) err(sf, "-", "missing")
  else {
    st <- read.csv(sf, check.names = FALSE, colClasses = "character", na.strings = character(0))
    if (!identical(names(st), studies_cols))
      err(sf, "header", "columns must match claims/_template/studies.csv exactly, in order")
    for (i in seq_len(nrow(st))) {
      id <- if ("study_id" %in% names(st)) st$study_id[i] else sprintf("row %d", i)
      bad <- names(st)[vapply(st[i, ], function(x) grepl("[VERIFY]", x, fixed = TRUE) || grepl("YYYY", x, fixed = TRUE), logical(1))]
      if (length(bad)) err(sf, id, sprintf("unverified or placeholder value in: %s", paste(bad, collapse = ", ")))
      if ("verified_by" %in% names(st) && (is_blank(st$verified_by[i]) || grepl("[", st$verified_by[i], fixed = TRUE)))
        err(sf, id, "verified_by is empty; a human must initial every row")
    }
  }
}

# ---- run -------------------------------------------------------------------

dirs <- list.dirs(claims_dir, recursive = FALSE)
dirs <- dirs[!grepl("^[_.]", basename(dirs)) & file.exists(file.path(dirs, "claim.yml"))]

checked <- 0
for (d in dirs) {
  qmd <- file.path(d, "index.qmd")
  if (file.exists(qmd) && isTRUE(front_matter(qmd)$draft)) {
    cat(sprintf("validate.R: skipped %s (draft: true)\n", basename(d)))
    next
  }
  check_claim(d)
  checked <- checked + 1
}

if (length(errors)) {
  cat(sprintf("\nvalidate.R: %d problem(s) found in %d claim(s). The build stops here.\n\n",
              length(errors), checked), file = stderr())
  cat(paste0("  - ", errors, collapse = "\n"), "\n\n", file = stderr())
  cat("Fix these, or set `draft: true` in the claim's index.qmd to keep it off the site.\n", file = stderr())
  quit(status = 1)
}

cat(sprintf("validate.R: %d claim(s) checked, all required fields present.\n", checked))
