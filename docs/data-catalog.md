# Dataiku Docs — data-catalog

## [data-catalog/data-collections/index]

# Data Collections

In **Data Collections** , you can find curated groups of datasets, view information about those datasets, and reuse them in your own projects. Click on any dataset in a collection to view its details, status, and schema. From here, you can also explore, publish, export, watch, mark the dataset as a favorite, or preview its content.

Users with relevant permissions can publish datasets to a Data Collection from the Flow or from another Data Collection. Other users can then browse collections to find relevant datasets, read the documentation, and add datasets to their projects straight from the collection.

---

## [data-catalog/data-collections/managing]

# Managing Data Collections

Data Collections can be created by anyone whose security group has been granted [permission](<../../security/permissions.html>) to create Data Collections by the instance admin in **Global group permissions**.

## Data Collections settings

If you are an Admin of a Data Collection, you can edit a data collection’s name, description, icon color, add or remove tags, by clicking on the relevant item and editing in place.

## Managing Data Collection Users

If you are an Admin of a Data Collection, you can also add or remove DSS users and groups from the collection and change their roles. This feature is available with the “Edit security settings” option in the “…” menu of a Data Collection.

## Data Collection Roles

Within a Data Collection, there are 3 types of roles: **Admins, Contributors, and Readers.**

  * **Admins** control access to the Data Collection by adding and removing users and assigning them roles (Admin, Contributor or Reader). They can also edit the Data Collection settings or delete the Data Collection.

  * **Contributors** can publish datasets to the Data Collection or remove them. In order to publish a dataset from a DSS project, a Contributor needs to have permission from the project owner; this is granted at the project level, separately from Data Collection membership. See [Publishing to a Data Collection](<publish-to-data-collection.html>) for more information.

  * **Readers** can access and interact with the content of the Data Collection.

---

## [data-catalog/data-collections/permissions-and-dataset-visibility]

# Permissions and Dataset Visibility

A member of a Data Collection may not be authorized to see every dataset published to the Data Collection. The level of authorization granted and the visibility of datasets depends on the authorization mode applied on the object (see [Authorized objects](<../../security/authorized-objects.html>)).

  * If the user already has read access to the dataset through another method (read access on the project, on a workspace on which the dataset has been published…), they will be able to see the dataset and all of its details in the Data Collection. Data Collection membership does not grant any additional permission.

  * If the user does not already have read access to the dataset but it is an authorized object, the user will also be able to see the dataset in the Data Collection and will be granted some authorization through it.

>     * If the dataset has the READ authorization mode, the user is granted access to the dataset in the same way as a workspace or a dashboard-only user (see [Authorized objects](<../../security/authorized-objects.html>)). In the Data Collection, they will see the dataset and all details.
> 
>     * If the dataset only has the DISCOVER authorization mode, the user will be only granted access to a limited amount of metadata. In the Data Collection, the dataset will appear in the list, but some details will not be shown. Notably, the preview (as well as any access to the dataset content) will be disabled.

  * If the user has no other access and the dataset is not an authorized object, they will not be able to see the dataset in the Data Collection. No authorization is granted to the user through the Data Collection.




This table summarizes the details & functionality available for different authorization levels.

Info / action | Readable dataset | Discoverable dataset  
---|---|---  
Project name | Yes | Yes  
Dataset name | Yes | Yes  
Dataset description | Yes | Yes  
Dataset tags | Yes | Yes  
Data Steward | Yes | Yes  
Dataset status | Yes | No  
Dataset schema | Yes | No  
Usage in other projects | Yes | No  
Quick share | If allowed on the dataset | No  
Request share | If allowed on the project | If allowed on the project  
Export | If allowed on the source project | No  
Preview | Yes | No  
Watch & Star | Yes | No

---

## [data-catalog/data-collections/publish-to-data-collection]

# Publishing Datasets to a Data Collection  
  
Publishing a dataset to a Data Collection can be done from:

  * the right panel of the dataset (from the flow, the dataset page…)

  * the Data Collection itself (blue “Add Dataset” button)




While adding the dataset, if it is not already readable, the user can add “Allow read” or “Allow discover” object authorization in order to improve its discoverability. See [related documentation](<permissions-and-dataset-visibility.html>) for details.

To be permitted to publish datasets to a Data Collection, a user must have all of the following authorizations:

  * “Publish to Data Collections” global group authorization, granted by an instance admin

  * “Publish to Data Collections” project-level authorization for the project that contains the dataset, granted by a project admin

  * “Contributor” or “Admin ” role on the Data Collection, granted by a Data Collection admin




# Removing Datasets from a Data Collection

Any Data Collection member with the “Contributor” or “Admin ” role may remove datasets from the collection.

This can be done using the “Remove” button in the right-panel of the Data Collection page, when the dataset is selected. The dataset is removed from the Data Collection, but unaffected elsewhere (in its source project, or any workspace it may be published on, for example).

Note

If the user doesn’t have the “Publish to Data Collections” global group authorization or the “Publish to Data Collections” project-level authorization for the project that contains the dataset, they would not be able to revert the dataset removal.

---

## [data-catalog/datasets-indexed-tables]

# Datasets & Indexed Tables

In the **Datasets & Indexed Tables** section of the Data Catalog, you can search for any dataset used in projects on your organization’s Dataiku instance.

If you have relevant permissions, you can also use a dataset in your own projects, or publish it to a Data Collection or the Feature Store. You also can see details such as the list of projects the dataset is used in, the data steward, and when the dataset was created, modified, or last built.

If your instance admin has indexed your external database connections, you can also toggle to search **Indexed External Tables**. This section allows you to search your organization’s indexed connections, preview tables and their schemas, and import them as Dataiku datasets.

Note

You also can search for datasets through Search DSS Items, available in the Applications menu on the top navigation bar. As of version 12, though, the Data Catalog is the recommended place to search for datasets, in order to more easily view information about datasets and use them in your own projects.

---

## [data-catalog/index]

# Data Catalog

The **Data Catalog** is a central place for analysts, data scientists, and other collaborators to share and search for datasets across their organization.

From the Data Catalog homepage, which you can find in the Applications menu on the top right, you can search for data in four categories:

  * Data Collections: manually curated list of relevant datasets

  * Most Used Datasets: datasets that are automatically considered the most relevant for publication or reuse

  * Connections Explorer: directly browse connections

  * Datasets & Indexed Tables: browse the list of datasets across all accessible Dataiku projects




The Data Catalog can be accessed from the Application menu, or from a project using the “Search and import” option of the new dataset menu (other options can bring you directly to a sub-section of the catalog).

---

## [data-catalog/most-used-datasets]

# Most Used Datasets

## Basics

At the bottom of the **Data Collections** home page, you can find a **Most Used Datasets** section containing the most used datasets in your organization’s Dataiku instance.

**Most Used Datasets** are datasets that are considered the most relevant for reuse or publication to data collections, workspaces, or feature stores.

If you have the relevant permissions, you can use a most used dataset in your own projects or publish it into a Workspace, a Data Collection, or the Feature Store.

A dataset is considered most used if it satisfies one of the following conditions:

  * It has been shared at least once with another project.

  * It is considered a popular dataset.




Popular datasets are dataset that satisfies other more restrictive conditions:

  * It has been shared to at least the minimum number of projects set in the settings.

  * It has a recent last build date.

  * It is used in at least one downstream recipe in a project it is shared with, and that recipe has been run at least once.




Optionally DSS administrators can strengthen these conditions by requiring a popular dataset to be trending, or part of a least one Data Collection.

## Settings

DSS administrators can enable or disable **Popular Datasets** and tune the settings used for the computation.

To configure Popular Datasets, go to Administration > Settings > Misc.

The following parameters can be configured to drive the conditions a popular dataset must fulfill:

> Parameter | Default value | Description  
> ---|---|---  
> Max # days since last rebuild | 30 | The maximum number of days since the last build of your dataset. This parameter cannot be set to 0.  
> Max # days since last used by a new recipe | 60 | The maximum number of days since the dataset has had a new downstream recipe created in a shared project. This parameter cannot be set to 0. This parameter is also used when checking whether a dataset is trending.  
> Min # shares | 3 | The minimum number of projects a dataset must be shared with to be considered popular (excluding the source project). This parameter cannot be set to 0.  
> Only from data collections | false | If true, only consider a dataset as popular if it is part of at least one Data Collection.  
> Only trending datasets | false | If true, only consider a dataset as popular if it is trending. **Trending datasets** refer to datasets that exhibit an increasing pattern of new recipe creation over specific temporal windows, determined by analyzing historical usage data.  
  
Note

Popular datasets are not detected across multiple DSS instances.