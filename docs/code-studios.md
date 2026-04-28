# Dataiku Docs — code-studios

## [code-studios/code-studio-ides/code-assistants]

# AI Code Assistants in Code Studios

You can use the following AI Coding Agents in Code Studios:

  * [OpenAI Codex](<../../ai-assistants/codex.html>)

  * [OpenCode](<../../ai-assistants/opencode.html>)

  * [GitHub Copilot](<../../ai-assistants/github-copilot.html>)

  * [AI Code Assistant](<../../ai-assistants/code-assistant.html>)

---

## [code-studios/code-studio-ides/index]

# IDEs in Code Studios

Note

All the following sections assume that you meet [the prerequisites](<../code-studio-requirements.html>) and, notably, that you have an Elastic AI setup, and a containerized execution configuration

---

## [code-studios/code-studio-ides/jupyterlab]

# JupyterLab

In this section, we will define a Code Studio template to run JupyterLab in order to interactively edit and debug Python recipes, libraries, …

## Create a Code Studio template

  * In “Administration > Code Studios”, click **Create Code Studio template** and create a new template named `jupyter-lab-template`

  * in the “Definition” tab, click on **Add a block** and select `Jupyterlab server`

  * Click **Build**




In the “General” tab, you can then grant access to some (or all) DSS groups, to control which users is allowed to start JupyterLab runtimes. In their projects, the selected users can now create JupyterLab Code Studios.

### Optional JupyterLab extensions

#### Monitor resource usage

Note

This extension works with the base env of JupyterLab. For more details on this extension, see <https://github.com/jupyter-server/jupyter-resource-usage>.

In the definition of the “JupyterLab server” block add `jupyter-resource-usage<1.0.0` as an additional python module. Then rebuild the template.

This extension displays how much resources your current notebooks uses in a sidebar.

#### Search and replace

Note

This extension requires the `ripgrep` package which can be installed by appending `RUN yum -y install ripgrep` to the Dockerfile. For more details on this extension, see <https://github.com/jupyterlab-contrib/search-replace>.

In the definition of the “JupyterLab server” block add `jupyterlab-search-replace` as an additional python module. Then rebuild the template.

This extension let you search across all the content of your synchronized files, notebooks included.

## Launch a Code Studio instance

After having built a JupyterLab template, in a project:

  * ensure the project is associated to a cluster, either by setting a default cluster in “Administration > Settings > Containerized execution” or by setting a cluster for the project in its “Settings > Cluster selection”

  * in the “Code Studios” section, click **New Code Studio** , select the `jupyter-lab-template` template, fill a name and create the Code Studio

  * once in the Code Studio, click **Start**




After the Code Studio has started, you get access to a Jupyterlab server instance. Work done in the Code Studio will usually materialize as modified files in the container. These would disappear when the Code Studio is stopped, so in order to safekeep them, synchronizing them back to the DSS server’s filesystem is needed, with the **Sync files with DSS** button.

## Edit a recipe

In your JupyterLab file explorer, you will see a folder called “recipes” listing all your DSS project recipes, open one recipe, edit it and then click **Sync files with DSS**. Now check that the recipe content has been updated in the DSS flow.

## Edit Project Libraries

In your JupyterLab file explorer, you will see a folder called “project-lib-versioned”. This folder contains all the files from your project Libraries. You can edit existing files/folders and create new ones. Click **Sync files with DSS** to save your changes to Dataiku.

---

## [code-studios/code-studio-ides/rstudio]

# RStudio Server

In this section, we will define a Code Studio template to run RStudio Server to interactively edit and debug R recipes, libraries, …

## Create a Code Studio template

  * In “Administration > Code Studios”, click **Create Code Studio template** and create a new template named `rstudio-template`

  * in the “Definition” tab, click on **Add a block** and select `RStudio`

  * Click **Build**




Then in the “General” tab, you can grant permission to use to given DSS groups (or all) to control which user is allowed to make RStudio runtimes. The selected users can now create new RStudio Code Studios in their projects.

## Launch a Code Studio instance

After having built a RStudio template:

  * ensure the project is associated to a cluster, either by setting a default cluster in “Administration > Settings > Containerized execution” or by setting a cluster for the project in its “Settings > Cluster selection”

  * In the “Code Studios” section, click **New Code Studio** , select the `rstudio-template` template, fill in a name, and create the Code Studio.

  * once in the Code Studio, click **Start**




After the Code Studio has started, you can access a RStudio server instance. Work done in the Code Studio will usually materialize as modified files in the container. These would disappear when the Code Studio is stopped, so in order to safe keep them, synchronizing them back to the DSS server’s filesystem is needed with the **Sync files with DSS** button (see [Editing files with Code Studio](<../code-studio-operations.html#synchronized-files>)).

## Edit a recipe

You will see a folder called “recipes” in your RStudio file explorer, listing all your DSS project recipes, open one recipe, edit it, and then click **Sync files with DSS**. Now check that the recipe content has been updated in the DSS flow.

## Edit Project Libraries

In your RStudio file explorer, you will see a folder called “project-lib-versioned”. This folder contains all the files from your project Libraries. You can edit existing files/folders and create new ones. Click **Sync files with DSS** to save your changes to Dataiku.

---

## [code-studios/code-studio-ides/vs-code]

# Visual Studio Code

In this section, we will define a Code Studio template to run Visual Studio Code to interactively edit and debug Python recipes, libraries, …

## Create a Code Studio template

  * In “Administration > Code Studios”, click **Create Code Studio template** and create a new template named `vscode-template`

  * In the “Definition” tab, click on **Add a block** and select `Visual Studio Code`

  * Click **Build**




Then in the “General” tab, you can grant permission to specific DSS groups (or all) to control which user can make Visual Studio Code runtimes. The selected users can now create new Code Studios in their projects using this template.

## Launch a Code Studio instance

After having built a Code Studio template, in a project:

  * Ensure the project is associated with a cluster, either by setting a default cluster in “Administration > Settings > Containerized execution” or by setting a cluster for the project in its “Settings > Cluster selection.”

  * In the “Code Studios” section, click **New Code Studio** , select the `vscode-template` template, fill in a name and create the Code Studio.

  * Once in the Code Studio, click **Start**.




After the Code Studio has started, you can access a Visual Studio Code server instance. Work done in the Code Studio will usually materialize as modified files in the container. These would disappear when the Code Studio is stopped, so in order to safe keep them, synchronizing them back to the DSS server’s filesystem is needed with the **Sync files with DSS** button (see [Editing files with Code Studio](<../code-studio-operations.html#synchronized-files>)).

## Edit a recipe

In your Visual Studio Code file explorer, you will see a folder called “recipes” listing all your DSS project recipes, open one recipe, edit it and then click **Sync files with DSS**. Now check that the recipe content has been updated in the DSS flow.

## Edit Project Libraries

In your VS Code file explorer, you will see a folder called “project-lib-versioned”. This folder contains all the files from your project Libraries. You can edit existing files/folders and create new ones. Click **Sync files with DSS** to save your changes to Dataiku.

---

## [code-studios/code-studio-operations]

# Operations

## Editing files with Code Studio

The Code Studios run separately from DSS, in the Kubernetes cluster.

Some files are then synchronized between DSS and the Code Studio, in order for recipes / project libraries / … to be available within each Code Studio.

Files are:

  * synchronized from DSS to Code Studio when the Code Studio starts

  * synchronized from Code Studio to DSS when the Code Studio stops

  * synchronized both ways (with conflict detection) when clicking the “Synchronize files” button in the UI of the Code Studio




Each type of file is synchronized to a particular location in the Code Studio, which is overridable in the template settings.

All versioned files are under control of the DSS instance’s _git_ , so it’s recommended to avoid putting large files or binary files in versioned areas. Instead, large files should preferably go into non-versioned (resources) areas

### Project libraries

The usual Project libraries (see [Reusing Python Code](<../python/reusing-code.html>) and [Reusing R Code](<../R/reusing-code.html>)) are available to all Code Studios of the project. Project libraries are versioned in the version control of the project.

Project libraries can be edited outside of a Code Studio through the “Code > Libraries” menu

Project libraries are available at `/home/dataiku/workspace/project-lib-versioned` in the Code Studio by default.

Note

Project libraries can also have non-Python and non-R files, such as stylesheets, small static files, … For large files, use Project resources instead.

### Project resources

Project resources are:
    

  * non-versioned files that are global to a project, and available to all Code Studios of the project.

  * useful for storing artifacts that may be used by several Code Studios in the project, and that should not be versioned (usually because they are large), such as images.

  * available at /home/dataiku/workspace/project-lib-resources in the Code Studio by default.




### Code Recipes

The code of code recipes (Python, R, SQL, Scala) is available to all Code Studios of the project, with one file per recipe.

The code is exactly what you see when editing a given recipe in the DSS UI, for example after opening it from the Flow.

Code Recipes are available at `/home/dataiku/workspace/recipes` in the Code Studio by default.

### Code Notebooks

The source of code recipes (Python, R, SQL, Scala) is available to all Code Studios of the project, with one file per notebook.

The code is exactly what you see when editing a given recipe in the DSS UI, for example after opening it from the notebook menu.

Notebooks are available at `/home/dataiku/workspace/notebooks` in the Code Studio by default.

### Code Agents

The source code for Python code agents is available to Code Studios within the project, enabling synchronization of code agent files. Code agent source code is available at `/home/dataiku/workspace/code_agents` in the Code Studio by default.

Each code agent version has its own folder in the Code Studio. The agent code can be found in the `agent.py` file. The folder also contains:

>   * `agent_test_query.json`: a test query, as defined in DSS
> 
>   * `test_agent.py`: a Python script to test the agent in Code Studio using the above test query
> 
> 


### Code Agent Tools

The source code for Python agent tools is available to Code Studios within the project, enabling synchronization of agent tools files. Agent tool source code is available at `/home/dataiku/workspace/agent_tools` in the Code Studio by default.

Each agent tool is in its own Python file within the `agent_tools` folder.

### Code Webapps

The source code (Python, JavaScript, HTML, CSS) of every DSS Python-based webapp is available to Code Studios within the project, enabling file synchronization for webapps.

Each webapp is located in its own folder within the `/home/dataiku/workspace/webapps` folder (by default).

The Python, JavaScript, CSS, HTML code is exactly what you see when editing a given webapp in the DSS UI. In addition, each webapp folder contains:

>   * `README.md`: a simple README containing dependency information, extendable as needed to facilitate collaboration.
> 
>   * `vscode_launch.py`: a launcher to enable running and debugging the webapp in Code Studio.
> 
> 


### Code Studio versioned files

These files are specific to each Code Studio and are not shared between Code Studios.

These files should be used for Code Studios that define an application (such as a Streamlit Application), for the code of the application itself. For example, the default “Streamlit” block for templates puts the code of the application there.

Code Studio versioned files can be edited in DSS, in “Files > Versioned” in the UI of the Code Studio.

Code Studio versioned files are available at `/home/dataiku/workspace/code_studio-versioned` in the Code Studio by default.

### Code Studio resource files

These files are specific to each Code Studio and are not shared between Code Studios.

These files should be used for Code Studios that define an application (such as a Streamlit Application), for storing artefacts that are needed by the Code Studio and that should not be versioned (usually because they are large), such as images.

Code Studio resource files can be edited in DSS, in “Files > Resources” in the UI of the Code Studio.

Code Studio resource files are available at `/home/dataiku/workspace/code_studio-resources` in the Code Studio by default.

### User config files

These files are shared across all Code Studios of a user and are not shared between users.

They are useful to store user settings.

In the built-in blocks for Visual Studio Code, RStudio Server and JupyterLab, this folder is used to store the IDE configuration.

User config files are available at `/home/dataiku/workspace/user-versioned` in the Code Studio by default

### User resource files

These files are shared across all Code Studios of an user, and are not shared between users. They are not versioned.

They are useful to store user artifacts that should not be versioned, such as plugins, tools, …

User resource files are available at `/home/dataiku/workspace/user-resources` in the Code Studio by default.

---

## [code-studios/code-studio-project-exports-bundles]

# Project exports and bundles

Code Studios are created from template in projects.

When exporting or bundling a project, only Code Studios that are published as webapps are included. For included Code Studios, both versioned and resource files of the Code Studio are exported. But project resources are not exported by default, and need to be manually checked, if some of the published Code Studios use them.

Note

Code studio templates are not included in bundles, and need to be installed separately on the target node, with the same name. As with plugins, the user gets a warning with the list of templates installed on the node from which the bundle originates.

---

## [code-studios/code-studio-requirements]

# Requirements

Note

We recommend using Dataiku Cloud Stacks, which fulfills all Code Studios requirements out of the box.

In order to use Code Studios:

  * [Elastic AI computation](<../containers/index.html>) must be fully setup (which includes having a containerized execution config, having the ability to build images and push them to the registry, and having a cluster defined)

  * Your `kubectl` version should be at least 1.23.

---

## [code-studios/code-studio-templates]

# Preparing Code Studio templates

Code Studio templates are prepared by the DSS administrator, in the Administration section of DSS. Permissions to use the templates can then be granted to groups.

## Building blocks

Templates are built from blocks, each adding some configuration to the Code Studios. The blocks are applied sequentially, so blocks can rely on the modifications defined in previous blocks.

### Standard blocks

#### Visual Studio Code

This block adds the VS Code IDE in the Code Studio. Each code env added by an “Add code environment” block is added to VS Code as a debug configuration and is available from the list of interpreters.

It is not usually needed to change any setting of this block.

#### JupyterLab server

This block adds the JupyterLab IDE in the Code Studio. Each code env added by a “Add code environment” block is added as a kernel in JupyterLab.

It is not usually needed to change any setting of this block.

#### RStudio

This block adds the RStudio Server IDE in the Code Studio.

It is not usually needed to change any setting of this block.

#### Streamlit

This block adds the Streamlit application building framework in the Code Studio and adds an entry point that runs the application. This allows you to both edit and run the application directly from the Code Studio.

By default, Streamlit use its own code env with necessary dependencies, but you can also choose an existing code environment (which must include the streamlit dependency).

The Streamlit application is automatically bootstrapped and can be edited directly from the “Code Studio Versioned Files”, in the streamlit/app.py file.

#### Gradio

This block adds the Gradio application building framework in the Code Studio and adds an entry point that runs the application. This allows you to both edit and run the application directly from the Code Studio.

By default, Gradio use its own code env with necessary dependencies, but you can also choose an existing code environment (which must include the gradio dependency).

The Gradio application is automatically bootstrapped and can be edited directly from the “Code Studio Versioned Files”, in the gradio/app.py file.

#### Voila

This block adds the Voilà framework in the Code Studio and adds an entry point that runs the application. This allows you to both edit and run the application directly from the Code Studio.

By default, Voilà use its own code env with necessary dependencies, but you can also choose an existing code environment (which must include the voila dependency).

You choose from multiple flavors:

  * `voila + DSS - compatible with Jupyterlab` let you used Voilà within JupyterLab.

  * `voila-vuetify + DSS` setup Voilà with the Dataiku Python client and Vuetify.

  * `voila-material + DSS` setup Voilà with the Dataiku Python client and Material.

  * `voila-gridstack + DSS` setup Voilà with the Dataiku Python client and Gridstack.

  * `latest voila version + DSS` setup the latest Voilà version with the Dataiku Python client.

  * `Custom voila version` let you setup a code environment including Voilà by yourself (advanced).




The Voilà application is automatically bootstrapped and can be edited directly from the “Code Studio Versioned Files”, in the voila/app.ipynb file.

#### Add a code environment

This block installs the specified code environment in the designated location in the container.

  * If your template contains JupyterLab, the code environment is also automatically registered as a Kernel.

  * If your template contains VS Code, the code environment is also automatically registered as a run config (debug panel), and as an interpreter (bottom right menu) in VS Code




### Advanced blocks

#### Append to DockerFile

A Code Studio template is primarily defined by the image that its container runs.

This block allows you to add arbitrary Dockerfile statements to the image. Each instance of this block appends to the Dockerfile of the image that is built.

The image starts from the DSS base image.

In the DockerFile section, you can refer to the path of template resources with `__TEMPLATE_RESOURCES__`.

eg: `COPY __TEMPLATE_RESOURCES__/my-file /home/dataiku/workspace/my-file`.

Resources listed in the block are copied to the Docker build context, next to the Dockerfile.

You can use `${dku.install.dir}` and `${dip.home}` to point to the DSS installation directory and data directory respectively. You can also use `${template.resources}` to point to the resources uploaded on this template.

eg: `${template.resources}/my-folder/my-file` → `/home/dataiku/workspace/my-file`.

#### Add an entry point

The actual entry point of the container is defined by DSS to be a technical “runner.py” script that’s part of the base DSS image. To start actual HTTP servers in the container, the template must define at least one entry point that this technical script will launch. Each entry point can also declare a port on which it’s expected to be running an HTTP server. That HTTP server is then made available in the DSS UI. To forward the HTTP communication to the DSS UI:

  * make sure **Expose HTML service** is checked. If left unchecked, the HTTP server is accessible by requesting its URL directly but not shown in the UI. The URL is built as http[s]://studio-host:port/dip/code-studios/<project-key>/<code-studio-id>/<exposed-port>/

  * whether the HTTP server is launched when using this template in a Webapp

  * specify a **label** to use on tabs in the Code Studio’s “View”

  * specify a **proxied subpath** that is given to a `proxy_pass` in an Nginx configuration. What to use depends on the capabilities of the HTTP server in the Code Studio, and in particular whether it’s able to handle a path prefix. A value of `/` works for most cases, but when the server can’t handle a path prefix, you should use `$request_uri` and force the server in the Code Studio to use a fixed prefix. DSS sets a `$DKU_CODE_STUDIO_BROWSER_PATH_<exposed-port>` variable in the Code Studio that the server entry point can use to set its path prefix.




#### Add custom action

While the Code Studio is up, some predefined actions can be triggered inside the container by the user, from the Code Studio’s “Actions” tab. Each action is a command line.

#### Add starter files

When a Code Studio is created from the template, the template writer can add predefined files inside the code-studio-specific file zones and user-specific file zones on the DSS server’s filesystem. This can for example be used to provide an initial working version of code for a webapp. The files are only added upon creating the Code Studio, not when (re)starting it.

You can use `${dku.install.dir}` and `${dip.home}` to point to the DSS installation directory and data directory respectively. You can also use `${template.resources}` to point to the resources uploaded in this template.

eg: `${template.resources}/my-folder/my-file` → `/home/dataiku/workspace/my-file`.

#### NGINX

Note

This block is not available on Dataiku Cloud.

This block basically allows you to have an HTTP access on your “zones” folders. With it you can easily make simple webapps. You can also setup a proxy on a “manually” installed framework for example.

### Special blocks

#### File synchronization

This special block defines which files are synchronized with the Code Studio and where. See [Editing files with Code Studio](<code-studio-operations.html#synchronized-files>) for more details about the different file locations.

Each synchronization definition consists of:

  * a “zone” of the DSS server’s filesystem

  * optionally a sub-folder of that zone

  * a target location in the container.




A synchronization can be made one-way by toggling the arrow; if one-way, then files are copied from the DSS server’s filesystem to the Code Studio, but not the other way around. The block also sports a list of exclusions to define which files on the container are excluded from synchronization. The exclusions follow the syntax used by [gitignore](<https://git-scm.com/docs/gitignore>) (minus the `!` negation)

#### Kubernetes parameters

This special block controls advanced settings.

The container in which the Code Studio actually runs is spawned as a pod in a Kubernetes deployment (single replica). In order to have a proper deployment, a functioning readiness probe is needed, and that is the main purpose of this block. The simplest is to activate TCP probing, and DSS will set the deployment to probe on the first exposed port of the container. (see Readiness probes)

This block also specifies to DSS which URL to use in order to probe the readiness of the HTTP server inside the container. This probing is independent of the one done by Kubernetes to find out whether the deployment rollout is finished. If using the JupyterLab / RStudio / VisualCode blocks, this field is not necessary, because these blocks will automatically adjust the readiness probe URL.

Finally, the block allows for defining additional exposed ports. However, these ports should preferably be defined from the Add an entry point block.

## Advanced template building

### Template resources

You can attach files to this template by uploading them in the “Resources” tab. These files can be used in the Append to DockerFile or Add starter files.

### Environment variables in the pod

The pod running the Code Studio receives some parameters using environment variables:

  * `DKU_CODE_STUDIO_BROWSER_PATH` : the path prefix used by DSS in front of the Code Studio in the UI. Its value is defined by DSS, and is currently `/code-studios/<project_key>/<code_studio_id>` in a code studio.

  * `DKU_CODE_STUDIO_BROWSER_PATH_{port}` : the specific path prefix used for a given exposed port (starts with `DKU_CODE_STUDIO_BROWSER_PATH`). Its value is `/code-studios/<project_key>/<code_studio_id>/<port_number>`

  * `K8S_NODE_NAME`, `K8S_POD_NAME`, `K8S_POD_NAMESPACE`, `K8S_POD_ID` : exposed from Kubernetes via the [downward API](<https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/#the-downward-api>)




These variables are also defined for code studios published as webapps, but:

  * the values of the `DKU_CODE_STUDIO_BROWSER_PATH*` variables is different, and corresponds to the usual backend path prefixes for webapps, like `/web-apps-backends/<project_key>/<web_app_id>...`

  * the variables’ values can contain other variables. A typical case is a webapp that’s exposed using the default port forward exposition, where `DKU_CODE_STUDIO_BROWSER_PATH` is valued `/web-apps-backends/<project_key>/<web_app_id>_${K8S_POD_NAME}` (so you have to perform the replacement of `K8S_POD_NAME` in the pod itself)




### Readiness probes

Code Studios run in pods in the cluster, and these pods are spawned by (Kubernetes) deployments. Deployments are typically started, and “rolled out” by the cluster. In order to do a proper rollout, Kubernetes needs to probe the pods to determine whether they’re ready. If pods cannot be flagged as ready, then rollout fails and ultimately the Code Studio shuts down. This flagging as ready is the work of [readiness probes](<https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/>). Additionally, when the Code Studio is used as a webapp, DSS also probes the Code Studio over HTTP, to decide whether it’s ready to be shown in the UI.

Kubernetes can do readiness probing on Code Studio with 2 mechanisms:

  * TCP probing (= check if some port is used by a server on the pod). Usually more reliable.

  * HTTP probing (= check if some request to the pod gets a response with a non-failure status).




Warning

HTTP probing is rather unreliable when using Code Studio as a WebApp. Prefer TCP probing in that case.

DSS only probes readiness through HTTP requests.

When writing a Code Studio template and not using the default JupyterLab/RStudio/VSCode blocks, it is necessary to fill a working readiness probe URL. It is also advised to check **TCP probing**. If the HTTP server inside the Code Studio needs to work with a path prefix, the readiness probe should include it by using `${baseUrl}`.

---

## [code-studios/code-studio-webapps/gradio]

# Gradio

Gradio is a Python package to build webapps for machine learning models, APIs, or Python functions.

Documentation for Gradio is available at <https://www.gradio.app>

## Create a Code Studio template

  * In “Administration > Code Studios”, click **Create Code Studio template** and create a new template named `gradio-template`

  * In the “Definition” tab, click on **Add a block** and select `Gradio`

  * In the “Definition” tab, click on **Add a block** and select `Visual Studio Code`

  * Click **Build**




Then in the **Permissions** tab, you can manage which user groups can use the template to create their own Code Studio instances in their projects.

## Launch a Code Studio instance

Once the template is built, in a project with a cluster attached:

  * In “Code Studios” click **New Code Studio**

  * Select the `gradio-template` Code Studio template, and create a new Code Studio named `Hello Gradio`

  * Start the Code Studio

  * From the **VS Code** tab, you can edit the webapp. The starter file is located at `code_studio-versioned/gradio/app.py`. Click on **Sync files with DSS** to persist changes upon Code Studio restart.

  * From the **Gradio** tab, visualize and interact with the webapp. Click on the refresh icon to apply changes made in the code editor.




## Publish your Code Studio as a webapp

  * In “Code Studios”, select the `Hello Gradio` Code Studio, and in its action panel, click **Publish** , then **Create**

  * Start the webapp and go to the “View” tab




See [Publish a Code Studio as a webapp](<../code-studios-as-webapps.html>) for more details about how to configure a webapp from a Code Studio.

---

## [code-studios/code-studio-webapps/index]

# Webapps in Code Studios

Note

All the following sections assume that you meet [the prerequisites](<../code-studio-requirements.html>) and, notably, that you have an Elastic AI setup, and a containerized execution configuration

---

## [code-studios/code-studio-webapps/streamlit]

# Streamlit

Streamlit is a Python library to build interactive webapps for machine learning and data science.

Documentation for Streamlit is available at <https://docs.streamlit.io>

## Create a Code Studio template

  * In “Administration > Code Studios”, click **Create Code Studio template** and create a new template named `streamlit-template`

  * In the “Definition” tab, click on **Add a block** and select `Streamlit`

  * In the “Definition” tab, click on **Add a block** and select `Visual Studio Code`

  * Click **Build**




Then in the **Permissions** tab, you can manage which user groups can use the template to create their own Code Studio instances in their projects.

## Launch a Code Studio instance

Once the template is built, in a project with a cluster attached:

  * In “Code Studios” click **New Code Studio**

  * Select the `streamlit-template` Code Studio template, and create a new Code Studio named `Hello Streamlit`

  * Start the Code Studio

  * From the **VS Code** tab, you can edit the webapp. The starter file is located at `code_studio-versioned/streamlit/app.py`. Click on **Sync files with DSS** to persist changes upon Code Studio restart.

  * From the **Streamlit** tab, visualize and interact with the webapp. Edits are applied in real-time.




## Work on your Streamlit app

From the **VS Code** tab you can start a separate instance of the webapp within the Code Studio pod. When the app starts, it outputs its local URL, which you can click on to open the open in a new browser tabs. Using the **Ports** panel you can choose to display it either in a browser tab or in a web view pane within VS Code. You can then start making changes to the webapp source code and watch the application update as you make changes.

Note

Code Studio webapp source code is located in the `code-studio_version` folder, and not in the `webapps` folder, used for regular webapps.

You can also debug the web app by choosing **Debug** instead of **Run**. This lets you set breakpoints and examine application state at desired stages of your webapp’s execution.

## Publish your Code Studio as a webapp

  * In “Code Studios”, select the `Hello Streamlit` Code Studio, and in its action panel, click **Publish** , then **Create**

  * Start the webapp and go to the “View” tab




See [Publish a Code Studio as a webapp](<../code-studios-as-webapps.html>) for more details about how to configure a webapp from a Code Studio.

---

## [code-studios/code-studio-webapps/voila]

# Voila

Voila is Python package to convert a Jupyter Notebook into an interactive dashboard.

Documentation for Voila is available at <https://voila.readthedocs.io>

## Create a Code Studio template

  * In “Administration > Code Studios”, click **Create Code Studio template** and create a new template named `voila-template`

  * In the “Definition” tab, click on **Add a block** and select `Voila`

  * In the “Definition” tab, click on **Add a block** and select `JupyterLab Server`

  * Click **Build**




Then in the **Permissions** tab, you can manage which user groups can use the template to create their own Code Studio instances in their projects.

## Launch a Code Studio instance

Once the template is built, in a project with a cluster attached:

  * In “Code Studios” click **New Code Studio**

  * Select the `voila-template` Code Studio template, and create a new Code Studio named `Hello Voila`

  * Start the Code Studio

  * From the **Jupyter Lab** tab, you can edit the notebook. The starter file is located at `code_studio-versioned/voila/app.ipynb`. Click on **Sync files with DSS** to persist changes upon Code Studio restart.

  * From the **Voila** tab, visualize and interact with the webapp. Click on the refresh icon to apply changes made in the code editor. You will need to add a code env with `pandas` to properly execute the “Basic output of code cells” cell.




## Publish your Code Studio as a webapp

  * In “Code Studios”, select the `Hello Voila` Code Studio, and in its action panel, click **Publish** , then **Create**

  * Start the webapp and go to the “View” tab




See [Publish a Code Studio as a webapp](<../code-studios-as-webapps.html>) for more details about how to configure a webapp from a Code Studio.

---

## [code-studios/code-studios-as-webapps]

# Publish a Code Studio as a webapp

In addition to serving as high-end IDEs for code edition, Code Studios can also be used to run web applications that are not natively managed in DSS, i.e. which are not using the [DSS-webapp-managed frameworks, Flask, Bokeh, Shiny and Dash](<../webapps/index.html>).

## Building a Code Studio template for webapps

In order to be able to run as a Webapp, the Code Studio template should contain an entrypoint that will run the webapp.

Typically, a Code Studio template that’s going to be used for webapps should contain the webapp framework (for example: Streamlit) and an IDE to edit each webapp’s applicative code (for example: Visual Studio Code). This implies that the Code Studio template defines:

  * several additions to the container image, either with existing blocks like the Visual Studio Code block, or with “Append toDockerfile” blocks, in order to install the necessary software onto the image

  * several entrypoints: at least one to start the webapp, and usually one to start the IDE. The entrypoint for the webapp must define an exposed port. The other endpoints may have their “launch for webapps” unchecked, if they’re only needed to edit the webapp’s code




Note

Webapps can have more than 1 pod running a given Code Studio, and can be run with a “port-forward” exposition in DSS (it’s actually the default). In such cases, each pod is served behind a different path prefix by the Nginx server of DSS, with the pod name used in the path prefix. It is thus recommended to use **TCP probing** on the “Kubernetes Parameters” block of the template, so that the deployments in Kubernetes can perform their rollout.

## Creating a webapp from a Code Studio

The first step is to write the code of the webapp, so a Code Studio is instantiated from the template. Once the code is written and works, the webapp is created using the “publish” in the actions panel of the Code Studio. The created webapp is a reference to the Code Studio, and in particular, they share the same set of defining files (the Code Studio versioned and resource files).

Note

After editing a Code Studio webapp, you don’t need to publish it again. The webapp will always point to the latest state of its Code Studio reference after a restart.

Once a webapp runs, it can fetch files from the DSS server’s filesystem like a regular Code Studio does, but cannot write back to the server’s filesystem. It essentially has read-only access to the Code Studio files.

## A complete example

Now that we’ve seen how Code Studio Webapps work, let’s rebuild the Streamlit sample from scratch.

The process up to a running webapp has several stages. We’ll start by adding some script files in a location that templates can use:

  * in “Global Shared code > Static web resources”, create a `start-streamlit.sh` file with the following contents:



    
    
    #! /bin/bash
    
    USER=dataiku
    HOME=/home/dataiku
    
    LC_ALL=en_US.utf8 /opt/dataiku/bin/streamlit run --server.enableXsrfProtection=false --server.enableCORS=false --server.address=0.0.0.0 --server.port=8051 /home/dataiku/workspace/code_studio-versioned/app.py
    

  * in “Global Shared code > Static web resources”, create a `streamlit-starter-app.py` file with the following contents (for the original version, check [the Streamlit tutorial](<https://docs.streamlit.io/library/get-started/>) ) :



    
    
    import streamlit as st
    import pandas as pd
    import numpy as np
    
    st.title('Uber pickups in NYC')
    
    DATE_COLUMN = 'date/time'
    DATA_URL = ('https://s3-us-west-2.amazonaws.com/'
                'streamlit-demo-data/uber-raw-data-sep14.csv.gz')
    
    @st.cache
    def load_data(nrows):
        data = pd.read_csv(DATA_URL, nrows=nrows)
        lowercase = lambda x: str(x).lower()
        data.rename(lowercase, axis='columns', inplace=True)
        data[DATE_COLUMN] = pd.to_datetime(data[DATE_COLUMN])
        return data
    
    data_load_state = st.text('Loading data...')
    data = load_data(10000)
    data_load_state.text("Done! (using st.cache)")
    
    if st.checkbox('Show raw data'):
        st.subheader('Raw data')
        st.write(data)
    
    st.subheader('Number of pickups by hour')
    hist_values = np.histogram(data[DATE_COLUMN].dt.hour, bins=24, range=(0,24))[0]
    st.bar_chart(hist_values)
    
    # Some number in the range 0-23
    hour_to_filter = st.slider('hour', 0, 23, 17)
    filtered_data = data[data[DATE_COLUMN].dt.hour == hour_to_filter]
    
    st.subheader('Map of all pickups at %s:00' % hour_to_filter)
    st.map(filtered_data)
    

Once the resources are ready, we can build a Code Studio template that uses them. We denote by `<k8s-config>` the name of a Kubernetes config in “Administration > Settings > Containerized execution” to use.

  * In “Administration > Code Studios”, click **Create Code Studio template** and create a new `defined by building blocks` template named `streamlit-template`

  * in the “General” tab, for **Run on** select the `<k8s-config>` configuration

  * in the “General” tab, for **Build for** select (at least) the `<k8s-config>` configuration

  * in the “Definition” tab, click on **Add a block** and select `Append to a dockerfile`

  * name the block `install streamlit`, check the **run as root** checkbox, and set the dockerfile addition to



    
    
    ENV LC_ALL en_US.utf8
    RUN /opt/dataiku/bin/python -m pip install markupsafe==2.0.1
    RUN /opt/dataiku/bin/python -m pip install streamlit \
     && ln -s /opt/dataiku/pyenv/bin/streamlit /opt/dataiku/bin/streamlit \
     && yum install -y psmisc
    

  * in the “Definition” tab, click on **Add a block** and select `Add an entrypoint`

  * name the block `run streamlit` and set

>     * set **Entrypoint** to `/home/dataiku/start-streamlit.sh`
> 
>     * add an item to **Scripts** to copy `${dip.home}/local/static/start-streamlit.sh` to `start-streamlit.sh`
> 
>     * toggle **Launch for webapps**
> 
>     * toggle **Expose port**
> 
>     * set **Exposed port label** to `streamlit`
> 
>     * set **Exposed port** to 8051 (see value set in the `/opt/dataiku/bin/streamlit` command above)

  * in the “Definition” tab, click on **Add a block** and select `Visual Studio Code`

  * in the “Definition” tab, click on **Add a block** and select `Add starter files`

  * in the block, add to the **Code Studio versioned files** a copy of `${dip.home}/local/static/streamlit-starter-app.py` to `app.py`

  * click **Save** then **Build**




Once the template is built, in a project with a project attached

  * in “Code Studios” click **New Code Studio**

  * select the `streamlit-template` Code Studio template, and create a new Code Studio named `NYC`

  * [optional] start the “NYC” code studio, edit the `code_studio-versioned/app.py` file, then click **Sync files with DSS**

  * select the “NYC” Code Studio, and in its action panel, click **Publish** , then **Create**

  * in the “Edit” tab of the “NYC” webapp, select `<k8s-config>` for **Container** (if not already selected)

  * in the “Edit” tab of the “NYC” webapp, make sure the **exposition** is set to `Port forwarding`. Usually this is the default at the instance level, but it can be overridden in the webapp’s “Advanced settings”

  * start the webapp and go to the “View” tab

---

## [code-studios/concepts]

# Concepts

## What is a Code Studio

A Code Studio is a personal space for running a web-based IDE, within DSS, and optionally one or several web applications.

Code Studios run in Kubernetes, and require setup of [Elastic AI computation](<../containers/index.html>).

Some of the capabilities made possible by Code Studios include:

  * Editing and debugging Python recipes in Visual Studio Code

  * Debugging Python code in JupyterLab

  * Developing custom web applications using the Streamlit framework

  * Editing and debugging R recipes in RStudio Server




Within each instance of a Code Studio, you have full access to the terminal, can install any package, perform any action, save your IDE preferences, …

Each Code Studio can be started and stopped.

Each Code Studio is a separate container and has its separate filesystem. It cannot access the DSS host filesystem.

Note

In Dataiku Cloud, a space-admin needs to activate the feature « Code-Studio » in the Launchpad (extension tab > add an extension). The feature will be ready to use without needing any additional requirements.

## Code Studio templates

Before you can run a Code Studio, the DSS administrator must set up a _Code Studio template_.

Each template provides a specific development environment and optional additional dependencies.

For example, you could have:

  * one template providing RStudio Server

  * another template containing the Visual Studio Code IDE + the streamlit framework for developing advanced visualizations




Users can then, from these templates, spawn personal instances of the development environments, called Code Studios. To follow our example, these Code Studios can then be used to edit an existing R recipe in DSS, or to develop a streamlit webapp using Visual Studio Code.

The template consists of _blocks_ that define what will be available in the Code Studio.

## Technical details

At its core, a Code Studio is a Kubernetes pod running an HTTP server in a Kubernetes cluster. DSS starts it and shuttles files between the DSS instance and the container inside the pod, then forwards requests on the DSS UI to the HTTP server.

To start and connect to a pod in a Kubernetes cluster, DSS must:

  * prepare container images

  * prepare Kubernetes resource definitions to start a pod in the cluster

  * identify ports on which the pod serves its app




All this is defined within the Code Studio template. Additionally, the template defines which files from the DSS filesystem are shared with the container in the cluster.

Once a Code Studio template has been prepared and is available to some users, they can start creating Code Studios to run the application(s) defined in that template, and access it via DSS. Here, “application” is something served by an HTTP server, and the runtime is hosting the HTTP server. Each Code Studio spawns some Kubernetes resources, typically a deployment, leading to a pod somewhere in the cluster running the application(s). DSS then synchronizes the files from the DSS filesystem to the container in the pod, as defined in the template, and starts the web server in the container.

Once running, the user can connect to all applications (that is, their HTTP servers) running in the container, use them as appropriate to edit files or perform analyses, and finally synchronize back modified files from the container to the DSS filesystem.

---

## [code-studios/index]

# Code Studios

_Code Studios_ allow DSS users to harness the power and versatility of many Web-based IDEs and web application building frameworks.

Some of the capabilities made possible by Code Studios include:

  * Editing library, recipe, notebook, webapp, agent, and agent tool Python code in Visual Studio Code

  * Debugging Python code in JupyterLab or Visual Studio Code

  * Developing custom web applications using Streamlit, Dash, Gradio, and Voila frameworks

  * Editing and debugging R recipes in RStudio Server




Code Studios are personal instances of these development environments.

---

## [code-studios/running]

# Running Code Studios

Code Studios are created from template in projects.

After having built a Code Studio template as described in [Preparing Code Studio templates](<code-studio-templates.html>):

  * ensure the project is associated to a cluster, either by setting a default cluster in “Administration > Settings > Containerized execution” or by setting a cluster for the project in its “Settings > Cluster selection”

  * in the “Code Studios” section, click **New Code Studio** , select a Code Studio template, fill a name and create the Code Studio

  * once in the Code Studio, click **Start**




Work done in the Code Studio will usually materialize as modified files in the container. These would disappear when the Code Studio is stopped, so in order to safekeep them, synchronizing them back to the DSS server’s filesystem is needed, with the **Sync files with DSS** button (see [Editing files with Code Studio](<code-studio-operations.html#synchronized-files>)).