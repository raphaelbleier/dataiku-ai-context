# Dataiku Docs — elastic-ai-containers

## [containers/aks/index]

# Using Microsoft Azure Kubernetes Service (AKS)

You can use containerized execution on AKS as a fully managed Kubernetes solution.

For a complete Elastic AI setup in Azure including elastic storage and elastic compute based on Kubernetes, we recommend that you read our [dedicated Azure documentation](<../../cloud/azure/index.html>)

---

## [containers/aks/managed]

# Using managed AKS clusters

## Initial setup

### Create your ACR registry

If you already have an Azure Container Registry (ACR) up and ready, you can skip this section and go to Install the AKS plugin.

Otherwise, follow the Azure documentation on [how to create your ACR registry](<https://docs.microsoft.com/en-us/azure/container-registry/>).

Warning

We recommend that you pay extra attention to the Azure [container registry pricing plan](<https://azure.microsoft.com/en-us/pricing/details/container-registry/>), as it is directly related to the registry storage capacity.

### Install the AKS plugin

To use Microsoft Azure Kubernetes Service (AKS), begin by installing the “AKS clusters” plugin from the Plugins store in Dataiku DSS. For more details, see the [instructions for installing plugins](<../../plugins/installing.html>).

### Prepare your local `az`, `docker`, and `kubectl` commands

Follow the Azure documentation to ensure the following on your local machine (where DSS is installed):

  * The `az` command is properly logged in. This implies running the `az login --service-principal --username client_d --password client_secret --tenant tenant_id` command. More details in [Azure documentation](<https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli>).

  * The `docker` command can successfully push images to the ACR repository. This implies running the `az acr login --name your-registry-name` command.

  * The `kubectl` command is installed.




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Create base images

Build the base image by following [these instructions](<../setup-k8s.html#k8s-base-image>).

### Create a new containerized execution configuration

Go to Administration > Settings > Containerized execution, and add a new execution configuration of type “Kubernetes”.

  * In particular, to set up the image registry, the URL must be of the form `your-registry-name.azurecr.io`.

  * Finish by clicking **Push base images**.




## Cluster configuration

  * The **connection** is where you define how to connect to Azure. This can be done either inline in each cluster (not recommended) or via a preset in the “AKS connection” plugin settings (recommended).

  * By default, the service principal associated to the cluster will be the same as the one used on the DSS machine. You can change this by enabling the **Use distinct credentials** option and defining a specific connection, either inline or via a preset.

  * **Cluster nodes** is where you define the number and type of nodes that you want in your cluster. You can define the properties of a node pool either inline (not recommended) or as a preset in the “Node pools” plugin settings (recommended). You have the possibility to define multiple node pools, each with its own properties.




## Using GPUs

Azure provides GPU-enabled instances with NVIDIA GPUs. Using GPUs for containerized execution requires the following steps.

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda --tag dataiku-container-exec-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../code-envs.html>).

Thereafter, create a new container configuration dedicated to running GPU workloads. If you specified a tag for the base image, report it in the “Base image tag” field.

### Enable GPU support on the cluster

When you create your cluster using the AKS plugin, be sure to select a VM with a GPU. See [Azure documentation for a full list](<https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-gpu>). You’ll also need to enable the “With GPU” option in the node pool settings.

At cluster creation, the plugin will run the NVIDIA driver “DaemonSet” installation procedure, which needs several minutes to complete.

### Add a custom reservation

For your containerized execution task to run on nodes with GPUs, and for AKS to configure the CUDA driver on your containers, the corresponding pods must be created with a custom limit (in Kubernetes parlance). This indicates that you need a specific type of resource (standard resource types are CPU and memory).

You must configure this limit in the containerized execution configuration. To do this:

  * In the “Custom limits” section, add a new entry with key `nvidia.com/gpu` and value `1` (to request 1 GPU).

  * Add the new entry and save your settings.




### Deploy

You can now deploy your GPU-based recipes and models.

## Other

When you create a cluster using the AKS plugin, Microsoft will receive information that this cluster was provisioned from a Dataiku DSS instance. Microsoft is able to correlate the Azure resources that are used to support the software. Microsoft collects this information to provide the best experiences with their products and to operate their business. The data is collected and governed by Microsoft’s privacy policies, which can be found [here](<https://www.microsoft.com/trustcenter/>).

To disable this, set a `DISABLE_AZURE_USAGE_ATTRIBUTION` environment variable to `1` in `DATADIR/bin/env-site.sh`.

---

## [containers/aks/unmanaged]

# Using unmanaged AKS clusters

## Setup

### Create your ACR registry

If you already have an Azure Container Registry (ACR) up and ready, you can skip this section and go to Create your AKS cluster.

Otherwise, follow the Azure documentation on [how to create your ACR registry](<https://docs.microsoft.com/en-us/azure/container-registry/>).

Warning

We recommend that you pay extra attention to the Azure [container registry pricing plan](<https://azure.microsoft.com/en-us/pricing/details/container-registry/>), as it is directly related to the registry storage capacity.

### Create your AKS cluster

To create your Azure Kubernetes Service (AKS) cluster, follow the Azure documentation on [how to create your AKS cluster](<https://docs.microsoft.com/en-us/azure/aks/>). We recommend that you allocate at least 16GB of memory for each cluster node.

Once the cluster is created, you must modify its IAM credentials to [grant it access to ACR](<https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-aks#grant-aks-access-to-acr>) (Kubernetes secret mode is not supported). This is required for the worker nodes to pull images from the registry.

### Prepare your local `az`, `docker`, and `kubectl` commands

Follow the Azure documentation to ensure the following on your local machine (where Dataiku DSS is installed):

  * The `az` command is properly logged in. As of October 2019, this implies running the `az login --service-principal --username client_d --password client_secret --tenant tenant_id` command. You must use a service principal that has sufficient IAM permissions to write to ACR and full control on AKS.

  * The `docker` command can successfully push images to the ACR repository. As of October 2019, this implies running the `az acr login --name your-registry-name` command.

  * The `kubectl` command can interact with the cluster. As of October 2019, this implies running the `az aks get-credentials --resource-group your-rg --name your-cluster-name` command.




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Create base images

Build the base image by following [these instructions](<../setup-k8s.html#k8s-base-image>).

### Create a new containerized execution configuration

Go to Administration > Settings > Containerized execution, and add a new execution configuration of type “Kubernetes”.

  * In particular, to set up the image registry, the URL must be of the form `your-registry-name.azurecr.io`.

  * Finish by clicking **Push base images**.




You’re now ready to run recipes, notebooks and ML models in AKS.

## Using GPUs

Azure provides GPU-enabled instances with NVIDIA GPUs. Several steps are required in order to use them for containerized execution.

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda --tag dataiku-container-exec-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../code-envs.html>).

Thereafter, create a new container configuration dedicated to running GPU workloads. If you specified a tag for the base image, report it in the “Base image tag” field.

### Create configuration and add a custom reservation

Create a new containerized execution configuration dedicated to running GPU workloads. If you specified a tag for the base image, report it in the “Base image tag” field.

In order for your container execution to be located on nodes with GPU accelerators, and for AKS to configure the CUDA driver on your containers, the corresponding AKS pods must be created with a custom “limit” (in Kubernetes parlance) to indicate that you need a specific type of resource (standard resource types are CPU and Memory). Also, NVIDIA drivers should be mounted in the containers.

To do so:

  * in the “Custom limits” section, add a new entry with key: `alpha.kubernetes.io/nvidia-gpu` and value: `1` (to request 1 GPU). Don’t forget to effectively add the new entry.

  * in “HostPath volume configuration”, mount `/usr/local/nvidia` as `/usr/local/nvidia`. Don’t forget to effectively add the new entry, and save the settings.




### Create a cluster with GPUs

Follow Azure documentation for how to create a cluster with GPU accelerators.

### Deploy

You can now deploy your GPU-requiring recipes and models.

---

## [containers/code-envs]

# Using code envs with containerized execution

Container-based execution is compatible with managed code environments for:

  * Python recipes

  * R recipes

  * Custom in-memory machine learning models

  * Deep learning models

  * Python notebooks

  * R notebooks




To make a code environment usable for containerized execution, you must select the containerized execution configuration(s) for which the code environment Docker image must be available. This setting is configured in the “Containerized execution” tab of the code env settings.

Warning

Container-based execution is not compatible with:

  * non-managed code environments, i.e. those that have deployment type “Non-managed path” or “Named external Conda env”

  * custom python interpreter from `PATH`

  * additional `PYTHONPATH` entries.

  * custom packages manually added to DSS’ builtin environment




## Code environment resources directory

[Managed code environment resources directory](<../code-envs/operations-python.html#code-env-resources-directory>) offers 3 modes for containerized execution:

  * **Run resources initialization script** : call the resources initialization script from within the container at image build time.

  * **Copy resources from local code environment** : copy the resources directory from the local code environment into the docker image (using the COPY docker instruction). This option avoids re-downloading the resources.

  * **None** : no resources directory in containerized execution.




## Updating code envs

Update a code env from the code env administration page. This causes corresponding Docker images to be built for the code env (one on top of each base image from the selected container configurations). Each time you use this code env and one of the selected container configurations to run a recipe or model, then the corresponding Docker image will be used.

Warning

After each upgrade of DSS, you must rebuild all base images and then all code env images. You can rebuild code env images by running `./bin/dssadmin build-container-exec-code-env-images --all`.

Likewise, adding a new container execution configuration does not automatically rebuild all code environments that are set to be available for “All container exec configurations”.

---

## [containers/concepts]

# Concepts

## Interaction between DSS and containers

DSS can work with container engines in three ways:

  1. Parts of the processing tasks of the DSS design and automation nodes can run on one or several hosts, powered by Docker or Kubernetes. For more details, see the [Elastic AI computation](<index.html>) section of the documentation.

  2. The DSS API node can run as multiple containers orchestrated by Kubernetes. For more details, see the [API Node & API Deployer: Real-time APIs](<../apinode/index.html>) section.

  3. The entirety of a DSS design or automation node can run as a Docker container. For more details, see [Running DSS as a container (in Docker or Kubernetes)](<../installation/other/container.html>).




Note

In general, running Dataiku DSS as a container (either by running Docker directly, or through Kubernetes) is incompatible with the ability to leverage containers as a processing engine.

Note

The rest of this section is about scaling processing of DSS design and automation nodes by leveraging elastic compute clusters powered by Kubernetes.

## Capabilities and benefits

DSS can run certain kinds of processes in elastic compute clusters powered by Kubernetes. These processes include the following:

  * Python and R recipes and notebooks

  * [Visual recipes](<containerized-dss-engine.html>) using the “DSS” engine

  * Spark-powered code recipes and notebooks

  * Spark-powered visual recipes

  * Plugin-provided recipes that are written in Python or R

  * Initial training of in-memory machine learning models (when using the “in-memory” engine, see [In-memory Python](<../machine-learning/algorithms/in-memory-python.html>))

  * Retraining of in-memory machine learning models

  * Scoring of in-memory machine learning models when NOT using the “Optimized engine” (see [Scoring engines](<../machine-learning/scoring-engines.html>)). The optimized engine can run on Spark.

  * Evaluation of in-memory machine learning models




Running DSS processes in containers provides several key advantages, namely:

  * **Improved scalability** : Use of Kubernetes provide the ability to scale processing of “local” code beyond the single DSS design/automation node machine.

  * **Improved computing capabilities** : Containers provide the ability to leverage processing nodes that may have different computing capabilities. In particular, you can leverage remote machines that provide GPUs, even though the DSS machine itself does not. This is especially useful for [deep learning](<../machine-learning/deep-learning/index.html>).

  * **Ease of resource management** : You can restrict the use of resources, such as CPU and memory usage




Warning

The base image for containers has only the basic python packages for DSS. If you need any additional packages that were manually added to the [built-in python environment](<../python/packages.html>) of DSS, then we recommend that you use a code environment. You could also choose to use a custom base image.

### Limitations

  * In code recipes and notebooks, using libraries from plugins is not supported in containers. For example, `dataiku.use_plugin_libs` and `dataiku.import_from_plugin` will not work.

  * For [deep learning models](<../machine-learning/deep-learning/introduction.html>), if you run a GPU-enabled training in a container, but the DSS server itself does not have a GPU or CUDA installed, Tensorboard visualization will not work, because it runs locally using the same code environment as the training. This should not prevent the training itself, only the Tensorboard visualization.




## Containerized execution configurations

Each kind of activity (such as recipes, machine learning models, …) that you run on containers targets a specific “Containerized execution configuration”.

This does not apply to Spark activities. For these, see below.

Kubernetes execution configurations indicate:

  * The base image to use

  * The “context” for the `kubectl` command. This allows you to target multiple unmanaged Kubernetes clusters or to use multiple sets of Kubernetes credentials.

  * Resource restriction keys (as specified by Kubernetes)

  * The Kubernetes resource namespace for resource quota management

  * The image registry URL

  * Permissions — to restrict which user groups have the right to use a specific Kubernetes execution configuration




Since each execution configuration specifies resource restrictions, you can use multiple ones to provide differentiated container sizes and quotas to users.

## Spark configurations

Each Spark activity references a Spark configuration, and Spark configurations can be configured so as to run on Kubernetes. Each Spark configuration that runs on Kubernetes specifies the base image to use, resource restrictions, Kubernetes resource namespaces and image registry URL.

## Execution configurations vs clusters

If you use the Dataiku ability to manage Kubernetes clusters, in addition to selecting the “execution configuration”, which specifies “how” to execute something, you need to select the “cluster”, which specifies “where” to run it.

Both execution configuration and clusters have global default that can be overridden per project, or even per recipe / notebook / …

Note that you do not need to use per-cluster container runtime configurations, or per-cluster Spark configurations . DSS automatically uses the requested cluster and the limits defined in the container runtime configuration.

## Base images

DSS uses one or multiple container images that must be built prior to running any workload.

In most cases, you’ll only have a single container base image that will be used for all container-based executions. At build time, it is possible to set up whether you want your image to have:

  * R support

  * CUDA support for execution on GPUs




For advanced use cases, you can build multiple base images. This can be used for example:

  * By having one base image with CUDA support, and one without

  * If you require additional base system packages




## Support of code environments

Kubernetes execution capabilities are fully compatible with multiple managed [code environments](<../code-envs/index.html>). You simply need to indicate for which containerized execution configuration(s) your code environment must be made available. For more information, see [Using code envs with containerized execution](<code-envs.html>).

---

## [containers/containerized-dss-engine]

# Containerized DSS engine

While [visual recipes](<../other_recipes/index.html>) are best run on Spark or in SQL databases, some setups don’t have access to compute resources outside the DSS node, some recipe instances have inputs or outputs that don’t let the recipe offload the compute externally, and some recipes just don’t manipulate enough data to warrant the use of Spark. In those cases the recipes will run with the engine named “DSS”, implying that the DSS node will be the one providing the compute resources. This can lead to over-consumption of CPU and memory on the DSS node.

If the DSS node can leverage a Kubernetes cluster, then most of these recipes can be pushed to run inside the Kubernetes cluster instead of on the DSS node, thereby freeing CPU and memory to maintain a reactive DSS UI. The feature is activated in `Administration > Settings > Containerized Execution` , in the `Containerized visual recipes` section.

## Setup

The prerequisites are the same as for containerization of [code recipes](<setup-k8s.html>).

### Build the base image

Before you can deploy to Kubernetes, at least one “base image” must be constructed.

Warning

After each upgrade of DSS, you must rebuild all base images

To build the base image, run the following command from the DSS data directory:
    
    
    ./bin/dssadmin build-base-image --type cde
    

On [cloud stacks](<../installation/index.html>) provisioned instances, this is handled by the setup action `Setup Kubernetes and Spark-on-Kubernetes`

### Instance-specific image

For containerized visual recipes to be able to leverage custom Java libraries, custom JDBC drivers or [plugin components](<../plugins/reference/plugins-components.html>), such as custom datasets or custom processors, a specific image must be built on top of the base image.

For [cloud stacks](<../installation/index.html>) provisioned instance, we recommend to use the following Setup Action:

  * Type: Run ansible Task

  * Stage: After DSS is started

  * Ansible Task:



    
    
    ---
    - name: Build image
      become: true
      become_user: "dataiku"
      command: "{{dataiku.dss.datadir}}/bin/dssadmin build-cde-plugins-image"
    
    - name: Push image
      become: true
      become_user: "dataiku"
      command: "{{dataiku.dss.datadir}}/bin/dsscli container-exec-base-images-push"
    

For on-premise installation, you can perform the same task using the button `Build image for Containerized Visual Recipes` in `Administration > Settings > Containerized Execution`

### Plugins

By default, plugins which DSS deems of interest for visual recipes are added to the image automatically, when plugins are installed or updated. This auto-rebuilding behavior can be turned of in `Administration > Settings > Containerized Execution` in the `Containerized visual recipes` section. You can also choose on a per-plugin basis whether the plugin is included in the base image by going to the plugin’s summary page and using the “Exclude from image” / “Include in image” button.

Note

By default, development plugins are not auto-rebuilt.

### Containerized execution configs

Container configs hold the settings controlling pods’ sizes and namespaces, and what kind of workload they accept in DSS. To use containerized visual recipes, some of them need to have their `Workload type` set to “Any workload type” (the default) or “Visual recipes”. Container configs with a “User code (Python, R, …)” workload type are not accepted by visual recipes.

You can set a container config to use by default for all visual recipes on the instance in `Administration > Settings > Containerized Execution` in the `Default container execution configuration` section. This setting can be overridden in each project and each individual recipe.

## Running a visual recipe in a container

For a given visual recipe, if the engine chosen is “DSS”, then the option to run in a container is controllable from its `Advanced` tab, by picking a `Container configuration` (or leave it to the instance- or project-level default setting). When a container config is set, then the engine label should change to “DSS (containerized)” to indicate that the recipe is expected to be run in a container. If it changes to “DSS (local)”, then it means that the characteristics of the recipe, or of its inputs or outputs, make it unsuitable to containerization. Notable cases where this happens are:

  * a Prepare recipe uses a “Python Function” processor

  * a recipe with input or output on some dataset types: internal datasets (metrics, stats), Hive, SCP, SFTP or Cassandra datasets

  * a recipe with input or output datasets on connections with authentication modes relying on the DSS VM, such as those using kerberos or instance profiles on AWS

  * a recipe with input or output datasets on connections only accessible locally, like SQL connections to a database on localhost




Note

To flag a connection as not-to-be-used-in-containerized-recipes, add a property in its `Advanced connection properties`, with name “cde.compatible” and value “false”

Note

For connection targeting a service running on the same VM as DSS, it is often possible to use the internal IP address instead of “localhost”.

## Tuning

Containerized visual recipes are subject to the limits enforced on the container config they are run with. While containerization allows to pull compute resources from nodes other than the DSS node, these resources are usually not infinite. Memory usage, in particular, can be excessive w.r.t. the pod’s limits, or w.r.t. the node running the pod. Additionally, the containerized visual recipe being run as a Java process, it’s subject to the “Xmx” command line flag, which controls the maximum memory it’s allowed to grab from the container. To control memory usage inside the container, there are 2 options:

  * add a “dku.cde.xmx” property in the `Custom properties` of the container config. The value is a standard “Xmx” value, like “4g” (for 4GB)

  * set a “Memory limit” on the container config and add a “dku.cde.memoryOverheadFactor” property in the `Custom properties` of the container config. The correct value of “Xmx” will then be deduced so that “Xmx + overheadFactor * Xmx” fits withing the memory limit of the container config




Additionally, it is advised to add a “CPU request” on the container config so that the pod immediately has CPU resources at its disposal, because Java processes tend to have a CPU usage spike when they start and load all the classes, for example ensuring half a core right from the beginning.

---

## [containers/custom-base-images]

# Customization of base images

Warning

This requires knowledge of Docker concepts and skills in creating custom Dockerfiles.

When building the base image with
    
    
    ./bin/dssadmin build-base-image --type container-exec
    

a default base image is created with:

  * Python 3.9, also Python 3.10 if DSS uses Python 3.10

  * R 4

  * No CUDA support




This can be customized with options to enable or disable additional language versions, eg `--with-py311 --without-r`.

Run `./bin/dssadmin build-base-image --help` for details.

## Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda --tag dataiku-container-exec-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<code-envs.html>).

### Multiple base images

If you don’t use the `--tag` flag, DSS builds a base image with this naming scheme:
    
    
    dku-exec-base-DSS_INSTALL_ID : dss-DSS_VERSION
    

Where

  * DSS_INSTALL_ID is the identifier of the DSS installation, found in the `install.ini` file.

  * DSS_VERSION is the version of DSS.




If you don’t specify anything in the “base image” field of the DSS containerized execution configuration, this tag will automatically be used.

You can build other base images by appending the `--tag IMAGE_NAME:IMAGE_VERSION` flag to the `./bin/dssadmin build-base-image --type container-exec` command.

### Setting a proxy

You can set the proxy to use to build with `--http-proxy` and `--no-proxy` to set the `http_proxy` and `no_proxy` environment variables.

### Adding system packages

There are cases where you would want to install additional system packages, generally because they are required by your code environments.

For that, add `--system-packages package1,package2,package3`

### Add a Dockerfile fragment

You may want to add custom Dockerfile commands. For that, use `--dockerfile-prepend PATH_TO_FILE` or `--dockerfile-append PATH_TO_FILE`.

The prepended Dockerfile is added just after the FROM. The appended Dockerfile is added at the very end of the Dockerfile.

To add a file to the build context, to make the file available to use in Dockerfile commands added via fragment, use `--copy-to-buildenv absolute/path/file.name file.name`.

### Completely custom Dockerfile

For cases not covered, the generic process would be:

  * Build a base image with the regular DSS mechanisms.

  * Write a custom Dockerfile that starts from the built base image, and add the required package.

  * Build this custom Dockerfile, and output a custom tag.

  * Enter this custom tag in the DSS containerized execution configuration.




Warning

After each upgrade of DSS, you must rebuild all base images, including custom ones.

---

## [containers/dgxsystems/index]

# Using NVIDIA DGX Systems

Warning

**Tier 2 support** : NVIDIA DGX support is experimental and covered by [Tier 2 support](<../../troubleshooting/support-tiers.html>)

You can use containerized execution using DGX Kubernetes cluster as the underlying Kubernetes engine.

Dataiku has been tested for use on DGX Systems and is certified as DGX-Ready Software.

To use DGX Systems you will need to add DGX Kubernetes cluster as an unmanaged cluster in Dataiku.

Additional configuration includes:

  * Building an image with CUDA support to set up a cluster with a CUDA-enabled base image.

  * Adding a custom reservation to request multiple GPUs.




Both cloud and on-premises DGX systems have been successfully tested. Multi-Instance GPU (MIG) support has not been tested

---

## [containers/docker]

# Using Docker instead of Kubernetes

In addition to pushing to Kubernetes, DSS can leverage standalone Docker daemons. This is a very specific setup, and we recommend using Kubernetes preferably.

## Why Kubernetes rather than Docker

### Kubernetes

A Kubernetes setup offers a lot of flexibility by providing the following:

  * A native ability to run on a cluster of machines. Depending on the available resources, Kubernetes automatically places containers on machines.

  * An ability to globally control resource usage.

  * A capability to auto scale (for managed cloud Kubernetes services).




DSS can natively leverage multiple cloud Kubernetes clusters for you, _e.g._ from all large cloud providers.

### Docker

A Docker-only configuration is easier to set up, as any recent operating system comes with full Docker execution capabilities. However, Docker itself is a _mono_ machine, and while DSS can leverage multiple Docker daemons, each workload must explicitly target a single machine.

With Docker, you can manage the resources used by each container, but you cannot globally restrict resources used by the sum of all containers (or all containers of a user).

## Prerequisites (Docker)

Warning

DSS is not responsible for setting up your Docker daemon.

Warning

Dataiku DSS is not compatible with podman, the alternative container engine for Redhat 8 / CentOS 8 / AlmaLinux 8

To run workloads in Docker:

  * You must have an existing Docker daemon. The `docker` command on the DSS machine must be fully functional and usable by the user running DSS. That includes the permission to build images, and thus access to a Docker socket.




For Docker execution, you may or may not need to push images to an image registry. Pushing images to an image registry is required if you plan to run workloads on multiple Docker daemons, or if you plan to build images on a Docker daemon and to run workloads on another Docker daemon.

If you plan to push images to an image registry:

  * The local `docker` command must have permission to push images to your image registry.

  * All other docker daemons need to have permission to pull images from your image registry.

  * The containers must be able to open TCP connections on the DSS host on any port.




## Other prerequisites

  * Your DSS machine must have direct outgoing Internet access in order to install packages.

  * Your containers must have direct outgoing Internet access in order to install packages.




## Build the base image

Before you can deploy to Docker, at least one “base image” must be constructed.

Warning

After each upgrade of DSS, you must rebuild all base images.

From the DSS data directory, run
    
    
    ./bin/dssadmin build-base-image --type container-exec
    

## Running in Docker

You then need to create containerized execution configurations. In Administration > Settings > Containerized execution, click **Add another config** , switch “Container engine” to “Docker” and specify an image repository if needed (in which case you would need to push the base image using the button on top of the screen).

Containerized execution configuration can be used:

  * In the _project settings_. In that case, the configuration will apply by default to all project activities that can run on containers.

  * In the _advanced settings_ of a recipe.

  * In the _Execution environment_ tab of in-memory machine learning design screen.




## Remote daemons

The `docker` command line is the Docker client. The Docker daemon, responsible for building images and running the containers, may be on the same server or may be remote.

### Rationale

Use cases for a remote docker daemon running your containers include:

  * Offloading heavy work onto other servers.

  * Leveraging resources available on another machine (like GPUs).




Furthermore, the Docker daemon runs with high privileges, and on some setups it may be moved to another server rather than kept locally.

### Setup

#### With a registry

You do not need a specific setup if all of the following conditions are met:

  * You are using an image registry.

  * On the DSS server, you have a local Docker daemon that can push to that registry.

  * The remote Docker daemon can pull from that registry.




Then the local Docker daemon can build the images, and the remote daemon can use those images to run the containers.

#### Without a registry

Otherwise, the remote Docker daemon has to build the images.

[](<../_images/remote-daemon-without-registry.svg>)

You still need the local `docker` command (Docker client) to be fully functional and usable by the user running DSS. You then need to specify the Docker daemon host before building the base image:
    
    
    export DOCKER_HOST=host_of_my_remote_daemon
    

If you are using TLS to securely connect to the remote daemon, then you will also need the corresponding environment variables:
    
    
    export DOCKER_TLS_VERIFY=1
    export DOCKER_CERT_PATH=/path/to/docker/cert/directory/
    

`DOCKER_CERT_PATH` is the path to a folder that contains the client certificates: `ca.pem`, `cert.pem`, and `key.pem`. It can be omitted if it is the default `~/.docker/`. For more information about Docker and TLS, refer to the [Docker documentation](<https://docs.docker.com/engine/security/https/>).

You can now build the base image as described in [Initial setup](<setup-k8s.html>).

Thereafter, you need to specify the same settings in the containerized execution configurations:

  * The Docker host

  * If using TLS authentication, check “Enable TLS”, and provide the path to the directory with the certificates.




If necessary, rebuild images for code environments. For details, see [Using code envs with containerized execution](<code-envs.html>).

### Usage

By selecting the corresponding containerized execution configuration, you are now ready to deploy your workload on remote Docker containers.

Note

If you have several remote Docker daemons, you would have to create multiple containerized execution configurations, and to manually dispatch execution among those configurations. DSS does not automatically dispatch among multiple configurations.

## Containerized execution configurations

Each kind of activity (such as recipes, machine learning models, …) that you run on containers targets a specific “Containerized execution configuration”.

Docker execution configurations indicate:

  * The [base image](<concepts.html#base-image-config>) to use

  * The host of the Docker daemon (by default, runs on the local Docker daemon)

  * Resource restriction keys (as specified by Docker)

  * Permissions — to restrict which user groups have the right to use a specific Docker execution configuration

  * Optionally, the image registry URL

  * Optionally, the Docker “runtime” (this is used for advanced use cases like GPUs)




### Multiple execution configurations

Since each execution configuration specifies resource restrictions, you can use multiple ones to provide differentiated container sizes and quotas to users.

---

## [containers/eks/index]

# Using Amazon Elastic Kubernetes Service (EKS)

You can use containerized execution on EKS as a fully managed Kubernetes solution.

For a complete Elastic AI setup in Amazon Web Services including elastic storage and elastic compute based on Kubernetes, we recommend that you read our [dedicated AWS documentation](<../../cloud/aws/index.html>)

---

## [containers/eks/managed]

# Using managed EKS clusters

## Initial Setup

### Install the EKS plugin

To use Amazon Elastic Kubernetes Service (EKS), begin by installing the “EKS clusters” plugin from the Plugins store in Dataiku DSS. For more details, see the [instructions for installing plugins](<../../plugins/installing.html>).

### Prepare your local commands

Follow the [AWS documentation](<https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html>) to ensure the following on your local machine (where DSS is installed):

  * The `aws` command has credentials that give it write access to Amazon Elastic Container Registry (ECR) and full control on EKS.

  * The `aws-iam-authenticator` command is installed. [See documentation](<https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html>).

  * The `kubectl` command is installed. [See documentation](<https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html>).

  * The `docker` command is installed and can build images. [See documentation](<https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-docker.html>).




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Create base images

Build the base image by following [these instructions](<../setup-k8s.html#k8s-base-image>).

### Create a new containerized execution configuration

Go to Administration > Settings > Containerized execution, and add a new execution configuration of type “Kubernetes”.

  * The image registry URL is the one given by `aws ecr describe-repositories`, without the image name. It typically looks like `XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/PREFIX`, where `XXXXXXXXXXXX` is your AWS account ID, `us-east-1` is the AWS region for the repository, and `PREFIX` is an optional prefix to triage your repositories.

  * Set “Image pre-push hook” to **Enable push to ECR**.




## Cluster configuration

### Connection

The connection is where you define how to connect to AWS. Instead of providing a value here, we recommend that you leave it empty, and use the AWS credentials found by the `aws` command in `~/.aws/credentials`.

The connection can be defined either inline in each cluster (not recommended), or as a preset in the plugin’s settings (recommended).

### Network settings

EKS requires two subnets in the same virtual private cloud (VPC). Your AWS administrator needs to provide you with two subnet identifiers. We strongly recommend that these subnets reside in the same VPC as the DSS host. Otherwise, you have to manually set up some peering and routing between VPCs.

Additionally, you must indicate security group ids. These security groups will be associated with the EKS cluster nodes. The networking requirement is that the DSS machine has full inbound connectivity from the EKS cluster nodes. We recommend that you use the `default` security group.

Network settings can be defined either inline in each cluster (not recommended), or as a preset in the plugin’s settings (recommended).

### Cluster nodes

This setting allows you to define the number and type of nodes in the cluster.

### Advanced settings

#### Custom registry for autoscaler images

By default, the plugin uses images from the public `registry.k8s.io` registry for the Kubernetes autoscaler images. If your cluster does not have access to the internet, you can set up a private registry and mirror the images there. You can then specify the URL of your private registry in the advanced settings of the cluster. The image must be identifiable by the following pattern: `${customRegistryURL}/autoscaler/cluster-autoscaler:${autoscalerVersion}` where `customRegistryURL` is the URL of your private registry. The `autoscalerVersion` will depend on your version of Kubernetes:

  * For Kubernetes ≤ 1.24, use `v1.24.3`

  * For Kubernetes == 1.25, use `v1.25.3`

  * For Kubernetes == 1.26, use `v1.26.4`

  * For Kubernetes == 1.27, use `v1.27.3`

  * For Kubernetes ≥ 1.28, use `v1.28.0`




## Using GPUs

AWS provides GPU-enabled instances with NVIDIA GPUs. Using GPUs for containerized execution requires the following steps.

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda --tag dataiku-container-exec-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../code-envs.html>).

Thereafter, create a new container configuration dedicated to running GPU workloads. If you specified a tag for the base image, report it in the “Base image tag” field.

### Enable GPU support on the cluster

When you create your cluster using the EKS plugin, be sure to select a instance type with a GPU. See [EC2 documentation for a full list](<https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/accelerated-computing-instances.html>). You’ll also need to enable the “With GPU” option in the node pool settings.

At cluster creation, the plugin will run the NVIDIA driver “DaemonSet” installation procedure, which needs several minutes to complete.

### Add a custom reservation

For your containerized execution task to run on nodes with GPUs, and for EKS to configure the CUDA driver on your containers, the corresponding pods must be created with a custom limit (in Kubernetes parlance). This indicates that you need a specific type of resource (standard resource types are CPU and memory).

You must configure this limit in the containerized execution configuration. To do this:

  * In the “Custom limits” section, add a new entry with key `nvidia.com/gpu` and value `1` (to request 1 GPU).

  * Add the new entry and save your settings.




### Deploy

You can now deploy your GPU-based recipes and models.

---

## [containers/eks/unmanaged]

# Using unmanaged EKS clusters

## Setup

### Create your EKS cluster

To create your Amazon Elastic Kubernetes Service (EKS) cluster, follow the [AWS user guide](<https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html>). We recommend that you allocate at least 15 GB of memory for each cluster node. More memory may be required if you plan on running very large in-memory recipes.

You’ll be able to configure the memory allocation for each container and per-namespace using multiple containerized execution configurations.

### Prepare your local `aws`, `docker`, and `kubectl` commands

Follow the [AWS documentation](<https://docs.aws.amazon.com/index.html?nc2=h_ql_doc_do_v>) to ensure the following on your local machine (where Dataiku DSS is installed):

  * The `aws ecr` command can list and create docker image repositories and authenticate `docker` for image push.

  * The `kubectl` command can interact with the cluster.

  * The `docker` command can successfully push images to the ECR repository.




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Create base images

Build the base image by following [these instructions](<../setup-k8s.html#k8s-base-image>).

### Create a new execution configuration

Go to Administration > Settings > Containerized execution, and add a new execution configuration of type “Kubernetes”.

  * The image registry URL is the one given by `aws ecr describe-repositories`, without the image name. It typically looks like `XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/PREFIX`, where `XXXXXXXXXXXX` is your AWS account ID, `us-east-1` is the AWS region for the repository and `PREFIX` is an optional prefix to triage your repositories.

  * Set “Image pre-push hook” to **Enable push to ECR**.




You’re now ready to run recipes and models on EKS.

## Using GPUs

AWS provides GPU-enabled instances with NVIDIA GPUs. Using GPUs for containerized execution requires the following steps.

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda --tag dataiku-container-exec-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../code-envs.html>).

Thereafter, create a new container configuration dedicated to running GPU workloads. If you specified a tag for the base image, report it in the “Base image tag” field.

### Enable GPU support on the cluster

To execute containers that leverage GPUs, your worker nodes and the control plane must also support GPUs. The following steps describe a simplified way to enable a worker node leverage its GPUs:

  * [Install the NVIDIA Driver](<https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-nvidia-driver.html>) that goes with the model of GPU on the instance.

  * [Install the Cuda driver](<https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html>). We recommend using the runfile installation method. Note that you do not have to install the cuda toolkit, as the driver alone is sufficient.

  * Install the [NVIDIA docker runtime](<https://github.com/NVidia/nvidia-docker>) and set this runtime as the default docker runtime.




Note

These steps can vary, depending on the underlying hardware and software version requirements for your projects.

Finally, enable the cluster GPU support with the [NVIDIA device plugin](<https://github.com/NVidia/k8s-device-plugin>). Be careful to select the version that matches your Kubernetes version (`v1.10` as of July 2018).

### Add a custom reservation

For your container execution to be located on nodes with GPU accelerators, and for EKS to configure the CUDA driver on your containers, the corresponding EKS pods must be created with a custom “limit” (in Kubernetes parlance). This indicates that you need a specific type of resource (standard resource types are CPU and memory).

You must configure this limit in the containerized execution configuration. To do this:

  * In the “Custom limits” section, add a new entry with key: `nvidia.com/gpu` and value: `1` (to request 1 GPU).

  * Add the new entry and save the settings.




### Deploy

You can now deploy your GPU-required recipes and models.

---

## [containers/gke/index]

# Using Google Kubernetes Engine (GKE)

You can use containerized execution on GKE as a fully managed Kubernetes solution.

For a complete Elastic AI setup in Google Cloud Platform including elastic storage and elastic compute based on Kubernetes, we recommend that you read our [dedicated GCP documentation](<../../cloud/gcp/index.html>)

---

## [containers/gke/managed]

# Using managed GKE clusters

## Initial setup

### Install the GKE plugin

To use Google Kubernetes Engine (GKE), begin by installing the “GKE clusters” plugin from the Plugins store in Dataiku DSS. For more details, see the [instructions for installing plugins](<../../plugins/installing.html>).

### Prepare your local commands

Follow the Google Cloud Platform (GCP) [documentation](<https://cloud.google.com/kubernetes-engine/docs/quickstart>) to ensure the following on your local machine (where DSS is installed):

  * The `gcloud` command is installed. See [install documentation](<https://cloud.google.com/sdk/docs/install>). The `gcloud` command has the appropriate permissions and scopes to:

>     * push to the Google Artifact Registry (GAR) service.
> 
>     * have full control on the GKE service.

  * The `gke-gcloud-auth-plugin` command is installed. See [GCP documentation](<https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke>).

  * The `kubectl` command is installed. See [install documentation](<https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl>).

  * The `docker` command is installed, can build images and push them to GAR. The latter can be enabled by running the `gcloud auth configure-docker` command. See [install documentation](<https://docs.docker.com/engine/install/>).




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Create base images

Build the base image by following [these instructions](<../setup-k8s.html#k8s-base-image>).

### Create a new execution configuration

Go to Administration > Settings > Containerized execution, and add a new execution configuration of type “Kubernetes.”

  * Configure the GAR repository URL to use, e.g. `<region>-docker.pkg.dev/my-gcp-project/my-repository`

  * Finish by clicking **Push base images**.




## Cluster configuration

### Connection

The connection is where you define how to connect to GCP. This can be done either inline in each cluster (not recommended), or as a preset in the “GKE connection” plugin settings (recommended).

### Network settings

The “network” field refers to the Virtual Private Cloud (VPC) where the cluster will be deployed. The “sub-network” field defines the IP space within that VPC where the pod IPs will be allocated. If left blank, those fields will use default network settings, the details of which are explained in the [GCP documentation](<https://cloud.google.com/kubernetes-engine/docs/quickstart>).

### Cluster nodes

This is where you define the number and type of nodes that you want in your cluster. You can define the properties of a node pool either inline (not recommended) or as a preset in the “Node pools” plugin settings (recommended). You have the possibility to define multiple node pools, each with its own properties.

## Using GPUs

GCP provides GPU-enabled instances with NVIDIA GPUs. Using GPUs for containerized execution requires the following steps.

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda --tag dataiku-container-exec-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../code-envs.html>).

Thereafter, create a new container configuration dedicated to running GPU workloads. If you specified a tag for the base image, report it in the “Base image tag” field.

### Enable GPU support on the cluster

When you create your cluster using the GKE plugin, be sure to enable the “With GPU” option in the node pool settings. Follow the [GCP documentation on GPUs](<https://cloud.google.com/compute/docs/gpus/>) to select the GPU type.

At cluster creation, the plugin will run the NVIDIA driver “DaemonSet” installation procedure, which needs several minutes to complete.

### Add a custom reservation

For your containerized execution task to run on nodes with GPUs, and for GKE to configure the CUDA driver on your containers, the corresponding pods must be created with a custom limit (in Kubernetes parlance). This indicates that you need a specific type of resource (standard resource types are CPU and memory).

You must configure this limit in the containerized execution configuration. To do this:

  * In the “Custom limits” section, add a new entry with key `nvidia.com/gpu` and value `1` (to request 1 GPU).

  * Add the new entry and save your settings.




### Deploy

You can now deploy your GPU-based recipes and models.

---

## [containers/gke/unmanaged]

# Using unmanaged GKE clusters

## Setup

### Create your GKE cluster

To create a Google Kubernetes Engine (GKE) cluster, follow the Google Cloud Platform (GCP) documentation on [creating a GKE cluster](<https://cloud.google.com/kubernetes-engine/docs/quickstart>). We recommend that you allocate at least 16GB of memory for each cluster node. More memory may be required if you plan on running very large in-memory recipes.

You’ll be able to configure the memory allocation for each container and per-namespace in Dataiku DSS using multiple containerized execution configurations.

### Prepare your local `gcloud`, `docker`, and `kubectl` commands

Follow the GCP [documentation](<https://cloud.google.com/kubernetes-engine/docs/quickstart>) to ensure the following on your local machine (where DSS is installed):

  * The `gcloud` command has the appropriate permission and scopes to push to the Google Artifact Registry (GAR) service.

  * The `kubectl` command is installed and can interact with the cluster. This can be achieved by running the `gcloud container clusters get-credentials your-gke-cluster-name` command.

  * The `docker` command is installed, can build images and push them to GAR. The latter can be enabled by running the `gcloud auth configure-docker` command.




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Create base images

Build the base image by following [these instructions](<../setup-k8s.html#k8s-base-image>).

### Create the execution configuration

Go to Administration > Settings > Containerized execution, and add a new execution configuration of type “Kubernetes”.

  * Configure the GAR repository URL to use, e.g. `<region>-docker.pkg.dev/my-gcp-project/my-registry`

  * Finish by clicking **Push base images**.




You’re now ready to run recipes and ML models in GKE.

## Using GPUs

GCP provides GPU-enabled instances with NVIDIA GPUs. Using GPUs for containerized execution requires the following steps.

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type container-exec --with-cuda --tag dataiku-container-exec-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../code-envs.html>).

Thereafter, create a new container configuration dedicated to running GPU workloads. If you specified a tag for the base image, report it in the “Base image tag” field.

### Enable GPU support on the cluster

Follow the GCP documentation on [how to create a GKE cluster with GPU accelerators](<https://cloud.google.com/kubernetes-engine/docs/how-to/gpus>). You can also create a GPU-enabled node pool in an existing cluster.

Be sure to run the “DaemonSet” installation procedure, which needs several minutes to complete.

### Add a custom reservation

For your containerized execution task to run on nodes with GPUs, and for GKE to configure the CUDA driver on your containers, the corresponding pods must be created with a custom limit (in Kubernetes parlance). This indicates that you need a specific type of resource (standard resource types are CPU and memory).

You must configure this limit in the containerized execution configuration. To do this:

  * In the “Custom limits” section, add a new entry with key `nvidia.com/gpu` and value `1` (to request 1 GPU).

  * Add the new entry and save your settings.




### Deploy

You can now deploy your GPU-based recipes and models.

---

## [containers/index]

# Elastic AI computation

DSS can scale most of its processing by pushing down computation to Elastic computation clusters powered by Kubernetes

Note

Dataiku Cloud manages the Elastic AI compute for its customers. Hence the setup / configuration described in the following chapters are not applicable for Dataiku Cloud.

---

## [containers/managed-k8s-clusters]

# Managed Kubernetes clusters

DSS can automatically start, stop and manage Kubernetes clusters running on the major cloud providers.

DSS provides managed Kubernetes capabilities on:

  * Amazon Web Services through [EKS](<eks/index.html>)

  * Azure through [AKS](<aks/index.html>)

  * Google Cloud Platform through [GKE](<gke/index.html>)




## Creating a cluster

To create managed clusters, you must first install the DSS plugin corresponding to your cloud provider ([EKS](<eks/index.html>), [AKS](<aks/index.html>), or [GKE](<gke/index.html>)). Then follow these steps:

  * Go to Administration > Clusters

  * You can choose to create a new cluster or attach to an existing cluster

>     * To create a new cluster, click **Create EKS/AKS/GKE Cluster**
> 
>     * To attach to an existing cluster, click **Add Cluster** and for “Type”, select the appropriate “Attach” cluster type

  * Fill in the required parameters

  * Click **Start/Attach**




## Using the cluster

You need to select the cluster to use. There is a global default for the cluster to use in Administration > Settings > Containerized execution.

In addition, each project can override this setting.

Warning

If you forget to select any global default cluster, then by default, activities that try to run on Kubernetes will fail, since they don’t have any cluster to run on.

Note that you do not need to use per-cluster container runtime configurations, or per-cluster Spark configurations. DSS automatically uses the requested cluster and the limits defined in the container runtime configuration.

## Advanced usage for multiple managed clusters

Warning

We recommend that you discuss with your Dataiku Customer Success Manager before using this kind of setup, which have quite a few constraints

It is most often preferable to use autoscaling clusters rather than dynamically creating clusters

### Use a specific or dynamic cluster for scenarios

A common use case for clusters is to run one or multiple scenarios. You can use either:

  * a specific named cluster — one that is already defined in the DSS settings, but that is not the default cluster for the project

  * or a dynamic cluster — one that is created for the scenario and shut down after the end of the scenario (for fully elastic approaches).




#### Use a specific static cluster

In this case, you can use the variables expansion mechanism of DSS.

To denote the contextual cluster to use at the project level, use the syntax `${variable_name}`, instead of the cluster identifier. At runtime, DSS will use the cluster denoted by the `variable_name` variable. Your scenario will then use a scenario-scoped variable to define the cluster to use for the scenario.

For example, if you want to use the cluster `regular1` for the design of the project and all activities not related to the scenario, and use the `fast2` cluster for a scenario, then set up your project as follows:

  * Cluster: `${clusterForScenario}`

  * Default cluster: `regular1`




With this setup, when the `clusterForScenario` variable is not defined (which will be the case outside of the scenario), DSS will fall back to `regular1`.

In your scenario, add an initial step “Define scenario variables”, and use the following JSON definition:
    
    
    {
            "clusterForScenario" : "fast2"
    }
    

The steps of the scenario will execute on the `fast2` cluster.

#### Use a dynamic cluster

In the case of the dynamic cluster, the idea is to create a dynamic cluster, then place the identifier of the dynamically-created cluster into a variable, and then use the variables expansion mechanism described above.

For example, if you want to use the cluster `regular1` for the design of the project and all activities not related to the scenario, and use a dynamically-created cluster for a scenario, then set up your project as follows:

  * Cluster: `${clusterForScenario}`

  * Default cluster: `regular1`




With this setup, when the `clusterForScenario` variable is not defined (which will be the case outside of the scenario), DSS will fall back to `regular1`

In your scenario, add an initial step “Setup cluster”:

  * Select the cluster type that you want to create (depending on the plugin you are using)

  * Fill in the configuration form (depending on the plugin you are using)

  * Set `clusterForScenario` as the “Target variable”




When the step (Setup cluster) runs, DSS creates the cluster and sets the “id” of the newly created cluster in the _clusterForScenario_ variable. Given the project configuration, the steps of the scenario will automatically execute on the dynamically-created cluster.

At the end of the scenario (regardless of whether the scenario succeeded or failed), DSS automatically stops the dynamic cluster. Note that you can override this behavior in the scenario settings.

Warning

If DSS unexpectedly stops while the scenario is running, the cluster resources will keep running on your cloud provider. We recommend that you set up monitoring for cloud resources created by DSS.

### Automate start and stop of clusters

DSS has scenario steps available for starting and stopping clusters. This feature is useful, for instance, to automatically start a cluster in the morning (so that it can be used during the day time), and then automatically shut down the cluster at night, to save on cloud consumption.

### Permissions

Each cluster has an owner and groups that are granted access levels. These access levels are:

  * **Use cluster** : to select the cluster and use it in a project

  * **Operate cluster** : to modify cluster settings

  * **Manage cluster users** : to manage the permissions of the cluster




In addition, each group can be granted global permissions to:

  * Create clusters and manage them

  * Manage all clusters — including clusters for which they have not explicitly been granted access

---

## [containers/namespaces]

# Dynamic namespace management

In Kubernetes, the namespace is the unit for access control and resources control.

DSS can either use a single namespace, multiple static namespaces, or multiple dynamic namespaces. In the latter case, DSS will itself create namespaces dynamically depending on what is requested, which allows for isolation of security and resources.

For example, you may want to:

  * Create one namespace per user, in order to put limits on what the user can do

  * Create one namespace per project

  * Create one namespace per team




DSS leverages variables expansion for this. For example, to have one namespace per user, you can configure DSS to execute in namespace `ns-${dssUserLogin}`. If user `user1` runs something, DSS will expand this and run in namespace `ns-user1`. If this namespace does not exist, DSS can create it on the fly (assuming DSS has been granted sufficient rights)

## Namespace policies

DSS can automatically apply policies to the dynamic namespaces, notably resource quotas (in order to limit the total amount of computation/memory available to a namespace/user/team/project/…) and limit ranges (in order to set default resource control for computations running in the dynamic namespace).

In order to apply a namespace policy, go to Administration > Settings > Containerized execution, and add a namespace policy. Select a pattern (regular expression) for which namespaces it will apply to, and to which clusters it will apply (including saying if it should apply to the default unmanaged cluster).

Policies are applied each time DSS creates a namespace and can be applied manually by clicking the button.

Policy elements must be YAML representations of Kubernetes quota-level objects, such as `ResourceQuota` or `LimitRange`.

For more details, please see <https://kubernetes.io/docs/concepts/policy/>

---

## [containers/openshift/index]

# Using Openshift

Warning

**Tier 2 support** : Openshift support is experimental and covered by [Tier 2 support](<../../troubleshooting/support-tiers.html>)

You can use containerized execution using Openshift 4 as the underlying Kubernetes engine.

Dataiku leverages Kubernetes as a pure base Kubernetes cluster and does not make usage of any Openshift-specific features. Dataiku does not manage Openshift clusters. Only “unmanaged” operation is possible.

---

## [containers/setup-k8s]

# Initial setup

Warning

When using Dataiku Cloud Stacks, all this setup is already handled as part of the Cloud Stacks capabilities. You do not need to go through this setup

## Prerequisites

Note

Many Kubernetes setups will be based on managed Kubernetes clusters handled by your Cloud Provider. DSS provides deep integrations with these, and we recommend that you read our dedicated sections: [Using Amazon Elastic Kubernetes Service (EKS)](<eks/index.html>), [Using Microsoft Azure Kubernetes Service (AKS)](<aks/index.html>) and [Using Google Kubernetes Engine (GKE)](<gke/index.html>)

### Docker and kubectl setup

Warning

Dataiku DSS is not responsible for setting up your local Docker daemon

Warning

Dataiku DSS is not compatible with podman, the alternative container engine for Redhat 8 / CentOS 8 / AlmaLinux 8

The prerequisites for running workloads in Kubernetes are:

  * You must have an existing Docker daemon. The `docker` command on the DSS machine must be fully functional and usable by the user running DSS. This includes the permission to build images, and thus access to a Docker socket.

  * You must have an image registry, that will accessible by your Kubernetes cluster.

  * The local `docker` command must have permission to push images to your image registry.

  * The `kubectl` command must be installed on the DSS machine and be usable by the user running DSS.

  * The containers running on the cluster must be able to open TCP connections on the DSS host on any port.




### Other prerequisites include

  * To install packages, your DSS machine must have direct outgoing Internet access.

  * To install packages, your containers must have direct outgoing Internet access.

  * DSS should be stopped prior to starting this procedure




## (Optional) Setup Spark

  * Download the dataiku-dss-spark-standalone binary from your usual Dataiku DSS download site

  * Download the dataiku-dss-hadoop-standalone-libs-generic-hadoop3 binary from your usual Dataiku DSS download site

  * Setup setup of Hadoop and Spark (note that this is only about client libraries, no Hadoop cluster will be setup)



    
    
    ./bin/dssadmin install-hadoop-integration -standaloneArchive /PATH/TO/dataiku-dss-hadoop3-standalone-libs-generic...tar.gz
    ./bin/dssadmin install-spark-integration -standaloneArchive /PATH/TO/dataiku-dss-spark-standalone....tar.gz -forK8S
    

## Build the base image

Before you can deploy to Kubernetes, at least one “base image” must be constructed.

Warning

After each upgrade of DSS, you must rebuild all base images

To build the base image, run the following command from the DSS data directory:
    
    
    ./bin/dssadmin build-base-image --type container-exec
    

## (Optional) Build the Spark base image

For Spark workloads, then run:
    
    
    ./bin/dssadmin build-base-image --type spark
    

## (Optional) Build the CDE base image

For CDE tasks, then run:
    
    
    ./bin/dssadmin build-base-image --type cde
    

## Setting up containerized execution configs

After building the base image, you need to create containerized execution configurations.

  * In Administration > Settings > Containerized execution, click **Add another config** to create a new configuration.

  * Enter the image registry URL

  * Dataiku recommends to create a namespace per user:

>     * Set `dssns-${dssUserLogin}` as namespace
> 
>     * Enable “auto-create namespace”

  * When deploying on AWS EKS the setting “Image pre-push hook” should be set to “Enable push to ECR”

  * Save




## Setting up Spark configurations

  * Go to Administration > Spark

  * Repeat the following operations for each named Spark configuration that you want to run on Kubernetes

>     * Enable “Managed Spark on K8S”
> 
>     * Enter the image registry URL (See [Elastic AI computation](<index.html>) for more details)
> 
>     * Dataiku recommends to create a namespace per user:
>
>>       * Set `dssns-${dssUserLogin}` as namespace
>> 
>>       * Enable “auto-create namespace”
> 
>     * Set “Authentication mode” to “Create service accounts dynamically”

  * When deploying on AWS EKS the setting “Image pre-push hook” should be set to “Enable push to ECR”

  * Save




## Push Base images

In Administration > Settings > Containerized execution, click on the “Push base images” button

## Use Kubernetes

The configurations for containerized execution can be chosen:

  * As a global default in Administration > Settings > Containerized execution

  * In the project settings — in which case the settings apply by default to all project activities that can run on containers

  * In a recipe’s advanced settings

  * In the “Execution environment” tab of in-memory machine learning Design screen




Each Spark activity which is configured to use one of the K8S-enabled Spark configurations will automatically use Kubernetes.

---

## [containers/troubleshooting]

# Troubleshooting

## Jobs fail to run

### requests.exceptions.ConnectionError

This issue means that the running container is unable to connect to the DSS backend. Some possible reasons for this error include:

  * The container tries to connect to a name that cannot be resolved to an IP address from the container.

  * The network is not routing traffic out of the cluster towards the machine hosting DSS.

  * A firewall is blocking access to the machine hosting DSS. This could be a result of cloud network rules as well as a local firewall.




This list is not exhaustive; however, the most common issue is that the host name cannot be resolved as-is by the container. To fix this, you can add the following variable in `DATADIR/bin/env-site.sh`.
    
    
    export DKU_BACKEND_EXT_HOST="xxx.xxx.xxx.xxx" # DNS name or IP address of DSS backend, reachable from the containers
    

Restart DSS when you are done. You can test if the networking works as expected by clicking the **Test** button available at the top right corner of each configuration in Administration > Settings > Containerized execution.

### Kubernetes job failed, exitCode=1, reason=Error

This message means that the process inside the container exited with an error return code. You will likely find in previous log lines a Python stack trace giving more information about what happened. The most common issue that causes this failure is the `requests.exceptions.ConnectionError` above.

### Spark on Kubernetes

If your see the error above in a Spark on Kubernetes container, you will need to set `spark.driver.host` to the DNS name or IP address of DSS backend. You can do this in the Spark section of DSS general administration settings. Please refer to [Spark configurations](<../spark/configuration.html>) for more information.

---

## [containers/unmanaged-k8s-clusters]

# Unmanaged Kubernetes clusters

## Using a single unmanaged cluster

This is the “default” and simplest behavior.

To use a single unmanaged cluster, you must have an existing Kubernetes cluster that is running version 1.10 or later. Also, the `kubectl` command on the DSS machine node must be fully functional and usable by the user running DSS.

No additional configuration is required. In other words, you only need to do the following:

  * Perform all of the initial setup steps (see [Initial setup](<setup-k8s.html>))

  * Create a container runtime configuration

  * Setup the image repository in the base image

  * Push the base image

  * Use the container runtime configuration




## Using multiple unmanaged clusters

Warning

This is an exotic setup. We recommend discussing with your Dataiku Customer Success Manager

DSS can connect to several existing Kubernetes clusters. If you already have multiple clusters (either managed by a cloud provider, or clusters that you deployed yourself), DSS can leverage all of them, using multiple containerized execution configurations.

DSS leverages the `kubectl` tool for Kubernetes. The _kubectl configuration file_ can define multiple “contexts”. Each kubectl context defines a cluster (API server URL) and credentials to use.

To use multiple clusters (or multiple sets of credentials to a cluster):

  * Create your clusters, running version 1.10 or later — this is not handled by DSS. To have DSS automatically manage Kubernetes clusters for you, see [Managed Kubernetes clusters](<managed-k8s-clusters.html>).

  * Define multiple contexts in your kubectl configuration file.

  * Define multiple container runtime configurations, each one referencing a kubectl context.




Each container runtime configuration can thus reference a different Kubernetes cluster, and you can dispatch between projects this way.