# Dataiku Docs — deployment

## [deployment/creating-bundles]

# Creating a bundle

A bundle can be roughly seen as a snapshot of the project together with the data that are also needed for the recomputation of the tasks. A bundle differs from a mere project export because its purpose is not to move a project with all its contents from one node to another but to move the metadata and the data needed to replay the tasks that should be performed on the production environment.

Bundles are used to transfer projects from the Design node to the Automation node. For example in a simple staged deployment workflow, bundles will be created on the Design Node, then transferred to a first Automation node where some tests will be performed, and then finally to the Automation node where the actual production batch recomputing will happen. Transferring bundles between nodes can either be done [manually](<manually-importing-bundles.html>) or via the [Project Deployer](<deploying-bundles.html>).

To create a bundle on a Design Node, go to the bundle list page (Project > Bundles). You need [Write project content privilege](<../security/permissions.html>) for this.

## Bundle contents

### Metadata

A bundle always contains a snapshot of the corresponding project’s metadata at the time of its creation, which includes the following:

  * Project settings

  * Notebooks

  * Analysis

  * Recipes

  * Scenarios

  * Datasets metadata

  * Saved Models metadata

  * Managed Folders metadata

  * Model Evaluation Store metadata

  * [Project shared code](<../python/reusing-code.html#project-lib>)




Note that this does not include the actual data nor the persisted models lying under the flow. It also does not include [Global shared code](<../python/reusing-code.html#global-lib>).

### Additional Data

Optionally, you can add to the bundle the actual data of some limited datasets, managed folders or saved models depending on what should be transferred to the production environment :

  * _Datasets:_ for example for static datasets containing enrichment or reference data that are not recomputed in production.

  * _Saved Models:_ for example when you plan to score data with a model that has been trained in the Design node.

  * _Managed Folders:_ Managed folders can contain all sorts of things (images, serializations, pdfs, etc). Adding managed folders is a convenient way to move their contents to the production environment together with the projects metadata.




### Bundle release notes

Upon creation, you can see the differences between the bundle under creation and the previous one and add the appropriate release notes. This helps

  * the tracking of high level changes between bundles

  * the communications between the teams responsible for putting bundles in production when they differ from those designing the bundles.




### Bundles that include shared objects

If a bundle contains any objects that were shared to it from other projects, it will be reliant on those upstream projects. As a result, upstream bundles should always be published and activated prior to publishing and activating downstream bundles. If upstream bundles are not published prior to downstream bundles, any updates to shared objects in upstream projects will not be reflected in the downstream projects.

## Publishing the bundle on the Project Deployer

You then publish the bundles to the Project Deployer. Please see [Publishing the bundle on the Project Deployer](<deploying-bundles.html#bundles-deploying-projectdeployer-publishing>) for more information.

## Downloading a bundle

All successfully created bundles are available for download as zip archives, which you can transfer to an Automation node in order to import them.

## Reverting a bundle on the design node

You can revert a project to a given bundle version. This will replace the current state of this project with the metadata stored into the bundle. If the bundles also contains data, the data will be imported as well and override current data.

If you made changes to the [User-defined meanings](<../schemas/user-defined-meanings.html>) since the bundle creation, you will see warnings before the bundle is reverted and will be able to choose whether you want to keep these changes or restore the UDMs from the bundle.

---

## [deployment/deploying-bundles]

# Deploying bundles with the Project Deployer

This page will guide you through the process of taking a bundle that you’ve created of an existing project on your Design node, publishing the bundle on the Project Deployer, and then deploying and activating this bundle on an Automation node.

Warning

This section assumes that you already have installed and configured the DSS Project Deployer, and already have an infrastructure connected to it. Please see [Setting up the Deployer](<setup.html>) and [Deployment infrastructures](<project-deployment-infrastructures.html>) if that’s not yet the case.

## Creating the bundle

The first step is to create a bundle for an existing project. Please see [Creating a bundle](<creating-bundles.html>) for more information.

## Publishing the bundle on the Project Deployer

With your created bundle selected on the project’s Bundles list, click the “Publish on Deployer” action.

This will create a project on the Project Deployer and then import the bundle into that project. Note that a project on the Project Deployer is not the same as a Design node project, it’s just a collection of bundles that in most cases all come from the same Design node project.

Click on the link that appears, which takes you to the uploaded bundle on the Project Deployer.

## Deploying the bundle

In the Project Deployer, you now need to actually deploy your bundle to your infrastructure (Automation node).

  * From the left column of the Project Deployer, click on the bundle that was just uploaded, and select “Deploy”

  * Select the infrastructure you wish to deploy to

  * Give an identifier to your deployment. This identifier will not appear on the Automation node. It is only used on the Project Deployer

  * Optionally, choose a different “Target Project Key” and “Target Project Folder”

>     * The “Target Project Key” allows you to choose the project key of the created project on the Automation node
> 
>     * By default, projects on the Automation node will be created in the root folder

  * Create




Your deployment is ready. You can either modify its settings, or start it.

When you click on the “Deploy” (or the “Update”) button, DSS sends your bundle to the Automation node and activates it. When this process completes, you can see:

  * The health status of the deployment, visible on both the main Deployments dashboard and the deployment’s status page

  * A timeline of recent scenario runs with their outcomes

  * Stored update information, available in the **Last Updates** tab of the deployment




## Modifying deployment settings

The Project Deployer also allows you to modify the settings of a deployment without having to actually log in to the Automation node. From the Settings tab of a deployment, you are able to modify settings such as the project’s local variables, connection remapping, and current active bundle.

Whenever you modify a deployment setting, you must click the “Update” button for the new settings to be sent over to the Automation node project, even if you haven’t changed the bundle. If not, you may see the deployment enter an “Out of sync” state, which means the settings on the Automation node project do not match what you have configured on the deployment.

Note that you can also change the active bundle of a deployment by clicking on one of the “Deploy” buttons associated with a bundle that has already been published on the Project Deployer. These “Deploy” buttons are found either on the bundle page on the Project Deployer, or the left sidebar of the Project Deployer’s Deployments dashboard. If a deployment already exists for the project that the bundle belongs to, you have the option of updating that existing deployment (or creating a brand new deployment).

### Scenarios

You can also control which scenarios will be enabled or disabled on the Automation node project from the “Scenarios” section of the “Settings” tab. In this section, you can see all the scenarios located in the deployment’s current active bundle. For each scenario, you are able to select whether you want the scenario’s triggers to be enabled, disabled, or left alone when activating a bundle. “Automation local” scenarios (scenarios that were created directly in the Automation node project) cannot be controlled from here.

You can also disable all automatic triggers on the Automation node project from this section.

---

## [deployment/index]

# Production deployments and bundles

Production deployments in DSS are managed from a central place: the Deployer. The Deployer is usually deployed as a dedicated node in your DSS cluster, but may also be run locally on a Design or Automation node. See below for instructions on how to install the Deployer in your environment.

The Deployer has two separate but similar components, the Project Deployer and the API Deployer, that handle the deployment of projects and API services respectively. This section focuses on the former. To know more about the API Deployer, please see [API Node & API Deployer: Real-time APIs](<../apinode/index.html>).

The DSS Automation Node provides a way to separate your DSS development and production environments and makes it easy to deploy and update DSS projects in production. The DSS Design Node is your development environment, it is the place where you can design your flow and build or improve your data logic. Once this logic has been tested and a new version is ready to be released and deployed, you can export it to your production environment and use production data as inputs in your flow, on the Automation node. Metrics and scenarios on the Automation node allow for better assessment of the performance of your models and more control over your production data.

Deploying projects built in the Design node to the Automation node is done at project-level with project bundles. Bundles are archives that contain a given version of the flow you built in the Design node.

The Project Deployer allows you to:

  * Manage all your Automation nodes

  * Deploy bundles to your Automation nodes

  * Monitor the health and status of your deployed Automation node projects

---

## [deployment/manually-importing-bundles]

# Manually importing bundles

Even if you are not using the Project Deployer, you can still import and activate bundles directly on the Automation node.

## Uploading a bundle

There are two ways to upload a new bundle:

  * To create a new project from a bundle, use the ‘New project’ button on the Automation home page.

  * To update an existing automation project to a more recent bundle, use the ‘Import bundle’ button in the bundles section of this project.




In Project > Bundles > Bundles list, you can see the list of uploaded bundles, their content and what commits / changes are included in this bundle compared to the previous bundle.

## Connection remapping

Before importing a bundle, make sure that the required connections are available on the Automation node. You can define how connections are mapped between the Design node and the Automation node in the ‘Activation settings’ tab. If no remapping is defined for a connection, DSS will automatically try to look for a connection with the same name on the Automation node.

## Activating a bundle

Activating a bundle refers to the process of extracting the metadata and additional data of a bundle to make it the current state of the project on the Automation node. This is done by clicking the ‘Activate’ button when a bundle is selected.

Before activating the bundle, DSS will perform various checks to make sure the bundle is ready to be imported. If some of the connections used in the bundle are missing, a fatal error will be returned, and you will need to go add a connection remapping to fix it. You will see a warning in case of conflict between the current [User-defined meanings](<../schemas/user-defined-meanings.html>) and the ones in your bundle, or if there were installed plugins that were not found.

## Local states and items on Automation node

The Automation node remembers which scenarios are currently activated in a project and keeps these activation states on new bundle activation.

Even though Automation nodes are dedicated to the recomputing of bundles coming from the Design node, in some situations it may be useful to add scenarios and notebooks beside those items coming from bundle activation. This functionality is particularly interesting when different teams are responsible for the design of the workflows and their automation.

In most cases, local scenarios and notebooks are kept when you activate a new bundle. However, an existing scenario in the Automation node will be overwritten by a bundle scenario on activation if the two have the same ID.

---

## [deployment/project-deployment-infrastructures]

# Deployment infrastructures

The Project Deployer manages several deployment infrastructures, which are Automation nodes. You need to create at least one in order to deploy projects.

## Creating Automation nodes

### Custom Dataiku

You will need to install one or several Automation nodes. Please see [Installing an automation node](<../installation/custom/automation-node.html>).

Then for each Automation node, go to Administration > Security > Global API keys and generate a new API key. This key must have global admin privileges. Take note of the secret.

### Dataiku Cloud Stacks

Simply start new Automation instances.

### Dataiku Cloud

You only need to activate your Automation node in the Launchpad > Extension Tab > Add an extension > Automation node.

The installation and setup will be automatically done without needing further actions from you.

## Creating Project Deployer Infrastructure

### Setting up stages

Each infrastructure belongs to a “lifecycle stage”. This is used to show the deployments per lifecycle stage. DSS comes preconfigured with the classic “Development”, “Test” and “Production” stages but you can freely modify these stages in Administration > Settings > Deployer > Project deployment stages.

### Basic configuration

Note

If you are using Dataiku Cloud Stacks, and have enabled fleet management on your virtual network, this is done automatically, you don’t need to do these operations.

On the Project Deployer:

  * From the home page, go to Project Deployer > Infrastructures

  * Create a new infrastructure with a unique ID

  * Enter the Automation node’s base URL (including protocol and port number) and an admin API key secret

  * Go to the “Settings” tab and grant to some user groups the right to deploy projects to this infrastructure

  * Repeat for all Automation nodes




Your infrastructure(s) is ready to use, and you can create your first bundle: [Creating a bundle](<creating-bundles.html>)

### Multi-node infrastructure

Note

An administrator needs to allow the creation of multi-node infrastructures in Admin > Settings > Deployer

For projects with WebApps, such as GenAI Applications, it can be useful to have several instances of the deployed project running in parallel for redundancy. For this use case, you can create specific multi-node project infrastructures. On such infrastructures, you can define two or more automation nodes on which to deploy and monitor a project as a single deployment.

## Configuring an Automation infrastructure

### Permissions

You can define a group-based security scheme for each infrastructure, to match your internal organization and processes.

Each user using Project Deployer has access to different set of actions depending on these rights:

  * if the user is **not granted any right** , this infrastructure and all its deployments will not even be visible or usable in any way

  * the **View** right limits the user’s ability to see deployments and their details in the dashboard

  * **Deploy** grants the user the right to create, update or delete deployments on this infrastructure

  * the **Admin** right allows the user to see and edit all infrastructure settings




Note

The user security is not only defined by infrastructure but also by project, as defined in the Projects tab. This allows advanced configuration such as allowing all users to deploy any project on a DEV infrastructure but only certain user able to deploy their projects on a PROD infrastructure. You can even restrict the deployment of projects on a production instance to a technical account used by a CI/CD orchestrator through Python API, while keeping users the view rights for Monitoring. You can learn more on this type of setup in our [Knowledge Base](<https://knowledge.dataiku.com/latest/deploy/scaling-automation/tutorial-getting-started-ci-cd.html>).

### Connection remapping

It is very common to store data in different systems between development & production. When deploying a bundle to an Automation node, Project Deployer will match connections by name: if your dataset is based on a connection named db-sql on your Design node, a connection named db-sql is expected to exist on the Automation node for the deployment to succeed. This connection can point to another location, but it needs to be of the same type (FileSystem, S3, GCS, ABLS…).

However, you may want to adopt another strategy with different connections names: connection remappings are used to define such setup. If a connection remapping ‘sql-dev’-> ‘sql-prod’ is configured, upon deployment, Project Deployer will require a connection ‘sql-prod’ and point all its usage to the ‘sql-prod’ connection.

Note

Any change made to this section will only be taken into account for future deployments, not for existing ones. If you need to change existing deployments, you need to do that in the Deployment itself, in its Connections section.

### Deployment policies

This section allows you to configure more advanced configuration regarding the user and security of the deployed project.

**Permissions propagation**

With permissions propagation, you can define the default security scheme of a new project deployed to this automation node.

  * By default, this is set to **None** , only the user doing the deployment will be set as Project Owner, no other rights are granted

  * When set to **Limited** , all users & groups from the design projects will be set as readers on the deployed project. This setup is meant for controlled deployments where you want your users to deploy, monitor and diagnose projects but not do any actual change directly on the Automation node

  * The **Full** option will replicate the design project security scheme on the deployed project. This setup is targeted for fully autonomous teams or for test environments.




Whatever your setup, users or groups will never be created by the deployer, they need to pre-exist. If a user of group does not exist, it will be ignored.

If you are using LDAP logins for your Automation nodes, remember that the default behavior is to import users dynamically from LDAP the first time they connect to DSS (provided that they belong to an authorized group). This import is only done when logging on to the DSS node. Thus, before being able to push services to the Deployer, users will need to log in at least once on the Deployer node.

**Deploy as user**

As a default, any change made on the Automation node during a deployment is made under the user requesting the deployment, be it from the interface or the Python API. This means that this user needs to be granted enough rights on the this node, at least to create or update projects.

By setting a deployment user, those changes are performed by this specific user, and not the user requesting the deployment. This setup is especially useful in a some production processes where team members are meant to do the deployment but not be able to do any actual change directly on the Automation node.

**Run-as user of Scenarios & WebApps**

Scenarios and WebApps are specific objects in terms of security as they need to be able to start without an interactive user. This is why they have a specific setup called the run-as user, setup by default to the last editor of the given object.

When moving them into a production environment, this dependency on a named user, potentially changing from one bundle to another, is risky as it can lead to errors or inconsistent behavior on your production processes. The solution is to associate those executions to specific technical users upon deployment, ensuring they will run reliably over time. This is what you can define here: a specific run-as user that the deployer will enforce to all Scenarios & WebApps upon each deployment.

### Deployment hooks

Deployment hooks allows you to execute your own set of actions written in Python, pre or post-deployment (available also for API Deployments). They are meant to be used in many contexts such as:

  * Creating a ticket in a change management tool (e.g. JIRA) containing details on the deployment

  * Publishing a message on your company slack/Teams when a deployment occurs

  * Executing a specific scenario on the deployed project on Automation once the deployment is finished

  * Setting a particular group of users as administrator of the deployed project on Automation




Only Infrastructure administrators can see, edit or delete hooks.

All hooks are executed on the node where the Deployer runs and is using the configured code-env and user.

Since Hooks are consuming resources and take an unknown time to run, there is a default limitation of 3 concurrent hooks running at any given time. If a deployment requires a hook but this limit has been reached, it will wait a maximum of 10 seconds for a pre-deployment hook & 60 seconds for a post-deployment hook. If unable to get an executor, the deployment will fail.

---

## [deployment/setup]

# Setting up the Deployer

There are two modes for installing the Deployer:

  * **Local Deployer.** When your infrastructure has a single Design or Automation node that you will use to create API services and/or projects, the Deployer can be part of this DSS node itself - in that case, no additional setup is required.

  * **Standalone Deployer.** When your infrastructure includes multiple Design and/or Automation nodes that you will use to create API services and/or projects, you can install a separate DSS node which will act as the centralized Deployer for all Design and Automation nodes.




## Using a local Deployer

When you install a DSS Design or Automation node, it is already preconfigured with its own Deployer.

You can skip to the [Create your first infrastructure](<../apinode/api-deployment-infrastructures.html#apinode-installing-apideployer-apideployer-first-infrastructure>) section for the API Deployer or the [Creating Automation nodes](<project-deployment-infrastructures.html#bundles-installing-projectdeployer-projectdeployer-first-infrastructure>) section for the Project Deployer.

## Using a standalone Deployer

  * If you are using Dataiku Cloud Stacks for AWS, you simply need to create a new instance of type Deployer

  * If you are using Dataiku Cloud, you simply need to activate the automation or API node in your launchpad (extension tab). The instance and the deployer will be automatically created and managed.

  * If you are using Dataiku Custom, please see [Installing a deployer node](<../installation/custom/deployer-node.html>)




### Setup users

The whole security mechanism of the Deployer is based on the _matching of user logins_ between the various nodes. It is thus critical that the same users with the same logins exist on the Deployer node. Otherwise, your Design or Automation users won’t be able to publish to the Deployer, or deploy to the Automation node in the case of the Project Deployer.

You therefore need to setup users access on the Deployer in a similar fashion to your Design and Automation nodes.

If you are using LDAP logins for your Design and Automation nodes, remember that the default behavior is to import users dynamically from LDAP the first time they connect to DSS (provided that they belong to an authorized group). This import is only done when logging on the DSS node, so before being able to push services to the Deployer, users will need to login at least once on the Deployer node.

### Connect your Design and Automation instances

Note

If you are using Dataiku Cloud Stacks, and have enabled fleet management on your virtual network, this is done automatically, you don’t need to do these operations.

Next, you are going to configure:

  * your Design nodes so that they can publish their projects and/or API services to the Deployer

  * your Automation nodes so that they can publish API services to the Deployer




#### Generate an admin API key on the Deployer

On the Deployer, go to Administration > Security > Global API keys and generate a new API key. This key must have global admin privileges. Take note of the secret.

#### Setup the key on the Design / Automation nodes

On the Design or Automation node:

  * Go to Administration > Settings > Deployer

  * Set the Deployer mode to “Remote” to indicate that we’ll connect to another node

  * Enter the base URL (`https://[host]:[port]`) of the Deployer node that you installed

  * Enter the secret of the API key




Repeat for each Design or Automation node that you wish to connect to the Deployer.