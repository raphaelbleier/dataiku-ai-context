# Dataiku Docs — metrics-data-quality

## [metrics-check-data-quality/checks]

# Checks

The checks system in DSS allows you to automatically run checks on Flow items (managed folders, saved models and evaluation stores). The checks system is integrated with the metrics system in that checks have access to the last values of the metrics of the Flow item they check.

Checks run as part of a build and returning an ERROR status will fail the build. On partitioned folders, the checks can be computed either on a per-partition basis or on the whole dataset.

Note

Checks are often used in conjunction with scenarios but are not strictly dependent on scenarios.

Note

For datasets, checks are replaced by [Data Quality rules](<data-quality-rules.html>)

Examples of checks on a managed folder include:

  * The duration of the build for the folder stays below 5 min

  * The file count is not 0 (i.e., the folder is not empty)

  * The total size of the folder is less / more than 1 GB




Checks are configured in the _Status_ tabs of managed folders, saved models and evaluation stores, and changes are automatically tracked over time.

## Checks

A check is a condition of some value(s), and the result of the execution of a check is a pair of:

  * an outcome: “OK”, “ERROR” or “WARNING”. A fourth outcome “EMPTY” is used to indicate that the condition could not be evaluated because the value is missing.

  * an optional message.




Each execution of the check produces one outcome. The value is recorded and associated to the name

### Numeric range check

A numeric range check asserts that the value of a metric is within a given range and/or within a given soft range:

  * value below minimum : ERROR

  * value below soft minimum : WARNING

  * value in range : OK

  * value above soft maximum : WARNING

  * value above maximum : ERROR




### Value in set check

A value in set check asserts that the value of a metric is in a given list of admissible values.

### Python check

You can also write a custom check in Python.

## Checks display UI

The value of checks can be viewed in the “Status” tab of a managed folder, saved model or evaluation store.

Since there can be a lot of checks on an item, you must select which checks to display, by clicking on the `X/Y checks` button

There are two check views:

  * A “list” view which displays the history of all selected checks.

  * A “table” view which displays the latest value of each selected check.

---

## [metrics-check-data-quality/custom_metrics_and_checks]

# Custom probes and checks

The predefined probes and checks handle simple cases, and more complex computations can be done using custom probes and custom checks. These are python functions, and run with access to the DSS [Python](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)").

## Custom probe

A custom python probe is a function taking the dataset or folder as parameter and returning values.

### Return values

The function can return a single value, in which case the metric gets the generic name “value”:
    
    
    def process(dataset):
        return dataset.get_dataframe().shape[1]
    

A custom probe can also compute several values in one pass, and return them as a dictionary of name to value:
    
    
    def process(dataset):
        df = dataset.get_dataframe()
        return {'num_rows' : df.shape[0], 'num_cols' : df.shape[1]}
    

DSS automatically infers the type of the metric’s value, among DOUBLE, BOOLEAN, BIGINT, STRING and ARRAY, but in some cases one wants to explicitly specify the type. For example, to get a ISO-formatted UTC timestamp recognized as a date, one has to pass the metric value under the form of a pair of (value, type)
    
    
    from datetime import datetime as dt
    from dataiku.metric import MetricDataTypes
    
    def process(dataset):
        now = dt.strftime(dt.now(), '%Y-%m-%dT%H:%M:%SZ')
        return {'now_as_string' : now, 'now_as_date' : (now, MetricDataTypes.DATE)}
    

### Partitioned datasets

For partitioned datasets, the function of the custom probe receives a second parameter: the partition on which the computation is requested. When the computation is requested on the full dataset and not on just one partition, the value passed is “ALL”.

## Custom check / Custom Data Quality rule

A custom check or Data Quality rule is a function taking the folder, saved model, model evaluation store or dataset as parameter and returning a check or rule outcome.

Note

It is advised to name all custom checks in order to distinguish the values they produce in the checks display, because custom checks can’t auto-generate a meaningful name.

If appropriate, a message can be returned as a second return value.
    
    
    def process(last_values, dataset):
        if dataset.name == 'PROJ.a_dataset':
            return 'OK'
        else:
            return 'ERROR', 'not the expected dataset'
    

The last values of each metric for the dataset, folder or saved model are passed as the first parameter. This parameter is a dict of metric identifier to metric data point.
    
    
    def process(last_values):
        if int(last_values['basic:COUNT_FILES'].get_value()) > 10:
            return 'OK'
        else:
            return 'ERROR', 'not enough files'
    

Here’s another example of a custom check that compares the max value of the dataset column `order_date` to the last build date for the dataset. Note that in the _Metrics_ tab, the “Column statistics” metric for the dataset column `order_date` is set to `MAX` in this example. This makes the metric value `last_values['col_stats:MAX:order_date']` available in our custom check.
    
    
    from datetime import datetime, timedelta
    
    def process(last_values):
        build_start_date = last_values['reporting:BUILD_START_DATE'].get_value()
        max_data_timestamp = last_values['col_stats:MAX:order_date'].get_value()
    
        # turn our values into datetime objects to allow us to use datetime functions
        build_date_datetime = datetime.strptime(build_start_date, "%Y-%m-%dT%H:%M:%S.%fZ")
        max_timestamp_datetime = datetime.strptime(max_data_timestamp, "%Y-%m-%dT%H:%M:%S.%fZ")
    
        # flag if the difference is greater than 1 day
        if build_date_datetime > max_timestamp_datetime + timedelta(days=1):
            return 'ERROR'
        else:
            return 'OK', build_date_formatted.isoformat()

---

## [metrics-check-data-quality/data-quality-rules]

# Data Quality Rules

The Data Quality mechanism in Dataiku allows you to easily ensure that your data meets quality standards and automatically monitor the status of your data quality across datasets, projects, and your entire Dataiku instance.

A Data Quality rule tests whether a dataset satisfies set conditions. The computation of a rule yields:

  * a status outcome: “Ok”, “Error” or “Warning”. A less common outcome “Empty” is used to indicate that the condition could not be evaluated because the value is missing.

  * an observed value with further detail. This parameter is optional for custom rules.




Each execution of a rule produces one outcome. Note that if the rule has not yet been computed, the status is “Not Computed”.

Note

The Data Quality mechanism is an improvement introduced in DSS 12.6.0 over the [checks](<checks.html>) system. Data quality rules allow you to specify expectations for datasets in a more streamlined way, and improve reporting of the results via specific dashboards. Other flow objects (managed folders, saved models, model evaluation store) still use checks.

Examples of simple Data Quality rules include:

  * The record count of a dataset is above 0 (i.e., the dataset is not empty)

  * The most frequent value of a column is ‘Y’

  * A column’s values are at most 10% empty




Data Quality rules are configured in the _Data Quality_ tab of a dataset, where you can also easily track the evolution of your dataset’s data quality over time.

## Data Quality rule types

### Column min in range

Ensures that a column’s minimum value falls within a given range.

Options:

  * the column(s) to check

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Column min is within its typical range

Ensures that a column's minimum value has not deviated from its typical values within a given time window.

Options:

  * the column(s) to check

  * the change detection parameters




### Column avg in range

Ensures that a column’s average value falls within a numeric range.

Options:

  * the column(s) to check

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Column avg is within its typical range

Ensures that a column's average value has not deviated from its typical values within a given time window.

Options:

  * the column(s) to check

  * the change detection parameters




### Column max in range

Ensures that a column’s maximum value falls within a given range.

Options:

  * the column(s) to check

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Column max is within its typical range

Ensures that a column's maximum value has not deviated from its typical values within a given time window.

Options:

  * the column(s) to check

  * the change detection parameters




### Column sum in range

Ensures that a column’s sum falls within a given range.

Options:

  * the column(s) to check

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Column sum is within its typical range

Ensures that a column's sum value has not deviated from its typical values within a given time window.

Options:

  * the column(s) to check

  * the change detection parameters




### Column median in range

Ensures that a column’s median falls within a given range.

Options:

  * the column(s) to check

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Column median is within its typical range

Ensures that a column's median value has not deviated from its typical values within a given time window.

Options:

  * the column(s) to check

  * the change detection parameters




### Column std dev in range

Ensures that a column’s standard deviation falls within a given range.

Options:

  * the column(s) to check

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Column std dev is within its typical range

Ensures that a column's standard deviation value has not deviated from its typical values within a given time window.

Options:

  * the column(s) to check

  * the change detection parameters




### Column values are not empty

Ensures that a column does not contain empty values.

Options:

  * the column(s) to check

  * the threshold type - you can verify that all values are non-empty, or that at most a certain number / proportion are empty

  * the expected soft maximum / maximum for empty values (if threshold type is not all values)




Note

The definition of empty values when computing the rule using a SQL engine is different than when using the stream engine. With a SQL engine, only NULL is considered as an empty value. To also consider empty strings “”, make sure to only activate the stream engine in the rules computation settings.

### Column values are empty

Ensures that a column contains empty values.

Options:

  * the column(s) to check

  * the threshold type: you can verify that all values / at least a certain number of values / at least a certain proportion of values are empty

  * the expected soft minimum / minimum for empty values (if threshold type is not all values)




Note

The definition of empty values when computing the rule using a SQL engine is different than when using the stream engine. With a SQL engine, only NULL is considered as an empty value. To also consider empty strings “”, make sure to only activate the stream engine in the rules computation settings.

### Column empty value is within its typical range

Ensures that a column's empty value count has not deviated from its typical values within a given time window.

Options:

  * the column(s) to check

  * the change detection parameters




Note

The definition of empty values when computing the rule using a SQL engine is different than when using the stream engine. With a SQL engine, only NULL is considered as an empty value. To also consider empty strings “”, make sure to only activate the stream engine in the rules computation settings.

### Column values are unique

Ensures that a column’s values are unique (no duplicates). Empty values are ignored (e.g. a column with 50% empty values will only check the uniqueness of the non-empty values).

Options:

  * the column(s) to check

  * the threshold type: you can verify that all values / at least a certain number of values / at least a certain proportion of values are unique

  * the expected soft minimum / minimum for unique values (if threshold type is not all values)




### Column unique value is within its typical range

Ensures that a column's unique value count has not deviated from its typical values within a given time window.

Options:

  * the column(s) to check

  * the change detection parameters




### Column values in set

Ensures all values in a column are in a given set. Empty values are ignored.

Options:

  * the column(s) to check

  * the list of values that are expected to contain all values from each selected column of the dataset




### Column values in range

Ensures all values in a column fall within a given range. Empty values are ignored.

Options:

  * the column(s) to check

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Column top N values in set

Ensures that a column’s N most frequent values fall into a given set. Empty values are ignored (the rule will check the N most frequent non-empty values).

Options:

  * the column(s) to check

  * the number of top values to check (must be less than 100)

  * the list of values that are expected to contain the N most frequent values from each selected column of the dataset




### Column most frequent value in set

Ensures that a column’s most common value is in a given set. Empty values are ignored (e.g. most frequent value cannot be empty).

Options:

  * the column(s) to check

  * the list of values that are expected to contain the most frequent value from each selected column of the dataset




### Column values are valid according to meaning

Ensures that a column’s values are consistent with a [meaning](<../schemas/meanings-list.html>)

Options:

  * the column(s) to check

  * for each selected column, the meaning to use to assert validity. You can either:

>     * use the option “Use meaning from schema” that will use the meaning specified by the dataset’s schema. This option allows the rule to adapt to changes to the column’s meaning, but requires the meaning to be locked in the schema, which you can do by manually selecting it from the dropdown in the Explore tab
> 
>     * explicitly select a meaning in the list. The rule will always check validity according to the selected meaning

  * the threshold type - you can verify that all values / at least a certain number / at least a certain proportion are valid

  * consider empty as valid - by default, empty cells are considered as invalid. If this option is checked, they will be considered as valid

  * the expected soft minimum / minimum for valid values (if threshold type is not all values)




### Metric value in range

Ensures that a DSS metric’s value falls within a given range.

Options:

  * the metric to test

  * auto-compute metric - if checked, when the rule is run, it will recompute the metric value. Otherwise, it will use the most recent value

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Metric value in set

Ensures that a DSS metric’s value is in a given set of values.

Options:

  * the metric to test

  * auto-compute metric - if checked, when the rule is run, it will recompute the metric value. Otherwise, it will use the most recent value

  * the list of allowed values




### Metric value is within its typical range

Ensures that a DSS metric value has not deviated from its typical values within a given time window.

Options:

  * the metric to test

  * auto-compute metric - if checked, when the rule is run, it will recompute the metric value. Otherwise, it will use the most recent value

  * the change detection parameters




### File size in range

Ensures that a dataset’s file size (in bytes) falls within a given range. Only available for a file-based dataset.

Options:

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Record count in range

Ensures that a dataset’s row count falls within a given range.

Options:

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Record count is within its typical range

Ensures that a dataset's row count has not deviated from its typical values within a given time window.

Options:

  * the change detection parameters




### Column count in range

Ensures that a dataset’s column count falls within a given range.

Options:

  * the expected range (minimum / soft minimum / soft maximum / maximum)




### Column count is within its typical range

Ensures that a dataset's column count has not deviated from its typical values within a given time window.

Options:

  * the change detection parameters




### Dataset schema equals

Ensures that a dataset [schema](<../schemas/index.html>) matches an expected schema.

At rule creation, the expected schema is set to the current schema of the dataset. You can then edit existing columns (name, type, meaning), remove columns, or add new columns to the expected schema. You can change column order by clicking the up or down arrows. At any point, you can reset the expected schema to the current schema of the dataset with the “Reset to current schema” button.

The rule will return “Error” if an expected column is missing from the dataset, has a different type, has a different meaning, is in a different order than expected, or if an unexpected column is present in the dataset. If the column type is “complex” (array, map, object), the rule will recursively check the sub-fields. Strings are furthermore checked for maximum length, with default “-1” value for infinite length.

The rule outcome is ranked by “Index”, which corresponds to the index in the expected schema. Unexpected columns are added at the end of the list.

Options:

  * columns names

  * columns types

  * columns meanings: “Any” means that the column meaning is not checked, otherwise you can select a meaning from the list of available meanings

  * columns order




### Dataset schema contains

Ensures that a dataset [schema](<../schemas/index.html>) contains an expected schema.

At rule creation, the expected schema is set to the current schema of the dataset. You can then edit existing columns (name, type, meaning), remove columns, or add new columns to the expected schema. At any point, you can reset the expected schema to the current schema of the dataset with the “Reset to current schema” button.

The rule will return “Error” if an expected column is missing from the dataset, or has a different type or meaning. If the column type is “complex” (array, map, object), the rule will recursively check the sub-fields. Strings are furthermore checked for maximum length, with default “-1” value for infinite length.

Note

Unlike the Dataset schema equals rule, columns order does not matter here.

The rule outcome is ranked by “Index”, which corresponds to the index in the expected schema.

Options:

  * columns names

  * columns types

  * columns meanings: “Any” means that the column meaning is not checked, otherwise you can select a meaning from the list of available meanings




### Python code

You can also write a custom rule in Python. This rule is equivalent to the “Python check”, so the same code can be used.

The Python method must return a tuple of two strings:

  * the first value is the outcome ‘Ok’, ‘Warning’ or ‘Error’

  * the second value is the optional observed value message




If there are any errors during the Python code execution, the rule will return an “Error” status.

Options:

  * The code env to use to run the python code

  * the python code itself




### Compare values of two metrics

Compares a metric from the current dataset to a metric from the current dataset or another.

Options:

  * the primary metric (from the current dataset)

  * auto-compute primary metric - if checked, when the rule is run, it will recompute the primary metric value. Otherwise, it will use the most recent value.

  * an operator describing which comparison must be done.

  * the comparison dataset, eg the dataset in which you pick the comparison metric. Using the current dataset is supported.

  * the comparison metric, to be compared with the primary metric




Note

The behavior or the comparison depends on the type of metrics manipulated. If both metrics are numeric, comparison is done using the numerical order. If one or more of the two metrics are non-numeric, comparison will be done using the alphabetical order.

### Plugin rules

You can use a plugin to define rules via Python code, using a similar syntax to the Python rule. Existing plugin checks are valid plugin rules. See [custom metrics and checks](<custom_metrics_and_checks.html>)

## Rule configuration

The below settings are available for both partitioned and non-partitioned datasets. Note that partitioned datasets have additional settings which you can read about below.

### Testing the rule

The Test button in the rule edition panel allows you to check the rule outcome, but does not save the result or update the status of the rule. When the rule relies on the computation of an underlying metric, it will also not save its result in the dataset metric history.

### Hard and soft minimums and maximums

Some rules check whether a specific numeric value falls within a given range. For these rules, you can configure up to four values: minimum, soft minimum, soft maximum and maximum. The rule outcome is defined as follows:

  * value below minimum : “Error”

  * value below soft minimum : “Warning”

  * value above soft maximum : “Warning”

  * value above maximum : “Error”

  * value in range : “Ok”




### Change detection rules and settings

After the _learning period_ has passed, we look at the observed metric values within the _lookback window_ , to compute the typical range, and see if the new value falls within or outside of that range.

Let’s explore the process step by step:

  1. The historical data is collected in order to control that the _learning period_ has passed. If not, the rule will not attempt to compare the current value with the history, and will immediately yield an EMPTY result.

  2. The first and third quartiles of the historical data withing the _lookback window_ are computed (designated Q1 and Q3), then the inter-quartile range (IQR = Q3 - Q1)

  3. The typical ranges are computed (for error using the _IQR factor_ parameter, and for warnings using _Soft IQR factor_):

>      * Lower bound = Q1 - (iqrFactor * IQR)
> 
>      * Upper bound = Q3 + (iqrFactor * IQR)

  4. The current value of the metric is compared to those ranges




This behavior is controlled by the following parameters:

  * Period unit: Days or runs. Applies to both _learning period_ and _lookback window_.

  * Learning period: a minimum amount of metric data required to consider the rule as computable

  * Lookback window: controls the number of data point considered as part of the history.

>     * If period unit is runs, the inter-quartile range will be based on the last _n_ data points, regardless of how old they are.
> 
>     * If it’s days, the inter-quartile range will be computed with all data points that are less than _n_ days old. If this results in less than 3 data points, the rule will yield a WARNING, as it would make change detection unreliable.

  * IQR factor: factor used to compute a hard typical range - if the current value falls outside of this range, the rule will yield an error

  * Soft IQR factor: factor used to compute a soft typical range - if the current value falls outside of this range, the rule will yield a warning (only applicable if the hard IQR check passed)




### Enable / disable

Rules can be enabled or disabled individually. A disabled rule is ignored when computing the rules and when updating the status of the dataset.

### Auto-run after build

When the “Auto-run after build” option is set, the rule will be computed automatically after each build of the dataset. This ensures that the rule status is always updated alongside the dataset content.

This setting is ignored for input datasets (dataset that are not the output of any recipe), as they cannot be built within DSS.

Rules computed as part of a dataset build and returning an “Error” status will cause the build job to fail.

### Changing the rule type

Starting DSS 13.4, it is possible to change the type of an existing rule. Changing a rule type allows you to upgrade a rule to a similar but more adequate type while keeping its history (for example, changing a ‘Column min in range’ rule into a ‘Column min is within its typical range’ in order to take advantage of the dynamically computed range). Using it as a way to repurpose a rule into something completely different is not recommended, as the history may become inconsistent.

Only similar settings between the previous and the new rule type will be preserved. You may have to set or fix some settings for the new rule type to be valid.

## Data Quality monitoring views

You can easily track the status of Data Quality rules at either the dataset, project, or instance level in Dataiku.

This makes it easy to quickly identify potential data quality issues at a high level and efficiently drill down into specific issues for further investigation.

The Data Quality views are available for both partitioned and non-partitioned datasets. Partitioned dataset have some specificities related to how statuses are aggregated across partitions which you can read about below.

### Dataset level view

This view provides detail on a dataset’s Data Quality rules and computation results.

  * the _Current status_ tab provides the overall dataset status as well as the current status of each rule and run details. Time information is displayed using the user’s timezone

  * the _Timeline_ tab enables you to explore the evolution of the dataset’s daily status and of each of the rules that influenced it, even if they have been disabled or deleted since. Time information is displayed using the UTC timezone.

>     * the _last status_ of a rule is the outcome of its last computation before the end of the selected day
> 
>     * the _worst daily status_ of a rule is the worst outcome of all computations that happened throughout the selected day

  * the _Rule History_ tab allows you to see all past rule computations Time information is displayed using the user’s timezone




You can also toggle the _Monitoring_ flag from the Current Status tab. When Monitoring is turned on, the dataset is included in the project-level status. Datasets are monitored by default as soon as any rules are added.

### Project level view

The project Data Quality tab provides an overview of the project status as well as the statuses of all included datasets.

  * the _Current status_ tab gives you an overview of the _current status_ of the project as a whole as well as each dataset. The _current status_ of the project is the worst _current status_ of its monitored datasets. Time information is displayed using the user’s timezone

  * the _Timeline_ tab enables you to explore the evolution of the status of the project and its datasets, even if they have been deleted since. Time information is displayed using the UTC timezone. Statuses are computed as follows:

>     * the _last status_ of a dataset is the worst outcome of the last computation of all enabled rules before the end of the selected day
> 
>     * the _worst daily status_ of a dataset is the worst outcome of all rule computations that happened throughout the selected day




By default, the project-level views are filtered to only display monitored datasets.

### Instance level view

The instance Data Quality view, available from the Navigation menu, gives you a high level view of Data Quality statuses of the _monitored projects_ you have access to.

A _monitored project_ is a project that contains at least one monitored dataset.

The _current status_ of a project is the worst _current status_ of its monitored datasets.

### Timezone limitations

Data Quality timelines and worst daily statuses require grouping rule outcomes per day. Since this information is computed and shared at the instance level, it cannot adapt to the user’s current timezone.

All daily Data Quality data is computed based on the days in UTC timezone.

## Other data quality views

### Dataset right panel

The Data Quality right panel tab offers a quick view of the _current status_ of all enabled rules. You can access it from the right panel of datasets from the flow, from any dataset screen and from the Data Catalog.

### Data Quality Flow view

The Data Quality flow view provides a quick view of the _current status_ of all datasets with Data Quality rules configured within a project.

## Data Quality on partitioned datasets

### Computation scope

On partitioned datasets, rules may be relevant to specific partitions and/or the whole dataset. The “Computation scope” setting allows you to control whether a given rule should be computed on partitions, the whole dataset, or both, when performing a mass computation.

  * “Partitions”: the rule will be computed individually on each selected partition only

  * “Whole dataset”: the rule will be computed on the whole dataset only

  * “Both”: the rule will be computed both on each selected partition and on the whole dataset




For example, if you have a dataset partitioned by Country and you want to ensure that the median of `columnA` is at least 20 in every Country partition, and that the average of `columnB` is at most 50 across the whole dataset (but not individually for each Country), you would use:

  * a “Column median in range” rule on `ColumnA` with the setting “Partitions” and a minimum of 20

  * a “Column avg in range” rule on `ColumnB` with the setting “Whole dataset” and a maximum of 50




If you clicked “Compute all” and selected “Whole dataset” and two Countries “Belgium” and “Canada” in the modal, the `ColumnA` rule would only actually be computed on the partitions “Belgium” and “Canada”, and the `ColumnB` rule would only actually be computed on the whole dataset.

This setting applies to any mass computation (auto-run after build, from scenarios, with the “Compute all” button). Manually computing a single rule, however, forces the computation on the selected partition regardless of the “Computation scope” setting.

### Auto-run after build

For partitioned datasets, this option triggers the computation of the rule on each newly built partition and/or on the whole dataset, depending on the “Computation scope” option. For example, if a job builds a single partition A, it will trigger:

  * the computation on partition A of all rules that have “Partitions” or “Both” as computation scope

  * the computation on the whole dataset of all rules that have “Whole dataset” or “Both” as computation scope




### Data Quality monitoring views

For partitioned datasets, the dataset level view shows information for either a single partition or for the whole dataset.

In the project level view, dataset statuses are defined as the worst status of all last computed partitions. The status of each partition is the worst outcome of all enabled rules for that partition (same definition as the status of a non-partitioned dataset)

The current and last status aggregations don’t necessarily include all partitions. They first identify the last day any rule computation happened and only include the partitions that had rule computations on that day. For example, if a dataset has 3 partitions A, B, and C, and on June 5th rules are computed on partitions A and B, then on June 7th rules are computed on partition B, C and on the whole dataset, the dataset statuses will take into account:

  * partitions A and B on the 5th and 6th

  * partitions B, C and whole dataset on the 7th and later




## Retro-compatibility with Checks

Data Quality rules are a super-set of checks, ensuring full retro-compatibility. Any existing checks will be displayed in the _Data Quality_ panel as a rule of the corresponding type.

The Data Quality views, however, rely on data that did not exist previously, and will therefore suffer some limitations:

  * timelines for periods before the introduction of Data Quality will stay empty

  * current status for datasets will be missing until a single rule is computed on the dataset or the settings are changed

  * external checks will not be taken into account in the dataset status until they receive a new value

  * current status for projects will only consider dataset that have a status, eg that had a rule computed since the introduction of Data Quality rules

---

## [metrics-check-data-quality/data-quality-templates]

# Data Quality Templates

Data Quality templates allow you to easily share and reuse Data Quality rules across datasets.

A template is a set of Data Quality rules, that can easily be applied to a dataset. Templates are global, allowing you to share standard configurations across your entire instance.

## Creating a template

You can create a template from the Data Quality Rule edition panel of any dataset, using the three-dot _Actions_ menu on the right side of the screen. This will create a snapshot of the rules from this dataset, available to all other users of the instance.

It is also possible to create a new template from scratch, from the _Templates_ tab of the instance Data Quality page.

## Reusing a template

From the Data Quality rule edition page, you can use a template using the _Add from template_ button. This will add all rules from the template to the dataset you’re in. Some rule configurations may be invalid or missing, since the dataset it was created from may differ from the current one. For example, the configuration will be invalid if a rule was created on a column name that doesn’t exist in your current dataset.

## Managing templates

The full list of templates, with their names and descriptions is available from the instance Data Quality page, using the _Templates_ tab. From this page, you can also delete templates or copy their content in order to manually use them in a dataset.

It is also possible to create or edit an existing template from this page.

## Security

Templates are publicly usable and manageable. Any authenticated user may discover, create, update, delete and use any template of the instance.

---

## [metrics-check-data-quality/index]

# Metrics, checks and Data Quality

Metrics allow you to automate computation of various measurements on flow items (datasets, managed folders, saved models and model evaluation stores). You can use Checks to assert whether metric values meet certain conditions.

Data Quality rules are an improvement over the check mechanism for datasets. They allow you to define expectations on a dataset’s contents in a single step and also provide different views to monitor and analyze data quality issues across datasets, projects, and the full Dataiku instance.

---

## [metrics-check-data-quality/metrics]

# Metrics

The metrics system in DSS allows you to automatically compute measurement on Flow items (datasets, managed folders, and saved models).

Note

Metrics are often used in conjunction with scenarios but are not strictly dependent on scenarios.

Examples of metrics on a dataset include:

  * The size (in MB) of the dataset

  * The number of rows in the dataset

  * The average of a given column




Metrics are configured in the _Status_ tabs of datasets, managed folders and saved models.

Metrics are automatically historicized, which is very useful to track the evolution of the status of a dataset. For example, how did the average of `basket` evolve in the last month?

## Probes and metrics

The whole system is made around the concept of a **Probe**. A probe is a component which computes several metrics on an item.

As much as possible, the probes execute all of their computations in a single pass over the data. Furthermore, the DSS metrics system automatically “merges” together probes when there is an efficient execution path which combines several probes.

Each probe has a configuration which indicates what should be computed for this probe.

Furthermore, each probe can be configured to run automatically after each build of the dataset or not.

### Dataset probes

The following probes are available on a dataset.

#### Basic info

This probe computes the size (when relevant) and the number of files (when relevant) of the dataset

#### Records

This probe computes the number of records in the dataset.

Note

On non-Hadoop non-SQL datasets, this probe requires enumerating the whole dataset, which can be costly. See the execution engines section.

#### Partitioning

This probe computes the number of partitions and the list of partitions. It only makes sense for a partitioned dataset.

#### Basic column statistics

This probe computes descriptive statistics on dataset columns (MIN, MAX, AVG, …). You can enable multiple metrics on multiple columns

#### Advanced column statistics

This probe computes more descriptive statistics on dataset columns: most frequent value and top N values.

This probe is separate from the “Basic column statistics” because its computation costs are much higher.

#### Column data validity statistics

This probe computes the number and ratio of invalid data in a column. Invalid is defined here with regard to the Meaning of the column. For more information about meanings and storage types, see [Schemas, storage types and meanings](<../schemas/index.html>).

Note that you can only enable this probe on columns for which there is a forced meaning, i.e. it is not possible to check validity compared to a meaning which is only automatically inferred by DSS.

#### SQL

On SQL dataset, probes can be written using a SQL query. Each value in the first row of the query’s result is stored as a metric, using the column name of the value as name for the metric.

Note

If the option “is a single aggregate” is selected, your aggregate metric will automatically be wrapped by the corresponding `SELECT`, `FROM`, and `WHERE` clauses.

For example, if this option is selected, the following would be a valid probe statement: `SUM(cost) / COUNT(customers)`.

If you were to run this probe on the dataset `orders` with the partition `order_date` set to ‘2018-01-01’, your aggregation would get translated into the following SQL statement: `SELECT SUM(cost) / COUNT(customers) as "col_0" FROM orders WHERE order_date='2018-01-01'`.

#### Python

You can also write a custom probe in Python.

## Metrics display UI

The value of metrics can be viewed in the “Status” tab of a dataset, managed folder or saved model.

Since there can be a lot of metrics on an item, you must select which metrics to display, by clicking on the `X/Y metrics` button

### Datasets and managed folders

There are two main metric views:

  * A “tile” view which displays the latest value of each selected metric. Clicking on the value of a metric will bring up a modal box with the history of this value.

  * A “ribbon” view which displays the history of all selected metrics.




Note that not all metric values are numerical. For example, the “most frequent value” for a given column is not always numerical. Therefore, the history view sometimes shows history as tables rather than charts.

## Probe execution engines

Depending on the type of dataset and selected probe configurations, dataset probes can use the following execution engines for their computations:

  * Hive

>     * If selected for a dataset, the Hive engine will be used on datasets that are larger than 10MB in size. The Streaming data engine will be used on smaller datasets.

  * Impala

  * SQL database

>     * This engine is used for SQL datasets, for probes that can perform their computation as a SQL query. The query is fully executed in the database, with no data movement.

  * No specific engine

>     * For example, the “files size” probe does not require any engine, it simply reads the size of the files

  * Streaming data engine

>     * Data is streamed into DSS for computation
> 
>     * This engine is generally much slower since it needs to move all of the data
> 
>     * This engine acts as a fallback if no other engine is possible (for example, )




## Metrics on partitioned datasets

On partitioned datasets, the metrics can be computed either on a per-partition basis or on the whole dataset.

Note

Metrics must actually be computed independently on each partition and on the whole dataset, since for a lot of metrics, the metric on the whole dataset is not the “sum” of metrics on each partition.

For example, the median of a column.

For these datasets, there are 4 views into the metrics:

  * The regular “tile” view, showing the last value of selected metrics, either for a given partition or the whole dataset.

  * The regular “ribbon” view, showing the history of the values of selected metrics, either for a given partition or the whole dataset.

  * A “partitions table” view, showing the last values of several metrics on all partitions, as a data table

  * A “partitions chart” view, which tries to display the last values of each metric on all partitions as a chart. This view particularly makes sense for time-based partitions, where the chart will actually be a timeline chart.