options(stringsAsFactors = FALSE)
cargs = commandArgs(TRUE)
local = cargs[1] == 'TRUE'

build_one = function(io)  {
  # if output is newer than input, skip the compilation
  if (file_test('-nt', io[2], io[1])) return()

  if (local) message('* knitting ', io[1])
  if (blogdown:::Rscript(shQuote(c('R/build_one.R', io))) != 0) {
    unlink(io[2])
    stop('Failed to compile ', io[1], ' to ', io[2])
  }
}

# build Rmd files under the content directory
rmds = list.files('content', '[.]Rmd$', recursive = TRUE, full.names = TRUE)
if (length(rmds)) {
  files = cbind(rmds, gsub('.Rmd$', '.md', rmds))
  for (i in seq_len(nrow(files))) {
    build_one(unlist(files[i, ]))
  }
}

blogdown::hugo_build(local = local)
