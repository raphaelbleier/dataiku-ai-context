# Dataiku Docs — schemas

## [schemas/basic]

# Basic usage

When you open a dataset in the “Explore” view, for each column, both the storage type (stored in the dataset metadata) and the meaning (inferred from data) are displayed.

In this example, we can see that the “location” column is stored as the basic “string” storage type, but DSS has inferred that the content is actually an URL, since most rows are _valid_ for the “URL meaning”.

By default, the explore views shows a _data quality bar_ , which shows which rows are valid for their _meaning_. When you are in data exploration, meanings are mostly useful for informational purpose.

If you choose to _Filter_ a column (click on Column header then on “Filter”), the filter shows a quality bar with checkboxes that allow you to focus on rows that are valid, invalid or empty for their meanings.

## Changing meaning and storage type

In dataset explore, you can change the storage type and the meaning by clicking on them.

[](<../_images/dataset-change-meaning.png>)

### Changing the storage type

Modifying the storage type for a column from the dataset explore screen has the exact same effect as doing it from the dataset settings.

You should generally be very careful when changing the storage type since it is used in external systems. See [Definitions](<definitions.html>) for more info about how the storage type is used.

### Changing the meaning

When you change the meaning, what you actually do is store in the dataset metadata that for this column, the meaning should not be auto-detected, but instead forced to the one you specified. When a column has a forced meaning, a small lock appears next to it.

Forcing the meaning is mostly useful when the automatic inference got it wrong.

You can go back to selecting “Auto-detect”, either in the meanings dropdown, or in the dataset schema screen.

### Editing advanced schema

You can also click on the column header > Edit column data (or go in the dataset settings screen) to set:

  * the details of the storage type (string max length, complex type elements, …)

  * a description for the column.




The column description is displayed wherever it may be relevant.

---

## [schemas/data-preparation]

# Schema for data preparation

Data preparation can be accessed in two parts in DSS:

  * In the Lab, through the _Visual analysis_. This is used to iterate between preparation, visualization and machine learning.

  * In a Prepare recipe in the Flow, used to create a new dataset




In Data Preparation, meanings are used to automatically suggest relevant transformations (either when clicking on a column header or on a cell).

In this example, the column has a meaning of “HTTP Query string” and has invalid values, so DSS suggests both removal of invalid values and query-string-specific operations.

## Schema in visual analysis

A visual analysis is a pure “Lab” object, which does not have persistence of output data. As such, columns in analysis don’t have a notion of storage types (since they are not stored).

In analysis, only meanings are shown.

When you create an analysis from a dataset, the forced meanings and column descriptions are carried over from the dataset.

## Schema in prepare recipe

When you create a data preparation recipe, DSS automatically sets the schema of the output dataset. At creation time, the forced meanings and column descriptions are carried over from the input to the output dataset.

The schema of the output dataset may or may not be inferred, depending on the data type mode selected in Administration > Settings > Other > Misc > Prepare recipe type inference. There are three modes:

  * Lock strongly typed inputs: Infer data types for loosely-typed input dataset formats (e.g. CSV) and lock for strongly-typed ones (e.g. SQL, Parquet). For a SQL dataset for example, any column of the output dataset present in the input dataset will retain consistent data types. This is the default behavior for DSS 12 onwards.

  * Always infer: Infer data types for all input dataset formats. This was the default behavior prior to DSS 12.

  * Lock all inputs: Not recommended. Preemptively lock the data types of the input columns and only infer for new columns.




With the first and second modes, the schema of the output dataset for a loosely-typed input (e.g. CSV) is inferred by computing the “best” storage type matching the data in the sample. If no “best” storage type is found, DSS defaults to a “string” column.

Type inference allows the prepare recipe to benefit from all of its functionality. For example, type inference ensures that numeric columns from a CSV will actually be treated as numbers rather than strings, so that 5+5 will return 10 rather than 55.

Since storage types use strict interpretation of what data is valid, you may need to parse or format the data before being able to use it with a precise storage type. For example, the string “1 245,21” has meaning “Decimal (comma)”, but is not valid for the “double” storage type, which only accepts “raw” decimals (i.e. “1245.21”). You need to use a “Numerical format converter” processor to convert to proper raw decimals.

In the UI of the Prepare recipe, both the meaning of the column and the storage type in the output dataset are displayed. When you change the storage type there, it changes what will be stored in the output dataset. Types that appear in white are “possible”, while those appearing in red will generate errors or warnings.

[](<../_images/prep-recipe-change-schema.png>)

By default, DSS discards invalid data when storing in the output dataset.

Note that the modification is only applied when you Save the recipe.

---

## [schemas/datasets]

# Creating schemas of datasets

## Schema of new external datasets

When an external (“source”) dataset is created, DSS automatically detects the column names and in some case types, and automatically initializes the schema of the dataset based on the data.

Some dataset backends (like SQL databases) have strict requirements for types, while other backends can accept invalid data more easily like most text-based formats (CSV, fixed-width, JSON, …).

### SQL and Cassandra datasets

For source datasets based on SQL or Cassandra, Data Science Studio retrieves the names and exact storage types from the SQL engine.

The schema of the dataset should generally not be edited, as the “source of truth” for the real schema is the database table.

If the schema of the underlying table changes, DSS will automatically update the schema of the dataset. However, it will only do so when you go to the edition page for this dataset. In that case, the “Save” button will be enabled. Note that this only happens if you never modified the schema of the dataset (see below).

### Text-based files datasets

For source datasets based on text-like files without a strict schema (CSV, fixed-width, JSON, …), Data Science Studio tries to detect column names from the content and metadata of the files. Column names can be freely edited by the user.

As these files don’t include a schema restricting what kind of data can be present, Data Science Studio takes a conservative approach to typing : all columns in the generated schema will be typed as “string”, which accepts any kind of data.

There are two main usage patterns from here:

  * If you are sure that your data is “valid” for what you want to do with it, you can directly set the storage type, either in the dataset settings screen, or in the explore screen. The storage type will be accessible to the recipes using the dataset.

  * If you need to clean, enrich or preprocess your data, you can leave all storage types to “string”, and use a Data Preparation recipe to generate a clean dataset. The Data Preparation recipe will automatically generate an output dataset with precise storage types depending on the transformations defined in it. More details are available in [Schema for data preparation](<data-preparation.html>).




If the schema of the underlying data changes, DSS will automatically update the schema of the dataset. However, it will only do so when you go to the edition page for this dataset. In that case, the “Save” button will be enabled. Note that this only happens if you never modified the schema of the dataset. If you did modify the schema, you can click on the “Redetect” button to force DSS to redetect format and schema (see below).

### “Typed” files datasets

For source datasets based on files that include a real notion of schema (Avro, Parquet, Sequence File, RC File, ORC File), the actual schema is automatically inferred when creating the dataset.

If the schema of the underlying data changes, DSS will automatically update the schema of the dataset. However, it will only do so when you go to the edition page for this dataset. In that case, the “Save” button will be enabled. Note that this only happens if you never modified the schema of the dataset. If you did modify the schema, you can click on the “Redetect” button to force DSS to redetect format and schema (see below).

## Schema of managed datasets

In an external dataset, the “source of truth” about the dataset is the data itself. This is why, on a SQL external dataset, the schema should not be edited, as Data Science Studio implicitly trusts the SQL table. In a managed dataset, on the other hand, the user controls the schema, and defines it from the start.

When you manually create a Managed Dataset, it starts empty with an empty schema. You can then manually fill the schema in the dataset edition UI.

In most situations, you would not manually fill the schema but use the capability of the generating recipe to do it. Managed datasets are created from the recipe creation and edition UI, to be used as output of the recipe being edited.

For more information, see [Handling of schemas by recipes](<recipes.html>).

## Modifying the schema

DSS never automatically modifies the schema of a dataset without an explicit user action. This is because changing the schema of a dataset can have strong consequences on all usages of the dataset.

If you hadn’t made any edit to the schema detected by Data Science Studio, it will automatically update the schema of the dataset if it notices that the underlying data files columns have changed. However, it will only do so when you go to the edition page for this dataset. In that case, the “Save” button will be enabled (in other words, while you stay on “Explore”, it will use the old schema, and detect the new schema when you go to “Settings”).

If you had manually edited the schema, Data Science Studio will notice the mismatch when you go to the edition page for this dataset and display a warning. You can then manually adapt the schema to the new data.

If at some point you modify the schema of a managed dataset while it already contains data, and the new schema does not match the existing data, Data Science Studio will notice the error and give you the option to reload the schema from the actual data, or to drop the existing data.

Each time you modify the schema, (from the dataset UI, the recipe UI or by validating a recipe), it is recommended to click on the button to check the consistency between data and schema.

---

## [schemas/dates]

# Handling and display of dates

In Dataiku DSS, “datetimes with zone” mean “an absolute point in time”, that is, something expressible as a date plus time plus timezone. For example, `2001-01-20T14:00:00.000Z` or `2001-01-20T16:00:00.000+0200`, which refer to the same point in time (14:00Z is 2pm UTC, and 16:00+0200 is 4pm UTC+2, so 2pm UTC too).

When the timezone indication is not present, the DSS type used is “datetime no zone”, and corresponds to a date plus a time. When the time indication is also not present, the DSS type is “date only”, and represents a calendar day, like `2001-01-20`.

## Displaying dates

DSS only displays datetime with zone values in UTC. This is especially true in charts. If you use the format date processor with a proper ISO8601 format, it will temporarily show it as a different time zone, but as soon as you write it out or read it in a chart, it will be in UTC again.

If you use a formatter to format as `16:00+0200` and selects the output to be a string, then the string value will be preserved but it’s not a date anymore.

See [Managing dates](<../preparation/dates.html>) for more information.

## Handling of dates in SQL

DSS offers settings on the SQL datasets to control how date types and datetime no zone types are read. Datetimes with zone don’t need additional settings since they correspond to values that are unambiguously defined.

A DATE column in a SQL database can be read by DSS:

  * “As is” : as a date only column

  * “As string” : the value is converted to a string representation and DSS handles it as a string. Note that the conversion is done by the database and the output format is often subject to database-specific settings

  * “As datetime with zone” : the value is converted to a datetime with zone by DSS, by considering that the value stored in the SQL database is 00h 00m of the date, in the timezone selected as `Assumed timezone` on the dataset.




For databases offering such a type, columns in a SQL database whose values are datetimes without zone indication can be read by DSS:

  * “As is” : as a datetime no zone column

  * “As string” : the value is converted to a string representation and DSS handles it as a string

  * “As datetime with zone” : the value is converted to a datetime with zone by DSS, by considering that the value stored in the SQL database is in the timezone selected as `Assumed timezone` on the dataset.




When selecting “Local” as “assumed time zone” in the settings of a SQL dataset, DSS will use the timezone of the server it is running on. For example when reading a value “2020-02-14” in the database with a DSS running in Amsterdam, DSS will consider that it is reading “2020-02-14 at midnight in Amsterdam”, then displays it in UTC, so “2020-02-13T23:00:00Z”. If you want it to show “2020-02-14T00:00:00Z”, you must set the assumed time zone to UTC.

---

## [schemas/definitions]

# Definitions

Datasets in Data Science Studio have a schema. The schema of a dataset is the list of columns, with their names and types.

There are two kinds of “types” in DSS.

  * The _storage type_ , used to indicate how the dataset backend should store the column data.

  * The _meaning_ , a “rich” semantic type. Meanings are automatically detected from the contents of the columns.




Storage types and meaning are related but with large amounts of flexibility that allow Data Science Studio to handle invalid data while retaining advanced meanings.

## Storage types

Storage types are “technical” types:

  * string

  * int (32 bits), bigint (64 bits), smallint (16 bits), tinyint (8 bits)

  * float (32 bits decimal), double (64 bits decimal)

  * boolean

  * datetime with zone, datetime no zone, date only

  * geopoint (for storing coordinates)

  * geometry (for storing lines, polygons, …)

  * array

  * map

  * object




A storage type is “strict”, ie. it is generally not possible to store data which would be “invalid” for a given storage type. For example, if a SQL table has an “int” columns, it is not possible at all to store a decimal in it.

### Why use precise storage types ?

Storage types are used in many places in DSS, notably recipes, including for generating queries and jobs in other systems (like SQL, Hadoop, Spark).

For example, if you use a text-based dataset directly in a Spark recipe, the storage type information will be taken into account for the typing of the input dataframes. If you use a text-based dataset directly in Hive, the storage type information will be taken into account for the typing of the input Hive table).

A mistyped column will generally result in failures.

## Meanings

Meanings have a “high-level” definition, like:

  * URL

  * IP Address

  * Email address

  * Country code

  * Currency code

  * …




Each meaning in DSS is able to _validate_ a cell value. Thus, each cell can be “valid” or “invalid” for a given meaning.

---

## [schemas/index]

# Schemas, storage types and meanings

---

## [schemas/meanings-list]

# List of recognized meanings

Here is the list of meanings that DSS recognizes.

## Basic meanings

### Text

Anything is valid for the “Text” meaning.

### Decimal

Recognizes “raw” decimals (like: 1234.32). Accepts negative and scientific notation

### Integer

Recognizes “raw” integers (like: 1234). If the number is higher than 2147483647 or lower than -2147483648, use bigint type.

### Boolean

This meaning recognizes a large number of possible values (true, false, yes, no, 1, 0, …)

### Datetime with zone / Dates (needs parsing)

The Datetime with zone meaning only recognizes datetimes in the ISO-8601 format, ie dates like `2014-12-31T23:05:43.123Z`

Note that the timezone information is mandatory for a valid _Datetime with eone_

For all other kinds of dates the “Date (needs parsing)” meaning will be recognized. For more information, see:

  * [Handling and display of dates](<dates.html>)

  * [Managing dates](<../preparation/dates.html>)




### Datetime no zone

The Datetime no zone meaning only recognizes datetimes in the `yyyy-MM-dd HH:mm:ss` format, ie dates like `2014-12-31 23:05:43`. Fractional seconds are optional.

### Date only

The Date only meaning only recognizes “pure” dates, that is values denoting a calendar day in the `yyyy-MM-dd` format, like `2014-12-31`.

### Object / Array

Recognizes objects and arrays in JSON notation

### Natural language

Recognizes “long text made of words”

## Geospatial meanings

### Latitude / Longitude

This meaning recognizes a large number of formats for expressing geometric coordinates.

### Geopoint

This meaning recognizes a large number of formats for expressing a point in geometric coordinates (notably WKT)

### Geometry

This meaning recognizes WKT format for geographic lines, polygons and multipolygons.

### Country

The Country meaning recognizes country names (in English) and ISO Country codes

### US State

This meaning recognizes both short codes and full names for USA states.

## Web-specific meanings

  * IP Address (IPv4 and IPv6)

  * URL

  * HTTP Query String

  * User Agent

  * E-Mail address




## Other meanings

DSS recognizes a few other specific meanings

---

## [schemas/recipes]

# Handling of schemas by recipes

Most recipes in DSS are able to generate automatically the output schema of their datasets, either:

  * When you click on the Save button

  * When you click on the Validate button




Note

DSS never automatically changes the schema of a dataset while running a job. Changing the schema of a dataset is a dangerous operation, which can lead to previous data becoming unreadable, especially for partitioned datasets.

Note

When possible, the schema verification is also performed when you “Run” the recipe from the recipe editor screen. It is however never performed when you build a dataset from :

>   * The dataset actions menu
> 
>   * The Flow
> 
>   * A scheduled job
> 
>   * The API
> 
> 


If you want to perform schema verifications from outside of the recipe editor screen, you need to use the [Propagate Schema Flow tool](<../flow/building-datasets.html>).

## Sample, Filter, Group, Window, Join, Split, Stack

For these recipes, the output schema is automatically computed each time you Save the recipe. If the computed schema does not match the current output dataset schema, a warning popup appears.

You can either accept the change, which outputs the schema in the output dataset, or ignore it.

Note

Ignoring output schema changes will often lead to recipe failures. For example, a Grouping recipe running in-database performs an INSERT in the target table. This INSERT fails if the schema of the output dataset is not correct.

## Sync

The Sync recipe has two modes of operation when it comes to schema handling:

  * Strict schema equality (default). In this mode, the Sync recipe behaves like the previous ones (schema updated when saving or running from the recipe editor).

  * Free output schema (name-based matching). In this mode, the Sync recipe never updates the output schema. You can use this Sync recipe mode if you want to only keep a few columns from the input dataset.




Note

Matching is case sensitive in “Free output schema (name-based matching)” mode.

For example, a column named `c1` in the input dataset will not match to a column named `C1` in the output dataset.

## Prepare

The Prepare recipe has a specific behavior. See [Schema for data preparation](<data-preparation.html>).

## Hive, Impala, SQL

For these recipes, computing the output schema requires calls to external systems. For example, for SQL, DSS sends the query to the database, and checks the schema of the resulting set.

Since these calls are expensive, they are not performed when you click on Save. Instead, a dedicated “Validate” button must be used.

## Python, R, PySpark, SparkR

For these 4 recipes, there is no way for DSS to automatically compute the schema of the output dataset. However, the Dataiku APIs that you use to interact with datasets provide ways to set the schema _when the recipe is executed_

These recipes thus update their schema at runtime (but only when you explicitly ask for it by using the appropriate API). This is particularly useful since you can easily set the schema of a dataset from the dataframe object of these languages.

However, you need to be quite careful when updating schemas from code, especially with partitioned datasets, since schema changes may render data of other partitions unreadable.

## Machine Learning (scoring)

These recipes behave like Prepare.

## SparkSQL

The SparkSQL recipe is unique: it unconditionally updates the schema at runtime. This breaks the rule stated at the beginning of this paragraph. Note that this situation might change in a future release.

## Shell

The Shell recipe normally doesn’t touch the output dataset schema. However, if you use the “Pipe out” option with “Auto-infer output schema”, the schema is unconditionally updated at runtime.

---

## [schemas/user-defined-meanings]

# User-defined meanings

In addition to the standard meanings, you can define custom meanings in DSS. Examples could include:

  * “Customer ID as expressed in the CRM system”

  * “Internal department code”

  * “Answer to a poll question” (1: strongly agree to 5: strongly disagree, -1: no answer)




Like regular meanings, user-defined meanings can be assigned to several columns. They complement the description on a given column. For example, in a dataset, you could have two columns with “Internal department code” meaning: the initial_department and the current_department columns. Each column could also have a description that indicates when each is filled.

Custom meanings can serve two purposes:

  * For documentation. When you set the meaning of a column, DSS shows the details (label and description) everywhere where it’s relevant. This way, when you edit a recipe, you have a quick reference available of the meaning of this column.

  * For validation. User-defined meanings can optionally define a list of valid values or a pattern. The data exploration screen then displays the usual valid/invalid displays, and you can use the “Remove invalid” processor in data preparation




User defined meanings can be generated from “Meanings” section in the administration dropdown.

## Kinds of user-defined meanings

There are 4 kinds for user-defined meanings

### Declarative

No validation is performed for this meaning, and it cannot be automatically detected. This meaning is used for documentation purposes only.

### Values list

In this mode, you specify the list of possible values for this meaning. When this meaning is forced, DSS will validate that the value is one of the possible values.

You can specify a normalization mode to indicate whether the match to the possible values should be done exactly, ignoring case, or ignoring accents.

### Values mapping

In this mode, you specify a mapping of possible values for this meaning. For each possible value, a “value in storage” (key) and a “label” are given. When this meaning is forced, DSS will validate that the value is one of the possible values (either in storage or as label).

The main goal of this kind is to handle columns that contain info like “0”, “1”, “-9” meaning “no”, “yes” and “no answer”. The mapping allows you to map these “internal” values to “human-readable” ones.

This kind of user-defined meanings goes with a specific Data preparation processor which handles these replacements.

You can specify a normalization mode to indicate whether the match to the possible keys should be done exactly, ignoring case, or ignoring accents.

### Pattern

In this mode, you specify a pattern (as a Java-compatible regular expression) that the values must match. The pattern can be evaluated case-sensitive or case-insensitive.

## Autodetecting user-defined meanings

User-defined meanings are normally not automatically detected. If you force them, they will be validated, but DSS will never suggest them.

It is possible to auto-detect meanings that are of kind:

  * Values list

  * Values mapping

  * Pattern




Warning

It is not recommended to enable auto-detection. Enabling auto-detection on a user-defined meaning can cause built-in meanings not to be recognized anymore, and can cause notable slowdowns in DSS usage.