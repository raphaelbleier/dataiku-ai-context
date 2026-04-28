# Dataiku Docs — data-lineage

## [data-lineage/access]

# How to access

You can access lineage for a column of interest in several ways:

  * In the top bar menu, under Operations & Monitoring, click on the Data Lineage item.

  * In the Explore tab of a dataset, a Prepare recipe, or visual analysis script, open your column’s dropdown menu and click on See column lineage.

  * In the right panel of a dataset, open the Schema tab and click on the lineage icon next to your column.

---

## [data-lineage/graphics-export]

# Exporting lineage graph to PDF or images

The lineage graph can be exported to PDF or image (PNG, JPG) files in order to share a snapshot of lineage details within your organization more easily.

## Setup

The graphics export feature must be setup before lineage can be exported.

Follow [Setting up DSS item exports to PDF or images](<../installation/custom/graphics-export.html>) to enable the export feature on your DSS instance.

## Manual usage

In the Data Lineage view, click “EXPORT” at the bottom.

## Settings

Files generated are fully customizable. The following parameters are available:

  * File type, to select the type of files to generate (PDF, PNG or JPEG).

  * Export format, to determine image dimensions.

>     * If a standard format (A4 or US Letter) is chosen, image dimensions will be calculated based on the size of your lineage graph and the chosen orientation (Landscape or Portrait). On the contrary, Custom format allows you to configure a custom width and height.

---

## [data-lineage/index]

# Data Lineage

With **Data Lineage** , you can track how column-level data is transformed across datasets and projects within your organization’s Dataiku instance. The data lineage view captures “direct” lineage between columns, which means that the transformation impacts the values of the output column directly.

From this view, you can investigate a column’s lineage both upstream and downstream to track the origin of a data issue or notify stakeholders of changes to downstream pipelines.

---

## [data-lineage/manual-lineage]

# Manual lineage

For some recipes and prepare recipe steps, column lineage might not be certain. For example, it’s not currently possible to generate certain lineage for code recipes or transformations that create new columns from rows (e.g. pivot recipe, split and unfold processor, etc). In these scenarios, the lineage is built with simple name-based matching, and you’re able to manually edit the lineage easily from the UI.

You can access the manual lineage settings from:

  * The Data Lineage view: blue icon on uncertain recipes.

  * The advanced settings tab of a recipe.




Note

“Manual lineage only” mode allows you to restrict the Data Lineage to columns manually selected in the modal, removing any automatically computed lineage for a given recipe.