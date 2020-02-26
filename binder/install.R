#install.packages("devtools")
cran_packages =
  c("keras", "tensorflow", "cowplot", "cloudml", "dplyr", "ggplot2", "magick",
    "knitr", "rio")

install.packages(cran_packages)

keras::install_keras()
