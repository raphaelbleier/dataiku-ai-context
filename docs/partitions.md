# Dataiku Docs — partitions

## [partitions/dependencies]

# Specifying partition dependencies

One of the major features of partitioned datasets is the ability to define partition-level dependencies in recipes. For more information, please refer to the [DSS concepts](<../concepts/index.html>) page.

For a given recipe, partition dependencies allow you to compute which partitions of the input datasets are required to compute the requested partition of the output datasets.

Partition dependencies are specified per dimension: for each dimension of each input dataset, a _dependency function_ is used to compute which dimension values are required.

## Dependency functions

Dependency functions can be “relative” or “absolute”.

  * “relative” functions return the _input_ values based on the _output_ values

  * “absolute” functions return the _input_ values without depending on the _output_ values




“Absolute” dependencies are less common and typically used when the output dataset is not partitioned, so “relative” functions are not applicable.

Function | Type | Constraints | Description  
---|---|---|---  
Equals | Relative | Input and output dimensions must be of the same type (and same period for time-based). | Use the same value  
Time range | Relative (time) | Input dimension must be time-based. If there is an output partition, it must also be time-based. There are no constraints on the time levels. | Yields all time periods in a time range relative to the output. More information about this function is available below.  
Since beginning of week | Relative (time) | Input and output dimensions must be time-based.

  * Output must be DAY level
  * Input must be HOUR or DAY level

| Yields all time periods (days or hours) corresponding to days between the beginning of the week defined by the output and the output date. Stops at the output date.  
Explicit values | Absolute |  | Explicitly lists some values. Note: You can use the partition spec syntax to define ranges.  
Latest available | Absolute |  | Lists the partitions of the input dataset available when the recipe is run and selects the “latest” one. For non-time-based dimensions, “latest” is defined as “last by alphabetical ordering”.  
All available | Absolute |  | Lists the partitions of the input dataset available when the recipe is run and selects them all.  
  
## Details about the “Time Range” function

The “time range” function can be used both as a “relative” or “absolute” function.

Time range generates a list of days or hours between a “FROM” date and a “TO” date.

The “TO” date is expressed relative to:

  * The output partition date if the output dataset is partitioned

  * “NOW” if the output dataset is not partitioned




The “FROM” date can be expressed either as:

  * A time span relative to
    
    * The output partition date if the output dataset is partitioned

    * “NOW” if the output dataset is not partitioned

  * An absolute date




### Examples

  * From “2020-02-03” to “3 days before output date”

  * From “7 days before output date” to “1 day before output date”

  * From “2 months before output date” to “output date”




### Available granularities

The granularity of the dates is limited by the granularity of the input dimension.

For example, if the input dimension is at “DAY” level, it is possible to specify a dependency as a number of days before, as a number of months before, but not as a number of hours. (It would not be possible to generate a list of partitions with enough precision to actually enforce this constraint)

### Interpreting time spans

  * For the “FROM” date and the “TO” date, the time span is inclusive

  * If a dependency would generate dates after “NOW” (the current date), they are ignored




Examples:

  * Day-level to Day-level partitioning: “3 days” to “1 days” will include 3 input values

  * Day-level to Day-level partitioning: “1 month” to “1 days” will go from the beginning of the previous month to the day before (inclusive)

  * Day-level to Day-level partitioning: “1 month” to “0” will go from the beginning of the previous month to the output day (inclusive)

  * Day-level to Month-level partitioning: “0 month” to “0” will include the whole output month

  * Day-level to Not partitioned: “1 month” to “0” will include the previous month and the current month up to the current day




## Note about “available” dependencies

The “all available” and “latest available” dependency functions are quite special: they can only return partitions that _already_ exist.

Therefore, it is not possible to generate new partitions using these dependencies function.

Consider the following example:

The “logs” and “log2” datasets are partitioned by DAY and we want to compute with SQL a historical report that uses the whole history. A first way that comes to mind is to use a “All available” dependency between “log2” and “report”.

By doing this, however, if new partitions of “logs” become available and you ask to rebuild “report”:

  * The “all available” dependency will select all partitions of “log2” that already exist

  * Dependencies engine will check whether they need recomputation

  * The “new” partitions of “log2” corresponding to the “new” days present in “logs” will not be handled.




To avoid this, you can either:

  * Build the new partitions of “log2” and then only, build “report”

  * Use a “time range” dependency. As the output dataset is not partitioned, the time range will be interpreted relative to “NOW”. You setup your dependency to go from “the origin of time for this project” to “0” (ie, to the current day).




## Custom partition dependencies

For advanced use cases, you can write your own dependency functions in Python.

Example use cases:

  * One of the input datasets is a referential that gets updated from time to time. The recipe depends on a specific version of the referential, which must be computed

  * Sometimes, a time-based dataset is not “complete”. For example, a dataset might be produced on the 1st and 15th of each month, and you want to depend on the “proper” one.




You need to write a single Python function:
    
    
    def get_dependencies(target_partition_id):
        return [partition1, partition2]
    

The function must return the list of [Partition identifiers](<identifiers.html>) required to compute `target_partition_id` of the output dataset.

The following image illustrates a simple example where we always return “the previous day” and “3 days before” as dependency.

Note

Click the “Test” button to test your dependency function on a “randomly” selected target partition

---

## [partitions/fs_datasets]

# Partitioning files-based datasets

All datasets based on files can be partitioned. This includes the following kinds of datasets:

  * Filesystem

  * HDFS

  * Amazon S3

  * Azure Blob Storage

  * Google Cloud Storage

  * Network




On files-based datasets, partitioning is defined by the _layout of the files on disk_.

Warning

Partitioning a files-based dataset cannot be defined by the content of a column within this dataset

For example, if a filesystem is organized this way:

  * `/folder/2020/02/03/file0.csv`

  * `/folder/2020/02/03/file1.csv`

  * `/folder/2020/02/04/file0.csv`

  * `/folder/2020/02/04/file1.csv`




This folder can be partitioned at the day level, with one folder per partition.

Files-based partitioning is defined by a matching pattern that maps each file to a given partition identifier.

For example, the previous example would be represented by the pattern `/%Y/%M/%D/.*`

## Defining a partitioned dataset

You first need to have defined the connection and format params. Once this is OK and you can see your data, go to the Partitioning tab, and click “Activate partitioning”

Dataiku DSS automatically tries to recognize the pattern. If it succeeds, a partitioning pattern will be suggested.

To manually define partitioning, first define a time dimension and/or discrete dimensions.

  * The time dimension period can be year, month, day or hour.

  * You can add multiple discrete value dimensions, each dimension corresponding to a subdirectory in your file structure.




Then, define the pattern.

  * The time dimension is referred in the pattern by the `%Y` (year, on 4 digits), `%M` (month, on 2 digits), `%D` (day, on 2 digits) and `%H` (hour, on 2 digits) specifiers. The pattern for the time dimension must represent a valid time hierarchy for the chosen period. For example, if you choose “Day” as the period for the time dimension, then the pattern must include `%Y`, `%M`, and `%D`.

  * Each discrete value dimension is referred by the `%{dimension_name}` specifier.




The above example defines a partitioning scheme with two dimensions, which would match files:

  * `/2020-02-04/France/file0.csv`

  * `/2020-02-05/Italy/file1.csv`




Note

The initial `'/'` is important, as all paths are anchored to the root of the dataset. The final `.*` is important: it catches all files with the given prefix.

The “List partitions” button inspects the folder and displays which partitions would be generated by the current pattern as well as the files that have not been matched by the pattern (and would then not be part of the dataset).

Note

If 0 partitions are detected, it generally means that the pattern does not match your files.

More information might be available in the backend log file. See [Diagnosing and debugging issues](<../troubleshooting/diagnosing.html>) for more information.

## Partition redispatch

If you are using a filesystem connection and your files do not map directly to partitions, you can still partition your dataset using Partition Redispatch.

The partition redispatch option is available in the Sync recipe (Configuration tab) and in the Prepare recipe (Advanced tab).

For example, if you have a filesystem dataset made of a singular csv file, it cannot be partitioned as is. The redispatch partition feature solves this problem, as it allows you transform a non-partitioned dataset to a partitioned dataset. Each row of the csv file is assigned to a partition dynamically based on columns.

Note

If you activate the redispatch option in the sync recipe, DSS will read and dispatch each row of the dataset depending on its value in the partitioning column, and will build one partition per distinct value in that column.

Beware that with files-based partitioning, the partition column(s) are removed from the schema. Once the partitioning has been performed, the partitioning columns will no longer be accessible in the recipes.

Possible workarounds:

  * Before partitioning: Duplicate the column before partitioning the dataset.

  * After partitioning: Add a column labeling the partition for each row via a prepare recipe. To do so, create a prepare recipe and add an “enrich records with files info” step, and fill in the “Output partition column” field.

---

## [partitions/hive]

# Partitioned Hive recipes

This page deals with the specific case of partitioned datasets in Hive recipes. For general information about Hive recipes, see [Hive recipes](<../code_recipes/hive.html>)

## Short summary

If your Hive recipe is a “simple” one, ie if:

  * You have only one output dataset

  * Your query starts with SELECT




Then you don’t need to do anything special to deal with partitioning: your query will only run over the selected input partitions and will write directly in the requested output partition.

Note

Even though Hive recipes look like SQL recipes, they act on HDFS datasets, which use files-based partitioning, while SQL recipes can only use column-based partitioning.

## What data is read from inputs ?

Each Hive recipe runs in a separate Hive environment (called a metastore). In this isolated environment, only the datasets that you declared as inputs exist as tables and only the partitions that are needed by the dependencies system are available. Therefore, you do not need to write any WHERE clause to restrict the selected partitions as you would in an SQL recipe. Only the required partitions will be included in the query.

Note

For the query `SELECT * FROM foo`, Hive includes the partitioning column in the result, even if it is not physically written on HDFS. If you don’t want it, name all columns in the request: `SELECT a,b,c FROM foo` (click the column names in the left side panel to do so quickly).

## How to write data ?

If you have only one output dataset and your query starts with a SELECT, Dataiku DSS automatically transforms it into a an INSERT OVERWRITE statement into the relevant partition.

If you want to take control over your insert (see [Hive recipes](<../code_recipes/hive.html>)) and the output datasets are partitioned, then you must explicitly write the proper INSERT OVERWRITE statement in the output partition.

The Hive syntax for writing in a partition is:
    
    
    INSERT OVERWRITE TABLE output_dataset_name
            PARTITION (dimension='value', dimension2='value2')
            SELECT your_select_query
    

The values in the PARTITION clause must be static, i.e., they cannot be computed using the query itself. Each time the recipe is run, the values must be the ones of the partition being computed of this dataset. To automatically set the proper values depending on which partition is being built, you can use [Partitioning variables substitutions](<variables.html>)

For example (supposing that the ‘customers’ dataset is partitioned by ‘date’ and ‘country’):
    
    
    INSERT OVERWRITE TABLE customers
            PARTITION (date='$DKU_DST_date', country='$DKU_DST_country')
            SELECT your_select_query

---

## [partitions/identifiers]

# Partition identifiers

When dealing with partitioned datasets, you need to identify or refer to partitions. Within a dataset, a partition identifier uniquely identifies a partition.

The identifier of a partition is made by concatenating the dimension values, separated by | (pipe)

## Time dimension identifiers

The format of a time dimension identifier depends on the time dimension granularity

Period | Format | Example  
---|---|---  
Year | `YYYY` | `2020`  
Month | `YYYY-MM` | `2020-01`  
Day | `YYYY-MM-DD` | `2020-01-17`  
Hour | `YYYY-MM-DD-HH` | `2020-01-17-13`  
  
Some special keywords are also available:

  * CURRENT_HOUR

  * CURRENT_DAY

  * CURRENT_MONTH

  * CURRENT_YEAR

  * PREVIOUS_HOUR

  * PREVIOUS_DAY

  * PREVIOUS_MONTH

  * PREVIOUS_YEAR




## Discrete dimension identifiers

The identifier of a discrete dimension value is the value itself. As such, discrete dimensions should only contain letters and numbers.

## Multiple dimensions

For example, if you have a time dimension named “date” with a “DAY” granularity and a discrete dimension named “country”, then you could have partitions like:

  * `2020-01-01|France`

  * `2020-01-01|Italy`

  * `2020-01-02|France`

  * `2020-01-02|Italy`




## Ranges specifications

In various locations in DSS, you can use a “partition range specification” syntax to refer to a set of partitions or values of a dimension.

For example:

>   * In “Exact values” dependency function
> 
>   * When building datasets
> 
>   * When creating scheduled jobs
> 
>   * …
> 
> 


The generic syntax is:

  * `PARTITION_SPEC = DIMENSION_SPEC|DIMENSION_SPEC|....`

  * `DIMENSION_SPEC =`

>     * `DATE` # Single Date (Time)
> 
>     * `DATE/DATE` # Date Range (Time)
> 
>     * `Any` # Actual Value (ExactValue)
> 
>     * `Any/Any/Any/...` # Several values (ExactValue)




Examples:

  * `2020-01-25/2020-01-28`: Single DAY dimension, select 3 days

  * `2020-01-25-14/2020-01-28-15`: Single HOUR dimension, select 73 hours

  * `2020-02/2020-03|FR/IT`: One MONTH dimension and one discrete dimension, select a total of 4 partitions:

>     * `2020-02|FR`
> 
>     * `2020-02|IT`
> 
>     * `2020-03|FR`
> 
>     * `2020-03|IT`

---

## [partitions/index]

# Working with partitions

Partitioning refers to the splitting of a dataset along meaningful _dimensions_. Each partition contains a subset of the dataset that can be built independently.

For a general introduction to partitioning, see [DSS concepts](<../concepts/index.html>)

## The two partitioning models

There are two models for partitioning datasets: files-based partitioning and column-based partitioning.

### Files-based partitioning

This partitioning method is used for all datasets based on a filesystem hierarchy. This includes Filesystem, HDFS, Amazon S3, Azure Blob Storage, Google Cloud Storage and Network datasets.

In this method, partitioning is defined by the layout of the files on disk., so the data in the files is NOT used to decide which records belong to which partition.

For more information, see [Partitioning files-based datasets](<fs_datasets.html>)

### Column-based partitioning

This partitioning method is used for datasets based on structured storage engines:

  * All SQL databases

  * NoSQL databases: MongoDB, Cassandra and Elasticsearch




In this method, the partitioning is derived from information (one or several columns) which is part of the data.

A very important point is that in this method, the schema of the dataset does contain the partitioning data.

---

## [partitions/models]

# Partitioned Models

You can train partitioned prediction models from partitioned datasets.

See [Partitioned Models](<../machine-learning/partitioned.html>).

---

## [partitions/recipes]

# Recipes for partitioned datasets

When a recipe is used to compute a partitioned dataset and/or to compute from a partitioned dataset, the recipe only processes the involved partitions and does not access the full datasets.

If a recipe computes several datasets:

  * All output datasets must have the same partitioning schema

  * The same partition will be computed for all target datasets.




A single invocation of a recipe will therefore:

  * Read one or several partitions of the input datasets

  * Write exactly one partition for each output dataset




Dataiku DSS automatically computes the partitions of the input datasets depending on the requested output partitions using the partition dependencies mechanism. For more information, please refer to [DSS concepts](<../concepts/index.html>) and [Specifying partition dependencies](<dependencies.html>)

See [Partitioned Hive recipes](<hive.html>) and [Partitioned SQL recipes](<sql_recipes.html>) about how to read only the input partitions and write to the output partition.

---

## [partitions/sql_datasets]

# Partitioned SQL datasets

## Partitioning SQL table datasets

Datasets based on SQL tables support partitioning based on the values of specified columns: the partitioning columns must be part of the schema of the table.

### External SQL table datasets

For an external SQL table dataset, you must configure:

  * Which columns provides the partitioning values. For example “country” or “day”.

  * The type and parameters of each partitioning dimension. For example:
    
    * Discrete values

    * Time with period DAY




Dataiku DSS can automatically list the available partitions by enumerating the values of the provided columns. In some cases, enumerating the values can be prohibitively costly. This is particularly the case when working on a non-column-oriented database without index on a partitioning column. In that case, you may specify an explicit, comma-separated, list of available partitions. Dataiku DSS will use this list whenever it needs to list the partitions of the dataset. Each element of the list can be a partition identifier or a partition range specification. For more information on partition identifiers, see [Partition identifiers](<identifiers.html>).

If your database engine natively supports partitioning and the external table uses it, Dataiku DSS suggests to use the native partitioning support. Checking this option, will make listing and removing partitions much more efficient. It might also make getting the records of a partition more efficient.

In the dataset edition screen, Dataiku DSS automatically selects an arbitrary partition to preview.

### Managed SQL table datasets

For partitioning, Managed SQL table datasets behave like external SQL table datasets.

Note

In a managed SQL table dataset, you define the schema of the table yourself. Don’t forget that you MUST have the partitioning column in the table schema. If you don’t have it, testing the dataset will fail.

## Partitioning SQL query datasets

SQL query datasets provide additional flexibility when it comes to partitioning (with a more complex setup).

To summarize:

  * The SQL query must use specific patterns to replace the requested values of the partition

  * You must provide a way to list the partitions

  * You must provide a partition identifier that will be used by Dataiku DSS to perform the preview in the dataset screen.




Let’s take an example. If we have the following database schema:
    
    
    event {
        geography_id integer;
        type string;
        user_id integer;
        timestamp integer;
    }
    geography {
        id integer
        continent string,
        country string,
        region string,
        city string
    }
    user {
        id integer;
        sex varchar(1);
    }
    

We want to create a dataset with the following data:

  * event_type

  * user_sex

  * timestamp

  * city




And we want that dataset to be partitioned by day and country. We cannot do that directly using SQL table datasets, and need to use SQL query datasets.

Note

Although this is an example, it should not be considered as a good practice: when doing a data analysis project, you should denormalize the data as soon as possible. Joining three tables to create an analytical dataset is expensive.

We first need to declare our query-based dataset, and to configure the two partitioning dimensions:

  * A discrete values dimension named “country”

  * A time dimension on DAY level named “day”




Then, we can create our query. The query must return the records for a single partition. When Dataiku DSS needs to fetch the records of a partition, it will take the SQL query that we have entered, and replace all _${dimensionName}_ patterns in the query by the value of the dimension for this partition.

So our query will be:
    
    
       SELECT event.type as event_type, user.sex as user_sex, event.timestamp as timestamp, geography.city as geography
        FROM event INNER JOIN geography ON geography.id = event.geography_id INNER JOIN user on user.id = event.user_id
    WHERE geography.country = '${country}' AND DATE_FORMAT(event.timestamp, 'yyyy-MM-dd') = '${day}'
    

In the substitution values, a time partition will be given using the DSS partition identifier syntax (see below).

We then need to provide Dataiku DSS with a way to list available partitions. The preferred way is to provide an SQL query able to list partitions. It should return a result set with one column for each partitioning dimension and one row for each partition.

Here, we could achieve this with:
    
    
    SELECT day, country FROM (
      SELECT DATE_FORMAT(event.timestamp, 'yyyy-MM-dd') as day, geography.country FROM event INNER JOIN geography ON geography.id = event.geography_id
    ) GROUP BY day, country;
    

The subquery + group is required to perform deduplication of multiple records on the same/day country.

In this example, we can see that listing all partitions is a very costly operation as it needs to perform a full scan of the event table. Due to the reformatting that we have to perform to extract the day, we cannot properly use indices.

On a large event database, that cost might be prohibitively high.

In that case, instead of providing an SQL query to list partitions, we can explicitly list the available partitions by entering something like: `2020-01-01/2020-10-01|france,uk,italy,germany` (see [Partition identifiers](<identifiers.html>) for details).

Note that explicitly listing partitions is generally not desirable for “live” datasets, for which new partitions are created each day.

To finish, we need to explicitly give a partition identifier that Dataiku DSS will use for preview. For example 2020-04-06|france

## Writing in partitioned SQL datasets

There are two main ways to write in a partitioned SQL table:

  * Using an SQL recipe or a visual recipe with SQL engine. In that case, see [Partitioned SQL recipes](<sql_recipes.html>).

  * Using a Sync recipe with optimized engine (S3 to Redshift, Azure to SQLServer, GCS to BigQuery, S3 to Snowflake, WASB to Snowflake, TDCH)

  * Using any other kind of recipe.




In the last case, the writes are “controlled” by Dataiku DSS (see [Recipes for partitioned datasets](<recipes.html>) for more details) and the following is automatically made for you:

  * Creating the table if it’s not yet created

  * Checking that the schema of the table is still valid

  * Dropping pre-existing records corresponding to the partition being written (to ensure idempotence)

  * Setting the output partition in all records being inserted




You do not need to make sure that the partitioning column appears in the records being inserted. DSS will always fill it with the value of the partition being written. However, it is mandatory to have the partitioning columns appear in the output schema. (This will automatically be done for you if you create the managed dataset by copying the partitioning from another dataset).

## SQL datasets and time partitioning

When using time-based partitioning on an SQL table, the partitioning columns must NOT be of Date type. Instead, it must be of “string” type and contain values compatible with the partition identifier syntax of Dataiku DSS, that is: 2020-02-28-14 for hour-partitioning 2020-02-28 for day-partitioning 2020-02 for month-partitioning 2020 for year-partitioning

The same is valid for SQL query datasets: the substitution values are given using the partition identifier syntax.

## Native partitioning and number of partitions

Most database engines do not support an arbitrary number of partitions when using their native partitioning support. For example, Vertica only supports 1024 partitions per table. This might make it impossible to keep, for example, a hour-level partitioning in the database.

---

## [partitions/sql_recipes]

# Partitioned SQL recipes

This page deals with the specific case of partitioned datasets in SQL recipes. For general information about SQL recipes, see [SQL recipes](<../code_recipes/sql.html>)

## Reading from partitioned datasets

In SQL recipes (both “query” and “script”), reading partitioned datasets requires that you manually restrict what is being read in your query.

For example, if you have a dataset “inp1” partitioned by “country” (a “discrete values” partitioning dimension), you want to write a query like that:
    
    
    SELECT col1, COUNT(*) AS count FROM inp1
            WHERE country = 'the partition I want to read'
            GROUP BY col1;
    

The partition(s) that you want to read is determined by the partition dependencies system and should not be hard-coded in your recipe. Instead, you should use [Partitioning variables substitutions](<variables.html>). In our previous example, you would actually write your query as:
    
    
    SELECT col1, COUNT(*) AS count FROM inp1
            WHERE country = '$DKU_SRC_country'
            GROUP BY col1;
    

## Writing into partitioned datasets (SQL query, writing to column-based partitioned)

This case applies if:

  * You are using an SQL Query recipe

  * You are writing to an SQL table dataset (or another column-based-partitioning dataset, like Cassandra or MongoDB)




In this case, the partitioning columns _must_ appear in the output data. Note that it must appear in the SQL query at the correct position wrt. the output schema and with the correct name.

For example, reusing our previous example, we are going to write the result of the query to a dataset “out1”, which is partitioned by “country2”.

The schema of out1 looks like:

  * country2

  * col1

  * count




The query could look like:
    
    
    SELECT country as country2, col1, COUNT(*) as count FROM inp1
            WHERE country = '$DKU_SRC_country'
            GROUP BY col1;
    

However, this only works in the case where we have a “equals” dependency, because we are actually writing the country of the _input_ dataset as the country2 of the _output_ dataset.

If we wanted to write in another partition, it would not work. In the more general case, we need to write the following:
    
    
    SELECT '$DKU_DST_country2' as country2, col1, COUNT(*) as count FROM inp1
            WHERE country = '$DKU_SRC_country'
            GROUP BY col1;
    

The DKU_DST variable is replaced by the value of the “country2” dimension for the output dataset. For more information, see [Partitioning variables substitutions](<variables.html>).

## Writing into partitioned datasets (SQL query, writing to file-based partitioned)

This case applies if:

  * You are using an SQL Query recipe.

  * You are NOT writing to an SQL table dataset in the same connection




Remember (as explained in [SQL recipes](<../code_recipes/sql.html>)) that in that specific case, DSS retrieves the rows from the query and writes them in the output dataset. In that case, DSS “controls” how data is written and handles all partitioning issues. (see [Recipes for partitioned datasets](<recipes.html>) for more details).

As you are writing to a files-based partitioned dataset, you _do not need to do anything specific_ in the SQL query about the output partitioning values. DSS will write to the correct folder automatically.

## Writing into partitioned datasets (SQL script)

When you write with an SQL script recipe, you are responsible for:

  * ensuring idempotence (running the script several times produces the same output as running it once)

  * inserting records with the correct partitioning values.




This generally involves:

  * Performing a DELETE query with a restriction on the target partitioning value (or, if you are using native partitioning, using the correct database-specific commands to drop a partition)

  * Making sure that inserted records have their partitioning columns values set to the target partitioning value.




To help you, Dataiku DSS provides you with many variables that you can substitute in your SQL scripts. See [Partitioning variables substitutions](<variables.html>).

---

## [partitions/variables]

# Partitioning variables substitutions

When a recipe involves partitioned datasets, some variables are made available to the code that you write for this recipe, to help you manage partitions.

## Substituting variables

### SQL

Variables are replaced in your code using the $VARIABLE_NAME syntax. For example, if you have the following code:
    
    
    SELECT * from mytable WHERE condition='$DKU_DST_country';
    

with a variable DKU_DST_country which has value France, the following query will actually be executed:
    
    
    SELECT * from mytable WHERE condition='France';
    

### Hive

Variables are replaced in your code using the ${hiveconf:VARIABLE_NAME} syntax. For example, if you have the following code:
    
    
    SELECT * from mytable WHERE condition='${hiveconf:DKU_DST_date}';
    

with a variable DKU_DST_date which has value 2020-12-21, the following query will actually be executed:
    
    
    SELECT * from mytable WHERE condition='2020-12-21';
    

### Python

Since read and write is done through Dataiku DSS, you don’t need to specify the source or destination partitions in your code for that, using “get_dataframe()” will automatically give you only the relevant partitions.

For other purposes than reading/writing dataframes, all variables are available in a dictionary called dku_flow_variables in the dataiku module. Example:
    
    
    import dataiku
    print("I am working for year %s" % (dataiku.dku_flow_variables["DKU_DST_YEAR"]))
    

### R

Flow variables are retrieved using the `dkuFlowVariable(variableName)` function
    
    
    library(dataiku)
    dkuFlowVariable("DKU_DST_country")
    

## Available variables

### Related to the target datasets

Variable name | Available if | Value | Examples  
---|---|---|---  
DKU_DST_dimensionName | For each dimension | Value of the dimension “dimensionName” for the current activity. For time dimensions, given using time partition identifier syntax. | 

  * France
  * 2020-01-22

  
DKU_DST_YEAR | time partitioned | Value of the year (4 digits) for the time dimension. | 2020  
DKU_DST_MONTH | time partitioned (month, day or hour) | Value of the month (2 digits, from) 01 to 12) for the time dimension | 01  
DKU_DST_DAY | time partitioned (day or hour) | Value of the day of month (2 digits, from 01 to 31) for the time dimension | 22  
DKU_DST_DATE | time partitioned (day or hour) | Date for the time dimension, in yyyy-MM-dd format | 2020-01-22  
DKU_DST_HOUR | time partitioned (hour) | Value of the hour of day (2 digits, from) 00 to 23) for the time dimension. | 21  
DKU_DST_YEAR_1DAYAFTER … | the same variable is available | Value of the various date components variables for the day FOLLOWING the dimension value. | 2020-01-23  
DKU_DST_YEAR_1DAYBEFORE | the same variable is available | Value of the various date components for the day PRECEDING the dimension value | 2020-01-21  
… _7DAYSBEFORE … _7DAYSAFTER | Idem | Value of the various date components for the date 7 days PRECEDING or FOLLOWING the dimension value | 2020-01-15  
… _1HOURBEFORE … _1HOURAFTER | Idem | Idem |   
  
### Related to the source datasets

Variable name | Available if | Value | Examples  
---|---|---|---  
DKU_SRC_datasetName_dimensionName | 

  * For each dimension of each dataset
  * There is only one source partition for this dataset

| The value of the dimension dimensionName for input dataset datasetName | 2020-01-23  
DKU_SRC_dimensionName | 

  * There is only one source dataset
  * There is only one source partition for this dataset

| The value of the dimension dimensionName for the single input dataset | 2020-01-23  
DKU_PARTITION_FILTER_datasetName | 

  * the recipe is an SQL recipe

| filter for the partitions used by the recipe |   
DKU_PARTITION_FILTER | 

  * the recipe is an SQL recipe
  * There is only one source dataset

| filter for the partitions used by the recipe |   
DKU_SRC_FIRST_DATE | 

  * There is only one source dataset
  * The dataset is time-partitioned

| smallest partition id |   
DKU_SRC_LAST_DATE | 

  * There is only one source dataset
  * The dataset is time-partitioned

| biggest partition id |   
  
Additionally, if the source dataset has time dimensions, all variables DKU_SRC_datasetName (date/year/month/day/hour), DKU_SRC_datasetName (DATE/YEAR/MONTH/DAY/HOUR)_(timeshift) will be available subject to the same rules as for DKU_DST _

If there is only one input dataset, all DKU_SRC_datasetName_variable variables are also available in the DKU_SRC_variable shortcut.