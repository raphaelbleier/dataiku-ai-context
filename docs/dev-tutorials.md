# Dataiku Docs — dev-tutorials

## [tutorials/admin/index]

# Administration  
  
This tutorial section contains articles about the various tasks an admin would like to automate.

**Disk management**

  * [Monitoring and Optimizing Disk Usage in Dataiku with the Datadir Footprint API](<monitoring-disk-usage.html>)




**Permissions**

  * [Retrieve AWS Credentials from Dataiku API](<retrieve-aws-credentials-from-dataikuapi/index.html>)

---

## [tutorials/admin/monitoring-disk-usage]

# Monitoring and Optimizing Disk Usage in Dataiku with the Datadir Footprint API

In this tutorial, you will learn how to use the [`Datadir Footprint API`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint"). This API helps you in monitoring the size of your instance. In a long-running instance, the size occupied by this instance could grow. For example, there might be some unused Code Environments, Model Cache, Code Studio Templates, etc. Obviously, this information can be found by using Dataiku and by looking in every location. But it’s cumbersome and a waste of time. The Datadir Footprint API helps you to find quickly where you need to pay attention to gain space.

## Prerequisites

  * Dataiku >= 14.2

  * Access to a Dataiku instance with the “Administration” permissions




## Getting the size of the directories

To get the size of the directories, you first need to obtain a handle to analyze the footprint, as shown in Code 1.

Code 1 – How to obtain a handle for the Datadir Footprint
    
    
    import dataiku
    import dataikuapi
    from dataikuapi.dss.data_directories_footprint import DSSDataDirectoriesFootprint, Footprint
    
    
    client: dataikuapi.DSSClient = dataiku.api_client()
    foot_print: DSSDataDirectoriesFootprint = client.get_data_directories_footprint()
    

Once the handle is obtained, you can use one of the following methods to compute the different sizes of the directories:

  * [`compute_global_only_footprint()`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_global_only_footprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_global_only_footprint"): which computes the size of the instance-wide directories like Code Environment, Plugins, Libraries, …

  * [`compute_project_footprint()`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_project_footprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_project_footprint"): which computes the size of directories associated with a specific project.

  * [`compute_unknown_footprint()`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_unknown_footprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_unknown_footprint"): which computes the size of directories that are not linked to Dataiku.

  * [`compute_all_dss_footprint()`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_all_dss_footprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_all_dss_footprint"): which computes all directories’ footprint (including project ones).




For example, if you need to investigate which global directory is growing, you can enter the following code:

Code 2 – Printing the size of the global directory
    
    
    foot_print_global: Footprint = foot_print.compute_global_only_footprint()
    print(foot_print_global.human_readable_size)
    

This will print the size of all global directories. `footPrintGlobal` contains all the necessary information, so if you want more details, you can iterate on it, as demonstrated in Code 3.

Code 3 – Printing the details of the global directory.
    
    
    def print_details(data: Footprint) -> None:
        """
        Print the size of all directories contained in data
        Args:
            data:
        """
        for rep in data.details:
            print(rep, " : ", Footprint(data.details.get(rep)).human_readable_size)
    
    print_details(foot_print_global)
    

And you can also iterate on the details.

Code 4 – Iterating on the details of the global directory.
    
    
    code_envs: Footprint = Footprint(foot_print_global.get('codeEnvs'))
    print_details(code_envs)
    

## Using the API

On a long-running instance, the codeEnv folder can consume a significant amount of disk space, due to unused Code Environments, for example. So let’s find which Code Environment takes up the most space by computing the size of each one and then sorting them. Code 5 shows how to do it.

Code 5 — Calculating the size of each subfolder.
    
    
    from typing import List, Tuple
    
    
    def get_size(data: Footprint) -> List[Tuple[str, int]]:
        """
        List the size of all directories contained in data
        Args:
            data: the parent folder
    
        Returns:
            the size of all directories contains in data
        """
        sizes: List[Tuple[str, int]] = list()
        for rep in data.details:
            sizes.append((rep, Footprint(data.details.get(rep)).size))
        ssizes: List[Tuple[str, int]] = sorted(sizes, key=lambda x: x[1], reverse=True)
        return ssizes
    

You can plot the results using Code 6. The resulting output can be seen in Fig. 1.

Code 6 — Visualization of the top 10 most consuming disk space.
    
    
    import matplotlib.pyplot as plt
    
    
    def extract_first_n_element(a_list: List[Tuple[str, int]], size: int = 20) -> Tuple[List[str], List[int]]:
        """
        Extract the first n element of a list of couple and return two lists
        Args:
            a_list: A list of couple
            size: number of elements to extract
    
        Returns:
            the list unboxed
        """
        list_env_name: List[str]
        list_env_size: List[int]
    
        list_env_name, list_env_size = [list(t) for t in zip(*a_list[:size])]
        return list_env_name, list_env_size
    
    
    code_envs: Footprint = Footprint(foot_print_global.get('codeEnvs'))
    print_details(code_envs)
    
    top_10_code_env = extract_first_n_element(get_size(code_envs), 10)
    plt.figure()
    plt.bar(top_10_code_env[0], top_10_code_env[1])
    plt.xticks(rotation=90)
    plt.show()
    

Figure 1: Plotting the most disk space consuming Code Environment.

## Wrapping up

In this tutorial, we used the Datadir Footprint API to monitor disk usage in your Dataiku instance. You can use these insights to optimize storage, clean up unused resources, and maintain your Dataiku environment.

Here is the complete code for this tutorial:

[`monitoring.py`](<../../_downloads/b2bf2b6a69d0bf8e12bcbb64623ba642/monitoring.py>)
    
    
    import dataiku
    import dataikuapi
    from dataikuapi.dss.data_directories_footprint import DSSDataDirectoriesFootprint, Footprint
    from typing import List, Tuple
    import matplotlib.pyplot as plt
    
    
    def extract_first_n_element(a_list: List[Tuple[str, int]], size: int = 20) -> Tuple[List[str], List[int]]:
        """
        Extract the first n element of a list of couple and return two lists
        Args:
            a_list: A list of couple
            size: number of elements to extract
    
        Returns:
            the list unboxed
        """
        list_env_name: List[str]
        list_env_size: List[int]
    
        list_env_name, list_env_size = [list(t) for t in zip(*a_list[:size])]
        return list_env_name, list_env_size
    
    
    def get_size(data: Footprint) -> List[Tuple[str, int]]:
        """
        List the size of all directories contained in data
        Args:
            data: the parent folder
    
        Returns:
            the size of all directories contains in data
        """
        sizes: List[Tuple[str, int]] = list()
        for rep in data.details:
            sizes.append((rep, Footprint(data.details.get(rep)).size))
        ssizes: List[Tuple[str, int]] = sorted(sizes, key=lambda x: x[1], reverse=True)
        return ssizes
    
    
    def print_details(data: Footprint) -> None:
        """
        Print the size of all directories contained in data
        Args:
            data:
        """
        for rep in data.details:
            print(rep, " : ", Footprint(data.details.get(rep)).human_readable_size)
    
    
    client: dataikuapi.DSSClient = dataiku.api_client()
    foot_print: DSSDataDirectoriesFootprint = client.get_data_directories_footprint()
    
    foot_print_global: Footprint = foot_print.compute_global_only_footprint()
    print(foot_print_global.human_readable_size)
    
    print_details(foot_print_global)
    
    code_envs: Footprint = Footprint(foot_print_global.get('codeEnvs'))
    print_details(code_envs)
    
    top_10_code_env = extract_first_n_element(get_size(code_envs), 10)
    plt.figure()
    plt.bar(top_10_code_env[0], top_10_code_env[1])
    plt.xticks(rotation=90)
    plt.show()
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint")(client) | Handle to analyze the footprint of data directories  
[`dataikuapi.dss.data_directories_footprint.Footprint`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.Footprint> "dataikuapi.dss.data_directories_footprint.Footprint")(data) | Helper class to access values of the data directories footprint  
  
### Functions

[`compute_all_dss_footprint`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_all_dss_footprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_all_dss_footprint")([wait]) | Lists all the DSS data directories footprints, returning directories size in bytes.  
---|---  
[`compute_global_only_footprint`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_global_only_footprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_global_only_footprint")([wait]) | Compute the global data directories footprints, returning directories size in bytes.  
[`compute_project_footprint`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_project_footprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_project_footprint")(project_key[, wait]) | Lists data directories footprints for the given project, returning directories size in bytes.  
[`compute_unknown_footprint`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_unknown_footprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint.compute_unknown_footprint")([...]) | Lists the unknown data directories footprints, returning directories size in bytes Unknown directories are any directory that does not belong to DSS  
[`details`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.Footprint.details> "dataikuapi.dss.data_directories_footprint.Footprint.details") | Drill down into this data directories footprint  
[`get_size`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.Footprint.get_size> "dataikuapi.dss.data_directories_footprint.Footprint.get_size")([unit]) | Get the size of this footprint item  
[`human_readable_size`](<../../api-reference/python/footprint.html#dataikuapi.dss.data_directories_footprint.Footprint.human_readable_size> "dataikuapi.dss.data_directories_footprint.Footprint.human_readable_size") | Get a printable size of this footprint item

---

## [tutorials/admin/retrieve-aws-credentials-from-dataikuapi/index]

# Retrieve AWS Credentials from Dataiku API  
  
## Prerequisites

  * A machine running Dataiku




## Introduction

You may have the need to manage users permission for security and organization purposes. In Dataiku, it is possible to manage AWS permissions through code with the Python API. With these credentials, it is then possible to manage AWS resources.

## Connecting AWS and Dataiku

Before being able to retrieve AWS credentials for Dataiku resources you must:

  1. Ensure that the machine running Dataiku has an [IAM instance profile](<https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html>).

  2. Enable a S3 connection with [AssumeRole](<https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html>) mode and **Details readable by** parameter. See more on [this tutorial](<https://knowledge.dataiku.com/latest/admin-configuring/connection-security/tutorial-aws-assumerole-mechanism.html>).

  3. As the role to assume, use `${adminProperty:associatedRole}`.

  4. In each user’s settings, in **Admin Properties** , add an entry `associatedRole` with the name of the IAM role to assume.

  5. Ensure that the IAM instance profile of the machine running Dataiku can assume the needed roles.




## Retrieving

The following code allows you to retrieve AWS credentials with a Dataiku API call and the S3 connection previously enabled.

In DataikuOutside Dataiku
    
    
    1import dataiku
    2
    3# to complete as needed
    4MY_S3_CONNECTION = ""
    5
    6conn_info = dataiku.api_client().get_connection(MY_S3_CONNECTION).get_info()
    7cred = conn_info.get_aws_credential()
    
    
    
     1import dataiku
     2
     3# to complete as needed
     4MY_S3_CONNECTION = ""
     5DATAIKU_HOST = ""
     6MY_API_KEY = ""
     7
     8dataiku.set_remote_dss(f"http://{DATAIKU_HOST}", API_KEY)
     9
    10conn_info = dataiku.api_client().get_connection(MY_S3_CONNECTION).get_info()
    11cred = conn_info.get_aws_credential()
    

The output `cred` is a dict that contains the Security Token Service (STS) token.

Note

If you run your code on an API endpoint, such as Kubernetes, you will have to initialize the Dataiku API client with [`dataikuapi.DSSClient()`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient") prior the steps described above.

This dictionary also contains access and secret keys, which allows to manage AWS resources. You can do it with [boto3](<https://boto3.amazonaws.com/v1/documentation/api/latest/index.html>), which is the AWS Software Development Kit (SDK) to access AWS services.

As an example, the code below allows you to create a session and access your [S3 buckets](<https://docs.aws.amazon.com/s3/>).
    
    
     1import boto3
     2
     3# Create a session using the retrieved credentials
     4session = boto3.Session(
     5    aws_access_key_id=cred['accessKey'],
     6    aws_secret_access_key=cred['secretKey'],
     7    aws_session_token=cred['sessionToken']
     8)
     9
    10# Use the session to interact with AWS services, such as S3 for example
    11s3 = session.client('s3')
    12
    13# Example: List all buckets in S3
    14response = s3.list_buckets()
    

## Wrapping up

In this tutorial, you retrieved credentials to manage AWS resources on a machine running Dataiku.

---

## [tutorials/data-engineering/bigframes-basics/index]

# Using Bigframes Python in Dataiku: basics

This tutorial introduces users to Bigframes, a Python library designed for efficient data manipulation in BigQuery, within the Dataiku environment. It covers the prerequisites for using Bigframes, demonstrates how to establish a session, provides guidance on loading data into BigQuery DataFrames, and performs common data operations. By using the NYC taxi trip and zone datasets, users will learn to leverage the Bigframes API for effective data processing.

## Prerequisites

  * Dataiku >= 13.4.0

  * A [BigQuery connection](<https://doc.dataiku.com/dss/latest/connecting/sql/bigquery.html>) with Datasets containing :

    * the [NYC Taxi trip data](<https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page>) over the year/month of your choice, referred to as `NYC_trips`

    * the [NYC Taxi zone lookup table](<https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv>) referred to as `NYC_zones`.

  * A Python 3.9 [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html>) with the [`bigframes`](<https://cloud.google.com/python/docs/reference/bigframes/latest>) package installed.




## What is Bigframes?

Bigframes is a Python library design to programmatically access and process data in BigQuery using Python. It allows the user to manipulate _DataFrames_ similarly to Pandas. The developer site of Bigframes mentions [Apache Ibis](<https://ibis-project.org>) as a precursor, which means that Bigframes’ goal is to convert operations expressed on Pandas dataframes as BigQuery SQL under the hood.

In this tutorial, you will work with the `NYC_trips` and `NYC_zones` Datasets to discover a few features of the Bigframes Python API and how they can be used within Dataiku to:

  * Facilitate reading and writing BigQuery Datasets.

  * Perform useful/common data transformation.




## Creating a Session

Whether using Bigframes in a Python recipe or notebook, you’ll first need to create a Bigframes Session.

A [Session](<https://cloud.google.com/python/docs/reference/bigframes/latest/bigframes.session.Session>) object is used to establish a connection with BigQuery. Normally, this Session would need to be instantiated with the user manually providing credentials such as a private key or an access token. However, the `get_session()` method reads all the necessary parameters from the BigQuery connection in Dataiku and thus exempts the user from having to handle credentials manually.

Start by creating a Jupyter notebook with the code environment mentioned in the prerequisites and instantiate your Session object:
    
    
    from dataiku.bigframes import DkuBigframes
    
    bf = DkuBigframes()
    # Replace with the name of your BigQuery connection
    session = bf.get_session(connection_name="YOUR-CONNECTION-NAME")
    

The default when instantiating the `DkuBigframes` object is to use the so-called “NULL ordering” or “partial ordering”. This mode is needed to use BigQuery tables with `require_partition_filter` set to true, and to avoid full scans in some Bigframes operations, but comes at the cost of ease of use of the API, since the dataframes then lack an index. You can pass `session_ordering_mode = 'strict'` to the `DkuBigframes` constructor if you don’t need the partial ordering.

## Loading data into a DataFrame

Before working with the data, you first need to read it, more precisely to _load it from a BigQuery table into a BigQuery DataFrame_. With your `session` variable, create a BigQuery DataFrame using one of the following ways:

### Option 1: with the Dataiku API

The easiest way to obtain a BigQuery DataFrame is by using the `get_dataframe()` method and passing a `dataiku.Dataset` object. The `get_dataframe()` can optionally be given a Bigframes Session argument. Dataiku will use the session created above or create a new one if no argument is passed.
    
    
    import dataiku 
    NYC_trips = dataiku.Dataset("NYC_trips")
    df_trips = bf.get_dataframe(dataset=NYC_trips)
    

### Option 2: with a SQL query

Using the `session` object, a DataFrame can be created from a SQL query.
    
    
    # Get the name of the dataiku.Dataset's underlying Bigquery table.
    trips_table_info = NYC_trips.get_location_info().get('info', {})
    df_trips = session.read_gbq_query(f"Select * from `{trips_table_info.get('schema')}.{trips_table_info.get('table')}`")
    

Unlike Pandas DataFrames, BigQuery DataFrames are lazily evaluated. This means that they, and any subsequent operation applied to them, are not immediately executed.

Instead, they are evaluated only upon the calling of certain methods (`peek()`, `to_pandas()` and converting to text, for example when printing in a notebook cell).

This lazy evaluation minimizes traffic between the BigQuery warehouse and the client as well as client-side memory usage.

## Retrieving rows

  * The `peek(n)` method is the only method that allows users to pull and check **n** rows from the BigQuery DataFrame. Yet, it is arguably not the most pleasant way of checking a DataFrame’s content.



    
    
    # Retrieve 5 rows
    df_trips.peek(5)
    

  * The `to_pandas()` method converts the BigQuery DataFrame into a more aesthetically-pleasing Pandas DataFrame. Avoid using this method if the data is too large to fit in memory. Instead, leverage the [`to_pandas_batches()`](<https://cloud.google.com/python/docs/reference/bigframes/latest/bigframes.dataframe.DataFrame#bigframes_dataframe_DataFrame_to_pandas_batches>) method. Alternatively, you can use a head statement before retrieving the results as a Pandas DataFrame. Note that the inner workings of Bigframes use orderings in order to replicate Pandas indexes, and this means that the `head()` method needs one such ordering to be present. Since the default when instantiating the `DkuBigframes` object is to use the so-called “NULL ordering” or “partial ordering”, the ordering needs to be provided manually for methods who need it, with a `sort_values()` call for example.



    
    
    df_trips.sort_values('VendorID').head(5).to_pandas()
    

## Common operations

Bigframes attempts to follow Pandas’ usage pattern when it comes to dataframes. This contrasts with Snowpark and Databricks Connect, whose dataframes behave a lot more like Spark dataframes.

The following paragraphs illustrate a few examples of basic data manipulation using DataFrames:

### Selecting column(s)

Accessing columns using classical Pandas indexing is possible, as well as accessing as properties.
    
    
    fare_amount = df_trips[['fare_amount', 'tip_amount']]
              
    # Single columns can also be accessed as
    fare_amount_only = df_trips['fare_amount']
    fare_amount_only_again = df_trips.fare_amount
    

### Computing the average of a column

Collect the mean `fare_amount`. This is evaluated directly and the `mean()` method returns the value as a `float`:
    
    
    avg_fare = df_trips['fare_amount'].mean()
    avg_fare # 12.556332926005984
    

### Creating a new column from a case expression

Columns can be added or replaced with the usual Pandas indexing, or with the `assign()` meethod.

Leverage the `assign()` method to create a new column indicating whether a trip’s fare was above average:
    
    
    df_trips = df_trips.assign(cost='high')
    df_trips["cost"] = df_trips["cost"].case_when([(df_trips["fare_amount"] < avg_fare, 'low')])
    
    # Check the first five rows
    df_trips[['cost', 'fare_amount']].peek(5)
    

### Joining two tables

The `NYC_trips` contains a pick up and drop off location id (_PULocationID_ and _DOLocationID_). We can map those location ids to their corresponding zone names using the `NYC_zones` Dataset.

To do so, perform two consecutive joins on the _LocationID_ column in the NYC zone Dataset.
    
    
    # Get the NYC_zones Dataset object
    NYC_zones = dataiku.Dataset("NYC_zones")
    df_zones = bf.get_dataframe(NYC_zones)
    
    df_zones.to_pandas()
    

Finally, perform the two consecutive left joins. We’ll use `merge()` and not `join()`, because `join()` is a join on the dataframe’s index, and not on a specific column; and by default the dataframes have a null index. Note how you are able to chain different operations including `rename()` to rename the _Zone_ column and `drop()` to remove other columns from the `NYC_zones` dataset:
    
    
    df = df_trips.merge(df_zones, how='left', left_on='PULocationID', right_on='LocationID') \
                 .drop(['LocationID', 'Borough', 'service_zone'], axis=1) \
                 .rename(columns={"Zone":"pickup_Zone"}) \
                 .merge(df_zones, how='left', left_on='DOLocationID', right_on='LocationID') \
                 .drop(['LocationID', 'Borough', 'service_zone'], axis=1) \
                 .rename(columns={"Zone":"dropoff_Zone"})
    

Since Bigframes essentially builds up SQL queries from operations on DataFrames, it is always possible to inspect the generated SQL query by looking at the `sql` property of the dataframe
    
    
    print(df.sql)
    

### Group By

Count the number of trips by pickup zone among expensive trips. Use dataframe indexing to remove cheaper trips, or the equivalent `query()`. Then use the `groupby()` method to group by _pickup_Zone_ , `agg()` to compute aggregates on each group, and `sort_values()` to get them in descending order. Finally, call the `to_pandas()` method to store the results of the group by as a Pandas DataFrame, which has a slightly different display from the BigQuery DataFrames, notably the ability to elide rows.
    
    
    # you can also use df.query("cost == 'low'")
    results_count_df = df[df["cost"] == 'low'] \
                               .groupby('pickup_Zone') \
                               .agg({"pickup_Zone":"count", "fare_amount":"mean"}) \
                               .rename(columns={'pickup_Zone':'count', 'fare_amount':'mean_fare'}) \
                               .sort_values('count', ascending=False)
    results_count_df.to_pandas()
    

## Writing a DataFrame into a BigQuery Dataset

In a Python recipe, you will likely want to write BigQuery DataFrame into a BigQuery output Dataset. We recommend using the `write_with_schema()` method of the `DkuBigframes` class. This method runs the [`to_gbq()`](<https://cloud.google.com/python/docs/reference/bigframes/latest/bigframes.dataframe.DataFrame#bigframes_dataframe_DataFrame_to_gbq>) Bigframes method to save the contents of a DataFrame into a BigQuery table.
    
    
    ouput_dataset = dataiku.Dataset("my_output_dataset")
    bf.write_with_schema(ouput_dataset, df)
    

Warning

You should avoid converting a Bigframes Python DataFrame to a Pandas DataFrame before writing the output Dataset. In the following example, using the `to_pandas()` method will create the Pandas DataFrame locally, further increasing memory usage and potentially leading to resource shortage issues.
    
    
    ouput_dataset = dataiku.Dataset("my_output_dataset")
    # Load the ENTIRE DataFrame in memory (NOT optimal !!)
    ouput_dataset.write_with_schema(df.to_pandas())
    

## Wrapping up

Congratulations, you now know how to work with Bigframes Python within Dataiku! To go further, here are some useful links:

  * [Dataiku reference documentation on the Bigframes Python integration](<https://doc.dataiku.com/dss/latest/connecting/sql/bigquery.html#bigframes-integration>)

  * [Bigframes Python reference](<https://cloud.google.com/python/docs/reference/bigframes/latest>)

---

## [tutorials/data-engineering/dask-dataframe/index]

# Using Dask DataFrames in Dataiku

This article introduces distributed data manipulation in Dataiku using [Dask DataFrames](<https://docs.dask.org/en/stable/dataframe.html>).  
Specifically, it illustrates how to:

  1. Deploy a Dask Cluster on a [Dataiku-managed Elastic AI cluster](<https://doc.dataiku.com/dss/latest/containers/managed-k8s-clusters.html> "\(in Dataiku DSS v14\)").

  2. Natively read a Dataiku dataset as a Dask DataFrame (i.e., without an intermediate step as a Pandas DataFrame).

  3. Perform distributed, parallelized computations on the Dask DataFrame.




## Pre-requisites

  * [Dataiku-managed Elastic AI cluster](<https://doc.dataiku.com/dss/latest/containers/managed-k8s-clusters.html> "\(in Dataiku DSS v14\)")

  * A [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)") with a Python version [supported by Docker Dask](<https://github.com/dask/dask-docker>) (which at the time of writing are 3.10, 3.11, and 3.12) and with the following packages:
        
        dask[distributed]
        pyarrow
        s3fs
        




Note

The code environment only needs to be built locally, i.e., [containerized execution support](<https://doc.dataiku.com/dss/latest/containers/code-envs.html> "\(in Dataiku DSS v14\)") is not required.

### Deploying a Dataiku-managed Elastic AI cluster

Before deploying the Dask Cluster, a Dataiku administrator must deploy a [Dataiku-managed Elastic AI cluster](<https://doc.dataiku.com/dss/latest/containers/managed-k8s-clusters.html> "\(in Dataiku DSS v14\)").

A few things to keep in mind about the Elastic AI Cluster:

  * Dataiku recommends creating a dedicated `nodegroup` to host the Dask Cluster; the `nodegroup` can be static or auto-scale.

  * Dataiku recommends that each cluster node have at least 32 GB RAM for typical data processing workloads.




## Deploying a Dask Cluster

The procedure to deploy a Dask Cluster onto a Dataiku-managed Elastic AI cluster is as follows.

By pluginAdvanced setup

Important

Note that this procedure requires Dataiku Administrator privileges.

  1. Install [this](<https://github.com/dataiku/dss-plugin-daskcluster>) plugin.

  2. Navigate to the “Macros” section of a Dataiku project, search for the “Dask” macros, and select the “Start Dask Cluster” macro.

Figure 1.1 – Macros for Dask

  3. Fill in the macro fields, keeping in mind the following information:

     * Dask image tag: this should be a valid tag from [Dask’s Docker Registry](<https://github.com/dask/dask-docker>); the Python version of the image tag should match the Python version of the Dataiku code environment created in the pre-requisites section.

     * The CPU / memory request should be at least 1 CPU / 2GB RAM per worker.

     * The total worker resources should fit within the Elastic AI Cluster’s default `nodegroup`.

Run the macro.

Figure 1.2 – Start macro

  4. Once the “Start Dask Cluster” macro is complete, run the “Inspect Dask Cluster” macro; this retrieves the Dask Cluster deployment status and provides the Dask Cluster endpoint once the cluster is ready.

Figure 1.3 – Inspect Dask Cluster

  5. Optionally, set up a port forwarding connection to the Dask Dashboard using the “Dask Dashboard Port-Forward” macro.

Figure 1.4 – Dask Dashboard Port-Forward

The Dask Dashboard will then be accessible at `http://\<Dataiku instance domain>:8787` while the macro is running.




If everything goes well, you should end up with something similar to:

Figure 1: Dask cluster is up and running

Important

Note that this procedure requires SSH access to the Dataiku server.

  1. SSH onto the Dataiku server and switch to the [dssuser](<https://doc.dataiku.com/dss/latest/user-isolation/index.html> "\(in Dataiku DSS v14\)").

  2. Point `kubectl` to the `kubeconfig` of the Elastic AI cluster onto which the Dask Cluster will be deployed:
         
         export KUBECONFIG=/PATH/TO/DATADIR/clusters/<cluster name>/exec/kube_config
         

where `/PATH/TO/DATADIR` is the path to Dataiku’s [data directory](<https://doc.dataiku.com/dss/latest/operations/datadir.html> "\(in Dataiku DSS v14\)"), and `<cluster name>` is the name of the Elastic AI cluster.

  3. Install the Dask Operator on the cluster:
         
         helm repo add dask https://helm.dask.org
         helm repo update
         helm install --create-namespace -n dask-operator --generate-name dask/dask-kubernetes-operator  
         

  4. Deploy the Dask Cluster:
         
         kubectl apply -f dask-cluster.yaml 
         

where `dask-cluster.yaml` is a file such as:
         
         apiVersion: kubernetes.dask.org/v1
         kind: DaskCluster
         metadata:
           namespace: dask
           name: simple-dask-cluster
         spec:
           worker:
             replicas: 2
             spec:
               nodeSelector:
                 label: value
               containers:
               - name: worker
                 image: "ghcr.io/dask/dask:latest-py3.10"
                 imagePullPolicy: "IfNotPresent"
                 args:
                   - dask-worker
                   - --name
                   - $(DASK_WORKER_NAME)
                   - --dashboard
                   - --dashboard-address
                   - "8788"
                 ports:
                   - name: http-dashboard
                     containerPort: 8788
                     protocol: TCP
                 resources:
                   limits:
                     cpu: "1"
                     memory: "2G"
                   requests:
                     cpu: "1"
                     memory: "2G"
           scheduler:
             spec:
               nodeSelector:
                 labelkey: labelvalue 
               containers:
               - name: scheduler
                 image: "ghcr.io/dask/dask:latest-py3.10"
                 imagePullPolicy: "IfNotPresent"
                 args:
                   - dask-scheduler
                 ports:
                   - name: tcp-comm
                     containerPort: 8786
                     protocol: TCP
                   - name: http-dashboard
                     containerPort: 8787
                     protocol: TCP
                 readinessProbe:
                   httpGet:
                     port: http-dashboard
                     path: /health
                   initialDelaySeconds: 5
                   periodSeconds: 10
                 livenessProbe:
                   httpGet:
                     port: http-dashboard
                     path: /health
                   initialDelaySeconds: 15
                   periodSeconds: 20
             service:
               type: NodePort
               selector:
                 dask.org/cluster-name: simple
                 dask.org/component: scheduler
               ports:
               - name: tcp-comm
                 protocol: TCP
                 port: 8786
                 targetPort: "tcp-comm"
               - name: http-dashboard
                 protocol: TCP
                 port: 8787
                 targetPort: "http-dashboard"
         

Attention

     * The `metadata.namespace` is optional and should correspond to a previously created namespace; Dataiku recommends using a dedicated namespace for each Dask cluster.

     * The `metadata.name` and `spec.scheduler.service.selector.dask.org/cluster-name` should be set to the desired Dask cluster name.

     * The `spec.worker.spec.nodeSelector` and `spec.scheduler.spec.nodeSelector` are optional.

     * The `spec.worker.replicas` should be set to the desired number of Dask workers.

     * The `spec.worker.spec.containers["worker"].name` and `spec.scheduler.spec.containers["scheduler"].name` fields should be the same and be valid tags from one of [Dask’s Docker Registry](<https://github.com/dask/dask-docker>) images.

     * The Python version of the `spec.worker.spec.containers["worker"].name` and `spec.scheduler.spec.containers["scheduler"].name` should match the Python version of the Dataiku code environment created in the pre-requisites section.

     * The `spec.worker.spec.containers["worker"].resources.limits` should be set to a **minimum** of 1 vCPU and 2GB RAM (although significantly more resources will likely be required depending on the specific data processing task).

For the complete schema of the Dask Cluster YAML file, see the [Dask documentation](<https://kubernetes.dask.org/en/latest/operator_resources.html#full-configuration-reference>).

  5. Watch the Dask Cluster pods being created:
         
         kubectl get pods -A -w -n <dask cluster namespace>
         

  6. Once the `scheduler` pod has been successfully created, describe it and determine its IP:
         
         kubect describe pod <dask-cluster-scheduler-pod-name> -n <dask cluster namespace>
         

The Dask Cluster endpoint is `<scheduler pod IP>:8786`.

  7. Optionally, set up a port forwarding connection to the Dask Dashboard:
         
         kubectl port-forward service/<dask cluster name>-scheduler -n <dask cluster namespace> --address 0.0.0.0 8787:8787
         

The Dask Dashboard will be accessible at `http://<Dataiku instance domain>:8787`. Accessing it via a browser may require opening this port at the firewall.




If everything goes well, you should end up with something similar to:

Figure 1: Dask cluster is up and running

For more information on this procedure and how to further customize the deployment of a Dask Cluster on Kubernetes (e.g., writing custom Dask Operator plugins), please refer to the relevant [Dask Kubernetes documentation](<https://kubernetes.dask.org/en/latest/index.html>).

## Read and Manipulate a Dataiku Dataset as a Dask DataFrame

Now that the Dask cluster is running, users can manipulate Dataiku datasets in a distributed, parallelized fashion using Dask DataFrames. All that is required is the Dask cluster endpoint determined above.

First, you will need to create a [Project Library](<../../../concepts-and-examples/project-libraries.html>) called `dku_dask` (under the `python` folder) with one file, `utils.py`, with the following content:

[utils.py](<../../../_downloads/00588e2dd552db774e6e86329dedfa81/utils.py>)

utils.py
    
    
    import dataiku
    
    def extract_packages_list_from_pyenv(env_name):
        """
        Extracts python package list (requested) from an environment.
        Returns a list of python packages.
        """   
        client = dataiku.api_client()
        pyenv = client.get_code_env(env_lang="PYTHON", env_name=env_name)
        pyenv_settings = pyenv.get_settings()
        
        packages = pyenv_settings.settings["specPackageList"]
        packages_list = packages.split("\n")
        
        return packages_list
    
    def s3_credentials_from_dataset(dataset_name):
        """
        Retireves S3 credentials (access key, secret key, session token) from S3 dataset.
        Assumues dataset is stored on S3 connection, with AssumeRole as auth method.
        
        TODO: actually check this, and don't just fail.
        """
        client = dataiku.api_client()
        
        ds = dataiku.Dataset(dataset_name) # resolved path and connection name via internal API
        ds_connection_name = ds.get_config()["params"]["connection"]
    
        ds_connection = client.get_connection(ds_connection_name)
        ds_connection_info = ds_connection.get_info()
        access_key = ds_connection_info["resolvedAWSCredential"]["accessKey"]
        secret_key = ds_connection_info["resolvedAWSCredential"]["secretKey"]
        session_token = ds_connection_info["resolvedAWSCredential"]["sessionToken"]
        
        return access_key, secret_key, session_token
    
    def s3_path_from_dataset(dataset_name):
        """
        Retrieves full S3 path (i.e. s3:// + bucket name + path in bucjet) for dataset.
        Assumues dataset is stored on S3 connection.
        
        TODO: actually check this, and don't just fail.
        """
        ds = dataiku.Dataset(dataset_name) # resolved path and connection name via internal API
        ds_path = ds.get_location_info()["info"]["path"]
        
        return ds_path
    

Second, you must create a dataset in the Flow, which will be read as a Dask DataFrame. This example (and the code of the `dku_dask` project library) assumes that this dataset is:

  * on S3

  * in the parquet format

  * on a Dataiku S3 connection that uses STS with AssumeRole as its authentication method and that the user running the code has “details readable by” access on the connection




Note

Modifying this example code to work with different connection and/or authentication types should be straightforward. For help, see the [Dask DataFrame API documentation](<https://docs.dask.org/en/stable/dataframe-create.html>).

Finally, the following code illustrates how to load a Dataiku dataset as a Dask DataFrame, apply a `groupby` transformation to the DataFrame (distributed over the cluster), and then collect the results. In this case, the `avocado_transactions` dataset is a slightly processed version of [this Kaggle dataset](<https://www.kaggle.com/datasets/neuromusic/avocado-prices>).
    
    
    import dataiku
    from dku_dask.utils import (
        extract_packages_list_from_pyenv, 
        s3_credentials_from_dataset,
        s3_path_from_dataset
    )
    
    from dask.distributed import Client, PipInstall
    import dask.dataframe as dd
    
    # Attach to the Dask cluster
    # Note: <Cluster IP> is the Dask cluster endpoint determined during the Dask cluster setup steps.
    dask_client = Client("<Dask Endpoint>")
    
    # Install missing packages on the cluster 
    # Note: <Dataiku code env name> is the name of the code environment created during the pre-requisites steps.
    packages = extract_packages_list_from_pyenv("<Dataiku code env name>")
    plugin = PipInstall(packages=packages, restart_workers=True)
    dask_client.register_plugin(plugin)
    
    # Retrieve Dataiku dataset as Dask DataFrame
    ## Get S3 credentials
    access_key, secret_key, session_token = s3_credentials_from_dataset("avocado_transactions")
    storage_options = {
        "key": access_key,
        "secret": secret_key,
        "token": session_token
    }
    
    ## Get dataset S3 path
    dataset_s3_path = s3_path_from_dataset("avocado_transactions")
    
    ## Read dataset as Dask DataFrame
    df = dd.read_parquet(dataset_s3_path, aggregate_files=True, storage_options=storage_options)
    
    # Perform a groupy manipulation on the DataFrame
    result = df.groupby(["type"]).mean()
    result.compute()
    

If all goes well, you should end up with something similar to (assuming you’ve run the code in a notebook):

Figure 1: Groupby result

## Conclusion

You now know how to set up a Dask cluster to achieve distributed, parallelized data manipulation using Dask DataFrames. Adapting this tutorial to your specific ETL needs should be easy.

Here is the complete code for this tutorial:

[code.py](<../../../_downloads/6c51cd4850183136e947d273b27808cb/code.py>)
    
    
    import dataiku
    from dku_dask.utils import (
        extract_packages_list_from_pyenv, 
        s3_credentials_from_dataset,
        s3_path_from_dataset
    )
    
    from dask.distributed import Client, PipInstall
    import dask.dataframe as dd
    
    # Attach to the Dask cluster
    # Note: <Cluster IP> is the Dask cluster endpoint determined during the Dask cluster setup steps.
    dask_client = Client("<Dask Endpoint>")
    
    # Install missing packages on the cluster 
    # Note: <Dataiku code env name> is the name of the code environment created during the pre-requisites steps.
    packages = extract_packages_list_from_pyenv("<Dataiku code env name>")
    plugin = PipInstall(packages=packages, restart_workers=True)
    dask_client.register_plugin(plugin)
    
    # Retrieve Dataiku dataset as Dask DataFrame
    ## Get S3 credentials
    access_key, secret_key, session_token = s3_credentials_from_dataset("avocado_transactions")
    storage_options = {
        "key": access_key,
        "secret": secret_key,
        "token": session_token
    }
    
    ## Get dataset S3 path
    dataset_s3_path = s3_path_from_dataset("avocado_transactions")
    
    ## Read dataset as Dask DataFrame
    df = dd.read_parquet(dataset_s3_path, aggregate_files=True, storage_options=storage_options)
    
    # Perform a groupy manipulation on the DataFrame
    result = df.groupby(["type"]).mean()
    result.compute()

---

## [tutorials/data-engineering/data-quality-sql/index]

# Data quality assessments (SQL Datasets)

Data quality is fundamental to the success of businesses, it leads to better decision-making which translates to better service and potential for higher revenues. In practice, making sure that key datasets abide by your project’s quality rules will ensure its robustness. For example, you will probably want to refrain from retraining a model if your training data has too much missing data in specific columns.

In Dataiku, ensuring data quality can be done visually with a combination of [Metrics](<https://doc.dataiku.com/dss/latest/metrics-check-data-quality/metrics.html#metrics>) and [Checks](<https://doc.dataiku.com/dss/latest/metrics-check-data-quality/checks.html>). You first use Metrics to take measurements on your data then use Checks to make sure those measurements meet some expectation about the data.

While it is possible to implement [custom metrics or checks](<https://doc.dataiku.com/dss/latest/metrics-check-data-quality/custom_metrics_and_checks.html#custom-probes-and-checks>), those still rely on the visual features of Dataiku. For a fully programmatic usage, it is more convenient to implement the same logic using plain Python Recipes. The resulting Flow can then be orchestrated and automated using [Scenarios](<https://doc.dataiku.com/dss/latest/scenarios/index.html>).

In this tutorial, you will implement an example of fully programmatic data quality assessment in a Dataiku Project. You can think of it as a light and custom version of the Metrics and Checks visual features.

## Prerequisites

  * A working Connection to a SQL database




## Setting up your project

This tutorial is based on the “Dataiku TShirts” sample Project available directly on your Dataiku platform. This project features a simple data processing pipeline on sales data to eventually build a ML model that predicts sales revenue from new visitors on the website.

  * Create the “Dataiku TShirts” sample project.




  * Go to the flow and [change all non-input datasets to your SQL connection](<https://knowledge.dataiku.com/latest/import-data/connections/concept-connection-changes.html>). Your data flow should look like this now:




Note

This tutorial assumes that you are using Snowflake, however any compatible SQL database can also work. You may have to slightly modify the SQL/Python code and use correct data types in the relevant Datasets to comply with your SQL’s flavor syntax.

## Creating metrics and checks

The `web_last_month_enriched` dataset serves as the train dataset for our model. As such, having quality data to feed to the model is of paramount importance. You will now create a python recipe to compute metrics and checks on that dataset.

### Create a Python recipe on the training dataset.

Create a python recipe from the `web_last_month_enriched` dataset. Name the output dataset `checks_web_last_month_enriched`. That output dataset will contain all the results of your checks which in turn will govern whether or not the model should be trained.

### Importing libraries, and defining handles and check functions.

Replace the recipe’s template code with the following snippet to import the necessary libraries, check functions, input and output datasets. The functions are implementations of [numeric range check](<https://doc.dataiku.com/dss/latest/metrics-check-data-quality/checks.html#numeric-range-check>) and [value in set check](<https://doc.dataiku.com/dss/latest/metrics-check-data-quality/checks.html#value-in-set-check>).
    
    
    import dataiku
    from dataiku import SQLExecutor2
    import numbers
    
    input_dataset_name = 'web_last_month_enriched'
    input_dataset = dataiku.Dataset(input_dataset_name)
    
    output_dataset_name = 'checks_web_last_month_enriched'
    output_dataset = dataiku.Dataset(output_dataset_name)
    
    def metric_in_numeric_range(metric_val=None, maximum=None,
                             soft_maximum=None, minimum=None, soft_minimum=None):
        """
        Returns OK if a metric value falls within the minimum - maximum range otherwise ERROR
        Returns WARNING if a metric value falls outside a soft_minimum - soft_maximum range
        """
        if metric_val is None:
            return 'EMPTY'
    
        if maximum is None and soft_maximum is None and minimum is None and soft_minimum is None:
            return 'EMPTY'
    
        elif isinstance(metric_val, numbers.Number):      
            if minimum is not None:
                if metric_val < minimum:
                    return 'ERROR'
            if maximum is not None:
                if metric_val > maximum:
                    return 'ERROR'
            if soft_minimum is not None:
                if metric_val < soft_minimum:
                    return 'WARNING'
    
            if soft_maximum is not None:
                if metric_val > soft_maximum:
                    return 'WARNING'
            return 'OK'  
    
        else:
            return 'WARNING'
    
        
    def metric_in_set_of_values(metric_vals=None, admissible_values=None):
        """
        Returns OK if the set of metric values is in 
        the set of allowed values
        """
        if not isinstance(metric_vals, set) or not isinstance(admissible_values, set):
            return 'EMPTY'
        
        if not len(metric_vals) or not len(admissible_values):
            return 'EMPTY'
        
        if len(metric_vals - admissible_values):
            return 'ERROR'
        else:
            return 'OK' 
    

### Querying the metrics and checking them.

In the recipe, you will leverage the [SQLExecutor2](<https://doc.dataiku.com/dss/latest/python-api/sql.html#performing-sql-hive-and-impala-queries>) module to inject a SQL query into the `web_last_month_enriched` dataset and collect statistics (your metrics) in the form of a Pandas dataframe. Besides computing column statistics, you are also “timestamping” for bookkeeping purposes.

Add the following code to the bottom of your recipe:
    
    
    query_stats = f"""
    SELECT
        current_timestamp(2) as "date",
        MIN("pages_visited") AS "metric_pages_visited_min",
        LISTAGG(DISTINCT("campain"), ', ') AS "metric_unique_campain",
        COUNT(*) AS "metric_rec_count"
        FROM "{input_dataset.get_location_info().get('info', {}).get('table')}"
    """
    
    executor = SQLExecutor2(dataset=input_dataset)
    df = executor.query_to_df(query_stats)
    
    
    # Checking that metric_pages_visited_min is at least 1 
    df['in_num_range_pages_visited_min'] = metric_in_numeric_range(
        df['metric_pages_visited_min'][0], minimum=1)
    
    # CHecking that metric_rec_count is greater than 1000
    df['in_num_range_rec_count'] = metric_in_numeric_range(
        df['metric_rec_count'][0], minimum=1000)
    
    # Check that "metric_unique_campain" is either true or false
    metric_values = set(df['metric_unique_campain'][0].split(', '))
    admissible_values = set(['true', 'false'])
    
    df['in_set_unique_campain'] = metric_in_set_of_values(
            metric_values, admissible_values)
    
    # write the results of the query to your output dataset
    output_dataset.write_with_schema(df)
    

In the above code, note that `LISTAGG` works for Snowflake, Oracle and Db2. For PostgreSQL or SQL Server, use `STRING_AGG`. For MySQL, use `GROUP_CONCAT()`.

You should be all set! Run the recipe to make sure everything works - the output should look like this:

## Persisting check results

When building datasets, the default behavior in Dataiku is to overwrite their content. If you want to persist the results from each build, go to the Python recipe, then click **Inputs/Ouputs** and check the **Append instead of overwrite** box. Save.

## Using test results

Suppose that every week, you wish to re-train your revenue-prediction model on newer data. Before doing so, it’s important to check that after every update, your train dataset (`web_last_month_enriched`) meet your data quality requirements and only re-train the model if none of the checks fails.

You can build a [scenario](<https://doc.dataiku.com/dss/latest/scenarios/definitions.html#definitions>) to automate this process. After setting a weekly trigger, you would use a Python script (or Python step) to:

  * Re-build the `checks_web_last_month_enriched` dataset recursively

  * Retrieve the results of the checks

  * Re-train the model only if all the checks passed.

---

## [tutorials/data-engineering/databricks-connect-basics/index]

# Using Databricks Connect Python in Dataiku: basics

This tutorial provides a comprehensive guide to using Databricks Connect with Python in Dataiku, from the initial setup to data manipulation with Pyspark DataFrames. By following this tutorial, users will be equipped to leverage Databricks’ computational resources effectively, directly from Dataiku.

## Prerequisites

  * Dataiku >= 12.1.0

  * A [Databricks cluster](<https://docs.databricks.com/clusters/configure.html>) with a runtime in version at least 13.0

  * A [Databricks connection](<https://doc.dataiku.com/dss/latest/connecting/sql/databricks.html>) with Datasets containing:

    * the [NYC Taxi trip data](<https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page>) over the year/month of your choice, referred to as `NYC_trips`

    * the [NYC Taxi zone lookup table](<https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv>) referred to as `NYC_zones`.

    * an [extract from the IMDB movie review dataset](<https://cdn.downloads.dataiku.com/public/website-additional-assets/data/IMDB_train.csv.gz>) referred to as `IMDB_train`.

  * A Python 3.10 [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html>) with the following packages installed:

    * `databricks-connect==13.0.*`

    * `spacy==3.6.0` The code environment should also have the following initialization script:
    
    from dataiku.code_env_resources import clear_all_env_vars
    clear_all_env_vars()
    import spacy
    spacy.cli.download("en_core_web_sm")
    




## What is Databricks Connect?

Databricks Connect is a package to run [Pyspark](<https://spark.apache.org/docs/latest/api/python/>) code on a Databricks cluster from any machine, by connecting remotely to the Databricks cluster and accessing its computational resources.

## Creating a Session

As usual with Pyspark, all commands will ultimately be issued to a Spark session, either via methods directly on the session object, or via Spark _DataFrames_ , which will translate and propagate commands to the session object they’re referencing.

Normally, this Session would need to be instantiated with the user manually providing credentials such as the personal access token, and connection details such as the workspace and cluster id. However, the `get_session()` method reads all the necessary parameters from the Databricks connection in Dataiku and thus exempts the user from having to handle credentials manually.

Start by creating a Jupyter notebook with the code environment mentioned in the prerequisites and instantiate your Session object:
    
    
    from dataiku.dbconnect import DkuDBConnect
    
    dbc = DkuDBConnect()
    # Replace with the name of your Databricks connection
    session = dbc.get_session(connection_name="YOUR-CONNECTION-NAME")
    

## Loading data into a DataFrame

Before working with the data, you first need to read it, more precisely to _get a Pyspark DataFrame pointing at the Databricks table_. With your `session` variable, create a Pyspark [DataFrame](<https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.html#pyspark.sql.DataFrame>) using one of the following ways:

### Option 1: with the Dataiku API

The easiest way to retrieve a DataFrame is by using the `get_dataframe()` method and passing a `dataiku.Dataset` object. The `get_dataframe()` can optionally be given a Databricks Connect Session argument. Dataiku will use the session created above or create a new one if no argument is passed.
    
    
    import dataiku 
    NYC_trips = dataiku.Dataset("NYC_trips")
    df_trips = dbc.get_dataframe(dataset=NYC_trips)
    

### Option 2: with a SQL query

Using the `session` object, a DataFrame can be created from a SQL query.
    
    
    # Retrieve useful metadata from the Dataset object:
    NYC_trips_info = NYC_trips.get_location_info().get('info', {})
    # Get the name of the dataiku.Dataset's underlying Databricks table:
    trips_table_name = NYC_trips_info.get('table')
    # Get the table's schema and catalog names:
    trips_table_schema = NYC_trips_info.get('schema')
    trips_table_catalog = NYC_trips_info.get('catalog')
    # Combine all this information to create the DataFrame via SQL:
    df_trips = session.sql(f"select * from {trips_table_catalog}.{trips_table_schema}.{trips_table_name}")
    

Unlike Pandas DataFrames, Pyspark DataFrames are lazily evaluated. This means that they, and any subsequent operation applied to them, are not immediately executed.

Instead, they are recorded in a Directed Acyclic Graph (DAG) that is evaluated only upon the calling of certain methods (`collect()`, `take()`, `show()`, `toPandas()`) or when writing out the dataframe produced by the chain of operations (`write.saveAsTable()`).

This lazy evaluation minimizes traffic between the Databricks cluster and the client as well as client-side memory usage.

## Retrieving rows

  * The `take(n)` method is a method that allows users to pull and check **n** rows from the Pyspark DataFrame. Yet, it is arguably not the most pleasant way of checking a DataFrame’s content.



    
    
    # Retrieve 5 rows
    df_trips.take(5)
    

  * The `toPandas()` method converts the Pyspark DataFrame into a more aesthetically-pleasing Pandas DataFrame. Avoid using this method if the data is too large to fit in memory. Alternatively, you can use a limit statement before retrieving the results as a Pandas DataFrame.



    
    
    df_trips.limit(5).toPandas()
    

## Common operations

The following paragraphs illustrate a few examples of basic data manipulation using DataFrames:

### Selecting column(s)

Databricks is case-insensitive w.r.t. identifiers (column names, table names, …). Using the `select` method returns a DataFrame:
    
    
    from pyspark.sql.functions import col
    
    fare_amount = df_trips.select([col('fare_amount'),col('tip_amount')])
              
    # Shorter equivalent version:
    fare_amount = df_trips.select(['fare_amount','tip_amount'])
    

### Computing the average of a column

Collect the mean `fare_amount`. This returns a 1-element list of type `snowflake.snowpark.row.Row`:
    
    
    from pyspark.sql.functions import mean
    
    avg_row = df_trips.select(mean(col('fare_amount'))).collect()
    avg_row
    

You can access the value as follows:
    
    
    avg = avg_row[0].asDict().get('avg(fare_amount)')
    

### Creating a new column from a case expression

Leverage the `withColumn()` method to create a new column indicating whether a trip’s fare was above average. That new column is the result of a case expression (`when()` and `otherwise()`):
    
    
    from pyspark.sql.functions import when
    
    df_trips = df_trips.withColumn('cost', when(col('fare_amount') > avg, "high")\
           .otherwise("low"))
    
    # Check the first five rows
    df_trips.select(['cost', 'fare_amount']).take(5)
    

### Joining two tables

The `NYC_trips` contains a pick up and drop off location id (_PULocationID_ and _DOLocationID_). We can map those location ids to their corresponding zone names using the `NYC_zones` Dataset.

To do so, perform two consecutive joins on the _OBJECTID_ column in the NYC zone Dataset.
    
    
    # Get the NYC_zones Dataset object
    NYC_zones = dataiku.Dataset("NYC_zones")
    df_zones = dbc.get_dataframe(NYC_zones)
    
    df_zones.toPandas()
    

Finally, perform the two consecutive left joins. Note how you are able to chain different operations including `withColumnRenamed()` to rename the _zone_ column and `drop()` to remove other columns from the `NYC_zones` Dataset:
    
    
    df = df_trips.join(df_zones, col('PULocationID')==col('LocationID'))\
            .withColumnRenamed('zone', 'pickup_zone')\
            .drop('LocationID', 'PULocationID', 'borough', 'service_zone')\
            .join(df_zones, col('DOLocationID')==col('LocationID'))\
            .withColumnRenamed('zone', 'dropoff_zone')\
            .drop('LocationID', 'DOLocationID', 'borough', 'service_zone')
    

### Group By

Count the number of trips by pickup zone among expensive trips. Use the `filter()` method to remove cheaper trips. Then use the `groupBy()` method to group by _pickup_zone_ , `count()` the number of trips and `sort()` them by descending order. Finally, call the `toPandas()` method to store the results of the group by as a Pandas DataFrame.
    
    
    results_count_df = df.filter((col('cost')=="low"))\
      .groupBy(col('pickup_zone'))\
      .count()\
      .sort(col('count'), ascending=False)\
      .toPandas()
    
    results_count_df
    

## User Defined Functions (UDF)

Databricks Connect can use UDFs like regular Pyspark.

A [User Defined Functions (UDF)](<https://archive.apache.org/dist/spark/docs/3.1.2/api/python/reference/api/pyspark.sql.functions.udf.html>) is a function that, for a single row, takes the values of one or several cells from that row, and returns a new value.

UDFs effectively allow users to transform data using custom complex logic beyond what’s possible in pure SQL. This includes the use of any Python packages.

To be used, UDFs first need to be _registered_ so that at execution time they can be properly sent to the Snowflake servers. In this section, you will see a simple UDF example and how to register it.

### Registering a UDF

  * The first option to register a UDF is to use either the [`register()`](<https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/api/snowflake.snowpark.udf.UDFRegistration.register.html#snowflake.snowpark.udf.UDFRegistration.register>) or the [`udf()`](<https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/api/snowflake.snowpark.functions.udf.html#snowflake.snowpark.functions.udf>) function. In the following code block is a simple UDF example that computes the tip percentage over the taxi ride total fare amount:



    
    
    from pyspark.sql.functions import udf
    from pyspark.sql.types import FloatType
    
    def get_tip_pct(tip_amount, fare_amount):
        return tip_amount/fare_amount
    
    # Register with register()
    get_tip_pct_udf = session.udf.register('get_tip_pct_udf', get_tip_pct, FloatType())
    
    # Register with udf() 
    get_tip_pct_udf = udf(get_tip_pct, FloatType())
    
    

  * An alternative way of registering the `get_tip_pct()` function as a UDF is to decorate your function with `@udf` . If you choose this way, you will need to specify the input and output types directly in the Python function.



    
    
    @udf(returnType=FloatType())
    def get_tip_pct(tip_amount:float, fare_amount:float) -> float:
        return tip_amount/fare_amount
    
    

### Applying a UDF

Now that the UDF is registered, you can use it to generate new columns in your DataFrame using `withColumn()`:
    
    
    df = df.withColumn('tip_pct', get_tip_pct_udf(col('tip_amount'), col('fare_amount') ))
    

After running this code, you should be able to see that the _tip_pct_ column was created in the `df` DataFrame.

## Advanced UDFs

UDfs can be simple Python code, not relying on any external package, or on base Python packages, but the real value comes from using complex packages. In the end, this is akin to using Spark as a resilient parallelization engine.

We’ll make an example by running [Spacy](<https://spacy.io/usage/linguistic-features>) part-of-speech abilities on the IMBD reviews dataset.

### Package setup

Using special packages comes with a price, though, in that packages must be installed in the Databricks cluster nodes. To that effect, use the [Libraries](<https://docs.databricks.com/libraries/cluster-libraries.html>) of your cluster to install libraries, each one a Pypi package:

  * `spacy==3.6.0`

  * `https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.6.0/en_core_web_sm-3.6.0.tar.gz`




On the Dataiku side, if you have properly fulfilled the tutorial prerequisites then you should be all set.

### Define UDF with imports

Since`spacy` is installed in the code environment, you can run in the notebook the example from Spacy’s tutorial:
    
    
    import spacy
    
    nlp = spacy.load("en_core_web_sm")
    for token in nlp("Apple is looking at buying U.K. startup for $1 billion"):
        print("%s\t%s" % (token.pos_, token.text))
    

We can use some UDF magic to apply this to each row of a Pyspark Dataframe, but there’s a catch: the `spacy.load()` function shouldn’t be called for each row processed, as it’s too slow, nor can the `nlp` object (the Spacy model handle) be created outside the UDF’s body and copied to the Databricks cluster. This implies using a global variable to store the model on the cluster-side.
    
    
    import spacy, json
    from pyspark.sql.types import StringType
    NLP = None
    @udf(returnType=StringType())
    def part_of_speech(input_text):
        global NLP
        if NLP is None:
            NLP = spacy.load("en_core_web_sm")
        poses = [token.pos_ for token in NLP(input_text)]
        return json.dumps(poses)
    

This can then be applied to our IMDB reviews dataset.
    
    
    df_imdb = dbc.get_dataframe(dataiku.Dataset("IMDB_train"))
    df_imdb = df_imdb.withColumn("partOfSpeech", part_of_speech(col('text')))
    df_imdb.limit(5).toPandas()
    

## Writing a DataFrame into a Databricks Dataset

In a Python recipe, you will likely want to write a Pyspark DataFrame into a Databricks output dataset. We recommend using the `write_with_schema()` method of the `DkuDBConnect` class. This method runs the [`saveAsTable()`](<https://archive.apache.org/dist/spark/docs/3.1.2/api/python/reference/api/pyspark.sql.DataFrameWriter.saveAsTable.html>) Pyspark method to save the contents of a DataFrame into a Databricks table.
    
    
    ouput_dataset = dataiku.Dataset("my_output_dataset")
    dbc.write_with_schema(ouput_dataset, df)
    

Warning

You should avoid converting a Pyspark DataFrame to a Pandas DataFrame before writing the output Dataset. In the following example, using the `toPandas()` method will create the Pandas DataFrame locally, further increasing memory usage and potentially leading to resource shortage issues.
    
    
    ouput_dataset = dataiku.Dataset("my_output_dataset")
    # Load the ENTIRE DataFrame in memory (NOT optimal !!)
    ouput_dataset.write_with_schema(df.toPandas())
    

## Wrapping up

Congratulations, you now know how to work with Databricks Connect within Dataiku! To go further, here are some useful links:

  * [Dataiku reference documentation on the Databricks Connect integration](<https://doc.dataiku.com/dss/latest/connecting/sql/databricks.html#databricks-connect-integration>)

  * [Pyspark reference](<https://spark.apache.org/docs/latest/api/python/reference/index.html>)

---

## [tutorials/data-engineering/index]

# Data Engineering  
  
The tutorials of this section aim at teaching the user on advanced use-cases for data preparation and feature engineering.

---

## [tutorials/data-engineering/mostly-ai-synthetic-data/index]

# Leveraging MOSTLY AI for Synthetic Data Generation

Using MOSTLY AI within Dataiku, you can generate a synthetic dataset by following this tutorial.

## Prerequisites

  * A MOSTLY AI account with an API Key. You can sign up for a free account at [MOSTLY.ai](<https://www.mostly.ai>).

  * Python 3.9

  * A [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)") with the following packages:
        
        mostlyai
        




Note

To know more about `mostlyai` and its installation, please see [`mostlyai`](<https://mostly.ai/docs/python-sdk>).

## Who is MOSTLY AI?

MOSTLY AI pioneered the creation of synthetic data for AI model development. Datasets generated by the MOSTLY AI platform look as real as a company’s original customer data with just as many details, but without the original personal data points – helping companies comply with privacy protection regulations such as GDPR and CCPA and ensuring that models are fair and unbiased.

  * [MOSTLY AI Python SDK documentation](<https://mostly.ai/docs/python-sdk>)




## Creating a Session

First, initialize a MOSTLY AI client session. Later, you will use the session to train a generator and create a synthetic dataset.
    
    
    # initialize the MOSTLY client
    from mostlyai import MostlyAI
    
    mostly = MostlyAI(
        api_key='REPLACE_WITH_YOUR_MOSTLY_API_KEY', 
        base_url='https://app.mostly.ai'
    )
    

## Loading data into a DataFrame

Load a dataset to train a generator model later. You can use any dataset that you have available in your Dataiku project. Here, we use a US Census Income dataset.
    
    
    # load a Dataiku dataset as a Pandas DataFrame
    us_census_income = dataiku.Dataset("us_census_income")
    us_census_income_df = mydataset.get_dataframe()
    

## Training a Generator

We train a generator on our dataset, which is used in the next step to generate synthetic data.
    
    
    # train a generator - for model creators
    g = mostly.train(data=us_census_income_df, start=True, wait=True)
    

## Generating a Synthetic Dataset

We use the generator trained in the previous step to create a synthetic dataset.
    
    
    # use generator to create a synthetic dataset - for data consumers
    sd = mostly.generate(g, size=200)
    synth_df = sd.data()
    

## Writing a DataFrame to Dataiku dataset

Lastly, write the DataFrame to a dataset to be used within your Dataiku Flow.
    
    
    # write the synthetic df to a Dataiku dataset
    output = dataiku.Dataset("synth_census_data")
    output.write_with_schema(synth_df)

---

## [tutorials/data-engineering/sessionization/index]

# Sessionization in SQL, Hive, and Python

Sessionization is the act of turning event-based data into [sessions](<https://en.wikipedia.org/wiki/Session_\(web_analytics\)>), the ordered list of a user’s actions in completing a task. It’s widely used in several domains, such as:

  * Web analytics:

A session tracks all of a user’s actions during a single visit to a website, such as a buying process on an e-commerce site.

Analyzing these sessions provides crucial insights into user behavior, including common purchase paths, site navigation, exit points, and the effectiveness of various acquisition funnels.

  * Trip analytics:

Given the GPS coordinates history of a vehicle, you can compute sessions to extract the different trips.

Each trip can then be labeled distinctly (e.g., user going to work, on holidays, etc.).

  * Predictive maintenance:

A session can encompass all the information related to a machine’s behavior (working, idle, etc.) until a change in its assignment occurs.




Given a user ID or machine ID, the question is: how can we recreate sessions? Or more precisely, how do we choose the boundaries of a session?

The third example defines a new session when the assignment changes. If we examine the first two examples, however, we see that we can define a new session if the user has been inactive for a certain amount of time, _T_.

In this case, a session is defined by two things: a user ID and a threshold time. If the subsequent action occurs within a time range greater than _T_ , it marks the start of a new session. This threshold can depend on the website constraints themselves.

## Prerequisites

  * An SQL database that supports window functions, such as PostgreSQL.

  * An HDFS connection for Hive.

  * An SQL Dataset named `toy_data`. You can create this Dataset by uploading this [`CSV file`](<../../../_downloads/ceed9528e162cdfbf6cb1c3232cd1163/toy_data.csv>) and using a **Sync recipe** to store the data in an SQL connection.




## Preparing the data

Coming from a CSV, the `mytimestamp` column of the `toy_data` dataset is currently stored as a string. To tackle sessionization, we want it stored as a date.

  1. Create a **Prepare** recipe with `toy_data` as the input.

  2. Store the output into your SQL database and create the recipe.

  3. Parse the `mytimestamp` column as a date into a new column.

  4. Delete the original and rename the parsed date column as `mytimestamp`.

  5. Run the recipe and update the schema.




On opening the synced output dataset, recognize that:

  * It’s sorted by time.

  * There are two different users.

  * `mytimestamp` is stored as a date.




Note

For more information on syncing datasets to SQL databases, please see this course on [Dataiku & SQL](<https://academy.dataiku.com/dataiku-dss-sql-1>).

## Sessionization in SQL

The objective is to identify the row in the ordered dataset where a new session begins. To do that, we need to calculate the interval between two rows of the same user. The SQL window function `LAG()` does it for us:

  1. Create a **new SQL notebook** on the `toy_data_prepared` dataset.

  2. Create a new query.

  3. Use the tables tab on the left to confirm the name of your table.

  4. If using the starter project, directly copy the snippet below to calculate a `time_interval` column.

  5. Click **Run** to confirm the result.



    
    
    SELECT *
        ,  EXTRACT(EPOCH FROM mytimestamp)
           - LAG(EXTRACT(EPOCH FROM mytimestamp))
           OVER (PARTITION BY user_id ORDER BY mytimestamp) AS time_interval
    FROM "DKU_SESSIONIZATION_toy_data_prepared";
    

This SQL query outputs a new column that is the difference between the timestamp of the current row and the previous one, by `user_id`. Note that the first appearance of a user contains a row with an empty time interval, as the calculation cannot produce a value.

Based on this interval, we will now flag each session of a given user. Assuming 30 minutes of inactivity defines a new session, we can slightly transform the previous expression into this one:
    
    
    SELECT *
      , CASE
          WHEN EXTRACT(EPOCH FROM mytimestamp)
               - LAG(EXTRACT(EPOCH FROM mytimestamp))
               OVER (PARTITION BY user_id ORDER BY mytimestamp) >= 30 * 60
          THEN 1
          ELSE 0
        END as new_session
    FROM
      "DKU_SESSIONIZATION_toy_data_prepared";
    

This query creates a Boolean column, where a value of 1 indicates a new session and zero otherwise.

Finally, we can create a cumulative sum over this Boolean column to create a `session_id`. To make it easier to visualize, we can concatenate it with the `user_id`, and then build our final `session_id` column:
    
    
    SELECT *
      , user_id || '_' || SUM(new_session)
      OVER (PARTITION BY user_id ORDER BY mytimestamp) AS session_id
    FROM (
      SELECT *
        , CASE
           WHEN EXTRACT(EPOCH FROM mytimestamp)
              - LAG(EXTRACT(EPOCH FROM mytimestamp))
                OVER (PARTITION BY user_id ORDER BY mytimestamp) >= 30 * 60
           THEN 1
           ELSE 0
          END as new_session
        FROM
          "DKU_SESSIONIZATION_toy_data_prepared"
    ) s1
    

We finally have our sessionized data! We can now move towards more advanced analytics and derive new KPIs.

Note that this code is enough for this simple example. However, if we had a large partitioned Hive table, a simple increment may not be enough (because we would have collisions for each partition). In this case, it’s possible to concatenate the user ID with the epoch of the first row of the session. You can perform the concatenation by calculating the first timestamp of each session and joining it on the previously calculated `session_id`.

## Sessionization in Hive

If your data is stored in Hadoop (HDFS), and you can use [Hive](<https://hive.apache.org/>) (and a version >= 0.11, where window partitioning functions were introduced), creating sessions will be similar to how you did in the previous PostgreSQL example. To make it work, ensure that your timestamp column has been serialized as “Hive” in your Dataiku dataset (in Dataset > Settings > Preview).

  1. Copy the existing Prepare recipe.

  2. Name the output `toy_data_hdfs`.

  3. Store it in an HDFS connection.

  4. Make sure the format is “CSV (Hive compatible)”.

  5. Create and run the recipe.

  6. In a Hive notebook on the output dataset, run the following query, adjusting the connection name as needed.



    
    
    SELECT *
        , CONCAT(user_id,
           CONCAT('_',
            SUM(new_session) OVER (PARTITION BY user_id ORDER BY mytimestamp)
           )
          ) AS session_id
    FROM (
        SELECT *
            , CASE
                WHEN UNIX_TIMESTAMP(mytimestamp)
                     - LAG (UNIX_TIMESTAMP(mytimestamp))
                     OVER (PARTITION BY user_id ORDER BY mytimestamp) >= 30 * 60
                THEN 1
                ELSE 0
              END AS new_session
        FROM `connection_name`.`toy_data_hdfs`
    ) s1
    

## Sessionization in Python

You can also build sessions using Python. There are several ways to do it, ranging from a pure Python implementation to reproducing the logic above using the [pandas](<https://pandas.pydata.org/>) library, which is what we will demonstrate here.

In a Python notebook, use the following snippet.
    
    
    import dataiku
    import pandas as pd
    from datetime import timedelta
    
    # define threshold value
    T = timedelta(seconds=30*60)
    
    # load dataset
    toy_data = dataiku.Dataset("toy_data_prepared").get_dataframe()
    
    # add a column containing previous timestamp
    toy_data =  pd.concat([toy_data,
                           toy_data.groupby('user_id').transform(lambda x:x.shift(1))]
                          ,axis=1)
    toy_data.columns = ['user_id','mytimestamp','prev_mytimestamp']
    
    # create the new session column
    toy_data['new_session'] = ((toy_data['mytimestamp'] - toy_data['prev_mytimestamp'])>=T).astype(int)
    
    # create the session_id
    toy_data['increment'] = toy_data.groupby("user_id")['new_session'].cumsum()
    toy_data['session_id'] = toy_data['user_id'].astype(str) + '_' + toy_data['increment'].astype(str)
    
    # to get the same result as with hive/postgresql
    toy_data = toy_data.sort_values(['user_id','mytimestamp'])
    

The output of this code should give you the sessionized dataset similar to the previous example. We can see that the `shift()` function is equivalent to `LAG()` in PostgreSQL, and `transform()` to a window function.

## Wrapping Up

Congratulations, you are now able to detect and mark sessions within your data, using SQL, Hive, or Python.

## Reference documentation

### Classes

[`dataiku.Dataset`](<../../../api-reference/python/datasets.html#dataiku.Dataset> "dataiku.Dataset")(name[, project_key, ignore_flow]) | Provides a handle to obtain readers and writers on a dataiku Dataset.  
---|---  
  
### Functions

[`get_dataframe`](<../../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe")([columns, sampling, ...]) | Read the dataset (or its selected partitions, if applicable) as a Pandas dataframe.  
---|---

---

## [tutorials/data-engineering/snowpark-basics/index]

# Using Snowpark Python in Dataiku: basics

This tutorial provides a comprehensive guide on using Snowpark Python within Dataiku, specifically focusing on integrating with Snowflake for data manipulation. It describes the process of importing and syncing datasets and illustrates the functionality of Snowpark DataFrames and Pandas on Snowflake through practical examples. Users will learn how to create a Snowpark session, load data, and perform data transformations efficiently.

## Prerequisites

  * Dataiku >= 10.0.7

  * A [Snowflake connection](<https://doc.dataiku.com/dss/latest/connecting/sql/snowflake.html#snowflake>) with write access.

  * A python 3.9, 3.10, or 3.11 [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html>) with the [`snowflake-snowpark-python`](<https://docs.snowflake.com/en/developer-guide/snowpark/python/setup.html#installation-instructions>) package installed

  * If using Pandas on Snowflake, install the `snowflake-snowpark-python` package with `modin`, like this: `snowflake-snowpark-python[modin]`




## Import Taxi Data

Download two datasets from the New York City government, [Taxi Zone Lookup Table](<https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv>) (`taxi_zone_lookup.csv`) and [2024 December Yellow Taxi Trip Records](<https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-12.parquet>) (`yellow_tripdata_2024-12.parquet`). For more information on this data, please refer to the NYC government [website](<https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page>).

Upload these datasets to a Dataiku project. You’ll need spark enabled on your Dataiku instance to read the parquet file. If you do not have spark enabled, you can use a parquet to csv converter tool like this one from [TabLab](<https://www.tablab.app/parquet/to/csv>).

Use a Sync recipe to sync these uploaded files to Snowflake datasets. In this tutorial, we named these Snowflake datasets `NYC_zones` and `NYC_trips`, respectively.

## What is Snowpark?

Snowpark is a set of libraries for programmatically accessing and processing data in Snowflake using languages like Python, Java, or Scala. It allows the user to manipulate `Snowpark DataFrames` similar to PySpark, and `Snowpark Pandas DataFrames (with Modin)` similar to Pandas. The [Snowflake documentation](<https://docs.snowflake.com/en/developer-guide/snowpark/index.html>) provides more details on how Snowpark works under the hood.

In this tutorial, we will work with the `NYC_trips` and `NYC_zones` Datasets to discover a few features of the Snowpark Python API, including Pandas on Snowflake, and how they can be used within Dataiku to:

  * Facilitate reading and writing Snowflake Datasets.

  * Perform useful/common data transformation.

  * Leverage User Defined Functions (UDFs).




We will start by creating a Snowpark session and then split the tutorial into dataset operations using 1) Snowpark DataFrame APIs and 2) Pandas on Snowflake APIs.

Snowpark DataFrames and Snowpark Pandas DataFrames with Modin work differently. For more information, please refer to the Snowflake [documentation](<https://docs.snowflake.com/en/developer-guide/snowpark/python/pandas-on-snowflake>).

## Import Python packages

Import the necessary dataiku and Snowpark packages:
    
    
    import dataiku
    from dataiku.snowpark import DkuSnowpark
    

If using Pandas on Snowflake, import the modin packages too:
    
    
    import modin.pandas as pd
    import snowflake.snowpark.modin.plugin
    

## Create a Session

Whether using Snowpark Python in a Python recipe or notebook, we’ll first need to create a Snowpark Session.

A [Session](<https://docs.snowflake.com/developer-guide/snowpark/reference/python/latest/api/snowflake.snowpark.Session>) object is used to establish a connection with a Snowflake database. Normally, this Session would need to be instantiated with the user manually providing credentials such as the user id and password. However, the `get_session()` method reads all the necessary parameters from the Snowflake connection in Dataiku and thus exempts the user from having to handle credentials manually.

Start by creating a Jupyter notebook with the code environment mentioned in the prerequisites and instantiate a Session object:
    
    
    sp = DkuSnowpark()
    # Replace with the name of your Snowflake connection
    session = sp.get_session(connection_name="YOUR-CONNECTION-NAME")
    

Snowpark DataFramesPandas on Snowflake (with Modin)

## Load data into a Snowpark DataFrame

There are multiple ways to load data from a Snowflake table into a Snowpark DataFrame object.

### Option 1: with the Dataiku API

The easiest way to query a Snowpark DataFrame is by using the [`get_dataframe()`](<../../../api-reference/python/snowpark.html#dataiku.snowpark.DkuSnowpark.get_dataframe> "dataiku.snowpark.DkuSnowpark.get_dataframe") method and passing a [`Dataset`](<../../../api-reference/python/datasets.html#dataiku.Dataset> "dataiku.Dataset") object. The [`get_dataframe()`](<../../../api-reference/python/snowpark.html#dataiku.snowpark.DkuSnowpark.get_dataframe> "dataiku.snowpark.DkuSnowpark.get_dataframe") can optionally be given a Snowpark Session argument. Dataiku will use the `session` created above or create a new one if no argument is passed.
    
    
    NYC_trips = dataiku.Dataset("NYC_trips")
    snowpark_df_trips = sp.get_dataframe(dataset=NYC_trips)
    

Here is the same example using a specific Snowpark `session`:
    
    
    NYC_trips = dataiku.Dataset("NYC_trips")
    snowpark_df_trips = sp.get_dataframe(dataset=NYC_trips, session=session)
    print("Trips table # rows: " + str(snowpark_df_trips.count()))
    

### Option 2: with a SQL query

Using the `session` object, a DataFrame can be created from a SQL query.
    
    
    # Get the name of the dataiku.Dataset's underlying Snowflake table.
    trips_table_name = NYC_trips.get_location_info().get('info', {}).get('quotedResolvedTableName')
    snowpark_df_trips = session.sql(f"Select * from {trips_table_name}")
    print("Trips table # rows: " + str(snowpark_df_trips.count()))
    

## Pandas DataFrames vs Snowpark DataFrames

Unlike DataFrames, Snowpark DataFrames are lazily evaluated. This means that they, and any subsequent operation applied to them, are not immediately executed.

Instead, they are recorded in a Directed Acyclic Graph (DAG) that is evaluated only upon the calling of certain methods.

Some methods that trigger eager evaluation: `collect()`, `take()`, `show()`, `toPandas()`

This lazy evaluation minimizes traffic between the Snowflake warehouse and the client as well as client-side memory usage.

## Retrieving rows

  * The `take(n)` method is the only method that allows users to pull and check **n** rows from the Snowpark DataFrame. Yet, it is arguably not the most pleasant way of checking a DataFrame’s content.



    
    
    # Retrieve 5 rows
    snowpark_df_trips.take(5)
    

  * The `toPandas()` method converts the Snowpark DataFrame into a more aesthetically-pleasing Pandas DataFrame. Avoid using this method if the data is too large to fit in memory. Instead, leverage the [`to_pandas_batches()`](<https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/latest/api/snowflake.snowpark.DataFrame.to_pandas_batches>) method. Alternatively, we can use a limit statement before retrieving the results as a Pandas DataFrame.



    
    
    snowpark_df_trips.limit(5).toPandas()
    

## Common operations

The following paragraphs illustrate a few examples of basic data manipulation using DataFrames:

### Selecting column(s)

Snowflake stores unquoted column names in uppercase. Be sure to use double quotes for case-sensitive column names. Using the `select` method returns a DataFrame:
    
    
    from snowflake.snowpark.functions import col
    
    fare_amount = snowpark_df_trips.select([col('"fare_amount"'),col('"tip_amount"')])
              
    # Shorter equivalent version:
    fare_amount = snowpark_df_trips.select(['"fare_amount"','"tip_amount"'])
    print(fare_amount)
    

### Computing the average of a column

Collect the mean `fare_amount`. This returns a 1-element list of type `snowflake.snowpark.row.Row`:
    
    
    from snowflake.snowpark.functions import mean
    
    avg_row = snowpark_df_trips.select(mean(col('"fare_amount"'))).collect()
    print(avg_row)
    

We can access the value as follows:
    
    
    avg = avg_row[0].asDict().get('AVG("FARE_AMOUNT")')
    print(avg)
    

### Creating a new column from a case expression

Leverage the `withColumn()` method to create a new column indicating whether a trip’s fare was above average. That new column is the result of a case expression (`when()` and `otherwise()`):
    
    
    from snowflake.snowpark.functions import when
    
    snowpark_df_trips = snowpark_df_trips.withColumn('"cost"', when(col('"fare_amount"') > avg, "high")\
                                                    .otherwise("low"))
    
    # Check the first five rows
    snowpark_df_trips.select(['"cost"', '"fare_amount"']).take(5)
    

### Joining two tables

First, read in the `NYC_zones` Dataset as a Snowpark DataFrame.
    
    
    import pandas as pd
    
    # Get the NYC_zones Dataset object
    NYC_zones = dataiku.Dataset("NYC_zones")
    snowpark_df_zones = sp.get_dataframe(NYC_zones)
    
    # Print out a few rows from the zones table
    snowpark_df_zones.toPandas().head()
    

The `NYC_trips` Dataset contains a pick up and drop off location id (`PULocationID` and `DOLocationID`). We can map those location ids to their corresponding zone names in the `NYC_zones` Dataset to get more helpful pick up and drop off zone names.

Next, let’s perform the two consecutive left joins. Note how we’re able to chain different operations including `withColumnRenamed()` to rename the `Zone` and `service_zone` columns and `drop()` to remove other columns from the `NYC_zones` Dataset:
    
    
    snowpark_df_merged = snowpark_df_trips.join(snowpark_df_zones, col('"PULocationID"')==col('"LocationID"'))\
        .withColumnRenamed(col('"Zone"'), '"pickup_zone"')\
        .withColumnRenamed(col('"service_zone"'), '"pickup_service_zone"')\
        .drop([col('"LocationID"'), col('"PULocationID"'), col('"Borough"')])\
        .join(snowpark_df_zones, col('"DOLocationID"')==col('"LocationID"'))\
        .withColumnRenamed(col('"Zone"'), '"dropoff_zone"')\
        .withColumnRenamed(col('"service_zone"'), '"dropoff_service_zone"')\
        .drop([col('"LocationID"'), col('"DOLocationID"'),col('"Borough"')])
    
    # Print out a few rows from the merged DataFrame
    snowpark_df_merged.toPandas().head()
    

### Group By

Count the number of trips by pick up zone among expensive trips. Use the `filter()` method to remove cheaper trips. Then use the `groupBy()` method to group by `pickup_zone`, `count()` the number of trips and `sort()` them by descending order. Finally, call the `toPandas()` method to store the results of the group by as a Pandas DataFrame.
    
    
    results_count_df = snowpark_df_merged.filter((col('"cost"')=="low"))\
      .groupBy(col('"pickup_zone"'))\
      .count()\
      .sort(col('"COUNT"'), ascending=False)
    
    # Print out a few rows from the merged DataFrame
    results_count_df.toPandas().head()
    

## User Defined Functions (UDF)

A [User Defined Functions (UDF)](<https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/latest/api/snowflake.snowpark.functions.udf>) is a function that, for a single row, takes the values of one or several cells from that row, and returns a new value.

UDFs effectively allow users to transform data using custom complex logic beyond what’s possible in pure SQL. This includes the use of any Python packages.

To be used, UDFs first need to be `registered` so that at execution time they can be properly sent to the Snowflake servers. In this section, we will see a simple UDF example and how to register it.

### Registering a UDF

  * The first option to register a UDF is to use either the [`register()`](<https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/latest/api/snowflake.snowpark.udf.UDFRegistration.register#snowflake.snowpark.udf.UDFRegistration.register>) or the [`udf()`](<https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/latest/api/snowflake.snowpark.functions.udf>) function. In the following code block is a simple UDF example that computes the tip percentage over the taxi ride total fare amount:



    
    
    from snowflake.snowpark.functions import udf
    from snowflake.snowpark.types import FloatType
    
    # Some fares are zero and below. Let's return zero if this is the case.
    def get_tip_pct(tip_amount, fare_amount):
        if fare_amount > 0:
            return tip_amount/fare_amount
        else:
            return 0.0
    
    # Register with register()
    get_tip_pct_udf = session.udf.register(get_tip_pct, input_types=[FloatType(), FloatType()], 
                         return_type=FloatType())
    
    # Register with udf() 
    get_tip_pct_udf = udf(get_tip_pct, input_types=[FloatType(), FloatType()], 
                         return_type=FloatType())
    

  * An alternative way of registering the `get_tip_pct()` function as a UDF is to decorate our function with `@udf` . If we choose this way, we’ll need to specify the input and output types directly in the Python function.



    
    
    @udf
    def get_tip_pct(tip_amount:float, fare_amount:float) -> float:
        if fare_amount > 0:
            return tip_amount/fare_amount
        else:
            return 0.0
    

### Applying a UDF

Now that the UDF is registered, we can use it to generate new columns in our DataFrame using `withColumn()`:
    
    
    snowpark_df_merged = snowpark_df_merged.withColumn('"tip_pct"', get_tip_pct_udf('"tip_amount"', '"fare_amount"' ))
    

After running this code, we should be able to see that the `tip_pct` column was created in the `snowpark_df_merged` DataFrame.

## Write a Snowpark DataFrame into a Snowflake Dataset

Note

You’ll first need to create a Snowflake dataset in your project flow to hold the output. Here, we’ve named this dataset `my_outut_dataset`. Dataiku automatically does this if you are using a Python recipe.

In a Python recipe, you will likely want to write Snowpark DataFrame into a Snowflake output Dataset. We recommend using the [`write_with_schema()`](<../../../api-reference/python/snowpark.html#dataiku.snowpark.DkuSnowpark.write_with_schema> "dataiku.snowpark.DkuSnowpark.write_with_schema") method of the [`DkuSnowpark`](<../../../api-reference/python/snowpark.html#dataiku.snowpark.DkuSnowpark> "dataiku.snowpark.DkuSnowpark") class. This method runs the [`saveAsTable()`](<https://docs.snowflake.com/developer-guide/snowpark/reference/python/latest/api/snowflake.snowpark.DataFrameWriter.saveAsTable#snowflake.snowpark.DataFrameWriter.saveAsTable>) Snowpark Python method to save the contents of a DataFrame into a Snowflake table.
    
    
    # Point to the output Dataset (a Snowflake table)
    ouput_dataset = dataiku.Dataset("my_output_dataset")
    # Write the Snowpark Dataframe to the output Snowflake table
    sp.write_with_schema(ouput_dataset, snowpark_df_merged)
    

Warning

Avoid converting a Snowpark Python DataFrame to a Pandas DataFrame before writing the output Dataset. In the following example, using the `toPandas()` method will create the Pandas DataFrame locally, further increasing memory usage and potentially leading to resource shortage issues.
    
    
    # Point to the output Dataset (a Snowflake table)
    ouput_dataset = dataiku.Dataset("my_output_dataset")
    # Load the ENTIRE DataFrame in memory (NOT optimal !!)
    ouput_dataset.write_with_schema(snowpark_df_merged.toPandas())
    

## Load data into a Snowpark Pandas DataFrame with Modin

There are multiple options to load data from a Snowflake table or Snowpark DataFrame into a Snowpark Pandas DataFrame with Modin.

### Option 1: with the Dataiku API

First, load a Snowflake table into a Snowpark DataFrame, then load into a Snowpark Pandas DataFrame with one additional line of code:
    
    
    NYC_trips = dataiku.Dataset("NYC_trips")
    snowpark_df_trips = sp.get_dataframe(dataset=NYC_trips)
    snowpark_pandas_df_trips = snowpark_df_trips.to_snowpark_pandas()
    

Here is the same example using a specific Snowpark `session`:
    
    
    NYC_trips = dataiku.Dataset("NYC_trips")
    snowpark_df_trips = sp.get_dataframe(dataset=NYC_trips, session=session)
    snowpark_pandas_df_trips = snowpark_df_trips.to_snowpark_pandas()
    

### Option 2: with the Snowpark Pandas API

Using the `session` object, create a Snowpark Pandas DataFrame with Modin using the standard Snowpark Pandas API.
    
    
    import modin.pandas as pd
    # pd.session is the session that Snowpark Pandas is using for new Modin DataFrames.
    # In this case we'll set it to be the Snowpark session we created earlier
    pd.session = session
    
    # Get the name of the dataiku.Dataset's underlying Snowflake table.
    trips_table_name = NYC_trips.get_location_info().get('info', {}).get('quotedResolvedTableName')
    snowpark_pandas_df_trips = pd.read_snowflake(trips_table_name)
    

## Pandas DataFrames vs Snowpark Pandas DataFrames (with Modin)

Unlike DataFrames, Snowpark Pandas DataFrames (with Modin) are lazily evaluated. This means that they, and any subsequent operation applied to them, are not immediately executed.

Instead, they are recorded in a Directed Acyclic Graph (DAG) that is evaluated only upon the calling of certain methods.

Some methods that trigger eager evaluation: `read_snowflake()`, `to_snowflake()`, `to_pandas()`, `to_dict()`, `to_list()`, `__repr__`

This lazy evaluation minimizes traffic between the Snowflake warehouse and the client and client-side memory usage.

## Retrieve rows

Just like with Pandas, we can use `head(n)` to retrieve the first n rows from the Snowpark Pandas DataFrame:
    
    
    # Retrieve 5 rows
    snowpark_pandas_df_trips.head(5)
    

## Common operations

The following paragraphs illustrate a few examples of basic data manipulation using Snowpark Pandas DataFrames:

### Select column(s)

We can pass a list of column names into square brackets to select column(s):
    
    
    fare_amount = snowpark_pandas_df_trips[['fare_amount','tip_amount']]
    print(fare_amount.head())
    

We can also use `.loc[]` on column names:
    
    
    fare_amount = snowpark_pandas_df_trips.loc[:, ['fare_amount', 'tip_amount']]
    

Or `.iloc[]` on column index positions:
    
    
    fare_amount = snowpark_pandas_df_trips.iloc[:, [2,4,8]]
    

### Compute the average of a column

Calculate the mean of the `fare_amount` column with `.mean()`:
    
    
    mean_fare_amount = snowpark_pandas_df_trips['fare_amount'].mean()
    print(mean_fare_amount)
    

### Create a new column from a where expression

We can use numpy’s `where()` method to create a new column indicating whether a trip’s fare was above average:
    
    
    import numpy as np
    
    snowpark_pandas_df_trips['cost'] = np.where(snowpark_pandas_df_trips['fare_amount'] >= mean_fare_amount, 'above', 'below')
    
    # Check the mean fare amount and the new column we just created
    print("Mean fare amount: " + str(mean_fare_amount))
    snowpark_pandas_df_trips[['fare_amount','cost']].head()
    

### Join two tables

First, read in the `NYC_zones` Dataset as a Snowpark Pandas DataFrame.
    
    
    # Get the NYC_zones Dataset object
    NYC_zones = dataiku.Dataset("NYC_zones")
    snowpark_df_zones = sp.get_dataframe(NYC_zones)
    snowpark_pandas_df_zones = snowpark_df_zones.to_snowpark_pandas()
    snowpark_pandas_df_zones.head()
    

The `NYC_trips` Dataset contains a pick up and drop off location id (`PULocationID` and `DOLocationID`). We can map those location ids to their corresponding zone names in the `NYC_zones` Dataset to get more helpful pick up and drop off zone names.

Next, let’s join the zones DataFrame to the trips DataFrame by the pick up location ID. We can chain different operations to the join to rename and drop columns:
    
    
    snowpark_pandas_df_merged = pd.merge(snowpark_pandas_df_trips, 
                         snowpark_pandas_df_zones, 
                         left_on='PULocationID', 
                         right_on='LocationID')\
                         .rename(columns={'Zone':'pickup_zone', 'service_zone':'pickup_service_zone'})\
                         .drop(['LocationID', 'PULocationID', 'Borough'], axis=1)
    

Then, let’s join the zones DataFrame again to the new merged DataFrame by the drop off location ID:
    
    
    snowpark_pandas_df_merged = pd.merge(snowpark_pandas_df_merged, 
                         snowpark_pandas_df_zones, 
                         left_on='DOLocationID', 
                         right_on='LocationID')\
                         .rename(columns={'Zone':'dropoff_zone', 'service_zone':'dropoff_service_zone'})\
                         .drop(['LocationID', 'DOLocationID', 'Borough'], axis=1)
    

We should see new `pickup_zone`, `pickup_service_zone`, `dropoff_zone`, and `dropoff_service_zone` columns.
    
    
    snowpark_pandas_df_merged.head()
    

### Group by aggregations

Count the number of trips by pick up zone with `groupby()`, `count()` the number of trips, and `sort_values()` to sort pick up zone counts in descending order.
    
    
    results_count_df = snowpark_pandas_df_merged.groupby("pickup_zone").size().sort_values(ascending=False)
    
    results_count_df
    

## Write a Snowpark Pandas DataFrame into a Snowflake Dataset

Note

You’ll first need to create a Snowflake dataset in your project flow to hold the output. Here, we’ve named this dataset `my_outut_dataset`. Dataiku automatically does this if you are using a Python recipe.

In a Python recipe, you will likely want to write a Snowpark Pandas DataFrame into a Snowflake output Dataset. We recommend first converting the Snowpark Pandas DataFrame back into a Snowpark DataFrame, then using the [`write_with_schema()`](<../../../api-reference/python/snowpark.html#dataiku.snowpark.DkuSnowpark.write_with_schema> "dataiku.snowpark.DkuSnowpark.write_with_schema") method of the [`DkuSnowpark`](<../../../api-reference/python/snowpark.html#dataiku.snowpark.DkuSnowpark> "dataiku.snowpark.DkuSnowpark") class. This method runs the [`saveAsTable()`](<https://docs.snowflake.com/developer-guide/snowpark/reference/python/latest/api/snowflake.snowpark.DataFrameWriter.saveAsTable#snowflake.snowpark.DataFrameWriter.saveAsTable>) Snowpark Python method to save the contents of a Snowpark DataFrame into a Snowflake table.
    
    
    # Convert the Snowpark Pandas DataFrame back to a Snowpark DataFrame
    output_snowpark_df = snowpark_pandas_df_merged.to_snowpark(index=False)
    # Point to the output Dataset (a Snowflake table)
    ouput_dataset = dataiku.Dataset("my_output_dataset")
    # Write the Snowpark Dataframe to the output Snowflake table
    sp.write_with_schema(ouput_dataset, output_snowpark_df)
    

## Wrapping up

Congratulations, you now know how to work with Snowpark Python DataFrames and Snowpark Pandas DataFrames within Dataiku! To go further, here are some useful links:

  * [Dataiku reference documentation on the Snowpark Python integration](<https://doc.dataiku.com/dss/latest/connecting/sql/snowflake.html#snowpark-integration>)

  * [Snowpark Python reference](<https://docs.snowflake.com/developer-guide/snowpark/reference/python/latest/index>)

  * [Pandas on Snowflake reference](<https://docs.snowflake.com/en/developer-guide/snowpark/python/pandas-on-snowflake>)

---

## [tutorials/data-engineering/spark-rapids/index]

# Using Spark RAPIDS on Dataiku

## Overview

This guide provides step-by-step instructions for setting up and configuring the **RAPIDS Accelerator for Apache Spark** (i.e., Spark RAPIDS) with **Dataiku** on an **Amazon EKS** cluster with GPU support. The setup enables GPU acceleration for Spark workloads, significantly improving performance for compatible operations.

Note

This guide assumes familiarity with Dataiku administration, Docker, and basic Kubernetes concepts.

You’ll need administrative access to your Dataiku instance and AWS environment.

## Prerequisites

  * Access to AWS with permissions to create and manage EKS clusters

  * Dataiku instance with administrative access

  * Docker installed and configured

  * SSH access to your Dataiku instance




## EKS Cluster Setup

### Requirements

  * EKS cluster with **NVIDIA GPU** support

  * Example instance types:

    * P4d EC2 instances

    * G4 EC2 instances




### Setup Instructions

  1. Follow the [Dataiku EKS Cluster Setup Guide](<https://doc.dataiku.com/dss/latest/containers/eks/index.html>) for initial cluster creation.

  2. Ensure NVIDIA GPU support is properly configured in your cluster.




## Building a Custom Spark Docker Image with RAPIDS

### Accessing the Dataiku Instance

  1. SSH into your Dataiku instance using the Terminal:
         
         ssh <user>@<your-instance-address>
         

Note

If you do not already have access, download `wget` using the command `sudo yum install wget` before proceeding to the next step.

  2. Sudo to the dataiku user and switch to the Dataiku user home directory (`/data/dataiku`)
         
         sudo -su dataiku
         




### Downloading Required Files

  3. Download the RAPIDS jar file:
         
         wget https://repo1.maven.org/maven2/com/nvidia/rapids-4-spark_2.12/25.02.0/rapids-4-spark_2.12-25.02.0.jar
         

Note

The link for the latest RAPIDS jar can be found at [Download | spark-rapids](<https://nvidia.github.io/spark-rapids/docs/download.html>)

  4. Download the GPU discovery script:
         
         wget -O getGpusResources.sh https://raw.githubusercontent.com/apache/spark/master/examples/src/main/scripts/getGpusResources.sh
         




### File Configuration

  5. Move the Rapids jar to the Dataiku Spark directory:
         
         cp rapids-4-spark_2.12-25.02.0.jar /opt/dataiku-dss-<YOUR VERSION>/spark-standalone-home/jars/
         

  6. Move the GPU discovery script to the Dataiku Spark directory:
         
         cp getGpusResources.sh /opt/dataiku-dss-<YOUR VERSION>/spark-standalone-home/bin/
         

  7. Make `getGpusResources.sh` executable:
         
         chmod +x /opt/dataiku-dss-<YOUR VERSION>/spark-standalone-home/bin/getGpusResources.sh
         




### Building the Docker Image

  8. Build the custom Spark image with CUDA support:
         
         dss_data/bin/dssadmin build-base-image \
           --type spark \
           --without-r \
           --build-from-image nvidia/cuda:12.6.2-devel-rockylinux8 \
           --tag <add_a_unique_name>
         




## Dataiku Spark Configuration

### Creating a Custom Configuration

  1. Navigate to the **Administration** panel in Dataiku.

  2. Select **Settings** > **Spark** configurations.

  3. Click the **\+ ADD ANOTHER CONFIG** button.




### Configuration Settings

Configure the following settings:

Setting | Value  
---|---  
Config name | `spark-rapids`  
Config keys | `Default spark configs on the container`  
Managed Spark-on-K8S | `Enabled`  
Image registry URL | `<your-registry>/spark-rapids`  
Image pre-push hook | `Enable push to ECR`  
Kubernetes namespace | `default`  
Authentication mode | `Create service accounts dynamically`  
Base image | `<Replace with your image tag name from Step 2h>`  
Managed cloud credentials | `Enabled`  
Provide AWS credential | `From any AWS connection`  
  
### Additional Parameters

Spark configuration parameters like these below can be used:
    
    
    spark.rapids.sql.enabled=true
    spark.rapids.sql.explain=NOT_ON_GPU
    

Note

Additional properties can be found at [Configuration | spark-rapids](<https://nvidia.github.io/spark-rapids/docs/configs.html>).

### Advanced Settings

Within **Advanced settings** > **Executor pod YAML** it is mandatory to include the GPU resource limits.
    
    
    spec:
      containers:
      - resources:
          limits:
            nvidia.com/gpu: 1
    

### Pushing the Base Image

  4. Click the **PUSH BASE IMAGES** button




## Congratulations!

You are now set up to begin using the Spark RAPIDS container.

## Best Practices

  * Regularly update Rapids jar and Delta Core to maintain compatibility

  * Monitor GPU utilization using NVIDIA tools

  * Back up configurations before making changes

  * Test the setup with a sample workload before production use




## Known Issues and Troubleshooting

### Missing GPU Resources Script

**Issue** : `getGpusResources.sh` file not found.

**Resolution** :
    
    
    wget https://raw.githubusercontent.com/apache/spark/master/examples/src/main/scripts/getGpusResources.sh
    mv getGpusResources.sh /opt/dataiku/spark/conf/
    chmod +x /opt/dataiku/spark/conf/getGpusResources.sh
    

### Delta Core ClassNotFoundException

**Issue** : Delta Core class not found during execution.

**Resolution** :

  1. Download the correct Delta Core JAR:
         
         wget https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.4.0/delta-core_2.12-2.4.0.jar
         

  2. Move it to the Spark jars directory:
         
         mv delta-core_2.12-2.4.0.jar /opt/dataiku/spark/jars/
         




### Shim Loader Exception

**Issue** : Version mismatch in Shim Loader - `java.lang.IllegalArgumentException: Could not find Spark Shim Loader for 3.4.1`

**Resolution** : Ensure compatibility between Rapids JAR and Spark versions

Important

Always verify version compatibility between Spark, Rapids, and Delta Core components before deployment.

### Spark Shuffle Manager

**Issue** :
    
    
    RapidsShuffleManager class mismatch (com.nvidia.spark.rapids.spark340.RapidsShuffleManager !=
    com.nvidia.spark.rapids.spark341.RapidsShuffleManager). Check that configuration
    setting spark.shuffle.manager is correct for the Spark version being used.
    

**Resolution** : Ensure that the correct shuffle manager is configured for the Spark version you are using. Mappings can be found in the [RAPIDS Shuffle Manager](<https://docs.nvidia.com/spark-rapids/user-guide/latest/additional-functionality/rapids-shuffle.html>)

## Additional Resources

  * [Dataiku Documentation](<https://doc.dataiku.com/>)

  * [NVIDIA Spark RAPIDS Documentation](<https://nvidia.github.io/spark-rapids/>)

  * [Apache Spark Documentation](<https://spark.apache.org/docs/latest/>)

---

## [tutorials/data-engineering/sql-in-code/index]

# Leveraging SQL in Python & R

Running SQL queries inside Python and R will help you build dynamic queries and run queries based on certain conditions. This gives you, as a coder, the control to know exactly what queries run in what specific situations. You can especially leverage this in the few examples laid out in this tutorial.

This can be initiated through Notebooks, Code Recipes, or Dash web-applications, and this tutorial focuses on all of these solutions, so you will be best suited to make a decision on when to leverage each of the solutions.

## Prerequisites

  * A Dataiku connection to a SQL database (or the possibility of creating one)

  * Have a Dataiku user profile with the following global permissions:

    * “Create projects”

    * “Write unisolated code”

    * [optional] “Create active Web content”

  * [optional] [R on Dataiku](<https://doc.dataiku.com/dss/latest/installation/custom/r.html>)

  * [optional] A code environment with python version >= 3.9 to install the `dash` package

  * [optional] Basic knowledge of dash




## Introduction

Structured Query Language (SQL) is a family of languages used to manage data held in relational databases. With SQL, Data practitioners or applications can efficiently insert, transform, and retrieve data.

Dataiku can translate visual recipes into the SQL syntax of the database that holds the data. This feature lets Dataiku users easily contribute to the development of efficient ETL pipelines without having to write a single line of SQL. Users can also chose to write SQL query or script recipes for more specific data processing.

Lesser known is the possibility for coders to inject SQL statements through the [`SQLExecutor2`](<https://doc.dataiku.com/dss/latest/python-api/sql.html>) module in Python, and the [`dkuSQLQueryToData`](<https://doc.dataiku.com/dss/api/10.0/R/dataiku/reference/dkuSQLQueryToData.html>) and [`dkuSQLExecRecipeFragment`](<https://doc.dataiku.com/dss/api/10.0/R/dataiku/reference/dkuSQLExecRecipeFragment.html>) functions in R. These functions are part of the Python and R dataiku internal package.

Using SQL in Python or R has three main advantages:

  1. The use of a programming language’s flexibility to generate SQL statements (e.g. dynamic queries).

  2. The possibility of further processing the result of a query direcly in Python or R.

  3. The use of the database’s engine.




In this tutorial, you’ll see how you can use Python or R to:

  1. Generate a dataframe from a SQL query in a Python or R notebook.

  2. Execute a SQL statement in a Python or R recipe.

  3. [Python Only] Use SQL in a Dash web app.




In this tutorial, you will get familiar with using SQL in Python or R by working with a modified sample of the notorious [New York City Yellow Cab data](<https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page>) and the [New York City zones data](<https://data.cityofnewyork.us/Transportation/NYC-Taxi-Zones/8meu-9t5y>). These datasets contain records from thousands of NYC yellow cab trips in 2020 and a lookup table for New York City neighborhood, respectively. See the Set Up section below for downloading instructions.

## Initial Set Up

In this section, you will take the necessary steps to have the two above-mentionned datasets ready in a SQL database.

### SQL connection on Dataiku

Important

For this tutorial, you will need a Dataiku connection to a SQL database.  
The examples in this tutorial were run on a PostgreSQL 11.14 connection named `pg`.  
However, any [supported databases](<https://doc.dataiku.com/dss/latest/connecting/sql/introduction.html#supported-databases>) should do (after potential modification of the SQL syntax shown in the code snippets).

If you have to create a new connection, please refer to our [documentation](<https://doc.dataiku.com/dss/latest/connecting/sql/index.html> "\(in Dataiku DSS v14\)") or this [tutorial](<https://knowledge.dataiku.com/latest/import-data/connections/sql/tutorial-index.html>). Note that you will either need to have admin access, or the right to create [personal connections](<https://doc.dataiku.com/dss/latest/security/connections.html> "\(in Dataiku DSS v14\)").

### Create your project and upload the datasets

  * Create a new project and name it `NYC Yellow Cabs`.

  * Download the [NYC_taxi_trips](<https://cdn.downloads.dataiku.com/public/website-additional-assets/code/NYC_taxi_trips.tar.gz>) and the [NYC_taxi_zones](<https://downloads.dataiku.com/public/website-additional-assets/code/NYC_taxi_zones.tar.gz>) datasets.

  * Upload those two datasets to your project. There is no need to decompress the datasets prior to uploading them.




### Build the two SQL datasets

Now use sync recipes to write both datasets to your sql connection. Name the output datasets `NYC_trips` and `NYC_zones`.

## Notebook examples

It’s time to explore both datasets in either a Python or R notebook.

  * In the top navigation bar, go to _< /> -> Notebooks_

  * Either create a Python or an R notebook (if R is available on your instance).




Copy and paste the following code. This code injects a string query to the database and collect the result as a dataframe:

Python
    
    
    import dataiku
    from dataiku.core.sql import SQLExecutor2
    
    dataset_trips = dataiku.Dataset("NYC_trips")
    
    # Instantiates the SQLExecutor2 class which takes the NYC dataset object as a parameter to retrieve the connection details of the dataset. An alternative is to use the `connection=pg` parameter.
    e = SQLExecutor2(dataset=dataset_trips) 
    
    # Get the name of the SQL table underlying the NYC_trips dataset. 
    table_name = dataset_trips.get_location_info().get('info', {}).get('quotedResolvedTableName')
    
    # Inject the query to the database and returns the result as a pandas dataframe.
    query = f"""SELECT * FROM {table_name} LIMIT 10""" 
    df = e.query_to_df(query)
    

R
    
    
    library(dataiku)
    
    # Get the name of the SQL table underlying the NYC_trips dataset.
    table_name_trips <- dkuGetDatasetLocationInfo("NYC_trips")$info$table
    
    query = sprintf('
    SELECT * FROM "%s" LIMIT 10
    ', table_name_trips)
    
    # Returns the result of the query as a dataframe. Also needs the connection name.
    df <- dkuSQLQueryToData(connection='pg', query=query) 
    

The above query may be simple, but it shows how Python or R give you the flexibility to generate any query string you want, potentially leveraging the results from other operations. Additionally, you can now analyze or further process the results of the query using one of the two programming languages.

Eeach row represents a trip. Trip duration is expressed in minutes and any amount in USD. The columns `PULocationID` and `DOLocationID` refers to the pickup and dropoff identifier of the NYC zones in the `NYC_zones` dataset Running a similar query on the zones dataset returns the following dataframe:

## Experiment with SQL Notebook

To calculate trips per borough, we’ll use the CASE expression.

For example, let’s use an SQL notebook to calculate the number of trips that start in Manhattan. Create a new SQL notebook on the `NYC_trips` and `NYC_zones` datasets.

In the Tables tab of the left panel, click the **+** next to the dataset to copy a query selecting all columns.

Be sure to adjust the tablename to match your instance, then run the query below:
    
    
    SELECT 
      SUM(CASE 
          WHEN z.borough = 'Manhattan' THEN 1 
          ELSE 0 
      END) AS manhattan_trips
    FROM "NYC_trips" t
    JOIN "NYC_zones" z ON t."PULocationID" = z."OBJECTID";
    

## Code recipe examples

You can also use SQL inside a Python or R recipe. If you don’t need to further transform the results of the query, there is no reason for you to load the results as a dataframe first. Why not be more efficient and run everything in database? You can rely on the [`exec_recipe_frament()`](<https://developer.dataiku.com/latest/api-reference/python/sql.html#dataiku.SQLExecutor2.exec_recipe_fragment>) method from the `SQLExecutor2` in Python or the [`dkuSQLExecRecipeFragment`](<https://doc.dataiku.com/dss/api/12/R/dataiku/reference/dkuSQLExecRecipeFragment.html>) function in R to store the result of the query directly into a SQL dataset on the _pg_ connection. For this to work, the output dataset must be a table within the same SQL connection.

Create a Python or R recipe that takes the `NYC_trips` and `NYC_zones` datasets as inputs, name the output dataset `NYC_trips_zones` and create it within the `pg` connection. Copy and paste the below code and run the recipe.

Python
    
    
    import dataiku
    from dataiku.core.sql import SQLExecutor2
    
    e = SQLExecutor2(connection='pg')
    
    zones_dataset = dataiku.Dataset("NYC_zones")
    table_name_zones = zones_dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
    taxi_dataset = dataiku.Dataset("NYC_trips")
    table_name_trips = taxi_dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
    
    query = f"""
    SELECT 
        "trips"."tpep_pickup_datetime" AS "tpep_pickup_datetime",
        "trips"."trip_duration" AS "trip_duration",
        "trips"."tpep_dropoff_datetime" AS "tpep_dropoff_datetime",
        "trips"."trip_distance" AS "trip_distance",
        "trips"."fare_amount" AS "fare_amount",
        "trips"."tip_amount" AS "tip_amount",
        "trips"."total_amount" AS "total_amount",
        "PUzones"."zone" AS "pu_zone",
        "DOzones"."zone" AS "do_zone"
      FROM {table_name_trips} "trips"
      LEFT JOIN {table_name_zones} "PUzones"
        ON "trips"."PULocationID" = "PUzones"."OBJECTID"
      LEFT JOIN {table_name_zones} "DOzones"
        ON "trips"."DOLocationID" = "DOzones"."OBJECTID"
    """
    
    nyc_trips_zones = dataiku.Dataset("NYC_trips_zones")
    
    # Pass the output dataset object in which to store the result of the query.
    e.exec_recipe_fragment(nyc_trips_zones, query)
    

R
    
    
    library(dataiku)
    
    table_name_zones <- dkuGetDatasetLocationInfo("NYC_zones")$info$table
    table_name_trips <- dkuGetDatasetLocationInfo("NYC_trips")$info$table
    
    query = sprintf('
    SELECT 
        "trips"."tpep_pickup_datetime" AS "tpep_pickup_datetime",
        "trips"."trip_duration" AS "trip_duration",
        "trips"."tpep_dropoff_datetime" AS "tpep_dropoff_datetime",
        "trips"."trip_distance" AS "trip_distance",
        "trips"."fare_amount" AS "fare_amount",
        "trips"."tip_amount" AS "tip_amount",
        "trips"."total_amount" AS "total_amount",
        "PUzones"."zone" AS "pu_zone",
        "DOzones"."zone" AS "do_zone"
      FROM "%s" "trips"
      LEFT JOIN "%s" "PUzones"
        ON "trips"."PULocationID" = "PUzones"."OBJECTID"
      LEFT JOIN "%s" "DOzones"
        ON "trips"."DOLocationID" = "DOzones"."OBJECTID"
    ', table_name_trips, table_name_zones, table_name_zones)
    
    # Pass the output dataset name in which to store the result of the query.
    dkuSQLExecRecipeFragment("NYC_trips_zones", query)
    

The query above demonstrates how to run the query directly on the database; however, it is also possible to run the query and load the result into memory. Of course, you will need to be careful when doing this, as you don’t want to load big datasets into memory. Below is the Python example of doing this.
    
    
    result = executor.query_to_df(query)
    
    output_dataset = dataiku.Dataset("NYC_trips_zones")
    output_dataset.write_with_schema(result)
    

Note

You could have performed this simple query using a visual join or a SQL recipe. The point here is to show you that you can use code to generate more complex SQL queries. In some instances, code is the most convenient way to write logic beyond what SQL constructs or visual recipes are capable of.

### Visualize the output

Now that your new dataset has been created using your Python or R code recipe you should validate it looks as you expect it. Return to the Flow, click your newly created `NYC_trips_zones` dataset, and click **Explore** to show your data. It should look like this.

## Dash webapp example

Most websites (or web applications) have to store and serve content. Whether it is to store customer login information, inventory lists or any data to be sent to the users, databases have become an essential part of a web application architecture.

You will now see how to use [`SQLExecutor2`](<https://doc.dataiku.com/dss/latest/python-api/sql.html>) in Dash webapp within Dataiku to visualize the count of trips over time in 2020 from and to user-specified locations.

### Create a Code Environment for your Dash app

  * In the top navigation bar, click the _Applications_ grid icon.

  * Click _Administration- >Code Envs->NEW PYTHON ENV_

  * Select `python>=3.9` (from PATH) and leave all other fields as is. Click create.

  * In _Packages to install_ , type `dash` under _Requested packages (Pip)_. Click _SAVE AND UPDATE_.




Note

If you need a refresher on code environment creation and packages install, please refer to [our documentation](<https://doc.dataiku.com/dss/latest/code-envs/index.html>).

### Create a Dash Webapp

  * Head back to your `NYC Yellow Cabs` project.

  * In the top navigation bar, go to _< /> -> Webapps_.

  * Click on _\+ NEW WEBAPP_ on the top right, then select _Code Webapp > Dash_.

  * Select the _An empty Dash app_ template and give a name to your newly-created Webapp.

  * Once create, go to _Settings_ and in the _code env_ dropdown, click _Select an environment_.

  * In the _Environment_ dropdown below, select your newly-created code environment.




### Build your Webapp

Copy and paste the code below:
    
    
    import dataiku
    import pandas as pd
    from dataiku.core.sql import SQLExecutor2
    import plotly.express as px
    from dash import dcc, html, Input, Output, State
    
    
    # Collect the zones to populate the dropdowns
    dataset_zones = dataiku.Dataset('NYC_zones')
    zones = dataset_zones.get_dataframe(columns=['zone']).values.ravel()
    zones.sort()
    
    dataset_trips = dataiku.Dataset("NYC_trips_zones")
    table_name_trips = dataset_trips.get_location_info().get('info', {}).get('table')
    
    e = SQLExecutor2(connection='pg')
    
    # This is the query template. There are two placeholders for the pick-up and drop-off locations in the WHERE clause. These will be populated from the dropdowns' values. 
    query = """
        SELECT
            "pickup_time",
            COUNT(*) AS "trip_count"
          FROM (
            SELECT
              date_trunc('day'::text, "tpep_pickup_datetime"::date) AS "pickup_time"
              FROM "{}"  WHERE "pu_zone" IN {} AND "do_zone" IN {}
            ) "dku__beforegrouping"
          GROUP BY "pickup_time" """ 
    
    
    app.layout = html.Div([
        html.H1("Taxi Data"),
        html.P("From"),
        # Dropdown for the input location(s).
        dcc.Dropdown(
                      id="pu_zone",
                      options=zones,
                      value=None,
                      multi=True,
                      placeholder="Select pick-up location(s)..."),
    
        html.P("To"),
    
        # Dropdown for the output location(s).
        dcc.Dropdown(
                      id="do_zone",
                      options=zones,
                      value=None,
                      placeholder="Select drop-off location(s)...",
                      multi=True),
    
        html.Br(),
        # "Query Trips" button.
        html.Button('Query Trips', id='submit', n_clicks=0),
    
        html.Br(),
        dcc.Graph(id="output")
    ])
    
    @app.callback(
        output=Output('output', 'figure'),
        inputs=dict(n_clicks=Input('submit', 'n_clicks')),
        state=dict(pu=State('pu_zone', 'value'),
                   do=State('do_zone', 'value'))
    )
    
    def get_query(n_clicks, pu, do):
        """ This function is run the user clicks the "Query Trips" button.
        """
        
        if n_clicks == 0 or pu is None or do is None: 
            return {} 
        pu = str(pu)[1:-1]
        do = str(do)[1:-1]
        q = query.format(table_name_trips, f'({pu})', f'({do})')
        # The pick-up and drop-off location(s) are fed into the query placeholders.
        df = e.query_to_df(q)
        fig = px.line(
            df, x='pickup_time', y="trip_count",
            labels={"pickup_time": "date", "trip_count": "trip count"}) 
        return fig 
    

### What does this webapp do?

  * This webapp lets users input one or more pick-up locations and one or more dropoff locations from two dropdown menus.

  * Once the query trips button is clicked, a SQL query is generated with a dynamic `WHERE` statement to filter on those pick-up and drop-off locations.

  * The query is then injected into the underlying table of the `nyc_taxi_with_zones` dataset and returns the count of trips from those pick-up locations to those drop-off locations aggregated at the day level as a pandas dataframe.

  * The dataframe is then fed to a _plotly.express_ line plot, allowing the users to visualize the results. Keep in mind that this a 10% random sample of the original dataset, so the true daily trip count is roughly 10 times greater than the one reported in the plot. Also, don’t be puzzled by the drastic fall in trip count starting March 2020–that’s what a pandemic does.

---

## [tutorials/devtools/IDE]

# IDE extensions

  * [VSCode extension for Dataiku](<vscode-extension/index.html>)

  * [PyCharm plugin for Dataiku](<pycharm-plugin/index.html>)

---

## [tutorials/devtools/api]

# Dataiku API

Dataiku’s public API is a powerful tool that allows you to automate various tasks and interact programmatically with multiple components within your Dataiku instance. By leveraging Dataiku’s Python client library, users can seamlessly interact with the API, enabling tasks such as managing datasets, triggering workflows, and accessing project information. Additionally, the REST API can also be used to achieve similar functionalities. However, it’s important to note that Dataiku strongly encourages users to leverage the Python client library due to its comprehensive functionality and ease of use.

## Python API

  * [Dataiku’s Public API: A Comprehensive Guide](<public-api-intro/index.html>)

  * [Using Dataiku’s Python packages](<python-client/index.html>)




## REST API

  * [Dataiku REST API](<rest-api/index.html>)

---

## [tutorials/devtools/code-studio/edit-agent/index]

# Editing & Debugging Code Agent with VS Code

This tutorial shows how to develop, test, and debug a Code Agent in Dataiku using Code Studio with VS Code. You will learn how to edit, sync, and safely manage Code Agents in your projects. For setting up a Code Studio template, see [the documentation](<../first-code-studio/index.html>).

## Prerequisites

Self-managedDataiku Cloud

Dataiku \\(\geq\\) 14.5Dataiku < 14.5

  * A Dataiku 14.5+ instance.

  * Administrator privileges for your user profile.

  * A Kubernetes cluster is configured. For details, visit [Elastic AI Computation](<https://doc.dataiku.com/dss/latest/containers/index.html> "\(in Dataiku DSS v14\)").

  * A base image is built. Typically, this is built using a command such as `./bin/dssadmin build-base-image --type container-exec`. For details, visit [Build the Base Image](<https://doc.dataiku.com/dss/latest/containers/setup-k8s.html#build-the-base-image>).

  * A project with some Code Agent and Code Tool. If you haven’t got one, you can follow [this tutorial](<../../../genai/agents-and-tools/code-agent/index.html>).

  * A Code Studio Template with VS Code and the Code Environment used by your GenAi component. Refer to [this tutorial](<../first-code-studio/index.html>) if you don’t know how to set up a Code Studio template.




  * A Dataiku 13.5+ instance.

  * Administrator privileges for your user profile.

  * A Kubernetes cluster is configured. For details, visit [Elastic AI Computation](<https://doc.dataiku.com/dss/latest/containers/index.html> "\(in Dataiku DSS v14\)").

  * A base image is built. Typically, this is built using a command such as `./bin/dssadmin build-base-image --type container-exec`. For details, visit [Build the Base Image](<https://doc.dataiku.com/dss/latest/containers/setup-k8s.html#build-the-base-image>).

  * A project with some Code Agent and Code Tool. If you haven’t got one, you can follow [this tutorial](<../../../genai/agents-and-tools/code-agent/index.html>).

  * A Code Studio Template with VS Code and the Code Environment used by your GenAi component. Refer to [this tutorial](<../first-code-studio/index.html>) if you don’t know how to set up a Code Studio template.




  * Administrator privileges for your user profile.

  * A project with some Code Agent and Code Tool. If you haven’t got one, you can follow [this tutorial](<../../../genai/agents-and-tools/code-agent/index.html>).

  * A Code Studio Template with VS Code and the Code Environment used by your GenAi component. Refer to [this tutorial](<../first-code-studio/index.html>) if you don’t know how to set up a Code Studio template.




## Editing a Code Agent

Dataiku \\(\geq\\) 14.5Dataiku < 14.5

If you haven’t set up a Code Studio, create one. Select the Code Studio attached to your project, and click the **Start** button. Once the Code Studio is running, you can select your Code Agent in the `code_agents` folder within VS Code.

Note

You should not create a Code Agent directly in the code-agents folder. Creating a Code Agent requires more than just creating a simple file. If you create a new file in this folder, you will be able to perform some tests, but the ‘Sync files with DSS’ button won’t save it back to DSS.

When you open the Code Studio instance, you will find a folder named: `/home/dataiku/workspace/code_agents`. All code agents are found in this folder, in a subfolder with a name that begins with the name of the agent you want to edit. Suppose you want to edit a code agent named `My code agent`. In this code agent, you have two versions (`v1` and `Second version`), and you want to edit version `v1`. The code of your agent will be located in a file named `agent.py` under the path:
    
    
    /home/dataiku/workspace/code_agents/My_code_agent_xxxxxxxx/v1/agent.py
    

where `xxxxxxxx` represents an ID (chosen by Dataiku), as shown in the figure below:

Any modification you make to this file won’t be propagated to Dataiku unless you hit the **Sync files with DSS** button. As soon as you synchronize your files with Dataiku, the code agent will be updated across the entire project, potentially affecting some users. Usually, it is not the way that you want to go when you are coding.

If you haven’t set up a Code Studio, create one. Select the Code Studio attached to your project, and click the **Start** button. Once the Code Studio is running, you can select your Code Agent in the `code-agents` folder within VS Code.

Note

You should not create a Code Agent directly in the code-agents folder. Creating a Code Agent requires more than just creating a simple file. If you create a new file in this folder, you will be able to perform some tests, but the ‘Sync files with DSS’ button won’t save it back to DSS.

To find your agent, you need to know its ID. This [code snippet](<../../../../concepts-and-examples/agents.html#ce-agents-list-your-agents>) can help you find it. A Code Agent can have multiple versions. You also need to know which version you want to edit. Suppose your agent has the name `Extract_topics`, its ID is `pO0H7cvh`, and you want to edit the version named `v1`, you should edit the file `code-agents/Extract_topics_pO0H7cvh_v1.py`.

When making changes to a Code Agent, you may want to test it. If you use the code below, the agent will run, but you won’t be able to see your changes, as you are working on a local copy of the code.
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    
    CODE_AGENT = "" # Fill with your Code Agent ID
    llm  = project.get_llm(CODE_AGENT)
    
    completion = llm.new_completion()
    completion.with_message("How to edit an Code Agent in Dataiku?")
    resp = completion.execute()
    print(resp.success)
    print(resp.trace)
    

To view your changes, synchronize your files with DSS and then run the code above. However, if you do that, the Code Agent will be updated for the entire project, and users may be affected by your changes. Usually, it is not the way that you want to go when you are coding. Hopefully, Dataiku provides a helper to test your modifications before publishing them.

Let’s take a real example. Imagine having a Code Agent (`Extract_topics`) that reformulates a question into smaller, more easily answerable questions, as shown in the code below. You also need to test/modify it, for example, to see if changing the base LLM would improve your results.
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    
    OPENAI_CONNECTION_NAME = "REPLACE_WITH_YOUR_CONNECTION_NAME"  # example: "openAI"
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            llm = dataiku.api_client().get_default_project().get_llm(f"openai:{OPENAI_CONNECTION_NAME}:gpt-4.1-mini")
            completion = llm.new_completion().with_message("Reformulates a question into smaller, more easily answerable questions", "system")
            for message in query["messages"]:
                if message.get("content"):
                    completion = completion.with_message(message["content"], message.get("role", "user"))
            llm_resp = completion.execute()
    
            resp_text = "Here are the questions you need to answer."
            resp_text = resp_text + "\n" + llm_resp.text
            return {"text": resp_text}
    

If you run this code, either by using the UI or by using the test file (see below for more information on using this test file), with the following input, you will obtain the following response:
    
    
    {
       "messages": [
          {
             "role": "user",
             "content": "What is the capital of the country where the Eiffel Tower is built?"
          }
       ],
       "context": {}
    }
    
    
    
    Here are the questions you need to answer.
    To answer your question, let's break it down into smaller parts:
    
    1. Which country is the Eiffel Tower located in?
    2. What is the capital city of that country?
    
    Would you like me to provide the answers?
    

## Using the Dataiku helper

Dataiku \\(\geq\\) 14.5Dataiku < 14.5

Now, you need to see if changing the LLM will impact the result. In your agent’s folder, you will find an autogenerated file (`test_agent.py`) with the following content:
    
    
    import agent
    from dataiku.llm.python import BaseLLM
    import json
    from dataiku.llm.python.tests import run_completion_query
    from dataiku.llm.python.types import SingleCompletionQuery
    import inspect
    from pathlib import Path
    
    HERE = Path(__file__).resolve().parent
    
    # Autogenerated test case for Code Agents in Code Studio.
    # This file can be freely edited in Code Studio, and changes
    # will persist.
    def test():
        agent_class = guess_agent_class()
    
        # load the json from agent_test_query.json
        query = load_test_query()
        response = run_completion_query(agent_class, query)
        print(json.dumps(response, indent=2, sort_keys=True))
    
    def load_test_query():
        return json.loads((HERE / "agent_test_query.json").read_text(encoding="utf-8"))
    
    def guess_agent_class():
        classes = [
            cls for name, cls in inspect.getmembers(agent, inspect.isclass)
            if cls.__module__ == agent.__name__
            and issubclass(cls, BaseLLM)
            and cls is not BaseLLM
        ]
        return classes[0]
    
    if __name__ == "__main__":
        test()
    

This file helps you both in testing and debugging. It provides starter code to quickly test your agent by reading `agent_test_query.json` and using it as input for your query. If needed, you can modify this file. The changes will be persisted when you hit the **Sync files with DSS** button.

Now, you need to see if changing the LLM will impact the result. In VS Code, in the `code-agents` folder, create a file named `test_agent.py` with the following content:
    
    
    import json
    from Extract_topics_pO0H7cvh_v1 import MyLLM
    from dataiku.llm.python.tests import run_completion_query
    
    resp = run_completion_query(MyLLM, "What is the capital of the country where the Eiffel Tower is built?")
    print(json.dumps(resp, indent=4))
    

The highlighted line shows how to use the helper for testing your Code Agent. Now that you know how to use your Code Agent locally, you can test your modifications.

For example, if you change your LLM definition with
    
    
    llm = dataiku.api_client().get_default_project().get_llm(f"openai:{OPENAI_CONNECTION_NAME}:gpt-5-mini")
    

and run the test again, you will obtain:
    
    
    {
        "text": "Here are the questions you need to answer.\nHere are smaller, easy-to-answer questions that lead to the original answer:\n\n1. In which city is the Eiffel Tower located?  \n2. Which country is that city in?  \n3. What is the capital of that country?",
        "trace": {
            "type": "span",
            "name": "DKU_TEST_AGENT_CALL",
            "children": [],
            "attributes": {},
            "inputs": {},
            "outputs": {},
            "begin": "2025-12-16T13:23:53.538000Z",
            "end": "2025-12-16T13:28:08.331000Z",
            "duration": 254793
        }
    }
    

## Tailoring to your needs

Dataiku \\(\geq\\) 14.5Dataiku < 14.5

By default, the `run_completion_query` method calls the `aprocess` method if it exists; otherwise, it calls `process`; if `process` does not exist, it calls `aprocess_stream`; if `aprocess_stream` also does not exist, it calls `process_stream`.

Usually, an agent only implements one of these functions, so using the `run_completion_query` is enough for the vast majority of cases. But sometimes, you can use another calling chain to test your agent. If you fall into a case where running this function does not fit your needs, you can instantiate the class and then test all the functions you want to test. To be able to do this, you first need to import the agent’s class:
    
    
    from agent import MyLLM
    

Once the import is complete, you can test the methods you need by simply calling them. For example, if you want to test the `aprocess` method, you can use this code (don’t forget to import asyncio):
    
    
    def test():
        query = load_test_query()
    
        agent = MyLLM()
        response = asyncio.run(agent.aprocess(query, None, SpanBuilder("titi")))
    
        print(response)
    

With the helper, you can easily test your modifications. However, if you synchronize your files, you will see that your test file (`test_agent.py`) has disappeared. This is due to the synchronization; as the test file is not a Code Agent, it is not saved, and as it is not present as an Agent, the synchronization deletes it. To be able to keep your test file from one synchronization to another, you need to move it from the `code-agents` folder to the `code_studio-versioned` folder. However, if you simply move the file, you will encounter an error, as `Extract_topics_pO0H7cvh_v1.py` is no longer in the same folder as the test file. You will need to modify the test file to include the code-agents folder in the path, as shown in the code below.
    
    
    import sys
    import os
    
    current_file_path = os.path.abspath(__file__)
    parent_dir = os.path.dirname(os.path.dirname(current_file_path))
    sibling_dir = os.path.join(parent_dir, 'code-agents')
    sys.path.insert(0, sibling_dir)
    
    import json
    from Extract_topics_pO0H7cvh_v1 import MyLLM
    from dataiku.llm.python.tests import run_completion_query
    
    resp = run_completion_query(MyLLM, "What is the capital of the country where the Eiffel Tower is built?")
    print(json.dumps(resp, indent=4))
    

As you are able to run your Code Agent in Code Studio, you can use the Debug action of Code Studio, as you do for classical debugging.

If your agent is using a tool, you will also be able to debug it by putting a breakpoint in the tool.

Do not forget to synchronize your files with Dataiku once you have finished testing/debugging your Code Agent.

## Wrapping up

In this tutorial, you learned how to develop and test a Code Agent in Dataiku using Code Studio and VS Code. You discovered how to safely edit, synchronize, and debug your agents, as well as run local tests before publishing changes.

---

## [tutorials/devtools/code-studio/edit-webapp/index]

# Editing & Debugging webapp in a Code Studio

This tutorial shows how to develop, test, and debug a webapp in Dataiku using Code Studio with Visual Studio Code. You will learn how to edit, sync, and safely manage webapp in your projects. For setting up a Code Studio template, see [the documentation](<../first-code-studio/index.html>).

## Prerequisites

  * Dataiku >= 14.5

  * Administrator privileges for your user profile to allow you to create a Code Studios template.




## Creating your Code Studio template

To edit your webapp with Code Studio, you need to create a Code Studio template with the code env adapted to your webapp and a Visual Studio.

### Creating a Code Studio Template

  1. In your Dataiku instance, choose **Administration** from the **Applications** menu.

  2. Navigate to the **Code Studios** tab.

  3. Select **\+ Create Code Studio Template**.

  4. Type a name for your template, such as `webapp-edit-template`, and then select **Create**.




### Adding the Code Environment block

Navigate to the **Definition** tab, where you select the blocks you want to use in your Code Studio. You may use an `Add Code Environment` block to choose a precise `Code Environment`.

This Code Environment must have the requirements needed for your webapp. Depending on your type of Webapp, you will need at least the following requested packages:

Type of Webapp | Framework | Requested packages  
---|---|---  
Standard | Flask |  flask flask-sock lxml  
FastAPI |  fastapi uvicorn_worker gunicorn lxml  
Bokeh | Bokeh |  bokeh  
Dash | Dash |  dash flask-sock  
Streamlit | Streamlit |  streamlit  
  
For the purpose of this tutorial, we are going to edit a webapp based on Dash. So, select a `Code Environment` with `dash` and `flask-sock`.

### Adding the Visual Studio Code block

Use the **\+ Add a Block** and select the `Visual Studio Code` block. This will be your IDE to edit your webapp.

Note

You can customize your Code Studios with additional blocks, such as the OpenCode block, to add your code assistant. You will find detailed information in [Using a code assistant in Code Studios: OpenCode](<../using-code-assistant-opencode/index.html>).

### Building the template

Let’s build and publish the Docker image so that our template becomes available. To do this:

  1. Select **Build**.

  2. Wait while Dataiku begins building the Docker image.

  3. Once the build is complete, you can select **Build History** to view the build details.




## Working with a webapp

We are now ready to start working with a Webapp. Let’s see how to create, edit, run and debug a new web application.

### Creating your webapp

You can create a Dash webapp following the following steps:

  * Select the **Webapps** option in the code menu (**< />**)

  * Use the **\+ New Webapp** button

  * Choose **Code Webapp**

  * Choose the **Dash** option

  * Keep **An empty Dash app** and name your app




Copy and paste the following code in the Python editor.
    
    
    from dash import Dash, dcc, html, dash_table, Input, Output
    from dash.exceptions import PreventUpdate
    import logging
    import dataiku
    
    logger = logging.getLogger(__name__)
    
    project = dataiku.api_client().get_default_project()
    datasets_name = list(map((lambda x: x.get("name", "")), project.list_datasets()))
    
    # build your Dash app
    app.layout = html.Div([
        html.H1("How to display a dataset"),
        dcc.Dropdown(datasets_name, placeholder="Choose a dataset to display.", id='dropdown'),
        dash_table.DataTable(id='table')
    ])
    
    
    @app.callback(
        Output('table', 'data'),
        Output('table', 'columns'),
        Input('dropdown', 'value')
    )
    def update(value):
        # If there is no value, do nothing (this is the case when the webapp is launched)
        if value is None:
            raise PreventUpdate
        # Take only the 100 first rows
        dataset = dataiku.Dataset(value).get_dataframe(limit=100)
        return dataset.to_dict('records'), [{"name": i, "id": i} for i in dataset.columns]
    

This Dash application will show a dataset selector and will display a table containing the content of the selected Dataset. You will find more details in the dedicated [Dash basics tutorial](<../../../webapps/dash/basics/index.html>).

### Editing your webapp

If you haven’t set up a Code Studio, create one using the template.

Note

If you need information, the [Launching your first Code Studio](<../first-code-studio/index.html#first-code-studio-launch>) tutorial will guide you through this step.

From your webapp, use the **EDIT IN CODE STUDIO** button.

Select your Code Studio in the dialog:

Your webapp will be located in a dedicated subfolder of the folder named `webapps`. The app folder contains the following:

  * /backend.py, /main.py, /app.py, etc. : main application file. This is the code edited in DSS for a regular webapp.

  * /vscode_launch.py: a run-and-debug-in-VSCode launcher, initially provided by Dataiku

  * /README.md: A starter readme provided by Dataiku, but yours to adapt to your needs

  * Optionally, other application files, including
    
    * /config.toml for Streamlit apps

    * JavaScript, CSS, and HTML files for a standard webapp




### Modifying the code

We are going to add a sort on the table displaying a Dataset.
    
    
    from dash import Dash, dcc, html, dash_table, Input, Output
    from dash.exceptions import PreventUpdate
    import logging
    import dataiku
    
    logger = logging.getLogger(__name__)
    
    project = dataiku.api_client().get_default_project()
    datasets_name = list(map((lambda x: x.get("name", "")), project.list_datasets()))
    
    # build your Dash app
    app.layout = html.Div([
        html.H1("How to display a dataset"),
        dcc.Dropdown(datasets_name, placeholder="Choose a dataset to display.", id='dropdown'),
        dash_table.DataTable(
            id='table',
            sort_action='native',
            sort_mode='multi'
        )
    ])
    
    
    @app.callback(
        Output('table', 'data'),
        Output('table', 'columns'),
        Input('dropdown', 'value')
    )
    def update(value):
        # If there is no value, do nothing (this is the case when the webapp is launched)
        if value is None:
            raise PreventUpdate
        # Take only the 100 first rows
        dataset = dataiku.Dataset(value).get_dataframe(limit=100)
        return dataset.to_dict('records'), [{"name": i, "id": i} for i in dataset.columns]
    

### Running the code

Open the file `vscode_launch.py` from your webapp folder. In the bottom right, select the Python interpreter for your VSCode. Use the one you added in your Code Studio template. You can then use the Run button on the top right corner.

Once it is started, you will have a pop up at the bottom right with a button to open the app in your browser.

If you missed the pop up, you will find a way to open your webapp from the **PORTS** tab.

The three icons will provide alternative ways to open your webapp:

  * _Copy Local adress_ : to use the adress in the browser and window of your choice.

  * _Open in Browser_ : to open in the current browser.

  * _Preview in Editor_ to open in a split view with the code editor.




Once you are done with this session, you can stop your application. To do so, focus on the _Terminal_ window where the logs were displayed and hit the keys ``CTRL`+`C``.

Warning

Do not hit the red **STOP** button on the upper right, as it will stop the entire Code Studio.

### Debugging the code

When the file `vscode_launch.py` is open, you can also run with the debugger. To do so, use the dropdown on the right of the run icon and use the debug option. In that mode, you will be able to use the debugging features of Visual Studio Code, like using breakpoints.

You will benefit from all the Visual Studio Code features, and you will find information in the [Debug code documentation](<https://code.visualstudio.com/docs/debugtest/debugging>). Just keep in mind to use the buttons in the upper middle panel to have debug actions, including the stop button to end your debugging session.

### Synchronizing your changes

Once the changes made to the webapp meet your success criteria, you need to synchronize the code with the Dataiku Webapp. Use the **SYNC FILES WITH DSS** button to start the synchronization.

## Wrapping up

In this tutorial, you learned how to develop and test a Webapp in Dataiku using Code Studio and Visual Studio Code. You discovered how to edit, synchronize, and debug your app.

---

## [tutorials/devtools/code-studio/first-code-studio/index]

# My first Code Studio

When coding and building solutions in Dataiku, it can be helpful to access your own integrated development environment (IDE), such as JupyterLab or Visual Studio Code (VS Code). Dataiku [Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/concepts.html> "\(in Dataiku DSS v14\)") allow you to do just that, and much more! In this tutorial, you will learn how to create a Code Studio template and run it.

## Prerequisites

Self-managedDataiku Cloud

  * A Dataiku 11+ instance.

  * Administrator privileges for your user profile.

  * A Kubernetes cluster is configured. For details, visit [Elastic AI Computation](<https://doc.dataiku.com/dss/latest/containers/index.html> "\(in Dataiku DSS v14\)").

  * A base image is built. Typically, this is built using a command such as `./bin/dssadmin build-base-image --type container-exec`. For details, visit [Build the Base Image](<https://doc.dataiku.com/dss/latest/containers/setup-k8s.html#build-the-base-image>).




  * Administrator privileges for your user profile.




## Creating a Code Studio template

To use Code Studios, you’ll need to set up a [Code Studio template](<https://doc.dataiku.com/dss/latest/code-studios/concepts.html#code-studio-templates>).

Attention

You’ll need Administrator privileges on your instance to create a Code Studio template.

To do this:

Self-managedDataiku Cloud

  1. In your Dataiku instance, choose **Administration** from the **Applications** menu.

  2. Navigate to the **Code Studios** tab.

  3. Select **\+ Create Code Studio Template**.

Code Studios tab in the Admin menu.

  4. Type a name for your template, such as `my-vsc-template`, and then select **Create**.




  1. In the Dataiku [Launchpad](<https://launchpad-dku.app.dataiku.io/>), navigate to the **Extensions** panel.

  2. Click on the **\+ Add an Extension** button.

Create code studios extension on Dataiku cloud launchpad.

  3. Choose **Code Studios** and click on **Confirm**. It may take a few minutes.

  4. Once it’s created, navigate to the Code Studios by clicking on **Create your first code studio template 🚀**.

  5. Select **+Create Code Studio Template**.

  6. Type a name for your template, such as `my-vsc-template`, and then select **Create**.

Code Studios tab in the Admin menu.




### Configuring general settings

In the General tab, name and describe your template. You can add an icon. The **Build** section uses your default container, which you can change.

Code Studio configuration.

### Configuring definition settings

The Definition settings define the services that your template provides. To enrich the template definition, you add blocks. By default, a Code Studio template comes with two default blocks (**File Synchronization** and **Kubernetes Parameters**):

  * **File Synchronization** : This block enables synchronisation between your Code Studio and Dataiku. There is no automatic save, and you will need to synchronise your files to save/edit your files within Code Studio.

A `CodeStudio_README.md` file explains what those different directories are. In addition, you can find more information in the [Code Studio reference documentation](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-operations.html#synchronized-files> "\(in Dataiku DSS v14\)"). Let’s summarise the use cases for every directory available in a Code Studio.

Directories | Scope | Example | Default mounting location  
---|---|---|---  
Agent Tools | **Project** | Inline Python Tool files | `agent-tools`  
Code Agent | **Project** | Code Agent files | `code-agents`  
Code Studio versioned files | **Code Studio** | Streamlit source code files | `code_studio-versioned`  
Code Studio resources | **Code Studio** | Code Studio - specific images | `code_studio-resources`  
Notebooks | **Project** | Project Notebooks | `notebooks`  
Project libraries | **Project** | Project Libraries | `project-lib-versioned`  
Project resources | **Project** | Project-specific images | `project-lib-resources`  
Project recipes | **Project** | Project recipes | `recipes`  
User config | **User** | IDE config files | `user-versioned`  
User resources | **User** | Plugins IDE | `user-resources`  
Webapps | **Project** | Native webapps files | `webapps`  
  
Important

The resources folders (`code_studio-resources`, `project-lib-resources`, `user-resources`) are not versioned in the project.

Note

These directories are available by default; however, a Code Studio administrator can configure them from a Code Studio template using the [File synchronization block](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#code-studios-code-studio-templates-file-sync> "\(in Dataiku DSS v14\)").

File Synchronization block.

  * **Kubernetes Parameters** : This special block controls advanced settings. For more information, please refer to [the documentation](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#code-studios-code-studio-templates-kubernetes> "\(in Dataiku DSS v14\)").




To edit files in Code Studio, let’s add a VS Code block so that we can use a VS Code editor in our browser.

  1. Navigate to the **Definition** tab.

  2. Select **Add a Block**.

  3. In **Select a block type** , click **Visual Studio Code**.

  4. Leave the other settings as default and select **Save**.




Note

The VS Code block contains a basic Python code environment and Dataiku APIs by default. To add a specific code environment, select **Add Block**. In **Select a block type** , select **Add Code Environment**.

Code Studio template definition.

### Building the template

Let’s build and publish the Docker image so that our template becomes available. To do this:

  1. Select **Build**.

  2. Wait while Dataiku begins building the Docker image.

  3. Once the build is complete, you can select **Build History** to view the build details.




We are now ready to use VS Code in our project!

## Launching your first Code Studio

Back in our project, we’ll launch Code Studios and select our new VS Code template.

  1. From the **Code** menu, select **Code Studios**.

  2. Select **Create Your First Code Studio**.

  3. In **New Code Studio** , select the VS Code template you just created.

  4. Name the Code Studio `VS Code` and select **Create**.

> Launching a new Code Studio in a project.

Now that your Code Studio is created, let’s start it and get a first look!

  5. Select **Start Code Studio**.

Wait while Dataiku starts the Code Studio and launches it in a browser window.

Note

If it’s the first time, VS Code may ask you to trust the authors.

Click **Yes, I trust the authors** to move forward.




## Wrapping up

In this tutorial, you’ve learned how to set up and launch a Code Studio in Dataiku, giving you access to powerful development environments like VS Code directly within your project. By following these steps, you can efficiently create and customise templates, configure your environment, and start coding right away. Code Studios streamlines development workflows, making it easier to build, debug, and maintain your solutions within Dataiku.

If you want to deep dive into using VSCode within Code Studio, you should read [this tutorial](<../../using-vscode-for-code-studios/index.html>).

---

## [tutorials/devtools/code-studio/using-code-assistant-copilot/index]

# Using a code assistant in Code Studios: GitHub Copilot

This tutorial teaches you how to add the [GitHub Copilot](<https://github.com/features/copilot>) assistant to help you write code. You can start by creating [your first Code Studio](<../first-code-studio/index.html>). We will guide you through the needed steps to empower your Code Studio with this assistant.

## Prerequisites

  * Dataiku >= 14.3

  * Administrator privileges for your user profile.

  * GitHub Copilot credentials




## Adding GitHub Copilot to a Code Studio

### Creating a Code Studio Template

  1. In your Dataiku instance, choose **Administration** from the **Applications** menu.

  2. Navigate to the **Code Studios** tab.

  3. Select **\+ Create Code Studio Template**.

  4. Type a name for your template, such as `copilot-template`, and then select **Create**.




### Adding the Visual Studio Code block

Navigate to the **Definition** tab, where you select the blocks you want to use in your Code Studio. You may use an `Add Code Environment` block to choose a precise `Code Environment`.

Use the **\+ Add a Block** and select the `Visual Studio Code` block.

### Installing GitHub Copilot

To install the `GitHub Copilot` extension, you need to check the option in the `Visual Studio Code` options.

### Building the template

You can now build your Code Studio image to use it. To do so, use the **Build** button. If you need more details on Code Studio Template, refer to the tutorial [My first Code Studio](<../first-code-studio/index.html>).

## Using GitHub Copilot in your Code Studio

Use the **Code Studios** from the **Code** menu to create and launch your Code Studio based on the image and template you defined. If you need detailed steps, the [Launching your first Code Studio](<../first-code-studio/index.html#first-code-studio-launch>) documentation will guide you.

### Signing in to GitHub Copilot

To start using GitHub Copilot, you need to sign in. To do so, look at the bottom of the Visual Studio Code for the Copilot avatar and click on it.

When you click the sign-in button, a window will let you choose your authentication method.

To finish authenticating, you will need to copy a code to a GitHub page. Just use the **Copy & Continue to GitHub** button.

### Using GitHub Copilot

At this point, your Code Studio is fully operational, and you can start using your environment to code with the assistance of all the features in [GitHub Copilot](<https://github.com/features/copilot>). You can find additional information on the usages of Code Studios in [edit your code](<../../using-vscode-for-code-studios/index.html>) or in [edit your Code Agent](<../edit-agent/index.html>).

## Wrapping up/Conclusion

Congratulations, you’ve learned how to set up and launch a Code Studio in Dataiku that provides access to GitHub Copilot.

---

## [tutorials/devtools/code-studio/using-code-assistant-opencode/index]

# Using a code assistant in Code Studios: OpenCode

Once you have created [your first Code Studio](<../first-code-studio/index.html>), you can start working on your project. This tutorial teaches you how to add the [OpenCode](<https://opencode.ai>) assistant to help you write code. We will outline the steps required to achieve this capability in your Code Studio. Then, we will check that OpenCode is operational and see basic actions with the assistant.

## Prerequisites

  * Dataiku >= 14.3

  * A Code Studio template, as defined in the tutorial [My first Code Studio](<../first-code-studio/index.html>), for example.

  * One or more LLM connections to access models with code assistance capacities




## Adding OpenCode to a Code Studio

Working in a Code Studio with Visual Studio Code is the first goal you reached with the tutorial [My first Code Studio](<../first-code-studio/index.html>). To enhance your development abilities, you may need to use a code assistant and work with a tool like [OpenCode](<https://opencode.ai>). Let’s discover the steps to get there.

### Adding the OpenCode block

In your Dataiku instance, choose **Administration** from the **Applications** menu. Navigate to the **Code Studios** tab and select the Code Studio you want to use.

Navigate to the **Definition** tab, where you select the blocks you want to use in your Code Studio. You may use an `Add Code Environment` block to select a precise `Code Environment`. This is also where you will see the `Visual Studio Code` block which brings the IDE to your Code Studio.

Use the **\+ Add a Block** and select the `OpenCode` block.

### Defining settings

You will be able to select the way the `OpenCode` agent will work. The first and second settings are linked. Depending on the value you choose for `Choose which model/models to use`, the second setting will have a different meaning. For plural values, a third setting will appear. The table below summarizes the possible values and their meanings.

Choose which model/ models to use |   
---|---  
Allow a single model | Model id | LLM Mesh model id  
Allow a list of models | Model ids | List of LLM Mesh model id  
Default model id | Default id from the list  
Allow all models of a single connection | Connection name | Name of the connection to allow  
Default model id | Default id from the list  
Allow all models from a list of connection types |  Restrict do LLM connections types |  Choose values in the dropdown OpenAI, Anthropic, Cohere…  
Default model id | Default id from the list  
Allow all models that the user can use | Default model id |  Default id from the list of authorized models  
Do not connect OpenCode to the LLM Mesh. Only use OpenCode builtin models  
  
The other settings are not dependent on the first one.

  * `Apply context window and max output tokens for each model`: when checked, it will apply the values found on <https://models.dev>, an open source database that contains information on AI models.

  * `OpenCode version`: specify the version you want to use, or leave it empty to use the latest version.

  * `Add VS Code extension?`: when checked, the OpenCode extension will be added to VS Code. You must place a `Visual Studio Code` block before.

  * `VS Code extension version`: if you decide to use the VS Code extension, you can specify a specific version here or leave it blank to use the latest.




### Building the template

You can now build your Code Studio image to use it. To do so, use the **Build** button. If you need more details, refer to the [Build the template](<../first-code-studio/index.html#first-code-studio-build>) section in the tutorial [My first Code Studio](<../first-code-studio/index.html>).

## Using OpenCode in your Code Studio

In the project, you want to use OpenCode. To do this, use the **Code Studios** from the **Code** menu to create and launch your Code Studio based on the image and template you defined. If you need detailed steps, the [Launching your first Code Studio](<../first-code-studio/index.html#first-code-studio-launch>) documentation will guide you.

### Launching OpenCode

OpenCode can be used in any terminal in your Code Studio. You can launch it with the command `opencode`. You can also launch OpenCode once you have a file open in the editor. You will have a dedicated button to launch OpenCode in a new terminal window.

### Using OpenCode

Once you have a window with OpenCode, you can start prompting what you need to work on. To learn how to use OpenCode, take some time to read the [OpenCode documentation](<https://opencode.ai/docs>).

All the available commands and their shortcuts are available using `ctrl+p`

## Wrapping up/Conclusion

Congratulations, you’ve learned how to set up and launch a Code Studio in Dataiku that provides access to OpenCode.

---

## [tutorials/devtools/code-studio]

# Code Studio

Code Studios are **personal** instances of a development environment. Within Code Studio, you can edit/interact with the following items:

Item | Editable ?  
---|---  
Agent Tools | ✅  
Code Agents | ✅  
Code Recipes | ✅  
Notebooks | ✅  
Plugins | ❌  
Project Libraries | ✅  
Webapps (native) | ✅  
Webapps (non-native) | ✅  
Wiki | ❌  
  
Note

Native webapps are Standard (HTML/JS/Python), Bokeh, Shinny, Dash, and Streamlit. It means that a user can create this kind of webapps without using an external tool, like Code Studio. Non-native webapps are webapps that a user can enable by correctly configuring their Code Studio.

For a deeper understanding of Code Studio, you can look at:

  * [My first Code Studio](<code-studio/first-code-studio/index.html>)

  * [Editing & Debugging Code with VS Code](<using-vscode-for-code-studios/index.html>)

  * [Editing & Debugging Code Agent with VS Code](<code-studio/edit-agent/index.html>)

  * [Editing & Debugging webapp in a Code Studio](<code-studio/edit-webapp/index.html>)

  * [Using a code assistant in Code Studios: OpenCode](<code-studio/using-code-assistant-opencode/index.html>)

  * [Using a code assistant in Code Studios: GitHub Copilot](<code-studio/using-code-assistant-copilot/index.html>)

  * [Using JupyterLab in Code Studios](<using-jupyterlab-in-code-studios/index.html>)

  * [Using RStudio for Code Studios](<using-rstudio-for-code-studios/index.html>)

---

## [tutorials/devtools/git-collaboration/index]

# Git collaboration

This tutorial teaches you how to use Git integration within Dataiku in a multi-developer team use case. We are going to follow the story of a team of two developers in charge of a new project. Starting with a Dataset with customers information, a Dataset with companies information will be created. The first developer will add a column with the stock ticker symbol. The second developer will add a column with the last stock value. In both cases, they will use two libraries to help them: yfinance and yahooquery. It will show the different steps during a collaboration on a project, including operations like branching, creating a Pull Request, and handling a case of merge conflict.

## Prerequisites

  * Dataiku >= 13.5

  * Python >= 3.10

  * A code environment with the following packages:
        
        yfinance    #tested with 0.2.65
        yahooquery  #tested with 2.4.1
        

  * An SQL Dataset named `pro_customers_sql`. You can create this Dataset by uploading this [`CSV file`](<../../../_downloads/bebbdc65d2087c3bb5bc130dbea25663/pro_customers.csv>) and using a **Sync recipe** to store the data in an SQL connection.




## Preparing the project

Before explaining the collaboration with branches, let’s prepare the project that will be used. Set up the required **Code Environment** In **Administration** > **Code envs** , select an existing **Code Environment** or click **Create code environment** , then add the libraries listed in the prerequisites section. Once you have fulfilled the requirements, you will have a project with a flow with the uploaded file, a Sync recipe, and an SQL Dataset with the data from the CSV file. For this tutorial, let’s call the SQL Dataset `pro_customers_sql`.

Fig. 1: Prepared project flow.

### Adding a Python recipe

We are going to add a **Python Code recipe** from the SQL dataset (`pro_customers_sql`). Go to the **Advanced** tab of the recipe to check you are using the **Code Environment** with the requirements installed. We will create a new Dataset (named `companies`) containing only the `company` column. For code implementation, you can use Code 1.

Code 1: Extract the `company` column
    
    
    import dataiku
    
    
    # Read recipe input
    pro_customers_sql = dataiku.Dataset("pro_customers_sql")
    customers_companies = pro_customers_sql.get_dataframe(columns=['company'])
    
    # Write recipe outputs
    companies = dataiku.Dataset("companies")
    companies_df = customers_companies.copy()
    companies.write_with_schema(companies_df)
    

You now have a `companies` Dataset with the following content.

Fig. 2: Starting `companies` table.

You can now add a remote repository, as described in the [Git basics section](<../git-dss-setup/index.html#git-setup-adding-remote-repository>). In summary, go to the **Version Control** menu and choose the **Add remote** action.

## Creating the developer’s environments

To collaborate on the project, let’s assume there are two developers. From the current state of the project, let’s create a branch for each of them. As described in the [Branches operations](<../git-dss-setup/index.html#git-setup-adding-branches>), you will follow those steps:

  * From the **Version Control** menu, choose the branch menu currently showing the `main` branch, and select **Create new branch…**.

  * Enter the branch name, `dev_1`, and click the **Next** button.

  * Click on the **Duplicate and create branch** button.




This will create the branch `dev_1` for the first developer, who will use the duplicated project. Return to the main project and repeat the sequence for the second developer (`dev_2`, for example). We have the following collaboration architecture:

Fig. 3: Collaboration architecture.

Each developer is going to work on a dedicated project and branch.

## Adding and pushing code

### Adding and filling the symbol column.

The first developer has to work on the following task: for each company in the `companies` Dataset, add the corresponding stock ticker symbol in a new column called `symbol`. Code 2 shows how to modify the Python recipe.

Code 2: Adding and filling the symbol column.
    
    
    import dataiku
    import yahooquery as yq
    
    def find_symbol(name):
        """
        Searches for a stock ticker symbol using the yahooquery package.
    
        Args:
            name (str): The company name or search term.
    
        Returns:
            str: The ticker symbol if found, 'NA' if not found, or 'ERROR' on exception.
        """
        try:
            data = yq.search(name)
        except ValueError:
            return "ERROR"
        else:
            quotes = data['quotes']
            if len(quotes) == 0:
                return 'NA'
    
            symbol = quotes[0]['symbol']
    
            return symbol
    
    # Read recipe input
    pro_customers_sql = dataiku.Dataset("pro_customers_sql")
    customers_companies = pro_customers_sql.get_dataframe(columns=['company'])
    
    # Write recipe outputs
    companies = dataiku.Dataset("companies")
    companies_df = customers_companies.copy()
    
    # For each company name, find the corresponding stock symbol
    symbols = []
    for company in companies_df['company']:
        symbol = find_symbol(company)
        if symbol not in ["ERROR", "NA"]:
            symbols.append(symbol)
        else:
            symbols.append(None)
    # Add the list of symbols as a new column 'symbol' in the DataFrame
    companies_df['symbol'] = symbols
    
    # writes the result to the dataset
    companies.write_with_schema(companies_df)
    

### Pushing the code

Once satisfied with this new version of the project, the first developer decides to push the code. To do so, go to the **Version Control** menu. From there, use the **Push** action. The `dev_1` branch now has this version of the project.

### Creating a Pull Request

As the branch has just been pushed, you can now navigate to Github and create a PR from the suggested **Compare & pull request**. You can also use the **New pull request** button from the **Pull requests** tab.

Fig. 4: Compare & pull request.

Add all the needed elements, such as a description. You can see that two files were modified.

Fig. 5: Dev1 changed files.

The file `datasets/companies.json` shows the modification done with the addition of the column `symbol`. The file `recipes/compute_companies.py` shows the code modification done.

### Merging changes in the main project

The Pull Request view on GitHub shows that there is no conflict: you can merge your pull request. Once it is done, you can go back to your Dataiku instance and navigate to the main project. From the **Version Control** menu, choose the **Pull** action. The main project now has all the modifications by the first developer.

## Working in the second environment

You can switch to the environment created for the second developer.

### Adding a stock value

The second developer will now modify the **Python recipe**. The developer must add a new column, `last_stock`, to the `companies` Dataset to store the last stock value retrieved using the `yfinance` package. This can be done by using the following code in the `compute_companies` recipe:

Code 3: Adding and filling the last stock column.
    
    
    import dataiku
    import yahooquery as yq
    import yfinance as yf
    
    
    def find_symbol(name):
        """
        Searches for a stock ticker symbol using the yahooquery package.
    
        Args:
            name (str): The company name or search term.
    
        Returns:
            str: The ticker symbol if found, 'NA' if not found, or 'ERROR' on exception.
        """
        try:
            data = yq.search(name)
        except ValueError:
            return "ERROR"
        else:
            quotes = data['quotes']
            if len(quotes) == 0:
                return 'NA'
    
            symbol = quotes[0]['symbol']
    
            return symbol
    
    # Read recipe input
    pro_customers_sql = dataiku.Dataset("pro_customers_sql")
    customers_companies = pro_customers_sql.get_dataframe(columns=['company'])
    
    # Write recipe outputs
    companies = dataiku.Dataset("companies")
    companies_df = customers_companies.copy()
    
    # For each company name, find the corresponding last stock value
    last_stocks = []
    for company in companies_df['company']:
        symbol = find_symbol(company)
        if symbol not in ["ERROR", "NA"]:
            try:
                ticker_obj = yf.Ticker(symbol)
                price = ticker_obj.history(period="1d")['Close']
                latest_price = price.iloc[-1] if not price.empty else None
                last_stocks.append(latest_price)
            except Exception as e:
                last_stocks.append(None)
        else:
            last_stocks.append(None)
    # Add the list of last_stocks as a new column 'last_stock' in the DataFrame
    companies_df['last_stock'] = last_stocks
    
    # writes the result to the dataset
    companies.write_with_schema(companies_df)
    

### Creating the Pull Request

The second developer will follow the same steps as the first one:

  * Push the code to the `dev_2` branch from the **Version Control** menu of Dataiku

  * Create a Pull Request from GitHub.




Note that conflicts have been detected this time.

Fig. 6: Dev2 conflict detected.

### Solving and merging changes in the main project

You now have to solve the conflicts detected. You can do it with the tools you are the most comfortable with. For the purpose of this tutorial, we will use the tool proposed on GitHub from the PR view.

Fig. 7: Resolve conflicts button

The conflict for the `datasets/companies.json` is solved by incorporating all modifications as shown below (don’t forget to add a , at the end of the first addition):

Fig. 8: Companies conflict solution.

The conflict in the recipe code is a little trickier. You have to add the elements corresponding to the `last_stock` into the existing loop. The final result is as the code below:

Code 4: Complete recipe code.
    
    
    import dataiku
    import yahooquery as yq
    import yfinance as yf
    
    
    def find_symbol(name):
        """
        Searches for a stock ticker symbol using the yahooquery package.
    
        Args:
            name (str): The company name or search term.
    
        Returns:
            str: The ticker symbol if found, 'NA' if not found, or 'ERROR' on exception.
        """
        try:
            data = yq.search(name)
        except ValueError:
            return "ERROR"
        else:
            quotes = data['quotes']
            if len(quotes) == 0:
                return 'NA'
    
            symbol = quotes[0]['symbol']
    
            return symbol
    
    # Read recipe input
    pro_customers_sql = dataiku.Dataset("pro_customers_sql")
    customers_companies = pro_customers_sql.get_dataframe(columns=['company'])
    
    # Write recipe outputs
    companies = dataiku.Dataset("companies")
    companies_df = customers_companies.copy()
    
    # For each company name, find the corresponding last stock value
    last_stocks = []
    symbols = []
    for company in companies_df['company']:
        symbol = find_symbol(company)
        if symbol not in ["ERROR", "NA"]:
            symbols.append(symbol)
            try:
                ticker_obj = yf.Ticker(symbol)
                price = ticker_obj.history(period="1d")['Close']
                latest_price = price.iloc[-1] if not price.empty else None
                last_stocks.append(latest_price)
            except Exception as e:
                last_stocks.append(None)
        else:
            symbols.append(symbol)
            last_stocks.append(None)
    # Add the list of last_stocks as a new column 'last_stock' in the DataFrame
    companies_df['last_stock'] = last_stocks
    # Add the list of symbols as a new column 'symbol' in the DataFrame
    companies_df['symbol'] = symbols
    
    # writes the result to the dataset
    companies.write_with_schema(companies_df)
    

You can commit the resulting merge. Your pull request for the second developer is now ready to be merged. You can merge into the main branch.

## Wrapping up

Congratulations! You are able to collaborate on a Dataiku project with a remote repository!

## Reference documentation

### Classes

[`dataiku.Dataset`](<../../../api-reference/python/datasets.html#dataiku.Dataset> "dataiku.Dataset")(name[, project_key, ignore_flow]) | Provides a handle to obtain readers and writers on a dataiku Dataset.  
---|---  
  
### Functions

[`get_dataframe`](<../../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe")([columns, sampling, ...]) | Read the dataset (or its selected partitions, if applicable) as a Pandas dataframe.  
---|---  
[`write_with_schema`](<../../../api-reference/python/datasets.html#dataiku.Dataset.write_with_schema> "dataiku.Dataset.write_with_schema")(df[, drop_and_create]) | Write a pandas dataframe to this dataset (or its target partition, if applicable).

---

## [tutorials/devtools/git-dss-setup/index]

# Git basics in Dataiku

This tutorial teaches you how to use Git integration within Dataiku to enhance project collaboration and manage changes effectively. It includes instructions for accessing project version control, guidance on executing key Git operations such as managing branches and creating merge requests, and instructions for setting up and using a remote repository.

## Prerequisites

  * Dataiku >= 13.5




## Introduction

Dataiku comes built-in with Git-based version control. A regular Git repository backs each project. Each change you make in the Dataiku (e.g., modifying the settings of a dataset, editing a recipe, or modifying a dashboard) is automatically recorded in the Git repository. The [Version Control](<https://doc.dataiku.com/dss/latest/collaboration/version-control.html> "\(in Dataiku DSS v14\)") documentation provides more details.

## Operating the integrated version control

### Accessing project version control

From your project, you can access the version control page by clicking the dot menu and clicking Version Control, as in the screenshot below.

Fig. 1: Accessing project version control.

You will have access to your project’s history and all the commits you have made so far. By clicking on a specific commit, you will see what modifications were made. An example is shown in the screenshot below.

Fig. 2: Shows a commit detail.

### Integrated git operations

The Version Control page allows you to perform several git operations.

#### Branches operations

From the branches menu, you will be able to:

  * Search branches to find the proper one among the existing branches.

  * Select a branch to switch to and work from there.

  * Create a new branch when needed

  * Delete branches to clean up the project




Fig. 3: Branches operations menu.

The creation and deletion of branches are git operations.

The creation has an additional option for the project itself. You can choose to duplicate the Dataiku project.

Fig. 4: Create branch dialog.

We encourage you to use this duplication option if you want to modify several project elements, like changing the workflow. In that case, you can work on this duplicated project without interfering with the source project. Once you are ready to contribute, you will use the Merge Request feature described in the next section.

#### Merge Request

When you have modifications done in other branches and need to integrate them into your branch, you must perform a Merge Request.

Fig. 5: Merge request menu.

A merge Request allows you to review the changes made to files and the corresponding history of commits. You can review and resolve potential conflicts and decide whether to validate the changes or delete the Merge Request.

Fig. 6: Merge request actions.

## Using a remote repository

It is possible to use remote repositories with. We recommend working with a remote whenever possible, as it offers more options for managing merge commits and better collaboration capabilities.

### Adding a remote repository

You will undoubtedly need an SSH key to add a remote repository and be authorized to operate it. Known Git service providers, such as GitHub, GitLab, or others like AWS Code Commit or Azure Repos, have a well-defined process for authorizing a connection using an SSH key.

To allow your Dataiku project to use such a key, you will have two cases:

  * You work on a Dataiku Cloud instance.

  * You work on an on-premises instance.




The process is described in more detail in the [Setup chapter in Working with Git](<https://doc.dataiku.com/dss/latest/collaboration/git.html#git-setup> "\(in Dataiku DSS v14\)") of the documentation. For quick reference here, let’s summarize as:

  * From Dataiku Cloud: add an extension with the git integration, then enter the service provider’s domain.

  * From a on-premises instance: generate an SSH key for the Dataiku user




In both cases, don’t forget to copy the public key to your git service provider.

From that point, you can now add a remote repository to your project.

Fig. 7: Add remote menu.

You will be asked for the git URL of your repository.

Fig. 8: Add remote dialog.

### Update operations

Once you have added a remote repository, a new set of actions is available.

Fig. 9: Remote actions.

The first actions are familiar operations to any git user.

  * Fetch: retrieve all the remote repository data without modifying your local work.

  * Push: uploads your local updates to the remote repository.

  * Pull: performs the fetch action and immediately integrates changes in your local branches.




The last actions allow you to:

  * Drop changes: Delete all of your non-pushed work on the current local branch. The project’s history of changes will be reset to the state of the remote repository.

  * Edit remote: allows you to modify the remote repository URL.

  * Remove remote: unlink the remote repository.




## Wrapping up

Congratulations! You can start collaborating on your project and managing its change workflow with all that information.

---

## [tutorials/devtools/git]

# Git usage in Dataiku

  * [Git basics in Dataiku](<git-dss-setup/index.html>)

  * [Git collaboration in Dataiku](<git-collaboration/index.html>)

  * [Using the API to interact with git for projects versioning](<using-api-with-git-project/index.html>)

---

## [tutorials/devtools/index]

# Developer tools  
  
This tutorial section contains articles about the various tools available to edit and maintain code running in Dataiku.

## Dataiku API

  * [Dataiku’s Public API: A Comprehensive Guide](<public-api-intro/index.html>)

  * [Using Dataiku’s Python packages](<python-client/index.html>)

  * [Dataiku REST API](<rest-api/index.html>)




## IDE Extensions

  * [VSCode extension for Dataiku](<vscode-extension/index.html>)

  * [PyCharm plugin for Dataiku](<pycharm-plugin/index.html>)




## Code Studio

  * [My first Code Studio](<code-studio/first-code-studio/index.html>)

  * [Editing & Debugging Code with VS Code](<using-vscode-for-code-studios/index.html>)

  * [Editing & Debugging Code Agent with VS Code](<code-studio/edit-agent/index.html>)

  * [Editing & Debugging webapp in a Code Studio](<code-studio/edit-webapp/index.html>)

  * [Using a code assistant in Code Studios: OpenCode](<code-studio/using-code-assistant-opencode/index.html>)

  * [Using a code assistant in Code Studios: GitHub Copilot](<code-studio/using-code-assistant-copilot/index.html>)

  * [Using JupyterLab in Code Studios](<using-jupyterlab-in-code-studios/index.html>)

  * [Using RStudio for Code Studios](<using-rstudio-for-code-studios/index.html>)




## Git usage in Dataiku

  * [Git basics in Dataiku](<git-dss-setup/index.html>)

  * [Git collaboration in Dataiku](<git-collaboration/index.html>)

  * [Using the API to interact with git for projects versioning](<using-api-with-git-project/index.html>)




## Miscellaneous

  * [Using external libraries for projects](<shared-code/index.html>)

  * [Running unit tests for your project libraries](<project-libs-unit-tests/index.html>)

---

## [tutorials/devtools/miscellaneous]

# Miscellaneous  
  
  * [Using external libraries for projects](<shared-code/index.html>)

  * [Running unit tests for your project libraries](<project-libs-unit-tests/index.html>)

---

## [tutorials/devtools/project-libs-unit-tests/index]

# Running unit tests on project libraries  
  
Dataiku’s project libraries allow you to centralize your code and easily call it from various places such as recipes or notebooks. However, as your project’s code base grows, you may want to assess its robustness by _testing_ it.

In this tutorial, you will create and run simple unit tests on transformations applied to a dataset.

## Prerequisites

  * Dataiku >= 11.0

  * Access to a project with the following permissions:

    * Read project content

    * Run scenarios

  * Access to a code environment with the following packages:

    * `pytest==7.2.2`




## Preparing the code and the data

In the Dataiku web interface, create a dataset from the [UCI Bike Sharing dataset](<https://archive.ics.uci.edu/ml/machine-learning-databases/00275/Bike-Sharing-Dataset.zip>) available online. There are two files in the archive to download: use only the `hour.csv` file to create a dataset in Dataiku and name it `BikeSharingData`.

Then, in your project library create a new directory called `bike_sharing` under `lib/python/`, and add two files to it:

  * `__init__.py` and leave it empty

  * `prepare.py`




The `prepare.py` file will contain the logic of our data transformation packaged into functions. There will be two of them:

  * `with_temp_fahrenheit()` will de-normalize the temperature data from the “temp” column and then convert it from Celsius to Fahrenheit degrees.

  * `with_datetime()`will combine the date and hour data from the “dteday” and “hr” columns into a single “datetime” column in the ISO 8601 format.




Here is the code for those functions:

prepare.py
    
    
    import pandas as pd
    from datetime import datetime
    
    # Useful to de-normalize tenperature.
    # Check https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset for more details
    TEMP_MIN_C = -8.0
    TEMP_MAX_C = 39.0
    
    def with_temp_fahrenheit(df: pd.DataFrame, temp_col: str) -> pd.DataFrame:
        """
        Denormalize temperature then convert it to Fahrenheit degrees.
    
        Args:
            df (pd.DataFrame): Input pandas DataFrame to chain on.
            temp_col (str): DataFrame column name for normalized temperature.
        
        Returns:
            A pandas DataFrame with a new column called "temp_F" containing
            de-normalized temperature in Fahrenheit degrees.
        """
        df["temp_F"] = 1.8 * (TEMP_MIN_C+df[temp_col].astype(float) * (TEMP_MAX_C-TEMP_MIN_C)) + 32.0
        return df
    
    def with_datetime(df: pd.DataFrame,
                      date_col: str,
                      hour_col: str) -> str:
        """
        Create a proper datetime column.
    
        Args:
            df (pd.DataFrame): Input pandas DataFrame to chain on.
            date_col (str) : column name in df containing date value (e.g. 2023-04-29)
            hour_col (str): column name in df containing hour value (e.g. 21)
        
        Returns:
            A pandas DataFrame with a new column called "datetime" containing
            date + hour information in ISO8601 format.
        """
    
        df["datetime"] = (df[date_col] + ' ' + df[hour_col].astype(str)) \
            .apply(lambda x: datetime.strptime(x, "%Y-%m-%d %H")) \
            .apply(datetime.isoformat)
        return df
    
    

You can now create a Python recipe taking `BikeSharingData` as input and a new output dataset called `BikeSharingData_prepared`. In that recipe, apply the transformations previously mentioned using pandas’ useful `pipe()` function:

recipe.py
    
    
    import dataiku
    from bike_sharing import prepare
    
    cols = ["dteday",
            "hr",
            "temp",
            "casual",
            "registered",
            "cnt"]
    
    df = dataiku.Dataset("BikeSharingData") \
        .get_dataframe() \
        [cols] \
        .pipe(prepare.with_temp_fahrenheit, temp_col="temp") \
        .pipe(prepare.with_datetime, date_col="dteday", hour_col="hr")
    
    output_dataset = dataiku.Dataset("BikeSharingData_prepared")
    output_dataset.write_with_schema(df)
    

If you inspect the output dataset, you should see the newly-created columns.

## Writing the tests

Your Flow is now operational, but what if you wanted to ensure that your code meets expected behavior and errors can be caught earlier in the development process? To address those issues, you are going to write unit tests for the `with_temp_fahrenheit()` and `with_datetime()` functions.

In a nutshell, unit tests are assertions where you verify that atomic parts of your source code operate correctly. In our case, we’ll focus on testing data transformations by submitting sample input values to the function for which we know the outcome, and comparing the result of the function with that outcome.

To run these tests, you will rely on the `pytest` package, a popular testing framework. You’ll first need to set it up so that it doesn’t make tests fail because of deprecation warnings, which can sometimes occur but should not be blocking. For that, go back to your project library and inside the `bike_sharing` tutorial create a new file called `pytest.ini` with the following content:

pytest.ini
    
    
    [pytest]
    filterwarnings = 
        ignore::DeprecationWarning
    

Next, still in the `bike_sharing` directory, create the file containing the code for your tests. Following the pytest conventions, it should be prefixed with `test_`, so call it `test_prepare.py`.

You’ll need to define sample data to run our tests on; the easiest way is to define a 1-record pandas DataFrame following the same schema as the `BikeSharingData` dataset:

test_prepare.py
    
    
    dummy_df = pd.DataFrame({
            "instant": "1",
            "dteday": "2023-01-01",
            "season": "1",
            "yr": "0",
            "mnth": "1",
            "hr": "13",
            "holiday": "0",
            "weekday": "1",
            "workingday": "0",
            "weathersit": "1",
            "temp": "1.0",
            "atemp": "0.5",
            "hum": "0.8",
            "windspeed": "0",
            "casual": "3",
            "registered": "10",
            "cnt": "13"
        }, index=[0])
    

Now let’s think a bit about how to test our functions.

### Temperature conversion

For `with_temp_fahrenheit()`, suppose we start with a normalized temperature of 1.0, which should translate into the upper boundary set as 39.0 by the [dataset documentation](<https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset>). The [Celsius-to-Fahrenheit](<https://en.wikipedia.org/wiki/Fahrenheit>) conversion formula is simple: multiply by 1.8, then add 32.0, so 39.0 degrees Celsius equal \\(1.8 \times 39.0 + 32.0 = 102.2\\) degrees Fahrenheit.

In practice, it translates into the following code:

test_prepare.py
    
    
    def test_with_temp_fahrenheit():
        out = dummy_df.pipe(with_temp_fahrenheit,
                            temp_col="temp")
        assert out["temp_F"][0] == pytest.approx(102.2)
    

### Date formatting

For `with_datetime()`, we’ll refer to the [ISO 8601](<https://en.wikipedia.org/wiki/ISO_8601>) norm: if the date is `2023-01-01` and the hour is `13`, then the resulting ISO 8601 date should be `2023-01-01T13:00:00`

Note that the time is assumed to be local to keep thing simple, so there is no time zone designator in the formatted date.

In practice, it translates into the following code:

test_prepare.py
    
    
    def test_with_datetime():
        out = dummy_df.pipe(with_datetime, date_col="dteday", hour_col="hr")
        expected_dt = datetime.datetime(2023, 1, 1, 13, 0)
        out_dt = datetime.datetime.fromisoformat(out["datetime"][0])
        assert out_dt == expected_dt
    

The entire content of your `test_prepare.py` file should now look like this:

test_prepare.py
    
    
    from bike_sharing.prepare import with_temp_fahrenheit
    from bike_sharing.prepare import with_datetime
    import datetime
    
    import pandas as pd
    import pytest
    
    dummy_df = pd.DataFrame({
            "instant": "1",
            "dteday": "2023-01-01",
            "season": "1",
            "yr": "0",
            "mnth": "1",
            "hr": "13",
            "holiday": "0",
            "weekday": "1",
            "workingday": "0",
            "weathersit": "1",
            "temp": "1.0",
            "atemp": "0.5",
            "hum": "0.8",
            "windspeed": "0",
            "casual": "3",
            "registered": "10",
            "cnt": "13"
        }, index=[0])
    
    def test_with_temp_fahrenheit():
        out = dummy_df.pipe(with_temp_fahrenheit,
                            temp_col="temp")
        assert out["temp_F"][0] == pytest.approx(102.2)
    
    def test_with_datetime():
        out = dummy_df.pipe(with_datetime, date_col="dteday", hour_col="hr")
        expected_dt = datetime.datetime(2023, 1, 1, 13, 0)
        out_dt = datetime.datetime.fromisoformat(out["datetime"][0])
        assert out_dt == expected_dt
    

Our tests are now ready! The only thing that is missing is scheduling their execution.

## Running tests

There are several ways to schedule the execution of your tests, from a purely manual approach to running a full-fledged CI pipeline. In this tutorial you will take a simple approach by regrouping the execution of the tests and the build of the `BikeSharingData_prepared` into a Dataiku scenario. Concretely, that scenario will build the dataset only if all tests pass: this way, you are able to guard against unintended behavior in your data transformation effectively.

Go to **Scenario > New Scenario > Sequence of steps**, call your scenario “Test and build” then click on **Create**. Then go to **Steps > Add step > Execute Python code**, and in the “Script” field enter the following code:

step.py
    
    
    import pytest
    import bike_sharing
    
    from pathlib import Path
    
    lib_path = str(Path(bike_sharing.__file__).parent)
    
    ret = pytest.main(["-x", lib_path])
    if ret !=0:
        raise Exception("Tests failed!")
    

If you are already familiar with pytest, you probably run your tests directly in a terminal with the `pytest` command. The same result is achieved here by calling the `pytest.main()` function within your Python code. Note that it requires the absolute path of your project library directory to retrieve the test code and configuration files stored here in the `lib_path` variable.

Don’t forget that you will need to run this code with the code environment that contains the pytest package! For that, select it in the **Environment** dropdown list.

The only thing missing now is to build your dataset: go to **Add step > Build/Train**, then click on _Add dataset to build_ and select `BikeSharingData_prepared`.

Your scenario is now complete! You can check if it works properly by clicking on **Run** : it will launch a manual run that should run successfully. If you want to inspect the pytest output, go to **Last runs** , select the desired run then next to “Custom Python” click on “View step log.”

## Wrapping up

Congratulations, you have written your first unit tests in Dataiku! In this tutorial, you have defined functions and unit tests for data processing, embedded them into project libraries then automated the test executions using a scenario.

You can now extend that logic and write tests to check the data itself, [this tutorial](<../../data-engineering/data-quality-sql/index.html>) has a few examples on how to implement data quality checks.

---

## [tutorials/devtools/public-api-intro/index]

# Dataiku’s Public API: A Comprehensive Guide

The public API of Dataiku is a powerful tool for automating tasks and programmatically interacting with your instance’s components. This tutorial will guide you through its basics and provide a few good practices for using it efficiently.

## Prerequisites

  * Dataiku >= 11.4

  * Dataiku’s Python API client is properly set up on your client machine following [this tutorial](<../python-client/index.html>).




## A bit of architecture

When working on Dataiku, under the hood, every user interacts with the platform’s _backend_. In short, Dataiku’s backend is an essential process that is responsible for managing many configuration items and orchestrating all running tasks.

The main interface to interact with the backend is through your browser by accessing Dataiku’s web interface. However, to provide more flexibility to advanced users, there is a programmatic alternative: Dataiku’s public API.

At its core, Dataiku’s public API is a collection of RESTful API endpoints that can be queried via HTTP. Working at this fine-grained level can be cumbersome and requires lots of code to manage the HTTP query properly. We strongly advise our coder users to rely on the Python client instead. Please refer to [this documentation](<../rest-api/index.html>) for more information on the REST API and its usage.

### The benefits of the Python API client

Dataiku’s Python API client is explicitly built to speed up the work of programmatic users. It wraps low-level endpoint operations into helper functions that make for more transparent and concise code. Additionally, working at a higher level removes the need for the user to manually parse the (often complex) responses provided by the REST API endpoints.

Retrieving a dataset’s schema with the Python API client would look like this:
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_project("YOURPROJECTKEY")
    dataset = project.get_dataset("yourDataset")
    schema = dataset.get_schema()
    
    print(schema)
    

which should output:
    
    
    {
        columns: [
            {"name": "Column1", type: "string", maxLength: -1},
            {"name": "Column2", type: "bigint"},
            ...
        ]
    }
    

From the previous code snippet, you can see that you have to manipulate a few handles before getting to the final result. You’ll learn more about them in the next section.

## Using the Python API handles

Code written with the Python API client follows a pattern where the user:

  1. First, “log in” by providing credentials when instantiating a [`dataikuapi.DSSClient`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient") object, which acts as the main entry point to interact with the API.

  2. Then, navigate through a _hierarchy of scopes_ to reach the item of interest they want to interact with.

  3. Finally, get a handle object on that item and manipulate it using the relevant methods at their disposal.




To illustrate this, let’s decompose the previous code snippet:

  * import dataiku
        
        client = dataiku.api_client()
        

First, a `client` (a [`dataikuapi.DSSClient`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient") object) is created and gives access to the _instance-level scope_ , which, as the name indicates, allows you to perform operations on your Dataiku instance, such as:

    * Editing the administration settings

    * Creating projects and project folders

Of course, these actions are only available if you have the proper permissions. We’ll get to this in the last section of the tutorial.

  * project = client.get_project("YOURPROJECTKEY")
        

Then, the scope shifts to the _project-level_ : you acquire a handle on a specific project from the `client` object. More precisely, the `project` variable you create is an instance of [`DSSProject`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject") obtained through the [`dataikuapi.DSSClient.get_project()`](<../../../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project") method. It allows you to perform operations only within the `YOURPROJECTKEY` project and manipulate _project-level_ items, for example:

    * Datasets

    * Recipes

    * Scenarios

  * dataset = project.get_dataset("yourDataset")
        

Following the same logic, you switch from the _project-level_ scope to the _dataset-level scope_ by creating a [`DSSDataset`](<../../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset") object via [`get_dataset()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_dataset> "dataikuapi.dss.project.DSSProject.get_dataset"). From there, the `dataset` variable allows you to handle all items relative to the `yourDataset` dataset within the `YOURPROJECTKEY` project, such as:

    * Schema

    * Metrics

    * Checks

  * schema = dataset.get_schema()
        

Finally, within the _dataset-level_ scope, you can obtain a handle on the dataset’s schema to display using the [`get_schema()`](<../../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_schema> "dataikuapi.dss.dataset.DSSDataset.get_schema") method. Other examples of _dataset-level_ operations are:

    * Listing the existing partitions

    * Getting the last computed metric values

    * Running checks




In summary, interacting programmatically with a given item is all about traversing the proper scopes, as illustrated in this diagram:

## Authentication, scopes, and permissions

When instantiating the [`DSSClient`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient") object, the standard practice is to pass a [personal API key](<https://doc.dataiku.com/dss/latest/publicapi/keys.html> "\(in Dataiku DSS v14\)") to authenticate (for more information, please refer to [Connecting to your Dataiku instance](<../python-client/index.html#connecting-dataiku-instance>)). All the subsequent actions will then be executed as the Dataiku user who owns the key. They will also be bounded by the permissions granted to that user.

For example, if your user doesn’t have permission to create projects when you try running this:
    
    
    import dataiku
    
    dataiku.set_remote_dss("https://dss.example", "YOURAPIKEY")
    client = dataiku.api_client()
    client.create_project("MYKEY", "My project", "myuserlogin")
    

Your code will fail after throwing an exception:
    
    
    DataikuException: java.lang.SecurityException: You may not create new projects
    

The [security section](<https://doc.dataiku.com/dss/latest/security/index.html> "\(in Dataiku DSS v14\)") in Dataiku’s reference documentation provides more details on its permission system.

## Wrapping up

You now have the basics to manipulate Dataiku’s public API through its Python client! If you are looking for specific API documentation, the client is extensively documented in the [API reference section](<../../../api-reference/python/index.html>).

---

## [tutorials/devtools/pycharm-plugin/index]

# PyCharm plugin for Dataiku

The PyCharm plugin for Dataiku enables you to connect to a Dataiku instance from your PyCharm environment and edit the following items:

Item | Editable ?  
---|---  
Code recipes | ✅  
Project libraries | ✅  
Plugins | ✅  
Notebooks | ❌  
Webapps (standard) | ❌  
Webapps (Bokeh) | ❌  
Webapps (Shiny) | ❌  
Webapps (Dash) | ❌  
Webapps (Streamlit) | ❌  
Wiki | ❌  
  
This tutorial will provide an overview of some of these capabilities through a simple example.

Caution

The Dataiku PyCharm plugin provides a richer edition environment, but doesn’t act as a full replacement for the web interface. Several important operations will still be done visually in your browser.

## Prerequisites

  * [PyCharm](<https://www.jetbrains.com/pycharm/>) installed on your local computer

  * A Dataiku API local environment set up. For detailed steps, see [this tutorial](<../python-client/index.html>)

  * “Write project content” permission on an existing Dataiku project




If you can’t install the required components on your computer, we advise that you use [Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/concepts.html> "\(in Dataiku DSS v14\)") instead.

## Setting up the plugin

  * Start by installing the plugin from the [JetBrains plugin repository](<https://plugins.jetbrains.com/plugin/12511-dataiku-dss>)

  * In PyCharm, create a new project. When setting up your project, do not create a new Python environment, instead:

    * Select the “Previously configured interpreter” option and click on “Add Interpreter > Add Local Interpreter…”

    * For “Environment”, select “Existing”

    * For “Interpreter”, select the path to your Dataiku API local environment’s Python executable

    * Finish the configuration by clicking on “Create”




You should now have your PyCharm project up and ready. The last setup step is to enable the Dataiku plugin.

Go to “File > Open Dataiku DSS…” and:

  * Don’t change the “module” field

  * In “DSS instance” select the name and URL of your target instance

  * in “type”, select the kind of Dataiku item you want to edit, in your case we’ll start with “Library”




Click on “Next”, then select which Dataiku project you want to work on, and click on “Create”.

In your PyCharm project layout, you should now see your Dataiku project and its libraries in the side panel. From there , you should be able to access their source code.

## Editing project libraries and code recipes

The first item we will edit in PyCharm is the project library.

In the Dataiku web interface, start by creating a dataset from the [Seoul bike sharing demand dataset](<https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand>) available online and name it `SeoulBikeData`. In your newly-created dataset, to prevent character encoding issues, go to “Settings > Schema” and rename the following columns:

  * `Temperature(°C)` -> `Temperature_C`

  * `Dew point temperature(°C)` -> `Dew point temperature_C`




Then, switch to PyCharm and in your project, create a new directory called `bikes` under `lib/python/`. Inside that directory, create the following files:

  * `__init__.py` and leave it empty

  * `prepare.py` with the following code:
        
        import pandas as pd
        
        COLUMNS = ["Date", "Hour", "Temperature_C", "Wind speed (m/s)"]
        
        def celsius_to_fahrenheit(df: pd.DataFrame,
                                     temp_celsius_col: str,
                                     temp_fahrenheit_col: str) -> pd.DataFrame:
            df[temp_fahrenheit_col] = (df[temp_celsius_col] * 1.8) + 32.0
            return df
        
        def ms_to_kmh(df: pd.DataFrame,
                      wind_ms_col: str,
                      wind_kmh_col: str) -> pd.DataFrame:
            df[wind_kmh_col] = df[wind_ms_col] * 3.6
            return df
        




Note that every time you save your file(s) in PyCharm, they are automatically synchronized to the Dataiku instance.

Next, come back to the Dataiku web interface and:

  * create a Python recipe using `SeoulBikeData` as input and a new dataset called `SeoulBikeData_prepared` as output

  * save the recipe

  * go back to the Flow screen




Switch to PyCharm and open your newly-created recipe. To do so, go to “File > Open Dataiku DSS…” and this time select the “Recipe” type. After clicking on “Next”, you should see a list of the available recipes in your target Dataiku project. The one you just created should appear as `compute_SeoulBikeData_prepared`: select it and click on “Create” to start editing the recipe in PyCharm and replace the boilerplate code by this one:
    
    
    import dataiku
    import pandas as pd
    
    from bikes.prepare import celsius_to_fahrenheit
    from bikes.prepare import ms_to_kmh
    from bikes.prepare import COLUMNS
    
    SeoulBikeData = dataiku.Dataset("SeoulBikeData")
    df_in = SeoulBikeData.get_dataframe(columns=COLUMNS)
    
    df_out = df_in \
        .pipe(celsius_to_fahrenheit,
              temp_celsius_col="Temperature_C",
              temp_fahrenheit_col="Temperature_F") \
        .pipe(ms_to_kmh,
              wind_ms_col="Wind speed (m/s)",
              wind_kmh_col="Wind_speed_kmh") \
        .round(2)
    
    SeoulBikeData_prepared = dataiku.Dataset("SeoulBikeData_prepared")
    SeoulBikeData_prepared.write_with_schema(df_out)
    
    

Don’t forget to save your recipe’s code! Same as for project libraries, it will synchronize it with the Dataiku instance. Your recipe is now ready to be run !

## Building datasets

In order to build the `SeoulBikeData_prepared` dataset you have two options: either trigger it from the Dataiku web interface or from PyCharm. Each case is further explained below.

### From the Dataiku web interface

This option is the simplest one: from the Flow screen, right-click on the `SeoulBikeData_prepared` dataset and choose “Build…”, keep the default settings (“Not recursive”) then click on “Build dataset”. Once the dataset is built you can inspect its content by clicking on it.

### From PyCharm

As opposed to the VSCode extension, you cannot run recipes remotely from PyCharm in a one-click fashion. Instead, you can leverage the Dataiku API from PyCharm to launch the job that will build your output dataset. To do so, create a new Python file called `build.py` inside your PyCharm project and populate it with the following code:
    
    
    import dataiku
    
    client = dataiku.api_client()
    
    # Uncomment this if your instance has a self-signed certificate
    # client._session.verify = False
    
    project = client.get_project("YOUR_PROJECT_KEY")
    
    output_dataset = project.get_dataset("SeoulBikeData_prepared")
    output_dataset.build()
    

To run your script, make sure that the current run/debug configuration is set to `build` (the name of your script) and click on the “Run” button. This will open the run tool window: if after some time you see a message saying “Processed finished with code 0” it means that your dataset was successfully built.

## Wrapping up

Congratulations, you now have a fully functional setup to leverage your PyCharm editor alongside your Dataiku instance! To dive deeper into the Dataiku API, you can read the [dedicated page](<../../../api-reference/python/index.html>).

---

## [tutorials/devtools/python-client/index]

# Using Dataiku’s Python packages

## Using the client from inside Dataiku

You have nothing to do when you use the client from inside Dataiku. The packages are preinstalled, and you don’t need to provide an API key. The client will inherit credentials from the current context. Both packages (`dataiku` and `dataikuapi`) can be used. The easiest way to create a client is:
    
    
    import dataiku
    
    client = dataiku.api_client()
    
    # client is now a DSSClient and can perform all authorized actions.
    # For example, list the project keys for which you have access
    client.list_project_keys()
    

## Using the client from outside Dataiku

There are a few additional setup steps to complete. This tutorial will help you set up your local environment by following these steps.

## Prerequisites

  * Access to a Dataiku instance via an API key (see [the documentation](<https://doc.dataiku.com/dss/latest/publicapi/keys.html> "\(in Dataiku DSS v14\)") for explanations on how to generate one)

  * Python >= 3.9 with the following packages:

    * `numpy`

    * `pandas`




Note

This tutorial has been tested with `Python 3.10` and
    
    
    numpy==2.1.1
    pandas==2.2.2
    

## Building your local virtual environment

The first step is to create a Python virtual environment on your computer in which you will install all the required dependencies.

  * Generate a new virtual environment using the tool of your choice (venv, Pipfile, poetry). In this tutorial, we’ll use `venv` and call our environment `dataiku_local_env`:
        
        # Create the virtual environment
        python3 -m venv dataiku_local_env
        
        # Activate the virtual environment
        source dataiku_local_env/bin/activate
        




### Installing the `dataiku` package

Via pipIn a requirements.txtManually

Install the `dataiku` package by running the following command
    
    
    pip install http(s)://DATAIKU_HOST:DATAIKU_PORT/public/packages/dataiku-internal-client.tar.gz
    

Warning

If your instance has a self-signed or expired certificate, to connect with HTTP, you will need to add the `--trusted-host` flag:
    
    
    pip install http(s)://DATAIKU_HOST:DATAIKU_PORT/public/packages/dataiku-internal-client.tar.gz --trusted-host=DATAIKU_HOST:DATAIKU_PORT
    

In your requirements.txt file, add a line:
    
    
    http(s)://DATAIKU_HOST:DATAIKU_PORT/public/packages/dataiku-internal-client.tar.gz
    

Then update your requirements with `pip install -r requirements.txt`

If you use HTTPS without a proper certificate, you may need to add `--trusted-host=DATAIKU_HOST:DATAIKU_PORT` to your pip command line.

  * Download the package’s tar.gz file from your Dataiku instance:

`http(s)://DATAIKU_HOST:DATAIKU_PORT/public/packages/dataiku-internal-client.tar.gz`

  * Install it with `pip install dataiku-internal-client.tar.gz`




### Installing the `dataikuapi` package

Install the `dataikuapi` package directly from the PyPI repository:
    
    
    pip install dataiku-api-client
    

This installs the client in the system-wide Python installation, so if you are not using virtualenv, you may need to replace `pip` with `sudo pip`.

Note that this will always install the latest version of the API client. You might need to request a version that is compatible with your Dataiku version.

When connecting from the outside world, you need an API key. See [Public API Keys](<https://doc.dataiku.com/dss/latest/publicapi/keys.html> "\(in Dataiku DSS v14\)")) for more information on creating an API key and the associated privileges.

You also need to connect using the base URL of your Dataiku instance.

Once all relevant packages are installed, you can connect with your Dataiku instance.

## Connecting to your Dataiku instance

Using dataiku packageUsing the dataikuapi package

The connection with your Dataiku instance will be established by the `dataiku` package, which will look for :

  * the instance URL,

  * the API key to use for authentication.




You can provide this information in different ways:

  * **directly inside your code** , by using the `set_remote_dss()` method and replacing `YOURAPIKEY` with your own API key:
        
        import dataiku
        dataiku.set_remote_dss("https://dss.example", "YOURAPIKEY")
        

Warning

If your instance has a self-signed or expired certificate, in order to connect with HTTPS you will need to pass the `no_check_certificate` flag:
        
        import dataiku
        
        dataiku.set_remote_dss("https://dss.example", "YOURAPIKEY", no_check_certificate=True)
        client = dataiku.api_client()
        print(client.list_project_keys())
        

  * **with environment variables** to be initialized before starting your Python environment:
        
        export DKU_DSS_URL="https://dss.example"
        export DKU_API_KEY="YOURAPIKEY"
        
        
        import dataiku
        
        client = dataiku.api_client()
        print(client.list_project_keys())
        

Warning

You can not turn off certificate checking via environment variables.

  * **with a configuration file** that should be located at `$HOME/.dataiku/.config.json` (or `%USERPROFILE%/.dataiku/config.json` on Windows) with the following structure:
        
        {
          "dss_instances": {
            "default": {
              "url": "https://dss.example",
              "api_key": "YOURAPIKEY"
            }
          },
          "default_instance": "default"
        }
        
        
        import dataiku
        
        client = dataiku.api_client()
        print(client.list_project_keys())
        

Warning

If your instance has a self-signed or expired certificate, in order to connect with HTTPS you will need to add the `no_check_certificate` property:
        
        {
          "dss_instances": {
            "default": {
              "url": "https://dss.example",
              "api_key": "YOURAPIKEY",
              "no_check_certificate": true
            }
          },
          "default_instance": "default"
        }
        

If at some point you need to clear the connection settings, you can do so with the following code:
        
        dataiku.clear_remote_dss()
        

The configuration will be cleared. If you are using the client within your Dataiku instance, it will target the API of your instance.




To work with the API, a connection needs to be established with Dataiku, by creating a [`DSSClient`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient") object. Once the connection is established, the [`DSSClient`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient") object serves as the entry point to the other calls.
    
    
    import dataikuapi
    
    host = "http://localhost:11200"
    apiKey = "some_key"
    client = dataikuapi.DSSClient(host, apiKey)
    
    # client is now a DSSClient and can perform all authorized actions.
    # For example, list the project keys for which the API key has access
    client.list_project_keys()
    

Warning

If your Dataiku has SSL enabled, the package will verify the certificate. In order for this to work, you may need to add the root authority that signed the Dataiku SSL certificate to your local trust store. Please refer to your OS or Python manual for instructions.

If this is not possible, you can also disable checking the SSL certificate by using `DSSClient(host, apiKey, insecure_tls=True)`

## Testing your setup

The last step is to check if you can properly connect to your Dataiku instance. For that, you can use the code snippet below:
    
    
    import dataiku
    
    # Uncomment this if you are not using environment variables or a configuration file
    # dataiku.set_remote_dss("https://dss.example", "YOURAPIKEY")
    
    client = dataiku.api_client()
    
    # Uncomment this if your instance has a self-signed certificate
    # client._session.verify = False
    
    info = client.get_auth_info()
    print(info)
    
    

If all goes well, you should see an output similar to this:
    
    
    {
        "authSource": "PERSONAL_API_KEY",
        "via": [],
        "authIdentifier": "your-user-name",
        "groups": ["one_group", "another_group"],
        "userProfile": "DESIGNER",
        "associatedDSSUSer": "your-user-name",
        "userForImpersonation": "your-user-name"
    }
    

If so, congratulations: your setup is now fully operational! You can move on and set up Dataiku plugins/extensions in your favorite IDE or learn more about how to automate things using the public API.

---

## [tutorials/devtools/rest-api/index]

# Dataiku REST API

At its core, Dataiku’s public API is a collection of RESTful API endpoints that can be queried via HTTP. Working at this fine-grained level can be cumbersome and require lots of code to manage the HTTP query properly. While Dataiku’s REST API endpoints are [fully documented](<https://doc.dataiku.com/dss/api/latest/rest/>), the use of this documentation may require a significant investment.

## Prerequisites

  * Access to a Dataiku instance via an API key (see [the documentation](<https://doc.dataiku.com/dss/latest/publicapi/keys.html> "\(in Dataiku DSS v14\)") for explanations on how to generate one)




## Introduction

For example, if you want to retrieve the schema of a given dataset, you would send the following request:
    
    
    GET /public/api/projects/yourProjectKey/datasets/yourDataset/schema
    
    HTTP/1.1
    Host: yourinstance.com
    Content-Type: application/json
    Authorization: Bearer your-api-key
    

If it’s successful, the response will look like this:
    
    
    HTTP/1.1 200 OK
    Content-Type: application/json;charset=utf-8
    DSS-Version: x.x.x
    DSS-API-Version 1
    
    {
        columns: [
            {"name": "Column1", type: "string", maxLength: -1},
            {"name": "Column2", type: "bigint"},
            ...
        ]
    }
    

## Sending requests

All calls in the Dataiku public API are relative to the `/public/api` path on the Dataiku server.

For example, if your Dataiku server is available at `http://DATAIKU_HOST:DATAIKU_PORT/`, and you want to call the [List projects API](<https://doc.dataiku.com/dss/api/latest/rest/#projects-projects-get>), you must make a GET request on `http://DATAIKU_HOST:DATAIKU_PORT/public/api/projects/`

### Project list

cUrljavascriptHTTP client
    
    
    curl --request GET \
      --url http://DATAIKU_HOST:DATAIKU_PORT/public/api/projects/ \
      --header 'Authorization: Bearer YOUR_USER_API_KEY' \
      --header 'Content-Type: application/json'
    
    
    
    import axios from "axios";
    
    const options = {
      method: 'GET',
      url: 'http://DATAIKU_HOST:DATAIKU_PORT/public/api/projects/',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer YOUR_USER_API_KEY'
      }
    };
    
    axios.request(options).then(function (response) {
      console.log(response.data);
    }).catch(function (error) {
      console.error(error);
    });
    

Figure 1: Postman request.

---

## [tutorials/devtools/shared-code/index]

# Using external libraries for projects

## Prerequisites

  * Dataiku >= 14

  * Access to a Dataiku instance with a personal API Key

  * Access to an existing project with the following permissions:
    
    * “Read project content”

    * “Write project content”

  * A GitHub account with a public SSH key. You need this to download a Python file from the [Dataiku Academy Samples](<https://github.com/dataiku/academy-samples>) repository using SSH.




Note

Visit [GitHub Docs](<https://docs.github.com/en/get-started/signing-up-for-github/signing-up-for-a-new-github-account>) to learn how to sign up for a GitHub account. For more information about adding a public SSH key to your account, visit GitHub Docs: [Connecting to GitHub with SSH](<https://docs.github.com/en/authentication/connecting-to-github-with-ssh>).

## Introduction

Developers benefit from collective knowledge when they code with others developing projects on the same Dataiku instance. One of the most common ways to access and share code in Dataiku is through project libraries. When the code you need is available in a Git repository, you can import it into your project library and share that library with other projects for maximum reusability. To learn more about Git and Dataiku, visit [Working with Git](<https://doc.dataiku.com/dss/latest/collaboration/git.html> "\(in Dataiku DSS v14\)") and [Importing code from Git in project libraries](<https://doc.dataiku.com/dss/latest/collaboration/import-code-from-git.html> "\(in Dataiku DSS v14\)").

Contrary to [Global shared python code](<https://doc.dataiku.com/dss/latest/python/reusing-code.html> "\(in Dataiku DSS v14\)"), importing a library directly from Git allows for efficient versioning and conflict resolution. It also ensures that each project has its dedicated allocated resources and is not flooded with irrelevant libraries.

In this tutorial, you will create a single project library to share among projects.

You will use the Shared Code starter projects: [Project A](<https://cdn.downloads.dataiku.com/public/dss-samples/DKU_TUT_SHARECODE_A/>) and [Project B](<https://cdn.downloads.dataiku.com/public/dss-samples/DKU_TUT_SHARECODE_B/>) as a starting template. Both projects can be created by clicking the **New project** button, selecting **Learning projects** , and choosing **Project A** or **B** from the **Developer** subtype. If you prefer, you can download them by clicking on the provided links and manually installing them.

Note

All steps in this tutorial that require code and API usage can be performed within Dataiku using a notebook or directly with the UI. For the latest, please see [Concept | Shared code](<https://knowledge.dataiku.com/latest/code/shared/concept-shared-code.html> "\(in Dataiku Academy v14.0\)"). For clarity and clarification, most of the steps and code will assume you are interacting with the platform from an external IDE.

## Creating a code library in Project A

In this section, you will add the `monthly_total_transactions` Python function to our shared code library in `Project A` by cloning a library from the [Dataiku Academy samples repository](<https://github.com/dataiku/academy-samples/blob/main/shared-code/total_transactions.py>). This function applies a group-by to a dataset and returns a new one. The first thing to do is to connect to your instance and get the project.

Note

This repository is public, hence the fetch is made with HTTPS.
    
    
    import dataiku
    
    DSS_HOST = ""  # Fill in your DSS instance's URL
    API_KEY = "" # Fill in your personal API key to access that instance
    
    # Connect to your instance
    dataiku.set_remote_dss(f"http://{DSS_HOST}", API_KEY)
    client = dataiku.api_client()
    
    # Work with the provided Project A
    PROJECT_KEY_A = "DKU_TUT_SHARECODE_A" # Replace with the correct project key
    project_a = client.get_project(PROJECT_KEY_A)
    
    project_git = project_a.get_project_git()
    
    # Add an external library to those already present
    REPO_URL = 'https://github.com/dataiku/academy-samples.git'
    GIT_PATH = 'shared-code'
    
    project_git.add_library(REPO_URL, 'python', 'main', path_in_git_repository=GIT_PATH, as_type='object')
    

Note that you’ll need to force a reload to get the new library if you are working on a Jupyter notebook.

You can then handle the project dataset and apply the new function.
    
    
    # import useful data manipulation packages
    import pandas as pd, numpy as np
    # import new library
    from total_transactions import monthly_total_transactions
    
    # Read recipe inputs
    ecommerce_transactions = dataiku.Dataset("ecommerce_transactions")
    ecommerce_transactions_df = ecommerce_transactions.get_dataframe()
    
    # Apply new functions to our dataset
    monthly_transactions_df = monthly_total_transactions(ecommerce_transactions_df)
    

## Sharing the library with other projects

First, get the second project so you can access its library.
    
    
    # Get the second project
    PROJECT_KEY_B = "DKU_TUT_SHARECODE_B" # Replace with the correct project key
    project_b = client.get_project(PROJECT_KEY_B)
    
    lib_b = project_b.get_library()
    

Then, you can read the library’s JSON and write the project key for `Project A`. This way, you’ll have access, in `Project B`, to all the code available in the `Project A` library.
    
    
    import json
    
    # Read the external library to get the JSON format
    external_libraries_json = json.loads(lib_b.get_file("/external-libraries.json").read())
    # Add the project key of the first project to access its library
    external_libraries_json['importLibrariesFromProjects'].append(PROJECT_KEY_A)
    # Write the new JSON into the library
    lib_b.get_file("/external-libraries.json").write(json.dumps(external_libraries_json, indent=2))
    

To finish, you can apply the shared function to the new dataset.

Important

If you are working on a notebook, you may need to completely reload it to access the new external libraries once imported.
    
    
    # read recipe inputs
    online_retail_dataset = dataiku.Dataset("online_retail_dataset")
    online_retail_dataset_df = online_retail_dataset.get_dataframe()
    
    df_gby = monthly_total_transactions(online_retail_dataset_df, date_col= 'InvoiceDate', marketplace_col = 'CustomerID')
    

Tip

You can access the right parameters with this line of code to ensure you have the right parameters.
    
    
    params = monthly_total_transactions.__code__.co_varnames[:monthly_total_transactions.__code__.co_argcount]
    print(params)
    

## Wrapping up

This example demonstrates the procedure for sharing code across multiple projects using APIs. It underscores Dataiku’s capability to facilitate programmatic interactions and collaboration among various projects, significantly enhancing the reusability and scalability of code within the platform.

### Complete code

Code: Complete API for Shared Code
    
    
    import dataiku
    
    DSS_HOST = ""  # Fill in your DSS instance's URL
    API_KEY = "" # Fill in your personal API key to access that instance
    
    # Connect to your instance
    dataiku.set_remote_dss(f"http://{DSS_HOST}", API_KEY)
    client = dataiku.api_client()
    
    # Work with the provided Project A
    PROJECT_KEY_A = "DKU_TUT_SHARECODE_A" # Replace with the correct project key
    project_a = client.get_project(PROJECT_KEY_A)
    
    project_git = project_a.get_project_git()
    
    # Add an external library to those already present
    REPO_URL = 'https://github.com/dataiku/academy-samples.git'
    GIT_PATH = 'shared-code'
    
    project_git.add_library(REPO_URL, 'python', 'main', path_in_git_repository=GIT_PATH, as_type='object')
    
    # import useful data manipulation packages
    import pandas as pd, numpy as np
    # import new library
    from total_transactions import monthly_total_transactions
    
    # Read recipe inputs
    ecommerce_transactions = dataiku.Dataset("ecommerce_transactions")
    ecommerce_transactions_df = ecommerce_transactions.get_dataframe()
    
    # Apply new functions to our dataset
    monthly_transactions_df = monthly_total_transactions(ecommerce_transactions_df)
    
    # Get the second project
    PROJECT_KEY_B = "DKU_TUT_SHARECODE_B" # Replace with the correct project key
    project_b = client.get_project(PROJECT_KEY_B)
    
    lib_b = project_b.get_library()
    
    import json
    
    # Read the external library to get the JSON format
    external_libraries_json = json.loads(lib_b.get_file("/external-libraries.json").read())
    # Add the project key of the first project to access its library
    external_libraries_json['importLibrariesFromProjects'].append(PROJECT_KEY_A)
    # Write the new JSON into the library
    lib_b.get_file("/external-libraries.json").write(json.dumps(external_libraries_json, indent=2))
    
    # read recipe inputs
    online_retail_dataset = dataiku.Dataset("online_retail_dataset")
    online_retail_dataset_df = online_retail_dataset.get_dataframe()
    
    df_gby = monthly_total_transactions(online_retail_dataset_df, date_col= 'InvoiceDate', marketplace_col = 'CustomerID')
    

### Reference documentation

#### Classes

[`dataikuapi.DSSClient`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.project.DSSProjectGit`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit> "dataikuapi.dss.project.DSSProjectGit")(client, ...) | Handle to manage the git repository of a DSS project (fetch, push, pull, ...)  
[`dataikuapi.dss.project.DSSProject`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.projectlibrary.DSSLibrary`](<../../../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary> "dataikuapi.dss.projectlibrary.DSSLibrary")(...) | A handle to manage the library of a project It saves locally a copy of taxonomy to help navigate in the library All modifications done through this object and related library items are done locally and on remote.  
  
#### Functions

[`add_library`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit.add_library> "dataikuapi.dss.project.DSSProjectGit.add_library")(repository, local_target_path, ...) | Add a new external library to the project and pull it.  
---|---  
[`get_dataframe`](<../../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe")([columns, sampling, ...]) | Read the dataset (or its selected partitions, if applicable) as a Pandas dataframe.  
[`get_file`](<../../../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary.get_file> "dataikuapi.dss.projectlibrary.DSSLibrary.get_file")(path) | Retrieves a file in the library  
[`get_library`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_library> "dataikuapi.dss.project.DSSProject.get_library")() | Get a handle to manage the project library  
[`get_project`](<../../../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`get_project_git`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_project_git> "dataikuapi.dss.project.DSSProject.get_project_git")() | Gets an handle to perform operations on the project's git repository.

---

## [tutorials/devtools/using-api-with-git-project/index]

# Using the API to interact with git for project versioning  
  
## Prerequisites

  * Dataiku >= 12.4.2

  * Access to a Dataiku instance with a personal API Key

  * Access to an existing project with the following permissions:
    
    * “Read project content”

    * “Write project content”

  * Access to an external git repository with necessary authentication




## Introduction

The git integration allows you to perform versioning in Dataiku directly in your IDE using the API client. This tutorial presents a day-to-day use case using git and project variables.

You will use the [Variable for Coders starter project](<https://cdn.downloads.dataiku.com/public/dss-samples/DKU_TUT_VARCOD/>) as a starting template. Its associated [tutorial](<https://knowledge.dataiku.com/latest/automate-tasks/variables/tutorial-variables-with-code.html>) provides a set of steps implemented via the UI. This complementary tutorial shows the feasibility of using only code from outside Dataiku to interact with the platform.

Note

All steps in this tutorial that require code and API usage can be performed within Dataiku using one of the hosted notebooks. For clarity and clarification, most of the steps and code will assume you are interacting with the platform from an external IDE.

## Connecting to the instance

A tutorial on connecting to the instance is already available [here](<../python-client/index.html#connecting-dataiku-instance>) but to quickly start, here is the code:

Refresher - connecting to the instance
    
    
    import dataiku
    
    DATAIKU_HOST = ""  # Fill in your Dataiku instance's URL
    API_KEY = "" # Fill in your personal API key to access that instance
    
    # connect to your instance
    dataiku.set_remote_dss(f"http://{DATAIKU_HOST}", API_KEY)
    client = dataiku.api_client()
    
    # list all the projects of the instance 
    project_keys = client.list_project_keys()
    print(f"N-projects on instance: {len(project_keys)}")
    

## Managing the repository

The first step is to interact with the project via a handle.
    
    
    # work with a specific sample project
    PROJECT_KEY = "DKU_TUT_VARCOD"
    project = client.get_project(PROJECT_KEY)
    

Next, manage the project git to target the remote repository. Please note that you will use the SSH address instead of the URL to connect.
    
    
    USERNAME = "" # Fill in your username
    REPO = "" # Fill in your repo
    
    # get the project git!
    project_git = project.get_project_git()
    
    # .. and set the remote
    project_git.set_remote(f"{USERNAME}@{REPO}:{PROJECT_KEY}")
    

If the project is already associated with a remote repository, you can show its address using the [`get_remote()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit.get_remote> "dataikuapi.dss.project.DSSProjectGit.get_remote") method.
    
    
    # create a new branch
    project_git.create_branch('definitely-not-master')
    project_git.checkout('definitely-not-master')
    

You have now created your working branch, on which changes will be tracked. If they exist, [`list_branches()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit.list_branches> "dataikuapi.dss.project.DSSProjectGit.list_branches") allows you to check the other branches of the repository.

## Making unit changes to and using code

### Add project variables

Next, you’ll replicate the [steps of this section](<https://knowledge.dataiku.com/latest/automate-tasks/variables/tutorial-variables-with-code.html#define-project-variables>) of the original tutorial.
    
    
    # add these variables
    project.update_variables({
       "country_name": "Germany",
       "merchant_url": "lidl"})
    

Update the project variables using the [`update_variables()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.update_variables> "dataikuapi.dss.project.DSSProject.update_variables") method. It takes a dictionary of variable names and their new values. The code adds two variables: `country_name` and `merchant_url`. You can retrieve these stored variables using the [`get_variables()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_variables> "dataikuapi.dss.project.DSSProject.get_variables") method.

### Edit code recipe

Now, you’ll implement [the next part of the other tutorial](<https://knowledge.dataiku.com/latest/automate-tasks/variables/tutorial-variables-with-code.html#use-variables-in-a-code-recipe>), editing the recipe to incorporate these variables. These new lines will switch the hardcoded `United States` with the `country_name` variable.
    
    
    country_name = dataiku.get_variables()["country_name"]
    df_filtered = df[df['MerchantIP_country'] == country_name]
    

The recipe that needs editing is called `compute_dy9hOjP1`. To access the project’s recipes from an IDE, you could use the [Dataiku VSCode extension](<../vscode-extension/index.html#setting-up-the-vscode-extension>) or a [Code Studio instance](<../using-vscode-for-code-studios/index.html#editing-recipe-with-code-studio>) to get a VSCode-like experience. You can also update the recipe from the Dataiku UI, for example, using a Jupyter notebook.

Dataiku VSCode extensionCode Studio

## Publishing changes

Once the changes are made, you can get the branch’s status, make commits and push these changes.
    
    
    project_git.get_status()
    project_git.commit(message="add project vars")
    project_git.push()
    

Note

Dataiku enables auto-commit as the **default** commit-tracking behavior. Hence, if you’ve made changes via the UI, you only have to [`push()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit.push> "dataikuapi.dss.project.DSSProjectGit.push") at the end. If you wish to make your commits manually, you can switch to **Explicit** mode under **Settings > Change Management > Commit mode**.

The [`commit()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit.commit> "dataikuapi.dss.project.DSSProjectGit.commit") function already includes `git add`, so files marked as _untracked_ in [`get_status()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit.get_status> "dataikuapi.dss.project.DSSProjectGit.get_status") are always included in the commit.

## Adapting to organizational processes

### Git in workflows

Various organizations have unique ways of working with projects in Dataiku and with git. Some might require version control systems to track changes, while others might need approval processes before changes are implemented. These git-related APIs can help accommodate your ways of working within the platform to meet these needs.

When changes are made to a project and pushed to a remote repository, you can retrieve the new branches and the content of your working branch using:
    
    
    project_git.fetch()
    project_git.pull()
    

### Implement a review process

Once branch development finishes, you might need to use standard review processes to validate the changes. Often, this involves having changes reviewed and approved by others. Using these APIs, you can use your IDE to connect to your instance and make unit changes in projects to code and code-like assets. Minor changes can often be easier to review and approve.

## Wrapping up

This is an example of a version control workflow using the project git APIs. It demonstrates the first step towards programmatically interacting with and modifying Dataiku projects, enabling further automation and scaling.

### Complete code

Code 1: Complete API client code
    
    
    import dataiku
    
    DATAIKU_HOST = ""  # Fill in your Dataiku instance's URL
    API_KEY = "" # Fill in your personal API key to access that instance
    
    # connect to your instance
    dataiku.set_remote_dss(f"http://{DATAIKU_HOST}", API_KEY)
    client = dataiku.api_client()
    
    # list all the projects of the instance 
    project_keys = client.list_project_keys()
    print(f"N-projects on instance: {len(project_keys)}")
    
    # work with a specific sample project
    PROJECT_KEY = "DKU_TUT_VARCOD"
    project = client.get_project(PROJECT_KEY)
    
    USERNAME = "" # Fill in your username
    REPO = "" # Fill in your repo
    
    # get the project git!
    project_git = project.get_project_git()
    
    # .. and set the remote
    project_git.set_remote(f"{USERNAME}@{REPO}:{PROJECT_KEY}")
    
    # create a new branch
    project_git.create_branch('definitely-not-master')
    project_git.checkout('definitely-not-master')
    
    # add these variables
    project.update_variables({
       "country_name": "Germany",
       "merchant_url": "lidl"})
    
    # commit & push
    project_git.get_status()
    project_git.commit(message="add project vars")
    project_git.push()
    
    # fetch & pull
    project_git.fetch()
    project_git.pull()
    

Code 2: Complete recipe code
    
    
    # -------------------------------------------------------------------------------- NOTEBOOK-CELL: CODE
    # -*- coding: utf-8 -*-
    import dataiku
    import pandas as pd, numpy as np
    
    import io
    import matplotlib.pyplot as plt
    
    # -------------------------------------------------------------------------------- NOTEBOOK-CELL: CODE
    # Read recipe inputs
    ecommerce_transactions_with_ip_prepared = dataiku.Dataset("ecommerce_transactions_with_ip_prepared")
    df = ecommerce_transactions_with_ip_prepared.get_dataframe()
    
    # -------------------------------------------------------------------------------- NOTEBOOK-CELL: CODE
    country_name = dataiku.get_variables()["country_name"]
    df_filtered = df[df['MerchantIP_country'] == country_name]
    
    df_avg_purchase = df_filtered[['PurchaseHour', 'CustomerAge', 'OrderTotal']].groupby(by = ['PurchaseHour',
                                                                                     'CustomerAge'],as_index=False).mean()
    
    # -------------------------------------------------------------------------------- NOTEBOOK-CELL: CODE
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    
    xs = df_avg_purchase['PurchaseHour']
    ys = df_avg_purchase['CustomerAge']
    zs = df_avg_purchase['OrderTotal']
    
    ax.set_xlabel('PurchaseHour')
    ax.set_ylabel('CustomerAge')
    ax.set_zlabel('OrderTotal')
    
    ax.scatter(xs, ys, zs)
    
    # -------------------------------------------------------------------------------- NOTEBOOK-CELL: CODE
    folder_for_plot = dataiku.Folder("dy9hOjP1")
    
    # -------------------------------------------------------------------------------- NOTEBOOK-CELL: CODE
    # Compute recipe outputs from inputs
    
    bs = io.BytesIO()
    plt.savefig(bs, format="png")
    folder_for_plot.upload_stream("scatter_plot.png", bs.getvalue())
    

### Reference documentation

[`dataikuapi.dss.project.DSSProjectGit`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit> "dataikuapi.dss.project.DSSProjectGit")(client, ...) | Handle to manage the git repository of a DSS project (fetch, push, pull, ...)  
---|---  
[`dataikuapi.dss.project.DSSProject`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.

---

## [tutorials/devtools/using-jupyterlab-in-code-studios/index]

# Using JupyterLab in Code Studios

This article covers the main features of JupyterLab in Code Studios. You can follow the [reference documentation](<https://doc.dataiku.com/dss/latest/code-studios/index.html>) if you have never set up Code Studio.

## What can you edit with Code Studio and the Jupyterlab block?

VSCode for Dataiku Code Studio enables you to edit the following items:

Item | Editable ?  
---|---  
Code recipes | ✅  
Project libraries | ✅  
Plugins | ❌  
Notebooks | ✅  
Webapps (standard) | ❌  
Webapps (Bokeh) | ❌  
Webapps (Shiny) | ❌  
Webapps (Dash) | ❌  
Webapps (Streamlit) | ✅  
Webapps (Gradio) | ❌  
Webapps (Voila) | ✅  
Wiki | ❌  
  
## Prerequisites

To use JupyterLab in Code Studios, you need a Dataiku 11+ instance with:

  * A working Code Studio instance with a JupyterLab block, a configured Kubernetes cluster, and an instance set up for Elastic AI computation created by an admin user. For details, visit [JupyterLab in Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-ides/jupyterlab.html>).




## Edit a Dataiku recipe

JupyterLab in Code Studios allows you to edit your code recipe created in the **Flow** quickly and dynamically.

  1. From the **Flow** , open the code recipe you wish to edit.

  2. On the top-right corner, click on **Edit in Code Studio** and select your Code Studio instance.




You can also access your recipe directly from JupyterLab in Code Studios:

  1. From the left panel, navigate to the **recipes** folder.

  2. Click the recipe you want to edit to open it as a Python file in the center panel.




Note

You can execute your code in a Code Studio. However, to create a new recipe or build the output, you still have to do it from the **Flow**.

## Debug a Dataiku recipe

You can use JupyterLab debugging tools on a code recipe in a Code Studio, just as you would on local JupyterLab.

### Debugger tool

Several magic commands trigger a debugger to allow traceback when raising an exception.

To name a few, you can use:

  * `%debug`

  * `%pdb`




### Debugging extension

JupyterLab also supports some debugging extensions. One of them is the _`jupyterlab/debugger`_ extension. To install it:

  1. Enter the command line `jupyter labextension install @jupyterlab/debugger` in a terminal.

  2. Access the debugger in the left panel.




## Manage a Jupyter Notebook

### Edit a notebook

Editing a notebook in a Code Studio is the same process as editing a recipe. To do so:

  1. Go to the Notebook page (`G+N`) and select a notebook to edit.

  2. In the top right corner, click **Edit in Code Studio**.




Alternatively, you can edit your notebook from your Code Studio instance. To do so:

  1. From the left panel, navigate to the **notebook** folder.

  2. Select the notebook you want to open.




### Create and retrieve a notebook

Unlike the recipe, you can create a new notebook directly from a Code Studio:

  1. Click **File > New > Notebook** and select the type of notebook you want to create.

  2. Click **Sync files with DSS** to save it to Dataiku.

  3. Go to the Notebook page (`G+N`) to access your new notebook.




## Code environment from scratch

### Import and install your code environment

Code Studios can be seen as a place of experimentation where you can try out a different environment to test which package best suits your code.

In JupyterLab, there are different ways to install various packages.

You can do it in a Jupyter Notebook (or a Python console):

  1. In the top tools bar, click on **File > New > Notebook**.

  2. In the first cell, install the wanted package with a package manager such as `pip` with the command:
         
         !pip install <package>    
         




Caution

Note that the installed packages are not persistent when the Code Studio instance is restarted.

You can also do it in a terminal:

  1. In the top tools bar, click on **File > New > Terminal**.

  2. In the command line, enter `pip install <package>`




If you already have your code environment with plenty of packages ready to be used, it is possible to install them quickly. To do so:

  1. In the **Libraries** menu (`G+L`), in the left panel, navigate to the _python/my_package_ folder and click on the **More options** icon.

  2. Click on **Upload file…**.

  3. Drag your _requirements.txt_ file in the dedicated area and click **Upload** to confirm.

  4. Click on the Code page **< />** in the top navigation bar and return to your Code Studio instance.

  5. In the terminal, enter the command line `pip install -r workspace/project-lib-versioned/python/my_package/requirements.txt`




Note

Note that the **project-lib-versioned** folder stores the different libraries in a Code Studio. It refers to the **lib** folder in the **Libraries** menu.

Alternatively, you can also install these libraries through a notebook or a console.

Caution

Mind where you create the notebook or the console in the directory, as the Path to the _requirements.txt_ file may change according to it. Note that you don’t have this issue with a terminal.

### Export your code environment

Once your tests are appealing, exporting the new code environment from your Code Studio is possible. To do so:

  1. In the top tools bar, click on **File > New > Terminal**.

  2. Enter the command line `pip freeze > workspace/project-lib-versioned/python/my_package/new_requirements.txt`

  3. On the top-right corner, click on **Sync files with DSS** to save the change and retrieve your code environment file in the **Libraries** menu.




## Provided code environment from a template

### Exploration of the code environment

If the Code Studio instance has been installed with a template providing a code environment block, you should be able to explore it. To do so:

  1. From the **Launcher** page of JupyterLab, under **Notebook** , click on the code environment provided to open a notebook. You can also open a Python console just below.

  2. In the first cell of the notebook, enter the magic command `%pip list` to list all the installed packages.




### Edit the provided code environment

From the notebook or the console of the code environment provided, you can update the code env. To do so:

  1. Enter `%pip install <package>` in the code cell and run it.

  2. You can check that the result of `%pip list` has been changed, including the newly installed package.




Caution

For this to persist in the instance, several other steps are required on the admin side.

## Using Code Studio to edit code in a Git reference

If you have imported code from Git in Libraries, you will be able to edit this code within a Code Studio. You can commit the changes made in a Code Studio to the Git reference:

  1. Edit the files in **project-lib-versioned** your Code Studio instance and click **Sync files with DSS**.

  2. Go back to Dataiku Project Libraries, click **Commit and push all…**.




## Wrapping up

Congratulations, you should now have a functional setup to leverage JupyterLab in Code Studios to edit your code in Dataiku as if you were working with your local JupyterLab!

---

## [tutorials/devtools/using-rstudio-for-code-studios/index]

# Using RStudio in Code Studios

This article covers the main features of RStudio in Code Studios. You can follow the [reference documentation](<https://doc.dataiku.com/dss/latest/code-studios/index.html>) if you have never set up Code Studio.

## Prerequisites

To use RStudio in Code Studios, you need a Dataiku 11+ instance with:

  * A working Code Studio instance with an RStudio block, a configured Kubernetes cluster, and an Elastic AI computation instance set up by an admin user. For details, visit [RStudio Server in Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-ides/rstudio.html>).




## Edit a Dataiku recipe

RStudio in Code Studios lets you edit your code recipe quickly and dynamically.

You can do it from the **Flow** by:

  1. Clicking on the code recipe you wish to edit.

  2. Clicking on **Edit in Code Studio** on the top-right corner of the recipe page.




You can also access your recipe directly from RStudio in Code Studios:

  1. From the Files panel, in the bottom-right, navigate **Home > workspace > recipes**

  2. Click on the recipe you want to edit to open it in the Source Editor panel.




Note

You can execute your code in Code Studio. However, to create a new recipe or build the output, you still have to do it from the **Flow**.

The recipe can be debugged with the proper tools of RStudio. For example:

  * Setting a diagnosis by launching `rlang::last_trace()` in the Console panel.

  * Using a linting package such as _`lintr`_ and call `library(lintr)` to detect typos.




## Explore and export your code environment

Code Studios can be seen as a place of experimentation where you can try out a different environment to test which package best suits your code. To get the details of your environment:

  1. In the Source Editor panel, enter :
         
         # Get information about installed packages
         installed_packages <- installed.packages()
         
         # Extract the package names
         package_names <- rownames(installed_packages)
         
         # Save the package names to a text file
         writeLines(package_names, "project-lib-versioned/requirements.txt")
         

  2. Run the code with **Ctrl + Enter** (or **Cmd + Enter** on Mac).

  3. Click **Sync files with DSS** to save the change in your instance.

  4. In the top navigation bar, navigate to the **Libraries** menu (`G+L`) to open your new file.

Note

You can notice that the `project-lib-versioned` is the folder for managing your libraries, and it refers to the **lib** folder on this page.

  5. Hover the `requirements.txt` file, click the **More options** icon, and **Move** it to the **R** folder.




Caution

For security purposes, the **R** folder is invisible in the Code Studio instance when empty.

When the Code Studio is created according to the template, if a code environment block is provided, the new packages are in this text file alongside with default R packages.

## Using Code Studio to edit code in a Git reference

If you have imported code from Git in Libraries, you will be able to edit this code within Code Studio. You can commit the changes made in Code Studio to the Git reference:

  1. Edit the files in `project-lib-versioned` in Code Studio and click **Sync files with DSS**.

  2. Go back to Dataiku Project Libraries, click **Commit and push all…**.




## Wrapping up

Congratulations, you should now have a functional setup to leverage RStudio in Code Studios to edit your code in Dataiku as if you were working with your local RStudio!

---

## [tutorials/devtools/using-vscode-for-code-studios/index]

# Editing & Debugging Code with VS Code

In this article, we will cover the main features and use cases of VSCode for [Code Studio](<https://doc.dataiku.com/dss/latest/code-studios/index.html> "\(in Dataiku DSS v14\)"). If you want to know what can be edited in Code Studio and thus within VS Code, please refer to [this page](<../code-studio.html>).

Caution

VSCode for Code Studio provides a richer edition environment, but doesn’t act as a full replacement for the Dataiku user interface. Several important operations will still be done visually in your Dataiku. For example, when you execute a code recipe from Code Studio, it doesn’t trigger a Dataiku job in your project.

## Prerequisites

Self-managedDataiku Cloud

  * A Dataiku 11+ instance.

  * Administrator privileges for your user profile.

  * A Kubernetes cluster is configured. For details, visit [Elastic AI Computation](<https://doc.dataiku.com/dss/latest/containers/index.html> "\(in Dataiku DSS v14\)").

  * A base image is built. Typically, this is built using a command such as `./bin/dssadmin build-base-image --type container-exec`. For details, visit [Build the Base Image](<https://doc.dataiku.com/dss/latest/containers/setup-k8s.html#build-the-base-image>).




  * Administrator privileges for your user profile.




This tutorial was written with Python 3.9, and the following package versions in a Dataiku Code Environment (to be added to the Code Studio template):

  * `black`

  * `pylint`




### Creating the project

  1. From the Dataiku homepage, click **+New Project** > **Learning projects** > **Developer** > **My First Code Studio**.

  2. From the project homepage, click **Go to Flow**.




Note

You can also download [the starter project](<https://cdn.downloads.dataiku.com/public/dss-samples/DKU_TUT_CODE_STUDIOS/>) and import it as a zip file.

### Use case summary

We’ll work with a project that contains a simple pipeline: one input dataset, two Python recipes, and two output datasets. Both recipes generate errors when run. Our goal is to debug these recipes in your own IDE. We’ll accomplish this within Dataiku using Code Studios.

See also

There are other ways to debug code recipes with Dataiku. You may also consider using various [IDE extensions](<../IDE.html>).

The first thing we’ll need is a Code Studio template. If you don’t have a Code Studio template, please refer to [this tutorial](<../code-studio/first-code-studio/index.html>).

## Editing a code recipe within VS Code

In a Dataiku project, you can start a Code Studio instance from a code recipe with the “Edit in Code Studio” button on the top right of each code recipe.

A pop-up will then ask you to select the Code Studio instance to use.

After editing your recipe in VSCode, click “Sync files with DSS” to update the file content on the Dataiku server.

Remember, changes in a Code Studio running in a Kubernetes pod are not saved unless you click “Sync files with DSS”. For more on Code Studio, see [Technical Details](<https://doc.dataiku.com/dss/latest/code-studios/concepts.html#technical-details>) in Dataiku’s reference documentation.

From a Code Studio instance, several directories are available, as you can see in the VSCode file explorer on the left.

### Debugging within VS Code

Let’s inspect and debug the `compute_contacts_1.` recipe in Code Studio.

  1. From the recipe, select Edit in Code Studio.

  2. In Code Studios, select VS Code.




Dataiku displays the VS Code Workspace Explorer ready to debug the recipe.

Tip

To go back and forth between the Flow and your Code Studio, you can keep the VS Code Workspace Explorer open in its own browser tab.

We are interested in working with the Python recipe, `compute_contacts_1`. To find it:

  1. Open the Recipes folder (`recipes`).

  2. Select `compute_contacts_1.py`.

  3. Run the code to generate the errors you saw when running the recipe, if you have done it.




Note

VSCode might warn you that the Python Interpreter is not set up. Run the command Python: Select Interpreter (via the command palette) and choose a Python interpreter (located in `dataiku-python-code-envs`).

Running the recipe in VS Code displays the same error we saw in the Flow. This lets us know the Code Studio is configured correctly. By looking at the result of this execution, you will see (in the Traceback) that the error comes from line 19.

You can work with the code recipe within your own IDE, all from Dataiku. However, you are now working in VS Code, rather than in the Dataiku Python recipe editor. If you make any changes to the code from the IDE, you’ll need to sync the changes back to Dataiku. Since we suspect the error is occurring before line 19, let’s set a breakpoint and use the VS Code debugger.

  1. Click in the far left margin before line 19 to set a breakpoint.

  2. Select Debug Python File from the dropdown at the top right, or from **menu** > *_Run_ > **Start Debugging**.

  3. VS Code executes the code and pauses at the breakpoint. To debug the code, you can utilise navigation commands and shortcuts in the IDE. More specifically, you can inspect the variables.

  4. Expand **Variables > Locals** in the debugger explorer, in the left panel.

  5. Upon inspection, you can see that the variable `value` is fetched from the project variables. If you want to see the definition of the project variables, select **… > Variables** from the top navigation bar of the project.

  6. You can change the value of this variable directly in VS Code, and then click the Continue button to see if it resolves the problem.

  7. Now, you know that the error originates from the definition of the variable: `value`.

  8. Edit the code, replacing `my_var` with `my_var2` on line 16.
         
         value = dataiku.get_custom_variables()["my_var2"]
         

  9. Run the code again.




Now that the code executes without error, you can sync the changes back to the recipe in the Flow.

### Syncing the changes back to Dataiku

When working in Code Studios, you are editing a local copy of your code separate from the version in Dataiku. After making changes, you must click “Sync files with DSS” in VS Code to update your project in Dataiku. If you return to the Flow without syncing, the changes will not appear in the Flow or in Dataiku’s interface. Always sync before switching back to Dataiku to ensure your edits are saved.

  1. In VS Code, select **Sync Files With DSS** in the upper right.

Once the sync is complete, VS Code displays a green checkbox.

  2. Return to the Flow.

  3. Open the `compute_contacts_1` Python recipe.

You can see that the recipe is updated and that `"my_var"` is now `"my_var2"`.

  4. Run the recipe.




The recipe runs without warnings.

Python recipe successfully edited and synchronized back to Dataiku.

## Editing a project library file

Project libraries are a great way to organise your code in a centralised location that can be reused in any project on the instance. From Dataiku, you can also connect to a remote Git repository to manage your code. For more details, visit [Reusing Python Code](<https://doc.dataiku.com/dss/latest/python/reusing-code.html> "\(in Dataiku DSS v14\)").

In this section, you’ll practice editing a project library in Code Studio. You’ll be working with the second Python recipe in the project.

### Running the Python recipe

  1. Return to the Flow.

  2. Run the Python recipe that `generates contacts_2`.




This recipe is performing a simple transformation using a custom Python package, `my_package`.

Custom Python package in the project library.

The error, “list index out of range”, is raised at line 21 of the code.
    
    
    row['new_feat'] = extract_domain(row['Email'])
    

You need to investigate this error to learn more. One way to do this is to use the logs, but you can also inspect and debug this error in Code Studio.

### Debugging with VS Code

Let’s see if you can find out more by using the VS Code debugger.

  1. From the recipe that `generates contacts_2`, select Edit in Code Studio.

  2. In Code Studios, select VS Code.




Dataiku displays the VS Code Workspace Explorer ready to debug the recipe. The `project-lib-versioned` folder contains the Python package, `my_package`. In addition, the `recipes` folder contains the recipes.

Let’s run the recipe in the debugger.

  1. Open the Recipes folder (`recipes`).

  2. Select `compute_contacts_2.py`.

  3. Select Debug Python File.




Running the recipe in VS Code displays the same error we saw in the Flow.

Using the same technique as before, you can spot the error and fix it. For example, you can use the code below for the `extract_domain` function in the project library. Once you have chosen a fix, the code should run without error.
    
    
    import re
    
    def extract_domain(name):
        split_name = re.split("\.|,",name)
        if len(split_name) > 1 :
            return split_name[1]
        return '(unknown)'
    
    

### Syncing the changes back to Dataiku

Let’s sync the changes back to the recipe in the Flow.

  1. In VS Code, select Sync Files With DSS in the upper right.

  2. Dataiku synchronises both the recipe and the project library file back to the project. Once the sync is complete, VS Code displays a green checkbox. Let’s verify that the project library file has been updated.

  3. Run the recipe that generates `contacts_2` to see that the output dataset is built without exceptions.




### Using Code Studio to edit code in a Git reference

If you have imported code from Git in Dataiku Project Libraries, you will be able to edit this code within Code Studio. Committing the changes made in Code Studio to the Git reference is a **2-step** process:

  * Edit the files in the `project-lib-versioned` folder in Code Studio and click **Sync files with DSS**.

  * Return to Dataiku Project Libraries and click **Commit and push all…**.




## Defining Custom User Settings

By default, VSCode for Code Studio user settings are stored under the `user-versioned` directory. For example, if you change the color theme, it will be saved in `/home/dataiku/workspace/user-versioned/settings/code-server/User/settings.json`. If you click **Sync File with DSS** the VSCode `settings.json` file will be stored in your user profile and be applied across all your user code studio sessions. You can find all the files under the user-versioned directory in your **Dataiku User Profile** > **My Files** tab.

## Wrapping up

Congratulations, you should now have a functional setup to leverage VSCode for Code Studio allowing you to edit your code in Dataiku as if you were working with your local VSCode.

---

## [tutorials/devtools/vscode-extension/index]

# VSCode extension for Dataiku

The VSCode extension for Dataiku enables you to connect to a Dataiku instance from your VSCode desktop environment and edit the following items:

Item | Editable ?  
---|---  
Code recipes | ✅  
Project libraries | ✅  
Plugins | ✅  
Notebooks | ❌  
Webapps (standard) | ✅  
Webapps (Bokeh) | ✅  
Webapps (Shiny) | ✅  
Webapps (Dash) | ❌  
Webapps (Streamlit) | ❌  
Webapps (Gradio) | ❌  
Webapps (Voila) | ❌  
Wiki | ✅  
  
This tutorial will provide an overview of some of these capabilities through a simple example.

Caution

The Dataiku VSCode extension provides a richer edition environment, but doesn’t act as a full replacement for the web interface. Several important operations will still be done visually in your browser.

## Prerequisites

  * [VSCode](<https://code.visualstudio.com/download>) installed on your local computer

  * A Dataiku API local environment set up. For detailed steps, see [this tutorial](<../python-client/index.html>)

  * “Write project content” permission on an existing Dataiku project




If you can’t install the required components on your computer, we advise that you use [Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/concepts.html> "\(in Dataiku DSS v14\)") instead.

## Setting up the extension

Start by installing and configuring the VSCode extension by following the instructions listed on the [marketplace page](<https://marketplace.visualstudio.com/items?itemName=dataiku.dataiku-dss>). Once it’s properly set up, you should see the Dataiku icon on VSCode’s activity bar. After accessing the extension, you should also be able to see the list of projects which you have access to in VSCode’s side bar. If you click on a given project you will be able to list its editable components.

## Pointing to your Dataiku API local environment

In order for VSCode to use the required dependencies, set up the Python interpreter to point to your Dataiku API local environment (see the [VSCode documentation](<https://code.visualstudio.com/docs/python/environments#_manually-specify-an-interpreter>)). Once this is done, your environment’s name should appear at the right side of the status bar.

## Editing project libraries and recipes

The first item we will edit in VSCode is the project library.

In the Dataiku web interface, start by creating a dataset from the [Seoul bike sharing demand dataset](<https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand>) available online and name it `SeoulBikeData`. In your newly-created dataset, to prevent character encoding issues, go to “Settings > Schema” and rename the following columns:

  * `Temperature(°C)` -> `Temperature_C`

  * `Dew point temperature(°C)` -> `Dew point temperature_C`




Then, switch to VSCode and in your project, create a new directory called `bikes` under `Libraries/python/`. Inside that directory, create the following files:

  * `__init__.py` and leave it empty

  * `prepare.py` with the following code:
        
        import pandas as pd
        
        COLUMNS = ["Date", "Hour", "Temperature_C", "Wind speed (m/s)"]
        
        def celsius_to_fahrenheit(df: pd.DataFrame,
                                     temp_celsius_col: str,
                                     temp_fahrenheit_col: str) -> pd.DataFrame:
            df[temp_fahrenheit_col] = (df[temp_celsius_col] * 1.8) + 32.0
            return df
        
        def ms_to_kmh(df: pd.DataFrame,
                      wind_ms_col: str,
                      wind_kmh_col: str) -> pd.DataFrame:
            df[wind_kmh_col] = df[wind_ms_col] * 3.6
            return df
        
        




Note that every time you save the file in VSCode, it is automatically synchronized to the Dataiku instance.

Next, come back to the web interface and:

  * create a Python recipe using `SeoulBikeData` as input and a new dataset called `SeoulBikeData_prepared` as output

  * save the recipe

  * go back to the Flow screen




If you switch to VSCode, you should see a new recipe called `compute_SeoulBikeData_prepared` in the side bar under your project’s “Recipes” menu. Click on it to open its source code and edit it as follows:
    
    
    import dataiku
    import pandas as pd
    
    from bikes.prepare import celsius_to_fahrenheit
    from bikes.prepare import ms_to_kmh
    from bikes.prepare import COLUMNS
    
    SeoulBikeData = dataiku.Dataset("SeoulBikeData")
    df_in = SeoulBikeData.get_dataframe(columns=COLUMNS)
    
    df_out = df_in \
        .pipe(celsius_to_fahrenheit,
              temp_celsius_col="Temperature_C",
              temp_fahrenheit_col="Temperature_F") \
        .pipe(ms_to_kmh,
              wind_ms_col="Wind speed (m/s)",
              wind_kmh_col="Wind_speed_kmh") \
        .round(2)
    
    SeoulBikeData_prepared = dataiku.Dataset("SeoulBikeData_prepared")
    SeoulBikeData_prepared.write_with_schema(df_out)
    
    

Don’t forget to save your recipe’s code! Same as for project libraries, it will synchronize it with the Dataiku instance. Your recipe is now ready to be run !

## Building datasets

In order to build the `SeoulBikeData_prepared` dataset you have two options: either trigger it from the Dataiku web interface or from VSCode. Each case is further explained below.

### From the Dataiku web interface

This option is the simplest one: from the Flow screen, right-click on the `SeoulBikeData_prepared` dataset and choose “Build…”, keep the default settings (“Not recursive”) then click on “Build dataset”. Once the dataset is built you can inspect its content by clicking on it.

### From VSCode

If you want to stay within the VSCode interface, an alternative is to click on the “Run this recipe in DSS” in the lower left part of the window. It should appear with the name of the recipe currently opened in your editor.

Clicking this button will start a Dataiku Job to build the recipe’s output dataset, and the activity logs will be streamed in the “Output” tab of VSCode.

## Editing wiki articles

The Dataiku VSCode extension also allows you to edit your project’s wiki pages. To showcase a simple example, in VSCode’s side bar under your project name, click on the “New wiki article” near the “Wikis” section and name your article “Home”. This will generate a `Home.md` file that you will be able to edit from VSCode, the resulting page will be rendered in the Dataiku web interface. Populate your page with the following content:

# Seoul Bike dataset analysis

This wiki page documents the different operations performed on the dataset:SeoulBikeData dataset. For more information about the source data, please visit the [UCI Machine Learning Repository page](<https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand>).

## Temperature units

Celsius-based measurements are converted to fahrenheit using the following formula:

\\[ T_F = (T_C * \frac{9}{5}) + 32 \\]

## Wind speed units

Meters/second measurements are converted to kilometers/hour using the following formula:

\\[ V_{km/h} = V_{m/s} * 3.6 \\]

After saving your changes, right-click on “Wiki > Open in DSS” to switch to the Dataiku web interface: you should see the rendered version of your page in the “Wiki” section of the project. 

Tip

From VSCode you can also preview your Markdown file by clicking on the “Open Preview to the side” button located at the top right. While this works well for basic content, Dataiku’s Markdown also introduces custom syntax elements (e.g.g links to Dataiku-specific objects, math formulas) that won’t be rendered in VSCode’s Preview screen. To get a full-rendered version of your wiki, you should always switch to the Dataiku web interface.

## Going further

Now that you have the basics of code edition, you can move on to more advanced tasks.

### Formatting

_Code formatting_ allows you to automatically adjust your code layout and make it more readable. In this section you will see how to use Python’s [`black`](<https://black.readthedocs.io/en/stable/>) formatter on your project libraries.

  * Start by installing the [Python extension](<https://marketplace.visualstudio.com/items?itemName=ms-python.python>) provided by Microsoft.

  * Next, add the `black` package to your virtual environment. From the VSCode terminal, run:
        
        pip install black
        

  * Open the [VSCode settings](<https://code.visualstudio.com/docs/getstarted/settings>) and search for the “Python > Formatting: Provider” section. In the dropdown list, select “black”.

  * Still in the settings, go to the “Text Editor > Formatting” section, and under “Editor: Format on Save” tick the “Format a file on save” box.




From now on, when editing Python files from VSCode (including code recipes and project libraries), your code layout will automatically be adjusted at every save.

### Linting

Linting is a process to analyze source code and visually highlight any syntax and style issue detected. In this section you will set up the [`pylint`](<https://pylint.readthedocs.io/en/latest/>) linter for Python code and use it to improve the quality of your project libraries.

  * Add the `pylint` package to your virtual environment. From the VSCode terminal, run:
        
        pip install pylint
        

  * Enable linting by following the [instructions in the VSCode documentation](<https://code.visualstudio.com/docs/python/linting>).

  * Go to the `prepare.py` file in your project library and run linting by opening the command palette and selecting “Python: Run Linting”. You should see a few highlighted parts in your source code: going to the “Problems” tab in the lower panel will provide you with a detailed list of the linter’s output.

  * From there you can fix your code accordingly. Here is the modified code that is both formatted by `black` and compliant with the `pylint` linter:
        
        """prepare.py
        
        This file contains data preparation functions to process the Seoul Bike dataset.
        """
        
        import pandas as pd
        
        COLUMNS = ["Date", "Hour", "Temperature_C", "Wind speed (m/s)"]
        
        
        def celsius_to_fahrenheit(
            df_data: pd.DataFrame, temp_celsius_col: str, temp_fahrenheit_col: str
        ) -> pd.DataFrame:
            """Convert celsius to fahrenheit.
        
            Args:
                df_input (pd.DataFrame): the input DataFrame
                temp_celsius_col (str): the column name containing celsius temperatures
                temp_fahrenheit_col: the name for the generated column with fahrenheit tempetatures
        
            Returns:
                pd.DataFrame: the output DataFrame
        
            """
            df_data[temp_fahrenheit_col] = (df_data[temp_celsius_col] * 1.8) + 32.0
            return df_data
        
        
        def ms_to_kmh(
            df_data: pd.DataFrame, wind_ms_col: str, wind_kmh_col: str
        ) -> pd.DataFrame:
            """Convert meters per second into kilometers per hour.
        
            Args:
                df_input (pd.DataFrame): the input DataFrame
                wind_ms_col (str): the column name containing m/s wind speeds
                wind_kmh_col (str): the name for the generated column with km:h wind speeds
        
            Returns:
                pd.DataFrame: the output DataFrame
        
            """
            df_data[wind_kmh_col] = df_data[wind_ms_col] * 3.6
            return df_data
        




## Wrapping up

Congratulations, you now have a fully functional setup to leverage your VSCode editor alongside your Dataiku instance! To dive deeper into the Dataiku API, you can read the [dedicated page](<../../../api-reference/python/index.html>).

---

## [tutorials/genai/agents-and-tools/agent/index]

# Building and using an agent with Dataiku’s LLM Mesh and Langchain

Large Language Models’ (LLMs) impressive text generation capabilities can be further enhanced by integrating them with additional modules: planning, memory, and tools. These LLM-based agents can perform tasks such as accessing databases, incorporating contextual understanding from external sensors, or interfacing with other software to execute more complex actions. This integration allows for more dynamic and practical applications, making LLMs active participants in decision-making processes.

This tutorial will construct an LLM agent using a practical use case. The use case involves retrieving customer information based on a provided ID and fetching additional data about the customer’s company utilizing an internet search. By the end of this tutorial, you will have a structured understanding of integrating Language Models with external tools to create functional and efficient agents.

## Prerequisites

  * Dataiku >= 12.6.2

  * Python >= 3.9

  * A code environment with the following packages:
        
        langchain # tested with 0.3.25
        duckduckgo_search #tested with 8.0.2
        

  * An SQL dataset called `pro_customers_sql` in the flow, like the one shown in Table 1.




Table 1: `pro_customers_sql` id | name | job | company  
---|---|---|---  
tcook | Tim Cook | CEO | Apple  
snadella | Satya Nadella | CEO | Microsoft  
jbezos | Jeff Bezos | CEO | Amazon  
fdouetteau | Florian Douetteau | CEO | Dataiku  
wcoyote | Wile E. Coyote | Business Developer | ACME  
  
## LLM initialization and library import

To begin with, you need to set up a development environment by importing some necessary libraries and initializing the chat LLM you want to use to create the agent. The tutorial relies on the LLM Mesh for this and the Langchain package to orchestrate the process. The `DKUChatModel` class allows you to call a model previously registered in the LLM Mesh and make it recognizable as a Langchain chat model for further use.

Code 1: LLM Initialization
    
    
    import dataiku
    
    # Prepare the LLM
    from dataiku.langchain.dku_llm import DKUChatModel
    
    LLM_ID = "" # Replace with a valid LLM id
    
    llm = DKUChatModel(llm_id=LLM_ID, temperature=0)
    

Tip

You’ll need to provide DKUChatModel with an `llm_id`, a Dataiku internal ID used in the LLM Mesh. The [documentation](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>) provides instructions on obtaining an `LLM ID`. The following code snippet will print you an exhaustive list of all the models to which your project has access.
    
    
    import dataiku
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

## Tools’ definition

In this section, you will define the external tools that your LLM agent will use to perform more advanced tasks. In our case, these tools include:

  * **Dataset lookup tool** : used to execute SQL queries on the `pro_customers_sql` dataset to retrieve customer information (name, role, company), given a customer ID. Code 2 shows an implementation of this tool.

  * **Internet search tool** : used to perform internet searches to fetch more detailed information about the customer’s company. Code 3 shows an implementation of this tool.




Note

Langchain offers three main ways to define custom tools: the `@tool` decorator, the `StructuredTool.from_function()` method that takes a Python function as input, or the class method, which extends the built-in `BaseTool` class and provides metadata as well as a `_run` method (at least).

The tutorial defines the tool here using the last option because we noticed that the LLM tends to use them more consistently. But don’t hesitate to try all three methods yourself.

Code 2: Definition of the Dataset lookup tool
    
    
    from langchain.tools import BaseTool
    from dataiku import SQLExecutor2
    from langchain.pydantic_v1 import BaseModel, Field
    from typing import Type
    from dataiku.sql import Constant, toSQL, Dialects
    
    
    class CustomerInfo(BaseModel):
        """Parameter for GetCustomerInfo"""
        id: str = Field(description="customer ID")
    
    
    class GetCustomerInfo(BaseTool):
        """Gathering customer information"""
    
        name: str = "GetCustomerInfo"
        description: str = "Provide a name, job title and company of a customer, given the customer's ID"
        args_schema: Type[BaseModel] = CustomerInfo
    
        def _run(self, id: str):
            dataset = dataiku.Dataset("pro_customers_sql")
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES) # Replace by your DB
            query_reader = executor.query_to_iter(
                 f"""SELECT * FROM {table_name}  where "id"={escaped_cid}""")
            for (user_id, name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named \"{company}\""
            return f"No information can be found about the customer {id}"
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    

Note

The SQL query might be written differently depending on your SQL Engine.

Code 3: Definition of the Internet search tool
    
    
    from duckduckgo_search import DDGS
    
    class CompanyInfo(BaseModel):
        """Parameter for the GetCompanyInfo"""
        name: str = Field(description="Company's name")
    
    
    class GetCompanyInfo(BaseTool):
        """Class for gathering in the company information"""
    
        name: str = "GetCompanyInfo"
        description: str = "Provide general information about a company, given the company's name."
        args_schema: Type[BaseModel] = CompanyInfo
    
        def _run(self, name: str):
            results = DDGS().text(name + " (company)", max_results=1)
            result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(name, max_results=1)
                result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + name
            return result
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    

## LLM agent creation

With the tools defined, the next step is to create an agent that can effectively utilize these tools. This tutorial uses the [ReAct](<https://react-lm.github.io/>) logic, which combines the LLM’s ability for reasoning (e.g., chain-of-thought prompting, etc.) and acting (e.g., interfacing with external software, etc.) through a purposely crafted prompt.

Alternatively, it is possible to use the tool calling logic, when the LLM supports tool calls. More information can be found in the [tool calls section](<../../../../concepts-and-examples/llm-mesh.html#llm-mesh-tool-calls>) of the developer guide.

ReActTool calls

Note

Langchain offers a hub for community members to share pre-built prompt templates and other resources. The prompt below has been taken from there, and it is also possible to [fetch it directly](<https://smith.langchain.com/hub/hwchase17/react>) with the following code:
    
    
    # Only need if you want to use a default prompt (may require langchainhub dependency)
    from langchain import hub
    prompt = hub.pull("hwchase17/react")
    

Code 4: LLM agent creation
    
    
    # Initializes the agent
    from langchain_core.prompts import ChatPromptTemplate
    from langchain.agents import AgentExecutor, create_react_agent
    from langchain.tools import StructuredTool
    
    # Link the tools
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    tool_names = [tool.name for tool in tools]
    
    prompt = ChatPromptTemplate.from_template(
    """Answer the following questions as best you can. You have only access to the following tools:
    
    {tools}
    
    Use the following format:
    
    Question: the input question you must answer
    Thought: you should always think about what to do
    Action: the action to take, should be one of {tool_names}
    Action Input: the input to the action
    Observation: the result of the action
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: I now know the final answer
    Final Answer: the final answer to the original input question
    
    Begin!
    
    Question: {input}
    Thought:{agent_scratchpad}""")
    
    agent = create_react_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools,
       verbose=True, return_intermediate_steps=True, handle_parsing_errors=True)
    

Note

Langchain offers a hub for community members to share pre-built prompt templates and other resources. The prompt below has been taken from there, and it is also possible to [fetch it directly](<https://smith.langchain.com/hub/hwchase17/openai-tools-agent>) with the following code:
    
    
    # Only need if you want to use a default prompt (may require langchainhub dependency)
    from langchain import hub
    prompt = hub.pull("hwchase17/openai-tools-agent")
    

Code 4: LLM agent creation
    
    
    # Initializes the agent
    from langchain_core.prompts import ChatPromptTemplate
    from langchain.agents import AgentExecutor, create_tool_calling_agent
    
    # Link the tools
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    
    prompt = ChatPromptTemplate.from_messages([
        ("system", "You are a helpful assistant"),
        ("placeholder", "{chat_history}"),
        ("human", "{input}"),
        ("placeholder", "{agent_scratchpad}"),
    ])
    
    agent = create_tool_calling_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(
        agent=agent, tools=tools,
        verbose=True, return_intermediate_steps=True, handle_parsing_errors=True
    )
    

Note

The Langchain tool calling `AgentExecutor` attempts to query the LLM with a streaming strategy. When the LLM supports tool calls but does not support response streaming, it is still possible to use the tool calling agent by setting the parameter `stream_runnable=False` in the call to the `AgentExecutor` constructor.

Tip

The `AgentExecutor` class has a `callback` [parameter](<https://api.python.langchain.com/en/latest/agents/langchain.agents.agent.AgentExecutor.html#langchain.agents.agent.AgentExecutor.callbacks>) that can be used with packages like `mlflow` for debugging and tracing purposes. For inspiration, refer to our [LLM StarterKit project](<https://gallery.dataiku.com/projects/EX_LLM_STARTER_KIT/flow/?zoneId=Gzn9KXV>) on the Dataiku Gallery.

## LLM agent invocation

Finally, you can run the `agent_executor`. Depending on the level of detail you want to see about the intermediate steps and the “decisions” taken by the agents, Langchain offers several methods and a debug mode. We are showing them below.

ReActTool calls

Code 5: Simple invocation
    
    
    from langchain.globals import set_debug
    
    set_debug(False) ## Set to True to get debug traces
    customer_id = "fdouetteau"
    
    ## This will directly return the output from the defined input
    agent_executor.invoke(
        {
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id}. Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })["output"]
    

Code 6: Iteration on intermediate steps
    
    
    ## You can also iterate on intermediate steps, to print them or run any tests, with the .iter() method
    i=1
    for step in agent_executor.iter({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id}.
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        }):
        print("\n", "*"*20, f"Step: {i}")
        if output := step.get("intermediate_step"):
            action, value = output[0]
            print(output[0])
            print("-"*80)
            print(action.log)
            print("+"*80)
            print(value)
            i += 1
        elif output := step.get('output'):
                print(output)
    

Code 5: Simple invocation
    
    
    from langchain.globals import set_debug
    
    set_debug(False) ## Set to True to get debug traces
    customer_id = "fdouetteau"
    
    ## This will directly return the output from the defined input
    agent_executor.invoke({
        "input": f"Give all the professional information you can about the customer with ID: {customer_id}. Also include information about the company if you can.",
    })["output"]
    

Code 6: Iteration on intermediate steps
    
    
    ## You can also iterate on intermediate steps, to print them or run any tests, with the .iter() method
    i=1
    for step in agent_executor.iter({
        "input": f"Give all the professional information you can about the customer with ID: {customer_id}. Also include information about the company if you can.",
    }):
        print("\n", "*"*20, f"Step: {i}")
        if output := step.get("intermediate_step"):
            action, value = output[0]
            print(output[0])
            print("-"*80)
            print(action.log)
            print("+"*80)
            print(value)
            i += 1
        elif output := step.get('output'):
                print(output)
    

## Wrapping up

This tutorial provided a walk-through for building an LLM-based agent capable of interacting with external tools to fetch and process information. Modularizing the approach - from initialization and tool definition to the creation and invocation of the agent - ensures clarity, reusability, and efficiency, suitable for tackling similar tasks.

---

## [tutorials/genai/agents-and-tools/auto-prompt/index]

# Building Auto Prompt Strategies with DSPy in Dataiku

DSPy is the framework for **programming—rather than prompting—language models**. It allows you to iterate fast on building modular AI systems. It offers algorithms for optimizing their prompts and weights, whether you’re building simple classifiers, sophisticated RAG pipelines, or Agent loops.

This tutorial shows how we can seamlessly integrate DSPy Auto Prompting strategies into Dataiku. DSPy has two main applications:

  1. Describe AI behavior as code instead of strings.

  2. Optimize your prompt to improve answer quality.




We will build a RAG module with DSPy to demonstrate the first application.

To demonstrate the second application, we will optimize our RAG module to maximize our answer quality.

Then, we can compare the performance of both RAG applications with the [LLM Evaluate recipe](<https://knowledge.dataiku.com/latest/deploy/genai-monitoring/tutorial-llm-evaluation.html>).

This code could be run in a notebook. Let’s start!

## Prerequisites

  * Dataiku >= 13.3

  * Python >=3.9

  * A code environment:

    * with the “Retrieval Augmented Generation models (used by Knowledge banks)” package set installed

    * with the following packages:
    
    dspy-ai
    langchain
    langchain_community
    




You must also generate and add a Dataiku API key in your [user secrets](<https://doc.dataiku.com/dss/latest/security/user-secrets.html> "\(in Dataiku DSS v14\)") with the name `dataiku_api_key`.

The starter flow must contain the following:

  * A dataset with a set of questions & ground truth (for evaluation)

  * A Knowledge Bank built with relevant information for the questions.

  * Have a **baseline** prompt recipe run on the dataset using a [RAG LLM](<https://doc.dataiku.com/dss/latest/generative-ai/knowledge/introduction.html> "\(in Dataiku DSS v14\)") built on the knowledge bank.




## Setting up DSPy

We start by importing all relevant packages for this tutorial.
    
    
    import dataiku
    import dspy
    import logging
    
    from langchain_core.documents.base import Document
    

To provide an LLM to DSPy, we will leverage Dataiku’s ability to provide an [OpenAI-compatible endpoint](<../../nlp/openaiXmesh/index.html#tutorials-nlp-openaixmesh-client>).

We build a `get_key_from_user_secret` function as a convenient way to get an API key saved in our user’s secrets. We then build the parameters needed to configure the `dspy` client.

Note

In this example, we saved an `LLM_ID` in the project variables to be defined once and reused many times across the project.
    
    
    def get_key_from_user_secret(key_name : str):
        """
        Fetches API key secret in user credentials
        """
        auth_info = dataiku.api_client().get_auth_info(with_secrets=True)
        for secret in auth_info["secrets"]:
            if secret["key"] == key_name:
                logging.info(f"{key_name} has been set")
                return secret["value"]
        logging.error(f"The {key_name} is not provided in user credentials. Please set it in the user credentials")
    
    
    
    # Prepare parameters
    project_key = dataiku.api_client().get_default_project().project_key
    base_url = f"https://design.ds-platform.ondku.net/public/api/projects/{project_key}/llms/openai/v1/"
    api_key = get_key_from_user_secret("dataiku_api_key")
    LLM_id = dataiku.get_custom_variables()["LLM_id"]
    
    # Load the LLM in DSPy as openai model
    lm = dspy.LM(f"openai/{LLM_id}", api_key=api_key, api_base=base_url)
    dspy.configure(lm=lm)
    

## Building and Running a DSPy RAG Module on a set of queries

Let’s load the inputs to our recipe:

  * We can load the input dataset containing questions and their ground truth answers.

  * We also load relevant information for our use case as a Langchain Retriever into the knowledge bank to simplify the retrieval.



    
    
    df = dataiku.Dataset("test_dataset_filtered").get_dataframe()
    
    retriever = (
        dataiku.api_client()
        .get_default_project()
        .get_knowledge_bank("YK6IMhfU")
        .as_core_knowledge_bank()
        .as_langchain_retriever(search_kwargs={"k": 5})
    )
    

It is time to build the DSPy chain of the Thought RAG client.

Notice that with the DSPy Framework, we never provide any prompt templates or text. We explain functionally that we will provide and `context` and a `question`, and that should yield a `response`.

We also define a `semantic_search` chain using the `Retriever` loaded up previously & a Document serializer function `format_docs`.

Note

To compare apples with apples, we want the context serialization to be the same as the RAG baseline.
    
    
    # Build DSPy predictor
    rag = dspy.ChainOfThought('context, question -> response')
    
    # Build Semantic Search Pipeline
    def format_docs(docs : list[Document]) -> list[str]:
        """
        Function to process a list of documents
        """
        return [f"{doc.page_content}\n{doc.metadata}" for doc in docs]
    semantic_search = retriever | format_docs
    

It is now time to check that everything is working as expected.
    
    
    # Test dspy call
    question = "Can I use python for data preparation in Dataiku?"
    context = semantic_search.invoke(question)
    rag(context=context, question=question)
    
    
    
    Prediction(
        reasoning='Yes, you can use Python for data preparation in Dataiku. Dataiku allows you to write Python recipes that can read and write datasets from various storage backends. You can manipulate datasets using regular Python code or by utilizing Pandas dataframes, making it a flexible option for data preparation tasks.',
        response='Yes, you can use Python for data preparation in Dataiku. Dataiku supports Python recipes that allow you to read and write datasets, and you can manipulate the data using either standard Python code or Pandas dataframes.'
    )
    

We can now run the DSPy RAG Module on our corpus of questions and save the results in the Flow to run the Evaluation Recipe on the results later.
    
    
    for i in df.index:
        question = df.at[i, "question"]
        context = semantic_search.invoke(question)
        answer = rag(context=context, question=question)
        df.at[i, "generated_answer"] = answer.get("response")
        df.at[i, "generated_reasoning"] = answer.get("reasoning")
        df.at[i, "context_with_metadata"] = str(context)
    
    dataiku.Dataset("answers_dspy").write_with_schema(df)
    

The answers generated by this RAG module should have comparable results to the visual baseline created directly from the knowledge bank.

The advantage of this one is that we never had to write any prompts for the LLM explicitly.

We explained **functionally** what we wanted the LLM to do and let DSPy take care of the rest.

## Optimize our DSPy RAG Module

For this second application of DSPy, we will optimize our RAG module to generate higher-quality answers.

The Optimization can change both the generated prompt and the AI Module parameters, for example, the number of returned documents.

DSPy provides different optimizers which work by:

  * Synthesizing good few-shot examples for every module like `dspy.BootstrapRS`

  * Proposing and intelligently exploring better natural-language instructions for every prompt like `dspy.MIPROv2`

  * And build datasets for your modules and use them to finetune the LLM weights in your system, like `dspy.BootstrapFinetune.3`




In this example, we will be using the `dspy.MIPROv2` Optimizer.

First we define our `RAG` DSPy module, which implements a `forward` function.
    
    
    class RAG(dspy.Module):
        def __init__(self):
            self.respond = dspy.ChainOfThought('context, question -> response')
    
        def forward(self, question):
            context = semantic_search.invoke(question)
            return self.respond(question=question,context=context)
    
    
    
    # Test the RAG module
    rag = RAG()
    rag(question = "Can I build and configure regression models in Dataiku?")
    #dspy.inspect_history(n=1) # Display the raw prompt generated for the last n calls
    
    
    
    Prediction(
        reasoning='Yes, you can build and configure regression models in Dataiku. The platform supports regression as one of the prediction types, allowing users to set a numeric target variable. In the Design tab, you can modify your target variable and choose regression for numeric targets. Additionally, Dataiku provides options for partitioning models, selecting performance metrics, and customizing hyperparameters, which are essential for effectively training regression models.',
        response='Yes, you can build and configure regression models in Dataiku. The platform allows you to set a numeric target variable and provides various options for model design, including partitioning, performance metrics, and hyperparameter customization.'
    )
    

We then format our input ground truth data to be compatible with the optimizer.

Note

This is a proof of concept. You might need to increase the number of ground truth Q&A to get better results.
    
    
    # Prepare data for optimization
    data = []
    for idx, row in df.iterrows():
        data.append({
            "question" :row["question"],
            "response" :row["ground_truths"],
            "gold_doc_ids" : [] # Not available in input dataset
        })
    data = [dspy.Example(**d).with_inputs('question') for d in data]
    
    trainset, devset = data[:20], data[20:50]
    len(trainset), len(devset)
    

We then define a metric for optimizing.

In this example, we use the `SemanticF1`, but DSPy offers to choose from.

The `dspy.Evaluate` allows us to set an average performance for our baseline RAG Module.
    
    
    from dspy.evaluate import SemanticF1
    
    # Instantiate the metric & and evaluator
    metric = SemanticF1(decompositional=True)
    evaluate = dspy.Evaluate(devset=devset, metric=metric, num_threads=24,
                             display_progress=True, display_table=2)
    
    # This sets a baseline Module Score
    evaluate(RAG())
    # Baseline Average Score : SemanticF1 = 55.3
    

| question | example_response | gold_doc_ids | reasoning | pred_response | SemanticF1  
---|---|---|---|---|---|---  
0 | How can I write a if condition in a Prepare recipe? | You should use th e "Create if, then, else statements" step. This p... | [] | To write an if condition in a Prepare recipe, you typically need t... | To write an if condition in a Prepare recipe, you can add a step i... | ✔️ [0.286]  
1 | How can I transform a dataset into an editable dataset? | The “Push to editable” recipe allows you to copy a regular dataset... | [] | To transform a dataset into an editable dataset in Dataiku, you ca... | To transform a dataset into an editable dataset, follow these step... | ✔️ [0.400]  
  
... 28 more rows not displayed ... 

It is time to feed some golden examples of questions and answers to our DSPy optimizer to optimize our module’s prompt generation.

Warning

This step can take some time and is very LLM query heavy. Make sure to estimate the cost of running the optimization and configure the parameters to fit your budget and LLM rate limit.
    
    
    tp = dspy.MIPROv2(metric=metric, auto="medium", num_threads=25)  # use fewer threads if your rate limit is small
    
    optimized_rag = tp.compile(RAG(), trainset=trainset,
                               max_bootstrapped_demos=2, max_labeled_demos=2,
                               requires_permission_to_run=False)
    

Once the training has been completed, we want to save the optimized model as a `json` artifact to a Dataiku [Managed Folder](<https://doc.dataiku.com/dss/latest/connecting/managed_folders.html> "\(in Dataiku DSS v14\)").

That way, next time we need the optimized prompt, we can load it back instead of optimizing the RAG module again!

Since the artifacts are saved as `json` objects, you can navigate the folders and see how the prompt configuration has changed.
    
    
    # Save the optimized model to managed folder
    handle = dataiku.Folder("1fazm3ba")
    
    # Save baseline rag
    baseline_file_path = handle.get_path() + "/baseline_rag.json"
    rag.save(baseline_file_path)
    
    # Save optimized rag
    optimized_rag_file_path = handle.get_path() + "/optimized_rag.json"
    optimized_rag.save(optimized_rag_file_path)
    
    
    
    # Ex: Load the optimized model from a managed folder
    loaded_rag = RAG()
    loaded_rag.load(optimized_rag_file_path)
    

Running the same question through the baseline and the optimized Module can already give us an idea of the difference in RAG performance.
    
    
    question = 'How can I write a pandas dataframe to a dataset in Python?'
    baseline = rag(question=question)
    print(baseline.response)
    
    
    
    You can write a pandas DataFrame to a dataset in Python using the following code:
    
    `python
    output_ds = dataiku.Dataset("myoutputdataset")
    output_ds.write_with_schema(my_dataframe)
    `
    
    This code creates a Dataset object for your output dataset and writes the DataFrame my_dataframe to it while maintaining the dataset's schema.
    
    
    pred = optimized_rag(question=question)
    print(pred.response)
    
    
    
    To write a Pandas DataFrame to a dataset in Python, you can use the following code:
    
    `python
    import dataiku
    import pandas as pd
    
    # Assuming 'my_dataframe' is your Pandas DataFrame
    output_ds = dataiku.Dataset("myoutputdataset")
    output_ds.write_with_schema(my_dataframe)
    `
    
    This code creates a Dataset object for the specified output dataset and writes the DataFrame to it while maintaining the schema

To understand why the answers are different, we can look at the differences in the prompts sent over to the LLM for both modules leveraging the `dspy.inspect_history(n=2)` tool.
    
    
    dspy.inspect_history(n=2) # Display the last two calls above
    

## Evaluating both RAG Modules with the LLM Evaluate Recipe

We could run the DSPy **evaluator** we created before, but the [LLM Evaluate Recipe](<https://knowledge.dataiku.com/latest/deploy/genai-monitoring/tutorial-llm-evaluation.html>) has a more comprehensive list of RAG metrics and integrates well with the rest of our Dataiku flow.
    
    
    # Eval the optimized rag Module
    evaluate(optimized_rag)
    # Result : SemanticF1 = 52.04
    

| question | example_response | gold_doc_ids | reasoning | pred_response | SemanticF1  
---|---|---|---|---|---|---  
0 | How can I write a if condition in a Prepare recipe? | You should use the "Create if, then, else statements" step. This p... | [] | In a Prepare recipe, you can write an if condition by using the sc... | To write an if condition in a Prepare recipe, you need to add step... | ✔️ [0.400]  
1 | How can I transform a dataset into an editable dataset? | The “Push to editable” recipe allows you to copy a regular dataset... | [] | To transform a dataset into an editable dataset in Dataiku, you ca... | To transform a dataset into an editable dataset in Dataiku, follow... | ✔️ [0.600]  
  
For this tutorial, all we need to do is log the relevant information to a dataset in the Flow to be used as input for the **LLM Evaluate Recipe**.
    
    
    # Run optimized prompt
    #df.drop(["generated_answer", "generated_reasoning","context_with_metadata"], axis=1, inplace=True)
    for i in df.index:
        question = df.at[i, "question"]
        answer = optimized_rag(question=question)
        df.at[i, "generated_answer"] = answer.get("response")
        df.at[i, "generated_reasoning"] = answer.get("reasoning")
        df.at[i, "context_with_metadata"] = semantic_search.invoke(question)
    
    dataiku.Dataset("answers_dspy_optimized").write_with_schema(df)

---

## [tutorials/genai/agents-and-tools/code-agent/index]

# Creating and using a Code Agent

A [Code Agent](<https://doc.dataiku.com/dss/latest/agents/code-agents.html> "\(in Dataiku DSS v14\)") is software that interacts with its environment. Agents can be built and deployed for different use cases. Dataiku provides several default implementations. This tutorial is focused on the _simple tool-calling_ agent implementation. The use case of this tutorial is the same as the one used in [LLM Mesh agentic applications](<../llm-agentic/index.html>), [Building and using an agent with Dataiku’s LLM Mesh and Langchain](<../agent/index.html>) and [Creating a custom tool](<../../../plugins/custom-tools/generality/index.html>). The use case involves retrieving customer information based on a provided ID and fetching additional data about the customer’s company utilizing an internet search.

## Prerequisites

  * Dataiku >= 13.4

  * An OpenAI connection

  * Python >= 3.9

  * A code environment with the following packages:
        
        langchain_core    # tested with 0.3.60
        langchain         # tested with 0.3.25
        duckduckgo_search # tested with 8.1.1
        

  * An SQL Dataset named `pro_customers_sql`. You can create this file by uploading this [`CSV file`](<../../../../_downloads/bebbdc65d2087c3bb5bc130dbea25663/pro_customers.csv>).




## Creating the Code Agent

To create a Code Agent, go to the project’s **Flow** , click the **Add item** button at the top right, select **Generative AI** , and click on **Code Agent**. Alternatively, you can select the **Agents & GenAI Models** item in the **GenAI** menu, click the **New Agent** button, and select the **Code Agent** option. Choose a meaningful name for the agent, then click the **Ok** button.

Fig. 1: Modal window for Code Agent creation.

In the modal window shown in Figure 1, choose the “Simple tool-calling agent” and click the **Create** button to enter a code environment, as shown in Figure 2.

Fig. 2: Code Agent – Code environment.

This window contains four tabs:

  * **Code** : where you will code your agent.

  * **Settings** : where you will notably set up the code environment used by the agent.

  * **Logs** : where you will find the agent’s logs. These logs are enriched each time your agent is called using the LLM Mesh.

  * **Quick test** : where you can test your code agent.




## Coding the Agent

Before coding the agent, select the **Settings** tabs and set **Code env** to use your code environment, which was created for the tutorial. Then, return to the **Code** tabs and start coding your agent. Dataiku provides a code sample to help you be more productive when creating a Code Agent. Like [Visual Agent](<https://doc.dataiku.com/dss/latest/agents/visual-agents.html> "\(in Dataiku DSS v14\)"), Code Agent relies on tools to answer your queries. There are three different ways to use a tool in a Code Agent:

  * Embedded into the Code Agent.

  * Using a function defined in the project library.

  * Using Custom Tools.




## Creating the tools

Attention

The SQL query might be written differently depending on your SQL Engine.

EmbeddedIn project libraryUsing Custom tools

To create the tools (**Get Customer Info** and **Get Company Info**), replace the default code with the code provided in Code 1.

Code 1: Embedded tools
    
    
    from langchain_core.tools import tool
    from langchain_core.messages import ToolMessage
    import dataiku
    from dataiku import SQLExecutor2
    from duckduckgo_search import DDGS
    from dataiku.llm.python import BaseLLM
    from dataiku.sql import Constant, toSQL, Dialects
    
    OPENAI_CONNECTION_NAME = "REPLACE_WITH_YOUR_CONNECTION_NAME"  # example: "openAI"
    
    @tool
    def get_customer_details(customer_id: str) -> str:
        """Get customer name, position and company information from database.
        The input is a customer id (stored as a string).
        The ouput is a string of the form:
            "The customer's name is \"{name}\", holding the position \"{job}\" at the company named \"{company}\""
        """
        dataset = dataiku.Dataset("pro_customers_sql")
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        cid = Constant(str(customer_id))
        escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT * FROM {table_name}  where "id"={escaped_cid}""")
        for (user_id, name, job, company) in query_reader.iter_tuples():
            return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named \"{company}\""
        return f"No information can be found about the customer {customer_id}"
    
    
    @tool
    def search_company_info(company_name: str) -> dict:
        """
        Use this tool when you need to retrieve information on a company.
        The input of this tool is the company name.
        The output is either a small recap of the company or "No information ..." meaning that we couldn't find information about this company
        """
        with DDGS() as ddgs:
            results = list(ddgs.text(f"{company_name} (company)", max_results=1))
            result = "Information found about " + company_name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(company_name, max_results=1)
                result = "Information found about " + company_name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + company_name
        return {"messages": result}
    
    
    tools = [get_customer_details, search_company_info]
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            project = dataiku.api_client().get_default_project()
            llm = project.get_llm(f"openai:{OPENAI_CONNECTION_NAME}:gpt-5-mini").as_langchain_chat_model(completion_settings=settings)
            llm_with_tools = llm.bind_tools(tools)
    
            messages = [m for m in query["messages"] if m.get("content")]
            iterations = 0
            while True:
                iterations += 1
                if iterations < 10:
                    with trace.subspan("Invoke LLM with tools") as llm_invoke_span:
                        llm_response = llm_with_tools.invoke(messages)
                else:
                    with trace.subspan("Invoke LLM without tools") as llm_invoke_span:
                        llm_response = llm.invoke(messages)
    
                if len(llm_response.tool_calls) == 0:
                    return {"text": llm_response.content}
    
                with llm_invoke_span.subspan("Call the tools") as tools_subspan:
                    messages.append(llm_response)
                    for tool_call in llm_response.tool_calls:
                        with tools_subspan.subspan("Call a tool") as tool_subspan:
                            tool_subspan.attributes["tool_name"] = tool_call["name"]
                            tool_subspan.attributes["tool_args"] = tool_call["args"]
                            if tool_call["name"] == "get_customer_details":
                                tool_output = get_customer_details.invoke(tool_call["args"])
                            elif tool_call["name"] == "search_company_info":
                                tool_output = search_company_info.invoke(tool_call["args"])
                            else:
                                raise ValueError("unknown tool: " + tool_call["name"])
                        messages.append(ToolMessage(tool_call_id=tool_call["id"], content=tool_output))
    

Under the **< />** Menu, select the **Libraries** menu. Under the `python` folder, create a folder called `tools`. In this folder, create a file `tutorial.py` and define the functions `get_customer_info` and `get_company_info` as shown in Code 1.

If you want to use those functions in a Code Agent, you should replace the default code with Code 2. Highlighted lines show where you have to pay attention compared to the Code Agent with embedded functions.

Code 1: `tutorial.py`
    
    
    import dataiku
    from dataiku import SQLExecutor2
    from duckduckgo_search import DDGS
    from dataiku.sql import Constant, toSQL, Dialects
    
    
    def get_customer_details(customer_id: str) -> str:
        """Get customer name, position and company information from database.
        The input is a customer id (stored as a string).
        The ouput is a string of the form:
            "The customer's name is \"{name}\", holding the position \"{job}\" at the company named \"{company}\""
        """
        dataset = dataiku.Dataset("pro_customers_sql")
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        cid = Constant(str(customer_id))
        escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT * FROM {table_name}  where "id"={escaped_cid}""")
        for (user_id, name, job, company) in query_reader.iter_tuples():
            return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named \"{company}\""
        return f"No information can be found about the customer {customer_id}"
    
    
    def search_company_info(company_name: str) -> dict:
        """
        Use this tool when you need to retrieve information on a company.
        The input of this tool is the company name.
        The ouput is either a small recap of the company or "No information ..." meaning that we couldn't find information about this company
        """
        with DDGS() as ddgs:
            results = list(ddgs.text(f"{company_name} (company)", max_results=1))
            result = "Information found about " + company_name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(company_name, max_results=1)
                result = "Information found about " + company_name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + company_name
        return {"messages": result}
    

Code 2: Using function in project library
    
    
    from langchain_core.tools import tool
    from langchain_core.messages import ToolMessage
    import dataiku
    from dataiku.llm.python import BaseLLM
    from tools.tutorial import get_customer_details, search_company_info
    
    OPENAI_CONNECTION_NAME = "REPLACE_WITH_YOUR_CONNECTION_NAME"  # example: "openAI"
    
    
    @tool
    def get_customer(customer: str) -> str:
        """Get customer name, position and company information from database.
        The input is a customer id (stored as a string).
        The ouput is a string of the form:
            "The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
        """
        return get_customer_details(customer)
    
    
    @tool
    def search_company(company: str) -> str:
        """
        Use this tool when you need to retrieve information on a company.
        The input of this tool is the company name.
        The ouput is either a small recap of the company or "No information ..." meaning that we couldn't find information about this company
        """
        return search_company_info(company)
    
    
    tools = [get_customer, search_company]
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            project = dataiku.api_client().get_default_project()
            llm = project.get_llm(f"openai:{OPENAI_CONNECTION_NAME}:gpt-5-mini").as_langchain_chat_model(completion_settings=settings)
            llm_with_tools = llm.bind_tools(tools)
    
            messages = [m for m in query["messages"] if m.get("content")]
            iterations = 0
            while True:
                iterations += 1
                if iterations < 10:
                    with trace.subspan("Invoke LLM with tools") as llm_invoke_span:
                        llm_response = llm_with_tools.invoke(messages)
                else:
                    with trace.subspan("Invoke LLM without tools") as llm_invoke_span:
                        llm_response = llm.invoke(messages)
    
                if len(llm_response.tool_calls) == 0:
                    return {"text": llm_response.content}
    
                with llm_invoke_span.subspan("Call the tools") as tools_subspan:
                    messages.append(llm_response)
                    for tool_call in llm_response.tool_calls:
                        with tools_subspan.subspan("Call a tool") as tool_subspan:
                            tool_subspan.attributes["tool_name"] = tool_call["name"]
                            tool_subspan.attributes["tool_args"] = tool_call["args"]
                            if tool_call["name"] == "get_customer":
                                tool_output = get_customer.invoke(tool_call["args"])
                            elif tool_call["name"] == "search_company":
                                tool_output = search_company.invoke(tool_call["args"])
                            else:
                                raise ValueError("unknown tool: " + tool_call["name"])
                        messages.append(ToolMessage(tool_call_id=tool_call["id"], content=tool_output))
    

If you have defined [Custom Tools](<../../../plugins/custom-tools/generality/index.html>), you can use them in a Code Agent. Suppose you have two tools defined: **Get Customer Info** and **Get Company Info** , like those defined in the tutorial [Creating a custom tool](<../../../plugins/custom-tools/generality/index.html>). You can directly use them in a Code Agent, as shown in Code 1.

Code 1: Using Custom Tools
    
    
    from langchain_core.tools import tool
    from langchain_core.messages import ToolMessage
    import dataiku
    from dataiku.llm.python import BaseLLM
    
    project = dataiku.api_client().get_default_project()
    
    OPENAI_CONNECTION_NAME = "REPLACE_WITH_YOUR_CONNECTION_NAME"  # example: "openAI"
    
    
    def find_tool(name: str):
        for tool in project.list_agent_tools():
            if tool["name"] == name:
                return project.get_agent_tool(tool['id'])
        return None
    
    
    # If you know the tool IDs, you can use them directly.
    get_customer = find_tool("Get Customer Info").as_langchain_structured_tool()
    get_company = find_tool("Get Company Info").as_langchain_structured_tool()
    
    tools = [get_customer, get_company]
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            project = dataiku.api_client().get_default_project()
            llm = project.get_llm(f"openai:{OPENAI_CONNECTION_NAME}:gpt-5-mini").as_langchain_chat_model(completion_settings=settings)
            llm_with_tools = llm.bind_tools(tools)
    
            messages = [m for m in query["messages"] if m.get("content")]
            iterations = 0
            while True:
                iterations += 1
                if iterations < 10:
                    with trace.subspan("Invoke LLM with tools") as llm_invoke_span:
                        llm_response = llm_with_tools.invoke(messages)
                else:
                    with trace.subspan("Invoke LLM without tools") as llm_invoke_span:
                        llm_response = llm.invoke(messages)
    
                if len(llm_response.tool_calls) == 0:
                    return {"text": llm_response.content}
    
                with llm_invoke_span.subspan("Call the tools") as tools_subspan:
                    messages.append(llm_response)
                    for tool_call in llm_response.tool_calls:
                        with tools_subspan.subspan("Call a tool") as tool_subspan:
                            tool_subspan.attributes["tool_name"] = tool_call["name"]
                            tool_subspan.attributes["tool_args"] = tool_call["args"]
                            if tool_call["name"] == get_customer.name:
                                tool_output = get_customer(tool_call["args"])
                            elif tool_call["name"] == get_company.name:
                                tool_output = get_company(tool_call["args"])
                            else:
                                raise ValueError("unknown tool: " + tool_call["name"])
                        messages.append(ToolMessage(tool_call_id=tool_call["id"], content=tool_output))
    

## Testing the Code Agent

No matter the way you define your Code Agent, you can test it in the **Quick test** tabs by entering the following test query:
    
    
    {
      "messages": [
          {
            "role": "user",
            "content": "Give all the professional information you can about the customer with ID: tcook. Also, include information about the company if you can."
          }
      ],
      "context": {}
    }
    

### Using the tool with code

After creating your agent, you can use it in any context where an LLM is applicable. To list all agents that have been defined in a project, you can use the [`list_llms()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms") and search for your agent.
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

Running this code snippet will provide a list of all LLMs defined in the project. You should see your agent in this list:
    
    
    - Agent - test guard (id: agent:2V8SR72P)
    - Agent - useCase4 (id: agent:44pVmkUi)
    - Agent - code (id: agent:4agXpWVO)
    - Agent - useCase5 (id: agent:GYrrlSns)
    - Agent - useCase1 (id: agent:IWX5i2Zh)
    - Agent - Visual (id: agent:Njgq8s9j)
    - Agent - Tutorial (id: agent:QRfIU99Z)
    

Once you know the agent’s ID, you can use it to call the agent, as shown in the code below:
    
    
    CODE_AGENT_ID = "agent:4agXpWVO"
    llm = project.get_llm(CODE_AGENT_ID)
    
    completion = llm.new_completion()
    completion.with_message('Give all the professional information you can about the customer with ID: fdouetteau. Also include information about the company if you can.')
    resp = completion.execute()
    resp.text
    
    
    
    "The customer's name is **Florian Douetteau** , holding the position of **CEO**
    at the company named **Dataiku**. \n\n### Company Information:\n
    Dataiku is a global software company specializing in machine learning
    and artificial intelligence. Since its launch in 2013, Florian Douetteau,
    as the co-founder and CEO, has been dedicated to making data science accessible
    to everyone, helping businesses unlock the potential of artificial intelligence."

## Wrapping up

Congratulations! You now know how to create a Code Agent. To wrap things up, setting up and utilizing a Code Agent in Dataiku opens up opportunities to automate and improve how we interact with Dataiku and data.

You can test other functions, mix the different approaches, or create many other Code Agents that fit your needs.

---

## [tutorials/genai/agents-and-tools/external-vector/index]

# Connecting to an external Vector Store

In this tutorial, you will learn how to connect to an external Vector Store using the Inline Python Agent tool. In this tutorial we will look at MongoDB Atlas Vector Search specifically, however, this tutorial would apply to other vector stores as well, as you’d only need to swap out the Mongo-specific code with the vector store you’d want to use otherwise.

## Prerequisites

As we’ll be creating an Inline Python Tool, it can be beneficial to read how they work in [this tutorial](<../inline-python-tool/index.html>). It is not a mandatory tutorial to follow, but it will allow you to understand the basics of Inline Python Tools.

  * Dataiku >= 14.2

  * MongoDB Atlas Cluster

    * Use the pre-seeded sample database if the database is empty

    * Have a username/password with read access to the database

    * A Vector Search Index

  * Python environment with `pymongo` installed as an additional package




## Introduction

In this tutorial, we’ll be diving into how to use MongoDB Atlas Vector Search in an Agent Tool. We’ll be using MongoDB Atlas to store the data. For easy demonstration of the tools.

You’ll see references to movies and a movie index in this tutorial. This is because we’re using the pre-seeded database by MongoDB: a collection of movies and their respective information. You, of course, don’t need to use the pre-seeded database, so feel free to adapt to your needs.

## Generate Embeddings

Although generating embeddings is listed as a prerequisite for this tutorial, it is essential to highlight this step. You will need to generate embeddings for the data you intend to use. You must use the same embedding model for creating the embeddings as you will use in the agent tool; Otherwise, it will not work (correctly).

Hint

If you haven’t yet created the embeddings, this is the time to do so. You can follow the tutorial on the [MongoDB Documentation](<https://www.mongodb.com/docs/atlas/atlas-vector-search/create-embeddings>) site for this if you don’t know how.

Storing the embeddings in the MongoDB Vector Search index is a mandatory step here.

## Setting up the Inline Python Tool

To set up the Inline Python Tool, go to the **GenAI** menu and click **Agent Tools**. Then click the **New Agent Tool** button on the top-right, and select **Inline Python**. Then, give it a suitable name, such as `MongoDB-Vector-Search`, and click **Create**.

The generated Inline Python Tool will have a prefilled code structure that we’ll use to create our tool.

### Selecting your Code Environment

Now, you need a Code Environment with the `pymongo` package installed.

See also

  * [How-to | Create a new code environment](<https://knowledge.dataiku.com/latest/admin-configuring/code-environments/how-to-create-code-env.html> "\(in Dataiku Academy v14.0\)")

  * [How-to | Manage code environment properties](<https://knowledge.dataiku.com/latest/admin-configuring/code-environments/how-to-manage-code-env-properties.html> "\(in Dataiku Academy v14.0\)")




Once you have created this Code Environment, you can select it through the **Settings** tab on your Inline Python Tool, and then click **Save**.

## Using MongoDB Vector Search

Now that you have all your configuration done correctly, it is time to focus on the code. As mentioned, we’ll be using the code already present in your Inline Python Tool by default. However, if it is not already present, here’s the code that should be in your tool right now.

[`inline-python-template.py`](<../../../../_downloads/315283deaef5b364202f4db11e6fa98a/inline-python-template.py>)
    
    
    import dataiku
    from dataiku.llm.agent_tools import BaseAgentTool
    
    class MyAgentTool(BaseAgentTool):
        """An empty interface for a code-based agent tool"""
    
        def __init__(self):
            pass
    
        def get_descriptor(self, tool):
            """
            Returns the descriptor of the tool, as a dict containing:
               - description (str)
               - inputSchema (dict, a JSON Schema representation)
            """
            return {
                "description": "",
                "inputSchema" : {
                    "$id": "",
                    "title": "",
                    "type": "object",
                    "properties": {},
                    "required": []
                }
            }
    
    
        def invoke(self, input, trace):
            """
            Invokes the tool.
    
            The arguments of the tool invocation are in input["input"], a dict
            """
            return {
                "output": "",
                "sources": [],
            }
    

Ensure you update the class name to something relevant, such as this.
    
    
    class MongoVectorSearchTool(BaseAgentTool):
    

### Importing pymongo

With everything set up correctly, we can now focus on the code required for talking to your MongoDB Vector Search. The first thing to do is importing `pymongo`.

Setting up imports
    
    
    import dataiku
    from dataiku.llm.agent_tools import BaseAgentTool
    from pymongo import MongoClient
    

### Configuration

The next step is configuration. There are several fields you will need to configure to get your connection working correctly. We’ll go over them one by one.

Configuration
    
    
    from pymongo import MongoClient
    
    MONGO_URI = "mongodb+srv://[username]:[password]@[cluster]"
    MONGO_DB = "movies"
    MONGO_COLLECTION = "movies_embeddings"
    MONGO_INDEX = "movie_index"
    TEXT_FIELD = "title"
    VECTOR_FIELD = "embedding"
    NUM_CANDIDATES = 100
    EMBEDDING_MODEL_ID = "internal-embedding-id"
    
    class MongoVectorSearchTool(BaseAgentTool):
    

  * `MONGO_URI`: Full MongoDB Atlas connection string, including username, password, and cluster host.

  * `MONGO_DB`: Name of the MongoDB database that stores the vectorized data.

  * `MONGO_COLLECTION`: Name of the collection inside that database containing documents and their embeddings.

  * `MONGO_INDEX`: Name of the MongoDB Atlas Vector Search index defined on the collection’s embedding field.

  * `TEXT_FIELD`: Name of the text field in each document that you want to return as the result.

  * `VECTOR_FIELD`: Name of the field in each document that stores the embedding vector used for similarity search.

  * `NUM_CANDIDATES`: Number of nearest-neighbor candidates MongoDB considers internally before selecting the top `k` results returned to the tool.

  * `EMBEDDING_MODEL_ID`: Identifier of the embedding model configured in the Dataiku project that you use to turn the query text into a vector.




### Defining config and descriptor

The methods for defining config and getting the descriptor, `set_config` and `get_descriptor` respectively, don’t need much adjustment. We won’t need `set_config` at all, and `get_descriptor` needs a bit of tweaking to match our use case. As `set_config` is a potential useful method, we’ll define it as an empty method.

We’ll also remove the `__init__` method from our code as we’re not using it in our use case.

Config and Descriptor
    
    
        def set_config(self, config, plugin_config):
            # Not needed for this script
            pass
    
        def get_descriptor(self, tool):
            return {
                "description": "Semantic search over a MongoDB Atlas Vector Search collection",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "query": {
                            "type": "string",
                            "description": "User question or search text",
                        },
                        "k": {
                            "type": "integer",
                            "description": "Number of results to return",
                            "default": 5,
                        },
                    },
                    "required": ["query"],
                },
            }
    

### Compute the search query

In the same way you’ve created embeddings for your dataset, you’ll also need to compute the embedding for your query. We’ll do this inline as so.

Computing the query
    
    
            args = input["input"]
            query_text = args["query"]
            client = dataiku.api_client()
            project = client.get_default_project()
            llm = project.get_llm(EMBEDDING_MODEL_ID)
    
            emb_query = llm.new_embeddings()
            emb_query.add_text(query_text)
            emb_resp = emb_query.execute()
            query_vector = emb_resp.get_embeddings()[0]
    

As you can see, we’re using the `EMBEDDING_MODEL_ID` you defined in the configuration to generate the embeddings using the built-in tools.

Hint

Ensure that your `EMBEDDING_MODEL_ID` matches the model used to generate the embeddings, to ensure this process works correctly.

### Connect to MongoDB

Next, we will connect to your MongoDB Vector Search. For this, we’re going to be using the `MongoClient` class you’ve imported from the `pymongo` package, and several of your configuration variables.

Using pymongo
    
    
            mongo = MongoClient(MONGO_URI)
            coll = mongo[MONGO_DB][MONGO_COLLECTION]
    

### Configuring the pipeline

With the connection in place, we can now configure the pipeline.

Vector Pipeline
    
    
            k = args.get("k", 5)
            pipeline = [
                {
                    "$vectorSearch": {
                        "index": MONGO_INDEX,
                        "path": VECTOR_FIELD,
                        "queryVector": query_vector,
                        "numCandidates": NUM_CANDIDATES,
                        "limit": k,
                    }
                },
                {
                    "$project": {
                        TEXT_FIELD: 1,
                        "score": {"$meta": "vectorSearchScore"},
                    }
                },
            ]
    

As you can see, we defined the pipeline using the MongoDB pipeline standards. We’ve defined the relevant fields, all explained in the configuration, as well as using the `k` property used in running this Inline Python Tool.

Furthermore, the second step of the pipeline defines the return value, where we return the `TEXT_FIELD` property we defined in the configuration, as well as the `score`, which is defined by the search.

### Getting the results

Everything is in place; the last step is to obtain the results and return them to the Inline Python Tool for consumption. For this, we only need a few more lines of code.

Getting results
    
    
            raw = list(coll.aggregate(pipeline))
            results = [
                {
                    "text": doc[TEXT_FIELD],
                    "score": doc["score"],
                }
                for doc in raw
            ]
    
            return {"output": results}
    

As you can see, we’re looping over the results, formatting the response, and then returning the results so it can be displayed in the Inline Python Tool or used by other agent tools.

## Testing the Inline Python Tool

Your code is complete. For reference, you can find the full code here.

[`mongodb-vector-search.py`](<../../../../_downloads/20be9cce30bc07cdec2d40a0623f8bb7/inline-python.py>)
    
    
    import dataiku
    from dataiku.llm.agent_tools import BaseAgentTool
    from pymongo import MongoClient
    
    MONGO_URI = "mongodb+srv://[username]:[password]@[cluster]"
    MONGO_DB = "movies"
    MONGO_COLLECTION = "movies_embeddings"
    MONGO_INDEX = "movie_index"
    TEXT_FIELD = "title"
    VECTOR_FIELD = "embedding"
    NUM_CANDIDATES = 100
    EMBEDDING_MODEL_ID = "internal-embedding-id"
    
    class MongoVectorSearchTool(BaseAgentTool):
        def set_config(self, config, plugin_config):
            # Not needed for this script
            pass
    
        def get_descriptor(self, tool):
            return {
                "description": "Semantic search over a MongoDB Atlas Vector Search collection",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "query": {
                            "type": "string",
                            "description": "User question or search text",
                        },
                        "k": {
                            "type": "integer",
                            "description": "Number of results to return",
                            "default": 5,
                        },
                    },
                    "required": ["query"],
                },
            }
    
        def invoke(self, input, trace):
            args = input["input"]
            query_text = args["query"]
            k = args.get("k", 5)
    
            client = dataiku.api_client()
            project = client.get_default_project()
            llm = project.get_llm(EMBEDDING_MODEL_ID)
    
            emb_query = llm.new_embeddings()
            emb_query.add_text(query_text)
            emb_resp = emb_query.execute()
            query_vector = emb_resp.get_embeddings()[0]
    
            mongo = MongoClient(MONGO_URI)
            coll = mongo[MONGO_DB][MONGO_COLLECTION]
    
            pipeline = [
                {
                    "$vectorSearch": {
                        "index": MONGO_INDEX,
                        "path": VECTOR_FIELD,
                        "queryVector": query_vector,
                        "numCandidates": NUM_CANDIDATES,
                        "limit": k,
                    }
                },
                {
                    "$project": {
                        TEXT_FIELD: 1,
                        "score": {"$meta": "vectorSearchScore"},
                    }
                },
            ]
    
            raw = list(coll.aggregate(pipeline))
            results = [
                {
                    "text": doc[TEXT_FIELD],
                    "score": doc["score"],
                }
                for doc in raw
            ]
    
            return {"output": results}
    

It is time to test the tool. If you have configured all correctly, you should see an immediate response.

On the right of the screen in your Inline Python Tool, you see a **Text** field. Enter a query that matches your data using the format below, and then click the **Run Test** button.
    
    
    {
       "input": {
          "query": "Give me movies about trains",
          "k": 5
       },
       "context": {}
    }
    

You should see the result below the Run Test button in the **Tool Output** tab.
    
    
    [
      {
        "text": "The Great Train Robbery",
        "score": 0.4930661916732788
      },
      {
        "text": "Shanghai Express",
        "score": 0.44809791445732117
      },
      {
        "text": "Now or Never",
        "score": 0.43981125950813293
      },
      {
        "text": "The Iron Horse",
        "score": 0.4387389123439789
      },
      {
        "text": "City Lights",
        "score": 0.4223432242870331
      }
    ]
    

This section is also where you can explore the **Logs** as well as the **Tool Descriptor** , which will show you the result of what you defined in the `get_descriptor` method.

## Conclusion

You’ve now connected to a remote MongoDB Vector Search using a Python Inline tool. You can use this connection and connections similar to it, to connect to external sources that have not been configured inside your Dataiku instance and/or those that are not supported out of the box by Dataiku.

You can now use this Inline Python tool to query your external Vector Store throughout Dataiku.

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.llm.DSSLLMEmbeddingsQuery`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsQuery> "dataikuapi.dss.llm.DSSLLMEmbeddingsQuery")(...) | A handle to interact with an embedding query.  
[`dataikuapi.dss.llm.DSSLLMEmbeddingsResponse`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsResponse> "dataikuapi.dss.llm.DSSLLMEmbeddingsResponse")(...) | A handle to interact with an embedding query result.  
  
### Functions

[`get_llm`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_llm> "dataikuapi.dss.project.DSSProject.get_llm")(llm_id) | Get a handle to interact with a specific LLM  
---|---  
[`new_embeddings`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.new_embeddings> "dataikuapi.dss.llm.DSSLLM.new_embeddings")([text_overflow_mode]) | Create a new embedding query.  
[`get_embeddings`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsResponse.get_embeddings> "dataikuapi.dss.llm.DSSLLMEmbeddingsResponse.get_embeddings")() | Retrieve vectors resulting from the embeddings query.  
[`add_text`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.add_text> "dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.add_text")(text) | Add text to the embedding query.  
[`execute`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.execute> "dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.execute")() | Run the embedding query.

---

## [tutorials/genai/agents-and-tools/index]

# Agents and Tools for Generative AI

Large Language Models (LLMs) are powerful but have inherent limitations in areas like real-time data access, mathematical computations, and specialized domain knowledge. To overcome these constraints, you can use certain tools and techniques to extend LLM capabilities through external functions, structured workflows, and integrations with other systems.

This section explores key approaches for enhancing LLM performance, from basic tool integration to complex agentic behaviors, enabling more accessible and even more powerful AI applications.

Concepts & examples

You can find code samples on this subject in the Developer Guide: [Agents](<../../../concepts-and-examples/agents.html>).

## Agents

### Visual agent and custom tool

[This tutorial](<../../plugins/custom-tools/generality/index.html>) shows how to build a custom tool. Once you have built a custom tool, or if you want to use tools provided by Dataiku, you can follow [this tutorial](<visual-agent/index.html>).

### Code Agent

[This tutorial](<code-agent/index.html>) introduces how you can use [Code Agents](<https://doc.dataiku.com/dss/latest/agents/code-agents.html> "\(in Dataiku DSS v14\)") in Dataiku. If you want to create your agent, you should follow [this tutorial](<../../plugins/agent/generality/index.html>). You can also create an [Inline Python Tool](<inline-python-tool/index.html>) in a simplified experience with inline code. As described in the [multi-agent tutorial](<multi-agent/index.html>), you will need a multi-agent system when working on complex tasks. You may also need to define your [LLM Connection](<../../plugins/llm-connection/generality/index.html>).

### Integrating an agent framework

[This tutorial](<integrating-agent-framework/index.html>) shows you how to use an agent framework in a Code Agent.

### LLM Mesh agentic applications

[This tutorial](<llm-agentic/index.html>) series demonstrates how to build agentic applications using the LLM Mesh in Dataiku.

### Integrate with external Vector Stores

[This tutorial](<external-vector/index.html>) explains how you can connect to an external Vector Store using the Inline Python Tool.

### Model Context Protocl (MCP)

[This tutorial](<mcp/index.html>) series demonstrates how to build custom & 3rd party MCP Servers using Code studios and Webapps in Dataiku.

### Langchain agents

In addition, you could also build agents in Dataiku using the Langchain framework. Langchain enhances LLM capabilities by integrating planning, memory, and tools modules. This allows LLMs to perform more complex tasks like accessing databases or interfacing with other software.

You can find the tutorial [here](<agent/index.html>).

## Processing

### Using JSON outputs

[This tutorial](<json-output/index.html>) demonstrates how to process and get structured outputs via the LLM Mesh.

## Prompt

### Auto Prompt Strategies with DSPy

[This tutorial](<auto-prompt/index.html>) demonstrates the usage of an auto-prompting library and its usage.

## Monitoring

### Adding traces to your agent

[This tutorial](<traces/index.html>) demonstrates the usage of traces to help you understand your agent’s behavior.

---

## [tutorials/genai/agents-and-tools/inline-python-tool/index]

# Creating an Inline Python Tool

You can elaborate your code in an Inline Python Tool before creating your [Code Agent](<../code-agent/index.html>) or [Custom Tool](<../../../plugins/custom-tools/generality/index.html>). An Inline Python Tool will allow you to keep a simple development workflow and inline your Python code. The tool produced will be available in your project, and you will have straightforward steps to create a shared tool like a Custom Tool or a Code Agent.

## Prerequisites

  * Dataiku >= 14.0

  * An OpenAI connection (or an equivalent LLM Mesh connection)

  * Python >= 3.10

  * A code environment with the following packages:
        
        langchain_core    #tested with 0.3.60
        langchain         #tested with 0.3.25
        duckduckgo_search #tested with 8.0.2
        

  * An SQL Dataset named `pro_customers_sql`. You can create this dataset by uploading this [`CSV file`](<../../../../_downloads/bebbdc65d2087c3bb5bc130dbea25663/pro_customers.csv>) and using a Sync recipe to store the data in an SQL connection.




## Creating the Inline Python Tool

To create an Inline Python Tool, go to the **GenAI** menu, select **Agent Tools** , and click the **New Agent Tool** button. Then select **Inline Python** , give it a meaningful name, such as **Get Company Info** , and click the **Create** button.

The window you reach contains three tabs:

  * **Design** : where you will code your tool and test your Inline Python Tool.

  * **Settings** : where you will notably set up the code environment the tool uses.

  * **History** : where you can see the history of the tool.




## Coding the Tool

Note

The code used in this tutorial is the same as the one used to define the first tool in the [Custom Tool tutorial](<../../../plugins/custom-tools/generality/index.html#custom-tool-dataset-lookup-tool-link>). When creating your Inline Python Tool, you are building the code that may be used in other tools and agents.

In the **Design** tab, you can write the code of your specific tool. You can start from one of the templates available by clicking the **Use code template** button. For this tutorial, we will code a tool to **Get Customer Info**. Replace the default code with the code provided in Code 1.

Code 1: Get Customer Info tool
    
    
    from dataiku.llm.agent_tools import BaseAgentTool
    import logging
    import dataiku
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    
    
    class DatasetLookupTool(BaseAgentTool):
        def set_config(self, config, plugin_config):
            self.logger = logging.getLogger(__name__)
            self.config = config
            self.plugin_config = plugin_config
    
        def get_descriptor(self, tool):
            return {
                "description": """Provide a name, job title and company of a customer, given the customer's ID""",
                "inputSchema": {
                    "title": "Input for a customer id",
                    "type": "object",
                    "properties": {
                        "id": {
                            "type": "string",
                            "description": "The customer Id"
                        }
                    }
                }
    
            }
    
        def invoke(self, input, trace):
            self.logger.setLevel(logging.DEBUG)
            self.logger.debug(input)
    
            args = input["input"]
            customerId = args["id"]
            dataset = dataiku.Dataset("pro_customers_sql")
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(customerId))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
    
            for (name, job, company) in query_reader.iter_tuples():
                return {
                    "output": f"""The customer's name is "{name}", holding the position "{job}" at the company named "{company}"."""}
            return {"output": f"No information can be found about the customer {customerId}"}
    

## Testing the Code Agent

Once you have your code, you can test it by entering the following test query:
    
    
    {
       "input": {
          "id": "tcook"
       },
       "context": {}
    }
    

## Call your Inline Python Tool from your application

After creating your agent, you can utilize it in any context where an LLM is applicable. It is a process in two steps:

First, you need to get the identifier of your Inline Python Tool. To list all Inline Python Tools that have been defined in a project, you can use the [`list_agent_tools()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_agent_tools> "dataikuapi.dss.project.DSSProject.list_agent_tools") and search for your tool.

Code 2: Get your Inline Python Tool identifier
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    project.list_agent_tools()
    

Running this code snippet will provide a list of all tools defined in the project. You should see your tool in this list:
    
    
    [{'id': 'xg3bQfN',
        'type': 'InlinePython',
        'name': 'inline-tool'},
    {'id': 'REDaiQN',
        'type': 'Custom_agent_tool_toolbox_internet-search',
        'name': 'Get Company Info'},
    {'id': 'SOy7zKq',
        'type': 'Custom_agent_tool_toolbox_dataset-lookup',
        'name': 'Get Customer Info'}]
    

Once you know the tool’s ID, you can use it to call the tool, as shown in the code below:

Code 3: Call your Inline Python Tool
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    tool =  project.get_agent_tool('xg3bQfN')
    result = tool.run({"id": "fdouetteau"})
    
    print(result['output'])
    
    
    
    The customer's name is "Florian Douetteau", holding the position "CEO" at the company named "Dataiku".
    

Using this type of code, you can call any of your Inline Python Tools at the right place in your application’s code.

## Call a Headless API from an Inline Python Tool

After following the [Headless API tutorial](<../../../webapps/common/api-llm/index.html>), you will have an application that can query an LLM from an API. An Inline Python Tool can use a headless API webapp to implement a query.

As we did for the first tool, to create a new Inline Python Tool, go to the **GenAI** menu, select **Agent Tools** , and click the **New Agent Tool** button. Then select **Inline Python** , give it a meaningful name, such as **API tool** , and click the **Create** button.

To call your API, you need to get the identifier of your headless API webapp. You can use the [`list_webapps()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_webapps> "dataikuapi.dss.project.DSSProject.list_webapps") to search for your webapp.

Code 4: Get your headless API webapp identifier
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    for webapp in project.list_webapps():
        print(f"WebApp id: {webapp['id']} name: {webapp['name']}")
    

Running this code snippet will provide a list of all webapp defined in the project. You should see your headless API webapp in this list:
    
    
    WebApp id: aRdCgN0 name: std
    WebApp id: cpxmkji name: headless api
    WebApp id: fzUJ5Bw name: llm based
    WebApp id: iNFGFHN name: Uploading
    

Note the id; in the **Design** tab, you can write the code provided in Code 5.

Code 5: Query API tool
    
    
    import dataiku
    from dataiku.llm.agent_tools import BaseAgentTool
    import logging
    
    
    class ApiAgentTool(BaseAgentTool):
        """A code-based agent tool that queries a headless API"""
    
        def set_config(self, config, plugin_config):
            self.logger = logging.getLogger(__name__)
    
        def get_descriptor(self, tool):
            """
            Returns the descriptor of the tool, as a dict containing:
               - description (str)
               - inputSchema (dict, a JSON Schema representation)
            """
            return {
                "description": "Provide a prompt to use to query the headless API",
                "inputSchema" : {
                    "$id": "",
                    "title": "",
                    "type": "object",
                    "properties": {
                        "prompt": {
                            "type": "string",
                            "description": "The prompt to use in the API call"
                        }
                    }
                }
            }
    
    
        def invoke(self, input, trace):
            """
            Invokes the tool.
    
            The arguments of the tool invocation are in input["input"], a dict
            """
            self.logger.setLevel(logging.DEBUG)
            self.logger.debug(input)
    
            WEBAPP_ID = "cpxmkji"
            client = dataiku.api_client()
            project = client.get_default_project()
            webapp = project.get_webapp(WEBAPP_ID)
            backend = webapp.get_backend_client()
            backend.session.headers['Content-Type'] = 'application/json'
            prompt = input['input']['prompt']
    
            # Query the LLM
            response = backend.session.post(backend.base_url + '/query', json={'message':prompt})
            if response.ok:
                return { "output": response.text }
            else:
                return { "output": f"An error occured: {response.status_code} {response.reason}" }
    

Your Query API agent is now available. You can follow the same steps as for the first tool. Identify the tool with Code 3. The tool list will look like this:
    
    
    [{'id': 'xg3bQfN', 'type': 'InlinePython', 'name': 'inline-tool'},
    {'id': 'REDaiQN', 'type': 'Custom_agent_tool_toolbox_internet-search', 'name': 'Get Company Info'},
    {'id': 'SOy7zKq', 'type': 'Custom_agent_tool_toolbox_dataset-lookup', 'name': 'Get Customer Info'},
    {'id': 'rmESZYL', 'type': 'InlinePython', 'name': 'api_tool'}]
    

As previously, you can now call your Query API tool with Code 6.

Code 6: Call your Query API Tool
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    tool =  project.get_agent_tool('rmESZYL')
    result = tool.run({"prompt": "Do you know Dataiku?"})
    
    print(result['output'])
    
    
    
    Yes, I am familiar with Dataiku. Dataiku is a data science and machine learning platform designed to help enterprises build and manage their data projects more efficiently.
    It provides tools for data preparation, analytics, machine learning, and deployment in a collaborative environment.
    Users can work with data using both a code-free, visual interface and through coding in languages like Python, R, and SQL. Dataiku is designed to empower data scientists, engineers, and analysts to work together on data-driven projects and make the process of developing and deploying models more streamlined and scalable.
    

## Wrapping up

Congratulations! You now know how to create an Inline Python Tool. You can use this to define and test your tool efficiently. Among the possible next steps, you can implement your current code in a [Code Agent](<../code-agent/index.html>) . This will allow you to broaden the scope of your code’s usage and make it available to other projects.

## Reference documentation

### Classes

[`dataiku.Dataset`](<../../../../api-reference/python/datasets.html#dataiku.Dataset> "dataiku.Dataset")(name[, project_key, ignore_flow]) | Provides a handle to obtain readers and writers on a dataiku Dataset.  
---|---  
[`dataiku.SQLExecutor2`](<../../../../api-reference/python/sql.html#dataiku.SQLExecutor2> "dataiku.SQLExecutor2")([connection, dataset]) | This is a handle to execute SQL statements on a given SQL connection.  
`dataiku.llm.agent_tools.BaseAgentTool`() | The base interface for a code-based agent tool  
[`dataikuapi.DSSClient`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
[`dataikuapi.dss.project.DSSProject`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.webapp.DSSWebApp`](<../../../../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp> "dataikuapi.dss.webapp.DSSWebApp")(client, ...) | A handle for the webapp.  
[`dataikuapi.dss.webapp.DSSWebAppBackendClient`](<../../../../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppBackendClient> "dataikuapi.dss.webapp.DSSWebAppBackendClient")(...) | A client to interact by API with a standard webapp backend  
  
### Functions

`api_client`() | Obtain an API client to request the API of this DSS instance  
---|---  
[`get_agent_tool`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_agent_tool> "dataikuapi.dss.project.DSSProject.get_agent_tool")(tool_id) | Get a handle to interact with a specific tool  
[`get_backend_client`](<../../../../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp.get_backend_client> "dataikuapi.dss.webapp.DSSWebApp.get_backend_client")() |   
[`get_default_project`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")() | Get a handle to the current default project, if available (i.e.  
[`get_location_info`](<../../../../api-reference/python/datasets.html#dataiku.Dataset.get_location_info> "dataiku.Dataset.get_location_info")([sensitive_info]) | Retrieve the location information of the dataset.  
[`get_webapp`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_webapp> "dataikuapi.dss.project.DSSProject.get_webapp")(webapp_id) | Get a handle to interact with a specific webapp  
[`list_agent_tools`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_agent_tools> "dataikuapi.dss.project.DSSProject.list_agent_tools")([as_type, include_shared]) | 

param str as_type:
    How to return the list. Supported values are "listitems" and "objects" (defaults to **listitems**).  
[`list_webapps`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_webapps> "dataikuapi.dss.project.DSSProject.list_webapps")([as_type]) | List the webapp heads of this project  
[`query_to_iter`](<../../../../api-reference/python/sql.html#dataiku.SQLExecutor2.query_to_iter> "dataiku.SQLExecutor2.query_to_iter")(query[, pre_queries, ...]) | This function returns a `QueryReader` to iterate on the rows.  
[`session`](<../../../../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppBackendClient.session> "dataikuapi.dss.webapp.DSSWebAppBackendClient.session") |

---

## [tutorials/genai/agents-and-tools/integrating-agent-framework/index]

# Integrating an agent framework

To tailor your [Code Agent](<../code-agent/index.html>) to suit your needs, consider using an agent framework, such as Google ADK, CrewAI, Microsoft AutoGen, or LangGraph. For this tutorial, you will implement a Code Agent with the help of the CrewAI framework. You will learn how to integrate this kind of framework, leveraging Dataiku tools and resources. The Agent will be a financial assistant, conducting research on companies and utilizing a tool to obtain quotes.

## Prerequisites

  * Dataiku >= 13.4

  * Python >= 3.10

  * A code environment with the following packages:
        
        crewai    #tested with 1.4.0
        yfinance  # tested with 0.2.66
        




## Creating the Code Agent

You need to create a Code Agent to represent your financial assistant. It will host the code of the different elements needed.

To create a Code Agent, go to the project’s **Flow** , click the **Add item** button at the top right, select **Generative AI** , and click on **Code Agent**. Choose a meaningful name for the agent, then click the **Ok** button. In the modal window, choose the “Simple tool-calling agent” and click the **Create** button.

In the **Settings** tab, verify you use a code environment with the prerequisites needed. You are now ready to code the financial assistant in the **Design** tab.

If you need more details on this creation step, you can read the [following tutorial](<../code-agent/index.html#tutorial-genai-agents-and-tools-code-agent-creation>), which describes the complete procedure.

## Coding the Agent

The architecture of your financial assistant will be as follows:

  * An [Agent](<https://docs.crewai.com/en/concepts/agents>) will be assigned to the financial assistant [Task](<https://docs.crewai.com/en/concepts/tasks>)

  * To achieve this task, the Agent will use an [LLM wrapper](<https://docs.crewai.com/en/concepts/llms#3-direct-code>)

  * During the thinking process of the LLM, a [tool](<https://docs.crewai.com/en/learn/create-custom-tools>) will be provided to help find quote information.

  * The orchestration of those elements will be controlled by a [Crew](<https://docs.crewai.com/en/concepts/crews>)




We will detail and implement each of these elements. You will insert all the code in the code editor of the **Design** tab of the Code Agent you just created.

Let’s start by setting some environment variables and settings.

Code 1: Setting environment
    
    
        def process(self, query, settings, trace):
            # Specify the Dataiku OpenAI-compatible public API URL, e.g., http://<DATAIKU_HOST>/public/api/projects/<PROJECT_KEY>/llms/openai/v1/
            BASE_URL = ""
    
            # Use your Dataiku API key instead of an OpenAI secret
            API_KEY = ""
    
            # Fill with your LLM ID - to get the list of LLM IDs, you can use dataiku.api_client().project.list_llms()
            LLM_ID = ""
    
            # Disable CrewAI telemetry if you have no usage of it
            os.environ['CREWAI_DISABLE_TELEMETRY'] = 'true'
    
    

This code sets up the OpenAI client by pointing it to its LLM Mesh configuration. You will need several pieces of information for access and authentication:

  * `BASE_URL` is a public Dataiku URL to access the LLM Mesh API, e.g., `http://<DATAIKU_HOST>/public/api/projects/<PROJECT_KEY>/llms/openai/v1/`. More information is available in the [Concept And Examples section](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-openai-compatible-api>).

  * If you don’t have a valid Dataiku `API_KEY`, go to your Dataiku **Profile & Settings** and then the **API Keys** Tab. Generate a new key.

  * This [code snippet](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>) provides instructions on obtaining an `LLM_ID`.




### Creating a tool

Now, we can add the code for the tool that will retrieve quote information from the Yahoo Finance service.

Code 2: Creating a tool
    
    
            @tool("Get quotes from Yahoo Finance")
            def get_quotes(company: str) -> str:
                """
                    This tool is used to retrieve quotes for a company from Yahoo Finance.
                    The output is a text with a line per quote found, separated by a new line.
    
                    :param company: str, the name of the company to retrieve quotes for.
                """
                message = f"No quote found for {company}"
    
                quotes = yf.Search("apple", include_research=True).quotes
                if len(quotes) > 0:
                    message = f"I found {len(quotes)} quote" + "s.\n" if len(quotes) >= 1 else ".\n"
                    for quote in quotes:
                        message += f"from {quote['exchange']} with symbol {quote['symbol']} for {quote['score']}\n"
    
                return message
    

The CrewAI framework offers an [annotation dedicated to the tool creation](<https://docs.crewai.com/en/learn/create-custom-tools#using-the-tool-decorator>). Always document the purpose, action, input, and output of the tool in the docstring: you will significantly improve your results.

### Wrapping the LLM

In order to use our Dataiku LLM mesh, we will create a [CrewAI wrapper](<https://docs.crewai.com/en/concepts/llms#3-direct-code>) for it.

Code 2: Creating a tool
    
    
            chosen_llm = LLM(
                model=LLM_ID,
                api_key=API_KEY,
                base_url=BASE_URL,  # Optional custom endpoint
                temperature=0.7,
                max_tokens=4000,
                top_p=0.9,
                frequency_penalty=0.1,
                presence_penalty=0.1,
                stop=["END"],
                seed=42,  # For reproducible outputs
                stream=True,  # Enable streaming
                timeout=60.0,  # Request timeout in seconds
                max_retries=3,  # Maximum retry attempts
                logprobs=True,  # Return log probabilities
                top_logprobs=5,  # Number of most likely tokens
                reasoning_effort="medium"  # For o1 models: low, medium, high
            )
    

You have all the parameters to fine-tune your usage, whether you want to adjust the temperature, limit the number of tokens, or enable streaming.

### Creating the Agent

The Agent is the entity that will make decisions, collaborate with other agent or decide to use tools.

Code 3: Creating an Agent
    
    
            financial_agent = Agent(
                role="Financial and economics Assistant",
                goal="Assist the user on specific tasks about finance and companies and answer queries",
                backstory="You are a financial assistant and you help the user "
                          "by answering questions on financial information about companies. "
                          "Do not assume any info. "
                          "To find the available financial quotes for the company, use a tool. "
                          "If you find several quotes, list all of them. "
                          "If you don't know, just say you don't know. "
                          "Answer with 3 or 4 sentences maximum and use a polite tone.",
                allow_delegation=False,
                llm=chosen_llm,
                tools=[get_quotes],
                verbose=True
            )
    

  * `name` and `description` are there to help you identify what you want to do with this Agent and have a descriptive value for yourself and your teams.

  * `role` will define the Agent’s action and its domain of expertise.

  * `goal` will direct the Agent’s effort and guide its decision-making.

  * `backstory` will give the Agent depth and background.

  * `llm` is as simple as it sounds: it’s the model you will use for this agent.

  * `tools` will list the tools that this Agent will be able to use.




### Creating the Task

The Task is the definition of the expected action an Agent will fulfill.

Code 4: Creating a Task
    
    
            financial_task = Task(
                description=(
                    "1. Analyze and answer the question: {topic}."
                    "2. Find the name of the company in the question. If there is no company name, stop working here and tell it in the answer."
                    "3. Find the available financial quotes for the company from Yahoo Finance."
                ),
                expected_output="A well-written paragraph with 3 or 4 sentences maximum, "
                                "use a corporate tone.",
                agent=financial_agent,
            )
    

Once more, be as precise as possible in the `description` and the `expected_output` to improve the quality of the answers.

### Creating the Crew

The Crew is the entity that is in charge of overall workflow of the Agents execution and collaboration to achieve the assigned tasks.

Code 5: Creating a Crew
    
    
            crew = Crew(
                agents=[financial_agent],
                tasks=[financial_task]
            )
    

### Evaluating the answer

The last step is to launch the Crew action with the parameters coming from the user message.

Code 6: Evaluating the answer
    
    
            iterations = 0
            while True:
                iterations += 1
    
                result = crew.kickoff(inputs={"topic": query["messages"][-1]["content"]})
    
                return {"text": result.raw}
    

To test your Code Agent, you can use the **Quick Test** zone.

Fig. 1: Code Agent test.

## Complete code

Here is the complete code of the Code Agent using an agent framework:

Code 7: Complete code of the Code Agent
    
    
    import os
    from dataiku.llm.python import BaseLLM
    import yfinance as yf
    from crewai import Agent, Task, Crew, LLM
    from crewai.tools import tool
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            # Specify the Dataiku OpenAI-compatible public API URL, e.g., http://<DATAIKU_HOST>/public/api/projects/<PROJECT_KEY>/llms/openai/v1/
            BASE_URL = ""
    
            # Use your Dataiku API key instead of an OpenAI secret
            API_KEY = ""
    
            # Fill with your LLM ID - to get the list of LLM IDs, you can use dataiku.api_client().project.list_llms()
            LLM_ID = ""
    
            # Disable CrewAI telemetry if you have no usage of it
            os.environ['CREWAI_DISABLE_TELEMETRY'] = 'true'
    
            @tool("Get quotes from Yahoo Finance")
            def get_quotes(company: str) -> str:
                """
                    This tool is used to retrieve quotes for a company from Yahoo Finance.
                    The output is a text with a line per quote found, separated by a new line.
    
                    :param company: str, the name of the company to retrieve quotes for.
                """
                message = f"No quote found for {company}"
    
                quotes = yf.Search("apple", include_research=True).quotes
                if len(quotes) > 0:
                    message = f"I found {len(quotes)} quote" + "s.\n" if len(quotes) >= 1 else ".\n"
                    for quote in quotes:
                        message += f"from {quote['exchange']} with symbol {quote['symbol']} for {quote['score']}\n"
    
                return message
    
            chosen_llm = LLM(
                model=LLM_ID,
                api_key=API_KEY,
                base_url=BASE_URL,  # Optional custom endpoint
                temperature=0.7,
                max_tokens=4000,
                top_p=0.9,
                frequency_penalty=0.1,
                presence_penalty=0.1,
                stop=["END"],
                seed=42,  # For reproducible outputs
                stream=True,  # Enable streaming
                timeout=60.0,  # Request timeout in seconds
                max_retries=3,  # Maximum retry attempts
                logprobs=True,  # Return log probabilities
                top_logprobs=5,  # Number of most likely tokens
                reasoning_effort="medium"  # For o1 models: low, medium, high
            )
    
            financial_agent = Agent(
                role="Financial and economics Assistant",
                goal="Assist the user on specific tasks about finance and companies and answer queries",
                backstory="You are a financial assistant and you help the user "
                          "by answering questions on financial information about companies. "
                          "Do not assume any info. "
                          "To find the available financial quotes for the company, use a tool. "
                          "If you find several quotes, list all of them. "
                          "If you don't know, just say you don't know. "
                          "Answer with 3 or 4 sentences maximum and use a polite tone.",
                allow_delegation=False,
                llm=chosen_llm,
                tools=[get_quotes],
                verbose=True
            )
    
            financial_task = Task(
                description=(
                    "1. Analyze and answer the question: {topic}."
                    "2. Find the name of the company in the question. If there is no company name, stop working here and tell it in the answer."
                    "3. Find the available financial quotes for the company from Yahoo Finance."
                ),
                expected_output="A well-written paragraph with 3 or 4 sentences maximum, "
                                "use a corporate tone.",
                agent=financial_agent,
            )
    
            crew = Crew(
                agents=[financial_agent],
                tasks=[financial_task]
            )
    
            iterations = 0
            while True:
                iterations += 1
    
                result = crew.kickoff(inputs={"topic": query["messages"][-1]["content"]})
    
                return {"text": result.raw}
    

## Wrapping up

Congratulations! You now have a Code Agent that uses an agent framework, but still benefits from all Dataiku resources.

---

## [tutorials/genai/agents-and-tools/json-output/index]

# Using the LLM Mesh to parse and output JSON objects

## Introduction

In this tutorial, you will process structured objects and receive JSON output from a model via the LLM Mesh. As autoregressive text generation models, LLMs almost often produce free-form text responses. You can ensure consistent results using JSON for both input and output, especially by specifying an output schema. Defined schemas are also easy to process, less error-prone and especially useful for saving the output for data analysis or use in downstream applications. The tutorial showcases this technique by performing sentiment analysis on product reviews. It could be extended to other tasks that process or output text.

## Prerequisites

  * Dataiku >= 13.3

  * Project permissions for “Read project content” and “Write project content”

  * An existing LLM Mesh connection that supports JSON output (OpenAI, Azure OpenAI, Vertex Gemini as of [13.3](<https://doc.dataiku.com/dss/latest/release_notes/13.html#id16>), with _experimental_ support on Hugging Face models)




## Data extraction

This tutorial uses the [Amazon Review Dataset](<https://nijianmo.github.io/amazon/index.html>). The Python script below downloads one of the subset [datasets](<http://jmcauley.ucsd.edu/data/amazon_v2/categoryFilesSmall/Luxury_Beauty_5.json.gz>), creates a small sample of reviews and uploads it as a dataset named `amznreviews-sample`. To use this script, you must create a Python recipe from the Flow with an output dataset named `amznreviews-sample` and copy the code into the recipe’s editor. Pay attention to how the reviews are stored as JSON with keys for product category and review text.

Extracting a sample from reviews dataset
    
    
    import dataiku
    import requests
    import gzip
    import json
    import random
    
    
    # URL & filenames to download & create
    URL = 'http://jmcauley.ucsd.edu/data/amazon_v2/categoryFilesSmall/Luxury_Beauty_5.json.gz'
    FILE_NAME = 'Luxury_Beauty_5.json.gz'
    FILE_UNZIP = 'Luxury_Beauty_5.json'
    PROD_CATEGORY = "Luxury Beauty"
    SAMPLE_SIZE = 47
    DATASET_NAME = "amznreviews-sample"
    
    response = requests.get(URL)
    
    with open(FILE_NAME, 'wb') as f:
        f.write(response.content)
    
    # Unzip the archive
    with gzip.open(FILE_NAME, 'rb') as gz_file:
         with open(FILE_UNZIP, "wb") as f_out:
            f_out.write(gz_file.read())
    
    with open(FILE_UNZIP, "r", encoding="utf-8") as f:
        data = []
        for line in f:
            record = json.loads(line)
            review = {
                "product_category": PROD_CATEGORY,
                "text": record.get("reviewText", "")
            }
            data.append({
                "review": json.dumps(review),
                "sentiment_score": record.get("overall", ""),
                "sentiment": "negative" if record["overall"] in [1, 2] 
                            else "neutral" if record["overall"] == 3 
                            else "positive"
            })
    
    # Get a random sample of records
    sample_data = random.sample(data, SAMPLE_SIZE)
    
    # Get the dataset object
    dataset = dataiku.Dataset(DATASET_NAME)
    
    # Define the schema for the dataset
    schema = [{"name": "review", "type": "string"},
              {"name": "sentiment_score", "type": "int"},
              {"name": "sentiment", "type": "string"}]
    
    # Write the schema to the dataset
    dataset.write_schema(schema)
    
    # Write the rows to the dataset
    with dataset.get_writer() as writer:
        for row in sample_data:
            writer.write_row_dict(row)
    

## Setting up the schema for JSON output

Note

Similar to the last script, you’ll create another Python recipe in the Flow with `amznreviews-sample` as the input dataset and `amznreviews-sample-llm-scored` as the output. Copy the scoring script (`score`) available at the end of this tutorial into the recipe’s editor. The sections below will discuss only relevant snippets of code.

Next, you will use the LLM Mesh to analyze product reviews and generate structured JSON responses. The key to getting consistent, structured output is defining the JSON schema beforehand when setting up the LLM’s completion task. It ensures that the output follows a predefined schema, making it easier to process and validate. The goal is to direct the LLM’s response to a consistent structure, since the output will saved as a structured dataset.

Defining the JSON schema
    
    
    # Define the JSON schema
    SCHEMA = {
        "type": "object",
        "properties": {
            "llm_sentiment": {
                "type": "string",
                "enum": ["positive", "negative", "neutral"]
            },
            "llm_explanation": {
                "type": "string"
            },
            "llm_confidence": {
                "type": "number"
            }
        },
        "required": ["llm_sentiment", "llm_explanation", "llm_confidence"],
        "additionalProperties": False
    }
    

## Getting structured output

Once you define the schema of your output, you’ll need to outline how you want the LLM to process the JSON input and what keys the output should contain. This is done using a system prompt:

Extracting a sample from reviews dataset
    
    
    # Outline the prompt
    PROMPT = """
    You are an assistant that classifies reviews in JSON format according to their sentiment. 
    Respond with a JSON object containing the following fields:
        - llm_explanation: a very short explanation for the sentiment
        - llm_sentiment: should only be either "positive" or "negative" or "neutral" without punctuation
        - llm_confidence: a float between 0-1 showing your confidence in the sentiment score
    """
    

Now, you can specify that the LLM output needs to matching the schema you defined using the [`with_json_output()`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionsQuery.with_json_output> "dataikuapi.dss.llm.DSSLLMCompletionsQuery.with_json_output") method. Here’s what a test of this setup could look like:
    
    
    completion = llm.new_completion()
    completion.with_json_output(schema=SCHEMA)
    completion.with_message(PROMPT, role="system")
    review_json = {
        "text": "This is an amazing product! It is exactly what I wanted.",
        "category": "Luxury_Beauty"
    }
    completion.with_message(json.dumps(review_json), role="user")
    
    response = completion.execute()
    result = response.json
    print(f"Sentiment: {result['llm_sentiment']}")
    print(f"Explanation: {result['llm_explanation']}")
    print(f"Confidence: {result['llm_confidence']}")
    
    # Sentiment: positive
    # Explanation: The review expresses strong satisfaction with the product.
    # Confidence: 0.95
    

## Processing Multiple Reviews

The `new_completions()` method sends multiple queries in a single request for batch processing multiple reviews from the extracted sample. This approach allows you to send multiple reviews in one batch to the LLM, which is more efficient than sending individual requests, as in the example above.

It is also helpful in parsing or creating large datasets since each review is processed consistently according to the schema you defined.

Extracting a sample from reviews dataset
    
    
    # Use a multi-completion query
    completions = llm.new_completions()
    completions.with_json_output(schema=SCHEMA)
    for row in ds_in.iter_rows():
        # Load review JSON
        review_data = json.loads(row["review"])
        comp = completions.new_completion()
        comp.with_message(PROMPT, role="system")
        comp.with_message(json.dumps(review_data), role="user")
    
    # Execute all completions in batch 
    responses = completions.execute()
    results = [r.json for r in responses.responses]
    

## Saving scores and other results

The results can be saved back to a Dataiku dataset. You’ll define the schema for the output dataset, ensuring that each review’s scores and analysis are stored in a structured format. The complete JSON output from the LLM is also saved.

Extracting a sample from reviews dataset
    
    
    # Write the results to the output dataset
    df_in = ds_in.get_dataframe()
    df_out = df_in.copy()
    
    df_out["llm_json_output"] = [json.dumps(r) for r in results]
    df_out["llm_sentiment"] = [r.get("llm_sentiment") for r in results]
    df_out["llm_explanation"] = [r.get("llm_explanation") for r in results]
    df_out["llm_confidence"] = [r.get("llm_confidence") for r in results]
    ds_out.write_with_schema(df_out)
    

## Wrapping up

Using Dataiku’s LLM Mesh with structured output provides several benefits, including built-in validation through JSON schema. You could extend this example by trying different schema definitions and including options like strict checking.

[extract](<../../../../_downloads/f8d3d2e905465a1ff51ec2233d5c1c14/extract.py>)

Full script
    
    
    import dataiku
    import requests
    import gzip
    import json
    import random
    
    
    # URL & filenames to download & create
    URL = 'http://jmcauley.ucsd.edu/data/amazon_v2/categoryFilesSmall/Luxury_Beauty_5.json.gz'
    FILE_NAME = 'Luxury_Beauty_5.json.gz'
    FILE_UNZIP = 'Luxury_Beauty_5.json'
    PROD_CATEGORY = "Luxury Beauty"
    SAMPLE_SIZE = 47
    DATASET_NAME = "amznreviews-sample"
    
    response = requests.get(URL)
    
    with open(FILE_NAME, 'wb') as f:
        f.write(response.content)
    
    # Unzip the archive
    with gzip.open(FILE_NAME, 'rb') as gz_file:
         with open(FILE_UNZIP, "wb") as f_out:
            f_out.write(gz_file.read())
    
    with open(FILE_UNZIP, "r", encoding="utf-8") as f:
        data = []
        for line in f:
            record = json.loads(line)
            review = {
                "product_category": PROD_CATEGORY,
                "text": record.get("reviewText", "")
            }
            data.append({
                "review": json.dumps(review),
                "sentiment_score": record.get("overall", ""),
                "sentiment": "negative" if record["overall"] in [1, 2] 
                            else "neutral" if record["overall"] == 3 
                            else "positive"
            })
    
    # Get a random sample of records
    sample_data = random.sample(data, SAMPLE_SIZE)
    
    # Get the dataset object
    dataset = dataiku.Dataset(DATASET_NAME)
    
    # Define the schema for the dataset
    schema = [{"name": "review", "type": "string"},
              {"name": "sentiment_score", "type": "int"},
              {"name": "sentiment", "type": "string"}]
    
    # Write the schema to the dataset
    dataset.write_schema(schema)
    
    # Write the rows to the dataset
    with dataset.get_writer() as writer:
        for row in sample_data:
            writer.write_row_dict(row)
    

[score](<../../../../_downloads/66fd8a38c5c477699addf6d83a4665fb/score.py>)

Full script
    
    
    import dataiku
    import json
    
    # Get Dataiku client and get project
    client = dataiku.api_client()
    project = client.get_default_project()
    
    # Get the LLM from the project
    LLM_ID = ""  # Set your LLM ID here
    llm = project.get_llm(LLM_ID)
    
    # Set up datasets
    ds_in = dataiku.Dataset("amznreviews-sample")
    ds_out = dataiku.Dataset("amznreviews-sample-llm-scored")
    
    # Define the JSON schema
    SCHEMA = {
        "type": "object",
        "properties": {
            "llm_sentiment": {
                "type": "string",
                "enum": ["positive", "negative", "neutral"]
            },
            "llm_explanation": {
                "type": "string"
            },
            "llm_confidence": {
                "type": "number"
            }
        },
        "required": ["llm_sentiment", "llm_explanation", "llm_confidence"],
        "additionalProperties": False
    }
    
    # Outline the prompt
    PROMPT = """
    You are an assistant that classifies reviews in JSON format according to their sentiment. 
    Respond with a JSON object containing the following fields:
        - llm_explanation: a very short explanation for the sentiment
        - llm_sentiment: should only be either "positive" or "negative" or "neutral" without punctuation
        - llm_confidence: a float between 0-1 showing your confidence in the sentiment score
    """
    
    # Use a multi-completion query
    completions = llm.new_completions()
    completions.with_json_output(schema=SCHEMA)
    for row in ds_in.iter_rows():
        # Load review JSON
        review_data = json.loads(row["review"])
        comp = completions.new_completion()
        comp.with_message(PROMPT, role="system")
        comp.with_message(json.dumps(review_data), role="user")
    
    # Execute all completions in batch 
    responses = completions.execute()
    results = [r.json for r in responses.responses]
    
    # Write the results to the output dataset
    df_in = ds_in.get_dataframe()
    df_out = df_in.copy()
    
    df_out["llm_json_output"] = [json.dumps(r) for r in results]
    df_out["llm_sentiment"] = [r.get("llm_sentiment") for r in results]
    df_out["llm_explanation"] = [r.get("llm_explanation") for r in results]
    df_out["llm_confidence"] = [r.get("llm_confidence") for r in results]
    ds_out.write_with_schema(df_out)