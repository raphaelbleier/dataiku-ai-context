# Dataiku Docs — metastore

## [metastore/dss-metastore]

# DSS as virtual metastore

When you don’t have a Hadoop cluster (and hence don’t have a HiveServer2), and if you are not running on AWS, you do not have a metastore service available.

For this kind of scenario, DSS itself can play the role of a metastore.

To enable DSS metastore, go to Admin > Settings > Metastore catalogs and select “DSS”.

With this configuration, all synchronization to metastore will be done to the virtual DSS metastore. DSS will respect per-project security on its builtin metastore.

When submitting Spark jobs, DSS will automatically configure Spark to use DSS as metastore with the appropriate credentials.

---

## [metastore/glue-metastore]

# Glue metastore

This kind of metastore catalog is the preferred setup when running on AWS and when using managed AWS services like EMR, EKS or Athena.

To enable Glue metastore, go to Admin > Settings > Metastore catalogs and select “AWS Glue”.

For authentication, we strongly recommend to use authentication through a S3 connection.

  * Create a S3 connection

  * Set Glue Auth to “Use AWS credentials from a connection”

  * Enter your S3 connection name




This way, all access to the Glue metastore will be done through the (possibly per-user) credentials defined in the S3 connection. When submitting Spark jobs, DSS will automatically configure Spark to use Glue with the appropriate credential.

---

## [metastore/hive-metastore]

# Hive metastore (through HiveServer2)

This kind of metastore catalog is the default when you install DSS.

It requires that you have one or multiple Hadoop clusters. DSS will leverage the HiveServer2 of your current Hadoop cluster to read and write from the Hive metastore server.

When running Spark jobs, Spark will talk directly to the Hive metastore server.

---

## [metastore/index]

# Metastore catalog

The metastore catalog is a concept that originated from the Hive project. The metastore stores an association between paths (initially on HDFS) and virtual tables.

A “table” in the metastore is made of:

  * A location of the files making up the data

  * A schema (column names and types)

  * A storage format indicating the file format of the data files

  * Other various metadata




Originally, a metastore catalog is an external service.

DSS features multiple integration points with the metastore catalog:

  * Datasets can be automatically and massively imported from definitions in a metastore catalog.

  * HadoopFS, S3, Azure Blob and Google Cloud Storage datasets can have an “associated metastore table”

  * When a managed dataset has an associated metastore table, the definition of the table in the metastore can be updated from the dataset settings each time the dataset is built. This allows you to then query the data of the dataset from any of the metastore-aware engines

  * When an external dataset has an associated metastore table, the definition of the dataset can be updated from the metastore. This is useful if the dataset was imported from the metastore




Multiple engines and features in DSS leverage the metastore (rather than the dataset definition) to perform computations:

  * Hive recipes and notebooks (see [Hive](<../hadoop/hive.html>) \- Requires a Hadoop cluster)

  * Hive datasets (see [Hive datasets](<../hadoop/hive-dataset.html>) \- Requires a Hadoop cluster)

  * Impala recipes and notebooks (see [Impala](<../hadoop/impala.html>) \- Requires a Hadoop cluster)

  * SparkSQL notebooks

  * SparkSQL recipes (if “global metastore” mode is enabled)

  * Athena




DSS can leverage three kinds of metastores:

  * [Hive metastore (through HiveServer2)](<hive-metastore.html>) if you use a Hadoop cluster

  * [Glue metastore](<glue-metastore.html>) if you run on AWS

  * [DSS itself as a virtual metastore](<dss-metastore.html>) for fully managed compute without a Hadoop cluster




Note

Dataiku Cloud is configured to use DSS itself as a virtual metastore. This property cannot be customized.