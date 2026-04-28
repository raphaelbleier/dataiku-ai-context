# Dataiku Docs — ai-governance

## [governance/action-designer]

# Build Custom Actions

From the [Waffle menu](<navigation.html#waffle-menu>), the **Action Designer page** allows an administrator to define custom actions for custom pages.

## Configuring actions

Administrators can create custom buttons to trigger Python-based logic.

When creating a new custom action, the administrator must define:

  * a **Name**

  * a unique **ID**. All IDs are automatically prefixed with `ac.`. Once an action is saved, the ID is permanent and cannot be modified.




Upon saving, a dedicated configuration page is created for the action. From there, you can:

  * **Add a Description:** Provide context on what the action does.

  * **Define the Python Script:** Write the logic that powers the action.




The script placeholder includes helpful hints and code snippets for common tasks, such as:

  * **Debugging:** Utilizing logging within the script.

  * **Context:** Identifying the user or auth context that triggered the action.

  * **Parameters:** Retrieving parameters passed to the script.

  * **Error Handling:** Marking a script execution as “Failed” to prevent the action from completing.

  * **Integration:** Using the Public API within your logic.




See also

Examples are provided within the Developer Guide, visit [this page](<https://developer.dataiku.com/latest/concepts-and-examples/govern/govern-advanced/govern-actions.html> "\(in Developer Guide\)").

## Display actions in a custom page

To make action buttons visible and functional, an administrator must configure the [Action Settings](<custom-pages.html#action-settings>) for the specific custom page from the **Custom Page Designer**.

Note

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

---

## [governance/blueprint-designer/blueprint-designer]

# Introduction to Blueprint Designer

## Blueprints

A **blueprint** is a high-level container used to organize and store governance templates. It houses a collection of **blueprint versions** , allowing you to maintain multiple configurations within a single structure to meet specific regulatory or organizational needs.

For example, a single blueprint can host distinct versions for **GxP Compliance** (Life Sciences) or the **EU AI Act** (Risk Assessment).

### Types of blueprints

There are three primary categories of blueprints available:

  * **Govern blueprints** : Used for Standard Govern items such as business initiatives, projects, bundles, models, and model versions.

  * **Dataiku blueprints** : These embed information directly from the **Dataiku Design** and the **Dataiku Deployer** nodes to surface them within the Govern interface. To view Dataiku blueprints, click the three dots button and ensure the “Display locked blueprint” checkbox is selected.

  * **Custom blueprints** : You can create new types not related to Dataiku items or existing artifacts if you want to track specific workflows or external information.




### Managing blueprints

Within the Govern node, you have full control over how blueprints are handled. The primary actions include:

  * **Create** : Build a new blueprint from scratch to fit your specific governance needs.

  * **Import** : Upload a **JSON blueprint** provided by Dataiku or exported from a different Govern node.

  * **Export** : Save a blueprint as a JSON file to share it or migrate it between environments.

  * **Edit** : Modify existing blueprints to update their structure or metadata as your requirements evolve.

  * **Visual Identification** : Assign a specific **icon or image** to a blueprint. This allows users to quickly identify the item type visually within the Govern interface.




## Blueprint versions

A **blueprint version** is the actual template applied to Govern items. It determines exactly what information is collected, which workflows are followed, and how metadata is stored for [artifacts](<../types-govern-items.html#govern-item-content>) like business initiatives, projects, or models.

### Lifecycle status

To maintain control over your governance standards, every version follows a specific lifecycle:

  * **Draft** : The template is under construction and cannot be used yet.

  * **Active** : The version is live and available for use. Only Active versions can be applied to items.

  * **Archived** : The template is retired; it remains in the system for historical items but cannot be applied to new ones.

  * **Delete** : Permanently remove the version (only available if not in use).




### Creating Blueprint versions

Every blueprint version must reside within a parent blueprint. When creating a new version, you can choose from three primary paths depending on your needs:

  * **Import (JSON)** : This is often the simplest method for quickly deploying a template. You can upload a blueprint version JSON file provided by Dataiku or one exported from another Govern node.

  * **Fork** : Duplicate an existing blueprint version to preserve built-in logic. You can choose to **Fork a System Blueprint** (built-in logic) or **Fork a Custom Version** (previously created).

  * **Blank Template** : Create a blueprint from scratch. This starts with a completely empty schema and is recommended for advanced users only.




Note

**Best Practice** : It is strongly advised to start by copying an existing blueprint version. Many versions contain “under-the-hood” fields and workflow steps such as sign-off logic or reviewer settings that are essential for Govern to function correctly.

Once a version is created, you can manage its lifecycle through several actions:

  * **Edit** : Refine the fields, layouts, or workflows.

  * **Export** : Save the version as a JSON file for backup or migration.




### Handling changes via Migrations

As your governance requirements evolve, you may need to move items from an older blueprint version to a newer one. This is handled through Migrations.

Migrations allow you to map data elements (fields, statuses, etc.) from a source version to a target version, ensuring continuity. Within the Blueprint Designer, you can:

  * **Script a new migration** : Define the logic and field-mapping rules to transition items safely.

  * **Edit a migration** : Adjust existing mapping logic if requirements change during the transition period.

  * **Remove a migration** : Delete migration scripts that are no longer needed or were created in error.




You can learn how to apply a migration in this [how-to](<https://knowledge.dataiku.com/latest/govern/customization/how-to-switch-templates.html>).

Caution

Migrations can only be applied to blueprint versions within the same blueprint. You can not migrate across blueprints.

---

## [governance/blueprint-designer/blueprint-version-design]

# Create Templates in Blueprint Designer

## Overview

To create a template (technically called **Blueprint version**) for an item (an **artifact**), you must design both the visual interface and the lifecycle rules that govern the item.

Using the Blueprint Designer, you can define:

  * **Hierarchy:** Establish parent-child relationships between items.

  * **Layout:** activate the _Overview page_ and build structured Views.

  * **Governance Logic:** Define workflow steps, mandatory sign-offs, and visibility conditions.

  * **Automation:** Set rules for the artifact lifecycle.




## General Settings

From the **General tab** in the **Main** section you have the key information:

  * **Icon or Image** : A visual identifier inherited from the parent blueprint and customizable across each version.

  * **Name** : The display name of the template.

  * **ID** : The unique system identifier.

  * **Blueprint version instructions:** Guidance for other administrators who interact with this template.

  * **Field containing parent:** The field that defines the parent item, establishing the hierarchy used to generate breadcrumbs for users.




To define the content of the _Overview page_ and workflow steps, you will have to build **Views** , which are the collection of **view components** , **Fields** , and **Actions** , that the users will see and interact with.

## Design Views

Views define the content and structure of a Govern item page by organizing **Fields** , **Actions** , and **Containers** , acting as a dynamic display for **Overview tab** , **Workflow steps** , and **fields**.

  * **Modular Components:** Containers and subcontainers act as sections to group related fields and actions.

  * **Create Once, Use Everywhere:** A single field or action can be included in multiple views. When a shared component is updated, the changes automatically reflect across all views where it is present.

  * **Visibility:** For a field or action to be visible on an item page, it must be placed within a view.

  * **Table Layouts:** Beyond pages, views also define how rows and data are structured within tables.




### Define the view components: Fields and Actions

#### Define Fields

In this page, you will define which **Fields** you would like to use on that blueprint version. These will be the fields that Govern users will fill in or view information about the items to which this template has been applied.

Fields can be defined which contain information and can accept user inputs.

**Constraints & Options:** All field types can be set as:

  * **Required** which is a global constraint that is enforced independently of View definitions. If a field is marked as required, it must be populated regardless of which workflow step the item is in. This applies even if the field is only visible on a specific step’s view—the requirement remains active whether that step is unstarted, ongoing, or already completed.

  * **a list** allowing users to add multiple values in a single field.




Note

To edit (or view) these fields, users will need to have Write (or Read) permission for that blueprint or field.

Field type | Description | Constraints & Options  
---|---|---  
| User inputs an integer or decimal value. | 

  * Is Required
  * Is a list
  * Define allowed range

  
| This creates a checkbox in the artifact that a user can select or leave unselected. | 

  * Is Required
  * Is a list

  
| User inputs a string value. | 

  * Is Required
  * Is a list

  
| Users choose items from a dropdown list. | 

  * Is Required
  * Is a list
  * Define categories

  
| Users input a date value. | 

  * Is Required
  * Is a list

  
| Provides other artifacts in Dataiku Govern, for example a specific governed Project. | 

  * Is Required
  * Is a list
  * Source type, “Store” or “Compute”, constrain on which allowed blueprints the reference item must be.

  
| Allows users to upload a file. | 

  * Is Required
  * Is a list

  
| Mainly used for models metrics graphs. A field from this type cannot be edited directly from the GUI, only through the public API or in a hook. | 

  * Is Required
  * Is a list
  * X and Y labels

  
| Allow users to put JSON code. | 

  * Is Required
  * Is a list

  
  
#### Define Actions

Administrators can create custom buttons to trigger Python-based logic.

When creating a new custom action, the administrator must define:

  * a **Name**

  * a unique **ID**. All IDs are automatically prefixed with `ac.`. Once an action is saved, the ID is permanent and cannot be modified.




Upon saving, a dedicated configuration page is created for the action. From there, you can:

  * **Add a Description:** Provide context on what the action does.

  * **Define the Python Script:** Write the logic that powers the action.




The script placeholder includes helpful hints and code snippets for common tasks, such as:

  * **Debugging:** Utilizing logging within the script.

  * **Context:** Identifying the user or auth context that triggered the action.

  * **Parameters:** Retrieving parameters passed to the script.

  * **Error Handling:** Marking a script execution as “Failed” to prevent the action from completing.

  * **Integration:** Using the Public API within your logic.




See also

Examples are provided within the Developer Guide, visit [this page](<https://developer.dataiku.com/latest/concepts-and-examples/govern/govern-advanced/govern-actions.html> "\(in Developer Guide\)").

### Creating and Customizing Views

  * **Adding Components:** You can add individual fields or containers to organize fields. Containers can be nested to create further subsections.

  * **Arranging and Editing:** You can easily rearrange view components using a drag-and-drop interface and copy/paste, or add or delete components as needed.

  * **Configurable Properties:** The following options can be managed from the right panel menu.


Properties | Description  
---|---  
Label | You can define a label for sections and fields.  
Description | You can add a description, which will be displayed in a tooltip next to the label.  
Documentation | You can add inline documentation written in HTML.  
View type | You can define if you want to display the content as a card or a table.  
Conditional views | You can define rules based on another field value to conditionally display a field or a container.  
  
Note

Once these views are created, saved, and published, they will appear in the associated item. Users with appropriate permissions will then be able to read and write information in the fields of those views.

See also

To practice configuring views, visit this [tutorial](<https://knowledge.dataiku.com/latest/govern/customization/custom-templates/tutorial-index.html>).

## Design the template structure

### Left navigation menu

From the **General tab** in the **Main** section you will have to define the **Artifact main view:** to set which View should be used on the **Overview** tab of any item using this blueprint version.

### Design Workflows

The design of the workflow is done is the **General tab** in the **Workflow** section.

  * **Step Configuration:** Define the sequential stages of the governance process. Leave this section empty for items requiring no formal workflow.

  * **View Assignment:** Assign a specific **View ID** to each step to control what information is displayed at different stages.

  * **Sign-off Requirements:** Designate steps that require formal approval. Use the sign-off editor to define specific stakeholders (Users, Groups, or API Keys).

  * **Visibility Conditions:** Apply logic to show steps based on Field value, Archived status, Name, Workflow step and/or sign-off.




### Design Sign-offs

Dataiku Govern supports extensive customization for complex requirements where predefined templates are insufficient. You can configure sign-off logic to match your organization’s specific approval policies.

#### Sign-off Workflow

Define how approvals interact with your workflow steps:

  * **Step Integration:** Add or remove a sign-off on each workflow step.

  * **Approval Gates:** Toggle whether a sign-off approval is mandatory to advance to the next stage.

  * **Visibility Logic:** If a step has visibility conditions and is hidden when the workflow advances, mandatory sign-offs are bypassed.




Note

Mandatory sign-offs defined on workflow steps having specific visibility conditions can be bypassed if the step was not visible when advancing the workflow. It still applies even if the step becomes visible afterwards. In such case, a warning will be displayed on the workflow step, but the workflow won’t be blocked from going forward, unless that step becomes ongoing again.

#### Sign-off Assignment

Control who is responsible for reviews and approvals:

  * **Feedback Groups:** Create multiple distinct groups for multi-stakeholder reviews.

  * **Reviewer Roles:** Assign responsibility to specific Users, Groups, or Global API Keys. You can combine multiple roles within a single group.




#### Sign-off Reset & Recurrence

Automate the lifecycle of an approval:

  * **Automated Recurrence:** Setup a schedule to automatically reset an approved sign-off after a specific period.

  * **Manual Reset:** Administrators can manually trigger a sign-off reset on individual items when updates are required.




## Set rules with Hooks

Hooks are used to automate actions related to artifacts in Dataiku Govern. They are written in Python and will be run during the artifacts lifecycle phases: CREATE, UPDATE, or DELETE. Which phases are selected to run a hook is configurable.

When you first create a hook, sample code will be included to demonstrate the available functionality. Some examples of how hooks can be used include calculating a field based on other fields (for example, if you want to calculate a “risk score” based on inputs in a few different fields), or changing the owner of a project based on some criteria.

Warning

Hooks are executed before the actual action is committed, which means that the item action (save/create/delete) may fail after the hook is run. For this reason, it is not recommended to have external side-effects on other items such as using the API client to save/create/delete an item in Govern because there may be inconsistent results.

In addition, saving/creating/deleting an external item via the API client may also trigger another hook execution which is not supported at the moment and will fail the action.

If there is a need to trigger a hook on a neighbor item for syncing reasons (ie. compute a sum from children items), you may fill the `handler.artifactIdsToUpdate` list with artifacts IDs to schedule the execution of their UPDATE hooks after the action has completed on the initial artifact.

---

## [governance/blueprint-designer/index]

# Build Custom Governance templates

From the [Waffle menu](<../navigation.html#waffle-menu>), the **Blueprint Designer** allows Admin users to create as many templates as desired to use within Dataiku Govern.

Note

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

---

## [governance/custom-pages]

# Build Custom Pages

## Overview

The **Custom Page Designer** is available from the [Waffle menu](<navigation.html#waffle-menu>). It allows administrators to create as many custom pages as needed beyond the standard pages.

Using the Custom Pages Designer, you can present your own selection of items with the option to display a Matrix as well. Custom and standard pages can be reordered and hidden in the navigation bar.

In the Custom Pages Designer, you will be able to:

  * Choose which items to show.

  * Utilize both standard and custom [blueprints](<blueprint-designer/blueprint-designer.html>).

  * Select the Row Views you want to use.

  * Utilize custom [actions](<action-designer.html>).

  * Create additional visualizations.




You will also be able to export a custom page as JSON and import it to another Govern node.

## General settings

The administrator defines a custom page by an ID, name, and an icon. The ID is prefixed by `cp.`. Once created, the ID cannot be changed.

Saving creates a preview of the page which is hidden from all non-admin users. Once the content is validated, you can set the page as **visible**.

From the left tab, you will be able to:

  * Search standard and custom pages.

  * Hide or unhide standard and custom pages.

  * Reorder standard and custom pages by dragging and dropping.

  * Export the selected custom page.

  * Delete custom pages.




Note

Standard pages cannot be deleted from Dataiku Govern. They can only be hidden from the navigation menu.

## Custom Page content

After creating a page, the user must select the **Custom Page content** of the page.

There are three types:

  * **Item table** , which is the default.

  * **Item table and matrix**.

  * **Custom HTML**.




This choice will trigger different settings to configure.

## Page settings

By default all items are displayed, and you can dynamically filter items using rules on:

  * Field value

  * Item type

  * Template

  * Item

  * Archived status

  * Name

  * Workflow step

  * Sign-off

  * Item contents




## Action settings

Administrators can configure specific actions to appear within the **vertical dots** menu on a custom page. To enable an action, the following parameters must be defined:

  * **Action ID:** Select the unique identifier of the custom action created from the [Action Designer](<action-designer.html>).

  * **Action Label:** Enter the text that will be displayed to the user in the menu.

  * **Input Parameters:** Define any required parameters that need to be passed to the Python script during execution (optional).

  * **Icon and Color:** Customize the visual representation of the action to help users identify it quickly.




## Table settings

The administrator defines the column to display by default within the table. The columns directly available are:

  * the **Name** of the item,

  * the **Workflow** status,

  * and the **Edit row button**.




For other column definition, select **View** and choose the blueprint in the first dropdown and fill-in the corresponding view ID in the View field. The field will suggest Row Views associated with the blueprint, as you can only select a row view ID.

See also

To learn more about views please refer to [Views and view components section](<blueprint-designer/blueprint-version-design.html#views-view-components>).

## Matrix view settings

The administrator defines a Matrix View by filling in the following fields:

  * **Matrix Label** , which will override the dynamic title (optional).

  * X and Y Axes, which define the default matrix axes.




### Matrix zones

The user can also choose the color gradient of the matrix zones.

Dataiku provides three preset color themes: **Business Value theme** , **Risk Matrix theme** and **Business Initiative theme**.

It is also possible to create a **Custom theme**. Custom theme options include the background colors and the point border colors.

## Custom HTML settings

There is also an option to create a page defined by HTML code. For example, you can embed dashboards and videos from external tools, or even from Dataiku DSS.

See also

To practice using the Custom Pages Designer, visit [this tutorial](<https://knowledge.dataiku.com/latest/govern/customization/custom-pages/tutorial-index.html>).

Note

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

---

## [governance/deployment-policies]

# Deployment Governance policies

Note

The following information applies to both deployment of model versions on an API node and deployment of bundles on an Automation node.

Once Dataiku Deployer is linked with your Dataiku Govern instance, you might define a governance policy for each Deployer Infrastructure.

From the infrastructure settings, you can choose between 3 different governance policies that will apply for all deployments made on this infrastructure:

  1. **Prevent the deployment of unapproved packages.** If the model version or the bundle is approved, its status will be updated and it can be deployed. If the model version or the bundle is abandoned or rejected, the workflow will be locked and deployment will be blocked. You will get an error asking you to complete the approval process before deployment.

  2. **Warn and ask for confirmation before deploying unapproved packages.** You will receive a warning asking you if you really want to continue the deployment.

  3. **Always deploy without checking.** You will be able to deploy regardless of the sign-off status. This is the default value.

---

## [governance/governance-features]

# Governance Process Features

## Governance actions

The **two key governance actions** for governable synced items, **Govern or Hide** , are automated or guided by policies configured on the [Governance settings page](<governance-settings.html#governance-settings>).

### Hide - Exclude items from the Governance cycle

**Hide action** means that **no governance action** is necessary. This will hide the item from Dataiku Govern user interface.

Governance **rules** are applied **based on the hierarchical structure of Dataiku items**. Below are the rules that you must know:

  * If a parent is hidden then the children will be automatically hidden. For example, if a saved model is hidden then all the related saved model versions will be hidden.

  * The hidden state is not a deletion. This state will not affect the visibility in other nodes and the user can still decide to put the item in a “governable” or “governed” state.




### Govern - Apply a Governance layer

Applying a **governance layer** enables governance qualification by applying a structured process with a Workflow and a review process with a Sign-off.

**A Standard template** is available for **each item type**. It is also possible to define specific templates according to the governance need. More specifically, you can customize the Govern item content by defining fields, views, the [Workflow](<blueprint-designer/blueprint-version-design.html#custom-workflow>), and the [Sign-off](<blueprint-designer/blueprint-version-design.html#custom-sign-off>) definition by using the [Build Custom Governance templates](<blueprint-designer/index.html>).

**Governance rules** are applied **based on the hierarchical structure of Dataiku items**. Below are the rules that you must know:

  * An item can be governed only if its parents are governed. For example, a saved model version can only be governed if the associated model and project are governed.

  * By default, upcoming items inherit rules from the instance Governance settings page.




See also

More information is available in [Concept | Adding a governance layer to Dataiku items](<https://knowledge.dataiku.com/latest/govern/overview/concept-adding-governance.html>).

## Notifications

Notifications in Dataiku Govern are **configured around sign-offs**. If a user is included in a sign-off, Dataiku Govern will notify them when an important status change occurs.

### Email notifications

Emails notifications can be sent to users who:

  * Were automatically subscribed.

  * Have explicitly subscribed an item and its children if applicable.




Email are sent to users when:

  * Feedback or Final approval is submitted.

  * Feedback or Final approval is edited. Notifications are only sent for status changes and not for edits to comments.

  * A sign-off is abandoned.

  * A sign-off is canceled.

  * A sign-off is reset.

  * A sign-off reset is scheduled (Advanced license feature).




Emails can be sent to **specific users** when:

  * Delegating Feedback or Final approval.




### Notification subscriptions

Users are automatically subscribed when they:

  * Create/govern, edit, or save a Govern item.

Note

If you govern a project by attaching it to an _existing_ Govern project, Dataiku will automatically subscribe the user to the existing Govern project even though it is not an item creation.

  * Submit Feedback or a Final approval.

  * Edit Feedback or a Final approval.

  * Abandon a sign-off.

  * Cancel a sign-off.

  * Reset a sign-off.

  * Schedule a sign-off (Advanced license feature).




Users can find the option to **unsubscribe** from the header of the item page or from the footer of a notification email.

Note

Email notifications must be configured by your administrator first. See [Setting up email notifications](<setup.html#governance-email>) for more details.

See also

To learn more, see [How-to | Subscribe to email notifications](<https://knowledge.dataiku.com/latest/govern/overview/how-to-subscribe-emails.html>).

## Governance across Dataiku nodes

While the Govern node syncs metadata from Dataiku nodes, Dataiku nodes also sync information from the Govern node.

For example, a **Governance status** section is visible on the Design node for each model version of saved models in its summary page, letting you know at which stage of the Governance workflow process your model is.

Similarly, in the bundle summary, there is a governance status section:

[](<../_images/governance-status-bundle.png>)

---

## [governance/governance-settings]

# Instance Governance settings

From the [Waffle menu](<navigation.html#waffle-menu>), the **Governance settings page** allows administrator to define governance rules for the entire instance.

There are different ways to define the [Governance action](<governance-features.html#governance-actions>) to apply on items:

  * **Automated** : Automatically apply the governance action without any manual user intervention as soon as items are synced or updated.

  * **Recommended** : Suggests the most suitable governance decision to make from the governance modal.

  * **Do Nothing** : Manually choose the governance action to apply from the governance modal.




Rules coming from this settings will be identified by an `Instance rules` tag. Instance rules can be overridden on “parent items”, which will then be tagged with:

  * `Custom rules` for projects.

  * `Project rules` for bundles and models.

  * `Model rules` for model versions.




Warning

Auto-governance will be applied only if the parents are governed.

With the **Advanced license** , it is also possible to **script the governance policies** , allowing for the creation of specific rules based on underlying asset metadata, such as _tags_ or _AI Types_. Furthermore, governance policies can be extended to related items, including the versions of a model.

See also

Refer to the Developer Guide for [examples of Governance settings scripts](<https://developer.dataiku.com/latest/concepts-and-examples/govern/govern-advanced/govern-policies-with-script.html> "\(in Developer Guide\)").

---

## [governance/index]

# AI Governance

Dataiku Govern is a **unified platform for overseeing and managing data and AI initiatives** across an organization, which is integrated as an [additional node in your Dataiku platform](<https://knowledge.dataiku.com/latest/govern/overview/concept-govern-in-dataiku-architecture.html>).

This documentation serves as your primary guide, covering the core concepts, interfaces, and features of Dataiku Govern, as well as its installation, configuration, and administrative operations.

To meet the diverse needs, two licenses are available:

  * **Standard License** : This license includes the core features of the platform.

  * **Advanced License** : Designed for enterprises with higher requirements for control and customization, the Advanced license unlocks powerful governance and advanced management features. The included features are:

>     * **Governance of GenAI items** and access to a dedicated GenAI registry page for centralizing and managing your assets.
> 
>     * **Custom actions** definition with the **Action Designer**.
> 
>     * **Custom governance templates** creation with the **Blueprint Designer**.
> 
>     * **Custom pages** creation with the **Custom Page Designer**.
> 
>     * **Custom governance settings** by using **scripting**.




## Dataiku Govern Concepts

## Govern node Installation and Setup

## Implementation of Governance Policies

## Custom Governance Processes

## Integrating with Dataiku Govern

---

## [governance/navigation]

# Navigation in Dataiku Govern

Dataiku Govern’s interface is organized into two main navigation areas: the **main navigation menu** and the **Application menu**.

## Pages from the top navigation bar

Pages from the top navigation bar are the main working spaces where all **synced and governed items are organized**. All of these pages feature a table that can display items as a **flat list, grouped by type, or with hierarchical relationships**.

### Standard Dataiku Govern pages

  0. The **Home** page is the main landing page, offering a quick overview of your review tasks and access to essential resources.

>      * **Learn more about Dataiku Govern:** This section contains direct links to [Reference Documentation](<https://doc.dataiku.com/dss/latest/governance/index.html>), [Knowledge Base](<https://knowledge.dataiku.com/latest/govern/index.html>), [Developer Guide](<https://developer.dataiku.com/latest/concepts-and-examples/govern/index.html>), [Academy](<https://academy.dataiku.com/path/governance>), and the [Community](<https://community.dataiku.com>) websites.
> 
>      * **AI Governance Solutions:** This section contains direct links to [EU AI Act Compliance Readiness](<https://www.dataiku.com/solutions/catalog/eu-ai-act-readiness/>), [Streamlined GxP Workflows](<https://www.dataiku.com/solutions/catalog/streamlined-gxp-workflows/>) and [Model Risk Management](<https://www.dataiku.com/solutions/catalog/model-risk-management/>) solutions.

  1. The **Governable items** page acts as an inbox for all synced items that have not been governed yet, highlighting what needs your attention.

  2. The **Model registry** page is a central repository for a hierarchical, project-based view of your models. Here, you can review model status, performance, and deployment metrics, track input drift, and see whether a model is governed and its current state (e.g., in production, waiting for approval, etc.).

  3. The **GenAI registry** page is a central repository for a hierarchical, project-based view of your generative AI assets. This includes fine-tuned LLMs, Agents, and Augmented LLMs, each with their respective versions.

  4. The **Bundle registry** page is a central repository that provides a hierarchical, project-based view of your bundles. Here you can easily review their status, track whether a bundle is governed and its current state (e.g., in production, waiting for approval), and drill down for more detailed information.

  5. The **Business initiatives** page provides a comprehensive list of your organization’s business initiatives. In addition to the **Matrix** view, it also offers **Kanban** view for flexible visualization, management, and monitoring.

  6. The **Governed projects** page is a list of all projects that have been officially brought under governance. For flexible visualization and monitoring, the page can be displayed in both a **Matrix** and a **Kanban** view.




### Views of pages

**Filters**

Tables can be filtered with the page header. In addition to the pre-defined filters that you can use, there is an option [](<../_images/custom-filter.png>) to refine your results further. Using the filter button, you can define logical operations and conditions to meet your requirements. The conditions you create can filter field values, workflow steps, sign-off statuses, and more.

**Access to additional metadata**

A right-hand panel on every page shows both synced and governance metadata. Depending on the item selected in the table or card you will be able to see the metadata linked to the item.

## Pages from the waffle menu

The waffle menu provides access to history, design and core administrative functions.

**Access your Govern instance history**

  * The **Timeline** page is a centralized hub for viewing a history of all item-related events, including creations, updates, and deletions.




**Customize your governance processes**

  * The **Action Designer** page allows you to create custom actions displayed as buttons within custom pages.

  * The **Blueprint Designer** page allows you to create custom governance templates.

  * The **Custom Pages Designer** page allows you to create custom pages for the instance.




**Security and governance policies configurations**

  * The **Governance Settings** page allows you to configure your instance’s specific governance policies.

  * The **Roles and Permissions** page allows you to define and manage user access rights for specific items.

  * The **Administration** page helps you to manage core system functions. This includes security, logs, user setup, authentication, and notifications.

---

## [governance/publicapi/features]

# Features

The Dataiku Govern public API allows you to perform the following operations in Dataiku Govern:

  * Blueprints and blueprint versions

>     * List accessible blueprints and blueprint versions

  * Artifacts

>     * Search and retrieve artifacts
> 
>     * Create, edit, and delete artifacts
> 
>     * Interact with sign-offs (feedback, final approval, etc.)
> 
>     * Interact with uploaded files and time series

  * Administration

>     * Manage users and groups
> 
>     * Manage API keys
> 
>     * Manage logs
> 
>     * Access the Blueprint Designer
> 
>     * Access the Role and Permissions Editor
> 
>     * Access the Custom Page Editor

---

## [governance/publicapi/index]

# Govern Public API

The Dataiku Govern public API allows you to interact with Govern from any external system. It allows you to perform a large variety of administration and maintenance operations, in addition to access to items and other data managed by Dataiku Govern.

The Dataiku Govern public API is available:

  * As a [Python API client](<https://developer.dataiku.com/latest/concepts-and-examples/govern/index.html> "\(in Developer Guide\)"). This allows you to easily send commands to the public API from a Python program. This is the recommended way to interact with the API.

  * As an [HTTP REST API](<rest.html>). This lets you interact with Dataiku Govern from any program that can send an HTTP request. This requires more work.




Example usage of the Python client can be found in the [Developer Guide](<https://developer.dataiku.com/latest/concepts-and-examples/govern/govern-client.html> "\(in Developer Guide\)").

---

## [governance/publicapi/keys]

# Public API Keys

All calls to the Dataiku Govern public API, either performed using [The REST API](<rest.html>) or [the Python client](<https://developer.dataiku.com/latest/concepts-and-examples/govern/index.html> "\(in Developer Guide\)") must be authenticated using API keys.

There is only one type of API key for the Dataiku Govern REST API:

  * Global API keys




## Global API keys

Global API keys are keys that are defined for the whole Dataiku Govern instance. Global API keys can only be created and modified by DSS administrators.

Global API keys are not equivalent to a DSS user. Global API keys have their own access rights, and calls performed will appear as having been performed by this key.

Global API keys are defined in Administration > Security > Global API Keys

### Global admin

This special permission gives global admin rights to this key. A global admin key has all permissions in the Dataiku Govern instance. It can also perform global DSS administration tasks:

  * Manage users

  * Manage log files

  * Access the Blueprint Designer

  * Access the Role and Permissions Editor

  * Access the Custom Page Editor

---

## [governance/publicapi/rest]

# The REST API

At its core, the Dataiku Govern public API is a REST HTTP API. The reference HTTP documentation of the Dataiku Govern REST API can be found here: <https://doc.dataiku.com/dss/api/14/govern>.

The API base URL is: `http://dss_host:dss_port/public/api/`

## Request and response formats

For POST and PUT requests, the request body must be JSON, with the Content-Type header set to application/json.

For almost all requests, the response will be JSON.

Whether a request succeeded is indicated by the HTTP status code. A 2xx status code indicates success, whereas a 4xx or 5xx status code indicates failure. When a request fails, the response body is still JSON and contains additional information about the error.

## Authentication

Authentication on the REST API is done via the use of [API keys](<keys.html>). API keys can be managed through the Dataiku Govern administration UI.

The API key must be sent using HTTP Basic Authorization:

  * Use the API key as username

  * The password can remain blank




## Authorization

Each API key has access rights and scopes. Dataiku Govern has a simple UI to edit API key permissions.

For more information about API keys, see [Public API Keys](<keys.html>)

## Methods reference

The reference documentation of the API is available at <https://doc.dataiku.com/dss/api/14/govern>

The API base URL is: <http://dss_host:dss_port/public/api/>

---

## [governance/setup]

# Govern Instance Setup

## Installing Govern

There are two modes for installing Govern:

  * If you are using [Dataiku Cloud Stacks](<../installation/cloudstacks-aws/index.html>) , you simply need to create a new instance of type Govern.

  * If you are using Dataiku Custom, please refer to [Installing a Govern node](<../installation/custom/govern-node.html>).




## User setup and authentication

It is recommended to have the same user logins between the different nodes of your Dataiku cluster. Users management on Govern node is the same as on other node types. Please see [Security](<../security/index.html>) for more details.

## Connecting your Govern and Design, Automation or Deployer instances

Warning

We recommend that you keep the versions of the nodes connected to Govern in sync with the version of the Govern node.

Although it may work, connecting nodes to Govern with different software versions is not supported.

Note

If you are using Dataiku Cloud Stacks, and have enabled fleet management on your virtual network, this is done automatically, so you don’t need to do the following operations.

Next, you are going to configure:

  * your Design / Automation nodes so that the different objects (projects, models, model versions) can be published to Govern

  * your Deployer nodes so that they can check the governance status of projects or API services before deploying them




### Setting up your node IDs

For the Govern integration to work properly, you have to set the node ID of every DSS node that will connect to Govern.

You can configure a node ID by adding a `nodeid` configuration option to the `general` section of the `DATADIR/install.ini` file, as shown in the example below:
    
    
    [general]
    nodeid = YOUR_NODE_ID
    

After modifying that file, you will have to restart the DSS node in question.

You also have to make Govern aware of the node IDs you configured. In Govern, go to “Administration > Settings > Notifications & Integrations” and add an entry per node to the “Fallback node references” section.

### Generate an admin API key on Govern

On Govern, go to Administration > Security > Global API keys and generate a new API key. This key must have global admin privileges. Take note of the secret.

### Setup the key on the Design / Automation / Deployer nodes

On the Design, Automation or Deployer node:

  * Go to “Administration > Settings > Dataiku Govern”

  * Enable Dataiku Govern integration

  * Enter the base URL (`http(s)://[host]:[port]`) of the Govern node that you installed

  * Enter the secret of the API key




Repeat for each Design / Automation / Deployer node that you wish to connect to Govern.

## Making Govern aware of its external URL

As any other node type, Govern cannot guess what its external URL is.

The external URL is used any time Govern needs to build an absolute URL for the user, for example when sending links to Govern in an email.

To configure this setting, go to “Administration > Settings > Notifications & Integrations” and click on the wand icon: it should automatically set the Govern external URL by looking at the current URL of your browser.

## Defining the Govern instance name

You can set the name of your Govern node by going to “Administration > Settings > Instance”.

If you set an instance name, it will be displayed at the top right of every page of this instance, in the main navigation bar.

When defined, the instance name will also be included in audit trail messages when they are sent to an [event server](<../operations/audit-trail/eventserver.html>).

## Setting up email notifications

Govern can be configured to send email notifications when appropriate. Currently, this is mostly used to notify users about changes in the [sign-off status of an item](<types-govern-items.html#sign-off>).

To enable email notifications:

  * Go to “Administration > Settings > Notifications & Integrations”.

  * Enable the “Enable notification emails” checkbox.

  * Fill-in the SMTP server connection parameters (host, port, SSL, TLS, login, password).

  * Click “Save”




In addition, you must make sure that users who wishes to receive email notifications have their email address correctly set in their user profiles.

## Managing security

Please see [Govern Security: Permissions](<../security/govern-permissions.html>) for details on the Govern security model.

---

## [governance/types-govern-items]

# Items in Dataiku Govern

Item is the generic way to describe the objects manipulated in Dataiku Govern. Items can be:

  * **Synced items** : they are synced from Dataiku nodes and the hierarchical relationship between objects are represented in the way Dataiku Govern employs inheritance throughout its architecture.

  * **Govern items** : these can be pure Govern objects such as Business initiatives or the representation of the layer of governance added on synced items.




See also

More information is available in [Concept | Governed items](<https://knowledge.dataiku.com/latest/govern/overview/concept-governed-items.html>)

## Items synced in Govern

In Dataiku Govern, items created in Dataiku nodes and their associated metadata are automatically synchronized. Items from the Design node have a hierarchical structure, which is reflected in the Registry pages.

Types of **governable items** include:

  * Projects

  * Bundles

  * ML Saved Models and their versions

  * GenAI Items, including:

>     * Fine-tuned LLMs and their versions.
> 
>     * Agents and their versions.
> 
>     * Augmented LLMs and their versions.




See also

More information is available in [Concept | Surfacing Dataiku items in the Govern node](<https://knowledge.dataiku.com/latest/govern/overview/concept-centralization-in-govern.html>)

## Dataiku Govern items

Dataiku Govern enables users to add a governance layer with specific definitions, metrics, attachments, workflows, and sign-offs. You can create this governance layer in two ways:

  * **By adding a layer** to existing synced items.

  * **By independently creating** a layer, such as for Govern projects, Business initiatives, and custom items.




A **Govern project** can be started from the “Governed projects” page during the ideation phase, even before it is linked to a Dataiku project.

For better organization, you can group governed projects into **Business initiatives** , which are created in Dataiku Govern to link multiple projects with shared business goals.

See also

More information is available in [Concept | Adding a governance layer to Dataiku items](<https://knowledge.dataiku.com/latest/mlops-o16n/govern/concept-adding-governance.html>)

## Govern item content

Each Govern item page has detailed information that you can access in the left navigation menu.

### Access the synced design and deployment metadata

  * The **Source objects** tab provides a view of the metadata connected from your **Dataiku Design node**. The information displayed is contextual, meaning it changes based on the item type.

> Type of metadata | Description  
> ---|---  
> General Information | Essential details such as the Node ID, creation date, and author.  
> Related Items | A list of connected items like projects, models, bundles, LLMs, and Agents.  
> Specific to an item type | For example, when viewing a bundle, this section will also include specific details like Release notes, Project standards values and the AI Types.  
  
  * The **Model metrics** tab is only available for _Dataiku Saved Model versions_. The information are related to the _Active version_ , the _Data drift_ and the _Performance metrics_.

  * The **Deployments** tab provides updates on deployable items like _Saved Model versions_ or _bundles_ , including their deployment status and related infrastructure details.

> Type of information | Description  
> ---|---  
> Deployment Location | The specific infrastructure and its type where the item is deployed.  
> Governance Policy | The specific Govern policy that is configured for the deployment.  
> Deployment History | The total number of times the item has been deployed.  
  



See also

More information is available in [Concept | Governed items](<https://knowledge.dataiku.com/latest/govern/overview/concept-governed-items.html>).

### Add Governance metadata

  * The **Overview** tab is a central location for enriching an item with additional metadata for governance purposes. The specific fields you can provide are contextual and vary by item type.



  * **Workflow** : Dataiku Govern provides a sequential _Standard workflow_ for tracking and managing AI items, allowing users to monitor an item’s status and its entire journey. For a clear record of progress, each item can have extra information and predefined workflows attached, with each step updated to a specific status.

> Workflow Steps Status | Description  
> ---|---  
> Not Started | The workflow process has not been initiated.  
> On Going | The work on the step is active.  
> Finished | The step is completed.  
>   
> See also
> 
> More information is available in [Concept | Governed items - Advancing the status of Govern items through a workflow](<https://knowledge.dataiku.com/latest/govern/overview/concept-governed-items.html#advancing-the-status-of-govern-items-through-a-workflow.html>).



  * **Sign-off** is associated to a workflow steps. Reviews can be assigned to either roles, individuals or groups. In the _Standard workflow_ , this sign-off occurs during the **Review step** , which includes **Feedback** and **Final Approval**. The Final Approval status is checked by Dataiku Deployer and the deployment authorization depends on the [Govern policy](<deployment-policies.html>) set up on the infrastructure.

> Review type | Description | Possible statuses  
> ---|---|---  
> Feedback | Guide the final approver’s decision. | `Approved` / `Minor issue` or `Major issue`.  
> Final approval | Only one final approval can be submitted. | `Approved` / `Rejected` / `Abandoned`  
>   
> See also
> 
> More information is available in [Concept | Sign-offs in workflows of Govern items](<https://knowledge.dataiku.com/latest/mlops-o16n/govern/concept-reviews-signoffs.html>).

  * From the **Attachments** tab, references and files can be added.




### Access your govern instance history

The **Timeline** records significant changes, including who made the change, a description, and a timestamp. A detailed table further shows the name of the updated attribute, its previous value, and its new value. To be able to easily find information about specific events, you can also filter the timeline.

### Adapt governance policies to a specific item

The **Governance settings** tab displays the [Instance Governance settings](<governance-settings.html>). From there, it is also possible to define specific rules that override the instance-level one.

### Assign permissions to a specific item

**Role assignments** can be configured at the item level with the **artifact admin** permission. Permissions, inherited role assignment rules, and computed roles are not editable at the item level. To do this, go to the **Roles and Permissions** settings.

See also

To learn more about role assignment rules settings, please refer to [Govern Security: Permissions](<../security/govern-permissions.html>).