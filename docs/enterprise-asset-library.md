# Dataiku Docs — enterprise-asset-library

## [enterprise-asset-library/index]

# Enterprise Asset Library

## Core concepts

The Enterprise Asset Library serves as the central hub for sharing, discovering, and reusing high-value assets across your organization. By providing a unified repository, it enables teams to build upon existing work rather than starting from scratch, fostering collaboration and accelerating development.

The Enterprise Asset Library currently supports the storage and distribution of:

  * Projects: Full DSS projects and all their associated components

  * Prompts: Reusable text prompts for use in Generative AI workflows inside Agent Hub

  * Prompt Templates: Advanced prompts where users can also define inputs and provide sample inputs and their corresponding outputs.




Note: Support for additional asset types is planned for future versions.

## Organization and access control

The Enterprise Asset Library can be accessed from the waffle menu. In order to have access to it, you need to have either the “Create Enterprise Asset Collections” permission or the “Manage Enterprise Asset Library” permission.

  * The “Create Enterprise Asset Collections” permission lets you access the Enterprise Asset Library and gives you the rights to create collections inside it.

  * The “Manage Enterprise Asset Library” permission acts as an admin level permission on the entire Enterprise Asset Library and on all the collections inside it.




These permissions are properties of DSS groups and can be found under the “Advanced permissions” section.

Assets within the Enterprise Asset Library are organized into collections. Access to collections is governed by a granular permission system. Permissions can be assigned to individual Users or entire Groups, ensuring that assets are exposed only to the relevant audiences. There are three distinct permission levels available:

  * **Reader** : This permission allows you to view assets within the collection and use the assets contained inside.

  * **Contributor** : This permission includes all Reader rights as well as uploading new assets to the collection. You can also update and remove existing assets.

  * **Admin** : This permission includes all Contributor rights, but also allows you to manage the permissions for the collection. You can add and remove users and groups, as well as change their permission levels.




For more information, consult the documentation for supported assets:

---

## [enterprise-asset-library/project-management]

# Managing projects

This guide outlines the lifecycle of an Enterprise Asset Library project: preparing the metadata, uploading the project, and installing it from the Enterprise Asset Library.

## Preparing a project for the upload to the Enterprise Asset Library

Before uploading a project, you can embed specific metadata and documentation within the project files. Otherwise you can define mandatory metadata them during the upload.

### 1\. Create metadata in project files

Open the existing project you wish to publish. From the top navigation bar, expand the coding section and select Libraries. On the Libraries page, click on “Resources” in the top right corner. You must create a specific folder structure to store the project information. Inside lib folder, create a new folder named “metadata”. Inside the metadata folder, create a file named `project.json`. The `project.json` needs to have the following JSON structure
    
    
    {
      "id": "MY_ID",
      "name": "The name shown in the UI",
      "description": "A description of the project shown underneath the name of the project",
      "version": "1.5.0",
      "tags": ["tag1", "tag2"]
    }
    

Guideline on the fields:

  * Mandatory Fields: id, name, and version.

  * Optional Fields: All other fields are optional. If left empty, they will appear blank in the Enterprise Asset Library UI.

  * Versioning: The version field does not require a strict semantic versioning system. Accepted characters mirror DSS group name standards: letters, numbers, periods (.), hyphens (-), and underscores (_).




### 2\. Add documentation

To provide a detailed overview of the project, create a `README.md` file inside the metadata folder. This file supports Markdown formatting. The content will be rendered and visible within the Enterprise Asset Library interface alongside the JSON metadata. This step is optional.

Note on project images: The project image currently set in your project settings will be automatically used as the thumbnail in the Enterprise Asset Library and will persist when the project is installed by other users.

### 3\. Export the project

Once the `project.json` and `README.md` are configured, export the project as a standard DSS project archive (ZIP). Save the archive to your local machine.

## Uploading to the Enterprise Asset Library

To publish a project, you must have Contributor rights on the target Enterprise Asset Library collection. Navigate to the Enterprise Asset Library and open the collection where you wish to upload the project. Click “New Asset” from the top right corner and select Upload project.

Note: If the collection is empty, this button also appears in the center of the screen.

Select the project archive you exported in the previous section. Click “Import”.

A modal will appear displaying the extracted metadata:

  * Left Pane: Displays the content of `project.json`.

  * Right Pane: Displays the rendered `README.md`.




Click “Create” to finalize the upload.

If you upload a project with an id that already exists in the Enterprise Asset Library, the system will detect it as an update. The modal will display the Previous Version alongside the New Version you are uploading. Proceeding will override the previous entry with the new version.

## Installing a project from the Enterprise Asset Library

Any user with Reader rights on an Enterprise Asset Library collection can install projects from it. Navigate to the DSS Home Page. Click on “New Project”. In the dropdown menu, select Enterprise Asset Library projects. A modal will display all projects available to your user profile. Click on a project to view its details and click “Install” to import it into your instance.

---

## [enterprise-asset-library/prompt-management]

# Managing prompts

This guide outlines the lifecycle of a prompt in the Enterprise Asset Library: creating the prompt, reviewing it, updating it and using it in Generative AI workflows.

## Creating a prompt

To create a prompt, you must have Contributor rights on the specific collection where you wish to add the asset.

Open the Enterprise Asset Library. Click into the target Collection. There are two ways to start creating a prompt:

  * Standard Method: Click “New Asset” in the top right corner and select “Create prompt” from the dropdown menu.

  * Empty State Method: If the collection does not contain any prompts yet, navigate to the Prompts tab (top left of the collection view). A “Create prompt” button will be available in the center of the screen.




A modal will appear requiring the following information:

  * Name: The display name for the prompt.

  * Description: A brief summary of the prompt’s purpose.

  * Tags: Organize your prompt using keywords. You may create new tags or select existing tags previously used on other prompts.

  * Content: The actual text or logic of the prompt.




Click “Create” to save the new asset. The prompt will immediately appear inside the Prompts tab.

## Viewing and editing prompts

Prompts are managed directly within the Prompts tab of a Collection. The actions available to you depend on your permission level for that specific collection. Users with Reader rights can browse the Prompts tab and click on any prompt to view its full details. Users with Contributor rights can edit existing prompts. Click on the prompt in the list to open the details modal. Modify the fields directly within the modal. Click “Update” to save your changes.

## Using prompts

Once created, prompts to which you have access are available for use inside the Prompt Library. The Prompt Library can be found in multiple places inside the AI Features tab, including the Prompt Studios, Agent Tools and others. You can access and use any prompt stored in a collection where you hold at least Reader rights.

---

## [enterprise-asset-library/prompt-template-management]

# Managing prompt templates

This guide outlines the lifecycle of a prompt template in the Enterprise Asset Library: creating the prompt template, reviewing it, updating it, and using it in Generative AI workflows.

## Creating a prompt template

To create a prompt template, you must have Contributor rights on the specific collection where you wish to add the asset.

Open the Enterprise Asset Library. Click into the target Collection. There are two ways to start creating a prompt template:

  * Standard Method: Click “New Asset” in the top right corner and select “Create prompt template” from the dropdown menu.

  * Empty State Method: If the collection does not contain any prompt templates yet, navigate to the Prompt Templates tab. A “Create prompt template” button will be available in the center of the screen.




A modal will appear requiring the following information:

  * Name: The display name for the prompt template.

  * Description: A brief summary of the template’s purpose.

  * Tags: Organize your template using keywords.

  * Prompt prefix: The actual text or logic of the prompt template.

  * Inputs: Define the input variables for your template.

  * Examples: Provide sample inputs and their corresponding output to guide the model.




Click “Create” to save the new asset. The prompt template will immediately appear inside the Prompt Templates tab.

## Viewing and editing prompt templates

Prompt templates are managed directly within the Prompt Templates tab of a Collection. The actions available to you depend on your permission level for that specific collection. Users with Reader rights can browse the Prompt Templates tab and click on any template to view its full details. Users with Contributor rights can edit existing templates. Click on the template in the list to open the details modal. Modify the fields directly within the modal. Click “Update” to save your changes.

## Using prompt templates

Once created, prompt templates to which you have read access are available for use in the Prompt Studio when adding a managed prompt.