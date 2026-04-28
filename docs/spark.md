# Dataiku Docs — spark

## [spark/configuration]

# Spark configurations

Spark has many configuration options and you will probably need to use several configurations according to what you do, which data you use, etc. For instance you may want to use spark “locally” (on the DSS server) for some jobs and on YARN on your Hadoop cluster for others, or specify the allocated memory for each worker…

  * As administrator, in the general settings (from the Administration menu), in the Spark section, you can add / remove / edit named “template” configurations, in which you can set Spark options by key/value pairs. See the [Spark configuration documentation](<https://spark.apache.org/docs/latest/configuration.html#available-properties>)

  * At every place where you can prepare a Spark job, you will have to choose the base template configuration to use, and optionally additional / override configuration options for that specific job.

  * In most recipes that can load non-HDFS datasets (or sampled HDFS datasets), datasets are loaded as a single partition. They must be repartitioned so that **every partition fits in a Spark worker’s RAM**. There is a Repartition non-HDFS inputs settings to specify in how many partitions it should be split.

---

## [spark/datasets]

# Interacting with DSS datasets

DSS can read and write all datasets using Spark.

If you have a Spark engine (which does not need a cluster installation), using Spark on local datasets can still bring performance improvements, for example for the Grouping and Join recipes. Additionally, using Spark will bring you the ability to run SparkSQL, even if you don’t have a Hadoop cluster.

However, only HDFS and S3 datasets fully benefit from the Spark distributed nature out of the box. This is because for HDFS and S3 datasets, Spark has builtin support for reading data from these backend, and for splitting the data into multiple partitions.

## Hadoop FS datasets

In order for Spark jobs to read HDFS datasets directly, you need to make sure that the user running the Spark job has the “Details readable by” permission on the connection. For more information on this flag, see [Connections security](<../security/connections.html>).

Having this flag allows the Spark job to access the URI of the HDFS dataset, which permits it to access the filesystem directly. If this flag is not enabled, DSS needs to go to the slow path described below. This will very strongly degrade the performance of the Spark job.

For “true” HDFS datasets, the “details” of the HDFS connection generally do not contain any secret (only a root path). However, for Hadoop filesystem datasets that actually point to S3, WASB, …, the details of the HDFS connection usually contain a secret credential in order to connect to the cloud storage. Giving the “Details readable by” permission on these datasets will give the user running te Spark job the ability to read this credential. A common setup is to have multiple such connections, each with its own credential, and each accessible to only one group of users, in order to provide both isolation and ability to read datasets with good performance.

## S3 datasets

In order for Spark jobs to read S3 datasets directly, you need to make sure that the user running the Spark job has the “Details readable by” permission on the connection. For more information on this flag, see [Connections security](<../security/connections.html>).

Having this flag allows the Spark job to access the S3 bucket, which permits it to read the data directly. If this flag is not enabled, DSS needs to go to the slow path described below. This will very strongly degrade the performance of the Spark job.

The details of the S3 connection usually contain an AWS key pair in order to connect to the cloud storage. Giving the “Details readable by” permission on these datasets will give the user running te Spark job the ability to read this credential. A common setup is to have multiple such connections, each with its own credential, and each accessible to only one group of users, in order to provide both isolation and ability to read datasets with good performance.

## Other

For other kinds of datasets, since Spark does not natively read and split them, DSS makes them available in Spark using a simplified reader. These datasets are read and written using a single Spark partition (not to be confused with DSS partitions). A single Spark partition will be processed in a single thread (per Spark stage). Furthermore, in some operations, a single Spark partition is restricted to 2GB of data. Therefore, if your dataset is large, you will need to **repartition** it.

  * In PySpark and SparkR recipes, you need to use the SparkSQL API to repartition a dataframe (generally `df.repartition(X)` where X is a number of partitions)

  * In SparkSQL, Visual preparation, MLLib and VisualSQL recipes, repartitioning is automatic (in 10 partitions by default). You can configure the repartitioning and the target number of partitions in the various Advanced tabs.




A good rule of thumb is to ensure that each partition will correspond to 100-200 MB of data. Therefore, if your input dataset (on a non-HDFS non-S3 dataset) is 10 GB, you might want to repartition it in 50-100 (remember that for HDFS or S3 datasets, partitioning is automatically done at the source).

---

## [spark/index]

# DSS and Spark

Spark is a general engine for distributed computation. Once Spark integration is setup, DSS will offer settings to choose Spark as a job’s execution engine in various components.

---

## [spark/installation]

# Setting up Spark integration

There are four major ways to setup Spark in Dataiku:

  * If you are using [Dataiku Cloud](<../installation/index.html>) installation, Spark is already setup and ready to use, you do not need any further action

  * If you are using [Dataiku Cloud Stacks](<../installation/index.html>) installation, Spark on Elastic AI clusters is already setup and ready to use, you do not need any further action

  * If you are doing a custom installation with [Elastic AI](<../containers/index.html>), this will configure and enable Spark on Elastic AI clusters

  * If you are doing a custom installation with [Hadoop](<../hadoop/index.html>), Spark will be available through your Hadoop cluster. Please see [Spark](<../hadoop/spark.html>) for more details.

  * Using “Unmanaged Spark on Kubernetes”




## Unmanaged Spark on Kubernetes

Warning

This is a very custom setup. We recommend that you leverage Dataiku Elastic AI capabilities rather.

The precise steps to follow for Spark-on-Kubernetes depend on which managed Kubernetes offering you are using and which cloud storage you want to use.

We strongly recommend that you rather use [Elastic AI](<../containers/index.html>).

The rest of this page provides indicative instructions for non-managed deployments

### Configure DSS

You first need to configure DSS to use your Spark 3.4

### Build your Docker images

Follow the Spark documentation to build Docker images from your Spark distribution and push it to your repository.

Note that depending on which cloud storage you want to connect to, it may be necessary to modify the Spark Dockerfiles. See our guided installation procedures for more details.

### Create the Spark configuration

Create a named Spark configuration (see [Spark configurations](<configuration.html>)), and set at least the following keys:

  * `spark.master`: `k8s://https://IP_OF_YOUR_K8S_CLUSTER`

  * `spark.kubernetes.container.image`: `the tag of the image that you pushed to your repository`

---

## [spark/limitations]

# Limitations and attention points

Spark is a fairly complex execution engine; tuning and troubleshooting Spark jobs require some experience.

Spark’s additional possibilities come with a few limitations:

  * Sampling with filter is not supported for input datasets; prefer a filtering recipe instead.

  * HDFS datasets perform much better on Spark than other datasets, for both reading and writing.

  * Sampling an HDFS dataset (except with a fixed ratio) can be slower than loading it unsampled.




Warning

Spark’s overhead is non-negligible and its support has some limitations (see above and [Usage of Spark in DSS](<usage.html>)). If your data fits in the memory of a single machine, other execution engines might be faster and easier to tune. It is recommended that you only use Spark for data that does not fit in the memory of a single machine.

---

## [spark/pipelines]

# Spark pipelines

One of the greatest strengths of Spark is its ability to execute long data pipelines with multiple steps without always having to write the intermediate data and re-read it at the next step.

In DSS, each recipe reads some datasets and writes some datasets. For example:

  * A grouping recipe will read from the storage the input dataset, perform the grouping and write the grouped dataset to its storage.

  * A PySpark recipe will direct Spark to read the input(s), perform the whole Spark computation defined by the PySpark recipe and then direct Spark to write the output(s)




With this behavior:

  * When writing a coding Spark recipe (PySpark, SparkR, Spark-Scala or SparkSQL), you can write complex data processing steps with an arbitrary number of Spark operations, and DSS will send this to Spark as one single activity.

  * However, when having a chain of visual and/or code recipes (a grouping then a prepare then a join then a grouping …), each recipe is executed independently, and the data is materialized in each dataset.




If all of these visual recipes are Spark-enabled, it is possible to avoid the read-write-read-write cycle using _Spark pipelines_. When several consecutive recipes in a DSS Flow (including with branches or splits) use the Spark engine, DSS can automatically merge all of these recipes and run them as a single Spark job, called a Spark pipeline. This strongly boosts performance by avoiding needless writes and reads of intermediate datasets, and also alleviates Spark startup overheads.

A Spark pipeline covers multiple recipes, and thus one or more intermediate datasets which are part of the pipeline. You can configure the behavior of the pipeline for each of these intermediate datasets:

  * Either this dataset is not meaningful nor useful by itself: it is only required as an intermediate step to feed recipes down the Flow. In that case, DSS will not at all write the data of this intermediate dataset when executing the Spark pipeline.

  * Or the data in this dataset is actually useful (maybe because you have charts or notebooks using it). In that case, during the execution of the pipeline, DSS will still write the intermediate dataset.




Writing intermediate datasets reduces the performance gain of using a Spark pipeline, but does not negate it since the burden of re-reading the dataset afterwards is still alleviated. It also mutualizes startup overheads.

## Enabling Spark pipelines

Merging of Spark pipelines is not enabled by default in DSS. It must be enabled on a per-project basis.

  * Go to the project **Settings**

  * Go to **Pipelines**

  * Select **Enable Spark pipelines**

  * **Save** settings




## Creating a Spark pipeline

You don’t need to do anything special to get Spark pipelines. Each time you run a build job, DSS will evaluate whether one or several Spark pipelines can be created and will run them automatically.

You can check whether a Spark pipeline has been created in the job’s results page. On the left part of the screen, “Spark pipeline (xx activities)” will appear and mention how many recipe or recipe executions were merged together.

## Configuring behavior for intermediate datasets

The behavior of intermediate datasets can be configured by the user: write them or not (only the final datasets are written in that case).

This behavior is configured per dataset.

  * Go to the dataset’s settings page

  * Go to Advanced

  * Check “Virtualizable in build” if you don’t require this dataset to be built when a Spark pipeline includes it.




## Limitations

The following are not supported in Spark pipelines:

  * PySpark and SparkR code recipes

  * Spark Scala code recipes in “Free-form” code mode

  * SparkSQL query recipes with [multiple statements](<../code_recipes/sql.html#code-recipes-sql-multiple-statements-handling>)

  * TopN visual recipes with a “Remaining rows” output dataset

  * Pivot visual recipes with the “Recompute schema at each run” option enabled

  * Split visual recipes using “Dispatch percentiles of sorted data” mode

  * [Generate features](<../other_recipes/generate-features.html>) visual recipes




The Spark Scala recipe has additional limitations when running in a Spark Pipeline:

  * `dkuContext.flowVariables` are not provided

  * `dkuContext.customVariables` remains the same through the entire job, including the entire pipeline. This is not specific to the Spark pipeline, but can be counter-intuitive when some upstream recipe modifies it.




While the Spark pipeline feature is supported, you may encounter some edge cases. In that case, note that pipelines can still be disabled on a per-project basis, and Dataiku Support may request that you do so.

---

## [spark/usage]

# Usage of Spark in DSS

When Spark support is enabled in DSS, a large number of components feature additional options to run jobs on Spark.

## SparkSQL recipes

SparkSQL recipes globally work like [SQL Recipes](<../code_recipes/sql.html>) but are not limited to SQL datasets. DSS will fetch the data and pass it on to Spark.

You can set the Spark configuration in the Advanced tab.

See [SparkSQL recipes](<../code_recipes/sparksql.html>)

## Visual recipes

You can run [Preparation](<../preparation/index.html>) and some [Visual Recipes](<../other_recipes/index.html>) on Spark. To do so, select Spark as the execution engine and select the appropriate Spark configuration.

For each visual recipe that supports a Spark engine, you can select the engine under the “Run” button in the recipe’s main tab, and set the Spark configuration in the “Advanced” tab.

All visual data-transformation recipes support running on Spark, including:

  * Prepare

  * Sync

  * Sample / Filter

  * Group

  * Distinct

  * Join

  * Pivot

  * Sort

  * Split

  * Top N

  * Window

  * Stack




### Falling back to DSS execution for small datasets

Visual recipes may auto-select Spark when it is enabled. Yet Spark may not always be the best choice, especially for small, non-partitioned datasets. Fortunately, this behavior can be overridden.

The **Recipe Engines** section in “Administration > Settings > Engines & Connections”, or at the project level in “Settings > Engines & Connections”, can be used to control which recipes and dataset sizes use DSS instead of Spark as the default engine choice.

Fallback from Spark to DSS for small datasets is disabled for installations predating Dataiku 14.5. It is enabled for later installations, for all visual recipes except Sync, Pivot and Join, with a dataset size threshold of 20MB.

## Python code

You can write Spark code using Python:

  * In a [Pyspark recipe](<../code_recipes/pyspark.html>)

  * In a [Python notebook](<../notebooks/python.html>)




### Note about Spark code in Python notebooks

All Python notebooks use the same named Spark configuration. See [Spark configurations](<configuration.html>) for more information about named Spark configurations.

When you change the named Spark configuration used by notebooks, you need to restart DSS afterwards.

## R code

Warning

**Tier 2 support** : Support for SparkR and sparklyr is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

You can write Spark code using R:

  * In a [Spark R recipe](<../code_recipes/sparkr.html>)

  * In a R notebook




Both the recipe and the notebook support two different APIs for accessing Spark:

  * The “SparkR” API, i.e. the native API bundled with Spark

  * The “sparklyr” API




### Note about Spark code in R notebooks

All R notebooks use the same named Spark configuration. See [Spark configurations](<configuration.html>) for more information about named Spark configurations.

When you change the named Spark configuration used by notebooks, you need to restart DSS afterwards.

## Scala code

You can use [Scala](<../code_recipes/scala.html>), Spark’s native language, to implement your custom logic. The Spark configuration is set in the recipe’s Advanced tab.

Interaction with DSS datasets is provided through a dedicated DSS Spark API, that makes it easy to read and write SparkSQL dataframes from datasets.

Warning

The Spark-Scala notebook is deprecated and will soon be removed

## Machine Learning with MLLib - Deprecated

See the dedicated [MLLib page](<../machine-learning/algorithms/mllib.html>).