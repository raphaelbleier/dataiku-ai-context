# Dataiku Docs — time-series

## [time-series/data-formatting]

# Format of time series data

Time series data usually has one of two formats:

  * Wide format

  * Long format




## Wide format

Time series data is in _wide_ format if you have [multiple time series](<understanding-time-series.html#ts-multiple-label>) and each distinct time series is in a separate column.

For example, given airline data from the [U.S. International Air Passenger and Freight Statistics Report](<https://www.transportation.gov/policy/aviation-policy/us-international-air-passenger-and-freight-statistics-report>), the dataset consists of data for two air carrier groups — U.S. domestic air carriers and foreign air carriers. This data can be represented in wide format if you have one column representing data for each group (for example, the total number of passengers).

Furthermore, if each time series in this data has multiple dimensions (such as the total number of passengers and the number of passengers carried by charter flights), then you have multiple [multivariate](<understanding-time-series.html#ts-multivariate-label>) time series data. The following figure shows a snippet of this data in wide format.

## Long format

_Long_ format is a compact way of representing multiple time series. In long format, values from distinct time series or from different dimensions of the same time series can be stored in the same column. Data in the long format also has an identifier column that provides context for the value in each row.

More commonly, values of the same variable from distinct time series are stored in the same column. Consider the previous example of multiple multivariate time series, the following figure shows a snippet of the data in long format. Notice that the _carriergroup_ column acts as the identifier column for each time series in the data.

[](<../_images/timeseries2_long.png>)

More generally, any data can be represented with only three columns: one for the timestamp, one for the identifier, and one for values. Applying this convention to the airline data, the identifier (_carriergroup_) would take one of these four values: charter_foreign, total_foreign, charter_domestic, and total_domestic.

## Data conversion

  * You can convert data from long to wide by using the Pivot recipe

  * You can convert data from wide to long format by using the [Fold multiple columns](<../preparation/processors/fold-columns-by-name.html#fold-multiple-columns>) processor or the [Fold multiple columns by pattern](<../preparation/processors/fold-columns-by-pattern.html#fold-multiple-columns-by-pattern>) processor.

---

## [time-series/index]

# Time Series

Time series use a sequence of time-ordered data points to represent how a measurement changes with time. A time series can record measurements of events, processes, systems, and so forth.

You can analyze time series by extracting meaningful statistics, charts, and other attributes from the data. You can also forecast or predict future values in a time series, based on previous observations.

Use-cases for time series analysis and prediction include: forecasting of quarterly sales and profits, weather forecasting, trend detection, and so forth.

---

## [time-series/time-series-forecasting]

# Time series forecasting

Forecasting is training and using models to predict future values of time series based on prior values.

Time series forecasting is a native capability of DSS. See [Time Series Forecasting](<../machine-learning/time-series-forecasting/index.html>).

---

## [time-series/time-series-preparation/decomposition]

# Trend/seasonal decomposition

Trend/seasonal decomposition is useful to understand, clean, and leverage your time series data. Not only is it necessary to retrieve seasonally-adjusted data, but it is also relevant for anomaly detection. This recipe decomposes the numerical columns of your time series into three components: trend, seasonality and residuals. The recipe relies on STL, seasonal and trend decomposition using Loess. For more information, see [Statsmodel’s documentation](<https://www.statsmodels.org/devel/generated/statsmodels.tsa.seasonal.STL.html>).

Note

The decomposition recipe only supports Python 3.6.

## Input Data

Data that consists of equispaced _n_ -dimensional time series in [wide or long format](<../data-formatting.html>).

## Settings

### Input parameters

#### Time column

Column with parsed dates and no missing values:

  * To parse dates, you can use a [Prepare](<../../preparation/processors/date-parser.html>) recipe.

  * To fill missing values, you can use the Time Series Preparation [Resampling](<resampling.html>) recipe.




#### Frequency

Frequency of the time column, from year to minute:

  * For minute and hour frequency, you can select the number of minutes or hours.

  * For week frequency, you can select the end-of-week day.




#### Season length

Length of the seasonal **period** in selected frequency unit.

  * For example, season length is 7 for daily data with a weekly seasonality

  * Season length is 4 for a 6H frequency with a daily seasonality




#### Target column(s)

Time series columns that you want to decompose. It must be numeric (_int_ or _float_). You can select one or multiple columns.

#### Long format checkbox

Indicator that the input data is in the long format. See [Long format](<../data-formatting.html#ts-long-format-label>).

#### Time series identifiers

The names of the columns that contain identifiers for the time series when the input data is in the long format. This parameter is available when you enable the “Long format” checkbox. You can select one or multiple columns.

### Decomposition parameters

#### Model type

The decomposition model of your time series. It may be :

  * **Additive** : Time series = trend + seasonality + residuals

  * **Multiplicative** : Time series = trend × seasonality × residuals




If the magnitude of the seasonality varies with the mean of the time series, then the series is multiplicative. Otherwise, the series is additive.

Note

  * A multiplicative model is only compatible with positive numerical values.

  * For multiplicative STL, the recipe first takes the logarithms of the data, then computes an additive decomposition and finally back-transforms the data.




### Advanced parameters

#### Seasonal smoother

The window size used to estimate the seasonal component in STL decompositions. It must be an odd integer greater than 7. It controls how rapidly the seasonal component can change.

#### Robust to outliers

If selected, the estimation will re-weight data, allowing the model to tolerate larger errors.

#### Additional parameters

The map parameter enables you to add any other parameter of the [Statsmodel STL function](<https://www.statsmodels.org/devel/generated/statsmodels.tsa.seasonal.STL.html>) . To add a parameter, click on “ADD KEY/VALUE”, then enter the parameter name as the ‘key’, and the parameter value as the ‘value’. You may use the following parameters:

**Degree of Loess:** Degrees of the regressions used to estimate the components. It must be 0 or 1.

**Speed jump:** If the speed jump is larger than 1, the LOESS is used every seasonal_jump points. Then, it performs linear interpolation to estimate the missing points.

**Length of the smoothers:** Number of consecutive timesteps (years, weeks..) used in estimating each value in the decomposition components. It controls how rapidly a component can change.

## Related pages

  * [Resampling](<resampling.html>)

  * [Interval extraction](<interval-extraction.html>)

  * [Extrema extraction](<extrema-extraction.html>)

  * [Windowing](<windowing.html>)

---

## [time-series/time-series-preparation/extrema-extraction]

# Extrema extraction

Time series extrema are the minimum and maximum values in time series data. It can be useful to compute aggregates of a time series around extrema values to understand trends around those values.

## Extrema extraction recipe

The extrema extraction recipe allows you to extract aggregates of time series values around a global extremum (global maximum or global minimum).

Using this recipe, you can find a global extremum in one dimension of a time series and perform windowing functions around the timestamp of the extremum on all dimensions. See [Windowing](<windowing.html>) for more details about the windowing operations.

This recipe works on all numerical columns (_int_ or _float_) in your time series data.

### Input Data

Data that consists of equispaced _n_ -dimensional time series in [wide or long format](<../data-formatting.html>).

If input data is in the long format, then the recipe will find the extremum of each time series in the column on which you operate. See Algorithms for more details.

### Parameters

#### Time column

Name of the column that contains the timestamps. Note that the timestamp column must have the date type as its [meaning](<../../schemas/definitions.html#schema-type-meaning>) (detected by DSS), and duplicate timestamps cannot exist for a given time series.

#### Long format checkbox

Indicator that the input data is in the long format. See [Long format](<../data-formatting.html#ts-long-format-label>).

#### Time series identifiers

The names of the columns that contain identifiers for the time series when the input data is in the long format. This parameter is available when you enable the “Long format” checkbox. You can select one or multiple columns.

#### Find extremum in column

Name of column from which to extract the extremum value.

#### Extremum type

Type of extremum to find, specified as “Global minimum” or “Global maximum”.

#### Causal window

Option to use a causal window, that is, a window that contains only past (and optionally, present) observations. The timestamp for the extremum point will be at the right border of the window.

If you deselect this option, Dataiku DSS uses a bilateral window, that is, a window that places the timestamp for the extremum point at its center.

#### Shape

Window shape applied to the _Sum_ and _Average_ operations. The shape can take on one of these values:

  * Rectangular: simple rectangular window with a flat profile

  * Triangle: triangle window (with nonzero values at the endpoints)

  * Bartlett: triangle window (with zero values at the endpoints)

  * Gaussian: nonlinear window in the shape of a Gaussian distribution

  * Parzen: nonlinear window made of connected polynomials of the third degree

  * Hamming: nonlinear window generated as a sum of cosines (trigonometric polynomial of order 1)

  * Blackman: nonlinear window generated as a sum of cosines (trigonometric polynomial of order 2)




#### Width

Width of the window, specified as a numerical value (_int_ or _float_).

The window width cannot be smaller than the frequency of the time series. For example, if your timestamp intervals equal 5 minutes, you cannot specify a window width smaller than 5 minutes.

#### Unit

Unit of the window width, specified as one of these values:

  * Years

  * Months

  * Weeks

  * Days

  * Hours

  * Minutes

  * Seconds

  * Milliseconds

  * Microseconds

  * Nanoseconds




#### Include window bounds

Edges of the window to include when computing aggregations. This parameter is active only when you use a causal window. Choose from one of these values:

  * Yes, left only

  * Yes, right only

  * Yes, both

  * No




#### Aggregations

Operations to perform on a window of time series data. Select one or more of these options:

  * Retrieve

  * Min

  * Max

  * Average

  * Sum

  * Standard deviation

  * 25th percentile

  * Median

  * 75th percentile

  * First order derivative

  * Second order derivative




### Output Data

Data consisting of the results of extrema extraction, one row for each time series. Each row contains the timestamp of the extremum and the computed aggregations for a window of data around the extremum.

### Algorithms

If the input data is in the wide format, the recipe works as follows:

>   1. Find the global extremum and corresponding timestamp for a specific column.
> 
>   2. For all columns, apply a window around the timestamp and compute aggregations.
> 
> 


If the input data is in the long format, then the recipe implements slightly different steps, as follows:

>   1. Find the global extremum and corresponding timestamp for _each_ time series in a specific column.
> 
>   2. For all columns, apply a window around the timestamps found in step 1 and then compute aggregations.
> 
> 


### Tips

  * If you have irregular timestamp intervals, first resample your data using the [resampling recipe](<resampling.html#tsresampling-recipe-label>). Then you can apply the extrema extraction recipe to the resampled data.

  * The extrema extraction recipe works on all numerical columns of a dataset. To apply the recipe to select columns, you must first prepare your data by removing the unwanted columns.




## Related pages

  * [Interval extraction](<interval-extraction.html>)

  * [Windowing](<windowing.html>)

  * [Resampling](<resampling.html>)

  * [Trend/seasonal decomposition](<decomposition.html>)

---

## [time-series/time-series-preparation/index]

# Time series preparation

Before using time series data for analysis or forecasting, it is often necessary to perform one or more preparation steps on the data.

For example, given time series data with missing or irregular timestamps, you may consider performing preparation steps such as resampling and interpolation. You may also want to perform smoothing, extrema extraction, or segmentation on the data.

## Time series preparation plugin

Dataiku DSS provides a preparation plugin that includes visual recipes for performing the following operations on time series data:

Note

The time series preparation plugin is fully supported by Dataiku.

### Plugin installation

You can install the time series preparation plugin (and other plugins) if you are a user with administrative privileges. See [Installing plugins](<../../plugins/installing.html>) for more details.

Once the plugin is installed, users with normal privileges can view the plugin store and the list of installed plugins, and use any plugins installed on the Dataiku DSS instance. See [Managing installed plugins](<../../plugins/installed.html>) for more details.

### Upgrade note

Starting with version 2.0.3, this plugin supports Python versions 3.6 to 3.11. If you have already installed the plugin and want to use its latest features, make sure to use one of these Python versions.

---

## [time-series/time-series-preparation/interval-extraction]

# Interval extraction

It is sometimes useful to identify periods when time series values are within a given range. For example, a sensor reporting time series measurements may record values that fall outside an acceptable range, thus making it necessary to extract segments of the data.

## Interval extraction recipe

The interval extraction recipe identifies segments of the time series where the values fall within a given range. See Algorithms for more information.

This recipe works on all numerical columns (_int_ or _float_) in your time series data.

### Input Data

Data that consists of equispaced _n_ -dimensional time series in [wide or long format](<../data-formatting.html>).

If input data is in the long format, then the recipe will separately extract the intervals of each time series that is in a column. See Algorithms for more information.

### Parameters

#### Time column

Name of the column that contains the timestamps. Note that the timestamp column must have the date type as its [meaning](<../../schemas/definitions.html#schema-type-meaning>) (detected by DSS), and duplicate timestamps cannot exist for a given time series.

#### Long format checkbox

Indicator that the input data is in the long format. See [Long format](<../data-formatting.html#ts-long-format-label>).

#### Time series identifiers

The names of the columns that contain identifiers for the time series when the input data is in the long format. This parameter is available when you enable the “Long format” checkbox. You can select one or multiple columns.

#### Apply threshold to column

Name of the column to which the recipe applies the threshold parameters.

#### Minimal valid value

Minimum acceptable value in the time series interval, specified as a numerical value (_int_ or _float_). The minimal valid value and the maximum valid value form the range of acceptable values.

#### Maximum valid value

Maximum acceptable value in the time series interval, specified as a numerical value (_int_ or _float_). The maximum valid value and the minimal valid value form the range of acceptable values.

#### Unit

Unit of the acceptable deviation and the minimal segment duration, specified as one of these values:

  * Days

  * Hours

  * Minutes

  * Seconds

  * Milliseconds

  * Microseconds

  * Nanoseconds




#### Acceptable deviation

Maximum duration of the specified unit, for which values within a valid time segment can deviate from the range of acceptable values.

For example, if you specify 400 - 600 as a range of acceptable values, and an acceptable deviation of 30 seconds, then the recipe can return a valid time segment that includes values outside the specified range, provided that those values last for a time duration that is less than 30 seconds.

#### Minimal segment duration

The minimum duration for a time segment to be valid, specified as a numerical value of the unit parameter.

For example, you can specify 400 - 600 as a range of acceptable values, and a minimal segment duration of 3 minutes. If all the values in a time segment are between 400 and 600 (or satisfy the acceptable deviation), but the segment lasts less than 3 minutes, then the time segment would be invalid.

### Output Data

Data consisting of equispaced and _discontinuous_ time series. Each interval in the output data will have an id (“interval_id”).

### Algorithms

For values of the minimal segment duration and acceptable deviation, the recipe implements the following steps.

>   1. Evaluate if consecutive values of a time series satisfy at least one of these conditions:
>
>>      1. the values are in the range of acceptable values (between the minimal valid value and the maximum valid value)
>> 
>>      2. the values deviate from the range of acceptable values but last for a time period that is smaller than the acceptable deviation
> 
> 

>
>>   * If yes, then these values form a segment and the recipe proceeds to step 2.
>> 
>>   * If no, then the values are not acceptable, and the recipe repeats step 1 for successive values in the time series.
>> 
>> 

> 
>   2. Evaluate if the segment lasts for a time duration that is greater than the _minimal segment duration_.
> 
> 

>
>>   * If yes, then keep this segment as an acceptable interval
>> 
>>   * If no, then this segment is not an acceptable time interval
>> 
>> 

>> 
>> Return to step 1 to evaluate successive values in the time series.

Note

If the input data is in the long format, then for each time series in a specified column, the recipe will perform the interval extraction algorithm separately.

### Tips

  * If you have irregular timestamp intervals, first resample your data, using the [resampling recipe](<resampling.html#tsresampling-recipe-label>). Then you can apply the interval extraction recipe to the resampled data.

  * The interval extraction recipe works on all numerical columns of a dataset. To apply the recipe on select columns, you must first prepare your data by removing the unwanted columns.




## Related pages

  * [Extrema extraction](<extrema-extraction.html>)

  * [Windowing](<windowing.html>)

  * [Resampling](<resampling.html>)

  * [Trend/seasonal decomposition](<decomposition.html>)

---

## [time-series/time-series-preparation/resampling]

# Resampling

Time series data can occur in irregular time intervals. However, to be useful for analytics, the time intervals need to be equispaced.

## Resampling recipe

The resampling recipe transforms time series data occurring in irregular time intervals into equispaced data. The recipe is also useful for transforming equispaced data from one frequency level to another (for example, minutes to hours).

This recipe resamples all numerical columns (type _int_ or _float_) and imputes categorical columns (type _object_ or _bool_) in your data.

### Input Data

Data that consists of _n_ -dimensional time series in [wide or long format](<../data-formatting.html>).

### Parameters

#### Time column

Name of the column that contains the timestamps. Note that the timestamp column must have the date type as its [meaning](<../../schemas/definitions.html#schema-type-meaning>), and duplicate timestamps cannot exist for a given time series.

#### Long format checkbox

Indicator that the input data is in the long format. See [Long format](<../data-formatting.html#ts-long-format-label>).

#### Time series identifiers

The names of the columns that contain identifiers for the time series when the input data is in the long format. This parameter is available when you enable the “Long format” checkbox. You can select one or multiple columns.

#### Time step

Number of steps between timestamps of the resampled (output) data, specified as a numerical value.

#### Unit

Unit of the time step used for resampling, specified as one of these values:

  * Years

  * Semi-annual

  * Quarters

  * Months

  * Weeks

  * Business days (Mon-Fri)

  * Days

  * Hours

  * Minutes

  * Seconds

  * Milliseconds

  * Microseconds

  * Nanoseconds




#### Interpolate

Method used for inferring missing values for timestamps, where the missing values do not begin or end the time series. The available interpolation methods are:

  * Nearest: nearest value

  * Previous: previous value

  * Next: next value

  * Mean: average value

  * Linear: linear interpolation

  * Quadratic: spline interpolation of second order

  * Cubic: spline interpolation of third order

  * Constant: replace missing values with a constant

  * Don’t interpolate (impute null): retrieve missing dates and leave missing values empty




Interpolation methods are based on the [scipy implementation](<https://docs.scipy.org/doc/scipy-1.2.1/reference/generated/scipy.interpolate.interp1d.html#scipy-interpolate-interp1d>).

#### Extrapolate

Method used for prolonging time series that stop earlier than others or start later than others. Extrapolation infers time series values that are located before the first available value or after the last available value. The available extrapolation methods are:

  * Previous/next: set to previous available value or next available value (if previous values are missing)

  * Same as interpolation

  * Don’t extrapolate (impute null): retrieve missing dates and leave missing values empty

  * Don’t extrapolate (no imputation): don’t extrapolate missing dates




#### Extrapolation start date

Earliest date to use when extrapolation is enabled. Defaults to using the first known timestamp across time series identifiers. If a custom date later than the first known timestamp is set, the custom date is ignored and the first timestamp is used instead.

#### Extrapolation end date

Latest date to use when extrapolation is enabled. Defaults to using the last known timestamp across time series identifiers. If a custom date earlier than the last known timestamp is set, the custom date is ignored and the last timestamp is used instead.

#### Impute category data

Method used to fill in categorical values during interpolation and extrapolation. The available methods are:

  * Empty : leave the categorical values of the inferred rows empty

  * Constant: replace missing categorical data with a constant value

  * Most common: set to the most common value of the time series

  * Previous/next : set to previous available value or next available value (if previous values are missing)

  * Previous: set to previous available value

  * Next: set to next available value




#### Clip start

Number of time steps to remove from the beginning of the time series, specified as a numerical value of the unit parameter.

#### Clip end

Number of time steps to remove from the end of the time series, specified as a numerical value of the unit parameter.

#### Shift value

Amount by which to shift (or offset) all timestamps, specified as a positive or negative numerical value of the unit parameter.

### Output Data

Data consisting of equispaced time series, and having the same number of columns as the input data.

### Algorithms

The resampling recipe upsamples or downsamples time series in your data so that the length of all the time series are aligned. When you specify a given time step (for example, 30 seconds), the recipe will upsample or downsample the time series by an integer multiple of the time step.

The recipe also performs both interpolation (See Interpolate) and extrapolation (See Extrapolate) to infer missing values.

### Tip

  * The resampling recipe works on all numerical columns in your input dataset. To apply the recipe on select columns, you must first prepare your data by removing the unwanted columns.




## Related pages

  * [Windowing](<windowing.html>)

  * [Interval extraction](<interval-extraction.html>)

  * [Extrema extraction](<extrema-extraction.html>)

  * [Trend/seasonal decomposition](<decomposition.html>)

---

## [time-series/time-series-preparation/windowing]

# Windowing

For high frequency or noisy time series data, observing the variations between successive observations may not always provide insightful information. In such cases, it can be useful to filter or compute aggregations over a rolling window of timestamps.

## Windowing recipe

The windowing recipe allows you to perform analytics functions over successive periods in equispaced time series data. This recipe works on all numerical columns (type _int_ or _float_) in your data.

### Input Data

Data that consists of equispaced _n_ -dimensional time series in [wide or long format](<../data-formatting.html>).

Note

If input data is in the long format, then windowing in any numerical column will be applied separately on each time series in the column.

### Parameters

#### Time column

Name of the column that contains the timestamps. Note that the timestamp column must have the date type as its [meaning](<../../schemas/definitions.html#schema-type-meaning>) (detected by DSS), and duplicate timestamps cannot exist for a given time series.

#### Long format checkbox

Indicator that the input data is in the long format. See [Long format](<../data-formatting.html#ts-long-format-label>).

#### Time series identifiers

The names of the columns that contain identifiers for the time series when the input data is in the long format. This parameter is available when you enable the “Long format” checkbox. You can select one or multiple columns.

#### Causal window

Option to use a causal window, that is, a window which contains only past (and optionally, present) observations. The current row in the data will be at the right border of the window.

If you de-select this option, Dataiku DSS uses a bilateral window, that is, a window which places the current row at its center.

#### Shape

Window shape applied to the _Sum_ and _Average_ operations. The shape is specified as one of these values:

  * Rectangular: simple rectangular window with a flat profile

  * Triangle: triangle window (with nonzero values at the endpoints)

  * Bartlett: triangle window (with zero values at the endpoints)

  * Gaussian: nonlinear window in the shape of a Gaussian distribution

  * Parzen: nonlinear window made of connected polynomials of the third degree

  * Hamming: nonlinear window generated as a sum of cosines (trigonometric polynomial of order 1)

  * Blackman: nonlinear window generated as a sum of cosines (trigonometric polynomial of order 2)




#### Width

Width of the window, specified as a numerical value (_int_ or _float_).

The window width cannot be smaller than the frequency of the time series. For example, if your timestamp intervals equal 5 minutes, then you cannot specify a window width that is smaller than 5 minutes.

#### Unit

Unit of the window width, specified as one of these values:

  * Years

  * Months

  * Weeks

  * Days

  * Hours

  * Minutes

  * Seconds

  * Milliseconds

  * Microseconds

  * Nanoseconds




#### Include window bounds

Edges of the window to include when computing aggregations. This parameter is active only when you use a causal window. Choose from one of these values:

  * Yes, left only

  * Yes, right only

  * Yes, both

  * No




#### Aggregations

Operations to perform on a window of time series data. Select one or more of these options:

  * Retrieve

  * Min

  * Max

  * Average

  * Sum

  * Standard deviation

  * 25th percentile

  * Median

  * 75th percentile

  * First order derivative

  * Second order derivative




### Output Data

Data consisting of equispaced time series, and having the same number of columns as the input data.

### Tips

  * If you have irregular timestamp intervals, first resample your data, using the [resampling recipe](<resampling.html#tsresampling-recipe-label>). Then you can apply the windowing recipe to the resampled data.

  * The windowing recipe works on all numerical columns of a dataset. To apply the recipe on select columns, you must first prepare your data by removing the unwanted columns.




## Related pages

  * [Resampling](<resampling.html>)

  * [Interval extraction](<interval-extraction.html>)

  * [Extrema extraction](<extrema-extraction.html>)

  * [Trend/seasonal decomposition](<decomposition.html>)

  * [Window: analytics functions](<../../other_recipes/window.html>)

---

## [time-series/time-series-visualization]

# Time series visualization

You can visualize time series using line charts with “automatic” aggregation mode.

The automatic aggregation mode allows you to display arbitrarily large series with aggregation pushed down to the database.

Make sure that your timestamp is of the date type to use this chart.

Find more information in [Lines & Curves](<../visualization/charts-basics.html#line-charts>)

---

## [time-series/understanding-time-series]

# Understanding time series data

A time series can record measurements of one or more variables that may be interrelated; for example, temperature and humidity levels of a city.

Depending on the relationships between variables in time series data, the data can be categorized as follows.

## Univariate time series

A univariate time series consists of a single variable (or dimension) that depends on time.

For example, given the daily closing stock prices for a specific company, you have a one-dimensional value (price) that changes with time. If you have to predict future prices, you can look at the past values of one variable (price) to build a prediction model.

## Multivariate time series

A multivariate time series consists of two or more interrelated variables (or dimensions) that depend on time.

In the previous example, suppose the time series data also consists of the volume of stocks traded daily. Each day, you have a two-dimensional value (price and volume) changing simultaneously with time. If you have to predict future prices, then you can use the past values of the two variables (price and volume) to build a prediction model.

## Multiple time series

Time series data can also consist of multiple time series, where each observation is made up of values from distinct time series that are not related to each other.

Consider time series data that consists of the daily prices for a group of unrelated companies. In this case the daily prices for each company is a separate time series.

## Related Pages

  * [Time series preparation](<time-series-preparation/index.html>)

  * [Time series forecasting](<time-series-forecasting.html>)

  * [Format of time series data](<data-formatting.html>)

  * [Time Series Analysis](<../statistics/time-series.html>)