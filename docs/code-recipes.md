# Dataiku Docs — code-recipes

## [code_recipes/code-explanations]

# Code explanations

Dataiku includes an AI assistant to generate explanations of code used in code recipes

Please see [AI Explain](<../ai-assistants/ai-explain.html>) for setup instructions

## Generating code explanations

  * Select the **Explain** tab in the left-hand side pane on the code recipe screen

  * Click **Explain**




You can choose to generate an explanation of a code selection only by making a code selection first.

## Explanation options

After clicking **Settings** it is possible to adjust the generated explanations using these options:

  * Language: the natural language of the explanation

  * Purpose: the intended audience of the explanation

  * Length: the verbosity of the explanation




Note

The explanations are AI-generated and as such are subject to errors.

---

## [code_recipes/common]

# The common editor layout

All code recipes in DSS use a common layout and UX with a code editor.

## Create the recipe

You can create a code recipe

  * From the Flow, by clicking on the New recipe button

  * From the Flow, in the actions menu of the dataset

  * From the Actions menu while being on a dataset

> 


### Select inputs and outputs

A creation modal appears, which lets you:

  * Select the input dataset(s)

  * Create or select the output dataset(s) or folders




If you have not already selected one, the first step is to select the datasets that are used as “inputs” of your recipe. You may only read in these datasets, not write.

> You then need to select or create the output datasets. Generally, when you create a recipe, you will be creating its output dataset at the same time. Most times, the output datasets of a recipe will be managed datasets (for more information on Managed datasets, see the [DSS concepts](<../concepts/index.html>) page).

>   * Give a name to the output dataset

  * Select in which connection it will be stored. For more information about the concept of storing Managed Datasets into connection, see [DSS concepts](<../concepts/index.html>)

  * You might be able to select storage format and partitioning for your dataset, depending on the storage backends.

  * Click on “Create dataset”




You can then create the recipe.

## Write code

Once you have created your recipe, it is autofilled with “starter” code. This code is here to help you get started, but obviously needs to be modified to suit your needs.

The code should fill data in the output datasets. Please refer to the specific documentation for each recipe for more information about how to do that.

## Validate and run the recipe

Code recipes have a “Run” button that automatically appears as soon as you have defined at least one output dataset for the recipe.

When you click the Run button, a new job is started. When it’s over, you get either a success or error message and can explore the generated output datasets.

Most recipes also have a “Validate” button that performs consistency checks in the recipe (for example, check the validity of the code). Some recipes are also able to automatically compute the output schema of your dataset(s). If the current output schema does not match what the recipe wants to output, you’ll get prompts to update the output datasets’ schemas.

---

## [code_recipes/dynamic-repeat]

# Dynamic recipe repeat

Any SQL query recipe can be configured to be repeating. Such a recipe takes a secondary “parameters” dataset as a setting and executes the query as many times as there are rows in the parameters dataset. Each time the query is executed, variables in the code are expanded based on the current row of the parameters dataset. The output of the recipe is the concatenation of the individual query results.

## Example use case

In order to dynamically build an output dataset based on repeated expansions of a SQL query, you can build a Flow like this:

  * Have a large dataset with a column named `title`

  * Create an editable dataset with a column named `title_to_match` containing values which can be used in a `WHERE` clause of a SQL query

  * Create a SQL query recipe, enable the repeating feature picking the editable dataset as the repeating parameters dataset

  * The query could be something like this:
        
        SELECT *
        FROM "MOVIES"
        WHERE "title" ILIKE '%${title_to_match}%'
        




## Configuring

To enable a repeating recipe:

  * Go to the Advanced tab of the recipe editor

  * Within the **Dynamic recipe repeat** section, make sure **Enable** is checked and a dataset is selected in the **Parameters dataset** dropdown




Once enabled, you’ll notice a repeat icon on the recipe in the Flow.

By default a variable is created for each column of the parameters dataset however it is also possible to create a mapping of column names to variable names. Only the variables specified by the mapping will then be created. This is useful to avoid variable shadowing.

---

## [code_recipes/hive]

# Hive recipes

For an overview of how DSS and Hive interact, please refer to [Hive](<../hadoop/hive.html>).

In its simplest form, the Hive recipe can be used to compute a new HDFS dataset by writing a SQL SELECT query.

## Pre-requisites

Prior to writing Hive recipes, you need to ensure that DSS and Hadoop are properly configured together. See [Setting up Hadoop integration](<../hadoop/installation.html>).

## Creating a simple Hive recipe

  * Create a new Hive recipe

  * Select the input datasets. Only HDFS datasets that have a compatible set of params will be proposed.

  * Select the dataset that will store the results of the Hive query. You can use an existing not-yet-connected HDFS dataset or create a new managed dataset (which can only be stored on HDFS)




If you create a new managed dataset and your input is partitioned, it’s recommended to use the « Copy partitioning » option.

You can then write your HiveQL query.

In the query, the datasets that you selected as input will automatically be available as tables with their proper schema. For example, if you declared dataset A as input of the recipe, and A has columns a1 and a2, you can write “SELECT a1 from A”.

When you run the query, the results of the SELECT query are automatically inserted in the output dataset (or output partition of the dataset, if the output dataset is partitioned). As usual with Data Science Studio, this insertion is made in “overwrite” mode. The previous content of the dataset (resp. partition) is erased and replaced with the new one.

## Validation and schema handling

At any time while writing your Hive recipe, you can click the “Validate” button to perform a comprehensive validation of your script. The validate button performs all checks that Hive normally performs, like:

  * Erroneous table/fields names

  * Hive QL syntax errors

  * Wrong types




When you validate, the schema of the output datasets are compared to the output of your Hive queries. If the schemas don’t match (which will always be the case when you validate for the first time after adding a new empty output dataset), DSS will explain the incompatibilities and propose to automatically adjust the output dataset schema.

## Available tables and partitions

Each Hive recipe runs in a separate Hive environment (called a metastore). In this isolated environment, only the datasets that you declared as inputs exist as tables. If you get table not found errors when running the query, you are probably trying to access a dataset that you did not declare as input.

If your input datasets are partitioned, only the partitions that are needed by the dependencies system are available. Therefore, you do not need to write any WHERE clause to restrict the selected partitions. Only the required partitions will be included in the results.

## Writing more complex queries

The cases we covered until now were cases where you actually only want to insert into the output dataset the results of a single Hive query. Behind the scene, Data Science Studio automatically rewrote your Hive query to include the Hive INSERT commands.

That simple case does not however cover all possible cases of the Hive recipe. Some example use cases include:

  * Write temporary tables to compute your dataset

  * Write several datasets in a single Hive recipe (which can be useful for performance reasons)




In that case, you need to write the full INSERT statement. Basically, you must write a statement like “INSERT OVERWRITE TABLE output_dataset_name SELECT your_select_query”.

Note

This statement does not cover the partitioned case. For more information about inserting when writing partitioned Hive recipes, see [Partitioned Hive recipes](<../partitions/hive.html>).

---

## [code_recipes/impala]

# Impala

Impala is an engine that runs Impala SQL queries on a hadoop cluster and offers performance gains over executing the same queries in Hive.

In its simplest form, the Impala recipe can be used to compute a new HDFS dataset by writing a SQL SELECT query.

## Pre-requisites

Prior to writing Impala recipes, you need to ensure that DSS and Hadoop are properly configured together, as well as DSS and Impala. See [Setting up Hadoop integration](<../hadoop/installation.html>) and [Impala](<../hadoop/impala.html>).

## Creating a simple Impala recipe

  * Create a new Impala recipe

  * Select the input datasets. Only HDFS datasets that have a compatible set of params will be proposed.

  * Select the dataset that will store the results of the Impala query. You can use an existing not-yet-connected HDFS dataset or create a new managed dataset (which can only be stored on HDFS)




If you create a new managed dataset and your input is partitioned, it’s recommended to use the « Copy partitioning » option.

You can then write your Impala SQL query.

In the query, the datasets that you selected as input will automatically be available as tables with their proper schema. For example, if you declared dataset A as input of the recipe, and A has columns a1 and a2, you can write “SELECT a1 from A”.

When you run the query, the results of the SELECT query are automatically inserted in the output dataset (or output partition of the dataset, if the output dataset is partitioned). Whether the dataset is replaced by the new data, or the new data appended to the dataset, is controlled by the “Append” checkbox on the “I/O” tab.

## Validation and schema handling

At any time while writing your Impala recipe, you can click the “Validate” button to perform a comprehensive validation of your script. The validate button performs all checks that Impala normally performs, like:

  * Erroneous table/fields names

  * Impala QL syntax errors

  * Wrong types




When you validate, the schema of the output datasets are compared to the output of your Impala query. If the schemas don’t match (which will always be the case when you validate for the first time after adding a new empty output dataset), DSS will explain the incompatibilities and propose to automatically adjust the output dataset schema.

## Stream mode

Because of Impala’s limitations when it comes to writing its output, it is sometimes desirable to simply not use Impala for writing the query output back to HDFS. By activating the “Stream mode” on the “Advanced” tab of the recipe, the user can let DSS handle the output. This makes it possible to use any type of output format and/or compression supported by DSS, and to avoid any problem that could arise from setting up or synchronizing file access permissions.

## Available tables and partitions

Impala queries are run on table definitions from the global metastore, so you need to use variables to filter on partitions (if using partitioned datasets). See [Partitioning variables substitutions](<../partitions/variables.html>) for information on variables in SQL queries in DSS.

---

## [code_recipes/index]

# Code recipes

DSS has a white-box approach to data projects. As such, you can use in your [Flow](<../flow/index.html>) recipes that execute a piece of user-defined code.

All recipes in which you write code have a common editor layout

---

## [code_recipes/pyspark]

# PySpark recipes

DSS lets you write recipes using Spark in Python, using the PySpark API.

As with all Spark integrations in DSS, PySPark recipes can read and write datasets, whatever their storage backends.

Pyspark recipes manipulate datasets using the PySpark / SparkSQL “DataFrame” API.

## Creating a PySpark recipe

  * First make sure that [Spark is enabled](<../spark/installation.html>)

  * Create a Pyspark recipe by clicking the corresponding icon

  * Add the input Datasets and/or Folders that will be used as source data in your recipes.

  * Select or create the output Datasets and/or Folder that will be filled by your recipe.

  * Click Create recipe.

  * You can now write your Spark code in Python. A sample code is provided to get you started.




Note

If the Pyspark icon is not enabled (greyed out), it can be because:

  * Spark is not installed. See [Setting up Spark integration](<../spark/installation.html>) for more information

  * You don’t have [write access](<../security/permissions.html>) on the project

  * You don’t have the proper [user profile](<../security/user-profiles.html>). Your administrator needs to grant you an appropriate user profile




## Anatomy of a basic Pyspark recipe

First of all, you will need to load the Dataiku API and Spark APIs, and create the Spark context
    
    
    # -*- coding: utf-8 -*-
    
    # Import Dataiku APIs, including the PySpark layer
    import dataiku
    from dataiku import spark as dkuspark
    # Import Spark APIs, both the base SparkContext and higher level SQLContext
    from pyspark import SparkContext
    from pyspark.sql import SQLContext
    
    sc = SparkContext()
    sqlContext = SQLContext(sc)
    

You will then need to obtain DataFrames for your input datasets and directory handles for your input folders:
    
    
    dataset = dataiku.Dataset("name_of_the_dataset")
    df = dkuspark.get_dataframe(sqlContext, dataset)
    

These return a SparkSQL DataFrame You can then apply your transformations to the DataFrame.

Finally you can save the transformed DataFrame into the output dataset. By default this method overwrites the dataset schema with that of the DataFrame:
    
    
    out = dataiku.Dataset("out")
    dkuspark.write_with_schema(out, the_resulting_spark_dataframe)
    

If you run your recipe on partitioned datasets, the above code will automatically load/save the partitions specified in the recipe parameters.

---

## [code_recipes/python]

# Python recipes

Dataiku DSS lets you write recipes using the Python language. Python recipes can read and write datasets, whatever their storage backend is.

For example, you can write a Python recipe that reads a SQL dataset and a HDFS dataset and that writes an S3 dataset. Python recipes use a specific API to read and write datasets.

Python recipes can manipulate datasets either :

  * Using regular Python code to iterate on the rows of the input datasets and to write the rows of the output datasets

  * Using Pandas dataframes.




## Your first Python recipe

  * From the Flow, select one of the datasets that you want to use as input of the recipe.

  * In the right column, in the “Actions” tab, click on “Python”

  * In the recipe creation window, create a new dataset that will contain the output of your Python code.

  * Validate to create the recipe

  * You can now write your Python code.




(Note that if needed, you might need to fill the partition dependencies. For more information, see [Working with partitions](<../partitions/index.html>))

First of all, you need to load the Dataiku API (the Dataiku API is preloaded when you create a new Python recipe)
    
    
    import dataiku
    

You then need to obtain Dataset objects corresponding to your inputs and outputs.

For example, if your recipe has datasets A and B as inputs and dataset C as output, you can use :
    
    
    datasetA = dataiku.Dataset("A")
    datasetB = dataiku.Dataset("B")
    datasetC = dataiku.Dataset("C")
    

Alternatively, you can get the inputs of the recipe as they are in the Input/Output tab with
    
    
    from dataiku import recipe
    # object_type can be omitted if there are only datasets
    all_input_datasets = recipe.get_inputs(object_type='DATASET')
    single_input_dataset = recipe.get_input(object_type='DATASET')
    second_input_dataset = recipe.get_input(index=1, object_type='DATASET')
    

## Introduction to reading and writing datasets

Pandas is a popular python package for in-memory data manipulation. <http://pandas.pydata.org/>

Using the dataset via Pandas will load your dataset in memory, it is therefore critical that your dataset is “small enough” to fit in the memory of the DSS server or container in which the recipe runs.

The core object of Pandas is the DataFrame object, which represents a dataset.

Getting a Pandas DataFrame from a Dataset object is straightforward:
    
    
    # Object representing our input dataset
    cars = dataiku.Dataset("mycarsdataset")
    
    # We read the whole dataset in a pandas dataframe
    cars_df = cars.get_dataframe()
    

The `cars_df` is a regular Pandas data frame, which you can manipulate using all Pandas methods.

If your dataset doesn’t fit in memory, read it in chunks. You will find more information on this subject in the Developer Guide’s [corresponding section](<https://developer.dataiku.com/latest/concepts-and-examples/datasets/datasets-data.html#ce-datasets-datasets-data-chunked-read> "\(in Developer Guide\)").

### Writing the Pandas DataFrame in an output dataset

Once you have used Pandas to manipulate the input data frame, you generally want to write it to the output dataset.

The Dataset object provides the method [`dataiku.Dataset.write_with_schema()`](<https://developer.dataiku.com/latest/api-reference/python/datasets.html#dataiku.Dataset.write_with_schema> "\(in Developer Guide\)")
    
    
    output_ds = dataiku.Dataset("myoutputdataset")
    output_ds.write_with_schema(my_dataframe)
    

## Going further

The above is only the very first example of reading and writing Dataiku datasets through the API.

The API for datasets has much more capabilities:

  * Fine-grained control over the schema

  * Chunked reading and writing, to read dataframes by blocks for large datasets

  * Streaming API for reading and writing datasets row-by-row

  * Fast-path access to certain storage types




More details about the whole dataset API can be found in the Developer Guide, at [Datasets](<https://developer.dataiku.com/latest/concepts-and-examples/datasets/index.html> "\(in Developer Guide\)")

In addition, the Python API cover much more, such as interacting with managed folders, models, … For more details, please see the [Dataiku - Developer Guide](<https://developer.dataiku.com/latest/index.html> "\(in Developer Guide\)")

## Using the streaming API

If the dataset does not fit in memory, it is also possible to stream the rows. This is often more complicated, so we recommend using Pandas for most use cases

### Reading

Dataset object’s:

  * iter_rows method are iterating over the rows of the dataset, represented as dictionary-like objects.

  * iter_tuples method are iterating over the rows of the dataset, represented as tuples. Values are ordered according to the schema of the dataset.



    
    
    import dataiku
    from collections import Counter
    
    cars = dataiku.Dataset("cars")
    
    origin_count = Counter()
    
    # iterate on the dataset. The row object is a dict-like object
    # the dataset is "streamed" and it is not required to fit in RAM.
    for row in cars.iter_rows():
            origin_count[row["origin"]] += 1
    

### Writing

Writing the output dataset is done via a writer object returned by Dataset.get_writer
    
    
    with output.get_writer() as writer:
            for (origin,count) in origin_count.items():
                    writer.write_row_array((origin,count))
    

Note

Don’t forget to close your writer. If you don’t, your data will not get fully written. In some cases (like SQL output datasets), no data will get written at all.

We strongly recommend that you use the `with` keyword in Python to ensure that the writer is closed.

### Writing the output schema

Generally speaking, it is preferable to declare the schema of the output dataset prior to running the Python code. However, it is often impractical to do so, especially when you write data frames with many columns (or columns that change often). In that case, it can be useful for the Python script to actually modify the schema of the dataset.

The Dataset API provides a method to set the schema of the output dataset. When doing that, the schema of the dataset is modified each time the Python recipe is run. This must obviously be used with caution.
    
    
    output.write_schema([
    {
      "name": "origin",
      "type": "string",
    },
    {
      "name": "count",
      "type": "int",
    }
    ])
    

### Going further

To see all details of the Python APIs for interacting with datasets, and other APIs that you can use in recipes, please see [Datasets](<https://developer.dataiku.com/latest/concepts-and-examples/datasets/index.html> "\(in Developer Guide\)")

---

## [code_recipes/r]

# R recipes

R is a language and environment for statistical computing. Data Science Studio provides an advanced integration with this environment, and gives you the ability to write recipes using the R language.

R recipes, like Python recipes, can read and write datasets, whatever their storage backend is. We provide a simple API to read and write them.

## Basic R recipe

  * Create a new R recipe by clicking the « R » button in the Recipes page.

  * Go to the Inputs/Outputs tab

  * Add the input datasets that will be used as source data in your recipes.

  * Select or create the output datasets that will be created by your recipe. For more information, see Creating recipes

  * If needed, fill the partition dependencies. For more information, see [Working with partitions](<../partitions/index.html>)

  * Give a name and save your Recipe.

  * You can now write your R code.




First of all, you will need to load the Dataiku R library.
    
    
    library(dataiku)
    

You will then be able to obtain the dataframe objects corresponding to your inputs.

### Reading a dataset in a dataframe

For example, if your recipe has dataset ‘A’ as input, you can use the method `read.dataset()` to load it into a native R dataframe :
    
    
    # Load the content of dataset A into a native R dataframe
    dataframeA <- read.dataset("A")
    

### Writing a dataframe in a dataset

Once you have used R to manipulate the input dataframe, you generally want to write it into the output dataset.

The Dataiku R API provides the method `write.dataset()` to do so.
    
    
    # Write the R dataframe 'my_dataframe' into the dataset 'output_dataset_name'
    write.dataset(my_dataframe,"output_dataset_name")
    

### Writing the output schema

Generally, you should declare the schema of the output dataset prior to running the R code. However, it is often impractical to do so, especially when you write dataframes with many columns (or columns that change often). In that case, it can be useful for the R script to actually modify the schema of the dataset.

The Dataiku R API provides a method to set the schema of the output dataset. When doing that, the schema of the dataset is modified each time the R recipe is run. This must obviously be used with caution.
    
    
    # Set the schema of ‘my_output_dataset’ to match the columns of the dataframe 'my_dataframe'
    write.dataset_schema(my_dataframe,"my_output_dataset")
    

You can also write the schema and the dataframe at the same time:
    
    
    # Write the schema from the dataframe 'my_dataframe' and write it into 'my_output_dataset'
    write.dataset_with_schema(my_dataframe,"my_output_dataset")
    

For more information, check the [R API documentation](<../R-api/index.html>).

---

## [code_recipes/scala]

# Spark-Scala recipes

Data Science Studio gives you the ability to write Spark recipes using Scala, Spark’s native language. Spark-Scala recipes can read and write datasets, even when their storage backend is not HDFS.

Spark-scala recipes can manipulate datasets by using [SparkSQL’s DataFrames](<http://spark.apache.org/docs/latest/sql-programming-guide.html>).

Reference documentation for the DSS Scala API can be found at: <https://doc.dataiku.com/dss/api/14/scala>

## Prerequisites

Prior to writing Scala recipes, you need to ensure that DSS and Spark are properly configured together. See [Setting up Spark integration](<../spark/installation.html>).

## Creating a Spark-Scala recipe

  * Create a new Spark-Scala recipe, either through a dataset’s Actions menu or in _+Recipe > Hadoop & Spark > Spark-Scala_

  * Add the input Datasets and/or Folders that will be used as source data in your recipes.

  * Select or create the output Datasets and/or Folder that will be filled by your recipe.

  * Click Create recipe.

  * You can now write your Spark code in Scala. A sample code is provided to get you started.




Note

If the Spark-Scala icon is not enabled (greyed out), it can be because:

  * Spark is not installed. See [Setting up Spark integration](<../spark/installation.html>) for more information

  * You don’t have [write access](<../security/permissions.html>) on the project

  * You don’t have the proper [user profile](<../security/user-profiles.html>). Your administrator needs to grant you an appropriate user profile




## Basic Spark-Scala recipe

First of all, you will need to load the Dataiku API and entry points:
    
    
    import com.dataiku.dss.spark._
    import org.apache.spark.SparkContext
    import org.apache.spark.sql.SQLContext
    import org.apache.spark.sql.functions._
    
    val sparkConf    = DataikuSparkContext.buildSparkConf()
    val sparkContext = new SparkContext(sparkConf)
    val sqlContext   = new SQLContext(sparkContext)
    val dkuContext   = DataikuSparkContext.getContext(sparkContext)
    

You will then need to obtain DataFrames for your input datasets and directory handles for your input folders:
    
    
    val inputDataset1 = dkuContext.getDataFrame(sqlContext, "KeyOfInputDataset")
    val inputFolder1 =  dkuContext.getManagedFolderRoot("IdOfInputFolder")
    

These return a SparkSQL DataFrame and a Java File (pointing to the Folder’s root) respectively. You can then apply your transformations to the DataFrame and do what you need in the Folder.

Finally you can save the transformed DataFrame into the output dataset. By default the `save` method overwrites the dataset schema with that of the DataFrame:
    
    
    dkuContext.save("KeyOfOutputDataset", transformedDataFrame)
    

If you declared the schema of the output dataset prior to running the Scala code, you can use `save(…, writeSchema = false)`. However, it can be impractical to do so, especially if your code generates many columns (or columns that change often).

If you run your recipe on partitioned datasets, the above code will automatically load/save the partitions specified in the recipe parameters. You can forcibly load or save another partition (or load all partitions) of a dataset:
    
    
    getDataFrame(sqlContext, "KeyOfInputDataset", partitions = Some(List("otherPartitionId")))
    getDataFrame(sqlContext, "KeyOfInputDataset", partitions = Some(null)) // whole dataset
    save("KeyOfOutputDataset", dataframe, targetPartition = Some("otherPartitionId"))
    

In the same vein, `save` will use the writing mode (append or overwrite) defined in the recipe’s configuration by default. You can also override this behavior, but please note that some dataset types do not support Append mode (e.g. HDFS):
    
    
    save("KeyOfOutputDataset", dataframe, writeMode = Some(WriteMode.Append))

---

## [code_recipes/shell]

# Shell recipes

In order to automate certain operations, DSS provides a “Shell” recipe which executes a script in the shell.

## Parameters to the script

No parameter to the script can be passed on the command line, but DSS sets up a handful of environment variables prior to running the script:

  * Usual flow variables : input and output partitioning info [Partitioning variables substitutions](<../partitions/variables.html>)

  * for each input and output dataset : identifier, and when relevant, filesystem path or jdbc url. Variables named `DKU_INPUT...` and `DKU_OUTPUT...` correspond to the inputs and outputs respectively. The (zero-based) index of the input or output in the list of inputs or outputs to the recipe is passed in the environment variable name. For example, `DKU_INPUT_1_DATASET_ID` will contain the identifier of the second input to the recipe




The list of all variables given by DSS to the script is accessible in the “Variables” tab next to the script pane.

## Piping a dataset in and out

DSS allows for one of the input datasets to be piped in the script, via the standard input. This dataset can be selected in the dropdown over the code pane. The data is sent as tab-separated CSV.

Likewise, DSS allows for the standard output of the script to be piped out into one output dataset, again selected with the dropdown over the code pane. This functionality can be used for example to report information in the script and have this information stored in a dataset in DSS. The data is expected as tab-separated CSV. When “auto-infer schema” is checked, the schema of the piped out dataset will be overwritten with columns inferred from the first line of the script output.

## Executed binary

By default, the script is run on the standard `sh` binary. A different binary can be set on the “Advanced” tab, or using a shebang.

## Examples

  * Simple shell recipe that contains an input dataset. This recipe will run the equivalent of the command `grep -i pattern {input dataset}`
        
        grep -i pattern
        

  * Shell script recipe that uses a variable `date_variable` with the value `2017/01/01` and an input dataset. This will run the equivalent of the command `grep pattern {input dataset} | grep 2017/01/01`.
        
        grep pattern | grep $DKU_CUSTOM_VARIABLES_date_variable
        

Note that available variables can be found in the lefthand panel beside the recipe.

  * Shell script recipe that executes an external command:
        
        sh /home/dataiku/shell-script.sh

---

## [code_recipes/sparkr]

# Spark / R recipes

DSS lets you write recipes using Spark in R, using one of two Spark / R integration APIs:

  * The “SparkR” API, ie. the native API bundled with Spark

  * The “sparklyr” API




As with all Spark integrations in DSS, PySPark recipes can read and write datasets, whatever their storage backends.

Warning

**Tier 2 support** : Support for SparkR and sparklyr is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

Warning

**Limited compatibility** : SparkR and sparklyr cannot be used on Cloudera, nor on Elastic AI / Spark-on-Kubernetes setups

Warning

**Features and security** : sparklyr has concurrency and security limitations

## Creating a Spark / R recipe

  * First make sure that [Spark is enabled](<../spark/installation.html>)

  * Create a SPARKR recipe by clicking the corresponding icon

  * Add the input Datasets and/or Folders that will be used as source data in your recipes.

  * Select or create the output Datasets and/or Folder that will be filled by your recipe.

  * Click Create recipe.

  * You can now write your Spark code in R. A sample code is provided to get you started.




Note

If the SPARKR icon is not enabled (greyed out), it can be because:

  * Spark is not installed. See [Setting up Spark integration](<../spark/installation.html>) for more information

  * You don’t have [write access](<../security/permissions.html>) on the project

  * You don’t have the proper [user profile](<../security/user-profiles.html>). Your administrator needs to grant you an appropriate user profile




## Choosing the API

By default, when you create a new Spark / R recipe, the recipe runs in “SparkR” mode, i.e. the native Spark / R API bundled with Spark. You can also choose to switch to the “sparklyr” API.

The two APIs are incompatible and you must choose the proper mode for the recipe to execute properly (i.e. if the recipe is declared as using the SparkR API, sparklyr-using code will not work).

To switch between the two R APIs, click on the “API” button at the bottom of the recipe editor. Each time you switch the API, your previous code is kept in the recipe but commented away, and a new sample code is loaded.

## Anatomy of a basic SparkR recipe

Note

This only covers the SparkR native API. See the next section for the sparklyr API.

The SparkR API is very different between Spark 1.X and Spark 2.X - DSS automatically loads the proper code sample for your Spark version. To cover this, DSS provides two packages: `dataiku.spark` (for Spark 1.X) and `dataiku.spark2` (for Spark 2.X)

### Spark 1.X

First of all, you will need to load the Dataiku API and Spark APIs, and create the Spark and SQL contexts
    
    
    library(SparkR)
    library(dataiku)
    library(dataiku.spark)
    
    # Create the Spark context
    sc <- sparkR.init()
    sqlContext <- sparkRSQL.init(sc)
    

You will then need to obtain DataFrames for your input datasets
    
    
    df <- dkuSparkReadDataset(sqlContext, "input_dataset_name")
    

These return a SparkSQL DataFrame. You can then apply your transformations to the DataFrame.

Finally you can save the transformed DataFrame into the output dataset. By default this method overwrites the dataset schema with that of the DataFrame:
    
    
    dkuSparkWriteDataset(df, "output_dataset_name")
    

If you run your recipe on partitioned datasets, the above code will automatically load/save the partitions specified in the recipe parameters.

### Spark 2.X

First of all, you will need to load the Dataiku API and Spark APIs, and create the Spark session
    
    
    library(SparkR)
    library(dataiku)
    library(dataiku.spark2)
    
    sc <- sparkR.session()
    

You will then need to obtain DataFrames for your input datasets
    
    
    df <- dkuSparkReadDataset("input_dataset_name")
    

These return a SparkSQL DataFrame. You can then apply your transformations to the DataFrame.

Finally you can save the transformed DataFrame into the output dataset. By default this method overwrites the dataset schema with that of the DataFrame:
    
    
    dkuSparkWriteDataset(df, "output_dataset_name")
    

If you run your recipe on partitioned datasets, the above code will automatically load/save the partitions specified in the recipe parameters.

## Anatomy of a basic Sparklyr recipe

Note

This only covers the Sparklyr API. See the previous section for the native SparkR API.

First of all, you will need to load the Dataiku API and sparklyr APIs, and create the sparklyr connection.
    
    
    library(sparklyr)
    library(dplyr)
    library(dataiku.sparklyr)
    
    sc <- dku_spark_connect()
    

Warning

Unlike other Spark APIs, the sparklyr requires an explicit “spark.master” configuration parameter. It cannot inherit “spark.master” from the default spark environment.

You will need either to:

>   * Have a “spark.master” in your [Spark configuration](<../spark/configuration.html>)
> 
>   * Pass `additional_config = list("spark.master" = "your-master-declaration")` to the `dku_spark_connect` function
> 
> 


You will then need to obtain DataFrames for your input datasets
    
    
    df <- spark_read_dku_dataset(sc, "input_dataset_name", "input_dataset_table_name")
    

Since sparklyr is based on dplyr, it mostly deals with SQL and requires a temporary table name for the dataset.

This returns a sparkly DataFrame, compatible with the dplyr APIs. You can then apply your transformations to the DataFrame.

Finally you can save the transformed DataFrame into the output dataset. By default this method overwrites the dataset schema with that of the DataFrame:
    
    
    spark_write_dku_dataset(df, "output_dataset_name")
    

If you run your recipe on partitioned datasets, the above code will automatically load/save the partitions specified in the recipe parameters.

---

## [code_recipes/sparksql]

# SparkSQL recipes

DSS lets you write recipes using SparkSQL. You simply need to write a SparkSQL query, which will be used to populate an output dataset.

As with all Spark integrations in DSS, SparkSQL recipes can read and write datasets, whatever their storage backends.

## Creating a SparkSQL recipe

  * First make sure that [Spark is enabled](<../spark/installation.html>)

  * Create a SparkSQL recipe by clicking the corresponding icon

  * Add the input Datasets that will be used as source data in your recipes.

  * Select or create the output dataset

  * Click Create recipe.

  * You can now write your SparkSQL code




Note

If the SparkSQL icon is not enabled (greyed out), it can be because:

  * Spark is not installed. See [Setting up Spark integration](<../spark/installation.html>) for more information

  * You don’t have [write access](<../security/permissions.html>) on the project




A SparkSQL recipe is simply a SELECT query based on the input datasets. Each input dataset is available as a SparkSQL table with the same name as the dataset (no database).

When you Validate your SparkSQL recipe, DSS verifies the syntax and computes the output schema of the output dataset. You get a prompt to update the schema.

Note

The first time you validate a SparkSQL recipe after DSS startup, validation can take up to one minute. Subsequent validations are faster.

## Using the global metastore

Alternatively to the default mode, where each input dataset is exposed as a table with the same name in the default database, you can choose to use the global Hive metastore as source of definitions for your tables.

Using the global metastore can be configured in the Advanced tab of the recipe.

In global metastore mode, your SparkSQL recipe does not need to declare its input datasets. It can actually run with no input dataset.

In global metastore mode, validation is disabled: it is not possible to validate your code anymore. The schema of your output dataset cannot be inferred prior to running, and cannot be propagated across the Flow without running the recipe. However, output schema will still be automatically inferred after running the recipe. This behavior can be disabled in the Advanced tab.

---

## [code_recipes/sql]

# SQL recipes

For introduction information about SQL datasets, please see [Other SQL databases](<../connecting/sql/index.html>)

DSS allows you to build datasets by executing SQL statements. Two variants are provided :

>   * The “SQL query” recipe
> 
>   * The “SQL script” recipe
> 
> 


Note

The SQL query recipe is the simplest recipe. Its usage should generally be preferred.

| SQL “query” recipe | SQL “script” recipe  
---|---|---  
Purpose | The SQL query should generally be preferred. It allows you to focus on writing your query, while leaving plumbing work to DSS. | The “SQL script” recipe should be used in the few cases where DSS cannot rewrite your query from a main SELECT statement. Two prominent examples are, the CTE (“WITH”) construct and data types not handled by DSS directly (like Geometry datatypes).  
Structure | At its core, a SQL query recipe is a SELECT statement. DSS reads the results from this SELECT statement and handles the task of writing the data to the output. The query can also include other statements that are executed before and after the main SELECT. (see below) | A SQL script recipe is a complete SQL script, made of several statements. DSS simply asks the database to execute the statement, and does not rewrite it.  
In / Out | 

  * Takes as input one or several SQL datasets and a single output dataset.
  * The output of the recipe may be stored anywhere. If the output is in the same connection as all the inputs, then the execution is done fully in the database (no data movement).

| 

  * Takes as input one or several SQL datasets
  * Takes as output one or several SQL datasets
  * The outputs can only be in the database
  * Always executes fully in the database

  
Features | 

  * DSS automatically manages CREATE/ DROP statements
  * You simply write a SELECT and DSS handles insertion in the target table
  * The schema of the output dataset is automatically inferred from the columns returned by the query
  * Automatic code validation is available (without executing the query)

| 

  * You must manage CREATE / DROP statements yourself
  * You must write the INSERT yourself
  * The schema of the output dataset(s) are automatically inferred from the tables created by your script
  * No code validation, you must execute the script

  
Limitations | 

  * DSS needs to rewrite your query. Certain statements, notably CTE (“WITH”) are not always supported, depending on the database
  * The types returned must be handled by DSS, which is not the case of certain Geometry datatypes
  * DSS has partial support for multiple statements handling. Manual overrides are available (see below)

| 

  * DSS has partial support for multiple statements handling. Manual overrides are available (see below)

  
  
## SQL query recipe

To write a SQL query recipe :

  * Create the recipe, either from the “New recipe” menu, or using the Actions menu of a dataset.

  * Select the input dataset(s). All input datasets must be SQL table datasets (either external or managed), and they generally must all be in the same database connection (if not, see Using multiple connections).

  * Select or create the output dataset.

  * Save and start writing your SQL query. Your query must consist of a top-level SELECT statement (plus optional other statements, see below)




Note

You cannot write a SQL recipe based on a “SQL query” dataset. Only “SQL table” datasets are supported.

### Testing and schema handling

At any point, you can click the Validate button. This does the following :

  * Check that the query is valid (syntactically and grammatically)

  * Fetch the names and types of columns created by the query

  * Compare them to the schema of the output dataset.




If the schemas don’t match (which will always be the case when you validate for the first time), DSS will explain the incompatibilities and propose to automatically adjust the output dataset schema. You also get details if there is a discrepancy.

If you overwrite the output schema while the output already contains data, it is strongly recommended to drop the existing data (and, if the output is SQL, drop the existing table). Not dropping the data would make the pre-existing data (and/or table) inconsistent with the schema of the output dataset as recorded by DSS, leading to various issues.

Note

The Validate button does not execute the query, it only asks the database to parse it. As such, executions of the validation step are always cheap, whatever the complexity of the query and size of the database.

### Creating tables

In a SQL query recipe, DSS automatically creates the output tables, and automatically handles clearing them or dropping them before running the recipe. You do not have anything to handle manually.

### Previewing results

Near the Validate button is a “Display first rows” button. Clicking it executes the query and displays the first rows. If the query is complex, this test can be costly.

You might also want to use a [SQL notebook](<../notebooks/sql-notebook.html>) to work on your query.

### Execution plan

Near the Validate button is a “Execution plan” button. Clicking it asks the database to compute the execution plan and displays it. This is useful to evaluate whether your recipe works as expected.

### Execution method

When the output dataset is a SQL table and is in the same connection as the input datasets, DSS will execute the query fully in the target database. DSS automatically rewrites your SELECT query to a “INSERT INTO … SELECT”.

In other cases, DSS will stream the SELECT results from the source database to the DSS server and write them back in the target.

### Using multiple connections

By default, in a SQL query recipe, all the inputs must be in the same database connection and, if needed, the output can be in another one (in this case the results are streamed through DSS).

You can explicitly enable an option to support inputs in multiple connections but this will only work if all the inputs can be accessed from the main SQL connection. To do so, go to the Advanced settings of the recipe, check the Allow SQL across connections option and pick the connection where the query will be executed.

The same option can be used to execute the query in the output connection, so that the results are not streamed through DSS but directly in-database.

Note

When using this option, you are responsible for making sure that all the inputs can be accessed from the selected connection.

In your query, you may need to use fully qualified names with explicit catalog and schema names, e.g. when using connections with different default schemas, or for cross-database setups.

### Multiple statements handling

In a SQL query recipe, the “core” of your code is a SELECT statement that DSS uses to stream the results (or insert them into the target table). Access to this SELECT statement is also used by DSS to compute the schema of the output dataset.

However, you can also write statements before and after the main SELECT.

Use cases for this include:

  * Pre statements that create temporary tables, used by the main SELECT

  * Pre statements creates indexes, post statements drop them

  * Pre statements define a temporary stored procedure




Since DSS needs to isolate the main SELECT statement to fetch the results from it, DSS splits your code in multiple statements, and considers the last SELECT statement found in your code as the “main” SELECT.

DSS splits statement with a logic that recognizes most semantic constructs. It supports comments, various kinds of quoting, …

However, DSS does not have full SQL parsing capability (which would be specific to each kind of database). Some constructs will confuse the splitter. For example, definition of stored procedures, if not quoted, will generally be improperly split. To work around this, you can take control over the splitting by inserting `-- DKU_END_STATEMENT` between each statement. If your code contains this `-- DKU_END_STATEMENT` constructs, then the DSS automatic splitter will be disabled.

For example, the following code would be improperly split by DSS, since it does not recognize that it’s in a stored procedure.
    
    
    CREATE PROCEDURE myproc1 (IN a int)
    BEGIN
        IF a > 42;
          INSERT INTO mytable values (a);
        END IF;
    END;
    
    CALL myproc1(17);
    SELECT * from mytable;
    

Instead, write:
    
    
    CREATE PROCEDURE myproc1 (IN a int)
    BEGIN
        IF a > 42;
          INSERT INTO mytable values (a);
        END IF;
    END;
    
    -- DKU_END_STATEMENT
    
    CALL myproc1(17);
    
    -- DKU_END_STATEMENT
    
    SELECT * from mytable;
    

### Limitations of the SQL query recipe

On a SQL query recipe, DSS needs to rewrite the query to transform a SELECT into an INSERT. This is required so that DSS can still read the schema of your query.

The DSS logic to rewrite query supports a variety of SQL constructs, including subqueries and UNION queries.

However, some advanced SQL constructs require a level of parsing that DSS does not have, and cannot be properly rewritten as INSERT. In that case, you will see parsing errors when executing your SQL query recipe.

A prominent of this is the “Common Table Expression” (CTE) construct, ie. the “WITH” statement:
    
    
    WITH s1 AS
      (select col, count(*) as cnt from A group by col)
    SELECT B.*, s1.cnt
      from B
      inner join s1
        on s1.col = B.col;
    

DSS is not able to properly insert the INSERT at the right location in this kind of queries. We suggest that you either:

  * Rewrite the query not to use a CTE (but this might prove impossible if you use the recursive capabilities of CTEs)

  * Use a SQL script recipe as detailed below.




## SQL Script recipe

To write a SQL script recipe:

  * Create the recipe, either from the “New recipe” menu, or using the Actions menu of a dataset.

  * Select the input dataset(s). All input datasets must be SQL table datasets (either external or managed), and must all be in the same database connection.

  * Select or create the output dataset(s). All output datasets must be SQL table datasets and they generally must all be in the same database connection as the input datasets (if not, see Using multiple connections)

  * Save and start writing your SQL script. The script must perform the insertions in the output tables. It may also handle creating and dropping the output tables.




In a SQL script recipe, DSS can not perform the same level of query analysis as in a SQL query recipe. Therefore, there is no “display first rows” button and the “validate” button only checks the validity of the configuration.

Only running the recipe will actually execute the SQL script.

Recipes in DSS should generally be idempotent (i.e., running them several times should not impact the results). Therefore, you should always have a TRUNCATE or DELETE statement in your SQL script.

Note

The previous statement does not apply exactly this way for partitioned SQL recipes. See [Partitioned SQL recipes](<../partitions/sql_recipes.html>) for more details.

### Use cases for SQL scripts

The main use cases for using a SQL script are:

  * When you manipulate a data type which is not natively handled by DSS. For instance, the PostGIS geometry types. Using SQL query, DSS would write as “varchar” the output columns, losing the ability to perform geo manipulation.

  * The Common Table Expression (CTE), aka the “WITH” statement, is generally not properly handled in a SQL query recipe.

  * When you need multiple outputs in a single SQL recipe.

  * When you need UPDATE or MERGE statements rather than INSERT.




Note

If you need to use stored procedures or temporary tables, the SQL query recipe generally fulfills your need since you can use multiple statements in a SQL query recipe.

### Managing schema or creating tables

In a SQL script recipe, DSS cannot detect the output schema of the output datasets. Detecting the schema is done at the end of the recipe: DSS asks the database for the metadata from the tables that your script created and then fills in the schema of the dataset.

This automatic filling of the schema from the table can be disabled in the Advanced settings of the SQL script recipe. In that case, after running the script, the schema of the dataset will be empty, while the table will have a non-empty schema. When you go to the explore of the output dataset(s), DSS will emit an error because the schema of the dataset does not match the table. To fix this, go to the settings of the output dataset(s), and click “Reload schema from table”. DSS fills the schema of the dataset, which is now consistent.

Another possible way is to start by writing manually the schema before running the SQL script. However, manually writing the schema for a non trivial table is a very cumbersome task.

#### Modification of the schema

Since the SQL script recipe cannot detect the schema without running, if you modify the code of a SQL script recipe to generate a differently-shaped table, don’t forget that you actually need to run the SQL script recipe so that the new schema of the dataset becomes effective and can be used in a further Flow step.

This behavior is similar to the behavior of Python and R recipes, but different from the behavior of SQL query recipe where a simple Validate can update the schema, without the need to actually run the recipe.

### Using multiple connections

By default, in a SQL script recipe, all the inputs and outputs must be in the same database connection.

You can explicitly enable an option to support datasets in multiple connections but this will only work if all the inputs and outputs can be accessed from the main SQL connection. To do so, go to the Advanced settings of the recipe, check the Allow SQL across connections option and pick the connection where the query will be executed.

Note

When using this option, you are responsible for making sure that all the inputs and outputs can be accessed from the selected connection.

In your query, you may need to use fully qualified names with explicit catalog and schema names, e.g. when using connections with different default schemas, or for cross-database setups.

### Multiple statements handling

See the paragraph about multiple statements handling in the SQL query recipe. Same rules apply to SQL script recipe.

### PostgreSQL-specific note

By default, SQL script recipes on PostgreSQL are run using the psql client tool. Using psql has the main advantage that the common RAISE NOTICE statements used for progress tracking in very long-running queries will be displayed in the log of the job as soon as they happen. However, this needs psql to be installed.

You can either:

  * Tell DSS not to use psql for a given SQL script recipe (go to the Advanced tab of the recipe editor)

  * Ensure that psql is installed and in your PATH.




Beware, on some Linux distributions or on some macOS package managers, installing the postgresql package does not place psql in PATH, but instead place it in a non-standard location, or with a non-standard name. You will need to ensure that a binary called psql is in your PATH, either by modifying the PATH of DSS or by adding wrapper scripts.

## AI SQL Generation

Dataiku includes an AI Assistant to help users write SQL queries. Please see [SQL Assistant](<../ai-assistants/sql-assistant.html>)

---

## [code_recipes/variables_expansion]

# Variables expansion in code recipes

Code recipes can use the two kinds of variables expansion in DSS:

  * Expansion of user-defined variables. See [Custom variables expansion](<../variables/index.html>)

  * Expansion of “Flow” variables (ie, variables that are specific to this specific recipe)




Flow variables are mostly used for partitioning-related stuff. See [Partitioning variables substitutions](<../partitions/variables.html>) for more information.

## Summary of expansion syntax

### SQL

Both Flow and custom variables are replaced in your code using the ${VARIABLE_NAME} syntax. For example, if you have the following code:
    
    
    SELECT * from mytable WHERE condition='${DKU_DST_ctry}';
    

with a variable DKU_DST_ctry which has value France, the following query will actually be executed:
    
    
    SELECT * from mytable WHERE condition='France';
    

### Hive

Both Flow and custom variables are replaced in your code using the ${hiveconf:VARIABLE_NAME} syntax. For example, if you have the following code:
    
    
    SELECT * from mytable WHERE condition='${hiveconf:DKU_DST_date}';
    

with a variable DKU_DST_date which has value 2013-12-21, the following query will actually be executed:
    
    
    SELECT * from mytable WHERE condition='2013-12-21';
    

### Python

Flow variables are available in a python dictionary called dku_flow_variables in the dataiku module. Example:
    
    
    import dataiku
    print("I am working for year %s" % (dataiku.dku_flow_variables["DKU_DST_YEAR"]))
    

Custom variables are available in a python dictionary retrieved by the `dataiku.get_custom_variables()` function. Example:
    
    
    import dataiku
    print("I am excluding %s" % (dataiku.get_custom_variables()["logs.preprocessing.excluded_ip"]))
    

### R

Flow variables are retrieved using the `dkuFlowVariable(variableName)` function
    
    
    library(dataiku)
    dkuFlowVariable("DKU_DST_ctry")
    

Custom variables are retrieved using the `dkuCustomVariable(name)` function.
    
    
    library(dataiku)
    dkuCustomVariable("logs.preprocessing_excluded_ip")