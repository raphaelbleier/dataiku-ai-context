# Dataiku Docs — charts-visualization

## [visualization/charts-basics]

# Basic Charts

The Basic charts build visualizations based on the following types of columns:

  * A required binning column, whose values are broken down into discrete values, or bins.

  * A required summary column, whose values are aggregated for each bin. Some basics charts allow multiple summary columns.

  * An optional grouping column to produce subgroups of bins.




* * *

## Chart Layouts

### Bar

  * The **Histogram** layout puts the binning column on the X axis, the summary column on the Y axis, and creates separate bars for each subgroup for each bin.




  * The **Stacked** layout puts the binning column on the X axis, the summary column on the Y axis, and stacks each subgroup within each bin.




  * The **Stacked 100%** is just like the Stacked layout, but the height of each bar is normalized to 100%. This is useful for seeing differences across bins.




  * The **Bars** layout puts the binning column on the Y axis, the summary column on the X axis, and stacks each subgroup within each bin.




  * The **Bars 100%** layout is just like the Bars layout, but the length of each bar is normalized to 100%.




### Lines & Curves

Lines & curves charts are generally most useful for comparing multiple subgroups or summary columns.

  * The **Lines** layout puts the binning column on the X axis, the line height column on the Y axis, and creates separate lines for each subgroup for each bin.




  * The **Mixed** layout puts the binning column on the X axis, for each height column on the Y axis and creates separate bars for each subgroup for each bin. You can choose whether to display it as a bar or line.




  * The **Stacked Area** layout works roughly like a Stacked Bar chart, but it will create a smooth area instead of columns.




  * The **Stacked Area 100%** layout works roughly like a Stacked 100% Bar chart, but it will create a smooth area instead of columns.




### Pie & Donuts

Pie & donut charts are generally most appropriate when there is no inherent ordering of the bins.

  * **Pie** charts are like bar charts, but each bin is represented by a wedge in a circle, like a slice of pie. The size of each wedge is proportional to the sum total of all wedges. There is no subgrouping of wedges.




  * **Donut** charts are like pie charts, but with the middle removed.




## Column Processing Options

### Binning Column

Set the binning rules by clicking on the name of the binning column.

[](<../_images/binning-column.png>)

### Summary Column

Set the aggregation rules by clicking on the name of the summary column.

[](<../_images/summary-column.png>)

### Grouping Column

Set the subgroup sorting rules by clicking on the name of the grouping column.

[](<../_images/grouping-column.png>)

Note

It generally does not make sense to use the “AVERAGE” aggregation when creating subgroups of of bars. Only aggregations that “naturally stack” should be used: SUM and COUNT.

## Compute modes

Compute modes determine the logic used to calculate chart values. By default, data is aggregated based on your chosen dimensions (such as binning or grouping) using standard functions like average or median.

### Standard aggregation modes

Compute modes available for aggregated measures:

  * **Normal** (`NORMAL`): displays the result of the aggregation function for each bin without additional calculations.

  * **Percentage scale** (`PERCENTAGE`): represents each bin’s aggregated value as a percentage of the total across the entire axis.

  * **Ratio to average** (`AVG_RATIO`): calculates the relative deviation from the mean using the formula \\((value / average) - 1\\).

>     * _Example:_ a result of `0.2` means the value is 20% **above** the average, while `-0.2` indicates it is 20% **below** the average.

  * **Cumulative values** (`CUMULATIVE`): replaces individual bin values with a running total (cumulative sum) along the chart axis.

  * **Cumulative percentage scale** (`CUMULATIVE_PERCENTAGE`): calculates the running total and expresses it as a percentage of the overall total.

  * **Differential values** (`DIFFERENCE`): shows the change between the current and previous bin values; the first bin serves as the starting baseline.




Availability may vary depending on chart type.

Note

`DIFFERENCE` is available only when there is a single main breakdown axis.

### Unaggregated measure modes

You can also choose to skip the standard aggregation for each bin and instead use a specific display mode:

  * `STACK`: keeps all distinct values within a bin and stacks them cumulatively.

  * `OVERLAY`: keeps all distinct values within a bin and overlays them from the same base. The visible extent follows the maximum positive and minimum negative value.

  * `KEEP_FIRST`: keeps only the first value found in the bin.

  * `KEEP_LAST`: keeps only the last value found in the bin.




Note

`KEEP_FIRST` and `KEEP_LAST` depend on the row order used to compute the chart. When using the SQL engine, the row order returned by the database is not deterministic by definition.

---

## [visualization/charts-maps]

# Map Charts

Map charts let you display a dataset containing geographic features on a world map.

The Map charts build visualizations based a required Geo column, whose values can be geographic points or geometries.

* * *

## Chart Layouts

### Scatter

  * The **Scatter Map** layout plots a point at each individual geopoint. It allows you to add optional Color and Size columns that change the color and size of the points based upon the column values. The Size column must be numeric, but the Color column can be text or numeric.




### Geometry

  * The **Geometry Map** layout works best with geometries, but will work with geopoints, in which case it is like a Scatter Map with no Size column. A Geometry Map can display several geographical columns.




#### Choose the order of the geo layers

The order of the dragged geo columns determines the order of appearance of the geo layers on a map. Hence,

  * if a geo column “geometry” is added on the **right hand side** of another geo column, the chart will display the layer “geometry” on top.

  * if a geo column “geometry” is added **under** another geo column, the chart will display the layer “geometry” on top.




Therefore, the chart below plots :

  * the column “isochrone_envelope” (orange) on top

  * the column “city_geom” (red) in between the two layers

  * the column “geoenvelope_walmart” (blue) in the background




To change the order of the displayed layers, you may change the order of the geo columns by dragging and dropping them.

#### Set the colors

You can modify the colors by clicking on the “drop” button: [](<../_images/geometry-map-drop-icon.png>) of the geo column of your choice.

For each geographical layer, you can add a color column to change the colors of the displayed geometries according to their values. For example, the chart below colors each county based on their area.

#### Aggregate geometries

If two geometries are equal, a Geometry map plots them twice. If you want to display duplicated geometries only once, set the **Aggregate** option to Make Unique.

The “Make unique” option is only available for geometry columns without a color column.

### Density

The **Density Map** layout displays the density of geopoints taking into accounts their spatial proximity and an optional quantitative metric.

The following parameters can be tuned:

  * Details: Optional quantitative column of the input dataset used as an additional point weight based on its value in the column.

  * Intensity (global for all points): A global parameter used as a multiplier for the weights of the points. Setting a high intensity will result in a less transparent chart.

  * Radius (global for all points): A global parameter setting the radius of each point, a higher radius will result in more overlapping between points and higher intensity in high density zones.




### Binned

The **Grid Map** layout plots the geographic locations as rectangular grids on the map. It allows you to add an optional Color column that changes the color of the points based upon the column values. The Color column can be text or numeric.

Note

Map charts cannot be downloaded as images. To share map charts, publish them to a dashboard or take a screenshot of the map to generate an image of the map chart.

### Administrative

Note

Administrative maps are considered a BETA feature. You might encounter issues while using it and we do not guarantee that this feature will keep working the same way in future versions.

To create Administrative maps, you must first install the [Reverse Geocoding plugin](<https://www.dataiku.com/dss/plugins/info/geoadmin.html>). See [Installing plugins](<../plugins/installing.html>) for details.

Administrative maps are aggregated charts: rows in your dataset are aggregated by administrative levels; for example:

  * By country

  * By region

  * By city




You can change the “level of aggregation” by opening the settings of the Geo column.

Two kinds of Administrative maps are available:

  * In the **Bubbles** layout, each administrative level is represented by a circle. You can assign measures to both color and size.




  * In the **Filled** layout, each administrative level is represented by its real polygon. You can assign a measure to the color




## Geographic columns

A geographic column is either a point or another kind of geometry. Valid geographic columns are detected as “Geopoint” or “Geometry” in the exploration component.

Geographic columns can be obtained in DSS:

  * By reading a GeoJSON or Shapefile dataset

  * By reading any dataset containing a column in [WKT format](<http://en.wikipedia.org/wiki/Well-known_text>)

  * By applying a geocoding processor in a preparation script

  * By applying a “Resolve GeoIP” processor in a preparation script




## Map backgrounds

DSS comes pre-bundled with map backgrounds provided by Carto. More map backgrounds can be added using DSS plugins:

  * You can find in the Dataiku plugins [a plugin to add map backgrounds from Mapbox](<https://www.dataiku.com/dss/plugins/info/mapbox-maps-backgrounds.html>) (requires a Mapbox API key)

  * In addition, you can [create your own plugins to add other backgrounds](<../plugins/reference/charts-elements.html>).

---

## [visualization/charts-other]

# Other Charts

These charts do not fit neatly into other classifications.

* * *

## Boxplot

Boxplots build a visualization that shows you the distribution of a required Y axis column, possibly broken down by the bins of an optional X axis column and creates separate boxplots for each subgroup for each bin on the color axis. The Y axis column must be numeric, the X axis column can be numeric or text.

## 2D Distribution

The 2D Distribution chart builds a visualization that shows you the bivariate distribution of a required X axis column and a required Y axis column. Each column is binned and the resulting cells are colored by the relative density of rows in that cell.

## Lift Chart

Warning

This chart type is deprecated. Lift charts are provided for models in Visual ML results.

## Treemap

Treemap charts build a visualization of the hierarchical structure of tree diagrams. Each parent node is represented by a rectangular area with its children nodes nested inside. The size of each area is dependent on the value of the corresponding node.

## KPI

Standing for “Key Performance Indicator”, KPI charts build a simple value visualization for single or multiple aggregations.

## Radar

Radar charts are ideal for comparing multiple quantitative variable, each variable being displayed as a radial axis. The values of the same category are shown as polygon, of which each chart can have 1 or more.

## Sankey

A Sankey chart is used to depict the flow of resources, quantities, or values from one set of entities to another. It is a type of flow chart that illustrates data across different categories or stages.

## Gauge

The Gauge chart, also known as speedometer, is used to display data in a circular axis to demonstrate performance or progress. This axis can be colored to offer better segmentation and clarity.

## Waterfall

A Waterfall chart is used to illustrate how an initial value is incrementally affected by a series of **positive** and **negative** variations. The horizontal axis can display one or two breakdowns, allowing you to analyze a measure across a single dimension or across two nested dimensions (e.g., variations of _Result_ over _Year_ and _City_).

  * With a single breakdown on the X axis, you can choose whether to display the Total bar, and control its position (left or right).

  * By default, waterfall bars use a dedicated color palette, with specific colors assigned to increases, decrease or totals.




  * When two breakdowns are used on the X axis, the second dimension can be used as a color dimension, instead of standard waterfall colors.




  * Waterfall charts use **unaggregated** data by default. This means that, for each bin, no aggregation (such as average or median) is computed. Instead, the chart displays either the first value (Keep first mode), or the last value (Keep last mode) retrieved from the dataset.

  * For details about standard and unaggregated compute modes, see [Compute modes](<charts-basics.html#compute-modes>).




Note: Totals and subtotals can be automatically calculated or pulled directly from your dataset.

---

## [visualization/charts-scatters]

# Scatter Charts

The Scatter charts build visualizations that display plotted points, based on the following types of columns:

  * Required X and Y axis columns, whose values determine the location of the plotted points.

  * An optional Color column that colors the points based upon the column’s values. If the Color column is not specified, then the points have a uniform color.

  * An optional Size column that sizes the points based upon the column’s values. If the Size column is not specified, then the points have a uniform size.




* * *

## Chart Layouts

### Basic

The **Scatter Plot** layout allows you to add an optional Shape column that changes the shape of the points based upon the column’s values. The Shape column should have a relatively limited number of value to avoid clutter.

The Basic Scatterplot plots a point at each individual X-Y value combination. Thus, each point has a single value from the Color, Size, and Shape columns, and these columns can be text or numeric.

### Multi-pair

The **Scatter multi-pair** chart allows you to add multiple pairs of X-Y value combinations. The points are assigned a color, corresponding to the pair that they belong to. Therefore, it is not possible to define a color dimension on this chart. The size and shape options are also not available. Each pair has a separate y axis that can be individually formatted. The x axis is common for all the pairs.

Both the x and y dimensions can be either numeric or date. However, the column type used for the x dimensions has to be consistent (either all numeric or all date).

### Grouped

The **Grouped Bubbles** layout adds a required Grouping column. First the Grouping column is discretized into bins. For each binned value, it plots one point in the chart. The X-Y location of each point is determined by aggregating the X and Y axis columns. Likewise, the color and size of each point is determined by aggregating those columns, if specified. The X and Y axis, Color, and Size columns must all therefore be numeric, so they can be aggregated.

### Binned

Binned Scatter charts discretize the values of X and Y axis columns, and create one point for each X-Y bin. The dimensions do not need to be numerical. The color and size of each circles are represented using aggregations of measures.

  * The **Bubble** layout allows the X and Y axis columns to be text or numeric. If an axis column is text, its raw values are used.




  * The **Rectangle** layout is like the Bubble layout, but instead of points it plots rectangles. The resulting chart resemble a heat map.




  * The **Hexagon** layout requires both the X and Y axis columns to be numeric. Hexagonal binning generally provides a better overview of the distribution of your data than the Bubble or Rectangle plots, and can better represent large amounts of data.




Warning

Hexagonal binning is incompatible with live in-database processing. If you use in-database processing and want to enable hexagonal binning, you will need to switch to DSS Charts Engine.

## Regression line

The regression line shows a relationship between the x and the y variables. It is possible to add a regression line on a scatterplot chart with both numerical or both date axes. There are 4 types of regression to choose from:

  * Linear

  * Polynomial

  * Logarythmic

  * Exponential




While it is always possible to calculate a linear and polynomial regression, the logarithmic regression can only be calculated for x values bigger than 0, and the exponential regression can only be calculated for y values bigger than 0. If your chart contains values that do not match these criteria, the regression line will still be drawn but it will not take those values into account.

The regression line is customizable - apart from type, you can also choose a line color, the stroke width, add a regression formula and customize its position, font size, font color, and background.

---

## [visualization/charts-tables]

# Tables

Tables build visualizations based on the following types of dropzone:

  * Rows dropzone, whose bins define how records are broken down along rows of the table.

  * Columns dropzone, whose bins define how records are broken down along columns of the table.




Note

Either a Row or a Column must be specified, but at least one is required.

You can use as many columns as you want on a dropzone

  * A required Content column (and optionally more than one), whose values are aggregated for each row/column bin.




Tables include an optional option that colors the table cells based upon the aggregated values of the Color column, like a heat map.

---

## [visualization/common]

# Common Chart Elements

The following controls have a common purpose across all chart types, though not every feature is available for every chart type.

  * By default, all rows are used to produce the chart. To focus the chart on a subset of records, drag one or more columns to the **Filters** control in the **Setup** tab and select which values of those columns should be displayed, and which should be filtered out. For more information about filter settings, see [Filter settings](<filter-settings.html>).

  * **Color** controls in the **Format** tab define the color in the charts. See [Color palettes](<palettes.html>) for details.

  * By default, charts are static. To animate a chart, drag a column to the **Animation** control in the **Setup** tab.

  * By default, a single chart is produced. To create paneled charts, drag a column to the **Subcharts** control in the **Setup** tab.

  * By default, charts include tooltips for points in the chart. Drag one or more columns to the **Tooltip** control in the **Setup** tab in order to add information on those columns to the tooltips. You can also disable the tooltips by unchecking the ‘Show tooltips’ section.

---

## [visualization/copy-paste]

# Copy/paste charts

The copy/paste charts feature allows to copy charts to clipboard and paste them on same or different datasets to avoid duplication of work.

---

## [visualization/custom-aggregations]

# Custom aggregations

Custom aggregations, also known as user-defined aggregations, allow you to use your dataset columns to create new aggregations. This means that you don’t need to rely solely on predefined aggregation functions like sum, count, average, etc. Instead, you have the flexibility to combine existing columns, apply specific calculations, and define your own unique aggregations based on the requirements of your analysis. You can create unique aggregations that unlock valuable insights and enable you to perform advanced analysis tailored specifically to your data.

See also

For more information, see the [Tutorial | Custom aggregation for charts](<https://knowledge.dataiku.com/latest/visualize-data/charts/tutorial-custom-aggregation.html>) article in the Knowledge Base.

## Creating and using custom aggregations

Underneath the columns in your dataset, there is a button that enables you to generate new aggregations.

This will open an editor panel, allowing you to create your own custom aggregation using the [Formula language](<../formula/index.html>). In addition to the functions and operators of the formula language, you also have access to all aggregations available on charts.

Once created, a custom aggregations is available at the bottom of your dataset columns.

Each custom measure can be edited, duplicated and deleted.

They can then be used as measures in your charts.

## Limitations

Custom aggregations have specific limitations that need to be considered when using this feature. Firstly, custom aggregations must adhere to the structure of an aggregation. They cannot be simple calculations such as `COLUMN_1 + 10` as this would be as defining a new column rather than an aggregation. Instead, they require aggregation operations to be applied as the result of your expression, using one of the available aggregations, such as `count`, `countd`, `min`, `max`, `avg`, or `sum`.

---

## [visualization/filter-settings]

# Filter settings

Filter settings allow you to fine tune how filters are expected to behave.

* * *

## Include/Exclude other values

[](<../_images/filters-include-exclude.png>)

This option is available for alphanumerical filters and its main role is to allow to choose how values that will be added to the dataset in the future will affect the dashboard. In exclude mode, new values will be filtered out while in include mode they won’t.

Note

For dashboard filters, this option also controls whether to display or not values that are present in a filterable insight but not in the filters tile. In exclude mode, these values are filtered out while in include mode they aren’t.

A value can be displayed in a filterable insight but not in the filters tile if the underlying datasets or sampling options are different.

Dashboards default behaviour is **Exclude other values**. Charts default behaviour is **Include other values**.

## Only relevant values/All values in sample

[](<../_images/filters-only-relevant-all-values.png>)

This option is available for all filter types and allows to choose if:

  * the values available in the filter should be restricted based on the other filters: **Only relevant values**.

  * all values should be shown without taking into account the other filters: **All values in sample**.




Dashboards and Charts default behaviour is **Only relevant values**.

---

## [visualization/formatting]

# Formatting

Formatting options are options that does not change how the chart data is computed but rather how it is displayed.

* * *

## Number Formatting

By default, DSS chooses how to format numbers based on available data for both axes and measures/numerical dimensions.

In order to give you more control over how these values are formatted, several formatting options are available:

  * multiplier (thousands, millions, billions)

  * decimal places

  * digit grouping

  * prefix

  * suffix




Number formatting can be applied to:

  * axes: the formatting is applied to the axis tick labels;

  * measures/numerical dimensions: the formatting is applied everywhere a value of this measure/dimension is displayed (eg in tooltips and in the legend).




_Note: axes and measures/dimensions are independent, meaning that if you want consistency between the axes tick labels and the measure/dimension values you have to apply the same options to the axes and the measures/dimensions from their dedicated configuration menus._

## Display labels

The “Display label” option allows you to change how the field name displays in the chart

Editing the “Display label” field will affect how that label is displayed in the chart: \- for measures: tooltips and color label will be updated; \- for dimensions: tooltips will be updated.

This option is available for most charts as soon as the measure/dimension name is displayed.

## Display values/labels in chart

The “Display value in chart” and “Display labels in chart” options allow you to have the values and/or labels shown directly in the chart. These options are checkboxes that are placed on the left side of the chart, in the “Values” section.

The “Display value in chart” option is available on the following charts: \- Vertical bars \- Vertical stacked bars \- Vertical stacked bars 100% \- Horizontal stacked bars \- Horizonal stacked bars 100% \- Pie \- Donut \- Treemap

_Note: on the treemap chart, this option is present both in the “Values” section (concerns the column used as “Value”), and in each dimension’s contextual menu (concerns the columns used as “Group”)._

The “Display labels in chart” option is available for Pie and Donut charts.

Additionally, the values and labels displayed in chart can be customised. For all of the charts mentioned above, you can choose a font color, font size, add a background and change its color and opacity. The exception is the treemap chart, where you can only customise the font size. Additionally, for all bar charts, both vertical and horizontal, you can select an overlapping strategy, specifically whether to hide overlapping values or display all of them.

## Axes formatting

The axis formatting options concern axis ticks and titles. They allow you to change the font size and font color of axis ticks and titles (if shown in the chart) These customisation options are applicable for all the charts that have axes, excluding the x axis on the boxplot chart. For the charts that allow multiple y axes, it is possible to format each axis separately. These settings can be found in the Format tab.

## Legend formatting

The legend formatting options are available for all the charts that have legends. They allow you to change the font size and font color of the items in the legend.

## Conditional Formatting (KPI and pivot table)

This features allows you to color your chart with more granularity. The coloring can be based on the values displayed on the chart themselves or on another column (when data is dropped in the “Base on another column” section).

Note

Once a column is selected in one rule’s “Apply to”, it cannot be selected by other rules

The available formatting conditions also depend on the type of data being used. Below are examples for alphanumerical, numerical, and date:

For the pivot table, the conditional formatting is located under the “Format” section, in the “Color” menu, when “Custom rules” is checked:

An individual scale can be used for each column or row, provided the values are numerical, or if “Base on another column” is used with a numerical column.

---

## [visualization/hierarchies-drill-down]

# Hierarchies and drill down

## Hierarchy

Hierarchies are structured data arrangements that allow users to analyze data at different levels of granularity, moving from broader categories to more specific details through interactive drill down and drill up actions.

Their main purpose is to allow the exploration of multi-level relationships in data visualizations.

You can place up to 5 columns in a hierarchy.

### Creation

Hierarchies can be created using the button located in the footer of the list of dataset columns, as well as from the three-dot column menu.

[](<../_images/hierarchy-creation.png>)

Upon clicking one of those buttons, a hierarchy creation modal is opened. The user is then prompted to input a unique name for the hierarchy, and add from 2 to 5 columns to create the structure.

Once a hierarchy is created, it is available under the list of dataset columns. It is defined at the dataset level, and therefore can be used for all the charts within this dataset.

Hierarchies can be edited, duplicated or removed. If a hierarchy used in a chart is edited, its level will be reset to the root.

### Support

Hierarchies can be used in the following charts: vertical and horizontal bars (normal, stacked, and 100%), pie, donut, lines, mix, pivot table, treemap, radar, grouped XY, binned bubbles and rectangles, stacked areas (normal and 100%), boxplot, and lift.

## Drilling down and up in a hierarchy

The navigation between hierarchy levels is done by performing drill-down and drill-up actions.

A drill down represents a move from a general, high-level overview of data, to more specific, detailed levels within the same dataset. When a drill down action is performed, the current dimension in chart is replaced by the next-in-line dimension in the hierarchy, and a filter is added on the selected dimension value. The newly created filter is not editable. This action can be performed from the chart tooltip, and the contextual menu.

A drill up action is the opposite of the drill down action. When it is performed, the filter corresponding to the current dimension is removed, and the current dimension is replaced by the previous dimension in the hierarchy. This action can be performed from the chart tooltip, contextual menu, breadcrumb and chart header.

Hierarchy level can be changed without performing a drill action as well, when modifying dimension settings from the hierarchy drop down menu or the “Data labels” section in the formatting pane.

### Drilling on dashboards

When a chart that uses hierarchies is published to a dashboard, the drill down and up actions can be performed in the dashboard’s view mode. The drill down action, when done in a dashboard context, creates a dashboard-level filter that affects all the other tiles present in this dashboard. The drill up action removes this filter.

### Visual indicators

#### Breadcrumb

The term “Breadcrumb” refers to the hierarchy state indicator displayed under the chart using a hierarchy. It represents a path from the hierarchy root to the current chart state, including the values selected for each dimension. It can be deactivated in the formatting pane on the left side of the chart. The breadcrumb, even if deactivated, is displayed when hovering the hierarchy dimension name in the chart header. The breadcrumb is only visible when the chart is already in the drilled-down state. It can be used to perform a drill up action upon clicking on one of its elements.

Note

The breadcrumb is not available in the pivot table.

#### Chart header

When a hierarchy is used in chart, its current dimension is displayed in the chart header, followed by a drill up action button (disabled when hierarchy is at root level).

---

## [visualization/index]

# Charts

Charts are visual aggregations of data that provide insight into the relationships in your datasets.

DSS delivers an advanced data visualization engine through the Charts tab of a dataset or visual analysis. The chart-building interface is essentially the same in both locations, with the following important caveats.

  * Charts in a visual analysis can work in real-time on the output of a data preparation Script. Instead of rebuilding a dataset, simply add a step to the script and view the result immediately.

  * Charts in a dataset can be published as insights for inclusion in dashboards, while charts in a visual analysis cannot. However, when a visual analysis is deployed as a Prepare recipe, its charts can be transferred during deployment to the output dataset.

  * Charts in a dataset can make use of the in-database [execution engine](<sampling.html>), while charts in a visual analysis are always run in the DSS engine.




See also

For more information, see the [Charts](<https://knowledge.dataiku.com/latest/visualize-data/charts/index.html>) section in the Knowledge Base.

* * *

---

## [visualization/interface]

# The Charts Interface

The Charts interface has the following components:

  * The **Columns, Sampling & Engine panel** is a control with two tabs.

    * The Columns tab provides a searchable list of columns in the dataset that you can use to build charts. A special _Count of records_ column is always available.

    * The [Sampling & Engine](<sampling.html>) tab allows you to set how the dataset is processed.

  * The **Chart type selector** determines the form of the chart. Choose from the [Basics](<charts-basics.html>), [Tables](<charts-tables.html>), [Scatters](<charts-scatters.html>), [Maps](<charts-maps.html>), or [Other](<charts-other.html>) chart types.

  * **Chart definition elements** define the contents of the chart. The exact set of required elements varies by chart type. Drag and drop columns from the Columns panel to the appropriate controls here.
    
    * Measures and dimensions settings can be found in this area. To access them, click the carret before the measure/dimension name. From this carret you’ll be able to configure the element and access its [formatting options](<formatting.html>).

  * The **Publish button** creates an [Insight](<../dashboards/insights/index.html>) from the Chart and publishes it to a [Dashboard](<../dashboards/index.html>)

  * The **Common chart elements** refine the display of the chart. The **Setup** tab defines the data used in the chart and how the chart will be build; and the **Format** tab allows to customize and refine it. See [Common Chart Elements](<common.html>) for details.

  * The **Chart display** displays the currently defined chart. You can edit the title of the chart by clicking on the pencil icon.

  * The **Chart tabs** along the bottom of the display allow you to navigate between multiple charts created for the dataset. You can duplicate or delete individual charts, or click **+Chart** to create a new chart from scratch.

---

## [visualization/palettes]

# Color palettes

## Palette types

There are 3 color palette types in DSS:

### Discrete palettes

Discrete palettes are used when the color dimension is categorical, either:

  * By nature (it is a string)

  * For numerical values, if the data is binned and aggregated (which is the case of most classical charts) or if the “treat as alphanum” option has been enabled

  * For date values, if the data is binned and aggregated (which is the case of most classical charts) if a “categorical-type” breakdown has been selected. For example “day of week”




Discrete palettes define a fixed number of colors (ordered). DSS assigns a color per value. If there are more values than colors, DSS cycles between the colors.

### Continuous palettes

Continuous palettes are used when the color dimension is numerical (or date). For example, it is used on scatter plots.

Continuous palettes define a fixed number of colors. DSS interpolates between the values and the colors. The most common case is to have two colors that define the colors of the extrema of the values. DSS makes a color interpolation between these.

You can also specify multiple color stops, and DSS will make interpolations by range between these stops. By default, DSS will equally split stops, but you can also assign an explicit value to each stop.

### Diverging palettes

Diverging palettes are conceptually very similar to continuous palettes and can be used in all situations where a continuous palette can be used. Diverging palettes have at least 3 colors, and you can easily select the value for the middle color. This is often used to have one hue for “positive” values, and one for “negative” values. Very often, the middle color is white.

A diverging palette is actually the same thing as a continuous palette with 3 stops and a custom value for the middle stop.

## Quantization

Instead of fully linear interpolation, you can also request quantization: DSS will divide the color space and pick the middle color for each. This often provides more readable charts by providing a fixed color for a small range of values. Quantization can either be linear between the extrema of the values range, or based on quantiles of data points.

## Scale mode

This option refers to the function that will be used to build the color scale.

  * **Normal** : No function will be applied.

  * **Logarithmic** : Suitable for exponential patterns and data spanning several orders of magnitude. Only applicable to positive values.

  * **Square root** : Effective for reducing skewness and stabilizing variance. Typically used for non-negative data.

  * **Square** : Emphasizes larger values. Useful in scenarios where distinctions among high values must be highlighted.




## Custom palettes

DSS comes pre-bundled with a number of palettes of the 3 types. Some of the palettes in DSS include color specifications and designs developed by [Cynthia Brewer](<http://colorbrewer.org/>).

You can create custom palettes on a per-chart basis, by selecting “Custom palette” in the palette selector. You can then select:

  * the colors for a discrete palette

  * the stops (and optional associated values) for a continuous or diverging palette




Palettes created this way are local to a chart and cannot be shared between charts

You can also create reusable charts by adding them to a plugin. DSS provides a quick way to transform a custom palette into a plugin palette. For more information, see [Components: Custom chart palettes and map backgrounds](<../plugins/reference/charts-elements.html>).

## Meaning-associated palettes

If the column used for coloring has an associated custom meaning of “values list”, you can associate a color to each of the values. DSS will automatically use the palette associated to the meaning (but this can be overridden).

## Color assignations

You can easily assign a palette color to a particular dimension.

[](<../_images/palette-assign-color-to-value.gif>)

The chart will get automatically updated.

Note

Customizing these colors will override theme colors, even when a new theme is applied or the chart is published in a dashboard. Reset the customizations to use the theme colors.

---

## [visualization/qlik-qvx]

# QLIK QVX

Dataiku can export datasets to the .QVX format for loading into QlikSene and QlikView

## Setup

This capability is provided by the “qlik-qvx” plugin, which you need to intall.Please see [Installing plugins](<../plugins/installing.html>).

## Usage

The capability is an exporter to convert your datasets to the .QVX format for QlikSense and QlikView

  * Select or explore the dataset you wish to export to the .qvx format.

  * From the actions panel, use **Export**.

  * Select the format QLIK (*.qvx) and click **Download**.




You can upload the file you downloaded to your Qlik environment’s data management panel.

---

## [visualization/reference-lines]

# Reference lines

Reference lines in data visualization are horizontal or vertical lines that are used to provide a visual reference point for comparison or context within a chart or graph. They help users interpret data by indicating thresholds, or important values, enhancing the overall understanding and analysis of the visualized information.

This feature is available on the following charts:

  * Vertical bars

  * Vertical stacked bars

  * Vertical stacked bars 100%

  * Horizontal stacked bars

  * Horizontal stacked bars 100%

  * Lines

  * Mix

  * Scatterplot




They can be added and customised in the “Reference lines” section on the left side of the chart. Each chart can have multiple reference lines.

There are 4 source choices for defining reference lines:

  * **Constant Value** : To assign a static value as the reference line.

  * **Displayed Aggregation** : To aggregate values displayed in the chart (not the underlying columns). _Note: this choice is not available for scatterplots as they are inherently unaggregated._

  * **Dataset Column** : To choose from all dataset columns and apply an aggregation to it.

  * **Custom Aggregation** : To choose from all created [Custom aggregations](<custom-aggregations.html>).


[](<../_images/ref-line-sources.png>)

Additionally, when filters are applied to the chart, you have the option to choose whether to ignore filters for reference lines with sources **Custom Aggregation** or **Dataset Columns**. This functionality provides greater control over how reference lines interact with applied filters.

[](<../_images/reference-lines-ignore-filters.png>)

_Note: If the value of your reference lines exceeds the chart’s axis range, it will automatically be updated in order for the line to remain visible._

The reference lines are customisable. You can define the line’s color, stroke width, style - dashed or filled, and for charts that can have more than one y axis you have to specify which axis should the line appear on. If you decide to display the value of the reference line, you can select a prefix, a suffix, a position of the value, a multiplier and customize the font size, color, and the background of the value.

---

## [visualization/reusable-dimensions]

# Reusable dimensions

Reusable dimensions let you create and save binnings of your numerical columns, so you can reuse them easily in different charts. Instead of repeating the same steps each time you want to bin a column, you can define it once as a reusable dimension and apply it anywhere.

There are different ways to bin your data with reusable dimensions:

  * **Fixed number of equal intervals** : split the column into a chosen number of evenly sized bins.

  * **Fixed-size interval** : define how wide each bin should be, and we will create bins to cover the whole range.

  * **Custom binning** : manually set the exact edges you want for each bin.




## Creating and using reusable dimensions

To create a reusable dimension, click the three-dot menu next to a numerical column, and choose the option to create a reusable dimension.

This will open an editor panel where you can define your binning and adjust a few options. From this panel, you can also visualize the distribution of the column and preview how your current binning setup will be applied. This helps you fine-tune the configuration before saving it as a reusable dimension.

Once created, a reusable dimension appears under its associated numerical column.

Each reusable dimension can be edited, duplicated and deleted.

They can then be used as dimensions in your charts.

Note

Editing a reusable dimension that is used in multiple charts will automatically update it everywhere it is used. Similarly, deleting a reusable dimension will remove it from all charts where it was used.

---

## [visualization/sampling]

# Sampling & Engine

## Charts Execution Engines

The choice of execution engine determines how Dataiku DSS processes data for charts. DSS will automatically suggest an engine based upon the dataset and sampling settings. The DSS engine is available for all dataset types, while the In-database engine is available for some data sources that support SQL queries. See below for details.

### DSS

The DSS engine uses a highly-optimized column-based and compressed storage format, which enables it to perform blazing fast aggregations and other visual analytics queries. The DSS engine takes full advantage of modern CPU caches.

The DSS engine does not require that the chart data be loaded in memory, but is instead able to efficiently stream data from disk and perform queries on the fly. This allows you to perform visual analytics on very large data extracts that would not fit in RAM using commodity hardware.

The DSS engine extracts data from your data source, transforms it in its optimized format, and then performs all queries using the pre-optimized data. Once data has been loaded in the Charts Engine, it won’t need to access your data source anymore, unless the source data changes.

The DSS engine can therefore perform visual analytic queries on all data sources that DSS supports, even data sources that are not at all suited for analytics, like CSV files.

### In-database

In addition to the DSS Charts Engine, DSS can perform visual analytic queries directly in the database, using DB-specific SQL queries. Switching between engines can be useful, for example, to prepare your charts on a sample of the full dataset using the DSS engine and then switch to the In-database engine for full-dataset analytics.

In-database processing is available for the following datasets:

  * PostgreSQL

  * MySQL

  * Vertica

  * HDFS - Using Cloudera Impala, if it is installed and the HDFS data source is compatible with Impala.




Note

The In-database engine is not available in Visual Analyses.

## Sampling

By default, the charts engine uses the same sample defined on the Explore tab. You can define a charts-specific sample using the same [sampling options available in Explore](<../explore/sampling.html>).

Note

The DSS Charts Engine does not require data to fit in memory, however it stores its optimized format on the disk on which DSS resides.

Therefore, for large samples, you need to make sure that you have enough space on this disk to store your data extracts.

## Limit Memory Usage

### RAM

By default, DSS limits the memory usage of a chart to 150MB. In general, you shouldn’t need to adjust this, but you can increase the value to improve the performance of charts, or decrease the value to improve the performance of your server.

### Number of bins

By default, the number of bins on a chart is limited to 50000. It can be changed by editing the file `DATADIR/config/dip.properties` and set the key `dku.charts.maxBins` to the new desired limit.

---

## [visualization/sorting]

# Sorting

Sorting settings let you control the display order of values for a given dimension, including:

  * The order of ticks on the X axis.

  * The order of sub-charts.

  * The sequence of frames in an animation.




These options are available for most chart types, but only for alphanumerical dimensions:

  * Text columns.

  * Date or Numerical dimensions interpreted as text.




## Natural ordering

Natural ordering is available for:

  * Alphanumerical dimensions (including date or numerical column treated as text), where values are sorted alphabetically.

  * Date dimensions, where values are sorted chronologically.




## No sorting

No sorting is applied, dimensions values are displayed in the order returned by the database.

## By aggregated measures ascending/descending

When a measure is computed over a dimension, the values of that dimension can be sorted based on the measure, in either ascending or descending order.

## Custom

Custom sorting gives you full control over the display order of a dimension’s values.

In the dedicated dialog, you can define the maximum number of values to display, and manually reorder them.

Note: The list of reorderable elements is limited to the first 500 values.

---

## [visualization/third-party-bi-tools]

# Third-party BI tools

In addition to its native charting capabilities, Dataiku supports integrations with several third-party BI tools

## Tableau

Tableau and Dataiku are complementary solution. In a typical usage scenario:

  * Users build workflows in DSS to create complex data transformation pipelines and build machine learning models

  * Users can then push the output of these workflows directly to Tableau to be consumed by end users, using its interactive visualization and dashboarding features.




Dataiku can export datasets to a Tableau Server. This makes them directly available for charting in Tableau.

In addition, Dataiku can directly produce a .hyper file for load in Tableau Desktop.

Dataiku can also read .hyper files as datasets.

This capability is provided by the [Tableau Hyper Export plugin](<https://www.dataiku.com/product/plugins/tableau-hyper-export/>). This plugin is not supported

## Microsoft PowerBI

Warning

Microsoft will retire the capability that DSS is using to publish datasets on PowerBI on October 31st, 2027.

Should you experience any restrictions with the PowerBI API prior to this date, please submit a support ticket through Microsoft’s platform. You can find instructions on how to do so [here](<https://learn.microsoft.com/en-us/power-bi/support/create-support-ticket>).

Further details are available on the [Microsoft Power BI Blog](<https://powerbi.microsoft.com/en-us/blog/announcing-the-retirement-of-real-time-streaming-in-power-bi/>) (the comment section is not visible with all browsers and requires to accept cookies) and [Microsoft Learn](<https://learn.microsoft.com/en-us/power-bi/connect-data/service-real-time-streaming>).

Microsoft Power BI and Dataiku DSS are 2 complementary solutions. In a typical usage scenario:

  * Users build workflows in DSS to create complex data transformation pipelines and build machine learning models, possibly relying on other Microsoft technologies (such as Azure Blob Storage, Azure Data Lake Store, Azure HDInsight or SQL Server)

  * Users can then push the output of these workflows directly to Power BI to be consumed by end users, using its interactive visualization and dashboarding features.




Dataiku can export datasets to PowerBI. This makes them directly available for charting in PowerBI.

This capability is provided by the [PowerBI plugin](<https://www.dataiku.com/product/plugins/microsoft-power-bi-v2>). This plugin is not supported.

## Qlik

Dataiku can export datasets to Qlik QVX files that can be downloaded by users.

This capability is provided by the [Qlik QVX plugin](<https://www.dataiku.com/product/plugins/qlik-qvx>). This plugin is not supported.

## Microstrategy

Dataiku can export datasets to a MicroStrategy cube.

This capability is provided by the [Microstrategy plugin](<https://www.dataiku.com/product/plugins/microstrategy>). This plugin is not supported.