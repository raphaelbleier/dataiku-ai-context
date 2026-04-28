# Dataiku Docs — notebooks

## [notebooks/containerized-notebooks]

# Containerized notebooks

By default, notebook kernels run alongside the notebook server process, which can lead to issues of resource contention on the machine (CPU or RAM). DSS offers the option to run the kernels in [containers](<../containers/index.html>), so as to run in:

  * local docker containers and benefit from resource monitoring from docker, or

  * remote containers in a Kubernetes cluster, thus freeing the machine hosting the notebook server from the burden of executing the notebooks




## Configuring containers for notebooks

A notebook kernel must be installed in the container.

### Builtin environment

Install or remove the notebook kernels for the builtin environment on the **Administration > Settings > Containerized execution** page.

### Code envs

For a [code environment](<../code-envs/index.html>) defined in **Administration > Code Envs**, within the code environment’s settings ensure that:

  * On **Packages to install** , Jupyter notebook support is selected, _and_

  * On **Containerized execution** , the environment is built for the desired container configurations




## Running a notebook in a container

Once the kernels are installed, you can select a container configuration by:

  * Creating a notebook and choosing the desired container

  * Changing the kernel in an existing notebook to a kernel running in a container




### Dependencies

  * Instance- and project-level code libraries are available in containerized notebooks, without needing to rebuild the container base image.

  * For code environments, changes in the package list require a rebuild of the base image (from the code env’s page) and a reload of the notebook to be effective.




### Writing files from notebook code

Code that saves files to the current working directory (for example when saving ML models) will not be effective in containerized notebooks because these files will only live in the container, and thus be lost when the notebook is unloaded. To save data from a running notebook, you should use [managed folders](<../connecting/managed_folders.html>).

---

## [notebooks/index]

# Code notebooks

In addition to [the Flow](<../flow/index.html>) where you perform the “production” work of your project with both [visual recipes](<../other_recipes/index.html>) and [code recipes](<../code_recipes/index.html>), and visual analysis where you can visually perform [data preparation](<../preparation/index.html>) and [machine learning](<../machine-learning/index.html>), DSS features code notebooks for exploratory / experimental work using code.

---

## [notebooks/jupyter-nbextensions]

# Installing Jupyter Extensions

You can install any extensions from [Jupyter contrib extensions](<https://jupyter-contrib-nbextensions.readthedocs.io/en/stable/nbextensions.html>) that do not require a server extension. You do not need to stop DSS to perform these actions.

When an extension is enabled, it is for all users on the platform, you cannot enable an extension for specific users.

Important

Some extensions need a specific package installed in the code env of the notebook to be able to run. Always refer to the documentation of the extension.

## List available extensions

To list all available extensions, open a terminal and type
    
    
    DATA_DIR/bin/dssadmin jupyter-nbextensions available
    

Warning

Even though they are listed, extensions requiring a server extension are not supported.

## List enabled extensions

To list all extensions enabled, open a terminal and type
    
    
    DATA_DIR/bin/dssadmin jupyter-nbextensions list
    

## Enable an extension

To enable an extension, open a terminal and type
    
    
    DATA_DIR/bin/dssadmin jupyter-nbextensions enable EXTENSION_NAME
    

For example if you want to enable the extension [Codefolding](<https://jupyter-contrib-nbextensions.readthedocs.io/en/stable/nbextensions/codefolding/readme.html>) :
    
    
    DATA_DIR/bin/dssadmin jupyter-nbextensions enable codefolding/main
    

## Disable an extension

To disable an extension, open a terminal and type
    
    
    DATA_DIR/bin/dssadmin jupyter-nbextensions disable EXTENSION_NAME
    

For example if you want to disable the extension [Collapsible Headings](<https://jupyter-contrib-nbextensions.readthedocs.io/en/stable/nbextensions/collapsible_headings/readme.html>) :
    
    
    DATA_DIR/bin/dssadmin jupyter-nbextensions disable collapsible_headings/main
    

## Customize an extension

Refer to the documentation of the extension to know the options and types supported. You can also find them in the `Parameters` section of the extension’s yaml file.

You need to edit the file on `DSS_HOME/jupyter-run/jupyter/config/nbconfig/notebook.json` and have an entry for the extension

Example using the extension Table of Contents (2):
    
    
    {
        "load_extensions": {
            "toc2/main": true,
        },
        "toc2": {
            "skip_h1_title": true,
            "toc_cell": true
        }
    }

---

## [notebooks/predefined-notebooks]

# Predefined notebooks

Code notebooks, especially Python and R notebooks are very useful for interactive exploratory analysis, especially for kinds of analysis that are not directly available in DSS visual analysis functionalities.

DSS provides a template mechanism when creating Python or R notebooks. This helps you get started very quickly with an analysis, while still giving you the full freedom to modify the notebook to your own needs, or to go further.

This provides additional interactive analysis capabilities with very little to no code that you have to write.

DSS comes with 8 prebuilt notebooks for analyzing datasets:

  * Simple statistical analysis

    * Distribution analysis and statistical tests on a single numerical population

    * Distribution analysis and statistical tests on multiple population groups

    * Correlations between variables

  * Dimensionality reduction

    * PCA

    * High-dimensionality data visualization using t-SNE

  * Time series

    * Time series visualization and analytics

    * Time series forecasting

  * Topics modeling using NMF and LDA




## Creating a notebook from a prebuilt template

From a dataset’s page or in the Flow, in the Actions menu, click on the Lab icon. Choose Notebooks > Predefined and choose the notebook to create.

Read carefully the instructions at the beginning of the notebook. Some notebooks are totally unattended, but for some notebooks, you’ll need to setup a few parameters. For example, on the distribution analysis notebook, you need to chose the variable to analyze.

## Creating your own prebuilt templates

You can create your own notebook templates that you or other users of your DSS instance can reuse. The templates that you create can also be distributed as a plugin.

  * Write your notebook in Jupyter (Python or R)

  * Download a copy as .ipynb of your notebook

  * Create a plugin as explained in [Plugins](<../plugins/index.html>)

  * Click on the “New Component” button and select “Notebook Template”

  * Choose the language your notebook is written in and whether you want your template to be accessible when creating a notebook from a dataset, or from the “New notebook” button in the notebooks list

  * Upon creating the “Notebook Template” component, DSS will take you to a code editor with pre-filled notebook content

  * Paste the content of your notebook in the editor in place of the pre-filled content

---

## [notebooks/python]

# Python notebooks

Python notebooks allow you to write and evaluate interactively Python code. Python notebooks in DSS are based on the Jupyter project.

Python notebooks can either be created directly from the notebooks list, or from a dataset’s Lab modal. Notebooks created using both methods are functionally equivalent.

However, if you create a notebook directly from a dataset’s lab modal:

>   * This notebook will remain associated to this dataset, so you can find it easily from the Lab modal later on, or from the dataset’s details view.
> 
>   * You can automatically create your notebook from templates that take the dataset name into account, allowing you to start faster.
> 
> 


## Creating a Python notebook

### From a dataset

This is the recommended method if the main goal of your notebook is to analyze and study a dataset.

  * From the dataset’s Actions menu, click on “Lab”

  * Choose Notebook > Python

  * Choose the template to use. This will populate your notebook with starter code. DSS provides several templates to read data from your dataset in various ways, and you can also create your own templates.




### From the notebooks list

  * From the notebook list, click on new menu, and select Python

  * Choose the template to use. This will populate your notebook with starter code. DSS provides several templates for performing various tasks. You can also create your own templates.




## Using the Python notebook

The Python notebook’s user interface is mostly the Jupyter one so we recommend that you read the Jupyter documentation.

### Available APIs

All DSS Python APIs are available in the code of a Python notebook. Please see [Python](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)")

Note that in a Python notebook, you do not need an API key to create a public API client. You can create a public API client which will inherit your personal access rights using `dataiku.api_client()`.

### Spark

You can use Spark from within a Python notebook. DSS provides templates to start using Pyspark, both when creating a notebook from a dataset or from the notebooks list.

### Unloading

A core concept of the Jupyter notebook is that the actual process running the code that you interactively type remains loaded in memory even if you leave the Jupyter interface. This allows you to start long-running computations while you are away.

Thus, it is important to understand that until you explicitly unload it, a Jupyter notebook keeps consuming resource (memory, possibly CPU). When you unload a notebook from memory, the process running the code and all its state is destroyed, but the code itself in the notebook is preserved.

DSS provides several ways to unload a notebook:

  * From the notebook UI interface, choose File > Close and Halt

  * From the notebooks list in the project, click on the yellow cross to unload the notebook

  * From your personal activity drawer, find the item corresponding to the notebook and click on the cross to unload it

  * For administrators, go to Administration > Monitoring > Background tasks, where you’ll see all notebooks running for all users (together with their identifiers) and choose which ones to unload

---

## [notebooks/search-notebook]

# Search notebook

The Search notebook is an interactive environment to perform search queries leveraging the native search capabilities of Elasticsearch.

A Search notebook is attached to a single Elasticsearch connection of DSS. It allows searching into one or multiple Elasticsearch indices or datasets.

The search query is based on the [Elasticsearch query_string](<https://www.elastic.co/guide/en/elasticsearch/reference/8.4/query-dsl-query-string-query.html>) syntax.

## Creating a Search notebook

You can create a Search notebook from the “Notebooks” tab of your project. Select “Search” among the new notebook options and then select an Elasticsearch connection.

Note

Only connections compatible with ES dialect v7 and higher are supported.

You can then configure the search scope of the first query.

## Queries and search scope

A Search notebook is made of several queries that can be rerun at any time. Each query has its own search scope that must be configured when adding a new query. The search scope of an existing query can be edited at any time.

The search scope can be based on _indices_ , an _index pattern_ or _datasets_.

### Indices-based search scope

DSS fetches all existing indices or aliases for the configured Elasticsearch connection. Select items from this list to configure the search scope of the current query.

Warning

Elasticsearch might raise an error if the string describing the scope of the search contains too many items. This limit is set by the [http.max_initial_line_length](<https://www.elastic.co/guide/en/elasticsearch/reference/8.4/modules-network.html#http-settings>) parameter. To search in a large volume of items, prefer configuring the scope using an index pattern.

### Index-pattern-based search scope

Enter a comma-separated list of indices or aliases to search. The pattern supports wildcards (`*`). To learn more about the syntax, please refer to [Multi-target syntax](<https://www.elastic.co/guide/en/elasticsearch/reference/8.4/api-conventions.html#api-multi-index>).

The pattern is resolved by Elasticsearch each time the query is executed.

### Datasets-based search scope

DSS fetches all existing datasets for the configured Elasticsearch connection. By default, DSS searches for datasets in the current project only but you can ask to load all projects you have access.

Note

The Search notebook does not allow explicit selection of partitions. Selecting specific partitions can be done either by:

  * editing the search scope for indices-based partitioned dataset

  * adding a filter in the search query for field-based partitioned datasets




Note

The custom DSL that might be configured to prefilter an existing dataset will be ignored. DSS displays a message for each affected dataset. Use the dataset [Search](<../connecting/elasticsearch.html#search-view>) tab if you want the custom DSL to be applied.

DSS resolves the underlying indices or aliases for all selected datasets when the notebook is loaded. To include changes from the index name setting of one of the selected datasets, you need to reload the page.

## Exporting a search query to a dataset

From a search query in a Search notebook, you can create a dataset so that you can apply further DSS recipes downstream on the Flow. DSS creates the resulting dataset with the following settings:

  * The index name is set to match the search scope of the query

  * The search query is applied using the custom DSL

---

## [notebooks/sql-notebook]

# SQL notebook

The SQL notebook is an interactive environment for performing queries on all SQL databases supported by Dataiku.

It supports all kinds of SQL statements, from simplest SQL queries to advanced DDL, stored procedures, …

A SQL notebook is attached to a single SQL connection of Dataiku.

## Creating a SQL notebook

You can create a SQL notebook either from the “Notebooks” tab of your project. Select SQL and then select the SQL connection on which you want to create the notebook.

## Cells and history

A SQL notebook is made of several _cells_. Each cell is where you execute and modify a single query and view its results. The recommended way to work with a SQL notebook is to keep a single cell for each query that you might want to rerun at a later time.

Each cell has its own history so you can work on tuning and debugging your queries with confidence, you’ll always be able to find previously executed states.

## Table View

The table view offers the same interactive exploration capabilities found in standard Dataiku datasets. You can use it to view and analyze the first 1000 rows of the results of your query.

You can perform column analysis to view statistics, search for specific values, and apply filters or sorts to the results without needing to re-run the query. Additionally, you can customize the display by hiding or showing specific columns to focus your analysis.

## Chart

You can visualize the first 1000 rows of your query results using the Dataiku charting engine.

Just as with standard datasets, you can create multiple charts based on the output of your query. You can create, edit, and delete as many charts as needed to analyze your results visually.

## AI SQL Generation

Dataiku includes an AI Assistant to help users write SQL queries. Please see [SQL Assistant](<../ai-assistants/sql-assistant.html>)