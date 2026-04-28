# Dataiku Docs — sql

## [sql/datasets]

# SQL datasets

You can interact with SQL databases using:

## External table datasets

SQL table datasets are the simplest form of interaction with SQL databases. To create an external SQL table dataset, you simply need to choose the connection, the table, and you’re all set. The content of the table is now a dataset.

  * Go to Datasets, click New > Your database type

  * Select a connection.

  * Make sure the « Read a database table » radio is selected.

  * Click on “Get tables list”

  * DSS connects to your database and retrieves the available tables.

  * Select your table.

  * Click the “Test table” button.

  * DSS shows a preview of the contents.

  * You can now save your dataset




Warning

You cannot edit the schema of an external SQL table dataset. The names of the columns are provided by the database engine.

On an external dataset, DSS chooses to preferably trust the content of the data.

If you need to edit the names of the columns for further processing, you can for example use a data preparation recipe.

When creating an external MySQL table dataset, upcast the types of the columns with unsigned integer types in the dataset schema, so that DSS’s representation covers the full range of the values in these columns (use ‘smallint’ for ‘tinyint unsigned’, ‘int’ for ‘smallint unsigned’, ‘bigint’ for ‘int unsigned’). As MySQL silently casts unsigned values to signed ones in queries, and DSS treats integer types as signed, it is advised to avoid unsigned integers.

## External query datasets

A SQL dataset can also be defined by a custom query. The results of the query become the rows of the dataset. This allows you to create a virtual dataset, without having to materialize the rows (for example, if the query joins several tables).

A SQL query database is read-only. You cannot write to a SQL query.

Note

Data Science Studio does not automatically test SQL queries, as they can be very expensive. You need to manually click the **Test query** button

## Managed SQL datasets

Managed datasets can be created on SQL databases. Only “table” datasets can be managed (it makes no sense to write on a SQL query dataset).

You can create a managed SQL dataset:

  * by clicking on the **Managed dataset** button in the New Dataset page

  * by creating a new managed dataset as output of a recipe




When you create a managed SQL dataset, you start by selecting the connection in which it gets written. A table name is automatically selected based on the name of the SQL dataset. You can change it. A managed SQL dataset can target either an existing table or a non-existing one.

When you click the **Test** button, Dataiku DSS checks if the table exists in the database:

  * If the table does not exist, then you have the ability to create it. You can choose not to create the table, and any recipe that requires it would automatically create the table.

  * If the table exists, DSS automatically checks its schema. DSS warns you if the schema of the table and the dataset do not match, and suggests these fixes:
    
    * Drop the table (so it will be recreated with the dataset schema)

    * Override the dataset schema with the current schema of the table.




It is good practice to ensure that the settings of the managed datasets are relocatable. See [Making relocatable managed datasets](<../connecting/relocation.html>) for more details.

---

## [sql/index]

# DSS and SQL

DSS can both read and write datasets in SQL databases. Using DSS with SQL, you can:

  * create datasets representing SQL tables (and read and write in them)

  * create datasets representing the results of a SQL query (and read them)

  * write code recipes that create datasets using the results of a SQL query on existing SQL datasets. See [SQL recipes](<../code_recipes/sql.html>) for more information about SQL recipes

  * use the SQL Notebook for interactive querying




In addition, on most supported databases, DSS is able to:

  * execute [Visual recipes](<../other_recipes/index.html>) directly in-database (ie: for a visual recipe from the database to the database, the data never moves out of the database)

  * execute [Charts](<../visualization/index.html>) directly in-database

  * create pipelines




For an overview of which databases are supported by DSS, see [the connecting to SQL reference](<../connecting/sql/index.html>).

---

## [sql/partition]

# Partitioning

Dataiku DSS can provide partitioning support, both on SQL databases that have native partitioning support and on those that do not. Also, all SQL datasets can be partitioned in DSS. See [Partitioned SQL datasets](<../partitions/sql_datasets.html>) for more information.

---

## [sql/pipelines/index]

# SQL pipelines in DSS

## Concept

In DSS, each recipe reads some datasets and writes some datasets. For example:

  * A grouping recipe will read the input dataset from the storage, perform the grouping, and write the grouped dataset to its storage.

  * A SQL recipe will either:

>     * If input and output connections are different, execute the SQL query in the source database, fetch results and write the results in the output database
> 
>     * If input and output connections are the same, transform the SQL query into a “INSERT … SELECT” query so that the data remains in the database




When using a chain of visual and/or code recipes, DSS executes each recipe independently. For example, if you have a grouping recipe followed by a prepare recipe then a join recipe then a grouping recipe, and so forth, each recipe will be executed independently, and the SQL engine will read and write the datasets in each recipe.

**SQL pipelines** are a Dataiku capability that combine several consecutive recipes (each using the same SQL engine) in a DSS workflow. These combined recipes can be either:

  * Visual recipes running on DSS engine

  * SQL query recipes




These combined recipes then run as a single job activity, without writing intermediate datasets

Using a SQL pipeline can strongly boost performance by avoiding unnecessary writes and reads of intermediate datasets. SQL pipelines also allow you to optimize the data storage capacity without having to manually re-factor the Dataiku flow (for example, by reducing the number of datasets).

## Using SQL pipelines

SQL pipelines are not enabled by default in DSS but can be enabled on a per-project basis.

  * Go to the project **Settings**

  * Go to **Pipelines**

  * Select **Enable SQL pipelines**

  * **Save** settings




### Configuring behavior for intermediate datasets

A SQL pipeline covers one or more intermediate datasets that are part of the pipeline. For each of these intermediate datasets, you can configure whether it is _virtualized_ or not.

When a dataset is virtualized, Dataiku will not write it at all while executing the pipeline.

If the dataset is not useful by itself, but is only required as an intermediate step to feed recipes down the Flow, virtualization improves performance by preventing DSS from writing the data of this intermediate dataset when executing the SQL pipeline.

Some intermediate datasets are however useful by themselves. For example, if the dataset is used by charts, enabling virtualization can prevent DSS from creating required charts, as the data needed to create the charts would not be available.

Although writing intermediate datasets reduces the performance gain of using a SQL pipeline, the pipeline still provides the benefit that the datasets do not have to be read again once they’ve been written. There are thus performance benefits to using pipelines even without virtualizing datasets, or only virtualizing some of them.

To enable virtualization for a dataset:

  * Open the dataset and go to the **Settings** tab at the top of the page

  * Go to the **Advanced** tab

  * Check “Virtualizable in build”




You can also enable virtualization for one or more datasets at once by performing these steps:

  * Select one or more datasets in the **Flow**

  * Locate the “Other actions” section in the right panel and select **Allow build virtualization (for pipelines)**




### Configuring behavior for recipes

A SQL pipeline covers multiple recipes, and you can configure the behavior of the pipeline for each recipe.

  * Open the recipe and go to the **Advanced** tab at the top of the page

  * Check the options for “Pipelining”:

>     * “Can this recipe be merged in an existing recipes pipeline?”
> 
>     * “Can this recipe be the target of a recipes pipeline?”




The first setting determines whether a recipe can be concatenated inside an existing SQL pipeline. The second setting determines whether running the recipe can trigger a new SQL pipeline.

### How do SQL pipelines run

When you run a build job, the Dataiku Flow dependencies engine automatically detects if there are SQL pipelines based on the settings of the datasets and recipes. The engine then creates separate job activities for each of them.

The details of the SQL pipelines that have run can be visualized in the job results page. On the left part of the screen, “SQL pipeline (xx activities)” will appear and mention how many recipes or recipe executions were merged together.

## Supported databases

The SQL pipelines feature is supported for databases that are compatible with SQL views. These include:

  * Snowflake

  * Databricks

  * Redshift

  * BigQuery

  * Synapse

  * SQL Server

  * PostgreSQL

  * MySQL

  * Oracle

  * Greenplum

  * Teradata

  * Vertica




## Views management

DSS uses temporary SQL views to represent virtualized datasets in a SQL pipeline.

During the execution of the pipeline, DSS references the view (instead of the the table backing the virtualized dataset) by using the view name. The view name contains these components:

  * [tableName]: name of the table from which the view is derived

  * [partitionID]: ID of the partition corresponding to the view (if working with a [partitioned SQL table dataset](<../../partitions/sql_datasets.html>))

  * [randomString]: randomly-generated 5-character alphanumeric string




Using these components, views are named as follows:

  * prefix: `DSSVIEW_`

  * middle: `[tableName]_[partitionID]`

  * suffix: `_[randomString]`




Because some databases have strict limits on the length of view names, the middle characters in the view name `[tableName]_[partitionID]` may be truncated to ensure that the prefix and suffix fit.

DSS has a process for automatically cleaning up all temporary views at the end of pipelines. In some rare cases, views may however be left behind. DSS contains a macro that attempts to clean up any old view. You can find it alongside the other macros under the name “Drop pipeline views”. You must have full DSS Administrator privileges to run it. If you run into a pipeline execution error that is linked to old views being left behind, you can use the naming convention `DSSVIEW_[tableName]_[partitionID]_[randomString]` to find the views that DSS created, and manually drop them.

## Limitations

  * The SQL datasets must be part of the same database connection

  * The following are not supported:

    * SQL script recipes

    * SQL query recipes with [multiple statements](<../../code_recipes/sql.html#code-recipes-sql-multiple-statements-handling>)

    * TopN visual recipes with a “Remaining rows” output dataset

    * Pivot visual recipes with the “Recompute schema at each run” option enabled

    * Split visual recipes using “Dispatch percentiles of sorted data” or “Full random” mode

    * [Generate features](<../../other_recipes/generate-features.html>) visual recipes

  * In some cases, even if a dataset is configured as virtualizable, DSS may still write it during the execution of the SQL pipeline. This happens when there are some technical constraints on the dataset that prevent the dataset from being virtualized.




While the SQL pipeline feature is supported, you may encounter some edge cases. In that case, note that pipelines can still be disabled on a per-project basis, and Dataiku Support may request that you do so.

---

## [sql/write_and_execute]

# SQL write and execution

## Writing in SQL table datasets

  * You can write to SQL table datasets (external table datasets and managed SQL datasets) but not to external query datasets. See [SQL datasets](<datasets.html>) for more information.




## Executing SQL queries

  * You can write code recipes that create datasets using the results of a SQL query on existing SQL datasets. See [SQL recipes](<../code_recipes/sql.html>) for more information about SQL recipes.

  * You can also use the SQL Notebook for interactive querying.