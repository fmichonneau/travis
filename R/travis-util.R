#' Travis CI utilities
#'
#' @description
#' Helper functions for Travis CI.
#'
#' `travis_sync()` initiates synchronization with GitHub and waits for completion
#' by default.
#'
#' @param block `[flag]`\cr
#'   Set to `FALSE` to return immediately instead of waiting.
#' @inheritParams travis_set_pat
#'
#' @export
travis_sync <- function(block = TRUE, token = travis_token(), quiet = FALSE) {
  user_id <- travis_user(token = token)[["id"]]

  req <- TRAVIS_POST3(sprintf("/user/%s/sync", user_id),
                      token = token)

  check_status(req, "initiat[ing]{e} sync with GitHub", quiet, 409)

  if (block) {
    message("Waiting for sync with GitHub", appendLF = FALSE)
    while (travis_user(token = token)[["is_syncing"]]) {
      if (!quiet) message(".", appendLF = FALSE)
      Sys.sleep(1)
    }
    if (!quiet) message()
  }

  if (!quiet) message("Finished sync with GitHub.")
}

#' @description
#' `travis_browse()` opens a browser pointing to the current repo on  Travis CI.
#'
#' @export
#' @rdname travis_sync
travis_browse <- function(repo = github_repo()) {
  utils::browseURL(paste0("https://travis-ci.org/", repo))
}
