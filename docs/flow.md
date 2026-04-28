# Dataiku Docs — flow

## [flow/building-datasets]

# Rebuilding Datasets

When you make changes to recipes within a Flow, or there is new data arriving in your source datasets, you will want to rebuild datasets to reflect these changes. There are multiple options for propagating these changes. This page illustrates the case of Datasets, but is also valid for Models and Folders. Datasets can also be built by running recipes, when running a recipe you also have the options listed in this document.

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Build modes](<https://knowledge.dataiku.com/latest/prepare-transform-data/build/concept-dataset-build-modes.html>)

  * [Tutorial | Build modes](<https://knowledge.dataiku.com/latest/prepare-transform-data/build/tutorial-build-modes.html>)




## Build modes

There are 3 main modes for building a dataset. Right-click on the dataset and select **Build** , then select one of the following options.

### Build only this (Non recursive)

Builds the selected dataset using its parent recipe. _This option requires the least computation_ , but only includes changes to datasets that are inputs of the parent recipe, and does not take into account any changes further upstream.

### Build upstream (recursive)

Builds the selected dataset and upstream datasets. There are two types of upstream builds

  * **Build only modified** : Checks each dataset and recipe upstream of the selected dataset. Dataiku DSS then rebuilds all datasets from the first outdated dataset down to the selected one. _This is the recommended default_. More details in the note below.

  * **Build all upstream** : Rebuilds all dependencies (unless specified by Rebuild behavior ) of the selected datasets going back to the start of the flow. _This is the most computationally-intense operation_. But, for example, it can be used for scheduled builds outside working hours that ensure the flow is completely up to date.




In both cases, you can also use the _Stop at zone boundary_ option. This means that upstream dependencies will only checked if they are located in the same flow zone as the selected dataset.

Note

In **Build only modified** mode, or where an options says **Build required dependencies** , DSS checks all datasets and recipes upstream, and datasets are considered outdated and will be rebuilt if any of the below are true:

  * A recipe upstream has been modified. If this is the case, its output dataset is considered out-of-date.

  * A recipe upstream has had one or more inputs modified. If this is the case, its output dataset is considered out-of-date

  * The settings of a dataset upstream have changed.

For external datasets (datasets not managed by DSS):
    
    * File based datasets: Check the marker file if there is one; otherwise, check if the content of the dataset has changed. DSS uses filesystem metadata to identify if there has been a change in the file list (e.g. files added/removed) or any files themselves (e.g. size, last modification date).

    * For SQL datasets: DSS considers it up-to-date by default, as it is difficult to know if there is a change in an input SQL dataset.




Known limitation: Build only modified can’t take into account variable changes in visual recipe; you have to force a rebuild.

### Build downstream (recursive)

Builds downstream datasets. In advanced settings :

  * **Build all downstream** : This runs recipes from the selected dataset until the end of the Flow is reached (unless specified by Rebuild behavior ). The selected dataset itself is not built.

  * **Find outputs and build recursively** : Dataiku DSS will find all final datasets downstream from selected dataset and build any upstream dependencies. In this case, you can choose to either build required dependencies or force-build those upstream datasets.




## Rebuild behavior

Datasets, folders and models can be configured on the Advanced settings in order to control the Rebuild behavior.

### Preventing a Dataset from being built

You might want to prevent some datasets from being rebuilt, for instance, if rebuilding them is particularly expensive or if their unavailability must be restricted to certain hours. In a dataset’s **Settings > Advanced** tab, you can configure its Rebuild behavior:

  * **Normal** : the dataset can be rebuilt, including recursively in the cases described above.

  * **Explicit** : the dataset can be rebuilt, but only if it is specifically the target of the build.

  * **Write-protected** : the dataset cannot be rebuilt, even explicitly, making it effectively read-only from the Flow’s perspective.




Note

When an explicit or write-protected dataset is included in a recursive build, it will not be rebuilt, and the exact behavior depends on the option chosen.   
Given a flow such as the following, with B set as Explicit or Write-protected.

  * **Build upstream (from output)** : Will only rebuild C (and output). B will not be rebuilt, nor will its upstream datasets.

  * **Build downstream (from input)**
    
    * **Build all downstream** : This will build A, skip the sync recipe and **NOT** build B, and then build output

    * **Find outputs and build recursively** : Will only rebuild C (and output). B will not be rebuilt, nor will its upstream datasets.




**Explicit Datasets** can be rebuilt if they are the direct target of a build when using **Build only this** or **Build upstream** modes.

Note

  * You can still write to **Write-protected** datasets from a Notebook.

  * Behavior is the same when building from a Scenario or via an API call.




### Allow build to continue when a Data Quality rule fails

By default, when building a dataset, any auto-computed Data Quality rules with an error status will prevent recursive build to continue. However you might want to allow recursive build to carry on for example when the downstream recipe is the [Extract failed rows recipe](<../other_recipes/extract-failed-rows.html>). If so, check the option in the dataset’s **Settings > Advanced > Allow build to continue when rule fails**.

### Preventing a Model from being retrained

Similarly, you might want to prevent some models from being retrained, for instance, if retraining them is particularly expensive or if you want to have more control on the model.   
In a model’s **Settings > Recursive build behavior**, you can configure its Retrain behavior. It works the same way as Dataset with minor differences :

  * Models are by default set as **Explicit**

  * Models cannot be set as **Write-protected**




## Propagate schema across Flow from here

This option propagates changes to the columns of a dataset to all downstream datasets. The schema can have changed either because the columns in the source data have changed or because you have made changes to the recipe that creates the dataset. To do this, right-click a recipe or dataset and select **Propagate schema across Flow from here**.

This opens the Schema Propagation tool. Click **Start** to begin manual schema propagation, then for each recipe that needs an update:

  * Open it, preferably in a new tab

  * Force a save of the recipe: hit Ctrl+s, (or modify anything, click **Save** , revert the change, save again). For most recipe types, saving it triggers a schema check, which will detect the need for an update and offer to fix the output schema. DSS will not silently update the output schema, as it could break other recipes relying on this schema. But most of the time, the desired action is to accept and click **Update Schema**.

  * You probably need to run the recipe again




Some recipe types cannot be automatically checked; for example, Python recipes.

Some options in the tool allow you to automate schema propagation:

  * **Perform all actions automatically** : when selected, schema propagation will automatically rebuild datasets and recipes to achieve full schema propagation with minimal user intervention.

  * **Perform all actions automatically and build all output datasets afterwards** : As the previous option, plus a standard recursive Build All operation invoked at the end of the schema propagation.




Note

If your schema changes would break the settings of a downstream recipe, then you will need to manually fix the recipe and restart the automatic schema propagation. For example, if you manually selected columns to keep in a Join recipe (rather than automatically keeping all columns), and then delete one of those selected columns in an upstream Prepare recipe, then automatic schema propagation will fail at the Join recipe.

### Advanced Options

You have Advanced options related to schema updates :

**Rebuild input datasets of recipes whose output schema may depend on input data (prepare, pivot)** :

If this option is selected, then the schema propagation will automatically rebuild datasets as necessary to ensure that the output schemas from the recipe can be correctly calculated. This is particularly important for Pivot recipes and Prepare recipes with pivot steps. If you have no such recipes it may faster to deselect this.

**Rebuild output datasets of recipes whose output schema is computed at runtime** :

Selecting this will ensure the rebuild of:

>   * all code recipes
> 
>   * Pivot recipes which are set to “recompute schema on each run” in the Output step
> 
> 


Schemas for Prepare recipes should update automatically even if this is not selected.

---

## [flow/flow-document-generator]

# Flow Document Generator

You can use the Flow Document Generator to create documentation associated with a project. It will generate on the fly a Microsoft Word™ .docx file that provides information regarding the following objects of the flow:

  * Datasets

  * Recipes

  * Managed Folders

  * Saved Models

  * Model Evaluation Stores

  * Labeling Tasks




## Generate a flow document

Note

To use this feature, the [graphical export library](<https://doc.dataiku.com/dss/latest/installation/custom/graphics-export.html>) must be activated on your DSS instance. Please check with your administrator.

You can generate a document from a project with the following steps:

  * Go to the flow of the project

  * Click the `Flow Actions` button on the bottom-right corner

  * Select `Export documentation`

  * On the modal dialog, select the default template or upload your own template, and click `Export` to generate the document

  * After the document is generated, you will be able to download your generated document using the `Download` link




## Custom templates

If you want the document generator to use your own template, you need to use Microsoft Word™ to create a `.docx` file.

You can create your base document as you would create a normal Word document

### Sample templates

Instead of starting from scratch, you can modify the default template:

[`Download the default template here`](<../_downloads/9f85e97c8a6f8ffc7e877c5a264ab9ba/flow_documentation_template.docx>)

### Placeholders

A placeholder is defined by a placeholder name inside two brackets, like `{{project.name}}`. The generator will read the placeholder and replace it with the value retrieved from the project.

There are multiple types of placeholders, which can produce text, an image or a variable.

### Conditional placeholders

You can customize even more your template by using conditional placeholders to display different information depending on the values of some placeholders

A conditional placeholder contains three elements, and each of them needs to be on a separate line:

  * a condition

  * a text to display if the condition is valid

  * a closing element




The condition itself is composed of three parts:

  * a text placeholder

  * an operator (`==` or `!=`)

  * a reference value




Example:
    
    
    {{if my.placeholder == myReferenceValue }}
    

The placeholder is replaced by its value during document generation and compared to the reference value. If the condition is correct, the text is displayed, otherwise nothing will appear on the final document.

Note

To check if the value in the placeholder is empty, have a condition with no reference value.

Example:
    
    
    {{if project.short_desc != }}
    
    Project description: {{ project.short_desc }}
    
    {{endif project.short_desc }}
    

Here is a more advanced example with a conditional boolean placeholders using a variable provided by an iterable placeholder. Boolean placeholders return the values “Yes” or “No” as text.
    
    
    {{ if $recipe.is_code_recipe == Yes }}
    
    Recipe code: {{ $recipe.payload }}
    
    {{ endif $recipe.is_code_recipe }}
    

### Iterable Placeholders

Iterable placeholders contain one or multiple objects and must be used with a `foreach` keyword, like this: `{{ foreach $variableName in placeholder.name }}` (replace `variableName` with the name you want for your variable, and `placeholder.name` with the name of the placeholder). Iterable placeholders provide a variable that can be used in other placeholders, depending on its **type**. The **type** of the variable depends on the iterable placeholder that provided it. see placeholder list.

Syntax rules:

  * A variable name must start with a `$` and must not contain any `.`.

  * Iterable placeholders need to be closed with a `{{ endforeach $variableName }}`




For example, the placeholder `flow.datasets` will iterate over all the datasets of the flow and the variable it provides is of type `$dataset` so it can use all the placeholders starting with `$dataset`. Here’s an example of how it can be used:
    
    
    {{ foreach $d in flow.datasets }}
    
    Dataset name: {{ $d.name }}
    Dataset type: {{ $d.type }}
    
    {{ endforeach $d }}
    

In this example, we iterate over all the datasets contained in the placeholder `flow.datasets` and for each of these placeholders, we print the name and the type of the dataset.

It is possible to have an iterable placeholder inside another iterable. For example, to print the schema columns of all the datasets, you would do:
    
    
    {{ foreach $dataset in flow.datasets }}
    
    Dataset name: {{ $dataset.name }}
    Dataset type: {{ $dataset.type }}
    
    Schema:
    {{ foreach $column in $dataset.schema.columns }}
    
        Column name: {{ $column.name }}
        Column type: {{ $column.type }}
    
    {{ endforeach $column }}
    {{ endforeach $dataset }}
    

#### Count placeholders

To know the number of elements in an iterable placeholder, use `.count` after the name of the iterable. This can be useful when used with a conditional placeholder if you don’t want to display a section if there is no element. For example:
    
    
    {{ if flow.models.count != 0 }}
    
    Saved model section
    
    There are {{ flow.models.count }} in the flow.
    
    {{ foreach $model in flow.models }}
    
    // Display model info
    
    {{ endforeach $model }}
    {{ endif flow.models.count }}
    

#### Type placeholders

To know the type of a variable, use `.$type` after the name of the variable. This can be useful when used with a conditional placeholder if you want to display something different for a specific type in an iterable placeholder that can output multiple types. See union-type iterable placeholders.

#### Union-types iterables

Some iterable placeholders can iterate over multiple types at the same time. For example, if you want to iterate over the outputs of a recipe, the type of the outputs can be datasets, managed folders, saved models or, model evaluation stores.

A variable created by an iterable placeholder with multiple output types can use all the placeholders common to the types it can be. The main flow objects (datasets, folders, recipes, models, labeling tasks and model evaluation stores) have at least these common placeholders:

  * id

  * name

  * creation.date

  * creation.user

  * last_modification.date

  * last_modification.user

  * short_desc

  * long_desc

  * tags

  * tags.list




If you want to use a placeholder specific to only one of the types, you need to use a conditional placeholder to check the type of the variable.

For example, to iterate over the outputs of a recipe:
    
    
    {{ foreach $output in $recipe.outputs.all }}
    
    Output name: {{ $output.name }}
    Output description: {{ $output.short_desc }}
    
    {{ if $output.$type = $dataset }}
    // this placeholder would fail for other types, so it has to be used only for datasets
    Dataset connection: {{ $output.connection }}
    {{endif $output.$type }}
    
    {{ endforeach $output }}
    

Note

If there is a problem during the generation of the document, for example if a placeholder contains a typo, if a placeholder is used on a variable with the wrong type or if there is no “end” placeholder after `foreach` or `if` placeholders, the placeholders will be removed in the final document and there will be a warning displayed after the generation.

### List of placeholders

Placeholder name | Output type | Description / prerequisite  
---|---|---  
config.author.email | Text | The email of the user running the Flow Document Generator  
config.author.name | Text | The user running the Flow Document Generator  
config.dss.version | Text | The version of the instance  
config.generation_date | Text | The date when the document is generated  
config.output_file.name | Text | The name of the document generated  
config.project.link | Text | A link to the project  
flow.datasets | $dataset | All datasets contained in this project  
flow.folders | $folder | All managed folders contained in this project  
flow.labeling_tasks | $labeling_task | All labeling tasks in the project  
flow.model_evaluation_stores | $model_evaluation_store | All model evaluation stores contained in the project  
flow.models | $model | All models contained in the project  
flow.picture.landscape | Image | A screenshot of the flow using landscape orientation. If the flow is too big to fit on one page, several pictures will be produced and inserted into the document. Each picture will be about as big as can fit on a single page.  
flow.picture.portrait | Image | A screenshot of the flow using portrait orientation. If the flow is too big to fit on one page, several pictures will be produced and inserted into the document. Each picture will be about as big as can fit on a single page.  
flow.recipes | $recipe | All recipes that are contained in the project.  
project.creation.date | Text | Creation date of the documented project  
project.creation.user | Text | The display name of the user who created the documented project  
project.current.git.branch | Text | The name of the currently active git branch of the documented project  
project.key | Text | The key of the documented project  
project.last_modification.date | Text | Date and time of the last modification of the documented project  
project.last_modification.user | Text | The display name of the user who last modified the documented project  
project.long_desc | Text | Long description of the documented project  
project.name | Text | The name of the documented project  
project.short_desc | Text | Short description of the documented project  
project.status | Text | The status of the documented project  
project.tags | $tag | The list of tags associated with the documented project as an iterable placeholder (see project.tags.list for a simpler version)  
project.tags.list | Text | The list of tags associated with the documented project as a single string for simpler usage (all tags are concatenated, separated by commas - see project.tags for the iterable version)  
$chart Placeholder name | Output type | Description / prerequisite  
---|---|---  
$chart.name | Text | Name of the chart  
$condition Placeholder name | Output type | Description / prerequisite  
---|---|---  
$condition.description | Text | Returns a small description of the condition.  
$condition.left_column.name | Text | Returns the name of the first column in the condition  
$condition.right_column.name | Text | Returns the name of the second column in the condition  
$data_relationship Placeholder name | Output type | Description / prerequisite  
---|---|---  
$data_relationship.conditions | $condition | Returns the list of join conditions linking the two datasets in data relationship.  
$data_relationship.left_dataset.name | Text | Returns the name of the left hand dataset in a data relationship.  
$data_relationship.left_dataset.participant_index | Text | Returns the index of the left hand dataset in the list of participants in data relationships, or ‘primary’ for the primary dataset (the same enrichment dataset can appear multiple times in the list with different indices, as part of different relationships).  
$data_relationship.left_dataset.time_index | Text | Returns the column name of the time index of the left hand dataset in a data relationship.  
$data_relationship.left_dataset.time_windows | $time_window | Returns the time windows related to the left hand dataset in a data relationship.  
$data_relationship.right_dataset.name | Text | Returns the name of the right hand dataset in a data relationship.  
$data_relationship.right_dataset.participant_index | Text | Returns the index of the right hand dataset in the list of participants in data relationships, or ‘primary’ for the primary dataset (the same enrichment dataset can appear multiple times in the list with different indices, as part of different relationships).  
$data_relationship.right_dataset.time_index | Text | Returns the column name of the time index of the right hand dataset in a data relationship.  
$data_relationship.right_dataset.time_windows | $time_window | Returns the time windows related to the right hand dataset in a data relationship.  
$data_relationship.type | Text | Returns the type of data relationship, such as ‘one-to-many’.  
$dataset Placeholder name | Output type | Description / prerequisite  
---|---|---  
$dataset.charts | $chart | List of the charts associated with this dataset. For datasets shared between multiple projects, only the charts created in the current project are returned.  
$dataset.connection | Text | The name of the connection used for this dataset  
$dataset.containing.folder | $folder | For ‘Files in Folder’ datasets, the folder that is the source of this dataset. It’s returned as an iterable with 1 element. For datasets that are not ‘Files in Folder’, or if the source folder is not in this project ($dataset is foreign), returns an iterable that contains 0 elements.  
$dataset.creation.date | Text | Creation date for the dataset  
$dataset.creation.user | Text | The display name of the user who created this dataset  
$dataset.data_steward | Text | The display name of the user set as Data Steward for the dataset, or None if no user was set.  
$dataset.full_name | Text | The full name of the dataset (includes the project key)  
$dataset.id | Text | Id of the documented dataset (without the project qualifier, yields the same result as $dataset.name)  
$dataset.is_foreign | Text (Yes/No) | Whether the dataset is foreign, eg if it belongs to another project but is exposed to this one.  
$dataset.is_partitioned | Text (Yes/No) | Whether the dataset is partitioned  
$dataset.last_modification.date | Text | The date of the last modification  
$dataset.last_modification.user | Text | The display name of the last modification author  
$dataset.long_desc | Text | The long description of the documented dataset  
$dataset.name | Text | The short name of the documented dataset (yields the same result as $dataset.id)  
$dataset.parent.all | $recipe, $labeling_task | The parent of the current dataset. It’s returned as an iterable, that can contain 0 or 1 element.  
$dataset.parent.labeling_tasks | $labeling_task | The parent labeling task of the current dataset. It’s returned as an iterable, that can contain 0 or 1 element.  
$dataset.parent.recipes | $recipe | The parent recipe of the current dataset. It’s returned as an iterable, that can contain 0 or 1 element.  
$dataset.project.key | Text | The key of the project containing this dataset (mostly useful for foreign datasets, otherwise yields the same result as project.key)  
$dataset.project.name | Text | The name of the project containing this dataset (mostly useful for foreign datasets, otherwise yields the same result as project.name)  
$dataset.schema.columns | $schema_column | Schema of the dataset, as a list of the schema columns.  
$dataset.short_desc | Text | The short description of the documented dataset  
$dataset.status.last_build | Text | Date and time of the last build. If no build is logged in the job database, ‘No build recorded’.  
$dataset.status.partition_count | Text | Last known number of partitions of the dataset. Using the placeholder will not trigger a computation as it can be long and expensive, so the value may be outdated if the dataset has changed since. If the size has never been computed, returns ‘Not computed’. If a recent value is required, it should be precomputed using the tools offered by DSS (metrics & scenarios). For non-partitioned datasets, returns 1.  
$dataset.status.record_count | Text | Last known number of records contained in the dataset. Using the placeholder will not trigger a computation as it can be long and expensive, so the value may be outdated if the dataset has changed since. If the size has never been computed, returns ‘Not computed’. If a recent value is required, it should be precomputed using the tools offered by DSS (metrics & scenarios).  
$dataset.status.total_size | Text | Last known size of the dataset files, if applicable. Using the placeholder will not trigger a computation as it can be long and expensive, so the value may be outdated if the dataset has changed since. If the size has never been computed, returns ‘Not computed’. If a recent value is required, it should be precomputed using the tools offered by DSS (metrics & scenarios).  
$dataset.successors.all | $recipe, $labeling_task | The successors of the current dataset. It’s returned as an iterable, that can contain 0 or more elements.  
$dataset.successors.labeling_tasks | $labeling_task | The successor labeling tasks of the current dataset. It’s returned as an iterable, that can contain 0 or more elements.  
$dataset.successors.recipes | $recipe | The successor recipes of the current dataset. It’s returned as an iterable, that can contain 0 or more elements.  
$dataset.tags | $tag | The list of tags associated with this dataset as an iterable placeholder (see $dataset.tags.list for a simpler version)  
$dataset.tags.list | Text | The list of tags associated with this dataset as a single string for simpler usage (all tags are concatenated, separated by commas - see $dataset.tags for the iterable version)  
$dataset.type | Text | The type of the documented dataset  
$dataset.worksheets | $worksheet | List of the worksheets associated with this dataset. For datasets shared between multiple projects, only the worksheets created in the current project are returned.  
$file Placeholder name | Output type | Description / prerequisite  
---|---|---  
$file.last_modified | Text | The last modification date of a file.  
$file.path | Text | The path of a file relative to its containing managed folder.  
$file.size | Text | The size of a file  
$folder Placeholder name | Output type | Description / prerequisite  
---|---|---  
$folder.connection | Text | The name of the connection used for this managed folder  
$folder.creation.date | Text | Creation date for the managed folder  
$folder.creation.user | Text | The display name of the user who created this managed folder  
$folder.files_in_folder.datasets | $dataset | The ‘Files in Folder’ datasets build from this folder. It’s returned as an iterable, that can contain 0 or more elements.  
$folder.files.list | $file | List all the files contained in the managed folder. Warning, this placeholder should be used with care because of the possible very high number of files contained in a managed folder, which could make this listing operation very long (and possibly costly depending on the managed folder location)  
$folder.full_id | Text | The full id of the documented managed folder (looks like PROJECTKEY.folderid)  
$folder.id | Text | Id of the documented managed folder (without the project qualifier)  
$folder.is_foreign | Text (Yes/No) | Whether the managed folder is foreign, eg if it belongs to another project but is exposed to this one.  
$folder.is_partitioned | Text (Yes/No) | Whether the managed folder is partitioned  
$folder.last_modification.date | Text | The date of the last modification  
$folder.last_modification.user | Text | The display name ofthe last modification author  
$folder.long_desc | Text | The long description of the documented managed folder  
$folder.name | Text | The short name of the documented managed folder  
$folder.parent.recipes | $recipe | The parent recipe of the current managed folder. It’s returned as an iterable, that can contain 0 or 1 element.  
$folder.project.key | Text | The key of the project containing this managed folder (mostly useful for foreign folders, otherwise yields the same result as project.key)  
$folder.project.name | Text | The name of the project containing this managed folder (mostly useful for foreign folders, otherwise yields the same result as project.name)  
$folder.short_desc | Text | The short description of the documented managed folder  
$folder.successors.all | $recipe, $labeling_task | The successor of the current managed folder. It’s returned as an iterable, that can contain 0 or more elements.  
$folder.successors.labeling_tasks | $labeling_task | The successor labeling tasks of the current managed folder. It’s returned as an iterable, that can contain 0 or more elements.  
$folder.successors.recipes | $recipe | The successor recipes of the current managed folder. It’s returned as an iterable, that can contain 0 or more elements.  
$folder.tags | $tag | The list of tags associated with this recipe as an iterable placeholder (see $folder.tags.list for a simpler version)  
$folder.tags.list | Text | The list of tags associated with this recipe as a single string for simpler usage (all tags are concatenated, separated by commas - see $folder.tags for the iterable version)  
$folder.type | Text | The type of the documented managed folder  
$join Placeholder name | Output type | Description / prerequisite  
---|---|---  
$join.condition_mode | Text | Returns the condition mode of the join (And, Or, Natural, Custom)  
$join.conditions | $condition | Return the list of condition of the join.  
$join.left_dataset.name | Text | Returns the name of the first dataset in the join  
$join.right_dataset.name | Text | Returns the name of the second dataset in the join  
$join.type | Text | Returns the type of join (Inner, Outer, etc.)  
$labeling_task Placeholder name | Output type | Description / prerequisite  
---|---|---  
$labeling_task.creation.date | Text | Creation date of the labeling task  
$labeling_task.creation.user | Text | The display name ofthe user who created the labeling task  
$labeling_task.id | Text | Id of the labeling task (without the project qualifier)  
$labeling_task.inputs.all | $dataset, $folder | The list of all items that are used as input for this labeling task. The output has a mixed type, so you must be careful how it is used in order not to generate errors when generating a document on a complex flow (see union-type iterable placeholders for more details)  
$labeling_task.inputs.datasets | $dataset | The list of dataset that are used as input for this labeling task. The labeling task may have a folder as input, that is not listed here (see $labeling_task.inputs.folders or $labeling_task.inputs.all)  
$labeling_task.inputs.folders | $folder | The list of managed folders that are used as input for this labeling task. The labeling task should have a dataset as input, that is not listed here (see $labeling_task.inputs.datasets or $labeling_task.inputs.all)  
$labeling_task.last_modification.date | Text | The date of the last modification  
$labeling_task.last_modification.user | Text | The display name ofthe last modification author  
$labeling_task.long_desc | Text | The long description of the labeling task  
$labeling_task.name | Text | Name of the labeling task  
$labeling_task.outputs.datasets | $dataset | The list of dataset used as output for this labeling task  
$labeling_task.short_desc | Text | The short description of the labeling task  
$labeling_task.tags | $tag | The list of tags associated with this labeling task as an iterable placeholder (see $labeling_task.tags.list for a simpler version)  
$labeling_task.tags.list | Text | The list of tags associated with this labeling task as a single string for simpler usage (all tags are concatenated, separated by commas - see $labeling_task.tags for the iterable version)  
$labeling_task.type | Text | Type of the labeling task  
$model Placeholder name | Output type | Description / prerequisite  
---|---|---  
$model.active_version.name | Text | Name of the active version of the model  
$model.creation.date | Text | Creation date of the model  
$model.creation.user | Text | The display name ofthe user who created the model  
$model.id | Text | Id of the model (without the project qualifier)  
$model.is_foreign | Text (Yes/No) | Whether the model is foreign, e.g. if it belongs to another project but is exposed to this one  
$model.last_modification.date | Text | The date of the last modification  
$model.last_modification.user | Text | The display name ofthe last modification author  
$model.long_desc | Text | The long description of the documented model  
$model.name | Text | Name of the model  
$model.parent.recipes | $recipe | The parent recipe of the current model. It’s returned as an iterable, that can contain 0 or 1 element.  
$model.project.key | Text | The key of the project containing this model (mostly useful for foreign models, otherwise yields the same result as project.key)  
$model.project.name | Text | The name of the project containing this model (mostly useful for foreign models, otherwise yields the same result as project.name)  
$model.short_desc | Text | The short description of the documented model  
$model.successors.recipes | $recipe | The successor recipes of the current model. It’s returned as an iterable, that can contain 0 or more elements.  
$model.tags | $tag | The list of tags associated with this model as an iterable placeholder (see $model.tags.list for a simpler version)  
$model.tags.list | Text | The list of tags associated with this model as a single string for simpler usage (all tags are concatenated, separated by commas - see $model.tags for the iterable version)  
$model_evaluation_store Placeholder name | Output type | Description / prerequisite  
---|---|---  
$model_evaluation_store.creation.date | Text | Creation date of the model evaluation store  
$model_evaluation_store.creation.user | Text | The display name ofthe user who created the model evaluation store  
$model_evaluation_store.id | Text | Id of the model evaluation store (without the project qualifier)  
$model_evaluation_store.is_foreign | Text (Yes/No) | Whether the model evaluation store is foreign, e.g. if it belongs to another project but is exposed to this one  
$model_evaluation_store.last_modification.date | Text | The date of the last modification  
$model_evaluation_store.last_modification.user | Text | The display name ofthe last modification author  
$model_evaluation_store.long_desc | Text | The long description of the documented model evaluation store  
$model_evaluation_store.name | Text | Name of the model evaluation store  
$model_evaluation_store.parent.recipes | $recipe | The parent recipe of the current model evaluation store. It’s returned as an iterable, that can contain 0 or 1 element.  
$model_evaluation_store.project.key | Text | The key of the project containing this model evaluation store (mostly useful for foreign model evaluation stores, otherwise yields the same result as project.key)  
$model_evaluation_store.project.name | Text | The name of the project containing this model evaluation store (mostly useful for foreign model evaluation stores, otherwise yields the same result as project.name)  
$model_evaluation_store.short_desc | Text | The short description of the documented model evaluation store  
$model_evaluation_store.successors.recipes | $recipe | The successor recipes of the current model evaluation store. It’s returned as an iterable, that can contain 0 or more elements.  
$model_evaluation_store.tags | $tag | The list of tags associated with this model evaluation store as an iterable placeholder (see $model_evaluation_store.tags.list for a simpler version)  
$model_evaluation_store.tags.list | Text | The list of tags associated with this model evaluation store as a single string for simpler usage (all tags are concatenated, separated by commas - see $model_evaluation_store.tags for the iterable version)  
$recipe Placeholder name | Output type | Description / prerequisite  
---|---|---  
$recipe.bottom_rows.count | Text | For Top N recipes, the number of bottom rows to keep  
$recipe.code_env | Text | For code recipes that use code env, return the code env used. See $recipe.has_code_env for an easy way to check if a given recipe has a code env.  
$recipe.creation.date | Text | Creation date for the recipe  
$recipe.creation.user | Text | The display name ofthe user who created this recipe  
$recipe.cutoff_time | Text | For a ‘Generate features’ recipe, returns the name of the column in the primary dataset used for the cutoff time (or an empty string if it was not set). Can only be used for a Generate features recipe, otherwise will issue a warning and output nothing.  
$recipe.data_relationships | $data_relationship | For a generate Features recipe, returns the list of data relationships. Can only be used for a ‘Generate features’ recipe, otherwise will issue a warning and output nothing.  
$recipe.distinct_keys | Text | For a Distinct recipe, returns the list of selected columns, as a string separated by ‘, ‘. Can only be used with a Distinct recipe, otherwise will issue a warning and output nothing.  
$recipe.feature_transformations.categorical | Text | For a ‘Generate features’ recipe, returns the active feature transformations of type ‘categorical’ (in the form of a string separated by ‘, ‘). Can only be used for a ‘Generate features’ recipe, otherwise will issue a warning and output nothing.  
$recipe.feature_transformations.date | Text | For a ‘Generate features’ recipe, returns the active feature transformations of type ‘date’ (in the form of a string separated by ‘, ‘). Can only be used for a ‘Generate features’ recipe, otherwise will issue a warning and output nothing.  
$recipe.feature_transformations.general | Text | For a ‘Generate features’ recipe, returns the active feature transformations of type ‘general’ (in the form of a string separated by ‘, ‘). Can only be used for a ‘Generate features’ recipe, otherwise will issue a warning and output nothing.  
$recipe.feature_transformations.numerical | Text | For a ‘Generate features’ recipe, returns the active feature transformations of type ‘numerical’ (in the form of a string separated by ‘, ‘). Can only be used for a ‘Generate features’ recipe, otherwise will issue a warning and output nothing.  
$recipe.feature_transformations.text | Text | For a ‘Generate features’ recipe, returns the active feature transformations of type ‘text’ (in the form of a string separated by ‘, ‘). Can only be used for a ‘Generate features’ recipe, otherwise will issue a warning and output nothing.  
$recipe.group_keys | Text | For a Grouping recipe, returns the list of group keys, as a string separated by ‘, ‘. Can only be used with a Grouping recipe, otherwise will issue a warning and output nothing.  
$recipe.has_code_env | Text | Indicates if the recipe has code env.  
$recipe.id | Text | Id of the documented recipe (without the project qualifier, yields the same result as $recipe.name)  
$recipe.inputs.all | $dataset, $folder, $model, $model_evaluation_store | The list of all items that are used as input for this recipe. The output has a mixed type, so you must be careful how it is used in order to not generate errors when generating a document on a complex flow (see union-type iterable placeholders for more details)  
$recipe.inputs.datasets | $dataset | The list of datasets that are used as input for this recipe. The recipe may have other objects as input, that are not listed here (see $recipe.inputs.xxx)  
$recipe.inputs.folders | $folder | The list of managed folders that are used as input for this recipe. The recipe may have other objects as input, that are not listed here (see $recipe.inputs.xxx)  
$recipe.inputs.model_evaluation_stores | $model_evaluation_store | The list of model evaluation stores that are used as input for this recipe. The recipe may have other objects as input, that are not listed here (see $recipe.inputs.xxx)  
$recipe.inputs.models | $model | The list of saved models that are used as input for this recipe. The recipe may have other objects as input, that are not listed here (see $recipe.inputs.xxx)  
$recipe.is_code_recipe | Text (Yes/No) | Indicate if the recipe is a code recipe  
$recipe.is_filtered | Text (Yes/No) | For a Sample / filter recipe, indicates whether the filter option is enabled. Can only be used with a Sample / Filter recipe, otherwise will issue a warning and output nothing.  
$recipe.is_join | Text (Yes/No) | Indicates if the recipe is a join-like recipe (Join, Fuzzyjoin, Geojoin)  
$recipe.is_sampled | Text (Yes/No) | For a Sample / filter recipe, indicates whether the sample option is enabled (ie if the sample mode is not a full dataset). Can only be used with a Sample / Filter recipe, otherwise will issue a warning and output nothing.  
$recipe.joins | $join | For join-like recipes, returns the list of joins in the recipe.  
$recipe.last_modification.date | Text | The date of the last modification  
$recipe.last_modification.user | Text | The display name ofthe last modification author  
$recipe.left_unmatched_output.datasets | $dataset | For a join recipe, the left unmatched rows output dataset, if it exists. It’s returned as an iterable, that can contain 0 or 1 element.  
$recipe.left_unmatched_output.may_exist | Text (Yes/No) | For a join recipe, whether the join settings allow to save unmatched rows for the left dataset as a separate output  
$recipe.left_unmatched_output.name | Text | For a join recipe, the name of the left unmatched rows output dataset, if it exists  
$recipe.long_desc | Text | The long description of the documented recipe  
$recipe.name | Text | Name of the recipe (yields the same result as $recipe.id)  
$recipe.outputs.all | $dataset, $folder, $model, $model_evaluation_store | The list of all items that are used as outputs of this recipe. The output has a mixed type, so you must be careful how it is used in order to not generate errors when generating a document on a complex flow (see union-type iterable placeholders for more details)  
$recipe.outputs.datasets | $dataset | The list of datasets that are used as outputs of this recipe. The recipe may have other objects as output, that are not listed here (see $recipe.outputs.xxx)  
$recipe.outputs.folders | $folder | The list of managed folders that are used as outputs of this recipe. The recipe may have other objects as output, that are not listed here (see $recipe.outputs.xxx)  
$recipe.outputs.model_evaluation_stores | $model_evaluation_store | The list of model evaluation stores that are used as outputs of this recipe. The recipe may have other objects as output, that are not listed here (see $recipe.outputs.xxx)  
$recipe.outputs.models | $model | The list of saved models that are used as outputs of this recipe. The recipe may have other objects as output, that are not listed here (see $recipe.outputs.xxx)  
$recipe.payload | Text | Returns the raw payload of the recipe.  
$recipe.pivots | Text | For Pivot recipe, returns a comma-separated list of the pivot columns  
$recipe.populated_columns | Text | For Pivot recipe, returns a comma-separated list of all the populated columns, only the name of the columns and the ‘Count of records’ are shown  
$recipe.prepare.steps | $step | For Prepare recipes, returns the list of steps of the recipe.  
$recipe.primary_dataset | Text | For a ‘Generate features’ recipe, returns the name of the primary dataset. Can only be used for a ‘Generate features’ recipe, otherwise will issue a warning and output nothing.  
$recipe.right_unmatched_output.datasets | $dataset | For a join recipe, the right unmatched rows output dataset, if it exists. It’s returned as an iterable, that can contain 0 or 1 element.  
$recipe.right_unmatched_output.may_exist | Text (Yes/No) | For a join recipe, whether the join settings allow to save unmatched rows for the right dataset as a separate output  
$recipe.right_unmatched_output.name | Text | For a join recipe, the name of the right unmatched rows output dataset, if it exists  
$recipe.row_identifiers | Text | For Pivot recipe, returns a comma-separated list of the row identifiers  
$recipe.short_desc | Text | The short description of the documented recipe  
$recipe.sorting_columns | $sorted_column | For Sort and Top N recipe, iterates over the sorted columns  
$recipe.split_mode | Text | For a Split recipe, returns a text explaining which rule is applied to split the input data. Can only be used with a Split recipe, otherwise will issue a warning and output nothing.  
$recipe.stack_mode | Text | For a Stack recipe, returns a text explaining which rule is applied to merge the schema of the input datasets. If the selected mode is to use the schema of one input dataset, its name will be indicated. Can only be used with a Stack recipe, otherwise will issue a warning and output nothing.  
$recipe.tags | $tag | The list of tags associated with this recipe as an iterable placeholder (see $recipe.tags.list for a simpler version)  
$recipe.tags.list | Text | The list of tags associated with this recipe as a single string for simpler usage (all tags are concatenated, separated by commas - see $recipe.tags for the iterable version)  
$recipe.top_rows.count | Text | For Top N recipes, the number of top rows to keep  
$recipe.type | Text | Type of the recipe, as displayed by the UI.  
$recipe.unique_keys | Text | For a Push to Editable recipe, returns the list of columns used to identify the lines (unique keys in the UI), as a string separated by ‘, ‘. Can only be used with a Push to Editable recipe, otherwise will issue a warning and output nothing.  
$recipe.windows | $window | For Window recipes, iterate over the windows of the recipe.  
$schema_column Placeholder name | Output type | Description / prerequisite  
---|---|---  
$schema_column.description | Text | Description of the column  
$schema_column.name | Text | Name of the column  
$schema_column.type | Text | Storage type of the column  
$sorted_column Placeholder name | Output type | Description / prerequisite  
---|---|---  
$sorted_column.direction | Text (Ascending/Descending) | The direction of the sort (Ascending or Descending)  
$sorted_column.name | Text | The name of the column  
$step Placeholder name | Output type | Description / prerequisite  
---|---|---  
$step.comment | Text | Returns the comment of the step, if there is one.  
$step.type | Text | Returns the type of the step.  
$tag Placeholder name | Output type | Description / prerequisite  
---|---|---  
$tag.name | Text | The name of a tag  
$time_window Placeholder name | Output type | Description / prerequisite  
---|---|---  
$time_window.from | Text | Returns the starting point of the interval in a time window (in the number of multiples of the unit prior to the cutoff time).  
$time_window.to | Text | Returns the end point of the interval in a time window (the number of multiples of the unit prior to the cutoff time).  
$time_window.units | Text | Returns the units used in the time window, in pluralized form, e.g. ‘days’.  
$window Placeholder name | Output type | Description / prerequisite  
---|---|---  
$window.name | Text | The name of the window  
$window.partitioning_columns | Text | Comma-separated list of the partitioning columns of the window  
$worksheet Placeholder name | Output type | Description / prerequisite  
---|---|---  
$worksheet.name | Text | Name of the worksheet

---

## [flow/flow-explanations]

# Flow explanations  
  
Dataiku includes an AI assistant to generate explanations of project Flows.

Please see [AI Explain](<../ai-assistants/ai-explain.html>) for more details.

## Generating project Flow explanations

  * On the Flow screen open the **Flow Actions** menu

  * Select **Explain Flow**




## Generating Flow zone explanations

  * On the Flow screen select a zone

  * Select the **Actions** tab in the right-hand side panel

  * Click **Explain**




Note

You can generate explanations of project Flows which do not use zones or you can generate explanations of Flow zones. It is currently not possible to generate explanations of Flows with zones.

## Explanation options

It is possible to adjust the generated explanations using these options:

  * Language: the natural language of the explanation

  * Purpose: the intended audience of the explanation

  * Length: the verbosity of the explanation




If editing a project or a Flow zone long description you can also choose to let the AI Explain feature generate it and then save it.

Note

The explanations are AI-generated and as such are subject to errors.

---

## [flow/folding]

# How to Manage Large Flows with Flow Folding

As the number of objects in a flow grows, it becomes increasingly difficult to visually comprehend. By selectively hiding parts of the flow, you can focus on and make sense of subsections of it.

## Folding and Unfolding a Flow

To hide objects in the Flow:

  * Right-click on a dataset or recipe in the flow

  * Select **Hide all upstream** or **Hide all downstream**. As you hover over each option, the links between objects that will be hidden turn from solid lines to dashed lines. _Upstream_ is the direction toward the source (inputs) of the Flow, and _downstream_ is the direction toward the end (outputs) of the Flow.




The hidden objects in the Flow are represented by a **+** within a circle. You can hide multiple subsections of the Flow.

To show hidden objects in the Flow:

  * Click on any **+** sign within a circle. As you hover over one of these symbols, the subsection of Flow that will be unfolded is displayed.

---

## [flow/graphics-export]

# Exporting the Flow to PDF or images

The Flow can be exported to PDF or image (PNG, JPG) files in order to share a snapshot of Flow details within your organization more easily.

## Setup

The graphics export feature must be setup before the Flow graph can be exported.

Follow [Setting up DSS item exports to PDF or images](<../installation/custom/graphics-export.html>) to enable the export feature on your DSS instance.

## Manual usage

In project Flow view, open Flow Actions menu and select Export to PDF/Image.

## Settings

Files generated are fully customizable. The following parameters are available:

  * File type, to select the type of files to generate (PDF, PNG or JPEG).

  * Export format, to determine image dimensions.

>     * If a standard format (A4 or US Letter) is chosen, image dimensions will be calculated based on the size of your Flow and the chosen orientation (Landscape or Portrait). On the contrary, Custom format allows you to configure a custom width and height.

---

## [flow/index]

# The Flow

In DSS, the datasets and the recipes together make up the **flow**. We have created a visual grammar for data science, so users can quickly understand a data pipeline through the **flow**.

Using the flow, DSS knows the lineage of every dataset in the flow. DSS, therefore, is able to dynamically rebuild datasets whenever one of their parent datasets or recipes has been modified.

DSS can limit the resource usage of jobs building datasets. Users can configure their recipes and administrators can configure DSS to prevent some users, projects, recipes or plugins from consuming too many resources.

---

## [flow/insert-delete]

# Inserting and deleting recipes

It is often useful to insert recipes in the middle of the Flow, or to delete parts of the Flow while keeping the connections

## Inserting a recipe

There are two ways to insert a recipe between items in a branch of your Flow:

  * Right-click on the dataset that will be the input of the new recipe and select Insert recipe after this dataset.

  * Select the dataset that will be the input of the new recipe and click More Actions > Insert recipe in the right panel.




You can then:

  * Select the type of recipe you want to insert.

  * Choose which recipes will receive the new output dataset as its input.

  * Click Next and then proceed to create the recipe




## Removing a recipe

If you want to remove a recipe from the middle of your Flow, you can delete the recipe and reconnect its input dataset(s) to subsequent recipes.

There are two ways to do so:

  * Right-click on the recipe and select “Delete and reconnect”.

  * Select the recipe and click “Delete and reconnect” in the right panel.




Delete and reconnect is available with the following conditions:

  * The recipe to delete must not be at the end of the Flow

  * The recipe to delete must have only one input dataset

  * All outputs of the recipe must be datasets

  * Both input and outputs of the recipe must be of the same type

  * The input and output datasets cannot be partitioned with different partitioning dimensions

---

## [flow/limits]

# Limiting Concurrent Executions

When a recipe is run to build a dataset (and its descendants if required or requested), DSS creates and executes a job to perform the work. This job is itself composed of one or more activities. DSS creates an activity per dataset per partition.

Spark and SQL pipelines can combine consecutive recipes into a single activity (in that case, it counts as a single activity).

Everything that is not part of a job (for example, Jupyter notebooks, Visual ML model training, webapps, …) are not activities.

To prevent jobs from consuming too many resources when they run, DSS limits the number of activities that are executed simultaneously.

## Global and per-job limits

For self managed deployments, by default, only 5 activities can be executed simultaneously on a DSS instance. Administrators can change this value in the _Administration > Settings > Resource control > Concurrent jobs and activities_ screen. On Dataiku Cloud, this value depends on your subscription and can be updated in _Launchpad > Settings_.

Administrators can also limit the number of max jobs executed simultaneously on an instance.

  * The number of running jobs will use the lowest value between _max activities_ and _max jobs_.

  * Use `0` to fallback to the max activities limit.




Administrators can also limit the number of activities simultaneously executed by a single job.

## Per-recipe limits

Users creating recipes can also limit the number of activities simultaneously executed by a recipe.

To set a limit, users must edit the recipe, go to the Advanced tab and change the recipe limit from zero (unlimited) to the desired value.

## Additional limits

Administrators can tune DSS even further regarding concurrent activities executions and add additional limits. They can limit the number of activities simultaneously executed:

  * for a given project.

  * for a given recipe type.

  * by a given user.

  * by recipes with a given tag.

  * by a plugin recipe.




These additional limits are defined using a key/value syntax.

To define a **limit for a given project** , the key must follow the pattern “project/XXXX” (where XXXX is the key of the project, as seen in the URL). For example, to limit the number of concurrent activities executed for the project TEST1 to 2, add a new key ‘project/TEST1’ with a corresponding value of 2.

To define a **limit for a given user** , the key must follow the pattern “user/XXXX” (where XXXX is the username of a user).

To define a **limit for a given tag** , the key must follow the pattern “tag/XXXX” (where XXXX is the name of a tag).

To define a **limit for a given recipe type** , the key must follow the pattern “recipeType/XXXX” (where XXXX is a type of recipe such as ‘shaker’).

To define a **limit for a plugin recipe** , the key must be one of the values of the `resourceKeys` field defined in the descriptor for the plugin recipe.

For example, to limit the number of concurrent activities executed by some CPU hungry plugin recipe to 1, edit the `recipe.json` file corresponding to the plugin recipe and add **cpu_hungry** in the `resourceKeys` field.
    
    
    {
        "meta" : {
            "label" : "...",
            "description" : "...",
            "icon" : "..."
        },
        "kind" : "...",
        "inputRoles" : [ "..." ],
        "outputRoles" : [ "..." ],
        "params" : [ "..." ],
        "resourceKeys" : [ "cpu_hungry" ]
    }
    

Note

The field “resourceKeys” holds a list of keys that allows to limit the number of concurrent executions and activities triggered by this recipe.

Administrators can configure the limit per resource key in the _Administration > Settings > Resources control > Concurrent jobs and activities_ screen.

Then go back to the _Administration > Settings > Resources control > Concurrent jobs and activities_ and add a limit using **cpu_hungry** as key and 1 as value.

---

## [flow/visual-grammar]

# Visual Grammar

Here’s an example of a complete project Flow in DSS:

## Datasets

**Datasets** in DSS appear as **blue squares**. The icon in the center of each square represents the type of dataset. For example, an upward pointing arrow indicates that the dataset was uploaded; two cubes represent Amazon S3; and an elephant represents HDFS.

See [Connecting to data](<../connecting/index.html>) for more information on the types of data that you can connect to in DSS.

The visual grammar for datasets can also acknowledge datasets that have been shared:

  * Any dataset shared to another DSS project is marked with a curved arrow in the top right corner of the dataset square.

  * Any dataset originating from another DSS project is marked with a black rather than a blue square.




See [Shared objects](<../security/shared-objects.html>) for more information on exposing objects between projects.

## Visual Recipes

**Visual recipes** in DSS appear as **yellow circles**. The icon inside of the visual recipe indicates the type of recipe. For example, the broom icon represents a Prepare recipe; a funnel represents a Filter recipe; and a pile of squares represents a Stack recipe.

See [Data preparation](<../preparation/index.html>) for an explanation of visual recipes and the transformations that they can accomplish.

## Machine Learning

Processes related to **machine learning** are shown in **green**. Here, a barbell represents a model training event; a scatter plot represents model scoring; and the trophy shows an application of the model to a new dataset.

See [Machine learning](<../machine-learning/index.html>) for more information about the machine learning capabilities of DSS.

## Code Recipes

DSS allows users to execute pieces of user-defined code inside the Flow. These user-defined scripts (in languages such as Python, R, SQL, Hive, …) are called code recipes.

**Code recipes** are represented by **orange circles**. The icon inside the circle indicates the programming language of the recipe. For example, the “two snakes” logo represents a Python recipe, and the honeycomb icon represents a Hive recipe.

See [Code recipes](<../code_recipes/index.html>) for more information on capturing user-defined code in R, Python, SQL, Hive recipes.

## Plugin Recipes

The visual capabilities of DSS can be extended through the Plugins system. Code recipes can be made into reusable components with a visual interface by creating plugin recipes. **Plugin recipes** are represented by **red circles**.

See [Plugins](<../plugins/index.html>) for more information on extending the features of DSS with plugins.

---

## [flow/zones]

# Flow zones

Data Science projects tend to quickly become complex, with large number of recipes and datasets in the Flow. This can make the Flow complex to read and navigate.

To better manage large projects, you can divide them into zones. You can define your zones in the Flow, and assign each dataset, recipe, … to a zone. The zones are automatically laid out in a graph, like super-sized nodes. You can work within a single zone or the whole flow, and collapse zones to create a simplified view of the flow.

Zones do not define new security boundaries, they are only used for laying out the flow.

## Use cases

You can use zones to:

  * Reflect the different phases of processing in a flow.

  * Isolate experimental branches.

  * Allow individuals to delimit what they are working on.




## Usage

Flow zones are a completely optional feature. As long as you have not defined zones, the Flow shows in its entirety.

### The default zone

By default, all nodes are in the **Default** zone. Any flow node that you have not placed in a zone is automatically in the Default zone. You can’t delete this zone, although you can rename it. When you delete the last non-default zone, the Default zone will also disappear and you will be left with a zone-free flow.

### Adding Zones and moving items

There are several ways to add zones into the flow. The simplest is the + Zone button at the top of the screen. Alternatively, you can select several nodes, right click and choose the option Move to a flow zone. In the modal you can create a new zone or select an existing one. Zones cannot be nested.

Recipes and their outputs always live in the same zone. If you try to move a dataset then DSS will move the upstream recipe with it. It is best to think in terms of moving recipes into zones, rather than datasets.

In the picture above we have moved the training recipe into the zone **Train**. This takes as input the dataset **labeled**. As a result the system has drawn in an extra node to show the reference to labeled inside the **Train** zone.

If you click on the labeled node in the Train zone, the original node in the Prepare zone is highlighted. You can use the right click option Go to original to jump back from the node in the Train zone to the original in Prepare.

### Sharing datasets between zones

Suppose you want to do some experimentation within this project. You want to keep your work self-contained so you will create a new, empty zone. If you know that you will be using various of the datasets in the flow although you’re not sure how yet. You can share those datasets into the zone much like you share items across projects. Then, when you open that zone, you have all you inputs ready for use. Use the right click option **Share to a flow zone** to achieve this.

### Open one zone

To “Maximize” one zone and work only in that zone, use the rectangular icon on the zone caption.

Once in a zone you can use the X icon in the top right corner to close it and go back to the multi-zone view.

### Collapsing zones

You can collapse any of the zones on the flow using the arrows icon on the zone caption. You can also right click on the caption and use the option there. If you select all the zones, for example by clicking on the flow zones text under the search bar, you can then right-click on a zone caption and collapse all the zones at once.

### Building zones

You can build all datasets from a zone by just clicking on the BUILD button. Behind the scene it runs a build upstream from datasets at the end of the zone. See [Rebuilding Datasets](<building-datasets.html>).

### Refactoring flows

There is a new Flow View for easy refactoring flows into Zones. This allows you to view the nodes without zones and to move them between zones in a similar fashion to apply tags in the tags view.

## Manual positioning

You can enable flow zones manual positioning in the project settings Flow Display section.

When the option is enabled, you can manually position flow zones by clicking and dragging on their header (or alt + click on the body of the zone).

When the option is disabled, all previous manual positions are cleared.