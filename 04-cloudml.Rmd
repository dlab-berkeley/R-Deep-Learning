---
title: "Deep Learning in R: Part 4 (Cloud Machine Learning)"
output: html_document
---

## Google Cloud ML

First go to (https://console.cloud.google.com/), create a new project, and enable the "Machine Learning Engine" API for that project.

Then run this first installation chunk manually. For more information please review
the Tensorflow Cloud ML [getting started page](https://tensorflow.rstudio.com/tools/cloudml/articles/getting_started.html). Bonus: this page has a link to apply for an additional $200 in credit specifically for R users (takes ~2 business days to get approved).

Side note: [HIPAA compliance information is available here](https://cloud.google.com/security/compliance/hipaa/).

```{r cloud_install, eval = FALSE}
# Xarigan is only needed because it's used in docs/slides.Rmd.
install.packages(c("cloudml", "xaringan"))

# Install Google Cloud SDK.
# This will run a bunch of stuff in the Terminal and require you to press
# enter and then possibly opt-in to usage reporting.
cloudml::gcloud_install()

```



```{r check_install}
library(cloudml)
# Carefully review any errors messages here. This will report if you still
# need to setup billing for a project, or if the Machine Learning Engine API
# still needs to be enabled for this project.
job_status()

```

Create the bucket and copy our local files

  * Go to [Google Storage Browser](https://console.cloud.google.com/storage/browser)
  * Click "create bucket".
  * Enter "medical-images-data-XXX" as the bucket name, where you replace XXX with a random number or your name.
  * Update the google storage bucket name in the chunk below and in cloudml/cloudml_tuning.yml (line 2)

```{r setup_data}
gcloud_terminal()
# synchronize a bucket and a local directory
dirs$base
# This bucket exists in the project we've specified when setting up cloudml
# copy from a local directory to a bucket
gs_copy(dirs$base, "gs://medical-images-data", recursive = TRUE)
#gs_rsync("gs://medical-images-data", dirs$base)

# Remove our local medical-images-data so that we don't waste time copying it
# to Google Cloud every time we submit a job.
unlink("data-raw/medical_images.zip")
unlink("data-raw/Open_I_abd_vs_CXRs", recursive = TRUE)
```

```{r submit_job}
# May need to manually install revealjs, xaringan on local computer due to slides.Rmd.

# This will take a long time the first time due to installation of packages, etc.
# Every package that is successfully installed is re-used in future runs, so this
# speeds up, even if it takes a few iterations to run successfully.
job = cloudml_train("cloudml/cloudml_train.R",
                    flags = "cloudml/cloudml_tuning.yml",
                    # True will "collect job when training is complete". See ?cloudml_train
                    collect = TRUE)
```

```{r review_job}
# List past runs.
ls_runs()

# Text-based summary of latest run.
latest_run()

# Visual summary of latest run.
view_run()
```