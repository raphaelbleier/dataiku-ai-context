# Dataiku Docs — visual-recipes

## [other_recipes/distinct]

# Distinct: get unique rows

The “distinct” recipe allows you to deduplicate rows in a dataset by retrieving unique rows. The rows are compared using the columns you specify. You can also choose to get the number of duplicates for each combination. It can be performed on any dataset in DSS, whether it’s a SQL dataset or not. The recipe offers visual tools to setup the specifications and aliases.

The “distinct” recipe can have pre-filters and post-filters. The filters documentation is available [here](<sampling.html>).

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Distinct recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/reduce/concept-distinct-recipe.html>)

  * [Tutorial | Distinct recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/reduce/tutorial-distinct-recipe.html>)




## Engines

Depending on the input dataset types, DSS will adjust the engine it uses to execute the recipe, and choose between Hive, Impala, SparkSQL, plain SQL, and internal DSS. The available engines can be seen and selected by clicking on the cog below the “Run” button.

---

## [other_recipes/download]

# Download recipe

The “download” recipe allows you to download files from files-based connections, and store them in a DSS managed folder. The managed folder itself can be stored in any files-based connection that accepts managed folders.

Files-based connections mean the following:

  * Filesystem

  * HDFS

  * S3

  * GCS

  * Azure Blob Storage

  * FTP

  * SFTP

  * SSH

  * HTTP (read-only, cannot write)




The download recipe only deals with files: it does not interpret the files, and does not create a directly usable dataset. It only creates a managed folder. Once you have created the download recipe and its associated output managed folder, you can create a “Files in folder” dataset based on the output managed folder. This “Files in folder” dataset deals with parsing the files in the managed folder, handling format, settings and schema.

## Creating a download recipe

From the Flow, click the “+Recipe” button, and select Visual > Download

Give a name to the output managed folder, and choose in which connection to store it.

Create the recipe. You can now add sources, and then “Run” the recipe to perform the initial download.

## Selecting files from the sources

The download recipe gets files from a number of “sources” and mirrors them to the output folder.

You can use as source of download:

  * A HTTP(s) URL (which can contain authentication)

  * A FTP URL (which can contain authentication)

  * A path within a Filesystem, HDFS, S3, GCS, Azure Blob, FTP, SFTP or SSH connection




The “Path in connection” text input defines the set of files to download from the source. Standard globbing expansion patterns are supported, where a question mark character `?` matches any character in a remote file or directory name, and a star character `*` matches any sequence of characters in a remote file or directory name. To match all files and subfolders in the connection’s startup directory, specify `*` as path.

Patterns can be absolute (with a leading `/` character) or relative, in which case they are interpreted according to the default remote directory for this connection.

Remote file names matching the given pattern are directly downloaded at the top-level of the output folder. Remote directory names matching the given pattern are downloaded as sub-directories of the output folder. along with all their contents.

Only regular files and directory are considered when enumerating sources. In particular, symbolic links are ignored.

Note that in order to avoid name collisions between downloaded files, renaming rules may be applied during the mirroring process:

  * When multiple data sources are defined for a single download recipe, individual file names are prefixed with the data source index and an underscore `_` character.

  * When wildcard expansion patterns appear in source directory specifications, downloaded file or directory names are prefixed with enclosing directory names and an underscore `_` character.




### Mirroring rules

Source files mirroring is performed according to file size and last modification time. If a remote file is created or updated on the remote host, it will be downloaded by the next output folder build operation. If a remote file disappears from the remote host, its local mirror will be deleted by the next output folder build operation.

This synchronization behavior can be customized with the two options:

  * Delete extra files (true by default)

  * Download up-to-date files (false by default)




### Examples

Path in connection | Matched remote files | Downloaded files (single source) | Downloaded files (multi sources) | Notes  
---|---|---|---|---  
`/stats/\*.log` | /stats/20140102.log /stats/20140103.log | 20140102.log 20140103.log | 1_20140102.log 1_20140103.log | Pattern matches files in single directory  
`/stats*/*.log` | /stats.2013/0101.log /stats.2013/0102.log /stats.2014/0101.log | stats.2013_0101.log stats.2013_0102.log stats.2014_0101.log | 1_stats.2013_0101.log 1_stats.2013_0102.log 1_stats.2014_0101.log | Pattern matches files in multiple directories  
`/stats\*` | /stats.2013/0101.log /stats.2013/0102.log /stats.2014/0101.log | stats.2013/0101.log stats.2013/0102.log stats.2014/0101.log | stats.2013/1_0101.log stats.2013/1_0102.log stats.2014/1_0101.log | Pattern matches directories  
  
## Partitioned download recipes

The output folder of a download recipe can be partitioned like any other DSS managed folder. See [Working with partitions](<../partitions/index.html>) for more information about partitioning.

When partitioning is activated for the output folder of a download recipe:

  * Remote files are downloaded from origin servers one partition at a time, for each “build” of each partition of the output folder

  * A set of expansion variables are available to include in the URL and remote path definitions, to choose remote file names from partition values.

  * The source definition screen contains an additional input field “Partition to download for preview” - this value is used when individual data sources are checked through the “Check source” buttons.




The variable expansion patterns that can be used in URLs and remote paths to define the set of files to download for a given dataset partition can be found at [Partitioning variables substitutions](<../partitions/variables.html>).

### Example

The following defines a download recipe from a directory of web server log files accessible through a FTP server (similar instructions apply for any downloaded data):

  * Create a download recipe. At that point, the output folder is not partitioned.

  * Go to the output folder, then in Settings > Partitioning

  * Add a time dimension named “date”, period “DAY”, pattern `%Y/%M/%D/.*`. This defines the naming pattern for **downloaded files** (ie, in the managed folder storage).

  * Save and go back to the download recipe definition

  * Add a source to download from, and enter `ftp://MYWEBSERVER/var/log/apache2/$DKU_DST_YEAR/$DKU_DST_MONTH/$DKU_DST_DAY/*.log`. This defines the naming pattern for **remote source** files.

  * If you want to check that the details are correct, you need to provide a partition identifier. DSS will replace the `DKU_DST_` variables by the ones from the partition identifier




Given the above definitions, whenever you try to build partition “2017-02-05”, the download recipe will mirror all files named `\*.log` in subdirectory `/var/log/apache2/2017/02/05` of the FTP server, and store them in subdirectory `2017/02/05` of the managed folder

---

## [other_recipes/dynamic-repeat]

# Dynamic recipe repeat

Any export or download recipe can be configured to be repeating. Such a recipe takes a secondary “parameters” dataset as a setting and “runs” as many times as there are rows in the parameters dataset. Each time a repeating recipe runs, variables are expanded in certain fields of the recipe settings based on the current row of the parameters dataset.

## Export recipe

Variables can be used in the **Filter** and the **File name** sections of the recipe settings.

### Example use case

There is a dataset containing movies with their corresponding distributors and the revenues they generated. In order to create dedicated report files per distributor, each containing only the movies for the given distributor, you can build a Flow like this:

  * Have a dataset

  * Create a distinct recipe in order to get unique values which can then be used for variable expansion to generate and filter the report

  * Create an export recipe, enable the repeating feature picking the output dataset of the distinct recipe as the repeating parameters dataset

  * The filtering formula could be something like this:
        
        val('distributor') == '${distributor}'
        

  * The output file name should also contain the variable to avoid overwriting the same file over and over




## Download recipe

Variables are expanded in the value used for the **URL** setting of the recipe.

### Example use case

In order to download multiple files based on a dataset containing their partial URLs, you can build a Flow like this:

  * Create an editable dataset containing, for instance, DSS version numbers

  * Create a download recipe, enable the repeating feature picking the editable dataset as the repeating parameters dataset

  * The URL format could be something like this:
        
        https://cdn.downloads.dataiku.com/public/dss/${version}/dataiku-dss-${version}.tar.gz
        




## Configuring

To enable a repeating recipe:

  * Go to the Advanced tab of the recipe editor

  * Within the **Dynamic recipe repeat** section, make sure **Enable** is checked and a dataset is selected in the **Parameters dataset** dropdown




Once enabled, you’ll notice a repeat icon on the recipe in the Flow.

By default a variable is created for each column of the parameters dataset however it is also possible to create a mapping of column names to variable names. Only the variables specified by the mapping will then be created. This is useful to avoid variable shadowing.

---

## [other_recipes/extract-document-content]

# Extracting document content  
  
Dataiku can natively process unstructured documents using the “Extract content” recipe. This recipe takes a managed folder of documents as input and lets you choose between two recipe types:

  * **Extract full document** , which extracts the content of each document into a dataset at different granularities, such as one row per page, detected section, or document.

  * **Extract fields** , which extracts specific structured fields from documents into a dataset.




To get started with document extraction:

  * see our [How to: Extract fulltext content](<https://knowledge.dataiku.com/latest/prepare-transform-data/process-unstructured-data/how-to-extract-fulltext-content.html>) for the **Extract full document** recipe

  * see our [How to: Extract fields from documents](<https://knowledge.dataiku.com/latest/prepare-transform-data/process-unstructured-data/how-to-extract-fields-from-documents.html>) for the **Extract fields** recipe




Note

The “Embed documents” recipe allows to extract documents in a similar way into a vector store instead of a dataset (see [Embedding and searching documents](<../generative-ai/knowledge/documents.html>)):

## Recipe types

The “Extract content” recipe includes two recipe types.

### Extract full document

Use **Extract full document** to extract the content of documents into a dataset. Depending on the extraction method and output settings, the output can contain one row per page, detected section, or document.

### Extract fields

Use **Extract fields** to extract specific values from documents into a structured dataset. This is useful for use cases such as extracting invoice numbers, supplier names, dates, totals, or repeated line items from business documents.

## Supported document types

The “Extract content” meta-recipe includes two recipe types with the following supported file types:

Recipe type | Supported file types  
---|---  
**Extract full document** | PDF, PPTX/PPT, DOCX/DOC, ODT/ODP, TXT, MD (Markdown), PNG, JPG/JPEG, HTML  
**Extract fields** | PDF, PPTX/PPT, DOCX/DOC, ODT/ODP, PNG, JPG/JPEG  
  
## Extract full document

The **Extract full document** recipe supports two ways of handling documents.

### Text extraction

Text extraction extracts text from documents and organizes it into meaningful units. It supports PDF, DOCX, PPTX, HTML, TXT, and MD. Image formats (PNG, JPEG, JPG) are supported if Optical Characters Recognition (OCR) is enabled.

Two engines are available for text extraction and can be configured using custom rules.

#### Raw text extraction

This engine focuses on the physical layout of the document. It extracts text in a single row per document while keeping the page or slide division of the document in the structured content column whenever possible, for example for PPTX and PDF files.

If OCR is enabled, PDF files are first converted into images. The engine then extracts text from those images (useful for scanned documents).

Because this engine does not try to infer the semantic structure of the document, it is very fast.

#### Structured text extraction

Structured text extraction runs as follows:

  * The text content is extracted from the document.

  * If headers are available, they are used to divide the content into meaningful units.

  * The extracted text is aggregated into one row per section or per document while keeping the structure of detected sections in a structured column.




Text can also be extracted from images detected in the documents:

  * with the ‘Optical Character Recognition’ (OCR) image handling mode. You can choose either EasyOCR or Tesseract as OCR engines. EasyOCR does not require any configuration but is slow when running on CPU. Tesseract requires some configuration, see OCR setup. Enabling OCR is recommended on scanned documents.

  * with the ‘VLM description’ image handling mode. A visual LLM is used to generate descriptions for each image in the document. This is available for PDF, DOCX, and PPTX files.




By default, this engine uses a lightweight classification model to identify and filter out non-informative images, such as barcodes, signatures, icons, logos, or QR codes, from text processing. While these images are skipped during extraction, all images are still saved to the output folder if `Store images` is enabled in **Output > Storage settings**. To process all images regardless of content, disable `Skip non-informative images` in the recipe advanced settings.

Note

Structured text extraction requires internet access for PDF document extraction. The models that need to be downloaded are layout models available from Hugging Face. The runtime environment will need to have access to the internet at least initially so that those models can be downloaded and placed in the huggingface cache.

If your instance does not have internet access then you can download those models manually. Here are the steps to follow:

14.3.0 and later
    

  * Go to the [model repository](<https://huggingface.co/ds4sd/docling-models/tree/v2.3.0>) and clone the repository (on the v2.3.0 revision)

  * Create a “ds4sd--docling-models” repository in the resources folder of the document extraction code environment (or the code env you chose for the recipe), under: /code_env_resources_folder/document_extraction_models/ds4sd--docling-models

>     * The folder “ds4sd--docling-models”, should contain the same files as <https://huggingface.co/ds4sd/docling-models/tree/v2.3.0/>

  * Create a “ds4sd--docling-layout-egret-medium” repository in the resources folder of the document extraction code environment (or the code env you chose for the recipe), under: /code_env_resources_folder/document_extraction_models/ds4sd--docling-layout-egret-medium

>     * The folder “ds4sd--docling-layout-egret-medium”, should contain the same files as <https://huggingface.co/docling-project/docling-layout-egret-medium/tree/main/>

  * (Optional) You can also choose to download “docling-layout-heron” model in addition to / instead of “docling-layout-egret-medium” if you need more accuracy in layout detection and sacrifice speed.

>     * Create a “ds4sd--docling-layout-heron” repository in the resources folder of the document extraction code environment (or the code env you chose for the recipe), under: /code_env_resources_folder/document_extraction_models/ds4sd--docling-layout-heron
> 
>     * The folder “ds4sd--docling-layout-heron”, should contain the same files as <https://huggingface.co/docling-project/docling-layout-heron/tree/main/>



Prior to 14.3.0
    

  * Go to the [model repository](<https://huggingface.co/ds4sd/docling-models/tree/v2.2.0>) and clone the repository (on the v2.2.0 revision)

  * Create a “ds4sd--docling-models” repository in the resources folder of the document extraction code environment (or the code env you chose for the recipe), under: /code_env_resources_folder/document_extraction_models/ds4sd--docling-models

>     * The folder “ds4sd--docling-models”, should contain the same tree structure as <https://huggingface.co/ds4sd/docling-models/tree/v2.2.0/>




If the models are not in this resources folder, then the huggingface cache will be checked and if the cache is empty, the models will be downloaded and placed in the huggingface cache.

Note

You can edit the run configuration of the text extraction engine in the **Administration** > **Settings** > **Other** > **LLM Mesh** > **Configuration** > **Document extraction recipes**.

### VLM extraction

For complex documents, Dataiku implements another strategy based on Vision Language Models (VLM), i.e. LLMs that can take images as input. If your LLM Mesh is connected to one of these (see [Multimodal capabilities](<../generative-ai/multimodal.html>) for a list), you can use the VLM strategy.

  * Instead of extracting the text, the recipe transforms each page of the document into images.

  * Ranges of images are sent to the VLM to extract the document content, including descriptions of visual elements such as graphics and tables.

  * The extracted content is then saved as dataset rows or aggregated to one row per document.

  * The images themselves can be stored in a managed folder and their paths will be referenced in the corresponding dataset rows.




The advanced image understanding capabilities of the VLM allow for more relevant results than relying only on extracted text.

The **Extract full document** recipe supports the VLM strategy for DOCX/DOC, PPTX/PPT, PDF, ODT/ODP, JPG/JPEG, and PNG files.

## Extract fields

The **Extract fields** recipe extracts specific structured values from documents into a dataset.

This recipe is useful when you want to define a target schema and automatically extract fields such as identifiers, dates, amounts, names, or repeated items from a set of documents.

The **Extract fields** recipe relies on a Vision Language Model (VLM) available through the LLM Mesh and supporting structured output.

### Recipe configuration

To configure the recipe, first select the VLM used for extraction.

Optionally, you can customize the general instructions to provide additional context to the model before defining the extraction schema.

Note

**Extract fields** requires a VLM connection in the LLM Mesh that supports structured output.

### Extraction schema

To define the extraction schema, select a sample document in the preview and define the fields to extract.

For each field, you can configure:

  * a field name

  * a description

  * a data type




Supported data types are:

  * string

  * integer

  * number

  * date

  * boolean

  * array




Use array fields when you want to extract repeated items, such as invoice line items. Array fields can contain subfields for each repeated item.

For example, an `invoice_items` array can contain subfields such as:

  * description

  * quantity

  * unit price




You can add, rename, remove, or modify fields and subfields after creating the recipe.

Warning

Changing the extraction schema changes the structure of the output dataset. After modifying the schema, re-run the recipe to regenerate the output dataset.

### Test extraction on a document

To evaluate the extraction results, you can run the extraction on the document currently selected in the preview.

If the extraction quality is not satisfactory, try one of the following:

  * refine the field descriptions to make them clearer and more specific

  * customize the general instructions to describe the document type, language, or extraction rules more precisely

  * use a different VLM available in the LLM Mesh




### Output settings

You can choose an update method to control how the output dataset is updated. For more details, see Output update methods.

You can also configure how values are handled when they do not match the expected data type defined in the extraction schema.

If your schema contains arrays with subfields, you can choose how arrays are written to the output dataset:

  * With array expansion disabled, the output contains one column per field and a single row for each document. Array values are stored in a nested structure.

  * With array expansion enabled, the output contains one column per subfield and one row per extracted item.




## Initial document extraction setup

  * Document Extraction is automatically preinstalled when using Dataiku Cloud Stacks or Dataiku Cloud. If you are using Dataiku Custom, before using the VLM extraction, you need a server administrator with elevated (sudoers) privileges to run:



    
    
    sudo -i "/home/dataiku/dataiku-dss-VERSION/scripts/install/install-deps.sh" -with-libreoffice
    

  * Text extraction on “Embed documents” and “Extract full document” recipes on DOCX/PDF/PPTX (with both engines) requires to install and enable a dedicated code environment (see [Code environments](<../code-envs/index.html>)):

In **Administration** > **Code envs** > **Internal envs setup** , in the Document extraction code environment section, select a Python version from the list and click Create code environment.



  * **Extract fields** requires access to a VLM in the LLM Mesh that supports structured output.




## OCR setup

When using the OCR mode of the text extraction, you can choose between EasyOCR and Tesseract. The AUTO mode will first use Tesseract if installed, else will use EasyOCR.

### Tesseract

Tesseract is preinstalled on Dataiku Cloud and Dataiku Cloud Stacks. If you are using Dataiku Custom, Tesseract needs to be installed on the system. Dataiku uses the tesserocr python package as a wrapper around the tesseract-ocr API. It requires libtesseract (>=3.04 and libleptonica (>=1.71).

The English language and the OSD files must be installed. Additional languages can be downloaded and added to the tessdata repository. Here is the [list](<https://tesseract-ocr.github.io/tessdoc/Data-Files-in-different-versions.html>) of supported languages.

For example on Ubuntu/Debian:
    
    
    sudo apt-get install tesseract-ocr tesseract-ocr-eng libtesseract-dev libleptonica-dev pkg-config
    

On AlmaLinux:
    
    
    sudo dnf install tesseract
    curl -L -o /usr/share/tesseract/tessdata/osd.traineddata https://github.com/tesseract-ocr/tessdata/raw/4.1.0/osd.traineddata
    chmod 0644 /usr/share/tesseract/tessdata/osd.traineddata
    

At runtime, Tesseract relies on the TESSDATA_PREFIX environment variable to locate the tessdata folder. This folder should contain the language files and config. You can either:

  * Set the TESSDATA_PREFIX environment variable (must end with a slash /). It should point to the tessdata folder of the instance.

  * Leave it unset. During the Document Extraction internal code env resources initialization, DSS will look for possible locations of the folder, copy it to the resources folder of the code env, then set the TESSDATA_PREFIX accordingly.




Note

If run in a container execution configuration, DSS handles the installation of Tesseract during the build of the image.

### EasyOCR

EasyOCR does not require any additional configuration. But it’s very slow if run on CPU. We recommend using an execution environment with GPU.

Note

By default EasyOCR will try to download missing language files. Any of the [supported languages](<https://tesseract-ocr.github.io/tessdoc/Data-Files-in-different-versions.html>) can be added in the UI of the recipe. If your instance does not have access to the internet, then all requested language models need to be directly accessible. DSS expects to find the language files in the resources folder of the code environment: /code_env_resources_folder/document_extraction_models/EasyOCR/model. You can retrieve the language files (*.pth) from [here](<https://www.jaided.ai/easyocr/modelhub/>)

## Output update methods

There are four different methods that you can choose for updating your recipe’s output and its associated folder (used for assets storage).

You can select the update method in the recipe output step.

Method | Description  
---|---  
**Smart sync** | Synchronizes the recipe’s output to match the input folder documents, smartly deciding which documents to add/update or remove.  
**Upsert** | Adds and updates the documents from the input folder into the recipe’s output. Smartly avoids adding duplicate documents. Does not delete any existing document that is no-longer present in the input folder.  
**Overwrite** | Deletes the existing output, and recreates it from scratch, using the input folder documents.  
**Append** | Adds the documents from the input folder into the recipe’s output, without deleting or updating any existing records. Can result in duplicates.  
  
Documents are identified by their path in the input folder. Renaming or moving around documents will prevent smart modes from matching them with any pre-existing documents and can result in outdated or duplicated versions of documents in the output of the recipe.

The update method also manages the output _folder_ of the recipe to ensure its content synchronisation with the recipe’s output. Non-managed deletions in the output folder is not recommended and can cause the recipe’s output to point to a missing source.

Tip

If your folder changes frequently, and you need to frequently re-run your recipe, choosing one of the smart update methods, **Smart sync** or **Upsert** , will be much more efficient than **Overwrite** or **Append**.

The smart update methods minimize the number of documents to be re-extracted, thus lowering the cost of running the recipe repeatedly.

Warning

When using one of the smart update methods, **Smart sync** or **Upsert** , all write operations on the recipe output must be performed through DSS. This also means that you cannot provide an output node that already contains data, when using one of the smart update methods.

## Limitations

  * Output dataset partitioning is not supported.

  * The **Extract fields** recipe relies on a VLM to process documents. The processing limit depends on the number of document pages sent as images to the VLM. If it exceeds the model limit, a warning is raised, the document is skipped, and other documents continue to be processed.

  * Some DSS SQL connectors, notably Teradata, only support a limited number of characters in each column of data. The output of the **Extract full document** recipe is likely to exceed those limits, resulting in an error message similar to: `Data too long for column 'extracted_content' at row 1` or `can bind a LONG value only for insert into a LONG column`.

To work around this limitation, you can manually redefine the structure of the output dataset.

Warning

This will delete all previously extracted data.

    * Go to the recipe’s output dataset **Settings > Advanced** tab.

    * Change `Table creation mode` to `Manually define`

    * Modify `Table creation SQL` to allow for a longer content in columns `section_outline`, `extracted_content` and `structured_content`. For example, you can increase the number of characters limit or switch to a different type (e.g `LONGTEXT` or `NCLOB`).

    * `SAVE`, then click on `DROP TABLE` and `CREATE TABLE NOW` to confirm the new structure is in place.

    * Re-run the recipe to take into account the new limits.

---

## [other_recipes/extract-failed-rows]

# Extract failed rows

The “extract failed rows” recipe allows users to create a new dataset containing the records that failed the Data Quality rules defined on the input dataset.

The output dataset will include all columns from the original dataset and new columns that have been appended for each Data Quality rule.

See also

> For more information about Data Quality, see also the following article in the Knowledge Base:

  * [Concept | Data Quality rules](<https://knowledge.dataiku.com/latest/data-quality/concept-data-quality.html>)

  * [Tutorial | Data Quality](<https://knowledge.dataiku.com/latest/data-quality/tutorial-data-quality.html>)




## Create a recipe

Users have two options to extract their failed Data Quality rows.

The first option is to initiate the extract from the ‘Current status’ tab of the Data Quality view within a dataset under the vertical dots ‘More actions’.

The second option is to click on the ‘+Recipe’ button from the flow. Alternatively, if you have selected a dataset, go to the right panel’s Action tab, and select ‘Other recipes’ > ‘Extract failed rows’.

## Supported Data Quality rules

The extract failed rows recipe is currently compatible with 6 rule types:

  * Column values are not empty

  * Column values are empty

  * Column values are unique

  * Column values in set

  * Column values in range

  * Column values are valid according to meaning (only with DSS engine)




## Engines

Depending on the input dataset types, DSS will adjust the engine it uses to execute the recipe, and choose between Hive, Impala, SparkSQL, plain SQL, and internal DSS. The available engines can be seen and selected by clicking on the cogwheel below the “Run” button.

## Data Quality rules selection

In the ‘Selected rules’ tab, you have the possibility to choose on which rules to apply the extraction. If a rule is defined on multiple columns, there will be as many entries in the table to select on which rule/column to apply the extraction.

Rules are listed in the same order as in the Data quality tab of the input dataset.

At recipe creation, all compatible rules will be selected by default. Moreover, the ‘Always select all’ option will be checked. This option guarantees all new rules added on the input dataset after the last save of the recipe and compatible for extraction will automatically be selected. Note that a rule can be compatible for extraction but not supported by the selected engine, e.g. the [meaning validity rule](<../metrics-check-data-quality/data-quality-rules.html#meaning-validity-rule>) with any other engines than DSS.

---

## [other_recipes/fuzzy-join]

# Fuzzy join: joining two datasets

The “fuzzy join” recipe is dedicated to joins between two datasets when join keys don’t match exactly.

It works by calculating a distance chosen by user and then comparing it to a threshold. DSS handles inner, left, right or outer joins.

See also

For more information, see the [Tutorial | Fuzzy join recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/join/tutorial-fuzzy-join.html>) article in the Knowledge Base.

## Building a simple join

When the recipe is first created it will try to automatically find matching columns based on their name and type. One to five initial conditions will be provided, but this list can be changed by user.

Adding join is a process involving several configuration steps. In the “Join” section of the recipe (in the left pane):

  * Click on an existing join conditions list or on a message “No join condition” to add a new condition.

  * Select the join type, between “Inner”, “Outer”, “Left” or “Right”.

  * Fill in the join conditions. Conditions can be added with the “+” button, and removed with the “Remove” button (after selecting one).




Once the join definition is ready, go to the “Selected columns” section of the recipe and select the columns of each dataset whose values you want to get.

Finally, review the execution specs in the “Output” section.

## Join conditions

Each join condition describes a matching rule for two columns. Depending on column types different options will be available.

Note

If all of the join conditions are set to strict equality then a fuzzy join recipe will be equivalent to a regular join recipe. In this case a regular join is preferred as it’s more performant.

## Available distances

### Text columns

  * [Damerau–Levenshtein](<https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance>) \- an edit distance between two sequences. Informally, the Damerau–Levenshtein distance between two words is the minimum number of operations (consisting of insertions, deletions or substitutions of a single character, or transposition of two adjacent characters) required to change one word into the other.

  * [Hamming](<https://en.wikipedia.org/wiki/Hamming_distance>) \- a distance between two strings of equal length is the number of positions at which the corresponding symbols are different.

  * [Jaccard](<https://en.wikipedia.org/wiki/Jaccard_index>) \- a distance, which measures dissimilarity between sample sets of characters from joined strings. Calculated as a size of a set containing common characters divided by a size of a set containing all characters from both strings.

  * [Cosine](<https://en.wikipedia.org/wiki/Cosine_similarity>) \- a distance is measured by converting strings into vectors by counting characters appearing in both strings and then calculating a dot product of two vectors.




Also text values can be normalized before joining, a list of possible operations includes:

Name | Description | Example before | Example after  
---|---|---|---  
Case insensitive | Ignores case when matching characters | Hello, the Mister Lefèvre | hello, the mister lefèvre  
Remove punctuation and extra spaces | Removes punctuation and extra spaces | Hello, the Mister Lefèvre | Hello the Mister Lefèvre  
Clear salutations | Removes English salutations, e.g. Miss, Sir, Dr | Hello, the Mister Lefèvre | Hello, the Lefèvre  
Clear stop words | Removes common stop words depending on the language | Hello, the Mister Lefèvre | Hello Mister Lefèvre  
Transform to stem | Transforms words to base form (Snowball stemmer) | Monkeys eat bananas | Monkey eat banana  
Alphabetic sorting of words | Alphabetic sorting of words | Hello, the Mister Lefèvre | Hello Lefèvre Mister the  
  
### Numeric columns

  * [Euclidean](<https://en.wikipedia.org/wiki/Euclidean_distance>) distance




### Geopoint columns

  * Geospatial distance




In case of other types or when column types don’t match the only join condition available is a strict equality.

For string and numeric columns it’s also possible to set a relative threshold. In this case a threshold will be in percents and the calculated distance will be divided by the length of a corresponding join key (or its value in case of numbers).

For example if there are two join keys “propre” and “propeller”, the distance is set to Damerau–Levenshtein and a threshold is relative and set to 50%.

  * An absolute Damerau–Levenshtein distance between these words is 4.

  * If the distance is calculated relatively to the first dataset, then a relative distance is 4/6 = 66%, (6 is a length of “propre”) so with a 50% it’s not a match.

  * If the distance is calculated relatively to the second dataset, then a relative distance is 4/9 = 44%, ( is a length of “propeller”) and it’s a match.




## Additional settings

There are two additional options of the recipe.

### Output matching details

Adds an additional “meta” column that contains a JSON object with details about joined keys that includes:

  * distance type

  * threshold

  * calculated distance

  * a result showing if two values matched

  * a pair of join values




### Debug mode

Activates a cross join and also enabled meta column generation. Useful when trying to understand why certain rows didn’t match.

Warning

Since debug mode forces a cross join the recipe can be slow and can generate very large output. Consider filtering the inputs to only the rows that you’re interested in while debugging.

## Columns in the output

Since datasets routinely have columns with identical names, it is possible to disambiguate column names in the “Selected columns” section, either by giving an alias for a given column (using the “pencil” button next to the given column), or by assigning a prefix to apply to all columns of the table (by clicking on the “No prefix” button).

## Engines

Only DSS engine is supported.

---

## [other_recipes/generate-features]

# Generate features

The “generate features” recipe makes it easy to enrich a dataset with new columns in order to improve the results of machine learning and analytics projects.

DSS will then automatically join, transform, and aggregate this data, ultimately creating new features.

You can also configure time settings to avoid prediction leakage or specify more narrow time windows for computations.

## Create a generate features recipe

  1. Either select a dataset and click on the “Generate features” icon in the right panel, or click on the “+Recipe” button and select Visual > Generate features.

  2. The recipe input should be your primary dataset, i.e. the dataset to enrich with new features.

  3. Create your output dataset. It should be on the same connection as the primary dataset.




Note

The generate features recipe only supports datasets that are compatible with Spark or with SQL views. Connections compatible with SQL views include:

  * PostgreSQL

  * MySQL

  * Oracle

  * SQL Server

  * Azure Synapse

  * Vertica

  * Greenplum

  * DB2

  * Redshift

  * Snowflake

  * BigQuery

  * Teradata

  * Exasol

  * Databricks

  * Trino/Starbust




## Set up data relationships

In the “Data relationships” section, you can add enrichment datasets and configure associated data relationships and join conditions. You may also specify time settings to avoid prediction leakage or add time windows.

### Set up relationships without time settings

If you are not familiar with the recipe or if your primary dataset does not have a notion of time, follow these steps to add new relationships to enrich your primary dataset.

  1. After creating a recipe with a primary dataset, click on “Add enrichment dataset”

  2. Set the cutoff time to “None”

  3. Add an enrichment dataset, and hit save

  4. If you want to edit the auto-selected join conditions, click on them from the recipe window. If no join conditions have been auto-selected, click “add a condition” and add join keys.

  5. Based on the join conditions, select the relationship type between your datasets. This will determine whether new features are generated from one or many rows. Select :

>      * **One-to-one** if one row in the left dataset matches one row in the right dataset. Only row-by-row computations will be performed.
> 
>      * **Many-to-one** if many rows in the left dataset match one row in the right dataset. Only row-by-row computations will be performed.
> 
>      * **One-to-many** if one row in the left dataset matches several rows in the right dataset. Both row-by-row computations and aggregations will be performed.
> 
> Note
> 
> If the relationship type is one-to-many, the join key(s) will be used as the group key(s) when computing many-row aggregation features.

  6. To add more than one enrichment dataset, click the “+” button next to the dataset you want to join onto.




The relationship type has a significant impact on the computations:

  * If the relationship type is **one-to-one** or **many-to-one** , the recipe will:

>     1. Perform a left join between the two datasets
> 
>     2. Perform selected row-by-row computations

  * If the relationship type is **one-to-many** , the recipe will:

>     1. Group the right dataset by the join key(s) & perform selected aggregations
> 
>     2. Perform a left join between the two datasets
> 
>     3. Perform selected row-by-row computations




### Build relationships with time settings

Defining time settings allows you to avoid data leakage in your new features, or to narrow the range of time used in feature generation. This involves a few key concepts :

  * **Cutoff time** : A date column in the primary dataset that indicates the point in time at which data from enrichment datasets should no longer be used in feature generation. This is a required step before adding time settings to enrichment datasets. For many use cases, the cutoff time is the time at which predictions should be made. For prediction problems, the notion of cutoff time is similar to the concept of [time variable](<../machine-learning/time-series-forecasting/settings.html#forecasting-general-settings>) or [time ordering](<../machine-learning/supervised/settings.html#settings-time-ordering>).

  * **Time index** : Column from an enrichment dataset indicating when an event, corresponding to each row of data, occurred. If you set a time index in an enrichment dataset, all rows from the enrichment dataset whose time index value is greater than or equal to the cutoff time will be excluded from computations.

  * **Time window** : Allows you to (optionally) further narrow the time range used in feature transformations. The start date of the time window is excluded from the feature transformation and the end date is included, unless it overlaps with the cutoff time, in which case it is still excluded.




To configure time settings in your “generate features” recipe, follow the below steps:

  1. After creating the recipe with a primary dataset, click on “Add enrichment dataset”

  2. Define a cutoff time for your primary dataset

  3. Add an enrichment dataset and add a time index, and optionally also a time window.




To see how this works in practice, imagine you want to predict whether a user will make a purchase at a given time. Your primary dataset contains a “User_id” column and a date column that indicates when you want to make a prediction. The recipe will only use enrichment dataset data that is available at prediction time, as shown below.

In the primary dataset, the cutoff time for “User_id” 001 is 2020-05-10, so, the recipe will include the row corresponding to 2020-05-02 from the enrichment dataset, but not the row corresponding to 2020-06-12 as it comes after 2020-05-10, the cutoff time. For “User_id” 002, however, the cutoff time is 2020-07-18, so the recipe keeps the row available on 2020-06-12.

## Select columns for computation

For each dataset, select the columns that you want to use to compute your features. Note the following :

  * Original values will also be retrieved for selected columns in the primary dataset or any datasets which the primary dataset has a one-to-one or many-to-one relationship with.

  * If you used the same dataset more than once in the “Data relationships” tab, the selections will be applied globally for all usage of that dataset.

  * You may edit the variable types to change the types of transformations performed on the selected column. The next section explains feature transformations in more detail.




## Select feature transformations

Choose the transformations that you want to apply to the columns selected in the “Columns for computation” tab. The features differ depending on the variables types of the columns, defined in the “Columns for computation” tab. Two types of transformations exist:

  * Row-by-row computations

>     * Applied on one row at a time
> 
>     * Performed on all datasets regardless of the relationship types
> 
>     * Run on date & text variable types

  * Aggregations

>     * Applied across many rows at a time
> 
>     * Performed only on datasets that are on the right side of a one-to-many relationship
> 
>     * Run on general, categorical & numerical variable types




More specifically…

  * The row-by-row computations consist of :

>     * Date :
>
>>       * Hour: the hour of the day
>> 
>>       * Day of week
>> 
>>       * Day of month
>> 
>>       * Month: the month of the year
>> 
>>       * Week: the week of the year
>> 
>>       * Year
> 
>     * Text :
>
>>       * Character count: the number of characters
>> 
>>       * Word count: the number of spaces in a string + 1




Note

For most databases, the word count first cleans strings to remove consecutive white spaces, tabs and new lines. The SQL databases that do not support REGEX such as SQL Server and Azure Synapse implement a more basic cleaning which keeps tabs, new lines and consecutive spaces (if there are 4 consecutive spaces or more). To improve the accuracy of the word count, you may want to clean your text data in a prepare recipe before using the generate features recipe.

  * The aggregations consist of :

>     * General :
>
>>       * Count: the count of records
> 
>     * Categorical :
>
>>       * Count distinct: the count of distinct values
> 
>     * Numerical :
>
>>       * Average
>> 
>>       * Maximum
>> 
>>       * Minimum
>> 
>>       * Sum




## Output column naming

The recipe derives the output column names from their origin datasets and the transformations. For example, the visual below illustrates how the recipe generates the column name for the count of distinct transaction days:

[](<../_images/generate-features-column-names.png>)

To better explain each computation, the recipe creates column descriptions which help clarify the output features. In the previous example, the recipe describes the column “distinct_TRANSACTIONS_day_date” as follows: “count of distinct values of day of the month of transaction_date for each customer_id in transactions’

## Limitations

  * The generate features recipe only accepts SQL and spark compatible datasets. If Spark is disabled on the Dataiku instance, the input and the output datasets of a recipe must all belong to the same connection.

  * The recipe does not support partitioned datasets.

  * The recipe does not support SQL pipelines




## Reduce the complexity of the recipe

To reduce the number of generated features, you may :

  * Decrease the number of relationships.

  * Create most relationships from the primary dataset instead of the enrichment datasets. If you enrich enrichment datasets, then their enriched version adds up to the primary dataset. As a result, it generates a lot of new features.

  * Deselect some columns for computation.

  * Deselect some feature transformations.




The generated features can get quite complex. To generate simpler features, you can :

  * Avoid using several join conditions. One-to-many relationships use join keys as group keys. So if you select many join keys, the recipe aggregates on multiple columns.

  * Create most relationships from the primary dataset instead of the enrichment datasets.

---

## [other_recipes/generate-recipe]

# Generate Recipe

See also

> For more information, see also the following article in the Knowledge Base:

  * [Concept | Generate recipes using Generative AI](<https://knowledge.dataiku.com/latest/prepare-transform-data/enrich/concept-generate-recipe.html>)




## Create a recipe

The feature is accessible from both the flow view and the explore view of a dataset. To use it, select one or multiple datasets from the flow view, then open the right-hand panel where you’ll find a new tab labeled “Generate Recipe”. Clicking this tab displays a text input box where you can describe the data preparation steps you want to apply to the selected dataset(s).

Note

To generate visual recipes for multiple datasets, such as join or stack, select all the datasets from the flow that you want to include in the recipe generation context.

## Supported recipes

The Generate Recipe feature currently generates only Visual recipes. The supported recipes are:

  * Distinct

  * Group

  * Join

  * Pivot

  * Prepare

  * Sample/Filter

  * Sort

  * Split

  * Stack

  * Top n

  * Windows

---

## [other_recipes/generate-statistics]

# Generate statistics

The “generate statistics” recipes allow you to perform statistical computations about a dataset. When creating a “generate statistics” recipe in the flow, you can choose among different kinds of analyses:

  * Univariate analysis

  * Principal component analysis

  * Statistical tests




These computations and more are also available in [interactive mode](<../statistics/index.html#interactive-statistics>) using the worksheet interface in the **Statistics** tab of your dataset.

For the computations that support it, it is also possible to directly export a card from an interactive statistics worksheet to a recipe in the flow.

Details about the computations and their parameters can be found on the dedicated pages in the [interactive statistics documentation](<../statistics/index.html#interactive-statistics>).

See also

For more information, see the [Concept | Generate statistics recipe](<https://knowledge.dataiku.com/latest/ml/statistics/concept-generate-statistics.html>) article in the Knowledge Base.

---

## [other_recipes/geojoin]

# Geo join: joining datasets based on geospatial features

The Geo join visual recipe allows you to perform a join between two (or more) datasets based on geospatial matching conditions.

This visual recipe offers multiple geospatial matching conditions. Join clauses can be chained together to perform join operations on many input datasets. Matching conditions can be combined to perform complex operations. Like other join recipes in DSS, join types (INNER, LEFT, RIGHT, FULL or CROSS) are defined for each individual join clause.

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Geo join recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/join/concept-geo-join-recipe.html>)

  * [Tutorial | Geo join recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/join/tutorial-geo-join-recipe.html>)




## Building a Geo join recipe in the flow

To create this recipe, either click on the Geo join icon in the right tab, or select several datasets from the flow and then click on the Geo join icon. All datasets involved in the join should have at least one geospatial column.

### Geometry storage types in DSS

In DSS, geometries are stored as String using the following storage types: geometry and geopoints. These are the two only types that can be used to store geospatial values in DSS. The geometry is expressed through [WKT format](<https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry>).

Note that, as for other features of DSS, all geometries are expressed in the SRID 4326. Therefore, before manipulating any geospatial data in DSS, it is mandatory to project in this SRID. No metadata is required and won’t be read.

### Compose join through matching conditions

The main join condition menu displays several 1-to-1 join relationships between datasets, referred to as join clauses. Each join clause is a combination of individual (geospatial) matching conditions.

When the recipe is created, DSS will analyze the list of columns of joined datasets trying to find the best pairs of columns that can match. This will result in a list of default join conditions.

Matching conditions can be added using the “+” button, and removed by clicking on the “Remove” button. While specifying the matching conditions, the user may change joined columns. The dropdowns will show only geospatial columns (point or geometry types) corresponding to each dataset.

After setting the full set of join clauses and defining the join relationships between the input datasets, go to the “Selected Columns” section of the recipe (left panel), to select the columns of each dataset that will be kept in the single output dataset. The column names of the output dataset should not be duplicated. To de-duplicate the output column names in the output dataset, each dataset comes with an optional prefix input form that can be filled to associate a prefix with input datasets.

## Detailed recipe configuration steps

### Pre-filters

A pre-filter can be configured for each dataset.

The filters documentation is available [here](<sampling.html>).

The distinct option will remove duplicated rows of the dataset in order to keep only distinct rows for the recipe to consider. This option can be useful to reduce computation time or get rid of unnecessary rows in the output dataset.

The filter option enables custom selection of the rows that will be considered for the join.

#### geoContains() formula

Sometimes it can be useful to only work with a certain part of the map, for example a dataset has a column called `geom` containing points and it’s required that all of the points are within a given area. In this case one can use a `geoContains` formula in a prefilter: `geoContains("POLYGON(...)", geom)` where the first argument is a WKT representation of the polygon limiting the area of interest.

The dataset column name can equally be used as a first argument, for example the following filter will filter only the rows where the value of the column polygons is a polygon (WKT geometry) containing the geopoint POINT(2.32 48.86). In this context “containing” has a geospatial meaning. (See related definition of the [ST_Contains function in PostGIS](<https://postgis.net/docs/ST_Contains.html>) )

### Join clause selection and matching conditions

Each pair of input dataset can be joined on one or several matching conditions on geospatial features. The definition of the join clause and the matching conditions appears in the Join panel of the left tab of the recipe.

There can be multiple datasets in the join operation as long as all of the datasets contain at least one geospatial column on which the join is to be applied.

Click on the matching condition (displayed on the image below) to change or add a matching condition. For example here, we have one join clause between datasets polygons and polygons_copy where the matching condition is an equality of the geometries and one other join clause between datasets polygons and lines.

Clicking on one of the matching conditions of a join clause displays the join submenu. The selection of the join type and of the set of matching conditions will be done in this menu.

There are several ways to match geospatial features based on operators.

### Geospatial matching operators

Full list of available geospatial operators:

  * [Contains](<https://postgis.net/docs/ST_Contains.html>)
    
    * Not symmetrical

  * [Is contained](<https://postgis.net/docs/ST_Within.html>)
    
    * Not symmetrical

  * [Within a distance](<https://postgis.net/docs/ST_DWithin.html>)
    
    * Symmetrical

    * Additional parameter for the distance

  * Beyond a distance: Opposite of Within a distance
    
    * Symmetrical

    * Additional parameter for the distance

  * [Intersects](<https://postgis.net/docs/ST_Intersects.html>)
    
    * Symmetrical

  * [Touches](<https://postgis.net/docs/ST_Touches.html>)
    
    * Symmetrical

  * [Disjoint](<https://postgis.net/docs/ST_Disjoint.html>)
    
    * Symmetrical

  * [Strict Equality](<https://postgis.net/docs/ST_Equals.html>)
    
    * Symmetrical




Operators Within a distance and Beyond a distance require an additional distance parameter. The available units for this distance are: Meter, Kilometer, Foot, Yard, Mile, Nautical Mile.

### Selected columns

Redefine schema of the output dataset if needed, de-duplicate column names and select only the columns that need to be in the output dataset. If all columns of a dataset are to be in the output dataset, click the Autoselect all toggle.

### Post-Filtering

The post-filtering option provides the same options as in pre-filtering but this time applied only on the output dataset. The two types of processing remain the same: Distinct and Filter.

### Selected engine

The Geo join recipe can run either in a DSS engine or in SQL databases. Based on the input connections the available engines differ. The supported databases include:

  * [PostGIS](<https://postgis.net/>) (PostgreSQL extension)

  * Snowflake




### Enabling PostGIS extension in DSS

[PostGIS](<https://postgis.net/>) database can be used when SQL engine is selected in the recipe settings. In this case the join will be done on the database side.

Refer to [PostGIS integration](<../connecting/sql/postgresql.html#postgis-integration>) for more information about PostGIS support in DSS.

### Spatial indexes on SQL databases

When running the GeoJoin recipe using a SQL engine like PostGIS, use of spatial indexes is strongly recommended to improve performance of the join. However, no index will be created by default when running the recipe.

In order to automate the creation of the spatial indexes, use a post-write statement. Go to Dataset > Advanced > Post-Write Statement to create spatial indexes each time the target dataset is updated.

In order to improve performance of the geojoin recipe, a geospatial index on each column involved in the join operation must be created. Such index can be created by executing the following SQL statement in the database hosting the datasets for every column involved in the join:
    
    
    CREATE INDEX "idx_name" ON "dataset_name" USING GIST ((ST_SETSRID("geometry_column", COALESCE(NULLIF(ST_SRID("geometry_column"), 0), 4326))));
    

Where:

  * `idx_name` is the name of the index (must be unique)

  * `dataset_name` is the name of the dataset

  * `geometry_column` is the name of the dataset column containing the geometry used for the join operation




The SRID must be set to 4326.

## Troubleshooting

### Side location conflict

Errors like `side location conflict [ (15.299400817384745, 37.08743007526999, NaN) ]`) occur when a MULTIPOLYGON geometry contains overlapping polygons.

Note

According to the Open Geospatial Consortium documentation, _the interiors of 2 Polygons that are elements of a MultiPolygon may not intersect_.

DSS provides the [geoMakeValid formula function](<https://doc.dataiku.com/dss/latest/formula/index.html#geometry-functions>) that can fix invalid geometries (for instance by merging two overlapping polygons into one). You can run a prepare recipe either on DSS engine or directly on a PostGIS database with a formula step in order to apply this function before the geojoin recipe.

---

## [other_recipes/grouping]

# Grouping: aggregating data

The “grouping” recipe allows you to perform aggregations on any dataset in DSS, whether it’s a SQL dataset or not. This is the equivalent of a SQL “group by” statement. The recipe offers visual tools to setup the (custom) aggregations and aliases.

The “grouping” recipe can have pre-filters and post-filters. The filters documentation is available [here](<sampling.html>).

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Group recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/aggregate/concept-group-recipe.html>)

  * [Tutorial | Group recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/aggregate/tutorial-group-data.html>)




## Engines

Depending on the input dataset types, DSS will adjust the engine it uses to execute the recipe, and choose between Hive, Impala, SparkSQL, plain SQL, and internal DSS. The available engines can be seen and selected by clicking on the cog below the “Run” button.

---

## [other_recipes/index]

# Visual recipes

In the Flow, recipes are used to create new datasets by performing transformations on existing datasets. The main way to perform transformations is to use the DSS “visual recipes”, which cover a variety of common analytic use cases, like aggregations or joins.

By using visual recipes, you don’t need to write any code to perform the standard analytic transformations.

Visual recipes are not the only way to perform transformations in the Flow. You can also use [code recipes](<../code_recipes/index.html>), for example with SQL or HiveQL queries, or with Python or R. These code recipes offer you complete freedom for analytic cases which are not covered by DSS visual recipes.

---

## [other_recipes/join]

# Join: joining datasets

The “join” recipe is dedicated to joins between two or more datasets. DSS handles inner, left outer, right outer, full outer, cross and advanced joins. Unmatched rows can be collected with the special left and right anti join types, or as an option for the regular inner, left outer, right outer joins.

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Join recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/join/concept-join-recipe.html>)

  * [Tutorial | Join recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/join/tutorial-join-recipe.html>)




## Building a simple join

Adding join is a process involving several configuration steps.

You can add one or two datasets in the recipe creation modal and can add additional datasets from the “Join” section of the recipe.

In the “Join” section of the recipe:

  * Use the “+” button to add additional datasets (if necessary)

  * Select the join type, between “Left join”, “Inner join”, “Outer join”, “Right join”, “Left anti join”, “Right anti join”, “Cross join”, and “Advanced join”

  * Review or add join conditions. If the datasets share column names, those columns will be selected by default. Click “ADD A CONDITION” if nothing has been auto-selected, or click on the join keys or operator to edit.




Once the join definition is ready, go to the “Selected columns” section of the recipe and select the columns of each dataset whose values you want to include in the output dataset.

Finally, review the execution specs in the “Output” section.

### Adding output datasets for unmatched rows

You can optionally add additional output datasets to capture unmatched rows resulting from your join. You can do this by clicking on the “Drop unmatched rows” dropdown, and selecting “Send unmatched rows to other output dataset(s)” and then clicking the “+ADD DATASET” button to add associated output datasets.

This functionality is supported for left, right, and inner joins between two datasets.

## Filtering

You can apply pre-filters and post-filters (on the main output only, not unmatched datasets). The filters documentation is available [here](<sampling.html>).

## Columns in the output

Since datasets routinely have columns with identical names, it is possible to disambiguate column names in the “Selected columns” section, either by aliasing a given column (using the “pencil” button next to the given column), or by assigning a prefix to apply to all columns of the table.

You can generate additional output columns by writing custom expressions in the “Post-join computed columns” section.

## Engines

Depending on the input dataset types, DSS will adjust the engine it uses to execute the recipe, and choose between Hive, Impala, SparkSQL, plain SQL, and internal DSS. The available engines can be seen and selected by clicking on the cog below the “Run” button.

## Database-specific notes

### Vertica

Due to the way Vertica handles the lowercasing and string normalization operations, if you want to use the join recipe with these options enabled, each join column must be below 8192 chars. You can set the width of string columns in the schema of the input datasets.

If you use lowercase only, the width must be below 32K.

---

## [other_recipes/list-access]

# List Access

The list access recipe lets you retrieve the [security tokens](<../agents/tools/knowledge-bank-search.html#document-level-security>) (here implemented with DSS group names) from a Sharepoint folder. To be more precise, this recipe lists the files from a Sharepoint folder, displays the Entra groups that have access to each file and provides the mapping between the Entra groups and the DSS groups.

This recipe is useful to create the input dataset, containing the security tokens, for the [embed recipe](<../generative-ai/knowledge/documents.html>).

## Settings

A key configuration for the list access recipe is located in the settings, under the [Azure AD](<../security/authentication/azure-ad.html>) section. If you set the [Azure AD groups readable by](<../security/authentication/azure-ad.html#azure-ad-permissions>) setting to _Everybody_ , it allows all the users to retrieve the DSS groups and their respective Azure AD mappings. As a result, running the list access recipe will leverage the existing mappings defined in DSS. However, you can run this recipe without this setting activated, but you will need to provide a manual mapping dataset as a second input.

## Inputs

Here are the inputs that the list access recipe expects:

  * _Sharepoint folder_ : The folder the content of which will be listed alongside the mapping of the groups. This input is mandatory.

  * _Manual mapping dataset_ (Optional): You can provide a dataset containing the mapping between the DSS groups and the Entra groups. The expected format is the following: a column for the DSS group of type string and another column for the Entra groups in a JSON array format (ex: [“entra-group1”, “entra-group2”]). This input is useful if the _Azure AD groups readable by_ setting is set to _Nobody_ , because you provide the mapping yourself. However, in case this setting is set to _Everybody_ , the manual mapping you provide will be used as an additional source of mapping alongside the existing DSS group mappings. Finally, if you enter here a mapping for a DSS group that was already mapped to Azure AD groups by the admin, the manual dataset will override the existing.




## Output columns

Structure of the output dataset:

  * _path_ : Path to the file in the folder.

  * _entra_groups_ : List of Entra groups that have access to the file.

  * _dss_groups_ : DSS groups that are mapped to the Entra groups. These will be used as security tokens in the rest of the workflow. They are in a JSON array format and each DSS group name is prefixed by _dss_group_ (ex: [“dss_group:tech-members”, “dss_group:readers”])

  * _error_details_ : Error messages raised during the computation with a per file granularity.

---

## [other_recipes/list-folder-contents]

# List Folder Contents

The “List Folder Contents” recipe lets you list all the files contained in a folder into a dataset, along with some information about the file and possibly extracting parts of the path into extra columns.

This recipe is useful to create the input dataset for [Computer vision](<../machine-learning/computer-vision/index.html>) or [Labeling](<../machine-learning/labeling.html>) from the input images folder.

## Output columns

You can select the information to retrieve about each file in the folder:

  * _path_ to the file in the folder

  * _basename_ filename without the extension

  * _extension_ of the file

  * _last_modified_ date

  * _size_ of the file in bytes




## Folder level mapping

Use this mapping to output extra columns containing the name of specific levels in the folder hierarchy.

Levels start at 1 and negative levels are relative to the end of the folder hierarchy.

For example:

---

## [other_recipes/pivot]

# Pivot recipe

The “pivot” recipe lets you build pivot tables, with more control over the rows, columns and aggregations than what the [pivot processor](<../preparation/processors/pivot.html>) offers. It also lets you run the pivoting natively on external systems, like SQL databases or Hive.

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Pivot recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/transform/concept-pivot-recipe.html>)

  * [Tutorial | Pivot recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/transform/tutorial-pivot-recipe.html>)




## Defining the pivot table rows

The rows in the output dataset are defined by the values of a tuple of columns, the row identifiers. This tuple can be specified explicitly, or implicitly as “all other columns”, in which case any column that is not used to define modalities nor is used in an aggregate will be used as row identifier.

A | B | C | D | E  
---|---|---|---|---  
x | 1 | a | 1 | 6  
y | 1 | b | 2 | 5  
x | 1 | a | 3 | 4  
y | 2 | b | 1 | 3  
x | 2 | b | 2 | 2  
  
For the input columns {A, B, C, D, E}, giving {A, B} as explicit list of row identifiers will produce a pivot table where the rows are indexed by the pairs of values for A and B found in the input data.

A | B | …  
---|---|---  
x | 1 | …  
y | 1 | …  
x | 2 | …  
y | 2 | …  
  
On the other hand, using “all other columns” while having the modalities defined by column B and aggregates on columns D and E will produce a pivot table where the rows are indexed by the tuples of values for A and C found in the input data.

A | C | 1_D_sum | 1_E_sum | 2_D_sum | 2_E_sum  
---|---|---|---|---|---  
x | a | 4 | 10 |  |   
x | b |  |  | 2 | 2  
y | b | 2 | 5 | 1 | 3  
  
## Modality handling

The columns in the output are defined as the list aggregates times the list of modalities.

### Computation of the list of modalities

The modalities themselves are the combinations of a non-empty list of columns. Since the list of combinations can be huge, there are several options to bring it back to something more manageable:

  * most frequent : keep only the N combinations appearing the most in the input data

  * min occurrence cont : keep only the combination appearing at least N times in the input data

  * explicit : specify the combinations explicitly




The effective list of modalities used to build the output is only known after the entire input dataset is scanned, so it’s not readily available at design-time, but computed when the recipe is run. By default, the list of modalities for a given set of settings is computed only once, and kept for ulterior runs of the recipe. The option to “recompute schema at each run” on the “Output” section of the recipe lets you force a recompute of the list of modalities at each run. Note that in this case, the changes in the list of output columns are not automatically propagated to downstream datasets and recipes.

### Cleaning of the modalities’ name

Since modalities are made up of a concatenation of the values of columns from the input data, their name is usually not directly usable as column name in SQL databases or Hive. The “Output” section of the recipe therefore offers options to simplify the names so that they become compatible with these systems:

  * soft slugification : swaps out whitespace and punctuation with ‘_’. This is sufficient for most SQL databases (PostgreSQL, Oracle…)

  * hard slugification : only keep alphanumeric characters, ‘_’ and ‘-’. This is typically for Hive (i.e. when the output dataset is HDFS)

  * numbering : completely ignores the original name of the modality and uses numbers instead. This is the safest of all schemes, and produces the shortest names.

  * truncation : after the above simplifications have been applied, truncate the names. SQL databases natural limitations are natively taken into account (for example the 32 char limit on Oracle’s column names), but some limitations are not implicit in the nature of the output dataset; typically, if the output is HDFS and is to be used with Impala, a 128 char limit needs to be enforced.




## Aggregates

The recipe offers 2 levels of aggregates :

  * aggregates per row and modality (i.e. per pivot table cell)

  * aggregates per row (i.e. marginals)




### Per row and modality

These are defined in the “Pivot” section of the recipe. “Add new” creates a new simple aggregate on a selected column, and the aggregate can be further setup by changing its aggregation, and if relevant, the aggregation settings.

For each aggregate defined in this section, and each modality, one column will be created in the output. The column name is made of the modality name concatenated with the aggregate’s column and aggregation type.

### Per row

The “Other columns” section of the recipe adds aggregates per row. There are 2 typical uses:

  * to keep columns that are neither row identifiers nor aggregates in the pivot table. In this case the aggregates “First”, “Last” or “Concat” should be preferred.

  * to compute marginals to compare the aggregates per row and modality to. For example, one can aggregate the average of column A for each row of X and modality of Y, and at the same time aggregate the average of column A for each row X (across modalities of Y).




## Comparison to pivot processor

The pivot processor is a stream-oriented processor that pivots one row at a time and is available in the preparation scripts, and consequently in Prepare recipes.

| Pivot recipe | Pivot processor  
---|---|---  
Modalities | computed by inspecting entire dataset. Not available at design-time until the recipe has run once | computed by using the design-time sample. A small sample or very imbalanced modalities implies that some modalities can be missed  
Dynamic output schema | the list of modalities can optionally be computed at each run of the recipe | schema is fixed at design-time  
Aggregations | aggregates can be defined for each value | no aggregation  
Output row definition | combinations of columns can be used to define a row. The data doesn’t need to be pre-sorted | rows are defined by the value of one column. The data needs to be sorted on that column to have all rows with the same key squashed together  
  
## Pre-filtering

Pre-filters can be applied. The filters documentation is available [here](<sampling.html>).

## Examples

### Pivoting country net revenue by product

For the input:

Product | Country | net | Year  
---|---|---|---  
Toothpaste | FR | 40 | 2015  
Toothpaste | GB | 80 | 2015  
Toothpaste | US | 60 | 2015  
Toothpaste | GB | 75 | 2017  
Toothpaste | US | 55 | 2017  
Chocolate | FR | 110 | 2015  
Chocolate | FR | 120 | 2017  
Chocolate | GB | 70 | 2017  
Peanut butter | US | 200 | 2017  
Peanut butter | GB | 30 | 2017  
  
A pivot recipe using Product as row identifier, Country to create columns with, and with an aggregate of sum of Net will yield

Product | FR_Net_sum | GB_Net_sum | US_Net_sum  
---|---|---|---  
Toothpaste | 40 | 155 | 115  
Chocolate | 230 | 70 |   
Peanut butter |  | 30 | 200  
  
Adding an aggregate of sum of Net in the ‘Other columns’ section will yield

Product | FR_Net_sum | GB_Net_sum | US_Net_sum | Net_sum  
---|---|---|---|---  
Toothpaste | 40 | 155 | 115 | 310  
Chocolate | 230 | 70 |  | 300  
Peanut butter |  | 30 | 200 | 230  
  
### Dummifying

The use of the Count of records aggregate allows for an easy and controlled way of dummifying columns. On the input:

Country | Product | Year  
---|---|---  
FR | Chocolate | 2017  
FR | Sugar | 2016  
FR | Apples | 2017  
GB | Chocolate | 2017  
GB | Sugar | 2015  
GB | Apples | 2017  
GB | Toffee | 2017  
US | Sugar | 2016  
US | Corn syrup | 2017  
US | Toffee | 2017  
US | Peanut butter | 2017  
  
A pivot recipe using Country as row identifier, Product to create columns with, and with an aggregate of count of records will yield:

Country | Chocolate | Sugar | Apples | Toffee | Corn syrup | Peanut butter  
---|---|---|---|---|---|---  
FR | 1 | 1 | 1 | 0 | 0 | 0  
GB | 1 | 1 | 1 | 1 | 0 | 0  
US | 0 | 1 | 0 | 1 | 1 | 1  
  
By additionally specifying that only the top 4 modalities should be used, the output becomes:

Country | Chocolate | Sugar | Apples | Toffee  
---|---|---|---|---  
FR | 1 | 1 | 1 | 0  
GB | 1 | 1 | 1 | 1  
US | 0 | 1 | 0 | 1

---

## [other_recipes/prepare]

# Prepare: Cleanse, Normalize, and Enrich

The Prepare recipe lets you create data cleansing, normalization and enrichment scripts in a visual and interactive way.

You can create a Prepare recipe from scratch or deploy it from a Visual Analysis in the Lab.

For details on the available data preparation steps, see [Data preparation](<../preparation/index.html>).

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Prepare recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/prepare/overview/concept-prepare-recipe.html>)

  * [Concept | Generating steps with AI](<https://knowledge.dataiku.com/latest/prepare-transform-data/prepare/overview/concept-prepare-recipe.html#generating-steps-with-ai>)

  * [Tutorial | Prepare recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/prepare/overview/tutorial-prepare-data.html>)

---

## [other_recipes/push-to-editable]

# Push to editable recipe

The “Push to editable” recipe allows you to copy a regular dataset to an Editable Dataset while keeping changes. Since Editable Datasets are limited to 100K rows, so are push to editable recipes. See [“Editable” dataset](<../connecting/editable-datasets.html>) for more information about Editable Datasets.

The first time you run a Push to editable recipe, it will copy the whole content of the regular dataset to the editable dataset. If you make changes to the content in the editable dataset, and then rerun the push to editable recipe, it will copy over all data that was new or changed in the original dataset but will preserve every modification you did in the editable dataset.

To identify what is considered as “new” or “was modified in editable dataset”, you need to select one or several columns that will form a unique identifier.

The main use case for a push to editable recipe is to make manual corrections to a dataset. For example, you have an input dataset of product categories in a database, but there are some errors, and for some reason, you can’t get the error to be fixed in the source data: you use a push to editable recipe, fix the erroneous entries, and base the rest of the flow on the editable dataset.

## Creating a Push to Editable recipe

From the Flow, click the “+Recipe” button, and select Visual > Push to editable. Alternatively if you have selected a dataset, go to the right panel’s Action tab, and select Other recipes > Push to editable.

Give a name to the output editable dataset.

Create the recipe. Select one or several columns to use as the unique identifier for each row.

You can also use the Filter section to remove data from your dataset. The filters documentation is available [here](<sampling.html>).

---

## [other_recipes/sampling]

# Sampling datasets

The “sample/filter” recipe serves the dual purpose of sampling and/or filtering dataset.

See also

For more information, see the [Concept | Sample/Filter recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/reduce/concept-sample-filter-recipe.html>) article in the Knowledge Base.

* * *

## Filtering in DSS

4 types of filtering are available and can be selected using the top dropdown menu :

  * Rules based

  * Formula based

  * SQL expression based

  * Elasticsearch query string (only available when the input dataset is on Elasticsearch v7 and above or OpenSearch)




### Rules based filters

A filter is defined by a list of possibly grouped conditions and the boolean operators that bind them.

#### Conditions

A Condition is defined by an input column, an operator, and a value.

  * Input column : choose any column from the dataset.

  * operator : choose an operator from the dropdown menu. The available operators match the storage type of the column. (a string column will have string operators available, such as `contains`, while a number column will have numerical operators available, such as `<`).

  * value : input a value or choose an existing column to apply the operator to.




Conditions can be added, deleted, duplicated, and turned into a group to create advanced conditions.

#### Groups

Groups can be used to create advanced logic for conditional statements. Groups can be nested to create sub-conditions `(y AND z AND (t OR u)))` or defined at the same level `(y OR z) AND (t OR u)`. Groups can be added using the +ADD > Add group button, deleted, duplicated, and ungrouped.

#### Boolean operators

Conditions and groups are bound using boolean operators, that can be either `And` or `Or`.

### Formula based filters

Formulas are manually defined using functions of the formula language, dataset column names, and project variables. Formulas are well suited for more complex filtering options or specific functions that do not appear in the rules based filter view. The formula language documentation can be found [here](<https://doc.dataiku.com/dss/latest/formula/index.html>).

### SQL expression based filters

When using an SQL based recipe engine, an SQL expression can directly be given to filter the dataset, using dataset columns and project variables.

### Elasticsearch query string

When using an input dataset on Elasticsearch v7 and above or OpenSearch, you can use the [query_string syntax](<https://www.elastic.co/guide/en/elasticsearch/reference/8.4/query-dsl-query-string-query.html>) to filter the dataset.

Note

When using an Elasticsearch query string, sampling is disabled and filtering is performed on the whole dataset.

---

## [other_recipes/sort]

# Sort: order values

The “sort” recipe allows you to order a dataset. You specify a list of columns, each with ascending or descending order. It can be performed on any dataset in DSS, wether it’s a SQL dataset or not. However in order the recipe to be useful, the output dataset must preserve the writing order. The most common ones are Filesystem and HDFS ; you can check it in the settings tab of the dataset if the option is available. Thereby when creating a new Sort recipe, the output dataset will be configured to preserve the order in writing if possible. The recipe also offers visual tools to setup the specifications and aliases. The “sort” recipe can have pre-filters. The filters documentation is available [here](<sampling.html>).

See also

For more information, see the [Concept | Sort recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/reorder/concept-sort-recipe.html>) article in the Knowledge Base.

## Engines

Depending on the input dataset types, DSS will adjust the engine it uses to execute the recipe, and choose between Hive, Impala, SparkSQL, plain SQL, and internal DSS. The available engines can be seen and selected by clicking on the cogwheel below the “Run” button.

## Null values handling

Since DSS version 4.1 and if the database engine allows it, the null values are sorted in a specific order. In the ascending order, the null values will be placed at the beginning and in descending order, the null values will be placed at the end. The main goal is to group together null values and empty strings as DSS consider both the same. Thus using most of the recent database engines or DSS engine provide the same outputs. However some database engines such as Vertica, Sybase IQ, and DB2 cannot explicitly order null values and using these engines may result in different outputs.

## Write ordering

Learn more about [Write ordering](<../connecting/ordering.html#write-ordering>). When the output dataset of the recipe preserves writing order, the recipe makes sense. In contrary, the Sort recipe is probably useless and the rows of the output dataset will lose their ordering. In this case, you may want to use a different processing:

>   * if your input and output datasets has the same connection, remove the Sort recipe and edit the read-order settings of the output dataset
> 
>   * if your input and output datasets has different connections, replace the Sort recipe by a [Sync recipe](<sync.html>) and edit the read-order settings of the output dataset
> 
>

---

## [other_recipes/split]

# Splitting datasets

The “split” recipe can dispatch rows of one dataset into several other datasets, based on rules. The “split” recipe can have pre-filters. You can also build specific filters to split your data in the Splitting tab. The filters documentation is available [here](<sampling.html>).

See also

For more information, see the [Concept | Split recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/stack-split/concept-split-recipe.html>) article in the Knowledge Base.

---

## [other_recipes/stack]

# Stacking datasets

The “stack” recipe merges several datasets into one dataset. This recipe is the equivalent of a “union all” SQL statement. The “stack” recipe can have pre-filters and post-filters. The filters documentation is available [here](<sampling.html>).

See also

For more information, see the [Concept | Stack recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/stack-split/concept-stack-recipe.html>) article in the Knowledge Base.

---

## [other_recipes/sync]

# Sync: copying datasets

The “sync” recipe allows you to synchronize one dataset to another. Synchronization can be global or per-partition.

One major use-case of the sync recipe is to copy a dataset between storage backends where different computation are possible. For example:

  * copying a SQL dataset to HDFS to be able to perform Hive recipes on it

  * copying a HDFS dataset to Elasticsearch to be able to query it

  * copying a file dataset to a SQL database for efficient querying.




See also

For more information, see also the [Concept | Sync recipe](<https://knowledge.dataiku.com/latest/import-data/connections/concept-sync-recipe.html>) article in the Knowledge Base.

## Schema handling

By default, when you create the sync recipe, DSS also creates the output dataset. In that case, DSS automatically copies the schema of the input dataset to the output dataset.

If you modify the schema of the input dataset, you should go to the edition screen for the sync recipe and click the “Resync Schema” button.

### Schema mismatch

With DSS streaming engine (see below), the Sync recipe allows the input and output schema to be different. In that case, DSS uses the **names** of the columns to perform the matching between the input and output columns

Therefore, you can use the Sync recipe to remove or reorder some columns of a dataset. You cannot use the Sync recipe to “rename” a column. To do this, use a Preparation recipe.

## Partitioning handling

By default, when syncing a partitioned dataset, DSS creates the output dataset with the same partitioning and puts a “equals” dependency. You can also sync to a non partitioned dataset or change the dependency.

When creating the recipe or clicking “Resync schema”, DSS automatically adds, if needed, the partitioning columns to the output schemas.

More on partitioning in [Working with partitions](<../partitions/index.html>)

## Engines

For optimal performance, the recipe can run over several engines:

  * DSS streaming (always available, may not be optimal)

  * Spark

  * SQL

  * Hive

  * Impala

  * Specific fast-paths (see links for specific documentation about the fast paths)

>     * [Amazon S3 to Amazon Redshift](<../connecting/redshift.html>) (and vice-versa)
> 
>     * Azure Blob Storage to Azure SQL Data Warehouse (and vice-versa)
> 
>     * Google Cloud Storage to Google BigQuery (and vice-versa)
> 
>     * [HDFS to Teradata](<../hadoop/tdch.html>) (and vice-versa)
> 
>     * [Amazon S3 to Snowflake](<../connecting/snowflake.html>) (and vice-versa)
> 
>     * [Azure Blob Storage to Snowflake](<../connecting/snowflake.html>) (and vice-versa)




Depending on the types and parameters of the input and output, DSS automatically chooses the engine to execute the synchronization.

---

## [other_recipes/topn]

# Top N: retrieve first N rows

The “top N” recipe allows you to retrieve the first N and the last M rows of subsets with the same grouping keys values. The rows within a subset are ordered by the columns you specify. It can be performed on any dataset in DSS, whether it’s a SQL dataset or not. The recipe offers visual tools to setup the specifications and aliases. The “top N” recipe can have pre-filters. The filters documentation is available [here](<sampling.html>).

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Top N recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/reorder/concept-top-n-recipe.html>)

  * [Tutorial | Top N recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/reorder/tutorial-top-n-recipe.html>)




## Engines

Depending on the input dataset types, DSS will adjust the engine it uses to execute the recipe, and choose between Hive, Impala, SparkSQL, plain SQL, and internal DSS. The available engines can be seen and selected by clicking on the cog below the “Run” button.

## Notes

  * If no grouping key is provided, the only considered subset will be the whole input dataset.

  * At least one order column is required.

  * When two rows have the same values for both the key and order columns, the order between those two rows is not deterministic and can change over the different builds (different rows may be retrieved for the same input values and recipe settings).

  * The remaining rows output is used to retrieve the rows from the original dataset that does not match the Top N recipe definitions.

  * However, when two rows have the same value according to the key and order columns, some engines may retrieve both rows in the two outputs (because the computations for the outputs are run separately). If one needs to strictly split the input dataset in two, one could use the DSS engine, or a Top N recipe plus a join recipe on the output and the original dataset to retrieve the non-matching rows.

  * Since DSS v4.1, null values are ordered in a specific way, take a look at [Null values handling](<sort.html#null-values-handling>)

---

## [other_recipes/upsert]

# Upsert: Consolidate data

Upsert is a term coined by blending “update” and “insert”, and the operation is often handled in SQL databases by a “MERGE INTO” verb. The operation’s goal is to take rows in, and perform two different operations at the same time:

  * if the row already exists in the output, update the values of the row in the output with the values of the incoming row (UPDATE mode)

  * if the row doesn’t yet exists in the output, add the incoming row to the output (INSERT mode)




Since no row deletion occurs in the output, the net effect of an upsert is that you consolidate incoming rows into one single output dataset.

This capability is provided by the “upsert-recipe” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

## Upsert keys

The upsert operation needs to map each row in the input and output dataset to some unique entity. This is done by specifying a subset of the columns to act as a unique key.

## Example

Let’s say you regularly have data files for customers, one row per customer, but only for customers that were added or for which some piece of information was modified since last time. Each customer is identified by some customer_id key. Starting from an empty output dataset, an upsert recipe would then behave like:

  1. First run (add customer 1 and 2), with input:


customer_id | name | rating  
---|---|---  
1 | Bob | 3  
2 | Alice | 1  
  
The output after run is:

customer_id | name | rating  
---|---|---  
1 | Bob | 3  
2 | Alice | 1  
  
  2. Second run (modify customer 2, add customer 3), with input:


customer_id | name | rating  
---|---|---  
2 | Alicia | 1  
3 | Daphne | 2  
  
The output after run is:

customer_id | name | rating  
---|---|---  
1 | Bob | 3  
2 | Alicia | 1  
3 | Daphne | 2  
  
  3. Third run (modify customer 1) with input:


customer_id | name | rating  
---|---|---  
1 | Bob | 999  
  
The output after run is:

customer_id | name | rating  
---|---|---  
1 | Bob | 999  
2 | Alicia | 1  
3 | Daphne | 2  
  
### Engines

Depending on the input dataset types, DSS will adjust the engine it uses to execute the recipe, and choose between Hive, Impala, SparkSQL, plain SQL, and internal DSS. The available engines can be seen and selected by clicking on the cog below the “Run” button.

When the engine is SQL, DSS can offer several modes of operation depending on the type of underlying database:

  * “direct upsert statement”: many SQL databases can handle upsert recipes “natively”, usually with a MERGE INTO verb, sometimes with a special handling of rejections to an INSERT INTO because of a unique constraint

  * “update then insert”: issue 2 SQL statements to the database, one to update rows already present in the output dataset, then one to add new rows. This mode doesn’t use a temporary table

  * “prepare upserted then replace output”: a temporary table is prepared, with existing rows and new rows, and the output dataset is cleared then replaced by this temporary table. This is the most generic mode, but also the slowest, and it requires being able to make a temporary table




### Notes

  * at least one upsert key is required to identify rows

  * DSS does not enforce or control the unicity of rows in the input or output dataset. If several rows have the same combination of values for the upsert keys, the behavior is undefined

---

## [other_recipes/window]

# Window: analytics functions

The “window” recipe allows you to perform analytics functions on any dataset in DSS, whether it’s a SQL dataset or not. This is the equivalent of a SQL “over” statement. The recipe offers visual tools to setup the windows and aliases. The “window” recipe can have pre-filters and post-filters. The filters documentation is available [here](<sampling.html>).

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Window recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/aggregate/concept-window-recipe.html>)

  * [Tutorial | Window recipe](<https://knowledge.dataiku.com/latest/prepare-transform-data/aggregate/tutorial-window-recipe.html>)




## Engines

Depending on the input dataset types, DSS will adjust the engine it uses to execute the recipe, and choose between Hive, Impala, SparkSQL, plain SQL, and internal DSS. The available engines can be seen and selected by clicking on the cog below the “Run” button.

Note

The DSS engine has different default window behavior than when using a SQL engine. When using the **DSS engine** , the window will default to the _whole_ frame if no window is specified. As a result, you can see different window behavior when switching between the DSS engine and a SQL engine. In order to see the same result when using the DSS Engine as you would with the SQL engine, you can enable the Window Frame option with both the “Limit preceding rows” and “Limit following rows” options unchecked.

## Notes

  * Since DSS v4.1, null values are ordered in a specific way, take a look at [Null values handling](<sort.html#null-values-handling>)