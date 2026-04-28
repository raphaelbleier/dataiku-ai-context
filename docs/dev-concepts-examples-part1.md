# Dataiku Docs — dev-concepts-examples

## [concepts-and-examples/llm-mesh]

# LLM Mesh  
  
The LLM Mesh is the common backbone for Enterprise Generative AI Applications. For more details on the LLM Mesh features of Dataiku, please visit [Generative AI and LLM Mesh](<https://doc.dataiku.com/dss/latest/generative-ai/index.html> "\(in Dataiku DSS v14\)").

The LLM Mesh API allows you to:

  * Send completion and embedding queries to all LLMs supported by the LLM Mesh

  * Stream responses from LLMs that support it

  * Query LLMs using multimodal inputs (image and text)

  * Query the LLM Mesh from LangChain code

  * Interact with knowledge banks, and perform semantic search

  * Create a fine-tuned saved model




## Read LLM Mesh metadata

### List and get LLMs

By default, [`list_llms()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms") returns a list of [`DSSLLMListItem`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMListItem> "dataikuapi.dss.llm.DSSLLMListItem").

List and get LLMs
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

### List LLMs with a purpose

In addition, you can list LLM with a defined purpose.

List LLMs with a purpose
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms(purpose="TEXT_EMBEDDING_EXTRACTION")
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

## Perform completion queries on LLMs

### Your first simple completion query

This sample receives an LLM and uses a completion query to ask the LLM to “write a haiku on GPT models.”
    
    
    import dataiku
    
    # Fill with your LLM id. For example, if you have an OpenAI connection called "myopenai", LLM_ID can be "openai:myopenai:gpt-4o"
    # To get the list of LLM ids, you can use project.list_llms() (see above)
    LLM_ID = ""
    
    # Create a handle for the LLM of your choice
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    
    # Create and run a completion query
    completion = llm.new_completion()
    completion.with_message("Write a haiku on GPT models")
    resp = completion.execute()
    
    # Display the LLM output
    if resp.success:
        print(resp.text)
    
    # GPT, a marvel,
    # Deep learning's symphony plays,
    # Thoughts dance, words unveil.
    

### Multi-turn and system prompts

You can have multiple messages in the `completion` object, with roles
    
    
    completion = llm.new_completion()
    
    # First, put a system prompt
    completion.with_message("You are a poetic assistant who always answers in haikus", role="system")
    
    # Then, give an example, or send the conversation history
    completion.with_message("What is a transformer", role="user")
    completion.with_message("Transformers, marvels\nOf the deep learning research\nAttention, you need", role="assistant")
    
    # Then, the last query of the user
    completion.with_message("What's your name", role="user")
    
    resp = completion.execute()
    

### Multimodal input

Multimodal input is supported on a subset of the LLMs in the LLM Mesh:

  * OpenAI

  * Bedrock Anthropic Claude

  * Azure AI Foundry

  * Azure OpenAI

  * Gemini Pro



    
    
    completion = llm.new_completion()
    
    with open("myimage.jpg", "rb") as f:
        image = f.read()
    
    mp_message = completion.new_multipart_message()
    mp_message.with_text("The image represents an artwork. Describe it as it would be described by art critics")
    mp_message.with_inline_image(image)
    
    # Add it to the completion request
    mp_message.add()
    
    resp = completion.execute()
    

### Completion settings

You can set settings on the completion query
    
    
    completion = llm.new_completion()
    completion.with_message("Write a haiku on GPT models")
    
    completion.settings["temperature"] = 0.7
    completion.settings["topK"] = 10
    completion.settings["topP"] = 0.3
    completion.settings["maxOutputTokens"] = 2048
    completion.settings["stopSequences"] = [".", "\n"]
    completion.settings["presencePenalty"] = 0.6
    completion.settings["frequencyPenalty"] = 0.9
    completion.settings["logitBias"] = {
      1489: 60,  # apply a logit bias of 60 on token value "1489"
    }
    completion.settings["logProbs"] = True
    completion.settings["topLogProbs"] = 3
    
    resp = completion.execute()
    

### Response streaming
    
    
    from dataikuapi.dss.llm import DSSLLMStreamedCompletionChunk, DSSLLMStreamedCompletionFooter
    
    completion = llm.new_completion()
    completion.with_message("Please explain special relativity")
    
    for chunk in completion.execute_streamed():
        if isinstance(chunk, DSSLLMStreamedCompletionChunk):
            print("Received text: %s" % chunk.data["text"])
        elif isinstance(chunk, DSSLLMStreamedCompletionFooter):
            print("Completion is complete: %s" % chunk.data)
    

## Text embedding
    
    
    import dataiku
    
    EMBEDDING_MODEL_ID = "" # Fill with your embedding model id, for example: openai:myopenai:text-embedding-3-small
    
    # Create a handle for the embedding model of your choice
    client = dataiku.api_client()
    project = client.get_default_project()
    emb_model = project.get_llm(EMBEDDING_MODEL_ID)
    
    # Create and run an embedding query
    txt = "The quick brown fox jumps over the lazy dog."
    emb_query = emb_model.new_embeddings()
    emb_query.add_text(txt)
    emb_resp = emb_query.execute()
    
    # Display the embedding output
    print(emb_resp.get_embeddings())
    
    # [[0.000237455,
    #   -0.103262354,
    #   ...
    # ]]
    
    

## Reranking
    
    
    import dataiku
    
    RERANKING_MODEL_ID = "" # Fill with your reranking model id, for example: azureaifoundry:myazureaifoundry:Cohere-rerank-v4.0-fast
    
    # Create a handle for the reranking model of your choice
    client = dataiku.api_client()
    project = client.get_default_project()
    rerank_model = project.get_llm(RERANKING_MODEL_ID)
    
    # Create and run a reranking query
    reranking_query = rerank_model.new_reranking()
    reranking_query.with_query("What is AI?")
    documents = [
        "Chocolate is a sweet treat made from cocoa beans.",
        "Artificial Intelligence (AI) is the simulation of human intelligence processes by machines, especially computer systems.",
        "An almost intelligent idea is an idea that seems smart but lacks depth.",
    ]
    for document in documents:
        reranking_query.with_document(document)
    response = reranking_query.execute()
    
    # display the reranking results
    print([(doc.index, doc.relevance_score) for doc in response.documents])
    # [(1, 0.88377875), (2, 0.42403036), (0, 0.18335953)]
    
    # Print the reranked documents
    print("Reranked documents:")
    for doc in response.documents:
        print(" - " + documents[doc.index])
    

## Tool calls

Tool calls (sometimes referred to as “function calling”) allow you to augment a LLM with “tools”, functions that it can call and provide the arguments. Your client code can then perform those calls, and provide the output back to the LLM so that it can generate the next response.

Tool calls are supported on the compatible completion models of some LLM connections:

  * OpenAI

  * Azure OpenAI

  * Azure LLM

  * Anthropic Claude

  * Anthropic Claude models on AWS Bedrock connections

  * MistralAI




### Define tools

You can define tools as settings in the completion query. Tool parameters are defined as JSON Schema objects. See the [JSON Schema reference](<https://json-schema.org/understanding-json-schema/>) for documentation about the format.

Tools can also be automatically prepared and invoked from Python code, _e.g._ using Langchain.
    
    
    completion = llm.new_completion()
    completion.settings["tools"] = [
      {
        "type": "function",
        "function": {
          "name": "multiply",
          "description": "Multiply integers",
          "parameters": {
            "type": "object",
            "properties": {
              "a": {
                "type": "integer",
                "description": "The first integer to multiply",
              },
              "b": {
                "type": "integer",
                "description": "The other integer to multiply",
              },
            },
            "required": ["a", "b"],
          }
        }
      }
    ]
    
    completion.with_message("What is 3 * 6 ?")
    resp = completion.execute()
    
    print(resp.tool_calls)
    
    # [{'type': 'function',
    # 'function': {'name': 'multiply', 'arguments': '{"a":3,"b":6}'},
    #   'id': 'call_gEB9fOdroydyxYuRs0Ge6Izg'}]
    

### Response streaming with tool calls

LLM responses which include tool calls can also leverage streaming. Depending on the LLM, response chunks may include **either complete tool calls or partial tool calls**. When the LLM sends partial tool calls, the streamed chunk contains an extra field `index` allowing to reconstruct the whole LLM response.
    
    
    for chunk in completion.execute_streamed():
        if isinstance(chunk, DSSLLMStreamedCompletionChunk):
            if "text" in chunk.data:
                print("Received text: %s" % chunk.data["text"])
            if "toolCalls" in chunk.data:
                print("Received tool call: %s" % chunk.data["toolCalls"])
    
        elif isinstance(chunk, DSSLLMStreamedCompletionFooter):
            print("Completion is complete: %s" % chunk.data)
    

### Provide tool outputs

Tool calls can then be parsed and executed. In order to provide the tool response in the chat messages, use the following methods:
    
    
    import json
    
    # Function to handle the tool call
    def multiply(llm_arguments):
        try:
            json_arguments = json.loads(llm_arguments)
            a = json_arguments["a"]
            b = json_arguments["b"]
            return str(a * b)
        except Exception as e:
            return f"Cannot call the 'multiply' tool: {str(e)}"
    
    tool_calls = resp.tool_calls
    call_id = tool_calls[0]["id"]
    llm_arguments = tool_calls[0]["function"]["arguments"]
    result = multiply(llm_arguments)
    
    completion.with_tool_calls(tool_calls)
    completion.with_tool_output(result, tool_call_id=call_id)
    
    resp = completion.execute()
    
    print(resp.text)
    
    # 3 multiplied by 6 is 18.
    

### Control tool usage

Tool usage can be constrained in the completion settings:
    
    
    completion = llm.new_completion()
    
    # Let the LLM decide whether to call a tool
    completion.settings["toolChoice"] = {"type": "auto"}
    
    # The LLM must call at least one tool
    completion.settings["toolChoice"] = {"type": "required"}
    
    # The LLM must not call any tool
    completion.settings["toolChoice"] = {"type": "none"}
    
    # The LLM must call the tool with name 'multiply'
    completion.settings["toolChoice"] = {"type": "tool_name", "name": "multiply"}
    

## Knowledge Banks (KB)

### List and get KBs

To list the KB present in a project:

List and get KBs
    
    
    import dataiku
    client = dataiku.api_client()
    project = client.get_default_project()
    kb_list = project.list_knowledge_banks()
    

By default, [`list_knowledge_banks()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_knowledge_banks> "dataikuapi.dss.project.DSSProject.list_knowledge_banks") returns a list of [`DSSKnowledgeBankListItem`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem> "dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem"). To get more details:
    
    
    for kb in kb_list:
        print(f"{kb.name} (id: {kb.id})")
    

To get a “core handle” on the KB (i.e. to retrieve a [`KnowledgeBank`](<../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank> "dataiku.KnowledgeBank") object) :
    
    
    KB_ID = "" # Fill with your KB id
    kb_public_api = project.get_knowledge_bank(KB_ID)
    kb_core = kb_public_api.as_core_knowledge_bank()
    

## LangChain integration

Dataiku LLM model objects can be turned into langchain-compatible objects, making it easy to:

  * stream responses

  * run asynchronous queries

  * batch queries

  * chain several models and adapters

  * integrate with the wider langchain ecosystem




### Transforming LLM handles to LangChain model
    
    
    # In this sample, llm is the result of calling project.get_llm() (see above)
    
    # Turn a regular LLM handle into a langchain-compatible one
    langchain_llm = llm.as_langchain_llm()
    
    # Run a single completion query
    langchain_llm.invoke("Write a haiku on GPT models")
    
    # Run a batch of completion queries
    langchain_llm.batch(["Write a haiku on GPT models", "Write a haiku on GPT models in German"])
    
    # Run a completion query and stream the response
    for chunk in langchain_llm.stream("Write a haiku on GPT models"):
        print(chunk, end="", flush=True)
    

See the [langchain documentation](<https://python.langchain.com/docs/tutorials/llm_chain/>) for more details.

You can also turn it into a langchain “chat model”, a specific type of LLM geared towards conversation:
    
    
    # In this sample, llm is the result of calling project.get_llm() (see above)
    
    # Turn a regular LLM handle into a langchain-compatible one
    langchain_llm = llm.as_langchain_chat_model()
    
    # Run a simple query
    langchain_llm.invoke("Write a haiku on GPT models")
    
    # Run a chat query
    from langchain_core.messages import HumanMessage, SystemMessage
    
    messages = [
        SystemMessage(content="You're a helpful assistant"),
        HumanMessage(content="What is the purpose of model regularization?"),
    ]
    langchain_llm.invoke(messages)
    
    # Streaming and chaining
    from langchain_core.prompts import ChatPromptTemplate
    
    prompt = ChatPromptTemplate.from_template("Tell me a joke about {topic}")
    chain = prompt | langchain_llm
    for chunk in chain.stream({"topic": "parrot"}):
        print(chunk.content, end="", flush=True)
    

See the [langchain documentation](<https://python.langchain.com/docs/tutorials/llm_chain/>) for more details.

### Creating Langchain models directly

If running from inside DSS, you can also directly create the Langchain model:
    
    
    from dataiku.langchain.dku_llm import DKULLM, DKUChatModel
    
    langchain_llm = DKUChatModel(llm_id="your llm id") # For example: openai:myopenai:gpt-4o
    

### Response streaming

The LangChain adapter `DKUChatModel` also support streaming of answer:
    
    
    from dataiku.langchain.dku_llm import DKULLM, DKUChatModel
    from langchain_core.messages import HumanMessage, SystemMessage
    
    langchain_llm = DKUChatModel(llm_id="your llm id") # For example: openai:myopenai:gpt-4o
    
    messages = [
        SystemMessage(content="You're a helpful assistant"),
        HumanMessage(content="What is the purpose of model regularization?"),
    ]
    
    for gen in langchain_llm.stream(messages):
        print(gen)
    

### Using knowledge banks as LangChain objects

Core handles allow users to leverage the Langchain library and, through it:

  * query the KB for semantic similarity search

  * combine the KB with an LLM to form a _chain_ and perform complex workflows such as _retrieval-augmented generation_ (RAG).




In practice, core handles expose KBs as a Langchain-native [vector store](<https://python.langchain.com/docs/how_to/#vector-stores>) through two different methods:

  * [`as_langchain_retriever()`](<../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank.as_langchain_retriever> "dataiku.KnowledgeBank.as_langchain_retriever") returns a generic `VectorStoreRetriever` object

  * [`as_langchain_vectorstore()`](<../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank.as_langchain_vectorstore> "dataiku.KnowledgeBank.as_langchain_vectorstore") returns an object whose class corresponds to the KB type. For example, for a FAISS-based KB, you will get a `langchain.vectorstores.faiss.FAISS` object.



    
    
    import dataiku
    client = dataiku.api_client()
    project = client.get_default_project()
    kb_core = project.get_knowledge_bank(KB_ID).as_core_knowledge_bank()
    
    # Return a langchain.vectorstores.base.VectorStoreRetriever
    lc_generic_vs= kb_core.as_langchain_retriever()
    
    # Return an object which type depends on the KB type
    lc_vs = kb_core.as_langchain_vectorstore()
    
    # [...] Move forward with similarity search or RAG 
    

#### Writing documents to a knowledge bank

Core handles allow users to leverage the LangChain library to write documents to the underlying vector store.

In practice, core handles expose the method [`get_writer()`](<../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank.get_writer> "dataiku.KnowledgeBank.get_writer") which allows to get a writer on the said knowledge bank, as a context manager. Such a writer can be used to build a LangChain [vector store](<https://python.langchain.com/docs/how_to/#vector-stores>) that inserts documents into the knowledge bank. The writer will synchronize the vector store content to the knowledge bank automatically upon closing. Make sure you have the `langchain_community` package in your code environment.
    
    
    import dataiku
    from langchain_core.documents import Document
    
    client = dataiku.api_client()
    project = client.get_default_project()
    dss_kb = project.get_knowledge_bank(KB_ID)
    kb_core = dss_kb.as_core_knowledge_bank()
    
    document = Document(page_content="I can write to a knowledge bank!")
    
    with kb_core.get_writer() as writer:
        print(f"Start from folder {writer.folder_path}")
        # writer.clear()  # uncomment to clear the knowledge bank
    
        langchain_vs = writer.as_langchain_vectorstore()
        langchain_vs.add_documents([document])
    

#### Saving knowledge bank metadata

When inserting documents into a vector store, it is possible to specify metadata that can be retrieved later on. To leverage this metadata during retrieval in Dataiku, it is necessary to set the metadata schema in the knowledge bank settings.
    
    
    kb_settings = dss_kb.get_settings()
    kb_settings.set_metadata_schema({
        "source": "string",
        "start_index": "int"
    })
    
    kb_settings.save()
    
    document = Document(
        page_content="I can set metadata",
        metadata={
          "source": "developer-guide",
          "start_index": 1
        }
    )
    
    with kb_core.get_writer() as writer:
        langchain_vs = writer.as_langchain_vectorstore()
        langchain_vs.add_documents([document])
    

#### Setting retrieval content in the document metadata

The write API allows to format retrieval content in the document metadata, so that the knowledge bank can be used for multimodal retrieval.

The image folder of the knowledge bank can be configured in the knowledge bank settings:
    
    
    images_folder = dataiku.Folder(IMAGE_FOLDER_ID)
    images_folder_full_id = f"{images_folder.project_key}.{images_folder.get_id()}"
    
    kb_settings = dss_kb.get_settings()
    kb_settings.set_images_folder(images_folder_full_id)
    kb_settings.save()
    

The retrieval content can be formatted using the knowledge bank writer:
    
    
    from dataikuapi.dss.document_extractor import ManagedFolderDocumentRef
    
    # assumption: the document has only one page
    original_document_ref = ManagedFolderDocumentRef("/path/to/file.pdf", ORIGINAL_DOCUMENT_FOLDER_ID)
    
    with kb_core.get_writer() as writer:
        document = Document(page_content="Summarized text from VLM extraction")
    
        document = (
            writer.get_metadata_formatter()
                .with_original_document_ref(original_document_ref)
                .with_original_document_page_range(1, 1)  # one page
                .with_retrieval_content(image_paths=[
                    "/path/to/screenshot/in/image/folder.jpg"
                ])
                .format_metadata(document)
        )
    
        # writer.clear()  # uncomment to clear the knowledge bank
        langchain_vs = writer.as_langchain_vectorstore()
        langchain_vs.add_documents([document])
    

### Hybrid Search

Combines both similarity search (default behaviour) and keyword search to retrieve more relevant documents. Only supported by Azure AI Search and Elasticsearch; and not compatible with the diversity option.

Additionally, both vector store offer advanced reranking capabilities, to enhance the mix of documents retrieved. Each has its own specific configuration.

#### Azure AI Search
    
    
    import dataiku
    client = dataiku.api_client()
    project = client.get_default_project()
    kb_core = project.get_knowledge_bank(KB_ID).as_core_knowledge_bank()
    
    # 1 using as_langchain_retriever
    azure_classic_retriever = kb_core.as_langchain_retriever(search_type="similarity")
    azure_hybrid_retriever = kb_core.as_langchain_retriever(search_type="hybrid")
    azure_hybrid_advanced_retriever = kb_core.as_langchain_retriever(search_type="semantic_hybrid")
    
    # 2 using as_langchain_vectorstore to get retriever
    azure_classic_retriever = kb_core.as_langchain_vectorstore().as_retriever(
      search_type="similarity")
    azure_hybrid_retriever = kb_core.as_langchain_vectorstore().as_retriever(
      search_type="hybrid")
    azure_hybrid_advanced_retriever = kb_core.as_langchain_vectorstore().as_retriever(
      search_type="semantic_hybrid")
    
    # 3 using as_langchain_vectorstore to perform query
    query = "A text to match some doccuments"
    azure_classic_result = kb_core.as_langchain_vectorstore().similarity_search(query)
    azure_hybrid_result = kb_core.as_langchain_vectorstore().hybrid_search(query)
    azure_hybrid_advanced_result = kb_core.as_langchain_vectorstore().semantic_hybrid_search(query)
    

#### ElasticSearch

For elastic search, since we need the info at db instantiation time, thats why we need to use `vectorstore_kwargs`.

Only `similarity` search type is allowed when using a hybrid strategy.
    
    
    import dataiku
    from elasticsearch.helpers.vectorstore import DenseVectorStrategy
    
    client = dataiku.api_client()
    project = client.get_default_project()
    kb_core = project.get_knowledge_bank(KB_ID).as_core_knowledge_bank()
    
    hybrid_strategy = DenseVectorStrategy(hybrid=True)
    hybrid_advanced_strategy = DenseVectorStrategy(hybrid=True, rrf=True)
    
    # 1 using as_langchain_retriever
    elastic_classic = kb_core.as_langchain_retriever()
    elastic_hybrid = kb_core.as_langchain_retriever(
      vectorstore_kwargs={"strategy": hybrid_strategy})
    elastic_hybrid_advanced = kb_core.as_langchain_retriever(
      vectorstore_kwargs={"strategy": hybrid_advanced_strategy})
    
    # 2 using as_langchain_vectorstore
    elastic_classic = kb_core.as_langchain_vectorstore().as_retriever()
    elastic_hybrid = kb_core.as_langchain_vectorstore(
      strategy=hybrid_strategy).as_retriever(search_type="similarity")
    elastic_hybrid_advanced = kb_core.as_langchain_vectorstore(
      strategy=hybrid_advanced_strategy).as_retriever(search_type="similarity")
    

### Using tool calls

The LangChain chat model adapter supports tool calling, assuming that the underlying LLM supports it too.

The first tab shows how to define tools and bind them to your LLM. The second tab shows how to have a more advanced tool output. In this case, the tool returns a tuple containing a content value that can be used to enhance an LLM’s context and an artifact value for advanced programmatic use.

Simple toolAdvanced tool output
    
    
    import dataiku
    
    from langchain_core.tools import tool
    from langchain_core.messages import HumanMessage
    
    # Define tools
    
    @tool
    def add(a: int, b: int) -> int:
        """Adds a and b."""
        return a + b
    
    @tool
    def multiply(a: int, b: int) -> int:
        """Multiplies a and b."""
        return a * b
    
    tools_by_name = {"add": add, "multiply": multiply}
    tools = [add, multiply]
    tool_choice = {"type": "auto"}
    
    # Get the LangChain chat model, bind it to the tools
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_id = "<your llm id>"  # For example: "openai:myopenai:gpt-4o"
    llm = project.get_llm(llm_id).as_langchain_chat_model()
    llm_with_tools = llm.bind_tools(tools, tool_choice=tool_choice)
    
    # Ask your question
    messages = [HumanMessage("What is 3 * 12? and 6 + 4?")]
    ai_msg = llm_with_tools.invoke(messages)
    messages.append(ai_msg)
    
    # Retrieve tool calls, run them and put the results in the chat messages
    for tool_call in ai_msg.tool_calls:
        tool_name = tool_call["name"]
        selected_tool = tools_by_name[tool_name]
        tool_msg = selected_tool.invoke(tool_call)
        messages.append(tool_msg)
    
    # Get the final response
    ai_msg = llm.invoke(messages)
    ai_msg.content
    # '3 * 12 is 36, and 6 + 4 is 10.'
    
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    from langchain_core.tools import tool
    from langchain_core.messages import ToolMessage
    
    
    OPENAI_CONNECTION_NAME = "" # fill with your LLM id. For example openai:my_connection:gpt-5 
    KB_ID = "" # fill with your Knowledge Bank
    
    @tool(response_format="content_and_artifact")
    def retrieve_context(query: str):
        """Retrieve information to help answer a query.
        The topics covered by this help are economy, inflation, energy, monetary, finances.
        """
        project = dataiku.api_client().get_default_project()
        kb = dataiku.KnowledgeBank(id=KB_ID, project_key=project.project_key)
        vector_store = kb.as_langchain_vectorstore()
        retrieved_docs = vector_store.similarity_search(query, k=2)
        serialized = "\n\n".join(
            (f"Source: {doc.metadata}\nContent: {doc.page_content}")
            for doc in retrieved_docs
        )
        return serialized, retrieved_docs
    
    tools = [retrieve_context]
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            project = dataiku.api_client().get_default_project()
            llm = project.get_llm(OPENAI_CONNECTION_NAME).as_langchain_chat_model(completion_settings=settings)
            llm_with_tools = llm.bind_tools(tools)
    
            messages = [m for m in query["messages"] if m.get("content")]
            iterations = 0
            while True:
                iterations += 1
                if iterations < 10:
                    llm_response = llm_with_tools.invoke(messages)
                else:
                    llm_response = llm.invoke(messages)
    
                if len(llm_response.tool_calls) == 0:
                    return {"text": llm_response.content}
    
                messages.append(llm_response)
                for tool_call in llm_response.tool_calls:
                    if tool_call["name"] == "retrieve_context":
                        tool_output = retrieve_context.invoke(tool_call)
                        messages.append(tool_output)
    

## Fine-tuning

### Create a Fine-tuned LLM Saved Model version

Note

[Visual model fine-tuning](<https://doc.dataiku.com/dss/latest/generative-ai/fine-tuning.html> "\(in Dataiku DSS v14\)") is also available to customers with the _Advanced LLM Mesh_ add-on.

With a Python recipe or notebook, it is possible to fine-tune an LLM from the HuggingFace Hub and save it as a Fine-tuned LLM Saved Model version. This is done with the [`create_finetuned_llm_version()`](<../api-reference/python/ml.html#dataiku.Model.create_finetuned_llm_version> "dataiku.Model.create_finetuned_llm_version") method, which takes an LLM Mesh connection name as input. Settings on this connection like usage permission, guardrails, code environment, or container configuration, will apply at inference time.

The above method must be called on an existing Saved Model. Create one either programmatically (if you are in a notebook and don’t have one yet) with [`create_finetuned_llm_saved_model()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_finetuned_llm_saved_model> "dataikuapi.dss.project.DSSProject.create_finetuned_llm_saved_model") or visually from the Agents & GenAI models list via **+New GenAI Model > Create Fine-tuned LLM** (if you want to do this in a python recipe, its output Saved Model must exist to create the recipe).

Here we fine-tune using several open-source frameworks from HuggingFace: [transformers](<https://huggingface.co/docs/transformers/en/index>), [trl](<https://huggingface.co/docs/trl/index>) & [peft](<https://huggingface.co/docs/peft/index>).

Attention

Note that fine-tuning a local LLM requires significant computational resources (GPU). The code samples below show state-of-the-art techniques to optimize memory usage and processing time, but this depends on your setup and might not always work. Also, beware that the size of your training (and optionally validation) dataset(s) greatly impacts the memory use and storage during fine-tuning.

Microsoft Phi3 Mini 4kMistral 7B V0.2DPO

One can fine-tune a smaller LLM with a small GPU available. [Phi3 Mini](<https://huggingface.co/microsoft/Phi-3-mini-4k-instruct>) is a good example, with “only” 3.8B parameters.

There are many techniques available to reduce memory usage and speed up computation. One of them is called [Low-Rank Adaptation](<https://arxiv.org/abs/2106.09685>). It consists in freezing the weights from the base model and adding new, trainable matrices to the Transformer architecture. It drastically reduces the number of trainable parameters and, hence, the GPU memory requirement.
    
    
    import datasets
    from peft import LoraConfig
    from transformers import AutoModelForCausalLM, AutoTokenizer
    from trl import SFTConfig, SFTTrainer
    
    from dataiku import recipe
    from dataiku.llm.finetuning import formatters
    
    base_model_name = "microsoft/Phi-3-mini-4k-instruct"
    assert base_model_name, ("please specify a base LLM, it must be available"
                             " on HuggingFace hub")
    
    connection_name = "a_huggingface_connection_name"
    assert connection_name, ("please specify a connection name, the fine-tuned "
                             "LLM will be available from this connection")
    
    ##################
    # Initial setup
    ##################
    # Here, we're assuming that your training dataset is composed of 2 columns:
    # the input (user message) and expected output (assistant message).
    # If using a validation dataset, format should be the same.
    user_message_column = "input"
    assistant_message_column = "output"
    columns = [user_message_column, assistant_message_column]
    
    system_message_column = ""  # optional
    static_system_message = ""  # optional
    if system_message_column:
        columns.append(system_message_column)
    
    # Turn Dataiku datasets into SFTTrainer datasets. 
    training_dataset = recipe.get_inputs()[0]
    df = training_dataset.get_dataframe(columns=columns)
    train_dataset = datasets.Dataset.from_pandas(df)
    
    validation_dataset = None
    eval_dataset = None
    if len(recipe.get_inputs()) > 1:
        validation_dataset = recipe.get_inputs()[1]
        df = validation_dataset.get_dataframe(columns=columns)
        eval_dataset = datasets.Dataset.from_pandas(df)
    
    saved_model = recipe.get_outputs()[0]
    
    ##################
    # Model loading
    ##################
    model = AutoModelForCausalLM.from_pretrained(base_model_name)
    tokenizer = AutoTokenizer.from_pretrained(base_model_name)
    
    # It is mandatory to define a formatting function for fine-tuning,
    # because ultimately, the model is fed with only one string:
    # the concatenation of your input columns, in a specific format.
    # Here, we leverage the apply_chat_template method, which depends on
    # the tokenizer. For more information, see
    # https://huggingface.co/docs/transformers/v4.43.3/chat_templating
    formatting_func = formatters.ConversationalPromptFormatter(tokenizer.apply_chat_template,
                                                               *columns)
    
    ##################
    # Fine-tune using SFTTrainer
    ##################
    with saved_model.create_finetuned_llm_version(connection_name) as finetuned_llm_version:
        # feel free to customize, the only requirement is for a transformers model
        # to be created in finetuned_model_version.working_directory
    
        # TRL package offers many possibilities to configure the training job. 
        # For the full list,
        # see https://huggingface.co/docs/transformers/v4.43.3/en/main_classes/trainer#transformers.TrainingArguments
        train_conf = SFTConfig(
            output_dir=finetuned_llm_version.working_directory,
            save_safetensors=True,
            gradient_checkpointing=True,
            num_train_epochs=1,
            logging_steps=5,
            eval_strategy="steps" if eval_dataset else "no",
        )
    
        # LoRA is one of the most popular adapter-based methods to reduce memory-usage
        # and speed up fine-tuning
        peft_conf = LoraConfig(
            r=16,
            lora_alpha=32,
            lora_dropout=0.05,
            task_type="CAUSAL_LM",
            target_modules="all-linear",
        )
    
        trainer = SFTTrainer(
            model=model,
            processing_class=tokenizer,
            train_dataset=train_dataset,
            eval_dataset=eval_dataset,
            formatting_func=formatting_func,
            args=train_conf,
            peft_config=peft_conf,
        )
        trainer.train()
        trainer.save_model()
    
        # Finally, we are logging training information to the Saved Model version
        config = finetuned_llm_version.config
        config["trainingDataset"] = training_dataset.short_name
        if validation_dataset:
            config["validationDataset"] = validation_dataset.short_name
        config["userMessageColumn"] = user_message_column
        config["assistantMessageColumn"] = assistant_message_column
        config["systemMessageColumn"] = system_message_column
        config["staticSystemMessage"] = static_system_message
        config["batchSize"] = trainer.state.train_batch_size
        config["eventLog"] = trainer.state.log_history
    

It is also possible to fine-tune larger models, for instance, Mistral 7B. In that case, quantization can help further reducing the memory footprint. A paper called [QLoRA](<https://arxiv.org/abs/2305.14314>) shows how the LoRA technique can efficiently fine-tune quantized LLMs while limiting the performance loss.
    
    
    import datasets
    import torch
    from peft import LoraConfig
    from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
    from trl import SFTConfig, SFTTrainer
    
    from dataiku import recipe
    from dataiku.llm.finetuning import formatters
    
    base_model_name = "mistralai/Mistral-7B-Instruct-v0.2"
    assert base_model_name, ("please specify a base LLM, it must be available"
                             " on HuggingFace hub")
    
    connection_name = "a_huggingface_connection_name"
    assert connection_name, ("please specify a connection name, the fine-tuned"
                             " LLM will be available from this connection")
    
    ##################
    # Initial setup
    ##################
    # Here, we're assuming that your training dataset is composed of 2 columns:
    # the input (user message) and expected output (assistant message).
    # If using a validation dataset, format should be the same.
    user_message_column = "input"
    assistant_message_column = "output"
    columns = [user_message_column, assistant_message_column]
    
    system_message_column = ""  # optional
    static_system_message = ""  # optional
    if system_message_column:
        columns.append(system_message_column)
    
    # Turn Dataiku datasets into SFTTrainer datasets. 
    training_dataset = recipe.get_inputs()[0]
    df = training_dataset.get_dataframe(columns=columns)
    train_dataset = datasets.Dataset.from_pandas(df)
    
    validation_dataset = None
    eval_dataset = None
    if len(recipe.get_inputs()) > 1:
        validation_dataset = recipe.get_inputs()[1]
        df = validation_dataset.get_dataframe(columns=columns)
        eval_dataset = datasets.Dataset.from_pandas(df)
    
    saved_model = recipe.get_outputs()[0]
    
    ##################
    # Model loading
    ##################
    # Here, we are quantizing the Mistral model. It means that the weights
    # are represented with lower-precision data types (like "Normal Float 4"
    # from the [QLoRA paper](https://arxiv.org/pdf/2305.14314)) to optimize
    # memory usage.
    # We also change the data type used for matrix multiplication to speed
    # up compute.
    # One can of course use double (/nested) quantization, but with inevitable
    # important precision loss.
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.float16,
        bnb_4bit_use_double_quant=False,
    )
    
    model = AutoModelForCausalLM.from_pretrained(base_model_name,
                                                 quantization_config=bnb_config)
    tokenizer = AutoTokenizer.from_pretrained(base_model_name)
    
    tokenizer.pad_token = tokenizer.unk_token
    tokenizer.padding_side = "right"
    
    # It is mandatory to define a formatting function for fine-tuning,
    # because ultimately, the model is fed with only one string:
    # the concatenation of your input columns, in a specific format.
    # Here, we leverage the apply_chat_template method, which depends
    # on the tokenizer. For more information,
    # see https://huggingface.co/docs/transformers/v4.43.3/chat_templating
    
    formatting_func = formatters.ConversationalPromptFormatter(tokenizer.apply_chat_template,
                                                               *columns)
    
    ##################
    # Fine-tune using SFTTrainer
    ##################
    with saved_model.create_finetuned_llm_version(connection_name) as finetuned_llm_version:
        # feel free to customize, the only requirement is for a transformers model
        # to be created in finetuned_model_version.working_directory
    
        # TRL package offers many possibilities to configure the training job. 
        # For the full list, see
        # https://huggingface.co/docs/transformers/v4.43.3/en/main_classes/trainer#transformers.TrainingArguments
        train_conf = SFTConfig(
            output_dir=finetuned_llm_version.working_directory,
            save_safetensors=True,
            gradient_checkpointing=True,
            num_train_epochs=1,
            logging_steps=5,
            eval_strategy="steps" if eval_dataset else "no",
        )
    
        # LoRA is one of the most popular adapter-based methods to reduce memory-usage
        # and speed up fine-tuning
        peft_conf = LoraConfig(
            r=16,
            lora_alpha=32,
            lora_dropout=0.05,
            task_type="CAUSAL_LM",
            target_modules="all-linear",
        )
    
        trainer = SFTTrainer(
            model=model,
            processing_class=tokenizer,
            train_dataset=train_dataset,
            eval_dataset=eval_dataset,
            formatting_func=formatting_func,
            args=train_conf,
            peft_config=peft_conf,
        )
        trainer.train()
        trainer.save_model()
    
        # Finally, we are logging training information to the Saved Model version
        config = finetuned_llm_version.config
        config["trainingDataset"] = training_dataset.short_name
        if validation_dataset:
            config["validationDataset"] = validation_dataset.short_name
        config["userMessageColumn"] = user_message_column
        config["assistantMessageColumn"] = assistant_message_column
        config["systemMessageColumn"] = system_message_column
        config["staticSystemMessage"] = static_system_message
        config["batchSize"] = trainer.state.train_batch_size
        config["eventLog"] = trainer.state.log_history
    

Direct Preference Optimization (DPO) is a stable, efficient, and lightweight way to fine-tune LLMs using preference data. It was introduced in 2023 as a simpler alternative to complex reinforcement learning algorithms.

Instead of training a separate reward model, DPO uses a simple cross-entropy loss function to directly teach the LLM to assign high probability to preferred responses.

In this example, we leverage DPO with both quantization and low-rank adapters (LoRA) from the PEFT framework.

For more on DPO, see the [original paper](<https://arxiv.org/abs/2305.18290>) and [TRL implementation](<https://huggingface.co/docs/trl/main/en/dpo_trainer>). Other RLHF alternatives are also supported, like IPO or [KTO](<https://huggingface.co/docs/trl/main/en/kto_trainer>). For traditional reinforcement learning algorithms, see [PPO](<https://huggingface.co/docs/trl/main/en/ppo_trainer>).

Note

Requirements to run this notebook:

  * Create an updated `INTERNAL_huggingface_local_vX` code environment with:
        
        trl==0.13.0
        datasets==2.21.0
        

  * Use this code env for training & in the selected **HuggingFace Local** connection.



    
    
    import dataiku
    from dataiku import recipe
    from datasets import Dataset
    import torch
    from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
    import huggingface_hub
    from trl import DPOTrainer, DPOConfig
    from peft import LoraConfig
    
    #################################
    # Model & Tokenizer Preparation #
    #################################
    
    MODEL_NAME = "mistralai/Mistral-7B-Instruct-v0.2"
    MODEL_REVISION = "c72e5d1908b1e2929ec8fc4c8820e9706af1f80f"
    connection_name = "a_huggingface_connection_name"
    
    saved_model = recipe.get_outputs()[0]
    
    # Here, we're assuming that your training dataset is composed of 3 columns:  
    # a question (we'll make it a prompt later), the chosen response and rejected response.  
    # If using a validation dataset, format should be the same.  
    train_dataset = Dataset.from_pandas(
        dataiku.Dataset("po_train").get_dataframe()
    )
    validation_dataset = Dataset.from_pandas(
        dataiku.Dataset("po_validation").get_dataframe()
    )
    
    auth_info = dataiku.api_client().get_auth_info(with_secrets=True)
    for secret in auth_info["secrets"]:
        if secret["key"] == "hf_token":
            huggingface_hub.login(token=secret["value"])
            break
    
    quantization_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.float16,
    )
    
    model = AutoModelForCausalLM.from_pretrained(
        MODEL_NAME,
        revision=MODEL_REVISION,
        device_map="auto",
        quantization_config=quantization_config,
        use_cache=False # Because the model will change as it is fine-tuned
    )
    
    tokenizer = AutoTokenizer.from_pretrained(
        MODEL_NAME,
        revision=MODEL_REVISION
    )
    tokenizer.pad_token = tokenizer.eos_token
    
    ####################
    # Data Preparation #
    ####################
    
    def return_prompt_and_responses(samples):
        """
        Transform a batch of examples in a format suitable for DPO.
        """
        return {
            "prompt": [
                f'[INST] Answer the following question in a concise manner: "{question}" [/INST]'
                for question in samples["question"]
            ],
            "chosen": samples["chosen"],
            "rejected": samples["rejected"]
        }
    
    def transform(ds):
        """
        Prepare the datasets in a format suitable for DPO.
        """
        return ds.map(
            return_prompt_and_responses,
            batched=True,
            remove_columns=ds.column_names
        )
    
    train_dataset = transform(train_dataset)
    validation_dataset = transform(validation_dataset)
    
    #####################
    # Fine Tuning Model #
    #####################
    
    with saved_model.create_finetuned_llm_version(connection_name) as finetuned_llm_version:
    
        peft_config = LoraConfig(
            r=16,
            lora_alpha=32,
            lora_dropout=0.05,
            task_type="CAUSAL_LM",
        )
        # Define the training parameters
        training_args = DPOConfig(
            per_device_train_batch_size=4,
            num_train_epochs=1,
            output_dir=finetuned_llm_version.working_directory,
            gradient_checkpointing=True
        )
    
        dpo_trainer = DPOTrainer(
            model,
            None, # The reference model is the base model (without LoRA adaptation)
            peft_config=peft_config,
            args=training_args,
            train_dataset=train_dataset,
            eval_dataset=validation_dataset,
            tokenizer=tokenizer,
        )
    
        # Fine-tune the model
        dpo_trainer.train()
    
        dpo_trainer.save_model()
        config = finetuned_llm_version.config
        config["batchSize"] = dpo_trainer.state.train_batch_size
        config["eventLog"] = dpo_trainer.state.log_history
    

In these examples, we used popular techniques to optimize memory usage and processing time, like LoRA, quantization or gradient checkpointing. Note that the research and open source community is constantly coming up with new ways to make fine-tuning more accessible, while trying to avoid too much performance loss. For more information on other techniques you could try, see for instance the [`Transformers`](<https://huggingface.co/docs/transformers/v4.43.3/performance>) or [`PEFT`](<https://huggingface.co/docs/peft/conceptual_guides/adapter>) documentations.

## OpenAI-compatible API

The OpenAI-compatible API provides an easy way to query the LLM Mesh as it is built on top of the LLM Mesh API and implements the most used parts of OpenAI’s APIs for text generation.

The OpenAI-compatible API allows you to send both Chat Completions API and Responses API queries to all LLMs supported by the LLM Mesh, using the standard OpenAI Python client. This includes, for models that support it:

  * Streamed Chat Completions API responses

  * Streamed Responses API events

  * Multimodal inputs (image and text)

  * Tool calls

  * JSON output mode




The Dataiku OpenAI-compatible public API URL will have the following form:  
`http://<DATAIKU_HOST>/public/api/projects/<PROJECT_KEY>/llms/openai/v1/`

  * `<DATAIKU_HOST>` is the qualifier of your Dataiku instance.

  * `<PROJECT_KEY>` is the identifier of the project containing the LLM Mesh you want to expose. You can retrieve it from your Dataiku designer URL.




Note

For example, let’s say you are working on a Dataiku project using the URL:  
<https://dataiku.mycompany.io/projects/AGENTCONCEPTION/>

Your <DATAIKU_HOST> will be `dataiku.mycompany.io` and your <PROJECT_KEY> will be `AGENTCONCEPTION`  
The Dataiku OpenAI-compatible public API URL in this case will be:  
`http://dataiku.mycompany.io/public/api/projects/AGENTCONCEPTION/llms/openai/v1/`

Use the same base URL for both APIs:

  * `openai_client.chat.completions.create(...)` maps to the LLM Mesh endpoint for the Chat Completions API

  * `openai_client.responses.create(...)` maps to the LLM Mesh endpoint for the Responses API




Attention

Some arguments from the OpenAI’s API reference are not supported.

Chat Completions API request:

  * n

  * response_format

  * seed

  * service_tier

  * parallel_tool_calls

  * user

  * function_call (deprecated)

  * functions (deprecated)




Chat Completions API response:

  * choices.message.refusal

  * choices.logprobs.refusal

  * created

  * service_tier

  * system_fingerprint

  * usage.completion_tokens_details




Responses API request:

Features that rely on OpenAI server-side conversation state are not supported through the LLM Mesh. In particular, you can’t use `previous_response_id`, so you need to send the conversation history back with each request.

### Your first OpenAI-compatible query

Chat Completions APIResponses APIStreaming with the Chat Completions APIStreaming with the Responses API
    
    
    from openai import OpenAI
    
    # Specify the DSS OpenAI-compatible public API URL, e.g. http://<DATAIKU_HOST>/public/api/projects/<PROJECT_KEY>/llms/openai/v1/
    BASE_URL = ""
    # Fill with your DSS API Key
    API_KEY = ""
    
    # Fill with your LLM id. For example, if you have a HuggingFace connection called "myhf", LLM_ID can be "huggingfacelocal:myhf:meta-llama/Meta-Llama-3.1-8B-Instruct:TEXT_GENERATION_LLAMA_2:promptDriven=true"
    # To get the list of LLM ids, you can use openai_client.models.list() or project.list_llms() through the dataiku client 
    LLM_ID = ""
    
    # Create an OpenAI client
    openai_client = OpenAI(
      base_url=BASE_URL,
      api_key=API_KEY
    )
    
    resp = openai_client.chat.completions.create(
      model=LLM_ID,
      messages=[{"role": "user", "content": "Write a haiku on GPT models" }],
    )
    
    if resp and resp.choices:
      print(resp.choices[0].message.content)
    
    # GPT, a marvel,
    # Deep learning's symphony plays,
    # Thoughts dance, words unveil.
    
    
    
    from openai import OpenAI
    
    # Specify the DSS OpenAI-compatible public API URL, e.g. http://<DATAIKU_HOST>/public/api/projects/<PROJECT_KEY>/llms/openai/v1/
    BASE_URL = ""
    # Fill with your DSS API Key
    API_KEY = ""
    
    # Fill with your LLM id. To get the list of LLM ids, you can use openai_client.models.list() or project.list_llms() through the dataiku client
    LLM_ID = ""
    
    # Create an OpenAI client
    openai_client = OpenAI(
      base_url=BASE_URL,
      api_key=API_KEY
    )
    
    resp = openai_client.responses.create(
      model=LLM_ID,
      input="Write a haiku on GPT models",
    )
    
    print(resp.output_text)
    
    # GPT, a marvel,
    # Deep learning's symphony plays,
    # Thoughts dance, words unveil.
    
    
    
    from openai import OpenAI
    
    # Specify the DSS OpenAI-compatible public API URL, e.g. http://<DATAIKU_HOST>/public/api/projects/<PROJECT_KEY>/llms/openai/v1/
    BASE_URL = ""
    # Fill with your DSS API Key
    API_KEY = ""
    
    # Fill with your LLM id. For example, if you have a HuggingFace connection called "myhf", LLM_ID can be "huggingfacelocal:myhf:meta-llama/Meta-Llama-3.1-8B-Instruct:TEXT_GENERATION_LLAMA_2:promptDriven=true"
    # To get the list of LLM ids, you can use openai_client.models.list() or project.list_llms() through the dataiku client 
    LLM_ID = ""
    
    # Create an OpenAI client
    openai_client = OpenAI(
      base_url=BASE_URL,
      api_key=API_KEY
    )
    
    resp = openai_client.chat.completions.create(
      model=LLM_ID,
      messages=[{"role": "user", "content": "Write a haiku on GPT models" }],
      stream=True
    )
    
    for chunk in resp:
        if chunk.choices and chunk.choices[0].delta and chunk.choices[0].delta.content:
            print(chunk.choices[0].delta.content)
    
    # Words
    #  weave
    #  through
    #  the
    #  code
    # ,
    # 
    #
    # Silent
    #  thoughts
    #  brought
    #  into
    #  light
    # ,
      
    
    # M
    # inds
    #  connect
    #  in
    #  spark
    # .
    
    
    
    from openai import OpenAI
    
    # Specify the DSS OpenAI-compatible public API URL, e.g. http://<DATAIKU_HOST>/public/api/projects/<PROJECT_KEY>/llms/openai/v1/
    BASE_URL = ""
    # Fill with your DSS API Key
    API_KEY = ""
    
    # Fill with your LLM id. To get the list of LLM ids, you can use openai_client.models.list() or project.list_llms() through the dataiku client
    LLM_ID = ""
    
    # Create an OpenAI client
    openai_client = OpenAI(
      base_url=BASE_URL,
      api_key=API_KEY
    )
    
    resp = openai_client.responses.create(
      model=LLM_ID,
      input="Write a haiku on GPT models",
      stream=True
    )
    
    for event in resp:
        if event.type == "response.output_text.delta":
            print(event.delta, end="")
    

## Image generation using the LLM Mesh

### Your first image-generation query

This sample shows how to send an image generation query with the LLM Mesh to ask the image generation model to generate an image of a blue bird.
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    # To list the image generation model ids, you can use project.list_llms(purpose="IMAGE_GENERATION")
    IMAGE_GENERATION_MODELS = project.list_llms(purpose="IMAGE_GENERATION")
    
    IMAGE_GENERATION_MODEL_ID = "" # Fill with your image generation model id, for example: openai:my_openai_connection:dall-e-3
    
    # Create a handle for the image generation model of your choice
    img_gen_model = project.get_llm(IMAGE_GENERATION_MODEL_ID)
    
    prompt_text = "Vibrant blue bird in a serene scene on a blooming cherry blossom branch. Tranquil morning sky background with soft pastel colors of dawn, gently blending pinks, purples, and soft oranges. Distant view of a calm lake reflecting the colors of the sky and surrounded by lush greenery."
    
    img_gen_query = img_gen_model.new_images_generation()
    img_gen_query.with_prompt(prompt_text)
    img_gen_resp = img_gen_query.execute()
    image_data = img_gen_resp.first_image()
    
    # You can display the image in your notebook
    from IPython.display import Image, display
    if img_gen_resp.success:
        display(Image(image_data))
    
    # Or you can save the image to a managed folder
    FOLDER_ID = ""  # Enter your managed folder id here
    my_images_folder = dataiku.Folder(FOLDER_ID)
    with my_images_folder.get_writer("blue_bird.png") as writer:
        writer.write(image_data)
    

You can parameterize the query to impact the resulting image or generate more images.

The LLM Mesh maps each parameter to the corresponding parameter for the underlying model provider. Support varies across models/providers, and in particular not all models can generate more than one image.

If you want to generate multiple images with different prompts, you must query the LLM Mesh multiple times.
    
    
    import dataiku
    
    IMAGE_GENERATION_MODEL_ID = "" # Fill with your image generation model id
    
    # Create a handle for the image generation model of your choice
    client = dataiku.api_client()
    project = client.get_default_project()
    img_gen_model = project.get_llm(IMAGE_GENERATION_MODEL_ID)
    generation = img_gen_model.new_images_generation()
    generation.height = 1024
    generation.width = 1024
    generation.seed = 3
    # If the underlying model supports weighted prompts they will be passed with
    # their specified weight, otherwise they will just be merged and sent as a single prompt.
    generation.with_prompt("meat pizza", weight=0.8).with_prompt("rustic wooden table", weight=0.6)
    
    # Not all models or providers support more than one
    generation.images_to_generate = 1
    
    # Regardless of what parameter the underlying provider expects for the image dimensions,
    # when using the LLM Mesh API you can specify either the height and width or the aspect_ratio.
    # The LLM Mesh will do the translation between its API and the underlying provider.
    # Not all models support the same dimensions.
    generation.aspect_ratio = 21 / 9
    
    # The following parameters are not relevant for all models
    generation.with_negative_prompt("tomatoes, basil, green leaf", weight=1)
    generation.fidelity = 0.5 # from 0.1 to 1, how strongly to adhere to prompt
    # valid values depend on the targeted model
    generation.quality = "hd"
    generation.style = "anime"
    
    resp = generation.execute()
    

### Image-to-image query

Some models can generate an image from another image, see [this documentation](<https://doc.dataiku.com/dss/latest/generative-ai/multimodal.html> "\(in Dataiku DSS v14\)").

  * Mask-free variation generates another image guided by a prompt

  * Some models can generate unprompted variations

  * Inpainting uses a mask (either black pixels in a second input image, or transparent pixels on the original image) to fill the corresponding pixels of the input image




Prompted variationUnprompted variationInpainting: mask imageInpainting: mask pixels

In this example, we ask the model for an image variation by passing an image and a prompt using the `MASK_FREE` mode.
    
    
    import dataiku
    
    IMAGE_GENERATION_MODEL_ID = "" # Fill with your image generation model id
    
    img_gen_model = dataiku.api_client().get_default_project().get_llm(IMAGE_GENERATION_MODEL_ID)
    
    # Your image to use as an input.
    # Here we're retrieving it from a managed folder but it could also be an image from a previous generation
    my_images_folder = dataiku.Folder("my_folder_id")
    with my_images_folder.get_download_stream("cat_on_the_beach.png") as img_file:
        input_img_data = img_file.read()
    
    # Create the generation query
    generation = img_gen_model.new_images_generation()
    generation.with_original_image(input_img_data, mode="MASK_FREE", weight=0.3)
    generation.with_prompt("dog on the beach")
    resp = generation.execute()
    

Image-to-image generation with a prompt can also be used with the `CONTROLNET_STRUCTURE` and `CONTROLNET_SKETCH` modes.

In this example, we ask the model for an image variation by sending an image without a prompt.
    
    
    import dataiku
    
    IMAGE_GENERATION_MODEL_ID = "" # Fill with your image generation model id
    
    img_gen_model = dataiku.api_client().get_default_project().get_llm(IMAGE_GENERATION_MODEL_ID)
    
    # Your image to use as an input.
    # Here we're retrieving it from a managed folder but it could also be an image from a previous generation
    my_images_folder = dataiku.Folder("my_folder_id")
    with my_images_folder.get_download_stream("cat_on_the_beach.png") as img_file:
        input_img_data = img_file.read()
    
    # Create the generation query
    generation = img_gen_model.new_images_generation()
    generation.with_original_image(input_img_data, mode="VARY", weight=0.3)
    resp = generation.execute()
    

When using the `MASK_IMAGE_BLACK` mask mode, you need to specify a mask with black pixels to fill.
    
    
    import dataiku
    
    IMAGE_GENERATION_MODEL_ID = "" # Fill with your image generation model id
    
    img_gen_model = dataiku.api_client().get_default_project().get_llm(IMAGE_GENERATION_MODEL_ID)
    
    # Your image to use as an input.
    # Here we're retrieving it from a managed folder but it could also be an image from a previous generation
    my_images_folder = dataiku.Folder("my_folder_id")
    with my_images_folder.get_download_stream("cat_on_the_beach.png") as img_file:
        input_img_data = img_file.read()
    with my_images_folder.get_download_stream("cat_black_mask.png") as img_file:
        black_mask_image_data = img_file.read()
    
    
    # Create the generation query
    generation = img_gen_model.new_images_generation()
    generation.with_original_image(input_img_data, mode="INPAINTING", weight=0.1)
    generation.with_mask("MASK_IMAGE_BLACK", image=black_mask_image_data)
    generation.with_prompt("dog")
    resp = generation.execute()
    

When using the `ORIGINAL_IMAGE_ALPHA` you do not need to specify a mask image. The model will fill the transparent pixels from the original image.
    
    
    import dataiku
    
    IMAGE_GENERATION_MODEL_ID = "" # Fill with your image generation model id
    
    img_gen_model = dataiku.api_client().get_default_project().get_llm(IMAGE_GENERATION_MODEL_ID)
    
    # Your image to use as an input.
    my_images_folder = dataiku.Folder("my_folder_id")
    with my_images_folder.get_download_stream("cat_transparent_background.png") as img_file:
        input_img_data = img_file.read()
    
    # Create the generation query
    generation = img_gen_model.new_images_generation()
    generation.with_original_image(input_img_data, mode="INPAINTING", weight=0.1)
    generation.with_mask("ORIGINAL_IMAGE_ALPHA")
    generation.with_prompt("Beach scene at sunset, with golden sands, gentle waves at the shore.")
    resp = generation.execute()
    

## Reference documentation

### Classes

[`dataiku.KnowledgeBank`](<../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank> "dataiku.KnowledgeBank")(id[, project_key, ...]) | This is a handle to interact with a Dataiku Knowledge Bank flow object  
---|---  
[`dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter`](<../api-reference/python/llm-mesh.html#dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter> "dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter")(...) | Helper class to format vector store documents metadata for usage within Dataiku.  
[`dataiku.core.vector_stores.data.writer.VectorStoreWriter`](<../api-reference/python/llm-mesh.html#dataiku.core.vector_stores.data.writer.VectorStoreWriter> "dataiku.core.vector_stores.data.writer.VectorStoreWriter")(...) | A helper class to write vector store data to the underlying knowledge bank folder.  
[`dataikuapi.dss.document_extractor.ManagedFolderDocumentRef`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.document_extractor.ManagedFolderDocumentRef> "dataikuapi.dss.document_extractor.ManagedFolderDocumentRef")(...) | A reference to a file in a DSS-managed folder.  
[`dataikuapi.dss.llm.DSSLLM`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM> "dataikuapi.dss.llm.DSSLLM")(client, ...) | A handle to interact with a DSS-managed LLM.  
[`dataikuapi.dss.llm.DSSLLMListItem`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMListItem> "dataikuapi.dss.llm.DSSLLMListItem")(client, ...) | An item in a list of llms  
[`dataikuapi.dss.llm.DSSLLMCompletionQuery`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery> "dataikuapi.dss.llm.DSSLLMCompletionQuery")(llm) | A handle to interact with a completion query.  
[`dataikuapi.dss.llm.DSSLLMCompletionsQuery`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionsQuery> "dataikuapi.dss.llm.DSSLLMCompletionsQuery")(llm) | A handle to interact with a multi-completion query.  
[`dataikuapi.dss.llm.DSSLLMCompletionsQuerySingleQuery`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionsQuerySingleQuery> "dataikuapi.dss.llm.DSSLLMCompletionsQuerySingleQuery")() |   
[`dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartMessage`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartMessage> "dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartMessage")(q, role) |   
[`dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartToolOutput`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartToolOutput> "dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartToolOutput")(q, ...) |   
[`dataikuapi.dss.llm.DSSLLMCompletionResponse`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionResponse> "dataikuapi.dss.llm.DSSLLMCompletionResponse")([...]) | Response to a completion  
[`dataikuapi.dss.llm.DSSLLMEmbeddingsQuery`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsQuery> "dataikuapi.dss.llm.DSSLLMEmbeddingsQuery")(...) | A handle to interact with an embedding query.  
[`dataikuapi.dss.llm.DSSLLMEmbeddingsResponse`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsResponse> "dataikuapi.dss.llm.DSSLLMEmbeddingsResponse")(...) | A handle to interact with an embedding query result.  
[`dataikuapi.dss.knowledgebank.DSSKnowledgeBank`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank")(...) | A handle to interact with a DSS-managed knowledge bank.  
[`dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem> "dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem")(...) | An item in a list of knowledge banks  
[`dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings> "dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings")(...) | Settings for a knowledge bank  
[`dataikuapi.dss.langchain.DKUChatModel`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.langchain.DKUChatModel> "dataikuapi.dss.langchain.DKUChatModel")(*args, ...) | Langchain-compatible wrapper around Dataiku-mediated chat LLMs  
[`dataikuapi.dss.langchain.DKULLM`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.langchain.DKULLM> "dataikuapi.dss.langchain.DKULLM")(*args, **kwargs) | Langchain-compatible wrapper around Dataiku-mediated LLMs  
[`dataikuapi.dss.langchain.DKUEmbeddings`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.langchain.DKUEmbeddings> "dataikuapi.dss.langchain.DKUEmbeddings")(...) | Langchain-compatible wrapper around Dataiku-mediated embedding LLMs  
[`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.utils.DSSSimpleFilter`](<../api-reference/python/utils.html#dataikuapi.dss.utils.DSSSimpleFilter> "dataikuapi.dss.utils.DSSSimpleFilter")(operator) | A simplified representation of a DSS filter.  
[`dataikuapi.dss.utils.DSSSimpleFilterOperator`](<../api-reference/python/utils.html#dataikuapi.dss.utils.DSSSimpleFilterOperator> "dataikuapi.dss.utils.DSSSimpleFilterOperator")(value) | Operators for the `DSSSimpleFilter`.  
  
### Functions

[`add`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartMessage.add> "dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartMessage.add")() | Add this message to the completion query  
---|---  
[`add_text`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.add_text> "dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.add_text")(text) | Add text to the embedding query.  
[`as_core_knowledge_bank`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank.as_core_knowledge_bank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank.as_core_knowledge_bank")() | Get the [`dataiku.KnowledgeBank`](<../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank> "dataiku.KnowledgeBank") object corresponding to this knowledge bank  
[`aspect_ratio`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.aspect_ratio> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.aspect_ratio") | 

return:
    The width/height aspect ratio or None if either is not set.  
[`bind_tools`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.langchain.DKUChatModel.bind_tools> "dataikuapi.dss.langchain.DKUChatModel.bind_tools")(tools[, tool_choice, strict, ...]) | Bind tool-like objects to this chat model.  
[`as_langchain_chat_model`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.as_langchain_chat_model> "dataikuapi.dss.llm.DSSLLM.as_langchain_chat_model")(**data) | Create a langchain-compatible chat LLM object for this LLM.  
[`as_langchain_llm`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.as_langchain_llm> "dataikuapi.dss.llm.DSSLLM.as_langchain_llm")(**data) | Create a langchain-compatible LLM object for this LLM.  
[`description`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMListItem.description> "dataikuapi.dss.llm.DSSLLMListItem.description") | 

returns:
    The description of the LLM  
[`execute`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.execute> "dataikuapi.dss.llm.DSSLLMCompletionQuery.execute")() | Run the completion query and retrieve the LLM response.  
[`execute`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.execute> "dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.execute")() | Run the embedding query.  
[`dataikuapi.dss.llm.DSSLLMImageGenerationQuery.execute`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.execute> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.execute")() | Executes the image generation  
[`execute_streamed`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.execute_streamed> "dataikuapi.dss.llm.DSSLLMCompletionQuery.execute_streamed")([collect_response]) | Run the completion query and retrieve the LLM response as streamed chunks.  
[`fidelity`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.fidelity> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.fidelity") | 

return:
    From 0.0 to 1.0, how strongly to adhere to prompt.  
[`first_image`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationResponse.first_image> "dataikuapi.dss.llm.DSSLLMImageGenerationResponse.first_image")([as_type]) | 

param str as_type:
    The type of image to return, 'bytes' for bytes otherwise 'str' for base 64 str.  
[`format_metadata`](<../api-reference/python/llm-mesh.html#dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter.format_metadata> "dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter.format_metadata")(document) | Formats the metadata in the provided document, so that it can be used for retrieval in Dataiku.  
[`get_embeddings`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMEmbeddingsResponse.get_embeddings> "dataikuapi.dss.llm.DSSLLMEmbeddingsResponse.get_embeddings")() | Retrieve vectors resulting from the embeddings query.  
[`get_knowledge_bank`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_knowledge_bank> "dataikuapi.dss.project.DSSProject.get_knowledge_bank")(id) | Get a handle to interact with a specific knowledge bank  
[`get_llm`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_llm> "dataikuapi.dss.project.DSSProject.get_llm")(llm_id) | Get a handle to interact with a specific LLM  
[`get_metadata_formatter`](<../api-reference/python/llm-mesh.html#dataiku.core.vector_stores.data.writer.VectorStoreWriter.get_metadata_formatter> "dataiku.core.vector_stores.data.writer.VectorStoreWriter.get_metadata_formatter")() | Gets the metadata formatter to help writing documents to this vector store.  
[`get_settings`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank.get_settings> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank.get_settings")() | Get the knowledge bank's definition  
[`get_writer`](<../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank.get_writer> "dataiku.KnowledgeBank.get_writer")() | Gets a writer on the latest vector store files on disk.  
[`id`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMListItem.id> "dataikuapi.dss.llm.DSSLLMListItem.id") | 

returns:
    The id of the llm.  
[`images_to_generate`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.images_to_generate> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.images_to_generate") | 

return:
    Number of images to generate per query. Valid values depend on the targeted model.  
[`list_knowledge_banks`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_knowledge_banks> "dataikuapi.dss.project.DSSProject.list_knowledge_banks")([as_type]) | List the knowledge banks of this project  
[`list_llms`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms")([purpose, as_type]) | List the LLM usable in this project  
[`new_completion`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.new_completion> "dataikuapi.dss.llm.DSSLLM.new_completion")() | Create a new completion query.  
[`new_embeddings`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.new_embeddings> "dataikuapi.dss.llm.DSSLLM.new_embeddings")([text_overflow_mode]) | Create a new embedding query.  
[`new_images_generation`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.new_images_generation> "dataikuapi.dss.llm.DSSLLM.new_images_generation")() |   
[`new_multipart_message`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.new_multipart_message> "dataikuapi.dss.llm.DSSLLMCompletionQuery.new_multipart_message")([role]) | Start adding a multipart-message to the completion query.  
[`quality`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.quality> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.quality") | 

return:
    Quality of the image to generate. Valid values depend on the targeted model.  
[`save`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings.save> "dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings.save")() | Saves the settings on the knowledge bank  
[`set_images_folder`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings.set_images_folder> "dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings.set_images_folder")(managed_folder_id[, ...]) | Sets the images folder to use with this knowledge bank.  
[`set_metadata_schema`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings.set_metadata_schema> "dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings.set_metadata_schema")(schema) | Sets the schema for metadata fields.  
[`settings`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.settings> "dataikuapi.dss.llm.DSSLLMCompletionQuery.settings") | 

return:
    The completion query settings.  
[`style`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.style> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.style") | 

return:
    Style of the image to generate. Valid values depend on the targeted model.  
[`success`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionResponse.success> "dataikuapi.dss.llm.DSSLLMCompletionResponse.success") | 

return:
    The outcome of the completion query.  
[`text`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionResponse.text> "dataikuapi.dss.llm.DSSLLMCompletionResponse.text") | 

return:
    The raw text of the LLM response.  
[`tool_calls`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionResponse.tool_calls> "dataikuapi.dss.llm.DSSLLMCompletionResponse.tool_calls") | 

return:
    The tool calls of the LLM response.  
`with_inline_image`(image[, mime_type]) | Add an image part to the multipart message  
[`with_message`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.with_message> "dataikuapi.dss.llm.DSSLLMCompletionQuery.with_message")(message[, role]) | Add a message to the completion query.  
[`with_original_document_page_range`](<../api-reference/python/llm-mesh.html#dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter.with_original_document_page_range> "dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter.with_original_document_page_range")(...) | Adds the page range in the original document.  
[`with_original_document_ref`](<../api-reference/python/llm-mesh.html#dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter.with_original_document_ref> "dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter.with_original_document_ref")(document_ref[, ...]) | Adds the original document information in the metadata.  
[`with_original_image`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.with_original_image> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.with_original_image")(image[, mode, weight]) | Add an image to the generation query.  
[`with_mask`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.with_mask> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.with_mask")(mode[, image]) | Add a mask for edition to the generation query.  
[`with_negative_prompt`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.with_negative_prompt> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.with_negative_prompt")(prompt[, weight]) | Add a negative prompt to the image generation query.  
[`with_prompt`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMImageGenerationQuery.with_prompt> "dataikuapi.dss.llm.DSSLLMImageGenerationQuery.with_prompt")(prompt[, weight]) | Add a prompt to the image generation query.  
[`with_retrieval_content`](<../api-reference/python/llm-mesh.html#dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter.with_retrieval_content> "dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter.with_retrieval_content")([text, image_paths, ...]) | Adds the retrieval content in the metadata. Accepts either  
`with_text`(text) | Add a text part to the multipart message  
[`with_tool_calls`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.with_tool_calls> "dataikuapi.dss.llm.DSSLLMCompletionQuery.with_tool_calls")(tool_calls[, role]) | Add tool calls to the completion query.  
[`with_tool_output`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.with_tool_output> "dataikuapi.dss.llm.DSSLLMCompletionQuery.with_tool_output")(tool_output, tool_call_id) | Add a tool message to the completion query.

---

## [concepts-and-examples/managed-folders]

# Managed folders  
  
Note

There are two main classes related to managed folder handling in Dataiku’s Python APIs:

  * [`dataiku.Folder`](<../api-reference/python/managed-folders.html#dataiku.Folder> "dataiku.Folder") in the `dataiku` package. It was initially designed for usage within DSS in recipes and Jupyter notebooks.

  * [`dataikuapi.dss.managedfolder.DSSManagedFolder`](<../api-reference/python/managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder") in the `dataikuapi` package. It was initially designed for usage outside of DSS.




Both classes have fairly similar capabilities, but we recommend using [`dataiku.Folder`](<../api-reference/python/managed-folders.html#dataiku.Folder> "dataiku.Folder") within DSS.

For more details on the two packages, please see [Getting started](<../getting-started/index.html>)

## Detailed examples

This section contains more advanced examples on Managed Folders.

### Load a model from a remote Managed Folder

If you have a trained model artifact stored remotely (e.g. using a cloud object storage Connection like AWS S3), then you can leverage it in a code Recipe. To do so, you first need to download the artifact and temporarily store it on the Dataiku instance’s local filesystem. The following code sample illustrates an example using a Tensorflow serialized model and assumes that it is stored in a Managed Folder called `spam_detection` alog with the following files:

  * `saved_model.pb`

  * `variables/variables.data-00000-of-00001`

  * `variables/variables.index`



    
    
    import dataiku
    import tensorflow as tf
    from tensorflow.keras.models import load_model
    import os
    import tempfile
    from pathlib import Path
    import shutil
    
    #FOLDER_ID = "" # Managed folder ID containing your model file
    folder = dataiku.Folder(FOLDER_ID)
    model_file = "my_model.keras"
    
    #Create temporary directory in /tmp
    with tempfile.TemporaryDirectory() as tmpdirname:
        #Loop through every file of the TF model and copy it localy to the tmp directory
        for file_name in folder.list_paths_in_partition():
            local_file_path = tmpdirname + file_name
            #Create file localy
            if not os.path.exists(os.path.dirname(local_file_path)):
                os.makedirs(os.path.dirname(local_file_path))
            #Copy file from remote to local
            with folder.get_download_stream(file_name) as f_remote, open(local_file_path,'wb') as f_local:
                shutil.copyfileobj(f_remote,f_local)
    
        #Load model from local repository
        model = tf.keras.models.load_model(os.path.join(tmpdirname, model_file))
    

## Reference documentation

Use the following class to interact with managed folders in Python recipes and notebooks. For more information see [Managed folders](<https://doc.dataiku.com/dss/latest/connecting/managed_folders.html>) and [Usage in Python](<https://doc.dataiku.com/dss/latest/connecting/managed_folders.html#usage-in-python>) for usage examples of the Folder API.

### Classes

[`dataiku.Folder`](<../api-reference/python/managed-folders.html#dataiku.Folder> "dataiku.Folder")(lookup[, project_key, ...]) | Handle to interact with a folder.  
---|---  
[`dataikuapi.dss.managedfolder.DSSManagedFolder`](<../api-reference/python/managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder")(...) | A handle to interact with a managed folder on the DSS instance.  
[`dataikuapi.dss.managedfolder.DSSManagedFolderSettings`](<../api-reference/python/managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolderSettings> "dataikuapi.dss.managedfolder.DSSManagedFolderSettings")(...) | Base settings class for a DSS managed folder.  
  
### Functions

[`get_download_stream`](<../api-reference/python/managed-folders.html#dataiku.Folder.get_download_stream> "dataiku.Folder.get_download_stream")(path) | Get a file-like object that allows you to read a single file from this folder.  
---|---  
[`list_paths_in_partition`](<../api-reference/python/managed-folders.html#dataiku.Folder.list_paths_in_partition> "dataiku.Folder.list_paths_in_partition")([partition]) | Gets the paths of the files for the given partition.

---

## [concepts-and-examples/meanings]

# Meanings  
  
The API offers methods to retrieve the list of meanings and their definition, to create a new meaning or update an existing one.

## Listing meanings

The list of all user-defined meanings can be fetched with the [`list_meanings()`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_meanings> "dataikuapi.DSSClient.list_meanings") method of the [`DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient").
    
    
    client.list_meanings()
    

## Creating a meaning

The [`dataikuapi.DSSClient.create_meaning()`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_meaning> "dataikuapi.DSSClient.create_meaning") method can be used to create new meanings.
    
    
    # Creating a declarative meaning
    client.create_meaning("meaning_1", "Test meaning", "DECLARATIVE",
            description="Test meaning description"
    )
    
    # Creating a value list meaning
    client.create_meaning("meaning_2", "Test meaning", "VALUES_LIST",
            description="Test meaning",
            values=["mercury","venus","earth","mars","jupiter","saturn","uranus","neptune"],
            normalizationMode="LOWERCASE"
    )
    
    # Creating a value mapping meaning
    client.create_meaning("meaning_3", "Test meaning", "VALUES_MAPPING",
            mappings=[
                    {"from": "0", "to": "no"   },
                    {"from": "1", "to": "yes"  },
                    {"from": "2", "to": "maybe"}
            ]
    )
    
    # Creating a pattern meaning
    client.create_meaning("meaning_4", "Test meaning", "PATTERN", pattern="[A-Z]+")
    

## Editing a meaning

Existing meanings can be fetched by calling the [`dataikuapi.DSSClient.get_meaning()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_meaning> "dataikuapi.DSSClient.get_meaning") method with the meaning ID. It returns a meaning handle that can be used to get or set the meaning’s definition with [`get_definition()`](<../api-reference/python/meanings.html#dataikuapi.dss.meaning.DSSMeaning.get_definition> "dataikuapi.dss.meaning.DSSMeaning.get_definition") and [`set_definition()`](<../api-reference/python/meanings.html#dataikuapi.dss.meaning.DSSMeaning.set_definition> "dataikuapi.dss.meaning.DSSMeaning.set_definition"), as follows:
    
    
    meaning = client.get_meaning("meaning_1")
    definition = meaning.get_definition()
    definition['label'] = "New label"
    definition['description'] = "New description"
    meaning.set_definition(definition)
    

## Assigning a meaning to a column

Meanings can be assigned to columns by editing the schema of their dataset and setting the `meaning` field of the column to the ID of the desired meaning.
    
    
    dataset = client.get_project("TEST_PROJECT").get_dataset("TEST_DATASET")
    schema = dataset.get_schema()
    schema['columns'][2]['meaning'] = "meaning_1"
    dataset.set_schema(schema)
    

## Reference documentation

### Classes

[`dataikuapi.dss.meaning.DSSMeaning`](<../api-reference/python/meanings.html#dataikuapi.dss.meaning.DSSMeaning> "dataikuapi.dss.meaning.DSSMeaning")(client, id) | A user-defined meaning on the DSS instance  
---|---  
  
### Functions

[`create_meaning`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_meaning> "dataikuapi.DSSClient.create_meaning")(id, label, type[, ...]) | Create a meaning, and return a handle to interact with it  
---|---  
[`get_definition`](<../api-reference/python/meanings.html#dataikuapi.dss.meaning.DSSMeaning.get_definition> "dataikuapi.dss.meaning.DSSMeaning.get_definition")() | Get the meaning's definition.  
[`get_meaning`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_meaning> "dataikuapi.DSSClient.get_meaning")(id) | Get a handle to interact with a specific user-defined meaning  
[`list_meanings`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_meanings> "dataikuapi.DSSClient.list_meanings")() | List all user-defined meanings on the DSS instance  
[`set_definition`](<../api-reference/python/meanings.html#dataikuapi.dss.meaning.DSSMeaning.set_definition> "dataikuapi.dss.meaning.DSSMeaning.set_definition")(definition) | Set the meaning's definition.

---

## [concepts-and-examples/metrics]

# Metrics and checks  
  
Note

There are two main parts related to handling of metrics and checks in Dataiku’s Python APIs:

  * [`dataiku.core.metrics.ComputedMetrics`](<../api-reference/python/metrics.html#dataiku.core.metrics.ComputedMetrics> "dataiku.core.metrics.ComputedMetrics") in the `dataiku` package. It was initially designed for usage within DSS

  * [`dataikuapi.dss.metrics.ComputedMetrics`](<../api-reference/python/metrics.html#dataikuapi.dss.metrics.ComputedMetrics> "dataikuapi.dss.metrics.ComputedMetrics") in the `dataikuapi` package. It was initially designed for usage outside of DSS.




Both classes have fairly similar capabilities

For more details on the two packages, please see [Concepts and examples](<index.html>)

## Add metric on a column
    
    
    def add_metrics_probes_col_stats(probes, aggregation, column):
        """
        Add a metrics of column statistics to probes
        :param probes: the list of existing probes
        :param aggregation: which aggregation is used
        :param column: the column dataset to use
    
         Usage example:
    
        .. code-block:: python
    
            settings: DSSDatasetSettings = dataset.get_settings()
            metrics: ComputedMetrics = settings.get_raw()['metrics']
            add_metrics_probes_col_stats(metrics['probes'], 'MIN', 'purchase_amount')
    
        """
    
        types_index = next((index for (index, d) in enumerate(probes) if d["type"] == 'col_stats'), None)
        if types_index:
            types_value = probes[types_index]
            existing_aggregation = types_value['configuration']['aggregates']
            to_append = {'aggregated': aggregation, 'column': column}
            if to_append not in existing_aggregation:
                existing_aggregation.append(to_append)
        else:
            probes.append({'computeOnBuildMode': 'NO',
                           'configuration': {'aggregates': [{'aggregated': aggregation,
                                                             'column': column}
                                                            ]},
                           'enabled': True,
                           'meta': {'level': 2, 'name': 'Columns statistics'},
                           'type': 'col_stats'})
    
    
    
    settings = dataset.get_settings()
    metrics = settings.get_raw()['metrics']
    add_metrics_probes_col_stats(metrics['probes'], 'MIN', 'purchase_amount')
    

## Make a defined metric visible
    
    
    def add_displayed_state_to_metrics(displayed_state, type_to_add, function_to_add, column=""):
        """
        Add to the metrics used a new one
        :param displayed_state: the previous state
        :param type_to_add: which kind of metrics
        :param function_to_add: function that been used
        :param column: column if any
    
        Usage example:
        .. code-block:: python
    
            settings: DSSDatasetSettings = dataset.get_settings()
            metrics: ComputedMetrics = settings.get_raw()['metrics']
            add_displayed_state_to_metrics(metrics['displayedState'], 'col_stats', 'MIN', 'purchase_amount')
    
        """
    
        line_to_add = type_to_add + ':' + function_to_add
        if column:
            line_to_add += ':' + column
        if line_to_add not in displayed_state['metrics']:
            displayed_state['metrics'].append(line_to_add)
    
    
    
    settings = dataset.get_settings()
    metrics = settings.get_raw()['metrics']
    add_displayed_state_to_metrics(metrics['displayedState'], 'col_stats', 'MIN', 'purchase_amount')
    

## Define a new numerical check
    
    
    def add_metrics_checks_numeric_range(checks, label, which, parameters):
        """
        Add a metric if only it doesn't exist
        :param checks: Existing checks
        :param label: Label for the check
        :param which: Probe for the check
        :param parameters: Operation to check
        
        Usage example:
        .. code-block:: python
    
            settings: DSSDatasetSettings = dataset.get_settings()
            checks = settings.get_raw()['metricsChecks']
            CHECK_RECORDS_NAME = 'Number of records should be greater than 100'
            add_metrics_checks_numeric_range(checks, CHECK_RECORDS_NAME, 'records:COUNT_RECORDS',
                                             [('minimum', 100)])
    
        """
    
        is_already_present = next((check for check in checks['checks'] if check['type'] == 'numericRange' and
                                   check['metricId'] == which), None)
        if not is_already_present:
            new_metric = {
                'computeOnBuildMode': 'PARTITION',
                'meta': {
                    'label': label,
                    'name': 'Value in range'
                },
                'metricId': which,
                'maximum': 0.0,
                'maximumEnabled': False,
                'minimum': 0.0,
                'minimumEnabled': False,
                'softMaximum': 0.0,
                'softMaximumEnabled': False,
                'softMinimum': 0.0,
                'softMinimumEnabled': False,
                'type': 'numericRange'
            }
            for parameter in parameters:
                new_metric[parameter[0]] = parameter[1]
                new_metric[parameter[0] + 'Enabled'] = True
            checks['checks'].append(new_metric)
    
    
    
    setting = dataset.get_settings()
    checks = settings.get_raw()['metricsChecks']
    CHECK_RECORDS_NAME = 'Number of records should be greater than 100'
    add_metrics_checks_numeric_range(checks, CHECK_RECORDS_NAME, 'records:COUNT_RECORDS',
                                             [('minimum', 100)])
    

## Make a defined check visible
    
    
    def set_check_visible(checks, label):
        """
        Add a defined checks to the displayed state (so the user can see it in the GUI)
        :param checks: the metricsChecks part of the dataset settings
        :param label: label to use
        :return:
        
        Usage example:
        .. code-block:: python
    
            settings: DSSDatasetSettings = dataset.get_settings()
            CHECK_RECORDS_NAME = 'Number of records should be greater than 100'
            checks = settings.get_raw()['metricsChecks']
            set_check_visible(checks, CHECK_RECORDS_NAME)
    
        """
    
        displayed_state = checks['displayedState']
        displayed = displayed_state['checks']
        if label not in displayed:
            displayed.append(label)
    
    
    
    settings = dataset.get_settings()
    CHECK_RECORDS_NAME = 'Number of records should be greater than 100'
    checks = settings.get_raw()['metricsChecks']
    set_check_visible(checks, CHECK_RECORDS_NAME)
    

## Retrieve metric results
    
    
    def get_metrics(dataset):
        """
        Compute and return all used metrics (only id) for a particular dataset
        :param dataset: the dataset
    
        Usage example:
        .. code-block:: python
    
            last_metrics = dataset.get_last_metric_values()
            metrics = get_metrics(dataset)
            for metric in metrics:
                metric_value = last_metrics.get_metric_by_id(metric)
                if metric_value and metric_value['lastValues']:
                    result[metric] = {
                        'initialValue': metric_value['lastValues'][0]['value']
                    }
        """
        dataset.compute_metrics()
        last_metrics = dataset.get_last_metric_values().get_raw()
        return_list = list()
        id_metrics = list(map((lambda metric: metric['metric']['id']),
                              filter(lambda metric: metric['displayedAsMetric'], last_metrics['metrics'])))
        return_list.extend(id_metrics)
        return return_list
    
    
    
    result = {}
    
    last_metrics = dataset.get_last_metric_values()
    metrics = get_metrics(dataset)
    for metric in metrics:
        metric_value = last_metrics.get_metric_by_id(metric)
        if metric_value and metric_value['lastValues']:
            result[metric] = {
                'initialValue': metric_value['lastValues'][0]['value']
            }
            
    print(result)
    

## Retrieve check results
    
    
    def get_checks_used(settings):
        """
        Get the list of all used checks for a dataset
        :param settings: the settings of the dataset
        :return: the list of all checks used for this dataset
        """
        return list(map((lambda check: 'check:CHECK:'+check), settings['metricsChecks']['displayedState']['checks']))
    
    
    
    def get_checks(dataset):
        """
        Compute and return all used checks (only id) for a particular dataset
        :param dataset: the dataset
    
        Usage example:
        .. code-block:: python
    
            last_metrics = dataset.get_last_metric_values()
            checks = get_checks(dataset)
            for check in checks:
                check_value = last_metrics.get_metric_by_id(metric)
                if check_value and check_value['lastValues']:
                    result[metric] = {
                        'initialValue': metric_value['lastValues'][0]['value']
                    }
        """
        dataset.compute_metrics()
        dataset.run_checks()
        return_list = list()
        return_list.extend(get_checks_used(dataset.get_settings().get_raw()))
        return return_list
    

## Reference documentation

### Classes

[`dataiku.core.metrics.ComputedMetrics`](<../api-reference/python/metrics.html#dataiku.core.metrics.ComputedMetrics> "dataiku.core.metrics.ComputedMetrics")(raw) | Handle to the metrics of a DSS object and their last computed value  
---|---  
[`dataiku.core.metrics.MetricDataPoint`](<../api-reference/python/metrics.html#dataiku.core.metrics.MetricDataPoint> "dataiku.core.metrics.MetricDataPoint")(raw) | A value of a metric, on a partition  
[`dataiku.core.metrics.ComputedChecks`](<../api-reference/python/metrics.html#dataiku.core.metrics.ComputedChecks> "dataiku.core.metrics.ComputedChecks")(raw) | Handle to the checks of a DSS object and their last computed value  
[`dataikuapi.dss.metrics.ComputedMetrics`](<../api-reference/python/metrics.html#dataikuapi.dss.metrics.ComputedMetrics> "dataikuapi.dss.metrics.ComputedMetrics")(raw) | Handle to the metrics of a DSS object and their last computed value  
  
### Functions

[`compute_metrics`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.compute_metrics> "dataikuapi.dss.dataset.DSSDataset.compute_metrics")([partition, metric_ids, probes]) | Compute metrics on a partition of this dataset.  
---|---  
[`get_last_metric_values`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_last_metric_values> "dataikuapi.dss.dataset.DSSDataset.get_last_metric_values")([partition]) | Get the last values of the metrics on this dataset  
[`get_settings`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_settings> "dataikuapi.dss.dataset.DSSDataset.get_settings")() | Get the settings of this dataset as a `DSSDatasetSettings`, or one of its subclasses.  
[`get_raw`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDatasetSettings.get_raw> "dataikuapi.dss.dataset.DSSDatasetSettings.get_raw")() | Get the raw dataset settings as a dict.  
[`run_checks`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.run_checks> "dataikuapi.dss.dataset.DSSDataset.run_checks")([partition, checks]) | Run checks on a partition of this dataset.

---

## [concepts-and-examples/ml]

# Visual Machine learning  
  
Through the public API, the Python client allows you to automate all the aspects of the lifecycle of machine learning models.

  * Creating a visual analysis and ML task

  * Tuning settings

  * Training models

  * Inspecting model details and results

  * Deploying saved models to Flow and retraining them




## Concepts

In DSS, you train models as part of a _visual analysis_. A visual analysis is made of a preparation script, and one or several _ML Tasks_.

A ML Task is an individual section in which you train models. A ML Task is either a prediction of a single target variable, or a clustering.

The ML API allows you to manipulate ML Tasks, and use them to train models, inspect their details, and deploy them to the Flow.

Once deployed to the Flow, the _Saved model_ can be retrained by the usual build mechanism of DSS.

A ML Task has settings, which control:

  * Which features are active

  * The preprocessing settings for each features

  * Which algorithms are active

  * The hyperparameter settings (including grid searched hyperparameters) for each algorithm

  * The settings of the grid search

  * Train/Test splitting settings

  * Feature selection and generation settings




## Usage samples

### The whole cycle

This examples create a prediction task, enables an algorithm, trains it, inspects models, and deploys one of the model to Flow
    
    
    # client is a DSS API client
    
    p = client.get_project("MYPROJECT")
    
    # Create a new ML Task to predict the variable "target" from "trainset"
    mltask = p.create_prediction_ml_task(
        input_dataset="trainset",
        target_variable="target",
        ml_backend_type='PY_MEMORY', # ML backend to use
        guess_policy='DEFAULT' # Template to use for setting default parameters
    )
    
    # Wait for the ML task to be ready
    mltask.wait_guess_complete()
    
    # Obtain settings, enable GBT, save settings
    settings = mltask.get_settings()
    settings.set_algorithm_enabled("GBT_CLASSIFICATION", True)
    settings.save()
    
    # Start train and wait for it to be complete
    mltask.start_train()
    mltask.wait_train_complete()
    
    # Get the identifiers of the trained models
    # There will be 3 of them because Logistic regression and Random forest were default enabled
    ids = mltask.get_trained_models_ids()
    
    for id in ids:
        details = mltask.get_trained_model_details(id)
        algorithm = details.get_modeling_settings()["algorithm"]
        auc = details.get_performance_metrics().get("auc", None)
    
        print("Algorithm=%s AUC=%s" % (algorithm, auc))
    
    # Let's deploy the first model
    model_to_deploy = ids[0]
    
    ret = mltask.deploy_to_flow(model_to_deploy, "my_model", "trainset")
    
    print("Deployed to saved model id = %s train recipe = %s" % (ret["savedModelId"], ret["trainRecipeName"]))
    

The methods for creating prediction and clustering ML tasks are defined at [`create_prediction_ml_task()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_prediction_ml_task> "dataikuapi.dss.project.DSSProject.create_prediction_ml_task") and [`create_clustering_ml_task()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_clustering_ml_task> "dataikuapi.dss.project.DSSProject.create_clustering_ml_task").

### Obtaining a handle to an existing ML Task

When you create these ML tasks, the returned [`dataikuapi.dss.ml.DSSMLTask`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask") object will contain two fields `analysis_id` and `mltask_id` that can later be used to retrieve the same [`DSSMLTask`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask") object
    
    
    # client is a DSS API client
    
    p = client.get_project("MYPROJECT")
    mltask = p.get_ml_task(analysis_id, mltask_id)
    

### Tuning feature preprocessing

#### Enabling and disabling features
    
    
    # mltask is a DSSMLTask object
    
    settings = mltask.get_settings()
    
    settings.reject_feature("name_of_not_useful_feature")
    settings.use_feature("name_of_useful_feature")
    
    settings.save()
    

#### Changing advanced parameters for a feature
    
    
    # mltask is a DSSMLTask object
    
    settings = mltask.get_settings()
    
    # Use impact coding rather than dummy-coding
    fs = settings.get_feature_preprocessing("myfeature")
    fs["category_handling"] = "IMPACT"
    
    # Impute missing with most frequent value
    fs["missing_handling"] = "IMPUTE"
    fs["missing_impute_with"] = "MODE"
    
    settings.save()
    

### Tuning algorithms

#### Global parameters for hyperparameter search

This sample shows how to modify the parameters of the search to be performed on the hyperparameters.
    
    
    # mltask is a DSSMLTask object
    
    settings = mltask.get_settings()
    
    hp_search_settings = settings.get_hyperparameter_search_settings()
    
    # Set the search strategy either to "GRID", "RANDOM" or "BAYESIAN"
    hp_search_settings.strategy = "RANDOM"
    
    # Alternatively use a setter, either set_grid_search
    # set_random_search or set_bayesian_search
    hp_search_settings.set_random_search(seed=1234)
    
    # Set the validation mode either to "KFOLD", "SHUFFLE" (or accordingly their
    # "TIME_SERIES"-prefixed counterpart) or "CUSTOM"
    hp_search_settings.validation_mode = "KFOLD"
    
    # Alternatively use a setter, either set_kfold_validation, set_single_split_validation
    # or set_custom_validation
    hp_search_settings.set_kfold_validation(n_folds=5, stratified=True)
    
    # Save the settings
    settings.save()
    

#### Algorithm specific hyperparameter search

This sample shows how to modify the settings of the Random Forest Classification algorithm, where two kinds of hyperparameters (multi-valued numerical and single-valued) are introduced.
    
    
    # mltask is a DSSMLTask object
    
    settings = mltask.get_settings()
    
    rf_settings = settings.get_algorithm_settings("RANDOM_FOREST_CLASSIFICATION")
    
    
    # rf_settings is an object representing the settings for this algorithm.
    # The 'enabled' attribute indicates whether this algorithm will be trained.
    # Other attributes are the various hyperparameters of the algorithm.
    
    # The precise hyperparameters for each algorithm are not all documented, so let's
    # print the dictionary keys to see available hyperparameters.
    # Alternatively, tab completion will provide relevant hints to available hyperparameters.
    print(rf_settings.keys())
    
    # Let's first have a look at rf_settings.n_estimators which is a multi-valued hyperparameter
    # represented as a NumericalHyperparameterSettings object
    print(rf_settings.n_estimators)
    
    # Set multiple explicit values for "n_estimators" to be explored during the search
    rf_settings.n_estimators.definition_mode = "EXPLICIT"
    rf_settings.n_estimators.values = [100, 200]
    # Alternatively use the set_values setter
    rf_settings.n_estimators.set_explicit_values([100, 200])
    
    # Set a range of values for "n_estimators" to be explored during the search
    rf_settings.n_estimators.definition_mode = "RANGE"
    rf_settings.n_estimators.range.min = 10
    rf_settings.n_estimators.range.max = 100
    rf_settings.n_estimators.range.nb_values = 5  # Only relevant for grid-search
    # Alternatively, use the set_range setter
    rf_settings.n_estimators.set_range(min=10, max=100, nb_values=5)
    
    # Let's now have a look at rf_settings.selection_mode which is a single-valued hyperparameter
    # represented as a SingleCategoryHyperparameterSettings object.
    # The object stores the valid options for this hyperparameter.
    print(rf_settings.selection_mode)
    
    # Features selection mode is not multi-valued so it's not actually searched during the
    # hyperparameter search
    rf_settings.selection_mode = "sqrt"
    
    # Save the settings
    settings.save()
    

The next sample shows how to modify the settings of the Logistic Regression classification algorithm, where a new kind of hyperparameter (multi-valued categorical) is introduced.
    
    
    # mltask is a DSSMLTask object
    
    settings = mltask.get_settings()
    
    logit_settings = settings.get_algorithm_settings("LOGISTIC_REGRESSION")
    
    # Let's have a look at logit_settings.penalty which is a multi-valued categorical
    # hyperparameter represented as a CategoricalHyperparameterSettings object
    print(logit_settings.penalty)
    
    # List currently enabled values
    print(logit_settings.penalty.get_values())
    
    # List all possible values
    print(logit_settings.penalty.get_all_possible_values())
    
    # Set the values for the "penalty" hyperparameter to be explored during the search
    logit_settings.penalty = ["l1", "l2"]
    # Alternatively use the set_values setter
    logit_settings.penalty.set_values(["l1", "l2"])
    
    # Save the settings
    settings.save()
    

### Exporting a model documentation

This sample shows how to generate and download a model documentation from a template.

See [Model Document Generator](<https://doc.dataiku.com/dss/latest//machine-learning/model-document-generator.html>) for more information.
    
    
    # mltask is a DSSMLTask object
    
    details = mltask.get_trained_model_details(id)
    
    # Launch the model document generation by either
    # using the default template for this model by calling without argument
    # or specifying a managed folder id and the path to the template to use in that folder
    future = details.generate_documentation(FOLDER_ID, "path/my_template.docx")
    
    # Alternatively, use a custom uploaded template file
    with open("my_template.docx", "rb") as f:
        future = details.generate_documentation_from_custom_template(f)
    
    # Wait for the generation to finish, retrieve the result and download the generated
    # model documentation to the specified file
    result = future.wait_for_result()
    export_id = result["exportId"]
    
    details.download_documentation_to_file(export_id, "path/my_model_documentation.docx")
    

## Using a model in a Python recipe or notebook

Once a Saved Model has been deployed to the Flow, the normal way to use it is to use scoring recipes.

However, you can also use the [`dataiku.Model`](<../api-reference/python/ml.html#dataiku.Model> "dataiku.Model") class in a Python recipe or notebook to directly score records.

This method has a number of limitations:

  * It cannot be used together with containerized execution

  * It is not compatible with Partitioned models




RegularLatency-optimized

By default, the predictor is full-featured and geared towards scoring dataframes.

`predictor.predict()` lets you score and, if needed, get the explanations associated with each prediction.
    
    
      import dataiku
    
      m = dataiku.Model(my_model_id)
      with m.get_predictor() as predictor:
        scored_df = predictor.predict(my_df_to_score) # faster if you don't need explanations
        scored_explained_df = predictor.predict(my_df_to_score, with_explanations=True, explanation_method="ICE", n_explanations=3)
    

Say you want to infer a single record, or a couple of records. If your model is compatible with [python export](<https://doc.dataiku.com/dss/latest/machine-learning/models-export.html#python-export> "\(in Dataiku DSS v14\)"), you can use a more lightweight predictor, that is not as full-featured (e.g. cannot compute prediction explanations) but may load faster. If your model is not compatible, it will automatically fallback to the regular predictor.
    
    
      import dataiku
    
      m = dataiku.Model(my_model_id)
      with m.get_predictor(optimize="LATENCY") as predictor:
        predictor.predict(my_df_to_score[:5])
    

## Detailed examples

This section contains more advanced examples using ML Tasks and Saved Models.

### Deploy best MLTask model to the Flow

After training several models in a ML Task you can programmatically deploy the best one by creating a new Saved Model or updating an existing one. In the following example:

  * The `deploy_with_best_model()` function creates a new Saved Model with the input MLTask’s best model

  * The `update_with_best_model()` function updates an existing Saved Model with the MLTask’s best model.




Both functions rely on [`dataikuapi.dss.ml.DSSMLTask`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask") and [`dataikuapi.dss.savedmodel.DSSSavedModel`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel").
    
    
    def get_best_model(project, analysis_id, ml_task_id, metric):
        analysis = project.get_analysis(analysis_id)
        ml_task = analysis.get_ml_task(ml_task_id)
        trained_models = ml_task.get_trained_models_ids()
        trained_models_snippets = [ml_task.get_trained_model_snippet(m) for m in trained_models]
        # Assumes that for your metric, "higher is better"
        best_model_snippet = max(trained_models_snippets, key=lambda x:x[metric])
        best_model_id = best_model_snippet["fullModelId"]
        return ml_task, best_model_id
    
    
    def deploy_with_best_model(project,
        analysis_id,
        ml_task_id,
        metric,
        saved_model_name,
        training_dataset):
        """Create a new Saved Model in the Flow with the 'best model' of a MLTask.
        """
    
        ml_task, best_model_id = get_best_model(project,
                                                analysis_id,
                                                ml_task_id,
                                                metric)
        ml_task.deploy_to_flow(best_model_id,
                               saved_model_name,
                               training_dataset)
    
    def update_with_best_model(project,
                               analysis_id,
                               ml_task_id,
                               metric,
                               saved_model_name,
                               activate=True):
        """Update an existing Saved Model in the Flow with the 'best model' 
           of a MLTask.
        """
        ml_task, best_model_id = get_best_model(project,
                                                analysis_id,
                                                ml_task_id,
                                                metric)
        training_recipe_name = f"train_{saved_model_name}"
        ml_task.redeploy_to_flow(model_id=best_model_id,
                                 recipe_name=training_recipe_name,
                                 activate=activate)
    

### List details of all Saved Models

You can retrieve, for each Saved Model in a Project, the current model algorithm and performances. In the following example, the `get_project_saved_models()` function outputs a Python dictionary with several details on the current activeversions of all Saved Models in the target Project.
    
    
    def explore_saved_models(client=None, project_key=None):
        """List saved models of a project and give details on the active versions.
        Args:
            client: A handle on the target Dataiku instance
            project_key: A string representing the target project key
        Returns:
            smdl_list: A dict with all saved model ids and perf + algorithm 
                       for the active versions. 
        """
        smdl_list = []
        prj = client.get_project(project_key)
        smdl_ids = [x["id"] for x in prj.list_saved_models()]
        for smdl in smdl_ids:
            data = {}
            obj = prj.get_saved_model(smdl)
            data["version_ids"] = [m["id"] for m in obj.list_versions()]
            active_version_id = obj.get_active_version()["id"]
            active_version_details = obj.get_version_details(active_version_id)
            data["active_version"] = {"id": active_version_id,
                                      "algorithm": active_version_details.details["actualParams"]["resolved"]["algorithm"],
                                      "performance_metrics": active_version_details.get_performance_metrics()}
            smdl_list.append(data)
        return smdl_list
    

### List version details of a given Saved Model

This code snippet allows you to retrieve a summary of all versions of a given Saved Model (algorithm, hyperparameters, performance, features) using [`dataikuapi.dss.savedmodel.DSSSavedModel`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel").
    
    
    import copy
    from dataiku import recipe
    
    def export_saved_model_metadata(project, saved_model_id):
        """
        """
    
        model = project.get_saved_model(saved_model_id)
        output = []
        for version in model.list_versions():
            version_details = model.get_version_details(version["id"])
            version_dict = {}
        
            # Retrieve algorithm and hyperarameters
            resolved = copy.deepcopy(version_details.get_actual_modeling_params()["resolved"])
            version_dict["algorithm"] = resolved["algorithm"]
            del resolved["algorithm"]
            del resolved["skipExpensiveReports"]
            for (key, hyperparameters) in resolved.items():
                for (hyperparameter_key, hyperparameter_value) in hyperparameters.items():
                    version_dict["hyperparameter_%s" % hyperparameter_key] = hyperparameter_value
                
            # Retrieve test performance
            for (metric_key, metric_value) in version_details.get_performance_metrics().items():
                version_dict["test_perf_%s" % metric_key] = metric_value
            
            # Retrieve lineage
            version_dict["training_target_variable"] = version_details.details["coreParams"]["target_variable"]
            split_desc = version_details.details["splitDesc"]
            version_dict["training_train_rows"] = split_desc["trainRows"]
            version_dict["training_test_rows"] = split_desc["testRows"]
            training_used_features = []
            for (key, item) in version_details.get_preprocessing_settings()["per_feature"].items():
                if item["role"] == "INPUT":
                    training_used_features.append(key)
            version_dict["training_used_features"] = ",".join(training_used_features)
            
            # Retrieve training time
            ti = version_details.get_train_info()
            version_dict["training_total_time"] = int((ti["endTime"] - ti["startTime"])/1000)
            version_dict["training_preprocessing_time"] = int(ti["preprocessingTime"]/1000)
            version_dict["training_training_time"] = int(ti["trainingTime"]/1000)
        
            output.append(version_dict)
    
        return output
    

### Retrieve linear model coefficients

You can retrieve the list of coefficient names and values from a Saved Model version for compatible algorithms.
    
    
    def get_model_coefficients(project, saved_model_id, version_id):
        """
        Returns a dictionary with key="coefficient name" and value=coefficient
        """
    
        model = project.get_saved_model(saved_model_id)
        if version_id is None:
            version_id = model.get_active_version().get('id')
        details = model.get_version_details(version_id)
        details_lr = details.details.get('iperf', {}).get('lmCoefficients', {})
        rescaled_coefs = details_lr.get('rescaledCoefs', [])
        variables = details_lr.get('variables',[])
        coef_dict = {var: coef for var, coef in zip(variables, rescaled_coefs)}
        if len(coef_dict)==0:
            print(f"Model {saved_model_id} and version {version_id} does not have coefficients")
        return coef_dict
    

### Export model

You can programmatically export the best version of a Saved Model as either a Python function or a MLFlow model. In the following example, the `get_best_classifier_version()` function returns the best version id of the classifier.

  1. Pass that id to the [`dataikuapi.dss.savedmodel.DSSSavedModel.get_version_details()`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.get_version_details> "dataikuapi.dss.savedmodel.DSSSavedModel.get_version_details") method to get a [`dataikuapi.dss.ml.DSSTrainedPredictionModelDetails`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails") handle.

  2. Then either use [`get_scoring_python()`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_scoring_python> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_scoring_python") or [`get_scoring_mlflow()`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_scoring_mlflow> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_scoring_mlflow") to download the model archive to a given file name in either Python or MLflow, respectively.



    
    
    import dataiku
    
    PROJECT_KEY = 'YOUR_PROJECT_KEY'
    METRIC = 'auc' # or any classification metrics of interest.
    SAVED_MODEL_ID = 'YOUR_SAVED_MODEL_ID'
    FILENAME = 'path/to/model-archive.zip'
    
    
    def get_best_classifier_version(project, saved_model_id, metric):
        """
        This function returns the best version id of a
        given Dataiku classifier model in a project.
        """
    
        model = project.get_saved_model(saved_model_id)
        outcome = []
        
        for version in model.list_versions():    
            version_id = version.get('id')
            version_details = model.get_version_details(version_id)
            perf = version_details.get_raw_snippet().get(metric)
            outcome.append((version_id, perf))
        
        # get the best version id. User reverse=False if 
        # lower metric means better
        best_version_id = sorted(
            outcome, key = lambda x: x[1], reverse=True)[0][0]
        
        return best_version_id
            
    
    
    client = dataiku.api_client()
    project = client.get_project(PROJECT_KEY)
    model = project.get_saved_model(SAVED_MODEL_ID)
    best_version_id = get_best_classifier_version(project, SAVED_MODEL_ID, METRIC)
    version_details = model.get_version_details(best_version_id)
    
    # Export in Python
    version_details.get_scoring_python(FILENAME)
    
    # Export in MLflow format
    version_details.get_scoring_mlflow(FILENAME)
    
    

### Using a Saved Model in a Python recipe or notebook

Once a model has been trained and deployed as a saved model, you typically use scoring recipes or API node in order to use them.

You can however also use the saved model directly in a Python recipe or notebook for performing scoring from your own code.

This comes with several limitations:

  * It only supports models trained with the in-memory engine. It does not support MLlib models.

  * It does not apply the model’s preparation script, if any. It expects as input a dataframe equivalent to the output of the model’s preparation script.

  * It does not support running in containers. Only local execution is supported.




RegularLatency-optimized

By default, the predictor is full-featured and geared towards scoring dataframes.

`predictor.predict()` lets you score and, if needed, get the explanations associated with each prediction.
    
    
      import dataiku
    
      m = dataiku.Model(my_model_id)
      with m.get_predictor() as predictor:
        scored_df = predictor.predict(my_df_to_score) # faster if you don't need explanations
        scored_explained_df = predictor.predict(my_df_to_score, with_explanations=True, explanation_method="ICE", n_explanations=3)
    

Say you want to infer a single record, or a couple of records. If your model is compatible with [python export](<https://doc.dataiku.com/dss/latest/machine-learning/models-export.html#python-export> "\(in Dataiku DSS v14\)"), you can use a more lightweight predictor, that is not as full-featured (e.g. cannot compute prediction explanations) but may load faster. If your model is not compatible, it will automatically fallback to the regular predictor.
    
    
      import dataiku
    
      m = dataiku.Model(my_model_id)
      with m.get_predictor(optimize="LATENCY") as predictor:
        predictor.predict(my_df_to_score[:5])
    

## Reference documentation

### Classes

[`dataiku.Model`](<../api-reference/python/ml.html#dataiku.Model> "dataiku.Model")(lookup[, project_key, ignore_flow]) | Handle to interact with a saved model.  
---|---  
`dataiku.core.saved_model.Predictor`(params, ...) | Object allowing to preprocess and make predictions on a dataframe.  
[`dataiku.core.saved_model.SavedModelVersionMetrics`](<../api-reference/python/ml.html#dataiku.core.saved_model.SavedModelVersionMetrics> "dataiku.core.saved_model.SavedModelVersionMetrics")(...) | Handle to the metrics of a version of a saved model  
[`dataikuapi.dss.ml.DSSClusteringMLTaskSettings`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSClusteringMLTaskSettings> "dataikuapi.dss.ml.DSSClusteringMLTaskSettings")(...) |   
[`dataikuapi.dss.ml.DSSMLTask`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")(client, ...) | A handle to interact with a ML Task for prediction or clustering in a DSS visual analysis.  
[`dataikuapi.dss.ml.DSSMLTaskSettings`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTaskSettings> "dataikuapi.dss.ml.DSSMLTaskSettings")(client, ...) | Object to read and modify the settings of an existing ML task.  
[`dataikuapi.dss.ml.DSSPredictionMLTaskSettings`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSPredictionMLTaskSettings> "dataikuapi.dss.ml.DSSPredictionMLTaskSettings")(...) |   
[`dataikuapi.dss.ml.DSSTimeseriesForecastingMLTaskSettings`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTimeseriesForecastingMLTaskSettings> "dataikuapi.dss.ml.DSSTimeseriesForecastingMLTaskSettings")(...) |   
[`dataikuapi.dss.ml.DSSTrainedClusteringModelDetails`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedClusteringModelDetails> "dataikuapi.dss.ml.DSSTrainedClusteringModelDetails")(...) | Object to read details of a trained clustering model  
[`dataikuapi.dss.ml.DSSTrainedPredictionModelDetails`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails")(...) | Object to read details of a trained prediction model  
[`dataikuapi.dss.ml.PredictionSplitParamsHandler`](<../api-reference/python/ml.html#dataikuapi.dss.ml.PredictionSplitParamsHandler> "dataikuapi.dss.ml.PredictionSplitParamsHandler")(...) | Object to modify the train/test dataset splitting params.  
[`dataikuapi.dss.savedmodel.DSSSavedModel`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel")(...) | Handle to interact with a saved model on the DSS instance.  
[`dataikuapi.dss.savedmodel.DSSSavedModelSettings`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModelSettings> "dataikuapi.dss.savedmodel.DSSSavedModelSettings")(...) | Handle on the settings of a saved model.  
[`dataikuapi.dss.savedmodel.ExternalModelVersionHandler`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.ExternalModelVersionHandler> "dataikuapi.dss.savedmodel.ExternalModelVersionHandler")(...) | Handler to interact with an External model version (MLflow import of Proxy model).  
[`dataikuapi.dss.savedmodel.MLFlowVersionSettings`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.MLFlowVersionSettings> "dataikuapi.dss.savedmodel.MLFlowVersionSettings")(...) | Handle for the settings of an imported MLFlow model version.  
  
### Functions

[`deploy_to_flow`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask.deploy_to_flow> "dataikuapi.dss.ml.DSSMLTask.deploy_to_flow")(model_id, model_name, ...[, ...]) | Deploys a trained model from this ML Task to the flow.  
---|---  
[`download_documentation_to_file`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.download_documentation_to_file> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.download_documentation_to_file")(export_id, path) | Download a model documentation into the given output file.  
[`get_active_version`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.get_active_version> "dataikuapi.dss.savedmodel.DSSSavedModel.get_active_version")() | Gets the active version of this saved model.  
[`get_algorithm_settings`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTaskSettings.get_algorithm_settings> "dataikuapi.dss.ml.DSSMLTaskSettings.get_algorithm_settings")(algorithm_name) |   
[`get_hyperparameter_search_settings`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSPredictionMLTaskSettings.get_hyperparameter_search_settings> "dataikuapi.dss.ml.DSSPredictionMLTaskSettings.get_hyperparameter_search_settings")() | Gets the hyperparameter search parameters of the current DSSPredictionMLTaskSettings instance as a HyperparameterSearchSettings object.  
[`get_feature_preprocessing`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTaskSettings.get_feature_preprocessing> "dataikuapi.dss.ml.DSSMLTaskSettings.get_feature_preprocessing")(feature_name) | Gets the feature preprocessing parameters for a particular feature.  
[`get_modeling_settings`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_modeling_settings> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_modeling_settings")() | Gets the modeling (algorithms) settings that were used to train this model.  
[`get_performance_metrics`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_performance_metrics> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_performance_metrics")() | Returns all performance metrics for this model.  
[`get_raw_snippet`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_raw_snippet> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_raw_snippet")() | Gets the raw dictionary of trained model snippet.  
[`get_saved_model`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_saved_model> "dataikuapi.dss.project.DSSProject.get_saved_model")(sm_id) | Get a handle to interact with a specific saved model  
[`get_settings`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask.get_settings> "dataikuapi.dss.ml.DSSMLTask.get_settings")() | Gets the settings of this ML Task.  
[`get_trained_model_details`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask.get_trained_model_details> "dataikuapi.dss.ml.DSSMLTask.get_trained_model_details")(id) | Gets details for a trained model.  
[`get_trained_models_ids`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask.get_trained_models_ids> "dataikuapi.dss.ml.DSSMLTask.get_trained_models_ids")([session_id, algorithm]) | Gets the list of trained model identifiers for this ML task.  
[`get_trained_model_snippet`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask.get_trained_model_snippet> "dataikuapi.dss.ml.DSSMLTask.get_trained_model_snippet")([id, ids]) | Gets a quick summary of a trained model, as a dict.  
[`get_version_details`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.get_version_details> "dataikuapi.dss.savedmodel.DSSSavedModel.get_version_details")(version_id) | Gets details for a version of a saved model  
[`list_versions`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.list_versions> "dataikuapi.dss.savedmodel.DSSSavedModel.list_versions")() | Gets the versions of this saved model.  
`predict`(df[, with_input_cols, ...]) | Predict a dataframe.  
[`reject_feature`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTaskSettings.reject_feature> "dataikuapi.dss.ml.DSSMLTaskSettings.reject_feature")(feature_name) | Marks a feature as 'rejected', disabling it from being used as an input when training.  
[`set_algorithm_enabled`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTaskSettings.set_algorithm_enabled> "dataikuapi.dss.ml.DSSMLTaskSettings.set_algorithm_enabled")(algorithm_name, enabled) | Enables or disables an algorithm given its name.  
[`set_kfold_validation`](<../api-reference/python/ml.html#dataikuapi.dss.ml.HyperparameterSearchSettings.set_kfold_validation> "dataikuapi.dss.ml.HyperparameterSearchSettings.set_kfold_validation")([n_folds, stratified, ...]) | Sets the validation mode to k-fold cross-validation.  
[`set_random_search`](<../api-reference/python/ml.html#dataikuapi.dss.ml.HyperparameterSearchSettings.set_random_search> "dataikuapi.dss.ml.HyperparameterSearchSettings.set_random_search")([seed]) | Sets the search strategy to "RANDOM", to perform a random search over the hyperparameters.  
[`start_train`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask.start_train> "dataikuapi.dss.ml.DSSMLTask.start_train")([session_name, ...]) | Starts asynchronously a new training session for this ML Task.  
[`strategy`](<../api-reference/python/ml.html#dataikuapi.dss.ml.HyperparameterSearchSettings.strategy> "dataikuapi.dss.ml.HyperparameterSearchSettings.strategy") | 

return:
    The hyperparameter search strategy. Will be one of "GRID" | "RANDOM" | "BAYESIAN".  
[`use_feature`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTaskSettings.use_feature> "dataikuapi.dss.ml.DSSMLTaskSettings.use_feature")(feature_name) | Marks a feature to be used (enabled) as an input when training.  
[`validation_mode`](<../api-reference/python/ml.html#dataikuapi.dss.ml.HyperparameterSearchSettings.validation_mode> "dataikuapi.dss.ml.HyperparameterSearchSettings.validation_mode") | 

return:
    The cross-validation strategy. Will be one of "KFOLD" | "SHUFFLE" | "TIME_SERIES_KFOLD" | "TIME_SERIES_SINGLE_SPLIT" | "CUSTOM".  
[`wait_guess_complete`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask.wait_guess_complete> "dataikuapi.dss.ml.DSSMLTask.wait_guess_complete")() | Waits for the ML Task guessing to be complete.  
[`wait_train_complete`](<../api-reference/python/ml.html#dataikuapi.dss.ml.DSSMLTask.wait_train_complete> "dataikuapi.dss.ml.DSSMLTask.wait_train_complete")() | Waits for training to be completed

---

## [concepts-and-examples/model-evaluation-stores]

# Model Evaluation Stores  
  
Through the public API, the Python client allows you to perform evaluation of models. Those models are typically models trained in the Lab, and then deployed to the Flow as Saved Models (see [Visual Machine learning](<ml.html>) for additional information). They can also be external models.

## Concepts

### With a DSS model

In DSS, you can evaluate a **version** of a Saved Model using an Evaluation Recipe. An Evaluation Recipe takes as input a Saved Model and a Dataset on which to perform this evaluation. An Evaluation Recipe can have three outputs:

  * an **output** dataset,

  * a **metrics** dataset, or

  * a **Model Evaluation Store** (MES).




By default, the **active** version of the Saved Model is evaluated. This can be configured in the Evaluation Recipe.

If a MES is configured as an output, a **Model Evaluation** (ME) will be written in the MES each time the MES is built (or each time the Evaluation Recipe is run).

A Model Evaluation is a container for metrics of the evaluation of the Saved Model Version on the Evaluation Dataset. Those metrics include:

  * all available **performance** metrics,

  * the **Data Drift** metric.




The Data Drift metric is the accuracy of a model trained to recognize lines:

  * from the evaluation dataset

  * from the **train time test dataset** of the configured version of the Saved Model.




The higher this metric, the better the model can separate lines from the evaluation dataset from those from the train time test dataset. And so, the more data from the evaluation dataset is different from train time data.

Detailed information and other tools, including a binomial test, univariate data drift, and feature drift importance, are available in the **Input Data Drift** tab of a Model Evaluation. Note that this tool is interactive and that displayed results are not persisted.

### With an external model

In DSS, you can also evaluate an **external model** using a **Standalone Evaluation Recipe (SER)**. A Standalone Evaluation Recipe takes as input a labeled dataset containing labels, predictions, and (optionally) weights. A SER takes a single output: a Model Evaluation Store.

As the Evaluation Recipe, the Standalone Evaluation Recipe will output a Model Evaluation to the configured Model Evaluation Store each time it runs. In this case, however, the Data Drift can not be computed as there is no notion of reference data.

### How evaluation is performed

The Evaluation Recipe and its counterpart for external models, the Standalone Evaluation Recipe, perform the evaluation on a sample of the Evaluation Dataset. The sampling parameters are defined in the recipe. Note that the sample will contain at most 20,000 lines.

Performance metrics are then computed on this sample.

Data drift can be computed in three ways:

  * at evaluation time, between the evaluation dataset and the train time test dataset;

  * using the API, between the samples of a Model Evaluation, a Saved Model Version (sample of train time test dataset) or a Lab Model (sample of train time test dataset);

  * interactively, in the “Input data drift” tab of a Model Evaluation.




In all cases, to compute the Data Drift, the sample of the Model Evaluation and a sample of the reference data are concatenated. In order to balance the data, those samples are truncated to the length of the smallest one. If the size of the reference sample if higher than the size of the ME sample, the reference sample will be truncated.

So:

  * at evaluation time, we shall take as input the sample of the Model Evaluation (whose length is at most 20,000 lines) and a sample of the train time test dataset;

  * interactively, the sample of the reference model evaluation and:

    * if the other compared item is an ME, its sample;

    * if the other compared item is a Lab Model or an SMV, a sample of its train time test dataset.




### Limitations

Model Evaluation Stores cannot be used with:

  * clustering models,

  * ensembling models,

  * partitioned models.




Compatible prediction models have to be Python models.

## Usage samples

### Create a Model Evaluation Store
    
    
    # client is a DSS API client
    
    project = client.get_project("MYPROJECT")
    
    mes_id = project.create_model_evaluation_store("My Mes Name")
    

Note that the display name of a Model Evaluation Store (in the above sample `My Mes Name`) is distinct from its unique id.

### Retrieve a Model Evaluation Store
    
    
    # client is a DSS API client
    
    project = client.get_project("MYPROJECT")
    
    mes_id = project.get_model_evaluation_store("mes_id")
    

### List Model Evaluation Stores
    
    
    # client is a DSS API client
    
    project = client.get_project("MYPROJECT")
    
    stores = project.list_model_evaluation_stores()
    

### Create an Evaluation Recipe

See [`dataikuapi.dss.recipe.EvaluationRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.EvaluationRecipeCreator> "dataikuapi.dss.recipe.EvaluationRecipeCreator")

### Build a Model Evaluation Store and retrieve the performance and data drift metrics of the just computed ME
    
    
    # client is a DSS API client
    
    project = client.get_project("MYPROJECT")
    
    mes = project.get_model_evaluation_store("M3s_1d")
    
    mes.build()
    
    me = mes.get_latest_model_evaluation()
    
    full_info = me.get_full_info()
    
    metrics = full_info.metrics
    

### List Model Evaluations from a store
    
    
    # client is a DSS API client
    
    project = client.get_project("MYPROJECT")
    
    mes = project.get_model_evaluation_store("M3s_1d")
    
    me_list = mes.list_model_evaluations()
    

### Retrieve an array of creation date / accuracy from a store
    
    
    project = client.get_project("MYPROJECT")
    
    mes = project.get_model_evaluation_store("M3s_1d")
    
    me_list = mes.list_model_evaluations()
    payload = er_settings.obj_payload
    
    # Change the settings
    
    payload['dontComputePerformance'] = True
    payload['outputProbabilities'] = False
    res = []
    
    for me in me_list:
        full_info = me.get_full_info()
        creation_date = full_info.creation_date
        accuracy = full_info.metrics["accuracy"]
        res.append([creation_date,accuracy])
    

### Retrieve an array of label value / precision from a store

The date of creation of a model evaluation might not be the best way to key a metric. In some cases, it might be more interesting to use the labeling system, for instance to tag the version of the evaluation dataset.

If the user created a label `"myCustomLabel:evaluationDataset"`, he may retrieve an array of label value / precision from a store with the following snippet:
    
    
    project = client.get_project("MYPROJECT")
    
    mes = project.get_model_evaluation_store("M3s_1d")
    
    me_list = mes.list_model_evaluations()
    
    res = []
    
    for me in me_list:
        full_info = me.get_full_info()
        label_value = next(x for x in full_info.user_meta["labels"] if x["key"] == "myCustomLabel:evaluationDataset")
        precision= full_info.metrics["precision"]
        res.append([label_value,precision])
    

### Compute data drift of the evaluation dataset of a Model Evaluation with the train time test dataset of its base DSS model version
    
    
    project = client.get_project("MYPROJECT")
    
    mes = project.get_model_evaluation_store("M3s_1d")
    
    me1 = mes.get_latest_model_evaluation()
    
    drift = me1.compute_drift()
    
    drift_model_result = drift.drift_model_result
    drift_model_accuracy = drift_model_result.drift_model_accuracy
    print("Value: {} < {} < {}".format(drift_model_accuracy.lower_confidence_interval,
                                        drift_model_accuracy.value,
                                        drift_model_accuracy.upper_confidence_interval))
    print("p-value: {}".format(drift_model_accuracy.pvalue))
    

### Compute data drift, display results and adjust parameters
    
    
    # me1 and me2 are two compatible model evaluations (having the same prediction type) from any store
    
    # make sure that you import the DataDriftParams and PerColumnDriftParamBuilder before running this code
    
    from dataikuapi.dss.modelevaluationstore import DataDriftParams, PerColumnDriftParamBuilder
    
    drift = me1.compute_drift(me2)
    
    drift_model_result = drift.drift_model_result
    drift_model_accuracy = drift_model_result.drift_model_accuracy
    print("Value: {} < {} < {}".format(drift_model_accuracy.lower_confidence_interval,
                                        drift_model_accuracy.value,
                                        drift_model_accuracy.upper_confidence_interval))
    print("p-value: {}".format(drift_model_accuracy.pvalue))
    
    # Check sample sizes
    print("Reference sample size: {}".format(drift_model_result.get_raw()["referenceSampleSize"]))
    print("Current sample size: {}".format(drift_model_result.get_raw()["currentSampleSize"]))
    
    
    # check columns handling
    per_col_settings = drift.per_column_settings
    for col_settings in per_col_settings:
        print("col {} - default handling {} - actual handling {}".format(col_settings.name, col_settings.default_column_handling, col_settings.actual_column_handling))
    
    # recompute, with Pclass set as CATEGORICAL
    drift = me1.compute_data_drift(me2,
                                DataDriftParams.from_params(
                                    PerColumnDriftParamBuilder().with_column_drift_param("Pclass", "CATEGORICAL", True).build()
                                )
                                )
    ...
    

## Reference documentation

There are two main parts related to the handling of metrics and checks in Dataiku’s Python APIs:

  * [`dataiku.core.model_evaluation_store.ModelEvaluationStore`](<../api-reference/python/model-evaluation-stores.html#dataiku.ModelEvaluationStore> "dataiku.core.model_evaluation_store.ModelEvaluationStore") and [`dataiku.core.model_evaluation_store.ModelEvaluation`](<../api-reference/python/model-evaluation-stores.html#dataiku.core.model_evaluation_store.ModelEvaluation> "dataiku.core.model_evaluation_store.ModelEvaluation") in the `dataiku` package. They were initially designed for usage within DSS.

  * [`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") and [`dataikuapi.dss.modelevaluationstore.DSSModelEvaluation`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluation> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluation") in the `dataikuapi` package. They were initially designed for usage outside of DSS.




Both set of classes have fairly similar capabilities.

For more details on the two packages, please see [The Dataiku Python packages](<../getting-started/dataiku-python-apis/index.html>).

### Classes

[`dataiku.ModelEvaluationStore`](<../api-reference/python/model-evaluation-stores.html#dataiku.ModelEvaluationStore> "dataiku.ModelEvaluationStore")(lookup[, ...]) | This is a handle to interact with a model evaluation store.  
---|---  
[`dataiku.core.model_evaluation_store.ModelEvaluation`](<../api-reference/python/model-evaluation-stores.html#dataiku.core.model_evaluation_store.ModelEvaluation> "dataiku.core.model_evaluation_store.ModelEvaluation")(...) | This is a handle to interact with a model evaluation from a model evaluation store.  
[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore")(...) | A handle to interact with a model evaluation store on the DSS instance.  
[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStoreSettings`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStoreSettings> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStoreSettings")(...) | A handle on the settings of a model evaluation store  
[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluation`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluation> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluation")(...) | A handle on a model evaluation  
[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationFullInfo`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationFullInfo> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationFullInfo")(...) | A handle on the full information on a model evaluation.  
`dataikuapi.dss.modelevaluationstore.DataDriftParams`(data) | Object that represents parameters for data drift computation.  
`dataikuapi.dss.modelevaluationstore.PerColumnDriftParamBuilder`() | Builder for a map of per column drift params settings.  
`dataikuapi.dss.modelevaluationstore.DataDriftResult`(data) | A handle on the data drift result of a model evaluation.  
`dataikuapi.dss.modelevaluationstore.DriftModelResult`(data) | A handle on the drift model result.  
`dataikuapi.dss.modelevaluationstore.UnivariateDriftResult`(data) | A handle on the univariate data drift.  
`dataikuapi.dss.modelevaluationstore.ColumnSettings`(data) | A handle on column handling information.  
`dataikuapi.dss.modelevaluationstore.DriftModelAccuracy`(data) | A handle on the drift model accuracy.  
  
### Functions

`build`([job_type, wait, no_fail]) | Starts a new job to build this evaluation store and wait for it to complete.  
---|---  
`compute_data_drift`([reference, ...]) | Compute data drift against a reference model or model evaluation.  
`compute_drift`([reference, drift_params, wait]) | Compute drift against a reference model or model evaluation.  
[`create_model_evaluation_store`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_model_evaluation_store> "dataikuapi.dss.project.DSSProject.create_model_evaluation_store")(name) | Create a new model evaluation store in the project, and return a handle to interact with it.  
[`get_full_info`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluation.get_full_info> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluation.get_full_info")() | Retrieve the model evaluation with its performance data  
[`get_latest_model_evaluation`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore.get_latest_model_evaluation> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore.get_latest_model_evaluation")() | Get a handle to interact with the latest model evaluation computed  
[`get_model_evaluation_store`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_model_evaluation_store> "dataikuapi.dss.project.DSSProject.get_model_evaluation_store")(mes_id) | Get a handle to interact with a specific model evaluation store  
[`get_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`list_model_evaluations`](<../api-reference/python/model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore.list_model_evaluations> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore.list_model_evaluations")() | List the model evaluations in this model evaluation store.  
[`list_model_evaluation_stores`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_model_evaluation_stores> "dataikuapi.dss.project.DSSProject.list_model_evaluation_stores")() | List the model evaluation stores in this project.

---

## [concepts-and-examples/plugins]

# Plugins  
  
The API offers methods to:

  * Install plugins

  * Uninstall plugins and list their usages

  * Update plugins

  * Read and write plugin settings

  * Create and update plugin code envs

  * List macros that can be run

  * Run macros




## Installing plugins

### From a Zip file
    
    
    with open("myplugin.zip", "rb") as f:
        client.install_plugin_from_archive(f)
    

### From the Dataiku plugin store
    
    
    future = client.install_plugin_from_store("googlesheets")
    future.wait_for_result()
    

### From a Git repository
    
    
    future = client.install_plugin_from_git("[[email protected]](</cdn-cgi/l/email-protection>):myorg/myrepo")
    future.wait_for_result()
    

## Uninstalling plugins

### Listing usages of a plugin
    
    
    plugin = client.get_plugin('my-plugin-id')
    usages = plugin.list_usages()
    

### Uninstalling a plugin
    
    
    plugin = client.get_plugin('my-plugin-id')
    future = plugin.delete()
    

Plugin deletion fails if a usage is detected. It can be forced with `force=True`:
    
    
    plugin = client.get_plugin('my-plugin-id')
    future = plugin.delete(force=True)
    

## Managing code envs
    
    
    plugin = client.get_plugin("myplugin")
    
    # Start creating the code env, and wait for it to be done
    future = plugin.create_code_env()
    result = future.wait_for_result()
    
    # NB: If the plugin requires Python 3.9 for example, you will use something like:
    # future = plugin.create_code_env(python_interpreter="PYTHON39")
    # result = future.wait_for_result()
    
    # Now the code env is created, but we still need to configure the plugin to use it
    settings = plugin.get_settings()
    settings.set_code_env(result["envName"])
    settings.save()
    

## Handling settings
    
    
    plugin = client.get_plugin("myplugin")
    
    # Obtain the current settings
    settings = plugin.get_settings()
    raw_settings = settings.get_raw()
    
    # Modify the settings
    # ...
    
    # And save them back
    settings.save()
    

## Reference documentation

### Classes

[`dataikuapi.dss.future.DSSFuture`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")(client, job_id) | A future represents a long-running task on a DSS instance.  
---|---  
[`dataikuapi.dss.macro.DSSMacro`](<../api-reference/python/plugins.html#dataikuapi.dss.macro.DSSMacro> "dataikuapi.dss.macro.DSSMacro")(client, ...[, ...]) | A macro on the DSS instance.  
[`dataikuapi.dss.plugin.DSSMissingType`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSMissingType> "dataikuapi.dss.plugin.DSSMissingType")(data) | Information on a type not found while analyzing usages of a plugin.  
[`dataikuapi.dss.plugin.DSSPlugin`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPlugin> "dataikuapi.dss.plugin.DSSPlugin")(client, ...) | A plugin on the DSS instance.  
[`dataikuapi.dss.plugin.DSSPluginSettings`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPluginSettings> "dataikuapi.dss.plugin.DSSPluginSettings")(...) | The settings of a plugin.  
[`dataikuapi.dss.plugin.DSSPluginParameterSet`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPluginParameterSet> "dataikuapi.dss.plugin.DSSPluginParameterSet")(...) | A parameter set in a plugin.  
[`dataikuapi.dss.plugin.DSSPluginUsage`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPluginUsage> "dataikuapi.dss.plugin.DSSPluginUsage")(data) | Information on a usage of an element of a plugin.  
[`dataikuapi.dss.plugin.DSSMissingType`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSMissingType> "dataikuapi.dss.plugin.DSSMissingType")(data) | Information on a type not found while analyzing usages of a plugin.  
[`dataikuapi.dss.plugin.DSSPluginUsages`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPluginUsages> "dataikuapi.dss.plugin.DSSPluginUsages")(data) | Information on the usages of a plugin.  
  
### Functions

[`create_code_env`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPlugin.create_code_env> "dataikuapi.dss.plugin.DSSPlugin.create_code_env")([python_interpreter, conda]) | Start the creation of the code env of the plugin.  
---|---  
[`delete`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPlugin.delete> "dataikuapi.dss.plugin.DSSPlugin.delete")([force]) | Delete a plugin.  
[`get_plugin`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_plugin> "dataikuapi.DSSClient.get_plugin")(plugin_id) | Get a handle to interact with a specific plugin  
[`get_settings`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPlugin.get_settings> "dataikuapi.dss.plugin.DSSPlugin.get_settings")() | Get the plugin-level settings.  
[`install_plugin_from_archive`](<../api-reference/python/client.html#dataikuapi.DSSClient.install_plugin_from_archive> "dataikuapi.DSSClient.install_plugin_from_archive")(fp) | Install a plugin from a plugin archive (as a file object)  
[`install_plugin_from_git`](<../api-reference/python/client.html#dataikuapi.DSSClient.install_plugin_from_git> "dataikuapi.DSSClient.install_plugin_from_git")(repository_url[, ...]) | Install a plugin from a Git repository.  
[`install_plugin_from_store`](<../api-reference/python/client.html#dataikuapi.DSSClient.install_plugin_from_store> "dataikuapi.DSSClient.install_plugin_from_store")(plugin_id) | Install a plugin from the Dataiku plugin store  
[`list_usages`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPlugin.list_usages> "dataikuapi.dss.plugin.DSSPlugin.list_usages")([project_key]) | Get the list of usages of the plugin.  
[`save`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPluginSettings.save> "dataikuapi.dss.plugin.DSSPluginSettings.save")() | Save the settings to DSS.  
[`set_code_env`](<../api-reference/python/plugins.html#dataikuapi.dss.plugin.DSSPluginSettings.set_code_env> "dataikuapi.dss.plugin.DSSPluginSettings.set_code_env")(code_env_name) | Set the name of the code env to use for this plugin.  
[`wait_for_result`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture.wait_for_result> "dataikuapi.dss.future.DSSFuture.wait_for_result")() | Waits for the completion of the long-running task, and returns its result.

---

## [concepts-and-examples/project-deployer]

# Project Deployer

Tutorials

You can find tutorials on this subject in the Developer Guide: [Project deployment](<../tutorials/xOps/project-deployment/index.html>).  
You will find a summary of the used classes and methods at the end of this document. The starting point for the Project Deployer API documentation will be the [`DSSProjectDeployer`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer> "dataikuapi.dss.projectdeployer.DSSProjectDeployer") class.

## Project Deployer

### Getting the Project Deployer
    
    
    project_deployer = client.get_projectdeployer()
    

### Listing deployments

Listing deployments on the Project Deployer.
    
    
    for deployment in project_deployer.list_deployments():
        print(f"Deployment id {deployment.id}")
    

### Getting a deployment

Getting a handle to interact with a deployment.
    
    
    DEPLOYMENT_ID = "" # Fill with your deployment id
    deployment = project_deployer.get_deployment(DEPLOYMENT_ID)
    

### Exporting a bundle

Exporting a bundle in a specific published project on the Project Deployer.
    
    
    PROJECT_KEY = "" # Fill with your project key
    project = client.get_project(PROJECT_KEY)
    BUNDLE_ID = "" # Fill with the unique identifier for the bundle
    release_notes = "" # Indicates the changes introduced by this bundle
    bundle = project.export_bundle(BUNDLE_ID, release_notes)
    

### Creating a published project

Creating a published project on the Project Deployer.

Creating a published project
    
    
    PUBLISHED_PROJECT_ID = "" # Fill with the identifier of the published project
    published_project = project_deployer.create_project(PUBLISHED_PROJECT_ID)
    

### Getting a published project

Getting a published project from the Project Deployer.
    
    
    PUBLISHED_PROJECT_ID = "" # Fill with the identifier of the published project
    published_project = project_deployer.get_project(PUBLISHED_PROJECT_ID)
    

### Deleting a published project

Deleting a published project on the Project Deployer.
    
    
    published_project.delete()
    

### Publishing a bundle

Publishing an exported bundle to a published project on the Project Deployer.
    
    
    PROJECT_KEY = "" # Fill with your project key
    project = client.get_project(PROJECT_KEY)
    BUNDLE_ID = "" # Fill with the unique identifier for the bundle
    PUBLISHED_PROJECT_ID = "" # Fill with the identifier of the published project
    published_project = project.publish_bundle(BUNDLE_ID, PUBLISHED_PROJECT_ID)
    

### Creating a deployment

Creating a deployment and return the handle to interact with it.
    
    
    DEPLOYMENT_ID = "" # Fill with your deployment id
    PUBLISHED_PROJECT_ID = "" # Fill with the identifier of the published project
    INFRA_ID = "" # Fill with the deployment id you chose
    BUNDLE_ID = "" # Fill with the unique identifier for the bundle
    deployment = project_deployer.create_deployment(deployment_id=DEPLOYMENT_ID, project_key=PUBLISHED_PROJECT_ID, infra_id=INFRA_ID, bundle_id=BUNDLE_ID, ignore_warnings=True)
    
    # Once created, you need to trigger the update mechanism.
    update = deployment.start_update()
    update.wait_for_result()
    print(f"Deployment state: {update.state}")
    

## Deployment infrastructures

### Listing stages

Listing the possible stages for infrastructures.
    
    
    project_deployer.list_stages()
    

### Listing deployment infrastructures

Listing the infrastructures on the Project Deployer.

Listing deployment infrastructures
    
    
    for infra in project_deployer.list_infras():
        print(f"Infrastructure id: {infra.id}")
    

### Getting a deployment infrastructure

Getting a handle to interact with an infrastructure.
    
    
    INFRA_ID = "" # Fill with the unique identifier of the infrastructure
    infra = project_deployer.get_infra(INFRA_ID)
    

### Creating a deployment infrastructure

Creating a new infrastructure and returns the handle to interact with it.
    
    
    INFRA_ID = "" # Fill with the unique identifier of the infrastructure to create
    STAGE_ID = "" # Fill with the stage of the infrastructure to create
    GOVERN_CHECK_POLICY = "" # Fill with the policy that Govern will apply. possible values: PREVENT, WARN, or NO_CHECK
    infra = project_deployer.create_infra(INFRA_ID, STAGE_ID, GOVERN_CHECK_POLICY)
    

## Published Projects

### Listing published projects

Listing published projects on the Project Deployer.
    
    
    for project in project_deployer.list_projects():
        print(f"Published project: {project.id} - {project.project_key}")
    

### Creating a published project
    
    
    PUBLISHED_ID = "" # Fill with the unique identifier of the published project to create
    published_project = project_deployer.create_project(PUBLISHED_ID)
    

### Getting a published project
    
    
    PUBLISHED_ID = "" # Fill with the unique identifier of the published project to create
    published_project = project_deployer.
    

## Deployment status

### Getting the status of a deployment
    
    
    DEPLOYMENT_ID = "" # Fillwith your deployment id
    deployment = project_deployer.get_deployment(DEPLOYMENT_ID)
    status = deployment.get_status()
    

### Getting details on a deployment status
    
    
    heavy = status.get_heavy()
    deployment_id = heavy.get('deploymentId')
    infra_id = heavy.get('infraId')
    health = status.get_health()
    if health == 'ERROR':
        print(f"The deployment {deployment_id} deployed on infra {infra_id} has an error status.")
        for message in status.get_health_messages().get('messages'):
            print(f"  {message.get('severity')}: {message.get('details')}")
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployer`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer> "dataikuapi.dss.projectdeployer.DSSProjectDeployer")(client) | Handle to interact with the Project Deployer.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment")(...) | A deployment on the Project Deployer.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentSettings`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentSettings> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentSettings")(...) | The settings of a Project Deployer deployment.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus")(...) | The status of a deployment on the Project Deployer.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerInfra`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerInfra> "dataikuapi.dss.projectdeployer.DSSProjectDeployerInfra")(...) | An Automation infrastructure on the Project Deployer.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerInfraSettings`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerInfraSettings> "dataikuapi.dss.projectdeployer.DSSProjectDeployerInfraSettings")(...) | The settings of an Automation infrastructure.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerInfraStatus`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerInfraStatus> "dataikuapi.dss.projectdeployer.DSSProjectDeployerInfraStatus")(...) | The status of an Automation infrastructure.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerProject`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerProject> "dataikuapi.dss.projectdeployer.DSSProjectDeployerProject")(...) | A published project on the Project Deployer.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerProjectSettings`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerProjectSettings> "dataikuapi.dss.projectdeployer.DSSProjectDeployerProjectSettings")(...) | The settings of a published project.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerProjectStatus`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerProjectStatus> "dataikuapi.dss.projectdeployer.DSSProjectDeployerProjectStatus")(...) | The status of a published project.  
  
### Functions

[`create_deployment`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer.create_deployment> "dataikuapi.dss.projectdeployer.DSSProjectDeployer.create_deployment")(deployment_id, ...[, ...]) | Create a deployment and return the handle to interact with it.  
---|---  
[`create_infra`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer.create_infra> "dataikuapi.dss.projectdeployer.DSSProjectDeployer.create_infra")(infra_id, stage[, ...]) | Create a new infrastructure and returns the handle to interact with it.  
[`get_deployment`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer.get_deployment> "dataikuapi.dss.projectdeployer.DSSProjectDeployer.get_deployment")(deployment_id) | Get a handle to interact with a deployment.  
[`get_health`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus.get_health> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus.get_health")() | Get the health of this deployment.  
[`get_health_messages`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus.get_health_messages> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus.get_health_messages")() | Get messages about the health of this deployment  
[`get_heavy`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus.get_heavy> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus.get_heavy")() | Get the 'heavy' (full) status.  
[`get_projectdeployer`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_projectdeployer> "dataikuapi.DSSClient.get_projectdeployer")() | Gets a handle to work with the Project Deployer  
[`get_status`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment.get_status> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment.get_status")() | Get status information about this deployment.  
[`list_deployments`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer.list_deployments> "dataikuapi.dss.projectdeployer.DSSProjectDeployer.list_deployments")([as_objects]) | List deployments on the Project Deployer.  
[`list_infras`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer.list_infras> "dataikuapi.dss.projectdeployer.DSSProjectDeployer.list_infras")([as_objects]) | List the infrastructures on the Project Deployer.  
[`list_stages`](<../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer.list_stages> "dataikuapi.dss.projectdeployer.DSSProjectDeployer.list_stages")() | List the possible stages for infrastructures.

---

## [concepts-and-examples/project-folders]

# Project folders  
  
You can interact with project folders through the API.

## Basic operations

The ROOT project folder can be retrieved with the [`get_root_project_folder()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_root_project_folder> "dataikuapi.DSSClient.get_root_project_folder") method.
    
    
    root_folder = client.get_root_project_folder()
    

Alternatively any project folder can be retrieved with its ID with the [`get_project_folder()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project_folder> "dataikuapi.DSSClient.get_project_folder") method.
    
    
    project_folder = client.get_project_folder(project_folder_id)
    

You can obtain the `project_folder_id` by using or adapting this function:
    
    
    def list_child_project(folder_id, prefix="", print_project=False):
        folder = client.get_project_folder(folder_id)
        print(prefix + "+", folder.name, " --> ", folder.id)
        if print_project:
            [print(prefix + "|--", p.project_key, "(", p.get_metadata().get('label'), ")")
             for p in client.get_project_folder(folder.id).list_projects()]
        children = folder.list_child_folders()
        if children:
            [list_child_project(child.id, prefix+"+--",print_project) for child in children]
    
    list_child_project(root_folder.id)
    

Getting basic attributes:
    
    
    # Getting the id of a project folder (for "get_project_folder")
    id = project_folder.id
    
    # Getting the name of a project folder:
    name = project_folder.name
    
    # Getting the "virtual path" of a project folder (NB: for information purpose only, does not hold special significance)
    path = project_folder.get_path()
    

## Navigating within project folders

In order to navigate from a project folder, its parent and children can be retrieved.
    
    
    parent = project_folder.get_parent()
    children = project_folder.list_child_folders()
    

This will list all its projects.
    
    
    project_key_list = project_folder.list_project_keys()
    project_list = project_folder.list_projects()
    

## Finding the folder of a project

From a project, you can find its project folder
    
    
    project = client.get_project("MYPROJECT")
    folder = project.get_project_folder()
    print("Project is in folder %s (path %s)" % (folder.name, folder.get_path()))
    

## Creating entities

To create a child project folder, use the [`create_sub_folder()`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.create_sub_folder> "dataikuapi.dss.projectfolder.DSSProjectFolder.create_sub_folder") method.
    
    
    # Creating a new project folder
    newborn_child = project_folder.create_sub_folder(project_folder_name)
    
    # Creating a project directly into a project folder
    new_project = project_folder.create_project(project_key, project_name, owner)
    

## Moving entities

To move a project folder to another location (into another project folder), use the [`move_to()`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.move_to> "dataikuapi.dss.projectfolder.DSSProjectFolder.move_to") method.
    
    
    project_folder.move_to(new_parent)
    
    project_folder.move_project_to(project_key, new_parent)
    

You can also move a project directly
    
    
    project.move_to_folder(target_folder)
    

## Managing project folders

### Deleting a project folder
    
    
    project_folder.delete()
    

### Modifying settings
    
    
    project_folder_settings = project_folder.get_settings()
    project_folder_settings.set_name(new_name)
    project_folder_settings.set_owner(new_owner)
    project_folder_permissions = project_folder_settings.get_permissions()
    new_perm = {'read': False, 'writeContents': False, 'admin': False}
    project_folder_permissions.append(new_perm)
    project_folder_settings.save()
    

## Reference documentation

### Classes

[`dataikuapi.dss.projectfolder.DSSProjectFolder`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder")(...) | A handle for a project folder on the DSS instance.  
---|---  
[`dataikuapi.dss.projectfolder.DSSProjectFolderSettings`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolderSettings> "dataikuapi.dss.projectfolder.DSSProjectFolderSettings")(...) | A handle for a project folder settings.  
  
### Functions

[`create_project`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.create_project> "dataikuapi.dss.projectfolder.DSSProjectFolder.create_project")(project_key, name, owner[, ...]) | Create a new project within this project folder.  
---|---  
[`create_sub_folder`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.create_sub_folder> "dataikuapi.dss.projectfolder.DSSProjectFolder.create_sub_folder")(name) | Create a project subfolder inside this project folder.  
[`delete`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.delete> "dataikuapi.dss.projectfolder.DSSProjectFolder.delete")() | Delete this project folder.  
[`get_path`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.get_path> "dataikuapi.dss.projectfolder.DSSProjectFolder.get_path")() | 

returns:
    The project folder path from the root project folder (e.g. `'/'` or `'/foo/bar'`).  
[`get_parent`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.get_parent> "dataikuapi.dss.projectfolder.DSSProjectFolder.get_parent")() | 

returns:
    A handle for the parent folder or `None` for the root project folder.  
[`get_permissions`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolderSettings.get_permissions> "dataikuapi.dss.projectfolder.DSSProjectFolderSettings.get_permissions")() | Get the permissions of the project folder.  
[`get_project_folder`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project_folder> "dataikuapi.DSSClient.get_project_folder")(project_folder_id) | Get a handle to interact with a project folder.  
[`get_root_project_folder`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_root_project_folder> "dataikuapi.DSSClient.get_root_project_folder")() | Get a handle to interact with the root project folder.  
[`get_settings`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.get_settings> "dataikuapi.dss.projectfolder.DSSProjectFolder.get_settings")() | 

returns:
    A handle for this project folder settings.  
[`list_child_folders`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.list_child_folders> "dataikuapi.dss.projectfolder.DSSProjectFolder.list_child_folders")() | 

returns:
    Handles for every child project folder.  
[`list_projects`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.list_projects> "dataikuapi.dss.projectfolder.DSSProjectFolder.list_projects")() | 

returns:
    Handles for every project stored in this project folder.  
[`list_project_keys`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.list_project_keys> "dataikuapi.dss.projectfolder.DSSProjectFolder.list_project_keys")() | 

returns:
    The project keys of all projects stored in this project folder.  
[`move_project_to`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.move_project_to> "dataikuapi.dss.projectfolder.DSSProjectFolder.move_project_to")(project_key, destination) | Move a project from this project folder into another project folder.  
[`move_to`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder.move_to> "dataikuapi.dss.projectfolder.DSSProjectFolder.move_to")(destination) | Move this project folder into another project folder.  
[`move_to_folder`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.move_to_folder> "dataikuapi.dss.project.DSSProject.move_to_folder")(folder) | Moves this project to a project folder  
[`save`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolderSettings.save> "dataikuapi.dss.projectfolder.DSSProjectFolderSettings.save")() | Save back the settings to the project folder.  
[`set_name`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolderSettings.set_name> "dataikuapi.dss.projectfolder.DSSProjectFolderSettings.set_name")(name) | Set the name of the project folder.  
[`set_owner`](<../api-reference/python/project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolderSettings.set_owner> "dataikuapi.dss.projectfolder.DSSProjectFolderSettings.set_owner")(owner) | Set the owner of the project folder.

---

## [concepts-and-examples/project-libraries]

# Project libraries  
  
You can interact with the Library of each project through the API.

## Getting the DSSLibrary object

You must first retrieve the [`DSSLibrary`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary> "dataikuapi.dss.projectlibrary.DSSLibrary") through the [`get_library()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_library> "dataikuapi.dss.project.DSSProject.get_library") method
    
    
    project = client.get_project("MYPROJECT")
    library = project.get_library()
    

## Retrieving the content of a file
    
    
    library_file = library.get_file("/file.txt")
    print("Content: %s" % library_file.read())
    
    # Alternate ways to retrieve a file handle
    library_file = library.get_file("/python/some_code.py")
    library_file = library.get_folder("/").get_file("file.txt")
    

## Getting the list of all the library items
    
    
    def print_library_items(item):
        print(item.path)
        if "list" in dir(item):
            for child in item.list():
                print_library_items(child)
    
    for item in library.list():
        print_library_items(item)
    

## Add a new folder in the library
    
    
    library.add_folder("/new_folder")
    library.add_folder("/python/new_sub_folder")
    library.get_folder("/python").add_folder("another_sub_folder")
    

## Add a new file in the library
    
    
    with open("/path/to/local/file", "rb") as file:
        new_txt_file = library.add_file("/new_folder/new_file.txt")
        new_txt_file.write(file)
    
    with open("/path/to/local/file", "rb") as file:
        new_json_file = library.get_folder("/new_folder").add_file("new_file.json")
        new_json_file.write(file)
    

## Rename a file or a folder in the library
    
    
    # rename a file in the library
    library.get_file("/folder/file.txt").rename("renamed_file.txt")
    
    # rename a folder in the library
    library.get_folder("/folder").rename("renamed_folder")
    

## Move a file or a folder in the library
    
    
    # move a file in the library
    library.get_file("/folder/file.txt").move_to(library.get_folder("/folder2"))
    
    # move a folder in the library
    library.get_folder("/folder").move_to(library.get_folder("/folder2"))
    

## Delete a file or a folder from the library
    
    
    library.get_file("/path/to/item").delete()
    library.get_folder("/path/to").get_file("/item").delete()
    library.get_folder("/path/to").delete()
    

## Reference documentation

### Classes

[`dataikuapi.dss.projectlibrary.DSSLibraryFolder`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibraryFolder> "dataikuapi.dss.projectlibrary.DSSLibraryFolder")(...) | A handle to manage a library folder  
---|---  
[`dataikuapi.dss.projectlibrary.DSSLibrary`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary> "dataikuapi.dss.projectlibrary.DSSLibrary")(...) | A handle to manage the library of a project It saves locally a copy of taxonomy to help navigate in the library All modifications done through this object and related library items are done locally and on remote.  
[`dataikuapi.dss.projectlibrary.DSSLibraryFile`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibraryFile> "dataikuapi.dss.projectlibrary.DSSLibraryFile")(...) | A handle to manage a library file  
  
### Functions

[`add_folder`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary.add_folder> "dataikuapi.dss.projectlibrary.DSSLibrary.add_folder")(folder_name) | Create a folder in the library root folder  
---|---  
`delete`() | Deletes this item from library  
`delete`() | Deletes this item from library  
[`add_folder`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibraryFolder.add_folder> "dataikuapi.dss.projectlibrary.DSSLibraryFolder.add_folder")(folder_name) | Create a folder in the library  
[`get_file`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary.get_file> "dataikuapi.dss.projectlibrary.DSSLibrary.get_file")(path) | Retrieves a file in the library  
[`get_folder`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary.get_folder> "dataikuapi.dss.projectlibrary.DSSLibrary.get_folder")(path) | Retrieves a folder in the library  
[`get_library`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_library> "dataikuapi.dss.project.DSSProject.get_library")() | Get a handle to manage the project library  
[`list`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary.list> "dataikuapi.dss.projectlibrary.DSSLibrary.list")([folder_path]) | Lists the contents in the given library folder or on the root if no folder is given.  
[`list`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibraryFolder.list> "dataikuapi.dss.projectlibrary.DSSLibraryFolder.list")() | Gets the contents of this folder sorted by name  
`move_to`(destination_folder) | Move a library item to another folder  
`move_to`(destination_folder) | Move a library item to another folder  
[`read`](<../api-reference/python/project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibraryFile.read> "dataikuapi.dss.projectlibrary.DSSLibraryFile.read")([as_type]) | Get the file contents from DSS

---

## [concepts-and-examples/projects]

# Projects  
  
[Projects](<https://doc.dataiku.com/dss/latest/concepts/projects/index.html>) are the main unit for organising workflows within the Dataiku platform.

## Basic operations

This section provides common examples of how to programmatically manipulate Projects.

### Listing Projects

The main identifier for Projects is the **Project Key**. The following can be run to access the list of Project Keys on a Dataiku instance:
    
    
    import dataiku
    client = dataiku.api_client()
    
    # Get a list of Project Keys
    project_keys = client.list_project_keys()
    

### Handling an existing Project

To manipulate a Project and its associated items you first need to get its handle, in the form of a [`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject") object. If the Project already exists on the instance, run:
    
    
    project = client.get_project("CHURN")
    

You can also directly get a handle on the current Project you are working on:
    
    
    project = client.get_default_project()
    

### Creating a new Project

The following code will create a new empty Project and return its handle:
    
    
    project = client.create_project(project_key="MYPROJECT",
                                        name="My very own project",
                                        owner="alice")
    

You can also duplicate an existing Project and get a handle on its copy:
    
    
    original_project = client.get_project("CHURN")
    copy_result = original_project.duplicate(target_project_key="CHURNCOPY",
                                              target_project_name="Churn (copy)")
    project = client.get_project(copy_result.get('targetProjectKey', None))
    

Finally, you can import a Project archive (zip file) and get a handle on the resulting Project. The newly imported Project should not already exist, and the `projectKey` must be unique.
    
    
    archive_path = "/path/to/archive.zip"
    with open(archive_path, "rb") as f:
        import_result = client.prepare_project_import(f).execute()
        # TODO Get handle
    

### Accessing Project items

Once your Project handle is created, you can use it to create, list and interact with Project items:
    
    
    # Print the names of all Datasets in the Project:
    for d in project.list_datasets():
        print(d.name)
    
    # Create a new empty Managed Folder:
    folder = project.create_managed_folder(name="myfolder")
    
    # Get a handle on a Dataset:
    customer_data = project.get_dataset("customers")
    

### Exporting a Project

To create a Project export archive and save it locally (i.e. on the Dataiku instance server), run the following:
    
    
    import os
    dir_path = "path/to/your/project/export/directory"
    archive_name = f"{project.project_key}.zip"
    with project.get_export_stream() as s:
        target = os.path.join(dir_path, archive_name)
        with open(target, "wb") as f:
            for chunk in s.stream(512):
                f.write(chunk)
    

### Deleting a Project

To delete a Project and all its associated objects, run the following:
    
    
    project.delete()
    

Warning

While the Project’s Dataset objects will be deleted, by default the underlying data will remain. To clear the data as well, set the `clear_managed_datasets` argument to `True`. **The deletion operation is permanent so use this method with caution.**

## Detailed examples

This section contains more advanced examples on Projects.

### Editing Project permissions

You can programmatically add or change Group permissions for a given Project using the [`set_permissions()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.set_permissions> "dataikuapi.dss.project.DSSProject.set_permissions") method. In the following example, the ‘readers’ Group is added to the `DKU_TSHIRTS` Project with read-only permissions:
    
    
    import dataiku
    
    PROJECT_KEY = "DKU_TSHIRTS"
    GROUP = "readers"
    
    client = dataiku.api_client()
    project = client.get_project(PROJECT_KEY)
    permissions = project.get_permissions()
    
    new_perm = {
        "group": GROUP,
        "admin": False,
        "executeApp": False,
        "exportDatasetsData": False,
        "manageAdditionalDashboardUsers": False,
        "manageDashboardAuthorizations": False,
        "manageExposedElements": False,
        "moderateDashboards": False,
        "readDashboards": True,
        "readProjectContent": True,
        "runScenarios": False,
        "shareToWorkspaces": False,
        "writeDashboards": False,
        "writeProjectContent": False
    }
    
    permissions["permissions"].append(new_perm)
    project.set_permissions(permissions)
    

### Creating a Project with custom settings

You can add pre-built properties to your Projects when creating them using the API. This example illustrates how to generate a Project and define the following properties:

  * name

  * description

  * tags

  * status

  * checklist




First, create a helper function to generate the checklist :
    
    
    def create_checklist(author, items):
        checklist = {
            "title": "To-do list",
            "createdOn": 0,
            "items": []
        }
        for item in items:
            checklist["items"].append({
                "createdBy": author,
                "createdOn": int(datetime.now().timestamp()),
                "done": False,
                "stateChangedOn": 0,
                "text": item
            })
        return checklist
    

You can now write the creation function, which wraps the [`create_project()`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_project> "dataikuapi.DSSClient.create_project") method and returns a handle to the newly-created Project:
    
    
    def create_custom_project(client,
                              project_key,
                              name,
                              custom_tags,
                              description,
                              checklist_items):
        current_user = client.get_auth_info()["authIdentifier"]
        project = client.create_project(project_key=project_key,
                                        name=name,
                                        owner=current_user,
                                        description=description)
        # Add tags                                 
        tags = project.get_tags()
        tags["tags"] = {k: {} for k in custom_tags}
        project.set_tags(tags)
    
        # Add checklist
        metadata = project.get_metadata()
        metadata["checklists"]["checklists"].append(create_checklist(author=current_user,
                                                                     items=checklist_items))
        project.set_metadata(metadata)
    
        # Set default status to "Draft"
        settings = project.get_settings()
        settings.settings["projectStatus"] = "Draft"
        settings.save()
    
        return project
    

This is how you would call this function:
    
    
    client = dataiku.api_client()
    tags = ["work-in-progress", "machine-learning", "priority-high"]
    checklist = [
        "Connect to data sources",
        "Clean, aggregate and join data",
        "Train ML model",
        "Evaluate ML model",
        "Deploy ML model to production"
        ]
                
    project = create_custom_project(client=client,
                                    project_key="MYPROJECT",
                                    name="A custom Project",
                                    custom_tags=tags,
                                    description="This is a cool Project",
                                    checklist_items=checklist)
    

### Export multiple Projects at once

If instead of just exporting a single Project you want to generate exports several Projects in one go and store the resulting archives in a local Managed Folder, you can extend the usage of [`get_export_stream()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_export_stream> "dataikuapi.dss.project.DSSProject.get_export_stream") with the following example:
    
    
    import dataiku
    import os
    
    from datetime import datetime
    
    PROJECT_KEY = "BACKUP_PROJECTS"
    FOLDER_NAME = "exports"
    PROJECT_KEYS_TO_EXPORT = ["FOO", "BAR"]
    
    # Generate timestamp (e.g. 20221201-123000)
    ts = datetime \
        .now() \
        .strftime("%Y%m%d-%H%M%S")
    
    client = dataiku.api_client()
    project = client.get_project(PROJECT_KEY)
    folder_path = dataiku.Folder(FOLDER_NAME, project_key=PROJECT_KEY) \
        .get_path()
    for pkey in PROJECT_KEYS_TO_EXPORT:
        zip_name = f"{pkey}-{ts}.zip"
        pkey_project = client.get_project(pkey)
        with pkey_project.get_export_stream() as es:
            target = os.path.join(folder_path, zip_name)
            with open(target, "wb") as f:
                for chunk in es.stream(512):
                    f.write(chunk)
    

## Reference documentation

### Classes

[`dataiku.Folder`](<../api-reference/python/managed-folders.html#dataiku.Folder> "dataiku.Folder")(lookup[, project_key, ...]) | Handle to interact with a folder.  
---|---  
[`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.project.DSSProjectGit`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectGit> "dataikuapi.dss.project.DSSProjectGit")(client, ...) | Handle to manage the git repository of a DSS project (fetch, push, pull, ...)  
[`dataiku.Project`](<../api-reference/python/projects.html#dataiku.Project> "dataiku.Project")([project_key]) | This is a handle to interact with the current project  
  
### Functions

[`create_managed_folder`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_managed_folder> "dataikuapi.dss.project.DSSProject.create_managed_folder")(name[, folder_type, ...]) | Create a new managed folder in the project, and return a handle to interact with it  
---|---  
[`create_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_project> "dataikuapi.DSSClient.create_project")(project_key, name, owner[, ...]) | Creates a new project, and return a project handle to interact with it.  
[`delete`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.delete> "dataikuapi.dss.project.DSSProject.delete")([clear_managed_datasets, ...]) | Delete the project  
[`duplicate`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.duplicate> "dataikuapi.dss.project.DSSProject.duplicate")(target_project_key, ...[, ...]) | Duplicate the project  
[`get_auth_info`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_auth_info> "dataikuapi.DSSClient.get_auth_info")([with_secrets]) | Returns various information about the user currently authenticated using this instance of the API client.  
[`get_dataset`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_dataset> "dataikuapi.dss.project.DSSProject.get_dataset")(dataset_name) | Get a handle to interact with a specific dataset  
[`get_export_stream`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_export_stream> "dataikuapi.dss.project.DSSProject.get_export_stream")([options]) | Return a stream of the exported project  
[`get_default_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")() | Get a handle to the current default project, if available (i.e.  
[`get_metadata`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_metadata> "dataikuapi.dss.project.DSSProject.get_metadata")() | Get the metadata attached to this project.  
[`get_path`](<../api-reference/python/managed-folders.html#dataiku.Folder.get_path> "dataiku.Folder.get_path")() | Get the filesystem path of this managed folder.  
[`get_permissions`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_permissions> "dataikuapi.dss.project.DSSProject.get_permissions")() | Get the permissions attached to this project  
[`get_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`get_settings`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_settings> "dataikuapi.dss.project.DSSProject.get_settings")() | Gets the settings of this project.  
[`get_tags`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_tags> "dataikuapi.dss.project.DSSProject.get_tags")() | List the tags of this project.  
[`list_datasets`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_datasets> "dataikuapi.dss.project.DSSProject.list_datasets")([as_type, include_shared, tags]) | List the datasets in this project.  
[`list_project_keys`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_project_keys> "dataikuapi.DSSClient.list_project_keys")() | List the project keys (=project identifiers).  
[`set_metadata`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.set_metadata> "dataikuapi.dss.project.DSSProject.set_metadata")(metadata) | Set the metadata on this project.  
[`set_permissions`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.set_permissions> "dataikuapi.dss.project.DSSProject.set_permissions")(permissions) | Sets the permissions on this project  
[`set_tags`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.set_tags> "dataikuapi.dss.project.DSSProject.set_tags")([tags]) | Set the tags of this project.

---

## [concepts-and-examples/pyspark]

# Pyspark recipes  
  
For an introduction about pyspark recipes in Dataiku, please see [code recipes](<https://doc.dataiku.com/dss/latest/code_recipes/pyspark.html> "\(in Dataiku DSS v14\)")

## Additional documentation

[`dataiku.spark`](<../api-reference/python/pyspark.html#module-dataiku.spark> "dataiku.spark") |   
---|---

---

## [concepts-and-examples/recipes]

# Recipes  
  
This page lists usage examples for performing various operations with recipes through Dataiku Python API. In all examples, `project` is a [`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject") handle, obtained using [`get_project()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project") or [`get_default_project()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")

## Basic operations

### Listing recipes
    
    
    recipes = project.list_recipes()
    # Returns a list of DSSRecipeListItem
    
    for recipe in recipes:
            # Quick access to main information in the recipe list item
            print("Name: %s" % recipe.name)
            print("Type: %s" % recipe.type)
            print("Tags: %s" % recipe.tags) # Returns a list of strings
    
            # You can also use the list item as a dict of all available recipe information
            print("Raw: %s" % recipe)
    

### Deleting a recipe
    
    
    recipe = project.get_recipe('myrecipe')
    recipe.delete()
    

### Modifying tags for a recipe
    
    
    recipe = project.get_recipe('myrecipe')
    settings = recipe.get_settings()
    
    print("Current tags are %s" % settings.tags)
    
    # Change the tags
    settings.tags = ["newtag1", "newtag2"]
    
    # If we changed the settings, we must save
    settings.save()
    

## Recipe creation

Please see [Flow creation and management](<flow.html>)

## Recipe status

You can compute the status of the recipe, which also provides you with the engine information.

### Find the engine used to run a recipe
    
    
    recipe = project.get_recipe("myrecipe")
    status = recipe.get_status()
    print(status.get_selected_engine_details())
    

### Check if a recipe is valid

[`get_status()`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe.get_status> "dataikuapi.dss.recipe.DSSRecipe.get_status") calls the validation code of the recipe
    
    
    recipe = project.get_recipe("myrecipe")
    status = recipe.get_status()
    print(status.get_selected_engine_details())
    

### Find the engines for all recipes of a certain type

This example shows how to filter a list, obtain [`DSSRecipe`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe") objects for the list items, and getting their status
    
    
    for list_item in project.list_recipes():
            if list_item.type == "grouping":
                    recipe = list_item.to_recipe()
                    engine = recipe.get_status().get_selected_engine_details()["type"]
                    print("Recipe %s uses engine %s" % (recipe.name, engine))
    

## Recipe settings

When you use [`get_settings()`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe.get_settings> "dataikuapi.dss.recipe.DSSRecipe.get_settings") on a recipe, you receive a settings object whose class depends on the recipe type. Please see below for the possible types.

### Checking if a recipe uses a particular dataset as input
    
    
    recipe = project.get_recipe("myrecipe")
    settings = recipe.get_settings()
    print("Recipe %s uses input:%s" % (recipe.name, settings.has_input("mydataset")))
    

### Replacing an input of a recipe
    
    
    recipe = project.get_recipe("myrecipe")
    settings = recipe.get_settings()
    
    settings.replace_input("old_input", "new_input")
    settings.save()
    

### Setting the code env of a code recipe
    
    
    recipe = project.get_recipe("myrecipe")
    settings = recipe.get_settings()
    
    # Use this to set the recipe to inherit the project's code env
    settings.set_code_env(inherit=True)
    
    # Use this to set the recipe to use a specific code env
    settings.set_code_env(code_env="myenv")
    
    settings.save()
    

## Reference documentation

### List and status

[`dataikuapi.dss.recipe.DSSRecipe`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")(client, ...) | A handle to an existing recipe on the DSS instance.  
---|---  
[`dataikuapi.dss.recipe.DSSRecipeListItem`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeListItem> "dataikuapi.dss.recipe.DSSRecipeListItem")(...) | An item in a list of recipes.  
[`dataikuapi.dss.recipe.DSSRecipeStatus`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeStatus> "dataikuapi.dss.recipe.DSSRecipeStatus")(...) | Status of a recipe.  
[`dataikuapi.dss.recipe.RequiredSchemaUpdates`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.RequiredSchemaUpdates> "dataikuapi.dss.recipe.RequiredSchemaUpdates")(...) | Handle on a set of required updates to the schema of the outputs of a recipe.  
  
### Settings

[`dataikuapi.dss.recipe.DSSRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeSettings> "dataikuapi.dss.recipe.DSSRecipeSettings")(...) | Settings of a recipe.  
---|---  
[`dataikuapi.dss.recipe.CodeRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.CodeRecipeSettings> "dataikuapi.dss.recipe.CodeRecipeSettings")(...) | Settings of a code recipe.  
[`dataikuapi.dss.recipe.SyncRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SyncRecipeSettings> "dataikuapi.dss.recipe.SyncRecipeSettings")(...) | Settings of a Sync recipe.  
[`dataikuapi.dss.recipe.PrepareRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.PrepareRecipeSettings> "dataikuapi.dss.recipe.PrepareRecipeSettings")(...) | Settings of a Prepare recipe.  
[`dataikuapi.dss.recipe.SamplingRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SamplingRecipeSettings> "dataikuapi.dss.recipe.SamplingRecipeSettings")(...) | Settings of a sampling recipe.  
[`dataikuapi.dss.recipe.GroupingRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.GroupingRecipeSettings> "dataikuapi.dss.recipe.GroupingRecipeSettings")(...) | Settings of a grouping recipe.  
[`dataikuapi.dss.recipe.SortRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SortRecipeSettings> "dataikuapi.dss.recipe.SortRecipeSettings")(...) | Settings of a Sort recipe.  
[`dataikuapi.dss.recipe.TopNRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.TopNRecipeSettings> "dataikuapi.dss.recipe.TopNRecipeSettings")(...) | Settings of a TopN recipe.  
[`dataikuapi.dss.recipe.DistinctRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DistinctRecipeSettings> "dataikuapi.dss.recipe.DistinctRecipeSettings")(...) | Settings of a Distinct recipe.  
[`dataikuapi.dss.recipe.PivotRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.PivotRecipeSettings> "dataikuapi.dss.recipe.PivotRecipeSettings")(...) | Settings of a Pivot recipe.  
[`dataikuapi.dss.recipe.WindowRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.WindowRecipeSettings> "dataikuapi.dss.recipe.WindowRecipeSettings")(...) | Settings of a Window recipe.  
[`dataikuapi.dss.recipe.JoinRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.JoinRecipeSettings> "dataikuapi.dss.recipe.JoinRecipeSettings")(...) | Settings of a join recipe.  
[`dataikuapi.dss.recipe.DownloadRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DownloadRecipeSettings> "dataikuapi.dss.recipe.DownloadRecipeSettings")(...) | Settings of a download recipe.  
[`dataikuapi.dss.recipe.SplitRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SplitRecipeSettings> "dataikuapi.dss.recipe.SplitRecipeSettings")(...) | Settings of a split recipe.  
[`dataikuapi.dss.recipe.StackRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.StackRecipeSettings> "dataikuapi.dss.recipe.StackRecipeSettings")(...) | Settings of a stack recipe.  
  
### Creation

[`dataikuapi.dss.recipe.DSSRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator> "dataikuapi.dss.recipe.DSSRecipeCreator")(type, ...) | Helper to create new recipes.  
---|---  
[`dataikuapi.dss.recipe.SingleOutputRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SingleOutputRecipeCreator> "dataikuapi.dss.recipe.SingleOutputRecipeCreator")(...) | Create a recipe that has a single output.  
[`dataikuapi.dss.recipe.VirtualInputsSingleOutputRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.VirtualInputsSingleOutputRecipeCreator> "dataikuapi.dss.recipe.VirtualInputsSingleOutputRecipeCreator")(...) | Create a recipe that has a single output and several inputs.  
[`dataikuapi.dss.recipe.CodeRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator> "dataikuapi.dss.recipe.CodeRecipeCreator")(...) | Create a recipe running a script.  
[`dataikuapi.dss.recipe.PythonRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.PythonRecipeCreator> "dataikuapi.dss.recipe.PythonRecipeCreator")(...) | Create a Python recipe.  
[`dataikuapi.dss.recipe.SQLQueryRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SQLQueryRecipeCreator> "dataikuapi.dss.recipe.SQLQueryRecipeCreator")(...) | Create a SQL query recipe.  
[`dataikuapi.dss.recipe.PrepareRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.PrepareRecipeCreator> "dataikuapi.dss.recipe.PrepareRecipeCreator")(...) | Create a Prepare recipe  
[`dataikuapi.dss.recipe.SyncRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SyncRecipeCreator> "dataikuapi.dss.recipe.SyncRecipeCreator")(...) | Create a Sync recipe  
[`dataikuapi.dss.recipe.SamplingRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SamplingRecipeCreator> "dataikuapi.dss.recipe.SamplingRecipeCreator")(...) | Create a Sample/Filter recipe  
[`dataikuapi.dss.recipe.DistinctRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DistinctRecipeCreator> "dataikuapi.dss.recipe.DistinctRecipeCreator")(...) | Create a Distinct recipe  
[`dataikuapi.dss.recipe.GroupingRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.GroupingRecipeCreator> "dataikuapi.dss.recipe.GroupingRecipeCreator")(...) | Create a Group recipe.  
[`dataikuapi.dss.recipe.PivotRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.PivotRecipeCreator> "dataikuapi.dss.recipe.PivotRecipeCreator")(...) | Create a Pivot recipe  
[`dataikuapi.dss.recipe.SortRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SortRecipeCreator> "dataikuapi.dss.recipe.SortRecipeCreator")(...) | Create a Sort recipe  
[`dataikuapi.dss.recipe.TopNRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.TopNRecipeCreator> "dataikuapi.dss.recipe.TopNRecipeCreator")(...) | Create a TopN recipe  
[`dataikuapi.dss.recipe.WindowRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.WindowRecipeCreator> "dataikuapi.dss.recipe.WindowRecipeCreator")(...) | Create a Window recipe  
[`dataikuapi.dss.recipe.JoinRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.JoinRecipeCreator> "dataikuapi.dss.recipe.JoinRecipeCreator")(...) | Create a Join recipe.  
[`dataikuapi.dss.recipe.FuzzyJoinRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.FuzzyJoinRecipeCreator> "dataikuapi.dss.recipe.FuzzyJoinRecipeCreator")(...) | Create a FuzzyJoin recipe  
[`dataikuapi.dss.recipe.GeoJoinRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.GeoJoinRecipeCreator> "dataikuapi.dss.recipe.GeoJoinRecipeCreator")(...) | Create a GeoJoin recipe  
[`dataikuapi.dss.recipe.SplitRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SplitRecipeCreator> "dataikuapi.dss.recipe.SplitRecipeCreator")(...) | Create a Split recipe  
[`dataikuapi.dss.recipe.StackRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.StackRecipeCreator> "dataikuapi.dss.recipe.StackRecipeCreator")(...) | Create a Stack recipe  
[`dataikuapi.dss.recipe.DownloadRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DownloadRecipeCreator> "dataikuapi.dss.recipe.DownloadRecipeCreator")(...) | Create a Download recipe  
[`dataikuapi.dss.recipe.PredictionScoringRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.PredictionScoringRecipeCreator> "dataikuapi.dss.recipe.PredictionScoringRecipeCreator")(...) | Create a new Prediction scoring recipe.  
[`dataikuapi.dss.recipe.ClusteringScoringRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.ClusteringScoringRecipeCreator> "dataikuapi.dss.recipe.ClusteringScoringRecipeCreator")(...) | Create a new Clustering scoring recipe,.  
[`dataikuapi.dss.recipe.EvaluationRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.EvaluationRecipeCreator> "dataikuapi.dss.recipe.EvaluationRecipeCreator")(...) | Create a new Evaluate recipe.  
[`dataikuapi.dss.recipe.StandaloneEvaluationRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.StandaloneEvaluationRecipeCreator> "dataikuapi.dss.recipe.StandaloneEvaluationRecipeCreator")(...) | Create a new Standalone Evaluate recipe.  
[`dataikuapi.dss.recipe.ContinuousSyncRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.ContinuousSyncRecipeCreator> "dataikuapi.dss.recipe.ContinuousSyncRecipeCreator")(...) | Create a continuous Sync recipe  
  
### Utilities

[`dataikuapi.dss.utils.DSSComputedColumn`](<../api-reference/python/recipes.html#dataikuapi.dss.utils.DSSComputedColumn> "dataikuapi.dss.utils.DSSComputedColumn")() |   
---|---  
[`dataikuapi.dss.utils.DSSFilter`](<../api-reference/python/recipes.html#dataikuapi.dss.utils.DSSFilter> "dataikuapi.dss.utils.DSSFilter")() | Helper class to build filter objects for use in visual recipes.  
[`dataikuapi.dss.utils.DSSFilterOperator`](<../api-reference/python/recipes.html#dataikuapi.dss.utils.DSSFilterOperator> "dataikuapi.dss.utils.DSSFilterOperator")(value) | An enumeration.

---

## [concepts-and-examples/scenarios-inside]

# Scenarios (in a scenario)  
  
This is the documentation of the API for use in scenarios.

Warning

This API can only be used within a scenario in order to run steps and report on progress of the current scenario.

If you want to control scenarios, please see [Scenarios](<scenarios.html>)

These functions can be used both for “Execute Python code” steps in steps-based scenarios, and for full Python scenarios

A quick description of Python scenarios can be found in [Definitions](<https://doc.dataiku.com/dss/latest/scenarios/definitions.html>). More details and usage samples are also available in [Custom scenarios](<https://doc.dataiku.com/dss/latest/scenarios/custom_scenarios.html>)

The Scenario is the main class you’ll use to interact with DSS in your “Execute Python code” steps and Python scenarios.

## Detailed examples

### Set Scenario step timeout

There is no explicit timeout functionality for a Build step within a Scenario. A common question is how to setup a timeout for a scenario or scenario step to avoid situations where a scenario gets stuck/hung in a running state indefinitely.

You can implement it using the Dataiku Python API. The same scenario step can be re-written as a custom Python step, in which case you can add additional Python code to implement a timeout.

Here is a code sample that you can try:
    
    
    ###########################################################################################
    # !! CUSTOM SCENARIO EXAMPLE !!                                                           #
    # See https://doc.dataiku.com/dss/latest/scenarios/custom_scenarios.html for more details #
    ###########################################################################################
    
    import time
    import dataiku
    from dataiku.scenario import Scenario, BuildFlowItemsStepDefHelper
    from dataikuapi.dss.future import DSSFuture
    
    TIMEOUT_SECONDS = 3600
    
    s = Scenario()
    
    # Replace this commented block by your Scenario steps
    # Example: build a Dataset
    step_handle = s.build_dataset("your_dataset_name", asynchronous=True)
    
    start = time.time()
    while not step_handle.is_done():
        end = time.time()
        print("Duration: {}s".format(end-start))
        if end - start > TIMEOUT_SECONDS:
            f = DSSFuture(dataiku.api_client(), step_handle.future_id)
            f.abort()
            raise Exception("Scenario was aborted because it took too much time.")
    

## Reference documentation

[`dataiku.scenario.scenario.Scenario`](<../api-reference/python/scenarios-inside.html#dataiku.scenario.Scenario> "dataiku.scenario.scenario.Scenario")() | Handle to the current (running) scenario.  
---|---  
[`dataiku.scenario.scenario.BuildFlowItemsStepDefHelper`](<../api-reference/python/scenarios-inside.html#dataiku.scenario.BuildFlowItemsStepDefHelper> "dataiku.scenario.scenario.BuildFlowItemsStepDefHelper")(...) | Helper to build the definition of a 'Build Flow Items' step.

---

## [concepts-and-examples/scenarios]

# Scenarios  
  
The scenario API can control all aspects of managing a scenario.

Note

There is a dedicated API to use _within_ a scenario to run steps and report on progress of the scenario. For that, please see [Scenarios (in a scenario)](<scenarios-inside.html>).

## Example use cases

In all examples, `project` is a [`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject") handle, obtained using [`get_project()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project") or [`get_default_project()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")

### Run a scenario

#### Variant 1: Run and wait for it to complete
    
    
    scenario = project.get_scenario("MYSCENARIO")
    
    scenario.run_and_wait()
    

#### Variant 2: Run, then poll while doing other stuff
    
    
    scenario = project.get_scenario("MYSCENARIO")
    
    trigger_fire = scenario.run()
    
    # When you call `run` a scenario, the scenario is not immediately
    # started. Instead a "manual trigger" fires.
    #
    # This trigger fire can be cancelled if the scenario was already running,
    # or if another trigger fires
    # Thus, the scenario run is not available immediately, and we must "wait"
    # for it
    
    scenario_run = trigger_fire.wait_for_scenario_run()
    
    # Now the scenario is running. We can wait for it synchronously with
    # scenario_run.wait_for_completion(), but if we want to do other stuff
    # at the same time, we can use refresh
    
    while True:
        # Do a bit of other stuff
        # ...
    
        scenario_run.refresh()
        if scenario_run.running:
            print("Scenario is still running ...")
        else:
            print("Scenario is not running anymore")
            break
    
        time.sleep(5)
    

### Get information about the last completed run of a scenario
    
    
    scenario = project.get_scenario("MYSCENARIO")
    
    last_runs = scenario.get_last_runs(only_finished_runs=True)
    
    if len(last_runs) == 0:
        raise Exception("The scenario never ran")
    
    last_run = last_runs[0]
    
    # outcome can be one of SUCCESS, WARNING, FAILED or ABORTED
    print(f"The last run finished with {last_run.outcome}")
    
    # start_time and end_time are datetime.datetime objects
    print(f"Last run started at {last_run.start_time} and finished at {last_run.end_time}")
    

### Disable/enable scenarios

#### Disable and remember

This snippet disables all scenarios in a project (i.e. prevents them from auto-triggering), and also keeps a list of the ones that were active, so that you can selectively re-enable them later
    
    
    # List of scenario ids that were active
    previously_active = []
    
    for scenario in project.list_scenarios(as_type="objects"):
        settings = scenario.get_settings()
    
        if settings.active:
            previously_active.append(scenario.id)
            settings.active = False
            # In order for settings change to take effect, you need to save them
            settings.save()
    

#### Enable scenarios from a list of ids
    
    
    for scenario_id in previously_active:
        scenario = project.get_scenario(scenario_id)
        settings = scenario.get_settings()
    
        settings.active = True
        settings.save()
    

### List the “run as” user for all scenarios

This snippet allows you to list the identity under which a scenario runs:
    
    
    for scenario in project.list_scenarios(as_type="objects"):
        settings = scenario.get_settings()
        # We must use `effective_run_as` and not `run_as` here.
        # run_as contains the "configured" run as, which can be None - in that case, it will run
        # as the last modifier of the scenario
        # effective_run_as is always valued and is the resolved version.
        print(f"Scenario {scenario.id} runs as user {settings.effective_run_as}")
    

### Reassign scenarios to another user

If user “u1” has left the company, you may want to reassign all scenarios that ran under his identity to another user “u2”.
    
    
    for scenario in project.list_scenarios(as_type="objects"):
        settings = scenario.get_settings()
    
        if settings.effective_run_as == "u1":
            print(f"Scenario {scenario.id} used to run as u1, reassigning it")
            # To configure a run_as, we must use the run_as property.
            # effective_run_as is read-only
            settings.run_as = "u2"
            settings.save()
    

### Get the “next expected” run for a scenario

If the scenario has a temporal trigger enabled, this will return a datetime of the approximate next expected run
    
    
    scenario = project.get_scenario("MYSCENARIO")
    # next_run is None if no next run is scheduled
    print(f"Next run is at {scenario.get_status().next_run}")
    

### Get the list of jobs started by a scenario

“Build/Train” or Python steps in a scenario can start jobs. This snippet will give you the list of job ids that a particular scenario run executed.

These job ids can then be used together with [`get_job()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_job> "dataikuapi.dss.project.DSSProject.get_job")
    
    
    scenario = project.get_scenario("MYSCENARIO")
    # Focusing only on the last completed run. Else, use get_last_runs() and iterate
    last_run = scenario.get_last_finished_run()
    
    last_run_details = last_run.get_details()
    
    all_job_ids = []
    for step in last_run_details.steps:
        all_job_ids.extend(step.job_ids)
    
    print(f"All job ids started by scenario run {last_run.id} : {all_job_ids}")
    

### Get the first error that happened in a scenario run

This snippet retrieves the first error that happened during a scenario run.
    
    
    scenario = project.get_scenario("MYSCENARIO")
    
    last_run = scenario.get_last_finished_run()
    
    if last_run.outcome == "FAILED":
        last_run_details = last_run.get_details()
        print(f"Error was: {last_run_details.first_error_details}")
    

### Start multiple scenarios and wait for all of them to complete

This code snippet starts multiple scenarios and returns when all of them have completed, returning the updated DSSScenarioRun for each
    
    
    import time
    
    scenarios_ids_to_run = ["s1", "s2", "s3"]
    
    scenario_runs = []
    
    for scenario_id in scenarios_ids_to_run:
        scenario = project.get_scenario(scenario_id)
    
        trigger_fire = scenario.run()
        # Wait for the trigger fire to have actually started a scenario
        scenario_run = trigger_fire.wait_for_scenario_run()
        scenario_runs.append(scenario_run)
    
    # Poll all scenario runs, until all of them have completed
    while True:
        any_not_complete = False
        for scenario_run in scenario_runs:
            # Update the status from the DSS API
            scenario_run.refresh()
            if scenario_run.running:
                any_not_complete = True
    
        if any_not_complete:
            print("At least a scenario is still running...")
        else:
            print("All scenarios are complete")
            break
    
        # Wait a bit before checking again
        time.sleep(30)
    
    print(f"Scenario run ids and outcomes: {[(sr.id, sr.outcome) for sr in scenario_runs]}")
    

### Change the “from” email for email reporters

Note that usually, we would recommend using variables for “from” and “to” email. But you can also modify them with the API.
    
    
    scenario = project.get_scenario("MYSCENARIO")
    
    settings = scenario.get_settings()
    
    for reporter in settings.raw_reporters:
        # Only look into 'email' kind of reporters
        if reporter["messaging"]["type"] == "mail-scenario":
            messaging_configuration = reporter["messaging"]["configuration"]
            messaging_configuration["sender"] = "[[email protected]](</cdn-cgi/l/email-protection>)"
            print(f"Updated reporter {reporter['id']}")
    
    settings.save()
    

## Detailed examples

This section contains more advanced examples on Scenarios.

### Get last run results

You can programmatically get the outcome of the last finished run for a given Scenario.
    
    
    scenario = project.get_scenario(scenario_id)
    last_run = scenario.get_last_finished_run()
    data = {
        "scenario_id": scenario_id,
        "outcome": last_run.outcome,
        "start_time": last_run.start_time.isoformat(),
        "end_time": last_run.end_time.isoformat()
    }
    print(data)
    

From there, you can easily extend the same logic to loop across all Scenarios within a Project.

## Reference documentation

### Classes

[`dataikuapi.dss.scenario.DSSScenario`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenario> "dataikuapi.dss.scenario.DSSScenario")(client, ...) | A handle to interact with a scenario on the DSS instance.  
---|---  
[`dataikuapi.dss.scenario.DSSScenarioListItem`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioListItem> "dataikuapi.dss.scenario.DSSScenarioListItem")(...) | An item in a list of scenarios.  
[`dataikuapi.dss.scenario.DSSScenarioSettings`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioSettings> "dataikuapi.dss.scenario.DSSScenarioSettings")(...) | Settings of a scenario.  
[`dataikuapi.dss.scenario.DSSScenarioRun`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun> "dataikuapi.dss.scenario.DSSScenarioRun")(...) | A handle containing basic info about a past run of a scenario.  
[`dataikuapi.dss.scenario.DSSScenarioRunDetails`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRunDetails> "dataikuapi.dss.scenario.DSSScenarioRunDetails")(data) | Details of a scenario run, notably the outcome of its steps.  
[`dataikuapi.dss.scenario.DSSScenarioStatus`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioStatus> "dataikuapi.dss.scenario.DSSScenarioStatus")(...) | Status of a scenario.  
[`dataikuapi.dss.scenario.DSSStepRunDetails`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSStepRunDetails> "dataikuapi.dss.scenario.DSSStepRunDetails")(data) | Details of a run of a step in a scenario run.  
[`dataikuapi.dss.scenario.DSSTriggerFire`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSTriggerFire> "dataikuapi.dss.scenario.DSSTriggerFire")(...) | A handle representing the firing of a trigger on a scenario.  
  
### Functions

[`active`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioSettings.active> "dataikuapi.dss.scenario.DSSScenarioSettings.active") | Whether this scenario is currently active, i.e. its auto-triggers are executing.  
---|---  
[`effective_run_as`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioSettings.effective_run_as> "dataikuapi.dss.scenario.DSSScenarioSettings.effective_run_as") | Get the effective 'run as' of the scenario.  
[`end_time`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun.end_time> "dataikuapi.dss.scenario.DSSScenarioRun.end_time") | Get the end time of the scenario run, if it completed, else raises.  
[`first_error_details`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSStepRunDetails.first_error_details> "dataikuapi.dss.scenario.DSSStepRunDetails.first_error_details") | Try to get the details of the first error if this step failed.  
[`get_details`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun.get_details> "dataikuapi.dss.scenario.DSSScenarioRun.get_details")() | Get the full details of the scenario run.  
[`id`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun.id> "dataikuapi.dss.scenario.DSSScenarioRun.id") | Get the identifier of this run.  
[`job_ids`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSStepRunDetails.job_ids> "dataikuapi.dss.scenario.DSSStepRunDetails.job_ids") | Get the list of DSS job ids that were run as part of this step.  
[`next_run`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioStatus.next_run> "dataikuapi.dss.scenario.DSSScenarioStatus.next_run") | Time at which the scenario is expected to run next.  
[`outcome`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun.outcome> "dataikuapi.dss.scenario.DSSScenarioRun.outcome") | The outcome of this scenario run, if available.  
[`raw_reporters`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioSettings.raw_reporters> "dataikuapi.dss.scenario.DSSScenarioSettings.raw_reporters") | Get the list of reporters.  
[`refresh`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun.refresh> "dataikuapi.dss.scenario.DSSScenarioRun.refresh")() | Refresh the details of the run.  
[`run`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenario.run> "dataikuapi.dss.scenario.DSSScenario.run")([params]) | Request a run of the scenario.  
[`run_and_wait`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenario.run_and_wait> "dataikuapi.dss.scenario.DSSScenario.run_and_wait")([params, no_fail]) | Request a run of the scenario and wait the end of the run to complete.  
[`run_as`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioSettings.run_as> "dataikuapi.dss.scenario.DSSScenarioSettings.run_as") | Get the login of the user the scenario runs as.  
[`running`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun.running> "dataikuapi.dss.scenario.DSSScenarioRun.running") | Whether this scenario run is currently running.  
[`save`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioSettings.save> "dataikuapi.dss.scenario.DSSScenarioSettings.save")() | Saves the settings to the scenario  
[`start_time`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun.start_time> "dataikuapi.dss.scenario.DSSScenarioRun.start_time") | Get the start time of the scenario run.  
[`steps`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenarioRunDetails.steps> "dataikuapi.dss.scenario.DSSScenarioRunDetails.steps") | Get the list of runs of the steps.  
[`wait_for_scenario_run`](<../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSTriggerFire.wait_for_scenario_run> "dataikuapi.dss.scenario.DSSTriggerFire.wait_for_scenario_run")([no_fail]) | Poll for the run of the scenario that the trigger fire should initiate.

---

## [concepts-and-examples/snowpark]

# Snowpark  
  
Dataiku can leverage the Snowpark framework in order to read Dataiku datasets stored in Snowflake, build queries using Dataframes and then write the result back to a Snowflake dataset.

## Detailed examples

The [tutorial section](<../tutorials/data-engineering/snowpark-basics/index.html>) contains a dedicated tutorial

## Reference documentation

[`dataiku.snowpark.DkuSnowpark`](<../api-reference/python/snowpark.html#dataiku.snowpark.DkuSnowpark> "dataiku.snowpark.DkuSnowpark") | Handle to create Snowpark sessions from DSS datasets or connections  
---|---

---

## [concepts-and-examples/sql]

# Performing SQL, Hive and Impala queries  
  
You can use the Python APIs to execute SQL queries on any SQL connection in DSS (including Hive and Impala).

Note

There are three capabilities related to performing SQL queries in Dataiku’s Python APIs:

  * [`dataiku.SQLExecutor2`](<../api-reference/python/sql.html#dataiku.SQLExecutor2> "dataiku.SQLExecutor2"), [`dataiku.HiveExecutor`](<../api-reference/python/sql.html#dataiku.HiveExecutor> "dataiku.HiveExecutor") and [`dataiku.ImpalaExecutor`](<../api-reference/python/sql.html#dataiku.ImpalaExecutor> "dataiku.ImpalaExecutor") in the `dataiku` package. It was initially designed for usage within DSS in recipes and Jupyter notebooks. These are used to perform queries and retrieve results, either as an iterator or as a pandas dataframe

  * “partial recipes”. It is possible to execute a “partial recipe” from a Python recipe, to execute a Hive, Impala or SQL query. This allows you to use Python to dynamically generate a SQL (resp Hive, Impala) query and have DSS execute it, as if your recipe was a SQL query recipe. This is useful when you need complex business logic to generate the final SQL query and can’t do it with only SQL constructs.

  * [`dataikuapi.DSSClient.sql_query()`](<../api-reference/python/client.html#dataikuapi.DSSClient.sql_query> "dataikuapi.DSSClient.sql_query") in the `dataikuapi` package. This function was initially designed for usage outside of DSS and only supports returning results as an iterator. It does not support pandas dataframe




We recommend the usage of the `dataiku` variants.

For more details on the two packages, please see [Concepts and examples](<index.html>)

## Executing queries

You can retrieve the results of a SELECT query as a Pandas dataframe.
    
    
    from dataiku import SQLExecutor2
    
    executor = SQLExecutor2(connection="db-connection") # or dataset="dataset_name"
    df = executor.query_to_df("SELECT col1, COUNT(*) as count FROM mytable")
    # df is a Pandas dataframe with two columns : "col1" and "count"
    

Alternatively, you can retrieve the results of a query as an iterator.
    
    
    from dataiku import SQLExecutor2
    
    executor = SQLExecutor2(connection="db-connection")
    query_reader = executor.query_to_iter("SELECT * FROM mytable")
    query_iterator = query_reader.iter_tuples()
    

### Queries with side-effects

For databases supporting commit, the transaction in which the queries are executed is rolled back at the end, as is the default in DSS.

In order to perform queries with side-effects such as INSERT or UPDATE, you need to add `post_queries=['COMMIT']` to your `query_to_df` call.

Depending on your database, DDL queries such as `CREATE TABLE` will also need a `COMMIT` or not.

## Partial recipes

It is possible to execute a “partial recipe” from a Python recipe, to execute a Hive, Impala or SQL query.

This allows you to use Python to dynamically generate a SQL (resp Hive, Impala) query and have DSS execute it, as if your recipe was a SQL query recipe.

This is useful when you need complex business logic to generate the final SQL query and can’t do it with only SQL constructs.

Note

Partial recipes are only possible when you are running a Python recipe. It is not available in the notebooks nor outside of DSS.

The partial recipe behaves like the corresponding SQL (resp Hive, Impala) recipe w.r.t. the inputs and outputs. Notably, a Python recipe in which a partial Hive recipe is executed can only have HDFS datasets as inputs and outputs. Likewise, a Impala or SQL partial recipe having only one ouput, the output dataset has to be specified for the partial recipe execution.

In the following example, we make a first query in order to dynamically build the larger query that runs as the “main” query of the recipe.
    
    
    from dataiku import SQLExecutor2
    
    # get the needed data to prepare the query
    # for example, load from another table
    executor = SQLExecutor2(dataset=my_auxiliary_dataset)
    words = executor.query_to_df(
    "SELECT word FROM word_frequency WHERE frequency > 0.01 AND frequency < 0.99")
    
    # prepare a query dynamically
    sql = 'SELECT id '
    for word in words['word']:
        sql = sql + ", (length(text) - length(regexp_replace(text, '" + word + "', ''))) / " + len(word) + " AS count_" + word
    sql = sql + " FROM reviews"
    
    # execute it
    # no need to instantiate an executor object, the method is static
    my_output_dataset = dataiku.Dataset("my_output_dataset_name")
    SQLExecutor2.exec_recipe_fragment(my_output_dataset, sql)
    

## Executing queries (dataikuapi variant)

Note

We recommend using [`SQLExecutor2`](<../api-reference/python/sql.html#dataiku.SQLExecutor2> "dataiku.SQLExecutor2") rather, especially inside DSS.

Running a query against DSS is a 3-step process:

>   * create the query
> 
>   * run it and fetch the data
> 
>   * verify that the streaming of the results wasn’t interrupted
> 
> 


The verification will make DSS release the resources taken for the query’s execution, so the [`verify()`](<../api-reference/python/sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery.verify> "dataikuapi.dss.sqlquery.DSSSQLQuery.verify") call has to be done once the results have been streamed.

An example of a SQL query on a connection configured in DSS is:
    
    
    streamed_query = client.sql_query('select * from train_set', connection='local_postgres', type='sql')
    row_count = 0
    for row in streamed_query.iter_rows():
            row_count = row_count + 1
    streamed_query.verify() # raises an exception in case something went wrong
    print('the query returned %i rows' % count)
    

Queries against Hive and Impala are also possible. In that case, the type must be set to ‘hive’ or ‘impala’ accordingly, and instead of a connection it is possible to pass a database name:
    
    
    client = DSSClient(host, apiKey)
    streamed_query = client.sql_query('select * from train_set', database='test_area', type='impala')
    ...
    

In order to run queries before or after the main query, but still in the same session, for example to set variables in the session, the API provides 2 parameters `pre_queries` and `post_queries` which take in arrays of queries:
    
    
    streamed_query = client.sql_query('select * from train_set', database='test_area', type='hive', pre_queries=['set hive.execution.engine=tez'])
    ...
    

## Detailed examples

This section contains more advanced examples on executing SQL queries.

### Remap Connections between Design and Automation for SQLExecutor2

When you deploy a project from a Design Node to an Automation Node, you may have to remap the Connection name used as a parameter in [SQLExecutor2](<https://doc.dataiku.com/dss/latest/python-api/sql.html#executing-queries>) to the name of the connection used on the Automation node.
    
    
    from dataiku import SQLExecutor2
    
    # Create a mapping between instance types and corresponding connection names.
    conn_mapping = {"DESIGN": "my_design_connection",
                    "AUTOMATION": "my_prod_connection"}
    
    # Retrieve the current Dataiku instance type
    client = dataiku.api_client()
    instance_type = client.get_instance_info().node_type
    
    # Instanciate a SQLExecutor2 object with the appropriate connection
    executor = SQLExecutor2(connection=conn_mapping[instance_type])
    

## Reference documentation

[`dataiku.SQLExecutor2`](<../api-reference/python/sql.html#dataiku.SQLExecutor2> "dataiku.SQLExecutor2")([connection, dataset]) | This is a handle to execute SQL statements on a given SQL connection.  
---|---  
[`dataiku.HiveExecutor`](<../api-reference/python/sql.html#dataiku.HiveExecutor> "dataiku.HiveExecutor")([dataset, database, ...]) |   
[`dataiku.ImpalaExecutor`](<../api-reference/python/sql.html#dataiku.ImpalaExecutor> "dataiku.ImpalaExecutor")([dataset, database, ...]) |   
[`dataikuapi.dss.sqlquery.DSSSQLQuery`](<../api-reference/python/sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery> "dataikuapi.dss.sqlquery.DSSSQLQuery")(client, ...) | A connection to a database or database-like on which queries can be run through DSS.

---

## [concepts-and-examples/sqlquery]

# SQL Query  
  
## Reference documentation

[`dataikuapi.dss.sqlquery.DSSSQLQuery`](<../api-reference/python/sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery> "dataikuapi.dss.sqlquery.DSSSQLQuery")(client, ...) | A connection to a database or database-like on which queries can be run through DSS.  
---|---

---

## [concepts-and-examples/static-insights]

# Static insights  
  
In DSS code recipes and notebooks, you can create static insights: data files that are created by code and that can be rendered on the dashboard.

This capability can notably be used to embed in one click charts created using:

  * [Plot.ly](<https://doc.dataiku.com/dss/latest/python/plotly.html> "\(in Dataiku DSS v14\)")

  * [Matplotlib](<https://doc.dataiku.com/dss/latest/python/matplotlib.html> "\(in Dataiku DSS v14\)")

  * [Bokeh](<https://doc.dataiku.com/dss/latest/python/bokeh.html> "\(in Dataiku DSS v14\)")

  * [Ggplot](<https://doc.dataiku.com/dss/latest/python/ggplot.html> "\(in Dataiku DSS v14\)")




You can also use it for embedding in the dashboard any kind of content (image, HTML, …)

## Reference documentation

[`dataiku.insights.save_data`](<../api-reference/python/static-insights.html#dataiku.insights.save_data> "dataiku.insights.save_data")(id, payload, ...) | Saves data as a DSS static insight that can be exposed on the dashboard  
---|---  
[`dataiku.insights.save_figure`](<../api-reference/python/static-insights.html#dataiku.insights.save_figure> "dataiku.insights.save_figure")(id[, figure, ...]) | Saves a matplotlib or seaborn figure as a DSS static insight that can be exposed on the dashboard  
[`dataiku.insights.save_bokeh`](<../api-reference/python/static-insights.html#dataiku.insights.save_bokeh> "dataiku.insights.save_bokeh")(id, bokeh_obj[, ...]) | Saves a Bokeh object as a DSS static insight that can be exposed on the dashboard A static HTML export of the provided Bokeh object is done  
[`dataiku.insights.save_plotly`](<../api-reference/python/static-insights.html#dataiku.insights.save_plotly> "dataiku.insights.save_plotly")(id, figure[, ...]) | Saves a Plot.ly figure as a DSS static insight that can be exposed on the dashboard A static HTML export of the provided Plot.ly object is done  
[`dataiku.insights.save_ggplot`](<../api-reference/python/static-insights.html#dataiku.insights.save_ggplot> "dataiku.insights.save_ggplot")(id, gg[, ...]) | Saves a ggplot object as a DSS static insight that can be exposed on the dashboard

---

## [concepts-and-examples/statistics]

# Statistics worksheets  
  
## Reference documentation

[`dataikuapi.dss.statistics.DSSStatisticsWorksheet`](<../api-reference/python/statistics.html#dataikuapi.dss.statistics.DSSStatisticsWorksheet> "dataikuapi.dss.statistics.DSSStatisticsWorksheet")(...) | A handle to interact with a worksheet.  
---|---  
[`dataikuapi.dss.statistics.DSSStatisticsWorksheetSettings`](<../api-reference/python/statistics.html#dataikuapi.dss.statistics.DSSStatisticsWorksheetSettings> "dataikuapi.dss.statistics.DSSStatisticsWorksheetSettings")(...) | A handle to interact with the worksheet settings.  
[`dataikuapi.dss.statistics.DSSStatisticsCardSettings`](<../api-reference/python/statistics.html#dataikuapi.dss.statistics.DSSStatisticsCardSettings> "dataikuapi.dss.statistics.DSSStatisticsCardSettings")(...) | A handle to interact with the card settings.  
[`dataikuapi.dss.statistics.DSSStatisticsCardResult`](<../api-reference/python/statistics.html#dataikuapi.dss.statistics.DSSStatisticsCardResult> "dataikuapi.dss.statistics.DSSStatisticsCardResult")(...) | A handle to interact with the computed result of a `DSSStatisticsCardSettings`.  
[`dataikuapi.dss.statistics.DSSStatisticsComputationSettings`](<../api-reference/python/statistics.html#dataikuapi.dss.statistics.DSSStatisticsComputationSettings> "dataikuapi.dss.statistics.DSSStatisticsComputationSettings")(...) | A handle to interact with the computation settings.  
[`dataikuapi.dss.statistics.DSSStatisticsComputationResult`](<../api-reference/python/statistics.html#dataikuapi.dss.statistics.DSSStatisticsComputationResult> "dataikuapi.dss.statistics.DSSStatisticsComputationResult")(...) | A handle to interact with the computed result of a `DSSStatisticsComputationSettings`.

---

## [concepts-and-examples/streaming-endpoints]

# Streaming Endpoints  
  
Note

There are two main classes related to streaming endpoint handling in Dataiku’s Python APIs:

  * [`dataiku.StreamingEndpoint`](<../api-reference/python/streaming-endpoints.html#dataiku.StreamingEndpoint> "dataiku.StreamingEndpoint") in the `dataiku` package. It was initially designed for usage within DSS in recipes and Jupyter notebooks.

  * [`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint`](<../api-reference/python/streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint") in the `dataikuapi` package. It was initially designed for usage outside of DSS.




Both classes have fairly similar capabilities, but we recommend using [`dataiku.StreamingEndpoint`](<../api-reference/python/streaming-endpoints.html#dataiku.StreamingEndpoint> "dataiku.StreamingEndpoint") within DSS.

For more details on the two packages, please see [The Dataiku Python packages](<../getting-started/dataiku-python-apis/index.html>).

## Reference documentation

Use the following classes to interact with streaming endpoints in Python recipes and notebooks.

[`dataiku.StreamingEndpoint`](<../api-reference/python/streaming-endpoints.html#dataiku.StreamingEndpoint> "dataiku.StreamingEndpoint")(id[, project_key]) | This is a handle to obtain readers and writers on a dataiku streaming endpoint.  
---|---  
[`dataiku.core.streaming_endpoint.StreamingEndpointStream`](<../api-reference/python/streaming-endpoints.html#dataiku.core.streaming_endpoint.StreamingEndpointStream> "dataiku.core.streaming_endpoint.StreamingEndpointStream")(...) | Handle to read a streaming endpoint.  
[`dataiku.core.continuous_write.ContinuousWriterBase`](<../api-reference/python/streaming-endpoints.html#dataiku.core.continuous_write.ContinuousWriterBase> "dataiku.core.continuous_write.ContinuousWriterBase")() | Handle to write using the continuous write API to a dataset or streaming endpoint.  
[`dataiku.core.continuous_write.StreamingEndpointContinuousWriter`](<../api-reference/python/streaming-endpoints.html#dataiku.core.continuous_write.StreamingEndpointContinuousWriter> "dataiku.core.continuous_write.StreamingEndpointContinuousWriter")(...) | Handle to write using the continuous write API to a streaming endpoint.  
  
Use the following class preferably outside of DSS.

[`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint`](<../api-reference/python/streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")(...) | A streaming endpoint on the DSS instance.  
---|---  
[`dataikuapi.dss.continuousactivity.DSSContinuousActivity`](<../api-reference/python/streaming-endpoints.html#dataikuapi.dss.continuousactivity.DSSContinuousActivity> "dataikuapi.dss.continuousactivity.DSSContinuousActivity")(...) | A handle to interact with the execution of a continuous recipe on the DSS instance.

---

## [concepts-and-examples/tables-import]

# Importing tables as datasets  
  
The “import tables as datasets” feature is available through the API, both for Hive and SQL tables

## Importing SQL tables
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    import_definition = project.init_tables_import()
    import_definition.add_sql_table("my_sql_connection", "schema_of_the_databse", "name_of_the_table")
    
    prepared_import = import_definition.prepare()
    future = prepared_import.execute()
    
    import_result = future.wait_for_result()
    

## Importing Hive tables
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    import_definition = project.init_tables_import()
    import_definition.add_hive_table("hdfs_managed", "hive_table_name")
    
    prepared_import = import_definition.prepare()
    future = prepared_import.execute()
    
    import_result = future.wait_for_result()
    

## Reference documentation

### Classes

[`dataikuapi.dss.project.TablesImportDefinition`](<../api-reference/python/tables-import.html#dataikuapi.dss.project.TablesImportDefinition> "dataikuapi.dss.project.TablesImportDefinition")(...) | Temporary structure holding the list of tables to import  
---|---  
[`dataikuapi.dss.project.TablesPreparedImport`](<../api-reference/python/tables-import.html#dataikuapi.dss.project.TablesPreparedImport> "dataikuapi.dss.project.TablesPreparedImport")(...) | Result of preparing a tables import.  
  
### Functions

[`add_hive_table`](<../api-reference/python/tables-import.html#dataikuapi.dss.project.TablesImportDefinition.add_hive_table> "dataikuapi.dss.project.TablesImportDefinition.add_hive_table")(hive_database, hive_table) | Add a Hive table to the list of tables to import  
---|---  
[`add_sql_table`](<../api-reference/python/tables-import.html#dataikuapi.dss.project.TablesImportDefinition.add_sql_table> "dataikuapi.dss.project.TablesImportDefinition.add_sql_table")(connection, schema, table[, ...]) | Add a SQL table to the list of tables to import  
[`execute`](<../api-reference/python/tables-import.html#dataikuapi.dss.project.TablesPreparedImport.execute> "dataikuapi.dss.project.TablesPreparedImport.execute")() | Starts executing the import in background and returns a [`dataikuapi.dss.future.DSSFuture`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") to wait on the result  
[`init_tables_import`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.init_tables_import> "dataikuapi.dss.project.DSSProject.init_tables_import")() | Start an operation to import Hive or SQL tables as datasets into this project  
[`prepare`](<../api-reference/python/tables-import.html#dataikuapi.dss.project.TablesImportDefinition.prepare> "dataikuapi.dss.project.TablesImportDefinition.prepare")() | Run the first step of the import process.

---

## [concepts-and-examples/users-groups]

# Users and groups  
  
The API exposes key parts of the DSS access control management: users and groups. All these can be created, modified and deleted through the API.

## Example use cases

In all examples, `client` is a [`dataikuapi.dssclient.DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient"), obtained either using [`dataikuapi.DSSClient()`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient") or `api_client()`

### Listing users
    
    
    client = DSSClient(host, apiKey)
    dss_users = client.list_users()
    # dss_users is a list of dict. Each item represents one user
    prettyprinter.pprint(dss_users)
    

outputs:
    
    
    [   {   'activeWebSocketSesssions': 0,
            'codeAllowed': True,
            'displayName': 'Administrator',
            'groups': ['administrators', 'data_scientists'],
            'login': 'admin',
            'objectImgHash': 0,
            'sourceType': 'LOCAL'},
        ...
    ]
    

### Listing connected users

You can programmatically retrieve the list of connected users on a Dataiku instance, for example to check if you can safely turn off/restart the instance. This is possible by using the [`list_users()`](<https://doc.dataiku.com/dss/latest/python-api/users-groups.html>) method of the Dataiku public API. That method returns a value for `activeWebSocketSessions`which indicates the number of sessions that a user is logged into at the moment. Anything other than 0 indicates that a user is connected to the instance.
    
    
    import dataiku
    
    client = dataiku.api_client()
    user_list = []
    dss_users = client.list_users()
    for user in dss_users:
        if user.get("activeWebSocketSesssions",None):
            user_list.append(user["displayName"])
    print(user_list)
    

### Creating a user

#### A local user with a password
    
    
    new_user = client.create_user('test_login', 'test_password', display_name='a test user', groups=['all_powerful_group'])
    

`new_user` is a [`dataikuapi.dss.admin.DSSUser`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser")

#### A user who will login through LDAP

Note that it is not usually required to manually create users who will login through LDAP as they can be automatically provisionned
    
    
    new_user = client.create_user('test_login', password=None, display_name='a test user', source_type="LDAP", groups=['all_powerful_group'], profile="DESIGNER")
    

#### A user who will login through SSO

This is only for non-LDAP users that thus will not be automatically provisioned, buut should still be able to log in through SSO.
    
    
    new_user = client.create_user('test_login', password=None, display_name='a test user', source_type="LOCAL_NO_AUTH", groups=['all_powerful_group'], profile="DESIGNER")
    

### Modifying a user’s display name, groups, profile, email, …

To modify the settings of a user, get a handle through [`get_user()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_user> "dataikuapi.DSSClient.get_user"), then use [`get_settings()`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUser.get_settings> "dataikuapi.dss.admin.DSSUser.get_settings")
    
    
    user = client.get_user("theuserslogin")
    
    settings = user.get_settings()
    
    # Modify the settings in the `get_raw()` dict
    settings.get_raw()["displayName"] = "DSS Lover"
    settings.get_raw()["email"] = "[[email protected]](</cdn-cgi/l/email-protection>)"
    settings.get_raw()["userProfile"] = "DESIGNER"
    settings.get_raw()["groups"] = ["group1", "group2", "group3"] # This completely overrides previous groups
    
    # Save the modifications
    settings.save()
    

### Modifying user preferences

You can modify user preferences through the given handle (here `ui_language` for the language - see [`dataikuapi.dss.admin.DSSUserPreferences`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserPreferences> "dataikuapi.dss.admin.DSSUserPreferences") for a comprehensive list of handles).
    
    
    user = client.get_user("theuserslogin")
    settings = user.get_settings()
    settings.preferences.ui_language = 'ja'
    settings.preferences.daily_digest_emails = true
    settings.save()
    

You can also do it through the [`get_raw()`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserSettings.get_raw> "dataikuapi.dss.admin.DSSUserSettings.get_raw") method described above :
    
    
    user = client.get_user("theuserslogin")
    
    settings = user.get_settings()
    
    # Modify the preferences in the `get_raw()` dict
    settings.get_raw()["preferences"]["uiLanguage"] = "en"
    settings.get_raw()["preferences"]["discussionEmails"] = false
    settings.get_raw()["preferences"]["rememberPositionFlow"] = true
    
    # Save the modifications
    settings.save()
    

### Deleting a user
    
    
    user = client.get_user('test_login')
    user.delete()
    

### Modifying user and admin properties
    
    
    user = client.get_user("test_login")
    settings = user.get_settings()
    settings.user_properties["myprop"] = "myvalue"
    settings.admin_properties["myadminprop"] = "myadminvalue"
    settings.save()
    

### Modifying user secrets
    
    
    user = client.get_user("test_login")
    settings = user.get_settings()
    settings.add_secret("secretname", "secretvalue")
    settings.save()
    

### Entering a per-user-credential for a connection
    
    
    user = client.get_user('test_login')
    settings = user.get_settings()
    settings.set_basic_connection_credential("myconnection", "username", "password")
    settings.save()
    

### Entering a per-user-credential for a plugin preset
    
    
    user = client.get_user('test_login')
    settings = user.get_settings()
    settings.set_basic_plugin_credential("myplugin", "my_paramset_id", "mypreset_id", "param_name", "username", "password")
    settings.save()
    

### Retrieve per-user-credential for all the users

Understanding what connections users are using and with what credentials can be useful for a DSS administrator.
    
    
    for dss_user in client.list_users(as_objects=True):
        creds = dss_user.get_settings().get_raw()["credentials"]
        for key, cred in creds.items():
            if cred["type"] == "BASIC":
                user = cred["user"]
            else:
                user = "N/A"  # OAuth credentials don't have a "user"
    
            if "lastUpdate" in cred:
                last_update = str(
                    datetime.datetime.fromtimestamp(cred["lastUpdate"] / 1000)
                )
            else:
                last_update = "NaN"
            print(
                "DSS user=%s cred_for=%s cred_type=%s user=%s lastUpdate=%s"
                % (dss_user.login, key, cred["type"], user, last_update)
            )
    

### Impersonating another user

As a DSS administrator, it can be useful to be able to perform API calls on behalf of another user.
    
    
    user = client.get_user("the_user_to_impersonate")
    client_as_user = user.get_client_as()
    
    # All calls done using `client_as_user` will appear as being performed by `the_user_to_impersonate` and will inherit
    # its permissions
    

### Managing trial status

The **trialStatus** field, part of the user settings, allows you to manage and monitor user trials on a Dataiku instance. The trial status provides details about whether a user is currently on trial, its validity, and expiration. This can be retrieved programmatically via the Dataiku API when querying user details.

#### Example: Checking Trial Status

To retrieve trial status for all users and display their trial details:
    
    
    import dataiku
    
    client = dataiku.api_client()
    dss_users = client.list_users()
    
    for user in dss_users:
        trial_status = user.get("trialStatus", {})
        if trial_status.get("exists", False):
            print(f"User: {user['displayName']}")
            print(f"  Trial granted on: {trial_status['grantedOn']}")
            print(f"  Trial expires on: {trial_status['expiresOn']}")
            print(f"  Trial valid: {trial_status['valid']}")
            print(f"  Trial expired: {trial_status['expired']}")
    
    

#### Trial Status Fields

  * **`exists`** : Indicates if the user is or was on a trial license (`true` if on trial).

  * **`expired`** : Indicates if the trial period has ended (`true` if expired).

  * **`valid`** : Indicates if the trial is active and authorized (`true` if valid).

  * **`expiresOn`** : Timestamp (ms since epoch) for when the trial expires.

  * **`grantedOn`** : Timestamp (ms since epoch) for when the trial was granted.




### Listing groups

A list of the groups can by obtained with the [`list_groups()`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_groups> "dataikuapi.DSSClient.list_groups") method:
    
    
    client = DSSClient(host, apiKey)
    # dss_groups is a list of dict. Each group contains at least a "name" attribute
    dss_groups = client.list_groups()
    prettyprinter.pprint(dss_groups)
    

outputs
    
    
    [   {   'admin': True,
            'description': 'DSS administrators',
            'name': 'administrators',
            'sourceType': 'LOCAL'},
        {   'admin': False,
            'description': 'Read-write access to projects',
            'name': 'data_scientists',
            'sourceType': 'LOCAL'},
        {   'admin': False,
            'description': 'Read-only access to projects',
            'name': 'readers',
            'sourceType': 'LOCAL'}]
    

### Creating a group
    
    
    new_group = client.create_group('test_group', description='test group', source_type='LOCAL')
    

### Modifying settings of a group

First, retrieve the group definition with a [`get_definition()`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSGroup.get_definition> "dataikuapi.dss.admin.DSSGroup.get_definition") call, alter the definition, and set it back into DSS:
    
    
    group_definition = new_group.get_definition()
    group_definition['admin'] = True
    group_definition['ldapGroupNames'] = ['group1', 'group2']
    new_group.set_definition(group_definition)
    

### Deleting a group
    
    
    group = client.get_group('test_group')
    group.delete()
    

## Reference documentation

### Classes

[`dataikuapi.dss.admin.DSSAuthorizationMatrix`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSAuthorizationMatrix> "dataikuapi.dss.admin.DSSAuthorizationMatrix")(...) | The authorization matrix of all groups and enabled users of the DSS instance.  
---|---  
[`dataikuapi.dss.admin.DSSGroup`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSGroup> "dataikuapi.dss.admin.DSSGroup")(client, name) | A group on the DSS instance.  
[`dataikuapi.dss.admin.DSSOwnUser`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUser> "dataikuapi.dss.admin.DSSOwnUser")(client) | A handle to interact with your own user  
[`dataikuapi.dss.admin.DSSOwnUserSettings`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUserSettings> "dataikuapi.dss.admin.DSSOwnUserSettings")(...) | Settings for the current DSS user.  
[`dataikuapi.dss.admin.DSSUser`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser")(client, login) | A handle for a user on the DSS instance.  
[`dataikuapi.dss.admin.DSSUserActivity`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserActivity> "dataikuapi.dss.admin.DSSUserActivity")(client, ...) | Activity for a DSS user.  
[`dataikuapi.dss.admin.DSSUserSettings`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserSettings> "dataikuapi.dss.admin.DSSUserSettings")(client, ...) | Settings for a DSS user.  
[`dataikuapi.dss.admin.DSSUserPreferences`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserPreferences> "dataikuapi.dss.admin.DSSUserPreferences")(...) | Preferences for a DSS user.  
  
### Functions

[`add_secret`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserSettings.add_secret> "dataikuapi.dss.admin.DSSUserSettings.add_secret")(name, value) | Add a user secret.  
---|---  
[`create_group`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_group> "dataikuapi.DSSClient.create_group")(name[, description, source_type]) | Create a group, and return a handle to interact with it  
[`create_user`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_user> "dataikuapi.DSSClient.create_user")(login, password[, display_name, ...]) | Create a user, and return a handle to interact with it  
[`delete`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSGroup.delete> "dataikuapi.dss.admin.DSSGroup.delete")() | Deletes the group  
[`delete`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUser.delete> "dataikuapi.dss.admin.DSSUser.delete")([allow_self_deletion]) | Deletes the user  
[`get_client_as`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUser.get_client_as> "dataikuapi.dss.admin.DSSUser.get_client_as")() | Get an API client that has the permissions of this user.  
[`get_definition`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSGroup.get_definition> "dataikuapi.dss.admin.DSSGroup.get_definition")() | Get the group's definition (name, description, admin abilities, type, ldap name mapping)  
[`get_raw`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserSettings.get_raw> "dataikuapi.dss.admin.DSSUserSettings.get_raw")() | Get the raw settings of the user.  
[`get_settings`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUser.get_settings> "dataikuapi.dss.admin.DSSUser.get_settings")() | Get the settings of the user.  
[`get_user`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_user> "dataikuapi.DSSClient.get_user")(login) | Get a handle to interact with a specific user  
[`list_groups`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_groups> "dataikuapi.DSSClient.list_groups")() | List all groups setup on the DSS instance  
[`list_users`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_users> "dataikuapi.DSSClient.list_users")([as_objects, include_settings]) | List all users setup on the DSS instance  
[`save`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserSettings.save> "dataikuapi.dss.admin.DSSUserSettings.save")() | Saves the settings  
[`set_basic_connection_credential`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserSettings.set_basic_connection_credential> "dataikuapi.dss.admin.DSSUserSettings.set_basic_connection_credential")(connection, ...) | Set per-user-credentials for a connection that takes a user/password pair.  
[`set_basic_plugin_credential`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUserSettings.set_basic_plugin_credential> "dataikuapi.dss.admin.DSSUserSettings.set_basic_plugin_credential")(plugin_id, ...) | Set per-user-credentials for a plugin preset that takes a user/password pair  
[`set_definition`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSGroup.set_definition> "dataikuapi.dss.admin.DSSGroup.set_definition")(definition) | Set the group's definition.

---

## [concepts-and-examples/utils]

# Utilities  
  
These classes are various utilities that are used in various parts of the API.

## Reference documentation

[`dataikuapi.dss.utils.DSSDatasetSelectionBuilder`](<../api-reference/python/utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder")() | Builder for a "dataset selection".  
---|---  
[`dataikuapi.dss.utils.DSSFilterBuilder`](<../api-reference/python/utils.html#dataikuapi.dss.utils.DSSFilterBuilder> "dataikuapi.dss.utils.DSSFilterBuilder")() | Builder for a "filter".  
[`dataikuapi.dss.utils.DSSInfoMessages`](<../api-reference/python/utils.html#dataikuapi.dss.utils.DSSInfoMessages> "dataikuapi.dss.utils.DSSInfoMessages")(data) | Contains a list of [`dataikuapi.dss.utils.DSSInfoMessage`](<../api-reference/python/utils.html#dataikuapi.dss.utils.DSSInfoMessage> "dataikuapi.dss.utils.DSSInfoMessage").  
[`dataikuapi.dss.utils.DSSInfoMessage`](<../api-reference/python/utils.html#dataikuapi.dss.utils.DSSInfoMessage> "dataikuapi.dss.utils.DSSInfoMessage")(data) | A message with a code, a title, a severity and a content.

---

## [concepts-and-examples/webapps]

# Webapps  
  
The webapps API can control all aspects of managing a webapp.

## Example use cases

In all examples, `project` is a [`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject") handle, obtained using [`get_project()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project") or [`get_default_project()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")

### List the webapps of a project and get a handle for the first one

By default, [`list_webapps()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_webapps> "dataikuapi.dss.project.DSSProject.list_webapps") returns a list of dict items describing the webapps of a project. From the dict item, the [`DSSWebApp`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp> "dataikuapi.dss.webapp.DSSWebApp") handle can be obtained using the [`to_webapp()`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppListItem.to_webapp> "dataikuapi.dss.webapp.DSSWebAppListItem.to_webapp") method. Documentation of the [`list_webapps()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_webapps> "dataikuapi.dss.project.DSSProject.list_webapps") and [`get_webapp()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_webapp> "dataikuapi.dss.project.DSSProject.get_webapp") methods can be found in the [API projects documentation](<../api-reference/python/projects.html>).
    
    
    project_webapps = project.list_webapps()
    my_webapp_dict = project_webapps[0]
    print("Webapp name : %s" % my_webapp_dict["name"])
    print("Webapp id : %s" % my_webapp_dict["id"])
    my_webapp = project_webapps[0].to_webapp()
    

### Get a webapp by id, check if the webapp is running and if not, start it

A handle to a webapps state [`DSSWebAppBackendState`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppBackendState> "dataikuapi.dss.webapp.DSSWebAppBackendState") object can be obtained using the [`get_state()`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp.get_state> "dataikuapi.dss.webapp.DSSWebApp.get_state") method.
    
    
    my_webapp = project.get_webapp(my_webapp_id)
    if (not my_webapp.get_state().running):
        my_webapp.start_or_restart_backend()
    

### Stop a webapp backend
    
    
    my_webapp = project.get_webapp(my_webapp_id)
    my_webapp.stop_backend()
    

### Get the settings of a webapp to change its name

A handle to a webapps settings [`DSSWebAppSettings`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppSettings> "dataikuapi.dss.webapp.DSSWebAppSettings") object can be obtained using the [`get_settings()`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp.get_settings> "dataikuapi.dss.webapp.DSSWebApp.get_settings") method.
    
    
    my_webapp = project.get_webapp(my_webapp_id)
    settings = my_webapp.get_settings()
    print("Current webapp name : %s" % settings.data["name"])
    settings.data["name"] = "new webapp name"
    print("New webapp name : %s" % settings.data["name"])
    settings.save()
    

## Reference documentation

### Classes

[`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
---|---  
[`dataikuapi.dss.webapp.DSSWebApp`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp> "dataikuapi.dss.webapp.DSSWebApp")(client, ...) | A handle for the webapp.  
[`dataikuapi.dss.webapp.DSSWebAppBackendState`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppBackendState> "dataikuapi.dss.webapp.DSSWebAppBackendState")(...) | A wrapper object holding the webapp backend state.  
[`dataikuapi.dss.webapp.DSSWebAppListItem`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppListItem> "dataikuapi.dss.webapp.DSSWebAppListItem")(...) | An item in a list of webapps.  
[`dataikuapi.dss.webapp.DSSWebAppSettings`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppSettings> "dataikuapi.dss.webapp.DSSWebAppSettings")(...) | A handle for the webapp settings.  
  
### Functions

[`get_default_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")() | Get a handle to the current default project, if available (i.e.  
---|---  
[`get_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`get_settings`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp.get_settings> "dataikuapi.dss.webapp.DSSWebApp.get_settings")() | 

returns:
    A handle for the webapp settings.  
[`get_state`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp.get_state> "dataikuapi.dss.webapp.DSSWebApp.get_state")() | 

returns:
    A wrapper object holding the webapp backend state.  
[`get_webapp`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_webapp> "dataikuapi.dss.project.DSSProject.get_webapp")(webapp_id) | Get a handle to interact with a specific webapp  
[`list_webapps`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_webapps> "dataikuapi.dss.project.DSSProject.list_webapps")([as_type]) | List the webapp heads of this project  
[`save`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppSettings.save> "dataikuapi.dss.webapp.DSSWebAppSettings.save")() | Save the current webapp settings.  
[`start_or_restart_backend`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp.start_or_restart_backend> "dataikuapi.dss.webapp.DSSWebApp.start_or_restart_backend")() | Start or restart the webapp backend.  
[`stop_backend`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebApp.stop_backend> "dataikuapi.dss.webapp.DSSWebApp.stop_backend")() | Stop the webapp backend.  
[`to_webapp`](<../api-reference/python/webapps.html#dataikuapi.dss.webapp.DSSWebAppListItem.to_webapp> "dataikuapi.dss.webapp.DSSWebAppListItem.to_webapp")() | Convert the current item.

---

## [concepts-and-examples/wiki]

# Wikis  
  
You can interact with the Wiki of each project through the API.

## Getting the DSSWiki object

You must first retrieve the [`DSSWiki`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWiki> "dataikuapi.dss.wiki.DSSWiki") through the [`get_wiki()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_wiki> "dataikuapi.dss.project.DSSProject.get_wiki") method
    
    
    project = client.get_project("MYPROJECT")
    wiki = project.get_wiki()
    

## Retrieving and modifying the content of an article
    
    
    article = wiki.get_article("article_name")
    article_data = article.get_data()
    
    # Modify the content of the article data
    current_markdown_content = article_data.get_body()
    article_data.set_body("# My new Markdown content")
    
    # And save the modified content
    article_data.save()
    

## Deleting an article
    
    
    article = wiki.get_article("article_name")
    article.delete()
    

## Getting the list of all articles

This prints the content of all articles in the Wiki
    
    
    for article in wiki.list_articles():
            print("Article: %s" % article.article_id)
            article_data = article.get_data()
            print("Content:")
            print(article_data.get_body())
    

## Uploading an attachment to an article

After upload, the attachment can be referenced through the Markdown syntax
    
    
    article = wiki.get_article("article_name")
    
    with open("/tmp/myimage.jpg", "rb") as f:
            article.upload_attachement(f, "myimage.jpg")
    
    

## Download an attachment of an article

After being uploaded, the attachment of an article can be retrieved through its upload id
    
    
    article_metadata = article.get_data().get_metadata()
    upload_attachment_id = article_metadata.get('attachments')[0].get("smartId")
    
    attachment_res = article.get_uploaded_file(upload_attachment_id)
    

## Moving an article in the taxonomy

You can change the parent of an article
    
    
    settings = wiki.get_settings()
    settings.move_article_in_taxonomy(article.article_id, parent_article.article_id)
    settings.save()
    

## Changing the home article of the wiki
    
    
    settings = wiki.get_settings()
    settings.set_home_article_id(article.article_id)
    settings.save()
    

## Reference documentation

### Classes

[`dataikuapi.dss.wiki.DSSWiki`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWiki> "dataikuapi.dss.wiki.DSSWiki")(client, project_key) | A handle to manage the wiki of a project  
---|---  
[`dataikuapi.dss.wiki.DSSWikiArticle`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticle> "dataikuapi.dss.wiki.DSSWikiArticle")(client, ...) | A handle to manage an article  
[`dataikuapi.dss.wiki.DSSWikiArticleData`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticleData> "dataikuapi.dss.wiki.DSSWikiArticleData")(...) | A handle to manage an article  
[`dataikuapi.dss.wiki.DSSWikiSettings`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiSettings> "dataikuapi.dss.wiki.DSSWikiSettings")(client, ...) | Global settings for the wiki, including taxonomy.  
  
### Functions

[`delete`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticle.delete> "dataikuapi.dss.wiki.DSSWikiArticle.delete")() | Delete the article  
---|---  
[`get_article`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWiki.get_article> "dataikuapi.dss.wiki.DSSWiki.get_article")(article_id_or_name) | Get a wiki article  
[`get_body`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticleData.get_body> "dataikuapi.dss.wiki.DSSWikiArticleData.get_body")() | Get the markdown body as string  
[`get_data`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticle.get_data> "dataikuapi.dss.wiki.DSSWikiArticle.get_data")() | Get article data handle  
[`get_metadata`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticleData.get_metadata> "dataikuapi.dss.wiki.DSSWikiArticleData.get_metadata")() | Get the article and attachment metadata  
[`get_settings`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWiki.get_settings> "dataikuapi.dss.wiki.DSSWiki.get_settings")() | Get wiki settings  
[`get_uploaded_file`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticle.get_uploaded_file> "dataikuapi.dss.wiki.DSSWikiArticle.get_uploaded_file")(upload_id) | Download an attachment of the article  
[`get_wiki`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_wiki> "dataikuapi.dss.project.DSSProject.get_wiki")() | Get the wiki  
[`move_article_in_taxonomy`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiSettings.move_article_in_taxonomy> "dataikuapi.dss.wiki.DSSWikiSettings.move_article_in_taxonomy")(article_id[, ...]) | An helper to update the taxonomy by moving an article with its children as a child of another article  
[`list_articles`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWiki.list_articles> "dataikuapi.dss.wiki.DSSWiki.list_articles")() | Get a list of all the articles in form of [`dataikuapi.dss.wiki.DSSWikiArticle`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticle> "dataikuapi.dss.wiki.DSSWikiArticle") objects  
[`save`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticleData.save> "dataikuapi.dss.wiki.DSSWikiArticleData.save")() | Save the current article data to the backend.  
[`set_body`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticleData.set_body> "dataikuapi.dss.wiki.DSSWikiArticleData.set_body")(content) | Set the markdown body  
[`set_home_article_id`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiSettings.set_home_article_id> "dataikuapi.dss.wiki.DSSWikiSettings.set_home_article_id")(home_article_id) | Set the home article ID  
[`upload_attachement`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticle.upload_attachement> "dataikuapi.dss.wiki.DSSWikiArticle.upload_attachement")(fp, filename) | Upload and attach a file to the article.

---

## [concepts-and-examples/workspaces]

# Workspaces

You can interact with the Workspaces through the API.

## Basic operations

### Listing workspaces
    
    
    workspaces = client.list_workspaces(True)
    # Returns a list of DSSWorkspace
    for workspace in workspaces:
            # Access to main information in the workspace
            print("Workspace key: %s" % workspace.workspace_key)
            print("Display name: %s" % workspace.get_settings().display_name)
            print("Description: %s" % workspace.get_settings().description)
            print("Permissions: %s" % workspace.get_settings().permissions) # Returns a list of DSSWorkspacePermissionItem
            # You can also list the objects in a workspaces
            print("Objects: %s" % workspace.list_objects())
    

### Modifying workspace
    
    
    from dataikuapi.dss.workspace import DSSWorkspacePermissionItem
    
    workspace = client.get_workspace("WORKSPACE_KEY")
    settings = workspace.get_settings()
    settings.permissions = [*settings.permissions, DSSWorkspacePermissionItem.member_user("LOGIN"), DSSWorkspacePermissionItem.contributor_group("GROUP")]
    settings.save()
    

### Deleting a workspace
    
    
    workspace = client.get_workspace("WORKSPACE_KEY")
    workspace.delete()
    

## Adding and deleting the objects in a workspace
    
    
    workspace = client.get_workspace("WORKSPACE_KEY")
    workspace_objects = workspace.list_objects()
    for workspace_object in workspace_objects:
            workspace_object.remove()
    
    workspace.add_object(client.get_project("PROJECT_KEY").get_dataset("DATASET_NAME")) # To add a dataset
    workspace.add_object(client.get_project("PROJECT_KEY").get_wiki().get_article("ARTICLE"))  # To add an article
    workspace.add_object(client.get_app("APP_ID")) # To add an app
    workspace.add_object({"htmlLink": {"name": "Dataiku", "url": "https://www.dataiku.com/", "description": "Dataiku website"}}) # You can also specify the content as a dict, here we add a link
    

## Reference documentation

### Classes

[`dataikuapi.dss.workspace.DSSWorkspace`](<../api-reference/python/workspaces.html#dataikuapi.dss.workspace.DSSWorkspace> "dataikuapi.dss.workspace.DSSWorkspace")(...) | A handle to interact with a workspace on the DSS instance.  
---|---  
[`dataikuapi.dss.workspace.DSSWorkspaceObject`](<../api-reference/python/workspaces.html#dataikuapi.dss.workspace.DSSWorkspaceObject> "dataikuapi.dss.workspace.DSSWorkspaceObject")(...) | A handle on an object of a workspace  
[`dataikuapi.dss.workspace.DSSWorkspaceSettings`](<../api-reference/python/workspaces.html#dataikuapi.dss.workspace.DSSWorkspaceSettings> "dataikuapi.dss.workspace.DSSWorkspaceSettings")(...) | A handle on the settings of a workspace  
[`dataikuapi.dss.workspace.DSSWorkspacePermissionItem`](<../api-reference/python/workspaces.html#dataikuapi.dss.workspace.DSSWorkspacePermissionItem> "dataikuapi.dss.workspace.DSSWorkspacePermissionItem")() |   
  
### Functions

[`add_object`](<../api-reference/python/workspaces.html#dataikuapi.dss.workspace.DSSWorkspace.add_object> "dataikuapi.dss.workspace.DSSWorkspace.add_object")(object) | Add an object to this workspace.  
---|---  
[`delete`](<../api-reference/python/workspaces.html#dataikuapi.dss.workspace.DSSWorkspace.delete> "dataikuapi.dss.workspace.DSSWorkspace.delete")() | Delete the workspace  
[`get_settings`](<../api-reference/python/workspaces.html#dataikuapi.dss.workspace.DSSWorkspace.get_settings> "dataikuapi.dss.workspace.DSSWorkspace.get_settings")() | Gets the settings of this workspace.  
[`get_workspace`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_workspace> "dataikuapi.DSSClient.get_workspace")(workspace_key) | Get a handle to interact with a specific workspace  
[`list_objects`](<../api-reference/python/workspaces.html#dataikuapi.dss.workspace.DSSWorkspace.list_objects> "dataikuapi.dss.workspace.DSSWorkspace.list_objects")() | List the objects in this workspace  
[`list_workspaces`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_workspaces> "dataikuapi.DSSClient.list_workspaces")([as_objects]) | List the workspaces