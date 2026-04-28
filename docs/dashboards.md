# Dataiku Docs — dashboards

## [dashboards/concepts]

# Dashboard concepts

## Dashboards, tiles and insights

A DSS project can contain multiple dashboards and each dashboard can be made of multiple pages.

Tiles can be added to pages, and the content of some can be refined directly from the dashboard using filters.

There are three kinds of tiles:

  * Simple tiles:

    * Text tile: to add some text and titles to your dashboard.

    * Image tile: to add images to your dashboard.

    * Embedded page: to add a web page to your dashboard.

    * Group tile: to group tiles together. See Group tile for more information.

  * Insight tiles. Each of these tiles displays a single insight. See [Insights](<insights/index.html>) for more information.

  * Filters panel: tile. See [Filters](<filters.html>) for more information.




### Navigation

There are different ways to navigate between multiple pages of a dashboard :

  * Using the preview on the left

  * Clicking on navigation arrows (after enabling the option to display them in the dashboard settings)

  * Using shortcuts (⌥ Option / Ctrl + → or ↓ for next and ⌥ Option / Ctrl + ← or ↑ for previous)




There is also a **circular navigation** option in the dashboard settings, allowing you to move from the last page back to the first one, and vice versa.

### Group tile

A _group tile_ is a container used to organize multiple tiles together. It helps visually and functionally group related content, and offers customization options for layout and styling.

It allows you to:

  * Frame several tiles inside a customizable container

  * Personalize the group’s background color and opacity

  * Control the spacing between tiles within the group




#### Creation

To create a group tile, switch your dashboard to **edit mode** , then use one of the following methods:

  * From the **“+ NEW TILE”** modal: select Group tile

  * By grouping existing tiles:

    1. Select multiple tiles: you can select multiple tiles using either method:

>     * **Click selection** : Hold `ctrl` (Linux/Windows) or `cmd` (macOS) and click each tile you want to include
> 
>     * **Rectangle selection** : Hold the `Shift` key and click and drag with the left mouse button to draw a rectangle. Any tile touched by the rectangle will be selected.

    2. Click the **“Group tiles”** button displayed on the left panel or use the shortcut:

>     * `ctrl` \+ `alt` \+ `G` on Linux and Windows
> 
>     * `cmd` \+ `option` \+ `G` on macOS




Any unselected tile that overlaps with the newly created group tile will be pushed to the bottom of the dashboard.

#### Editing

A group tile can be edited, rearranged and styled:

  * **Rearrange tiles** : Select the group tile, then drag and resize the tiles inside the group as needed

  * **Add tiles** : Drag and drop additional tiles from the main dashboard grid into the group tile

  * **Remove tiles** : Select the group tile, then drag a tile out of the group, into the main dashboard grid

  * **Customize** :

    * Change the **background color** and **opacity** in the group tile’s settings panel

    * Adjust the **spacing between inner tiles** in the settings panel:

      * Choose to inherit the dashboard’s default tile spacing

      * Or define a custom spacing value (in pixels)




#### Deletion

You have two options to delete a group tile:

  * **Delete the entire group and its content** : Click the trash icon in the group tile’s header.

  * **Ungroup tiles** : You can ungroup tiles to remove the container and return all inner tiles to the main dashboard grid.

>     * Click the **Ungroup** icon in the group tile’s header.
> 
>     * Select the group tile, then use the shortcut:
>
>>       * `ctrl` \+ `alt` \+ `G` on Linux and Windows
>> 
>>       * `cmd` \+ `option` \+ `G` on macOS




### Insights

An insight is a piece of information that can be shared on a dashboard. There are many kinds of insights:

  * [A dataset, as a tabular representation](<insights/dataset-table.html>)

  * [A chart](<insights/chart.html>)

  * [The report of a machine learning model](<insights/model-report.html>)

  * [The contents of a DSS managed folder](<insights/managed-folder.html>)

  * [A DSS metric](<insights/metric.html>)

  * [The report of a scenario](<insights/scenario.html>)

  * [A button to run a scenario](<insights/scenario.html>)

  * [An export from a Jupyter notebook](<insights/jupyter-notebook.html>)

  * [The display of a webapp](<insights/webapp.html>)

  * Activity & comments feed of any DSS object

  * Activity summary reports of a DSS project

  * A button to run a DSS macro




Each insight lives independently from dashboards and can be attached on multiple dashboards. By default, DSS always creates new insights when adding something to the dashboard, but you can also choose to reattach an existing insight.

Most insights _reference_ DSS objects:

  * A dataset table references a dataset

  * A chart references a dataset

  * A machine learning model report references the machine learning model

  * A DSS metric insights references a dataset, model or folder




Security is owned by the referenced objects, through the [Authorized objects](<../security/authorized-objects.html>) mechanism. In other words, if a dataset added as an authorized object with the READ mode, it is considered as ‘dashboard-authorized’, and the dashboard-only users of the project will be able to create dataset tables, charts and comment insights based on this dataset.

Insights live independently from their referenced objects. In most cases, modifying anything on the insight will either be impossible, or will not reflect in the original object.

When you are on the dashboard, you can go to a full-size view of the insight by clicking on the Go button

## Permissions

### Owners

Each dashboard (and each insight) has an owner, who is the person who created this dashboard (resp insight).

The following people (apart from the owner) can modify a dashboard created by a given user:

  * People who have “Write Dashboard” access to the project (See [Main project permissions](<../security/permissions.html>))

  * DSS administrators




### Dashboard visibility

Everybody who has “Read dashboards” permission to the project can view a dashboard, regardless of who created it: dashboards don’t carry access restrictions. However, by default, dashboards are unpromoted. An unpromoted dashboard is readable but not visible to users with “Read dashboards”.

To view an unpromoted dashboard, you need to know its URL. This makes it easy to share dashboards with colleagues by sending them the URL. People who have “Write dashboards” permission on the project can see and edit all dashboards in the list (even unpromoted ones of which they are not the owner). They can also promote a dashboard and make it visible to “Read dashboards” users.

### Sharing

You can share a dashboard with other users (including non-DSS users via email) directly from the **Actions** tab of the right-hand panel of the dashboard by selecting **Share**.

This action does the following:

  * Automatically grants the “Read dashboards” permission to the user or the pending user account (if you have “Edit permissions” on the project)

  * Sends an email with a link to the dashboard (if a valid email channel is configured on the instance)

  * Includes a screenshot of the dashboard in the email (if the instance configuration allows screenshot generation)




If the user does not exist yet, they will be invited to create an account.

Invitations by email can be disabled on the **Administration > Settings > Access & requests** page.

Note

The “Read dashboards” permission is a project-level permission: the user will be able to see all promoted dashboards of the project.

### Editing the dashboard as an analyst

When you have “Read project content” on the project, you may add every item to the dashboard, not only items which are previously dashboard-authorized.

Each time you add an item to the dashboard (either directly from the item, or from the dashboard), if this object is not already in the dashboard authorizations, you will get a warning that dashboard-only users will not be able to see this insight, since the source is not dashboard-authorized.

  * If you have “Manage authorized objects” permission, you’ll get a prompt to add it automatically

  * If you don’t have “Manage authorized objects” permission, you’ll only have a warning indicating that you must ask your project administrator

---

## [dashboards/display-settings]

# Display settings

## Tile display settings

Each [tile](<concepts.html>) on the dashboard has display settings.

Some of these settings are specific to the specific type of tile (for example, on a tile showing a chart insight, you can select whether the vertical axis must be displayed). For more information on the tile-specific settings, see [Insights reference](<insights/index.html>)

Other settings are common to all tiles

### Title display

Each tile has a title (which is by default the name of the insight, but can be edited). You can choose whether the title is displayed:

  * Never

  * Permanently

  * Only if you hover on the tile




Note that while you are on the dashboard edit view, even if you choose “on mouseover”, the title will remain visible. This option only takes effect on the “View” tab.

If you don’t display at all the title, the space for the title is reused to leave more space for the content of the tile. However, in that case, it’s not possible anymore to click on the “Go” icon to go to the insight

### Behavior on click

By default, when you click on a tile, nothing “generic” happens. Each tile kind handles clicks differently.

For example, on a chart or dataset, click will do nothing. On a webapp, the webapp itself can handle clicks. On a model report, it depends on the specific page you’re viewing.

If you want to go to the insight that the tile shows, you can click on the small Go icon in the tile header

You can also select to capture all clicks on the tile to automatically go to the insight. In that case, if you click anywhere on the tile, it will open the insight. This disables all possible mouse interaction with the tile itself.

A third option is “Open another insight”. In that case, opening on the tile will go to an insight, but not the one that the tile is displaying. You’ll need to select the other insight. A use case for this could be: a [metric insight](<insights/metric.html>) is showing a value on a dataset, and when you click, you want to open the full-width view of a [dataset table insight](<insights/dataset-table.html>) showing the content of the dataset, or a [dataset chart insight](<insights/chart.html>) showing a chart on the dataset, relevant to the metric.

## Tile positioning

### Spacing

The spacing between tiles can be set in the dashboard settings.

### Stack up tiles

You can turn on **Stack up automatically** to enter a mode where tiles are automatically rearranged whenever you move or resize them, ensuring that no vertical gaps remain. This keeps the dashboard compact and neatly organized.

To enable or disable this behavior:

  * Go to the dashboard settings and toggle **Stack up automatically**. When enabled, it will apply to all tiles across all pages of the dashboard.

  * To set the default value for all new dashboards you create, change the option in your user settings.




If the option is disabled, you can still stack tiles manually at any time:

  * Right-click on a dashboard page and select **Stack tiles up** from the contextual menu. This will remove all vertical gaps on the current page.

  * You can also perform the same action inside a group tile to remove vertical gaps within that group.




## Dashboard Format

The **format** defines the reference layout used to display dashboards and to split their content when exporting. It ensures a consistent visual appearance across screen sizes and predictable page boundaries for exports.

The format is a **dashboard-level concept** and applies to all pages and tiles of a dashboard.

### Format

Each dashboard has an associated format that defines either:

  * a **page ratio** and **orientation** (portrait or landscape) for **standard formats** (A4, US Letter, …)

  * a **custom width and height** for **Custom format**




The selected format:

  * is **persisted on the dashboard**

  * is used as the reference for PDF exports

  * is used by the dashboard renderer to ensure consistent display




Existing dashboards use **A4 landscape** as their default format, matching the historical PDF export behavior.

### Display modes

The display mode controls how the dashboard is rendered in the viewport with respect to the selected format. It can only be changed in **edit mode**.

#### Fixed aspect ratio

The dashboard is rendered using the selected format ratio.

  * Margins are added around the page so that the visible area matches the format.

  * As long as the viewport is large enough, the ratio is strictly respected.

  * When the viewport becomes too narrow, more content is displayed to preserve usability.




#### Fit to width

The dashboard always uses the full available width.

  * This may introduce vertical scrolling.

  * The visible portion of the dashboard depends on the viewport width.




### Visual separator

Dashboards can display a **visual separator** to help understand how the content relates to the selected format.

The separator represents:

  * the **end of the visible screen**

  * the **page boundary used for export** (end of page)




Depending on the dashboard height, multiple separators may be visible at once, corresponding to successive export pages.

The visual separator:

  * is displayed as a horizontal guide

  * is **not part of the dashboard content**

  * is only visible in **edit mode**

  * is visually distinct from the page content




The separator can be enabled or disabled from the dashboard settings.

### User defaults

Users can define default format settings in their **profile settings** :

  * a default **display mode** ,

  * a default **page format** (ratio and orientation).




These defaults apply only to newly created dashboards.

---

## [dashboards/exports]

# Exporting dashboards to PDF or images

Dashboards can be exported to PDF or image (PNG, JPG) files in order to propagate information inside your organization more easily.

Dashboard exports can be:

  * created and downloaded manually from the dashboard interface

  * created automatically and sent by mail using the “mail reporters” mechanism in a scenario

  * created automatically and stored in a managed folder using a dedicated scenario step




If the exported dashboard has filters applied to it, these filters will be re-used to build the export.

## Setup

The dashboards export feature must be setup prior to being usable.

Follow [Setting up DSS item exports to PDF or images](<../installation/custom/graphics-export.html>) to enable the export feature on your DSS instance.

## Manual usage

In dashboard tab, there are three ways to download it directly:

  * Inside dashboard menu in edit and view mode. In view mode, any filter changes will be used to build the export even if they are not persisted in the dashboard itself.




  * After selecting a dashboard in the list, go to actions tab.




  * Inside dashboard menu in list mode. With this one, you can select multiple dashboard exports and export it in one click. Pretty neat, right?




## Automatic usage

In a scenario, there are two ways to create dashboard exports:

  * Create a “dashboard export” step that allows you to store an export in a local managed folder.




  * With a mail reporter and a valid mail channel, you can select a “dashboard export” attachment. The dashboard will be attached to the mail




## Settings

Files generated are fully customizable so users are fully in control over what they obtain. There are several parameters that will enable it:

  * **File type** , to select the type of files to generate (PDF, PNG, or JPEG).

  * **Export format** , to determine image dimensions. Users can either:

    * **Use the dashboard’s format** as defined in the dashboard settings (see [Dashboard Format](<display-settings.html#dashboard-format>))

    * **Specify a custom export format** with exact width, height, and orientation

  * If a **standard format** (A4 or US Letter) is chosen, image dimensions will be exported using the selected orientation (Landscape or Portrait).

  * **Custom formats** allow specifying exact width and height for the export.

---

## [dashboards/filters]

# Filters

Filters can be applied to a dashboard page to refine its insights.

They remove data from all filterable insights on the page, enabling you to explore the data and focus on what matters.

Filterable insights are:

  * charts

  * dataset tables




Note

Chart and dataset insights can be filtered themselves. Dashboard filters are applied on top of insight filters.

## The filters panel

You can add filters to the filters panel in edit mode, or through cross-filtering from the chart and dataset table insights in view mode.

For more information about cross-filtering, see the Cross-filtering section below.

The filters panel offers different options depending on the mode you are in.

  * In View mode, you can interact with any filters that already exist in the panel. You can only add new filters using cross-filtering (if enabled).

  * In Edit mode, you can add and remove filters as well as configure their default states. You can also access the individual filter settings or the panel configuration options.




Note

Both modes allow disabling all the filters in the panel as well as expanding or collapsing all the filters at once. Please note that these options won’t be saved, even in Edit mode.

### Filters in View mode

In View mode, you can explore the data by interacting with the filters created by the dashboard owner. If cross-filtering is enabled, you can also create new filters from chart and dataset table insights.

You are only modifying your local instance of the dashboard page. Any changes made in View mode will be lost when exiting the dashboard. If you want to save or share the modifications you applied on filters, see [Filtering a dashboard using a query parameter in the URL](<url-filters-query-param.html>).

### Filters in Edit mode

In Edit mode, you can define which filters will be applied to the dashboard page as well as how they will be presented on the page.

When adding your first filters on a page, you will need to select a dataset. You can either pick an existing tile to automatically reuse its underlying dataset, or manually search for a dataset.

The columns of the chosen dataset can then be selected to create filters.

When adding filters on a page that already had filters, you will only need to choose from which columns.

To change from which dataset to add filters from, start by removing all the filters in the filters panel, and start again the process of adding filters. This way, you’ll be asked to select a dataset.

You can quickly remove all filters in the panel using the “Remove all filters” entry in the panel menu.

Note

To reorder filters, use your mouse to drag and drop them at the preferred locations.

In Edit mode, filter default states can be defined in the filter settings menu. You will also decide if their facet should display “Only relevant values” - the values remaining after other filters are applied, or if it should display “All values in sample” - every value regardless of other filters.

In the filter settings menu, you can also choose between “Include other values” or “Exclude other values.” This allows you to decide if new values added to the dataset or values absent from the filter facet but present in other insight samples should be included or excluded.

For more information about filter settings, see [charts filter settings](<../visualization/filter-settings.html>).

In Edit mode, you can choose where the filters panel will be positioned. The available positions are at the top, at the left, at the right, or inside the page as a tile.

Note

While it is not encouraged, you can change which engine (DSS or SQL) is used to process the filters, and which sampling to apply using the “Sampling & Engine” entry in the panel menu. By default, the filters panel uses the same engine as the selected dataset and uses all its data (no sampling).

## Cross-filtering

In view mode, you can create filters from chart and dataset insights. This action is called cross-filtering. Filters created using cross-filtering are added to the filters panel and applied to all filterable tiles on the dashboard page.

Two kinds of filters can be created using cross-filtering: \- “Include only”: only the filtered value will be kept and displayed in the filterable tiles. \- “Exclude”: the filtered value will be discarded from the filterable tiles.

If your chart is multidimensional you’ll be able to choose between including/excluding all dimensions at once and selecting which dimension to include/exclude.

Note

Using the multidimensional “Include only” will give the same result as using the unidimensional “Include only” on all the dimensions. However, using the multidimensional “Exclude” will discard the rows satisfying all the conditions, while using the unidimensional “Exclude” on all the dimensions will discard the rows satisfying at least one of the conditions.

### From a chart insight

To cross-filter from a chart insight, you can hover the data point of interest and then either:

  1. right-click to open a contextual menu from which all filtering actions are available.




  2. click on the data point to pin the tooltip. Once the tooltip is pinned, a filter icon will appear next to each dimension, allowing cross-filtering.




### From a dataset insight

To cross-filter from a dataset insight, hover the cell of interest and open the contextual menu by right-clicking on it. In the contextual menu, click on the “Include only” entry to cross-filter.

### Filters created using cross-filtering

When possible, cross-filtering updates the filters present in the filters panel. For example, suppose the filters panel contains a filter on the numerical column “Age” and the filter is created using cross-filtering on the same column. In that case, the cross-filtering value will be applied to the existing filter.

When updating an existing filter is impossible, either because there is no matching filter in the filters panel or because of a filter type incompatibility, a new filter with a minimal UI will be created. In this case, the filter’s value won’t be editable, but the filter will be deactivatable and removable.

### Turning cross-filtering on or off

Cross-filtering is enabled by default for dashboard pages containing a filters panel. To disable cross-filtering in this case, switch to edit mode, and in the “Slide” tab, uncheck the “Cross-Filtering” option under the “Filters” section.

If a dashboard page doesn’t contain a filters panel, cross-filtering is disabled, and a filters panel needs to be added to enable cross-filtering.

---

## [dashboards/index]

# Dashboards

Dashboards allow you to share elements of your data project, either with other analysts working on the project, or with users who don’t have full access to the project.

This section details reference material about dashboards. We recommend that you have a look at DSS sample projects and [the public DSS gallery](<https://gallery.dataiku.com/home/>) to get familiar with what dashboards can do.

See also

For more information, see the [Dashboards](<https://knowledge.dataiku.com/latest/visualize-data/dashboards/index.html>) section in the Knowledge Base.

---

## [dashboards/insights/chart]

# Chart

A chart insight shows a chart from the [data visualization](<../../visualization/index.html>) component of DSS.

A chart insight shows a chart based on a dataset. Charts built in a visual analysis cannot be published to the Dashboard.

## Publishing a chart insight

You can publish a chart insight from several locations:

### From a dataset

Note

This method is only possible if you have at least the “Read project content” permission.

When you are designing charts in the “Charts” tab of a dataset, once you are satisfied you can click on the “Publish” button.

This will copy the current chart to a new insight and publish it on a dashboard. Further modifications in the insight will not be reflected in the dataset chart, and further modifications in the dataset chart will not be reflected in the insight.

### From the dashboard

Click on the + button to add tiles. Select chart, then select the dataset on which you want to create a chart. If you only have dashboard access, you will only see the datasets that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

You are redirected to the “Edit” view of the insight, which is similar to the regular DSS charts editor. See [Charts](<../../visualization/index.html>) for more information. Design your chart and save it.

When you go back to the dashboard, the tile shows your newly created chart.

## Tile display

The tile display of a chart only displays the chart itself. It does not display filters. You can choose whether you want to display the axis, legends and tooltips.

## View and edit insights

If you have write access to the chart insight, you can modify all settings (axis, legends, filters, …) in the Edit view of the insight.

If you only have read access, you can only see the chart and cannot modify the axis and displayed data in the “View” display. You can modify the filters but your changes to filters will not be persisted.

Changes to filters are only persisted if they are done in the “Edit” view by someone who has write access to the insight (and the insight is then saved)

---

## [dashboards/insights/data-quality]

# Data Quality

The Data Quality insight allows you to publish dataset or project level aggregated information about your [Data Quality rules](<../../metrics-check-data-quality/data-quality-rules.html>).

## Publishing a Data Quality insight

You can publish a Data Quality insight from several locations:

### From the Data Quality current status page

From the Dataset _Data Quality_ tab, you can click the action buttons, in the _Current dataset status_ tile, or in the _Status breakdown_ tile. Each will allow you to publish the corresponding dataset view to a dashboard.

Note

The breakdown view will provide a per-rule breakdown for a non-partitioned dataset, or a per-partition breakdown for partitioned datasets. If some rules are computed on the full dataset, ‘Whole dataset’ it is considered as a partition in the breakdown.

Similarly, in the project Data Quality page, the _Current project status_ and _Status breakdown_ tiles allow you to publish the corresponding project view to a dashboard.

### From the dashboard

Click on the + button to add tiles. Select _Data quality_ , then select the data source for which you want to display the Data quality status. If you only have dashboard access, you will only see the datasets that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

Choose the view mode (Current status or Status breakdown) and a title.

## Tile display

The tile can display either:

  * The current status of the dataset / project

  * The dataset / project status breakdown

---

## [dashboards/insights/dataset-table]

# Dataset table

A “dataset table” insight shows the dataset in a view fairly similar to the [Explore](<../../explore/index.html>) view of a dataset.

## Publishing a dataset table insight

You can publish a dataset table insight from several locations:

### From a dataset

Note

This method is only possible if you have at least the “Read project content” permission.

Either from the dataset’s view, or from the Flow, click on the “Publish” button in the Actions column of the dataset.

This creates a new insight pointing to the dataset.

### From the dashboard

Click on the + button to add tiles. Select dataset table, then select the dataset for which you want to show the data. If you only have dashboard access, you will only see the datasets that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

You are redirected to the “Edit” view of the insight, which is similar to the Explore view of DSS.

When you go back to the dashboard, the tile shows the dataset

## Tile display

The tile display of a “dataset table” displays the table. You can customize which elements are displayed. You cannot view or configure filters in the file.

For Elasticsearch datasets, the tile can also display the “[Search](<../../connecting/elasticsearch.html#search-view>)” tab, to allow users searching interactively in a dataset. Saved queries can be used but can not be created.

## View and edit insight

If you have write access to the chart insight, you can modify all settings, like in a regular dataset Explore (sampling, filters, displayed columns, sorting, coloring) in the Edit view of the insight.

If you only have read access, you can only see the table and cannot modify most elements. You can modify the filters but your changes to filters will not be persisted.

Changes to filters are only persisted if they are done in the “Edit” view by someone who has write access to the insight (and the insight is then saved).

The “[Search](<../../connecting/elasticsearch.html#search-view>)” tab is not available in insights for Elasticsearch datasets.

---

## [dashboards/insights/index]

# Insights reference

This section details the behavior and options of each type of insight (and associated tile) in DSS.

---

## [dashboards/insights/jupyter-notebook]

# Jupyter Notebook

A “Jupyter notebook” insight shows a snapshot (called an export) of the content of a Jupyter (Python, R, Scala) notebook. For more information, see [Code notebooks](<../../notebooks/index.html>).

The insight only shows a static snapshot, it does not show the “current” version of the notebook. The insight does not give the possibility to modify or run the notebook.

Note

Unlike most other insights, a Jupyter notebook must first be published at least once by a user with “Write project content” permission on the project and “Write safe code” global permission.

Once this user has published a first time the notebook, other users can create insights pointing to it and add them on their dashboards

There can be several exports of the same Jupyter notebook. In the insight, you can choose between the different versions. This allows you to show the notebook at different points in time.

## Publishing a Jupyter notebook insight

You can publish a Jupyter notebook insight from several locations:

### From the notebook

Note

This method is only possible if you have at least the “Write project content” permission, and the permission to create Jupyter notebook

Go to the Jupyter notebook. From the Actions menu, click on the “Publish” button. This action is also possible from the notebooks list.

This actually does three actions:

>   * Create a snapshot (an export) of the Jupyter notebook
> 
>   * Create an insight pointing to the notebook. The insight will display the latest snapshot
> 
>   * Add the insight to the specified dashboard
> 
> 


### From the dashboard

Click on the + button to add tiles. Select “Jupyter notebook”, then select the notebook for which you want to show the export.

If you only have dashboard access, you will only see the notebooks that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

## Tile display

The tile display of a “Jupyter notebook” insight shows the content of the notebook. In the tile settings, you can select whether the code should be shown or not.

## View and edit insight

The View page of the Jupyter notebook insight shows the content of the notebook.

If you have write access to the insight, you can go to the Edit tab, where you can select between the different exports.

If you have “Write project content” access to the project and the permission to write code, you’ll be able to create a new export.

---

## [dashboards/insights/managed-folder]

# Managed folder

A “managed folder” insight shows the content of a [DSS managed folder](<../../connecting/managed_folders.html>).

There actually two kinds of insights depending on what you want to display:

  * Display the listing of the files in the folder (with preview). This gives the ability to download each file or the whole folder content, as a .zip file

  * Display the preview of a single file. This gives the ability to download the file. Note that downloading other files is not exposed but still technically feasible: the permissions granularity is the managed folder, not the file.




## Publishing a managed folder insight

You can publish a managed folder insight from several locations:

### From the managed folder

Note

This method is only possible if you have at least the “Read project content” permission.

#### To publish a “whole folder insight”

Either from the folders’s view, or from the Flow, click on the “Publish” button in the Actions column of the folder.

This creates a new insight pointing to the folder.

#### To publish a “single file insight”

From the folder’s view, select the file to display, and click on the Publish button next to the file name. This creates a new insight pointing to the file.

### From the dashboard

Click on the + button to add tiles. Select folder, then select the folder you want to display. If you only have dashboard access, you will only see the datasets that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

Select whether you want to publish a “whole folder insight” or a “single file insight”. In the latter case, select the file.

## Tile display

There are no tile display specific options for the managed folder insight.

## View and edit insight

The “View” tab of the insight offers the additional download options. It is not possible to modify anything in the insight. All editions must be done in the source managed folder.

---

## [dashboards/insights/metric]

# Metric

The metric insight allows you to publish a [metric](<../../metrics-check-data-quality/metrics.html>) about any supported object (dataset, saved model, managed folder or model evaluation store).

## Publishing a metric insight

You can publish a metric insight from several locations:

### From the metrics view

Note

This method is only possible if you have at least the “Read project content” permission.

From the metrics view, either in a dataset, saved model or managed folder, you can click on the caret next to each metric, and click Publish

### From the dashboard

Click on the + button to add tiles. Select metric, then select the data source for which you want to display a metric. If you only have dashboard access, you will only see the datasets, models and folders that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

Choose the metric to display. You can only add metrics which have already been computed.

## Tile display

The tile can display either:

  * The current value of the metric as a large display (either a number, a histogram or a list of values).

  * The history values




## View insight

The full-size view of the insight always displays the history value of the metric.

No edition is possible on the metric insight.

---

## [dashboards/insights/model-report]

# Model report

A “model report” insight shows the result screens of the active version of a saved model (deployed in Flow).

A model report insight cannot show a model which is still living in a visual analysis. Only models that have been deployed to the Flow can be put in a model report insight. For more information, see [Machine learning](<../../machine-learning/index.html>)

## Publishing a model report insight

You can publish a chart insight from several locations:

### From the model version

Note

This method is only possible if you have at least the “Read project content” permission.

Go to the saved model in the Flow and open the active version. From here, click on the “Publish” button.

This creates a new insight pointing to the saved model.

### From the dashboard

Click on the + button to add tiles. Select “model report”, then select the model for which you want to show the data. If you only have dashboard access, you will only see the models that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

## Tile display

The tile display of a “model report” shows a single report page (summary, variables importance, decision chart, confusion matrix, …). In the tile settings, you can select which page to show.

If you want to show multiple pages, you can create several tiles based on the model report insight. To do that, click on the + button, select “Pick existing”, and pick the model report insight that you previously created. The new tile can show a different page of the same insight.

## View insight

The View page of the saved model report insight shows all the pages, in an interface similar to the regular models result page of DSS.

Note that you cannot edit anything in that insight view (threshold, cost matrix gain, cluster hierarchy, …), even if you have write access to the project.

All modifications must be done in the original model.

---

## [dashboards/insights/scenario]

# Scenarios

DSS provides two very different kinds of insights about [scenarios](<../../scenarios/index.html>).

## Scenario runs report

This insight displays a timeline of the last runs of a specific scenario, on a configurable time period. It is very similar to the view available per scenario in View > Last runs, or for multiple scenarios in Automation

  * Display the listing of the files in the folder (with preview). This gives the ability to download each file or the whole folder content, as a .zip file

  * Display the preview of a single file. This gives the ability to download the file. Note that downloading other files is not exposed but still technically feasible: the permissions granularity is the managed folder, not the file.




### Publish

You can publish a scenario runs report insight from several locations:

#### From the scenario

Note

This method is only possible if you have at least the “Read project content” permission.

From the scenario’s action menu, click Publish. This creates a new runs report insight.

#### From the dashboard

Click on the + button to add tiles. Select scenario, then select “Last runs” and the scenario for which you want to display the timeline. If you only have dashboard access, you will only see the datasets, models and folders that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

### Tile display

In the tile display, you can configure between various display modes for the timeline of past runs, and select a predefined time range over which scenario runs should be displayed.

### Insight view

The insight full view gives you more advanced browsing capabilities in the scenario history. It is not possible to edit anything for a scenarios runs report insight.

Changing time range in the full view does not reflect on the tile.

## Run a scenario button

You can also create a “Run scenario” insight. This insight displays a button that allows dashboard-only users to run a scenario.

This insight gives some form of write access to people who don’t normally have this kind of access, so you want to carefully evaluate the security implications of this insight.

A scenario whose run button is exposed on the dashboard always runs as the “Run as” user of the scenario (see [Automation scenarios](<../../scenarios/index.html>) for more information). It does not run as the user who clicked the button (since the user who clicked the button might not have requested permissions on the data sources). However, the [DSS audit log](<../../security/audit-trail.html>) will include information about the user who clicked the button.

### Publish

Note

You can only publish a “Scenario run” button if you have the “Read project content” permission.

Click on the + button to add tiles. Select scenario, then select “Run button” and the scenario for which you want to create a run button

### Dashboard authorization

Like for all other types of insights, a dashboard authorization. The “Scenario run” button needs a special “Run” permission on the dashboard authorization. This can be configured in the Dashboard authorizations page in the project settings.

If, when you create the Scenario run button, you have the “Manage dashboard authorizations” permissions, the run dashboard authorization is automatically granted.

### Tile display

The tile displays a big “Run” button, which turns into a “Running” info while the scenario is running. You can also click to Abort while the scenario is running.

There are no tile display specific options for the Scenario run button insight.

### View and edit insight

There is no full-size view for this insight

---

## [dashboards/insights/webapp]

# Webapp

A “webapp” insight displays the content of a [DSS webapp](<../../webapps/index.html>).

The insight is a read-only view of the webapp. For a webapp to be displayable in the dashboard, it must have been “run” at least once in the webapp editor.

## Publishing a webapp insight

You can publish a webapp insight from several locations:

### From the webapp

Note

This method is only possible if you have at least the “Read project content” permission.

From the Webapp’s view, click on Actions > Publish.

This creates a new insight pointing to the webapp.

### From the dashboard

Click on the + button to add tiles. Select “Webapp”, then select the webapp that you want to display. If you only have dashboard access, you will only see the datasets that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

## Tile and insight display

Both the tile view and the full insight view display the content of the webapp. It is not possible to modify anything in the insight. All editions must be done in the webapp editor.

## Accessing dashboard filters

[“Standard” web apps](<../../webapps/standard.html>) can access the dashboard filters by listening for messages sent from the dashboard. This allows to dynamically adjust the content of the webapp based on the filters applied in the dashboard.

Here is an example of how to access the dashboard filters using JavaScript:
    
    
    window.addEventListener('message', function(event) {
      const data = event.data;
      if (data && data.type === 'filters') {
          console.log(data.filters); // the filters
      }
    });
    

This code listens for messages sent to the webapp. When a message of type ‘filters’ is received, it logs the filters and their parameters to the console. You can use this information to update the webapp’s display dynamically.

---

## [dashboards/insights/wiki-article]

# Wiki article

A “wiki article” insight shows the rendering of the text of a particular [wiki article](<../../collaboration/wiki.html>).

## Publishing a wiki article insight

You can publish an article insight from the dashboard itself.

### From the dashboard

Click on the + button to add tiles. Select “article”, then select the article you want to show. If you only have dashboard access, you will only see the articles that have previously been [dashboard-authorized](<../../security/authorized-objects.html>).

---

## [dashboards/url-filters-query-param]

# Filtering a dashboard using a query parameter in the URL

If a dashboard contains filters, it can be pre-filtered by defining the filters default state in Edit mode.

However, in View mode changes are not kept. To share or bookmark a dashboard pre-filtered from the View mode, you can add a query string parameter to the dashboard URL and share or bookmark it.

Note

If filters are present in the dashboard page’s filters panel but absent from your URL, their default state will be applied.

## Generating a URL from a filters panel

The fastest and easiest way to create a ready-to-use dashboard URL with a filters query parameter is to open the dashboard, edit the filters to match the expected state, and click on the “Copy as URL in clipboard” button.

[](<../_images/filters-copy-as-url.png>)

Once the URL is ready, you will get a notification and it will be available in your clipboard so you can paste it wherever you want.

Note

Opening a generated URL with a filters query parameter ensures that the insights in the dashboard are filtered as they were at generation time. The values available in the filter facets can be restricted to what’s shown without the possibility to extend the selection. To be able to select more values, open a filter settings menu and switch to “All values in sample” mode.

## Filters query parameter syntax

You will see below that the filters query parameter value uses a syntax that can be understood and written by humans. However, it contains special characters that browsers will fail to parse. Once your filter query parameter value is ready, do not forget to encode it before appending it to the dashboard URL (many tools can be found online to encode a URL).

For example:
    
    
    https://mydssinstance.com/projects/MYPROJECT/dashboards/42?pageFilters=foo:in("bar")
    

becomes:
    
    
    https://mydssinstance.com/projects/MYPROJECT/dashboards/42?pageFilters=foo%3Ain%28%22bar%22%29
    

### Value types

#### Column name

Column names are on the left part of a filter description, and they are always followed by a colon that separates the column name from the filter values. Special characters (any character that is not a letter or a digit) must be encoded. To encode a special character, use its hexadecimal ASCII code padded with 0 if necessary so that the code is 4 characters long, prefixed by `_x` and suffixed by `_`.

For example `Weight: maximum`` becomes ``Weight_x003A__x0020_`maximum``. The hexadecimal ASCII code of : is `3A`. We pad it with two zeros to have a 4-digit code, it gives us `003A`. Then, we add the prefix and suffix and obtain the final encoded version `_x003A_`. The same reasoning is applied to the space characters: its hexadecimal ASCII code is `20`, padded it gives `0020`, and with the prefix and suffix `_x0020_`.

#### String

A String is wrapped in double quotes. Double quotes and backslashes within the string content must be escaped by prefixing them with a backslash. For example `"Hello", \ he says` becomes `"\"Hello\", \\ he says"`.

#### ISO Date

An ISO Date is defined by the ISO 8601 norm and doesn’t need any special formatting. For example, a valid ISO Date is `2023-01-01T00:00:00.000Z`.

#### Number

A Number is either an integer or a rational number and doesn’t need any special formatting.

#### Constants

Constants are used to describe specific states. They are written using snake case with all uppercase letters. The different special tokens are:

  * `OFF`, used to describe a deactivated filter. For example: `ColumnName:OFF`;

  * `NO_VALUE`, used to describe the absence of value (ie an empty cell in a dataset);

  * `HOUR_OF_DAY`, `DAY_OF_WEEK`, `DAY_OF_MONTH`, `MONTH_OF_YEAR`, `WEEK_OF_YEAR`, `QUARTER_OF_YEAR`, `YEAR`, used to describe the date part on which a date part or relative date filter is applied;

  * `drilled()`, a suffix used to mark filter coming from a drill down action, it can be used with alphanumerical include only filter, numerical range filter, or date range filter.




### Alphanumerical filter

Alphanumerical filters can either specify a list of values to include, in case the `in` operator will be used, or a list of values to exclude, in case the `nin` operator will be used.

These operators can contain a list of values. These values are separated by commas and can be:

  * Strings for alphanumerical filters based on alphanumerical columns;

  * Numbers for alphanumerical filters based on numerical columns.




To filter on a column named City so as to include only Paris and New York:
    
    
    ?pageFilters=City:in("Paris","New York")
    

Note

When using this syntax, the filter is in “Exclude other values” mode.

To filter on a column named Age so as to exclude 42 and 66:
    
    
    ?pageFilters=City:nin(42,66)
    

Note

When using this syntax, the filter is in “Include other values” mode.

### Custom filter

Custom filters specify a list of values with normalization applied to the column and how to search, with the combination of `in()`, `.match()`, `.normalization()` operators.

The `in()` operator can contain a list of values. These values are separated by commas and can be:

  * Strings for alphanumerical filters based on alphanumerical columns;

  * Numbers for alphanumerical filters based on numerical columns.




The `match()` operator contains a list of constant values:

  * **FULL_STRING** : Will perform a match on the full string

  * **SUBSTRING** : Will perform a match on a part of the string

  * **REGEX** : Will perform a match with regular expression




The normalizations are:

  * **EXACT** : Case sensitive

  * **IGNORE_CASE** : Case insensitive

  * **NORMALIZED** : Transform to lowercase, remove punctuation and accents and perform Unicode NFD normalization (`Café` -> `cafe`)




To filter on a column named City to get all cities that contain an `e` ignoring the case:
    
    
    ?pageFilters=City:in("e").match(SUBSTRING).normalization(IGNORE_CASE)
    ?pageFilters=City:in("[eE]").match(REGEX)
    

Note

When using this syntax, the filter is in “Exclude other values” mode.

### Numerical range filter

Numerical range filters can only be applied to numerical columns and use the range operator. This operator takes two optional Number parameters: a minimum value and a maximum value, separated by a comma (`,`).

To filter on a column named Age so as to restrict the values from 24 to 42:
    
    
    ?pageFilters=Age:range(24,42)
    

To filter on a column named Age so as to restrict the values to at least 24:
    
    
    ?pageFilters=Age:range(24)
    

To filter on a column named Age so as to restrict the values to at most 42:
    
    
    ?pageFilters=Age:range(,42)
    

To filter on a column named Age so as to include all values:
    
    
    ?pageFilters=Age:range()
    

### Date range filter

Date range filters can only be applied to date columns and use the daterange operator. This operator takes two optional ISO Date parameters: a minimum value and a maximum value, separated by a comma (`,`).

To filter on a column named Birthday so as to restrict the values from a date to another:
    
    
    ?pageFilters=Birthday:daterange(2022-01-01T00:00:00.000Z,2023-01-01T00:00:00.000Z)
    

To filter on a column named Birthday so as to restrict the values from a date:
    
    
    ?pageFilters=Birthday:daterange(2022-01-01T00:00:00.000Z)
    

To filter on a column named Birthday so as to restrict the values until a date:
    
    
    ?pageFilters=Birthday:daterange(,2023-01-01T00:00:00.000Z)
    

To filter on a column named Birthday so as to include all values:
    
    
    ?pageFilters=Birthday:daterange()
    

### Date part filter

Date part filters can be applied to date columns only and use two operators:

  * the `datepart` operator taking a date part constant as parameter;

  * either the `in` or `nin` operator depending on whether the values should be included or excluded and taking as parameters a list of comma delimited values that are Strings for days and months and Numbers for other date parts.




The two operators are separated by a dot (`.`).

Example of a date part filter on a column Birthday to include dates from the years 2022 and 2023:
    
    
    ?pageFilters=Birthday:datepart(YEAR).in(2022,2023)
    

Example of a date part filter on a column Birthday to exclude dates corresponding to Mondays and Wednesdays:
    
    
    ?pageFilters=Birthday:datepart(DAY_OF_WEEK).nin("Monday","Wednesday")
    

### Relative date filter

Relative date filters can only be applied to date columns and use at least two operators:

  * the `datepart` operator taking a date part constant as a parameter;

  * Operators such as `this`, `ts`, `next`, or `last` that can be combined together. Among these, `this` and `ts` do not require any parameters, while `next` and `last` necessitate one Number parameter.




Example of a relative date filter on a column Birthday to include values in the current day of week:
    
    
    ?pageFilters=Birthday:datepart(DAY_OF_WEEK).this()
    

Example of a relative date filter on a column Birthday to include values in the year to date (until now):
    
    
    ?pageFilters=Birthday:datepart(YEAR).td()
    

Example of a relative date filter on a column Birthday to include values in the next 3 months:
    
    
    ?pageFilters=Birthday:datepart(MONTH_OF_YEAR).next(3)
    

Example of a relative date filter on a column Birthday to include values in the last 3 months:
    
    
    ?pageFilters=Birthday:datepart(MONTH_OF_YEAR).last(3)
    

Example of a relative date filter on a column Birthday to include values from the last week to the end of the current one:
    
    
    ?pageFilters=Birthday:datepart(WEEK_OF_YEAR).last(1).this()
    

Example of a relative date filter on a column Birthday to include values from the last week until now:
    
    
    ?pageFilters=Birthday:datepart(WEEK_OF_YEAR).last(1).this().td()
    

Example of a relative date filter on a column Birthday to include values from today until tomorrow:
    
    
    ?pageFilters=Birthday:datepart(DAY_OF_WEEK).this().next(1)
    

Example of a relative date filter on a column Birthday to include values from the last 2 months, the current month, and the next 3 months:
    
    
    ?pageFilters=Birthday:datepart(MONTH_OF_YEAR).last(2).this().next(3)
    

### Multidimensional exclude filters

Multidimensional exclude filters offer a method for combining multiple conditions to exclude data that satisfy all specified criteria.

Filters eligible for this type of combination include:

  * Alphanumerical filters in include mode (using the `in` operator) with exactly one value;

  * Date part filters in include mode (using the `in` operator) with exactly one value;

  * Numerical and date range filters with both a min and a max.




To form a multidimensional exclusion condition, combine these filters using the “not” operator:

Example of a multidimensional filter excluding all data points for which City is equal to New York, Birthdate is a date for which the month is January, and Age is between 0 and 18:
    
    
    ?pageFilters=not(City:in("New York");Birthdate:datepart(MONTH_OF_YEAR).in("January");Age:range(0,18))
    

### Multiple filters at once

If you need multiple filter facets in your URL, separate them with semicolons (`;`).

Example of multiple filter facets:
    
    
    ?pageFilters=City:in("Paris","New York");Age:range(24);Birthday:datepart(YEAR).nin("2022","2023")
    

Once encoded and appended to the URL:
    
    
    https://mydssinstance.com/projects/MYPROJECT/dashboards/42?pageFilters=City%3Ain%28%22Paris%22%2C%22New%20York%22%29%3BAge%3Arange%2824%29%3BBirthday%3Adatepart%28YEAR%29.nin%28%222022%22%2C%222023%22%29