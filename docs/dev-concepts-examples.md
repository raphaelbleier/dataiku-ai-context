# Dataiku Docs — dev-concepts-examples

## [concepts-and-examples/administration]

# Administration  
  
Here are some more global administration tasks that can be performed using the DSS Public API:

  * Reading and writing general instance settings

  * Managing user and group impersonation rules for [User Isolation Framework](<https://doc.dataiku.com/dss/latest/user-isolation/index.html>)

  * Managing (creating/modifying) code environments

  * Managing instance variables

  * Listing long-running tasks, getting their status, aborting them

  * Listing running notebooks, getting their status, unloading them

  * Managing global API keys

  * Listing global DSS usages (projects, datasets, recipes, scenarios…)

  * Managing personal API keys




## Detailed examples

This section contains more advanced examples on administration tasks.

### List running Jupyter notebooks

You can use [`dataikuapi.dss.project.DSSProject.list_jupyter_notebooks()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_jupyter_notebooks> "dataikuapi.dss.project.DSSProject.list_jupyter_notebooks") to retrieve a list of notebooks for a given Project, along with useful metadata.
    
    
    import pprint
    import dataiku
    
    def get_instance_notebooks(client):
        all_notebooks = dict()
        for p in client.list_projects():
            p_key = p["projectKey"]
            project = client.get_project(p_key)
            project_notebooks = project.list_jupyter_notebooks()
            if project_notebooks:
                notebooks = []
                for nb in project_notebooks:
                    # If the notebook is active then it has at least 1 running session
                    sessions = nb.get_sessions()
                    if sessions:
                        status = "ACTIVE - {} session(s)".format(len(sessions))
                    else:
                        status = "INACTIVE"
                    notebooks.append({"name": nb.notebook_name,
                                      "status": status})
                all_notebooks[p_key] = notebooks
        return all_notebooks
    
    def pprint_instance_notebooks(client):
        all_notebooks = get_instance_notebooks(client)
        pprint.pprint(all_notebooks)
    
    client = dataiku.api_client()
    pprint_instance_notebooks(client)
    

## Reference documentation

### Classes

[`dataikuapi.dss.admin.DSSGeneralSettings`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSGeneralSettings> "dataikuapi.dss.admin.DSSGeneralSettings")(client) | The general settings of the DSS instance.  
---|---  
[`dataikuapi.dss.admin.DSSUserImpersonationRule`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSUserImpersonationRule> "dataikuapi.dss.admin.DSSUserImpersonationRule")([raw]) | An user-level rule items for the impersonation settings  
[`dataikuapi.dss.admin.DSSGroupImpersonationRule`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSGroupImpersonationRule> "dataikuapi.dss.admin.DSSGroupImpersonationRule")([raw]) | A group-level rule items for the impersonation settings  
[`dataikuapi.dss.admin.DSSInstanceVariables`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSInstanceVariables> "dataikuapi.dss.admin.DSSInstanceVariables")(...) | Dict containing the instance variables.  
[`dataikuapi.dss.future.DSSFuture`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")(client, job_id) | A future represents a long-running task on a DSS instance.  
[`dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`](<../api-reference/python/other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebook> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebook")(...) | A handle on a Python/R/scala notebook.  
[`dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem`](<../api-reference/python/other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem")(...) | An item in a list of Jupyter notebooks.  
[`dataikuapi.dss.jupyternotebook.DSSNotebookSession`](<../api-reference/python/other-administration.html#dataikuapi.dss.jupyternotebook.DSSNotebookSession> "dataikuapi.dss.jupyternotebook.DSSNotebookSession")(...) | Metadata associated to the session of a Jupyter Notebook.  
[`dataikuapi.dss.jupyternotebook.DSSNotebookContent`](<../api-reference/python/other-administration.html#dataikuapi.dss.jupyternotebook.DSSNotebookContent> "dataikuapi.dss.jupyternotebook.DSSNotebookContent")(...) | The content of a Jupyter Notebook.  
[`dataikuapi.dss.sqlnotebook.DSSSQLNotebook`](<../api-reference/python/other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebook> "dataikuapi.dss.sqlnotebook.DSSSQLNotebook")(...) | A handle on a SQL notebook  
[`dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem`](<../api-reference/python/other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem> "dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem")(...) | An item in a list of SQL notebooks  
[`dataikuapi.dss.sqlnotebook.DSSNotebookContent`](<../api-reference/python/other-administration.html#dataikuapi.dss.sqlnotebook.DSSNotebookContent> "dataikuapi.dss.sqlnotebook.DSSNotebookContent")(...) | The content of a SQL notebook  
[`dataikuapi.dss.sqlnotebook.DSSNotebookHistory`](<../api-reference/python/other-administration.html#dataikuapi.dss.sqlnotebook.DSSNotebookHistory> "dataikuapi.dss.sqlnotebook.DSSNotebookHistory")(...) | The history of a SQL notebook  
[`dataikuapi.dss.sqlnotebook.DSSNotebookQueryRunListItem`](<../api-reference/python/other-administration.html#dataikuapi.dss.sqlnotebook.DSSNotebookQueryRunListItem> "dataikuapi.dss.sqlnotebook.DSSNotebookQueryRunListItem")(...) | An item in a list of query runs of a SQL notebook  
[`dataikuapi.dss.notebook.DSSNotebook`](<../api-reference/python/other-administration.html#dataikuapi.dss.notebook.DSSNotebook> "dataikuapi.dss.notebook.DSSNotebook")(client, ...) | A Python/R/Scala notebook on the DSS instance.  
[`dataikuapi.dss.admin.DSSGlobalApiKey`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKey> "dataikuapi.dss.admin.DSSGlobalApiKey")(client, ...) | A global API key on the DSS instance  
[`dataikuapi.dss.admin.DSSGlobalApiKeyListItem`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKeyListItem> "dataikuapi.dss.admin.DSSGlobalApiKeyListItem")(...) | An item in a list of global API keys.  
[`dataikuapi.dss.admin.DSSPersonalApiKey`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKey> "dataikuapi.dss.admin.DSSPersonalApiKey")(...) | A personal API key on the DSS instance.  
[`dataikuapi.dss.admin.DSSPersonalApiKeyListItem`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKeyListItem> "dataikuapi.dss.admin.DSSPersonalApiKeyListItem")(...) | An item in a list of personal API key.  
  
### Functions

[`get_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
---|---  
[`get_sessions`](<../api-reference/python/other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebook.get_sessions> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebook.get_sessions")([as_objects]) | Get the list of running sessions of this Jupyter notebook.  
[`list_jupyter_notebooks`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_jupyter_notebooks> "dataikuapi.dss.project.DSSProject.list_jupyter_notebooks")([active, as_type]) | List the jupyter notebooks of a project.  
[`list_projects`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_projects> "dataikuapi.DSSClient.list_projects")([include_location]) | List the projects

---

## [concepts-and-examples/agents]

# Agents  
  
For more details on the Agents, please refer to our documentation: [AI Agents](<https://doc.dataiku.com/dss/latest/agents/index.html> "\(in Dataiku DSS v14\)").

For more details on the LLM Mesh, please refer to our documentation [Introduction](<https://doc.dataiku.com/dss/latest/generative-ai/introduction.html> "\(in Dataiku DSS v14\)").

If you want more information about the LLM Mesh API, please refer to [LLM Mesh](<llm-mesh.html>).

Tutorials

You can find tutorials on this subject in the Developer Guide: [Agents and Tools for Generative AI](<../tutorials/genai/agents-and-tools/index.html>).

Note

Once you have a `DKUChatModel`, obtained by [`as_langchain_chat_model()`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.as_langchain_chat_model> "dataikuapi.dss.llm.DSSLLM.as_langchain_chat_model"), you can use the langchain methods (like `invoke`, `stream`, etc.)

Tip

In the code provided on this page, you will need to provide ID of other elements. You will find how to [list your LLM](<llm-mesh.html#ce-llm-mesh-get-llm-id>) , [list your Knowledge Bank](<llm-mesh.html#llm-mesh-get-kbs>) or list your Agent Tools in dedicated pages.

## Listing your agents

The following code lists all the Agents and their IDs, which you can reuse in the code samples listed later on this page.

How to retrieve an Agent’s ID
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms()
    for llm in llm_list:
        if 'agent:' in llm.id:
            print(f"- {llm.description} (id: {llm.id})")
    

## Using your agent

Native DSSLLMDKUChatModel

Using the native [`DSSLLM`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM> "dataikuapi.dss.llm.DSSLLM") completion, for more information, refer to [Perform completion queries on LLMs](<llm-mesh.html#ce-llm-mesh-native-llm-completion-on-queries>):

Using your agent
    
    
    import dataiku
    
    AGENT_ID = "" # Fill with your agent id
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(AGENT_ID)
    completion = llm.new_completion()
    resp = completion.with_message("How to run an agent?").execute()
    if resp.success:
        print(resp.text)
    

With the [`DKUChatModel`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.langchain.DKUChatModel> "dataikuapi.dss.langchain.DKUChatModel"), for more information, refer to [LangChain integration](<llm-mesh.html#ce-llm-mesh-langchain-integration>):

Using your agent
    
    
    AGENT_ID = "" # Fill with your agent id
    langchain_llm = project.get_llm(AGENT_ID).as_langchain_chat_model()
    resp = langchain_llm.invoke("How to run an agent?")
    print(resp.content)
    

### Streaming (in a notebook)

Native DSSLLMDKUChatModel

Streaming (in a notebook)
    
    
    from dataikuapi.dss.llm import DSSLLMStreamedCompletionChunk, DSSLLMStreamedCompletionFooter
    from IPython.display import display, clear_output
    
    AGENT_ID = "" # Fill with your agent id
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(AGENT_ID)
    completion = llm.new_completion()
    completion.with_message("Who is the customer fdouetteau? Please provide additional information.")
    
    gen = ""
    for chunk in completion.execute_streamed():
        if isinstance(chunk, DSSLLMStreamedCompletionChunk):
            gen += chunk.data["text"]
            clear_output()
            display("Received text: %s" % gen)
        elif isinstance(chunk, DSSLLMStreamedCompletionFooter):
            print("Completion is complete: %s" % chunk.data)
    

Streaming (in a notebook)
    
    
    from IPython.display import display, clear_output
    
    AGENT_ID = "" # Fill with your agent id
    langchain_llm = project.get_llm(AGENT_ID).as_langchain_chat_model()
    resp = langchain_llm.stream("Who is the customer fdouetteau? Please provide additional information.")
    
    gen = ""
    for r in resp:
        clear_output()
        gen += r.content
        display(gen)
    

### Asynchronous Streaming (in a notebook)

Asynchronous Streaming (in a notebook)
    
    
    import asyncio
    from IPython.display import display, clear_output
    
    async def func(response):
        gen = ""
        async for r in response:
            clear_output()
            gen += r.content
            display(gen)
    
    AGENT_ID = "" # Fill with your agent id
    langchain_llm = project.get_llm(AGENT_ID).as_langchain_chat_model()
    resp = langchain_llm.astream("Who is the customer fdouetteau? Please provide additional information.")
    
    
    await(func(resp))
    

### Agent response: sources and artifacts

When an agent is queried via the Dataiku LLM Mesh, it may return sources to show which documents it has used to formulate its response. It may also return artifacts to enhance its response.

  * Sources are documents that an agent reads to help it formulate an answer to a user’s query.

  * Artifacts are similar to sources, but they are produced by an agent as an output for the user, rather than being read as an input.




After a call to your agent, you will get a [`dataikuapi.dss.llm.DSSLLMCompletionResponse`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionResponse> "dataikuapi.dss.llm.DSSLLMCompletionResponse"). If the call was streamed, you will get a series of `DSSLLMStreamedCompletionChunk` objects and a final `DSSLLMStreamedCompletionFooter` object.

In non-streamed mode, the artifacts are returned in the artifacts field of the response, and the sources are returned in the additionalInformation.sources field of the response:

Agent response in non-streamed mode
    
    
    {
      "ok": true,
      "text": "..."
      "finishReason": "STOP",
      "artifacts": [  ],  /* list of artifact objects */
      "additionalInformation": {
        "sources": [  ],  /* list of source objects */
      }
    }
    

In streamed mode, artifacts are streamed inline with text chunks, and sources are included in the streaming footer:

Agent response in streamed mode
    
    
    {
        {"type": "event", "eventKind": "AGENT_GETTING_READY"}
        {"type": "event", "eventKind": "AGENT_THINKING"}
        {"type": "content", "text": "..." }
        {"type": "content", "artifacts": [  ]}
        {"type": "content", "artifacts": [  ]}
        {"type": "content", "text": "..." }
        /* ... */
        {
          "type": "footer",
          "finishReason": "STOP",
          "additionalInformation": {
            "sources": [  ]
          }
          "trace": " "
        }
    }
    

#### Artifact structure

The `artifact` object has the following structure:

Artifact structure
    
    
    {
      "id": "...",
      "type": "...",
      "name": "...",
      "description": "...",
      "hierarchy": [  ],
      "parts": [  ],
    }
    

  * `id` is optional. It is used for aggregating streaming chunks if one artifact is streamed in multiple chunks.

  * `type` is mandatory. It instructs Dataiku on how to display this artifact and signals which parts are permitted.

  * `name` is optional. It is used in the Dataiku UI to describe this artifact to the user.

  * `description` is optional. It is used in the Dataiku UI to describe this artifact to the user.

  * `hierarchy` is optional. It is used to identify the origin of artifacts in complex agent architectures.

  * `parts` is mandatory. This is a list of part objects, where the data of the artifact resides. Both sources and artifacts share the same data structure for parts (called `items` for sources).




#### Source structure

The `source` object has the following format:

Source structure
    
    
    {
      "toolCallDescription": "...",
      "hierarchy": [  ],
      "items": [  ],
    }
    

  * `toolCallDescription` is optional.

  * `hierarchy` is optional. It is used to identify the origin of artifacts in complex agent architectures.

  * `items` is mandatory. This is a list of part objects, where the data of the artifact resides. Both sources and artifacts share the same data structure for items (called `parts` for artifacts)




#### Source items and Artifact parts structure

The `parts` field of `artifact` and the `items` field of `source` have the same format:

Parts and Items structure
    
    
    {
      "type": "...",
      "index": /* integer value */,
      /* type-specific fields */
    }
    

  * `type` is mandatory. It informs DSS of the type of part this item is, and it determines which type-specific fields can be provided. Possible values are `reasoning` and `text`, but plugins might provide other types.

  * `index` is optional. It is used for aggregating streaming chunks if one part is streamed in multiple chunks.

  * Each part has different additional fields specific to the part type.




When you are provided with `type` `reasoning` you will see the reasoning of the LLM agent separated in different parts. Each part is a sequential reasoning text, leveraging the `index` field. Each of these parts will be provided with the `text` field.

## Code Agents

In Dataiku, you can implement a custom agent in code that leverages models from the LLM Mesh, LangChain, and its wider ecosystem.

The resulting agent becomes part of the LLM Mesh, seamlessly integrating into your AI workflows.

Dataiku includes basic code examples to help you get started. Below are more advanced samples that showcase full-fledged examples of agents built with LangChain and LangGraph. They both work with the internal code environment for retrieval-augmented generation to avoid any code env issue.

Support Assistant (LangChain)Data Analysis Assistant (LangGraph)

This support agent is designed to handle customer inquiries efficiently. With its tools, it can:

  * retrieve relevant information from an FAQ database

  * log issues for follow-up when immediate answers aren’t available

  * escalate complex requests to a human agent when necessary.




We have tested it on this [Paris Olympics FAQ dataset](<https://www.kaggle.com/datasets/sahityasetu/paris-2024-olympics-faq>), which we used to create a knowledge bank with the Embed recipe. We have embedded a column containing both the question and the corresponding answer. Use the agent on inquiries like: How will transportation work in Paris during the Olympic Games? or I booked a hotel for the Olympic games in Paris, but never received any confirmation. What’s happening? and see how it reacts!
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    from dataiku.langchain import LangchainToDKUTracer
    from langchain.tools import Tool
    from langchain.agents import create_openai_tools_agent, AgentExecutor
    from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
    
    ## 1. Set Up Vector Search for FAQs
    # Here, we are using a knowledge bank from the flow, build with our native Embed recipe.
    # We make it a Langchain retriever and pass it to our first tool.
    
    KB_ID = "" # fill with the ID of your Knowledge Bank
    LLM_ID = "" # fill with your LLM id
    
    faq_retriever = dataiku.KnowledgeBank(id=KB_ID).as_langchain_retriever()
    faq_retriever_tool = Tool(
        name="FAQRetriever",
        func=faq_retriever.get_relevant_documents,
        description="Retrieves answers from the FAQ database based on user questions."
    )
    
    
    ## 2. Define (fake) Ticketing & Escalation Tools
    # Simulated ticket creation function
    
    def create_ticket(issue: str):
        # Here, you would typically use the API to your internal ticketing tool.
        return f"Ticket created: {issue}"
    
    
    ticketing_tool = Tool(
        name="CreateTicket",
        func=create_ticket,
        description="Creates a support ticket when the issue cannot be resolved automatically."
    )
    
    
    # Simulated escalation function
    def escalate_to_human(issue: str):
        # This function could send a notification to the support engineers, for instance.
        # It can be useful to attach info about the customer's request, sentiment, and history.
        return f"Escalation triggered: {issue} has been sent to a human agent."
    
    
    escalation_tool = Tool(
        name="EscalateToHuman",
        func=escalate_to_human,
        description="Escalates the issue to a human when it's too complex, or the user is upset."
    )
    
    ## 3. Build the LangChain Agent
    # Define LLM for agent reasoning
    llm = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_chat_model()
    
    # Agent tools (FAQ retrieval + ticketing + escalation)
    tools = [faq_retriever_tool, ticketing_tool, escalation_tool]
    tool_names = [tool.name for tool in tools]
    
    # Define the prompt
    prompt = ChatPromptTemplate.from_messages(
        [
            ("system",
             """You are an AI customer support agent. Your job is to assist users by:
             - Answering questions using the FAQ retriever tool.
             - Creating support tickets for unresolved issues.
             - Escalating issues to a human when necessary."""),
            MessagesPlaceholder("chat_history", optional=True),
            ("human", "{input}"),
            MessagesPlaceholder("agent_scratchpad"),
        ]
    )
    
    # Initialize an agent with tools.
    # Here, we define it as an agent that uses OpenAI tools.
    # More options are available at https://python.langchain.com/api_reference/langchain/agents.html
    
    agent = create_openai_tools_agent(llm=llm, tools=tools, prompt=prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools)
    
    agent_executor.invoke({"input": "How will transportation work in Paris during the Olympic Games?"})
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            prompt = query["messages"][0]["content"]
            tracer = LangchainToDKUTracer(dku_trace=trace)
            # Wrap the agent in an executor
            agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True, handle_parsing_errors=True)
            response = agent_executor.invoke({"input": prompt}, config={"callbacks": [tracer]})
            return {"text": response["output"]}
    

This data analysis agent is designed to automate insights from data.

Given a table (from an SQL database) and its schema (list of columns with information about what they contain), it can:

  * take a user question

  * translate it into an SQL query

  * run the query and fetch the result

  * interpret the result and convert it back into natural language.




The code below was written for [this dataset about car sales](<https://www.kaggle.com/datasets/missionjee/car-sales-report>). We used a Prepare recipe to remove some columns and parse the date to a proper format. Once implemented, test your agent with questions like: What were the top 5 best-selling car models in 2023? or What was the year-over-year evolution in the Scottsdale region regarding the number of sales?.
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    from dataiku.langchain import LangchainToDKUTracer
    
    from langchain.prompts import ChatPromptTemplate
    from dataiku import SQLExecutor2
    
    from langgraph.graph import StateGraph, START, END
    from typing_extensions import TypedDict
    
    
    LLM_ID = "" # fill with your LLM id
    
    # Basic configuration
    # Initialize LLM
    llm = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_chat_model()
    
    # Connect to the sales database
    dataset = dataiku.Dataset("car_data_prepared_sql")
    table_name = dataset.get_location_info().get('info', {}).get('table')
    table_schema = """
    - `Car_id` (TEXT): Unique car ID
    - `Date` (DATE): Date of the sale
    - `Dealer_Name` (TEXT): Name of the car dealer
    - `Company` (TEXT): Company or brand of the car
    - `Model` (TEXT): Model of the car
    - `Transmission` (TEXT): Type of transmission in the car
    - `Color` (TEXT): Color of the car's exterior
    - `Price` (INTEGER): Listed price of the car sold
    - `Body_Style` (TEXT): Style or design of the car's body
    - `Dealer_Region` (TEXT): Geographic region of the car dealer
    """
    
    
    # Here, we are adding a dispatcher as the first step of our graph. If the user query is not related to car sales,
    # the agent will simply answer that it can't talk about anything else that car sales. 
    def dispatcher(state):
        """
        Decides if the query is related to car sales data or just a general question.
        
        Args:
            state (dict): The current graph state
        
        Returns:
            str: Binary decision for the next node to call
        """
        user_query = state["user_query"]
    
        # Classification prompt
        prompt = ChatPromptTemplate.from_messages(
            [
                (
                    "system",
                    "You are a classifier that determines whether a user's query is related to car sales data.\n\n"
                    "The table contains information about car sales, including:\n"
                    "- Sale date & price\n"
                    "- Info about the cars (brand, model, transmission, body style & color) \n"
                    "- Dealer name and region\n\n"
                    "If the query is related to analyzing car sales data, return 'SQL'.\n"
                    "Otherwise, return 'GENERIC'."
                ),
                (
                    "human", "{query}"
                )
            ]
        )
    
        # Get the classification result
        classification = llm.invoke(
            prompt.format_messages(query=user_query)
        ).content.strip()
    
        return classification
    
    
    # First node, take the user input and translate it into a coherent SQL query.
    def sql_translation(state):
        """
        Translates a natural language query into SQL using the database schema.
        
        Args:
            state (dict): The current graph state that contains the user_query
        
        Returns: 
            state (dict): New key added to state -- sql_query -- that contains the query to execute.
        """
        print("---Translate to SQL---")
        user_query = state["user_query"]
    
        # We need to pass the model our table name and schema. Adapt instructions according to your needs, of course.
        prompt = ChatPromptTemplate.from_messages(
            [
                (
                    "system",
                    "You are an AI assistant that converts natural language questions into SQL queries.\n\n"
                    "Here are the table name: {name} and schema:\n{schema}\n\n"
                    "Here are some important rules:\n"
                    "- Use correct table and column names\n"
                    "- Do NOT use placeholders (e.g., '?', ':param').\n"
                    "- The SQL should be executable in PostgreSQL, which means that table and column names should ALWAYS be double-quoted.\n"
                    "- Never return your answer with SQL Markdown decorators. Just the SQL query, nothing else."
                ),
                (
                    "human",
                    "Convert the following natural language query into an SQL query:\n\n{query}"
                )
            ]
        )
    
        # Invoke LLM with formatted prompt
        sql_query = llm.invoke(
            prompt.format_messages(name=table_name, schema=table_schema, query=user_query)
        ).content
        return {"sql_query": sql_query}
    
    
    # Second node, run the SQL query on the table. For this, we are using Dataiku's API.
    def database_query(state):
        """
        Executes the SQL query and retrieves results.
        
        Args:
            state (dict): The current graph state that contains the query to execute.
        
        Returns: 
            state (dict): New key added to state -- query_result -- that contains the result of the query. 
                          Returns an error key if not working. 
        """
        print("---Run SQL query---")
        sql_query = state["sql_query"]
    
        try:
            executor = SQLExecutor2(dataset=dataset)
            df = executor.query_to_df(sql_query)
            return {"query_result": df.to_dict(orient="records")}
        except Exception as e:
            return {"error": str(e)}
    
    
    # Third node, interpret the results and convert it back into natural language.
    def result_interpreter(state):
        """
        Takes the raw database output and converts it into a natural language response.
        
        Args:
            state (dict): The current graph state, that contains the result of the query (or an error if it didn't work)
        
        Returns: 
            state (dict): New key added to state -- response -- that contains the final agent response. 
        """
        print("---Interpret results---")
        query_result = state.get("query_result", [])
    
        if not query_result:
            return {"response": "No results were found, or the query failed."}
    
        prompt = ChatPromptTemplate.from_messages(
            [
                (
                    "system",
                    "You are an AI assistant that summarizes findings from database results in a clear, human-readable format.\n"
                ),
                (
                    "human", "{query_result}"
                )
            ]
        )
    
        formatted_prompt = prompt.format_messages(query_result=query_result)
        if len(formatted_prompt) > 1000:
            return {"response": "The returned results were too long to be analyzed. Rephrase your query."}
    
        summary = llm.invoke(formatted_prompt).content
        return {"response": summary}
    
    
    # On the other branch of our graph, if the question is too generic, the agent will just answer with a generic response. 
    def generic_response(state):
        return {
            "response": "I'm an agent specialized in car sales data analysis. I only have access to info like "
                        "sales date, price, car characteristics, and dealer name or region. "
                        "Ask me anything about car sales!"
        }
    
    
    class AgentState(TypedDict):
        """State object for the agent workflow."""
        user_query: str
        sql_query: str
        query_result: list
        response: str
    
    
    # Create graph
    graph = StateGraph(AgentState)
    
    # Add nodes
    graph.add_node("sql_translation", sql_translation)
    graph.add_node("database_query", database_query)
    graph.add_node("result_interpreter", result_interpreter)
    graph.add_node("generic_response", generic_response)
    
    # Define decision edges
    graph.add_conditional_edges(
        START,
        dispatcher,
        {
            "SQL": "sql_translation",  # If query is about sales, go to SQL path
            "GENERIC": "generic_response"  # Otherwise, respond with a generic answer
        }
    )
    
    # Define SQL query flow
    graph.add_edge("sql_translation", "database_query")
    graph.add_edge("database_query", "result_interpreter")
    graph.add_edge("result_interpreter", END)
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            prompt = query["messages"][0]["content"]
            tracer = LangchainToDKUTracer(dku_trace=trace)
    
            # Compile the graph
            query_analyzer = graph.compile()
    
            result = query_analyzer.invoke({"user_query": prompt}, config={"callbacks": [tracer]})
            resp_text = result["response"]
            sql_query = result.get("sql_query", [])
    
            if not sql_query:
                return {"text": resp_text}
    
            # If the agent did succeed, then we return the final response, as well as the sql_query, for audit purposes.
            full_resp_text = f"{resp_text}\n\nHere is the SQL query I ran:\n\n{sql_query}"
            return {"text": full_resp_text}
    

### Creating your code agent

All code agents must implement the `BaseLLM` class. The `BaseLLM` class is somewhat similar to this implementation:

Creating your code agent
    
    
    class BaseLLM(BaseModel):
        """The base interface for a Custom LLM"""
    
        # Implement this for synchronous answer
        def process(self, query: SingleCompletionQuery, settings: CompletionSettings,
                    trace: SpanBuilder) -> CompletionResponse:
            raise _NotImplementedError
    
        # Implement this for asynchronous answer
        async def aprocess(self, query: SingleCompletionQuery, settings: CompletionSettings,
                           trace: SpanBuilder) -> CompletionResponse:
            raise _NotImplementedError
    
        # Implement this for a streamed answer
        def process_stream(self, query: SingleCompletionQuery, settings: CompletionSettings,
                           trace: SpanBuilder) -> Iterator[StreamCompletionResponse]:
            raise _NotImplementedError
            yield
    
        # Implement this for a asynchronous streamed answer
        async def aprocess_stream(self, query: SingleCompletionQuery,
                                  settings: CompletionSettings, trace: SpanBuilder) -> \
                AsyncIterator[StreamCompletionResponse]:
            raise _NotImplementedError
            yield
    

Generating an answer from a code agent follows the same rules, whether the agent is synchronous, streamed, or not.

  1. Get an LLM (refer to Using your agent, for more details).

  2. Process the input (and the settings).

  3. Potentially manipulate the trace.

  4. Invoke the LLM (refer to Using your agent, for more details).

  5. Return the answer (refer to Using your agent, for more details).




#### 1\. Process the input without history

If you want to deal with the last message, you should only take the last `content` from the query, as highlighted in the following code:

Native DSSLLMDKUChatModel

Process the input without history
    
    
        prompt = query["messages"][-1]["content"]
        completion = llm.new_completion().with_message(prompt)
    
        ## .../...
    
        llm_resp = completion.execute()
    

Process the input without history
    
    
    prompt = query["messages"][-1]["content"]
    message = [HumanMessage(prompt)]
    
    ## .../...
    
    llm_resp = llm.invoke(message)
    

#### 2\. Process the input with history

If your intent is to use your agent conversationally, you may need to process the query to provide the whole context to the LLM.

Native DSSLLMDKUChatModel

Process the input with history
    
    
    completion = llm.new_completion()
    for m in query.get('messages'):
        completion.with_message(m.get('content'), m.get('role'))
    
    ## .../...
    
    llm_resp = completion.execute()
    

Process the input with history
    
    
    messages = []
    for m in query.get('messages'):
        match m.get('role'):
            case 'user':
                messages.append(HumanMessage(m.get('content')))
            case 'assistant':
                messages.append(AIMessage(m.get('content')))
            case 'system':
                messages.append(SystemMessage(m.get('content')))
            case 'tool':
                messages.append(ToolMessage(m.get('content')))
            case _:
                logger.info('Unknown role', m.get('content'))
    
    ##.../...
    
    llm.invoke(messages)
    

#### 3\. Adding trace information

Adding trace information
    
    
    with trace.subspan("Invoke the LLM") as subspan:
        ai_msg = llm.invoke(messages)
        subspan.attributes['messages']= str(messages)
    

### Adding visual dependencies to your Code Agent settings

You can add visual dependencies to your Code Agent to show interactions in the **Flow**. A dependency is represented by a `dict` object with the following structure:
    
    
    {'type': str, 'ref': str}
    

The `type` value is one of the following:

  * `DATASET` and the `ref` value is the Dataset name.

  * `SAVED_MODEL` and the `ref` value is the Model ID.

  * `RETRIEVABLE_KNOWLEDGE` and the `ref` value is the Knowledge Bank ID.




Modifying your Code Agent settings
    
    
    import dataiku
    
    CODE_AGENT_ID = "" # fill with your Code Agent id
    
    client = dataiku.api_client()
    project = client.get_default_project()
    code_agent = project.get_agent(CODE_AGENT_ID)
    
    settings = code_agent.get_settings()
    version = settings.active_version
    vsettings = settings.get_version_settings(version)
    raw = vsettings.get_raw()
    raw["pythonAgentSettings"]["dependencies"] = [] # fill with the dependencies dictionnaries
    vsettings._version_settings = raw
    settings.save()
    

* * *

## Handling the trace

Once you have a trace, you can access the `inputs`, `outputs`, and `attributes` objects, or if you prefer, you can use the `to_dict()` method. Then you can modify these objects to reflect your needs. You can add a child to the trace (use the `subspan()` method) or append another trace to the current trace (use the `append_trace()` method).

In the following code example, we consider `trace` to be a trace, and `dict` to be a dictionary built using `trace.to_dict()`.

Adding input information on a trace
    
    
    trace.inputs["additional_information"] = "Useful information"
    dict["inputs"].update({"additional_information" : "Useful information"})
    

Adding output information on a trace
    
    
    trace.outputs["additional_information"] = "Useful information"
    dict["outputs"].update({"additional_information" : "Useful information"})
    

Adding attributes information on a trace
    
    
    trace.attributes["additional_information"] = "Useful information"
    dict["attributes"].update({"additional_information" : "Useful information"})
    

Changing the name of a trace
    
    
    dict["name"] = "New name"
    

Note

Updating the name is rarely helpful, as you can provide the name with the `subspan()` method

## Agent Tools

### Listing your agent tools

The following code lists all the Agent Tools with their names and IDs, which you can reuse in the code samples listed later on this page.

Listing your agent tools
    
    
    tools_list = project.list_agent_tools()
    
    for tool in tools_list:
        print(f"{tool.name} - {tool.id}")
    

### Creating your agent tool

Creating your agent tool
    
    
    import dataiku
    
    KB_ID = "" # fill with the ID of your Knowledge Bank
    
    client = dataiku.api_client()
    project = client.get_default_project()
    vector_search_tool_creator = project.new_agent_tool("VectorStoreSearch")
    vector_search_tool = vector_search_tool_creator.with_knowledge_bank(KB_ID).create()
    

### Modifying your agent tool settings

Modifying your agent tool settings
    
    
    settings = vector_search_tool.get_settings()
    print(settings.params['maxDocuments'])
    settings.params['maxDocuments'] = 8
    settings.save()
    

### Running your agent tool

Running your agent tool
    
    
    vector_search_tool.run({"searchQuery": "best review"})
    

### Deleting your agent tool

Deleting your agent tool
    
    
    vector_search_tool.delete()
    

### Tool response

The response object contains additional information like `sources` and `artifacts`. The explanations are the same as seen in the Agent response: sources and artifacts section.

Tool response
    
    
    {
      "output": "",
      "trace": "<removed for print>",
      "sources": [],
      "artifacts": []
    }
    

## Retrieval-augmented LLM agent

### Creating your RAG agent

Creating your RAG agent
    
    
    import dataiku
    
    KB_ID = "" # fill with your Knowledge Bank's id
    LLM_ID = "" # fill with your LLM id
    
    client = dataiku.api_client()
    project = client.get_default_project()
    rag_agent = project.create_retrieval_augmented_llm("MyRAG", KB_ID, LLM_ID)
    

### Modifying your RAG agent settings

Modifying your RAG agent settings
    
    
    LLM_ID2 = "" # fill with an alternate LLM id
    rag_agent_settings = rag_agent.get_settings()
    active_version = rag_agent_settings.active_version
    v_rag_agent_settings = rag_agent_settings.get_version_settings(active_version)
    v_rag_agent_settings.llm_id = LLM_ID2
    rag_agent_settings.save()
    

### Running your RAG agent

Running your RAG agent
    
    
    response = rag_agent.as_llm().new_completion().with_message("What will inflation in Europe look like and why?").execute()
    print(response.text)
    

### Deleting your RAG agent

Deleting your RAG agent
    
    
    rag_agent.delete()
    

## Visual Agent

### Creating your visual agent

Creating your visual agent
    
    
    import dataiku
    
    TOOL_ID = "" # fill with your agent tool's id
    
    client = dataiku.api_client()
    project = client.get_default_project()
    agent = project.create_agent("visual1", "TOOLS_USING_AGENT")
    

### Modifying your visual agent settings

Modifying your visual agent settings
    
    
    TOOL_ID = "" # fill with your agent tool id
    tool = project.get_agent_tool(TOOL_ID)
    agent_settings = agent.get_settings()
    versionned_agent_settings = agent_settings.get_version_settings("v1")
    versionned_agent_settings.llm_id = LLM_ID
    versionned_agent_settings.add_tool(tool)
    agent_settings.save()
    

### Running your visual agent

Running your visual agent
    
    
    response = agent.as_llm().new_completion().with_message("tell me everything you know about Dataiku").execute()
    response.text
    

### Deleting your visual agent

Deleting your visual agent
    
    
    agent.delete()
    

## Extracting sources

Suppose you have an agent that is querying a knowledge bank. You can retrieve the sources by using the following code snippet:

Extracting sources
    
    
    #AGENT_ID = "" # Fill with your agent id
    langchain_llm = project.get_llm(AGENT_ID).as_langchain_chat_model()
    messages = "What is the climate in 2024"
    current_agent_response = langchain_llm.invoke(messages)
    last_trace = current_agent_response.response_metadata.get('lastTrace', None)
    attributes = last_trace.get('attributes')
    completionResponse = attributes.get('completionResponse')
    additionalInformation = completionResponse.get('additionalInformation')
    sources = additionalInformation.get('sources')
    for source in sources:
        items = source.get('items')
        for document in items:
            print(document)
    

## Running multiple asynchronous agents

Sometimes, achieving a task requires running multiple agents. Some of the tasks handled by the agent can be run in parallel.

Using `asyncio`Using Langchain Runnable

To run agents in parallel, you need to invoke agents asynchronously, and be sure that your agent/tool is `async` compatible. The `ainvoke()` method allows the user to make an asynchronous call.

Running multiple asynchronous agents
    
    
    import asyncio
    
    AGENT_ID = "" ## Fill you your agent ID (agent:xxxxxxxx)
    langchain_llm = project.get_llm(AGENT_ID).as_langchain_chat_model()
    
    async def queryA():
        try:
            print("Calling query A")
            resp = langchain_llm.ainvoke("Give all the professional information you can about the customer with ID: fdouetteau. Also include information about the company if you can.")
            response = await resp
            return response
        except:
            return None
    
    async def queryB():
        try:
            print("Calling query B")
            resp = langchain_llm.ainvoke("Give all the professional information you can about the customer with ID: tcook. Also include information about the company if you can.")
            response = await resp
            return response
        except:
            return None
    
    ## Uncomment this if you are running into a notebook
    # import nest_asyncio
    # nest_asyncio.apply()
    
    loop = asyncio.get_event_loop()
    results = [asyncio.create_task(query) for query in [queryA(), queryB()]]
    loop.run_until_complete(asyncio.wait(results))
    for r in results:
        if r.result() and r.result().content:
            print(r.result().content)
    

Running multiple asynchronous agents
    
    
    from langchain_core.runnables import RunnableParallel
    from langchain_core.output_parsers import StrOutputParser
    from langchain_core.prompts import PromptTemplate
    
    AGENT_ID = "" ## Fill you your agent ID (agent:xxxxxxxx)
    ids = ["id1", "id2"] ## Use your data
    langchain_llm = project.get_llm(AGENT_ID).as_langchain_chat_model()
    local_prompt = PromptTemplate(
        input_variables=["user_id"],
        template="Give all the professional information you can about the customer with ID: {user_id}. Also include information about the company if you can."
    )
    runnable_map = {
        f"chain_{i}": local_prompt.partial(user_id=ida) | langchain_llm
        for i,ida in enumerate(ids)}
    parallel_chain = RunnableParallel(runnable_map)
    results = parallel_chain.invoke({})
    for key, output in results.items():
        print(f"{key}: {getattr(output, 'content', output)}")
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.langchain.DKUChatModel`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.langchain.DKUChatModel> "dataikuapi.dss.langchain.DKUChatModel")(*args, ...) | Langchain-compatible wrapper around Dataiku-mediated chat LLMs  
[`dataikuapi.dss.llm.DSSLLM`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM> "dataikuapi.dss.llm.DSSLLM")(client, ...) | A handle to interact with a DSS-managed LLM.  
[`dataikuapi.dss.llm.DSSLLMCompletionQuery`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery> "dataikuapi.dss.llm.DSSLLMCompletionQuery")(llm) | A handle to interact with a completion query.  
[`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
  
### Functions

`append_trace`(trace_to_append) |   
---|---  
[`execute`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionsQuery.execute> "dataikuapi.dss.llm.DSSLLMCompletionsQuery.execute")() | Run the completions query and retrieve the LLM response.  
[`execute_streamed`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.execute_streamed> "dataikuapi.dss.llm.DSSLLMCompletionQuery.execute_streamed")([collect_response]) | Run the completion query and retrieve the LLM response as streamed chunks.  
[`get_default_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")() | Get a handle to the current default project, if available (i.e.  
[`get_llm`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_llm> "dataikuapi.dss.project.DSSProject.get_llm")(llm_id) | Get a handle to interact with a specific LLM  
[`list_llms`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms")([purpose, as_type]) | List the LLM usable in this project  
[`new_completion`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.new_completion> "dataikuapi.dss.llm.DSSLLM.new_completion")() | Create a new completion query.  
`subspan`(name) |   
`to_dict`() |   
[`with_message`](<../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.with_message> "dataikuapi.dss.llm.DSSLLMCompletionQuery.with_message")(message[, role]) | Add a message to the completion query.

---

## [concepts-and-examples/api-deployer]

# API Deployer

For an introduction to API Deployer in DSS, please see [this page](<https://doc.dataiku.com/dss/latest/apinode/introduction.html>).

Reference documentation can be found in [API Deployer](<../api-reference/python/api-deployer.html>)

---

## [concepts-and-examples/api-designer/custom-responses]

# Return custom HTTP responses

## Define returned HTTP status codes

Using the `DkuCustomApiException` class, you can control which HTTP status code and message are returned by a deployed API endpoint. This is helpful when you want to handle unexpected response states.

The `DkuCustomApiException` exception’s constructor has two parameters:

  * `message` \- mandatory

  * `http_status_code` \- optional with the default value of `500`




### Python function
    
    
    def api_py_function(p1, p2, p3):
        http_headers = dku_http_request_metadata.headers
    
        # Your custom logic for handling specific header values
        if not http_headers.get("Authorization"):
            raise DkuCustomApiException("The caller is not authorized", http_status_code=401)
    
        # Python function logic
        result = ...
    
        return result
    

### Custom prediction (classification)

The `DkuCustomApiException` class is only accessible from the `predict` method
    
    
    from  dataiku.apinode.predict.predictor import ClassificationPredictor
    import pandas as pd
        def predict(self, features_df):
            http_headers = dku_http_request_metadata.headers
    
            # Your custom logic for handling specific header values
            if not http_headers.get("Authorization"):
                raise DkuCustomApiException("The caller is not authorized", http_status_code=401)
    
            # Prediction logic
            ...
    

### Custom prediction (regression)

The `DkuCustomApiException` class is only accessible from the `predict` method
    
    
    from  dataiku.apinode.predict.predictor import RegressionPredictor
    import pandas as pd
    class MyPredictor(RegressionPredictor):
        def predict(self, features_df):
            http_headers = dku_http_request_metadata.headers
    
            # Your custom logic for handling specific header values
            if not http_headers.get("Authorization"):
                raise DkuCustomApiException("The caller is not authorized", http_status_code=401)
    
            # Prediction logic
            ...
    

## Customize HTTP response content

**Warning:** this feature is only available for Python function endpoints.

The `DkuCustomHttpResponse` can help define the response content type and HTTP headers returned by a deployed Python function API endpoint.

The feature is disabled by default and can be enabled in Python function endpoint settings by checking the “Returns custom response” option. Only the **Static Dataiku API node** and **Kubernetes cluster** infrastructure types support this feature.

### Text response
    
    
    from dataiku.apinode import DkuCustomHttpResponse
    
    def api_py_function():
        response = DkuCustomHttpResponse.create_text_response("Hello, World!")
        return response
    

### XML response
    
    
    import xml.etree.ElementTree as ET
    from dataiku.apinode import DkuCustomHttpResponse
    
    def api_py_function():
        root = ET.Element("person")
        name = ET.SubElement(root, "name")
        name.text = "John Doe"
        age = ET.SubElement(root, "age")
        age.text = str(42)
        xml_string = ET.tostring(root, encoding="unicode")
        response = DkuCustomHttpResponse.create_text_response(xml_string, content_type="text/xml")
        return response
    

### JSON response
    
    
    from dataiku.apinode import DkuCustomHttpResponse
    
    def api_py_function():
        my_values = dict()
        my_values["a"] = "b"
        my_values["c"] = ["e", 42]
        return DkuCustomHttpResponse.create_json_response(my_values, content_type="application/json")
    

### Image response

You can use a content type that reflects the type of the image: `image/png`, `image/jpg`, etc. All common MIME types can be found [here](<https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types/Common_types>).
    
    
    import base64
    from dataiku.apinode import DkuCustomHttpResponse
    
    def api_py_function():
        obj = base64.b64decode("<your-image-encoded-with-base64>")
        response = DkuCustomHttpResponse.create_binary_response(obj, content_type="image/png")
        return response
    

### Extra headers
    
    
    from dataiku.apinode import DkuCustomHttpResponse
    
    def api_py_function():
        response = DkuCustomHttpResponse.create_text_response("Hello, World!")
        # Add headers after instantiation
        response.headers["Machin"] = "Truc"
        # Using the add_header method, define multiple headers with the same key. Valid in a limited set of cases, such as Set-Cookie
        response.add_header("Set-Cookie", "chocolate")
        response.add_header("Set-Cookie", "pecan")
        return response
    

### Using the direct initialization of `DkuCustomHttpResponse`
    
    
    from dataiku.apinode import DkuCustomHttpResponse
    
    def api_py_function():
        response = DkuCustomHttpResponse(
            200,
            "Hello No Helper World", {
            "Content-Type": "text/plain",
            "Content-Encoding": "utf-8"
            }
        )
        return response

---

## [concepts-and-examples/api-designer/index]

# API Designer  
  
For an introduction to API Designer in DSS, please see [this page](<https://doc.dataiku.com/dss/latest/apinode/introduction.html>).

Detailed examples on designing API services:

Reference documentation can be found in [API Designer](<../../api-reference/python/api-designer.html>)

---

## [concepts-and-examples/api-designer/inter-calling]

# Calling another endpoint

A common use-case is to have an API Service with several endpoints (for example several prediction models), and to have an additional “dispatcher” code endpoint that orchestrates the other endpoints.

Users only directly query the dispatcher endpoint, and this dispatcher endpoint in turns needs to query the other endpoints of the same API Service

For example, a dispatcher endpoint could query several prediction models and provide an “aggregated” answer, or it could select which endpoint to query based on query parameters.

For this kind of cases, the dispatcher endpoint would normally need:

>   * To have an API key in order to query the other endpoint, which may not be known at design time
> 
>   * To know the service identifier in order to query the proper URL, which may not be known at design time
> 
>   * To know the port on which the API node server is running, which may not be known at design time
> 
> 


In order to facilitate this kind of setup, in a Python function or prediction endpoint, you can obtain a [`dataikuapi.APINodeClient`](<https://doc.dataiku.com/dss/latest/apinode/api/user-api.html#dataikuapi.APINodeClient> "\(in Dataiku DSS v14\)") that is already preconfigured to query other endpoints of the same service.

Use the following code
    
    
    from dataiku.apinode import utils
    
    def my_api_function():
            client = utils.get_self_client()
    
            # client is now a dataikuapi.APINodeClient, so you can use the regular methods
            # to query other endpoints
            result = client.predict_record("other_endpoint", {"feature1" : "value1", "feature2" : 42})
    

Warning

The call to `utils.get_self_client()` must be called _within_ your function or `predict` method. Calling this in your initialization will not retrieve the API Key.

Note

You may cache the returned client, in order to keep persistent HTTP connections. However, doing that will cause subsequent queries to service to reuse the same API key, which may be undesirable.

---

## [concepts-and-examples/api-designer/request-metadata]

# Access HTTP Request Metadata

You can access the metadata of HTTP requests from “Python function” and “Custom prediction (Python)” endpoints by using the `dku_http_request_metadata` variable within your custom code.

The `dku_http_request_metadata` variable is an object with the following properties:

  * `headers` \- an instance of [`wsgiref.headers.Headers`](<https://docs.python.org/3/library/wsgiref.html#wsgiref.headers.Headers>) that holds headers used in a request.

  * `path` \- a relative URL’s path as a string to which the client sent an HTTP request. Example: `"/public/api/v1/python-service/py-func/run"`.




The feature is disabled by default and can be enabled by an infrastructure admin in the following ways:

  * Use the _“Enable` dku_http_request_metadata` variable”_ setting in the general settings of the **Kubernetes cluster** , **Azure ML** , **Amazon SageMaker** , **Snowflake Snowpark** , and **Google Vertex AI** infrastructures.

  * On a **Static Dataiku API node** infrastructure, add the following key-value pair to an API node’s `<api-node-root-dir>/config/server.json` file
        
        "isRequestMetadataEnabled": true
        

  * The variable is always enabled when running test queries in the API Designer




## Python function
    
    
    def api_py_function():
        # Your custom logic for handling specific header values
        if not dku_http_request_metadata.headers.get("Authorization"):
            raise Exception("Received no Authorization header")
    
        # Python function logic
        result = ...
    
        return result
    

## Custom prediction (classification)

The `dku_http_request_metadata` is accessible from the `predict` method
    
    
    from  dataiku.apinode.predict.predictor import ClassificationPredictor
    import pandas as pd
    class MyPredictor(ClassificationPredictor):
        def predict(self, features_df):
            # Your custom logic for handling specific header values
            if not dku_http_request_metadata.headers.get("Authorization"):
                raise Exception("Received no Authorization header")
    
            # Prediction logic
            predictions = ...
            return (predictions, None)
    

## Custom prediction (regression)

The `dku_http_request_metadata` is accessible from the `predict` method
    
    
    from  dataiku.apinode.predict.predictor import RegressionPredictor
    import pandas as pd
    class MyPredictor(RegressionPredictor):
        def predict(self, features_df):
            # Your custom logic for handling specific header values
            if not dku_http_request_metadata.headers.get("Authorization"):
                raise Exception("Received no Authorization header")
    
            # Prediction logic
            predictions = ...
            return (predictions, None)

---

## [concepts-and-examples/authinfo]

# Authentication information and impersonation  
  
## Introduction

From any Python code, it is possible to retrieve information about the user or API key currently running this code.

This can be used:

  * From code running within a recipe or notebook, for the code to know who is running said code

  * From code running with a plugin recipe, for the code to know who is running said code

  * From code running outside of DSS, simply to retrieve details of the current API key




Furthermore, the API provides the ability, from a set of HTTP headers, to identify the user represented by these headers. This can be used in the backend of a webapp (either Flask, FastAPI, Bokeh, Dash, or Streamlit), in order to securely identify which user is currently browsing the webapp.

## Code samples

### Getting your own login information
    
    
    import dataiku
    
    client = dataiku.api_client()
    auth_info = client.get_auth_info()
    
    # auth_info is a dict which contains at least a "authIdentifier" field, which is the login for a user
    print("User running this code is %s" % auth_info["authIdentifier"])
    

### Authenticating calls made from a webapp

Please see [Webapps and security](<https://doc.dataiku.com/dss/latest/webapps/security.html>) and [Impersonation with webapps](<../tutorials/webapps/common/impersonation/index.html>)

### Impersonating another user

As a DSS administrator, it can be useful to be able to perform API calls on behalf of another user.
    
    
    import dataiku
    
    client = dataiku.api_client()
    
    user = client.get_user("the_user_to_impersonate")
    client_as_user = user.get_client_as()
    
    # All calls done using `client_as_user` will appear as being performed by `the_user_to_impersonate` and will inherit
    # its permissions
    

### Modifying your own user properties

As a user (not an administrator), you can modify some of your own settings:

  * User properties

  * User secrets (see below)

  * Per-user-credentials (see below)



    
    
    import dataiku
    
    client = dataiku.api_client()
    my_user = client.get_own_user()
    settings = my_user.get_settings()
    settings.user_properties["myprop"] = "myvalue"
    settings.save()
    

### Modifying your own user secrets
    
    
    import dataiku
    
    client = dataiku.api_client()
    my_user = client.get_own_user()
    settings = my_user.get_settings()
    settings.add_secret("secretname", "secretvalue")
    settings.save()
    

### Entering a per-user-credential for a connection, for yourself

To do it for other users, [Users and groups](<https://doc.dataiku.com/dss/latest/python-api/users-groups.html>).
    
    
    import dataiku
    
    client = dataiku.api_client()
    my_user = client.get_own_user()
    settings = my_user.get_settings()
    settings.set_basic_connection_credential("myconnection", "username", "password")
    settings.save()
    

### Entering a per-user-credential for a plugin preset, for yourself

To do it for other users, see [Users and groups](<https://doc.dataiku.com/dss/latest/python-api/users-groups.html>).
    
    
    import dataiku
    
    client = dataiku.api_client()
    my_user = client.get_own_user()
    settings = my_user.get_settings()
    settings.set_basic_plugin_credential("myplugin", "my_paramset_id", "mypreset_id", "param_name", "username", "password")
    settings.save()
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.admin.DSSOwnUser`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUser> "dataikuapi.dss.admin.DSSOwnUser")(client) | A handle to interact with your own user  
[`dataikuapi.dss.admin.DSSOwnUserSettings`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUserSettings> "dataikuapi.dss.admin.DSSOwnUserSettings")(...) | Settings for the current DSS user.  
[`dataikuapi.dss.admin.DSSUser`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser")(client, login) | A handle for a user on the DSS instance.  
  
### Functions

[`add_secret`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUserSettings.add_secret> "dataikuapi.dss.admin.DSSOwnUserSettings.add_secret")(name, value) | Add a user secret.  
---|---  
[`get_auth_info`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_auth_info> "dataikuapi.DSSClient.get_auth_info")([with_secrets]) | Returns various information about the user currently authenticated using this instance of the API client.  
[`get_auth_info_from_browser_headers`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_auth_info_from_browser_headers> "dataikuapi.DSSClient.get_auth_info_from_browser_headers")(headers_dict) | Returns various information about the DSS user authenticated by the dictionary of HTTP headers provided in headers_dict.  
[`get_client_as`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSUser.get_client_as> "dataikuapi.dss.admin.DSSUser.get_client_as")() | Get an API client that has the permissions of this user.  
[`get_own_user`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_own_user> "dataikuapi.DSSClient.get_own_user")() | Get a handle to interact with the current user  
[`get_settings`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUser.get_settings> "dataikuapi.dss.admin.DSSOwnUser.get_settings")() | Get your own settings  
[`get_user`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_user> "dataikuapi.DSSClient.get_user")(login) | Get a handle to interact with a specific user  
[`set_basic_connection_credential`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUserSettings.set_basic_connection_credential> "dataikuapi.dss.admin.DSSOwnUserSettings.set_basic_connection_credential")(connection, ...) | Set per-user-credentials for a connection that takes a user/password pair.  
[`set_basic_plugin_credential`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUserSettings.set_basic_plugin_credential> "dataikuapi.dss.admin.DSSOwnUserSettings.set_basic_plugin_credential")(plugin_id, ...) | Set per-user-credentials for a plugin preset that takes a user/password pair  
[`user_properties`](<../api-reference/python/users-groups.html#dataikuapi.dss.admin.DSSOwnUserSettings.user_properties> "dataikuapi.dss.admin.DSSOwnUserSettings.user_properties") | Get the user properties for this user.

---

## [concepts-and-examples/bigframes]

# Bigframes  
  
Dataiku can leverage the Bigframes framework in order to read Dataiku datasets stored in BigQuery, build queries using Dataframes and then write the result back to a BigQuery dataset.

## Detailed examples

The [tutorial section](<../tutorials/data-engineering/bigframes-basics/index.html>) contains a dedicated tutorial

## Reference documentation

[`dataiku.bigframes.DkuBigframes`](<../api-reference/python/bigframes.html#dataiku.bigframes.DkuBigframes> "dataiku.bigframes.DkuBigframes") | Handle to create Bigframes sessions from DSS datasets or connections  
---|---

---

## [concepts-and-examples/client]

# The main API client  
  
The [`DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient") class is the entry point for many of the capabilities of the Dataiku API.

Dataiku provides two different packages serving different roles. For more on the differences between the packages, please refer to [The Dataiku Python packages](<../getting-started/dataiku-python-apis/index.html>). For additional information, please refer to the [Dataiku API](<../tutorials/devtools/api.html>) section.

## Creating a client from inside DSS

To work with the API, a connection must be established with DSS by creating a [`DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient") object. Once the connection is established, the [`DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient") object serves as the entry point to the other calls.
    
    
    import dataiku
    
    client = dataiku.api_client()
    
    # client is now a DSSClient and can perform all authorized actions.
    # For example, list the project keys for which you have access
    client.list_project_keys()
    

## Creating a client from outside DSS

To work with the API, a connection must be established with DSS by creating a [`DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient") object. Once the connection is established, the [`DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient") object serves as the entry point to the other calls.
    
    
    import dataikuapi
    
    host = "http://localhost:11200"
    apiKey = "some_key"
    client = dataikuapi.DSSClient(host, apiKey)
    
    # client is now a DSSClient and can perform all authorized actions.
    # For example, list the project keys for which the API key has access
    client.list_project_keys()
    

### Turning off the SSL certificate check

If your DSS has SSL enabled, the package will verify the certificate. You may need to add the root authority that signed the DSS SSL certificate to your local trust store for this to work. Please refer to your OS or Python manual for instructions.

If this is not possible, you can also turn off checking the SSL certificate by using `DSSClient(host, apiKey, insecure_tls=True)`

## Reference documentation

### Classes

[`dataikuapi.dssclient.DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient")(host[, ...]) | Entry point for the DSS API client  
---|---  
  
### Functions

[`list_project_keys`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_project_keys> "dataikuapi.DSSClient.list_project_keys")() | List the project keys (=project identifiers).  
---|---

---

## [concepts-and-examples/cloud/index]

# Cloud (Launchpad)  
  
This page provides examples for managing users and access on Dataiku Cloud spaces through the Launchpad API.

## Creating a Launchpad client

Use [`LaunchpadClient`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient> "dataikuapi.launchpad_client.LaunchpadClient") as the entry point for all operations. To create an API key, go to your space and select **Users & Access Management** > **API keys**.
    
    
    from dataikuapi.launchpad_client import LaunchpadClient
    
    space_id = "<space-id>"
    api_key_id = "<api-key-id>"
    api_key_secret = "<api-key-secret>"
    
    client = LaunchpadClient(
        space_id=space_id,
        api_key_id=api_key_id,
        api_key_secret=api_key_secret
    )
    

## Creating groups

Create groups first, then add invites and users. [`build_group()`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient.build_group> "dataikuapi.launchpad_client.LaunchpadClient.build_group") returns a handle; the group is created in the Launchpad on save. In the following example, the group has no permissions on Govern or Dataiku nodes.
    
    
    group = client.build_group(
        name="analytics-team",
        description="Analytics users"
    )
    group.launchpad_permissions = {"mayTurnOnSpace": True}
    group.save()
    

## Creating invites

Invites are used to provision users. Once an invite is accepted, the person appears as a user in [`list_users()`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient.list_users> "dataikuapi.launchpad_client.LaunchpadClient.list_users").
    
    
    group_name = "analytics-team"
    # Single invite
    invite = client.build_invite(
        email="[[email protected]](</cdn-cgi/l/email-protection>)",
        profile="reader",
        groups=[group_name]
    )
    successes, errors = client.create_invites([invite])
    
    # Bulk invites
    invites = [
        client.build_invite("[[email protected]](</cdn-cgi/l/email-protection>)", "reader", [group_name]),
        client.build_invite("[[email protected]](</cdn-cgi/l/email-protection>)", "reader", [group_name]),
    ]
    successes, errors = client.create_invites(invites)
    

## Updating users

Users are available only after an invite is accepted.
    
    
    # List users currently present in the space
    users = client.list_users()
    
    # Update profile and groups for existing users
    user = client.get_user("[[email protected]](</cdn-cgi/l/email-protection>)")
    user.set_profile("designer", is_trial=False)
    user.add_groups(["analytics-team"])
    
    updated, update_errors = client.update_users([user])
    

## Adding multiple groups to a user

Use [`add_groups()`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.user.LaunchpadUser.add_groups> "dataikuapi.launchpad.user.LaunchpadUser.add_groups") to add multiple groups to one user.
    
    
    user = client.get_user("[[email protected]](</cdn-cgi/l/email-protection>)")
    user.add_groups(["analytics-team", "data-scientists", "designers"])
    updated, update_errors = client.update_users([user])
    

## Adding users to a group

Use [`add_users()`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.group.LaunchpadGroup.add_users> "dataikuapi.launchpad.group.LaunchpadGroup.add_users") to add existing users to a group.
    
    
    group = client.get_group("analytics-team")
    group.add_users(["[[email protected]](</cdn-cgi/l/email-protection>)", "[[email protected]](</cdn-cgi/l/email-protection>)"])
    group.save()
    

## Permissions

Permissions are managed on groups and assigned to nodes that have been granted access to the group.

Note

Permissions need to be consistent across all nodes of the same type accessible by the same group.

Permissions differ for the Launchpad, Dataiku nodes, and Govern nodes.

Note

[`update_permissions()`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.group.LaunchpadGroup.update_permissions> "dataikuapi.launchpad.group.LaunchpadGroup.update_permissions") grants node access by default. It can be disabled by using `grant_node_access=False` as a parameter.
    
    
    # List permissions on the group, a group need to have access to the nodes to list permissions
    group.launchpad_permissions
    group.dataiku_permissions
    group.govern_permissions
    
    # List accessible nodes by the group
    group.accessible_nodes
    
    # Grant access to node "design-0" with no permissions
    group.grant_node_access(
        node_name="design-0",
    )
    group.save()
    
    # List default permissions for design-0
    group.dataiku_permissions
    
    # Grant access and copy permissions from another node
    group.grant_node_access(
        node_name="automation-0",
        copy_permissions_from_node="design-0"
    )
    
    # Update permissions for all Dataiku nodes
    group.update_permissions(
        permissions={"mayCreateProjects": True},
        node_type="dataiku"
    )
    
    # Update permissions for one specific node
    group.update_permissions(
        permissions={"mayCreateProjects": True},
        node_name="design-0"
    )
    
    # Update permissions for the Govern node
    group.update_permissions(
        permissions={"mayManageGovern": True},
        node_type="govern"
    )
    
    group.save()
    

## Inspecting profiles and nodes

Before provisioning users, check available profiles (seats) and target nodes.
    
    
    profiles = client.list_profiles()
    nodes = client.list_nodes()
    
    # Optional: filter nodes by type
    dataiku_nodes = client.list_nodes(type="dataiku")
    govern_nodes = client.list_nodes(type="govern")
    

## Other useful operations

You may also need:

  * `client.update_invites(...)` to modify profiles or groups on pending invites

  * `client.delete_invites(["user@example.com"])` to delete invites

  * `client.delete_users(["user@example.com"])` to delete users

  * `group.revoke_node_access(node_type="dataiku")` or `group.revoke_node_access(node_name="design-0")` to remove a node from a group




## Reference documentation

### Classes

[`dataikuapi.launchpad_client.LaunchpadClient`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient> "dataikuapi.launchpad_client.LaunchpadClient")(...) | Entry point for the Launchpad API client  
---|---  
[`dataikuapi.launchpad.group.LaunchpadGroup`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.group.LaunchpadGroup> "dataikuapi.launchpad.group.LaunchpadGroup")(...) | A group on the Cloud space  
[`dataikuapi.launchpad.user.LaunchpadInvite`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.user.LaunchpadInvite> "dataikuapi.launchpad.user.LaunchpadInvite")(...) | An invite on the Cloud space  
[`dataikuapi.launchpad.user.LaunchpadUser`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.user.LaunchpadUser> "dataikuapi.launchpad.user.LaunchpadUser")(...) | A user on the Cloud space  
  
### Functions

[`add_groups`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.user.LaunchpadUser.add_groups> "dataikuapi.launchpad.user.LaunchpadUser.add_groups")(groups) | Add the user to the specified groups  
---|---  
[`add_users`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.group.LaunchpadGroup.add_users> "dataikuapi.launchpad.group.LaunchpadGroup.add_users")(emails) | Add the users to the group  
[`build_group`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient.build_group> "dataikuapi.launchpad_client.LaunchpadClient.build_group")(name[, description, emails, ...]) | Get a handle for a new group  
[`build_invite`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient.build_invite> "dataikuapi.launchpad_client.LaunchpadClient.build_invite")(email, profile[, groups]) | Get a handle for a new invite  
[`create_invites`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient.create_invites> "dataikuapi.launchpad_client.LaunchpadClient.create_invites")(invites[, fail_all_on_error]) | Create invites on the Cloud space  
[`get_user`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient.get_user> "dataikuapi.launchpad_client.LaunchpadClient.get_user")(email) | Get a handle to interact with an existing user on the Cloud space  
[`list_users`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient.list_users> "dataikuapi.launchpad_client.LaunchpadClient.list_users")([emails]) | List users on the Cloud space  
[`save`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.group.LaunchpadGroup.save> "dataikuapi.launchpad.group.LaunchpadGroup.save")([wait_for_propagation]) | Saves the group  
[`set_profile`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.user.LaunchpadUser.set_profile> "dataikuapi.launchpad.user.LaunchpadUser.set_profile")(name[, is_trial]) | Set the user's profile  
[`update_permissions`](<../../api-reference/python/cloud.html#dataikuapi.launchpad.group.LaunchpadGroup.update_permissions> "dataikuapi.launchpad.group.LaunchpadGroup.update_permissions")(permissions, *[, ...]) | Update permissions for the specified node type or node name  
[`update_users`](<../../api-reference/python/cloud.html#dataikuapi.launchpad_client.LaunchpadClient.update_users> "dataikuapi.launchpad_client.LaunchpadClient.update_users")(users[, fail_all_on_error, ...]) | Update users on the Cloud space  
  
See [Cloud](<../../api-reference/python/cloud.html>) for class-level API details.

---

## [concepts-and-examples/clusters]

# Clusters  
  
The API offers methods to:

  * Start, stop or delete clusters

  * Read and write settings of clusters

  * Get the status of clusters




Clusters may be listed, created and obtained using methods of the [`DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient"):

  * list clusters: [`list_clusters()`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_clusters> "dataikuapi.DSSClient.list_clusters")

  * obtain a handle on a cluster: [`get_cluster()`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_cluster> "dataikuapi.DSSClient.get_cluster")

  * create a cluster: [`create_cluster()`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_cluster> "dataikuapi.DSSClient.create_cluster")




[`DSSClusterSettings`](<../api-reference/python/clusters.html#dataikuapi.dss.admin.DSSClusterSettings> "dataikuapi.dss.admin.DSSClusterSettings") is an opaque type and its content is specific to each cluster provider. It is therefore strongly advised to use scenario steps to create/start/delete clusters, as this will greatly help define a consistent configuration.

## Starting a managed cluster
    
    
    import logging
    logger = logging.getLogger("my.package")
    
    client = dataiku.api_client()
    
    cluster_id = "my_cluster_id"
    
    # Obtain a handle on the cluster
    my_cluster = client.get_cluster(cluster_id)
    
    # Start the cluster. This operation is synchronous. An exception is thrown in case of error
    try:
        my_cluster.start()
        logger.info("Cluster {} started".format(cluster_id))
    except Exception as e:
        logger.exception("Could not start cluster: {}".format(e))
    

## Getting the status of a cluster
    
    
    import logging
    logger = logging.getLogger("my.package")
    
    client = dataiku.api_client()
    
    cluster_id = "my_cluster_id"
    
    # Obtain a handle on the cluster
    my_cluster = client.get_cluster(cluster_id)
    
    # Get status
    status = my_cluster.get_status()
    
    logger.info("Cluster status is {}".format(status.status))
    

## Reference documentation

### Classes

[`dataikuapi.dss.admin.DSSCluster`](<../api-reference/python/clusters.html#dataikuapi.dss.admin.DSSCluster> "dataikuapi.dss.admin.DSSCluster")(client, ...) | A handle to interact with a cluster on the DSS instance.  
---|---  
[`dataikuapi.dss.admin.DSSClusterSettings`](<../api-reference/python/clusters.html#dataikuapi.dss.admin.DSSClusterSettings> "dataikuapi.dss.admin.DSSClusterSettings")(...) | The settings of a cluster.  
[`dataikuapi.dss.admin.DSSClusterStatus`](<../api-reference/python/clusters.html#dataikuapi.dss.admin.DSSClusterStatus> "dataikuapi.dss.admin.DSSClusterStatus")(...) | The status of a cluster.  
  
### Functions

[`get_cluster`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_cluster> "dataikuapi.DSSClient.get_cluster")(cluster_id) | Get a handle to interact with a specific cluster  
---|---  
[`get_status`](<../api-reference/python/clusters.html#dataikuapi.dss.admin.DSSCluster.get_status> "dataikuapi.dss.admin.DSSCluster.get_status")() | Get the cluster's status and usage  
[`start`](<../api-reference/python/clusters.html#dataikuapi.dss.admin.DSSCluster.start> "dataikuapi.dss.admin.DSSCluster.start")() | Starts or attaches the cluster

---

## [concepts-and-examples/code-envs]

# Code envs  
  
The API offers methods to:

  * Create code envs

  * Read and write settings and packages of code envs

  * Update code envs

  * Reinstall

  * Set code environment resources environment variables




## Creating a code env

### Code env with default Python without Jupyter support
    
    
    client = dataiku.api_client()
    
    # Create the code env
    code_env = client.create_code_env("PYTHON", "my_code_env_name", "DESIGN_MANAGED")
    
    # Setup packages to install
    definition = code_env.get_settings()
    definition.settings["desc"]["installCorePackages"] = True
    
    # We want to install 2 packages (tabulate and nameparser)
    definition.settings["specPackageList"] = "tabulate\nnameparser"
    
    # Save the new settings
    definition.save()
    
    # Actually perform the installation
    code_env.update_packages()
    

### Code env with specific Python version with Jupyter support
    
    
    client = dataiku.api_client()
    
    # Create the code env
    code_env = client.create_code_env("PYTHON", "my_code_env_name", 
                                      "DESIGN_MANAGED", {"pythonInterpreter": "PYTHON310"})
    
    # Setup packages to install
    definition = code_env.get_settings()
    definition.settings["desc"]["installCorePackages"] = True
    definition.settings["desc"]["installJupyterSupport"] = True
    
    # We want to install 2 packages (tabulate and nameparser)
    definition.settings["specPackageList"] = "tabulate\nnameparser"
    
    # Save the new settings
    definition.save()
    
    # Actually perform the installation
    code_env.update_packages()
    code_env.set_jupyter_support(True)
    

## Managing the code environment resources directory environment variables

These methods may only be called from a resource initialization script. See [Managed code environment resources directory](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html#code-env-resources-directory>).
    
    
    from dataiku.code_env_resources import clear_all_env_vars
    from dataiku.code_env_resources import delete_env_var
    from dataiku.code_env_resources import get_env_var
    from dataiku.code_env_resources import set_env_var
    from dataiku.code_env_resources import set_env_path
    
    # Delete all environment variables from the code environment runtime
    clear_all_env_vars()
    
    # Set a raw environment variable for the code environment runtime
    set_env_var("ENV_VAR", "42")
    
    # Set a relative path environment variable to be loaded at runtime
    # (relative path with respect to the code env resources directory)
    set_env_path("TFHUB_CACHE_DIR", "tensorflow")
    
    # Get an environment variable from the code environment runtime
    print("TFHUB_CACHE_DIR:", get_env_var("TFHUB_CACHE_DIR"))
    
    # Delete an environment variable from the code environment runtime
    delete_env_var("ENV_VAR")
    
    # Then download pre-trained models in the resources directory, e.g.
    # for TensorFlow
    # import tensorflow_hub
    # tensorflow_hub.KerasLayer("https://tfhub.dev/google/imagenet/mobilenet_v2_140_224/classification/4")
    

**(Advanced)** The method `dataiku.code_env_resources.fetch_from_backend` allows to fetch specific resources files or folders from the backend, when running in containerized execution. It is meant to be called in a python recipe/notebook, when the resources were not already copied or initialized for containerized execution at build time (see [Code environment resources directory](<https://doc.dataiku.com/dss/latest/containers/code-envs.html#code-env-resources-containerized>)).
    
    
    from dataiku.code_env_resources import fetch_from_backend
    
    # Fetch resources files and folders from the backend
    fetch_from_backend([
        "pytorch/hub/checkpoints/fasterrcnn_resnet50_fpn_coco-258fb6c6.pth",
        "huggingface/",
    ])
    
    # Load pre-trained models as usual
    

## Detailed examples

### Get Recipes using specific Code Environments

When editing a Code Environment you may want to assess which Code Recipe is using that environment and thus could be affected by the changes. The following code snippet allows you to get such a mapping:
    
    
    import dataiku
    
    
    def get_instance_default_code_env(client):
        """Return the global default code envs (instance-level).
        """
    
        defaults = {}
        general_settings = client.get_general_settings()
        for rcp_type in [("python", "defaultPythonEnv"), ("r", "defaultREnv")]:
            code_env = general_settings.settings["codeEnvs"].get(rcp_type[1], None)
            if code_env:
                defaults[rcp_type[0]] = code_env
            else:
                defaults[rcp_type[0]] = "dss_builtin"
        return defaults
            
    
    def get_code_env_mapping(client, project):
        """Return a dict mapping code-based items with their code envs.
        """
    
        rcp_types = ["python", "r"]
        mapping = {"python": [], "r": []}
    
        env_default = {}
        settings = project.get_settings()
        project_default_modes = settings.get_raw()["settings"]["codeEnvs"]
        all_recipes = project.list_recipes()
        for rcp_type in rcp_types:
            if project_default_modes[rcp_type]["mode"] == "USE_BUILTIN_MODE":
                env_default[rcp_type] = "dss_builtin"
            if project_default_modes[rcp_type]["mode"] == "INHERIT":
                env_default[rcp_type] = get_instance_default_code_env(client).get(rcp_type)
            if project_default_modes[rcp_type]["mode"] == "EXPLICIT_ENV":
                env_default[rcp_type] = project_default_modes[rcp_type]["envName"]
            recipes = [r for r in all_recipes if r["type"] == rcp_type]
            for r in recipes:
                name = r["name"]
                env_select = r["params"]["envSelection"]
                if env_select["envMode"] == "EXPLICIT_ENV":
                    code_env = env_select["envName"]
                else:
                    code_env = env_default[rcp_type]
                mapping[rcp_type].append({"name": name, "code_env": code_env})
        return mapping
    
    client = dataiku.api_client()
    project = client.get_default_project()
    mapping = get_code_env_mapping(client, project)
    print(mapping)
    

## Reference documentation

### Classes

[`dataikuapi.dss.admin.DSSAutomationCodeEnvSettings`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSAutomationCodeEnvSettings> "dataikuapi.dss.admin.DSSAutomationCodeEnvSettings")(...) | Base settings class for a DSS code env on an automation node.  
---|---  
[`dataikuapi.dss.admin.DSSAutomationCodeEnvVersionSettings`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSAutomationCodeEnvVersionSettings> "dataikuapi.dss.admin.DSSAutomationCodeEnvVersionSettings")(...) | Base settings class for a DSS code env version on an automation node.  
[`dataikuapi.DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
[`dataikuapi.dss.admin.DSSCodeEnv`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSCodeEnv> "dataikuapi.dss.admin.DSSCodeEnv")(client, ...) | A code env on the DSS instance.  
[`dataikuapi.dss.admin.DSSDesignCodeEnvSettings`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSDesignCodeEnvSettings> "dataikuapi.dss.admin.DSSDesignCodeEnvSettings")(...) | Base settings class for a DSS code env on a design node.  
[`dataikuapi.dss.admin.DSSGeneralSettings`](<../api-reference/python/other-administration.html#dataikuapi.dss.admin.DSSGeneralSettings> "dataikuapi.dss.admin.DSSGeneralSettings")(client) | The general settings of the DSS instance.  
[`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.project.DSSProjectSettings`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProjectSettings> "dataikuapi.dss.project.DSSProjectSettings")(...) | Settings of a DSS project  
  
### Functions

[`create_code_env`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_code_env> "dataikuapi.DSSClient.create_code_env")(env_lang, env_name, ...[, ...]) | Create a code env, and return a handle to interact with it  
---|---  
[`get_default_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")() | Get a handle to the current default project, if available (i.e.  
[`get_general_settings`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_general_settings> "dataikuapi.DSSClient.get_general_settings")() | Gets a handle to interact with the general settings.  
[`get_settings`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSCodeEnv.get_settings> "dataikuapi.dss.admin.DSSCodeEnv.get_settings")() | Get the settings of this code env.  
[`get_settings`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_settings> "dataikuapi.dss.project.DSSProject.get_settings")() | Gets the settings of this project.  
[`list_recipes`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_recipes> "dataikuapi.dss.project.DSSProject.list_recipes")([as_type]) | List the recipes in this project  
[`save`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSAutomationCodeEnvSettings.save> "dataikuapi.dss.admin.DSSAutomationCodeEnvSettings.save")() | Save the changes to the code env's settings  
[`save`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSDesignCodeEnvSettings.save> "dataikuapi.dss.admin.DSSDesignCodeEnvSettings.save")() | Save the changes to the code env's settings  
[`set_jupyter_support`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSCodeEnv.set_jupyter_support> "dataikuapi.dss.admin.DSSCodeEnv.set_jupyter_support")(active[, wait]) | Update the code env jupyter support  
[`update_packages`](<../api-reference/python/code-envs.html#dataikuapi.dss.admin.DSSCodeEnv.update_packages> "dataikuapi.dss.admin.DSSCodeEnv.update_packages")([force_rebuild_env, ...]) | Update the code env packages so that it matches its spec

---

## [concepts-and-examples/code-studios]

# Code Studios  
  
The API offers methods to:

  * Create and list code studios

  * Start/stop them and trigger file synchronizations




For code studio templates, the API offers methods to:

  * list code studio templates

  * build them




## Build a code studio template
    
    
    client = dataiku.api_client()
    
    template_id = "my_template_id"
    
    # Obtain a handle on the code studio template
    my_template = client.get_code_studio_template(template_id)
    
    # Build the template. This operation is asynchronous
    build_template = my_template.build()
    build_template.wait_for_result()
    

## Reference documentation

### Classes

[`dataikuapi.dss.admin.DSSCodeStudioTemplateListItem`](<../api-reference/python/code-studios.html#dataikuapi.dss.admin.DSSCodeStudioTemplateListItem> "dataikuapi.dss.admin.DSSCodeStudioTemplateListItem")(...) | An item in a list of code studio templates.  
---|---  
[`dataikuapi.dss.admin.DSSCodeStudioTemplate`](<../api-reference/python/code-studios.html#dataikuapi.dss.admin.DSSCodeStudioTemplate> "dataikuapi.dss.admin.DSSCodeStudioTemplate")(...) | A handle to interact with a code studio template on the DSS instance  
[`dataikuapi.dss.admin.DSSCodeStudioTemplateSettings`](<../api-reference/python/code-studios.html#dataikuapi.dss.admin.DSSCodeStudioTemplateSettings> "dataikuapi.dss.admin.DSSCodeStudioTemplateSettings")(...) | The settings of a code studio template  
[`dataikuapi.dss.codestudio.DSSCodeStudioObject`](<../api-reference/python/code-studios.html#dataikuapi.dss.codestudio.DSSCodeStudioObject> "dataikuapi.dss.codestudio.DSSCodeStudioObject")(...) | A handle to manage a code studio in a project  
[`dataikuapi.dss.codestudio.DSSCodeStudioObjectConflicts`](<../api-reference/python/code-studios.html#dataikuapi.dss.codestudio.DSSCodeStudioObjectConflicts> "dataikuapi.dss.codestudio.DSSCodeStudioObjectConflicts")(...) | Summary of the conflicts on zones of a code studio.  
[`dataikuapi.dss.codestudio.DSSCodeStudioObjectListItem`](<../api-reference/python/code-studios.html#dataikuapi.dss.codestudio.DSSCodeStudioObjectListItem> "dataikuapi.dss.codestudio.DSSCodeStudioObjectListItem")(...) | An item in a list of code studios.  
[`dataikuapi.dss.codestudio.DSSCodeStudioObjectSettings`](<../api-reference/python/code-studios.html#dataikuapi.dss.codestudio.DSSCodeStudioObjectSettings> "dataikuapi.dss.codestudio.DSSCodeStudioObjectSettings")(...) | Settings for a code studio  
[`dataikuapi.dss.codestudio.DSSCodeStudioObjectStatus`](<../api-reference/python/code-studios.html#dataikuapi.dss.codestudio.DSSCodeStudioObjectStatus> "dataikuapi.dss.codestudio.DSSCodeStudioObjectStatus")(...) | Handle to inspect the status of a code studio  
[`dataikuapi.dss.future.DSSFuture`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")(client, job_id) | A future represents a long-running task on a DSS instance.  
  
### Functions

[`build`](<../api-reference/python/code-studios.html#dataikuapi.dss.admin.DSSCodeStudioTemplate.build> "dataikuapi.dss.admin.DSSCodeStudioTemplate.build")([disable_docker_cache]) | Build or rebuild the template.  
---|---  
[`get_code_studio_template`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_code_studio_template> "dataikuapi.DSSClient.get_code_studio_template")(template_id) | Get a handle to interact with a specific code studio template  
[`wait_for_result`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture.wait_for_result> "dataikuapi.dss.future.DSSFuture.wait_for_result")() | Waits for the completion of the long-running task, and returns its result.

---

## [concepts-and-examples/connections]

# Connections  
  
The API exposes DSS connections, which can be created, modified and deleted through the API. These operations are restricted to API keys with the “admin rights” flag.

## Getting the list of connections

A list of the connections can by obtained with the [`list_connections()`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_connections> "dataikuapi.DSSClient.list_connections") method:
    
    
    client = DSSClient(host, apiKey)
    dss_connections = client.list_connections()
    prettyprinter.pprint(dss_connections)
    

outputs
    
    
    {   'filesystem_managed': {   'allowManagedDatasets': True,
                                   'allowMirror': False,
                                   'allowWrite': True,
                                   'allowedGroups': [],
                                   'maxActivities': 0,
                                   'name': 'filesystem_managed',
                                   'params': {   'root': '${dip.home}/managed_datasets'},
                                   'type': 'Filesystem',
                                   'usableBy': 'ALL',
                                   'useGlobalProxy': True},
        'hdfs_root':                  {    'allowManagedDatasets': True,
                                       'allowMirror': False,
                                       'allowWrite': True,
                                       'allowedGroups': [],
                                       'maxActivities': 0,
                                       'name': 'hdfs_root',
                                       'params': {'database': 'dataik', 'root': '/'},
                                       'type': 'HDFS',
                                       'usableBy': 'ALL',
                                       'useGlobalProxy': False},
        'local_postgress':    {    'allowManagedDatasets': True,
                                   'allowMirror': False,
                                   'allowWrite': True,
                                   'allowedGroups': [],
                                   'maxActivities': 0,
                                   'name': 'local_postgress',
                                   'params': { 'db': 'testdb',
                                               'host': 'localhost',
                                               'password': 'admin',
                                               'port': '5432',
                                               'properties': {   },
                                               'user': 'admin'},
                                'type': 'PostgreSQL',
                                'usableBy': 'ALL',
                                'useGlobalProxy': False},
        ...
    }
    

## Creating a connection

Connections can be added:
    
    
    new_connection_params = {'db':'mysql_test', 'host': 'localhost', 'password': 'admin', 'properties': [{'name': 'useSSL', 'value': 'true'}], 'user': 'admin'}
    new_connection = client.create_connection('test_connection', type='MySql', params=new_connection_params, usable_by='ALLOWED', allowed_groups=['administrators','data_team'])
    prettyprinter.pprint(client.list_connections()['test_connection'])
    

outputs
    
    
    {   'allowManagedDatasets': True,
        'allowMirror': True,
        'allowWrite': True,
        'allowedGroups': ['data_scientists'],
        'maxActivities': 0,
        'name': 'test_connection',
        'params': {   'db': 'mysql_test',
                       'host': 'localhost',
                       'password': 'admin',
                       'properties': {   },
                       'user': 'admin'},
        'type': 'MySql',
        'usableBy': 'ALLOWED',
        'useGlobalProxy': True}
    

## Modifying a connection

To modify a connection, it is advised to first retrieve the connection definition with a [`get_definition()`](<../api-reference/python/connections.html#dataikuapi.dss.admin.DSSConnection.get_definition> "dataikuapi.dss.admin.DSSConnection.get_definition") call, alter the definition, and set it back into DSS:
    
    
    connection_definition = new_connection.get_definition()
    connection_definition['usableBy'] = 'ALL'
    connection_definition['allowWrite'] = False
    new_connection.set_definition(connection_definition)
    prettyprinter.pprint(new_connection.get_definition())
    

outputs
    
    
    {   'allowManagedDatasets': True,
        'allowMirror': True,
        'allowWrite': False,
        'allowedGroups': ['data_scientists'],
        'maxActivities': 0,
        'name': 'test_connection',
        'params': {   'db': 'mysql_test',
                       'host': 'localhost',
                       'password': 'admin',
                       'properties': {   },
                       'user': 'admin'},
        'type': 'MySql',
        'usableBy': 'ALL',
        'useGlobalProxy': True}
    

## Deleting a connection

Connections can be deleted through their handle:
    
    
    connection = client.get_connection('test_connection')
    connection.delete()
    

## Detailed examples

This section contains more advanced examples on Connections.

### Mass-change filesystem Connections

You can programmatically switch all Datasets of a Project from a given filesystem Connection to a different one, thus reproducing the “Change Connection” action available in the Dataiku Flow UI.
    
    
    import dataiku
    
    
    def mass_change_connection(project, origin_conn, dest_conn):
        """Mass change dataset connections in a project (filesystem connections only)"""
    
        for dataset in project.list_datasets(as_type='objects'):
            ds_settings = dataset.get_settings()
            if ds_settings.type == 'Filesystem':
                params = ds_settings.get_raw().get('params')
                if params.get('connection') == origin_conn:
                    params['connection'] = dest_conn
                    ds_settings.save()
    
    client = dataiku.api_client()
    project = client.get_default_project()
    mass_change_connection(project, "FSCONN_SOURCE", "FSCONN_DEST")
    

## Reference documentation

### Classes

[`dataikuapi.dss.admin.DSSConnection`](<../api-reference/python/connections.html#dataikuapi.dss.admin.DSSConnection> "dataikuapi.dss.admin.DSSConnection")(client, name) | A connection on the DSS instance.  
---|---  
[`dataikuapi.dss.admin.DSSConnectionDetailsReadability`](<../api-reference/python/connections.html#dataikuapi.dss.admin.DSSConnectionDetailsReadability> "dataikuapi.dss.admin.DSSConnectionDetailsReadability")(data) | Handle on settings for access to connection details.  
[`dataikuapi.dss.admin.DSSConnectionInfo`](<../api-reference/python/connections.html#dataikuapi.dss.admin.DSSConnectionInfo> "dataikuapi.dss.admin.DSSConnectionInfo")(data) | A class holding read-only information about a connection.  
[`dataikuapi.dss.admin.DSSConnectionListItem`](<../api-reference/python/connections.html#dataikuapi.dss.admin.DSSConnectionListItem> "dataikuapi.dss.admin.DSSConnectionListItem")(...) | An item in a list of connections.  
[`dataikuapi.dss.admin.DSSConnectionSettings`](<../api-reference/python/connections.html#dataikuapi.dss.admin.DSSConnectionSettings> "dataikuapi.dss.admin.DSSConnectionSettings")(...) | Settings of a DSS connection.  
  
### Functions

[`create_connection`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_connection> "dataikuapi.DSSClient.create_connection")(name, type[, params, ...]) | Create a connection, and return a handle to interact with it  
---|---  
[`get_connection`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_connection> "dataikuapi.DSSClient.get_connection")(name) | Get a handle to interact with a specific connection  
[`get_definition`](<../api-reference/python/connections.html#dataikuapi.dss.admin.DSSConnection.get_definition> "dataikuapi.dss.admin.DSSConnection.get_definition")() | Get the connection's raw definition.  
[`list_connections`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_connections> "dataikuapi.DSSClient.list_connections")([as_type]) | List all connections setup on the DSS instance.  
[`set_definition`](<../api-reference/python/connections.html#dataikuapi.dss.admin.DSSConnection.set_definition> "dataikuapi.dss.admin.DSSConnection.set_definition")(definition) | Set the connection's definition.

---

## [concepts-and-examples/data-collections]

# Data Collections  
  
You can interact with the Data Collections through the API.

## Basic operations

### Listing Data Collections
    
    
    data_collections = client.list_data_collections(as_type="objects")
    # Returns a list of DSSDataCollection
    
    for data_collection in data_collections:
            settings = data_collection.get_settings()
    
            # Access to main information in the Data Collection
            print("Data Collection id: %s" % settings.id)
            print("Display name: %s" % settings.display_name)
            print("Description: %s" % settings.description)
            print("Color: %s" % settings.color)
            print("Tags: %s" % settings.tags)
            print("Permissions: %s" % settings.permissions)
    
            # You can also list the objects in a Data Collection
            print("Content: %s" % data_collection.list_objects(as_type='dict'))
    

### Modifying Data Collection
    
    
    data_collection = client.get_data_collection("someDcId")
    settings = data_collection.get_settings()
    settings.display_name = "new name"
    settings.permissions = [*settings.permissions, DSSDataCollectionPermissionItem.reader_user("LOGIN"), DSSDataCollectionPermissionItem.contributor_group("GROUP")]
    settings.save()
    

### Creating a Data Collection
    
    
    data_collection = client.create_data_collection("The name of the collection", description="Description *markdown is allowed*")
    # returns a DSSDataCollection that can be used for adding objects
    

### Deleting a Data Collection
    
    
    data_collection = client.get_data_collection("someDcId")
    data_collection.delete()
    

## Adding and deleting the objects in a Data Collection
    
    
    data_collection = client.get_data_collection("someDcId")
    data_collection_objects = data_collection.list_objects()
    
    # remove all contained objects
    for data_collection_object in data_collection_objects:
            data_collection_object.remove()
    
    # add a dataset
    data_collection.add_object(client.get_project("PROJECT_KEY").get_dataset("DATASET_NAME"))
    

## Reference documentation

### Classes

[`dataikuapi.dss.data_collection.DSSDataCollection`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollection> "dataikuapi.dss.data_collection.DSSDataCollection")(...) | A handle to interact with a Data Collection on the DSS instance.  
---|---  
[`dataikuapi.dss.data_collection.DSSDataCollectionItem`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollectionItem> "dataikuapi.dss.data_collection.DSSDataCollectionItem")(...) | A handle on an object inside a Data Collection  
[`dataikuapi.dss.data_collection.DSSDataCollectionListItem`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollectionListItem> "dataikuapi.dss.data_collection.DSSDataCollectionListItem")(...) | An item in a list of Data Collections.  
[`dataikuapi.dss.data_collection.DSSDataCollectionPermissionItem`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollectionPermissionItem> "dataikuapi.dss.data_collection.DSSDataCollectionPermissionItem")() |   
[`dataikuapi.dss.data_collection.DSSDataCollectionSettings`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollectionSettings> "dataikuapi.dss.data_collection.DSSDataCollectionSettings")(...) | A handle on the settings of a Data Collection  
  
### Functions

[`add_object`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollection.add_object> "dataikuapi.dss.data_collection.DSSDataCollection.add_object")(obj) | Add an object to this Data Collection.  
---|---  
[`create_data_collection`](<../api-reference/python/client.html#dataikuapi.DSSClient.create_data_collection> "dataikuapi.DSSClient.create_data_collection")(displayName[, id, ...]) | Create a new data collection and return a handle to interact with it  
[`delete`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollection.delete> "dataikuapi.dss.data_collection.DSSDataCollection.delete")() | Delete this Data Collection  
[`get_settings`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollection.get_settings> "dataikuapi.dss.data_collection.DSSDataCollection.get_settings")() | Gets the settings of this Data Collection.  
[`list_data_collections`](<../api-reference/python/client.html#dataikuapi.DSSClient.list_data_collections> "dataikuapi.DSSClient.list_data_collections")([as_type]) | List the accessible data collections  
[`list_objects`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollection.list_objects> "dataikuapi.dss.data_collection.DSSDataCollection.list_objects")([as_type]) | List the objects in this Data Collection  
[`remove`](<../api-reference/python/data-collections.html#dataikuapi.dss.data_collection.DSSDataCollectionItem.remove> "dataikuapi.dss.data_collection.DSSDataCollectionItem.remove")() | Remove this object from the Data Collection

---

## [concepts-and-examples/data-quality]

# Data Quality  
  
You can interact with Data Quality through the API.

## Basic operations

### Listing Data Quality rules of a dataset
    
    
    project = client.get_project("SomeProjectId")
    dataset = project.get_dataset("SomeDatasetId")
    ruleset = dataset.get_data_quality_rules()
    rules = ruleset.list_rules()
    # Returns a list of DSSDataQualityRule
    
    for rule in rules:
    
            # Access to main information of the rule
            print("Rule id: %s" % rule.id)
            print("name: %s" % rule.name)
    

### Computing a rule
    
    
    project = client.get_project("SomeProjectId")
    dataset = project.get_dataset("SomeDatasetId")
    ruleset = dataset.get_data_quality_rules()
    rules = ruleset.list_rules()
    future = rules[0].compute()
    future.wait_for_result()
    

### Creating a rule
    
    
    project = client.get_project("SomeProjectId")
    dataset = project.get_dataset("SomeDatasetId")
    ruleset = dataset.get_data_quality_rules()
    rule_config = { "type": "RecordCountInRangeRule", "softMinimum": 10, "softMinimumEnabled": True, "displayName": "My newly created rule."}
    newRule = ruleset.create_rule(rule_config)
    

### Deleting a rule
    
    
    project = client.get_project("SomeProjectId")
    dataset = project.get_dataset("SomeDatasetId")
    ruleset = dataset.get_data_quality_rules()
    rules = ruleset.list_rules()
    rules[0].delete()
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.data_quality.DSSDataQualityRule`](<../api-reference/python/data-quality.html#dataikuapi.dss.data_quality.DSSDataQualityRule> "dataikuapi.dss.data_quality.DSSDataQualityRule")(...) | A rule defined on a dataset.  
[`dataikuapi.dss.data_quality.DSSDataQualityRuleSet`](<../api-reference/python/data-quality.html#dataikuapi.dss.data_quality.DSSDataQualityRuleSet> "dataikuapi.dss.data_quality.DSSDataQualityRuleSet")(...) | Base settings class for dataset data quality rules.  
[`dataikuapi.dss.dataset.DSSDataset`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")(client, ...) | A dataset on the DSS instance.  
[`dataikuapi.dss.future.DSSFuture`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")(client, job_id) | A future represents a long-running task on a DSS instance.  
[`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
  
### Functions

[`compute`](<../api-reference/python/data-quality.html#dataikuapi.dss.data_quality.DSSDataQualityRule.compute> "dataikuapi.dss.data_quality.DSSDataQualityRule.compute")([partition]) | Compute the rule on a given partition or the full dataset.  
---|---  
[`create_rule`](<../api-reference/python/data-quality.html#dataikuapi.dss.data_quality.DSSDataQualityRuleSet.create_rule> "dataikuapi.dss.data_quality.DSSDataQualityRuleSet.create_rule")([config]) | Create a data quality rule on the current dataset.  
[`delete`](<../api-reference/python/data-quality.html#dataikuapi.dss.data_quality.DSSDataQualityRule.delete> "dataikuapi.dss.data_quality.DSSDataQualityRule.delete")() | Delete the rule from the dataset configuration.  
[`get_data_quality_rules`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_data_quality_rules> "dataikuapi.dss.dataset.DSSDataset.get_data_quality_rules")() | Get a handle to interact with the data quality rules of the dataset.  
[`get_dataset`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_dataset> "dataikuapi.dss.project.DSSProject.get_dataset")(dataset_name) | Get a handle to interact with a specific dataset  
[`get_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`list_rules`](<../api-reference/python/data-quality.html#dataikuapi.dss.data_quality.DSSDataQualityRuleSet.list_rules> "dataikuapi.dss.data_quality.DSSDataQualityRuleSet.list_rules")([as_type]) | Get the list of rules defined on the dataset.  
[`wait_for_result`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture.wait_for_result> "dataikuapi.dss.future.DSSFuture.wait_for_result")() | Waits for the completion of the long-running task, and returns its result.

---

## [concepts-and-examples/databricks-connect]

# Databricks Connect  
  
Dataiku can leverage the Databricks Connect framework in order to read Dataiku datasets stored in Databricks, build queries using Dataframes and then write the result back to a Databricks dataset.

## Detailed examples

The [tutorial section](<../tutorials/data-engineering/databricks-connect-basics/index.html>) contains a dedicated tutorial

## Reference documentation

[`dataiku.dbconnect.DkuDBConnect`](<../api-reference/python/databricks-connect.html#dataiku.dbconnect.DkuDBConnect> "dataiku.dbconnect.DkuDBConnect") | Handle to create Databricks Connect sessions from DSS datasets or connections  
---|---

---

## [concepts-and-examples/dataiku-applications]

# Dataiku Applications  
  
The API offers methods to:

  * Create and list instances of an application

  * Manipulate the manifest of an application




## Reference documentation

[`dataikuapi.dss.app.DSSApp`](<../api-reference/python/dataiku-applications.html#dataikuapi.dss.app.DSSApp> "dataikuapi.dss.app.DSSApp")(client, app_id) | A handle to interact with an application on the DSS instance.  
---|---  
[`dataikuapi.dss.app.DSSAppListItem`](<../api-reference/python/dataiku-applications.html#dataikuapi.dss.app.DSSAppListItem> "dataikuapi.dss.app.DSSAppListItem")(client, data) | An app item in a list of apps.  
[`dataikuapi.dss.app.DSSAppInstance`](<../api-reference/python/dataiku-applications.html#dataikuapi.dss.app.DSSAppInstance> "dataikuapi.dss.app.DSSAppInstance")(client, ...) | Handle on an instance of an app.  
[`dataikuapi.dss.app.DSSAppManifest`](<../api-reference/python/dataiku-applications.html#dataikuapi.dss.app.DSSAppManifest> "dataikuapi.dss.app.DSSAppManifest")(client, ...) | Handle on the manifest of an app or an app instance.  
[`dataikuapi.dss.app.TemporaryDSSAppInstance`](<../api-reference/python/dataiku-applications.html#dataikuapi.dss.app.TemporaryDSSAppInstance> "dataikuapi.dss.app.TemporaryDSSAppInstance")(...) | Variant of `DSSAppInstance` that can be used as a Python context.

---

## [concepts-and-examples/datasets/datasets-data]

# Datasets (reading and writing data)

Please see [Datasets](<index.html>) for an introduction to interacting with datasets in Dataiku Python API

For a starting code sample, please see [Python Recipes](<https://doc.dataiku.com/dss/latest/code_recipes/python.html>).

## Basic usage

Reading a Dataiku dataset as a Pandas Dataframe:
    
    
    import dataiku
    
    mydataset = dataiku.Dataset("myname")
    
    df = mydataset.get_dataframe()
    

Writing a Pandas Dataframe to a Dataiku dataset
    
    
    import dataiku
    
    output_dataset = dataiku.Dataset("output_dataset")
    
    output_dataset.write_with_schema(df)
    

Adding a dataframe to an input Dataiku dataset, or to any other dataset.

### Append Mode

When writing to a dataset, you must choose whether or not to use `appendMode`. By default, `appendMode` is disabled, and writing to a dataset will overwrite the data, meaning the dataset will be emptied and filled with the new data.

With `appendMode` enabled, you will instead add data to the existing dataset.

To enable `appendMode` you should go to the _Inputs/Outputs_ tab on your coding recipe and enable `Append instead of overwrite` in the output section.

You can also enable `appendMode` in code by using the `spec_item` property, as shown in the sample below:
    
    
    import dataiku
    
    df = ## The dataframe you want to add
    
    input_append = dataiku.Dataset("input_dataset", ignore_flow=True)
    input_append.spec_item["appendMode"] = True
    
    input_append.write_with_schema(df)
    

## Accessing Dataset Connection Information

You generally want to avoid hard-coding connection information, table names, and other details in your recipe code. Dataiku can provide you with some connection/location information about the datasets you are trying to read or write.

For all datasets, you can use the [`get_location_info()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_location_info> "dataiku.Dataset.get_location_info") method. It returns a structure containing an `info` dict. The keys in the `info` dict depend on the specific kind of dataset. Here are a few examples:
    
    
    # myfs is a Filesystem dataset
    dataset = dataiku.Dataset("myfs")
    location_info = dataset.get_location_info()
    print(location_info)
    
    
    
    {
        'locationInfoType': 'UPLOADED',
        'info': {
            'path': '/data/input/PROJECTKEY/myfs',
            'isSingleFile': False
        }
    }
    
    
    
    # sql is a Snowflake dataset
    dataset = dataiku.Dataset("sql")
    location_info = dataset.get_location_info()
    print(location_info)
    
    
    
    {
        'locationInfoType': 'SQL', 
        'info': {
            'databaseType': 'Snowflake', 
            'schema': 'schema', 
            'quotedResolvedTableName': '"schema"."SQL"',
            'connectionName': 'snowflake', 
            'table': 'SQL'
        }
    }
    

In addition, for filesystem-like datasets (Filesystem, HDFS, S3, etc.), you can use the [`get_files_info()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_files_info> "dataiku.Dataset.get_files_info") to get details about all files in a dataset (or partition).
    
    
    dataset = dataiku.Dataset("non_partitioned_fs")
    files_info = dataset.get_files_info()
    
    for filepath in files_info["globalPaths"]:
      # Returns a path relative to the root path of the dataset.
      # The root path of the dataset is returned by get_location_info
      print(filepath["path"])
      # Size in bytes of that file
      print(filepath["size"])
      
      
    dataset = dataiku.Dataset("partitioned_fs")
    files_info = dataset.get_files_info()
    
    for (partition_id, partition_filepaths) in files_info["pathsByPartition"].items():
        print(partition_id)
    
        for filepath in partition_filepaths:
            # Returns a path relative to the root path of the dataset.
            # The root path of the dataset is returned by get_location_info
            print(filepath["path"])
            # Size in bytes of that file
            print(filepath["size"])      
    

## Typing and schema

### Type inference versus dataset-provided types

This applies when reading a dataframe.

By default, the data frame is created without explicit typing. This means that we let Pandas “guess” the proper Pandas type for each column. The main advantage of this approach is that even if your dataset only contains “string” columns (which is the default on a newly imported dataset from CSV, for example) if the column actually contains numbers, a proper numerical type will be used.

If you pass `infer_with_pandas=False` as an option to [`get_dataframe()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe"), the exact dataset types will be passed to Pandas. Note that if your dataset contains invalid values, the whole [`get_dataframe()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe") call will fail.
    
    
    import dataiku
    
    mydataset = dataiku.Dataset("myname")
    # The dataframe will have the types specified by the storage types in the dataset "myname"
    df = mydataset.get_dataframe(infer_with_pandas=False)
    

### Nullable integers

This applies when reading a dataframe.

By default, when using `infer_with_pandas=False`, DSS uses the regular integer types for pandas, i.e. `np.int64` and others.

These types do not support null values, which mean that if a column contains a single missing value, reading will fail. To avoid this, you can use the pandas “nullable integer” types, i.e. `pd.Int64DType` and others.

To use these, use `use_nullable_integers=True`
    
    
    import dataiku
    
    mydataset = dataiku.Dataset("myname")
    # The dataframe will have the types specified by the storage types in the dataset "myname", even if an integer column contains null values
    df = mydataset.get_dataframe(infer_with_pandas=False, use_nullable_integers=True)
    

Using nullable integers also causes DSS to use the exact type size (8 bits for tinyint, 16 bits for smallint, …)

### Using categoricals

This applies when reading a dataframe.

For alphanumerical columns with a small number of values, pandas provides a `Categorical` type that improves memory consumption by storing references in a dictionary of possible values.

DSS does not automatically use categoricals, but you can request to use categoricals, either for explicitly-selected columns or for string columns.
    
    
    import dataiku
    
    mydataset = dataiku.Dataset("myname")
    
    # Read columns A and B as categoricals. Other string columns will be read as regular strings
    df = mydataset.get_dataframe(infer_with_pandas=False, categoricals=["A", "B"])
    
    # Read all string columns as categoricals (beware, if your columns have many values, this will be less efficient)
    df = mydataset.get_dataframe(infer_with_pandas=False, categoricals="all_strings")
    

## Writing the output schema

When you use the [`write_with_schema()`](<../../api-reference/python/datasets.html#dataiku.Dataset.write_with_schema> "dataiku.Dataset.write_with_schema") method, this is what happens: the schema of the dataframe is used to modify the schema of the output dataset, each time the Python recipe is run. This must obviously be used with caution, as mistakes could lead the “next” parts of your Flow to fail if your schema changes.

You can also select to only write the schema (not the data):
    
    
    import dataiku
    
    # Set the schema of ‘myoutputdataset’ to match the columns of the dataframe
    output_ds = dataiku.Dataset("myoutputdataset")
    output_ds.write_schema_from_dataframe(my_dataframe)
    

And you can write the data in the dataframe without changing the schema:
    
    
    # Write the dataframe without touching the schema
    output_ds.write_dataframe(my_dataframe)
    

## Fast path reading

When using the universal [`get_dataframe()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe") API, all data goes through DSS, to be handled in a unified way.

In addition, Dataiku has the ability to read the dataset as a Pandas dataframe, using fast-path access (without going through DSS), if possible.

The fast path method provides better performance than the usual [`get_dataframe()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe") method, but is only compatible with some dataset types and formats.

Fast path requires the “permission details readable” to be granted on the connection.

Dataframes obtained using this method may differ from those using [`get_dataframe()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe"), notably around schemas and data.

At the moment, this fast path is available for:

  * S3 datasets using Parquet. This requires the additional `s3fs` package, as well as `fastparquet` or `pyarrow`

  * Snowflake datasets. This requires the additional `snowflake-connector-python[pandas]` package



    
    
    import dataiku
    
    ds = dataiku.Dataset("my_s3_parquet_dataset")
    df = ds.get_fast_path_dataframe() # will usually be much faster than get_dataframe
    
    # fast path dataframe on S3+parquet is especially efficient when only selecting some columns
    df = ds.get_fast_path_dataframe(columns=["A", "B", "C"])
    
    
    ds = dataiku.Dataset("my_snowflake_dataset")
    df = ds.get_fast_path_dataframe() # will usually be much faster than get_dataframe
    
    # fast path dataframe on Snowflake is especially efficient when only selecting some columns
    df = ds.get_fast_path_dataframe(columns=["A", "B", "C"])
    

## Improving read performance

When not using fast path reading, you can get improved reading performance by adding the `skip_additional_data_checks` option.
    
    
    import dataiku
    
    ds = dataiku.Dataset("my_s3_parquet_dataset")
    df = ds.get_dataframe(skip_additional_data_checks=True)
    

While this option is not enabled by default to ensure backwards compatibility, it can almost always be used.

If you know data is good, read performance on CSV datasets can also be strongly improved by going to the format settings and setting “Bad data type behavior (read)” to “Ignore”

## Chunked reading and writing with Pandas

When using [`get_dataframe()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe"), the whole dataset (or selected partitions) is read into a single Pandas dataframe, which must fit in RAM on the DSS server.

This is sometimes inconvenient and DSS provides a way to do this in chunks:
    
    
    import dataiku
    
    mydataset = dataiku.Dataset("myname")
    
    for df in mydataset.iter_dataframes(chunksize=10000):
            # df is a dataframe of at most 10K rows.
    

By doing this, you only need to load a few thousand rows at a time.

Writing in a dataset can also be made by chunks of data frames. For that, you need to obtain a writer:
    
    
    import dataiku
    
    inp = dataiku.Dataset("myname")
    out = dataiku.Dataset("output")
    
    with out.get_writer() as writer:
    
            for df in inp.iter_dataframes():
                    # Process the df dataframe ...
    
                    # Write the processed dataframe
                    writer.write_dataframe(df)
    

Note

When using chunked writing, you cannot set the schema for each chunk, you cannot use [`write_with_schema()`](<../../api-reference/python/datasets.html#dataiku.Dataset.write_with_schema> "dataiku.Dataset.write_with_schema").

Instead, you should set the schema first on the dataset object, using [`write_schema_from_dataframe()`](<../../api-reference/python/datasets.html#dataiku.Dataset.write_schema_from_dataframe> "dataiku.Dataset.write_schema_from_dataframe"), with the first chunked dataframe.

## Using the streaming API

If the dataset does not fit in memory, it is also possible to stream the rows. This is often more complicated, so we recommend using Pandas for most use cases.

### Reading

Dataset object’s:

  * `iter_rows` method are iterating over the rows of the dataset, represented as dictionary-like objects.

  * `iter_tuples` method are iterating over the rows of the dataset, represented as tuples. Values are ordered according to the schema of the dataset.



    
    
    import dataiku
    from collections import Counter
    
    cars = dataiku.Dataset("cars")
    
    origin_count = Counter()
    
    # iterate on the dataset. The row object is a dict-like object
    # the dataset is "streamed" and it is not required to fit in RAM.
    for row in cars.iter_rows():
        origin_count[row["origin"]] += 1
    

### Writing the output schema

Generally speaking, it is preferable to declare the schema of the output dataset prior to running the Python code. However, it is often impractical to do so, especially when you write data frames with many columns (or columns that change often). In that case, it can be useful for the Python script to actually modify the schema of the dataset.

The Dataset API provides a method to set the schema of the output dataset. When doing that, the schema of the dataset is modified each time the Python recipe is run. This must obviously be used with caution.
    
    
    output.write_schema([
    {
      "name": "origin",
      "type": "string",
    },
    {
      "name": "count",
      "type": "int",
    }
    ])
    

### Writing the data

Writing the output dataset is done via a writer object returned by [`get_writer()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_writer> "dataiku.Dataset.get_writer")
    
    
    with output.get_writer() as writer:
        for (origin,count) in origin_count.items():
            writer.write_row_array((origin,count))
    

Don’t forget to close your writer. If you don’t, your data will not get fully written. In some cases (like SQL output datasets), no data will get written at all.

We strongly recommend that you use the `with` keyword in Python to ensure that the writer is closed.

## Sampling

All calls to iterate the dataset ([`get_dataframe()`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe"), [`iter_dataframes()`](<../../api-reference/python/datasets.html#dataiku.Dataset.iter_dataframes> "dataiku.Dataset.iter_dataframes"), [`iter_rows()`](<../../api-reference/python/datasets.html#dataiku.Dataset.iter_rows> "dataiku.Dataset.iter_rows"), and [`iter_tuples()`](<../../api-reference/python/datasets.html#dataiku.Dataset.iter_tuples> "dataiku.Dataset.iter_tuples")) take several arguments to set sampling.

Sampling lets you only retrieve a selection of the rows of the input dataset. It’s often useful when using Pandas if your dataset does not fit in RAM.

For more information about sampling methods, please see [Sampling](<https://doc.dataiku.com/dss/latest/preparation/sampling.html>).

The `sampling` argument takes the following values: `head`, `random`, `random-column`

  * `head` returns the first rows of the dataset. Additional arguments:

    * `limit=X` : number of rows to read

  * `random` returns a random sample of the dataset. Additional arguments:

    * `ratio=X`: ratio (between 0 and 1) to select.

    * OR: `limit=X`: number of rows to read.

  * `random-column` return a column-based random sample. Additional arguments:

    * `sampling_column`: column to use for sampling

    * `ratio=X`: ratio (between 0 and 1) to select




Examples:
    
    
    # Get a Dataframe over the first 3K rows
    dataset.get_dataframe(sampling='head', limit=3000)
    
    # Iterate over a random 10% sample
    dataset.iter_tuples(sampling='random', ratio=0.1)
    
    # Iterate over 27% of the values of column 'user_id'
    dataset.iter_tuples(sampling='random-column', sampling_column='user_id', ratio=0.27)
    
    # Get a chunked stream of dataframes over 100K randomly selected rows
    dataset.iter_dataframes(sampling='random', limit=100000)
    

## Getting a dataset as raw bytes

In addition to retrieving a dataset as Pandas Dataframes or iterator, you can also ask DSS for a streamed export, as formatted data.

Data can be exported by DSS in various formats: CSV, Excel, Avro, …
    
    
    # Read a dataset as Excel, and dump to a file, chunk by chunk
    #
    # Very important: you MUST use a with() statement to ensure that the stream
    # returned by raw_formatted is closed
    
    with open(target_path, "wb") as ofl:
            with dataset.raw_formatted_data(format="excel") as ifl:
                    while True:
                            chunk = ifl.read(32000)
                            if len(chunk) == 0:
                                    break
                            ofl.write(chunk)
    

## Data interaction (dataikuapi variant)

This section covers reading data using the `dataikuapi` pacakge. We recommend that you rather use the `dataiku` package for reading data. [The Dataiku Python packages](<../../getting-started/dataiku-python-apis/index.html>) explains how to use and connect to the `dataikuapi` package.

### Reading data (dataikuapi variant)

The data of a dataset can be streamed with the [`iter_rows()`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.iter_rows> "dataikuapi.dss.dataset.DSSDataset.iter_rows") method. This call returns the raw data, so that in most cases it is necessary to first get the dataset’s schema with a call to [`dataikuapi.dss.dataset.DSSDataset.get_schema()`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_schema> "dataikuapi.dss.dataset.DSSDataset.get_schema"). For example, printing the first 10 rows can be done with
    
    
    columns = [column['name'] for column in dataset.get_schema()['columns']]
    print(columns)
    row_count = 0
    for row in dataset.iter_rows():
            print(row)
            row_count = row_count + 1
            if row_count >= 10:
                    break
    

outputs
    
    
    ['tube_assembly_id', 'supplier', 'quote_date', 'annual_usage', 'min_order_quantity', 'bracket_pricing', 'quantity', 'cost']
    ['TA-00002', 'S-0066', '2013-07-07', '0', '0', 'Yes', '1', '21.9059330191461']
    ['TA-00002', 'S-0066', '2013-07-07', '0', '0', 'Yes', '2', '12.3412139792904']
    ['TA-00002', 'S-0066', '2013-07-07', '0', '0', 'Yes', '5', '6.60182614356538']
    ['TA-00002', 'S-0066', '2013-07-07', '0', '0', 'Yes', '10', '4.6877695119712']
    ['TA-00002', 'S-0066', '2013-07-07', '0', '0', 'Yes', '25', '3.54156118026073']
    ['TA-00002', 'S-0066', '2013-07-07', '0', '0', 'Yes', '50', '3.22440644770007']
    ['TA-00002', 'S-0066', '2013-07-07', '0', '0', 'Yes', '100', '3.08252143576504']
    ['TA-00002', 'S-0066', '2013-07-07', '0', '0', 'Yes', '250', '2.99905966403855']
    ['TA-00004', 'S-0066', '2013-07-07', '0', '0', 'Yes', '1', '21.9727024365273']
    ['TA-00004', 'S-0066', '2013-07-07', '0', '0', 'Yes', '2', '12.4079833966715']
    

### Reading data for a partition (dataikuapi variant)

The data of a given partition can be retrieved by passing the appropriate partition spec as parameter to [`dataikuapi.dss.dataset.DSSDataset.iter_rows()`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.iter_rows> "dataikuapi.dss.dataset.DSSDataset.iter_rows"):
    
    
    row_count = 0
    for row in dataset.iter_rows(partitions='partition_spec1,partition_spec2'):
            print(row)
            row_count = row_count + 1
            if row_count >= 10:
                    break
    

## Reference documentation

### Classes

[`dataiku.Dataset`](<../../api-reference/python/datasets.html#dataiku.Dataset> "dataiku.Dataset")(name[, project_key, ignore_flow]) | Provides a handle to obtain readers and writers on a dataiku Dataset.  
---|---  
[`dataikuapi.dss.dataset.DSSDataset`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")(client, ...) | A dataset on the DSS instance.  
[`dataiku.core.dataset_write.DatasetWriter`](<../../api-reference/python/datasets.html#dataiku.core.dataset_write.DatasetWriter> "dataiku.core.dataset_write.DatasetWriter")(dataset) | Handle to write to a dataset.  
  
### Functions

[`get_dataframe`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_dataframe> "dataiku.Dataset.get_dataframe")([columns, sampling, ...]) | Read the dataset (or its selected partitions, if applicable) as a Pandas dataframe.  
---|---  
[`get_fast_path_dataframe`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_fast_path_dataframe> "dataiku.Dataset.get_fast_path_dataframe")([auto_fallback, ...]) | Reads the dataset as a Pandas dataframe, using fast-path access (without going through DSS), if possible.  
[`get_schema`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_schema> "dataikuapi.dss.dataset.DSSDataset.get_schema")() | Get the dataset schema.  
[`get_writer`](<../../api-reference/python/datasets.html#dataiku.Dataset.get_writer> "dataiku.Dataset.get_writer")() | Get a stream writer for this dataset (or its target partition, if applicable).  
[`iter_dataframes`](<../../api-reference/python/datasets.html#dataiku.Dataset.iter_dataframes> "dataiku.Dataset.iter_dataframes")([chunksize, ...]) | Read the dataset to Pandas dataframes by chunks of fixed size.  
[`iter_rows`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.iter_rows> "dataikuapi.dss.dataset.DSSDataset.iter_rows")([partitions]) | Get the dataset data as a row-by-row iterator.  
[`iter_tuples`](<../../api-reference/python/datasets.html#dataiku.Dataset.iter_tuples> "dataiku.Dataset.iter_tuples")([sampling, sampling_column, ...]) | Get the rows of the dataset as tuples.  
[`raw_formatted_data`](<../../api-reference/python/datasets.html#dataiku.Dataset.raw_formatted_data> "dataiku.Dataset.raw_formatted_data")([sampling, columns, ...]) | Get a stream of raw bytes from a dataset as a file-like object, formatted in a supported DSS output format.  
[`write_dataframe`](<../../api-reference/python/datasets.html#dataiku.Dataset.write_dataframe> "dataiku.Dataset.write_dataframe")(df[, infer_schema, ...]) | Write a pandas dataframe to this dataset (or its target partition, if applicable).  
[`write_dataframe`](<../../api-reference/python/datasets.html#dataiku.core.dataset_write.DatasetWriter.write_dataframe> "dataiku.core.dataset_write.DatasetWriter.write_dataframe")(df) | Append a Pandas dataframe to the dataset being written.  
[`write_row_array`](<../../api-reference/python/datasets.html#dataiku.core.dataset_write.DatasetWriter.write_row_array> "dataiku.core.dataset_write.DatasetWriter.write_row_array")(row) | Write a single row from an array.  
[`write_schema_from_dataframe`](<../../api-reference/python/datasets.html#dataiku.Dataset.write_schema_from_dataframe> "dataiku.Dataset.write_schema_from_dataframe")(df[, ...]) | Set the schema of this dataset to the schema of a Pandas dataframe.  
[`write_with_schema`](<../../api-reference/python/datasets.html#dataiku.Dataset.write_with_schema> "dataiku.Dataset.write_with_schema")(df[, drop_and_create]) | Write a pandas dataframe to this dataset (or its target partition, if applicable).

---

## [concepts-and-examples/datasets/datasets-other]

# Datasets (other operations)  
  
Please see [Datasets](<index.html>) for an introduction about interacting with datasets in Dataiku Python API

This page lists many usage examples for performing various operations (listed below) with datasets through Dataiku Python API. It is designed to give an overview of the main capabilities but is not an exhaustive documentation.

In all examples, `project` is a [`dataikuapi.dss.project.DSSProject`](<../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject") handle, obtained using [`get_project()`](<../../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project") or [`get_default_project()`](<../../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")

## Basic operations

### Listing datasets
    
    
    datasets = project.list_datasets()
    # Returns a list of DSSDatasetListItem
    
    for dataset in datasets:
            # Quick access to main information in the dataset list item
            print("Name: %s" % dataset.name)
            print("Type: %s" % dataset.type)
            print("Connection: %s" % dataset.connection)
            print("Tags: %s" % dataset.tags) # Returns a list of strings
    
            # You can also use the list item as a dict of all available dataset information
            print("Raw: %s" % dataset)
    

outputs
    
    
    Name: train_set
    Type: Filesystem
    Connection: filesystem_managed
    Tags: ["creator_admin"]
    Raw: {  'checklists': {   'checklists': []},
            'customMeta': {   'kv': {   }},
            'flowOptions': {   'crossProjectBuildBehavior': 'DEFAULT',
                                'rebuildBehavior': 'NORMAL'},
            'formatParams': {  /* Parameters specific to each format type */ },
            'formatType': 'csv',
            'managed': False,
            'name': 'train_set',
            'tags' : ["mytag1"]
            'params': { /* Parameters specific to each dataset type */ "connection" : "filesystem_managed" },
            'partitioning': {   'dimensions': [], 'ignoreNonMatchingFile': False},
            'projectKey': 'TEST_PROJECT',
            'schema': {   'columns': [   {     'name': 'col0',
                                               'type': 'string'},
                                           {   'name': 'col1',
                                               'type': 'string'},
                                           /* Other columns ... */
                                           ],
                           'userModified': False},
            'tags': ['creator_admin'],
            'type': 'Filesystem'},
    ...
    ]
    

### Deleting a dataset
    
    
    dataset = project.get_dataset('TEST_DATASET')
    dataset.delete(drop_data=True)
    

### Modifying tags for a dataset

Modifying tags for a dataset
    
    
    dataset = project.get_dataset("mydataset")
    settings = dataset.get_settings()
    
    print("Current tags are %s" % settings.tags)
    
    # Change the tags
    settings.tags = ["newtag1", "newtag2"]
    
    # If we changed the settings, we must save
    settings.save()
    

### Modifying the description for a dataset

Modifying the description for a dataset
    
    
    dataset = project.get_dataset("mydataset")
    settings = dataset.get_settings()
    
    # To change the short description
    settings.short_description = "Small description"
    
    # To change the long description
    settings.description = """Very long description
    with multiline"""
    
    settings.save()
    

### Reading and modifying the schema of a dataset

Warning

Using [`DSSDataset`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset") to modify the schema from within a DSS job would not be taken into account for subsequent activities in the job.
    
    
    dataset = project.get_dataset("mydataset")
    settings = dataset.get_settings()
    
    for column in settings.get_raw().get('schema').get('columns'):
            print("Have column name=%s type=%s" % (column["name"], column["type"]))
    
    # Now, let's add a new column in the schema
    settings.add_raw_schema_column({"name" : "test", "type": "string"})
    
    # If we changed the settings, we must save
    settings.save()
    

### Modifying the meaning or comment of a column in a dataset

Modifying the meaning or comment of a column in a dataset
    
    
    name_of_the_column = "example"
    meaning_of_the_column = "Existing meaning"
    comment_if_the_column = "My comment"
    
    
    dataset = project.get_dataset("mydataset")
    schema = dataset.get_schema()
    for col in schema['columns']:
        if col['name'] == name_of_the_column:
            col['meaning'] = meaning_of_the_column
            col['comment'] = comment_if_the_column
            
    dataset.set_schema(schema)
    

### Building a dataset

You can start a job in order to build the dataset
    
    
    dataset = project.get_dataset("mydataset")
    
    # Build the dataset non recursively and waits for build to complete.
    #Returns a :meth:`dataikuapi.dss.job.DSSJob`
    job = dataset.build()
    
    # Builds the dataset recursively
    dataset.build(job_type="RECURSIVE_BUILD")
    
    # Build a partition (for partitioned datasets)
    dataset.build(partitions="partition1")
    

## Programmatic creation and setup (external datasets)

The API allows you to leverage Dataiku’s automatic detection and configuration capabilities in order to programmatically create datasets or programmatically “autocomplete” the settings of a dataset.

### SQL dataset: Programmatic creation
    
    
    dataset = project.create_sql_table_dataset("mydataset", "PostgreSQL", "my_sql_connection", "database_table_name", "database_schema")
    
    # At this point, the dataset object has been initialized, but the schema of the underlying table
    # has not yet been fetched, so the schema of the table and the schema of the dataset are not yet consistent
    
    # We run autodetection
    settings = dataset.autodetect_settings()
    # settings is now an object containing the "suggested" new dataset settings, including the completed schema
    # We can just save the new settings in order to "accept the suggestion"
    settings.save()
    

### SQL dataset: Modifying settings

The object returned by [`dataikuapi.dss.dataset.DSSDataset.get_settings()`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_settings> "dataikuapi.dss.dataset.DSSDataset.get_settings") depends on the kind of dataset.

For a SQL dataset, it will be a [`dataikuapi.dss.dataset.SQLDatasetSettings`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.SQLDatasetSettings> "dataikuapi.dss.dataset.SQLDatasetSettings").
    
    
    dataset = project.get_dataset("mydataset")
    settings = dataset.get_settings()
    
    # Set the table targeted by this SQL dataset
    settings.set_table(connection="myconnection", schema="myschema", table="mytable")
    settings.save()
    
    # If we have changed the table, there is a good chance that the schema is not good anymore, so we must
    # have DSS redetect it. `autodetect_settings` will however only detect if the schema is empty, so let's clear it.
    del settings.schema_columns[:]
    settings.save()
    
    # Redetect and save the suggestion
    settings = dataset.autodetect_settings()
    settings.save()
    

### Files-based dataset: Programmatic creation

#### Generic method for most connections

This applies to all files-based datasets, but may require additional setup
    
    
    dataset = project.create_fslike_dataset("mydataset", "HDFS", "name_of_connection", "path_in_connection")
    
    # At this point, the dataset object has been initialized, but the format is still unknown, and the
    # schema is empty, so the dataset is not yet usable
    
    # We run autodetection
    settings = dataset.autodetect_settings()
    # settings is now an object containing the "suggested" new dataset settings, including the detected format
    # and completed schema
    # We can just save the new settings in order to "accept the suggestion"
    settings.save()
    

#### Quick helpers for some connections
    
    
    # For S3: allows you to specify the bucket (if the connection does not already force a bucket)
    dataset = project.create_s3_dataset(dataset_name, connection, path_in_connection, bucket=None)
    

### Uploaded datasets: programmatic creation and upload
    
    
    dataset = project.create_upload_dataset("mydataset") # you can add connection= for the target connection
    
    with open("localfiletoupload.csv", "rb") as f:
            dataset.uploaded_add_file(f, "localfiletoupload.csv")
    
    # At this point, the dataset object has been initialized, but the format is still unknown, and the
    # schema is empty, so the dataset is not yet usable
    
    # We run autodetection
    settings = dataset.autodetect_settings()
    # settings is now an object containing the "suggested" new dataset settings, including the detected format
    # andcompleted schema
    # We can just save the new settings in order to "accept the suggestion"
    settings.save()
    

### Manual creation

You can create and setup all parameters of a dataset yourself. We do not recommend using this method.

For example loading the csv files of a folder
    
    
    project = client.get_project('TEST_PROJECT')
    folder_path = 'path/to/folder/'
    for file in listdir(folder_path):
        if not file.endswith('.csv'):
            continue
        dataset = project.create_dataset(file[:-4]  # dot is not allowed in dataset names
            ,'Filesystem'
            , params={
                'connection': 'filesystem_root'
                ,'path': folder_path + file
            }, formatType='csv'
            , formatParams={
                'separator': ','
                ,'style': 'excel'  # excel-style quoting
                ,'parseHeaderRow': True
            })
        df = pandas.read_csv(folder_path + file)
        dataset.set_schema({'columns': [{'name': column, 'type':'string'} for column in df.columns]})
    

## Programmatic creation and setup (managed datasets)

Managed datasets are much easier to create because they are managed by DSS

### Creating a new SQL managed dataset
    
    
    builder = project.new_managed_dataset("mydatasetname")
    builder.with_store_into("mysqlconnection")
    dataset = builder.create()
    

### Creating a new Files-based managed dataset with a specific schema
    
    
    builder = project.new_managed_dataset("mydatasetname")
    builder.with_store_into("myhdfsconnection", format_option_id="PARQUET_HIVE")
    dataset = builder.create()
    

### Creating a new partitioned managed dataset

This dataset copies partitioning from an existing dataset
    
    
    builder = project.new_managed_dataset("mydatasetname")
    builder.with_store_into("myhdfsconnection")
    builder.with_copy_partitioning_from("source_dataset")
    dataset = builder.create()
    

## Flow handling

For more details, please see [Flow creation and management](<../flow.html>) on programmatic flow building.

### Creating recipes from a dataset

This example creates a sync recipe to sync a dataset to another
    
    
    recipe_builder = dataset.new_recipe("sync")
    recipe_builder.with_new_output("target_dataset", "target_connection_name")
    recipe = recipe_builder.create()
    
    # recipe is now a :class:`dataikuapi.dss.recipe.DSSRecipe`, and you can run it
    recipe.run()
    

This example creates a code recipe from this dataset
    
    
    recipe_builder = dataset.new_recipe("python")
    recipe_builder.with_script("""
    import dataiku
    from dataiku import recipe
    
    input_dataset = recipe.get_inputs_as_datasets()[0]
    output_dataset = recipe.get_outputs_as_datasets()[0]
    
    df = input_dataset.get_dataframe()
    df = df.groupby("mycol").count()
    
    output_dataset.write_with_schema(df)
    """)
    recipe_builder.with_new_output_dataset("target_dataset", "target_connection_name")
    recipe = recipe_builder.create()
    
    # recipe is now a :class:`dataikuapi.dss.recipe.DSSRecipe`, and you can run it
    recipe.run()
    

## ML & Statistics

### Creating ML models

You can create a ML Task in order to train models based on a dataset. See [Visual Machine learning](<../ml.html>) for more details.
    
    
    dataset = project.get_dataset('mydataset')
    mltask = dataset.create_prediction_ml_task("variable_to_predict")
    mltask.train()
    

### Creating statistics worksheets

For more details, please see [Statistics worksheets](<../statistics.html>)
    
    
    dataset = project.get_dataset('mydataset')
    ws = dataset.create_statistics_worksheet(name="New worksheet")
    

## Misc operations

### Listing partitions

For partitioned datasets, the list of partitions is retrieved with [`list_partitions()`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.list_partitions> "dataikuapi.dss.dataset.DSSDataset.list_partitions"):
    
    
    partitions = dataset.list_partitions()
    # partitions is a list of string
    

### Clearing data

The rows of the dataset can be cleared, entirely or on a per-partition basis, with the [`clear()`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.clear> "dataikuapi.dss.dataset.DSSDataset.clear") method.
    
    
    dataset = project.get_dataset('SOME_DATASET')
    dataset.clear(['partition_spec_1', 'partition_spec_2'])         # clears specified partitions
    dataset.clear()                                                                                         # clears all partitions
    

### Hive operations

For datasets associated with a table in the Hive metastore, the synchronization of the table definition in the metastore with the dataset’s schema in DSS will be needed before it can be visible to Hive, and usable by Impala queries.
    
    
    dataset = project.get_dataset('SOME_HDFS_DATASET')
    dataset.synchronize_hive_metastore()
    

Or in the other direction, to synchronize the dataset’s information from Hive
    
    
    dataset = project.get_dataset('SOME_HDFS_DATASET')
    dataset.update_from_hive()
    
    # This will have the updated settings
    settings = dataset.get_settings()
    

## Detailed examples

This section contains more advanced examples on Datasets.

### Clear tagged Datasets

You can programmatically clear specific Datasets that match a given list of tags. The following code snippets will clear all Datasets that match _any_ of the names in the `tag` variable:
    
    
    tags = ["DEPRECATED", "TO_DELETE"]
    datasets_to_clear = []
    for ds_item in project.list_datasets():
        tag_intersection = list(set(tags) & set(ds_item["tags"]))
        if tag_intersection:
                datasets_to_clear.append(ds_item["name"])
    for d in datasets_to_clear:
        project.get_dataset(d).clear()
    

To match _all_ of the names in the `tag` variable:
    
    
    tags = ["DEPRECATED", "TO_DELETE"]
    datasets_to_clear = []
    for ds_item in project.list_datasets():
        if set(tags) == set(ds_item["tags"]):
            to_clear.append(ds_item["name"])
    for d in datasets_to_clear:
        project.get_dataset(d).clear()
    

### Compare Dataset schemas

If you want to compare the schemas of two Datasets you can leverage the [`get_schema()`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_schema> "dataikuapi.dss.dataset.DSSDataset.get_schema") method. In the following code snippet the `common_columns` contains columns names found both in Datasets `ds_a` and `ds_b`:
    
    
    import json
    
    def unpack_schema(s):
        return [json.dumps(x) for x in s]
    
    dataset_names = ["ds_a", "ds_b"]
    schemas = {}
    for ds in dataset_names: 
        schemas[ds] = project.get_dataset(ds) \
            .get_schema() \
            .get("columns")
        
    common_cols = set(unpack_schema(schemas["ds_a"])) \
        .intersection(unpack_schema(schemas["ds_b"]))
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.dataset.DSSDataset`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")(client, ...) | A dataset on the DSS instance.  
[`dataikuapi.dss.dataset.DSSDatasetSettings`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDatasetSettings> "dataikuapi.dss.dataset.DSSDatasetSettings")(...) | Base settings class for a DSS dataset.  
[`dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper> "dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper")(...) | Provide an helper to create partitioned dataset  
[`dataikuapi.dss.dataset.SQLDatasetSettings`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.SQLDatasetSettings> "dataikuapi.dss.dataset.SQLDatasetSettings")(...) | Settings for a SQL dataset.  
[`dataikuapi.dss.project.DSSProject`](<../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.recipe.CodeRecipeCreator`](<../../api-reference/python/recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator> "dataikuapi.dss.recipe.CodeRecipeCreator")(...) | Create a recipe running a script.  
[`dataikuapi.dss.recipe.DSSRecipeCreator`](<../../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator> "dataikuapi.dss.recipe.DSSRecipeCreator")(type, ...) | Helper to create new recipes.  
[`dataikuapi.dss.recipe.SingleOutputRecipeCreator`](<../../api-reference/python/recipes.html#dataikuapi.dss.recipe.SingleOutputRecipeCreator> "dataikuapi.dss.recipe.SingleOutputRecipeCreator")(...) | Create a recipe that has a single output.  
  
### Functions

[`autodetect_settings`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.autodetect_settings> "dataikuapi.dss.dataset.DSSDataset.autodetect_settings")([infer_storage_types]) | Detect appropriate settings for this dataset using Dataiku detection engine  
---|---  
[`build`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.build> "dataikuapi.dss.dataset.DSSDataset.build")([job_type, partitions, wait, no_fail]) | Start a new job to build this dataset and wait for it to complete.  
[`clear`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.clear> "dataikuapi.dss.dataset.DSSDataset.clear")([partitions]) | Clear data in this dataset.  
[`create`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper.create> "dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper.create")([overwrite]) | Executes the creation of the managed dataset according to the selected options  
[`create`](<../../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator.create> "dataikuapi.dss.recipe.DSSRecipeCreator.create")() | Creates the new recipe in the project, and return a handle to interact with it.  
[`create_prediction_ml_task`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.create_prediction_ml_task> "dataikuapi.dss.dataset.DSSDataset.create_prediction_ml_task")(target_variable[, ...]) | Creates a new prediction task in a new visual analysis lab for a dataset.  
[`create_statistics_worksheet`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.create_statistics_worksheet> "dataikuapi.dss.dataset.DSSDataset.create_statistics_worksheet")([name]) | Create a new worksheet in the dataset, and return a handle to interact with it.  
[`create_sql_table_dataset`](<../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_sql_table_dataset> "dataikuapi.dss.project.DSSProject.create_sql_table_dataset")(dataset_name, type, ...) | Create a new SQL table dataset in the project, and return a handle to interact with it.  
[`create_upload_dataset`](<../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_upload_dataset> "dataikuapi.dss.project.DSSProject.create_upload_dataset")(dataset_name[, connection]) | Create a new dataset of type 'UploadedFiles' in the project, and return a handle to interact with it.  
[`delete`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.delete> "dataikuapi.dss.dataset.DSSDataset.delete")([drop_data]) | Delete the dataset.  
[`get_dataset`](<../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_dataset> "dataikuapi.dss.project.DSSProject.get_dataset")(dataset_name) | Get a handle to interact with a specific dataset  
[`get_raw`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDatasetSettings.get_raw> "dataikuapi.dss.dataset.DSSDatasetSettings.get_raw")() | Get the raw dataset settings as a dict.  
[`get_schema`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_schema> "dataikuapi.dss.dataset.DSSDataset.get_schema")() | Get the dataset schema.  
[`get_settings`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_settings> "dataikuapi.dss.dataset.DSSDataset.get_settings")() | Get the settings of this dataset as a `DSSDatasetSettings`, or one of its subclasses.  
[`get_default_project`](<../../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")() | Get a handle to the current default project, if available (i.e.  
[`get_project`](<../../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`list_datasets`](<../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_datasets> "dataikuapi.dss.project.DSSProject.list_datasets")([as_type, include_shared, tags]) | List the datasets in this project.  
[`list_partitions`](<../../api-reference/python/datasets.html#dataiku.Dataset.list_partitions> "dataiku.Dataset.list_partitions")([raise_if_empty]) | List the partitions of this dataset, as an array of partition identifiers.  
[`new_managed_dataset`](<../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.new_managed_dataset> "dataikuapi.dss.project.DSSProject.new_managed_dataset")(dataset_name) | Initializes the creation of a new managed dataset.  
[`new_recipe`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.new_recipe> "dataikuapi.dss.dataset.DSSDataset.new_recipe")(type[, recipe_name]) | Start the creation of a new recipe taking this dataset as input.  
[`run`](<../../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe.run> "dataikuapi.dss.recipe.DSSRecipe.run")([job_type, partitions, wait, no_fail]) | Starts a new job to run this recipe and wait for it to complete.  
[`save`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDatasetSettings.save> "dataikuapi.dss.dataset.DSSDatasetSettings.save")() | Save settings.  
[`set_table`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.SQLDatasetSettings.set_table> "dataikuapi.dss.dataset.SQLDatasetSettings.set_table")(connection, schema, table[, catalog]) | Sets this SQL dataset in 'table' mode, targeting a particular table of a connection Leave catalog to None to target the default database associated with the connection  
[`with_new_output`](<../../api-reference/python/recipes.html#dataikuapi.dss.recipe.SingleOutputRecipeCreator.with_new_output> "dataikuapi.dss.recipe.SingleOutputRecipeCreator.with_new_output")(name, connection[, type, ...]) | Create a new dataset or managed folder as output to the recipe-to-be-created.  
[`with_new_output_dataset`](<../../api-reference/python/recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator.with_new_output_dataset> "dataikuapi.dss.recipe.CodeRecipeCreator.with_new_output_dataset")(name, connection[, ...]) | Create a new managed dataset as output to the recipe-to-be-created.  
[`with_script`](<../../api-reference/python/recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator.with_script> "dataikuapi.dss.recipe.CodeRecipeCreator.with_script")(script) | Set the code of the recipe-to-be-created.  
[`with_store_into`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper.with_store_into> "dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper.with_store_into")(connection[, ...]) | Sets the connection into which to store the new managed dataset

---

## [concepts-and-examples/datasets/index]

# Datasets

Note

There are two main classes related to datasets handling in Dataiku’s Python APIs:

  * [`dataiku.core.dataset.Dataset`](<../../api-reference/python/datasets.html#dataiku.Dataset> "dataiku.core.dataset.Dataset") in the `dataiku` package, which deals primarily with reading and writing data. It has the most flexibility when it comes to reading and writing

  * [`dataikuapi.dss.dataset.DSSDataset`](<../../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset") in the `dataikuapi` package which is mostly used for creating datasets, managing their settings, building flows, creating ML models, and performing a wider range of operations on datasets.




For more details on the two packages, please see [Getting started](<../../getting-started/index.html>)

For starting code samples, please see [Python Recipes](<https://doc.dataiku.com/dss/latest/code_recipes/python.html>).

Detailed samples about interacting with datasets can be found in:

Reference documentation for the classes supporting interaction with datasets can be found in [Datasets](<../../api-reference/python/datasets.html>)

---

## [concepts-and-examples/discussions]

# Discussions  
  
You can interact with the discussions on each DSS object through the API.

## Obtaining the discussions

The first step is always to retrieve a [`DSSObjectDiscussions`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions") object corresponding to the DSS object your manipulating. Generally, it’s through a method called `get_object_discussions`
    
    
    # Get the discussions of a dataset
    discussions = dataset.get_object_discussions()
    
    # Get the discussion of a wiki article
    discussions = wiki.get_article("my article").get_object_discussions()
    
    # Get the discussions of a project
    discussions = project.get_object_discussions()
    
    # ...
    

## List the discussions of an object
    
    
    for discussion in discussions.list_discussions():
            # Discussion is a DSSDiscussion object
            print("Discussion with id: %s" % discussion.discussion_id)
    

## Reading the messages of a discussion
    
    
    for message in discussion.get_replies():
            print("Message by author %s" % message.get_author())
            print("Message posted on %s" % message.get_timestamp())
            print("Message content: %s" % message.get_text())
    

## Adding a new message to a discussion
    
    
    discussion.add_reply("hello world\n# This is Markdown")
    

## Creating a new discussion
    
    
    new_discussion = discussions.create_discussion("Topic", "Hello, this is the message")
    

## Detailed examples

This section contains more advanced examples on discussions.

### Export discussions from a Project

You can programmatically retrieve all discussion messages from various “commentable” items in a Project.
    
    
    import dataiku
    
    def get_discussions_from_object(object_handle):
        """Return all discussion messages from a commentable object.
        """
        
        disc_data = []
        discussions = object_handle.get_object_discussions()
        for disc in discussions.list_discussions():
            disc_content = {}
            disc_content["topic"] = disc.get_metadata()["topic"]
            msg_list = []
            for msg in disc.get_replies():
                msg_content = {}
                msg_content["author"] = msg.get_author()
                msg_content["ts"] = msg.get_timestamp()
                msg_content["text"] = msg.get_text()
                msg_list.append(msg_content)
            disc_content["messages"] = msg_list
            disc_data.append(disc_content)
        return disc_data
    
            
    def export_project_discussions(project):
        """Return all discussion data for a given Project.
        """
    
        proj_disc = {}
        dispatch = {
            "datasets": {
                "f_list": project.list_datasets, 
                "f_get": project.get_dataset
            },
            "recipes": {
                "f_list": project.list_recipes,
                "f_get": project.get_recipe
            },
            "scenarios": {
                "f_list": project.list_scenarios,
                "f_get": project.get_scenario
            },
            "managed_folders": {
                "f_list": project.list_managed_folders,
                "f_get": project.get_managed_folder
            }
        }
        
        for obj_type, funcs in dispatch.items():
            obj_disc = []
            for item in funcs["f_list"]():
                disc = {}
                disc["name"] = item["name"]
                obj_handle = funcs["f_get"](item["name"])
                disc["discussions"] = get_discussions_from_object(obj_handle)
                obj_disc.append(disc)
            proj_disc[obj_type] = obj_disc
            
        # Special case: project discussions
        proj_disc["project"] = get_discussions_from_object(project)
        
        # Special case: wiki
        wiki_disc = []
        articles = project.get_wiki().list_articles()
        for art in articles:
            art_disc = {}
            art_disc["article_id"] = art.article_id
            art_disc["discussions"] = get_discussions_from_object(art)
            wiki_disc.append(art_disc)
        proj_disc["wiki"] = wiki_disc
        
        return proj_disc
    
    client = dataiku.api_client()
    project = client.get_default_project()
    discussions = export_project_discussions(project)
    

## Reference documentation

### Classes

[`dataikuapi.dss.discussion.DSSDiscussion`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSDiscussion> "dataikuapi.dss.discussion.DSSDiscussion")(...) | A handle to interact with a discussion.  
---|---  
[`dataikuapi.dss.discussion.DSSDiscussionReply`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSDiscussionReply> "dataikuapi.dss.discussion.DSSDiscussionReply")(...) | A read-only handle to access a discussion reply.  
[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")(...) | A handle to manage discussions on a DSS object.  
  
### Functions

[`add_reply`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSDiscussion.add_reply> "dataikuapi.dss.discussion.DSSDiscussion.add_reply")(text) | Adds a reply to a discussion.  
---|---  
[`create_discussion`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions.create_discussion> "dataikuapi.dss.discussion.DSSObjectDiscussions.create_discussion")(topic, message) | Creates a new discussion with one message.  
[`get_author`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSDiscussionReply.get_author> "dataikuapi.dss.discussion.DSSDiscussionReply.get_author")() | Gets the reply author.  
[`get_object_discussions`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_object_discussions> "dataikuapi.dss.dataset.DSSDataset.get_object_discussions")() | Get a handle to manage discussions on the dataset  
[`get_object_discussions`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_object_discussions> "dataikuapi.dss.project.DSSProject.get_object_discussions")() | Get a handle to manage discussions on the project  
[`get_object_discussions`](<../api-reference/python/wiki.html#dataikuapi.dss.wiki.DSSWikiArticle.get_object_discussions> "dataikuapi.dss.wiki.DSSWikiArticle.get_object_discussions")() | Get a handle to manage discussions on the article  
[`get_metadata`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSDiscussion.get_metadata> "dataikuapi.dss.discussion.DSSDiscussion.get_metadata")() | Gets the discussion metadata.  
[`get_replies`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSDiscussion.get_replies> "dataikuapi.dss.discussion.DSSDiscussion.get_replies")() | Gets the list of replies in this discussion.  
[`get_timestamp`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSDiscussionReply.get_timestamp> "dataikuapi.dss.discussion.DSSDiscussionReply.get_timestamp")() | Gets the reply timestamp.  
[`get_text`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSDiscussionReply.get_text> "dataikuapi.dss.discussion.DSSDiscussionReply.get_text")() | Gets the reply text.  
[`list_discussions`](<../api-reference/python/discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions.list_discussions> "dataikuapi.dss.discussion.DSSObjectDiscussions.list_discussions")() | Gets the list of discussions on the object.

---

## [concepts-and-examples/experiment-tracking]

# Experiment Tracking  
  
For an introduction to Experiment Tracking in DSS, please see [Experiment Tracking](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/index.html> "\(in Dataiku DSS v14\)").

Experiment Tracking in DSS uses the [MLflow Tracking](<https://www.mlflow.org/docs/2.17.2/tracking.html>) API.

## Detailed examples

The [tutorial section](<../tutorials/machine-learning/index.html>) contains several examples of experiment tracking implementation using a variety of frameworks.

## Reference documentation

[`dataikuapi.dss.mlflow.DSSMLflowExtension`](<../api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension> "dataikuapi.dss.mlflow.DSSMLflowExtension")(...) | A handle to interact with specific endpoints of the DSS MLflow integration.  
---|---  
[`dataikuapi.dss.project.DSSProject.get_mlflow_extension`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_mlflow_extension> "dataikuapi.dss.project.DSSProject.get_mlflow_extension")() | Get a handle to interact with the extension of MLflow provided by DSS

---

## [concepts-and-examples/feature-store]

# Feature Store  
  
The public API allows you to:

  * list feature groups [`dataikuapi.dss.feature_store.DSSFeatureStore.list_feature_groups()`](<../api-reference/python/feature-store.html#dataikuapi.dss.feature_store.DSSFeatureStore.list_feature_groups> "dataikuapi.dss.feature_store.DSSFeatureStore.list_feature_groups")

  * check if a dataset is a feature group [`dataikuapi.dss.dataset.DSSDatasetSettings.is_feature_group()`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDatasetSettings.is_feature_group> "dataikuapi.dss.dataset.DSSDatasetSettings.is_feature_group")

  * set/unset a dataset as a feature group: [`dataikuapi.dss.dataset.DSSDatasetSettings.set_feature_group()`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDatasetSettings.set_feature_group> "dataikuapi.dss.dataset.DSSDatasetSettings.set_feature_group")




See [Feature Store](<https://doc.dataiku.com/dss/latest/mlops/feature-store/index.html>) for more information.

## Listing feature groups
    
    
    import dataiku
    
    # if using API from inside DSS
    client = dataiku.api_client()
    
    feature_store = client.get_feature_store()
    
    feature_groups = feature_store.list_feature_groups()
    
    for feature_group in feature_groups:
        print("{}".format(feature_group.id))
    

Note

This will only display feature groups of projects on which the user has at least read permission

Note

Because of indexing latency, you have have to wait a few seconds before newly defined feature groups are visible

## (Un)setting a dataset as a Feature Group
    
    
    import dataiku
    
    # if using API from inside DSS
    client = dataiku.api_client()
    
    project = client.get_project('PROJECT_ID')
    
    ds = project.get_dataset('DATASET_ID')
    
    ds_settings = ds.get_settings()
    
    # pass False to undefine as Feature Group
    ds_settings.set_feature_group(True)
    
    ds_settings.save()
    

## Collecting feature groups with a specific meaning
    
    
    import dataiku
    
    # if using API from inside DSS
    client = dataiku.api_client()
    
    # Define the meaning ID to look for
    meaning="doublemeaning"
    
    result = set()
    
    # List feature group
    feature_store = client.get_feature_store()
    feature_groups = feature_store.list_feature_groups()
    feature_groups = [ feature_group.id for feature_group in feature_groups ]
    
    # Search for meaning
    for f in feature_groups:
        data = f.split('.')
        project = client.get_project(data[0])
        dataset = project.get_dataset(data[1])
        schema = dataset.get_schema()
        for col in schema['columns']:
            if ('meaning' in col) and (col['meaning'] == meaning):
                result.add(f)
    print(result)
    

## Documenting a feature store

There are several ways to document a feature group, acting on the underlying dataset:

  * [Adding a description](<datasets/datasets-other.html#ce-datasets-datasets-other-modifying-the-description-for-a-dataset>)

  * [Adding some tags](<datasets/datasets-other.html#ce-datasets-datasets-other-modifying-tags-for-a-dataset>)

  * [Describing the schema (meaning and comment)](<datasets/datasets-other.html#ce-datasets-datasets-other-modifying-meaning-of-a-column>)




## Reference documentation

### Classes

[`dataikuapi.dss.feature_store.DSSFeatureStore`](<../api-reference/python/feature-store.html#dataikuapi.dss.feature_store.DSSFeatureStore> "dataikuapi.dss.feature_store.DSSFeatureStore")(client) | A handle on the Feature Store.  
---|---  
[`dataikuapi.dss.feature_store.DSSFeatureGroupListItem`](<../api-reference/python/feature-store.html#dataikuapi.dss.feature_store.DSSFeatureGroupListItem> "dataikuapi.dss.feature_store.DSSFeatureGroupListItem")(...) | An item in a list of feature groups.  
  
### Functions

[`get_dataset`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_dataset> "dataikuapi.dss.project.DSSProject.get_dataset")(dataset_name) | Get a handle to interact with a specific dataset  
---|---  
[`get_feature_store`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_feature_store> "dataikuapi.DSSClient.get_feature_store")() | Get a handle to interact with the Feature Store.  
[`get_project`](<../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`get_schema`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_schema> "dataikuapi.dss.dataset.DSSDataset.get_schema")() | Get the dataset schema.  
[`get_settings`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.get_settings> "dataikuapi.dss.dataset.DSSDataset.get_settings")() | Get the settings of this dataset as a `DSSDatasetSettings`, or one of its subclasses.  
[`list_feature_groups`](<../api-reference/python/feature-store.html#dataikuapi.dss.feature_store.DSSFeatureStore.list_feature_groups> "dataikuapi.dss.feature_store.DSSFeatureStore.list_feature_groups")() | List the feature groups on which the user has at least read permissions.  
[`save`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDatasetSettings.save> "dataikuapi.dss.dataset.DSSDatasetSettings.save")() | Save settings.  
[`set_feature_group`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDatasetSettings.set_feature_group> "dataikuapi.dss.dataset.DSSDatasetSettings.set_feature_group")(status) | (Un)sets the dataset as a Feature Group, available in the Feature Store.

---

## [concepts-and-examples/fleetmanager/accounts]

# Fleet Manager Accounts  
  
Accounts are the different identities Fleet Manager can impersonate to manipulate cloud objects.

## Create an account
    
    
    import dataikuapi
    
    key_id = "<my key id>"
    key_secret = "<my key secret>"
    
    # <Cloud vendor> is either AWS, Azure or GCP
    client = dataikuapi.FMClient<Cloud vendor>("https://localhost", key_id, key_secret)
    
    # create an account
    creator = client.new_cloud_account_creator("My new account")
    
    # Set the different parameters
    account = creator.create()
    

## Reference documentation

[`dataikuapi.fm.cloudaccounts.FMCloudAccount`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.cloudaccounts.FMCloudAccount> "dataikuapi.fm.cloudaccounts.FMCloudAccount")(...) |   
---|---  
[`dataikuapi.fm.cloudaccounts.FMCloudAccountCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.cloudaccounts.FMCloudAccountCreator> "dataikuapi.fm.cloudaccounts.FMCloudAccountCreator")(...) |   
[`dataikuapi.fm.cloudaccounts.FMAWSCloudAccount`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.cloudaccounts.FMAWSCloudAccount> "dataikuapi.fm.cloudaccounts.FMAWSCloudAccount")(...) |   
[`dataikuapi.fm.cloudaccounts.FMAWSCloudAccountCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.cloudaccounts.FMAWSCloudAccountCreator> "dataikuapi.fm.cloudaccounts.FMAWSCloudAccountCreator")(...) |   
[`dataikuapi.fm.cloudaccounts.FMAzureCloudAccount`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.cloudaccounts.FMAzureCloudAccount> "dataikuapi.fm.cloudaccounts.FMAzureCloudAccount")(...) |   
[`dataikuapi.fm.cloudaccounts.FMAzureCloudAccountCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.cloudaccounts.FMAzureCloudAccountCreator> "dataikuapi.fm.cloudaccounts.FMAzureCloudAccountCreator")(...) |   
[`dataikuapi.fm.cloudaccounts.FMGCPCloudAccount`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.cloudaccounts.FMGCPCloudAccount> "dataikuapi.fm.cloudaccounts.FMGCPCloudAccount")(...) |   
[`dataikuapi.fm.cloudaccounts.FMGCPCloudAccountCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.cloudaccounts.FMGCPCloudAccountCreator> "dataikuapi.fm.cloudaccounts.FMGCPCloudAccountCreator")(...) |

---

## [concepts-and-examples/fleetmanager/fmclient]

# The main FMClient class  
  
The REST API Python client makes it easy to write client programs for the Fleet Manager REST API in Python. The REST API Python client is in the `dataikuapi` Python package.

The client is the entrypoint for many of the capabilities listed in this chapter.

## Creating a Fleet Manager client

To work with the API, a connection needs to be established with Fleet Manager, by creating an `FMClient` object. Once the connection is established, the `FMClient` object serves as the entry point to the other calls.

Depending on your cloud provider, you will have to create the dedicated `FMClient`:

  * a `FMClientAWS` for Amazon Web Services

  * a `FMClientAzure` for Microsoft Azure

  * a `FMClientGCP` for Google Cloud Platform




To connect you will need to provide the URL of your Fleet Manager server, and a key identifier and secret
    
    
    import dataikuapi
    
    key_id = "<my key id>"
    key_secret = "<my key secret>"
    
    client = dataikuapi.FMClientAWS("https://localhost", key_id, key_secret)
    
    client = dataikuapi.FMClientAzure("https://localhost", key_id, key_secret)
    
    client = dataikuapi.FMClientGCP("https://localhost", key_id, key_secret)
    
    # client is now a FMClient and can perform all authorized actions.
    # For example, list the Dataiku instances in the fleet for which you have access
    client.list_instances()
    

## Reference API doc

[`dataikuapi.fmclient.FMClient`](<../../api-reference/python/fleetmanager.html#dataikuapi.fmclient.FMClient> "dataikuapi.fmclient.FMClient")(host, ...[, ...]) |   
---|---  
[`dataikuapi.fmclient.FMClientAWS`](<../../api-reference/python/fleetmanager.html#dataikuapi.fmclient.FMClientAWS> "dataikuapi.fmclient.FMClientAWS")(host, ...[, ...]) |   
[`dataikuapi.fmclient.FMClientAzure`](<../../api-reference/python/fleetmanager.html#dataikuapi.fmclient.FMClientAzure> "dataikuapi.fmclient.FMClientAzure")(host, ...) |   
[`dataikuapi.fmclient.FMClientGCP`](<../../api-reference/python/fleetmanager.html#dataikuapi.fmclient.FMClientGCP> "dataikuapi.fmclient.FMClientGCP")(host, ...[, ...]) |

---

## [concepts-and-examples/fleetmanager/fminstances]

# Fleet Manager Instances  
  
Instances are the DSS instances that Fleet Manager will manage.

## Create an instance
    
    
    import dataikuapi
    
    key_id = "<my key id>"
    key_secret = "<my key secret>"
    
    # <Cloud vendor> is either AWS, Azure or GCP
    client = dataikuapi.FMClient<Cloud vendor>("https://localhost", key_id, key_secret)
    
    my_template_id = "ist-default"
    my_network_id = "vn-default"
    
    # create an instance
    creator = client.new_instance_creator("My new designer", my_template_id, my_network_id, "dss-11.0.3-default")
    dss = creator.create()
    
    # provision the instance
    status = dss.reprovision()
    res = status.wait_for_result()
    

## Reference documentation

[`dataikuapi.fm.instances.FMInstance`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMInstance> "dataikuapi.fm.instances.FMInstance")(client, ...) | A handle to interact with a DSS instance.  
---|---  
[`dataikuapi.fm.instances.FMInstanceCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMInstanceCreator> "dataikuapi.fm.instances.FMInstanceCreator")(...) |   
[`dataikuapi.fm.instances.FMAWSInstance`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMAWSInstance> "dataikuapi.fm.instances.FMAWSInstance")(...) |   
[`dataikuapi.fm.instances.FMAWSInstanceCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMAWSInstanceCreator> "dataikuapi.fm.instances.FMAWSInstanceCreator")(...) |   
[`dataikuapi.fm.instances.FMAzureInstance`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMAzureInstance> "dataikuapi.fm.instances.FMAzureInstance")(...) |   
[`dataikuapi.fm.instances.FMAzureInstanceCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMAzureInstanceCreator> "dataikuapi.fm.instances.FMAzureInstanceCreator")(...) |   
[`dataikuapi.fm.instances.FMGCPInstance`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMGCPInstance> "dataikuapi.fm.instances.FMGCPInstance")(...) |   
[`dataikuapi.fm.instances.FMGCPInstanceCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMGCPInstanceCreator> "dataikuapi.fm.instances.FMGCPInstanceCreator")(...) |   
[`dataikuapi.fm.instances.FMInstanceEncryptionMode`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMInstanceEncryptionMode> "dataikuapi.fm.instances.FMInstanceEncryptionMode")(value) | An enumeration.  
[`dataikuapi.fm.instances.FMInstanceStatus`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMInstanceStatus> "dataikuapi.fm.instances.FMInstanceStatus")(data) | A class holding read-only information about an Instance.  
[`dataikuapi.fm.instances.FMSnapshot`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instances.FMSnapshot> "dataikuapi.fm.instances.FMSnapshot")(client, ...) | A handle to interact with a snapshot of a DSS instance.

---

## [concepts-and-examples/fleetmanager/future]

# Fleet Manager Future  
  
A Future object allows to wait for the completion of an operation.

## Reference documentation

[`dataikuapi.fm.future.FMFuture`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.future.FMFuture> "dataikuapi.fm.future.FMFuture")(client, job_id) | A future on the DSS instance  
---|---

---

## [concepts-and-examples/fleetmanager/index]

# Fleet Manager

---

## [concepts-and-examples/fleetmanager/instancetemplates]

# Fleet Manager Instance Templates  
  
Instance settings templates allow to set several properties used when creating a new instance.

## Create a new settings template
    
    
    import dataikuapi
    
    key_id = "<my key id>"
    key_secret = "<my key secret>"
    
    # <Cloud vendor> is either AWS, Azure or GCP
    client = dataikuapi.FMClient<Cloud vendor>("https://localhost", key_id, key_secret)
    creator = client.new_instance_template_creator("MyTemplate")
    # set the properties of your template
    ...
    setting_template = creator.create()
    

## Reference documentation

[`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate> "dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate")(...) |   
---|---  
[`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplateCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplateCreator> "dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplateCreator")(...) |   
[`dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator> "dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator")(...) |   
[`dataikuapi.fm.instancesettingstemplates.FMAzureInstanceSettingsTemplateCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instancesettingstemplates.FMAzureInstanceSettingsTemplateCreator> "dataikuapi.fm.instancesettingstemplates.FMAzureInstanceSettingsTemplateCreator")(...) |   
[`dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator> "dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator")(...) |   
[`dataikuapi.fm.instancesettingstemplates.FMSetupAction`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instancesettingstemplates.FMSetupAction> "dataikuapi.fm.instancesettingstemplates.FMSetupAction")(...) |   
[`dataikuapi.fm.instancesettingstemplates.FMSetupActionStage`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instancesettingstemplates.FMSetupActionStage> "dataikuapi.fm.instancesettingstemplates.FMSetupActionStage")(value) | An enumeration.  
[`dataikuapi.fm.instancesettingstemplates.FMSetupActionAddJDBCDriverDatabaseType`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.instancesettingstemplates.FMSetupActionAddJDBCDriverDatabaseType> "dataikuapi.fm.instancesettingstemplates.FMSetupActionAddJDBCDriverDatabaseType")(value) | An enumeration.

---

## [concepts-and-examples/fleetmanager/loadbalancers]

# Load Balancers  
  
Load balancers act as application gateways in front of Dataiku nodes. They can also be used to perform load balancing in front of automation nodes to achieve high availability.

## Create a load balancer
    
    
    import dataikuapi
    
    key_id = "<my key id>"
    key_secret = "<my key secret>"
    
    # <Cloud vendor> is either AWS or Azure
    client = dataikuapi.FMClient<Cloud vendor>("https://localhost", key_id, key_secret)
    
    my_network_id = "vn-default"
    
    # create a load balancer
    creator = client.new_load_balancer_creator("My load balancer", my_network_id)
    
    # set the load balancer properties
    ...
    
    load_balancer = creator.create()
    status = load_balancer.reprovision()
    res = status.wait_for_result()
    

## Reference documentation

`dataikuapi.fm.loadbalancers.FMLoadBalancer`(...) |   
---|---  
`dataikuapi.fm.loadbalancers.FMLoadBalancerCreator`(...) |   
`dataikuapi.fm.loadbalancers.FMLoadBalancerPhysicalStatus`(data) | A class holding read-only information about an load balancer.  
`dataikuapi.fm.loadbalancers.FMAWSLoadBalancer`(...) |   
`dataikuapi.fm.loadbalancers.FMAWSLoadBalancerCreator`(...) |   
`dataikuapi.fm.loadbalancers.FMAzureLoadBalancer`(...) |   
`dataikuapi.fm.loadbalancers.FMAzureLoadBalancerCreator`(...) |   
`dataikuapi.fm.loadbalancers.FMAzureLoadBalancerTier`(value) | An enumeration.

---

## [concepts-and-examples/fleetmanager/tenant]

# Fleet Manager Tenant  
  
The FMCloudAuthentication and FMCloudCredentials help define how the authentication will be done on the cloud side.

FMCloudTags are the Fleet Manager tags.

## Reference documentation

[`dataikuapi.fm.tenant.FMCloudAuthentication`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.tenant.FMCloudAuthentication> "dataikuapi.fm.tenant.FMCloudAuthentication")(data) |   
---|---  
[`dataikuapi.fm.tenant.FMCloudCredentials`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.tenant.FMCloudCredentials> "dataikuapi.fm.tenant.FMCloudCredentials")(...) | A Tenant Cloud Credentials in the FM instance  
[`dataikuapi.fm.tenant.FMCloudTags`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.tenant.FMCloudTags> "dataikuapi.fm.tenant.FMCloudTags")(client, ...) | A Tenant Cloud Tags in the FM instance

---

## [concepts-and-examples/fleetmanager/virtualnetworks]

# Fleet Manager Virtual Networks  
  
A virtual network allows instances to communicate with each other.

## Create a new virtual network
    
    
    import dataikuapi
    
    key_id = "<my key id>"
    key_secret = "<my key secret>"
    
    # <Cloud vendor> is either AWS, Azure or GCP
    client = dataikuapi.FMClient<Cloud vendor>("https://localhost", key_id, key_secret)
    creator = client.new_virtual_network_creator("MyNetwork")
    # set the properties of your network
    ...
    network = creator.create()
    

## Reference documentation

[`dataikuapi.fm.virtualnetworks.FMVirtualNetwork`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMVirtualNetwork> "dataikuapi.fm.virtualnetworks.FMVirtualNetwork")(...) |   
---|---  
[`dataikuapi.fm.virtualnetworks.FMVirtualNetworkCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMVirtualNetworkCreator> "dataikuapi.fm.virtualnetworks.FMVirtualNetworkCreator")(...) |   
[`dataikuapi.fm.virtualnetworks.FMAWSVirtualNetwork`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMAWSVirtualNetwork> "dataikuapi.fm.virtualnetworks.FMAWSVirtualNetwork")(...) |   
[`dataikuapi.fm.virtualnetworks.FMAWSVirtualNetworkCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMAWSVirtualNetworkCreator> "dataikuapi.fm.virtualnetworks.FMAWSVirtualNetworkCreator")(...) |   
[`dataikuapi.fm.virtualnetworks.FMAzureVirtualNetwork`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMAzureVirtualNetwork> "dataikuapi.fm.virtualnetworks.FMAzureVirtualNetwork")(...) |   
[`dataikuapi.fm.virtualnetworks.FMAzureVirtualNetworkCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMAzureVirtualNetworkCreator> "dataikuapi.fm.virtualnetworks.FMAzureVirtualNetworkCreator")(...) |   
[`dataikuapi.fm.virtualnetworks.FMGCPVirtualNetwork`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMGCPVirtualNetwork> "dataikuapi.fm.virtualnetworks.FMGCPVirtualNetwork")(...) |   
[`dataikuapi.fm.virtualnetworks.FMGCPVirtualNetworkCreator`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMGCPVirtualNetworkCreator> "dataikuapi.fm.virtualnetworks.FMGCPVirtualNetworkCreator")(...) |   
[`dataikuapi.fm.virtualnetworks.FMHTTPSStrategy`](<../../api-reference/python/fleetmanager.html#dataikuapi.fm.virtualnetworks.FMHTTPSStrategy> "dataikuapi.fm.virtualnetworks.FMHTTPSStrategy")(...) |

---

## [concepts-and-examples/flow]

# Flow creation and management  
  
## Programmatically building a Flow

The flow, including datasets, recipes, … can be fully managed and created programmatically.

Datasets can be created and managed using the methods detailed in [Datasets (other operations)](<datasets/datasets-other.html>).

Recipes can be created using the [`new_recipe()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") method. This follows a builder pattern: [`new_recipe()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") returns you a recipe creator object, on which you add settings, and then call the [`create()`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator.create> "dataikuapi.dss.recipe.DSSRecipeCreator.create") method to actually create the recipe object.

The builder objects reproduce the functionality available in the recipe creation modals in the UI, so for more control on the recipe’s setup, it is often necessary to get its settings after creation, modify it, and save it again.

### Creating a Python recipe
    
    
    builder = project.new_recipe("python")
    
    # Set the input
    builder.with_input("myinputdataset")
    # Create a new managed dataset for the output in the filesystem_managed connection
    builder.with_new_output_dataset("grouped_dataset", "filesystem_managed")
    
    # Set the code - builder is a PythonRecipeCreator, and has a ``with_script`` method
    builder.with_script("""
    import dataiku
    from dataiku import recipe
    input_dataset = recipe.get_inputs_as_datasets()[0]
    output_dataset = recipe.get_outputs_as_datasets()[0]
    
    df = input_dataset.get_dataframe()
    df = df.groupby("something").count()
    output_dataset.write_with_schema(df)
    """)
    
    recipe = builder.create()
    
    # recipe is now a ``DSSRecipe`` representing the new recipe, and we can now run it
    job = recipe.run()
    

### Creating a Sync recipe
    
    
    builder = project.new_recipe("sync")
    builder = builder.with_input("input_dataset_name")
    builder = builder.with_new_output("output_dataset_name", "filesystem_managed")
    
    recipe = builder.create()
    job = recipe.run()
    

### Creating and modifying a grouping recipe

The recipe creation mostly handles setting up the inputs and outputs of the recipes, so most of the setup of the recipe has to be done by retrieving its settings, altering and saving them, then applying schema changes to the output

> 
>     builder = project.new_recipe("grouping")
>     builder.with_input("dataset_to_group_on")
>     # Create a new managed dataset for the output in the "filesystem_managed" connection
>     builder.with_new_output("grouped_dataset", "filesystem_managed")
>     builder.with_group_key("column")
>     recipe = builder.build()
>     
>     # After the recipe is created, you can edit its settings
>     recipe_settings = recipe.get_settings()
>     recipe_settings.set_column_aggregations("myvaluecolumn", sum=True)
>     recipe_settings.save()
>     
>     # And you may need to apply new schemas to the outputs
>     # This will add the myvaluecolumn_sum to the "grouped_dataset" dataset
>     recipe.compute_schema_updates().apply()
>     
>     # It should be noted that running a recipe is equivalent to building its output(s)
>     job = recipe.run()
>     

### A complete example

This examples shows a complete chain:

  * Creating an external dataset

  * Automatically detecting the settings of the dataset (see [Datasets (other operations)](<datasets/datasets-other.html>) for details)

  * Creating a prepare recipe to cleanup the dataset

  * Then chaining a grouping recipe, setting an aggregation on it

  * Running the entire chain



    
    
    dataset = project.create_sql_table_dataset("mydataset", "PostgreSQL", "my_sql_connection", "mytable", "myschema")
    
    dataset_settings = dataset.autodetect_settings()
    dataset_settings.save()
    
    # As a shortcut, we can call new_recipe on the DSSDataset object. This way, we don't need to call "with_input"
    
    prepare_builder = dataset.new_recipe("prepare")
    prepare_builder.with_new_output("mydataset_cleaned", "filesystem_managed")
    
    prepare_recipe = prepare_builder.create()
    
    # Add a step to clean values in "nb_colis" that are not valid Double
    prepare_settings = prepare_recipe.get_settings()
    prepare_settings.add_processor_step("FilterOnBadType", {
        "action":"REMOVE_ROW","booleanMode":"AND",
        "appliesTo":"SINGLE_COLUMN",
        "columns":["nb_colis"],"type":"Double"})
    prepare_settings.save()
    
    prepare_recipe.compute_schema_updates().apply()
    prepare_recipe.run()
    
    # Grouping recipe
    
    grouping_builder = project.new_recipe("grouping")
    grouping_builder.with_input("mydataset_cleaned")
    grouping_builder.with_new_output("mydataset_cleaned_grouped", "filesystem_managed")
    grouping_builder.with_group_key("week")
    grouping_recipe = grouping_builder.build()
    
    grouping_recipe_settings = grouping_recipe.get_settings()
    grouping_recipe_settings.set_column_aggregations("month", min=True)
    grouping_recipe_settings.save()
    
    grouping_recipe.compute_schema_updates().apply()
    grouping_recipe.run()
    

## Working with flow zones

### Listing and getting zones
    
    
    # List zones
    
    for zone in flow.list_zones():
        print("Zone id=%s name=%s" % (zone.id, zone.name))
    
        print("Zone has the following items:")
        for item in zone.items:
            print("Zone item: %s" % item)
    
    # Get a zone by id - beware, id not name
    zone = flow.get_zone("21344ZsQZ")
    
    # Get the "Default" zone
    zone = flow.get_default_zone()
    

### Creating a zone and adding items in it
    
    
    flow = project.get_flow()
    zone = flow.create_zone("zone1")
    
    # First way of adding an item to a zone
    dataset = project.get_dataset("mydataset")
    zone.add_item(dataset)
    
    # Second way of adding an item to a zone
    dataset = project.get_dataset("mydataset")
    dataset.move_to_zone(zone)
    
    # Third way of adding an item to a zone
    zones = flow.list_zones()
    zone = "zone1"
    zoneId = [z.id for z in zones if z.name==zone][0]
    
    dataset = project.get_dataset("mydataset")
    dataset.move_to_zone(zoneId)
    

### Changing the settings of a zone
    
    
    flow = project.get_flow()
    zone = flow.get_zone("21344ZsQZ")
    
    settings = zone.get_settings()
    settings.name = "New name"
    
    settings.save()
    

### Getting the zone of a dataset
    
    
    dataset = project.get_dataset("mydataset")
    
    zone = dataset.get_zone()
    print("Dataset is in zone %s" % zone.id)
    

## Navigating the flow graph

DSS builds the Flow graph dynamically by enumerating datasets, folders, models and recipes and linking all together through the inputs and outputs of the recipes. Since navigating this can be complex, the [`dataikuapi.dss.flow.DSSProjectFlow`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow> "dataikuapi.dss.flow.DSSProjectFlow") class gives you access to helpers for this

### Finding sources of the Flow
    
    
    flow = project.get_flow()
    graph = flow.get_graph()
    
    for source in graph.get_source_computables(as_type="object"):
        print("Flow graph has source: %s" % source)
    

### Enumerating the graph in order

This method will return all items in the graph, “from left to right”. Each item is returned as a [`DSSDataset`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<../api-reference/python/managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<../api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSStreamingEndpoint`](<../api-reference/python/streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint") or [`DSSRecipe`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")
    
    
    flow = project.get_flow()
    graph = flow.get_graph()
    
    for item in graph.get_items_in_traversal_order(as_type="object"):
        print("Next item in the graph is %s" % item)
    

### Replacing an input everywhere in the graph

This method allows you to replace an input (dataset for example) in every recipe where it appears as a input
    
    
    flow = project.get_flow()
    flow.replace_input_computable("old_dataset", "new_dataset")
    
    # Or to replace a managed folder
    flow.replace_input_computable("oldid", "newid", type="MANAGED_FOLDER")
    

## Schema propagation

When the schema of an input dataset is modified, or when the settings of a recipe are modified, you need to propagate this schema change across the flow.

This can be done from the UI, but can also be automated through the API
    
    
    flow = project.get_flow()
    
    # A propagation always starts from a source dataset and will move from left to right till the end of the Flow
    
    propagation = flow.new_schema_propagation("sourcedataset")
    
    future = propagation.start()
    future.wait_for_result()
    

There are many options for propagation, see [`dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder> "dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder")

## Exporting a flow documentation

This sample shows how to generate and download a flow documentation from a template.

See [Flow Document Generator](<https://doc.dataiku.com/dss/latest/flow/flow-document-generator.html>) for more information.
    
    
    # project is a DSSProject object
    
    flow = project.get_flow()
    
    # Launch the flow document generation by either
    # using the default template by calling without arguments
    # or specifying a managed folder id and the path to the template to use in that folder
    future = flow.generate_documentation(FOLDER_ID, "path/my_template.docx")
    
    # Alternatively, use a custom uploaded template file
    with open("my_template.docx", "rb") as f:
        future = flow.generate_documentation_from_custom_template(f)
    
    # Wait for the generation to finish, retrieve the result and download the generated
    # flow documentation to the specified file
    result = future.wait_for_result()
    export_id = result["exportId"]
    
    flow.download_documentation_to_file(export_id, "path/my_flow_documentation.docx")
    

## Detailed examples

This section contains more advanced examples on Flow-based operations.

### Delete orphaned Datasets

It can happen that after some operations on a Flow one or more Datasets end up not being linked to any Recipe and thus become disconnected from the Flow branches. In order to programmatically remove those Datasets from the Flow, you can list nodes that have neither predecessor nor successor in the graph using the following function:
    
    
    def delete_orphaned_datasets(project, drop_data=False, dry_run=True):
        """Delete datasets that are not linked to any recipe.
        """
    
        flow = project.get_flow()
        graph = flow.get_graph()
        cpt = 0
        for name, props in graph.nodes.items():
            if not props["predecessors"] and not props["successors"]:
                print(f"- Deleting {name}...")
                ds = project.get_dataset(name)
                if not dry_run:
                    ds.delete(drop_data=drop_data)
                    cpt +=1 
                else:
                    print("Dry run: nothing was deleted.")
        print(f"{cpt} datasets deleted.")
    
    
    

Attention

Note that the function has additional flags with default values set up to prevent accidental data deletion. Even so, we recommend you to remain extra cautious when clearing/deleting Datasets.

## Reference documentation

### Classes

[`dataikuapi.dss.recipe.CodeRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator> "dataikuapi.dss.recipe.CodeRecipeCreator")(...) | Create a recipe running a script.  
---|---  
[`dataikuapi.dss.dataset.DSSDataset`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")(client, ...) | A dataset on the DSS instance.  
[`dataikuapi.dss.flow.DSSFlowZone`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone")(flow, data) | A zone in the Flow.  
[`dataikuapi.dss.flow.DSSFlowZoneSettings`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSFlowZoneSettings> "dataikuapi.dss.flow.DSSFlowZoneSettings")(zone) | The settings of a flow zone.  
[`dataikuapi.dss.future.DSSFuture`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")(client, job_id) | A future represents a long-running task on a DSS instance.  
[`dataikuapi.dss.job.DSSJob`](<../api-reference/python/jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob")(client, ...) | A job on the DSS instance.  
[`dataikuapi.dss.project.DSSProject`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.flow.DSSProjectFlow`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow> "dataikuapi.dss.flow.DSSProjectFlow")(client, ...) |   
[`dataikuapi.dss.flow.DSSProjectFlowGraph`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlowGraph> "dataikuapi.dss.flow.DSSProjectFlowGraph")(...) |   
[`dataikuapi.dss.recipe.DSSRecipe`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")(client, ...) | A handle to an existing recipe on the DSS instance.  
[`dataikuapi.dss.recipe.DSSRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator> "dataikuapi.dss.recipe.DSSRecipeCreator")(type, ...) | Helper to create new recipes.  
[`dataikuapi.dss.recipe.DSSRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeSettings> "dataikuapi.dss.recipe.DSSRecipeSettings")(...) | Settings of a recipe.  
[`dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder> "dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder")(...) |   
[`dataikuapi.dss.recipe.GroupingRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.GroupingRecipeCreator> "dataikuapi.dss.recipe.GroupingRecipeCreator")(...) | Create a Group recipe.  
[`dataikuapi.dss.recipe.GroupingRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.GroupingRecipeSettings> "dataikuapi.dss.recipe.GroupingRecipeSettings")(...) | Settings of a grouping recipe.  
[`dataikuapi.dss.recipe.PrepareRecipeSettings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.PrepareRecipeSettings> "dataikuapi.dss.recipe.PrepareRecipeSettings")(...) | Settings of a Prepare recipe.  
[`dataikuapi.dss.recipe.SingleOutputRecipeCreator`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SingleOutputRecipeCreator> "dataikuapi.dss.recipe.SingleOutputRecipeCreator")(...) | Create a recipe that has a single output.  
[`dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder> "dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder")(...) |   
  
### Functions

[`add_processor_step`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.PrepareRecipeSettings.add_processor_step> "dataikuapi.dss.recipe.PrepareRecipeSettings.add_processor_step")(type, params) | Add a step in the script.  
---|---  
[`add_item`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSFlowZone.add_item> "dataikuapi.dss.flow.DSSFlowZone.add_item")(obj) | Adds an item to this zone.  
[`autodetect_settings`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.autodetect_settings> "dataikuapi.dss.dataset.DSSDataset.autodetect_settings")([infer_storage_types]) | Detect appropriate settings for this dataset using Dataiku detection engine  
[`compute_schema_updates`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe.compute_schema_updates> "dataikuapi.dss.recipe.DSSRecipe.compute_schema_updates")() | Computes which updates are required to the outputs of this recipe.  
[`create`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator.create> "dataikuapi.dss.recipe.DSSRecipeCreator.create")() | Creates the new recipe in the project, and return a handle to interact with it.  
[`create_sql_table_dataset`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_sql_table_dataset> "dataikuapi.dss.project.DSSProject.create_sql_table_dataset")(dataset_name, type, ...) | Create a new SQL table dataset in the project, and return a handle to interact with it.  
[`download_documentation_to_file`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.download_documentation_to_file> "dataikuapi.dss.flow.DSSProjectFlow.download_documentation_to_file")(export_id, path) | Download a flow documentation into the given output file.  
[`generate_documentation`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.generate_documentation> "dataikuapi.dss.flow.DSSProjectFlow.generate_documentation")([folder_id, path]) | Start the flow document generation from a template docx file in a managed folder, or from the default template if no folder id and path are specified.  
[`generate_documentation_from_custom_template`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.generate_documentation_from_custom_template> "dataikuapi.dss.flow.DSSProjectFlow.generate_documentation_from_custom_template")(fp) | Start the flow document generation from a docx template (as a file object).  
[`get_default_zone`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.get_default_zone> "dataikuapi.dss.flow.DSSProjectFlow.get_default_zone")() | Returns the default zone of the Flow.  
[`get_graph`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.get_graph> "dataikuapi.dss.flow.DSSProjectFlow.get_graph")() | Get the flow graph.  
[`get_items_in_traversal_order`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlowGraph.get_items_in_traversal_order> "dataikuapi.dss.flow.DSSProjectFlowGraph.get_items_in_traversal_order")([as_type]) | Get the list of nodes in left to right order.  
[`get_settings`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe.get_settings> "dataikuapi.dss.recipe.DSSRecipe.get_settings")() | Get the settings of the recipe, as a `DSSRecipeSettings` or one of its subclasses.  
[`get_source_computables`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlowGraph.get_source_computables> "dataikuapi.dss.flow.DSSProjectFlowGraph.get_source_computables")([as_type]) | 

param str as_type:
    How to return the source computables. Possible values are "dict" and "object" (defaults to **dict**)  
[`get_zone`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.get_zone> "dataikuapi.dss.flow.DSSProjectFlow.get_zone")(id) | Gets a single Flow zone by id.  
[`id`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSFlowZone.id> "dataikuapi.dss.flow.DSSFlowZone.id") |   
[`items`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSFlowZone.items> "dataikuapi.dss.flow.DSSFlowZone.items") | The list of items explicitly belonging to this zone.  
[`list_zones`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.list_zones> "dataikuapi.dss.flow.DSSProjectFlow.list_zones")() | Lists all zones in the Flow.  
[`move_to_zone`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.move_to_zone> "dataikuapi.dss.dataset.DSSDataset.move_to_zone")(zone) | Move this object to a flow zone  
[`new_recipe`](<../api-reference/python/datasets.html#dataikuapi.dss.dataset.DSSDataset.new_recipe> "dataikuapi.dss.dataset.DSSDataset.new_recipe")(type[, recipe_name]) | Start the creation of a new recipe taking this dataset as input.  
[`new_recipe`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe")(type[, name]) | Initializes the creation of a new recipe.  
[`new_schema_propagation`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.new_schema_propagation> "dataikuapi.dss.flow.DSSProjectFlow.new_schema_propagation")(dataset_name) | Start an automatic schema propagation from a dataset.  
[`replace_input_computable`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.replace_input_computable> "dataikuapi.dss.flow.DSSProjectFlow.replace_input_computable")(current_ref, new_ref) | This method replaces all references to a "computable" (Dataset, Managed Folder or Saved Model) as input of recipes in the whole Flow by a reference to another computable.  
[`run`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipe.run> "dataikuapi.dss.recipe.DSSRecipe.run")([job_type, partitions, wait, no_fail]) | Starts a new job to run this recipe and wait for it to complete.  
[`save`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeSettings.save> "dataikuapi.dss.recipe.DSSRecipeSettings.save")() | Save back the recipe in DSS.  
[`set_column_aggregations`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.GroupingRecipeSettings.set_column_aggregations> "dataikuapi.dss.recipe.GroupingRecipeSettings.set_column_aggregations")(column[, type, min, ...]) | Set the basic aggregations on a column.  
[`start`](<../api-reference/python/flow.html#dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder.start> "dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder.start")() | Starts the actual propagation.  
[`wait_for_result`](<../api-reference/python/other-administration.html#dataikuapi.dss.future.DSSFuture.wait_for_result> "dataikuapi.dss.future.DSSFuture.wait_for_result")() | Waits for the completion of the long-running task, and returns its result.  
[`with_group_key`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.GroupingRecipeCreator.with_group_key> "dataikuapi.dss.recipe.GroupingRecipeCreator.with_group_key")(group_key) | Set a column as the first grouping key.  
[`with_input`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator.with_input> "dataikuapi.dss.recipe.DSSRecipeCreator.with_input")(input_id[, project_key, role]) | Add an existing object as input to the recipe-to-be-created.  
[`with_new_output`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.SingleOutputRecipeCreator.with_new_output> "dataikuapi.dss.recipe.SingleOutputRecipeCreator.with_new_output")(name, connection[, type, ...]) | Create a new dataset or managed folder as output to the recipe-to-be-created.  
[`with_new_output_dataset`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator.with_new_output_dataset> "dataikuapi.dss.recipe.CodeRecipeCreator.with_new_output_dataset")(name, connection[, ...]) | Create a new managed dataset as output to the recipe-to-be-created.  
[`with_script`](<../api-reference/python/recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator.with_script> "dataikuapi.dss.recipe.CodeRecipeCreator.with_script")(script) | Set the code of the recipe-to-be-created.

---

## [concepts-and-examples/govern/govern-administration/govern-admin-roles-permissions/govern-role-assignment]

# Add a rule to assign a role to a new user  
      
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # get the role and permissions editor
    rp_editor = client.get_roles_permissions_handler()
    
    # retrieve the role assignments for the Business initiative blueprint
    bi_ra = rp_editor.get_role_assignments('bp.system.business_initiative')
    
    # get the definition
    bi_ra_def = bi_ra.get_definition()
    
    # add a rule to assign the new user to the project manager role
    project_manager_def = bi_ra_def.get_raw()['roleAssignmentsRules'].get('ro.project_manager', [])
    project_manager_def.append({
      "criteria": [],
      "userContainers": [{"type": "user", "login": "new_user"}]
    })
    bi_ra_def.get_raw()['roleAssignmentsRules']['ro.project_manager'] = project_manager_def
    bi_ra_def.save()

---

## [concepts-and-examples/govern/govern-administration/govern-admin-roles-permissions/govern-rules]

# Bootstrap default groups matching provided roles

Dataiku Govern comes with [several predefined roles and associated permissions](<https://doc.dataiku.com/dss/latest/security/govern-permissions.html> "\(in Dataiku DSS v14\)"). In a real use case, a company’s users and groups cannot be created upfront because they usually depend on the company LDAP setup.

The following script aims to create groups matching each of the provided roles along with their related [role assignment rules](<https://knowledge.dataiku.com/latest/govern/permissions/concept-roles-permissions.html>). Run this script to quickly try out Dataiku Govern with users **without considering security/permissions matters**.

After running this script, users can be put in these newly created groups to be assigned to the corresponding roles directly.
    
    
    import dataikuapi
    
    # Connect with a GovernClient
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # Create the groups
    client.create_group("readers", "Default group for read-only access")
    client.create_group("contributors", "Default group for contributor access")
    client.create_group("project_managers", "Default group for project manager access")
    
    # Setup the Role Assignment Rules
    rp = client.get_roles_permissions_handler()
    
    def setup_rars(blueprint_id):
        try:
            rp.create_role_assignments({ "blueprintId": blueprint_id })
        except:
            pass
        radef = rp.get_role_assignments(blueprint_id).get_definition()
    
        rar = radef.get_raw().get("roleAssignmentsRules", {})
    
        # set readers
        rar_list_reader = rar.get("ro.reader", [])
        rar_list_reader.append({
            "criteria": [],
            "userContainers": [{ "type": "group", "groupName": "readers" }],
            "fieldIds": []
        })
        rar["ro.reader"] = rar_list_reader
    
        # set contributors
        rar_list_contributor = rar.get("ro.contributor", [])
        rar_list_contributor.append({
            "criteria": [],
            "userContainers": [{ "type": "group", "groupName": "contributors" }],
            "fieldIds": []
        })
        rar["ro.contributor"] = rar_list_contributor
    
        # set project_managers
        rar_list_project_manager = rar.get("ro.project_manager", [])
        rar_list_project_manager.append({
            "criteria": [],
            "userContainers": [{ "type": "group", "groupName": "project_managers" }],
            "fieldIds": []
        })
        rar["ro.project_manager"] = rar_list_project_manager
    
        # re-create the rar
        radef.get_raw()["roleAssignmentsRules"] = rar
        radef.save()
    
    setup_rars("bp.system.business_initiative")
    setup_rars("bp.system.dataiku_project")

---

## [concepts-and-examples/govern/govern-administration/govern-admin-roles-permissions/index]

# Govern Roles and Permissions  
  
The Role and Permissions feature in Dataiku Govern lets you control who has authorization to view, edit, delete, and/or create items in Dataiku Govern.

The Roles and Permissions Handler in the Python API is used to manage roles, role assignments, and permissions.

See also

For a conceptual understanding of roles and permissions in Dataiku Govern, visit [Govern roles and permissions](<https://knowledge.dataiku.com/latest/govern/permissions/concept-roles-permissions.html>) in the Knowledge Base.

## Examples

## Reference documentation

[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler")(client) | Handle to edit the roles and permissions Do not create this directly, use [`get_roles_permissions_handler()`](<../../../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient.get_roles_permissions_handler> "dataikuapi.govern_client.GovernClient.get_roles_permissions_handler")  
---|---  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRoleListItem`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRoleListItem> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRoleListItem")(...) | An item in a list of roles.  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRole`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRole> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRole")(...) | A handle to interact with the roles of the instance as an admin.  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRoleDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRoleDefinition> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRoleDefinition")(...) | The definition of a specific role.  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignmentsListItem`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignmentsListItem> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignmentsListItem")(...) | An item in a list of blueprint role assignments.  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignments`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignments> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignments")(...) | A handle to interact with the blueprint role assignments for a specific blueprint Do not create this directly, use [`get_role_assignments()`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler.get_role_assignments> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler.get_role_assignments")  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignmentsDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignmentsDefinition> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignmentsDefinition")(...) | The role assignments for a specific blueprint.  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissionsListItem`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissionsListItem> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissionsListItem")(...) | An item in a list of blueprint permissions.  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissions`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissions> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissions")(...) | A handle to interact with blueprint permissions for a specific blueprint Do not create this directly, use [`get_blueprint_permissions()`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler.get_blueprint_permissions> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler.get_blueprint_permissions")  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissionsDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissionsDefinition> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissionsDefinition")(...) | The permissions for a specific blueprint.  
[`dataikuapi.govern.admin_roles_permissions_handler.GovernAdminDefaultPermissionsDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminDefaultPermissionsDefinition> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminDefaultPermissionsDefinition")(...) | The default permissions of the instance Do not create this directly, use [`get_default_permissions_definition()`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler.get_default_permissions_definition> "dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler.get_default_permissions_definition")

---

## [concepts-and-examples/govern/govern-administration/govern-authinfo]

# Authentication information and impersonation

## Introduction

From any Python code, it is possible to retrieve information about the user or API key currently running this code.

This can be used:

  * From code running outside of Dataiku Govern, simply to retrieve details of the current API key




Furthermore, the API provides the ability, from a set of HTTP headers, to identify the user represented by these headers.

## Code samples

### Getting your own login information
    
    
    auth_info = client.get_auth_info()
    
    # auth_info is a dict which contains at least a "authIdentifier" field, which is the login for a user
    print("User running this code is %s" % auth_info["authIdentifier"])
    

### Impersonating another user

As a Dataiku Govern administrator, it can be useful to be able to perform API calls on behalf of another user.
    
    
    user = client.get_user("the_user_to_impersonate")
    client_as_user = user.get_client_as()
    
    # All calls done using `client_as_user` will appear as being performed by `the_user_to_impersonate` and will inherit
    # its permissions
    

## Reference documentation

[`dataikuapi.govern_client.GovernClient.get_auth_info`](<../../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient.get_auth_info> "dataikuapi.govern_client.GovernClient.get_auth_info")() | Returns various information about the user currently authenticated using this instance of the API client.  
---|---

---

## [concepts-and-examples/govern/govern-administration/govern-other-administration]

# Other administration tasks  
  
Here are some more global administration tasks that can be performed using the DSS Public API:

  * Reading and writing general instance settings

  * Managing global API keys




## Reference documentation

[`dataikuapi.govern.admin.GovernGeneralSettings`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernGeneralSettings> "dataikuapi.govern.admin.GovernGeneralSettings")(client) | The general settings of the Dataiku Govern instance.  
---|---  
[`dataikuapi.govern.admin.GovernGlobalApiKey`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernGlobalApiKey> "dataikuapi.govern.admin.GovernGlobalApiKey")(...) | A global API key on the Dataiku Govern instance

---

## [concepts-and-examples/govern/govern-administration/govern-users-groups]

# Users and groups  
  
The API exposes key parts of the Dataiku Govern access control management: users and groups. All these can be created, modified and deleted through the API.

## Example use cases

In all examples, client is a [`dataikuapi.govern_client.GovernClient`](<../../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient> "dataikuapi.govern_client.GovernClient"), obtained using `dataikuapi.govern_client.GovernClient.__init__()`

### Listing users
    
    
    client = GovernClient(host, apiKey)
    govern_users = client.list_users()
    # govern_users is a list of dict. Each item represents one user
    prettyprinter.pprint(govern_users)
    

outputs
    
    
    [   {   'displayName': 'Administrator',
            'groups': ['administrators', 'data_scientists'],
            'login': 'admin',
            'sourceType': 'LOCAL'},
        ...
    ]
    

### Creating a user

#### A local user with a password
    
    
    new_user = client.create_user('test_login', 'test_password', display_name='a test user', groups=['all_powerful_group'])
    

new_user is a [`dataikuapi.govern.admin.GovernUser`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernUser> "dataikuapi.govern.admin.GovernUser")

#### A user who will login through LDAP

Note that it is not usually required to manually create users who will login through LDAP as they can be automatically provisionned
    
    
    new_user = client.create_user('test_login', password=None, display_name='a test user', source_type="LDAP", groups=['all_powerful_group'], profile="DESIGNER")
    

#### A user who will login through SSO

This is only for non-LDAP users that thus will not be automatically provisioned, buut should still be able to log in through SSO.
    
    
    new_user = client.create_user('test_login', password=None, display_name='a test user', source_type="LOCAL_NO_AUTH", groups=['all_powerful_group'], profile="DESIGNER")
    

### Modifying a user’s display name, groups, profile, email, …

To modify the settings of a user, get a handle through [`dataikuapi.govern_client.GovernClient.get_user()`](<../../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient.get_user> "dataikuapi.govern_client.GovernClient.get_user"), then use [`dataikuapi.govern.admin.GovernUser.get_settings()`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernUser.get_settings> "dataikuapi.govern.admin.GovernUser.get_settings")
    
    
    user = client.get_user("theuserslogin")
    
    settings = user.get_settings()
    
    # Modify the settings in the `get_raw()` dict
    settings.get_raw()["displayName"] = "Govern Lover"
    settings.get_raw()["email"] = "[[email protected]](</cdn-cgi/l/email-protection>)"
    settings.get_raw()["userProfile"] = "DESIGNER"
    settings.get_raw()["groups"] = ["group1", "group2", "group3"] # This completely overrides previous groups
    
    # Save the modifications
    settings.save()
    

### Deleting a user
    
    
    user = client.get_user('test_login')
    user.delete()
    

### Impersonating another user

As a Dataiku Govern administrator, it can be useful to be able to perform API calls on behalf of another user.
    
    
    user = client.get_user("the_user_to_impersonate")
    client_as_user = user.get_client_as()
    
    # All calls done using `client_as_user` will appear as being performed by `the_user_to_impersonate` and will inherit
    # its permissions
    

### Listing groups

A list of the groups can by obtained with the list_groups method:
    
    
    client = GovernClient(host, apiKey)
    # govern_groups is a list of dict. Each group contains at least a "name" attribute
    govern_groups = client.list_groups()
    prettyprinter.pprint(govern_groups)
    

outputs
    
    
    [   {   'admin': True,
            'description': 'Govern administrators',
            'name': 'administrators',
            'sourceType': 'LOCAL'},
        {   'admin': False,
            'description': 'Read-write access',
            'name': 'data_scientists',
            'sourceType': 'LOCAL'},
        {   'admin': False,
            'description': 'Read-only access',
            'name': 'readers',
            'sourceType': 'LOCAL'}]
    

### Creating a group
    
    
    new_group = client.create_group('test_group', description='test group', source_type='LOCAL')
    

### Modifying settings of a group

First, retrieve the group definition with a get_definition call, alter the definition, and set it back into Govern:
    
    
    group_definition = new_group.get_definition()
    group_definition['admin'] = True
    group_definition['ldapGroupNames'] = ['group1', 'group2']
    new_group.set_definition(group_definition)
    

### Deleting a group
    
    
    group = client.get_group('test_group')
    group.delete()
    

## Reference documentation

[`dataikuapi.govern.admin.GovernUser`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernUser> "dataikuapi.govern.admin.GovernUser")(client, login) | A handle for a user on the Dataiku Govern instance.  
---|---  
[`dataikuapi.govern.admin.GovernUserSettings`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernUserSettings> "dataikuapi.govern.admin.GovernUserSettings")(...) | Settings for a Dataiku Govern user.  
[`dataikuapi.govern.admin.GovernOwnUser`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernOwnUser> "dataikuapi.govern.admin.GovernOwnUser")(client) | A handle to interact with your own user  
[`dataikuapi.govern.admin.GovernOwnUserSettings`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernOwnUserSettings> "dataikuapi.govern.admin.GovernOwnUserSettings")(...) | Settings for the current Dataiku Govern user.  
[`dataikuapi.govern.admin.GovernGroup`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin.GovernGroup> "dataikuapi.govern.admin.GovernGroup")(client, name) | A group on the Dataiku Govern instance.

---

## [concepts-and-examples/govern/govern-administration/govern-utils]

# Utilities

These classes are various utilities that are used in various parts of the API.

## Reference documentation

[`dataikuapi.govern.blueprint.GovernBlueprintVersionId`](<../../../api-reference/python/govern.html#dataikuapi.govern.blueprint.GovernBlueprintVersionId> "dataikuapi.govern.blueprint.GovernBlueprintVersionId")(...) | A Blueprint Version ID builder  
---|---  
[`dataikuapi.govern.users_container.GovernUsersContainer`](<../../../api-reference/python/govern.html#dataikuapi.govern.users_container.GovernUsersContainer> "dataikuapi.govern.users_container.GovernUsersContainer")(type) | An abstract class to represent a users container definition.  
[`dataikuapi.govern.users_container.GovernUserUsersContainer`](<../../../api-reference/python/govern.html#dataikuapi.govern.users_container.GovernUserUsersContainer> "dataikuapi.govern.users_container.GovernUserUsersContainer")(...) | A users container representing a single user

---

## [concepts-and-examples/govern/govern-administration/index]

# Administration  
  
This section will help with users, groups, roles, permissions, and other administrative topics.

---

## [concepts-and-examples/govern/govern-advanced/govern-actions]

# Govern Actions

Actions are used to manually trigger user-defined scripts in Dataiku Govern. They are written in Python and exist at two levels: artifact and instance.

Here, we provide some use cases that demonstrate how to use actions.

## Trigger a scenario on a design node from a govern artifact

Scenarios defined at the project level in the Design node can be triggered directly from the Govern node using actions attached to project artifacts.

The logic implemented here is the following:

  * Retrieve the Dataiku projects associated with the Govern project.

  * Loop over the artifacts retrieving the associated project key and node ID and filtering out automation nodes.

  * Use DSSClient on each Dataiku artifact to retrieve the requested scenario and run it with the specified custom parameters.




Note

In the sample code below, the scenario is run synchronously, blocking the kernel until its completion. The scenario can also be run asynchronously using scenario.run(params)
    
    
    from govern.core.artifact_action_handler import get_artifact_action_handler
    import dataikuapi
    import logging
    
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    handler = get_artifact_action_handler()
    
    SCENARIO_ID = 'TESTPARAM'
    
    DSS_NODES_CONFIG = {
        "Staging design": {
            "url": "https://design-node-url",
            "api_key": "SECRET_KEY"
        }
    }
    
    def get_dataiku_items_from_govern_item(govern_client, govern_item):
        definition = govern_item.get_definition()
        dku_items = definition.get_raw().get('fields', {}).get('dataiku_item', [])
        return [govern_client.get_artifact(artifact_id) for artifact_id in dku_items]
    
    def trigger_scenario_on_node(node_id, project_key, scenario_id):
        if node_id not in DSS_NODES_CONFIG:
            logger.info(f"[Skipping] No credentials for Node ID: {node_id}")
            return
    
        creds = DSS_NODES_CONFIG[node_id]
        try:
            client = dataikuapi.DSSClient(creds["url"], creds["api_key"])
            project = client.get_project(project_key)
            scenario = project.get_scenario(scenario_id)
            params = handler.params
    
            logger.info(f"Triggering scenario '{SCENARIO_ID}' on project '{project_key}' and node '{node_id}'")
    
            # we can run the scenario asynchronously and not wait for the result
            # outcome = scenario.run(params)
            outcome = scenario.run_and_wait(params)
            logger.info(f"Scenario finished with outcome: {outcome.outcome}")
    
        except Exception as e:
            handler.status = "ERROR"
            handler.message = f"An error occurred: {e}"
            logger.error(f"An error occurred running the scenario: {e}")
    
    
    def trigger_scenario_workflow():
        govern_client = handler.client
    
        govern_project = govern_client.get_artifact(handler.enrichedArtifact.artifact.id)
    
        linked_dku_artifacts = get_dataiku_items_from_govern_item(govern_client, govern_project)
    
        logger.info(f"Found {len(linked_dku_artifacts)} linked Dataiku projects.")
    
        for dku_artifact in linked_dku_artifacts:
            raw_fields = dku_artifact.get_definition().get_raw().get('fields', {})
    
            target_project_key = raw_fields.get('project_key')
            target_node_id = raw_fields.get('node_id')
            is_automation = raw_fields.get('automation_node')
            logger.info(f"Processing '{target_project_key}' on '{target_node_id}'")
    
            # Filter: Skip if it is an automation node
            if is_automation is True:
                logger.info(f"Skipping automation node project '{target_project_key}' and node '{target_node_id}'")
                continue
    
            # Process only Design nodes
            if target_project_key and target_node_id:
                trigger_scenario_on_node(target_node_id, target_project_key, SCENARIO_ID)
    
    
    
    trigger_scenario_workflow()
    

## Create a DSS Project with custom settings from a Govern Artifact

### Context

This example demonstrates how to use Dataiku Govern for **Project Pre-qualification** before technical development begins.

  1. **Blueprint & Pre-assessment:** Users initiate the process by creating an Artifact from a Blueprint (e.g., “Project pre-qualification”). This stage allows stakeholders to document the feasibility, assess risks, and define necessary controls.

  2. **Assertion of Readiness:** When the assessment is complete, the user asserts readiness by enabling the checkbox field with id dss_project_creation. This acts as a validation gate.

  3. **Trigger Creation Action:** The user clicks the custom action button. If the validation gate is checked, the script automatically creates a project on the Dataiku Design node, carrying over the approved metadata.




Note

This script relies on three specific fields that should be present in the Blueprint Version:
    

  * description: a field of type TEXT

  * controls: a field of type TEXT list

  * dss_project_creation: a field of type BOOLEAN




### Logic Implemented

The logic implemented in the code sample is the following:

  * Retrieve the dss_project_creation, description and controls fields from the Govern artifact.

  * If the dss_project_creation field is True:

    * Connect to the remote Design node using dataikuapi.DSSClient.

    * Impersonate the artifact owner to ensure the project is created under their user profile.

_(Note: The user must exist on both the Govern and Design nodes for impersonation to succeed; otherwise, the script falls back to the Admin user.)_

    * Create a new project using a key and name derived from the artifact.

    * Add specific tags and checklist to the project metadata.

    * Set the project status to “Draft”.

    * return the project link to be displayed in a success message

  * If the dss_project_creation field is False:

    * Set the handler status to `ERROR` and return a message prompting the user to confirm the creation.




Note

For more examples and API details, please refer to the [Projects](<../../projects.html>) documentation.
    
    
    from govern.core.artifact_action_handler import get_artifact_action_handler
    import dataiku
    import dataikuapi
    import re
    import logging
    
    # import logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    ### CONFIGURATION TO CHANGE
    DSS_URL = 'http://localhost:8086'
    DSS_API_KEY = 'dkuaps-XXXXX'
    ### /CONFIGURATION
    
    
    def create_checklist(author, items):
        checklist = {
            "title": "To-do list",
            "createdOn": 0,
            "items": []
        }
        for item in items:
            checklist["items"].append({
                "createdBy": author,
                "done": False,
                "stateChangedOn": 0,
                "text": item
            })
        return checklist
    
    def impersonate_client(client, owner):
        try:
            # If it's an API key user, we usually cannot 'impersonate' them via get_user()
            # so we return the original client.
            if owner.startswith('api:'):
                logger.info(f"Request coming from api. keeping old client.")
    
                return client
            logger.info(f"Creating client to act as user {owner}.")
            return client.get_user(owner).get_client_as()
        except Exception as e:
            # Good practice: Log why it failed, fallback to original client
            logger.error(f"Impersonation failed for {owner}: {e}. Using original client.")
            return client
    
    
    def create_custom_project(client,
                                owner,
                                project_key,
                                name,
                                custom_tags,
                                description,
                                checklist_items):
    
        acting_client = impersonate_client(client, owner)
        project = acting_client.create_project(project_key=project_key,
                                        name=name,
                                        owner=owner,
                                        description=description)
    
        logger.info(f"Project with key: {project.get_summary()['projectKey']} created.")
    
        # Add checklist
        metadata = project.get_metadata()
        metadata["checklists"]["checklists"].append(create_checklist(author=owner,
                                                                     items=checklist_items))
        # Add tags
        metadata["tags"] = custom_tags
    
        project.set_metadata(metadata)
    
        # Set default status to "Draft"
        settings = project.get_settings()
        settings.settings["projectStatus"] = "Draft"
        settings.save()
        logger.info(f"Project with key: {project.get_summary()['projectKey']} updated and set as draft.")
    
        return project
    
    def clean_and_uppercase(input_string):
        # Remove all special characters, keeping only alphanumeric characters and spaces
        cleaned_string = re.sub(r'[^A-Za-z0-9]+', '', input_string)
        # Convert to uppercase
        return cleaned_string.upper()
    
    
    handler = get_artifact_action_handler()
    enrichedArtifact = handler.enrichedArtifact
    artifact = enrichedArtifact.artifact
    
    dss_project_tags = ["created from Govern"]
    dss_project_controls = artifact.fields.get("controls")
    if dss_project_controls:
        dss_project_tags.extend(dss_project_controls)
    
    dss_project_checklist = [
        "Connect to data sources",
        "Clean, aggregate and join data",
        "Train ML model",
        "Evaluate ML model",
        "Deploy ML model to production"
        ]
    
    dss_project_owner = handler.authCtxIdentifier
    dss_project_name = artifact.name
    dss_project_key = clean_and_uppercase(dss_project_name)
    dss_project_description = artifact.fields.get("description")
    
    checkbox_value = artifact.fields.get("dss_project_creation")
    if (str(checkbox_value) == "True"):
        dss_client = dataikuapi.DSSClient(DSS_URL, DSS_API_KEY)
    
        project = create_custom_project(client=dss_client,
                                    owner=dss_project_owner,
                                    project_key=dss_project_key,
                                    name=dss_project_name,
                                    custom_tags=dss_project_tags,
                                    description=dss_project_description,
                                    checklist_items=dss_project_checklist)
        handler.status = "SUCCESS"
        handler.message = f"Project created with link: {DSS_URL}/projects/{project.get_summary()['projectKey']}"
    else:
        handler.status = "ERROR"
        handler.message = "Please confirm the creation of the project by checking the box above."

---

## [concepts-and-examples/govern/govern-advanced/govern-admin-blueprint-designer/govern-blueprint-html-documentation]

# Govern Blueprint HTML Documentation

In each view component, you have the possibility to define a HTML documentation which will be displayed along with the component itself.

## Example 1. Create a show more/less button

In the case of a very long content in the HTML documentation of a view component, it may be useful to have a “show more” / “show less” button to be able to hide / show part of this content.

Note that you need to make sure that the IDs of the tag elements in the code are unique among all documentations shown in a page. You may want to generate a unique identifier as a prefix for all the IDs for this purpose.

The following HTML can be used in a HTML documentation field in the Blueprint Designer to add a “show more” / “show less” button:
    
    
    A program initiative is a coordinated set of activities, projects, or strategic efforts designed to achieve specific long-term business objectives.
        <br><br>
    
        <button id="0250de15a30e-showmore-button" onclick="document.getElementById('0250de15a30e-text').style['display'] = 'inherit';document.getElementById('0250de15a30e-showless-button').style['display'] = 'inherit';document.getElementById('0250de15a30e-showmore-button').style['display'] = 'none';">Show more</button>
    
        <button id="0250de15a30e-showless-button" onclick="document.getElementById('0250de15a30e-text').style['display'] = 'none';document.getElementById('0250de15a30e-showmore-button').style['display'] = 'inherit';document.getElementById('0250de15a30e-showless-button').style['display'] = 'none';" style="display: none;">Show less</button>
    
        <div id="0250de15a30e-text" style="display:none">
        <br>
        These initiatives are typically aligned with the organization's broader mission and vision, aiming to drive significant growth, innovation, or transformation across various departments or functions.
        <br><br>
        Key Characteristics of a Program Initiative:
        <br><br>
        1 - Strategic Alignment: Program initiatives are directly linked to the company’s strategic goals. They are often part of a larger portfolio of initiatives that collectively support the company's long-term vision, such as entering new markets, enhancing operational efficiency, or launching new products.
        <br><br>
        2 - Cross-Functional Collaboration: These initiatives usually require the collaboration of multiple departments or business units. For instance, a program focused on digital transformation might involve IT, operations, marketing, and human resources working together to modernize the company’s technology infrastructure and processes.
        <br><br>
        3 - Resource Allocation: Due to their complexity and scope, program initiatives typically require substantial resources, including budget, personnel, and time. They are often managed by a dedicated program manager or team, responsible for overseeing the initiative’s progress and ensuring it stays on track.
        <br><br>
        4 - Long-Term Focus: Unlike short-term projects, program initiatives are long-term efforts that may span several months or even years. They are designed to create lasting impact, such as implementing a company-wide sustainability strategy or overhauling a customer relationship management (CRM) system.
        <br><br>
        5 - Measurable Outcomes: Success for a program initiative is measured against clearly defined outcomes or key performance indicators (KPIs). These might include financial metrics, such as revenue growth, or operational metrics, like improved customer satisfaction or reduced time-to-market.
        <br><br>
        6 - Governance and Oversight: Program initiatives typically involve a formal governance structure to monitor progress, manage risks, and ensure alignment with the company’s overall strategy. This might include regular reporting to senior leadership and adjustments to the initiative’s scope or direction as needed.
        </div>

---

## [concepts-and-examples/govern/govern-advanced/govern-admin-blueprint-designer/govern-blueprint-migration]

# Script a blueprint migration

Dataiku Govern requires a Python script to define the conditions for blueprint migrations. Blueprint migration scripts allow you to control how an artifact’s information is mapped from one blueprint version to another. This page provides some guidance about how to script a blueprint migration.

Note

The migration script cannot edit the structure of blueprint versions. It can only map the information of an artifact within the framework of existing blueprint versions.

See also

If you are only interested in applying blueprint migrations, check out [How-to | Switch artifact templates (blueprint versions)](<https://knowledge.dataiku.com/latest/govern/customization/how-to-switch-templates.html>).

## Pre-populated lines

The pre-populated lines in the script establish the source and target blueprints.
    
    
    from govern.core.migration_handler import get_migration_handler
    
    handler = get_migration_handler()
    ### Get the artifact to migrate
    target_artifact = handler.target_artifact
    ### Get the source enriched artifact
    source_enriched_artifact = handler.source_enriched_artifact
    ### Get the target blueprint version definition
    target_blueprint_version = handler.target_blueprint_version
    

There are also a few lines that are commented out that may help you do things like rename the target artifact, create default target fields, etcetera.

Note

`source_enriched_artifact` contains multiple objects:

  * the source blueprint (`source_enriched_artifact.blueprint`)

  * the source blueprint version (`source_enriched_artifact.blueprint_version`)

  * the source artifact (`source_enriched_artifact.artifact`)




The most important one that needs to be manipulated is `target_artifact`.

Important

A key point is that the `target_artifact` object in the migration script is a **copy of the incoming artifact** that will be migrated.

### Managing fields

When writing a migration script, one main task is to migrate the fields. For each field being migrated, there are four possible cases to consider:

Case | Old blueprint version | New blueprint version  
---|---|---  
Case 1 | Field exists | Field exists with the same definition  
Case 2 | Field exists | Field exists with different definition  
Case 3 | Field exists | Field doesn’t exist  
Case 4 | Field doesn’t exist | Field exists  
  
Note

In the examples below, `fields` is a python dictionary and is accessed with `target_artifact.fields`.

#### Case 1

The field already exists in the old BPV, and the field still exists in the new BPV with the same definition.

→ Nothing to do in the migration script, because the copied value is valid.

#### Case 2

The field already exists in the old BPV, and the field still exists in the new BPV but with a different definition.

→ The field must be overridden in the `target_artifact` to match the new definition because the copied value won’t be valid.

##### Example: changed `field2` from a `text` to a `list of text`

Error when applying the migration:

> Error executing migration mp.mig1: The migrated artifact generated by the migration is not valid. Field field2 is a list. , caused by: ValidationException: Field field2 is a list.

Possible solution in migration script:
    
    
    # Wrap the existing value to become the first element of the list
    fields['field2'] = [fields['field2']]
    

#### Case 3

The field exists in the previous BPV, and the field is removed in the new BPV.

→ The field must be removed from `target_artifact`

##### Example: removed `field3` in the target bpv

Error when applying the migration:

> Error executing migration mp.mig1: The migrated artifact generated by the migration is not valid. Some fields of Artifact were not found in its blueprint version reference. Field names: field3, caused by: ValidationException: Some fields of Artifact were not found in its blueprint version reference. Field names: field3

Possible solution in migration script:
    
    
    # Remove the field safely (does nothing if the field doesn't exist)
    fields.pop('field3', None)
    

#### Case 4

The field does not exist in the previous BPV, and the field is created in the new BPV.

→ The field can/must (depending on the mandatory checkbox) be set in the target_artifact.

##### Example: added a mandatory text `field4` in the target BPV

Error when applying the migration:

> Error executing migration mp.mig1: The migrated artifact generated by the migration is not valid. Field ID ‘field4’ is required, caused by: ValidationException: Field ID ‘field4’ is required`

Possible solution in migration script:
    
    
    # Value the new field with a static value
    fields['field4'] = 'new value'
    

#### To sum up:

For the migration to be successful, all the fields must be correctly handled according to one of the cases 1, 2, 3 or 4.

## Managing workflow steps

To change the current step:
    
    
    # Change the current step to be 'new_step'
    target_artifact.json.get("status", {})["stepId"] = "new_step"
    

## TLDR

Here is a short list of potential manipulations.

Action | Code  
---|---  
Define a default value for a new field | `fields["new_field"] = "value"`  
Remove values from a deleted field | `fields.pop("old_field", None)`  
Move the data from one field to another | `fields["new_field"] = fields["old_field"]`  
Change the current workflow step | `target_artifact.json.get("status", {})["stepId"] = "new_step"`  
  
If you want a new field to appear empty in the target blueprint, you don’t need to define anything in the blueprint migration script. There are no values to migrate.

---

## [concepts-and-examples/govern/govern-advanced/govern-admin-blueprint-designer/govern-blueprints-blueprint-versions]

# View blueprints and blueprint versions  
  
Blueprint versions are templates describing the items in Dataiku Govern. Several blueprint versions are gathered within the same blueprint that represents a logical concept.

## List all blueprints
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # List the blueprints for which the API key has access
    client.list_blueprints()
    

## Reference API doc

[`dataikuapi.govern.blueprint.GovernBlueprintListItem`](<../../../../api-reference/python/govern.html#dataikuapi.govern.blueprint.GovernBlueprintListItem> "dataikuapi.govern.blueprint.GovernBlueprintListItem")(...) | An item in a list of blueprints.  
---|---  
[`dataikuapi.govern.blueprint.GovernBlueprint`](<../../../../api-reference/python/govern.html#dataikuapi.govern.blueprint.GovernBlueprint> "dataikuapi.govern.blueprint.GovernBlueprint")(...) | A handle to read a blueprint on the Govern instance.  
[`dataikuapi.govern.blueprint.GovernBlueprintDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.blueprint.GovernBlueprintDefinition> "dataikuapi.govern.blueprint.GovernBlueprintDefinition")(...) | The definition of a blueprint.  
[`dataikuapi.govern.blueprint.GovernBlueprintVersionListItem`](<../../../../api-reference/python/govern.html#dataikuapi.govern.blueprint.GovernBlueprintVersionListItem> "dataikuapi.govern.blueprint.GovernBlueprintVersionListItem")(...) | An item in a list of blueprint versions.  
[`dataikuapi.govern.blueprint.GovernBlueprintVersion`](<../../../../api-reference/python/govern.html#dataikuapi.govern.blueprint.GovernBlueprintVersion> "dataikuapi.govern.blueprint.GovernBlueprintVersion")(...) | A handle to interact with a blueprint version on the Govern instance.  
[`dataikuapi.govern.blueprint.GovernBlueprintVersionTrace`](<../../../../api-reference/python/govern.html#dataikuapi.govern.blueprint.GovernBlueprintVersionTrace> "dataikuapi.govern.blueprint.GovernBlueprintVersionTrace")(...) | The trace of a blueprint version containing information about its lineage and its status.  
[`dataikuapi.govern.blueprint.GovernBlueprintVersionDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.blueprint.GovernBlueprintVersionDefinition> "dataikuapi.govern.blueprint.GovernBlueprintVersionDefinition")(...) | The definition of a blueprint version.

---

## [concepts-and-examples/govern/govern-advanced/govern-admin-blueprint-designer/govern-fork-blueprint-version]

# Fork a Govern project blueprint version  
  
You can fork or create a new blueprint version from an existing blueprint version using the following Python code.

## Fork the blueprint version
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # get the blueprint designer
    blueprint_designer = client.get_blueprint_designer()
    
    # get the provided govern_project blueprint
    govern_project_bp = blueprint_designer.get_blueprint('bp.system.govern_project')
    
    # fork a blueprint version
    govern_project_new_version = govern_project_bp.create_version('my_new_version', name='My New Version', origin_version_id='bv.system.default')
    
    # add a field and save version
    new_ver_def = govern_project_new_version.get_definition()
    new_ver_def.get_raw()['fieldDefinitions']['new_field'] = {
      "description": "my new beautiful text field",
      "fieldType": "TEXT",
      "label": "my new field",
      "required": False,
      "sourceType": "STORE"
    }
    new_ver_def.save()

---

## [concepts-and-examples/govern/govern-advanced/govern-admin-blueprint-designer/index]

# Govern Blueprint Designer

The Blueprint Designer is used to edit and customize blueprints and blueprint versions.

See also

Visit [Build Custom Governance templates](<https://doc.dataiku.com/dss/latest/governance/blueprint-designer/index.html> "\(in Dataiku DSS v14\)") in the product documentation for more detailed background information.

## Examples

## Reference documentation

[`dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintDesigner`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintDesigner> "dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintDesigner")(client) | Handle to interact with the blueprint designer Do not create this directly, use [`get_blueprint_designer()`](<../../../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient.get_blueprint_designer> "dataikuapi.govern_client.GovernClient.get_blueprint_designer")  
---|---  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintListItem`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintListItem> "dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintListItem")(...) | An item in a list of blueprints.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprint`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprint> "dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprint")(...) | A handle to interact with a blueprint as an admin on the Govern instance.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintDefinition> "dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintDefinition")(...) | The definition of a blueprint.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionListItem`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionListItem> "dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionListItem")(...) | An item in a list of blueprint versions.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersion`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersion> "dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersion")(...) | A handle to interact with a blueprint version.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionDefinition> "dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionDefinition")(...) | The blueprint version definition.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionTrace`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionTrace> "dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionTrace")(...) | The trace of a blueprint version containing information about its lineage and its status.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfigurationListItem`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfigurationListItem> "dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfigurationListItem")(...) | An item in a list of sign-off configurations.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfiguration`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfiguration> "dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfiguration")(...) | A handle to interact with the sign-off configuration of a specific step of a workflow.  
[`dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfigurationDefinition`](<../../../../api-reference/python/govern.html#dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfigurationDefinition> "dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfigurationDefinition")(...) | The definition of sign-off configuration.

---

## [concepts-and-examples/govern/govern-advanced/govern-custom-pages-handler]

# Govern Custom Pages Handler  
  
Admins can manage custom pages.

## Retrieve the definition of a custom page
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # retrieve the custom pages handler
    custom_pages_handler = client.get_custom_pages_handler()
    
    # get a custom page by its ID
    custom_page = custom_pages_handler.get_custom_page('cp.cust_page_1')
    
    # get its definition
    custom_page_def = custom_page.get_definition()
    
    # print its definition
    print(custom_page_def.get_raw())
    
    # retrieve custom pages order
    order = custom_pages_handler.get_order()
    
    # update custom pages order
    order = custom_pages_handler.save_order(["cp.id1", "cp.id2"])
    

## Reference documentation

[`dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPagesHandler`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPagesHandler> "dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPagesHandler")(client) | Handle to edit the custom pages Do not create this directly, use [`get_custom_pages_handler()`](<../../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient.get_custom_pages_handler> "dataikuapi.govern_client.GovernClient.get_custom_pages_handler")  
---|---  
[`dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPageListItem`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPageListItem> "dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPageListItem")(...) | An item in a list of custom pages.  
[`dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPage`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPage> "dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPage")(...) | A handle to interact with a custom page as an administrator.  
[`dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPageDefinition`](<../../../api-reference/python/govern.html#dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPageDefinition> "dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPageDefinition")(...) | The definition of a custom page.

---

## [concepts-and-examples/govern/govern-advanced/govern-custom-pages]

# Govern Custom Pages

Custom pages are pages that you can create and configure, and that will appear as new entries in the Govern top navigation bar.

## Retrieve the custom pages
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # list custom pages
    custom_pages = client.list_custom_pages()
    

## Reference documentation

[`dataikuapi.govern.custom_page.GovernCustomPageListItem`](<../../../api-reference/python/govern.html#dataikuapi.govern.custom_page.GovernCustomPageListItem> "dataikuapi.govern.custom_page.GovernCustomPageListItem")(...) | An item in a list of custom pages.  
---|---  
[`dataikuapi.govern.custom_page.GovernCustomPage`](<../../../api-reference/python/govern.html#dataikuapi.govern.custom_page.GovernCustomPage> "dataikuapi.govern.custom_page.GovernCustomPage")(...) | A handle to interact with a custom page.  
[`dataikuapi.govern.custom_page.GovernCustomPageDefinition`](<../../../api-reference/python/govern.html#dataikuapi.govern.custom_page.GovernCustomPageDefinition> "dataikuapi.govern.custom_page.GovernCustomPageDefinition")(...) | The definition of a custom page.

---

## [concepts-and-examples/govern/govern-advanced/govern-hooks]

# Automate actions with Govern Hooks  
  
Hooks are used to automate actions related to artifacts in Dataiku Govern. They are written in Python and run during specified artifact lifecycle phases, including:

  * CREATE

  * UPDATE

  * DELETE




Here, we provide some use cases that demonstrate how to use hooks.

## Automatically set the first workflow step to ‘ONGOING’

This hook will put the first visible step of the artifact workflow to ‘ONGOING’, during its creation.

The logic implemented here is the following:

  * Retrieve the workflow step definitions.

  * Change the status of the first visible step to ‘ONGOING’.

  * Change the status of all steps before the first visible one to ‘SKIPPED’.



    
    
    import logging
    from govern.core.handler import get_handler
    
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    handler = get_handler()
    
    def set_first_visible_step_ongoing():
    
        if handler.hookPhase != "CREATE":
            return
        new_enriched_artifact = handler.newEnrichedArtifact
        artifact = handler.artifact
    
        if new_enriched_artifact is None or artifact is None:
            return
    
        stepDefinitions = new_enriched_artifact.blueprintVersion.json.get("workflowDefinition", {}).get(
            "stepDefinitions", []
        )
        if len(stepDefinitions) <= 0:
            return
    
        workflow_steps = artifact.json.get("workflow", {}).get("steps", {})
        for definition in stepDefinitions:
            step_id = definition['id']
            if workflow_steps[step_id]['visible']:
                workflow_steps[step_id]['status'] = 'ONGOING'
                logger.info('Workflow step ' + step_id + ' : status set as ONGOING')
                break
            else:
                workflow_steps[step_id]['status'] = 'SKIPPED'
                logger.info('Workflow step ' + step_id + ' : status set as SKIPPED')
        return
    
    
    # Set the first visible step of the workflow as ONGOING:
    set_first_visible_step_ongoing()
    

## Make a field mandatory for a workflow step

By default, no fields in Dataiku Govern are mandatory for completing a workflow step. However, there might be a case where you want to check if a field is populated before a workflow step is marked as finished.

In this situation, hooks can be used to define and automatically check this condition.

Note

In the sample hook below, the fields that are mandatory only for setting a workflow step as finished should not be set as “Required” in the field configuration.
    
    
    from govern.core.handler import get_handler
    
    def check_mandatory_step_fields(hookHandler, step_mandatory_field_ids):
    
        def get_ongoing_step_id(newEnrichedArtifact):
            workflow_steps = newEnrichedArtifact.artifact.json.get('workflow', {}).get('steps', {})
            for step in newEnrichedArtifact.blueprintVersion.json.get('workflowDefinition', {}).get('stepDefinitions', []):
                workflow_step = workflow_steps.get(step['id'], {})
                if workflow_step.get('status', 'NOT_STARTED') == 'ONGOING':
                    return step['id']
            return None
    
        def get_step_index(step_definitions, step_id):
            for i, v in enumerate(step_definitions):
                if v.get('id', None) == step_id:
                    return i
    
        def field_ids_from_view_component(view_component):
            if view_component is None:
                return []
            field_id = view_component.get('fieldId', '')
            if len(field_id) > 0:
                return [field_id]
            if view_component.get('type', '') == 'container':
                layout = view_component.get('layout', None)
                if layout is not None:
                    if layout.get('type', '') == 'sequential':
                        ret = []
                        for vc in layout.get('viewComponents', []):
                            ret = ret + field_ids_from_view_component(vc)
                        return ret
            return []
    
        def field_ids_from_step_id(nea, step_id):
            uiStepDefinition = nea.blueprintVersion.json.get('uiDefinition', {}).get('uiStepDefinitions', {}).get(step_id, None)
            if uiStepDefinition is None:
                return []
            view_id = uiStepDefinition.get('viewId', '')
            if len(view_id) <= 0:
                return []
            view = nea.blueprintVersion.json.get('uiDefinition', {}).get('views', {}).get(view_id, {})
            # if view is None or view.get('type', '') != 'card':  # Before 13.3.0
            if view is None:  # After 13.3.0
                return []
            return field_ids_from_view_component(view.get('viewComponent', None))
    
        # 2/ Then it retrieves all the associated fields by looking at the configuration of the view associated with the workflow step:
        def check_step(nea, step_id, mandatory_fields):
            field_ids = field_ids_from_step_id(nea, step_id)
            # 3/ Finally, looping through the fields attached to the workflow step, it checks the ones defined as mandatory for this step and raises an error if those fields are not set:
            for field_id in field_ids:
                if field_id in mandatory_fields:
                    field_value = nea.artifact.fields.get(field_id, None)
                    if field_value is None or (isinstance(field_value, str) and len(field_value) == 0) or (isinstance(field_value, list) and len(field_value) == 0):
                        handler.fieldMessages[field_id] = "field is mandatory in step id: " + step_id
                        handler.status = "ERROR"
    
        # 1/ This hook first aims to detect that the user is trying to set a specific workflow step as finished and retrieve the corresponding step id:
        if hookHandler.hookPhase == 'DELETE':
            return
        nea = hookHandler.newEnrichedArtifact
        if nea is None:
            return
    
        stepDefinitions = nea.blueprintVersion.json.get('workflowDefinition', {}).get('stepDefinitions', [])
        if len(stepDefinitions) <= 0:
            return
    
        # step_id = nea.artifact.json.get('status', {}).get('stepId', '') #  Before 13.5.0
        step_id = get_ongoing_step_id(nea)  # After 13.5.0
        if step_id is None:
            return
    
        step_index = get_step_index(stepDefinitions, step_id)
    
        for i in range(0, step_index):
            previous_step_id = stepDefinitions[i].get('id', '')
            if not previous_step_id in step_mandatory_field_ids:
                continue
            check_step(nea, previous_step_id, step_mandatory_field_ids[previous_step_id])
    
    handler = get_handler()
    
    # 4/ The way to attach fields to a workflow step is as follows:
    check_mandatory_step_fields(
        handler,
        {
            # Each step and corresponding fields are identified by their ids.
            # You can add as many mandatory fields for any workflow step as you wish.
            "exploration": ["mandatory_exploration"],
            "qualification": ["mandatory_qualification", "mandatory_qualification_2"],
            "progress": ["mandatory_ref_progress"]
        }
    )
    

## Automatically assign sign-off final approvers for a bundle

This hook should be added to the Govern Bundle hooks list, and should run on “UPDATE”. As it cannot run on “CREATE” phase (as the link to the Dataiku Bundle won’t be set yet), it can be backed up by another hook to trigger a “post-create” run (see below in this doc). Please note it requires to fork the Govern Bundle template to modify the template / blueprint version, and this behaviour will work only for Govern Bundle using this forked template. This hook requires the forked bundle to have a new field called “approvers”, which is a list of users.

The logic implemented here is the following:

  * the list of potential final approvers of the bundle is defined by the list of the project contributors in DSS

  * we don’t want the bundle creator to be able to approve their own bundle, so the bundle creator is removed from this list

  * the field “approvers” is filled with that list, and can be used to configure the sign-off final-approval permission rule




Note

To get the contributors from DSS, the hook needs to have access to the DSS API key, see the “CONFIGURATION” section in the script below that needs to be changed. The users logins should match between DSS and Govern as the matching is done on the login only.
    
    
    from govern.core.handler import get_handler
    import dataikuapi
    from dataikuapi.govern.artifact_search import GovernArtifactSearchQuery, GovernArtifactFilterBlueprints
    import logging
    import json
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    ### CONFIGURATION TO CHANGE
    DSS_URL = 'http://localhost:8086'
    DSS_API_KEY = 'dkuaps-XXXXX'
    ### /CONFIGURATION
    
    handler = get_handler()
    govern_bundle = handler.artifact
    
    def assign_contributors_as_approvers():
        dataiku_bundle_artifact_ids = govern_bundle.fields.get("dataiku_item", [])
    
        if not isinstance(dataiku_bundle_artifact_ids, list) or len(dataiku_bundle_artifact_ids) == 0:
            # we can't do anything, the govern bundle is not linked to a dataiku bundle (can happen if the dataiku bundle has been removed)
            return
    
        dataiku_bundle_artifact_id = dataiku_bundle_artifact_ids[0]
        dataiku_bundle_artifact = handler.client.get_artifact(dataiku_bundle_artifact_id)
        raw_artifact_bundle = dataiku_bundle_artifact.get_definition().get_raw()
        project_key = raw_artifact_bundle.get('fields', {}).get('project_key')
        created_by = raw_artifact_bundle.get('fields', {}).get('createdBy')
    
        # fetch the contributors from dataiku
        dss_client = dataikuapi.DSSClient(DSS_URL, DSS_API_KEY)
        # to turn off the SSL certificate check (for versions >v13.3.2)
        # dss_client = dataikuapi.DSSClient(DSS_URL, DSS_API_KEY, no_check_certificate=True)
        timeline = dss_client.get_project(project_key).get_timeline(item_count=0)
        contributors = timeline.get('allContributors')
        logger.info('found contributors for project ' + project_key + ': ' + json.dumps(contributors))
    
        # make the list of potential approvers
        potential_approvers = set([contributor.get('login') for contributor in contributors])
        potential_approvers.remove(created_by)
    
        all_users = get_existing_users_logins()
        all_users_logins = set(all_users.keys())
    
        # remove unexisting users (that exist in Dataiku but not in Govern) so the role assignment rule doesn't fail on that
        approvers_logins = potential_approvers.intersection(all_users_logins)
    
        # transform list of logins to list of user artifact ids
        approvers_artifact_ids = [all_users[approver_login] for approver_login in approvers_logins]
        logger.info('removing creator "' + created_by + '" and unexisting users, the list of approvers for ' + project_key + ' is: ' + str(approvers_logins) + ', mapped to artifacts: ' + str(approvers_artifact_ids))
    
        # update 'approvers' field with the computed list
        govern_bundle.fields['approvers'] = approvers_artifact_ids
    
    
    def get_existing_users_logins():
        request = handler.client.new_artifact_search_request(GovernArtifactSearchQuery(artifact_filters=[
            GovernArtifactFilterBlueprints(blueprint_ids=['bp.system.user'])
        ]))
    
        all_users = {}
        next_batch = True
        while next_batch:
            response = request.fetch_next_batch(page_size=1000).get_raw()
            next_batch = response.get('hasNextPage', False)
    
            for uiArtifact in response.get("uiArtifacts", []):
                if uiArtifact.get("uiArtifactDetails", {}).get("user") is not None:
                    all_users[uiArtifact["uiArtifactDetails"]["user"]["login"]] = uiArtifact['artifact']['id']
    
        return all_users
    
    # don't want to fail the artifact save if something goes wrong (e.g Dataiku not available)
    try:
        if handler.hookPhase == 'UPDATE' and govern_bundle.json.get('status', {}).get('stepId', '') == 'review':
            assign_contributors_as_approvers()
    except:
        logger.exception("Can't assign contributors")
    

## Trigger a post-create update hook

As some hooks don’t have all the information needed on create, it’s possible to workaround the issue by calling an update just after the creation has been commited.

The logic implemented here is the following:

  * Create a thread with a max lifetime

  * Try to fetch the just-created artifact from the API. If it’s found, it means that the creation transaction has been committed / completed successfully and we can move to the next step. If the artifact is not found, this step is repeated while the lifetime of the thread is not reached.

  * Run a save from the API on the just-created artifact so it runs the update phase hooks




Note

To trigger the update in Govern, the hook needs to have access to a persistent GOVERN API key (the one given by default to the hook is revoked after hook completion), see the “CONFIGURATION” section in the script below that needs to be changed.
    
    
    from govern.core.handler import get_handler
    import dataikuapi
    import time
    import threading
    import logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    ### CONFIGURATION TO CHANGE
    WATCHDOG_TIMEOUT_MAX_FOR_POST_CREATE = 10 # seconds
    MY_GOVERN_ADMIN_API_KEY = "dkuaps-XXXXX"
    ####### /CONFIG
    
    def post_create(host, api_key, wd_to, ar_id):
        time.sleep(1) # start by sleeping a bit to let the create transaction finish
        time_started = time.time()
        thread_client = dataikuapi.GovernClient(host, api_key)
        while True:
            if time.time() > time_started + wd_to:
                # watchdog return anytime it waited for too long (default 10sec)
                logger.info("watchdog: Ending post-create thread")
                return
            try:
                ar_def = thread_client.get_artifact(ar_id).get_definition()
                # in this example, this "post create hook" is a bit specific to updating the final approvers, but this line can be removed or adapted
                # won't run the update hook if we don't have the needed information for it to run correctly
                if isinstance(ar_def.get_raw()['fields'].get('dataiku_item', []), list) and len(ar_def.get_raw()['fields'].get('dataiku_item', [])) > 0:
                    ar_def.save() # run the save hook on the govern bundle without any changes to trigger the actual logic code
                    return # only need to run it once
            except:
                # logger.exception("Failed attempt to post-create") # useful to debug
                pass # if the get fails, do not nothing and keep trying
            time.sleep(1) # sleep to make sure the thread breaths
    
    handler = get_handler()
    hookPhase = handler.hookPhase
    
    if hookPhase == 'CREATE':
        my_govern_host = handler.client.host
        govern_bundle_artifact_id = handler.artifact.json.get('id', '')
        t1 = threading.Thread(target=post_create, args=(my_govern_host, MY_GOVERN_ADMIN_API_KEY, WATCHDOG_TIMEOUT_MAX_FOR_POST_CREATE, govern_bundle_artifact_id))
        t1.start()

---

## [concepts-and-examples/govern/govern-advanced/govern-policies-with-script]

# Scripts for Governance Policies

When using **scripts** to define governance policies, you write the logic in a single Python script that is executed for all item types where the governance mode is set to “**Use script** ”. This includes:

  * Projects

  * Bundles

  * Models

  * Model versions




See also

For the complete list of supported item types and a detailed explanation of their behavior, please see [Types of Govern items](<https://doc.dataiku.com/dss/latest/governance/types-govern-items.html> "\(in Dataiku DSS v14\)").

The script’s output is communicated via the `handler.script_output` object, which determines whether the item should be governed, hidden, or left untouched, along with any related configuration. This enables automated and policy-driven governance workflows across your platform.

This page describes how to populate `handler.script_output` for various governance scenarios. In the code examples below, the term _artifact_ can be found as the technical name for items.

## Accessing Artifact Metadata

Since governance behavior may differ across artifact types, it is essential to identify and handle the current artifact type accordingly.

You can access metadata about the artifact currently being processed via the `handler.enrichedArtifact` object. The most commonly used attributes include:
    
    
    # Get the artifact type by its blueprint ID
    artifact_type = handler.enrichedArtifact.blueprint.id  # e.g. "bp.system.dataiku_project"
    
    # Get the unique ID of the artifact
    artifact_id = handler.enrichedArtifact.artifact.id  # e.g. "ar.123"
    
    # Get a dictionary of metadata fields attached to the artifact
    fields = handler.enrichedArtifact.artifact.fields  # e.g. {"tags": ["test"], "governed_by": "ar.1337"}
    
    # Get the node id of the artifact
    node_id = handler.enrichedArtifact.artifact.fields.get("node_id")  # e.g. "dss_node"
    

These properties allow you to selectively apply logic depending on the artifact’s type or attributes.

## Governance Actions

### Governing Artifacts

Artifacts can be governed automatically or as a suggested action when managing the artifact manually.

When governing, you typically associate the artifact with a **blueprint version**.

#### Automatically govern an artifact

The artifact will be governed without user input using the provided blueprint.
    
    
    handler.script_output.action = "GOVERN"
    handler.script_output.blueprintVersionId = {"blueprintId": "bp.system.govern_project", "versionId": "bv.system.default"}
    handler.script_output.status = "AUTO"
    

**Prefilling Artifact Fields**

When an artifact is being governed, you can prefill metadata fields to help users later on.

This is useful for providing default values for example.
    
    
    handler.script_output.artifactPrefill.fields["fieldId"] = "myNewValue"
    

#### Suggest governing an artifact

The artifact governance is proposed to the user when managing the artifact manually.
    
    
    handler.script_output.action = "GOVERN"
    handler.script_output.blueprintVersionId = {"blueprintId": "bp.system.govern_project", "versionId": "bv.system.default"}
    handler.script_output.status = "SUGGESTED"
    

#### Governing projects with linked artifacts

When governing **projects** , you have additional options to associate them with existing govern projects or link them to business initiatives.

Note

These fields are available both in `AUTO` and `SUGGESTED` modes of governing

**Associate with an existing governed project**

If you want to govern two projects (e.g. synced from different nodes) with the same govern project, you can associate the second project to the existing govern artifact instead of creating a new one.
    
    
    handler.script_output.action = "GOVERN"
    handler.script_output.status = "AUTO"
    handler.script_output.projectExistingArtifactId = "ar.1337"
    

**Link to a business initiative**

If you want to create a **new governed project** , you can link it to a business initiative artifact of your choice based on the context of the project being governed.
    
    
    handler.script_output.action = "GOVERN"
    handler.script_output.blueprintVersionId = {"blueprintId": "bp.system.govern_project", "versionId": "bv.system.default"}
    handler.script_output.status = "AUTO"
    handler.script_output.projectBusinessInitiativeArtifactId = "ar.1337"
    

### Hiding Artifacts

Artifacts can be hidden either automatically or as a suggested action when managing the artifact manually.

**Automatically hide an artifact**

Use this to immediately hide an artifact without user interaction.
    
    
    handler.script_output.action = "HIDE"
    handler.script_output.status = "AUTO"
    

**Suggest hiding an artifact**

Use this to propose hiding the artifact, but allow the user to override the suggestion.
    
    
    handler.script_output.action = "HIDE"
    handler.script_output.status = "SUGGESTED"
    

### Customizing Child Artifact Behavior

Some artifact types, such as projects and models, have nested artifact (e.g., bundles, models, model versions). You can control governance or visibility on these child elements independently using the `childrenConfiguration` field.

Note

  * This field is available in all the types of actions (`DO_NOTHING`, `HIDE`, `GOVERN`)

  * This field is available both in `AUTO` and `SUGGESTED` statuses




**Custom child configuration for a project**

In this example, the script does nothing with bundles, governs the models automatically with the specified blueprint version, and suggests hiding model versions.
    
    
    handler.script_output.action = "GOVERN"
    handler.script_output.blueprintVersionId = {"blueprintId": "bp.system.govern_project", "versionId": "bv.system.default"}
    handler.script_output.status = "AUTO"
    handler.script_output.childrenConfiguration = {
        "bundlesConfig": {
            "action": "DO_NOTHING",
        },
        "modelsConfig":  {
            "action": "GOVERN",
            "status": "AUTO",
            "blueprintVersionId": {"blueprintId": "bp.system.govern_model", "versionId": "bv.system.default"}
        },
        "modelVersionsConfig": {
            "action": "HIDE",
            "status": "SUGGESTED"
        },
    }
    

**Custom child configuration for a model**

Here, only model versions are configured, and the script suggests hiding them.
    
    
    handler.script_output.action = "GOVERN"
    handler.script_output.blueprintVersionId = {"blueprintId": "bp.system.govern_model", "versionId": "bv.system.default"}
    handler.script_output.status = "AUTO"
    handler.script_output.childrenConfiguration = {
        "modelVersionsConfig": {
            "action": "HIDE",
            "status": "SUGGESTED"
        },
    }
    

## Advanced Example

### Example 1: Conditional Hiding and Governance

This script applies governance logic based on artifact type and metadata:

  * Projects:
    
    * Automatically hidden if they include the tag: “test”.

    * Otherwise ignored.

  * Bundles:
    
    * If linked to a governed project rated as “High” risk, governance is suggested using the system default blueprint.

    * Otherwise ignored.

  * All other artifacts:
    
    * Explicitly ignored.




**Behavior Summary**

Artifact Type | Condition | Action  
---|---|---  
Project | Contains tag “test” | Automatically hide  
Project | Does _not_ contain “test” | Do nothing  
Bundle | Associated project has “High” risk rating | Suggest governance  
Bundle | Any other case | Do nothing  
Other artifact types | — | Do nothing  
  
Note

  * This example uses the system default blueprint (`bv.system.default`) for bundle governance.

  * The script uses `handler.client` to look up associated project and governance metadata.




**Code**

You can find below the script implementation:
    
    
    from govern.core.autogovernance_handler import get_autogovernance_handler
    
    handler = get_autogovernance_handler()
    
    def handle_project():
        fields = handler.enrichedArtifact.artifact.fields
        tags = fields.get("tags", [])
    
        if "test" in tags:
            handler.script_output.action = "HIDE"
            handler.script_output.status = "AUTO"
        else:
            handler.script_output.action = "DO_NOTHING"
    
    def handle_bundle():
        artifact = handler.enrichedArtifact.artifact
        dku_project_id = artifact.fields.get("dataiku_project")
    
        if dku_project_id is None:
            handler.script_output.action = "DO_NOTHING"
            return None
    
        dku_project_json = (
            handler.client.get_artifact(dku_project_id)
            .get_definition()
            .get_raw()
        )
    
        govern_project_id = dku_project_json.get("fields", {}).get("governed_by")
    
        if govern_project_id is None:
            handler.script_output.action = "DO_NOTHING"
            return None
    
        govern_project_json = (
            handler.client.get_artifact(govern_project_id)
            .get_definition()
            .get_raw()
        )
    
        risk_rating = govern_project_json.get("fields", {}).get("qualification_risk_rating")
    
        if risk_rating == "High":
            handler.script_output.action = "GOVERN"
            handler.script_output.blueprintVersionId = {"blueprintId": "bp.system.govern_bundle", "versionId": "bv.system.default"}
            handler.script_output.status = "SUGGESTED"
        else:
            handler.script_output.action = "DO_NOTHING"
    
    if handler.enrichedArtifact.blueprint.id == "bp.system.dataiku_project":
        handle_project()
    elif handler.enrichedArtifact.blueprint.id == "bp.system.dataiku_bundle":
        handle_bundle()
    else:
        handler.script_output.action = "DO_NOTHING"

---

## [concepts-and-examples/govern/govern-advanced/index]

# Advanced Govern  
  
These features are only available with the Advanced Govern add-on.

---

## [concepts-and-examples/govern/govern-artifacts/govern-artifact-search]

# Govern Artifact Search

The artifact search handler is used to search among artifacts.

## Search for all the Govern Project artifacts
    
    
    import dataikuapi
    from dataikuapi.govern.artifact_search import GovernArtifactSearchQuery, GovernArtifactFilterBlueprints
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # build a query
    govern_projects_query = GovernArtifactSearchQuery(artifact_filters=[GovernArtifactFilterBlueprints(blueprint_ids=['bp.system.govern_project'])])
    
    # build a request
    request = client.new_artifact_search_request(govern_projects_query)
    
    # perform the search (first batch)
    result_1 = request.fetch_next_batch()
    
    # continue the search (next batch)...
    result_2 = request.fetch_next_batch()
    

## Reference documentation

[`dataikuapi.govern.artifact_search.GovernArtifactSearchRequest`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchRequest> "dataikuapi.govern.artifact_search.GovernArtifactSearchRequest")(...) | A search request object.  
---|---  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchResponse`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchResponse> "dataikuapi.govern.artifact_search.GovernArtifactSearchResponse")(...) | A search request response for a single batch.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchResponseHit`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchResponseHit> "dataikuapi.govern.artifact_search.GovernArtifactSearchResponseHit")(...) | A search request response.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchQuery`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchQuery> "dataikuapi.govern.artifact_search.GovernArtifactSearchQuery")([...]) | A definition of an artifact query.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchSource`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchSource> "dataikuapi.govern.artifact_search.GovernArtifactSearchSource")(...) | An abstract class to represent the different search source.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchSourceAll`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchSourceAll> "dataikuapi.govern.artifact_search.GovernArtifactSearchSourceAll")() | A generic search source definition.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchSort`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchSort> "dataikuapi.govern.artifact_search.GovernArtifactSearchSort")(...) | An abstract class to represent the different search sort.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchSortName`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchSortName> "dataikuapi.govern.artifact_search.GovernArtifactSearchSortName")([...]) | An artifact sort definition based on their names.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchSortWorkflow`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchSortWorkflow> "dataikuapi.govern.artifact_search.GovernArtifactSearchSortWorkflow")([...]) | An artifact sort defintion based on their workflow.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchSortField`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchSortField> "dataikuapi.govern.artifact_search.GovernArtifactSearchSortField")([...]) | An artifact sort definition based on a list of fields.  
[`dataikuapi.govern.artifact_search.GovernArtifactSearchSortFieldDefinition`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactSearchSortFieldDefinition> "dataikuapi.govern.artifact_search.GovernArtifactSearchSortFieldDefinition")(...) | A field sort definition builder to use in a search query in order to sort on a field of a blueprint.  
[`dataikuapi.govern.artifact_search.GovernArtifactFilter`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactFilter> "dataikuapi.govern.artifact_search.GovernArtifactFilter")(...) | An abstract class to represent artifact filters.  
[`dataikuapi.govern.artifact_search.GovernArtifactFilterBlueprints`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactFilterBlueprints> "dataikuapi.govern.artifact_search.GovernArtifactFilterBlueprints")([...]) | An artifact filter definition based on a list of specific blueprints.  
[`dataikuapi.govern.artifact_search.GovernArtifactFilterBlueprintVersions`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactFilterBlueprintVersions> "dataikuapi.govern.artifact_search.GovernArtifactFilterBlueprintVersions")([...]) | An artifact filter definition based on a list of specific blueprint versions.  
[`dataikuapi.govern.artifact_search.GovernArtifactFilterArtifacts`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactFilterArtifacts> "dataikuapi.govern.artifact_search.GovernArtifactFilterArtifacts")([...]) | An artifact filter definition based on a list of specific artifacts.  
[`dataikuapi.govern.artifact_search.GovernArtifactFilterFieldValue`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactFilterFieldValue> "dataikuapi.govern.artifact_search.GovernArtifactFilterFieldValue")(...) | An artifact filter definition based on specific fields value.  
[`dataikuapi.govern.artifact_search.GovernArtifactFilterArchivedStatus`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact_search.GovernArtifactFilterArchivedStatus> "dataikuapi.govern.artifact_search.GovernArtifactFilterArchivedStatus")(...) | An artifact filter definition based on the archived status.

---

## [concepts-and-examples/govern/govern-artifacts/govern-artifact-workflow]

# Govern Artifact Workflow  
  
Workflow management has changed in Dataiku Govern 13.5.0 artifact.status.stepId is now deprecated. While it’s still supported in a best-effort way, some behaviors can be not totally supported anymore. Please use artifact.workflow instead.

## New artifact property artifact.workflow structure
    
    
    {
        "workflow": {
            "steps": {
                "development": {
                    "status": "FINISHED",
                    "visible": true
                },
                "review": {
                    "status": "SKIPPED",
                    "visible": false
                },
                "deployment": {
                    "status": "ONGOING",
                    "visible": true
                },
                "production": {
                    "status": "NOT_STARTED",
                    "visible": true
                }
            }
        }
    }
    

Note that since it is a JSON object, these steps are not ordered. If you want to manipulate them in proper order, you must iterate over the blueprintVersion.workflowDefinition.stepDefinitions property.
    
    
    from dataikuapi import GovernClient
    
    govern_client = GovernClient(host, api_key)
    artifact = govern_client.get_artifact('ar.5').get_definition().get_raw()
    blueprint_version = govern_client.get_blueprint(artifact.get('blueprintVersionId').get('blueprintId')).get_version(artifact.get('blueprintVersionId').get('versionId')).get_definition().get_raw()
    for step_definition in blueprint_version.get('workflowDefinition', {}).get('stepDefinitions', []):
        artifact_step = artifact.get('workflow', {}).get('steps', {}).get(step_definition.get('id'), {})
        step_status = artifact_step.get('status')
        step_visibility = artifact_step.get('visible')
        print('Step %s %s is visible : %s' % (step_definition.get('id'), step_status, step_visibility))
    

## Legacy artifact.status.stepId behavior

The artifact.status.stepId will be set according to the artifact.workflow following those priority rules :

>   1. null if no workflow on artifact’s blueprint version
> 
>   2. null if workflow is not started (only not started steps)
> 
>   3. the current ongoing step id if there is one
> 
>   4. the id of the first not started step
> 
>   5. the last finished step id if all steps are finished
> 
> 


If the current ongoing step is not visible anymore, the workflow will not have a visible ongoing step. The artifact.status.stepId will be the next not started visible step id. The only way to actually put the workflow on this step is to use the new artifact.workflow property.

The artifact.status.stepId is now null when creating an artifact, if no artifact.status.stepId or artifact.workflow is provided. If some custom hooks were defined this way, they might not function anymore.

---

## [concepts-and-examples/govern/govern-artifacts/govern-artifacts]

# Govern Artifacts

Artifacts are all items in Dataiku Govern. Note: to learn more about them, go to [AI Governance](<https://doc.dataiku.com/dss/latest/governance/index.html> "\(in Dataiku DSS v14\)").

## List all artifact sign-offs
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # retrieve a specific artifact by its ID
    artifact = client.get_artifact('ar.1773')
    
    # list all its sign-offs
    signoffs = artifact.list_signoffs()
    

## Reference documentation

[`dataikuapi.govern.artifact.GovernArtifact`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifact> "dataikuapi.govern.artifact.GovernArtifact")(...) | A handle to interact with an artifact on the Govern instance.  
---|---  
[`dataikuapi.govern.artifact.GovernArtifactDefinition`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactDefinition> "dataikuapi.govern.artifact.GovernArtifactDefinition")(...) | The definition of an artifact.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffListItem`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffListItem> "dataikuapi.govern.artifact.GovernArtifactSignoffListItem")(...) | An item in a list of sign-offs.  
[`dataikuapi.govern.artifact.GovernArtifactSignoff`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoff> "dataikuapi.govern.artifact.GovernArtifactSignoff")(...) | Handle to interact with the sign-off of a specific workflow step.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffDefinition`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffDefinition> "dataikuapi.govern.artifact.GovernArtifactSignoffDefinition")(...) | The definition of a sign-off.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffRecurrenceConfiguration`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffRecurrenceConfiguration> "dataikuapi.govern.artifact.GovernArtifactSignoffRecurrenceConfiguration")(...) | The recurrence configuration of a sign-off.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffDetails`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffDetails> "dataikuapi.govern.artifact.GovernArtifactSignoffDetails")(...) | The details of a sign-off.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffFeedbackListItem`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffFeedbackListItem> "dataikuapi.govern.artifact.GovernArtifactSignoffFeedbackListItem")(...) | An item in a list of feedback reviews.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffFeedback`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffFeedback> "dataikuapi.govern.artifact.GovernArtifactSignoffFeedback")(...) | Handle to interact with a feedback.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffFeedbackDefinition`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffFeedbackDefinition> "dataikuapi.govern.artifact.GovernArtifactSignoffFeedbackDefinition")(...) | The definition of a feedback review.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffApproval`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffApproval> "dataikuapi.govern.artifact.GovernArtifactSignoffApproval")(...) | Handle to interact with an approval.  
[`dataikuapi.govern.artifact.GovernArtifactSignoffApprovalDefinition`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactSignoffApprovalDefinition> "dataikuapi.govern.artifact.GovernArtifactSignoffApprovalDefinition")(...) | The definition of an approval.

---

## [concepts-and-examples/govern/govern-artifacts/govern-time-series]

# Retrieve time series data from Govern artifacts  
  
## Get values
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # retrieve a specific artifact of type dataiku model version by its ID
    artifact = client.get_artifact('ar.1773')
    
    # get the time series ID from a field
    ts = client.get_time_series(artifact.get_definition().get_raw()['fields']['evaluation_metrics_auc'])
    
    # get the time series values
    values = ts.get_values()
    

## Reference API doc

[`dataikuapi.govern.time_series.GovernTimeSeries`](<../../../api-reference/python/govern.html#dataikuapi.govern.time_series.GovernTimeSeries> "dataikuapi.govern.time_series.GovernTimeSeries")(...) | A handle to interact with a time series.  
---|---

---

## [concepts-and-examples/govern/govern-artifacts/govern-uploaded-files]

# Retrieve files from Govern artifacts  
  
## Download an uploaded file
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # retrieve a specific artifact of type govern project by its ID
    artifact = client.get_artifact('ar.1773')
    
    # get the first uploaded file stored in the related_docs field
    uf = client.get_uploaded_file(artifact.get_definition().get_raw()['fields']['related_docs'][0])
    
    # get the file description
    f_desc = uf.get_description()
    
    # retrieve the file as a stream
    f_stream = uf.download()
    

## Reference API doc

[`dataikuapi.govern.uploaded_file.GovernUploadedFile`](<../../../api-reference/python/govern.html#dataikuapi.govern.uploaded_file.GovernUploadedFile> "dataikuapi.govern.uploaded_file.GovernUploadedFile")(...) | A handle to interact with an uploaded file Do not create this directly, use [`get_uploaded_file()`](<../../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient.get_uploaded_file> "dataikuapi.govern_client.GovernClient.get_uploaded_file")  
---|---

---

## [concepts-and-examples/govern/govern-artifacts/index]

# Artifacts  
  
Artifacts store, organize, and package information into objects in Dataiku Govern.

---

## [concepts-and-examples/govern/govern-client]

# The main GovernClient class

The REST API Python client makes it easy to write client programs for the Dataiku Govern REST API in Python. The REST API Python client is in the `dataikuapi` Python package.

The client is the entrypoint for many of the capabilities listed in this chapter.

## Creating a Govern client

To work with the API, a connection needs to be established with Dataiku Govern, by creating an `GovernClient` object. Once the connection is established, the `GovernClient` object serves as the entry point to the other calls.

To use the Python client from outside Dataiku Govern, simply install it from pip.
    
    
    pip install dataiku-api-client
    

This installs the client in the system-wide Python installation, so if you are not using virtualenv, you may need to replace `pip` by `sudo pip`.

Note that this will always install the latest version of the API client. You might need to request a version compatible with your version of Dataiku Govern.

When connecting from the outside world, you need an API key. See [Public API Keys](<https://doc.dataiku.com/dss/latest/governance/publicapi/keys.html> "\(in Dataiku DSS v14\)") for more information on how to create an API key and the associated privileges.

You also need to connect using the base URL of your Dataiku Govern instance.
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # client is now a GovernClient and can perform all authorized actions.
    # For example, list the blueprints for which the API key has access
    client.list_blueprints()
    

### Disabling SSL certificate check

If your Dataiku Govern has SSL enabled, the package will verify the certificate. In order for this to work, you may need to add the root authority that signed the Govern SSL certificate to your local trust store. Please refer to your OS or Python manual for instructions.

If this is not possible, you can also disable checking the SSL certificate by using `GovernClient(host, apiKey, insecure_tls=True)`

## Reference documentation

[`dataikuapi.govern_client.GovernClient`](<../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient> "dataikuapi.govern_client.GovernClient")(host) | Entry point for the Dataiku Govern API client  
---|---

---

## [concepts-and-examples/govern/govern-deployments/govern-multi-envs]

# Governance checks with multi envs

## Concept

Dataiku Deployer has pre-deployment hooks which can be used to add additional checks when deploying. In this example, we will perform a check prior to deployment that a specific sign-off is properly approved before deployment.

This code example is designed to work with the Project Deployer. It must be written in an infrastructure settings, as a “pre-deployment” hook.

## Code example
    
    
    def execute(requesting_user, deployment_id, deployment_report, deployer_client, automation_client, deploying_user, deployed_project_key, **kwargs):
    
        host = '' # the govern instance host
        apikey = '' # a govern instance admin api key
        pre_prod_signoff_step_id = 'review' # to be changed to the step_id of the step which holds the sign-off to check for approval state
    
        import dataikuapi
        from dataikuapi.govern.artifact_search import GovernArtifactSearchQuery, GovernArtifactFilterArchivedStatus, GovernArtifactFilterBlueprints, GovernArtifactFilterFieldValue
        gc = dataikuapi.GovernClient(host, apikey)
        # gc = dataikuapi.GovernClient(host, apikey, insecure_tls=True) # this line can be be used instead to disable checking the SSL certificate
        deployer_node_id = deployer_client.get_instance_info().node_id
    
        # first get the synced deployment on govern
        results = gc.new_artifact_search_request(GovernArtifactSearchQuery(
            artifact_filters=[
                GovernArtifactFilterArchivedStatus(is_archived=False),
                GovernArtifactFilterBlueprints(blueprint_ids=['bp.system.project_deployer_deployment']),
                GovernArtifactFilterFieldValue(condition_type='EQUALS', condition=deployer_node_id, field_id='node_id', case_sensitive=True),
                GovernArtifactFilterFieldValue(condition_type='EQUALS', condition=deployment_id, field_id='deployment_id', case_sensitive=True),
            ]
        )).fetch_next_batch().get_response_hits()
        if len(results) <= 0:
            return HookResult.error('Deployment is not synced to govern, wait a bit more, or perform a manual full sync of deployer items in the settings.')
        govern_deployment = results[0].to_artifact()
    
        # get the related bundle
        dku_bundle_id = govern_deployment.get_definition().get_raw().get('fields', {}).get('dataiku_bundle', None)
        if dku_bundle_id is None:
            return HookResult.error('Govern deployment has no linked bundle, perform a manual full sync of deployer items in the settings.')
        dku_bundle = gc.get_artifact(dku_bundle_id)
    
        # get the related govern bundle (associated governance layer)
        gov_bundle_id = dku_bundle.get_definition().get_raw().get('fields', {}).get('governed_by', None)
        if gov_bundle_id is None:
            return HookResult.error('Associated bundle is not governed, artifact_id: ' + dku_bundle_id)
    
        # get the associated signoff
        signoff_def = gc.get_artifact(gov_bundle_id).get_signoff(pre_prod_signoff_step_id).get_definition().get_raw()
    
        # perform the signoff status check
        if signoff_def.get('status', None) != 'APPROVED':
            return HookResult.error('Pre-prod sign-off on bundle is not approved: ' + gov_bundle_id + ', stepid: ' + pre_prod_signoff_step_id)
    
        # if all good, return success
        return HookResult.success("Pre-prod sign-off is approved")

---

## [concepts-and-examples/govern/govern-deployments/index]

# Govern Deployments

Concepts and examples related to Govern and Deployments

---

## [concepts-and-examples/govern/govern-helpers/delete-govern-dataiku-items]

# Dataiku and Govern items modifier helpers functions

## Delete all Dataiku artifacts linked to a node id

When changing or decommissioning a **Design** , an **Automation** , or a **Deployer** node you may want to clean up the synced Dataiku Items coming from the old node. Doing this one-by-one in Govern can be tedious if many items are involved. This helper shows how to:

  * programmatically list Dataiku blueprints,

  * search for artifacts linked to a given `node_id`, and

  * (optionally) delete them in bulk.




Warning

This operation **permanently deletes** Govern artifacts. Use `dry_run=True` first to review what would be removed before executing a real deletion.

### Helper function

The function below:

  * discovers **Dataiku** blueprints dynamically via `client.list_blueprints()`,

  * restricts the search to blueprints whose IDs start with `bp.system.dataiku_`,

  * queries artifacts that also match the provided `node_id` (case-sensitive), and

  * either returns the list (`dry_run=True`) or deletes them (`dry_run=False`).



    
    
    import dataikuapi
    from dataikuapi.govern.artifact_search import (
        GovernArtifactSearchQuery,
        GovernArtifactFilterBlueprints,
        GovernArtifactFilterFieldValue,
    )
    
    def delete_dataiku_artifacts_by_node_id(client, node_id, page_size=1000, dry_run=False):
        """
        Delete all Govern artifacts synced from Dataiku (project, dataset, bundles, models, etc.)
        that are linked to the given Dataiku node id.
    
        Parameters
        ----------
        client : dataikuapi.GovernClient
            An authenticated Govern client.
        node_id : str
            The Dataiku node identifier to match (exact, case-sensitive).
        page_size : int
            Pagination size for the search request.
        dry_run : bool
            If True, nothing is deleted and the matching artifact IDs are returned.
    
        Returns
        -------
        list[str]
            List of artifact IDs matched (and deleted if dry_run is False).
        """
    
        # Helper to robustly extract the blueprint id from list items
        def _bp_id(bp):
            raw = bp.get_raw()
            return raw.get("blueprint",{}).get("id")
    
        # Discover Dataiku system blueprints dynamically
        dataiku_bp_ids = []
        blueprints = client.list_blueprints()
        for bp in blueprints:
            raw = bp.get_raw()
            bp_id = raw.get("blueprint", {}).get("id", "")
            if bp_id.startswith("bp.system.dataiku_"):
                dataiku_bp_ids.append(bp_id)
    
    
        if not dataiku_bp_ids:
            print("No Dataiku blueprints found; nothing to do.")
            return []
    
        # Build the artifact search
        query = GovernArtifactSearchQuery(artifact_filters=[
            GovernArtifactFilterBlueprints(blueprint_ids=dataiku_bp_ids),
            GovernArtifactFilterFieldValue(
                "EQUALS", field_id="node_id", condition=node_id, case_sensitive=True
            ),
        ])
        request = client.new_artifact_search_request(query)
    
        # Collect matching artifact ids
        artifact_ids = []
        has_next = True
        while has_next:
            raw = request.fetch_next_batch(page_size=page_size).get_raw()
            has_next = raw.get("hasNextPage", False)
            for ui in raw.get("uiArtifacts", []):
                artifact_ids.append(ui["artifact"]["id"])
    
        print(f"Matched {len(artifact_ids)} artifact(s).")
    
        if dry_run:
            # Only preview; do not delete
            return artifact_ids
    
        # Delete artifacts
        for aid in artifact_ids:
            print(f"Deleting artifact {aid} …")
            client.get_artifact(aid).delete()
    
        print(f"Deleted {len(artifact_ids)} artifact(s).")
        return artifact_ids
    

### Usage examples
    
    
    import os
    import dataikuapi
    
    govern_url = os.environ["GOVERN_URL"]
    govern_token = os.environ["GOVERN_TOKEN"]
    
    client = dataikuapi.GovernClient(host=govern_url, api_key=govern_token)
    
    # Preview what would be deleted
    to_delete = delete_dataiku_artifacts_by_node_id(client, node_id="dss1", dry_run=True)
    print(to_delete)
    
    # Proceed with deletion
    delete_dataiku_artifacts_by_node_id(client, node_id="dss1", dry_run=False)

---

## [concepts-and-examples/govern/govern-helpers/index]

# Govern Helpers

Govern Helpers are functions that helps browsing or editing Govern items more easily.

---

## [concepts-and-examples/govern/govern-helpers/list-govern-dataiku-items]

# Dataiku and Govern items getter helpers functions

## Helpers function definitions

This document presents a set of helper functions for bridging Dataiku items with their Govern counterparts.

### Retrieve a Dataiku Project

Fetches a Dataiku project, using a node ID and project key.
    
    
    def get_dataiku_project_as_artifact(govern_client, node_id, project_key):
        """
        Retrieve the Dataiku project as an artifact from both a node ID and a project Key
    
        :param GovernClient govern_client: a govern client connected via the public API to the govern instance
        :param str node_id: the node ID of the project to look for
        :param str project_key: the project Key of the project to look for
        :return: the dataiku project as an artifact or None if not found
        :rtype: GovernArtifact or None
        """
        from dataikuapi.govern.artifact_search import GovernArtifactSearchQuery, GovernArtifactFilterArchivedStatus, GovernArtifactFilterBlueprints, GovernArtifactFilterFieldValue
        results = govern_client.new_artifact_search_request(GovernArtifactSearchQuery(
            artifact_filters=[
                GovernArtifactFilterArchivedStatus(is_archived=False),
                GovernArtifactFilterBlueprints(blueprint_ids=['bp.system.dataiku_project']),
                GovernArtifactFilterFieldValue(condition_type='EQUALS', condition=node_id, field_id='node_id', case_sensitive=True),
                GovernArtifactFilterFieldValue(condition_type='EQUALS', condition=project_key, field_id='project_key', case_sensitive=True),
            ]
        )).fetch_next_batch().get_response_hits()
        if len(results) == 0:
            return None
        return results[0].to_artifact()
    

### Get the Govern Item of a Dataiku Item

Returns the Govern representation (project, bundle, model, or model version) that corresponds to a given Dataiku item.
    
    
    def get_govern_item_from_dataiku_item(govern_client, dataiku_item):
        """
        Retrieve the Govern item (could be project, bundle, model, model version) corresponding to the Dataiku item
    
        :param GovernClient govern_client: a govern client connected via the public API to the govern instance
        :param GovernArtifact dataiku_item: the Dataiku item as input
        :return: the corresponding Govern item or None if not governed
        :rtype: GovernArtifact or None
        """
        definition = dataiku_item.get_definition()
        gb = definition.get_raw().get('fields', {}).get('governed_by', None)
        if gb is None:
            return None
        return govern_client.get_artifact(gb)
    

### Get Dataiku Items of a Govern Item

Retrieves the list of Dataiku items linked to a given Govern item. This is the reverse mapping, useful for exploring which Dataiku items are associated with a Govern item.
    
    
    def get_dataiku_items_from_govern_item(govern_client, govern_item):
        """
        Retrieve the Dataiku items (could be project, bundle, model, model version) corresponding to the Govern item
    
        :param GovernClient govern_client: a govern client connected via the public API to the govern instance
        :param GovernArtifact govern_item: the Govern item as input
        :return: the list of corresponding Dataiku items (several dataiku projects can be governed by the same govern project, for other item types, there should be at max a single value in the list)
        :rtype: list of GovernArtifact
        """
        definition = govern_item.get_definition()
        dku_items = definition.get_raw().get('fields', {}).get('dataiku_item', [])
        return [govern_client.get_artifact(arid) for arid in dku_items]
    

### Get Artifact from Field Reference

Some artifact fields are **reference fields** : instead of storing data directly, they store one or more **artifact IDs** (e.g., `ar.123`) that point to other items. This helper reads such a field from an artifact and resolves each stored ID into a full `GovernArtifact` by fetching it via the Govern API.
    
    
    def get_reference_list_as_artifacts(govern_client, artifact, field_id):
        """
        Retrieve the referenced items based on field (list of references) of an artifact
    
        :param GovernClient govern_client: a govern client connected via the public API to the govern instance
        :param GovernArtifact artifact: the item as input
        :param str field_id: the field ID of the reference list
        :return: the list of corresponding items
        :rtype: list of GovernArtifact
        """
        definition = artifact.get_definition()
        items = definition.get_raw().get('fields', {}).get(field_id, [])
        return [govern_client.get_artifact(arid) for arid in items]
    

### List Bundles of a Govern Project

Returns all Govern bundles associated with a given Govern project. Internally, it reuses `get_reference_list_as_artifacts()` (Get Artifact from Field Reference) to resolve the bundle links.
    
    
    def get_govern_bundles(govern_client, govern_project):
        """
        Retrieve the list of govern bundles from a govern project
    
        :param GovernClient govern_client: a govern client connected via the public API to the govern instance
        :param GovernArtifact govern_project: the govern project as input
        :return: the list of govern bundles for this project
        :rtype: list of GovernArtifact
        """
        return get_reference_list_as_artifacts(govern_client, govern_project, 'govern_bundles')
    

### List Models of a Govern Project

Returns all Govern models associated with a given Govern project. Internally, it reuses `get_reference_list_as_artifacts()` (Get Artifact from Field Reference) to resolve the model links.
    
    
    def get_govern_models(govern_client, govern_project):
        """
        Retrieve the list of govern models from a govern project
    
        :param GovernClient govern_client: a govern client connected via the public API to the govern instance
        :param GovernArtifact govern_project: the govern project as input
        :return: the list of govern models for this project
        :rtype: list of GovernArtifact
        """
        return get_reference_list_as_artifacts(govern_client, govern_project, 'govern_models')
    

### List Model Versions of a Govern Model

Returns all Govern model versions associated with a given Govern model. Internally, it reuses `get_reference_list_as_artifacts()` (Get Artifact from Field Reference) to resolve the model version links.
    
    
    def get_govern_model_versions(govern_client, govern_model):
        """
        Retrieve the list of govern model versions from a govern model
    
        :param GovernClient govern_client: a govern client connected via the public API to the govern instance
        :param GovernArtifact govern_model: the govern model as input
        :return: the list of govern model versions for this model
        :rtype: list of GovernArtifact
        """
        return get_reference_list_as_artifacts(govern_client, govern_model, 'govern_model_versions')
    

### Retrieve Related Govern Projects from a Dataiku Project

This helper function retrieves all **Govern projects** that correspond to the same underlying Dataiku project across **Design** and **Automation** nodes, and returns a `GovernArtifact` object for each related project.

Internally, it reuses `get_govern_item_from_dataiku_item()` (Get the Govern Item of a Dataiku Item) to resolve the govern item links.
    
    
    def get_related_projects(govern_client, dataiku_project):
        """
        Retrieve the list of related govern projects from a dataiku project
    
        :param govern_client: a govern client connected via the public API to the govern instance
        :type govern_client: GovernClient
        :param dataiku_project: the dataiku project as input
        :type dataiku_project: GovernArtifact
        :return: the list of govern projects for this dataiku project
        :rtype: list[GovernArtifact]
        """
        from dataikuapi.govern.artifact_search import GovernArtifactSearchQuery, GovernArtifactFilterArchivedStatus, GovernArtifactFilterBlueprints, GovernArtifactFilterFieldValue
    
        fields = dataiku_project.get_definition().get_raw().get('fields',{})
        automation_node = fields.get('automation_node')
    
        node_id = None
        project_key = None
        results=[]
    
        if automation_node == True:
            node_id = fields.get('original_node_id')
            project_key = fields.get('original_project_key')
    
            if node_id and project_key:
                hits = govern_client.new_artifact_search_request(GovernArtifactSearchQuery(
                    artifact_filters=[
                        GovernArtifactFilterArchivedStatus(is_archived=False),
                        GovernArtifactFilterBlueprints(blueprint_ids=['bp.system.dataiku_project']),
                        GovernArtifactFilterFieldValue(
                            condition_type='EQUALS',
                            condition=node_id,
                            field_id='node_id',
                            case_sensitive=True
                        ),
                        GovernArtifactFilterFieldValue(
                            condition_type='EQUALS',
                            condition=project_key,
                            field_id='project_key',
                            case_sensitive=True
                        ),
                        GovernArtifactFilterFieldValue(
                            condition_type='EQUALS',
                            condition='true',
                            field_id='automation_node',
                            negate_condition=True,
                            case_sensitive=True
                        )
                    ]
                )).fetch_next_batch().get_response_hits()
                results.extend([hit.to_artifact() for hit in hits])
            else:
                results.append(dataiku_project)
        else:
            node_id = fields.get('node_id')
            project_key = fields.get('project_key')
    
        if node_id and project_key:
            hits = govern_client.new_artifact_search_request(GovernArtifactSearchQuery(
                artifact_filters=[
                    GovernArtifactFilterArchivedStatus(is_archived=False),
                    GovernArtifactFilterBlueprints(blueprint_ids=['bp.system.dataiku_project']),
                    GovernArtifactFilterFieldValue(
                        condition_type='EQUALS',
                        condition=node_id,
                        field_id='original_node_id',
                        case_sensitive=True
                    ),
                    GovernArtifactFilterFieldValue(
                        condition_type='EQUALS',
                        condition=project_key,
                        field_id='original_project_key',
                        case_sensitive=True
                    ),
                    GovernArtifactFilterFieldValue(
                        condition_type='EQUALS',
                        condition='true',
                        field_id='automation_node',
                        negate_condition=False,
                        case_sensitive=True
                    )
                ]
            )).fetch_next_batch().get_response_hits()
            results.extend([hit.to_artifact() for hit in hits])
    
    
        governed_results = [
            get_govern_item_from_dataiku_item(handler.client, item)
            for item in results
        ]
    
        return [r for r in governed_results if r is not None]
    

## Few usages
    
    
    import dataikuapi
    
    host = "http(s)://GOVERN_HOST:GOVERN_PORT"
    apiKey = "Your API key secret"
    client = dataikuapi.GovernClient(host, apiKey)
    
    # search for a specific Dataiku project (could be None if not found)
    dku_project = get_dataiku_project_as_artifact(client, 'design_node_id', 'MY_PROJECT_KEY')
    print(dku_project.get_definition().get_raw())
    
    # get the associated Govern project tied to it
    govern_project = get_govern_item_from_dataiku_item(client, dku_project)
    print(govern_project.get_definition().get_raw())
    
    # get back the Dataiku projects tied to this Govern project
    # the returned value is a list since several dataiku project can be governed by the same govern project
    dataiku_projects = get_dataiku_items_from_govern_item(client, govern_project)
    for dkup in dataiku_projects:
        print(dkup.get_definition().get_raw())
    
    # list the govern bundles from the govern project
    bundles = get_govern_bundles(client, govern_project)
    for bundle in bundles:
        print(bundle.get_definition().get_raw())

---

## [concepts-and-examples/govern/index]

# Dataiku Govern

The Govern node in Dataiku enables AI governance at scale. In this section, learn how to use code, scripts, and the API to accomplish specific governance tasks like artifact management and administration.

See also

For an overview of Dataiku Govern, visit [Introducing Dataiku Govern](<https://knowledge.dataiku.com/latest/govern/overview/concept-govern-in-dataiku-architecture.html>) in the Knowledge Base.

For feature specifications, visit [AI Governance](<https://doc.dataiku.com/dss/latest/governance/index.html> "\(in Dataiku DSS v14\)") in the product documentation.

## Topics

---

## [concepts-and-examples/index]

# Concepts and examples

The **Concepts and examples** section is a catalog of examples showcasing how to programmatically manipulate the different parts of Dataiku. You will find here basic code samples to help you getting started as well as more advanced and specific use-cases.

---

## [concepts-and-examples/jobs]

# Jobs  
  
The API offers methods to retrieve the list of jobs and their status, so that they can be monitored. Additionally, new jobs can be created to build datasets.

## Reading the jobs’ status

The list of all jobs, finished or not, can be fetched with the [`dataikuapi.dss.project.DSSProject.list_jobs()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_jobs> "dataikuapi.dss.project.DSSProject.list_jobs") method. For example, to retrieve job failures posterior to a given date:
    
    
    import dataiku
    import datetime
    
    
    date = '2015/09/24'
    date_as_timestamp = int(datetime.datetime.strptime(date, "%Y/%m/%d").strftime('%s')) * 1000
    client = dataiku.api_client()
    project = client.get_default_project()
    jobs = project.list_jobs()
    failed_jobs = [job for job in jobs if job['state'] == 'FAILED' and job['def']['initiationTimestamp'] >= date_as_timestamp]
    

The method [`list_jobs()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_jobs> "dataikuapi.dss.project.DSSProject.list_jobs") returns all job information for each job, as a JSON object. Important fields are:
    
    
    {
            'def': {   'id': 'build_cat_train_hdfs_NP_2015-09-28T09-17-37.455',    # the identifier for the job
                    'initiationTimestamp': 1443431857455,                      # timestamp of when the job was submitted
                    'initiator': 'API (aa)',
                    'mailNotification': False,
                    'name': 'build_cat_train_hdfs_NP',
                    'outputs': [   {   'targetDataset': 'cat_train_hdfs',      # the dataset(s) built by the job
                                        'targetDatasetProjectKey': 'IMPALA',
                                        'targetPartition': 'NP',
                                        'type': 'DATASET'}],
                    'projectKey': 'IMPALA',
                    'refreshHiveMetastore': False,
                    'refreshIntermediateMirrors': True,
                    'refreshTargetMirrors': True,
                    'triggeredFrom': 'API',
                    'type': 'NON_RECURSIVE_FORCED_BUILD'},
        'endTime': 0,
        'stableState': True,
        'startTime': 0,
        'state': 'ABORTED',                                                    # the stable state of the job
        'warningsCount': 0}
    

The `id` field is needed to get a handle of the job and call [`abort()`](<../api-reference/python/jobs.html#dataikuapi.dss.job.DSSJob.abort> "dataikuapi.dss.job.DSSJob.abort") or [`get_log()`](<../api-reference/python/jobs.html#dataikuapi.dss.job.DSSJob.get_log> "dataikuapi.dss.job.DSSJob.get_log") on it.

## Starting new jobs

Datasets can be built by creating a job of which they are the output. A job is created by building a job definition and starting it. For a simple non-partitioned dataset, this is done with:
    
    
    import dataiku
    import time
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    definition = {
            "type" : "NON_RECURSIVE_FORCED_BUILD",
            "outputs" : [{
                "id" : "dataset_to_build",
                "type": "DATASET",
                "partition" : "NP"
            }]
        }
    job = project.start_job(definition)
    state = ''
    while state != 'DONE' and state != 'FAILED' and state != 'ABORTED':
            time.sleep(1)
            state = job.get_status()['baseStatus']['state']
    # done!
    

The example above uses [`start_job()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.start_job> "dataikuapi.dss.project.DSSProject.start_job") to start a job, and then checks the job state every second until it is complete. Alternatively, the method [`start_job_and_wait()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.start_job_and_wait> "dataikuapi.dss.project.DSSProject.start_job_and_wait") can be used to start a job and return only after job completion.

The [`start_job()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.start_job> "dataikuapi.dss.project.DSSProject.start_job") method returns a job handle that can be used to later abort the job. Other jobs can be aborted once their id is known. For example, to abort all jobs currently being processed:
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    for job in project.list_jobs():
        if job['stableState'] == False:
            project.get_job(job['def']['id']).abort()
    

Here’s another example of using [`new_job()`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.new_job> "dataikuapi.dss.project.DSSProject.new_job") to build a managed folder and the `with_output` method as an alternative to creating a dictionary job definition:
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    # where O2ue6CX3 is the managed folder id
    job = project.new_job('RECURSIVE_FORCED_BUILD').with_output('O2ue6CX3', object_type='MANAGED_FOLDER')
    res = job.start_and_wait()
    print(res.get_status())
    

## Aborting jobs

Jobs can be individually be aborted using the [`abort()`](<../api-reference/python/jobs.html#dataikuapi.dss.job.DSSJob.abort> "dataikuapi.dss.job.DSSJob.abort") method. The following example shows how to extend it to abort all jobs of a given Project.
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    aborted_jobs = []
    for job in project.list_jobs():
        if not job["stableState"]:
            job_id = job["def"]["id"]
            aborted_jobs.append(job_id)
            project.get_job(job_id).abort()
    print(f"Deleted {len(aborted_jobs)} running jobs")
    

## Reference documentation

### Classes

[`dataikuapi.dss.job.DSSJob`](<../api-reference/python/jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob")(client, ...) | A job on the DSS instance.  
---|---  
[`dataikuapi.dss.job.DSSJobWaiter`](<../api-reference/python/jobs.html#dataikuapi.dss.job.DSSJobWaiter> "dataikuapi.dss.job.DSSJobWaiter")(job) | Creates a helper to wait for the completion of a job.  
[`dataikuapi.dss.project.JobDefinitionBuilder`](<../api-reference/python/jobs.html#dataikuapi.dss.project.JobDefinitionBuilder> "dataikuapi.dss.project.JobDefinitionBuilder")(project) | Helper to run a job.  
  
### Functions

[`get_status`](<../api-reference/python/jobs.html#dataikuapi.dss.job.DSSJob.get_status> "dataikuapi.dss.job.DSSJob.get_status")() | Gets the current status of the job.  
---|---  
[`list_jobs`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_jobs> "dataikuapi.dss.project.DSSProject.list_jobs")() | List the jobs in this project  
[`new_job`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.new_job> "dataikuapi.dss.project.DSSProject.new_job")([job_type]) | Create a job to be run.  
[`start_and_wait`](<../api-reference/python/jobs.html#dataikuapi.dss.project.JobDefinitionBuilder.start_and_wait> "dataikuapi.dss.project.JobDefinitionBuilder.start_and_wait")([no_fail]) | Starts the job, waits for it to complete and returns a [`dataikuapi.dss.job.DSSJob`](<../api-reference/python/jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob") handle to interact with it  
[`start_job`](<../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.start_job> "dataikuapi.dss.project.DSSProject.start_job")(definition) | Create a new job, and return a handle to interact with it