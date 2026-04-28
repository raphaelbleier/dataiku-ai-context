# Dataiku Docs — concepts

## [concepts/homepage/applications-page]

# Applications Page

This page allows you to browse and search any [Dataiku Application](<../../applications/index.html>) you have access to.

---

## [concepts/homepage/data-catalog-page]

# Data Catalog Page

The Data Catalog page gives you quick access to some of the [Data Catalog](<../../data-catalog/index.html>) features:

  * on the top, the quick search allows you to search in all [datasets and indexed tables](<../../data-catalog/datasets-indexed-tables.html>)

  * in the left panel, the list of the [Data Collections](<../../data-catalog/data-collections/index.html>)

  * in the center, the list of [Most used datasets](<../../data-catalog/most-used-datasets.html>)

  * in the right panel, the list of recently added datasets to a Data Collection.

---

## [concepts/homepage/index]

# Homepage

After logging in, you are taken to the Dataiku DSS homepage. The homepage is designed to prominently display the information most relevant to you.

For example, if you are a:

  * Data scientist, you want quick access to the projects you’re currently working on or the objects you recently explored;

  * Data consumer without project access, you want quick access to [Workspaces](<../../workspaces/index.html>) that have been designed to give you an easy access to shared assets.




Regardless of your role on the team, you’ll want immediate access to documentation, or as the instance grows to some key resources (projects, workspaces…)

The personal homepage is broken into several sections:

---

## [concepts/homepage/landing-page]

# Landing page

The landing page is meant to give you quick access to the resources you are most likely to use, divided in two main sections:

  * the objects you are most likely to access. Depending on your profile and authorizations, this section will give you access to:

>     * projects, recently visited and favorite items if you have access to them
> 
>     * workspaces otherwise

  * Global resources, which may include:

>     * Instance promoted content (Admin messages, links, data collections, wiki articles, projects, workspaces, web-app, Dataiku app, or app instances promoted by the instance administrators)
> 
>     * Tutorials for Dataiku’s feature you may be interested in
> 
>     * Links to other external resources like demos, Dataiku reference documentation, …




## Managing promoted content

Instance administrators can add or remove promoted content from the _Administration - > Settings -> Homepage_ page.

In the Promoted content section, you can add new content, edit existing content, and re-order it.

Note

Note that promoting a content doesn’t affect its access authorization. Only users who are able to see the promoted items will be able to see them in the homepage.

---

## [concepts/homepage/projects-page]

# Projects Page

The Projects page allows you to create and manage projects and project folders.

Folders can be nested within other folders, and the folder hierarchy is common for all users across the DSS instance. When you create a project, you can choose its folder.

## Managing Projects and Folders

By right-clicking in a project tile or clicking on the ellipsis button you can:

  * manage tags

  * change the project status

  * duplicate the project




On a project folder, you can:

  * rename it

  * delete it

  * manage permissions




Both projects and project folders can be:

  * moved into an other project folder (using the menu, or drag-and-drop)

  * marked as favorite by clicking on the star button




You can also select multiple projects and folders using the checkbox on the top-left corner of each tile, or by ctrl + click (⌘ + click on macos) on the tile. You can also select all currently displayed project and folders using the mass select button.

Note

Project management capabilities are only available on the projects page, not on the landing page.

Some actions require specific permissions, and may not be available for all users.

Some actions are only available when a single item is selected, or when multiple items of the same type are selected (e.g. add tags is only available when no project folder is selected).

## Security

Folders have Read, Write, and Admin permissions, which can be granted to any groups defined on the instance, or All Users. To do so, open the context menu on the folder tile and click on **Permissions**.

When a folder is created within another folder, its default permissions are those of the parent folder; these can later be changed.

Note

Any user with permissions on a project will always have implicit read access to the folder structure containing that project. For example

  * If a user has no explicit access to _folder-1_ and no access to any project it contains, then they will not see _folder-1_ in the Projects view.

  * However, if they have read access to _project-1_ , and _project-1_ is contained within _folder-1_ (including if it’s in a sub-folder), then they will see _folder-1_ in the Projects view.




Note

Suppose there is a [discoverable](<../../security/permissions.html#project-access>) project contained in _folder-2_ or any of its descendants. Any user will always have implicit read access to _folder-2_.

In order to control permissions in the root folder, a new [permission “Write in root project folder”](<../../security/permissions.html>) has been added to each security group. This allows administrators to prevent folders and projects from being created in, or moved to, the root.

---

## [concepts/homepage/workspaces-page]

# Workspaces Page

This page allows you to browse and search any [workspace](<../../workspaces/index.html>) you have access to.

---

## [concepts/index]

# DSS concepts

Note

For a step by step introduction to DSS, we recommend that you select the [quick start](<https://knowledge.dataiku.com/latest/getting-started/tasks/index.html>) most interesting to you.

## Data

Dataiku DSS allows you to work with data that is structured or unstructured.

Structured data is a series of records with the same schema. In Dataiku DSS, such data is referred to as a dataset.

[Unstructured data](<../unstructured-data/index.html>) can have an internal structure, but the entries do not necessarily have the same schema. Examples of unstructured data are images, video, audio, and so forth.

## Datasets

The dataset is the core object you will be manipulating in DSS. It is analogous to a SQL table, as it consists of a series of records with the same schema.

DSS supports various kinds of datasets. For example :

  * A SQL table or custom SQL query

  * A collection in MongoDB

  * A folder with data files on your server

  * A folder with data files on a Hadoop cluster.




## Recipes

Recipes are the building blocks of your data applications. Each time you make a transformation, an aggregation, a join, … with DSS, you will be creating a recipe.

Recipes have input datasets and output datasets, and they indicate how to create the output datasets from the input datasets.

DSS supports various kind of recipes :

  * Executing a data preparation script defined visually within the Studio

  * Executing a SQL query

  * Executing a Python script (with or without the use of the Pandas library)

  * Executing a Hive query

  * Synchronizing the content of input to output datasets




## Building datasets

Recipes and datasets together create the graph of the relationships between the datasets and how to build them. This graph is called the Flow. It is used by the dependencies management engine to automatically keep your output datasets up to date each time your input datasets or recipes are modified.

## Managed and external datasets

Data Science Studio reads data from the outside world in “external” datasets. On the other hand, when you use the Data Science Studio to create new datasets from recipes, these new datasets are “managed” datasets. This means that Data Science Studio “takes ownership” of these output datasets. For example, if the managed dataset is a SQL dataset, Data Science Studio will be able to drop / create the table, change its schema, …

Managed datasets are created by Data Science Studio in “managed connections”, which act as data stores. Managed datasets can be created:

  * On the filesystem of the Data Science Studio server

  * On Hadoop HDFS

  * In a SQL database

  * On Amazon S3

  * …




## Partitioning

Note

Partitioning is not available in Data Science Studio Community Edition

Partitioning refers to the splitting of the dataset along meaningful dimensions. Each partition contains a subset of the dataset.

For example, a dataset representing a database of customers could be partitioned by country.

There are two kinds of partitioning dimensions :

  * “Discrete” partitioning dimension. The dimension has a small number of values. For example : country, business unit

  * “Time” partitioning dimension. The dataset is divided in fixed periods of time (year, month, day or hour). Time partitioning is the most common pattern when dealing with log files.




A dataset can be partitioned by more than one dimension. For example, a dataset of web logs could be partitioned by day and by the server which generated the log line.

Whenever possible, the Data Science Studio uses underlying native mechanisms of the dataset backend for partitioning. For example, if a SQL dataset is hosted on a RDBMS engine which natively supports partitioning, Data Science Studio will map the partitioning of the dataset to the SQL partitions.

Partitioning serves several purposes in Data Science Studio.

### Incrementality

Partitions are the unit of computation and incrementality. When a dataset is partitioned, you don’t build the full dataset, but instead you build it partition by partition.

Partitions are fully recomputed. When we build partition X of a dataset, the previous data for this partition is removed and is replaced by the output of the recipe that generated the dataset. Recomputing a partition of a dataset is idempotent : computing it several times won’t create duplicate records.

This is especially important when processing times series data. If you have a day-partitioned log dataset as input, and a day-partitioned enriched log dataset as output, you want to build the partition X of the output dataset each day.

### Partition-level dependencies

Partitioning a dataset allows you to have partition-level dependencies management. Instead of just having the recipe specify that an output dataset depends on an input dataset, you can define what partitions of the input are required to compute a given partition of the output.

Let’s look at an example:

  * The “logs” dataset is partitioned by day. Each day, an upstream system adds a new partition with the logs of the day.

  * The “enriched logs” dataset is also partitioned by day. Each day, we need to compute the enriched logs using the “same” partition of the logs.

  * The “sliding report” dataset is also partitioned by day. Each day, we want to compute a report using data of the 7 previous days.




To achieve that, we will declare: An “equals” dependency between “logs” and “enriched logs” A “sliding days” dependency between “enriched logs” and “sliding report”.

If we ran the above flow for the November 29th partition:

  * The “enriched logs” dataset would be built directly from the November 29th partition of the “logs” dataset, since it is using an equals dependency function.

  * The “sliding report” dataset would be built from the November 23rd through November 29th partitions of the “enriched logs” dataset, since it is using a 7 day time range.




Data Science Studio will then check which partitions are available and up-to-date, and automatically compute all missing partitions. Data Science Studio will automatically parallelize the computation of enriched logs for each missing day, and then compute the sliding report.

### Performance

Generally speaking, when a dataset is partitioned, it can improve querying performance on this dataset. This is especially true for file-based datasets where only the files corresponding to the partition will be read.

---

## [concepts/projects/creating-through-macros]

# Creating projects through macros

Many administrators wish to have more control on how projects are created. Examples of use cases include forcing a default code env, container runtime config, automatically creating a new code env, setting up authorizations, setting up UIF settings, creating a Hive database, …

This led many administrators to deny project creation to users, leading to higher administrative burden for administrators.

With project creation macros, administrators can delegate the creation of projects to users, but the project will be created using administrator-controlled code, in order to perform additional actions or setup.

## For users

Once your administrator has created a project creation macro, and granted you the appropriate [permission](<../../security/permissions.html#projects-creation>), you’ll see new options appear in the “New project” button

## For administrators

You need to create a dev plugin and create a project creation macro in it.

Please see [Component: Project creation macros](<../../plugins/reference/project-creation-macros.html>) for more details

---

## [concepts/projects/duplicate]

# How to Copy a Dataiku Project

An existing project can make a useful template for a new project so that you don’t have to manually replicate the Flow. How to copy a project depends upon whether you want to:

  * Make a copy on the current instance

  * Make a copy on another instance




## Technical Requirements

  * Dataiku user with the Create projects global permission

  * Admin rights on the project you want to copy




## Make a Copy on the Current Dataiku Instance

  * From the homepage of the project you want to copy, choose Actions > Duplicate project.




Alternatively:

  * From the Projects page, right-click on the tile of the project you want to copy and choose Duplicate project.




### Duplicate Project Options

When duplicating a project:

  * It must have a unique project ID. Dataiku provides a default name and ID, or you can choose your own.

  * You have the option to choose what data is included in the export. Be sure that your connections to any databases use the `${projectKey}_` prefix to ensure that there is no conflict over database tables between the original and duplicated projects.




## Make a Copy on Another Dataiku Instance

  * From the homepage of the project you want to copy, choose Actions > Export.

  * Download the project export .zip file.

  * From the user homepage of another instance, choose +New project > Import and select the .zip file.




Alternatively:

  * Use the command-line export and import scripts available on the DSS server:



    
    
    DATA_DIR/bin/dsscli project-export project_key foo.zip
    DATA_DIR/bin/dsscli project-import foo.zip
    

  * Use `dsscli project-export -h` for a short help.




## Export/Import Project Options

When exporting a project, you have the option to choose what data is included in the export. This can be useful if the bandwidth between the Dataiku instances is slow:

  * Deselect the export of non-input data. Once the project is imported on the second Dataiku instance, rebuild the downstream datasets.




When importing a project:

  * It must have a unique project ID. You’ll be prompted if there is a conflict with an existing project on the instance.

  * The new instance must have connections configured for the imported project to use. Do not create a connection to the same location (e.g. the same database) on the second instance: both projects would then write to the same tables (in SQL, Hive, etc.). The last dataset to be computed would overwrite the other dataset stored in the same table.

  * The new instance must have any necessary code environments for the imported project to use. If the names of the code environments on the new instance are different from those on the original instance, you can “remap” the old names to the new names.

---

## [concepts/projects/index]

# Projects

A Dataiku DSS project is a container for all your work on a particular activity.

Each project has a single [Flow](<../../flow/index.html>) that shows the pipeline of datasets and recipes associated with the project.

The project home acts as the command center from which you can see the overall status of a project, view recent activity, and collaborate through comments, tags, and a project to-do list. It is also where the project’s **Actions** menu resides. From the **Actions** menu, you can:

  * [Duplicate](<duplicate.html>) a project

  * Export a project to a ZIP file

  * Delete a project




The `...` (more actions) menu on the project page provides access to the **Application Designer** , where you can create a [Project Setup](<project-setup.html>) workflow for your project. Through the Application Designer’s advanced options, you can create guided setup actions that help users configure duplicated versions of your project.

See also:

---

## [concepts/projects/project-setup]

# Project Setup

## What is Project Setup?

As a project administrator, Project Setup allows to create a project configuration wizard: a guided, structured workflow to help users finish configuring a project so that it becomes ready to use.

Then, when opening for the first time a project with a Project Setup, DSS users with appropriate permissions can walk through the guided setup and perform necessary configuration tasks, ensuring that all critical steps are completed before the project can be effectively utilized.

Once configured, the Project Setup presents users with organized sections containing specific actions they need to perform, such as uploading datasets, configuring connections, setting variables, or running initial scenarios. This guided approach both reduces the complexity and ensures the consistency of project onboarding.

## Restrictions

  * **Reader Profile** : Users with Reader profile cannot access or use Project Setup functionality whereas they are able to access Dataiku Applications.

  * **Project Application** : Project Setup is not available for projects that have been converted into a Dataiku Application (Visual Application or Application-as-recipe).

  * **Feature usage frequency** : The Project Setup UI is not intended for daily usage. It is designed as a one-time or occasional configuration tool, not for routine project operations.

  * **Project duplication/export/import** : When duplicating, exporting, or importing a project that already has a completed setup, the setup configuration is copied along with the project. This may not align with end user expectations, as the new project instance may not require the same setup steps or may need different configuration values.




## When to Use Project Setup vs. Dataiku Applications

Project Setup is ideal to create a project template that can be reused with different configurations. It’s particularly useful when users need to perform one-time setup tasks like running scenarios, variable configuration, or initial data uploads, and to ensure consistent project configuration across different environments.

Dataiku Applications are better suited to provide ongoing, interactive functionality to end users, when Reader profiles need access to the functionality, when the solution requires regular user interaction rather than one-time setup, or to create a simplified interface for routine project operations.

### Key Differences:

  * **Audience** : Project Setup targets project configurators and administrators; Dataiku Applications target end users including those with Reader profiles

  * **Frequency** : Project Setup is for one-time or occasional configuration; Dataiku Applications are for regular usage

  * **Purpose** : Project Setup ensures proper project configuration; Dataiku Applications provide simplified interfaces for project functionality (Visual Applications or Application-as-recipe)




## Adding Project Setup to an Existing Project

To add Project Setup to an existing project:

  1. **Access Application Designer**

     * Go to your project’s main page

     * Click on the `...` (more actions) menu

     * Select “Application Designer”

  2. **Enable Project Setup**

     * In the Application Designer, click “Show advanced options”

     * Click “Add a setup action to this project”

  3. **Create Setup Sections**

     * Add sections to organize related configuration tasks in the logical order users should complete them

     * Give each section a pertinent name and optional description

  4. **Configure Actions**

     * Within each section, add specific actions users need to perform

     * Choose from available action types (“Upload files in dataset”, “Edit datasets”, “Configure variables”, etc.)

     * Provide clear titles for each action

     * Re-organize actions by dragging within a section if necessary

  5. **Usage**

     * Save your Project Setup configuration

     * Duplicate the project containing the Project Setup configuration to share copies with users

     * Users will see the setup interface when they access the duplicated project




Once configured, Project Setup will be available on the duplicated project’s homepage. Users will see a message that says “This project requires setup” with a project setup button to start the guided configuration flow.