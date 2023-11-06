# R Deep Learning

[![DataHub](https://img.shields.io/badge/launch-datahub-blue)](https://dlab.datahub.berkeley.edu/hub/user-redirect/git-pull?repo=https%3A%2F%2Fgithub.com%2Fdlab-berkeley%2FR-Deep-Learning&urlpath=rstudio%2F&branch=main)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/dlab-berkeley/R-Deep-Learning/HEAD?urlpath=rstudio)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Workshop Materials](https://img.shields.io/badge/D--Lab-Workshop%20Materials-blue)](https://docs.google.com/presentation/d/1eQsjdzcareMpEK59EJS5gLqOWIcmQpTjDvQnXIBOh_c/edit?usp=sharing)

This is the repository for D-Lab’s six-hour Introduction to Deep Learning in R
workshop. We recommend attendees be intermediate R users and have had some prior
exposure to the concepts in
[R-Machine-Learning](https://github.com/dlab-berkeley/R-Machine-Learning).

Check D-Lab's [Learning Pathways](https://dlab-berkeley.github.io/dlab-workshops/R_path.html) to figure out which of our workshops to take!

## Workshop Goals 

In this workshop, we provide an introduction to Deep Learning using TensorFlow
and keras in R. First, we will cover the basics of what makes deep learning
"deep." Then, we will explore using code to classify images. Along the way, we
will build a workflow of a deep learning project. 

## Installation Instructions

We will use RStudio to go through the workshop materials, which requires
installation of R, RStudio, and TensorFlow. Complete the following steps if you
want to work locally. 

1. Download [R](https://cloud.r-project.org/) and
   [RStudio](https://www.rstudio.com/products/rstudio/download/)

2. Within the R console, run the following commands 

```
install.packages(c("tensorflow", "keras", "reticulate")) # Pulls in all R dependencies necessary for TensorFlow in R

library(reticulate)

# Set up R with a Python installation it can use
virtualenv_create("r-reticulate", python = install_python()) 

library(keras)
install_keras(envname = "r-reticulate") # Install TensorFlow and Keras python modules
```

After these steps you will have a working Keras and TensorFlow installation.
This process will take some time if you decide to download to your local
machine. To determine the TensorFlow version installed on your machine, run in
the console

```
library(tensorflow)
tf$constant("Hello Tensorflow!")
```

3. Install additional packages required for this workshop

```
install.packages(c("tfhub", "tfdatasets")
```

# About the UC Berkeley D-Lab

D-Lab works with Berkeley faculty, research staff, and students to advance
data-intensive social science and humanities research. Our goal at D-Lab is to
provide practical training, staff support, resources, and space to enable you to
use R for your own research applications. Our services cater to all skill levels
and no programming, statistical, or computer science backgrounds are necessary.
We offer these services in the form of workshops, one-to-one consulting, and
working groups that cover a variety of research topics, digital tools, and
programming languages.  

Visit the [D-Lab homepage](https://dlab.berkeley.edu/) to learn more about us.
You can view our [calendar](https://dlab.berkeley.edu/events/calendar) for
upcoming events, learn about how to utilize our
[consulting](https://dlab.berkeley.edu/consulting) and [data
services](https://dlab.berkeley.edu/data), and check out upcoming
[workshops](https://dlab.berkeley.edu/events/workshops). Subscribe to our
[newsletter](https://dlab.berkeley.edu/news/weekly-newsletter) to stay up to
date on D-Lab events, services, and opportunities.


# Additional Resources

* Massive open online courses
    * [fast.ai - Practical Deep Learning for Coders](https://course.fast.ai/)
    * [Kaggle Deep Learning](https://www.kaggle.com/learn/deep-learning)
    * [Google Machine Learning Crash Course](https://developers.google.com/machine-learning/crash-course/)
    * [See this](https://developers.google.com/machine-learning/crash-course/fitter/graph) sweet interactive learning rate tool
    * [Google seedbank examples](https://tools.google.com/seedbank/seeds)
    * [DeepLearning.ai](https://www.deeplearning.ai/)
    
* Workshops
    * [Nvidia's Modeling Time Series Data with Recurrent Neural Networks in Keras](https://courses.nvidia.com/courses/course-v1:DLI+L-HX-05+V1/about)

* Stanford
    * CS 20 - [Tensorflow for Deep Learning Research](http://web.stanford.edu/class/cs20si/syllabus.html)
    * CS 230 - [Deep Learning](http://cs230.stanford.edu/)
    * CS 231n - [Neural Networks for Visual Recognition](http://cs231n.github.io/)
    * CS 224n - [Natural Language Processing with Deep Learning](http://web.stanford.edu/class/cs224n/)

* Berkeley
    * Machine Learning at Berkeley [ML@B](https://ml.berkeley.edu/)
    * CS [189/289A](https://people.eecs.berkeley.edu/~jrs/189/)

* UToronto CSC 321 - [Intro to Deep Learning](http://www.cs.toronto.edu/~rgrosse/courses/csc321_2018/)

* Videos
    * J.J. Allaire [talk at RStudioConf 2018](https://www.rstudio.com/resources/videos/machine-learning-with-tensorflow-and-r/)

* Books
    * F. Chollet and J.J. Allaire - [Deep Learning in R](https://www.manning.com/books/deep-learning-with-r)
    * Charniak E - [Introduction to Deep Learning](https://mitpress.mit.edu/books/introduction-deep-learning)  
    * I. Goodfellow, Y. Bengio, A. Courville - [www.deeplearningbook.org](https://www.deeplearningbook.org/)
    * Zhang et al. - [Dive into Deep Learning](http://en.diveintodeeplearning.org/) 

# Other D-Lab R workshops

D-Lab offers a variety of R workshops, catered toward different levels of
expertise.
## Introductory Workshops

* [R Data Wrangling](https://github.com/dlab-berkeley/R-Data-Wrangling)
* [R Data Visualization](https://github.com/dlab-berkeley/R-Data-Visualization)
* [R Census Data](https://github.com/dlab-berkeley/Census-Data-in-R)

## Intermediate and Advanced Workshops
* [R Geospatial Fundamentals](https://github.com/dlab-berkeley/R-Geospatial-Fundamentals)
* [R Machine Learning](https://github.com/dlab-berkeley/R-Machine-Learning)
* [R Deep Learning](https://github.com/dlab-berkeley/R-Deep-Learning)
