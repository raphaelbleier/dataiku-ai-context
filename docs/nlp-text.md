# Dataiku Docs — nlp-text

## [nlp/aws-apis]

# NLP using AWS APIs

Dataiku can leverage multiple AWS APIs to provide various NLP capabilities

## AWS Transcribe

The AWS Transcribe integration provides speech-to-text extraction in [40 languages](<https://docs.aws.amazon.com/transcribe/latest/dg/supported-languages.html>)

This capability is provided by the “Amazon Transcribe” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>)

### Setup

You need to create AWS credentials with the necessary permissions using AWS Identity and Access Management (IAM). If you don’t have an IAM user yet, create one first.

Next, grant the user access to Amazon Transcribe by giving them privileges directly, or by assigning them to a group.

Make sure to take note of the Access key ID & Secret access key which will appear after creation. Once you have an IAM user with the necessary privileges, you just need to provide Dataiku with the credentials.

In Dataiku, navigate to the **Plugins > Settings > API** and create a preset with the credentials.

The default _Concurrency_ parameter means that 4 calls to the API happen in parallel. This parallelization operates within the API Quota settings defined above. We do not recommend to change this default parameter.

The default _Maximum Attempts_ means that if an API request fails, it will be tried another 3 times. Regardless of why the request fails (e.g. an access error with your AWS account or a throttling exception due to too many concurrent requests), it will be tried again. Note that AWS may charge you depending on the nature of the error, for each additional attempt.

### Usage

Let’s assume that you have installed this plugin and that you have a Dataiku project with a folder hosted on S3 bucket containing the audio files to transcribe.

  * **Remote Folder must be hosted on a S3 bucket on the same account as the one of Amazon Transcribe containing the audio files to process**

  * Only the files in the format FLAC, MP3, MP4, Ogg, WebM, AMR, or WAV are taken into account.

  * The file has to last less than 4 hours in length and less than 2 GB in size (500 MB for call analytics jobs)




To create your transcribe recipe:

  1. Navigate to the Flow, click on the **\+ Recipe** button.

  2. Access the **Natural Language Processing** menu.

  3. If your folder is selected, you can directly find the recipe in the right panel.




### Settings

  * **Review INPUT parameters**

    * The _language_ parameter is the original language of the _audio files_. If you would like the transcribe api to infer the original language, you can select the Auto-detect option.

Tip

Find the [available languages here.](<https://docs.aws.amazon.com/transcribe/latest/dg/transcribe-whatis.html>)

    * Check _Display JSON checkbox_ if you want a column with the raw JSON results of the transcription.

    * The _Timeout_ parameter is the maximum time to wait for an audio file to be transcribed, if this the job is longer than that time, the result will not be shown in the dataset. However, the JSON file will appear in the output folder. Leave it empty if you don’t want a timeout.

  * **Review CONFIGURATION parameters**.




The _Preset_ parameter is automatically filled by the default one made available by your Dataiku admin. You may select another one if multiple presets have been created.

### Output

  * **Dataset with text transcribed from the audio files**




The columns of the output dataset are as follows:

output dataset columns Column | Description  
---|---  
path | Path to the audio file in the S3 bucket  
job_name | Name to identify the job in Amazon Transcribe  
transcript | Transcript of the audio file  
language | Language detected or setup by the user  
language_code | Language code detected or setup by the user  
(Optional) json | Raw API response in JSON form  
output_error_type | The error type in case an error occurs  
output_error_message | The error message in case an error occurs  
  
  * **(Optional) Output folder to put the JSON results from Amazon Transcribe**

>     * Remote folder hosted in an AWS S3 bucket. This folder will be written by Amazon Transcribe by putting the JSON results in this folder when the jobs are done. The plugin will then read that folder to put it in the output dataset.
> 
>     * This output folder is optional, if you decide to not give an output folder to the plugin, the results are written in the input folder. Make sure it has the write permissions.




## AWS Comprehend

The AWS Comprehend integration provides:

  * [Language Detection](<language-detection.html>) in [100 languages](<https://docs.aws.amazon.com/comprehend/latest/dg/how-languages.html>)

  * [Sentiment Analysis](<sentiment-analysis.html>) in [12 languages](<https://docs.aws.amazon.com/comprehend/latest/dg/supported-languages.html#supported-languages-feature>)

  * [Named Entities Extraction](<named-entities.html>) in [12 languages](<https://docs.aws.amazon.com/comprehend/latest/dg/supported-languages.html#supported-languages-feature>)

  * [Key phrase extraction](<key-phrase-extraction.html>) in [12 languages](<https://docs.aws.amazon.com/comprehend/latest/dg/supported-languages.html#supported-languages-feature>)




This capability is provided by the “Amazon Comprehend” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

### Setup

#### Create an IAM user with the Amazon Comprehend policy – in AWS

Let’s assume that your AWS account has already been created and that you have full admin access. If not, please follow this [guide](<https://docs.aws.amazon.com/comprehend/latest/dg/setting-up.html>). Start by creating a dedicated IAM user to centralize access to the Comprehend API, or select an existing one. Next, you will need to attach a policy to this user following this [documentation](<https://docs.aws.amazon.com/comprehend/latest/dg/access-control-managing-permissions.html>).

We recommend using the **“ComprehendFullAccess”** managed policy.

Alternatively, you can create a custom IAM policy to allow _“comprehend:*”_ actions.

#### Create an API configuration preset – in Dataiku DSS

In Dataiku, navigate to the **Plugins > Settings > API** and create a preset with the credentials.

#### (Optional) Review the API QUOTA and PARALLELIZATION settings

  * The default API Quota settings ensure that one recipe calling the API will be throttled at 25 requests (_Rate limit_ parameter) per second (_Period_ parameter). In other words, after sending 25 requests, it will wait for 1 second, then send another 25, etc.

  * By default, each request to the API contains a batch of 10 documents (_Batch size_ parameter). Combined with the previous settings, it means that it will send 25 * 10 = 250 rows to the API every second.

  * This default quota is defined by Amazon. You can request a quota increase, as documented on this [page.](<https://docs.aws.amazon.com/comprehend/latest/dg/guidelines-and-limits.html>)

  * You may need to decrease the _Rate limit_ parameter if you envision that multiple recipes will run concurrently to call the API. For instance, if you want to allow 5 concurrent DSS activities, you can set this parameter at 25/5 = 5 requests per second.

  * The default _Concurrency_ parameter means that 4 calls to the API happen in parallel. This parallelization operates within the API Quota settings defined above. We do not recommend to change this default parameter.




### Usage

Let’s assume that you have a Dataiku DSS project with a dataset containing text data. This text data must be stored in a dataset, inside a text column, with one row for each document.

As an example, we will use the [Amazon Review dataset for instant videos](<http://snap.stanford.edu/data/amazon/productGraph/categoryFiles/reviews_Amazon_Instant_Video_5.json.gz>). You can follow the same steps with your own data.

To create your first recipe, navigate to the Flow, click on the **\+ RECIPE** button and access the **Natural Language Processing** menu. If your dataset is selected, you can directly find the recipe on the right panel.

### Language Detection

#### Input

**Dataset with a text column**

#### Output

**Dataset with 5 additional columns**

  * Language code from the API in ISO 639 format.

  * Confidence score of the API from 0 to 1.

  * Raw response from the API in JSON format.

  * Error message from the API if any.

  * Error type (module and class name) if any.




#### Settings

  * **Fill INPUT PARAMETERS**

>     * Specify the _Text column_ parameter for your column containing text data.

  * **Review CONFIGURATION parameters**

>     * The _API configuration preset_ parameter is automatically filled by the default one made available by your Dataiku admin.
> 
>     * You may select another one if multiple presets have been created.

  * **(Optional) Review ADVANCED parameters**

>     * You can activate the _Expert mode_ to access advanced parameters.
> 
>     * The _Error handling_ parameter determines how the recipe will behave if the API returns an error.
>
>>       * In “Log” error handling, this error will be logged to the output but it will not cause the recipe to fail.
>> 
>>       * We do not recommend to change this parameter to “Fail” mode unless this is the desired behaviour.




### Sentiment Analysis

#### Input

**Dataset with a text column**

#### Output

**Dataset with 8 additional columns**

  * Sentiment prediction from the API (POSITIVE/NEUTRAL/NEGATIVE/MIXED).

  * Confidence score in the POSITIVE prediction from 0 to 1.

  * Confidence score in the NEUTRAL prediction from 0 to 1.

  * Confidence score in the NEGATIVE prediction from 0 to 1.

  * Confidence score in the MIXED prediction from 0 to 1.

  * Raw response from the API in JSON format.

  * Error message from the API if any.

  * Error type (module and class name) if any.




#### Settings

The parameters are almost exactly the same as the Language Detection recipe (see above).

The only change is the addition of _Language_ parameters. By default, we assume the _Text column_ is in English. You can change it to any of the supported languages listed [here](<https://docs.aws.amazon.com/comprehend/latest/dg/supported-languages.html>) or choose “Detected language column” if you have multiple languages. In this case, you will need to reuse the language code column computed by the Language Detection recipe.

### Named Entity Recognition

#### Input

  * **Dataset with a text column**




#### Output

**Dataset with additional columns**

  * One column for each selected entity type, with a list of entities.

  * Raw response from the API in JSON format.

  * Error message from the API if any.

  * Error type (module and class name) if any.




#### Settings

The parameters under **INPUT PARAMETERS** and **CONFIGURATION** are almost the same as the Sentiment Analysis recipe.

The one addition is _Entity types_ : select multiple among this [list](<https://docs.aws.amazon.com/comprehend/latest/dg/how-entities.html>) Under **ADVANCED** with _Expert mode_ activated, you have access to an additional _Minimum score_ parameter: increase from 0 to 1 to filter results which are not relevant. Default is 0 so that no filtering is applied.

### Key Phrase Extraction

#### Input

**Dataset with a text column**

#### Output

**Dataset with additional columns**

  * Two columns for each key phrase ordered by confidence (see _Number of key phrases_ parameter).

>     * Key phrase (1-4 words from the input text).
> 
>     * Confidence score in the key phrase.

  * Raw response from the API in JSON format.

  * Error message from the API if any.

  * Error type (module and class name) if any.




#### Settings

The parameters under **INPUT PARAMETERS** and **CONFIGURATION** are almost the same as the Sentiment Analysis recipe (see above). The one addition is: _Number of key phrases_ parameter: how many key phrases to extract by decreasing order of confidence score. The default value extracts the Top 3 key phrases.

### Visualization

Thanks to the output datasets produced by the plugin, you can create [Charts](<../visualization/index.html>) to analyze results from the API. For instance, you can:

  * Filter documents to focus on one language.

  * Analyze the distribution of sentiment scores.

  * Identify which entities are mentioned.

  * Understand what are the key phrases used by reviewers.




After crafting these charts, you can share them with business users in a [Dashboard](<../dashboards/index.html>)

## AWS Translation

The AWS Translation integration provides translation in [71 languages](<https://aws.amazon.com/translate/details/>).

This capability is provided by the “Amazon Translation” plugin, which you need to install.

Please see our [Plugin documentation page](<https://www.dataiku.com/product/plugins/nlp-amazon-translation/>) for more details

## AWS Comprehend Medical

The AWS Comprehend Medical integration provides Protected Health Information extraction and medical entity recognition in English

Note

This capability is provided by the “Amazon Comprehend Medical” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Warning

Costs for the AWS Comprehend Medical API are significantly higher than other APIs

Please see our [Plugin documentation page](<https://www.dataiku.com/product/plugins/amazon-comprehend-medical/>) for more details

---

## [nlp/azure-apis]

# NLP using Azure APIs

Dataiku can leverage multiple Azure APIs to provide various NLP capabilities

## Azure Cognitive Services

Dataiku can leverage the Azure Cognitive Services API to provide the following NLP capabilities:

  * [Language Detection](<language-detection.html>) of [108 languages](<https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/language-support?tabs=language-detection>)

  * [Sentiment Analysis](<sentiment-analysis.html>) in [13 languages](<https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/language-support?tabs=sentiment-analysis>)

  * [Named Entities Extraction](<named-entities.html>) in [23](<https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/language-support?tabs=named-entity-recognition>)

  * [Key phrase extraction](<key-phrase-extraction.html>) in [16 languages](<https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/language-support?tabs=key-phrase-extraction>)




Note

This capability is provided by the “Azure Cognitive Services” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Plugin documentation page](<https://www.dataiku.com/product/plugins/azure-cognitive-services-nlp/>) for more details

## Azure Translation

Dataiku can leverage the Azure Translation API to provide translation in [90 languages](<https://docs.microsoft.com/en-us/azure/cognitive-services/translator/language-support>)

Note

This capability is provided by the “Azure Translation plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Plugin documentation page](<https://www.dataiku.com/product/plugins/nlp-azure-translation/>) for more details

---

## [nlp/deepl-api]

# NLP using Deepl API

The Deepl API integration provides translation between [28 languages](<https://www.deepl.com/docs-api/translating-text/request/>)

Note

This capability is provided by the “Deepl Translation” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [DeepL Translation plugin page](<https://www.dataiku.com/product/plugins/nlp-deepl-translation/>) for more details

---

## [nlp/embedding]

# Text Embedding

Warning

You do not need this for RAG purposes. Please see [Adding Knowledge to LLMs](<../generative-ai/knowledge/index.html>) instead

Text Embedding refers to the process of computing a numerical representation of a piece of text (often a sentence), that can then be used as a feature vector for Machine Learning.

Text Embeddings are computed using large-scale embedding models that generate vectors that are close for related pieces of text.

## Native embedding in Visual Machine Learning

Text embedding is a native feature handling option for text features in Visual ML. Please see [Text variables](<../machine-learning/features-handling/text.html>) for more information. With this method, you can benefit for high quality extraction from text features without any specific configuration or work

## Explicit embedding

Alternatively, you can also use the “Sentence Embedding” plugin. This plugin provides a recipe that allows you to retrieve the text embeddings directly as a vector column. This can be used for further customized processing in code. This can also be used for [similarity search](<https://www.dataiku.com/product/plugins/similarity-search/>)

This feature is only available in English.

Note

This capability is provided by the “sentence-embedding” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Warning

You do not need this plugin for RAG purposes, nor for having text features in VisualML

The plugin contains:

  * A macro that allows you to download pre-trained word embeddings from various models: Word2vec, GloVe, FastText or ELMo.

  * A recipe that allows you to use these vectors to compute sentence embeddings. This recipe relies on one of two possible aggregation methods:

    * Simple Average: Averages the word embeddings of a text to get its sentence embedding.

    * SIF embedding: Computes a weighted average of word embeddings, followed by the removal of their first principal component. For more information about SIF, you can refer to this paper or this blogpost.

  * A second recipe that allows you to compute the distance between texts. It first computes text representations like in the previous recipe. Then it computes their distances using one of the following metrics: * Cosine Distance: Computes 1 - cos(x, y) where x and y are the sentences’ word vectors. * Euclidean Distance: Equivalent to L2 distance between two vectors. * Absolute Distance: Equivalent to L1 distance between two vectors. * Earth-Mover Distance: Informally, the minimum cost of turning one word vector into the other. For more details refer to the following Wikipedia article.




### Macro: Download pre-trained embeddings

This macro downloads the specified model’s pre-trained embeddings (Source) into the specified managed folder (Output folder name) of the flow. If the folder doesn’t exist, it will be auto-created.

Available models:

  * Word2vec (English)

  * GloVe (English)

  * FastText (English & French, selectable via Text language)

  * ELMo (English)




Note: Unlike the other models, ELMo produces contextualized word embeddings. This means that the model will process the sentence where a word occurs to produce a context-dependent representation. As a result, ELMo embeddings are better but also slower to compute.

### Compute sentence embedding Recipe

This recipe creates sentence embeddings for the texts of a given column. The sentence embeddings are obtained using pre-trained word embeddings and one of the following two aggregation methods: a simple average aggregation (by default) or a weighted aggregation (so-called SIF embeddings).

  * Select the downloaded pre-trained word embeddings, your dataset with the column(s) containing your texts, an aggregation method and run the recipe!




Note: For SIF embeddings you can set advanced hyper-parameters such as the model’s smoothing parameter and the number of components to extract.

Note: You can also use your own custom word embeddings. To do that, you will need to create a managed folder and put the embeddings in a text file where each line corresponds to a different word embedding in the following format: word emb1 emb2 emb3 … embN where emb are the embedding values. For example, if the word dataiku has a word vector [0.2, 1.2, 1, -0.6] then its corresponding line in the text file should be: dataiku 0.2 1.2 1 -0.6.

### Compute Sentence Similarity Recipe

This recipe takes two text columns and computes their distance. The distance is based on sentence vectors computed using pre-trained word embeddings that are compared using one of three available metrics: cosine distance (default), euclidian distance (L2), absolute distance (L1) or earth-mover distance.

Using this recipe is similar to using the “Compute sentence embeddings” recipe. The only differences are that you will now choose exactly two text columns and you will have the option to choose a distance metric from the list of available distances.

### References

SIF references: Sanjeev Arora, Yingyu Liang and Tengyu Ma, A Simple but Tough-to-Beat Baseline for Sentence Embeddings

Word2vec references: Tomas Mikolov, Kai Chen, Greg Corrado, and Jeffrey Dean. Efficient Estimation of Word Representations in Vector Space. In Proceedings of Workshop at ICLR, 2013.

Tomas Mikolov, Ilya Sutskever, Kai Chen, Greg Corrado, and Jeffrey Dean. Distributed Representations of Words and Phrases and their Compositionality. In Proceedings of NIPS, 2013.

Tomas Mikolov, Wen-tau Yih, and Geoffrey Zweig. Linguistic Regularities in Continuous Space Word Representations. In Proceedings of NAACL HLT, 2013.

GloVe references: Jeffrey Pennington, Richard Socher, and Christopher D. Manning. 2014. GloVe: Global Vectors for Word Representation.

FastText references: P. Bojanowski, E. Grave, A. Joulin, T. Mikolov, Enriching Word Vectors with Subword Information

ELMo references: Matthew E. Peters, Mark Neumann, Mohit Iyyer, Matt Gardner, Christopher Clark, Kenton Lee, Luke Zettlemoyer. Deep contextualized word representations NAACL 2018.

---

## [nlp/google-apis]

# NLP using Google APIs

Dataiku can leverage multiple Google APIs to provide various NLP capabilities

## Google Cloud NLP

The Google Cloud NLP integration provides multiple NLP capabilities:

  * [Sentiment Analysis](<sentiment-analysis.html>) in [16 languages](<https://cloud.google.com/natural-language/docs/languages#sentiment_analysis>)

  * [Named Entities Extraction](<named-entities.html>) in [11 languages](<https://cloud.google.com/natural-language/docs/languages#entity_analysis>)

  * Text classification in English




Note

This capability is provided by the “Google Cloud NLP” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Google Cloud NLP plugin page](<https://www.dataiku.com/product/plugins/google-cloud-nlp/>) for more details

## Google Cloud Translation

The Google Cloud Translation integration provides translation between [109 languages](<https://cloud.google.com/translate/docs/languages>)

Note

This capability is provided by the “Google Cloud Translation” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Google Cloud Translation plugin page](<https://www.dataiku.com/product/plugins/nlp-google-cloud-translation/>) for more details

---

## [nlp/index]

# Text & Natural Language Processing

A large amount of information is available in the form of text. For example, tweets, emails, survey responses, product reviews and so forth contain information that is written in natural language.

The goal of working with text is to convert it into data that can be useful for analysis. Some applications of text analysis include: sentiment analysis, named entity recognition, summarization, and so forth.

DSS provides numerous NLP capabilities, either through native processing, through locally-running models, or leveraging third party APIs.

In addition, many NLP capabilities can now be more efficiently performed using LLMs. Please see [Generative AI and LLM Mesh](<../generative-ai/index.html>) for more details.

---

## [nlp/key-phrase-extraction]

# Key phrase extraction

Key phrase extraction allows you to quickly identify the main concepts in text.

Dataiku provides several key phrase extraction capabilities

## AWS Comprehend

The AWS Comprehend integration provides key phrase extraction in 13 languages.

Please see [NLP using AWS APIs](<aws-apis.html>) for more details

## Azure Cognitive Services

The Azure Cognitive Services integration provides key phrase extraction in 16 languages.

Please see [NLP using Azure APIs](<azure-apis.html>) for more details

---

## [nlp/language-detection]

# Language Detection

Language Detection is the process of finding out the language of a piece of text

Dataiku provides multiple language detection capabilities

## Native language detection

The native language detection capability of Dataiku provides language detection in [114 languages](<https://github.com/dataiku/dss-plugin-nlp-preparation/blob/ae7691471e1b98aa8c714a97dec963ae5193996b/custom-recipes/nlp-preparation-language-detection/recipe.json#L52>)

It is an offline capability, meaning that it does not leverage a 3rd party API.

Note

This capability is provided by the “Text Preparation” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Text preparation plugin page](<https://www.dataiku.com/product/plugins/nlp-preparation/>) for detailed documentation.

## AWS Comprehend

The AWS Comprehend integration provides language detection in 100 languages

Please see [NLP using AWS APIs](<aws-apis.html>) for more details

## Azure Cognitive Services

The Azure Cognitive Services integration provides language detection in 108 languages

Please see [NLP using Azure APIs](<azure-apis.html>) for more details

---

## [nlp/named-entities]

# Named Entities Extraction

Named Entities Extraction is the process of recognizing various kinds of entities (persons, cities, diseases, …) in documents, and tagging each text with the named entities that it contains.

Dataiku provides several named entities extraction capabilities

## Native entity extraction

The native entity extraction capability of Dataiku extracts information about people, dates, places, …

It is an offline capability, meaning that it does not leverage a 3rd party API.

Extraction is provided in [7 languages](<https://github.com/dataiku/dss-plugin-nlp-named-entity-recognition/blob/19a682f579670dec0675b9997fb706dfc4e0dc71/custom-recipes/named-entity-recognition-extract/recipe.json#L61>)”

Note

This capability is provided by the “Named Entities Recognition” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Named entity recognition plugin page](<https://www.dataiku.com/product/plugins/named-entity-recognition/>) for detailed documentation.

## AWS Comprehend

The AWS Comprehend integration provides named entity recognition in 12 languages.

Please see [NLP using AWS APIs](<aws-apis.html>) for more details

## Azure Cognitive Services

The Azure Cognitive Services integration provides named entity recognition in 23 languages.

Please see [NLP using Azure APIs](<azure-apis.html>) for more details

## Google Cloud NLP

The Google Cloud NLP integration provides named entity recognition in 11 languages.

Please see [NLP using Google APIs](<google-apis.html>) for more details

---

## [nlp/ocr]

# OCR (Optical Character recognition)

OCR is the process of recognizing, parsing and extracting text from images.

Dataiku leverages two open source OCR engines:

  * The [Tesseract library](<https://tesseract-ocr.github.io/>) to perform OCR in [100 languages](<https://tesseract-ocr.github.io/tessdoc/Data-Files/>)

  * The EasyOCR library




It is an offline capability, meaning that it does not leverage a 3rd party API.

Note

This capability is provided by the “Text extraction and OCR” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [OCR plugin page](<https://www.dataiku.com/product/plugins/tesseract-ocr/>) for detailed instructions

---

## [nlp/ontology-tagging]

# Ontology Tagging with Text Analysis

Ontology Tagging is the process of extracting explicitly defined content and entities from text.

It can tag documents matching keywords within a corpus of text documents.

## Setup

This capability is provided by the “Text Analysis” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

To use this plugin with containers, you will need to customize the base image. Please follow [this documentation](<https://doc.dataiku.com/dss/latest/containers/custom-base-images.html#add-a-dockerfile-fragment>) with this [Dockerfile fragment](<https://github.com/dataiku/dss-plugin-nlp-analysis/blob/main/Dockerfile>).

## How to use

Let’s assume that you have a Dataiku project with a dataset containing raw text data in one or more languages. This text data must be stored as a single column in the dataset, with one row for each document.

To create your first recipe, navigate to the Flow, click on the **\+ RECIPE** button and access the **Natural Language Processing** menu. If your dataset is selected, you can directly find the plugin on the right panel.

### Ontology tagging recipe

**Assign tags to documents matching keywords within a corpus of text documents**

#### Inputs

  * Document dataset: Dataset with a text column, and potentially a language column.

  * Ontology dataset




You will also need to create or import a dataset composed of the following columns:

>   * A column such as “keywords”, which are the terms that will be searched for in the corpus of documents.
> 
>   * A column such as “tags”, which are the tags you wish to assign to your documents. A tag can be linked to a set of keywords.
> 
>   * (Optional) a column such as “category”, which are the categories you wish to group your tags by. All tags without categories will later be classified as “uncategorized”.
> 
> 


#### Settings

  * **Document dataset**

>     * _Text column_ : name of the column containing the text to be tagged
> 
>     * _Language_ : the language parameter lets you choose among 59 supported languages <ontology-supported-languages> if your documents are monolingual. Else, the Multilingual option will let you specify an additional Language column, that is expected to contain the [ISO 639-1 language code](<https://www.dataiku.com/product/plugins/nlp-analysis/#supported-languages-ontology-tagging>) corresponding to each document.

  * **Ontology dataset**

>     * _Tag column_ : name of the tag column
> 
>     * _Keyword column_ : name of the keyword column
> 
>     * (Optional) Category column: name of the category column

  * **Matching Parameters** You can widen the search by activating the following matching parameters:

>     * Ignore case: To match documents by ignoring case (e.g will try to match _guitar_ , _Guitar_ , _GUITAR_)
> 
>     * Ignore diacritics: To match documents by ignoring diacritics marks such as accents, cedillas, tildes
> 
>     * Lemmatize: To match documents by simplifying words to their lemma form (e.g., going → go, mice → mouse).

  * **Output parameters** There are three available output formats. All the output formats preserve the initial data of the input dataset

>     * Default output “One row per document (array style)”: A row for each document, with additional columns:
>
>>       * tag_list column: the assigned tags of the document (array-like). If you gave a _category column_ in the [matching parameters](<https://www.dataiku.com/product/plugins/nlp-analysis/#matching-parameters>), you will have one column per category, each one containing a list of associated tags
>> 
>>       * tag_keywords column: the keywords that matched the document (array-like)
>> 
>>       * tag_sentences column: the concatenated sentences that matched the keywords (string-like).
> 
>     * Output “One row per document (JSON style)”: A row for each document, with additional output columns:
>
>>       * tag_json_full column: a dictionary with details about occurrences for each tag, matched keywords for each tag, and the sentences where they appear. (object-like)
>> 
>>       * If you gave a category column in the matching parameters, you will also have a column tag_json_categories (object-like), which is a simplified version of the previous dictionary containing categories (keys) and associated tags (values)
> 
>     * Output “One row per match”: A row per match per document. This mode may create an output dataset with more rows than the input dataset, as you may have multiple matching keywords in a single document, which would result in duplication of that document in the output for each matched keyword. In this case, the additional output columns would be:
>
>>       * tag column: a tag column (string-like)
>> 
>>       * keyword column: a keyword column (string-like)
>> 
>>       * sentence column: a sentence column (string-like)
>> 
>>       * category column: (Optional) a category column (string-like)




#### Output

**Dataset with assigned tags for each document**.

## Supported languages

Here are the 59 supported languages and their ISO 639-1:

  * Afrikaans (af) *

  * Albanian (sq) *

  * Arabic (ar) *

  * Armenian (hy) *

  * Basque (eu) *

  * Bengali (bn)

  * Bulgarian (bg) *

  * Catalan (ca)

  * Chinese (simplified) (zh) *

  * Croatian (hr)

  * Czech (cs)

  * Danish (da)

  * Dutch (nl)

  * English (en)

  * Estonian (et) *

  * Finnish (fi) *

  * French (fr)

  * German (de)

  * Greek (el)

  * Gujarati (gu) *

  * Hebrew (he) *

  * Hindi (hi) *

  * Hungarian (hu)

  * Icelandic (is) *

  * Indonesian (id)

  * Irish (ga) *

  * Italian (it)

  * Japanese (ja) *

  * Kannada (kn) *

  * Latvian (lv) *

  * Lithuanian (lt)

  * Luxembourgish (lb)

  * Macedonian (mk)

  * Malayalam (ml) *

  * Marathi (mr) *

  * Nepali (ne) *

  * Norwegian Bokmål (nb)

  * Persian (fa)

  * Polish (pl)

  * Portuguese (pt)

  * Romanian (ro)

  * Russian (ru)

  * Sanskrit (sa) *

  * Serbian (sr)

  * Sinhala (si) *

  * Slovak (sk) *

  * Slovenian (sl) *

  * Spanish (es)

  * Swedish (sv)

  * Tagalog (tl)

  * Tamil (ta) *

  * Tatar (tt) *

  * Telugu (te) *

  * Thai (th) *

  * Turkish (tr)

  * Ukrainian (uk) *

  * Urdu (ur)

  * Vietnamese (vi) *

  * Yoruba (yo) *




* Lemmatization not supported

---

## [nlp/sentiment-analysis]

# Sentiment Analysis

Sentiment Analysis estimates the sentiment polarity (positive/negative) of text data

Dataiku provides several sentiment analysis capabilities

## LLM-based sentiment analysis

The [LLM Mesh](<../generative-ai/index.html>) has a native recipe for performing LLM-based sentiment analysis. This is usually the most performance option.

Please see our [Tutorial](<https://knowledge.dataiku.com/latest/genai/text-processing/tutorial-classification.html>) for detailed information.

## Offline sentiment analysis

The native sentiment analysis capability provides sentiment analysis in English.

It is an offline capability, meaning that it does not leverage a 3rd party API.

Note

This capability is provided by the “Sentiment analysis” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

### Usage instructions

If you have a Dataiku DSS project with a dataset containing text data in English. This text data must be stored in a dataset, inside a text column, with one row for each document.

Navigate to the Flow, click on the + RECIPE button and access the Natural Language Processing menu. If your dataset is selected, you can directly find the plugin on the right panel, and click “Sentiment analysis”

  * The Text column parameter lets you choose the column of your input dataset containing text data.

  * Choose your Sentiment scale.

    * Either binary (0 = negative, 1 = positive) or 1 to 5 (1 = highly negative, 5 = highly positive).

    * Default is binary.

  * Choose whether to Output predictions as numbers and/or Output predictions as categories.

    * These parameters depend on the chosen Sentiment scale.

    * Default is yes to both.

  * Choose whether to Output confidence scores for the predicted sentiment polarity.

    * Confidence scores are from 0 to 1.

    * Default is false.




Output dataset will be a copy of the input dataset with additional columns on predicted sentiment polarity

## AWS Comprehend

The AWS Comprehend integration provides sentiment analysis in 12 languages.

Please see [NLP using AWS APIs](<aws-apis.html>) for more details

## Azure Cognitive Services

The Azure Cognitive Services integration provides sentiment analysis in 13 languages.

Please see [NLP using Azure APIs](<azure-apis.html>) for more details

## Google Cloud NLP

The Google Cloud NLP integration provides sentiment analysis in 16 languages.

Please see [NLP using Google APIs](<google-apis.html>) for more details

---

## [nlp/speech-to-text]

# Speech-to-Text

Speech to Text is the process of transforming audio files to text.

This capability is provided by the “Speech to Text” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

Dataiku provides several speech-to-text capabilities

## Native speech-to-text

The native speech to text capability of Dataiku provides speech-to-text in English. It is an offline capability, meaning that it does not leverage a 3rd party API.

Warning

The underlying DeepSpeech library requires the [following system libraries](<https://deepspeech.readthedocs.io/en/latest/SUPPORTED_PLATFORMS.html#supported-platforms-for-inference>):

>   * `libstdc++6 >= 4.8.5`
> 
>   * `glibc >= 2.19`
> 
> 


libstdc++6 >= 4.8 is not installed by default on several Linux distributions. If that is the case, you will need _sudo_ access to the server hosting your Dataiku instance in order to upgrade libstdc++6.

### Download DeepSpeech model macro

This macro downloads the weights of the [DeepSpeech pre-trained model](<https://github.com/mozilla/DeepSpeech/releases/tag/v0.9.1>) into a folder in your project. Note that this model has been trained on American English speech data.

### Speech to Text recipe

This recipe takes as input the folder with DeepSpeech weights from the macro and a folder with audio files of .WAV format. The output will be a dataset with two columns: the audio file path and the associated transcription.

## AWS Transcribe

The AWS Transcribe integration provides speech-to-text extraction in 40 languages

Please see [NLP using AWS APIs](<aws-apis.html>) for more details

---

## [nlp/spell-checking]

# Spell checking

Spell checking is the process of correcting typos in text

Dataiku provides offline spell checking

## Offline spell checking

The native spell checking capability of Dataiku provides spell checking in [37 languages](<https://github.com/dataiku/dss-plugin-nlp-preparation/blob/ae7691471e1b98aa8c714a97dec963ae5193996b/custom-recipes/nlp-preparation-spell-checker/recipe.json#L75>) .

It is an offline capability, meaning that it does not leverage a 3rd party API.

Note

This capability is provided by the “Text Preparation” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Text preparation plugin page](<https://www.dataiku.com/product/plugins/nlp-preparation/>) for detailed documentation.

---

## [nlp/summarization]

# Text summarization

Text summarization is the process of generating a summary of documents which could be considered as too long.

Extractive summarization extracts the most relevant sentences from the document. Abstractive summarization generates a summary that is not extracted from the original document, but fully generated.

## LLM-based summarization

The [LLM Mesh](<../generative-ai/index.html>) has a native recipe for performing LLM-based summarization. This is usually the most performant option.

Please see our [Tutorial](<https://knowledge.dataiku.com/latest/genai/text-processing/tutorial-summarization.html>) for detailed information.

## Offline Text Summarization

The native text summarization capability of Dataiku provides language-agnostic extractive summarization using open-source models. It is an offline capability, meaning that it does not leverage a 3rd party API.

Note

This capability is provided by the “Text Summarization” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

This plugin provides a tool for doing automatic text summarization.

It uses extractive summarization methods, which means that the summary will be a number of extracted sentences from the original input text. This can be used for example to turn customer reviews or long reports into shorter texts.

The plugin comes with a single recipe that uses one of three possible models:

  * Text Rank[1], which builds a graph of every sentence of the input text, where each text is linked to its most similar sentences, before running the PageRank algorithm to select the most relevant sentences for a summary.

  * KL-Sum[2], which summarizes texts by decreasing a KL Divergence criterion. In practice, it selects sentences based on how much they have the same word distribution as the original text.

  * LSA[3], which uses Latent Semantic Allocation (LSA) to summarize texts. Basically, this starts by looking for the most important topics of the input text then keeps the sentences that best represent these topics.




### How To Use

First, make sure your text data is stored in a dataset, inside a text column, with one row for each document. Using the recipe is straightforward: select your dataset and the column containing your documents. Then, select a method, set the number of desired sentences and run the recipe!

### References

  * Rada Mihalcea and Paul Tarau, TextRank: Bringing Order into Texts.

  * Aria Haghighi and Lucy Vanderwende, Exploring Content Models for Multi-Document Summarization.

  * Josef Steinberger and Karel Ježek, Using Latent Semantic Analysis in Text Summarization and Summary Evaluation.

---

## [nlp/text-cleaning]

# Text cleaning

Text cleaning is the process of cleaning up, simplifying text, and preparing it for further analysis

Dataiku provides offline text cleaning

## Offline text cleaning

The native text cleaning capability of Dataiku provides capabilities in [59 languages](<https://github.com/dataiku/dss-plugin-nlp-preparation/blob/ae7691471e1b98aa8c714a97dec963ae5193996b/custom-recipes/nlp-preparation-cleaning/recipe.json#L51>)

It provides:

  * Tokenization

  * Filtering of punctuation, stop words, and multiple other categories

  * Lemmatization




It is an offline capability, meaning that it does not leverage a 3rd party API.

Note

This capability is provided by the “Text Preparation” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Text preparation plugin page](<https://www.dataiku.com/product/plugins/nlp-preparation/>) for detailed documentation.

---

## [nlp/text-extraction]

# Text extraction

Dataiku can extract text from several document types:

  * PDF

  * DOCX

  * HTML

  * Metadata




The Text extraction recipe takes as input a folder of various file types (pdf, docx, html, etc) and outputs a dataset with three columns: filename, extracted text and error messages when it failed to extract any text.

For some input formats, it is possible to extract text in chunks, with an extra metadata column containing section info. This will output one row by unit of document. A unit can be a page in a PDF file or a section in a DOCX, HTML, Markdown, etc. These metadata can either be in plain text or JSON format.

Note

This capability is provided by the “Text extraction and OCR” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [OCR plugin page](<https://www.dataiku.com/product/plugins/tesseract-ocr/>) for detailed instructions

---

## [nlp/text-in-ml]

# Machine Learning with Text features

Text can be used as regular features in Dataiku’s [Visual Machine Learning](<../machine-learning/index.html>)

Please see [Text variables](<../machine-learning/features-handling/text.html>) for more details

---

## [nlp/translation]

# Translation

Translation is about translating text content from one language to another.

Dataiku provides several translation capabilities

## Native translation

The native translation capability of Dataiku provides translation between [100 languages](<https://huggingface.co/facebook/m2m100_418M/>) using open-source models.

It is an offline capability, meaning that it does not leverage a 3rd party API.

Note

This capability is provided by the “Offline Translation” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

Please see our [Offline Translation plugin page](<https://www.dataiku.com/product/plugins/offline-translation/>) for detailed documentation.

## AWS Translation

The AWS Translation integration provides translation between 71 languages

Please see [NLP using AWS APIs](<aws-apis.html>) for more details

## Azure Translation

The Azure Translation integration provides translation between 90 languages

Please see [NLP using Azure APIs](<azure-apis.html>) for more details

## Google Cloud Translation

The Google Cloud Translation integration provides translation between 109 languages

Please see [NLP using Google APIs](<google-apis.html>) for more details

## Deepl Translation

The Deepl Translation integration provides translation between 28 languages

Please see [NLP using Deepl API](<deepl-api.html>) for more details