# Pulls in all R dependencies necessary for TensorFlow in R
install.packages(c("tensorflow", "keras", "reticulate"))
# Load reticulate
library(reticulate)
# Set up R with a Python installation it can use
virtualenv_create("r-reticulate", python = install_python()) 
# Install TensorFlow and Keras python modules
library(keras)
install_keras(envname = "r-reticulate") 
# Install additional packages
install.packages(c("tfhub", "tfdatasets"))
