---
output: github_document
---

# Participant Instructions - Deep Learning in R

We are looking forward to the next deep learning training! In order to complete the workshop we ask that participants please go through the following software installation steps at least a day in advance. We estimate that this will take about 30 minutes to complete.

If you run into any errors please send an email to Chris Kennedy & Evan Muzzall (ck37@berkeley.edu, evan.muzzall@berkeley.edu) and include:  

1. Which step you're running,  
2. The error message(s) (screenshot preferred), and  
3. Your operating system + R version + RStudio version.  

We will then work with you to resolve any challenges. It is important to get everything working before the training because we will not likely have sufficient time to investigate fixes during the training itself.

## Software Requirements

### Core Programs

1. Install R 3.4 or greater: https://cloud.r-project.org/  

To avoid package errors this should be installed separate from Anaconda. If you have R installed through Anaconda please uninstall it and install the non-Anaconda version.  

2. Install RStudio: https://www.rstudio.com/products/rstudio/download/

Install Anaconda Python (3.7+) if you have not already done so: https://www.anaconda.com/distribution/  

Use the default options.

### R and Python Packages

Install Keras by running these commands in the RStudio console or an R script:  

```{r eval = FALSE}
# This will install the R package.
install.packages("keras")
# This will setup the Python environment, including Keras and tensorflow.
keras::install_keras()
```

### Install key additional packages

#### Image Magick

```{r eval = FALSE}
install.packages("magick")
library(magick)
```

MacOS users with R installed via Homebrew, or Linux users, [see extra install info here.](https://cran.r-project.org/web/packages/magick/vignettes/intro.html#build_from_source)

## Part 4 Google Cloud

To follow along with part 4's Google Cloud demonstration, you will need to:

1. Sign in to Google Cloud at: https://console.cloud.google.com/  

Accept the terms of service box that pops up the first time.  

2. Click the blue "Activate" button in the top right to get $300 in free credits. You will need to add a credit card, HOWEVER note that it will not automatically charge you when the 12-month trial ends - you would need to explicitly upgrade to a paid account.

3. Select the "APIs & Services" menu in the left side column, then "Dashboard".  

4. Click "+ Enable APIs and Services" in the top middle area. Enter "compute engine api" into the search box and press enter.

5. Click the "Compute Engine API" result with the blue icon.
Click the blue "Enable" button. You will be asked to enable billing - this won't result in any charges but you need to enable this.  

6. Click back to left-hand navigation menu (icon three horizontal bars in upper left corner), then "APIs & Services", then "Dashboard", then "+ Enable APIs and Services". Enter "machine learning engine" into the search box and press enter.  

7. Click the "Cloud Machine Learning Engine" result with the blue icon.  

8. Click the blue "Enable" button.

9. Install the cloudml R package by running in RStudio:

```{r eval = FALSE}
install.packages("cloudml")
library(cloudml)
gcloud_install()
```

Accept the default options.

10. You will be prompted to log in to your google account and authorize the Google Cloud SDK. When prompted, use the randomly generated project name (option 1). 

11. job_status()

If everything is setup correctly you will see "no lines available in input" as an expected error message. Otherwise carefully review any error messages and take the recommended action if one is provided (e.g. visit a certain URL).

12. (Optional) 

Apply for an additional $200 credit for R users

## Download Workshop Materials

This does not need to be done in advance, because we may be making last-minute improvements.

Download workshop materials: https://github.com/dlab-berkeley/Deep-Learning-in-R

1. Click green “Clone or Download” button  

2. Either:  

A) Click “Download Zip”  

Extract this zip file to your Dropbox / Box / etc. and open in RStudio.  

... or

B) (advanced):  

Copy the github clone URL (https or ssh version). In RStudio select File -> New Project -> Version Control -> Git and paste the repository URL. 

#### Anaconda notes

Anaconda is required on Windows, whereas MacOS and Linux should be ok without it. However it is probably easier to manage & troubleshoot when everyone is using Keras through anaconda.
