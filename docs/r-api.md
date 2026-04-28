# Dataiku Docs — r-api

## [R-api/authinfo]

# Authentication information

## Introduction

From any R code, it is possible to retrieve information about the user or API key currently running this code.

This can be used:

  * From code running within a recipe or notebook, for the code to know who is running said code

  * From code running with a plugin recipe, for the code to know who is running said code




Furthermore, the API provides the ability, from a set of HTTP headers, to identify the user represented by these headers. This can be used in the backend of a Shiny webapp, in order to securely identify which user is currently browsing the webapp.

## Code samples

### Basic usage
    
    
    library(dataiku)
    
    auth_info = dkuGetAuthInfo()
    
    # auth_info is list dict which contains at least a "authIdentifier" member
    print(auth_info$authIdentifier)
    

### Other samples

  * How to authenticate calls made from a Shiny webapp: <https://github.com/dataiku/dss-code-samples/tree/master/_old/visualization/shiny/authenticate-calls>




## Reference documentation

See:

  * <https://doc.dataiku.com/dss/api/5.0/R/dataiku/reference/dkuGetAuthInfo.html>

  * <https://doc.dataiku.com/dss/api/5.0/R/dataiku/reference/dkuGetAuthInfoFromBrowserHeaders.html>

  * <https://doc.dataiku.com/dss/api/5.0/R/dataiku/reference/dkuGetAuthInfoFromRookRequest.html>

---

## [R-api/index]

# R API

DSS comes with a complete set of R API.

In many parts of DSS, you can write R code (recipes, notebooks, webapps, …). This R code interacts with DSS (for example, to read datasets) using the R API of DSS.

Most of the R APIs can be used both _within_ DSS and _outside_ of DSS (for example, in RStudio).

The Dataiku R API is contained in several R packages:

  * `dataiku`, containing most of the features

  * `dataiku.spark`, to work with SparkR in Spark 1.X

  * `dataiku.spark2`, to work with SparkR in Spark 2.X

  * `dataiku.sparklyr`, to work with sparklyr




Warning

**Tier 2 support** : Support for SparkR and sparklyr is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

---

## [R-api/inside-usage]

# Using the R API inside of DSS

When running inside of DSS, nothing is required in order to use the APIs contained in the `dataiku` R package.

You simply need to use `library(dataiku)` and start using the functions of the package

---

## [R-api/outside-usage]

# Using the R API outside of DSS

You can use most of the R APIs outside of DSS in your favorite IDE, such as RStudio. This allows you to develop code in that IDE and then push it to DSS.

## Installing the dataiku package

The `dataiku` package is not available through CRAN. Instead, it must be obtained from the DSS instance itself.
    
    
    install.packages("http(s)://DSS_HOST:DSS_PORT/public/packages/dataiku_current.tar.gz", repos=NULL)
    

## Setting up the connection with DSS

In order to connect to DSS, you’ll need to supply:

  * The URL of DSS

  * A REST API key in order to perform actions




We strongly recommend that you use a personal API key. Please see [Public API Keys](<../publicapi/keys.html>) for more information

There are three ways to supply this information:

  * Using the RStudio integration, as described in [RStudio integration](<../R/rstudio.html>)

  * Through code:



    
    
    library(dataiku)
    
    dkuSetRemoteDSS("http(s)://DSS_HOST:DSS_PORT/", "Your API Key secret")
    

  * Through environment variables. Before starting your R process, export the following environment variables:



    
    
    export DKU_DSS_URL=http(s)://DSS_HOST:DSS_PORT/
    export DKU_API_KEY="Your API key secret"
    

  * Through a configuration file. Create or edit the file `~/.dataiku/config.json` (or `%USERPROFILE%/.dataiku/config.json` on Windows), and add the following content:



    
    
    {
      "dss_instances": {
        "default": {
          "url": "http(s)://DSS_HOST:DSS_PORT/",
          "api_key": "Your API key secret"
        },
      },
      "default_instance": "default"
    }
    

You can now use most of the functions of the `dataiku` package from your own machine, independently from the DSS installation.

### Setting the current project

Most functions of the `dataiku` package require a “current project” to be set. This allows functions like `dkuReadDataset("my_dataset_name")` to know which project to load the dataset from.

To set the current project, use:
    
    
    dkuSetCurrentProjectKey("PROJECT_KEY")
    

### Advanced options

#### Disabling SSL certificate check

If your DSS has SSL enabled, the packages will verify the certificate. In order for this to work, you may need to add the root authority that signed the DSS SSL certificate to your local trust store. Please refer to your OS or Python manual for instructions.

If this is not possible, you can also disable checking the SSL certificate:

  * Through code:



    
    
    dkuSetRemoteDSS("http(s)://DSS_HOST:DSS_PORT/", "Your API Key secret", TRUE)
    

  * Through environment variables: Not supported at the moment

  * Through configuration file: Modify the configuration file as such:



    
    
    {
      "dss_instances": {
        "default": {
          "url": "http(s)://DSS_HOST:DSS_PORT/",
          "api_key": "Your API key secret",
          "no_check_certificate": true
        }
      },
      "default_instance": "default"
    }

---

## [R-api/reference-doc]

# Reference documentation

The DSS R API is made of several R packages which are bundled with DSS:

  * The `dataiku` package provides datatable-based interaction
    
    * Reference documentation for the _dataiku_ package can be found at <https://doc.dataiku.com/dss/api/14/R/dataiku/reference>

  * The `dataiku.spark` package provides Spark interaction using the “SparkR” native API for Spark 1.X
    
    * Reference documentation for the _dataiku.spark_ package can be found at <https://doc.dataiku.com/dss/api/14/R/dataiku.spark/reference>

  * The `dataiku.spark2` package provides Spark interaction using the “SparkR” native API for Spark 2.X
    
    * Reference documentation for the _dataiku.spark2_ package can be found at <https://doc.dataiku.com/dss/api/14/R/dataiku.spark2/reference>

  * The `dataiku.sparklyr` package provides Spark interaction using the “sparklyr” API
    
    * Reference documentation for the _dataiku.sparklyr_ package can be found at <https://doc.dataiku.com/dss/api/14/R/dataiku.sparklyr/reference>

---

## [R-api/static_insights]

# Creating static insights

In DSS code recipes and notebooks, you can create static insights: data files that are created by code and that can be rendered on the dashboard.

This capability can notably be used to embed in one click charts created using:

  * [ggplot2](<../R/ggplot2.html>)

  * [dygraphs](<../R/dygraphs.html>)

  * [ggvis](<../R/ggvis.html>)

  * [googleVis](<../R/googlevis.html>)




You can also use it for embedding in the dashboard any kind of content (image, HTML, …)

The API reference for creating insights in R can be found in the documentation of the `dataiku` package: <https://doc.dataiku.com/dss/api/14/R/dataiku/reference>