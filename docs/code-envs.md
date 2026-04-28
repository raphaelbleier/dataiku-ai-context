# Dataiku Docs — code-envs

## [code-envs/automation]

# Automation nodes

Like projects, code environments on an automation node come from bundles created on a design node and imported in the automation node. Unlike projects, code environments can also be created directly in the Administration section, and will be found and used when a bundle requiring them is imported.

## Versioning

The code environments existing on an automation node can be versioned. A versioned code environment actually holds several code environments, each with its own independent list of requirements. Only the permissions and installation command overrides are shared.

Each bundle can then link to a specific version of a code environment, and versions of a given code environment are not removed, allowing for rolling back to a previous version of a project without risking to not be able to rebuild the exact same code environment. Once a bundle is preloaded and activated, all items inside the project only see one version of a versioned code environment, the version that matches the bundled requirements.

Note

The kernels in Python and R notebooks can be changed at runtime, and the scoping to the relevant version of a versioned code environment for the project is not enforced.

## Code environments from bundles

Before activating a bundle of a project using non-builtin code environments, a new action is required:

  * go to the Bundles management page

  * select the desired bundle of the project

  * use the “Preload” button in the action bar on the right

  * once preloading is complete, the bundle can be activated




Preloading the bundle scans it for needed code environments, compares to the ones available on the automation node, and if needed and parametrized as such, creates new code environments or code environments versions, or updates existing ones.

### Comparison between bundled and existing

Code environments are identified by their language (Python or R) and by their name. When a code environment exists with the right language and name, the requirements of the bundled code environment are compared to the definition of the existing one, or to the definition of its versions in case it is a versioned code environment. A (version of a) code environment matches if its definition is the same, and “definition” can be :

  * the requirements of the code environment, i.e. the lists of user-required packages (Conda packages if relevant, and Pip or R packages)

  * the actual lists of packages of the code environment




The mode for defining a code environments contents can be selected in the Activation Settings part of the Bundles management page.

### Preloading code environments

The behavior when faced with a missing or outdated code environment in the Preloading phase can be selected in the Activation settings of the Bundles management page :

  * do nothing

  * stop preloading if a code environment used by the project is flat-out missing (i.e. no code environment with the same language and name exists) or not up-to-date (with requirements differing)

  * ensure existence of an appropriate code environment by either creating a new one if no code environment with the same language and name exists, or updating an existing non-versioned code environment, or adding a version to a versioned code environment




Code environments created in the preloading have their type defined by the type of the code environment in the design node they need to correspond to:

  * managed code environments on the design node become versioned code environments on the automation node

  * non-managed code environments on the design node become non-managed code environments on the automation node

  * external Conda code environments on the design node become external Conda code environments on the automation node




## Managing code environments directly

Creating code environments manually can be done in Administration > Code envs, and code environments created this way will be considered by preloading of bundles when their language and name match. Versions of versioned code environments or non-versioned code environment can be imported, their packages lists modified.

Note

Modifying the package list of a code environment and updating it is very likely to prevent it from matching requirements in bundled code environments, meaning these modified code environments will not be used by the bundle preloading.

---

## [code-envs/base-packages]

# Base packages

Two sets of packages can be pre-installed in environments (both Python and R)

  * “Core packages”. These are the absolute minimal requirements for the `dataiku` package to work. If you don’t install these packages (or change their versions), the `dataiku` package cannot work. While it is possible to create virtual environments without core packages, their functionality will be strongly decreased

  * “Jupyter packages”. These packages are required to be able to use the Jupyter notebook with this code environment. If you choose not to install these packages, you will not be able to use the Jupyter notebook with this environment (but you can still use recipes, scenarios, …)

---

## [code-envs/conda]

# Using Conda

In addition to the builtin mechanisms to create and manage code environments (ie, virtualenv for Python and custom mechanism for R), you can choose to use Conda.

Conda is a third-party packages management system which provides both Python and R packages.

Warning

**Tier 2 support** : Conda code envs are covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

conda packages repositories tend to be very bleeding-edge, and move quickly, with frequent backwards-incompatibles changes.

Various incompatibilities may happen, and Dataiku can only provide limited support with setup and usage of conda-based code environments.

For these reasons, Dataiku does not generally recommend using conda for code environments. We recommend that you only use conda if there are reasons for which you cannot use the native virtualenv and R packages systems.

Warning

In most cases, using Conda repositories is **not free** , and you **must** have a paid license.

Before using Conda in Dataiku, ensuring that you have a paid license and that you are compliant with Conda’s licensing terms is **your responsibility**.

## Prerequisites

  * For Custom or Cloud Stacks installations, you need to install miniconda or anaconda. The “conda” binary should be in the PATH of DSS.

  * In Dataiku Cloud, enable the extension “Conda” in the Launchpad to install miniconda.




## Using Conda environments

To use Conda for an environment instead of the builtin mechanisms, check the “Use conda” checkbox when creating the environment.

When managing the packages of a Conda-based environment, you actually need to manage two lists of packages:

  * The list of Conda packages

  * The “regular” list of language packages (either pip requirements or R packages)




This is due to the fact that not all packages are available through Conda. For packages not available through Conda, you need to put them in the “regular” list.

It is strongly recommended not to put the same packages in both lists. Various issues can also happen if a package in a list depends on one in another.

---

## [code-envs/custom-options]

# Custom options and environment

In many cases, it may be needed to customize options passed to the various system commands used in the management of the code environment system (`virtualenv`, `pip`, `R` and `conda`)

One of the main use cases for doing so is if your DSS server does not have outgoing Internet access. In that case, you will not be able to install packages from the main repositories, and will need to pass additional arguments for custom repositories.

Custom options for virtualenv, pip, R and conda can be configured in Administration > Settings > Misc. These settings can only be configured by the DSS administrator.

These options can also be overridden on a per-code-environment basis by unchecking “Inherit global settings” in the “General > Extra options” configuration section for the code environment.

## Examples

The options for pip, virtualenv, R and conda can be found in the relevant documentation.

>   * For pip, the relevant custom options can be found in the [pip install documentation](<https://pip.pypa.io/en/stable/cli/pip_install/>).
> 
>   * For virtualenv, the relevant custom options can be found in the [virtualenv documentation](<https://virtualenv.pypa.io/en/latest/cli_interface.html>)
> 
>   * For conda, you can customize the [conda create](<https://docs.conda.io/projects/conda/en/latest/commands/create.html#>) and [conda install](<https://docs.conda.io/projects/conda/en/latest/commands/install.html>) options.
> 
>   * For R, you can customize the [CRAN mirror URL](<https://cran.r-project.org/mirrors.html>)
> 
> 


You can apply regular pip, virtualenv or conda install flags to a code environment by adding the respective option flags. The syntax for all options is an entry line for the option, followed by a separate entry line for the option value.

### Adding a trusted host for pip installs

Trust the following hosts even without valid HTTPS. This will run the equivalent of `pip install --trusted-host pypi.python.org --trusted-host file.pythonhosted.org [...]`
    
    
    --trusted-host
    pypi.python.org
    --trusted-host
    file.pythonhosted.org
    

### Adding a proxy for pip installs

Apply a proxy to your pip installations. This will run the equivalent of `pip install --proxy [user:passwd@]proxy.server:port [...]`
    
    
    --proxy
    [user:passwd@]proxy.server:port
    

### Point to a custom python package repository for pip installs

Use an alternative python package repository for pip installs (not PyPI). This will run the equivalent of `pip install --index-url http://index.example.com/simple/ [...]`
    
    
    --index-url
    http://index.example.com/simple/
    

### Install from a local directory without scanning remote package indexes

If you are installing packages on a system with limited connectivity, you can set pip not to scan remote package indexes when installing a package, and provide a local path to install from. This will run the equivalent of `pip install --no-index --find-links /full/path/to/package-folder/ [...]`
    
    
    --no-index
    --find-links
    /full/path/to/package-folder/
    

### Add a conda channel for packages install

Adds an additional channel to search for packages. Runs the equivalent of `conda install --channel conda-forge [...]`
    
    
    --channel
    conda-forge

---

## [code-envs/index]

# Code environments

DSS allows you to create an arbitrary number of code environments. A code environment is a standalone and self-contained environment to run Python or R code.

Each code environment has its own set of packages. Environments are independent: you can install different packages or different versions of packages in different environments without interaction between them. In the case of Python environments, each environment may also use its own version of Python. You can for example have one environment running Python 3.8 and one running Python 3.9

In each location where you can run Python or R code, you can select which code environment to use.

---

## [code-envs/non-managed]

# Non-managed code environments

When a completely custom Python or R installation is needed, DSS can let the user maintain code environment directly. In this case, the code environment is “non-managed” from the point of view of DSS. To create such an environment:

  * go to Administration > Code envs

  * create a new Python or R environment

  * select “Non-managed path” as environment type

  * Give an identifier to your code environment. Only use A-Z, a-z, digits and hyphens




Note

Code environment identifiers must be globally unique to the DSS instance, so use a complete and descriptive identifier

A non-managed code environment is basically a folder created by DSS. Its path can be found on the code environment’s General tab, as “Location of the environment”.

## Non-managed Python code environment

DSS requires the presence in the location of the non-managed code environment of the following files:

  * bin/python : a python executable

  * bin/pip : a script to list the packages, that will be called with the arguments “bin/python bin/pip freeze -l”




## Non-managed R code environment

DSS requires the presence in the location of the non-managed code environment of the following files:

  * bin/R : a R executable

---

## [code-envs/operations-python]

# Operations (Python)

Note

  * You need to have specific permissions to create, modify and use code environments. If you do not have these permissions, contact your DSS administrator.

  * See [Requests](<../collaboration/requests.html>) for more details on how users without these permissions can request a new code environment.




## Create a code environment

Note

On Dataiku Cloud, you have to enable custom code environments in the Launchpad’s Code Environments tab before being able to create your own code environment.

  * Go to Administration > Code envs

  * Click on “New Python env”

  * Give an identifier to your code environment. Only use A-Z, a-z, digits and hyphens




Note

Code environment identifiers must be globally unique to the DSS instance, so use a complete and descriptive identifier

  * Choose the Python version that you want to use. DSS is compatible with Python versions 3.9 to 3.14




Note

  * Python 3.14’s initial support doesn’t include package presets nor internal code environments

  * While still possible to create Python 3.6, 3.7 and 3.8 code envs, they are deprecated and not recommended

  * While still technically possible to create Python 2.7 code envs, they are **extremely** deprecated and you should never create a new one
    
    * The requested version of Python must be installed on your system (by your system administrator)

    * In most cases, you also need the Python development headers packages in order to install packages with pip. Depending on the OS, this system package (to be installed by the system administrator) is called “libpython-dev” or “python-devel”




  * Click on “Create”

  * DSS creates the code environment and installs the minimal set of packages




Note

To use Visual Machine Learning, Visual Deep Learning or Time series forecasting, additional packages are required. They can be added in the “Packages to install” tab after code env creation by clicking “Add sets of packages”.

  * You are taken to the new environment page




## Manage packages

You can manage the list of packages to install by clicking on the “Packages to install” tab.

You see here two lists:

  * A non-editable list of the “Base Packages”. These are packages that are required by your current settings. These packages cannot be removed, and you cannot modify their version. For more information, see [Base packages](<base-packages.html>)

  * An editable list of “Requested Packages”. This is where you write the list of packages that you want in your virtual environment. To quickly add the required packages for visual machine learning and deep learning on CPU or GPU, click on “Add Sets of Packages” and make your selections. The required packages will be added to the Requested Packages list.




The list of requested packages is in the `requirements.txt` file format (see [the documentation about the format of requirements.txt](<https://pip.pypa.io/en/latest/reference/requirements-file-format/>)). Each line must be a package name, optionally with constraints information.

For example:

  * `tabulate`

  * `sklearn==1.0.2`

  * `sklearn>1.2`




Once you have written the packages you want, click on **Save and update**. DSS downloads and installs the newly required packages

Afterwards, you can inspect the exact installed versions in the “Actually installed packages” tab.

## Installing packages not available through pip

Some packages aren’t directly available from pip and need to be installed from the source code. To install such a package in a code environment, you should:

  * download the source code of the package on the DSS server

  * in the “Packages to install” section of your code environment, fill the “Requested packages” field with:

    * `/path/to/package/source.zip` for zipped or gzipped packages

    * `-e /path/to/package/source` for unzipped packages where `source` is a directory that contains a `setup.py` file

  * click on “Save and update”.




Warning

  * This operation is not possible for a combined use with containerized execution and model API deployment on Kubernetes.

  * For automation/API nodes, the package must exist at the same path on the server.




## Managed code environment resources directory

The resources directory allows you to download/upload resources to a directory managed by the code environment, and set environment variables that will be loaded at runtime. This makes those resources available to all the recipes, notebooks, etc. that use this code environment.

Note

The typical use case is to download heavy pre-trained deep learning models to the resources directory, by settings the framework’s cache directory environment variable (e.g. `TFHUB_CACHE_DIR` for TensorFlow, `TORCH_HOME` for PyTorch, `HF_HOME` for Hugging Face etc).

Manage the code environment resources directory in the “Resources” tab:

  * Write the **resources initialization script** (code samples for common deep learning frameworks are available). This script is executed when updating the code environment, if the “Run resources init script” option is active.

  * Choose whether the resources initialization script will be executed or not when building this code environment on an API node.

  * View the **environment variables** to load at runtime (set by the initialization script).

  * Explore the resources directory.




Warning

  * Code environment resources require the core packages to be installed.

  * Code environment resources are not supported on external conda code environments.




## Using custom package repositories

On the Design or Automation Nodes, custom repositories can be set via GUI by defining extra “options for ‘pip install’” at Admin > Settings > Misc. under the “Code Envs” section. Each option must be added on a separate line.

For example:

  * `--index-url=http://custom.pip.repo`

  * `--extra-index-url=http://custom.pip.repo/sample`

  * `--trusted-host=custom.pip.repo`




On the API node, custom repositories can be set by editing the `config/server.json` file. The `codeEnvsSettings` field contains `pipInstallExtraOptions` where you can set required options.

For example:
    
    
    "codeEnvsSettings": {
      "preventOverrideFromImportedEnvs": true,
      "condaInstallExtraOptions": [],
      "condaCreateExtraOptions": [],
      "pipInstallExtraOptions": [
          "--index-url", "http://custom.pip.repo",
          "--extra-index-url", "http://custom.pip.repo/sample",
          "--trusted-host", "custom.pip.repo"
      ],
      "virtualenvCreateExtraOptions": [],
      "cranMirrorURL": "https://your.cran.mirror"
    }
    

## Containerized execution

When [running DSS processes in containers](<../containers/index.html>), you can specify which containers should include this code environment.

---

## [code-envs/operations-r]

# Operations (R)

Note

  * You need to have specific permissions to create, modify and use code environments. If you do not have these permissions, contact your DSS administrator.

  * See [Requests](<../collaboration/requests.html>) for more details on how users without these permissions can request a new code environment.




## Create a code environment

  * Go to Administration > Code envs

  * Click on “New R env”

  * Give an identifier to your code environment. Only use A-Z, a-z, digits and hyphens




Note

Code environment identifiers must be globally unique to the DSS instance, so you should use a complete and descriptive identifier.

  * Click on **CREATE**

  * DSS creates the code environment and installs the minimal set of packages

  * You are taken to the new environment page




Given that compiling R packages from source takes time, it is advised to use Conda when available for code environment, and benefit from pre-compiled packages.

## Manage packages

You can manage the list of packages to install by clicking on the “Packages to install” tab.

You see here two lists:

  * A non-editable list of the “base packages”. These are packages that are required by your current settings. These packages cannot be removed, and you cannot modify their version constraints. For more information, see [Base packages](<base-packages.html>)

  * An editable list of “Requested packages”. This is where you write the list of packages that you want in your virtual environment.




The list of requested packages is a table where the first column is the package name, and an optional second column may specify a minimum version number for this package:

  * If the version is not specified, DSS will install this package if not already present.

  * If the version is specified, DSS will (re-)install this package if not already present, or if the currently installed version is lower than the requested minimum version.




Note

In both cases, installing a package will pull the latest version currently available in the configured repository (as determined by the standard `install.packages()` R function). In particular, it is not possible to specify that a given version of a package should be installed, nor that a version older than the latest should be installed.

For example:

  * `"dplyr",` will install the latest version of dplyr if dplyr is not yet installed, and keep any existing version otherwise

  * `"RJSONIO","1.3"` will install the latest version of RJSONIO, if RJSONIO is not yet installed or is installed in a version older than “1.3”




Once you have written the packages you want, click on **Save and update**. DSS downloads and installs the newly required packages

Afterwards, you can inspect the exact installed versions in the “Actually installed packages” tab.

## Using different package repositories

R packages not installed via Conda are pulled from repositories that mirror CRAN, and there is regularly a need to use a particular mirror (most often because of the availability of older versions). When DSS is installed on a machine without outgoing internet access, there is also a need to use a packaged CRAN repository hosting on the internal network.

To work with both these cases, the user can override the default CRAN mirror in Administration > Settings > Misc, and even override it on a per-code environment basis in the Extra Options, by unchecking “Inherit global settings”. This lets the user pass an URL to point to the R packages repository.

---

## [code-envs/permissions]

# Code env permissions

For each code env, on the Permissions panel, you can control who has the rights to manage and use the code environment.

**Owner.** This is the DSS user that owns the code environment and has all access/permissions by default.

**Usable by all.** By default, all DSS users on this instance can see this code environment and choose to use it. If you deselect this checkbox, you will be able to select which groups of users can view this code env in the list of possible code envs.

For each group defined in [Security](<../security/index.html>), you can also grant permissions to update the packages in the code environment, update user access to the code environment, and use (i.e. view in the list) the code environment.

Note

The “use” permissions is advisory only. Not having the “use” permission will remove the code env from the list of possible code envs in the various code env selection dropdowns, but does not actually physically prevent you from using the code envs. This is especially true in the notebook where you can change the code env of a kernel.

The “use” permission is mostly used to keep “clean” lists of blessed environments per group.

The underlying binaries of a code env are structurally always readable and knowledgeable users can always use them.

The update / manage permissions are, on the other hand, fully enforced.

---

## [code-envs/plugins]

# Plugins’ code environments

Since plugins package Python or R code, they sometimes need to impose requirements on the installed packages so that they can run on an instance of DSS.

## Defining requirements of a plugin

Making the plugin package a code environment definition is one of the 2 modes available to plugins writers, and the preferred one. See [Other topics](<../plugins/reference/other.html>)

## Creating code environment instances for plugins

After installing a plugin that contains a code environment definition, the user is prompted to create a code environment for the plugin. To create the code environment for a plugin after the plugin’s installation:

  * go to Administration > Plugins

  * open the plugin or expand its requirements notice in the list

  * use Create or Create a new one to create a new code environment with the definition in the plugin

  * or select among the existing code environments for that plugin

  * Be sure to click the ‘Create’ button in lower left of the plugin home page




## Plugin code environment types

Code environments for plugins are only of 2 types:

  * managed code environments are created by DSS according to the definition in the plugin

  * non-managed code environments are empty code environments where the user has to run the installation commands manually

---

## [code-envs/troubleshooting]

# Troubleshooting

## Where to look for logs

All logs of operations are in the “Logs” tab of the code environment. If the error happens while you are not in a code environment, you may need to look in the backend logs. See [Diagnosing and debugging issues](<../troubleshooting/diagnosing.html>)

## Creation or package installation fails with gcc error

In most cases, this kind of error is due to missing system development headers.

### Python.h not found

If you get this error, you need to install the Python development headers system package which matches the version of Python for this code env.

Note

System packages can only be installed by system administrators. The following instructions require shell access to the machine hosting DSS with **sudo** privileges.

In most cases, the name of the development package for a given version of Python can be obtained by appending “-devel” (for RHEL-like systems) or “-dev” (for Debian-like systems) to the name of the system package which provides Python itself.

The following examples provide the corresponding instructions for the standard versions of Python 3.x which are installed by the DSS installer.

#### RHEL / CentOS / AlmaLinux / Rocky Linux / Oracle Linux
    
    
    # System development tools
    sudo yum groupinstall "Development Tools"
    
    # RHEL/CentOS/Oracle Linux/AlmaLinux 8.x
    sudo yum install python39-devel
    
    # RHEL/CentOS/Oracle Linux/AlmaLinux 9.x
    sudo yum install python3.9-devel
    

#### Debian / Ubuntu
    
    
    # System development tools
    sudo apt-get install build-essential
    
    # Ubuntu 20.04 / Debian 11 (Python 3.9)
    sudo apt-get install python3.9-dev
    
    # Ubuntu 22.04 / Debian 11 (Python 3.10)
    sudo apt-get install python3.10-dev
    

#### SUSE Linux Enterprise Server 15
    
    
    # System development tools
    sudo zypper install -t pattern devel_basis
    
    # Python 3.6
    sudo zypper install python3-devel
    

#### macOS

First, download and install [Xcode](<https://developer.apple.com/xcode/>) and then its Command Line Tools on the terminal.
    
    
    xcode-select --install
    

If you need a specific Python version, you will need to install it. Several options are possible such as [Python.org](<https://www.python.org/downloads/mac-osx/>) or [Pyenv](<https://github.com/pyenv/pyenv#homebrew-on-macos>).

### Other .h file not found

This error generally means that you need to install the development headers system package for the mentioned library. This package can only be installed by your system administrator. The name of the package is generally `libsomething-dev` or `something-devel`

## Creation of code environments fails with : No module named ‘distutils.spawn’

On some Ubuntu systems, the “distutils.spawn” Python module, which is a standard part of Python (though considered “legacy” in Python 3) is packaged independently of Python 3 itself.

This module is required by virtualenv however. If it is not present, creation of virtualenv-based code environments will fail with: `ModuleNotFoundError: No module named 'distutils.spawn'`

You need to install the `python3-distutils` system package:
    
    
    # apt-get install python3-distutils
    

## MXNet does not support numpy 2

MXNet is a library used by GluonTS, which is used by Dataiku for deep time series models.

MXNet doesn’t support numpy 2, so installing it will downgrade numpy to 1.26. You can choose to avoid installing MXNet so that you can install numpy 2. In this case, you still have access to the statistical timeseries models.