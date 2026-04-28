# Dataiku Docs — data-preparation

## [preparation/copy-steps]

# How to Copy Prepare Recipe Steps

Existing steps in a data preparation Script can be reused in another Script so that you don’t have to manually replicate the steps.

Note

You can copy steps to/from the script of a Prepare Recipe or Visual Analysis.

## Copying Steps

From within the data preparation Script that contains the steps you want to copy:

  * Select the steps you want to copy

  * Choose **Actions > Copy steps**.

  * Navigate to the Script where you want to paste the steps

  * Select the step that marks where the copied steps should be pasted

  * Choose **Actions > Paste after selection**, or use your keyboard’s “Paste” shortcut to paste the steps.

---

## [preparation/dates]

# Managing dates

## Working with dates in Preparation

Data Preparation provides several components for easy management, transformation and normalization of dates.

### Meanings and types

The **Datetime with zone** meaning is the main meaning in Dataiku DSS used for representing dates in a non-ambiguous format. Two standard date formats, both including timezone information, are recognized as valid:

  * ISO-8601 with timezone indicator: for example `2013-05-30T15:16:13.764Z` or `2013-05-30T15:16:13.764+0200`

  * RFC 822: for example `Tue, 22 Jan 2013 12:14:33 GMT`




Both these formats include timezone information and are therefore non-ambiguous. Internally, the Datetime with zone type handles all dates in UTC.

In addition to **Datetime with zone** , DSS offers 2 temporal data types:

  * **Date only** represents a date without any time information. It accepts ISO-8601 dates like `2013-05-30`

  * **Datetime no zone** represents a wall-clock time on a given day, without any time zone indication. It accepts values like `2013-05-30 15:16:13.764`




Dates stored in all other date formats need to be **parsed** into one of the temporal data types in order to leverage the date manipulation and transformation components described below.

Any columns that are recognized as likely to contain dates but which have yet to be converted into either valid format will be automatically given the meaning ‘Date (unparsed)’. Only columns recognized as having valid date formats can be stored using the ‘datetime with zone’, ‘date only’ or ‘datetime no zone’ storage types. Dataiku DSS performs all computations on ‘datetime with zone’ columns in UTC timezone for the server’s locale, unless otherwise specified.

## Parsing Dates

Parsing a date column will convert a column that contains a date written in non-ISO-8601 or non-RFC-822 format into a standard, non-ambiguous format. Once parsed, Dataiku DSS will consistently recognize and use a date column as such. The output can be chosen to be any of the 3 data types handled by DSS: **datetime with tz** , **date only** or **datetime no tz**.

The `asDatetimeTz` function in Dataiku DSS can be used to parse dates into an acceptable format as can the features described below. Its counterparts for the other temporal data types are `asDateOnly` and `asDatetimeNoTz`.

### Smart Date Parser

The ‘Smart Date’ parser detects probable formats in which an unparsed date column is written and assists in generating the correct format for use in the date parsing processor. There are two ways to parse a column into a date; both will open the Smart Date parser:

  * Select ‘Parse date…’ from the dropdown menu that appears upon hovering the column name of a column recognized as “Date (unparsed).”

  * Open the Processor Library (“+ADD A NEW STEP”), select the “Parse to standard date format” processor under the “Dates” category, input the column name then click “Find with Smart Dates.”




The Smart Date parser displays a list of probable date formats. Select the one that best fits the format of your data and it will then populate the ‘inputs date format(s)’ section of the parse date processor.

On occasion, the Smart Date parser cannot automatically recognize the format of a date column. In this case, you can input a custom format at the bottom of the list of detected formats. As you type your custom format using the Java DateFormat syntax, (<https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html>), Dataiku DSS checks the syntax in real-time, indicates the extent to which the custom format fully parses the source data or not, and displays the result of the parsing in real-time.

### Parse date processor

The parse date processor will convert columns in your dataset to a valid date format for use in DSS. The Smart Date parser can assist in identifying the correct date format(s) for dates as they are stored in your dataset.

### Internationalized parsing

Some dates include international formats like month names or day names.

By default, the Date Parser automatically parses these elements in both French and English. You can also force a specific locale for these internationalized elements.

### Timezones

Any date recognized as valid by Dataiku DSS includes complete timezone information so that dates remain unambiguous. Some date formats natively include timezone information like +0200, CST, UTC, etc. These are denoted by the Z character in the date parsing pattern. `2013/04/17 13:23:32 +0400` will be parsed to `2020-04-17T09:23:32.000Z` using `‘yyyy/MM/dd HH:mm:ss Z’` as a conversion pattern.

However, most formats do not include timezone information. For these formats, the date parsing processor needs to know in which timezone this value was recorded. There are three ways to determine the timezone for a given row:

  * Using a static value (like “UTC” or “Europe/Paris”) : you indicate that all your rows are at a given timezone, and Date parser will use this. This is useful for example, for timestamps in server log files, where all servers are at the same time zone.

  * Using a timezone column. If your row contains a column with timezone information, Date parser can use it directly. This allows you to have a different timezone per row. You need to configure which column contains the timezone information.

> Note
> 
> If for a given record, the timezone information is invalid, the Date parser does not output a date for this row

  * Using an IP address column. If your row contains an IP address, and you know that the timezone of the row is the timezone of the IP address (for example, a client-generated timestamp in a web browsing log). The Date parser will automatically geolocate this IP address and use the timezone of the detected location. You need to configure which column contains the IP address.

> Note
> 
> If the Date Parser cannot geolocate the IP, it does not output a date for this row




### Converting from a UNIX timestamp

Columns that contain a UNIX timestamp are handled separately. You do not parse them using the Smart Date / Date parse processor combination. Use the dedicated “Convert UNIX timestamp to a date’ processor instead. UNIX timestamps are always expressed in UTC.

UNIX timestamps can come into two variants: in seconds since Epoch (i.e. January 1st 1970) or in milliseconds since Epoch.

You need to indicate which format your column is in.

## Using dates

Once you have a column in proper non ambiguous format, with the “Datetime with zone”, “Date only” or “Datetime no zone” type, you can perform various operations on this column:

  * Extract some components of the date (year, month, day, week, day of week, ..) into separate columns

  * Reformat the date into another format

  * Manipulate your date field(s) by incrementing, truncating, or finding the difference between two date columns

  * Flag / filter rows based on a variety of time divisions




### Extracting date components

This processor allows you to easily extract components from the date into separate columns. For example, you could create a column with the day of the week for each row. The day of the week is generally a very good feature for machine learning.

The components that can be extracted from a “Datetime with zone” or a “Datetime no zone” column are:

  * Year

  * Month (01 = January, 12 = December)

  * Day

  * Week of year

  * Week year

  * Day of week (1 = Monday, 7 = Sunday)

  * Hour

  * Minutes

  * Seconds

  * Milliseconds




For a “Date only” column, hours, minutes, seconds and milliseconds are not possible.

Additional date components are available using the `datePart` function in a Formula processor (see [Formula language](<../formula/index.html>))

#### Timezones handling

All computations on parsed date columns are performed in UTC. However, it is often useful to extract information from a column in a different timezone.

For example, imagine that you are processing web log files containing page events coming from all around the world. The Datetime with zone column that indicates the timestamp of the event is always aligned on the UTC timezone. What we want to know is at what time of the day the most events happen. However, we want this information in the local timezone of the client that generated this event. For example, we might want to know the proportion of events that happen in the morning for the client rather than for the server.

To help you with that, while extracting components, Dataiku DSS can “realign” them on a different timezone.

Like for the Date Parser, this timezone can be specified using 3 different ways:

  * Using a static value (like “UTC” or “Europe/Paris”). All components for all rows will be output on this timezone.

  * Using a timezone column. If your row contains a column with timezone information, the extractor can use it directly. This allows you to have a different timezone per row. You need to configure which column contains the timezone information.

  * Using an IP address column. If your row contains an IP address, and you know that the timezone of the row is the timezone of the IP address (for example, a client-generated timestamp in a web browsing log). The extractor will automatically geolocate this IP address and use the timezone of the detected location. You need to configure which column contains the IP address.i




Example:

  * We have a web log file with a Date, in UTC, which is the date of the hit on the server, and with the IP of the client

> [](<../_images/date-extractor-realign-source.png>)

  * If we extract the day and the hour using UTC timezone, we get them for the server UTC timezone. This does not tell us at what time of their days customers come on the website

  * If we use the IP column as timezone source, Data Science Studio geolocates each IP, and uses the timezone of the IP to automatically translate the date components in the local timezone.

>     * Some hits at 11pm UTC in France are actually at 1am local time (GMT + 2 due to DST)
> 
>     * Some hits at 12am UTC in the US are actually at 8pm local time (GMT - 4 due to DST)




### Reformating dates

The ‘Format date’ processor allows you to recreate a date column as a “human-readable” string. Like the date components extractor described above, the date formatter allows you to realign dates on a local timezone. The date formatter can either be opened by creating a new ‘format date’ processor or by selecting the appropriate action in the column dropdown.

The format of the Date Formatter must be specified using the [Java DateFormat specification](<https://docs.oracle.com/javase/8/docs/api/java/text/SimpleDateFormat.html>).

The formatter can be outputted dates in English or French.

### Performing date calculations

Several processors facilitate performing calculations on date columns. It is possible to use a processor to increment a date column by a specified unit of time, to truncate a date column by a specified unit of time, and to calculate the difference between two date columns in terms of the specified time. The `inc`, `trunc`, and `diff` functions of the Dataiku DSS formula language will perform the same calculations as well.

### Filtering or flagging rows using dates

Several capabilities exist to help you create a variety of different types of date filters which you can apply to the preview of your data or as a script step–static ranges, relative ranges, and filters on date components–without writing a complex formula. Open the filter pop-up from the dropdown menu of any parsed date column, set your range, and click on ‘Apply as step’ to add that filter as a script step:

  * A static date range: supports a closed range (2020-10-01 to 2020-10-05) or an open one (after 2020-10-01). Time zones are supported.

  * A relative date range: define a moving date filter with which to filter your data. Each period is a calendar period and calculated at each run relative to the time on the server.

  * A range based on date part: filter by year, quarter, month, etc…




For more information, refer to the documentation about [filtering and flagging processors](<filter-flag.html>)

---

## [preparation/engines]

# Execution engines

## Design of the preparation

The design of a data preparation is always done on an in-memory sample of the data. See [Sampling](<sampling.html>) for more information.

## Execution in analysis

When in an analysis, execution on the whole dataset happens when:

  * Exporting the prepared data.

  * Running a machine learning model.




In both cases, this uses a streaming engine: all data goes through the DSS server but does not need to be in memory.

## Execution of the recipe

For execution of the recipe, DSS provides three execution engines:

### DSS

All data goes through the DSS server but does not need to be in memory (as it is streamed).

### Spark

When Spark is installed (see: [DSS and Spark](<../spark/index.html>)), preparation recipe jobs can run on Spark.

We recommend that you only use this on the following dataset types that support fast read and write on Spark:

  * S3

  * Azure Blob Storage

  * Google Cloud Storage

  * Snowflake

  * HDFS




### In-database (SQL)

A subset of the preparation processors can be translated to SQL queries. When all processors in a preparation recipe can be translated, and both input and output are tables in the same SQL connection, the recipe runs fully in-database.

Please see the warnings and limitations below.

## Details on the in-database (SQL) engine

Only a subset of processors can be translated to SQL queries. They are documented in the processors reference. The SQL engine can only be selected if all processors are compatible with it.

If you add a non-supported processor while the in-database engine is selected, DSS will show which processor cannot be used with details.

Note

There are some edge cases of columns that change type where DSS may show the engine as supported, but upon running the recipe, you encounter a syntax error. If that happens, you will need to disable the SQL engine and fall back to the DSS engine.

Some of these edge cases relate to type conflicts, if for example you have a textual column and perform a find/replace operation that transforms it into a numerical column and immediately use it for numerical operations.

When using Snowflake with Java UDF, additional processors are supported thanks to unique extended push-down capabilities. Please see [Snowflake](<../connecting/snowflake.html>) for more details. Additional setup is required to benefit from extended push-down.

### Supported processors

These processors are available with SQL processing.

  * Keep/Delete columns

  * Reorder columns

  * Rename columns

  * Split columns

  * Filter by alphanumerical value

  * Filter by numerical range

  * Flag by alphanumerical value

  * Flag by numerical range

  * Remove rows with empty value

  * Fill empty cells with value

  * Concatenate columns

  * Copy columns

  * Unfold

  * Split and unfold

  * Create if, then, else statements




These processors are only available with Snowflake with Java UDF processing.

  * [Discretize (bin) numerical values](<processors/binner.html>)

  * [Convert currencies](<processors/currency-converter.html>)

  * [Split currencies in column](<processors/currency-splitter.html>)

  * [Split e-mail addresses](<processors/email-split.html>)

  * [Extract numbers](<processors/extract-numbers.html>)

  * [Resolve GeoIP](<processors/geoip.html>)

  * [Flag holidays](<processors/holidays-computer.html>)

  * [Normalize measure](<processors/measure-normalize.html>)

  * [Split HTTP Query String](<processors/querystring-split.html>)

  * [Simplify text](<processors/simplify-text.html>)

  * [Convert a UNIX timestamp to a date](<processors/unixtimestamp-parser.html>)

  * [Split URL (into protocol, host, port, …)](<processors/url-split.html>)

  * [Classify User-Agent](<processors/user-agent.html>)

  * [Generate a best-effort visitor id](<processors/visitor-id.html>)




### Partially supported processors

In some variants of configuration of the processor, it will revert to a normal processing. Various issues may also appear and require you to switch back to DSS engine.

  * Formula (essentially same support as in other visual recipes)

  * Filter by formula (see above)

  * Flag by formula (see above)

  * Find / Replace (especially around regular expressions)

  * [Transform string](<processors/string-transform.html>) (depends on the transformation) -All are available with Snowflake

  * [Extract with regular expression](<processors/pattern-extract.html>) \- More options are available with Snowflake

  * Date-handling processors (parse date, extract date components)

  * Geo processors (extract from geo column, change coordinate reference system (CRS), compute distances between geospatial objects)

  * [Filter invalid rows/cells](<processors/filter-on-meaning.html>) and [Flag invalid rows](<processors/flag-on-meaning.html>) (not supported for custom meanings) (Snowflake with Java UDF only)




## Details on the Spark engine

All processors are compatible with the Spark engine.

---

## [preparation/filter-flag]

# Filtering and flagging rows

DSS provides 5 processors for filtering data. These processors can:

  * Remove rows based on various conditions

  * Clear the content of cells based on the same conditions

  * Create “flag” columns indicating whether each row matches a condition




## Common filtering actions

The configuration for most of these processors can be divided into two sections:

  * Defining match conditions that will be evaluated on a row

  * Defining the action to perform on the rows matching the condition:
    
    * Remove matching rows

    * Keep matching rows only

    * Clear the content of a cell, only for matching rows

    * Clear the content of a cell, only for non-matching rows

    * Create an indicator (0 / 1) column indicating whether the row matches the condition




## Columns selection

Some of these processors can check their condition on multiple columns:

  * A single column

  * An explicit list of columns

  * All columns matching a given pattern

  * All columns




For processors that support column selection, you can select whether the column will be considered as matching if:

  * All columns are matching

  * Or, at least one column is matching




## Filter on value

The [Filter rows/cells on value](<processors/filter-on-value.html>) and [Flag rows on value](<processors/flag-on-value.html>) match rows based on whether certain columns contain specified values.

### Values

You can select multiple values. The filter matches if at least one of the values matches.

### Matching mode

By setting the match mode, you can specify how you want this processor to search:

  * ‘Complete value’ : match where the searched value is the complete cell value

  * ‘Substring’ : match when the cell contains the searched value

  * ‘Regular expression’: match when the cell matches the searched pattern (note: the regular expression is not anchored)




### Normalization mode

By setting the normalization mode, you can specify how you want this processor to search

  * Using a case-sensitive search (‘Exact’ mode)

  * Using a case-insensitive search (‘Lowercase’ mode)

  * Using an accents-insensitive search (‘Normalize’ mode)




‘Normalize’ mode performs an unicode normalization.

## Filter on numerical range

The [Filter rows/cells on numerical range](<processors/filter-on-range.html>) and [Flag rows on numerical range](<processors/flag-on-range.html>) match rows for which the value is within a numerical range.

  * The boundaries of the numerical range are inclusive.

  * Both lower and upper boundaries are optional.

  * If the column does not contain a valid numerical value for a row, this row is considered as being out of the range (and thus non-matching).




## Filter on date range

The [Filter rows/cells on date](<processors/filter-on-date.html>) and [Flag rows/cells on date range](<processors/flag-on-date.html>) match rows for which the date is within different types of ranges: a static range, a relative (moving) range, a range of date parts.

**Date Range** * The boundaries are inclusive. * Both lower and upper boundaries are optional * If the column does not contain a valid date for a row, this row is considered as being out of the range. * The provided time zone will be used to filter dates.

**Relative Range** * The boundaries are inclusive * The boundaries are dynamic and update relative to the time specified on the DSS server * Date periods are calendar periods : ‘last 3 months’ will be a range that only includes the last 3 complete calendar months

**Date Part** * Filter using date components like year, quarter, or weekday

Note: this processor works on columns with “Date” meaning, i.e. parsed dates. For more information, please see [Managing dates](<dates.html>)

## Filter on formula

The [Filter rows/cells with formula](<processors/filter-on-formula.html>) and [Flag rows with formula](<processors/flag-on-formula.html>) match rows based on the result of a [Formula language](<../formula/index.html>).

The row matches if the result if the formula is considered as “truish”, which includes:

  * A true boolean

  * A number (integer or decimal) which is not 0

  * The string “true”




## Filter on bad meaning

The [Filter invalid rows/cells](<processors/filter-on-meaning.html>) and [Flag invalid rows](<processors/flag-on-meaning.html>) match rows based on whether they are considered as valid for the selected meaning. For more information about meanings, please see [Schemas, storage types and meanings](<../schemas/index.html>)

---

## [preparation/geographic]

# Geographic processors

The prepare recipe provides a variety of processors to work with geographic information.

For an overview of all geographic capabilities in DSS, please see [Geographic data](<../geographic/index.html>)

DSS also provides a set of formulas to compute geographic operations (see [Formula language](<../formula/index.html>))

## Geopoint converters

DSS provides two processors to convert between a Geopoint column and latitude/longitude columns:

  * [Create GeoPoint from lat/lon](<processors/geopoint-create.html>)

  * [Extract lat/lon from GeoPoint](<processors/geopoint-extract.html>)




## Resolve GeoIP

The [Resolve GeoIP](<processors/geoip.html>) processor uses the GeoLite City database (<https://www.maxmind.com>) to resolve an IP address to the associated geographic coordinates.

It produces two kinds of information:

  * Administrative data (country, region, city, …)

  * Geographic data (latitude, longitude)




The output GeoPoint can be used for [Map Charts](<../visualization/charts-maps.html>).

## Reverse geocoding

Please see [Geocoding and reverse geocoding](<../geographic/geocoding.html>)

## Zipcode geocoding

Please see [Geocoding and reverse geocoding](<../geographic/geocoding.html>)

## Change coordinates system

This processor changes the Coordinates Reference System (CRS) of a geometry or geopoint column.

Source and target CRS can be given either as a EPSG code (e.g., “EPSG:4326”) or as a projected coordinate system WKT (e.g., “PROJCS[…]”).

Use this processor to convert data projected in a different CRS to the WGS84 (EPSG:4326) coordinates system.

## Compute distances between geospatial objects

The [Compute distance between geospatial objects](<processors/geo-distance.html>) processor allows you to compute distance between geospatial objects

## Create area around a geopoint

The [Create area around a geopoint](<processors/geopoint-buffer.html>) processor performs creation of polygons centered on input geopoints. For each input geospatial point, a spatial polygon is created around it, delimiting the area of influence covered by the point (all the points that fall within a given distance from the geopoint). The shape area of the polygon can be either rectangular or circular (using an approximation) and the size will depend on the selected parameters.

## Extract from geo column

The [Extract from geo column](<processors/geo-info-extractor.html>) processor extracts data from a geometry column:

  * centroid point,

  * length (if input is not a point),

  * area (if input is a polygon).

---

## [preparation/index]

# Data preparation

Visual data preparation in DSS lets you create data cleansing, normalization and enrichment scripts in a visual and interactive way.

You can create these scripts directly in a Prepare recipe, or in a Visual Analysis that can be deployed to the Flow as a Prepare recipe.

Note

For a step by step introduction to the data preparation component of Data Science Studio, we recommend that you follow the:

  * [Quick Start | Dataiku for data preparation](<https://knowledge.dataiku.com/latest/getting-started/tasks/data-prep/quick-start-index.html>)

  * [Visual recipes](<https://academy.dataiku.com/visual-recipes>) course on the Dataiku Academy.

---

## [preparation/processors/array-extract]

# Extract from array

Extract an element or a sub-array from an array written in JSON.

## Options

**Input column**

Column to extract element or array.

**Mode**

Choose from:
    

  * **Extract an element:** Provide the element’s index number. Use negative index to count from the end of the array: (-1 is the last value, -2 is second to last, etc).

  * **Extract a sub-array:** Provide the starting and ending index numbers.




**Output column**

Create a separate output column or leave blank to perform extraction in-column.

---

## [preparation/processors/array-fold]

# Fold an array

Transform a cell containing a JSON array and fold it into several rows, performing the transformation in-place. Each generated row contains a single value from the input array. All other columns are copied in each generated row.

---

## [preparation/processors/array-sort]

# Sort array

This processor sorts an array (written in JSON).

---

## [preparation/processors/arrays-concat]

# Concatenate JSON arrays

This processor concatenates N input columns containing arrays (as JSON) into a single JSON array.

## Example

  * Input:



    
    
    a       b
    [1,2]   ["x","y"]
    

  * Output:



    
    
    [1, 2, "x", "y"]

---

## [preparation/processors/binner]

# Discretize (bin) numerical values

Group numbers into bins (intervals).

## Options

**Input columns**

Number column to transform into bin.

**Binning mode**

Choose from two binning modes:

  * **Fixed size intervals:** Define **bin width** to create bins of equal width. For example, `2` generates `...,-2:0, 0:2, 2:4, ....`

>     * In each bin, the lower bound is included and the upper bound is excluded.
> 
>     * **Minimum value:** Set a minimum value _N_ below which the corresponding bin will be _< N_. This also creates an offset for the bins: with `width=2` and `minimum=0.5`, the generated bins will be `0.5:2.5, 2.5:4.5, 4.5:6.5, ...`
> 
>     * **Maximum value:** Set a maximum value _N_ above which the corresponding bin will be _> = N._

  * **Custom, use raw values:** specify non-overlapping intervals to create bins.

>     * In each bin, the lower bound is included and the upper bound is excluded.
> 
>     * If a bound isn’t specified, +/- infinity will be used.
> 
>     * The output bin for a value that is out of the ranges will be an empty cell.




**Output column**

Perform the binning in an additional output column or leave it empty to perform the binning in place.

---

## [preparation/processors/change-crs]

# Change coordinates system

This processor changes the Coordinates Reference System (CRS) of a geometry or geopoint column.

Source and target CRS can be given either as a EPSG code (e.g., “EPSG:4326”) or as a projected coordinate system WKT (e.g., “PROJCS[…]”).

Warning

Dataiku uses the WGS84 (EPSG:4326) coordinates system when processing geometries. Before manipulating any geospatial data in Dataiku, make sure they are projected in the WGS84 (EPSG:4326) coordinates system.

Use this processor to convert data projected in a different CRS to the WGS84 (EPSG:4326) coordinates system.

---

## [preparation/processors/coalesce]

# Coalesce

Return the first non-null (and non-empty) value across several input columns.

The _Coalesce_ processor evaluates a list of columns and, for each row, outputs the first value that is neither null nor an empty string. If all selected input columns are null or empty, the processor can return a user-provided default value or NULL.

This processor behaves similarly to the SQL `COALESCE` function (specifically ignoring empty strings), but operates directly on recipe rows within DSS.

Note

Columns are evaluated in the order listed in the configuration.

## Options

**Columns to apply to**

Select one or more columns that the processor will evaluate. You may choose:

  * A single column

  * Multiple explicit columns

  * A pattern-based rule (regular expression)

  * All columns




Columns are evaluated from left to right. The processor uses the first non-null and non-empty value.

**Use default value**

Enable this option to specify a fallback value if all input columns are null or empty.

  * If **unchecked** : The processor returns `NULL` when no valid value is found.

  * If **checked** : The processor returns the content of the “Default value” field.




**Default value**

The value to return if “Use default value” is enabled and all inputs are null/empty.

  * If you leave this field empty, the processor returns an empty string (`""`).

  * If you enter text (e.g. `"N/A"`, `"0"`), that text is returned.

  * If containing spaces (e.g. `" "`), these spaces are preserved.




## Example

The following table illustrates the behavior of the processor given two input columns, `col1` and `col2`, in different scenarios.

col1 | col2 | Result | Scenario / Configuration  
---|---|---|---  
`""` | `"foo"` | `"foo"` | **Value found.** The empty string in `col1` is skipped; valid data in `col2` is returned.  
`""` | `""` | `NULL` | **Fallback (Default disabled).** All inputs are empty. “Use default value” is **unchecked**.  
`""` | `""` | `""` | **Fallback (Default empty).** All inputs are empty. “Use default value” is **checked** , but the field is left blank.  
`""` | `""` | `"N/A"` | **Fallback (Default set).** All inputs are empty. “Use default value” is **checked** and set to `"N/A"`.

---

## [preparation/processors/column-copy]

# Copy column  
  
Duplicate the content of a column into another one.

---

## [preparation/processors/column-pseudonymization]

# Column Pseudonymization

This processor implements pseudonymization by replacing values of columns (containing sensitive data) with hashes. The processor works on any data type by hashing the string representation of the data.

## What is pseudonymization ?

Pseudonymization is a process of replacing a unique attribute in your data by a pseudonym or alias. This reduces the likelihood that the data will be linked to the original identity of the data subject. Pseudonymization is a means of ensuring data privacy but differs from anonymization because the latter irreversibly destroys any way of identifying the data subject.

## Input

  * Column selection:

>     * A single column
> 
>     * A list of multiple columns
> 
>     * All columns matching a given pattern
> 
>     * All columns

  * A hashing algorithm:

>     * SHA-256
> 
>     * SHA-512
> 
>     * MD5

  * (Optional) A static **pepper** value - To protect against dictionary attacks, the _pepper_ value is added to all input values before hashing. If you intend to use the hash as join or lookup keys, then the _pepper_ should be the same for all pseudonymized datasets.

  * (Optional) A **salt** column - To protect against dictionary attacks, the value in each row of this column will be added to the corresponding row of the input values before hashing. If you intend to use the hash as join or lookup keys, then the _salt_ column should be present and identical for all pseudonymized datasets.




## Output

The values in each processed column are replaced with the pseudonymized values. For a cell, the preparation processor calculates a hash of the concatenation of the cell value, the _pepper_ value, and the _salt_ value. For the i-th row of a pseudonymized column the output is:

\\[HASH(row_i + pepper + salt_i)\\]

## Pseudonymization Steps

Using the Visual analysis tool of the Lab, in the Script tab:

  * Add a new step of type **Pseudonymize text**

  * Select an option for _Column_ , and type the column name(s) or pattern, as applicable

  * Select a value for _Hashing algorithm_

  * Specify a column for _Salt_ (optional)

  * Specify a value for _Pepper_ (optional)




## Spark Execution

When Spark is installed, this preparation processor can run on Spark.

## In-Database Execution

This processor can be run using SQL Engine. But some databases have a limited support for hashing functions. Here are the details of this support:

Databases | MD5 | SHA256 | SHA512  
---|---|---|---  
MySQL | Y | Y | Y  
PostgreSQL | Y | N | N  
SQLServer | Y | Y | Y  
Vertica | Y | Y | Y  
Oracle | >=12c | >=12c | >=12c  
Redshift | Y | N | N  
GreenPlum | Y | N | N  
BigQuery | Y | Y | Y  
Hive | >=1.3 | N | N  
Impala | N | N | N  
DB2 | Y | Y | Y  
Snowflake | Y | Y | Y  
Teradata | N | N | N

---

## [preparation/processors/column-rename]

# Rename columns

Rename one or more columns.

To rename columns in bulk, edit renamings in _Raw text edit_. Separate each column and its new name by a horizontal tab.

---

## [preparation/processors/columns-concat]

# Concatenate columns

Concatenate values across columns using a delimiter string and produce a single output.

## Example

If `col1=myval`, `col2=myother`, and the delimiter is `.` , the concatenated output is `myval.myother`.

## Options

**Columns to concatenate**

List the columns to concatenate.

**Delimiter to use**

The delimiter separates values from each input column within the output.

**Output column**

Column containing the concatenated values.

---

## [preparation/processors/columns-select]

# Delete/Keep columns by name

Select one or more columns and either keep or remove them.

## Options

**Column**

Apply the matching condition to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns

---

## [preparation/processors/count-matches]

# Count occurrences  
  
This processor counts the number of occurrences of a pattern in the specified column

## Matching modes

  * ‘Complete value’ : counts complete cell values (output can only be 0 or 1)

  * ‘Substring’ : counts all occurrences of a string within the cell

  * ‘Regular expression’: counts matches of a regular expression




## Normalization modes

  * Case-sensitive matches (‘Exact’ mode)

  * Case-insensitive matches (‘Lowercase’ mode)

  * Accents-insensitive matches (‘Normalize’ mode)




Note: accent-insensitive matching is only available for ‘complete value’ matching.

---

## [preparation/processors/create-if-then-else]

# Create if, then, else statements

This processor performs actions or calculations based on conditional statements defined using an if, then else syntax.

IF [Condition(s)] THEN [Action(s) If True]

ELSE IF (optional) [Condition(s)] THEN [Action(s) If True]

…

ELSE IF (optional) [Condition(s) THEN [Action(s) If True]

ELSE (optional) [Action(s) if False]

## Conditions

A condition is defined with a column, an operator, a type of comparison and a value.

  * Column: choose any column from the dataset.

  * Operator: For example, string operators refer to operators that apply to string columns, like “contains”, “equals”, “matches the regex”; while numerical operators like “>”, “==“, apply to numerical columns. If you are not sure of what is the column type, refer to the storage type in the input dataset of the recipe, given under the name of the column.

  * Type of comparison: choose to compare either to a value or to another existing column.

  * Value: use an existing column or enter a value.




A Condition can be:

  * Simple: Column, operator, and value or existing column.

  * A conjunction: A (or|and) B - by adding a condition.

  * Nested: A and (B or C) - by adding a group or turning a simple condition into a group.




## Actions

  * Output column: use an existing column or create a new one for the output

  * A type of output: value, column, formula

  * The item that is assigned: a value, an existing column or a formula




For more details on how to use formulas, see the [formula language documentation](<../../formula/index.html>)

---

## [preparation/processors/currency-converter]

# Convert currencies

This processor converts a column with monetary data from one currency to another.

It supports around 40 currencies with historical data

## Input currency

The processor can either use a constant input currency, or read a different input currency from a dedicated column. This can be used to ‘realign’ different input currencies to a single output

## Output currency

The processor outputs all output in the same currency

## Reference date

The processor includes historical data for the currencies. You can either set the conversion to a fixed date, or use a Date-typed column to use a different reference date for each row

---

## [preparation/processors/currency-splitter]

# Split currencies in column

This processor takes a column containing an amount of money with its currency symbol ($,£,…) and outputs two new columns: in the first one the amount (number), in the second one the currency code (USD,GBP,…).

---

## [preparation/processors/date-components-extract]

# Extract date elements

Extract various elements of a ISO-8601 formatted date (`yyyy-MM-ddTHH:mm:ss.SSSZ`) to other columns.

## Options

**Date column**

Column containing data in ISO-8601 format. Use a Prepare step to parse your data into this format if it isn’t already.

**Timezone**

Change the timezone from the UTC default. Options include using a TZ column, an IP column, or specifying a timezone from the dropdown.

**Date elements**

To extract a given date element into a column, give the corresponding column a name. Each output column is optional; if left empty, the processor will not extract the date element.

Note

Year, month (1-12), day, day of week (1-7, 1=Monday, 7=Sunday), hour, minutes, seconds, milliseconds, week of year (1-53), timestamp (UNIX timestamp in seconds since Epoch) can all be extracted as separate outputs.

## Related resources

For more information on managing dates with Dataiku DSS, please see the [reference documentation](<https://doc.dataiku.com/dss/latest/preparation/dates.html>).

---

## [preparation/processors/date-difference]

# Compute difference between dates

Compute the difference between an ISO-8601 formatted date column (`yyyy-MM-ddTHH:mm:ss.SSSZ`) and another time reference: the current time, a fixed date, or another column.

The difference can be expressed in various **output time units** : years, months, weeks, days, hours, minutes or seconds.

If the output unit is set to **Days** , you can choose to exclude weekends and bank holidays from the computation, based on a selected country’s calendar.

Country | Default timezone | Weekend days  
---|---|---  
AE | Asia/Dubai | Saturday, Sunday  
DE | Europe/Berlin | Saturday, Sunday  
ES | Europe/Madrid | Saturday, Sunday  
FR | Europe/Paris | Saturday, Sunday  
IN | Asia/Kolkata | Saturday, Sunday  
OM | Asia/Dubai | Friday, Saturday  
SA | Asia/Riyadh | Friday, Saturday  
US | America/New_York | Saturday, Sunday  
  
## Options

**Time since column**

Column containing data in ISO-8601 format. Use a Prepare step to parse your data into this format if it isn’t already.

**Until**

Choose the second time reference to compute the difference — now, another date column, or a fixed date.

**Output time unit**

Determine the unit of time in which to express the datetime difference — year, month, week, day, hour, minute or second.

**Output column**

Column into which the datetime difference will be written.

**Reverse output**

Multiply the computed difference by -1, reversing it: `3 days` → `-3 days`.

**Exclude weekends**

Exclude weekend days based on the selected calendar. Only available when the **Output time unit** is set to **Days**.

**Exclude bank holidays**

Exclude bank holiday days. Only available when the **Output time unit** is set to **Days**. Only for the whole country, not for specific regions.

**Country code**

Choose the country for which to consider holidays and weekends. Only available if **Exclude weekends** or **Exclude bank holidays** is selected.

**Country’s timezone**

Holidays are defined by a year, month and day. However, a date in DSS corresponds to a precise point in time. To determine if a date falls on a holiday, it is necessary to know the timezone in which to consider the date.

By default, the country’s standard timezone is used, but you can specify another one. Only available if **Exclude weekends** or **Exclude bank holidays** is selected.

---

## [preparation/processors/date-formatter]

# Format date with custom format

Format data in standard ISO-8601 format (`yyyy-MM-ddTHH:mm:ss.SSSZ`) to another custom date format. Use this processor to convert an ISO-8601 date into a string that may be easier to read.

## Options

**Input column**

Column containing data in ISO-8601 format. Use a Prepare step to parse your data into this format if it isn’t already.

**Date format**

Specify the custom date format of the output column using the [Java syntax for date specifier](<http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html>).

Note

Common patterns include y (year), M (month in year), w (week in year), d (day in month), E (day name in week), a (am/pm marker), H (hour in day 0-24), h (hour in am/pm 1-12), m (minute in hour), s (second in minute), S (millisecond), Z (time zone).

**Locale**

Translate date information in locale format (like ‘mercredi’ or ‘janvier’ in French).

**Timezone**

Change the timezone from the UTC default. Options include using a TZ column, an IP column, or specifying a timezone from the dropdown.

**Output column**

Leave blank to format data in place, or create a separate output column.

Warning

If the output format is not ISO-8601, DSS will treat it as an unparsed date.

## Related resources

For more information on managing dates with Dataiku DSS, please see the [reference documentation](<https://doc.dataiku.com/dss/latest/preparation/dates.html>).

---

## [preparation/processors/date-parser]

# Parse to standard date format

Parse strings containing dates in any format into the standard ISO 8601 format (`yyyy-MM-ddTHH:mm:ss.SSSZ`) to work with them in DSS. Use Smart Dates to get semi-automatic date parsing with the assistance of DSS.

## Options

**Column**

Apply date parsing to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




**Output column**

Leave blank to parse data in-place or create a separate output column.

**Input date format(s)**

Open **Find with Smart Date** to get semi-automatic date parsing with the help of DSS. Otherwise, specify the format of your inputs column(s) using the [Java syntax for date specifiers](<http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html>).

Note

Common patterns include y (year), M (month in year), w (week in year), d (day in month), E (day name in week), a (am/pm marker), H (hour in day 0-24), h (hour in am/pm 1-12), m (minute in hour), s (second in minute), S (millisecond), Z (time zone).

**Locale**

Translate date information in locale format (like ‘mercredi’ or ‘janvier’ in French).

**Timezone**

Provide details on the time zone, if needed. Options include using a TZ column, an IP column, or specifying a timezone from the dropdown. UTC is the default.

## Related resources

For more information on managing dates with Dataiku DSS, please see the [reference documentation](<https://doc.dataiku.com/dss/latest/preparation/dates.html>). Alternatively, check out this [Knowledge Base article](<https://knowledge.dataiku.com/latest/prepare-transform-data/prepare/dates/concept-date-handling.html>) on parsing dates with DSS.

---

## [preparation/processors/email-split]

# Split e-mail addresses

Split an e-mail address into two parts: the local part (before the @) and the domain (after the @).

This processor generates two output columns, prefixed by the input column name. If the input doesn’t contain a valid email address, the processor will not produce an output value.

## Example

From the input column `email` two output columns are created: `email_localpart` and `email_domain`. The `email` column also is preserved in the output dataset.

Input `myemail@domain.com` becomes two values: `myemail` and `domain.com`.

---

## [preparation/processors/enrich-french-departement]

# Enrich from French department

This processor takes a column containing a French department code and outputs several columns with demographic data about this department.

The source data from INSEE can be selected from either:

  * the 2009-2011 release (`INSEE 2009-2011`): data coming from 2009 to 2011 censuses and statistics

  * the January 2024 release (`INSEE Jan 2024`): data coming from 2020 to 2022 censuses and statistics




## Available data

  * Basic demographic data (population, households, births, deaths, …)

  * Housing data (households, second homes, …)

  * Fiscal/Revenue data (number of ‘foyers fiscaux’, average revenue, …)

  * Employment data (number of jobs, unemployment rate, …)

  * Companies data (number of companies, breakdown by industry sector, breakdown by size, …)

---

## [preparation/processors/enrich-french-postcode]

# Enrich from French postcode

This processor takes a column containing a French post code and outputs several columns with demographic data about the cities using this post code.

The source data from INSEE can be selected from either:

  * the 2009-2011 release (`INSEE 2009-2011`): data coming from 2009 to 2011 censuses and statistics

  * the January 2024 release (`INSEE Jan 2024`): data coming from 2020 to 2022 censuses and statistics




## Available data

  * Associated department code

  * Basic demographic data (population, households, births, deaths, …)

  * Housing data (households, second homes, …)

  * Fiscal/Revenue data (number of ‘foyers fiscaux’, average revenue, …)

  * Employment data (number of jobs, unemployment rate, …)

  * Companies data (number of companies, breakdown by industry sector, breakdown by size, …)

---

## [preparation/processors/enrich-with-build-context]

# Enrich with build context

This processor adds columns containing information about the current build context, when available.

The following information can be added:

  * Build date: date when the job started

  * Job ID: ID of the job that ran the Prepare recipe




Additionally, this processor will not output any valid data when designing the preparation. The data will only be filled when actually running the recipe.

---

## [preparation/processors/enrich-with-record-context]

# Enrich with record context

Add columns containing information about the current record, when available. This processor is used on partitioned or file-based datasets.

## Options

Add a column name to create any of the following:

  * **Output partition column:** Create new column with source partition (for partitioned input datasets)

  * **Output partition chunks columns prefix:** Create new column with source partition dimension values (for partitioned input datasets)

  * **Output file path column:** Create column with file path (for file-based datasets)

  * **Output filename column:** Create column with file name (for file-based datasets)

  * **Output file record column:** Create column with record id in file (for file-based datasets)

  * **Output last modified column:** Create column with file last modification timestamp (for file-based datasets)




Warning

This processor can only work in the “DSS” engine. It is not compatible with the Spark and SQL engines.

Note

This processor will not output any valid data when designing the preparation. The data will only populate when the Prepare recipe runs.

---

## [preparation/processors/extract-ngrams]

# Extract ngrams

This processor extracts sequences of words, called _ngrams_ , from a text column.

## What are ngrams ?

For example, for text ‘the quick brown fox jumps’, the ngrams are:

  * ngrams of size 2 (also called 2-grams) : the quick, quick brown, brown fox, fox jumps

  * ngrams of size 3 (also called 3-grams): the quick brown, quick brown fox, brown fox jumps




## Example use case

You want to perform statistics on the sequence of words used in a query log.

## Output

The NGram extractor offers several output modes:

  * Convert to JSON: A JSON array containing the ngrams is generated, either in the input column or in another column. This mode is most useful if you intend to perform some custom processing and need to retain the structure of the original text.

  * One ngram per row: in this mode, for each ngram, a new row is generated. The row contains a copy of all other columns in the original row. This mode is most useful if you intend to group by ngram afterwards.

  * One ngram per column: in this mode, a new column is generated for each ngram. For example, if a column contains 4 words, you ask for 2-grams, and you use ‘out_’ as prefix, columns ‘out_0’, ‘out_1’ and ‘out_2’ will be generated.




## Simplification

Very often, you’ll want to simplify the text to remove some variance in your text corpus. This processor offers several possible simplifications on the text before extracting ngrams.

  * Normalize text: transforms to lowercase, removes accents and performs Unicode normalization (Café -> cafe)

  * Clear stop words: remove so-called ‘stop words’ (the, I, a, of, …). This transformation is language-specific and requires you to enter the language of your column.

  * Stem words: transforms each word into its ‘stem’, ie its grammatical root. For example, ‘grammatical’ is transformed to ‘grammat’. This transformation is language-specific and requires you to enter the language of your column.

  * Sort words alphabetically: sorts all words of the text. For example, ‘the small dog’ is transformed to ‘dog small the’. This allows you to match together strings that are written with the same words in a different order.




Note: it is strongly advised to clear stop words before extracting ngrams

## Advanced options

  * Split on sentence boundaries: Generally, you don’t want to compute cross-sentence ngrams. For example, with text ‘The rain falls. The sun shines’, you don’t want to generate ‘falls the’ as a ngram.

  * Compute skip-grams : In our sample sentence, the skip-grams would be: the brown, the fox, the jumps, quick fox, quick jumps, … Enabling skip-grams computation dramatically increases output size and computation requirements.

---

## [preparation/processors/extract-numbers]

# Extract numbers

Extract numerical values from a text column.

## Options

**Extract several values**

By default, the processor extracts several values and outputs each detected number into a separate column, suffixed with the index of the number. Unselect this option to extract only the first found number.

**Extract values into a JSON array**

Output the found number(s) in a single column as a JSON-array.

Note

In SQL mode, the number of output columns must be fixed beforehand. It is therefore extrapolated from the sample.

**Expand ‘k’ to ‘1000’ and ‘m’ to ‘1000000’**

Automatically expand notations like ‘10K’ and ‘5M’

**Decimal separator**

Use the program’s best guess or choose from between comma and dot separators.

---

## [preparation/processors/fill-column]

# Fill column

Fill all values of a column with a fixed value.

---

## [preparation/processors/fill-empty-with-computed-value]

# Impute with computed value

This processor imputes missing values with mean, median or mode.

The mean is the sum of values of a data set divided by number of values. This is what is most often meant by an average.

The median is the middle value separating the greater and lesser halves of a set of values

The mode is the most frequent value in a set of values

For example, given the values `1, 2, 2, 3, 4, 7, 9`:

>   * Mean is `4` ((1+2+2+3+4+7+9) / 7)
> 
>   * Median is `3` (1, 2, 2 – **3** – 4, 7, 9)
> 
>   * Mode is `2` (1, **2** , **2** , 3, 4, 7, 9)
> 
>

---

## [preparation/processors/fill-empty]

# Fill empty cells with fixed value

Fill the empty cells in a column with a fixed value.

## Options

**Column**

Apply fill to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




**Value to fill with**

Enter the value with which to fill empty cells.

---

## [preparation/processors/filter-on-date]

# Filter rows/cells on date

Filter rows from the dataset using a date filter defined by a fixed date range, a relative date range, or a matching date part. Alternatively, clear content from matching cells rather than filter the rows.

## Options

**Action**

Select the action to perform on matching (in range) rows or cells:

  * Keep matching rows only

  * Remove matching rows

  * Clear content of matching cells

  * Clear content of non-matching cells




**Date column**

Column containing data in ISO-8601 format. Use a Prepare step to parse the data into this format if it isn’t already. If the column doesn’t not contain a valid date for a row, this row is considered out of range.

**Filter on**

Choose how to define the date filter:

  * **Date range:** Use a fixed date range. The lower/upper boundaries are inclusive. If the lower bound is empty, all dates before the upper bound will match, and vice versa.

  * **Relative range:** Use a relative date range and time window (last N, next N, current, until now). The range is calculated relative to the current date and the chosen date parts. It will update itself over time.

  * **Date part:** Filter on date part falling within values in a list.

---

## [preparation/processors/filter-on-formula]

# Filter rows/cells with formula

Filter rows from the dataset based on the result of a formula. Alternatively, clear content from matching cells rather than filter the rows.

The row/cell matches if the result of the formula is considered as “truish,” which includes:

  * A true boolean

  * A number (integer or decimal) that is not 0

  * The string “true”




## Options

**Action**

Select the action to perform on matching (in range) rows or cells:

  * Keep matching rows only

  * Remove matching rows

  * Clear content of matching cells

  * Clear content of non-matching cells

---

## [preparation/processors/filter-on-meaning]

# Filter invalid rows/cells

Filter rows from the dataset with invalid values, i.e. those that are invalid for the selected meaning. Alternatively, this processor can clear content from invalid cells instead of filtering entire rows.

Meaning is semantic information about the data and is usually automatically detected from the content of the column: URL, IP Address, Country. As such, each cell can be valid or invalid for a given meaning.

## Options

**Action**

Select the action to perform on matching (in range) rows or cells:

  * Keep matching rows only

  * Remove matching rows

  * Clear content of matching cells

  * Clear content of non-matching cells




**Column**

Apply the matching condition to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




Note

When applying the match condition to several columns (multiple, pattern, all), select whether the row will be considered as matching if all columns match (ALL) or at least one column matches (OR).

**Meaning to check**

Select which meaning to check cells in the column for: text, decimal, integer, boolean, date, object, array, natural lang., geo…

## Related resources

For more information on data types (storage vs. meaning) in DSS, please see the [reference documentation](<https://doc.dataiku.com/dss/latest/schemas/definitions.html>). If you prefer a hands-on approach, check out the article on meanings in the [Dataiku Knowledge Base](<https://knowledge.dataiku.com/latest/import-data/exploration/concept-meaning.html>) or explore [user-defined meanings](<https://doc.dataiku.com/dss/latest/schemas/user-defined-meanings.html>).

---

## [preparation/processors/filter-on-range]

# Filter rows/cells on numerical range

Filter rows from the dataset that contain numbers within a numerical range. Alternatively, this processor can clear content from matching cells instead of filtering entire rows.

The boundaries of the numerical range are inclusive. A value is considered out of range if it isn’t a valid numerical value.

## Options

**Action**

Select the action to perform on matching (in range) rows or cells:

  * Keep matching rows only

  * Remove matching rows

  * Clear content of matching cells

  * Clear content of non-matching cells




**Column**

Apply the matching condition to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




Note

When applying the match condition to several columns (multiple, pattern, all), select whether the row will be considered as matching if all columns match (ALL) or at least one column matches (OR).

---

## [preparation/processors/filter-on-value]

# Filter rows/cells on value

Filter rows from the dataset that contain specific values. Alternatively, this processor can clear content from matching cells instead of filtering entire rows.

## Options

**Action**

Select the action to perform on matching (in range) rows or cells:

  * Keep matching rows only

  * Remove matching rows

  * Clear content of matching cells

  * Clear content of non-matching cells




**Column**

Apply the matching condition to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




Note

When applying the match condition to several columns (multiple, pattern, all), select whether the row will be considered as matching if all columns match (ALL) or at least one column matches (OR).

**has values**

Input the values for the match condition. A cell will match if it matches one or more values in the list.

**Match mode**

Determine the match type:

  * **Complete value:** the entire cell must match the searched value(s)

  * **Substring:** the cell contains the searched value(s)

  * **Regular expression:** the cell matches the regex




Note

The regex is not anchored.

**Normalization mode**

Specify how to find the match:

  * **Exact (no transformation):** use case-sensitive search

  * **Ignore case:** use case-insenstive search

  * **Normalize (ignore accents):** use accents-insensitive search




Note

Accent-insensitive normalization is only available for complete value matching.

---

## [preparation/processors/find-replace]

# Find and replace

Find and replace strings in one or more columns. Find/Replace supports multiple replacements: Several replacements can be applied on the same cell, one after the other.

To stop looking for matches in a cell after successfully applying a replacement, select **Only perform the first matching replacement**.

## Options

**Column**

Apply find and replace to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




**Output column**

Create a separate output column or leave blank to perform find and replace in-column.

**Replacements**

List the strings to match and their corresponding replacements.

**Matching mode**

Determine the type of replacement for find and replace to perform.

  * **Complete value:** replace the entire content of the matched cell

  * **Substring:** replace all occurrences of a string within the cell

  * **Regular expression:** replace matches of a regular expression




Note

  * Regular expression matching supports group captures. Reference groups using the $index notation. If you want to find/replace `val-17-x` into `V17`, use the following replacement `val-([0-9]*)-.*` → `V$1`

  * To replace the symbol `$` in a regular expression match, escape it and type `\$`.




**Normalization mode**

Specify how to find the match:

  * **Exact (no transformation):** use case-sensitive search

  * **Lowercase:** use case-insensitive search




Note

Accent-insensitive normalization is only available for complete value matching.

**Read replacements from a dataset**

To read replacements from a dataset, select **Advanced: Read replacements from a dataset** and specify the dataset to read the replacements from along with two columns of that dataset; one which contains the strings to match and another one which contains their corresponding replacements.

Note

When replacements are read from a dataset, any replacements listed explicitly in this step of the Prepare recipe’s script will be ignored.

## Related resources

To extract multiple values from a cell using a regular expression, use the [extract with regular expression](<https://doc.dataiku.com/dss/11.0/preparation/processors/pattern-extract.html>) processor.

---

## [preparation/processors/flag-on-date]

# Flag rows/cells on date range

This processor flags rows or cells based on the type of date flag applied: a date range, a relative range, or a date part.

This processor should only be used on columns with meaning ‘Date’, ie. parsed dates.

## Action

You can select the action to perform on matching (in range) rows:

  * Remove matching rows

  * Keep matching rows only

  * Clear the content of the matching cells

  * Clear the content of the non-matching cells




**Flag on Date Range**

Flag rows in the dataset if the date values in a column fall within the boundaries specified by a static range; these boundaries are inclusive. If the lower bound (From) is left empty, all dates before the upper bound (To) are flagged, and vice-versa. If the column does not contain a valid date for a given row, that row is considered as being outside the specified range.

The provided timezone will be used to flag dates.

**Flag on Relative Range**

Flag rows in the dataset if the date values in a column fall within the boundaries specified by a relative range; these boundaries are dynamic and will update relative to the time on the local server. The relative range is defined using different date periods (year, quarter, month, day) and times (for example: this year, last N years, next N years, year to date). Note: each period is a calendar period; the last 1 year will flag data for the last complete calendar year.

The dates in the dataset as interpreted using the UTC timezone when flagging on relative range.

**Flag on Date Range**

Flag rows in the dataset if the date values in a column have the same date part(s) as the one(s) specified in the processor. Data can be flagged on a variety of date parts like year, month, week, weekday, day, specific date…

The dates in the dataset as interpreted using the UTC timezone when flagging on date part.

---

## [preparation/processors/flag-on-formula]

# Flag rows with formula

Flag rows from the dataset based on the result of a formula by creating a column containing ‘1’ for all matching (in-range) rows. Unmatched rows are left empty.

## Options

**Expression**

Write a formula by which to evaluate each row for a match. The row matches if the result of the formula is considered as “truish,” which includes:

  * A true boolean

  * A number (integer or decimal) that is not 0

  * The string “true”




**Flag column**

Name the column that will contain the match flags 1-true, empty-false

## Related resources

For more information on the formula language, please see the [formula language reference](<https://doc.dataiku.com/dss/latest/formula/index.html>) in Dataiku’s documentation.

---

## [preparation/processors/flag-on-meaning]

# Flag invalid rows

This processor flags rows with invalid values, ie values not matching a selected meaning.

It creates a column which will contain ‘1’ if the row matches (invalid), nothing else

## Columns selection

This processor can check its matching condition on multiple columns:

  * A single column

  * An explicit list of columns

  * All columns matching a given pattern

  * All columns




You can select whether the row will be considered as matching if:

  * All columns are matching

  * Or, at least one column is matching

---

## [preparation/processors/flag-on-range]

# Flag rows on numerical range

This processor flags rows for which the value is within a numerical range.

The boundaries of the numerical range are inclusive. If the column does not contain a valid numerical value for a row, this row is considered as being out of the range.

This processor creates a column containing ‘1’ for matching (in-range) rows, nothing else.

## Columns selection

This processor can check its matching condition on multiple columns:

  * A single column

  * An explicit list of columns

  * All columns matching a given pattern

  * All columns




You can select whether the row will be considered as matching if:

  * All columns are matching

  * Or, at least one column is matching

---

## [preparation/processors/flag-on-value]

# Flag rows on value

Flag rows from dataset that contain specific values by creating a column containing ‘1’ for all matching (in-range) rows. Unmatched rows are left empty.

## Options

**Flag (output) column**

Create a column in which to store the flag.

**Column**

Apply the matching condition to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




Note

When applying the match condition to several columns (multiple, pattern, all), select whether the row will be considered as matching if all column match (ALL) or at least one column matches (OR).

---

## [preparation/processors/fold-columns-by-name]

# Fold multiple columns

Perform the opposite of a pivot and fold a **list of columns** , transforming a wide dataset into a narrow one. This is also sometimes called a melt. This processor outputs two columns: one containing **column names** and the other containing **column values**.

## Example

student | math | science | arts  
---|---|---|---  
Marie | 85 | 83 | 81  
Caroline | 74 | 91 | 86  
Paul | 70 | 85 | 89  
  
Applying “Fold multiple columns” with `class` for folded column names and `grade` for folded values generates the following table:

student | class | grade  
---|---|---  
Marie | math | 85  
Marie | science | 83  
Marie | arts | 81  
Caroline | math | 74  
Caroline | science | 91  
Caroline | arts | 86  
Paul | math | 70  
Paul | science | 85  
Paul | arts | 89  
  
## Options

**Column for folded column names**

Column containing the names of folded columns.

**Column for folded values**

Column containing the values of folded columns.

**Remove folded columns**

Remove the now empty folded columns.

## Related resources

For more information, read about [reshaping data](<https://doc.dataiku.com/dss/11.0/preparation/reshaping.html>) in the Dataiku documentation.

---

## [preparation/processors/fold-columns-by-pattern]

# Fold multiple columns by pattern

Transforms values from multiple columns into one line per column. This processor selects the columns to fold using a pattern. It only creates lines for non-empty columns.

If the pattern has a capture group, this processor uses the captured portion of the column name instead of the full column name.

## Examples

Using `.*_score` as a column to fold pattern:

person | age | Q1_score | Q2_score | Q3_score  
---|---|---|---|---  
John | 24 | 3 | 4 | 6  
Sidney | 31 |  | 6 | 9  
Bill | 33 | 1 |  | 4  
  
becomes:

person | age | quarter | score  
---|---|---|---  
John | 24 | Q1_score | 3  
John | 24 | Q2_score | 4  
John | 24 | Q3_score | 6  
Sidney | 31 | Q2_score | 6  
Sidney | 31 | Q3_score | 9  
Bill | 33 | Q1_score | 1  
Bill | 33 | Q3_score | 4  
  
Using a capture group, with the pattern `(.*)_score`, the example becomes:

person | age | quarter | score  
---|---|---|---  
John | 24 | Q1 | 3  
John | 24 | Q2 | 4  
John | 24 | Q3 | 6  
Sidney | 31 | Q2 | 6  
Sidney | 31 | Q3 | 9  
Bill | 33 | Q1 | 1  
Bill | 33 | Q3 | 4  
  
## Options

**Columns to fold pattern**

Write a regular expression to find matching columns, or choose **Find with Smart Pattern** to get help writing a regular expression. In the Smart Pattern window, you can highlight the portion of the column name that you wish to use. To use a pattern in the processor, select it and choose **OK**.

**Column for fold name**

Give a name for the new column that will contain the fold name. (“Quarter” in the example.)

**Column for fold value**

Give a name for the new column that will contain the fold value. (“Score” in the example.)

**Remove folded columns**

Check the box to delete folded columns after running the recipe.

## Related resources

This processor is a variant of Fold multiple columns. Read more about that processor in the [Dataiku documentation](<https://doc.dataiku.com/dss/11.0/preparation/processors/fold-columns-by-name.html>).

---

## [preparation/processors/fold-object]

# Fold object keys

This processor splits a JSON Object column and transforms them into several rows with key and value in new columns.

For more details on reshaping, please see [DSS Users’s Guide](<http://doc.dataiku.com/>), notably the section about the Fold Object processor

For more details on reshaping, please see [Reshaping](<../reshaping.html>).

---

## [preparation/processors/formula]

# Formula

This processor computes new columns using formulas based on other columns (like in a spreadsheet). The [formula language](<../../formula/index.html>) provides:

  * Math functions

  * String manipulation functions

  * Date handling functions

  * Boolean and conditional expressions for rules creation




## Usage examples

  * Compute a numerical expression: `(col1 + col2) / 2 * log(col3)`

  * Manipulate strings : `toLowercase(substring(strip(mytext), 0, 7))`

  * Create a rule-based column: `if (width > height, "wide", "tall")`




## Getting help

The formula editor provides live syntax checking, preview of results, a complete language reference, and examples.

---

## [preparation/processors/fuzzy-join]

# Fuzzy join with other dataset (memory-based)

Warning

**Deprecated** : Memory-based fuzzy join processor is deprecated. Use a [dedicated fuzzy join recipe](<../../other_recipes/fuzzy-join.html>) instead.

This processor performs a fuzzy left join with another (small) dataset.

‘Fuzzy’ means that the join can match even if the two strings being matched are not exactly equal, but close.

Since the join is done in memory the main limitation is the dataset size. To overcome this limit there’s a [dedicated fuzzy join recipe](<../../other_recipes/fuzzy-join.html>) that is a recommended way of using fuzzy join in DSS.

## Example use case

You are processing a dataset of search queries. Many queries target the name of a product, but with lots of variations and typos. You also have a dataset with all your products, and you want to add some product details info to each query, when we can identify which product it is about.

Fuzzy join can help you find the correct product, even when the product name is not exact. # Behaviour details The processor performs a deduplicated left join:

  * If no rows in the ‘other’ dataset match, joined columns are left empty

  * If multiple rows match in the ‘other’ dataset, the ‘closest’ one in terms of edit distanceis selected




## Requirements and limitations

The ‘other’ dataset must fit in RAM. A good limit would be that it should not be more than ~500 000 rows. If this is not the case, you should use a recipe to join the datasets (for example, a Hive, Python or SQL recipe).

Both the dataset being processed and the ‘other’ dataset must contain a column containing the join key. # Fuzziness and simplification The processor performs a fuzzy search by computing the ‘distance’ between two string (roughly speaking, the number of differing characters between them). In order to increase the recall (ie, the number of times we find a match), it is generally recommended to first ‘simplify’ the text in both datasets, to remove some variance. This processor has built-in simplification options.

  * Normalize text: transforms to lowercase, removes accents and performs Unicode normalization (Café -> cafe)

  * Clear stop words: remove so-called ‘stop words’ (the, I, a, of, …). This transformation is language-specific and requires you to enter the language of your column.

  * Stem words: transforms each word into its ‘stem’, ie its grammatical root. For example, ‘grammatical’ is transformed to ‘grammat’. This transformation is language-specific and requires you to enter the language of your column.

  * Sort words alphabetically: sorts all words of the text. For example, ‘the small dog’ is transformed to ‘dog small the’. This allows you to match together strings that are written with the same words in a different order.




## Parameters

The processor needs the following parameters:

  * Column containing the join key in the current dataset (which may have been generated by a previous step)

  * Name of the dataset to join with. Note that the dataset to join with must be in the same project.

  * Column containing the join key in the joined dataset.

  * Columns from the joined dataset that should be copied to the local dataset, for the matched row.

  * Simplification options

  * Maximum Damerau-Levenstein distance between the simplified strings so that they are considered a match.




## Output

The processor outputs selected columns from the joined dataset. For each row of the current dataset, the columns will contain the data from the matching row in the joined dataset.

If no row matched in the joined dataset, the output columns will be left empty.

---

## [preparation/processors/generate-big-data]

# Generate Big Data

This processor generates Big Data out of small data.

The number of output rows will be exactly the number of input rows times the specified Expansion Factor.

The processor does not simply copy rows; instead, for numeric columns, it generates new values in the same range as the input values. For alphanumeric columns, it splits the column into words, and replaces each input word by a randomly selected one from the observed values.

---

## [preparation/processors/geo-distance]

# Compute distance between geospatial objects

This processor computes the geodesic distance between a geospatial column and another geospatial object.

You can compare a column with:

  * A fixed geopoint

  * A fixed geospatial object

  * Another geospatial column




The computation outputs a number of distance units (kilometers, miles) in another column.

In the case of a distance between two geometries, the distance is the shortest distance between these two.

The processor assumes that the data uses GPS coordinates, also known as WGS-84, SRID 4326 or EPSG:4326.

GeoJSON format is not supported with the SQL Engine when using PostgreSQL.

---

## [preparation/processors/geo-info-extractor]

# Extract from geo column

This processor extracts data from a geometry column.

Extracts:

  * Centroid point

  * Length (if input is not a point)

  * Area (if input is a polygon)




Warning: Length and area are expressed in the unit of the CRS, so often in degrees instead of meters.

---

## [preparation/processors/geo-join]

# Geo join with other dataset (memory-based)

Warning

**Deprecated** : Memory-based geo join processor is deprecated. Use a [dedicated geo join recipe](<../../other_recipes/geojoin.html>) instead.

This processor performs a geographic nearest-neighbour join between two datasets with geo coordinates.

## Example use case

You are processing a dataset of geo-tagged events. You have another dataset containing geo-tagged points of interest, and you want, for each event, to retrieve the identifier and details of the nearest point of interest.

## Requirements

The dataset being processed must contain two columns containing the latitude and longitude. The ‘other’ dataset you join with must also contain two columns with latitude and longitude.

For the dataset being processed, the columns may have been generated by a previous step (like the GeoIP resolver).

## Parameters

The processor needs the following parameters:

  * Latitude and longitude column in current dataset (which may have been generated by a previous step)

  * Name of the dataset to join with. Note that the dataset to join with must be in the same project.

  * Latitude and longitude column in the joined dataset.

  * Columns from the joined dataset that should be copied to the local dataset, for the nearest row.




## Output

The processor outputs all columns from the joined dataset. For each row of the current dataset, the columns will contain the data from the nearest row in the joined dataset.

In addition, the processor outputs a ‘join_distance’ column containing the distance of the found nearest neightbour, in kilometers.

---

## [preparation/processors/geoip]

# Resolve GeoIP

Extract geographic information from an IP address, including:

  * **Country name**

  * **Country code:** 2, 3 letters

  * **Region:** Generate three new columns

>     * **Region code.** Depending on country, this can be a state code, a region code, a department identifier, …
> 
>     * **Region name.** Depending on country, this can be a state name, a region name, a department name, …
> 
>     * **Region hierarchy.** When available, this is a comma-separated hierarchical list of region names, from most general to most specific

  * **City name**

  * **Postal code**

  * **Latitude and longitude**

  * **GeoPoint**

  * **Timezone identifier**

  * **Continent name**




Warning

The precision of the GeoLite City database varies widely upon on the visitor’s ISP.

---

## [preparation/processors/geopoint-buffer]

# Create area around a geopoint

This processor creates buffer polygons around geopoints. For each input geospatial point, a spatial polygon is created around it, delimiting the area of influence covered by the point (all the points that fall within a given distance from the geopoint). The shape area of the polygon can be either rectangular or circular (using an approximation) and the size will depend on the selected parameters.

## Action

You can select an input column that contains geopoints on which the polygon is centered. The output column will contain created polygons in the WKT format.

## Polygon creation options

Select the shape of polygons from:

  * Rectangular

  * Circular




Select the unit of distances from:

  * Kilometers

  * Miles




If Rectangle shape is selected:

  * Select the Width and Height of the Rectangle shape to compute.




If Circle shape is selected:

  * Select the Radius of the Circle shape to compute.




Each distance is expressed according to the input unit.

## Screenshots

Explore view of input and output columns:

Parameters of the processor:

Input and associated output on a map (Circular shape):

---

## [preparation/processors/geopoint-create]

# Create GeoPoint from lat/lon

Create a column in GeoPoint format from two columns containing latitude and longitude. GeoPoint is a data meaning that represents a point on Earth, POINT(longitude, latitude), and is used in map charts.

This processor uses the WKT (well-known text) markup format for representing GeoPoints.

---

## [preparation/processors/geopoint-extract]

# Extract lat/lon from GeoPoint

This processor extracts two latitude and longitude columns from a column in GeoPoint format. GeoPoint is a data meaning representing a point on Earth. It supports several standard point representation formats.

---

## [preparation/processors/grok]

# Extract with grok

This processor extracts parts from a column using grok patterns and/or a set of regular expressions. The chunks to extract are delimited using named captures.

## Overview

>   * The processor comes with a list of integrated grok patterns. See Supported grok patterns below.
> 
>   * You can combine several grok patterns with regular expressions in the same processor.
> 
>   * You can use the Grok Editor window to write & preview the results of your regular expressions.
> 
> 


## Syntax

Named captures copy the matches into new columns.

### With a grok pattern

Syntax: `%{Grok_Pattern_Name:named_capture}`

>   * Example:
> 
> 

>
>> `%{IP:clientIP}`
>> 
>> [](<../../_images/grok-2.png>)

  * Output:

clientIP  
---  
83.149.9.216  



### With a regular expression (regex)

Syntax: `(?<named_capture>custom_pattern)`

>   * Example:
> 
> 

>
>> `(?<firstWord>\w+)`
>> 
>> [](<../../_images/grok-1.png>)
> 
>   * Output:
> 
> 

>
>> firstWord  
>> ---  
>> 2021  
  
Note

Named captures only works with a full name (i.e: no `“_”`, `“-”` or `“ “` allowed).

## Found column

If you enable this option, a column named ‘found’ will contain a boolean to indicate whether the pattern matched.

## Some cases of application

  1. Parsing DSS access logs:




>   * Here is a data sample from DSS access.log:
> 
> 


Line  
---  
“127.0.0.1 - - [15/Oct/2020:07:31:29 +0200] “”GET /bower_components/jquery/dist/jquery.min.js HTTP/1.1”” 200 34847 “”<http://localhost:11200/home/>”” “”Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.80 Safari/537.36”””  
“127.0.0.1 - - [15/Oct/2020:07:31:29 +0200] “”GET /static/dataiku/css/style.css HTTP/1.1”” 200 341166 “”<http://localhost:11200/home/>”” “”Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.80 Safari/537.36”””  
“127.0.0.1 - - [15/Oct/2020:07:31:29 +0200] “”GET /static/dataiku/css/style.css HTTP/1.1”” 200 341166 “”<http://localhost:11200/home/>”” “”Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.80 Safari/537.36”””  
  
>   * Regular expression:
>     
>         
>         %{IP:ip} - - \[%{HTTPDATE:HTTPDate}\]
>         ""%{WORD:method} %{URIPATH:resourceURI} %{WORD}/%{NUMBER}""
>         %{NUMBER:statusCode} %{NUMBER:noIdea} ""http:%{URIPATH}""
>         ""%{GREEDYDATA:userAgent}"""
>         
> 
>   * Output:
> 
> 

>
>> [](<../../_images/grok-3.png>)

  2. Parsing backend logs timestamp:




>   * Here is a data sample from DSS backeng.log:
> 
> 


Line  
---  
[2021/09/15-15:12:09.776] [qtp1429351083-884] [DEBUG] [dku.tracing] - [ct: 2] Start call: /api/discussions/get-discussion-counts [GET] user=admin [projectKey=S3DSSVSELK objectType=PROJECT objectId=S3DSSVSELK]  
[2021/09/15-15:12:09.811] [qtp1429351083-884] [DEBUG] [dku.db.internal] - [ct: 37] Created DSSDBConnection dssdb-h2-discussions-WboYz62  
[2021/09/15-15:12:09.818] [qtp1429351083-884] [DEBUG] [dku.tracing] - [ct: 44] Done call: /api/discussions/get-discussion-counts [GET] time=44ms user=admin [projectKey=S3DSSVSELK objectType=PROJECT objectId=S3DSSVSELK]  
  
>   * Regular expression:
> 
> 


`(?<Timestamp>%{YEAR}[/-]%{MONTHNUM}[/-]%{MONTHDAY}[/-]%{HOUR}:?%{MINUTE}?:%{SECOND})`

>   * Output:
> 
> 


[](<../../_images/grok-4.png>)

## Supported grok patterns
    
    
    USERNAME [a-zA-Z0-9._-]+
    USER %{USERNAME:UNWANTED}
    INT (?:[+-]?(?:[0-9]+))
    BASE10NUM (?<![0-9.+-])(?>[+-]?(?:(?:[0-9]+(?:\.[0-9]+)?)|(?:\.[0-9]+)))
    NUMBER (?:%{BASE10NUM:UNWANTED})
    BASE16NUM (?<![0-9A-Fa-f])(?:[+-]?(?:0x)?(?:[0-9A-Fa-f]+))
    BASE16FLOAT \b(?<![0-9A-Fa-f.])(?:[+-]?(?:0x)?(?:(?:[0-9A-Fa-f]+(?:\.[0-9A-Fa-f]*)?)|(?:\.[0-9A-Fa-f]+)))\b
    
    POSINT \b(?:[1-9][0-9]*)\b
    NONNEGINT \b(?:[0-9]+)\b
    WORD \b\w+\b
    NOTSPACE \S+
    SPACE \s*
    DATA .*?
    GREEDYDATA .*
    #QUOTEDSTRING (?:(?<!\\)(?:"(?:\\.|[^\\"])*"|(?:'(?:\\.|[^\\'])*')|(?:`(?:\\.|[^\\`])*`)))
    QUOTEDSTRING (?>(?<!\\)(?>"(?>\\.|[^\\"]+)+"|""|(?>'(?>\\.|[^\\']+)+')|''|(?>`(?>\\.|[^\\`]+)+`)|``))
    UUID [A-Fa-f0-9]{8}-(?:[A-Fa-f0-9]{4}-){3}[A-Fa-f0-9]{12}
    
    # Networking
    MAC (?:%{CISCOMAC:UNWANTED}|%{WINDOWSMAC:UNWANTED}|%{COMMONMAC:UNWANTED})
    CISCOMAC (?:(?:[A-Fa-f0-9]{4}\.){2}[A-Fa-f0-9]{4})
    WINDOWSMAC (?:(?:[A-Fa-f0-9]{2}-){5}[A-Fa-f0-9]{2})
    COMMONMAC (?:(?:[A-Fa-f0-9]{2}:){5}[A-Fa-f0-9]{2})
    IPV6 ((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?
    IPV4 (?<![0-9])(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))(?![0-9])
    IP (?:%{IPV6:UNWANTED}|%{IPV4:UNWANTED})
    HOSTNAME \b(?:[0-9A-Za-z][0-9A-Za-z-]{0,62})(?:\.(?:[0-9A-Za-z][0-9A-Za-z-]{0,62}))*(\.?|\b)
    HOST %{HOSTNAME:UNWANTED}
    IPORHOST (?:%{HOSTNAME:UNWANTED}|%{IP:UNWANTED})
    HOSTPORT (?:%{IPORHOST}:%{POSINT:PORT})
    
    # paths
    PATH (?:%{UNIXPATH}|%{WINPATH})
    UNIXPATH (?>/(?>[\w_%!$@:.,~-]+|\\.)*)+
    #UNIXPATH (?<![\w\/])(?:/[^\/\s?*]*)+
    TTY (?:/dev/(pts|tty([pq])?)(\w+)?/?(?:[0-9]+))
    WINPATH (?>[A-Za-z]+:|\\)(?:\\[^\\?*]*)+
    URIPROTO [A-Za-z]+(\+[A-Za-z+]+)?
    URIHOST %{IPORHOST}(?::%{POSINT:port})?
    # uripath comes loosely from RFC1738, but mostly from what Firefox
    # doesn't turn into %XX
    URIPATH (?:/[A-Za-z0-9$.+!*'(){},~:;=@#%_\-]*)+
    #URIPARAM \?(?:[A-Za-z0-9]+(?:=(?:[^&]*))?(?:&(?:[A-Za-z0-9]+(?:=(?:[^&]*))?)?)*)?
    URIPARAM \?[A-Za-z0-9$.+!*'|(){},~@#%&/=:;_?\-\[\]]*
    URIPATHPARAM %{URIPATH}(?:%{URIPARAM})?
    URI %{URIPROTO}://(?:%{USER}(?::[^@]*)?@)?(?:%{URIHOST})?(?:%{URIPATHPARAM})?
    
    # Months: January, Feb, 3, 03, 12, December
    MONTH \b(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)\b
    MONTHNUM (?:0?[1-9]|1[0-2])
    MONTHNUM2 (?:0[1-9]|1[0-2])
    MONTHDAY (?:(?:0[1-9])|(?:[12][0-9])|(?:3[01])|[1-9])
    
    # Days: Monday, Tue, Thu, etc...
    DAY (?:Mon(?:day)?|Tue(?:sday)?|Wed(?:nesday)?|Thu(?:rsday)?|Fri(?:day)?|Sat(?:urday)?|Sun(?:day)?)
    
    # Years?
    YEAR (?>\d\d){1,2}
    # Time: HH:MM:SS
    #TIME \d{2}:\d{2}(?::\d{2}(?:\.\d+)?)?
    # I'm still on the fence about using grok to perform the time match,
    # since it's probably slower.
    # TIME %{POSINT<24}:%{POSINT<60}(?::%{POSINT<60}(?:\.%{POSINT})?)?
    HOUR (?:2[0123]|[01]?[0-9])
    MINUTE (?:[0-5][0-9])
    # '60' is a leap second in most time standards and thus is valid.
    SECOND (?:(?:[0-5]?[0-9]|60)(?:[:.,][0-9]+)?)
    TIME (?!<[0-9])%{HOUR}:%{MINUTE}(?::%{SECOND})(?![0-9])
    # datestamp is YYYY/MM/DD-HH:MM:SS.UUUU (or something like it)
    DATE_US %{MONTHNUM}[/-]%{MONTHDAY}[/-]%{YEAR}
    DATE_EU %{MONTHDAY}[./-]%{MONTHNUM}[./-]%{YEAR}
    ISO8601_TIMEZONE (?:Z|[+-]%{HOUR}(?::?%{MINUTE}))
    ISO8601_SECOND (?:%{SECOND}|60)
    TIMESTAMP_ISO8601 %{YEAR}-%{MONTHNUM}-%{MONTHDAY}[T ]%{HOUR}:?%{MINUTE}(?::?%{SECOND})?%{ISO8601_TIMEZONE}?
    DATE %{DATE_US}|%{DATE_EU}
    DATESTAMP %{DATE}[- ]%{TIME}
    TZ (?:[PMCE][SD]T|UTC)
    DATESTAMP_RFC822 %{DAY} %{MONTH} %{MONTHDAY} %{YEAR} %{TIME} %{TZ}
    DATESTAMP_RFC2822 %{DAY}, %{MONTHDAY} %{MONTH} %{YEAR} %{TIME} %{ISO8601_TIMEZONE}
    DATESTAMP_OTHER %{DAY} %{MONTH} %{MONTHDAY} %{TIME} %{TZ} %{YEAR}
    DATESTAMP_EVENTLOG %{YEAR}%{MONTHNUM2}%{MONTHDAY}%{HOUR}%{MINUTE}%{SECOND}
    
    # Syslog Dates: Month Day HH:MM:SS
    SYSLOGTIMESTAMP %{MONTH} +%{MONTHDAY} %{TIME}
    PROG (?:[\w._/%-]+)
    SYSLOGPROG %{PROG:program}(?:\[%{POSINT:pid}\])?
    SYSLOGHOST %{IPORHOST}
    SYSLOGFACILITY <%{NONNEGINT:facility}.%{NONNEGINT:priority}>
    HTTPDATE %{MONTHDAY}/%{MONTH}/%{YEAR}:%{TIME} %{INT}
    
    # Shortcuts
    QS %{QUOTEDSTRING:UNWANTED}
    
    # Log formats
    SYSLOGBASE %{SYSLOGTIMESTAMP:timestamp} (?:%{SYSLOGFACILITY} )?%{SYSLOGHOST:logsource} %{SYSLOGPROG}:
    
    MESSAGESLOG %{SYSLOGBASE} %{DATA}
    
    COMMONAPACHELOG %{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{HTTPDATE:timestamp}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{NUMBER:bytes}|-)
    COMBINEDAPACHELOG %{COMMONAPACHELOG} %{QS:referrer} %{QS:agent}
    COMMONAPACHELOG_DATATYPED %{IPORHOST:clientip} %{USER:ident;boolean} %{USER:auth} \[%{HTTPDATE:timestamp;date;dd/MMM/yyyy:HH:mm:ss Z}\] "(?:%{WORD:verb;string} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion;float})?|%{DATA:rawrequest})" %{NUMBER:response;int} (?:%{NUMBER:bytes;long}|-)
    
    
    # Log Levels
    LOGLEVEL ([A|a]lert|ALERT|[T|t]race|TRACE|[D|d]ebug|DEBUG|[N|n]otice|NOTICE|[I|i]nfo|INFO|[W|w]arn?(?:ing)?|WARN?(?:ING)?|[E|e]rr?(?:or)?|ERR?(?:OR)?|[C|c]rit?(?:ical)?|CRIT?(?:ICAL)?|[F|f]atal|FATAL|[S|s]evere|SEVERE|EMERG(?:ENCY)?|[Ee]merg(?:ency)?)

---

## [preparation/processors/holidays-computer]

# Flag holidays

This processor identifies whether a date is a school holiday, a bank holiday or a weekend.

It takes as input a Date column.

It’s worth noting that a Date in DSS corresponds to a point in time, just like a timestamp. Conversely, a holiday is always defined by a timezone-less tuple (year,month,day). Consequently, a timezone must be provided in order to convert this timezone-less representation into a Date.

Although the timezone can be specified explicitly, it may be more convenient to use the country’s default timezone.

Country | Default timezone | Weekend days  
---|---|---  
AE | Asia/Dubai | Saturday, Sunday  
DE | Europe/Berlin | Saturday, Sunday  
ES | Europe/Madrid | Saturday, Sunday  
FR | Europe/Paris | Saturday, Sunday  
IN | Asia/Kolkata | Saturday, Sunday  
OM | Asia/Dubai | Friday, Saturday  
SA | Asia/Riyadh | Friday, Saturday  
US | America/New_York | Saturday, Sunday  
  
## Options

**Input column**

The column containing the date to check.

**Output column prefix**

The prefix to add to output column names.

**Country code**

Choose the country for which to consider holidays and weekends.

**Country’s timezone**

Choose the timezone in which to consider the date, it can be UTC or simply the country’s default timezone.

**Flag bank holidays**

Computes a boolean column that indicates if the date is a bank holiday. Appends `bank` to the **output column prefix**.

**Flag school holidays (FR only)**

Computes a boolean column that indicates if the date is a school holiday. Appends `school` to the **output column prefix**.

**Flag weekends**

Computes a boolean column that indicates if the date falls on a weekend. Appends `weekend` to the **output column prefix**.

**Extract reasons**

Extracts the holiday name (e.g. “Christmas”, “New Year’s Day”) into an array column. This option creates columns only if **Flag bank holidays** or **Flag school holidays** is selected:

  * If **Flag bank holidays** is selected, it appends `bank_reasons` to the **output column prefix** for the newly created column.

  * If **Flag school holidays** is selected, it appends `school_reasons` to the **output column prefix** for the newly created column.




**Extract zones (FR only)**

Extracts the holiday zone (e.g. `"A"`, `"B"`) into an array column. Appends `zones` to the **output column prefix** for the newly created column. Only available if **Flag school holidays** is selected.

---

## [preparation/processors/index]

# Processors reference

This section provides a reference of all preparations processors in DSS. When available, this section includes links to Howto articles indicating concrete use of processors.

---

## [preparation/processors/invalid-split]

# Split invalid cells into another column

This processor takes all values of a column that are invalid for a specific meaning and moves them to another column.

## Example

With the following data:

icol  
---  
42  
Baad  
  
With parameters:

  * Column: icol

  * Column for invalid data: bad_icol

  * Meaning to check: Number The result will be:


icol | bad_icol  
---|---  
42 |   
| Baad

---

## [preparation/processors/join]

# Join with other dataset (memory-based)  
  
Warning

**Deprecated** : Memory-based join processor is deprecated. Use a [dedicated join recipe](<../../other_recipes/join.html>) instead.

This processor performs a left join with another (small) dataset.

## Example use case

You are processing a dataset of events. The events contain a reference to a product id. You have another dataset which contains details about the products, and you want to retrieve the product details for each event.

## Requirements and limitations

The ‘other’ dataset must fit in RAM. A good limit would be that it should not be more than ~500 000 rows. If this is not the case, you should use a recipe to join the datasets (for example, a Hive, Python or SQL recipe).

Both the dataset being processed and the ‘other’ dataset must contain a column containing the join key.

## Behavior details

The processor performs a deduplicated left join:

  * If no rows in the ‘other’ dataset match, joined columns are left empty

  * If multiple rows match in the ‘other’ dataset, the ‘last’ one is selected (but ordering is not guaranteed)




## Parameters

The processor needs the following parameters:

  * Column containing the join key in the current dataset (which may have been generated by a previous step)

  * Name of the dataset to join with. Note that the dataset to join with must be in the same project.

  * Column containing the join key in the joined dataset.

  * Columns from the joined dataset that should be copied to the local dataset, for the matched row.




## Output

The processor outputs selected columns from the joined dataset. For each row of the current dataset, the columns will contain the data from the matching row in the joined dataset.

If no row matched in the joined dataset, the output columns will be left empty.

---

## [preparation/processors/jsonpath]

# Extract with JSONPath

Extract data from a column containing JSON using the JSONPath syntax, and create a new column containing the extracted data.

## Example

JSON object from input column: `{"person":"John","age":24}`

JSONPath expression: `$.age`

Extracted data: `24`

## Options

**Input column**

Column containing the JSON to extract.

**Output column**

Create a new column for output.

**JSONPath expression**

Expression following the syntax in the [JSONPath documentation](<http://goessner.net/articles/JsonPath/>).

**Single value**

Check if the path represents a single value and not an array.

---

## [preparation/processors/long-tail]

# Group long-tail values

This processor merges together all values of a column that are not part of an allow-list of values that should not be merged.

## Use case

The main use case of this processor is to merge all values of a column except the most frequent ones. The merged values are replaced by a generic ‘Others’ value.

---

## [preparation/processors/mean]

# Compute the average of numerical values

This processor computes the line by line arithmetical mean (average) of a set of numeric columns.

For a given line, empty columns will be ignored, the mean will be calculated only over the non-empty columns. If all columns are empty, the result will be either an empty cell or a default value defined in the processor options.

## Columns selection

This processor can compute the mean over multiple columns:

  * An explicit list of columns

  * All columns matching a given pattern




## Examples

  * Mean of `[1, 2, 3]` will be `2`

  * Mean of `[1, 2, ""]` will be `1.5` (the empty cell is ignored)

  * Mean of `["", ""]` will be an empty cell or the default value, depending on the processor options.




Note that the processor doesn’t support non-numeric values: Mean of `[1, 2, "some text"]` may yield an error when the recipe runs, depending on the execution environment.

---

## [preparation/processors/meaning-translate]

# Translate values using meaning

This processor replaces values according to the meaning’s mapping definitions. It requires a ‘Value mapping’ meaning.

---

## [preparation/processors/measure-normalize]

# Normalize measure

This processor normalizes a measurement (mass, volume, surface)

---

## [preparation/processors/merge-long-tail-values]

# Merge long-tail values

This processor merges values below a certain appearance threshold.

---

## [preparation/processors/move-columns]

# Move columns

Select one or more columns and move them either before/after an existing column or at the beginning/end of all columns.

---

## [preparation/processors/negate]

# Negate boolean value

This processor transforms a boolean value to its negation

---

## [preparation/processors/number-clipping]

# Force numerical range

Creates upper and/or lower bounds in one or several numerical columns. This processor always acts in place.

## Options

**Clip outliers**

Replaces outliers with lower and/or upper bounds.

**Clear outliers**

Removes outliers.

---

## [preparation/processors/numerical-combinations]

# Generate numerical combinations

This processor combine every pair of numerical columns with standard `+` `-` `×` `÷` operations.

Operations on empty cells and division by 0 yield empty cells.

---

## [preparation/processors/numerical-format-convert]

# Convert number formats

Convert numbers from one language/country-specific format to another.

## Options

**Column**

Convert numbers in the following columns:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




**Input format**

Number format of input column(s). Decimal numbers are stored in the raw format. Supported formats:

  * Raw: 1234567890.123 (required format for numeric columns fed to other DSS mechanisms)

  * French: 1 234 567 890,123 (also: Canadian, Danish, Finnish, Swedish)

  * English: 1,234,567,890.123 (also: Thai)

  * Italian: 1.234.567.890,123 (also: Norwegian, Spanish)

  * Swiss: 1’234’567’890.123




**Output format**

Number format of output column(s). See supported formats above.

---

## [preparation/processors/object-nest]

# Nest columns

Combine N input columns into a single JSON object column.

## Example

Input:
    
    
    a       b
    1       2
    

Output:
    
    
    {"a": 1, "b": 2}
    

## Options

**Column**

Apply the nest processor to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




**Output column**

Name the created output column. Cannot be left blank.

---

## [preparation/processors/object-unnest-json]

# Unnest object (flatten JSON)

Unnest, or flatten, JSON objects or arrays. By default, arrays are kept untouched.

## Example

The following JSON, `jsoncol = {"firstname": "a", "lastname": "b", "details": { "uid": 237, "comment": " a comment"}`, unnested to 1 level of depth yields:

  * `jsoncol_firstname = a`

  * `jsoncol_lastname = b`

  * `jsoncol_details = {"uid": 237, “comment”: “a comment”}`




## Options

**Input column**

Column containing a JSON object or array.

**Maximum depth**

Limit the depth at which the processor stops unnesting the JSON object or array.

**Flatten arrays**

By default, this processor does not flatten arrays when unnesting JSON. If the column contains a JSON array nested _within_ a JSON object, the JSON array will be preserved as a single column. If the column contains a JSON array at the top level, the processor will do nothing.

Note

Be aware that unnesting large arrays by selecting this option can lead to high memory and CPU consumption.

**Convert null to empty cell**

Convert a null value in a JSON property — flattened as a cell with the string “null” in it — to an empty cell.

**Prefix output columns**

Prefix output column names with the input column name.

---

## [preparation/processors/pattern-extract]

# Extract with regular expression

Extract chunks from a column using a regular expression. Note that regular expressions are not anchored: `([0-9]*)` will capture `232` in `val-232`.

## Options

**Regular expression**

Once the input column is filled, use **Find with Smart Pattern** to help generate a regular expression.

**Capture groups**

Use named or unnamed capture groups to extract distinct chunks into several output columns. Unnamed capture groups use the `(pattern)` syntax and place matches into numbered columns. Named capture groups use the `((?<groupname>pattern)` syntax and place matches into named columns using the group name.

Example, unnamed group:

  * Cell value: `id-37-X234`

  * Pattern: `id-([0-9]*)-([0-9A-Z]*)`

  * Output column prefix: `extracted_`

  * Result: `extracted_1=37 extracted_2=X234`




Example, named group:

  * Cell value: `id-37-X234`

  * Pattern: `id-(?<numidentifier>[0-9]*)-(?<identifier2>[0-9A-Z]*)`

  * Output column prefix: `extracted_`

  * Result: `extracted_numidentifier=37 extracted_identifier2=X234`




**Found column**

Enable this option to create a column name _found_ containing a boolean to indicate whether or not the pattern matched.

**Extract all occurrences**

Enable this option to extract multiple matches of a group into one array.

## Related resources

See [How-To: Extract Patterns With the Smart Pattern Builder](<https://knowledge.dataiku.com/latest/prepare-transform-data/prepare/additional-data-prep/tutorial-smart-pattern-builder.html>) for a detailed example of working with the Smart Pattern Builder.

---

## [preparation/processors/pivot]

# Pivot

Transpose multiple rows into columns, widening the dataset.

Note

Before running a Pivot processor:
    

  * Sort the values of the index column so that identical values are adjacent. If the column is not sorted, the processor may create unneeded index rows.

  * Ensure the data source is not parallel (i.e. single-threaded, e.g. a single file)




## Example

Input:

Company | Type | Value  
---|---|---  
Comp.A | Revenue | 42M  
Comp.A | Raw Margin | 9M  
Comp.B | Revenue | 137M  
Comp.B | Raw Margin | 3M  
Comp.B | Net income | -11M  
  
Pivot with:

  * Index column: Company

  * Labels column: Type

  * Values column: Value




Result:

Company | Revenue | Raw Margin | Net income  
---|---|---|---  
Comp.A | 42M | 9M |   
Comp.B | 137M | 3M | -11M  
  
## Options

**Index column**

Generate a new row for each change of value in the index column.

**Labels column**

Create a column for each value in the label column.

**Values column**

Populate cells with the values of the values column. When several rows have the same index and label, the pivot only keeps the value corresponding to the last row in the output.

**Other columns**

Select how to populate the cells in the other columns:

  * Clear the cells

  * Keep only the first value

  * Retain the value if only one distinct value exists

  * Enclose all values in an array




Example of OK input:

idx1 | label1 | v1  
---|---|---  
idx1 | label2 | v2  
idx2 | label1 | v3  
  
Example of not OK input:

idx1 | label1 | v1  
---|---|---  
idx2 | label1 | v3  
idx1 | label2 | v2  
  
## Related Resources

To build pivot tables with more control over the rows, columns and aggregations, use the [Pivot recipe](<../../other_recipes/pivot.html>).

---

## [preparation/processors/python-custom]

# Python function

Execute a custom Python function for each row and easily perform complex computations in a Prepare script.

## Options

**Mode**

Select one of three modes for the Python function to run. Each option creates a block of starter code to edit with custom logic. You can choose between non-vectorized or vectorized processing if you use a real Python process.

  * Cell: produce a new cell for each row.

    * Non-vectorized: The function receives the data for a row, and must return a single value for each row which is used as the value of the output column.

    * Vectorized: The function receives the input batch of rows as a pandas Dataframe, and must return a pandas Series of the same number of records, which will be used as the values of the output column.

  * Row: return a row for each row.

    * Non-vectorized: The function receives the data for a row as a Python dict, and can modify in place all the values of the row. The function returns a Python dictionary. All columns and values of the input rows are replaced by the keys and values of the dictionary.

    * Vectorized: The function receives the input batch of rows as a pandas Dataframe, and must return a pandas Dataframe of the same number of records, which will be used as the values of the output batch of rows (of the same length).

  * Rows: produce a list of rows for each row.

    * Non-vectorized: The function receives the data for a row, and can output an arbitrary number of output rows. The function returns an iterable list of rows. The input row is deleted and replaced by all rows returned by the function (so you can have 1->N processing).

    * Vectorized: The function receives the input batch of rows as a pandas Dataframe, and must return an indexed dictionary of vectors, either built by modifying the ‘rows’ or by returning a pandas DataFrame.




**Error Column**

Create a new column that will be filled with any error messages raised from the Python code.

**Stop on first error**

Stops the processor execution if an error is raised.

**Pass data as unicode**

Read data as unicode.

**Use a real Python process (instead of Jython)**

Change to Python instead of Jython, a reimplementation of Python in Java, and allow vectorized operation to process rows in batches using the Pandas library.

  * Selection behavior: Choose an environment: Use DSS builtin env, Inherit project default or Select an environment.

  * Used input columns: Add one or more columns to use as input for faster processing.

  * Vectorized processing: When selected the input will change from a python dict to a Pandas Dataframe. This provides much improved performance and is strongly recommended when using a real Python process. Operates based on the Cell, Row and Rows options above using Pandas dataframes.




Note

The Python function is executed by Jython, which supports only Python 2 and for which only the standard Python library is available. To use Python libraries, use the real Python process or a separate Python recipe. When using the real Python process, you can use all normal Python packages and the code defined in [libraries](<../../python/reusing-code.html>).

---

## [preparation/processors/querystring-split]

# Split HTTP Query String

This processor splits the elements of an HTTP query string.

The query string is the part coming after the `?` in the string. For example: `product_id=234&step=3`

## Output

This processor outputs one column for each chunk of the query string. Columns are named with the prefix and the key of the HTTP Query string chunk.

## Example

For input:

qs  
---  
productid=234&step=3  
customer_id=FDZ&action=cart&step=2  
  
With prefix : ‘qs_’, result would be:

qs | qs_product_id | qs_step | qs_customer_id | qs_action  
---|---|---|---|---  
productid=234&step=3 | 234 | 3 |  |   
customer_id=FDZ&action=cart&step=2 |  | 2 | FDZ | cart

---

## [preparation/processors/remove-empty]

# Remove rows where cell is empty  
  
Remove (or keep) rows for which cells in the selected column are empty. When using multiple columns, a row is considered matching if at least one of the selected columns is empty.

## Options

**Column**

Apply check to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns

---

## [preparation/processors/round]

# Round numbers

Round decimal numbers in one or several columns using round, floor, or ceil.

## Options

**Column**

Apply rounding to numbers in the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




**Rounding mode**

Select how to round numbers:

  * Round: Round the number to the specified significant digit.

  * Floor: Round the number down, or toward zero.

  * Ceil: Round the number up, or away from zero.




**Significant digits**

Control the _precision_ of the number. `1234.5` with 2 significant digits is `1200`. Using 0 means the number is unbounded and keeps all significant digits.

**Decimal places**

How many numbers to show after the decimal point. `1.234` with 1 decimal place is `1.2`. Using 0 rounds to the integer; -2 rounds to the hundreds.

---

## [preparation/processors/simplify-text]

# Simplify text

Perform various simplifications on a text column.

## Options

  * **Normalize text** : Transform to lowercase, remove punctuation and accents and perform Unicode NFD normalization (`Café` -> `cafe`).

  * **Stem words:** Transform each word into its “stem”, i.e. its grammatical root. For example, `grammatical` is transformed to `grammat`. This transformation is language-specific.

  * **Clear stop words** : Remove so-called “stop words” (`the`, `I`, `a`, `of`, …). This transformation is language-specific.

  * **Sort words alphabetically:** Sorts all words of the text. For example, `the small dog` is transformed to `dog small the`, allowing strings containing the same words in different order to be matched.




Note

Other processors with text operation — tokenization, n-gram extraction, fuzzy join — benefit from built-in text simplification options. You do not need to perform text simplification separately prior to using them.

---

## [preparation/processors/split-fold]

# Split and fold

This processor splits the values of a column based on a separator and transforms them into several rows.

For example, with the following dataset:

customer_id | events | browser  
---|---|---  
1 | login,product,buy | Mozilla  
2 | login,product,logout | Chrome  
  
Applying “Split and Fold” on the “events” column with “,” as the separator will generate the following result:

customer_id | events | browser  
---|---|---  
1 | login | Mozilla  
1 | product | Mozilla  
1 | buy | Mozilla  
2 | login | Chrome  
2 | product | Chrome  
2 | logout | Chrome  
  
All columns except the folded column are copied in each new line.

For more details on reshaping, please see [Reshaping](<../reshaping.html>).

---

## [preparation/processors/split-into-chunks]

# Split into chunks

This processor splits text into chunks (one row per chunk) using a recursive splitter approach.

## Example use case

You want to perform embedding and semantic search on a corpus of text documents for Retrieval-Augmented Generation (RAG). Splitting the text into smaller chunks ensures that each piece of text can be embedded into a vector store efficiently.

## Output

For each chunk, a new row is generated. The row contains a copy of all other columns in the original row and a new chunk column.

## Options

  * Maximum Chunk Size: Define the maximum number of characters each chunk can contain. This helps to keep chunks within manageable sizes for embedding.

  * Chunk Overlap: Specify the number of characters that should overlap between consecutive chunks. This is useful for ensuring context continuity across chunks.

  * Separators: Specify the separators to consider for splitting the text. By default, the separators are (in the following order) double new lines, new line, space and between any character. The order of separators matters as the processor will apply them sequentially. You can add or remove separators as required.

  * Regular expressions can also be used to specify separators, providing additional flexibility for complex text structures.

  * Keep Separators: you can choose whether the separators should be kept in the output chunks or removed.

---

## [preparation/processors/split-unfold]

# Split and unfold

This processor splits the values of a column based on a separator and transforms them into several binary columns. Also called ‘dummification’.

You can prefix new columns by filling the “Prefix” option.

You can choose the maximum number of columns to create with the “Max nb. columns to create” option.

For example, with the following dataset:

customer_id | events  
---|---  
1 | login, product, buy  
2 | login, product, logout  
  
We get:

customer_id | events_login | events_product | events_buy | events_logout  
---|---|---|---|---  
1 | 1 | 1 | 1 |   
2 | 1 | 1 |  | 1  
  
The unfolded column is deleted.

Warning

**Limitations**

The limitations that apply to the [Unfold](<unfold.html#unfold>) processor also apply to the Split and Unfold processor.

For more details on reshaping, please see [Reshaping](<../reshaping.html>).

---

## [preparation/processors/split]

# Split column

Split a column into several columns on each occurrence of the delimiter. The output columns are numbered: The first chunk will be in prefix_0, the second in prefix_1, and so on.

## Examples

  * Split `col=a/b/c` using `/` as the delimiter and `chunk` as the output column prefix

>     * Output: `chunk_0=a`, `chunk_1=b`, `chunk_3=c`

  * Split `col=a/b/c` using `/` as the delimiter, `chunk` as the output column prefix, and keep 2 columns from the beginning

>     * Output: `chunk_0=a`, `chunk_1=b`




## Options

**Delimiter**

Separates values from each input column within the output.

**Output columns prefix**

Add a prefix to identify the output columns.

**Output as**

Output the result(s) of the split as separate columns or as an array (`A-B` → `["A",”B”]`).

**Truncate**

Limit the number of output columns and keep only the first N columns or the N last columns.

**Keep empty chunks**

Preserve empty chunks between consecutive delimiters. (`App`, delimiter `p` → `["A", “”, “”]`)

---

## [preparation/processors/string-transform]

# Transform string

Perform a variety of encoding, decoding, and string transformations on one or several columns. Transformations are always done in-place. For more advanced transformations, use the [Formula processor](<https://doc.dataiku.com/dss/latest/preparation/processors/formula.html>).

## Options

**Column**

Apply transformation to the following:

  * A single column

  * An explicit list of columns

  * All columns matching a regex pattern

  * All columns




**Mode**

Select transformation to apply:

  * **Convert to uppercase/lowercase:** convert all text to upper or lower case

  * **Encode/decode URL:** form URL escape (`nice 7%` -> `nice%207%25`) or unescape (`nice%207%25` -> `nice 7%`)

  * **Escape/unescape XML entities:** replace `&lt;`, `&gt;`, and `&amp;` by `<`, `>` and `&` respectively in XML strings

  * **Escape/unescape Unicode values:** replace Unicode characters by their codepoint: `é` -> `\u00e9` or the opposite

  * **Remove leading/trailing whitespace** : trim

  * **Capitalize:** put a capital letter at the beginning of each cell

  * **Capitalize every word:** put a capital letter at the beginning of each word in the cell

  * **Normalize:** convert to lowercase, remove accents, and perform Unicode normalization (`Café` -> `cafe`)

  * **Truncate:** keep only the first N characters of the cell

---

## [preparation/processors/switch-case]

# Switch case

This processor applies rules to compute a new column based on the input column values.

## Rules

Rules are defined as a list of key-value pairs. When a key is found in the input column, the corresponding value is set in the output column. If a column row matches no key, the value for unmatched row is empty by default. You can set a default value in the `Value for unmatched rows` field. In order to add as many matching conditions as necessary, click on the `ADD RULE` plus icon.

Note

The matching between column values and key values is based on a strict equality comparison.

## Normalization modes

By setting the normalization mode, you can specify whether you want the processor to perform:

  * Case-sensitive matches (‘Exact’ mode)

  * Case-insensitive matches (‘Lowercase’ mode)

  * Accents-insensitive matches (‘Normalize’ mode)

---

## [preparation/processors/tokenizer]

# Tokenize text

This processor tokenizes (splits in words) a text column.

## Example use case

You want to perform statistics on the words used in a product catalog or query log. Tokenization allows you to handle words separately.

## Output

The tokenizer offers several output modes:

  * Convert to array: An array (JSON-formatted) containing the words is generated, either in the input column or in another column. This mode is most useful if you intend to perform some custom processing and need to retain the structure of the original text.

  * One token per row: in this mode, for each token, a new row is generated. The row contains a copy of all other columns in the original row. This mode is most useful if you intend to group by word afterwards.

  * One token per column: in this mode, a new column is generated for each token. For example, if a column contains 4 words, and you use ‘out_’ as prefix, columns ‘out_0’, ‘out_1’, ‘out_2’ and ‘out_3’ will be generated.




## Simplification

Very often, you’ll want to simplify the text to remove some variance in your text corpus. This processor offers several possible simplifications on the text to tokenize.

  * Normalize text: transforms to lowercase, removes accents and performs Unicode normalization (Café -> cafe)

  * Clear stop words: remove so-called ‘stop words’ (the, I, a, of, …). This transformation is language-specific and requires you to enter the language of your column.

  * Stem words: transforms each word into its ‘stem’, ie its grammatical root. For example, ‘grammatical’ is transformed to ‘grammat’. This transformation is language-specific and requires you to enter the language of your column.

  * Sort words alphabetically: sorts all words of the text. For example, ‘the small dog’ is transformed to ‘dog small the’. This allows you to match together strings that are written with the same words in a different order.

---

## [preparation/processors/transpose]

# Transpose rows to columns

This processor turns rows to columns. It is limited currently to 100 rows as input (and columns as output)

---

## [preparation/processors/triggered-unfold]

# Triggered unfold

This processor is used to reassemble several rows when a specific value is encountered.

It is useful for analysis of “interaction sessions” (a series of events with a specific event marking the beginning of a new interaction session). For example, while analyzing the logs of a web game, the “start game” event would be the beginning event.

Warning

**Limitations**

Triggered unfold offers a a basic session analysis that is very simple to use, but it comes with many limitations.

Triggered unfold assumes that the input data is sorted by time. It only works on “unsplitted” datasets (for example, a single file or a SQL table)

Non-terminated sessions are kept in memory. It is recommended that you do not use Triggered Unfold if you have more than a few thousands sessions

For more advanced sessions analysis, if you have splitted data or a large number of sessions, you should use specific recipes (for example, using SQL)

For example, let’s imagine this dataset:

user_id | event_type | timestamp  
---|---|---  
user_id1 | login_event | t1  
user_id2 | login_event | t2  
user_id1 | event_type2 | t3  
user_id2 | event_type2 | t4  
user_id1 | login_Event | t5  
user_id2 | event_type3 | t6  
user_id2 | login_event | t7  
  
We know that “login_event” marks the beginning of a new session / new interaction, and we want to track the timestamps of other event types in each session.

We apply a “Triggered unfold” with the following parameters:

  * Column acting as event key: user_id

  * Fold column: event_type

  * Trigger value: login_event

  * Column with data: timestamp




We generate the following result:

user_id | login_event | event_type2 | event_type3 | login_event_prev  
---|---|---|---|---  
user_id1 | t1 | t3 |  |   
user_id2 | t2 | t4 | t6 |   
user_id1 | t5 |  |  | t1  
user_id2 | t7 |  |  | t2  
  
We get:

  * One column for each type of event

  * One line for each occurence of “login_event” in the stream

  * The user_id associated to each login_event is kept, and the timestamps of events are restored

  * The “_prev” column tracks the data associated to the previous occurence of “login_event” for each user_id.




For more details on reshaping, please see [Reshaping](<../reshaping.html>).

---

## [preparation/processors/unfold-array]

# Unfold an array

This processor takes a column containing JSON-formatted arrays and transforms it into several columns, containing the number of occurrences of each term of the array.

You can prefix new columns by filling the “Prefix” option.

You can choose the maximum number of columns to create with the “Max nb. columns to create” option.

You can transform the original column into binary columns by unchecking the “Count of Values” option.

For example, with the following dataset:

id | words  
---|---  
0 | [‘hello’, ‘hello’, ‘world’]  
1 | [‘hello’, ‘world’]  
2 | [‘hello’]  
3 | [‘world’, ‘world’]  
  
Applying the “Unfold an array” processor on the “words” column will generate the following result:

id | words | words_hello | words_world  
---|---|---|---  
0 | [‘hello’, ‘hello’, ‘world’] | 2 | 1  
1 | [‘hello’, ‘world’] | 1 | 1  
2 | [‘hello’] | 1 |   
3 | [‘world’, ‘world’] |  | 2  
  
Each value of the unfolded column will create a new column. This new column:

  * contains the number of occurrences of the value found in the original column,

  * remains empty if the original column does not contain this value.




Warning

**Limitations**

The limitations that apply to the [Unfold](<unfold.html#unfold>) processor also apply to the Unfold an array processor.

For more details on reshaping, please see [Reshaping](<../reshaping.html>).

---

## [preparation/processors/unfold]

# Unfold

This processor transforms the values of a column into several binary columns. Also called ‘dummification’, creation of ‘dummy columns’ or one-hot encoding.

You can prefix new columns by filling the “Prefix” option.

You can choose the maximum number of columns to create with the “Max nb. columns to create” option.

For example, with the following dataset:

id | type  
---|---  
0 | A  
1 | A  
2 | C  
3 | B  
  
Applying the “Unfold” processor on the “type” column will generate the following result:

id | type_A | type_C | type_B  
---|---|---|---  
0 | 1 |  |   
1 | 1 |  |   
2 |  | 1 |   
3 |  |  | 1  
  
Each value of the unfolded column will create a new column. This new column:

  * contain the value “1” if the original column contained this value

  * remains empty else.




Unfolding is often used to find some correlations to a particular value, or for creating graphs.

Warning

**Limitations**

The Unfold processor dynamically creates new columns based on the actual data within the cells.

Due to the way the schema is handled when you create a preparation recipe, only the values that were found at least once in the sample will create columns in the output dataset.

Unfolding a column with a large number of values will create a large number of columns. This can cause performance issues. It is highly recommended not to unfold columns with more than 100 values, or to limit the number of created columns with the “Max nb. columns to create” option.

For more details on reshaping, please see [Reshaping](<../reshaping.html>).

---

## [preparation/processors/unixtimestamp-parser]

# Convert a UNIX timestamp to a date

Convert a UNIX timestamp (number of seconds or number of milliseconds since Epoch — January 1, 1970) into a column containing ISO-8601 formatted dates.

## Option

**Treat input as milliseconds**

By default, the conversion between UNIX and ISO-8601 is done in milliseconds. Deselect to treat input as seconds.

---

## [preparation/processors/up-down-fill]

# Fill empty cells with previous/next value

Fill empty cells in column(s) with the previous or next non-empty value.

## Example

Values | Fill with previous | Fill with next  
---|---|---  
A | A | A  
| A | B  
B | B | B  
| B |   
  
## Options

When filling with previous value, you can specify multiple columns. When filling with next value, you can use only a single column.

---

## [preparation/processors/url-split]

# Split URL (into protocol, host, port, …)

This processor splits the elements of an URL into multiple columns

A valid URL is in the form `scheme://hostname[:port][/path][?querystring][#anchor]`

The output values are produced in columns prefixed by the input column name.

If the input does not contain a valid URL, no output value is produced. # Examples * `http://www.google.com/search?q=query#results` * `ftp://ftp.server.com/pub/downloads/myfile.tar.gz`

---

## [preparation/processors/user-agent]

# Classify User-Agent

This processor parses and extracts information from a browser’s User-Agent string.

The following columns are created and may or may not be filled depending on the user agents:

  * ‘type’: one of:




>   * ‘browser’ (desktop OS)
> 
>   * ‘tablet’
> 
>   * ‘phone’
> 
>   * ‘mobile’ (could be either a tablet or phone)
> 
>   * ‘bot’ (crawlers, spam, …)
> 
>   * ‘library’ (wget, urllib2, …)
> 
>   * ‘rss’ : RSS feed readers
> 
>   * ‘unknown’
> 
> 


  * ‘brand’: Chrome, Firefox, Safari, Android, …

  * ‘category’: Quite like brand, but tries to distinguish browsers of the same brand that behave differently. For example, IE8 and IE9 are the same brand, but different categories

  * ‘version’

  * ‘os’ : Operating system

  * ‘osversion’ : Version of the Operating system

  * ‘osflavor’ : Variant of the Operating System (Linux distribution, 32/64 bits, …)

---

## [preparation/processors/visitor-id]

# Generate a best-effort visitor id

This processor generates visitor identifiers for web logs that don’t already have one.

When processing web logs, it is often required to have a unique identifier for each visitor.

When processing logs coming from a full-featured web tracker, like [Dataiku’s WT1](<https://github.com/dataiku/wt1/wiki>), each log line already features a unique visitor id.

However, when processing more raw logs, like Apache Access logs, you generally don’t have one. It is also possible to have no visitor id if the visitor disabled cookies.

This processor will try to assign a visitor-id to each line, using as much information to identify the visitor as possible. You need to specify a name for the output column, and to fill information about which columns are available. All input columns are optional.

This processor will try to use:

  * The IP address

  * The user-agent string

  * The language of the user’s browser

  * The timezone offset of the user’s browser # Important note Although these information will often lead to uniquely identifying each visitor (especially for home users), this is a best-effort and some collisions (two distinct visitors being assigned the same id) will happen, especially for visitors from large companies.

---

## [preparation/processors/zip-arrays]

# Zip JSON arrays

This processor combines N input columns containing arrays (as JSON) into a single output column.

The output column will contain JSON arrays of objects.

## Example

  * Input:



    
    
    a       b
    [1,2]   ["x","y"]
    

  * Output:



    
    
    [{"a":1, "b":"x"} , {"a":2, "b":"y"}]

---

## [preparation/reshaping]

# Reshaping

Reshaping processors are used to change the « shape » (rows/columns) of the data.

DSS provides the following reshaping processors

## Split and Fold

The [Split and fold](<processors/split-fold.html>) processor creates new lines by splitting the values of a column.

For example, with the following dataset:

customer_id | events | browser  
---|---|---  
1 | login,product,buy | Mozilla  
2 | login,product,logout | Chrome  
  
Applying “Split and Fold” on the “events” column with “,” as the separator will generate the following result:

customer_id | events | browser  
---|---|---  
1 | login | Mozilla  
1 | product | Mozilla  
1 | buy | Mozilla  
2 | login | Chrome  
2 | product | Chrome  
2 | logout | Chrome  
  
More details are available in the [reference](<processors/split-fold.html>)

## Fold multiple columns

The [Fold multiple columns](<processors/fold-columns-by-name.html>) processor takes values from multiple columns and transforms them to one line per column.

For example, with the following dataset representing monthly scores:

person | age | 01/2014 | 02/2014 | 03/2014  
---|---|---|---|---  
John | 24 | 3 | 4 | 3  
Sidney | 31 |  | 6 | 9  
Bill | 33 | 1 |  | 4  
  
We would like to get one line per (month, person) couple with the score.

Applying the processor with:

  * 3 columns in the “columns list”: 01/2014, 02/2014, 03/2014

  * “month” as the “fold name column”

  * “score” as the “fold value column”




will generate the following result:

person | age | month | score  
---|---|---|---  
John | 24 | 01/2014 | 3  
John | 24 | 02/2014 | 4  
John | 24 | 03/2014 | 6  
Sidney | 31 | 01/2014 |   
Sidney | 31 | 02/2014 | 6  
Sidney | 31 | 03/2014 | 9  
Bill | 33 | 01/2014 | 1  
Bill | 33 | 02/2014 |   
Bill | 33 | 03/2014 | 4  
  
More details are available in the [reference](<processors/fold-columns-by-name.html>)

## Fold multiple columns by pattern

This processor is a variant of Fold multiple columns, where the columns to fold are specified by a pattern instead of a list. The processor only creates lines for non-empty columns.

For example, using “tag_(.*)” as column to fold pattern :

name | n_connection | tag_1 | tag_2 | tag_3  
---|---|---|---|---  
Florian | 16570 | bigdata | python | puns  
  
becomes

name | n_connection | tag | rank  
---|---|---|---  
Florian | 16570 | bigdata | 1  
Florian | 16570 | python | 2  
Florian | 16570 | puns | 3  
  
More details are available in the [reference](<processors/fold-columns-by-pattern.html>)

## Unfold

This processor transforms cell values into binary columns.

For example, with the following dataset:

id | type  
---|---  
0 | A  
1 | A  
2 | C  
3 | B  
  
Applying the “Unfold” processor on the “type” column will generate the following result:

id | type_A | type_C | type_B  
---|---|---|---  
0 | 1 |  |   
1 | 1 |  |   
2 |  | 1 |   
3 |  |  | 1  
  
Each value of the unfolded column will create a new column. This new column:

  * contain the value “1” if the original column contained this value

  * remains empty else.




Unfolding is often used to find some correlations to a particular value, or for creating graphs.

Warning

**Limitations**

The Unfold processor dynamically creates new columns based on the actual data within the cells.

Due to the way the schema is handled when you create a preparation recipe, only the values that were found at least once in the sample will create columns in the output dataset.

Unfolding a column with a large number of values will create a large number of columns. This can cause performance issues. It is highly recommended not to unfold columns with more than 100 values, or to limit the number of created columns with the “Max nb. columns to create” option.

More details are available in the [reference](<processors/unfold.html>)

## Unfold an array

This processor transforms array values into occurrence columns.

For example, with the following dataset:

id | words  
---|---  
0 | [‘hello’, ‘hello’, ‘world’]  
1 | [‘hello’, ‘world’]  
2 | [‘hello’]  
3 | [‘world’, ‘world’]  
  
Applying the “Unfold an array” processor on the “words” column will generate the following result:

id | words | words_hello | words_world  
---|---|---|---  
0 | [‘hello’, ‘hello’, ‘world’] | 2 | 1  
1 | [‘hello’, ‘world’] | 1 | 1  
2 | [‘hello’] | 1 |   
3 | [‘world’, ‘world’] |  | 2  
  
Each value of the unfolded column will create a new column. This new column:

  * contains the number of occurrences of the value found in the original column,

  * remains empty if the original column does not contain this value.




Warning

**Limitations**

The limitations that apply to the [Unfold](<processors/unfold.html#unfold>) processor also apply to the Unfold an array processor.

More details are available in the [reference](<processors/unfold-array.html>)

## Split and Unfold

This processor splits multiple values in a cell and transforms them into columns.

For example, with the following dataset:

customer_id | events  
---|---  
1 | login, product, buy  
2 | login, product, logout  
  
We get:

customer_id | events_login | events_product | events_buy | events_logout  
---|---|---|---|---  
1 | 1 | 1 | 1 |   
2 | 1 | 1 |  | 1  
  
The unfolded column is deleted.

Warning

**Limitations**

The limitations that apply to the [Unfold](<processors/unfold.html#unfold>) processor also apply to the Split and Unfold processor.

More details are available in the [reference](<processors/split-unfold.html>)

## Triggered Unfold

This processor is used to reassemble several rows when a specific value is encountered. It is useful for analysis of “interaction sessions” (a series of events with a specific event marking the beginning of a new interaction session). For example, while analyzing the logs of a web game, the “start game” event would be the beginning event.

More details are available in the [reference](<processors/triggered-unfold.html>)

---

## [preparation/sampling]

# Sampling

When exploring and preparing data in DSS, you always get immediate visual feedback, no matter how big the dataset that you are manipulating. To achieve this, DSS works on a sample of your dataset.

In the visual data preparation, all transformation steps that you define are executed on the sample and the results are presented to you right away. When you export the processed data or create a recipe to insert your preparation script in your data flow, the whole input dataset is processed.

When you create a new visual data preparation (either in a visual analysis or a prepare recipe), by default, the sample that was used in the “Explore” part is kept.

For more information about sampling for exploration and data preparation, please see [Sampling](<../explore/sampling.html>).