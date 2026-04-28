# Dataiku Docs — R

## [R/dygraphs]

# Using Dygraphs

The dygraphs package is an R interface to the dygraphs JavaScript charting library. It provides rich facilities for charting time-series data in R.

More information on dygraphs can be found at <https://rstudio.github.io/dygraphs/>

## Installing dygraphs

The dygraphs package is not installed by default in DSS. The recommended method for doing so is to use a [code environment](<../code-envs/index.html>). See [how to install R packages](<packages.html>)

You need to install the `dygraphs` package. If you are using a Conda environment, you can also choose to install in the Conda section the `r-dygraphs` package.

## Displaying charts in a Jupyter notebook

dygraphs charts will not work properly if you only use the `dygraph()` method in a Jupyter R notebook.

To display dygraphs charts in a Jupyter notebook, use:
    
    
    library(dataiku)
    library(dygraphs)
    
    the_graph <- dygraph(mydata)
    
    dkuDisplayDygraph(the_graph)
    

For example, to display the sample `lungDeaths` dataset
    
    
    library(dygraphs)
    library(dataiku)
    lungDeaths <- cbind(mdeaths, fdeaths)
    dkuDisplayDygraph(dygraph(lungDeaths))
    

### Converting a date column to a time-series

Dygraphs works primarily with time series. If you have a DSS dataset with a “date” column, you’ll need to convert your dataframe to a time series or XTS object.

For example, the following will create a time-series of `revenue` by `order_ts`
    
    
    library(xts)
    df <- dkuReadDataset("orders")
    
    timeseries <- xts(df$revenue, order.by=as.Date(df$order_ts))
    
    # You can then plot timeseries
    dkuDisplayDygraph(dygraph(timeseries) %>% dyRangeSelector())
    

## Displaying charts on a dashboard

dygraphs charts generated using R code can be shared on a DSS dashboard using the “static insights” system.

Each dygraphs chart can become a single insight in the dashboard. Each chart will retain full interactive capabilities (if you have defined them in your dygraph)

To do so, create [static insights](<../R-api/static_insights.html>)
    
    
    # dg is a dygraphs object, created using the dygraph() function
    
    dkuSaveHTMLInsight("my-dygraphs-plot", dg)
    

From the Dashboard, you can then add a new “Static” insight, select the `my-dygraphs-plot` insight

### Refreshing charts on a dashboard

You can refresh the charts automatically on a dashboard by using a scenario to re-run the above piece of code.

This call to `dkuSaveHTMLInsight` code can be:

  * In a DSS recipe (use a regular “Build” scenario step)

  * In a Jupyter notebook (use a “Export notebook” scenario step)




## Using in Shiny

Dygraphs can be used directly in Shiny. See <https://rstudio.github.io/dygraphs/shiny.html> for more information.

See <https://github.com/dataiku/dss-code-samples/tree/master/visualization/shiny/shiny-and-dygraphs> for a complete code sample

---

## [R/ggplot2]

# Using ggplot2

The ggplot2 package offers a powerful graphics language for creating elegant and complex plots.

For more information, see <http://ggplot2.org/>

## Installing ggplot2

The ggplot2 package is installed in the builtin R environment of DSS. If you are using a custom code environment, you’ll need to install it.

See [how to install R packages](<packages.html>)

  * For a regular R environment, you need to install the `ggplot2` package

  * If you are using a Conda environment, you can also choose instead to install in the Conda section the `r-ggplot2` package.




## Displaying charts in a Jupyter notebook

ggplot2 charts display naturally inthe Jupyter notebook.

For example, if “df” is a dataframe obtained with `dkuReadDataset` with columns “age” and “price”, you can make a scatter plot with a smoothing line with
    
    
    library(ggplot2)
    
    ggplot(df, aes(x = age))
            + geom_point( aes(y = price))
            + geom_smooth( aes(y = price))
    

## Displaying charts on a dashboard

ggplot2 charts generated using R code can be shared on a DSS dashboard using the “static insights” system.

Each chart can become a single insight in the dashboard.

To do so, create [static insights](<../R-api/static_insights.html>)

You can either save the last displayed plot:
    
    
    # Display a plot
    ggplot(df, aes(x=myXColumn, y=myYColumn)) + geom_point()
    
    # Save it as an insight
    dkuSaveGgplotInsight("my-ggplot2-plot")
    

Or save an explicit plot object:
    
    
    # Prepare a plot object
    gg <- ggplot(df, aes(x=myXColumn, y=myYColumn)) + geom_point()
    
    # Save it as an insight
    dkuSaveGgplotInsight("my-ggplot2-plot", gg)
    

From the Dashboard, you can then add a new “Static” insight, select the `my-ggplot2-plot` insight

### Refreshing charts on a dashboard

You can refresh the charts automatically on a dashboard by using a scenario to re-run the above piece of code.

This call to `dkuSaveGgplotInsight` code can be:

  * In a DSS recipe (use a regular “Build” scenario step)

  * In a Jupyter notebook (use a “Export notebook” scenario step)




## Using in Shiny

ggplot2 can be used directly in Shiny, inside of a `renderPlot` block.

---

## [R/ggvis]

# Using ggvis

ggvis is a data visualization package for R

For more information, see <http://ggvis.rstudio.com/>

## Installing ggvis

### Installing the ggvis package

The ggvis package is not installed by default. The recommended way to install it is to use a [code environment](<../code-envs/index.html>)

See [how to install R packages](<packages.html>)

  * For a regular R environment, you need to install the `ggvis` package

  * If you are using a Conda environment, you can also choose instead to install in the Conda section the `r-ggvis` package.




### Installing the frontend dependencies

To work, ggvis first needs some frontend libraries, that need to be preinstalled once.

To install the dependencies, open a R notebook and run
    
    
    library(dataiku)
    dkuInstallGgvisDependenciesOnce()
    

Warning

It is not possible to run this if your DSS instance has the User Isolation Framework enabled.

In that case, your DSS administrator needs to run this from a command-line ./bin/R prompt, after setting the DIP_HOME env variable to the location of the DSS data directory

## Displaying charts in a Jupyter notebook

ggvis charts will not work properly if you only enter it in a Jupyter notebook

Instead, use the `dkuDisplayGgvis` method.

For example; to display the first example in the ggvis documentation:
    
    
        library(dataiku)
        library(ggvis)
    
        # Prepare the chart
        chart <- mtcars %>% ggvis(~wt, ~mpg) %>% layer_points()
    
    # And display it
    dkuDisplayGgvis(Line)
    

## Displaying charts on a dashboard

googleVis charts generated using R code can be shared on a DSS dashboard using the “static insights” system.

Each chart can become a single insight in the dashboard.

To do so, create [static insights](<../R-api/static_insights.html>)
    
    
    # Prepare the chart
    chart <- mtcars %>% ggvis(~wt, ~mpg) %>% layer_points()
    
    # Save it as an insight
    dkuSaveGgvisInsight("my-ggvis-plot", chart)
    

From the Dashboard, you can then add a new “Static” insight, select the `my-ggvis-plot` insight

Plots can be donwloaded in SVG or PNG format

### Refreshing charts on a dashboard

You can refresh the charts automatically on a dashboard by using a scenario to re-run the above piece of code.

This call to `dkuSaveGgvisInsight` code can be:

  * In a DSS recipe (use a regular “Build” scenario step)

  * In a Jupyter notebook (use a “Export notebook” scenario step)

---

## [R/googlevis]

# Using googleVis

The googleVis package is R interface to Google’s chart tools.

For more information, see <https://cran.r-project.org/web/packages/googleVis/>

## Installing googleVis

The googleVis package is not installed by default. The recommended way to install it is to use a [code environment](<../code-envs/index.html>)

See [how to install R packages](<packages.html>)

  * For a regular R environment, you need to install the `googleVis` package

  * If you are using a Conda environment, you can also choose instead to install in the Conda section the `r-googlevis` package.




## Displaying charts in a Jupyter notebook

googleVis charts will not work properly if you only use the `plot()` method in a Jupyter R notebook.

Instead, use the `dkuDisplayGooglevis` method.

For example; to display the first example in the googleVis documentation:
    
    
        library(googleVis)
    
        # Make some data
        df=data.frame(country=c("US", "GB", "BR"),
              val1=c(10,13,14),
              val2=c(23,12,32))
    
    # Prepare the chart
    Line <- gvisLineChart(df)
    
    # And display it
    dkuDisplayGooglevis(Line)
    

## Displaying charts on a dashboard

googleVis charts generated using R code can be shared on a DSS dashboard using the “static insights” system.

Each chart can become a single insight in the dashboard.

To do so, create [static insights](<../R-api/static_insights.html>)
    
    
    # Prepare thje chart
    Line <- gvisLineChart(df)
    
    # Save it as an insight
    dkuSaveGooglevisInsight("my-googlevis-plot", Line)
    

From the Dashboard, you can then add a new “Static” insight, select the `my-googlevis-plot` insight

### Refreshing charts on a dashboard

You can refresh the charts automatically on a dashboard by using a scenario to re-run the above piece of code.

This call to `dkuSaveGooglevisInsight` code can be:

  * In a DSS recipe (use a regular “Build” scenario step)

  * In a Jupyter notebook (use a “Export notebook” scenario step)

---

## [R/index]

# DSS and R

DSS includes deep integration with R. In many parts of DSS, you can write R code:

  * In recipes (both regular R, SparkR and Sparklyr)

  * In Jupyter notebooks

  * For Shiny webapps

  * In plugins

  * In API node, for [custom prediction models](<../apinode/endpoint-r-prediction.html>) or [custom functions](<../apinode/endpoint-r-function.html>) endpoints




Any R package may be used in DSS.

In addition, DSS features a complete R API, which has its own [documentation](<../R-api/index.html>).

The following highlights how a few specific R packages can be used in DSS. DSS features advanced integration with most of the packages described below.

DSS also has [integration with RStudio](<rstudio.html>)

On Dataiku Cloud, R can be installed by activating the R integration extension in the Extension tab of the Launchpad.

---

## [R/packages]

# Installing R packages

Any R package can be used in DSS. There is no restriction to which package can be installed and used.

The recommend way to install your own R packages is to install them in a [code environment](<../code-envs/index.html>).

## Installing in a specific code environment (recommended)

Please see [Operations (R)](<../code-envs/operations-r.html>)

## Installing in the root DSS environment (not recommended)

In addition to user-controlled code environments, DSS has its own builtin R environment, which contains a default set of packages. It is possible, although not recommended to install your own packages in that builtin environment.

Installing packages in the builtin environment requires shell access on the host running DSS and can only be performed by DSS administrators.

A number of packages are preinstalled in the builtin environment. Modifying the version of these packages is **not supported** and may result in causing DSS to stop functioning.

  * Go to the DSS data directory

  * Run `./bin/R`




Warning

Beware: you must run ./bin/R, not the “R” binary on your PATH

  * Run the regular `install.packages()` R command




In Dataiku Cloud, the built-in environment is managed so it is not possible to install your own packages. Please use a code environment to install non-default packages.

### Installing without Internet access

---

## [R/prophet]

# Installing STAN or Prophet

Warning

**Tier 2 support** : These instructions installation are provided “as-is” and are covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

The STAN and prophet packages for time series forecasting are challenging to install, because they require very recent C++ compilers that most Linux distributions do not provide, in particular the “C++14” features.

## Common errors

You will often see the following error in the code environment build log:
    
    
    Error in .shlib_internal(args) :
            C++14 standard requested but CXX14 is not defined
    

## Installing on RedHat 7 or Centos 7

On a CentOS 7.6 system, you could for example proceed as follows:

  1. As root, install the “software collection library” (SCL)



    
    
    yum install centos-release-scl
    

  2. As root, install the latest Developer Toolset (which contains a recent version of the GCC suite)



    
    
    yum install devtoolset-8-toolchain
    

  3. Activate the developer toolset in the DSS user session by adding the following to the session initialization file for the DSS user account (ie .bash_profile or equivalent):



    
    
    source /opt/rh/devtoolset-8/enable
    

  4. Logout and login from your shell on the DSS user account, to pick up the new definition above, and restart DSS from it so it also picks the updated environment.

  5. Create a file named $HOME/.R/Makevars, where $HOME is the homedir of the DSS user, containing:



    
    
    CXX14 = g++
    CXX14FLAGS = -O3 -march=native -mtune=native -fPIC
    

This declares to R that there is a C++ 14 compiler available, named “g++”

You should now be able to build R packages containing C++14 code from DSS.

  6. If UIF is enabled on your DSS instance, you also need to tell UIF to use system sudo, because devtoolset-8 includes a non-compatible sudo. Follow [these steps](<../user-isolation/troubleshooting.html>) to edit the `install.ini` file and add a line:



    
    
    [mus]
    custom_root_sudo = ["/usr/bin/sudo"]

---

## [R/reusing-code]

# Reusing R code

When you write a lot of R code in a project, or across projects, you will often want to make reusable parts of code.

DSS provides several mechanisms for reusing R code:

  * Packaging your code as functions or modules, and making them available in a specific project

  * Importing code that has been made available from one project to another

  * Packaging your code as functions or modules, and making them available in all projects

  * Packaging your code as a reusable plugin, and making it available for coder and non-coder users alike




## Sharing R code within a project

In each project, you can write R files in the **Library editor**. The project’s library editor is available by going into the “Code” universe (orange), and selecting the “Libraries” tab.

You can then write code under a “R source” folder, i.e. a folder that has the “R” icon associated to it.

Each time you want to use the functions defined in these R files, you need to use the `dkuSourceLibR` function, which uses the `source` feature of R to import the functions in the global namespace.

For example if you wrote a file “miscfuncs.R” that contains a `do_awesome_stuff()` function, you can use:
    
    
    library(dataiku)
    
    dkuSourceLibR("miscfuncs.R")
    
    do_awesome_stuff()
    

### Working with multiple source folders

By default, the Library editor contains two top-level folders, “python” and “R”, which are respectively the root folder for Python and R code.

You can create other folders that will also act as R source folders, i.e. that will be available using `dkuSourceLibR` to all R processes running in the project.

Working with multiple source folders is mainly useful when [importing code from external Git repositories](<../collaboration/import-code-from-git.html>).

To manually edit the list and order of the R source folders, open the `external-libraries.json` file in the library editor and edit the `rsrcPath` list. All paths must be relative to the root of the library editor.

## Importing libraries from other projects

If you have created libraries in a project A, you can import them in project B. The libraries of project A will be added to the source path of all code running in project B.

  * Go to the library editor of project B

  * Open the `external-libraries.json` file

  * Edit the `importLibrariesFromProjects` list and add the project key (which appears in the URL, i.e. not the project display name) to it

  * Save the `external-libraries.json` file




You need to have “Read project content” permission on A and “write project content” on B.

## Sharing R code globally

You can write custom R code files in the global **R library editor**. The global R library editor is available from the **Application menu > Global Shared Code**.

The click on the “lib/R” tab

Files that are written here can be used by all R code in all projects.

Each time you want to use the functions defined in these R files, you need to use the `dkuSourceLibR` function, which uses the `source` feature of R to import the functions in the global namespace.

For example if you wrote a file “miscfuncs.R” that contains a `do_awesome_stuff()` function, you can use:
    
    
    library(dataiku)
    
    dkuSourceLibR("miscfuncs.R")
    
    do_awesome_stuff()
    

### Permissions

You need the “Edit lib folders” global (group-level) permission to use the global R library editor.

## Manual editing of the R code library folder

Although not recommended, if you have shell access to the DSS machine, you can modify the library folder directly in `DATA_DIR/lib/R`

## Packaging code as plugins

See [Plugins](<../plugins/index.html>)

## Packaging your R code as a package

The source mechanism is practical but does not enforce namespacing. To get namespacing, you need to build a complete R package, compile it, and install it (possibly in the code environment) using `install.packages`. This generally requires shell access on the machine running DSS.

---

## [R/rmarkdown]

# R Markdown reports

R Markdown reports can be used to generate documents based on your project’s data.

## Technical Requirements

R Markdown reports can be built in any R code environment that includes the `rmarkdown` package. The builtin R environment has the `rmarkdown` package preinstalled.

Many export formats of R Markdown require the `pandoc` system package to be installed on your Linux server. This package pulls a large number of additional dependencies and is not installed by default. Ask your system administrator to install the `pandoc` system package (pandoc version 1.12.3 or higher). You will also need the the `adjustbox`, `collectbox`, `ucs`, `collection-fontsrecommended`, and `titling` LaTeX packages to produce PDF documents.

## Creating an R Markdown report

You can create a report from the “RMarkdown reports” tab of the “Notebooks” section of DSS.

## Writing R Markdown in DSS

[R Markdown](<http://rmarkdown.rstudio.com/>) is an extension of the [markdown](<https://en.wikipedia.org/wiki/Markdown>) language that enables you to mix formatted text with code written in several languages (in particular R or Python).

When editing your R Markdown report, you can “build” it to generate the output document. This document can be displayed as HTML and published into a dashboard. You can download the output document in various formats including:

>   * HTML
> 
>   * PDF
> 
>   * Microsoft Word (docx)
> 
>   * OpenDocument (odt)
> 
>   * Markdown (or plain text)
> 
> 


### Including Images

One method is to use markdown image syntax. The sample code below references the image `image_name.png` in the specified path.
    
    
    ![](DATADIR/managed_folders/YOUR_PROJ/YOUR_FOLDER/image_name.png)
    

Another method is to use the `knitr` package’s `include_graphics()` function. Below is an example of an R Markdown block that includes an image in a Dataiku DSS folder.

  * the value assigned to `folder` is the unique ID of the Dataiku folder; this can be found, for example, in the URL when you have the folder open

  * the value assigned to `pathWithinFolder` is simply the path to the file you want to use; in the example, the image is in a subfolder of the main folder

  * the `paste()` function concatenates the pieces of the path, and

  * the `include_graphics()` function inserts the image in the report



    
    
    ```{r}
    library(dataiku)
    folder = "9672PoPB"
    pathWithinFolder = "/testing/0/10.png"
    fullPath = paste(dkuManagedFolderPath(folder),pathWithinFolder,sep="")
    knitr::include_graphics(fullPath)
    ```
    

### Using Python blocks

Be aware that Python blocks in R Markdown reports are not run by the built-in DSS Python environment. We recommend that you create a [Python code environment](<../code-envs/operations-python.html>) in DSS and set it as the Python environment used by R Markdown. For example:
    
    
    ```{r global_options, include=FALSE}
    library(knitr)
    library(reticulate)
    use_python("[data-dir]/code-envs/python/[code-env-name]/bin/python")
    knitr::knit_engines$set(python = reticulate::eng_python)
    matplotlib <- import("matplotlib")
    matplotlib$use('Agg')
    ```
    
    ```{python, engine.path="[data-dir]/code-envs/python/[code-env-name]/bin/python", echo=FALSE}
    import seaborn
    import pandas as pd
    print(dir(seaborn))
    ```

---

## [R/rstudio]

# RStudio integration

In addition to the ability to [use the DSS R API outside of DSS](<../R-api/outside-usage.html>), DSS features several integration points with RStudio.

## RStudio Server in a Code Studio

Code Studios allow you to run and expose a RStudio server in Dataiku to interactively edit and debug R recipes, libraries…

Learn more about [Code Studios](<../code-studios/index.html>) and how to [launch a RStudio Server](<../code-studios/code-studio-ides/rstudio.html>).

## RStudio Desktop

As soon as you install the `dataiku` package in your RStudio Desktop (as documented in [Using the R API outside of DSS](<../R-api/outside-usage.html>)), new RStudio extensions become available in the “Addins” menu:

These extensions allow you to:

  * Setup connection to a DSS instance (URL and API key)

  * Download the code of a R recipe in order to edit it locally in RStudio

  * Once you’re done editing the recipe, uploading it back to DSS for saving and execution.




## RStudio Server (running on a separate server)

Integration with RStudio Server runs exactly like with RStudio Desktop, in the case where RStudio Server is not running on the same server as DSS.

In addition, in order to provide a better user experience to your users, you can choose to embed the RStudio Server UI directly within the Dataiku UI.

### Embedding the RStudio Server UI in DSS

  * Edit `/etc/rstudio/rserver.conf` and add a line `www-frame-origin = BASE_URL_OF_DSS`

  * Restart RStudio Server

  * Edit `DSS_DATA_DIR/config/dip.properties` and add a line `dku.rstudioServerEmbedURL=http(s)://URL_OF_RSTUDIO_SERVER/`

  * Restart DSS




In a project, from the top navigation bar, the code menu will now have a new “RStudio Server” entry that gets you to RStudio Server. You need to login to RStudio Server independently from DSS.

You can then install the `dataiku` package and use the RStudio extensions (as documented above) to interact with DSS. If your RStudio Server is running on the same machine as DSS, more advanced integrations are possible. See below.

## RStudio Server (running on the DSS server)

If:

  * You are running RStudio Server

  * RStudio Server is running on the same host as DSS

  * You are using [User Isolation Framework](<../user-isolation/index.html>), and you are using the same UNIX account name in DSS and RStudio Server




You can use an enhanced version of the RStudio integration. In addition to the features documented above, this gives you the following (for each user of DSS who also uses RStudio Server):

  * DSS can automatically install the `dataiku` package in the R library of the user

  * DSS can automatically setup the connectivity between DSS and RStudio Server, so that you don’t have to go through the URL and API key declaration phase

  * DSS can automatically create a RStudio Server project corresponding to a Dataiku project, giving you RStudio workspaces per DSS project.




To benefit from these:

  * Embed RStudio Server as described above

  * In the RStudio page, you’ll have a “RStudio actions” button




### Installing the R package

Select the “Install R package” action. The `dataiku` package (and its dependencies) will be installed into the personal R library of the user.

### Setup connectivity

Select the “Setup connectivity to DSS” action. This action creates a personal API key and configures the `dataiku` package running in the personal R library of the user to be able to talk with DSS.

After this action, you can use the RStudio extensions documented above.

### Create RStudio project

Select the “Create RStudio project” action. This action creates a folder in the home directory of the user and adds it to the “Recent projects” list. Afterwards, in RStudio Server, click “File > Recent Projects” to switch to the project.