# Dataiku Docs — dev-tutorials

## [tutorials/webapps/dash/form-to-submit-values/index]

# How to create a form for data input?

## Prerequisites

  * Dataiku >= 11.0

  * Some familiarity with HTML, CSS, and Dash for the front-end

  * Some familiarity with Python for the backend

  * An existing Dataiku Project in which you have the “Project Admin” permissions

  * A Python code environment with `dash`, `dash-bootstrap-components` and `beautifulsoup4` packages installed (see the [documentation](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html> "\(in Dataiku DSS v14\)") for more details)




This tutorial was written with Python 3.9 and uses the following package versions:

  * `dash==2.7.0`

  * `dash-bootstrap-components==1.2.1`

  * `beautifulsoup4==4.12.2`




## Introduction

In this tutorial, we will use Dash to develop a web application that enables users to view, edit, and save data. The data will be fetched from an external API, and a subset will be displayed. By following this tutorial, you will gain an understanding of the fundamental concepts of Dash, which will enable you to create complex applications. This tutorial builds upon the same concepts and objectives as [another tutorial](<../../standard/form-to-submit-values/index.html>) that covers standard web applications.

The web application allows users to enter a search term, which will be used to find a list of board games that match the criteria. The list will be displayed in a dropdown menu, allowing users to select a board game and view/edit its characteristics. Once the data has been validated, it can be saved into an existing dataset. To create an empty Dash webapp, please refer to this [mini-tutorial](<../common-parts/create-the-webapp-empty-template.html>).

## Simple form creation

### Form template

Let’s create a basic form to search for board games in a Dash web application. This form will require an input field for submitting text, a search button, and a dropdown menu for displaying search results (and later for selecting a board game for editing). The necessary code for implementing the form is highlighted in Code 1, and Fig. 1 provides a visual representation of this form.

Code 1: Design of the first part of the form.
    
    
    import dash
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash.exceptions import PreventUpdate
    
    import requests
    import xml.etree.ElementTree as ET
    
    
    # use the style of examples on the Plotly documentation
    app.config.external_stylesheets = [dbc.themes.BOOTSTRAP]
    
    search_text_layout = html.Div([
        dbc.Row([
            dbc.Label("Search for", html_for="search_input", width=2),
            dbc.Col(dbc.Input(id="search_input", placeholder="Please first enter a text to search for"), width=8),
            dbc.Col(dbc.Button("Search", id="search_button", color="primary", n_clicks=0), width=2, className="d-grid col-2 gap-2"),
        ], className="mb-3",),
        dbc.Row([
            dbc.Label("Select a game", html_for="selected_game_dropdown", width=2),
            dbc.Col(dcc.Dropdown(id="selected_game_dropdown", options=[], placeholder="Please select a game in the list..."), width=10)
        ], className="mb-3"),
    ])
    
    # build your Dash app
    app.layout = html.Div([
        search_text_layout
    ], className="container-fluid mt-3")
    

Figure 1: Basic form to search for board games

### Implement search functionality

When the user clicks on the “Search” button, we must look for the entered text in the list of board games and subsequently fill the dropdown with the returned list. Code 2 depicts the corresponding callback, which takes the following parameters:

  * output: the dropdown options

  * input: the button click event

  * state: the input value




Code 2: Callback for the search functionality
    
    
    @app.callback(
        Output("selected_game_dropdown", "options"),
        Input("search_button", "n_clicks"),
        State("search_input", "value"),
        prevent_initial_call = True
    )
    def on_search_button_click(n, text):
        if n and text:
            try:
                url= f"https://boardgamegeek.com/xmlapi/search?search={text}&type=boardgame"
                resp = requests.get(url)
                root = ET.fromstring(resp.text)
                return [{'label' : boardgame.find("name").text, 'value': boardgame.get("objectid")} for boardgame in root.findall('boardgame')]
            except Exception as e:
                # We should log this error
                return []
        else:
            raise PreventUpdate
    

Highlighted lines in Code 2 send a request to an external API responsible for the search in a board games list.

## Editing the data

### Form template for a board game

When a user select a game in the dropdown list we need to display the corresponding data. Among the data provided, we choose to display only a subset. Code 3 presents a form to display and edit those data. We also must add this layout to the `app_layout`.

Code 3: A form to display and edit data
    
    
    game_data_layout = html.Div([
        dbc.Row([html.H2("Current Game")], className="mb-3"),
        dbc.Row([
            dbc.Label("Game title", html_for="game_title_input", width=2),
            dbc.Col(dbc.Input(id="game_title_input", placeholder="Game title"), width=10)
        ], className="mb-3"),
        dbc.Row([
            dbc.Label("Year", html_for="year_input", width=2),
            dbc.Col(dbc.Input(id="year_input", placeholder="Year published"), width=10)
        ], className="mb-3"),
        dbc.Row([
            dbc.Label("Min player", html_for="year_input", width=2),
            dbc.Col(dbc.Input(id="min_player_input", placeholder="Min player"), width=4),
            dbc.Label("Max player", html_for="year_input", width=2),
            dbc.Col(dbc.Input(id="max_player_input", placeholder="Max player"), width=4)
        ], className="mb-3"),
        dbc.Row([
            dbc.Label("Complexity", html_for="complexity_input", width=2),
            dbc.Col(dcc.Slider(id="complexity_input", min=0, max=5, value=0, step=0.001,
                               marks={str(mark): str(mark) for mark in range(6)},
                               tooltip={"placement": "bottom", "always_visible": True}), width=10)
        ], className="mb-3"),
        dbc.Row([
            dbc.Label("Ratings", html_for="ratings_input", width=2),
            dbc.Col(dcc.Slider(id="ratings_input", min=0, max=10, value=0, step=0.001,
                               marks={str(mark): str(mark) for mark in range(11)},
                               tooltip={"placement": "bottom", "always_visible": True}), width=10)
        ], className="mb-3"),
        dbc.Row([dbc.Col(dbc.Textarea(id="text_input", style={"height": "200px"}), width=12)], className="mb-3"),
        dbc.Row([dbc.Col(dbc.Button("Save data", id="save_button", color="primary", outline=True, disabled=True),
                         width=12, className=" d-grid col-12 gap-12")], className="mb-3"),
    ])
    

### Parsing XML to fill the form

As this form contains many fields, we must create a callback that uses all these fields as an output and the dropdown value as an input. The external API in charge of providing the data returns XML, so we must deal with XML parsing to extract the data. The highlighted lines in Code 4 extract data from XML.

Code 4: Extracting data and displaying them.
    
    
    @app.callback(
        [
            Output("game_title_input", "value"),
            Output("year_input", "value"),
            Output("min_player_input", "value"),
            Output("max_player_input", "value"),
            Output("complexity_input", "value"),
            Output("ratings_input", "value"),
            Output("text_input", "value"),
            Output("save_button", "disabled"),
            Output("save_button", "outline")
        ],
        Input("selected_game_dropdown", "value"),
        State("selected_game_dropdown", "options"),
        prevent_initial_call = True
    )
    def on_selected_game_dropdown_change(id, options):
        if id and options:
            try:
                url= f"https://boardgamegeek.com/xmlapi/boardgame/{id}?stats=1"
                resp = requests.get(url)
                root = ET.fromstring(resp.text)
                boardgame = root.find("boardgame")
                yearpublished = boardgame.find("yearpublished").text
                minplayers = boardgame.find("minplayers").text
                maxplayers = boardgame.find("maxplayers").text
                ratings = boardgame.find("statistics").find("ratings")
                rating = ratings.find("average").text
                xml_str = ET.tostring(ratings, encoding='unicode')
                complexity = ratings.find("averageweight").text
                soup = BeautifulSoup(boardgame.find("description").text, features="html.parser")
                description = soup.get_text('\n')
                return [
                    [x['label'] for x in options if x['value'] == id][0],
                    yearpublished, minplayers, maxplayers, complexity, rating, description,
                    False, False
                ]
            except Exception as e:
                 # We should log this error
                raise PreventUpdate
        else:
            raise PreventUpdate
    

Note

Remember to import `from bs4 import BeautifulSoup` at the beginning of the code. We use BeautifulSoup, as the external API returns an HTML description for the board game description. We want to provide a nicer renderer than displaying code with HTML tags.

This callback also activates the “Save data” button, which is disabled by default.

## Saving data

After editing the data, the user can click the “Save data” button to save the data into an existing dataset using the dataiku API. Before coding this function, we need to import the `dataiku` package and `pandas`. When the user clicks the button to save data, there is no output except adding to the database. We should inform the user that the addition works (or fails), but we won’t do it in the first approach. So the callback has no `Output`, which is not feasible in Dash. We will use a little trick here, setting an `Output`, but we won’t update this `Output`. Code 5 shows how to write such a callback.

Code 5: Saving data into an existing dataset.
    
    
    @app.callback(
        Output("save_button", "n_clicks"),
        Input("save_button", "n_clicks"),
        [
            State("game_title_input", "value"),
            State("year_input", "value"),
            State("min_player_input", "value"),
            State("max_player_input", "value"),
            State("complexity_input", "value"),
            State("text_input", "value"),
        ],
        prevent_initial_call=True
    )
    def on_save_button_click(n, game_title, year_published, min_player, max_player, complexity, description):
        try:
            dataset_name = "BGG"
            dataset = dataiku.Dataset(dataset_name)
            df = dataset.get_dataframe()
            game = {
                'name': game_title,
                'year_published': year_published,
                'min_player': min_player,
                'max_player': max_player,
                'complexity': complexity,
                'description': description
            }
            df = df.append(game, ignore_index=True)
            dataset.write_dataframe(df)
        finally:
            raise PreventUpdate
    

## Complete code and conclusion

Code 6 show the complete code for searching and editing a board game. Our functional form allows us to request an external API to fetch, edit and save data into an existing dataset.

Code 6: complete code of the tutorial
    
    
    # Import necessary libraries
    import dash
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash.exceptions import PreventUpdate
    
    import logging
    import requests
    import xml.etree.ElementTree as ET
    from bs4 import BeautifulSoup
    
    import dataiku
    
    logger = logging.getLogger(__name__)
    
    # use the style of examples on the Plotly documentation
    app.config.external_stylesheets = [dbc.themes.BOOTSTRAP]
    
    home_layout = html.Div([
        dbc.Row([
            dbc.Label("Search for", html_for="search_input", width=2),
            dbc.Col(dbc.Input(id="search_input", placeholder="Please first enter a text to search for"), width=8),
            dbc.Col(dbc.Button("Search", id="search_button", color="primary", n_clicks=0), width=2,
                    className="d-grid col-2 gap-2"),
        ], className="mb-3", ),
        dbc.Row([
            dbc.Label("Select a game", html_for="selected_game_dropdown", width=2),
            dbc.Col(
                dcc.Dropdown(id="selected_game_dropdown", options=[], placeholder="Please select a game in the list..."),
                width=10)
        ], className="mb-3"),
        dbc.Row([html.H2("Current Game")], className="mb-3"),
        dbc.Row([
            dbc.Label("Game title", html_for="game_title_input", width=1),
            dbc.Col(dbc.Input(id="game_title_input", placeholder="Game title"), width=11)
        ], className="mb-3"),
        dbc.Row([
            dbc.Label("Year", html_for="year_input", width=1),
            dbc.Col(dbc.Input(id="year_input", placeholder="Year published"), width=11)
        ], className="mb-3"),
        dbc.Row([
            dbc.Label("Min player", html_for="year_input", width=1),
            dbc.Col(dbc.Input(id="min_player_input", placeholder="Min player"), width=5),
            dbc.Label("Max player", html_for="year_input", width=1),
            dbc.Col(dbc.Input(id="max_player_input", placeholder="Max player"), width=5)
        ], className="mb-3"),
        dbc.Row([
            dbc.Label("Complexity", html_for="complexity_input", width=1),
            dbc.Col(dcc.Slider(id="complexity_input", min=0, max=5, value=0, step=0.001,
                               marks={str(mark): str(mark) for mark in range(6)},
                               tooltip={"placement": "bottom", "always_visible": True}), width=11)
        ], className="mb-3"),
        dbc.Row([
            dbc.Label("Ratings", html_for="ratings_input", width=1),
            dbc.Col(dcc.Slider(id="ratings_input", min=0, max=10, value=0, step=0.001,
                               marks={str(mark): str(mark) for mark in range(11)},
                               tooltip={"placement": "bottom", "always_visible": True}), width=11)
        ], className="mb-3"),
    
        dbc.Row([dbc.Textarea(id="text_input", style={"width": "100%", "height": "200px"})], className="mb-3",
                style={"height": "100%"}),
        dbc.Row([dbc.Button("Save the data", id="save_button", color="primary", outline=True, disabled=True)],
                className="mb-3"),
        dbc.Toast(
            [html.P("This is the content of the toast", className="mb-0")],
            id="auto-toast",
            header="This is the header",
            icon="primary",
            duration=4000,
            is_open=False,
        ),
    ], className="container-fluid mt-3")
    
    # build your Dash app
    app.layout = home_layout
    
    
    @app.callback(
        [
            Output("selected_game_dropdown", "options"),
        ],
        Input("search_button", "n_clicks"),
        State("search_input", "value"),
        prevent_initial_call=True
    )
    def on_search_button_click(n, text):
        """
        Search functionality
        Args:
            n: click event
            text: text to search for
    
        Returns:
            an updated dropdown list of board games that match the criteria.
        """
        if n and text:
            try:
                url = f"https://boardgamegeek.com/xmlapi/search?search={text}&type=boardgame"
                resp = requests.get(url)
                root = ET.fromstring(resp.text)
                return [[{'label': boardgame.find("name").text, 'value': boardgame.get("objectid")} for boardgame in
                         root.findall('boardgame')]]
            except Exception as e:
                logger.info(str(e))
                return []
        else:
            raise PreventUpdate
    
    
    @app.callback(
        [
            Output("game_title_input", "value"),
            Output("year_input", "value"),
            Output("min_player_input", "value"),
            Output("max_player_input", "value"),
            Output("complexity_input", "value"),
            Output("ratings_input", "value"),
            Output("text_input", "value"),
            Output("save_button", "disabled"),
            Output("save_button", "outline")
        ],
        Input("selected_game_dropdown", "value"),
        State("selected_game_dropdown", "options"),
        prevent_initial_call=True
    )
    def on_selected_game_dropdown_change(id, options):
        """
        Filling the form for board games edition
        Args:
            id: id of the board game
            options: name of the board game.
    
        Returns:
            Fill the form responsible for the board game edition
        """
        if id and options:
            try:
                url = f"https://boardgamegeek.com/xmlapi/boardgame/{id}?stats=1"
                resp = requests.get(url)
                root = ET.fromstring(resp.text)
                boardgame = root.find("boardgame")
                yearpublished = boardgame.find("yearpublished").text
                minplayers = boardgame.find("minplayers").text
                maxplayers = boardgame.find("maxplayers").text
                ratings = boardgame.find("statistics").find("ratings")
                rating = ratings.find("average").text
                xml_str = ET.tostring(ratings, encoding='unicode')
                complexity = ratings.find("averageweight").text
                soup = BeautifulSoup(boardgame.find("description").text, features="html.parser")
                description = soup.get_text('\n')
                return [
                    [x['label'] for x in options if x['value'] == id][0],
                    yearpublished, minplayers, maxplayers, complexity, rating, description,
                    False, False
                ]
            except Exception as e:
                logger.info(f"Error : {str(e)}")
                raise PreventUpdate
        else:
            raise PreventUpdate
    
    
    @app.callback(
        Output("save_button", "n_clicks"),
        Input("save_button", "n_clicks"),
        [
            State("game_title_input", "value"),
            State("year_input", "value"),
            State("min_player_input", "value"),
            State("max_player_input", "value"),
            State("complexity_input", "value"),
            State("text_input", "value"),
        ],
        prevent_initial_call=True
    )
    def on_save_button_click(n, game_title, year_published, min_player, max_player, complexity, description):
        """
        Save the board game into the associated dataset
        Args:
            n: board game id
            game_title: title
            year_published: year published
            min_player: minimum player
            max_player: maximum player
            complexity: complexity of the board game
            description: board game description.
        """
        dataset_name = "BGG"
        client = dataiku.api_client()
        project = client.get_default_project()
        ds = project.get_dataset(dataset_name)
        if ds.exists():
            dataset = dataiku.Dataset(dataset_name)
            df = dataset.get_dataframe()
            logger.info(df.head())
            game = {
                'name': game_title,
                'year_published': year_published,
                'min_player': min_player,
                'max_player': max_player,
                'complexity': complexity,
                'description': description
            }
            logger.info(game)
            df = df.append(game, ignore_index=True)
            dataset.write_dataframe(df)
        raise PreventUpdate
    

We could have been deeper by adding feedback to the user when he acts, by the addition of a `dbc.Toast` component. Usually, when an error is thrown/detected, we should log it using the logger capability. We could also have cleared the data when the user searches for a new text, as shown in Code 7.

Code 7: Clearing the data.
    
    
    @app.callback(
        [
            Output("game_title_input", "value", allow_duplicate=True),
            Output("year_input", "value", allow_duplicate=True),
            Output("min_player_input", "value", allow_duplicate=True),
            Output("max_player_input", "value", allow_duplicate=True),
            Output("complexity_input", "value", allow_duplicate=True),
            Output("ratings_input", "value", allow_duplicate=True),
            Output("text_input", "value", allow_duplicate=True),
            Output("save_button", "disabled", allow_duplicate=True),
            Output("save_button", "outline", allow_duplicate=True)
        ],
        Input("selected_game_dropdown", "options"),
        prevent_initial_call = True
    )
    def on_dropdown_change(options):
        return ["", "", "", "", "", "", "", True, True]

---

## [tutorials/webapps/dash/index]

# Dash

  * [Dash: your first webapp](<basics/index.html>)

  * [Display a Bar chart using Dash](<display-charts/index.html>)

  * [Create a simple admin project dashboard](<admin-dashboard/index.html>)

  * [Create a multi pages application](<multi-page/index.html>)

  * [Upload or download files with Managed Folders in Dash](<upload-download-files/index.html>)

  * [Create a form for data inputs](<form-to-submit-values/index.html>)

  * [Simple scoring application](<simple-scoring/index.html>)

  * [Listing and deleting a selection of projects](<delete-projects/index.html>)




## Generative AI

  * [API for a LLM based agent](<api-agent/index.html>)

  * [GPT-powered web app assistant](<chatGPT-web-assistant/index.html>)

  * [LLM based agent](<llm-based-agent/index.html>)

---

## [tutorials/webapps/dash/llm-based-agent/index]

# Creating a Dash application using an LLM-based agent

In this tutorial, you will learn how to build an LLM-based agent application using Dash. You will build an application to retrieve customer and company information based on a login. This tutorial relies on two tools. One tool retrieves a user’s name, position, and company based on a login. This information is stored in a Dataset. A second tool searches the Internet to find company information.

This tutorial is based on the [Building and using an agent with Dataiku’s LLM Mesh and Langchain](<../../../genai/agents-and-tools/agent/index.html>) tutorial. It uses the same tools and agents in a similar context. If you have followed this tutorial, you can jump to the Creating the Dash application section.

## Prerequisites

  * Administrator permission to build the template

  * An LLM connection configured

  * A Dataiku version > 12.6.2

  * A code environment (named `dash_GenAI`) with the following packages:
        
        dash
        dash-bootstrap-components
        langchain==0.2.0
        duckduckgo_search==6.1.0
        




## Creating the Agent application

### Preparing the data

You need to create the associated dataset, as you will use a dataset that stores a user’s ID, name, position, and company based on that ID.

Table 1: customer ID id | name | job | company  
---|---|---|---  
tcook | Tim Cook | CEO | Apple  
snadella | Satya Nadella | CEO | Microsoft  
jbezos | Jeff Bezos | CEO | Amazon  
fdouetteau | Florian Douetteau | CEO | Dataiku  
wcoyote | Wile E. Coyote | Business Developer | ACME  
  
Table 1, which can be downloaded [`here`](<../../../../_downloads/ef631dd2adc601ecfd3edb132ec16e5e/pro_customers.csv>), represents such Data. Create an SQL Database named `pro_customers_sql` by uploading the CSV file and using a **Sync recipe** to store the data in an SQL connection.

### LLM initialization and library import

Be sure to have a valid `LLM ID` before creating your Gradio application. The [documentation](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>) provides instructions on obtaining an `LLM ID`.

  * Create a new webapp by clicking on **< /> > Webapps**.

  * Click the **+New webapp** , choose the **Code webapp** , then click on the **Dash** button, choose the **An empty Dash app** option, and choose a meaningful name.

  * Go to the **Settings** tabs, select the `dash_GenAI` code environment for the **Code env** option, and remove the code from the **Python** tab, as shown in Figure 1.




Figure 1: Dash settings.

To begin with, you need to set up a development environment by importing some necessary libraries and initializing the chat LLM you want to use to create the agent. The tutorial relies on the LLM Mesh for this and the Langchain package to orchestrate the process. The `DKUChatModel` class allows you to call a model previously registered in the LLM Mesh and make it recognizable as a Langchain chat model for further use. Code 1 shows how to do and import the needed libraries.

Code 1: LLM initialization and library import
    
    
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash import no_update
    from dash import set_props
    
    import dataiku
    from dataiku.langchain.dku_llm import DKUChatModel
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from duckduckgo_search import DDGS
    from langchain.agents import AgentExecutor
    from langchain.agents import create_react_agent
    from langchain_core.prompts import ChatPromptTemplate
    from langchain.tools import BaseTool, StructuredTool
    from langchain.pydantic_v1 import BaseModel, Field
    from typing import Type
    
    from textwrap import dedent
    
    dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"
    app.config.external_stylesheets = [dbc.themes.SUPERHERO, dbc_css]
    
    LLM_ID = ""  # Fill in with a valid LLM ID
    DATASET_NAME = "pro_customers_sql"
    VERSION = "V3"
    
    llm = DKUChatModel(llm_id=LLM_ID, temperature=0)
    

### Tools definition

Then, you have to define the different tools the application needs. There are various ways of defining a tool. The most precise one is based on defining classes that encapsulate the tool. Alternatively, you can use the `@tool` annotation or the `StructuredTool.from_function` function, but it may require more work when using those tools in a chain.

To define a tool using classes, there are two steps to follow:

  * Define the interface: which parameter is used by your tool.

  * Define the code: how the code is executed.




Code 2 shows how to describe a tool using classes. The highlighted lines define the tool’s interface. This simple tool takes a customer ID as an input parameter and runs a query on the SQL Dataset.

Code 2: Get customer’s information
    
    
    class CustomerInfo(BaseModel):
        """Parameter for GetCustomerInfo"""
        id: str = Field(description="customer ID")
    
    
    class GetCustomerInfo(BaseTool):
        """Gathering customer information"""
    
        name: str = "GetCustomerInfo"
        description: str = "Provide a name, job title and company of a customer, given the customer's ID"
        args_schema: Type[BaseModel] = CustomerInfo
    
        def _run(self, id: str):
            dataset = dataiku.Dataset(DATASET_NAME)
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {id}"
    
        def _arun(self, id: str):
            raise NotImplementedError("This tool does not support async")
    
    

Attention

The SQL query might be written differently depending on your SQL Engine.

Similarly, Code 3 shows how to create a tool that searches the Internet for information on a company.

Code 3: Get company’s information
    
    
    class CompanyInfo(BaseModel):
        """Parameter for the GetCompanyInfo"""
        name: str = Field(description="Company's name")
    
    
    class GetCompanyInfo(BaseTool):
        """Class for gathering in the company information"""
    
        name: str = "GetCompanyInfo"
        description: str = "Provide general information about a company, given the company's name."
        args_schema: Type[BaseModel] = CompanyInfo
    
        def _run(self, name: str):
            results = DDGS().text(name + " (company)", max_results=1)
            result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(name, max_results=1)
                result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + name
            return result
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    
    

Code 4 shows how to declare and use these tools.

Code 4: How to use tools
    
    
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    tool_names = [tool.name for tool in tools]
    

Once all the tools are defined, you are ready to create your agent. An agent is based on a prompt and uses some tools and an LLM. Code 5 creates an _agent_ and the associated _agent executor_.

Code 5: Declaring an agent
    
    
    # Initializes the agent
    prompt = ChatPromptTemplate.from_template(
        """Answer the following questions as best you can. You have only access to the following tools:
    {tools}
    Use the following format:
    Question: the input question you must answer
    Thought: you should always think about what to do
    Action: the action to take, should be one of [{tool_names}]
    Action Input: the input to the action
    Observation: the result of the action
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: I now know the final answer
    Final Answer: the final answer to the original input question
    Begin!
    Question: {input}
    Thought:{agent_scratchpad}""")
    
    agent = create_react_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools,
                                   verbose=True, return_intermediate_steps=True, handle_parsing_errors=True)
    
    

## Creating the Dash application

You now have a working agent; let’s build the Dash application. Code 6 creates the Dash layout, which constructs an application like Figure 2, consisting of an input Textbox for entering a customer ID and an output Textarea.

Code 6: Dash layout
    
    
    # build your Dash app
    v1_layout = html.Div([
        dbc.Row([html.H2("Using LLM-based agent with Dash"), ]),
        dbc.Row(dbc.Label("Please enter the login of the customer:")),
        dbc.Row([
            dbc.Col(dbc.Input(id="customer_id", placeholder="Customer Id"), width=10),
            dbc.Col(dbc.Button("Search", id="search", color="primary"), width="auto")
        ], justify="between"),
        dbc.Row([dbc.Col(dbc.Textarea(id="result", style={"min-height": "500px"}), width=12)]),
        dbc.Toast(
            [html.P("Searching for information about the customer", className="mb-0"),
             dbc.Spinner(color="primary")],
            id="auto-toast",
            header="Agent working",
            icon="primary",
            is_open=False,
            style={"position": "fixed", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)"},
        ),
        dcc.Store(id="step", data=[{"current_step": 0}]),
    ], className="container-fluid mt-3")
    
    app.layout = v1_layout
    

Figure 2: Dash layout.

Now, the only thing to do is connect the button to a function invoking the agent. Code 7 shows how to do it.

Code 7: connecting the agent and Dash
    
    
    def search_V1(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
        Returns:
            the agent result
        """
        return agent_executor.invoke({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })['output']
    
    @app.callback(
        Output("result", "value", allow_duplicate=True),
        Input("search", "n_clicks"),
        State("customer_id", "value"),
        prevent_initial_call=True,
        running=[(Output("auto-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False)],
    )
    def search(_, customer_id):
            return search_V1(customer_id)
    

You could also use another way to display the result of the agent, as shown in Code 8.

Code 7: connecting the agent and Dash
    
    
    def search_V2(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
        Returns:
            the agent result
        """
        iterator = agent_executor.iter({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id.strip()}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })
        return iterator
    
    @app.callback(
        Output("result", "value", allow_duplicate=True),
        Input("search", "n_clicks"),
        State("customer_id", "value"),
        prevent_initial_call=True,
        running=[(Output("auto-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False)],
    )
    def search(_, customer_id):
            iterator = list(search_V2(customer_id))
            actions = ""
            for value in iterator:
                if 'intermediate_step' in value:
                    for action in value['intermediate_step']:
                        actions = f"{actions}\n{action[0].log}\n{'*' * 80}"
                if 'output' in value:
                    actions = f"{actions}\nFinal Result:\n\n{value['output']}"
            return actions
    

## Going further

You can test different versions of an LLM, let the user decide to use another prompt, or define new tools. In the application’s complete code, you will find another version that incrementally displays an agent’s result.

Here are the complete versions of the code presented in this tutorial:

[`app.py`](<../../../../_downloads/9132a80c115fff8e9f3ec860ea4e0de5/app.py>)
    
    
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash import no_update
    from dash import set_props
    
    import dataiku
    from dataiku.langchain.dku_llm import DKUChatModel
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from duckduckgo_search import DDGS
    from langchain.agents import AgentExecutor
    from langchain.agents import create_react_agent
    from langchain_core.prompts import ChatPromptTemplate
    from langchain.tools import BaseTool, StructuredTool
    from langchain.pydantic_v1 import BaseModel, Field
    from typing import Type
    
    from textwrap import dedent
    
    dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"
    app.config.external_stylesheets = [dbc.themes.SUPERHERO, dbc_css]
    
    LLM_ID = ""  # Fill in with a valid LLM ID
    DATASET_NAME = "pro_customers_sql"
    VERSION = "V3"
    
    llm = DKUChatModel(llm_id=LLM_ID, temperature=0)
    
    
    class CustomerInfo(BaseModel):
        """Parameter for GetCustomerInfo"""
        id: str = Field(description="customer ID")
    
    
    class GetCustomerInfo(BaseTool):
        """Gathering customer information"""
    
        name: str = "GetCustomerInfo"
        description: str = "Provide a name, job title and company of a customer, given the customer's ID"
        args_schema: Type[BaseModel] = CustomerInfo
    
        def _run(self, id: str):
            dataset = dataiku.Dataset(DATASET_NAME)
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {id}"
    
        def _arun(self, id: str):
            raise NotImplementedError("This tool does not support async")
    
    
    class CompanyInfo(BaseModel):
        """Parameter for the GetCompanyInfo"""
        name: str = Field(description="Company's name")
    
    
    class GetCompanyInfo(BaseTool):
        """Class for gathering in the company information"""
    
        name: str = "GetCompanyInfo"
        description: str = "Provide general information about a company, given the company's name."
        args_schema: Type[BaseModel] = CompanyInfo
    
        def _run(self, name: str):
            results = DDGS().text(name + " (company)", max_results=1)
            result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(name, max_results=1)
                result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + name
            return result
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    
    
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    tool_names = [tool.name for tool in tools]
    
    # Initializes the agent
    prompt = ChatPromptTemplate.from_template(
        """Answer the following questions as best you can. You have only access to the following tools:
    {tools}
    Use the following format:
    Question: the input question you must answer
    Thought: you should always think about what to do
    Action: the action to take, should be one of [{tool_names}]
    Action Input: the input to the action
    Observation: the result of the action
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: I now know the final answer
    Final Answer: the final answer to the original input question
    Begin!
    Question: {input}
    Thought:{agent_scratchpad}""")
    
    agent = create_react_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools,
                                   verbose=True, return_intermediate_steps=True, handle_parsing_errors=True)
    
    # build your Dash app
    v1_layout = html.Div([
        dbc.Row([html.H2("Using LLM-based agent with Dash"), ]),
        dbc.Row(dbc.Label("Please enter the login of the customer:")),
        dbc.Row([
            dbc.Col(dbc.Input(id="customer_id", placeholder="Customer Id"), width=10),
            dbc.Col(dbc.Button("Search", id="search", color="primary"), width="auto")
        ], justify="between"),
        dbc.Row([dbc.Col(dbc.Textarea(id="result", style={"min-height": "500px"}), width=12)]),
        dbc.Toast(
            [html.P("Searching for information about the customer", className="mb-0"),
             dbc.Spinner(color="primary")],
            id="auto-toast",
            header="Agent working",
            icon="primary",
            is_open=False,
            style={"position": "fixed", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)"},
        ),
        dcc.Store(id="step", data=[{"current_step": 0}]),
    ], className="container-fluid mt-3")
    
    app.layout = v1_layout
    
    
    def search_V1(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
        Returns:
            the agent result
        """
        return agent_executor.invoke({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })['output']
    
    
    def search_V2(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
        Returns:
            the agent result
        """
        iterator = agent_executor.iter({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id.strip()}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })
        return iterator
    
    
    def search_V3(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
        Returns:
            the agent result
        """
        actions = ""
        steps = ""
        output = ""
        iterator = agent_executor.stream({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id.strip()}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })
        for i in iterator:
            if "output" in i:
                output = i['output']
            elif "actions" in i:
                for action in i["actions"]:
                    actions = action.log
            elif "steps" in i:
                for step in i['steps']:
                    steps = step.observation
            yield [actions, steps, output]
    
    
    
    
    @app.callback(
        Output("result", "value", allow_duplicate=True),
        Input("search", "n_clicks"),
        State("customer_id", "value"),
        prevent_initial_call=True,
        running=[(Output("auto-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False)],
    )
    def search(_, customer_id):
        if VERSION == "V1":
            return search_V1(customer_id)
        elif VERSION == "V2":
            iterator = list(search_V2(customer_id))
            actions = ""
            for value in iterator:
                if 'intermediate_step' in value:
                    for action in value['intermediate_step']:
                        actions = f"{actions}\n{action[0].log}\n{'*' * 80}"
                if 'output' in value:
                    actions = f"{actions}\nFinal Result:\n\n{value['output']}"
            return actions
        else:
            global generator
            generator = search_V3(customer_id)
            value = next(generator)
            set_props("step", {"current_step": 1})
            return value[0]
    
    
    @app.callback(
        Output("result", "value", allow_duplicate=True),
        Input("step", "current_step"),
        State("result", "value"),
        prevent_initial_call=True,
        running=[(Output("auto-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False)],
    )
    def next_value(n, old_text):
        value = next(generator, None)
        if value:
            new_text = f"""Action: {dedent(value[0])}
            Tool Result: {dedent(value[1])}
            ## Final Result: {dedent(value[2])}
            {'-' * 80}
            {old_text}
            """
            new_text = dedent(new_text)
            set_props("step", {"current_step": n + 1})
    
            return new_text
        else:
            return no_update

---

## [tutorials/webapps/dash/multi-page/index]

# Create a simple multi-page webapp

## Prerequisites

  * Some familiarity with HTML, CSS, and Dash for the front-end

  * Some familiarity with Python for the backend

  * An existing Dataiku Project in which you have the “write project content” permissions

  * A Python code environment with `dash` and `dash-bootstrap-components` packages installed (see the [documentation](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html> "\(in Dataiku DSS v14\)") for more details)




Note

This tutorial used `python==3.9`, `dash==3.0.4`, and `dash-bootstrap-components==2.0.2`, but other versions could work.

## Introduction

In this tutorial, we’ll create a simple multi-page web application to understand the underlying principles. Multi-page webapps are beneficial when we can visually separate content into distinct areas, allowing for a more focused and logically organized layout. This approach creates an application that spans multiple screens, with shared facilities between them.

To create an empty Dash webapp, please refer to this [mini-tutorial](<../common-parts/create-the-webapp-empty-template.html>).

## Start with an empty template

In the “Python” tab, we will replace the existing code with Code 1. Line 6 specifies the theme used for the webapp. After clicking the **Save** button, we should land on a page similar to Fig. 1.

Code 1: Check if the webapp is working
    
    
     1# Import necessary libraries
     2from dash import html, dcc
     3import dash_bootstrap_components as dbc
     4
     5# use the style of examples on the Plotly documentation
     6app.config.external_stylesheets = [dbc.themes.SUPERHERO]
     7
     8nav_layout = html.Div([
     9    dbc.NavbarSimple(
    10        children=[
    11            dbc.NavItem(dbc.NavLink("Page 1", href="page1")),
    12            dbc.NavItem(dbc.NavLink("Page 2", href="page2")),
    13        ] ,
    14        brand="Multi-page Dash App",
    15        brand_href="home",
    16        fluid=True,
    17        color="dark",
    18        dark=True,
    19    ),
    20])
    21
    22# Define the index page layout
    23app.layout = nav_layout
    

Figure 1: The very first rendering

Next, we will define and add two empty templates to the webapp. After line 20, we will add two templates, as shown in Code 2.

Code 2: Defining two new empty templates
    
    
    page1_layout = html.Div([
        html.H2("Page 1")
    ])
    
    page2_layout = html.Div([
        html.H2("Page 2")
    ])
    

Once we have these two templates, we can build the multi-page webapp. For this, we need to create an application layout. Some components will be shared by the whole application, the navigation bar, for example, or a footer. And some content is displayed only when navigating from one page to another. Code 3 shows how to write the application layout. The highlighted line will be used to display the specific content.

Code 3: Application layout
    
    
    1home_layout = html.Div([
    2    nav_layout,
    3    html.H1("Global shared components"),
    4    html.Div(id='page-content'),
    5    html.Footer("We can even have a footer")
    6])
    7
    8app.layout = home_layout
    

## Build the navigation

### Simple navigation workflow

We need to understand the navigation concept to build the navigation process. Navigation is usually built upon two different schemas: using hashtags or using different URLs. These schemas do not change the way to handle changes. Dash provides a component (`Location`) that represents the page’s location. We can access the properties by using the appropriate fields. When the URL changes, the `Location` component is updated. So when we click on a link, like the navLink, the URL is (internally) updated, and so is the `Location`.

In Dash, to react to a user interface event (like a click), we must connect a callback from the user interface to processing. In this case, we could have bound the click on the link to mimic the location’s change. But we prefer connecting the URL’s change (hold by `Location`) to react to any event that may change the URL. We must include the `Location` component in the webapp to connect the callback for loading the content. The callback will take the `Location` pathname as an `Input` and changes the `Div` content referenced with the `id`: `page-content`. See Code 4.

Code 4: Connecting the navigation system
    
    
    # Default template for the home page
    index_layout = html.Div([])
    
    # Global layout for the webapp
    home_layout = html.Div([
        dcc.Location(id='url', refresh=False),
        nav_layout,
        html.H1("Global shared components."),
        html.Div(id='page-content'),
        html.Footer("We can even have a footer")
    ])
    
    app.layout = home_layout
    
    # When the URL changes, update the content
    @app.callback(Output('page-content', 'children'),
              [Input('url', 'pathname')])
    def display_page(pathname):
        if pathname.endswith('page1'):
            return page1_layout
        elif pathname.endswith('page2'):
            return page2_layout
        else:
            return index_layout
    

### Advanced navigation workflow

Since we don’t know where the webapp will be deployed, we need to get the URL used. It could end with `page2`. If this is the case, we won’t be able to display the home page. So simple navigation workflow does not cover the needs. To circumvent this problem, we must register the URL where to webapp is deployed when the user runs it. Then we can compare the `Location` with the saved URL to determine which content is displayed.

For storing the `Root-url`, we will use the `Store` Dash component. As we want to save the `root-url` only at the loading time, we must also store if the `root-url` has been modified. For this, we replace the `home_layout` with Code 5. Code 6 shows how to use these new components. This code needs to adjust the `import` section `from dash.dependencies import Input, Output, State`, and `from dash.exceptions import PreventUpdate`.

Code 5: Modification of the `home_layout`
    
    
    home_layout = html.Div([
        dcc.Store(id='root-url', storage_type = 'local', clear_data=True),
        dcc.Store(id='loaded', storage_type = 'local', clear_data=True, data=False),
        dcc.Location(id='url', refresh=False),
        nav_layout,
        html.H1("Global shared components"),
        html.Div(id='page-content'),
        html.Footer("We can even have a footer")
    ])
    

Code 6: Update the corresponding callbacks
    
    
    # The following callback is used to dynamically instantiate the root-url when the webapp is launched
    @app.callback([
        Output('root-url', 'data'),
        Output('loaded', 'data')],
        Input('url', 'pathname'),
        State('loaded', 'data')
    )
    def update_root_url(url, loaded):
        if not loaded:
            return url, True
        else:
            raise PreventUpdate
    
    #  When the URL changes, update the content
    @app.callback(Output('page-content', 'children'),
              [Input('url', 'pathname')],
              [State('root-url', 'data'),
               State('loaded', 'data')],
             prevent_initial_call=True)
    def display_page(pathname, root_url, is_loaded):
        if is_loaded:
            if pathname == root_url + 'page1':
                return page1_layout
            elif pathname == root_url + 'page2':
                return page2_layout
            elif pathname == root_url + 'home':
                return index_layout
            else:
                return index_layout
        else:
            return index_layout
    

## Complete code and conclusion

Code 7 shows the complete code of this multi-page webapp. This tutorial demonstrates how to create a multi-page webapp. It is easily extendable for many more pages. Depending on the use case, we can use the most straightforward way or provide a more robust way to navigate from one page to another.

Code 7: Full code of a simple multi-page webapp
    
    
    # Import necessary libraries
    from dash import html
    from dash import dcc
    from dash import dash_table
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash.exceptions import PreventUpdate
    import logging
    
    logger = logging.getLogger(__name__)
    
    # use the style of examples on the Plotly documentation
    app.config.external_stylesheets = [dbc.themes.SUPERHERO]
    
    nav_layout = html.Div([
        dbc.NavbarSimple(
            children=[
                dbc.NavItem(dbc.NavLink("Page 1", href="page1")),
                dbc.NavItem(dbc.NavLink("Page 2", href="page2")),
            ] ,
            brand="Multi-page Dash App",
            brand_href="home",
            fluid=True,
            color="dark",
            dark=True,
        ),
    ])
    
    page1_layout = html.Div([
        html.H2("Page 1"),
    ])
    
    page2_layout = html.Div([
        html.H2("Page 2"),
    ])
    
    index_layout = html.Div([
        html.H2("Index"),
    ])
    
    home_layout = html.Div([
        dcc.Store(id='root-url', storage_type = 'local', clear_data=True),
        dcc.Store(id='loaded', storage_type = 'local', clear_data=True, data=False),
        dcc.Location(id='url', refresh=False),
        nav_layout,
        html.H1("Global shared components"),
        html.Div(id='page-content'),
        html.Footer("We can even have a footer")
    ])
    
    # Define the index page layout
    app.layout = home_layout
    
    # The following callback is used to dynamically instantiate the root-url when the webapp is launched
    @app.callback([
        Output('root-url', 'data'),
        Output('loaded', 'data')],
        Input('url', 'pathname'),
        State('loaded', 'data')
    )
    def update_root_url(url, loaded):
        if not loaded:
            return url, True
        else:
            raise PreventUpdate
    
    #  When the URL changes, update the content
    @app.callback(Output('page-content', 'children'),
                  [Input('url', 'pathname')],
                  [State('root-url', 'data'),
                   State('loaded', 'data')],
                 prevent_initial_call=True)
    def display_page(pathname, root_url, is_loaded):
        logger.info(f"Root URL: {pathname}")
        if is_loaded:
            if pathname == root_url + 'page1':
                logger.info("## Page1")
                return page1_layout
            elif pathname == root_url + 'page2':
                logger.info("## Page 2")
                return page2_layout
            elif pathname == root_url + 'home':
                logger.info("## Index")
                return index_layout
            else:
                return index_layout
        else:
            return index_layout

---

## [tutorials/webapps/dash/simple-scoring/index]

# Simple scoring application

## Prerequisites

  * Dataiku >= 12.1

  * “Use” permission on a code environment using Python >= 3.9 with the following packages:
    
    * `dash` (tested with version `2.11.1`)

    * `dash-bootstrap-components` (tested with version `1.4.2`)

  * Access to an existing project with the following permissions:
    
    * “Read project content”

    * “Write project content”

  * Access to a model deployed as an API endpoint for scoring




## Introduction

In this tutorial, you will learn how to request an API endpoint. This endpoint can be a deployed model or anything else connected to an API endpoint. This tutorial uses the model from the [MLOps training](<https://knowledge.dataiku.com/latest/deploy/api-deployment/basics/tutorial-index.html>) (from Learning projects > Real-time APIs) and a deployed API endpoint named `predict_fraud`. It provides an API endpoint to predict the authorized flag from the provided data (transaction from credit card).

To follow the tutorial, you must know the URL where the endpoint is deployed. You can find this URL in the **Local Deployer > API services** and select the tab **Sample code** from your deployment, and note the URL as shown in Fig. 1

Figure 1: Where to find the URL of an API endpoint.

Once the URL is known, you are ready to start the tutorial. Please start with an empty Dash webapp. To create an empty Dash webapp, please refer to this [mini-tutorial](<../common-parts/create-the-webapp-empty-template.html>).

## Building the webapp

You will rely on the method [`dataikuapi.APINodeClient.predict_record()`](<https://doc.dataiku.com/dss/latest/apinode/api/user-api.html#dataikuapi.APINodeClient.predict_record> "\(in Dataiku DSS v14\)") from the `dataikuapi` package to use the API endpoint. This method requires having an identifier of the endpoint to query and a Python dictionary of features. Before using this method, you need to obtain a `dataiku.APINodeClient`. This process is shown in Code 1.

Code 1: Get a prediction from a `dataiku.APINodeClient`
    
    
                client = dataikuapi.APINodeClient(url, name)
    
                record_to_predict = eval(data)
                prediction = client.predict_record("predict_fraud", record_to_predict)
    

You need the endpoint’s URL and the deployed endpoint’s name to instantiate the client. So you will create a form for the user to enter this data. And, as features must be supplied to use the [`dataikuapi.APINodeClient.predict_record()`](<https://doc.dataiku.com/dss/latest/apinode/api/user-api.html#dataikuapi.APINodeClient.predict_record> "\(in Dataiku DSS v14\)") method, you will include this data entry in the form. Code 2 shows a possible implementation of such a form.

Code 2: Form implementation
    
    
    # Content for entering API endpoint information
    api_information = html.Div([
        dbc.Row([
            dbc.Label("Endpoint URL", html_for="endpoint_url", width=2),
            dbc.Col(dbc.Input(id="endpoint_url",
                              placeholder="Please enter the endpoint URL (http://<IP_Address>:<Port>)"),
                    width=10)
        ]),
        dbc.Row([
            dbc.Label("Endpoint name", html_for="endpoint_name", width=2),
            dbc.Col(dbc.Input(id="endpoint_name",
                              placeholder="Please enter the name of the endpoint"),
                    width=10)
        ])
    ])
    
    # Content for entering feature values
    data = dbc.Row([
        dbc.Label("Data to score", html_for="features", width=2),
        dbc.Col(dbc.Textarea(id="features", class_name="mb-3"), width=10)])
    
    # Send button
    send = dbc.Row([
        dbc.Col(dbc.Button("Score it", id="score_button", color="primary", n_clicks=0),
                width=2)],
        justify="end")
    
    # Content for displaying the result
    result = dbc.Row([
        dbc.Label("Prediction", width=2),
        dbc.Label(id="prediction_result", width=10),
    ])
    
    # build your Dash app
    app.layout = html.Div([
        api_information,
        data,
        send,
        result
    ], className="container-fluid mt-3")
    

Code 3 is responsible for using the input data and predicting the result. A few error handlings are done in this callback to give some feedback to the user when something goes wrong.

Code 3: Callback to get the prediction
    
    
    @app.callback(
        Output("prediction_result", "children"),
        Input("score_button", "n_clicks"),
        State("endpoint_url", "value"),
        State("endpoint_name", "value"),
        State("features", "value"),
        prevent_initial_call=True
    )
    def score(_nclicks, url, name, data):
        if url and name:
            try:
                client = dataikuapi.APINodeClient(url, name)
    
                record_to_predict = eval(data)
                prediction = client.predict_record("predict_fraud", record_to_predict)
                return prediction \
                    .get('result', {'prediction': 'No result was found'}) \
                    .get('prediction', 'No prediction was made.')
            except SyntaxError:
                return "Parse error in feature"
            except Exception:
                return "Error"
        else:
            return "Unable to reach the endpoint"
    

## Testing the webapp

Code 4 is the complete code of the webapp. You can now test the webapp by entering the URL previously noted and the name. If you have deployed your API based on the referenced project, you can enter the following:
    
    
    {
        "purchase_date_parsed": "2017-01-01T00:00:59.000Z",
        "card_id": "C_ID_efced389a0",
        "merchant_id": "M_ID_18038b5ae7",
        "item_category": "A",
        "purchase_amount": 194.88,
        "signature_provided": 1,
        "merchant_subsector_description": "gas",
        "days_active": "-1429",
        "card_reward_program": "cash_back",
        "card_fico_score": 839,
        "card_age": 18,
        "card_state_enName": "Vermont",
        "dist_cardholder_merchant": "479.82"
    }
    

The webapp should display `1` as a result or an error message if you did not enter the correct address/name for the API endpoint.

## Complete code and conclusion

Congratulations! You now have a functional webapp that helps you to use an API endpoint. You can go further by doing a specific form for your data. If you want to do so, the tutorial “[How to create a form for data input?](<../form-to-submit-values/index.html>)” could be helpful. You can display the probabilities of the prediction. You may also send the result to another endpoint using the `requests` API.

Code 4: Complete code of the webapp
    
    
    import dash
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input, Output, State
    from dash import html
    import dataikuapi
    
    # use the style of examples on the Plotly documentation
    app.config.external_stylesheets = [dbc.themes.BOOTSTRAP]
    
    # Content for entering API endpoint information
    api_information = html.Div([
        dbc.Row([
            dbc.Label("Endpoint URL", html_for="endpoint_url", width=2),
            dbc.Col(dbc.Input(id="endpoint_url",
                              placeholder="Please enter the endpoint URL (http://<IP_Address>:<Port>)"),
                    width=10)
        ]),
        dbc.Row([
            dbc.Label("Endpoint name", html_for="endpoint_name", width=2),
            dbc.Col(dbc.Input(id="endpoint_name",
                              placeholder="Please enter the name of the endpoint"),
                    width=10)
        ])
    ])
    
    # Content for entering feature values
    data = dbc.Row([
        dbc.Label("Data to score", html_for="features", width=2),
        dbc.Col(dbc.Textarea(id="features", class_name="mb-3"), width=10)])
    
    # Send button
    send = dbc.Row([
        dbc.Col(dbc.Button("Score it", id="score_button", color="primary", n_clicks=0),
                width=2)],
        justify="end")
    
    # Content for displaying the result
    result = dbc.Row([
        dbc.Label("Prediction", width=2),
        dbc.Label(id="prediction_result", width=10),
    ])
    
    # build your Dash app
    app.layout = html.Div([
        api_information,
        data,
        send,
        result
    ], className="container-fluid mt-3")
    
    
    @app.callback(
        Output("prediction_result", "children"),
        Input("score_button", "n_clicks"),
        State("endpoint_url", "value"),
        State("endpoint_name", "value"),
        State("features", "value"),
        prevent_initial_call=True
    )
    def score(_nclicks, url, name, data):
        if url and name:
            try:
                client = dataikuapi.APINodeClient(url, name)
    
                record_to_predict = eval(data)
                prediction = client.predict_record("predict_fraud", record_to_predict)
                return prediction \
                    .get('result', {'prediction': 'No result was found'}) \
                    .get('prediction', 'No prediction was made.')
            except SyntaxError:
                return "Parse error in feature"
            except Exception:
                return "Error"
        else:
            return "Unable to reach the endpoint"

---

## [tutorials/webapps/dash/upload-download-files/index]

# Uploading or downloading files with Managed Folders in Dash

## Prerequisites

  * Dataiku >= 11.0

  * Some familiarity with HTML, CSS, and Dash for the front-end

  * Some familiarity with Python for the backend

  * An existing Dataiku Project in which you have the “write project content” permissions

  * A Python code environment with `dash` and `dash-bootstrap-components` packages installed (see the [documentation](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html> "\(in Dataiku DSS v14\)") for more details)




This tutorial was written with Python 3.9 and the following package versions:

  * `dash==2.9.1`

  * `dash-bootstrap-components==1.4.1`




## Introduction

In this tutorial, we want to focus on file upload and download functionality using a web application. There are several ways to implement this. The best approach depends on the specific needs of the project. We will build an application that allows the user to select an existing managed folder in the project. With this selected managed folder, we will let the user upload one or more files into the managed folder. We will also display the file list, so the user can easily download them.

## Start with an empty template

We will start with an empty Dash web application. If you don’t know how to create one please refer to this [mini-tutorial](<../common-parts/create-the-webapp-empty-template.html>).

In the **Python** tab, we will replace the existing code with Code 1.

Code 1: First template
    
    
    # Import necessary libraries
    import dash
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash.exceptions import PreventUpdate
    from dash import ALL, MATCH
    
    #from webapps.utils import get_managed_folder_list
    #from webapps.utils import get_files_in_folder
    
    import logging
    import dataiku
    import io
    import base64
    
    logger = logging.getLogger(__name__)
    
    dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"
    # use the style of examples on the Plotly documentation
    app.config.external_stylesheets = [dbc.themes.SUPERHERO, dbc_css]
    
    home_layout = html.Div([
        dcc.Store(id='sequential_call'),
        dbc.Row([html.H2("Select a managed folder"), ]),
        dbc.Row([dcc.Dropdown(id='select_managed', options=[], placeholder="Select a managed folder", className="dbc"), ]),
        dbc.Row([html.H3("Upload a file to the managed folder"), ]),
        dbc.Row(
            dcc.Upload(
                id='upload_data',
                children=html.Div(id='output-data-upload', children=
                ["Drag and drop or click to select a file to upload."]
                                  ),
                style={
                    "height": "60px",
                    "lineHeight": "60px",
                    "borderWidth": "1px",
                    "borderStyle": "dashed",
                    "borderRadius": "5px",
                    "textAlign": "center",
                    "margin": "10px",
                },
                multiple=True,
                disabled=True
            ),
        ),
        dbc.Row([html.H3("Files from the managed folder"), ]),
        dbc.Row([html.Ul(id='file_list')], className="dbc container-fluid mt-3"),
    ], className="container-fluid mt-3")
    
    # build your Dash app
    app.layout = home_layout
    

This template code has two highlighted lines. Those lines will be uncommented later in the tutorial. We also use a `dcc.Store` component. For more detail about this component, please refer to [this documentation](<https://dash.plotly.com/dash-core-components/store>). After clicking the **Save** button, we should land on a page similar to Fig. 1.

Figure 1: First template rendering.

## Utility functions

Before using this template, we will create some utility functions in the project library. Go to **< />** > **Library** , under the `python` folder, and create a sub-folder named `webapps`. Create a file named `utils.py` in this folder with the content shown in Code 2. There are only two functions:

  * `get_managed_folder_list`: to retrieve the managed folder list of the current project

  * `get_files_in_folder`: to retrieve a list of files contained in a managed folder




Code 2: Helper functions in the project library
    
    
    import dataiku
    
    
    def get_managed_folder_list():
        """
        Get the list of managed folders in the current project
    
        :return: A list of (id, name)
        """
        project = dataiku.api_client().get_default_project()
        managed_folders = project.list_managed_folders()
        ids_and_names = [(mf.get('id', ''), mf.get('name', ''))
                         for mf in managed_folders]
        return ids_and_names
    
    
    def get_files_in_folder(folder_id):
        """
        Get the list of files in a managed folder
    
        :param id: Id of the managed folder
    
        :return: A list of files in the managed folder
        """
        mf = dataiku.Folder(folder_id)
        files = mf.list_paths_in_partition()
        return files
    

## Uploading a file

With the help of the utility functions, we can populate the dropdown with the list of managed folders in the project. Before using these utility functions, uncomment the highlighted lines of Code 1. As we have deactivated the upload component by default, we should enable it once the user selects a managed folder. We will also display the list of files contained in the managed folder.

Code 3 shows how to do this.

Code 3: Filling the dropdown with the list of managed folders
    
    
    @app.callback(
        Output('select_managed', 'options'),
        Input('select_managed', 'id')
    )
    def load_select(id):
        ids_and_names = get_managed_folder_list()
        return [{'value': ian[0], 'label': ian[1]} for ian in ids_and_names]
    
    @app.callback(
        [Output('file_list', 'children'),
         Output('upload_data', 'disabled')],
        Input('select_managed', 'value'),
        prevent_initial_call = True
    )
    def update_list(folder_id):
        files = get_files_in_folder(folder_id)
        if len(files) == 0:
            return [[html.Li("No file in the selected folder")], False]
        else:
            return [[html.Li(html.A(filename, href="")) for filename in files], False]
    

With the help of these callbacks, we can now display the list of files in the managed folder, as shown in Fig. 2

Figure 2: Showing files in a managed folder.

Now, we need to connect the upload to a callback, allowing the user to upload data in the selected managed folder. Code 4 shows how to do it. We need to consider the usual parameter of an Upload widget for the input parameters. The output of this callback is the `folder-id` to update the list of files. Returning the `folder_id` will trigger the callback to update the list of files in the managed folder once the upload is completed.

Code 4: Callback for uploading a file in a selected managed folder.
    
    
    # Upload file in a managed folder
    @app.callback(
        Output('select_managed', 'value', allow_duplicate=True),
        [Input('upload_data', 'filename'),
         Input('upload_data', 'contents')],
        State('select_managed', 'value'),
        prevent_initial_call=True
    )
    def update_output(uploaded_filenames, uploaded_file_contents, folder_id):
        """Save uploaded files and regenerate the file list."""
        if (folder_id is not None):
            mf = dataiku.Folder(folder_id)
            if uploaded_filenames is not None and uploaded_file_contents is not None:
                for name, data in zip(uploaded_filenames, uploaded_file_contents):
                    content_type, content_string = data.split(',')
                    stream_d = base64.b64decode(content_string)
                    stream = io.BytesIO(stream_d)
                    mf.upload_stream(name, stream)
    
            return folder_id
        else:
            return dash.no_update
    

## Downloading files

As explained in the Dash documentation, we will use the `Download component` from the Dash core components library to download a file and associate a button to this component.So for each file, we need to create a button (with a unique id) and a download component. We will wrap this creation into an HTML `LI` tag, so we can easily display a list of files by using the HTML `UL` tags. The button `id` will be the index of the file in the list of files in the managed folder, but any other way of defining an `id` is a valid approach. The emphasized lines in Code 5 show how to create this component. The other lines show how to use it.

Code 5: Display a list of download buttons
    
    
    def make_download_button(filename, index):
        btn_id = "btn_{}".format(index)
        dld_id = "dld_{}".format(index)
        id = index;
        download_area = dcc.Download(id=dld_id);
        button = html.Button(filename, id=btn_id);
        layout = html.Li(html.Div(children=[button, download_area]));
        return layout
    
    @app.callback(
        [Output('file_list', 'children'),
         Output('upload_data', 'disabled')],
        Input('select_managed', 'value'),
        prevent_initial_call = True
    )
    def update_list(folder_id):
        if (folder_id):
            files = get_files_in_folder(folder_id)
            if len(files) == 0:
                return [[html.Li("No file in the selected folder")], False]
            else:
                return [[make_download_button(filename,x) for x,filename in enumerate(files)], False]
        else:
            return dash.no_update, True
    

We do not plug the callback for the button to work. But this code would not work correctly, even if we plug a callback. If the user changes several times the managed folder, the webapp will create many buttons with the same id, preventing the webapp from working properly. To solve this problem, we first need a callback that cleans the existing buttons (and downloads items) and then populates the new list with new objects. As both callbacks (the one for cleaning and for generating the list of files) will work on the same object, we need to be sure that the callback for cleaning the objects will be called before the other one. The clean callback will modify the list based on the selected manage folder. It will also update the store. The callback for generating the list of files is executed when the webapp modifies the store. Code 6 implements this synchronization between two callbacks.

In summary, the sequence of events is controlled by the `sequential_call` data store. The `clear_list` callback changes the data in the store, which triggers the `update_list` callback. This ensures that every time a new folder is selected, the list of files is cleared and updated with the files in the new folder.

Code 6: Callback synchronization
    
    
    # List files in selected managed folder
    @app.callback(
        [
            Output('upload_data', 'disabled', allow_duplicate=True),
            Output('sequential_call', 'data', allow_duplicate=True),
            Output('file_list', 'children', allow_duplicate=True),
        ],
        Input('select_managed', 'value'),
        State('sequential_call', 'data'),
        prevent_initial_call = True
    )
    def clear_list(n, data):
        value = data or {'update_list': 0}
        value['update_list'] = value['update_list'] + 1
        return [False, value, []]
    
    
    # Update list of file
    @app.callback(
        [
            Output('file_list', 'children', allow_duplicate = True),
            Output('upload_data', 'disabled', allow_duplicate = True),
        ],
        Input('sequential_call', 'data'),
        State('select_managed', 'value'),
        prevent_initial_call = True
    )
    def update_list(data, folder_id):
        if (folder_id):
            files = get_files_in_folder(folder_id)
            if len(files) == 0:
                return [[html.Li("No file in the selected folder")], False]
            else:
                return [[make_download_button(filename,x) for x,filename in enumerate(files)], False]
        else:
            return dash.no_update, True
    

Now we need to connect the download buttons to a callback for downloading a file. We will use the pattern-matching callback mechanism. For more information, please refer to the [Dash documentation](<https://dash.plotly.com/pattern-matching-callbacks>). To use pattern-matching callback, we must replace the `make_download_button` with the function shown in Code 7 (highlighted lines). With this button, the associated callback is straightforward.

Code 7: Generating a download button compatible with pattern-matching callbacks
    
    
    def make_download_button(filename, index):
        download_area = dcc.Download(id={'index': index, 'type': 'dld'}, data={'base64':True})
        button = html.Button(filename, id={'index': index, 'type': 'btn', 'filename': filename})
        layout = html.Li(html.Div(children=[button, download_area]))
        return layout
    
    # Download file from Managed Folder
    @app.callback(
        Output({'type': 'dld', 'index': MATCH}, 'data'),
        Input({'type':'btn', 'index': MATCH, 'filename': ALL}, 'n_clicks'),
        State({'type':'btn', 'index': MATCH, 'filename': ALL}, 'id'),
        State('select_managed', 'value'),
        prevent_initial_call = True
    )
    def download_file(n, id, managed):
        if (id):
            mf = dataiku.Folder(managed)
    
            def write_file(bytes_io):
                stream = mf.get_download_stream(id[0].get('filename',''))
                bytes_io.write(stream.read())
    
            return dcc.send_bytes(write_file, (id[0].get('filename','_file'))[1:])
        else:
            return dash.no_update
    

## Complete code and conclusion

Code 8 shows the complete code for uploading/downloading files from a managed folder. This tutorial shows how to read files from a managed folder and write files to a managed folder. The complexity of this tutorial comes from the need for a dedicated component (a file explorer-like) in Dash.

Code 8: Complete code of the tutorial
    
    
    # Import necessary libraries
    import dash
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash.exceptions import PreventUpdate
    from dash import ALL, MATCH
    
    from webapps.utils import get_managed_folder_list
    from webapps.utils import get_files_in_folder
    
    import logging
    import dataiku
    import io
    import base64
    
    logger = logging.getLogger(__name__)
    
    dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"
    # use the style of examples on the Plotly documentation
    app.config.external_stylesheets = [dbc.themes.SUPERHERO, dbc_css]
    
    home_layout = html.Div([
        dcc.Store(id='sequential_call'),
        dbc.Row([html.H2("Select a managed folder"), ]),
        dbc.Row([dcc.Dropdown(id='select_managed', options=[], placeholder="Select a managed folder", className="dbc"), ]),
        dbc.Row([html.H3("Upload a file to the managed folder"), ]),
        dbc.Row(
            dcc.Upload(
                id='upload_data',
                children=html.Div(id='output-data-upload', children=
                ["Drag and drop or click to select a file to upload."]
                                  ),
                style={
                    "height": "60px",
                    "lineHeight": "60px",
                    "borderWidth": "1px",
                    "borderStyle": "dashed",
                    "borderRadius": "5px",
                    "textAlign": "center",
                    "margin": "10px",
                },
                multiple=True,
                disabled=True
            ),
        ),
        dbc.Row([html.H3("Files from the managed folder"), ]),
        dbc.Row([html.Ul(id='file_list')], className="dbc container-fluid mt-3"),
    ], className="container-fluid mt-3")
    
    # build your Dash app
    app.layout = home_layout
    
    
    def make_download_button(filename, index):
        """
        Create a button associated with a dcc.Download component
        Args:
            filename: filename associated with the download component
            index: index of the button.
    
        Returns:
            a button associated with a dcc.Download component
        """
        download_area = dcc.Download(id={'index': index, 'type': 'dld'}, data={'base64': True})
        button = html.Button(filename, id={'index': index, 'type': 'btn', 'filename': filename})
        layout = html.Li(html.Div(children=[button, download_area]))
        return layout
    
    
    @app.callback(
        Output('select_managed', 'options'),
        Input('select_managed', 'id')
    )
    def load_select(_):
        """
        Populate the dropdown with the list of the managed folders
    
        Returns:
            list of the managed folders with their id
        """
        ids_and_names = get_managed_folder_list()
        return [{'value': ian[0], 'label': ian[1]} for ian in ids_and_names]
    
    
    # List files in selected managed folder
    @app.callback(
        [
            Output('upload_data', 'disabled', allow_duplicate=True),
            Output('sequential_call', 'data', allow_duplicate=True),
            Output('file_list', 'children', allow_duplicate=True),
        ],
        Input('select_managed', 'value'),
        State('sequential_call', 'data'),
        prevent_initial_call=True
    )
    def clear_list(_, data):
        """
        Clear the list of Button and Download components
        Args:
            _: not used (only for calling the callback)
            data: for callback synchronization
    
        Returns:
            False (to enable the Upload component),
            value (for calling the next callback (update list))
            [] (to remove existing component)
        """
        value = data or {'update_list': 0}
        value['update_list'] = value['update_list'] + 1
        return [False, value, []]
    
    
    # Update list of file
    @app.callback(
        [
            Output('file_list', 'children', allow_duplicate=True),
            Output('upload_data', 'disabled', allow_duplicate=True),
        ],
        Input('sequential_call', 'data'),
        State('select_managed', 'value'),
        prevent_initial_call=True
    )
    def update_list(_, folder_id):
        """
        Update the file list
        Args:
            _: not use, callback synchronization
            folder_id: the id of the managed folder
    
        Returns:
            the file list
        """
        if folder_id:
            files = get_files_in_folder(folder_id)
            if len(files) == 0:
                return [[html.Li("No file in the selected folder")], False]
            else:
                return [[make_download_button(filename, x) for x, filename in enumerate(files)], False]
        else:
            return dash.no_update, True
    
    
    # Upload file in managed folder
    @app.callback(
        Output('select_managed', 'value', allow_duplicate=True),
        [Input('upload_data', 'filename'),
         Input('upload_data', 'contents')],
        State('select_managed', 'value'),
        prevent_initial_call=True
    )
    def update_output(uploaded_filenames, uploaded_file_contents, folder_id):
        """
        Save uploaded files and regenerate the file list.
        Args:
            uploaded_filenames: filenames
            uploaded_file_contents: file contents
            folder_id: where to upload the files.
    
        Returns:
            folder_id for file list refresh
        """
        if folder_id is not None:
            mf = dataiku.Folder(folder_id)
            if uploaded_filenames is not None and uploaded_file_contents is not None:
                for name, data in zip(uploaded_filenames, uploaded_file_contents):
                    content_type, content_string = data.split(',')
                    stream_d = base64.b64decode(content_string)
                    stream = io.BytesIO(stream_d)
                    mf.upload_stream(name, stream)
    
            return folder_id
        else:
            return dash.no_update
    
    
    # Download file from Managed Folder
    @app.callback(
        Output({'type': 'dld', 'index': MATCH}, 'data'),
        Input({'type': 'btn', 'index': MATCH, 'filename': ALL}, 'n_clicks'),
        State({'type': 'btn', 'index': MATCH, 'filename': ALL}, 'id'),
        State('select_managed', 'value'),
        prevent_initial_call=True
    )
    def download_file(_, id, managed):
        """
        Callback for downloading a file
        Args:
            _: not used (only for triggering the callback)
            id: id of the associated button
            managed: value of the selected managed folder
        Returns:
            nothing, just the ability of downloading a file.
        """
        if id:
            mf = dataiku.Folder(managed)
    
            def write_file(bytes_io):
                stream = mf.get_download_stream(id[0].get('filename', ''))
                bytes_io.write(stream.read())
    
            return dcc.send_bytes(write_file, (id[0].get('filename', '_file'))[1:])
        else:
            return dash.no_update

---

## [tutorials/webapps/gen-ai]

# Webapps using Generative AI

## Headless API

  * [API Endpoint on LLM](<common/api-llm/index.html>)




## Dash

  * [API for a LLM based agent](<dash/api-agent/index.html>)

  * [GPT-powered web app assistant](<dash/chatGPT-web-assistant/index.html>)

  * [LLM based agent](<dash/llm-based-agent/index.html>)




## Gradio

  * [First application](<gradio/first-webapp/index.html>)

  * [LLM based agent](<gradio/agent/index.html>)




## Voilà

  * [First application](<voila/first-webapp/index.html>)

  * [LLM based agent](<voila/agent/index.html>)

---

## [tutorials/webapps/gradio/agent/index]

# Creating a Gradio application using an LLM-based agent

In this tutorial, you will learn how to build an Agent application using Gradio. You will build an application to retrieve customer and company information based on a login. This tutorial relies on two tools. One tool retrieves a user’s name, position, and company based on a login. This information is stored in a Dataset. A second tool searches the Internet to find company information.

This tutorial is based on the [Building and using an agent with Dataiku’s LLM Mesh and Langchain](<../../../genai/agents-and-tools/agent/index.html>) tutorial. It uses the same tools and agents in a similar context. If you have followed this tutorial, you can jump to the Creating the Gradio application section.

## Prerequisites

  * Administrator permission to build the template

  * An LLM connection configured

  * A Dataiku version > 12.6.2

  * A code environment (named `gradio-and-agents`) with the following packages:
        
        gradio <4
        langchain==0.2.0
        duckduckgo_search==6.1.0
        




## Building the Code Studio template

If you know how to build a Code Studio template using Gradio and a dedicated code environment, you have to create one named `gradio-and-agent`.

If you don’t know how to do it, please follow these instructions:

  * Go to the **Code Studios** tab in the **Administration** menu, click the **+Create Code Studio template** button, and choose a meaningful label (`gradio_template`, for example).

  * Click on the **Definition** tab.

  * Add a new **Visual Studio Code** block. This block will allow you to edit your Gradio application in a dedicated Code Studio.

  * Add the **Add Code environment** block, and choose the code environment previously created (`gradio-and-agents`).

  * Add the **Gradio** block and select the code environment previously imported, as shown in Figure 1.

  * Click the **Save** button.

  * Click the **Build** button to build the template.




Figure 1: Code Studio – Gradio block.

Your Code Studio template is ready to be used in a project.

## Creating the Agent application

### Preparing the data

You need to create the associated dataset, as you will use a dataset that stores a user’s ID, name, position, and company based on that ID.

Table 1: customer ID id | name | job | company  
---|---|---|---  
tcook | Tim Cook | CEO | Apple  
snadella | Satya Nadella | CEO | Microsoft  
jbezos | Jeff Bezos | CEO | Amazon  
fdouetteau | Florian Douetteau | CEO | Dataiku  
wcoyote | Wile E. Coyote | Business Developer | ACME  
  
Table 1, which can be downloaded [`here`](<../../../../_downloads/d9ccaf2596f6987d39eadc31024cdfb7/pro_customers.csv>), represents such Data. Create a SQL Database named `pro_customers_sql` by uploading the CSV file and using a **Sync recipe** to store the data in an SQL connection.

### Creating utility functions

Be sure to have a valid `LLM ID` before creating your Gradio application. The [documentation](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>) provides instructions on obtaining an `LLM ID`.

  * Create a new project, click on **< /> > Code Studios**.

  * Click the **+New Code Studio** , choose the previously created template, choose a meaningful name, click the **Create** button, and then click the **Start Code Studio** button.

  * To edit the code of your Gradio application, click the highlighted tabs (VS Code) as shown in Figure 2.

Figure 2: Code studio – Edit the code.

  * Select the `gradio` subdirectory in the `code_studio-versioned` directory. Dataiku provides a sample application in the file `app.py`.




You will modify this code to build the application. The first thing to do is define the different tools the application needs. There are various ways of defining a tool. The most precise one is based on defining classes that encapsulate the tool. Alternatively, you can use the `@tool` annotation or the `StructuredTool.from_function` function, but it may require more work when using those tools in a chain.

To define a tool using classes, there are two steps to follow:

  * Define the interface: which parameter is used by your tool.

  * Define the code: how the code is executed.




Code 1 shows how to describe a tool using classes. The highlighted lines define the tool’s interface. This simple tool takes a customer ID as an input parameter and runs a query on the SQL Dataset.

Code 1: Get customer’s information
    
    
    class CustomerInfo(BaseModel):
        """Parameter for GetCustomerInfo"""
        id: str = Field(description="customer ID")
    
    
    class GetCustomerInfo(BaseTool):
        """Gathering customer information"""
    
        name: str = "GetCustomerInfo"
        description: str = "Provide a name, job title and company of a customer, given the customer's ID"
        args_schema: Type[BaseModel] = CustomerInfo
    
        def _run(self, id: str):
            dataset = dataiku.Dataset(DATASET_NAME)
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {id}"
    
        def _arun(self, id: str):
            raise NotImplementedError("This tool does not support async")
    
    

Attention

The SQL query might be written differently depending on your SQL Engine.

Similarly, Code 2 shows how to create a tool that searches the Internet for information on a company.

Code 2: Get company’s information
    
    
    class CompanyInfo(BaseModel):
        """Parameter for the GetCompanyInfo"""
        name: str = Field(description="Company's name")
    
    
    class GetCompanyInfo(BaseTool):
        """Class for gathering in the company information"""
    
        name:str = "GetCompanyInfo"
        description:str = "Provide general information about a company, given the company's name."
        args_schema: Type[BaseModel] = CompanyInfo
    
        def _run(self, name: str):
            results = DDGS().text(name + " (company)", max_results=1)
            result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(name, max_results=1)
                result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + name
            return result
    
    

Code 3 shows how to declare and use these tools.

Code 3: How to use tools
    
    
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    tool_names = [tool.name for tool in tools]
    

Once all the tools are defined, you are ready to create your agent. An agent is based on a prompt and uses some tools and an LLM. Code 4 is about creating an _agent_ and the associated _agent executor_.

Code 4: Declaring an agent
    
    
    # Initializes the agent
    prompt = ChatPromptTemplate.from_template(
        """Answer the following questions as best you can. You have only access to the following tools:
    
    {tools}
    
    Use the following format:
    
    Question: the input question you must answer
    Thought: you should always think about what to do
    Action: the action to take, should be one of [{tool_names}]
    Action Input: the input to the action
    Observation: the result of the action
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: I now know the final answer
    Final Answer: the final answer to the original input question
    
    Begin!
    
    Question: {input}
    Thought:{agent_scratchpad}""")
    
    agent = create_react_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools,
                                   verbose=True, return_intermediate_steps=True, handle_parsing_errors=True)
    
    

## Creating the Gradio application

You now have a working agent; let’s build the Gradio application. This first version has an input Textbox for entering a customer ID and displays the result in an output Textbox. Thus, the code is straightforward. You need to connect your agent to the Gradio framework, as shown in Code 5.

Code 5: First version of the application
    
    
    def search_V1(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
    
        Returns:
            the agent result
        """
        return agent_executor.invoke({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })['output']
    
    
    
    
    
    demo = gr.Interface(
        fn=search_V1,
        inputs=gr.Textbox(label="Enter a customer ID to get more information", placeholder="ID Here..."),
        outputs="text"
    )
    
    
    
    
    browser_path = os.getenv("DKU_CODE_STUDIO_BROWSER_PATH_7860")
    # replacing env var keys in browser_path with their values
    env_var_pattern = re.compile(r'(\${(.*)})')
    env_vars = env_var_pattern.findall(browser_path)
    for env_var in env_vars:
        browser_path = browser_path.replace(env_var[0], os.getenv(env_var[1], ''))
    
    # WARNING: make sure to use the same params as the ones defined below when calling the launch method,
    # otherwise you app might not be responding!
    demo.queue().launch(server_port=7860, root_path=browser_path)
    

This will lead to an application like the one shown in Figure 3.

Figure 3: First version of the web app.

## Going further

You have an application that takes a customer ID as input and displays the result. However, the result is displayed only when the agent has it, and you don’t see the agent’s actions to obtain it. The second version of the application (Code 6) displays the process as it goes along.

Code 6: Second version of the application
    
    
    async def search_V2(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
    
        Returns:
            the agent result
        """
        iterator = agent_executor.stream({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id.strip()}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })
        for i in iterator:
            if "output" in i:
                yield i['output']
            else:
                yield i
    
    
    
    
    
    demo = gr.Interface(
        fn=search_V2,
        inputs=gr.Textbox(label="Enter a customer ID to get more information", placeholder="ID Here..."),
        outputs="text"
    )
    
    
    
    browser_path = os.getenv("DKU_CODE_STUDIO_BROWSER_PATH_7860")
    # replacing env var keys in browser_path with their values
    env_var_pattern = re.compile(r'(\${(.*)})')
    env_vars = env_var_pattern.findall(browser_path)
    for env_var in env_vars:
        browser_path = browser_path.replace(env_var[0], os.getenv(env_var[1], ''))
    
    # WARNING: make sure to use the same params as the ones defined below when calling the launch method,
    # otherwise you app might not be responding!
    demo.queue().launch(server_port=7860, root_path=browser_path)
    

Code 7 shows how to show how the agent is acting more comprehensively. Figure 5 shows the result of this code.

Code 7: Final version of the application
    
    
    async def search_V3(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
    
        Returns:
            the agent result
        """
        actions = ""
        steps = ""
        output = ""
        iterator = agent_executor.stream({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id.strip()}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })
        for i in iterator:
            if "output" in i:
                output = i['output']
            elif "actions" in i:
                for action in i["actions"]:
                    actions = action.log
            elif "steps" in i:
                for step in i['steps']:
                    steps = step.observation
            yield [actions, steps, output]
    
    
    
    
    
    demo = gr.Interface(
        fn=search_V3,
        inputs=gr.Textbox(label="Enter a customer ID to get more information", placeholder="ID Here..."),
        outputs=[
            gr.Textbox(label="Agent thought"),
            gr.Textbox(label="Tool Result"),
            gr.Textbox(label="Final result")]
    )
    
    
    
    
    browser_path = os.getenv("DKU_CODE_STUDIO_BROWSER_PATH_7860")
    # replacing env var keys in browser_path with their values
    env_var_pattern = re.compile(r'(\${(.*)})')
    env_vars = env_var_pattern.findall(browser_path)
    for env_var in env_vars:
        browser_path = browser_path.replace(env_var[0], os.getenv(env_var[1], ''))
    
    # WARNING: make sure to use the same params as the ones defined below when calling the launch method,
    # otherwise you app might not be responding!
    demo.queue().launch(server_port=7860, root_path=browser_path)
    

Figure 4: Final version.

If you want to test different usage of an LLM, follow the steps:

  * Use the [`list_llms()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms") method (like shown [here](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>)).

  * Store the result in a list.

  * Use this list as a dropdown.

  * Create a new agent each time the user changes the input.




There are many other ways to improve this application, but you now have enough knowledge to adapt it to your needs.

Here are the complete versions of the code presented in this tutorial:

[`app.py`](<../../../../_downloads/35f853114e7cd72d15b80624d35ee2df/app.py>)
    
    
    import gradio as gr
    import os
    import re
    
    import dataiku
    from dataiku.langchain.dku_llm import DKUChatModel
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from langchain.agents import AgentExecutor
    from langchain.agents import create_react_agent
    from langchain_core.prompts import ChatPromptTemplate
    from langchain.tools import BaseTool, StructuredTool
    from langchain.pydantic_v1 import BaseModel, Field
    from typing import Optional, Type
    
    from duckduckgo_search import DDGS
    
    
    LLM_ID = "" # Fill in with a valid LLM ID
    DATASET_NAME = "pro_customers_sql"
    VERSION = "V3"
    
    llm = DKUChatModel(llm_id=LLM_ID, temperature=0)
    
    
    class CustomerInfo(BaseModel):
        """Parameter for GetCustomerInfo"""
        id: str = Field(description="customer ID")
    
    
    class GetCustomerInfo(BaseTool):
        """Gathering customer information"""
    
        name: str = "GetCustomerInfo"
        description: str = "Provide a name, job title and company of a customer, given the customer's ID"
        args_schema: Type[BaseModel] = CustomerInfo
    
        def _run(self, id: str):
            dataset = dataiku.Dataset(DATASET_NAME)
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {id}"
    
        def _arun(self, id: str):
            raise NotImplementedError("This tool does not support async")
    
    
    class CompanyInfo(BaseModel):
        """Parameter for the GetCompanyInfo"""
        name: str = Field(description="Company's name")
    
    
    class GetCompanyInfo(BaseTool):
        """Class for gathering in the company information"""
    
        name:str = "GetCompanyInfo"
        description:str = "Provide general information about a company, given the company's name."
        args_schema: Type[BaseModel] = CompanyInfo
    
        def _run(self, name: str):
            results = DDGS().text(name + " (company)", max_results=1)
            result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(name, max_results=1)
                result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + name
            return result
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    
    
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    tool_names = [tool.name for tool in tools]
    
    # Initializes the agent
    prompt = ChatPromptTemplate.from_template(
        """Answer the following questions as best you can. You have only access to the following tools:
    
    {tools}
    
    Use the following format:
    
    Question: the input question you must answer
    Thought: you should always think about what to do
    Action: the action to take, should be one of [{tool_names}]
    Action Input: the input to the action
    Observation: the result of the action
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: I now know the final answer
    Final Answer: the final answer to the original input question
    
    Begin!
    
    Question: {input}
    Thought:{agent_scratchpad}""")
    
    agent = create_react_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools,
                                   verbose=True, return_intermediate_steps=True, handle_parsing_errors=True)
    
    
    def search_V1(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
    
        Returns:
            the agent result
        """
        return agent_executor.invoke({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })['output']
    
    
    async def search_V2(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
    
        Returns:
            the agent result
        """
        iterator = agent_executor.stream({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id.strip()}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })
        for i in iterator:
            if "output" in i:
                yield i['output']
            else:
                yield i
    
    
    async def search_V3(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
    
        Returns:
            the agent result
        """
        actions = ""
        steps = ""
        output = ""
        iterator = agent_executor.stream({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id.strip()}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })
        for i in iterator:
            if "output" in i:
                output = i['output']
            elif "actions" in i:
                for action in i["actions"]:
                    actions = action.log
            elif "steps" in i:
                for step in i['steps']:
                    steps = step.observation
            yield [actions, steps, output]
    
    
    if VERSION == "V1":
        demo = gr.Interface(
            fn=search_V1,
            inputs=gr.Textbox(label="Enter a customer ID to get more information", placeholder="ID Here..."),
            outputs="text"
        )
    
    if VERSION == "V2":
        demo = gr.Interface(
            fn=search_V2,
            inputs=gr.Textbox(label="Enter a customer ID to get more information", placeholder="ID Here..."),
            outputs="text"
        )
    
    if VERSION == "V3":
        demo = gr.Interface(
            fn=search_V3,
            inputs=gr.Textbox(label="Enter a customer ID to get more information", placeholder="ID Here..."),
            outputs=[
                gr.Textbox(label="Agent thought"),
                gr.Textbox(label="Tool Result"),
                gr.Textbox(label="Final result")]
        )
    
    browser_path = os.getenv("DKU_CODE_STUDIO_BROWSER_PATH_7860")
    # replacing env var keys in browser_path with their values
    env_var_pattern = re.compile(r'(\${(.*)})')
    env_vars = env_var_pattern.findall(browser_path)
    for env_var in env_vars:
        browser_path = browser_path.replace(env_var[0], os.getenv(env_var[1], ''))
    
    # WARNING: make sure to use the same params as the ones defined below when calling the launch method,
    # otherwise you app might not be responding!
    demo.queue().launch(server_port=7860, root_path=browser_path)

---

## [tutorials/webapps/gradio/first-webapp/index]

# Gradio: your first web application

In this tutorial, you will learn how to build your first Gradio web application. To be able to create a Gradio application, you will first need to configure a Code Studio template and then code your application using this application. Once the application is designed, you can publish it as a web application.

## Prerequisites

  * Administrator permission to build the template

  * An LLM connection configured




## Building the Code Studio template

  * Go to the **Code Studios** tab in the **Administration** menu, click the **+Create Code Studio template** button, and choose a meaningful label (`gradio_template`, for example).

  * Click on the **Definition** tab.

  * Add a new **Visual Studio Code** block. This block will allow you to edit your Gradio application in a dedicated Code Studio.

  * Add a new **Gradio** block, and choose **Generate a dedicated code env** for the **Code env mode** , as shown in Figure 1.

  * Click the **Save** button.

  * Click the **Build** button to build the template.




Figure 1: Code Studio – Gradio block.

Your Code Studio template is ready to be used in a project. If you need a specific configuration for a block, please refer to [the documentation](<https://doc.dataiku.com/dss/latest/code-studios/index.html> "\(in Dataiku DSS v14\)"). If you want to generate your code environment to include other packages than Gradio, you should pin the Gradio version to 3.48.0.

## Creating a new Gradio application

Before creating your Gradio application, be sure to have a valid LLM ID. You can refer to [the documentation](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>) to retrieve an LLM ID.

  * Create a new project, click on **< /> > Code Studios**.

  * Click the **+New Code Studio** , choose the previously created template, choose a meaningful name, click the **Create** button, and then click the **Start Code Studio** button.

  * To edit the code of your Gradio application, click the highlighted tabs (**VS Code**) as shown in Figure 2.

  * Select the `gradio` subdirectory in the `code_studio-versioned` directory. Dataiku provides a sample application in the file `app.py`.

  * Replace the provided code with the code shown in Code 1. Replace the LLM_ID with your LLM_ID in the highlighted line.

  * If everything goes well, you should have a running Gradio application like the one shown in Figure 3.




Figure 2: Code Studio.

Figure 3: First Gradio application using a LLM.

## Wrapping up

You now have a running Gradio application. You can customize it a little to fit your needs. When you are happy with the result, you can click on the Publish button in the right panel. Then, your Gradio application is available for all users who can use it without running the Code Studio.

[`app.py`](<../../../../_downloads/e434cfad973a657f292dadc76e39e841/app.py>)

Code 1: First Gradio application
    
    
    import gradio as gr
    import os
    import re
    import dataiku
    
    LLM_ID = "YOUR_LLM_ID"
    
    browser_path = os.getenv("DKU_CODE_STUDIO_BROWSER_PATH_7860")
    env_var_pattern = re.compile(r'(\${(.*)})')
    env_vars = env_var_pattern.findall(browser_path)
    for env_var in env_vars:
        browser_path = browser_path.replace(env_var[0], os.getenv(env_var[1], ''))
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    
    def chat_function(message, history):
        completion = llm.new_completion()
        completion.with_message(message="You are a helpful assistant.")
        for msg in history:
            completion.with_message(message=msg[0], role="user")
            completion.with_message(message=msg[1], role="assistant")
        completion.with_message(message=message, role="user")
        resp_text = completion.execute().text
        return resp_text
    
    
    demo = gr.ChatInterface(fn=chat_function)
    demo.launch(server_port=7860, root_path=browser_path)

---

## [tutorials/webapps/gradio/index]

# Gradio  
  
  * [Gradio: your first web application](<first-webapp/index.html>)

  * [Creating a Gradio application using an LLM-based agent](<agent/index.html>)

---

## [tutorials/webapps/index]

# Webapps

This tutorial section contains learning material to master the development of Webapps, using various frameworks and backend types.

## Common subjects

  * [Accessible resources from webapps](<common/resources/index.html>)

  * [Creating an API endpoint from webapps](<common/api/index.html>)

  * [Querying the LLM from an headless API](<common/api-llm/index.html>)

  * [Impersonation with webapps](<common/impersonation/index.html>)




### Use your own Framework

  * [Basic setup: Code studio template](<code-studio/template/index.html>)

  * [Basic setup: Quickstart with Angular & Vue Templates](<code-studio/code-starters/index.html>)

  * [Basic setup: Deploy your web application](<code-studio/deployment/index.html>)

  * [Advanced setup: Code Studio template creation](<code-studio/configuring-code-studio/index.html>)

  * [Advanced setup: Web application creation and publication](<code-studio/web-application-creation/index.html>)




## Bokeh

  * [Bokeh: your first webapp](<bokeh/basics/index.html>)




## Dash

  * [Dash: your first webapp](<dash/basics/index.html>)

  * [Display a Bar chart using Dash](<dash/display-charts/index.html>)

  * [Simple administration dashboard](<dash/admin-dashboard/index.html>)

  * [Create a multi-page application](<dash/multi-page/index.html>)

  * [Upload or download files with Managed Folders in Dash](<dash/upload-download-files/index.html>)

  * [Create a form for data inputs](<dash/form-to-submit-values/index.html>)

  * [Simple scoring application](<dash/simple-scoring/index.html>)

  * [Listing and deleting a selection of projects](<dash/delete-projects/index.html>)




### GenAI

  * [Using Dash and LLM Mesh to build a GPT-powered web app assistant](<dash/chatGPT-web-assistant/index.html>)

  * [Creating a Dash application using an LLM-based agent](<dash/llm-based-agent/index.html>)

  * [Creating an API endpoint for using an LLM-Based agent](<dash/api-agent/index.html>)




## Gradio (GenAI)

  * [Gradio: your first web application](<gradio/first-webapp/index.html>)

  * [Creating a Gradio application using an LLM-based agent](<gradio/agent/index.html>)




## Standard (HTML, CSS, JS)

  * [HTML/CSS/JS: your first webapp](<standard/basics/index.html>)

  * [Adapt a d3js template in a Webapp](<standard/adapt-d3js-template/index.html>)

  * [Use custom static files](<standard/custom-static-files-kb/index.html>)

  * [Upload a file](<standard/upload-file-kb/index.html>)

  * [Download a file](<standard/download-file-kb/index.html>)

  * [Create a form for data inputs](<standard/form-to-submit-values/index.html>)

  * [Simple scoring application](<standard/simple-scoring/index.html>)




## Streamlit

  * [Streamlit: your first webapp](<streamlit/getting-started/index.html>)

  * [Create a Streamlit webapp in a Code Studio](<streamlit/basics/index.html>)




## Voilà (GenAI)

  * [Voilà: your first web application](<voila/first-webapp/index.html>)

  * [Creating a Voilà application using an LLM-based agent](<voila/agent/index.html>)

---

## [tutorials/webapps/standard/adapt-d3js-template/index]

# Adapt a D3.js Template in a Webapp

D3.js is a state-of-the-art library for data visualization. Check out the [D3.js gallery](<https://github.com/d3/d3/wiki/Gallery>) for stunning examples. Happily, many of these visualizations include their source code, so that you can easily duplicate them.

For example, [the parallel coordinates chart](<https://bl.ocks.org/mbostock/7586334>), shown in Fig. 1, created by Mike Bostock, is given with the generating D3 code and data! This is a cool and useful data viz that allows you to quickly visualize a multi-dimensional (but relatively small) dataset. You can immediately spot correlations across dimensions and uncover clusters. In this interactive visualization, you can explore the data in depth by filtering values on each dimension with a brush tool.

This brief tutorial replicates the parallel coordinates chart in a Dataiku webapp. In this tutorial, we will also cover how to use a specific version of D3.

Fig. 1: Example of a D3js parallel coordinates chart.

## Prerequisites

The tutorial on the basics of [standard Webapps](<../basics/index.html#draw-an-interactive-map-using-the-sfpd-crime-data>) is suggested, but not required.

## Upload the data and create a new webapp

The parallel coordinates chart is illustrated on a dataset of car specifications.

  * In a new blank project, create the cars dataset by uploading this [CSV file](<https://cdn.downloads.dataiku.com/public/website-additional-assets/data/cars.csv>).

  * From the Code menu, create a new code webapp, of the “standard” variety.

  * Choose a simple webapp to get started, and delete all of the sample code (in both HTML, CSS, and Javascript panels).




Fig. 2: New Webapp creation.

Fig. 3: Creation of a new standard Web Application.

Fig. 4: Creation of a new simple Webapp.

We first need access to the data and the needed libraries.

  * In the Settings tab, click on “Configure” in the Security section.

  * In the dataset list, find the cars dataset and allow the webapp to read it.

  * As we will use another version of D3 than the one proposed by default, we don’t have to check the “D3.js” javascript library, in the settings tabs.




Fig. 5: How to give read access permission to a dataset.

## Understand the overall code structure

Many D3 code samples, given in the [D3 gallery](<https://d3-graph-gallery.com/>) or [bl.ocks.org](<https://bl.ocks.org/>), have the same overall structure.

Code 1: Classical D3 code architecture.
    
    
    <!DOCTYPE html>
    <meta charset="utf-8"/>
    <style>
        /* CSS  code */     <!-- This goes in the CSS Panel-->
    </style>
    <body>
        <!-- HTML code -->  <!-- This goes in the HTML Panel-->
        <script src="https://d3js.org/d3.v3.min.js"></script>
        <script>
            // JS code      <!-- This goes in the Javascript Panel-->
        </script>
    </body>
    

To replicate the D3 visualizations in the webapp, we can copy the whole code inside the HTML panel, but most of the time, we dispatch the code into the three panels (HTML, CSS, and Javascript).

## Copying the HTML code

For the parallel coordinates chart example, we will use two HTML tags; one for importing the D3 library, and one for having a dedicated place where the chart will be displayed. So the content of the HTML panel is the code shown in Code 2.

Code 2: Content of the HTML panel for the parallel coordinates chart.
    
    
    <!-- Load d3.js -->
    <script src="https://d3js.org/d3.v7.min.js"></script>
    
    <!-- Create a div where the graph will take place -->
    <div id="my_dataviz"></div>
    

## Copying the CSS code

When there is the CSS code, defined within the `<style>` tags, you should copy it into the CSS panel of your editor. In this tutorial, we don’t have specific CSS tweaks, to insert or use. So the CSS Panel remains empty.

## Adapting the JS code

The trickiest part in adapting a D3 template is always to shape the data in the format required by the data viz. First, we will set up different parameters for the visualization. We will copy Code 3 into the javascript panel.

Code 3: Parameters for the visualization
    
    
    const margin = ({ top: 30, right: 50, bottom: 30, left: 50 })
    const width = document.querySelector('#my_dataviz').offsetWidth - margin.left - margin.right;
    const height = window.innerHeight - margin.top - margin.bottom;
    
    const svg = d3.select("#my_dataviz")
        .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform",
            `translate(${margin.left},${margin.top})`);
    
    const brushHeight = 50;
    const label = d => d.name
    const colors = d3.interpolateCool
    const deselectedColor = "#ddd"
    

In the parallel coordinates charts, the data in the D3 code is represented as the _cars_ JSON array. Generally, however, your source data is not in JSON format. In many D3 templates, the data is given as a CSV file, which is converted to JSON.

In the original D3 code, the data is thus read from the `cars.csv` file:
    
    
    // D3 code
    d3.csv("cars.csv", function(error, cars) {
        // D3 code
    });
    // D3 code
    

Then the D3 code defined inside the `d3.csv()` function is applied to the cars JSON array.

In our webapp, you will have to connect to your dataset (which can be stored in a great variety of formats and database systems) through the Dataiku JavaScript API.

To do this, we need to modify the JS code in two ways:

  * Without touching the body of the function, replace the original d3.csv() function name and parameters with the code below:




Code 4: Code for the data visualization.
    
    
    function parallelCoordinatesChart(data) {
        const keys = Object.keys(data.slice(1, 2)[0])
        keys.pop() // Drop the last column which is the name
        const keyz = keys[1]
    
        const x = new Map(Array.from(keys, key => [key, d3.scaleLinear(d3.extent(data, d => d[key]), [margin.left, width - margin.right])]))
        const y = d3.scalePoint(keys, [margin.top, height - margin.bottom])
        const z = d3.scaleSequential(x.get(keyz).domain().reverse(), colors)
    
        const line = d3.line()
            .defined(([, value]) => value != null)
            .x(([key, value]) => x.get(key)(value))
            .y(([key]) => y(key))
    
        const brush = d3.brushX()
            .extent([
                [margin.left, -(brushHeight / 2)],
                [width - margin.right, brushHeight / 2]
            ])
            .on("start brush end", brushed);
    
        const path = svg.append("g")
            .attr("fill", "none")
            .attr("stroke-width", 1.5)
            .attr("stroke-opacity", 0.4)
            .selectAll("path")
            .data(data.slice().sort((a, b) => d3.ascending(a[keyz], b[keyz])))
            .join("path")
            .attr("stroke", d => z(d[keyz]))
            .attr("d", d => line(d3.cross(keys, [d], (key, d) => [key, d[key]])));
    
        path.append("title")
            .text(label);
    
        svg.append("g")
            .selectAll("g")
            .data(keys)
            .join("g")
            .attr("transform", d => `translate(0,${y(d)})`)
            .each(function (d) { d3.select(this).call(d3.axisBottom(x.get(d))); })
            .call(g => g.append("text")
                .attr("x", margin.left)
                .attr("y", -6)
                .attr("text-anchor", "start")
                .attr("fill", "currentColor")
                .text(d => d))
            .call(g => g.selectAll("text")
                .clone(true).lower()
                .attr("fill", "none")
                .attr("stroke-width", 5)
                .attr("stroke-linejoin", "round")
                .attr("stroke", "white"))
            .call(brush);
    
        const selections = new Map();
    
        function brushed({ selection }, key) {
            if (selection === null) selections.delete(key);
            else selections.set(key, selection.map(x.get(key).invert));
            const selected = [];
            path.each(function (d) {
                const active = Array.from(selections).every(([key, [min, max]]) => d[key] >= min && d[key] <= max);
                d3.select(this).style("stroke", active ? z(d[keyz]) : deselectedColor);
                if (active) {
                    d3.select(this).raise();
                    selected.push(d);
                }
            });
            svg.property("value", selected).dispatch("input");
        }
    
        return svg.property("value", data).node();
    }
    

In other words, keep the entire D3 code unchanged, except for the call to the `d3.csv()` function, which is replaced by defining the `parallelCoordinatesChart()` function, which takes the _cars_ JSON array as input.

Now, we only need to connect to the _cars_ dataset through the Dataiku JS API, to create the corresponding cars JSON array. Recall that, when you gave permission for your webapp to read the cars dataset, an option to add a snippet calling to the `dataiku.fetch()` function could have been added.

  * Copy and paste the code below into the JS tab. This code creates the cars JSON array and calls the `parallelCoordinatesChart()` function to create the chart.




Code 5: Reading a dataset from the flow.
    
    
    dataiku.fetch('cars', function(dataFrame) {
        var columnNames = dataFrame.getColumnNames();
        function formatData(row) {
            var out = {};
            columnNames.forEach(function (col) {
                out[col]= col==='name' ? row[col] : +row[col];
            });
            return out;
        }
      var cars = dataFrame.mapRecords(formatData);
      parallelCoordinatesChart(cars);
    });
    

That’s it, you have a running D3 data viz in your webapp!

Fig. 6: The final result of the parallel coordinates chart.

## Troubleshooting

If you’re having trouble, be sure you have carefully followed all the steps. The best way to debug is to use the JS console in your browser with the webapp editor open.

Here are the complete versions of the code presented in this tutorial:

HTML Code
    
    
    <!-- Load d3.js -->
    <script src="https://d3js.org/d3.v7.min.js"></script>
    
    <!-- Create a div where the graph will take place -->
    <div id="my_dataviz"></div>
    

JS Code
    
    
    const margin = ({top: 30, right: 50, bottom: 30, left: 50})
    const width = document.querySelector('#my_dataviz').offsetWidth - margin.left - margin.right;
    const height = window.innerHeight - margin.top - margin.bottom;
    
    const svg = d3.select("#my_dataviz")
        .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform",
            `translate(${margin.left},${margin.top})`);
    
    const brushHeight = 50;
    const label = d => d.name
    const colors = d3.interpolateCool
    const deselectedColor = "#ddd"
    
    // D3 code
    function parallelCoordinatesChart(data) {
        const keys = Object.keys(data.slice(1, 2)[0])
        keys.pop() // Drop the last column which is the name
        const keyz = keys[1]
    
        const x = new Map(Array.from(keys, key => [key, d3.scaleLinear(d3.extent(data, d => d[key]), [margin.left, width - margin.right])]))
        const y = d3.scalePoint(keys, [margin.top, height - margin.bottom])
        const z = d3.scaleSequential(x.get(keyz).domain().reverse(), colors)
    
        const line = d3.line()
            .defined(([, value]) => value != null)
            .x(([key, value]) => x.get(key)(value))
            .y(([key]) => y(key))
    
        const brush = d3.brushX()
            .extent([
                [margin.left, -(brushHeight / 2)],
                [width - margin.right, brushHeight / 2]
            ])
            .on("start brush end", brushed);
    
        const path = svg.append("g")
            .attr("fill", "none")
            .attr("stroke-width", 1.5)
            .attr("stroke-opacity", 0.4)
            .selectAll("path")
            .data(data.slice().sort((a, b) => d3.ascending(a[keyz], b[keyz])))
            .join("path")
            .attr("stroke", d => z(d[keyz]))
            .attr("d", d => line(d3.cross(keys, [d], (key, d) => [key, d[key]])));
    
        path.append("title")
            .text(label);
    
        svg.append("g")
            .selectAll("g")
            .data(keys)
            .join("g")
            .attr("transform", d => `translate(0,${y(d)})`)
            .each(function (d) {
                d3.select(this).call(d3.axisBottom(x.get(d)));
            })
            .call(g => g.append("text")
                .attr("x", margin.left)
                .attr("y", -6)
                .attr("text-anchor", "start")
                .attr("fill", "currentColor")
                .text(d => d))
            .call(g => g.selectAll("text")
                .clone(true).lower()
                .attr("fill", "none")
                .attr("stroke-width", 5)
                .attr("stroke-linejoin", "round")
                .attr("stroke", "white"))
            .call(brush);
    
        const selections = new Map();
    
        function brushed({selection}, key) {
            if (selection === null) selections.delete(key);
            else selections.set(key, selection.map(x.get(key).invert));
            const selected = [];
            path.each(function (d) {
                const active = Array.from(selections).every(([key, [min, max]]) => d[key] >= min && d[key] <= max);
                d3.select(this).style("stroke", active ? z(d[keyz]) : deselectedColor);
                if (active) {
                    d3.select(this).raise();
                    selected.push(d);
                }
            });
            svg.property("value", selected).dispatch("input");
        }
    
        return svg.property("value", data).node();
    }
    
    // D3 code
    
    dataiku.fetch('cars', function (dataFrame) {
        var columnNames = dataFrame.getColumnNames();
    
        function formatData(row) {
            var out = {};
            columnNames.forEach(function (col) {
                out[col] = col === 'name' ? row[col] : +row[col];
            });
            return out;
        }
    
        var cars = dataFrame.mapRecords(formatData);
        parallelCoordinatesChart(cars);
    });

---

## [tutorials/webapps/standard/basics/index]

# HTML/CSS/JS: your first webapp

In this tutorial, you will create a Dataiku Webapp using HTML, JavaScript, and a Flask-powered Python backend to draw a map of San Francisco reflecting the number of crimes by year and location. A few preliminary steps are done using visual features, but the Webapp part relies entirely on code.

## Prerequisites

  * Some familiarity with HTML and JavaScript for the front-end

  * Some familiarity with Python for the backend




## Supporting data

We will work with the [San Francisco Police Department Crime Incidents](<https://data.sfgov.org/Public-Safety/SFPD-Incidents-from-1-January-2003/tmnf-yvry>) data used under the [Open Data Commons PDDL](<https://opendatacommons.org/licenses/pddl/>) license.

## Prepare the Project and the Dataset

From the Dataiku homepage, go to _New Project - > Learning projects -> Developer -> SFPD Incidents_.

If you want to start from a blank Project, you can download and import the data from the [San Francisco Open Data Portal](<https://data.sfgov.org/Public-Safety/SFPD-Incidents-from-1-January-2003/tmnf-yvry>).

Your map will display the data with year-based filters: To do that efficiently, you will need to create a new enriched Dataset with a “year” column:

  * Select the Dataset and **create a new Prepare recipe** with an output Dataset called `sfpd_enriched`.

  * In the Prepare recipe’s script, parse the “Date” column.

  * From the parsed date, add a new **Extract date components** step to the script and only extract the year to a new column named “year”. Leave the other column name fields empty.

  * Rename columns “X” to `longitude` and “Y” to `latitude`.

  * Run the Prepare recipe.




## Create the Webapp

  * In the top navigation bar, go to _< /> -> Webapps_.

  * Click on _\+ New Webapp_ on the top right, then select _Code Webapp > Standard_.

  * Select the _Starter code for creating map visualizations_ template and give a name to your newly-created Webapp.




## Configure the Webapp settings

Since we will be reading a Dataset, we must first authorize its access. From the Webapp interface:

  * Go to _Settings - > Show legacy settings -> Configure_.

  * Look up the `sfpd_enriched` Dataset, and under “Authorizations,” select “Read data.”

  * Save the settings.




Note

The _“Add snippet to read dataset (and authorize it)”_ link comes in handy when you want to add a piece of JavaScript code automatically formatted to give you access to your Dataset’s data. You won’t have to use it here because the template already contains the relevant code.

Since we will be rendering the dataset using the D3 library, we must add it. From the Webapp interface:

  * Go to _Settings - > Show legacy settings -> Javascript libraries_.

  * Enable the `D3.js` library.

  * Save the settings.




## Initialize the map

The starter code renders a default map with no data centered on France. To center it on San Francisco, change the way the `map` variable is created in the JavaScript code:
    
    
    // Create a Map centered on San Francisco
    
    
    // Leaflet's `setView` method sets the geographical center and zoom level of the map.
    var map = L.map('map').setView([37.76, -122.4487], 11); // (1)
    

Click on _Save_ to update the preview output. Your map is now ready! You can start adding some data to it.

## Create the backend processing function

While your Webapp can retrieve the contents of a Dataset using JavaScript, given the size of the Dataset, it may not be optimal to load it all in the browser. Instead, you will use a Python backend to load the Dataset into a Pandas DataFrame, filter it by year, and aggregate it by area.

  * In the “JS” tab, remove all the code associated with the `dataiku.fetch()` method. Only the `map` and `cartodb` variables should remain, as well as the `map.addLayer(cartodb);` statement.

  * In the “Python” tab, click “Enable” to launch the backend.

  * Replace the generated boilerplate Python code with the following :



    
    
    import dataiku
    import pandas as pd
    import json
    
    sfpd = dataiku.Dataset("sfpd_enriched").get_dataframe()
    # Only keep valid locations and criminial incidents
    sfpd = sfpd[(sfpd.longitude!=0) & (sfpd.latitude!=0) & (sfpd.Category!="NON-CRIMINAL")]
    
    # The Python backend is implemented with Flask. It reuses the concept of routes to map the data exchanges with the frontend.
    
    @app.route('/Count_crime')
    def count_crime():
        year = 2014
        # Filter data for the chosen year
        tab = sfpd[["longitude", "latitude"]][(sfpd.year == year)]
    
        # Group incident locations into bins
        x_bin = pd.cut(tab.longitude, 25, retbins=True, labels=False)
        y_bin = pd.cut(tab.latitude, 25, retbins=True, labels=False)
        tab["longitude"] = x_bin[0]
        tab["latitude"] = y_bin[0]
        tab["C"] = 1
    
        # Group incidents by binned locations and count them
        gp = tab.groupby(["longitude", "latitude"])
        df = gp["C"].count().reset_index()
        max_cr = max(df.C)
        min_cr = min(df.C)
        gp_js = df.to_json(orient="records")
    
        # Return a JSON-formatted string containing incident counts by location and location limits
        return json.dumps({
            "bin_x": list(x_bin[1]),
            "bin_y": list(y_bin[1]),
            "nb_crimes": eval(gp_js),
            "min_nb": min_cr,
            "max_nb": max_cr
            })
    

## Make the frontend query data from the backend

Add the following code to the “JS” tab to query the backend and draw the resulting data on the map:
    
    
    // This function calls the `Count_crime` endpoint of the backend to retrieve the lattice into the `data` variable.
    // It then goes through each lattice square to draw it on the map with a proper color (the more red, the more crimes).
    
    var draw_map = function () { // (1)
        // Request aggregated data from the backend
        $.getJSON(getWebAppBackendUrl('Count_crime')).done(function (data) {
            // Draw data on the map using d3.js
            var cmap = d3.scale.sqrt()
                .domain([data.min_nb, data.max_nb])
                .range(["steelblue", "red"])
                .interpolate(d3.interpolateHcl);
    
            for (var i = 0; i < data.nb_crimes.length; i++) {
                // Retrieve square corner
                c_1 = [data.bin_y[data.nb_crimes[i].latitude], data.bin_x[data.nb_crimes[i].longitude]];
                c_2 = [data.bin_y[data.nb_crimes[i].latitude], data.bin_x[data.nb_crimes[i].longitude + 1]];
                c_3 = [data.bin_y[data.nb_crimes[i].latitude + 1], data.bin_x[data.nb_crimes[i].longitude + 1]];
                c_4 = [data.bin_y[data.nb_crimes[i].latitude + 1], data.bin_x[data.nb_crimes[i].longitude]];
    
                // Draw square coloured by the number of crimes
                var polygon = L.polygon([c_1, c_2, c_3, c_4], {
                    fillOpacity: 0.4,
                    clickable: false,
                    color: cmap(data.nb_crimes[i].C)
                })
                    .addTo(map);
            }
        });
    };
    draw_map();
    

Excellent! You now have the map of San Francisco with a transparent lattice representing the number of crimes by area for 2014.

What if it doesn’t work?

If the lattice doesn’t appear, you can check for errors in two places:

  * Backend errors will appear in the “Log” tab. Don’t forget to refresh the logs to get the most recent events.

  * Frontend (JS) errors will appear in the JavaScript console of your browser’s developer tools interface.

    * Chrome: _View - > Developer -> JavaScript console_

    * Firefox: _Tools - > Browser Tools -> Web Developer Tools_, then look for the “Console” tab




## Add interactivity to your map

Besides the zoom level adjustment, your Webapp isn’t very interactive yet. In this final section, you will add a slider allowing the user to select the year for which data should be displayed. Every time the user moves the slider, the backend will be called to process the relevant data accordingly.

First, you need to edit the code in the “HTML” tab to source the jQuery add-ons:
    
    
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"></link>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    

Still, in the “HTML” tab, add an anchor for the slider and an input to display the selected year. The exact placement is up to you! In the following code, it is placed directly above the `<h1>` heading:
    
    
    <p>
        <label for="amount"> Year: </label>
        <input type="text" id="amount" readonly style="border:0; color:#f6931f; font-weight:bold;"></input>
    </p>
    <div id="slider"></div>
    

In the “JS” tab, change the `draw_map()` function to pass the selected year to the backend. As shown below, two changes are required:

  * Passing the `year` argument to the function.

  * Add the `{year: year}` JSON in the request sent to the backend.



    
    
    var draw_map = function(year) {
        // Request aggregated data from the backend
        $.getJSON(getWebAppBackendUrl('Count_crime'), {year: year})
            .done(
                function(data) {
                    // ...
                });
            }
    

In the “Python” tab, you will now add some code to dynamically retrieve the values related to a given year. To do so, you first need to add an import statement:
    
    
    from flask import request
    

Now you can edit the `count_crime()` function to dynamically retrieve data depending on the year:
    
    
    @app.route('/Count_crime')
    def count_crime():
        year = int(request.args.get("year"))
        # ...
    

Finally, add a slider to move within a given year range on your page. At every value change, it should also clear the map. To do so, add the following code to the “JS” tab:
    
    
    function clearMap() {
        for (i in map._layers) {
            if (map._layers[i]._path != undefined) {
                try {
                    map.removeLayer(map._layers[i]);
                } catch(e) {
                    console.log("Problem with " + e + map._layers[i]);
                }
            }
        }
    }
    
    $('#slider').slider({
        value: 2014,
        min: 2004,
        max: 2014,
        step: 1,
        create: function(event, ui) {
            $('#amount').val($(this).slider('value'));
            draw_map($(this).slider('value'));
        },
        change: function(event, ui) {
            $('#amount').val(ui.value);
            clearMap();
            draw_map(ui.value);
        }
    });
    
    $('#amount').val($('#slider').slider('value'));
    

You now have a dynamic, interactive map, congratulations!

## Next steps

Now that your webapp is finished, you can publish it on a [Dashboard](<https://doc.dataiku.com/dss/latest/dashboards/index.html>). If you want to improve it further, there are several possibilities, for example:

  * Factoring in more contextual data, for example, by overlaying [business areas](<https://data.sfgov.org/Economy-and-Community/Registered-Business-Locations-San-Francisco/g8m3-pdis>) or more exotic data, like [street trees](<https://data.sfgov.org/City-Infrastructure/Street-Tree-List/tkzw-k3nq>).

  * Try out one of the other Webapp frameworks, like [Dash](<https://doc.dataiku.com/dss/latest/webapps/dash.html>).




For more details on Webapps in Dataiku, don’t forget to read the [Reference Documentation](<https://doc.dataiku.com/dss/latest/webapps/index.html>).

Here are the complete versions of the code presented in this tutorial:

[HTML Code](<../../../../_downloads/02b9c4dafcae02885d7675a7e16d8074/code.html>)
    
    
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    
    <!-- Body of your app -->
    <div class="container">
        <p>
            <label for="amount"> Year: </label>
            <input type="text" id="amount" readonly style="border:0; color:#f6931f; font-weight:bold;"/>
        </p>
        <div id="slider"></div>
        <h1>Geo analysis</h1>
        <p class="lead">A short legend</p>
        <hr/>
        <div class="row">
            <div class="col-md-9" id="map"></div>
            <div class="col-md-3"><strong>Description</strong>
                <p>
                    For better communication, all insights should have a small explanation.
                </p>
            </div>
        </div>
    </div>
    

[CSS Code](<../../../../_downloads/7f82f33fd048fa2504c57f020dc3d712/code.css>)
    
    
    #map {
    	height: 400px;
    }
    

[JS Code](<../../../../_downloads/2fb8408821a76f32b74813153406043c/code.js>)
    
    
    // Create a Map
    var map = L.map('map').setView([37.76, -122.4487], 11);
    
    // Add an OpenStreetMap(c) based background
    var cartodb = new L.tileLayer(
        'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>'
        })
    map.addLayer(cartodb);
    
    // This function calls the `Count_crime` endpoint of the backend to retrieve the lattice into the `data` variable. It then goes through each lattice square to draw it on the map with a proper color (the more red, the more crimes).
    var draw_map = function (year) { // (1)
        // Request aggregated data from the backend
        $.getJSON(getWebAppBackendUrl('Count_crime'), {year: year}).done(function (data) {
            // Draw data on the map using d3.js
            var cmap = d3.scale.sqrt()
                .domain([data.min_nb, data.max_nb])
                .range(["steelblue", "red"])
                .interpolate(d3.interpolateHcl);
    
            for (var i = 0; i < data.nb_crimes.length; i++) {
                // Retrieve square corner
                c_1 = [data.bin_y[data.nb_crimes[i].latitude], data.bin_x[data.nb_crimes[i].longitude]];
                c_2 = [data.bin_y[data.nb_crimes[i].latitude], data.bin_x[data.nb_crimes[i].longitude + 1]];
                c_3 = [data.bin_y[data.nb_crimes[i].latitude + 1], data.bin_x[data.nb_crimes[i].longitude + 1]];
                c_4 = [data.bin_y[data.nb_crimes[i].latitude + 1], data.bin_x[data.nb_crimes[i].longitude]];
    
                // Draw square coloured by the number of crimes
                var polygon = L.polygon([c_1, c_2, c_3, c_4], {
                    fillOpacity: 0.4,
                    clickable: false,
                    color: cmap(data.nb_crimes[i].C)
                })
                    .addTo(map);
            }
        });
    };
    
    function clearMap() {
        for (i in map._layers) {
            if (map._layers[i]._path != undefined) {
                try {
                    map.removeLayer(map._layers[i]);
                } catch (e) {
                    console.log("Problem with " + e + map._layers[i]);
                }
            }
        }
    }
    
    $('#slider').slider({
        value: 2014,
        min: 2004,
        max: 2014,
        step: 1,
        create: function (event, ui) {
            $('#amount').val($(this).slider('value'));
            draw_map($(this).slider('value'));
        },
        change: function (event, ui) {
            $('#amount').val(ui.value);
            clearMap();
            draw_map(ui.value);
        }
    });
    
    $('#amount').val($('#slider').slider('value'));
    

[Python Code](<../../../../_downloads/eabfbce8d37b654364b1c53f940885a0/code.py>)
    
    
    import dataiku
    import pandas as pd
    import json
    from flask import request
    
    sfpd = dataiku.Dataset("sfpd_enriched").get_dataframe()
    # Only keep valid locations and criminial incidents
    sfpd = sfpd[(sfpd.longitude != 0) & (sfpd.latitude != 0) & (sfpd.Category != "NON-CRIMINAL")]
    
    
    # The Python backend is implemented with Flask. It reuses the concept of routes to map the data exchanges with the frontend.
    
    @app.route('/Count_crime')
    def count_crime():
        year = int(request.args.get("year"))
        # Filter data for the chosen year
        tab = sfpd[["longitude", "latitude"]][(sfpd.year == year)]
    
        # Group incident locations into bins
        x_bin = pd.cut(tab.longitude, 25, retbins=True, labels=False)
        y_bin = pd.cut(tab.latitude, 25, retbins=True, labels=False)
        tab["longitude"] = x_bin[0]
        tab["latitude"] = y_bin[0]
        tab["C"] = 1
    
        # Group incidents by binned locations and count them
        gp = tab.groupby(["longitude", "latitude"])
        df = gp["C"].count().reset_index()
        max_cr = max(df.C)
        min_cr = min(df.C)
        gp_js = df.to_json(orient="records")
    
        # Return a JSON-formatted string containing incident counts by location and location limits
        return json.dumps({
            "bin_x": list(x_bin[1]),
            "bin_y": list(y_bin[1]),
            "nb_crimes": eval(gp_js),
            "min_nb": min_cr,
            "max_nb": max_cr
        })

---

## [tutorials/webapps/standard/custom-static-files-kb/index]

# Use Custom Static Files (Javascript, CSS) in a Webapp

In addition to the JavaScript or CSS you type in a [standard webapp](<https://doc.dataiku.com/dss/latest/webapps/standard.html>), you may want to use certain code libraries.

Dataiku comes with some embedded standard JS libraries (jQuery, boostrap, etc). Just go to the “Settings” tab of the webapp editor to activate them.

If the library you are looking for is not available in Dataiku, a quick way to load it, if your library is already hosted, is to simply link from your HTML:
    
    
    <script type="text/javascript" src='https://www.gstatic.com/charts/loader.js'></script>
    

Dataiku also has a “static” folder where you can place static content (JavaScript, CSS, images) that will be served by Dataiku and available to your webapps.

There are two ways to move files to that folder:

  * using the web interface or

  * using the command line.




## Import Libraries using the Graphical Interface

If you have admin rights on your Dataiku instance, you can click on the Application menu near the top-right corner. Select **Global Shared Code** and navigate to the “Static Web Resources” tab on the right.

You can either create and edit files within Dataiku, or upload your files.

## Import Libraries using the Command Line

If you have many files to import, you may want to use the command line. Here is how:

  * Navigate to the [Dataiku Data Directory](<https://doc.dataiku.com/dss/latest/operations/datadir.html>).

  * Check for the presence of a `local/static` directory. Create it if needed. Inside a terminal, enter:



    
    
    mkdir -p local/static
    

  * Copy your static files into this directory. For instance, you might copy your team’s CSS and JavaScript common files.




## Using Static Files in your Webapp

Once they are in, you can use the static files from the HTML code of your webapp as in the following example. (Note that there is a ‘/’ before “local”).
    
    
    <script type="text/javascript" src="/local/static/my-team.js" />
    <link rel="stylesheet" href="/local/static/my-team.css" />
    <img src="/local/static/my-image.jpg" />
    

That’s it! You can now use your favorite Javascript or CSS libs in Dataiku!

Tip

A word of further explanation: This works thanks to `DATA_DIR/nginx/conf/nginx.conf`, which maps `/local/static/` to `dss-data-dir/local/static/`.

---

## [tutorials/webapps/standard/download-file-kb/index]

# Downloading from a Dataiku Webapp

When building a webapp in Dataiku, you may want to allow users to download a file from a [managed folder](<https://doc.dataiku.com/dss/latest/connecting/managed_folders.html>). Here are steps to build an HTML button, which will allow webapp users to download files stored in a managed folder.

## Basic Download

Here’s how you can download a file from a managed folder by clicking on a button in a webapp.

In the Python part of the webapp, define an endpoint like:
    
    
    import dataiku
    from flask import request
    from flask import send_file
    import io
    @app.route('/downloadFile')
    def first_call():
        filename = request.args.get('filename')
        stream = dataiku.Folder('FOLDER_ID').get_download_stream(filename)
        with stream:
            return send_file(
                io.BytesIO(stream.read()),
                as_attachment=True,
                attachment_filename=filename)
    

Then in the Javascript section, you’d need a function like:
    
    
    window.download = function(){
        window.location.href = getWebAppBackendUrl('/downloadFile?filename=test.txt');
    }
    

Finally, in the HTML you can add a button to trigger that JS function:
    
    
    <button onclick="download()">Download</button>
    

## What’s Next?

To learn more about webapps in Dataiku, visit the [documentation](<https://doc.dataiku.com/dss/latest/webapps/index.html> "\(in Dataiku DSS v14\)").

---

## [tutorials/webapps/standard/form-to-submit-values/index]

# How to create a form for data input?

## Context

In this tutorial, we want to explain all the concepts used when we write a webapp for interacting with Dataiku objects. This tutorial presents some fundamental concepts for writing a webapp. Many of these concepts are not Dataiku concepts but are widely used concepts. Our “top -> bottom -> top” approach lets you understand why you must do or modify the code. The provided code only covers some options for writing a webapp. You will learn how to send a request from the frontend to the backend. You will also learn how to deal with the backend’s response.

## Webapp creation

  * In the top navigation bar, go to **< /> –> Webapps**.

  * Click on **\+ New webapp** on the top right, then select **Code webapp > Standard**, as shown in Fig. 1.

  * Select any template you want and give a name to your newly-created Webapp (for example, `Simple form webapp`).




Fig. 1: Creation of a standard web app.

Once the webapp is open, click on the **Settings** tab, **Python** , and click on **Enable** as shown in Fig. 2, to enable Python backend, we will use it later. Then, go to the **HTML** tab, and remove everything; we will construct the form from the beginning. Do the same for the **CSS** and **JS** tabs. Go to the **Settings** tab and verify that the `DataikuAPI` and `JQuery` libraries are checked.

Fig. 2: How to enable python backend.

## First form creation

### HTML

Now that we have an empty webapp, we can focus on the form creation. In HTML, a `form` is part of a document containing interactive controls for submitting information. A form can have many inputs but only one output (the data). In this tutorial, we will first focus on the processing, that is:

  * create the form;

  * retrieve the data from the javascript part;

  * send the data to the backend;

  * process the data on the backend.




Once the processing is finished, we will make the form more attractive by adding CSS.

To create a form, go to the HTML Tab, and copy Code 1.

Code 1: First form
    
    
    1<form action="" method="" onsubmit="send_data(event)">
    2    <label for="name">Enter your name: </label>
    3    <input type="text" name="name" id="name" required />
    4    <input type="submit" value="Validate" />
    5</form>
    

It is an elementary form, but we have many things to learn. On line 1, the `form` has three parameters:

  * `action`: represents the default URL that processes the form submission. A `formaction` attribute, for `button` or `input`, can override it. As Dataiku runs the webapp, we do not know in advance the running context (particularly the URL of the webapp), so we let it empty.

  * `method`: is the HTTP verb for sending the request to the URL defined in `action`. This attribute can be omitted.

  * `onsubmit`: is a call to a javascript function (which will be defined after) for validating the form. We will use this function to process the form.




The `for` attribute of the `label` tag refers to the `id` attribute of another HTML tag; here, it is the text input. It helps the user to select the input. If the user clicks on the input or the associated label text, the focus will be on the input.

### Javascript

Now, go to the JS tab, and copy Code 2. This code defines the function `send_data` responsible for sending data to the python backend (line 1) and adds it to the HTML “scope.” This function prevents the default behavior of an HTML form submission (call to `action`) in line 2. Lines 3–4 prepare the data needed for the python backend call, and line 5 makes the request.

Code 2: Javascript function to send data to the python backend
    
    
     1window.send_data = function (event) {
     2  event.preventDefault()
     3  param = makeRequestParam()
     4  let url = getWebAppBackendUrl('/first_form')
     5  fetch(url, param)
     6}
     7
     8function getName () {
     9  return $('#name').val()
    10}
    11
    12function makeRequestParam() {
    13  let data = {
    14    "name": getName()
    15  }
    16  return {
    17    "method": 'POST',
    18    "headers": {
    19      'Content-Type': 'application/json',
    20    },
    21    "body": JSON.stringify(data)
    22  }
    23}
    

The function `getName` is a simple [JQuery](<https://jquery.com/>) call to retrieve the value entered in the input with the id: `name`.

An HTTP request is composed of the following:

  * A verb: one among the verbs: GET, POST, PUT, DELETE, PATCH, OPTIONS, CONNECT, TRACE, HEAD. For more about verb-defined semantics, please refer to [HTTP Request methods](<https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods>).

  * A URL that identifies the resource we want to query.

  * A content.




The function `makeRequestParam` retrieves the data and make a JSON Object with those data (line 13 – 15). Then it builds the complete parameter of the request sent to the python backend.

As we want to pass data to the python backend, we have to provide content with those data. We will use a JSON Object for this purpose, so the content type should be `application/json` (line 19). The body of the request is the JSON object, line 21.

The `fetch` function, line 5, is a native javascript function that easily handles HTTP requests over the network.

### Backend (Python)

Go to the **Python** tabs, and copy Code 3.

Code 3: The very first version of the python backend
    
    
    from flask import request
    import logging
    
    # Example:
    # As the Python webapp backend is a Flask app, refer to the Flask
    # documentation for more information about how to adapt this
    # example to your needs.
    # From JavaScript, you can access the defined endpoints using
    # getWebAppBackendUrl('first_api_call')
    
    @app.route('/first_form', methods=['POST', 'PUT'])
    def first_form():
        logging.info(request.get_json())
        return "ok"
    

The backend will run the associated function when it receives a request on the route `/first-form` with the verb `PUT` (or `POST`). As the backend is a Flask application, it requires returning something. Usually, we have to produce a response. For now, we return a string, which is not used, but this is enough for the webapp to be able to work. We can now run the webapp and see that when a user enters something in the input and validates it, the backend logs the input. To see the logs, go to the **Log** and click on the “Refresh log” button. Fig. 3 represents the webapp workflow, where solid lines are the actual state of the form. And the dotted ones are the next steps for having a fully working form.

Fig. 3: Webapp workflow.

## Send back the response to the user interface

Sometimes, we need to inform the user that the processing has ended. We could also give feedback to the caller. That is why we should return a Response in the python backend once the process is finished. An HTTP response (and so the flask response) is composed of:

  * A status code: for more about the status code, please refer to [HTTP Status code](<https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>) documentation.

  * Possibly a body

  * Some other standard parameters of HTTP.




In an ideal world, choosing the correct HTTP status code is as crucial as selecting the proper verb for the request. There are two ways to complete a request: success or failure. The request should always succeed in our case, as we are only logging data. So the response should indicate a success so we will choose the 200 status code. Code 4 is the new version of the python backend for sending a response to the javascript part.

Code 4: Python backend responding to a request.
    
    
    from flask import Response, request
    import logging
    import json
    
    
    @app.route('/first_form', methods=['POST', 'PUT'])
    def first_form():
        """
        Process the request sent from the frontend.
    
        :return: a response containing the data coming from the request.
        """
        request_body = request.get_json()
        logging.info(request_body)
    
        response = Response(response=json.dumps(request_body),
                            status=200,
                            mimetype='application/json')
        response.headers["Content-Type"] = "text/json; charset=utf-8"
        return response
    

## Processing the response

The backend responds to the caller (the javascript code). As a consequence, we can provide some feedback to the user. But before coding the javascript part, we need to understand the asynchronicity concept. Asynchronous communication is like sending a mail to a teammate. The writer sends a message. Then the recipient reads and responds to the message when available. Afterward, the requester (the writer) can read the response when available. This is asynchronous communication. As nobody waits for the other, they can go about their business. For HTTP requests/responses, it is the same. We have already seen how to implement the recipient part (python backend) and how the writer sends a message (javascript part).

The function responsible for sending a request to the backend is the `fetch` function in the javascript code (line 5, Code 2). This function implements a mechanism called [promise](<https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise>), and promise can be chained with the `then (callbackSuccess, callbackFailure)` method, which can also be chained with `then`. You can omit the `callbackFailure`, either if you don’t plan to handle the failure (which might not be a good idea) or if you plan to address the overall miss with a `catch(callbackFailure)`. We can write the callbacks with [Arrow functions](<https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions>), which leads to elegant code to handle promises.

Code 5: How to handle promise in javascript.
    
    
    const promise = fetch(url, param)
    
    function displayResponseCode(response) {
        console.log(`Response Code: ${response.status}`)
    }
    
    // Handle both Success and Failure with then
    promise.then(displayResponseCode, displayResponseCode)
    
    // Alternatively
    promise
        .then(displayResponseCode)
        .catch(displayResponseCode)
    

As our backend returns JSON data, we need to retrieve them from the response using the [json()](<https://developer.mozilla.org/en-US/docs/Web/API/Response/json>) method, which produces a promise. So this leads to Code 6, more likely, to Code 7.

Code 6: Handling the response.
    
    
     window.send_data = function (e) {
      e.preventDefault()
      param = makeRequestParam()
      let url = getWebAppBackendUrl('/first_form')
      fetch(url, param)
        .then(extractJSON)
        .then(displayResponse)
        .catch((error) => console.log(error))
      return false
    }
    
    function extractJSON(response) {
      return response.json()
    }
    
    function displayResponse(response) {
      console.log(`JSON Response: ${JSON.stringify(response)}`)
    }
    
    // ...
    

Code 7: Handling the response (with explicit parameters).
    
    
     window.send_data = function (e) {
      e.preventDefault()
      param = makeRequestParam()
      let url = getWebAppBackendUrl('/first_form')
      fetch(url, param)
        .then((response) => extractJSON(response))
        .then((json) => displayResponse(json))
        .catch((error) => console.log(error))
    
      return false
    }
    
    function extractJSON(response) {
      return response.json()
    }
    
    function displayResponse(response) {
      console.log(`JSON Response: ${JSON.stringify(response)}`)
    }
    
    // ...
    

## Giving feedback to the user

Finally, we can display feedback to the user. Giving feedback to the user is done in two steps:

  * Changing the initial HTML file to add a dedicated zone for feedback.

  * Modifying the HTML from the javascript to reflect changes.




We will rely on the show()/hide() Jquery mechanism to give feedback to the user. Code 8 shows the slight modifications we make to enable feedback. The `style="display: none;"` prevents the `p` from being displayed. But the `p` element exists, so we can show it as needed in the Javascript, Code 9, by modifying the `displayResponse` function.

Code 8: HTML form with an element for feedback.
    
    
    <form action="" method="" onsubmit="send_data(event)">
        <label for="name">Enter your name: </label>
        <input type="text" name="name" id="name" required />
        <input type="submit" value="Validate"/>
    </form>
    
    <p id="feedback" style="display: none;">
        User feedback
    </p>
    

Code 9: Giving feedback to the user.
    
    
    function displayResponse(response) {
        let message = `The server respond ${JSON.stringify(response)}`
        $("#feedback").text(message).show()
    }
    

## Make it more attractive

We will rely on the [Bootstrap library](<https://getbootstrap.com/>) to make the form more attractive. A library helps speed development and provides some friendly components without writing too many CSS lines. Add the bootstrap library into your HTML, and then use it. Code 10 is one possible use of this library.

Code 10: A form using bootstrap
    
    
    <link href="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
    
    <div class="container-fluid">
        <form action="" method="" onsubmit="send_data(event)">
            <div class="mb-3">
                <label for="name" class="form-label">Enter your name: </label>
                <input type="text" class="form-control" name="name" id="name" required />
            </div>
            <button type="submit" class="btn btn-primary">Validate</button>
        </form>
    
        <div class="toast-container position-fixed bottom-50 p-3">
          <div id="liveToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
              <strong class="me-auto">Dataiku webapp -- Simple form</strong>
              <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body" id="feedback">
              Hello, world! This is a toast message.
            </div>
          </div>
        </div>
    </div>
    

Code 11: Changing the javascript to use “Toast”
    
    
    ...
    const toastLiveExample = document.getElementById('liveToast')
    
    function displayResponse(response) {
        let message = `The server respond ${JSON.stringify(response)}`
        const toast = new bootstrap.Toast(toastLiveExample)
        $("#feedback").text(message)
        toast.show()
    }
    ...
    

## Do something interesting with the backend

We will use the form to append data to an existing dataset. The backend is responsible for the processing. So we need to modify the backend to add the data sent by the frontend. Read the **existing** dataset, add a row to this dataset, and write the result. There are many ways to do that; Code 12 is an example of how to process to add data to an existing dataset.

Code 12: Adding data to a dataset
    
    
    import dataiku
    import pandas as pd
    from flask import Response, request
    import logging
    import json
    
    
    @app.route('/first_form', methods=['POST', 'PUT'])
    def first_form():
        """
        Process the request sent from the frontend.
    
        :return: a response containing the data coming from the request.
        """
        request_body = request.get_json()
        resp = add_json_to_dataset(request_body)
    
    
        response = Response(response=json.dumps(resp),
                            status=resp['status'],
                            mimetype='application/json')
        response.headers["Content-Type"] = "text/json; charset=utf-8"
        return response
    
    
    def add_content_to_dataset(name, json):
        """
        Add a new row in JSON format to an existing data.
        :param name: Name of the dataset.
        :param json: Value to append.
        """
        dataset = dataiku.Dataset(name)
        df = dataset.get_dataframe()
        df = df.append(json, ignore_index=True)
        logging.info(df.head())
        dataset.write_dataframe(df)
    
    
    def add_json_to_dataset(json):
        """
        Add a row to a dataset, only if the dataset exists.
        :param json: Value to add.
        :return: a dict representing the result of the addition.
        """
    
        # This could be a part of data sent by the frontend.
        dataset_name = "mydataset"
        client = dataiku.api_client()
        project = client.get_default_project()
        dataset = project.get_dataset(dataset_name)
        if dataset.exists():
            add_content_to_dataset(dataset_name, json)
            return {'status': 200, 'name': json.get('name', '')}
        else:
            return {'status': 400, 'reason': "Dataset {} does not exist".format(dataset_name)}
    

## Conclusion

We have a complete webapp that creates a form and sends data to the backend. The backend can handle the request and appends data to an existing dataset. We also introduce the usage of an external library for the layout. Although the application is functional, many things are left to the reader, like:

  * Better error handling (both in the frontend part and the backend);

  * Entire form;

  * Smarter processing.




However, we have covered and explained all the required parts to create a web application for interacting with Dataiku objects.

Here are the complete versions of the code presented in this tutorial:

HTML Code
    
    
    <link href="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN"
            crossorigin="anonymous"></script>
    
    <div class="container-fluid">
        <form action="" method="" onsubmit="send_data(event)">
            <div class="mb-3">
                <label for="name" class="form-label">Enter your name: </label>
                <input type="text" class="form-control" name="name" id="name" required/>
            </div>
            <button type="submit" class="btn btn-primary">Validate</button>
        </form>
    
        <div class="toast-container position-fixed bottom-50 p-3">
            <div id="liveToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <strong class="me-auto">Dataiku webapp -- Simple form</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="feedback">
                    Hello, world! This is a toast message.
                </div>
            </div>
        </div>
    </div>
    

JS Code
    
    
    window.send_data = function (e) {
        e.preventDefault()
        param = makeRequestParam()
        let url = getWebAppBackendUrl('/first_form')
        fetch(url, param)
            .then((response) => extractJSON(response))
            .then((json) => displayResponse(json))
            .catch((error) => console.log(error))
    
        return false
    }
    
    function extractJSON(response) {
        return response.json()
    }
    
    const toastLiveExample = document.getElementById('liveToast')
    
    function displayResponse(response) {
        let message = `The server respond ${JSON.stringify(response)}`
        const toast = new bootstrap.Toast(toastLiveExample)
        $("#feedback").text(message)
        toast.show()
    }
    
    function getName() {
        return $('#name').val()
    }
    
    function makeRequestParam() {
        let data = {
            "name": getName()
        }
        return {
            "method": 'POST',
            "headers": {
                'Content-Type': 'application/json',
            },
            "body": JSON.stringify(data)
        }
    }
    

Python Code
    
    
    import dataiku
    import pandas as pd
    from flask import Response, request
    import logging
    import json
    
    
    @app.route('/first_form', methods=['POST', 'PUT'])
    def first_form():
        """
        Process the request sent from the frontend.
    
        :return: a response containing the data coming from the request.
        """
        request_body = request.get_json()
        resp = add_json_to_dataset(request_body)
    
        response = Response(response=json.dumps(resp),
                            status=resp['status'],
                            mimetype='application/json')
        response.headers["Content-Type"] = "text/json; charset=utf-8"
        return response
    
    
    def add_content_to_dataset(name, json):
        """
        Add a new row in JSON format to an existing data.
        :param name: Name of the dataset.
        :param json: Value to append.
        """
        dataset = dataiku.Dataset(name)
        df = dataset.get_dataframe()
        df = df.append(json, ignore_index=True)
        logging.info(df.head())
        dataset.write_dataframe(df)
    
    
    def add_json_to_dataset(json):
        """
        Add a row to a dataset, only if the dataset exists.
        :param json: Value to add.
        :return: a dict representing the result of the addition.
        """
    
        # This could be a part of data sent by the frontend.
        dataset_name = "mydataset"
        client = dataiku.api_client()
        project = client.get_default_project()
        dataset = project.get_dataset(dataset_name)
        if dataset.exists():
            add_content_to_dataset(dataset_name, json)
            return {'status': 200, 'name': json.get('name', '')}
        else:
            return {'status': 400, 'reason': "Dataset {} does not exist".format(dataset_name)}

---

## [tutorials/webapps/standard/index]

# Standard (HTML, CSS, JS)

  * [HTML/CSS/JS: your first webapp](<basics/index.html>)

  * [Adapt a d3js template in a Webapp](<adapt-d3js-template/index.html>)

  * [Use custom static files](<custom-static-files-kb/index.html>)

  * [Upload a file](<upload-file-kb/index.html>)

  * [Download a file](<download-file-kb/index.html>)

  * [Create a form for data inputs](<form-to-submit-values/index.html>)

  * [Simple scoring application](<simple-scoring/index.html>)

---

## [tutorials/webapps/standard/simple-scoring/index]

# Simple scoring application

## Prerequisites

  * Dataiku >= 12.1

  * Access to an existing project with the following permissions:
    
    * “Read project content”

    * “Write project content”

  * Access to a model deployed as an API endpoint for scoring




## Introduction

In this tutorial, you will learn how to request an API endpoint. This endpoint can be a deployed model (like in this tutorial) or anything else connected to an API endpoint. This tutorial uses the model from the MLOps training (from Learning projects > MLOps project) and a deployed API endpoint named `SimpleScoring`. It provides an API endpoint to predict the authorized flag for the provided data (transaction from credit card).

To follow the tutorial, you must know the URL where the endpoint is deployed. You can find this URL in the **Local Deployer > API services** and select the tab **Sample code** from your deployment, and note the IP address (and the port) as shown in Fig. 1

Figure 1: Where to find the URL of an API endpoint.

Once the URL is known, you are ready to start the tutorial. Create a new “Simple web app to get started” standard webapp.

## Building the webapp

You will rely on the method [`dataikuapi.APINodeClient.predict_record()`](<https://doc.dataiku.com/dss/latest/apinode/api/user-api.html#dataikuapi.APINodeClient.predict_record> "\(in Dataiku DSS v14\)") from the `dataikuapi` package to use the API endpoint. This method requires having an identifier of the endpoint to query and a Python dictionary of features. Before using this method, you need to obtain a `dataiku.APINodeClient`. This process is shown in Code 1.

Code 1: Get a prediction from a `dataiku.APINodeClient`
    
    
            try:
                client = dataikuapi.APINodeClient(url, endpoint)
                record_to_predict = features
                prediction = client.predict_record("predict_authorized", record_to_predict)
    

To instantiate the client, you need the endpoint’s URL and the deployed endpoint’s name. So you will create a form for the user to enter this data. And, as features must be supplied to use the [`dataikuapi.APINodeClient.predict_record()`](<https://doc.dataiku.com/dss/latest/apinode/api/user-api.html#dataikuapi.APINodeClient.predict_record> "\(in Dataiku DSS v14\)") method, you will include this data entry in the form. Code 2 shows a possible implementation of such a form.

Code 2: Form implementation
    
    
        <form action="" onsubmit="score(event)">
            <div class="mb-3">
                <div class="row">
                    <label for="endpoint_url"
                           class="col-sm-2 col-form-label">
                        Endpoint URL
                    </label>
                    <div class="col-sm-10">
                        <input id="endpoint_url" type="text"
                               class="form-control"
                               placeholder="Please enter the endpoint URL (http://<IP_Address>:<Port>)"
                               required/>
                    </div>
                </div>
                <div class="row">
                    <label for="endpoint_name"
                           class="col-sm-2 col-form-label">
                        Endpoint name
                    </label>
                    <div class="col-sm-10">
                        <input id="endpoint_name" type="text"
                               class="form-control"
                               placeholder="Please enter the name of the endpoint"
                               required/>
                    </div>
                </div>
                <div class="row">
                    <label for="features"
                           class="col-sm-2 col-form-label">
                        Data to score
                    </label>
                    <div class="col-sm-10">
                        <textarea id="features" type="text"
                                  class="form-control"
                                  placeholder="Please enter the name of the endpoint"
                                  style="height: 300px;"
                                  required></textarea>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col">
                        <button id="btn_score" type="submit"
                                class="offset-sm-10 col-sm-2 btn btn-primary">
                            Score it
                        </button>
                    </div>
                </div>
            </div>
        </form>
    

This form uses Bootstrap in its 5.1.3 version. You will find how to use this bootstrap version in the complete HTML code at the first and last line by using a CDN. But you can use the embedded bootstrap version in Dataiku or a local one if needed.

The first line of the form defines the javascript function to call when the user clicks on the “Score it” button. The score function is responsible for sending the data from the form to the backend and sending back the backend response to the user (Code 3).

Code 3: Javascript code
    
    
    /**
     * Get the data from the UI, send them to the backend, and display the result on the frontend.
     * @param event: not used. Only for preventing default behavior.
     */
    window.score = function (event) {
        event.preventDefault();
        let result_object = $('#result')
        result_object.text("Waiting for the result.")
        let param;
        try {
            param = makeRequestParam();
        } catch {
            result_object.text("Your data seems to be malformed.");
            return;
        }
        let url = getWebAppBackendUrl('/score');
        fetch(url, param)
            .then(response => response.text())
            .then(data => {
                let result = JSON.parse(data).result;
                if (typeof result === 'string' || result instanceof String) {
                    result_object.text(result);
                } else {
                    result_object.text(result.prediction);
                }
            })
            .catch(err => result_object.text(err))
    }
    
    /**
     * Create a javascript object to be sent to the server with a POST request.
     *
     * @returns {{headers: {"Content-Type": string}, method: string, body: string}}
     */
    function makeRequestParam() {
        let data = {
            "url": $('#endpoint_url').val(),
            "endpoint": $('#endpoint_name').val(),
            "features": JSON.parse($('#features').val())
        }
        return {
            "method": 'POST', "headers": {
                'Content-Type': 'application/json',
            }, "body": JSON.stringify(data)
        }
    }
    

You do not know how many features will be sent to the backend, neither the order nor the name of the features. This prevents you from defining a specific route to be processed by the backend. It also prevents you from using the query string (`?...`). You should use a `POST` request with a JSON body containing all information needed by the backend. This is the purpose of the highlighted lines in Code 3.

The first function is sending the data to the backend and processing the response to display the result on the frontend. Some error handlings have been implemented, but you can do more.

The Python backend (Code 4) is pretty simple. It extracts the needed information from the body request, uses it to predict the result, and creates an appropriate response that you will send back to the caller That is the javascript code in the context of this tutorial.

Code 4: Python code
    
    
    from flask import request
    import dataikuapi
    
    
    @app.route('/score', methods=['POST'])
    def getit():
        """
        Query the API endpoint with the data passed in the body of the request.
    
        Returns:
            A response object containing the prediction is everything goes well
            or an object with an error as the result.
        """
        body = request.get_json()
        url = body.get('url', None)
        endpoint = body.get('endpoint', None)
        features = body.get('features', None)
        if url and endpoint and features:
            try:
                client = dataikuapi.APINodeClient(url, endpoint)
                record_to_predict = features
                prediction = client.predict_record("predict_authorized", record_to_predict)
                return prediction
            except Exception as e:
                return {"result": str(e)}
        else:
            return {"result": "Unable to reach the endpoint"}
    

## Complete code and conclusion

Code 6 is the complete HTML code you should have at the end of the tutorial. Codes 7 and 8 are for the Javascript and the Python code. You should not have specific CSS code, as you use Bootstrap. You now have a working webapp for scoring data.

You can go further by changing the result display, or the input form to adapt to your specific needs.

Code 6: Complete HTML code of the webapp
    
    
    <link href="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    
    <div class="container-fluid">
        <h1>Standard webapp: Simple Scoring</h1>
        <h2>Enter your data</h2>
        <form action="" onsubmit="score(event)">
            <div class="mb-3">
                <div class="row">
                    <label for="endpoint_url"
                           class="col-sm-2 col-form-label">
                        Endpoint URL
                    </label>
                    <div class="col-sm-10">
                        <input id="endpoint_url" type="text"
                               class="form-control"
                               placeholder="Please enter the endpoint URL (http://<IP_Address>:<Port>)"
                               required/>
                    </div>
                </div>
                <div class="row">
                    <label for="endpoint_name"
                           class="col-sm-2 col-form-label">
                        Endpoint name
                    </label>
                    <div class="col-sm-10">
                        <input id="endpoint_name" type="text"
                               class="form-control"
                               placeholder="Please enter the name of the endpoint"
                               required/>
                    </div>
                </div>
                <div class="row">
                    <label for="features"
                           class="col-sm-2 col-form-label">
                        Data to score
                    </label>
                    <div class="col-sm-10">
                        <textarea id="features" type="text"
                                  class="form-control"
                                  placeholder="Please enter the name of the endpoint"
                                  style="height: 300px;"
                                  required></textarea>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col">
                        <button id="btn_score" type="submit"
                                class="offset-sm-10 col-sm-2 btn btn-primary">
                            Score it
                        </button>
                    </div>
                </div>
            </div>
        </form>
        <h2>Result</h2>
        <div>
            <div class="row">
                <label
                        class="col-sm-2">
                    Prediction
                </label>
                <div class="col-sm-10">
                    <p id="result">
                        Here goes the result
                    </p>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
            crossorigin="anonymous"></script>
    

Code 7: Complete Javascript code of the webapp
    
    
    /**
     * Get the data from the UI, send them to the backend, and display the result on the frontend.
     * @param event: not used. Only for preventing default behavior.
     */
    window.score = function (event) {
        event.preventDefault();
        let result_object = $('#result')
        result_object.text("Waiting for the result.")
        let param;
        try {
            param = makeRequestParam();
        } catch {
            result_object.text("Your data seems to be malformed.");
            return;
        }
        let url = getWebAppBackendUrl('/score');
        fetch(url, param)
            .then(response => response.text())
            .then(data => {
                let result = JSON.parse(data).result;
                if (typeof result === 'string' || result instanceof String) {
                    result_object.text(result);
                } else {
                    result_object.text(result.prediction);
                }
            })
            .catch(err => result_object.text(err))
    }
    
    /**
     * Create a javascript object to be sent to the server with a POST request.
     *
     * @returns {{headers: {"Content-Type": string}, method: string, body: string}}
     */
    function makeRequestParam() {
        let data = {
            "url": $('#endpoint_url').val(),
            "endpoint": $('#endpoint_name').val(),
            "features": JSON.parse($('#features').val())
        }
        return {
            "method": 'POST', "headers": {
                'Content-Type': 'application/json',
            }, "body": JSON.stringify(data)
        }
    }
    

Code 8: Complete python code of the webapp
    
    
    from flask import request
    import dataikuapi
    
    
    @app.route('/score', methods=['POST'])
    def getit():
        """
        Query the API endpoint with the data passed in the body of the request.
    
        Returns:
            A response object containing the prediction is everything goes well
            or an object with an error as the result.
        """
        body = request.get_json()
        url = body.get('url', None)
        endpoint = body.get('endpoint', None)
        features = body.get('features', None)
        if url and endpoint and features:
            try:
                client = dataikuapi.APINodeClient(url, endpoint)
                record_to_predict = features
                prediction = client.predict_record("predict_authorized", record_to_predict)
                return prediction
            except Exception as e:
                return {"result": str(e)}
        else:
            return {"result": "Unable to reach the endpoint"}

---

## [tutorials/webapps/standard/upload-file-kb/index]

# Uploading to Dataiku in a Webapp

Out of the box, Dataiku offers datasets and managed folders in which users can upload files from their local machines, and then build their Flow on this uploaded data. But for users with no access to the Flow, or for automated tasks, manually uploading to a dataset or a managed folder in the UI can be out of the question.

Webapps can fill this gap by letting users upload files from their machine to Dataiku, and trigger actions from the webapp.

Shiny offers a fileInput widget, but Python APIs for Dataiku’s managed folders are more convenient to use. Since Bokeh requires coding the uploading widget yourself, the simplest option is to use the simplest webapp type, namely standard webapps, that is, a combination of HTML/JS for the frontend and Flask for the backend.

## Basic Upload

The simplest version is an HTML form with a `<input type="file" />` field, one Ajax call to send the data, and a route in the Flask app to forward the data to a managed folder via the Python API.

In a standard webapp which has jquery, dataiku api, and bootstrap javascript libraries (see Settings tab), the frontend is:
    
    
    <form style="margin: 20px;">
        <div class="form-group" id="fileGroup">
            <label for="newFile">Select file</label>
            <input class="form-control" id="newFile" type="file" />
        </div>
        <button id="uploadButton" class="btn btn-primary">Upload to Dataiku</button>
    </form>
    
    
    
    $('#uploadButton').click(function (e) {
        e.preventDefault();
        let newFile = $('#newFile')[0].files[0];
        let form = new FormData();
        form.append('file', newFile);
        $.ajax({
            type: 'post',
            url: getWebAppBackendUrl('/upload-to-dss'),
            processData: false,
            contentType: false,
            data: form,
            success: function (data) { console.log(data); },
            error: function (jqXHR, status, errorThrown) { console.error(jqXHR.responseText); }
        });
    });
    

The Ajax call targets a route `/upload-to-dss` in the Flask backend, whose code is:
    
    
    import dataiku
    from flask import request
    
    @app.route('/upload-to-dss', methods = ['POST'])
    def upload_to_dss():
        f = request.files.get('file')
        mf = dataiku.Folder('box') # name of the folder in the flow
        target_path = '/%s' % f.filename
        mf.upload_stream(target_path, f)
        return json.dumps({"status":"ok"})
    

This produces a UI like:

Select file, hit the upload button, and voilà, the file is now in the managed folder (named box), ready to be used in a Flow or by the webapp itself!

## Adding Parameters

Just sending a file to the Python backend is often not enough, and additional parameters might be needed. To add a field to the form and retrieve its value in the backend, add:
    
    
     ...
     <div class="form-group" id="paramGroup">
         <label for="someParam">Some param</label>
         <input class="form-control" id="someParam" type="text" />
     </div>
    ...
    
    
    
    ...
    let form = new FormData();
    form.append('file', newFile);
    form.append('extra', $('#someParam').val())
    ...
    
    
    
    ...
    extra_param = request.form.get('extra', '')
    f = request.files.get('file')
    ...
    

## Simple UI Improvements

In order to make the upload a bit more pleasant, you can tweak the html/js to add drag & drop on the form field:
    
    
    $('#newFile').on('dragover', function(e) {
        e.preventDefault();
        e.stopPropagation();
    });
    $('#newFile').on('dragenter', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $("#newFile").css("opacity", "0.5")
    });
    $('#fileGroup').on('dragleave', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $("#newFile").css("opacity", "")
    });
    $('#newFile').on('drop', function(e){
        $("#newFile").css("opacity", "")
        if(e.originalEvent.dataTransfer && e.originalEvent.dataTransfer.files.length) {
            e.preventDefault();
            e.stopPropagation();
            $("#newFile")[0].files = e.originalEvent.dataTransfer.files;
        }
    });
    

If files to upload can be large, it’s a good idea to give some user feedback on the progress of the upload, to not give the impression nothing is happening. A simple progress bar would be:
    
    
    let stopUpload = function() {
        $("#progress").remove();
    };
    
    let startUpload = function() {
        stopUpload();
            let progress = $('<div id="progress"/>').css("height", "10px").css("margin", "10px 0").css("background","lightblue");
        $('#fileGroup').append(progress);
    };
    ...
    $.ajax({
        type: 'post',
        ...
        xhr: function() {
            startUpload();
            var ret = new window.XMLHttpRequest();
            ret.upload.addEventListener("progress", function(evt) {
              if (evt.lengthComputable) {
                var pct = parseInt(evt.loaded / evt.total * 100);
                $('#progress').css("width", "" + pct + "%");
              }
            }, false);
            return ret;
        },
        complete: function() { stopUpload(); }
    });
    

After that, improvements could be feedback post-upload, styling, etc.

## What’s Next?

To learn more about HTML/JS, Python Bokeh, and R Shiny webapps in Dataiku, visit the Dataiku Academy for tutorials and examples.

Here are the complete versions of the code presented in this tutorial:

HTML Code
    
    
    <link href="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous"></link>
    <script src="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
    
    <form style="margin: 20px;">
        <div class="form-group" id="fileGroup">
            <label for="newFile">Select file</label>
            <input class="form-control" id="newFile" type="file" />
        </div>
        <div class="form-group" id="paramGroup">
            <label for="someParam">Some param</label>
            <input class="form-control" id="someParam" type="text" />
        </div>
    
        <button id="uploadButton" class="btn btn-primary">Upload to Dataiku</button>
    </form>
    

JS Code
    
    
    $('#uploadButton').click(function (e) {
        e.preventDefault();
        let newFile = $('#newFile')[0].files[0];
        let form = new FormData();
        form.append('file', newFile);
        form.append('extra', $('#someParam').val())
        $.ajax({
            type: 'post',
            url: getWebAppBackendUrl('/upload-to-dss'),
            processData: false,
            contentType: false,
            data: form,
            success: function (data) { console.log(data); },
            error: function (jqXHR, status, errorThrown) { console.error(jqXHR.responseText); },
            xhr: function() {
                startUpload();
                var ret = new window.XMLHttpRequest();
                ret.upload.addEventListener("progress", function(evt) {
                    if (evt.lengthComputable) {
                        var pct = parseInt(evt.loaded / evt.total * 100);
                        $('#progress').css("width", "" + pct + "%");
                    }
                }, false);
                return ret;
            },
            complete: function() { stopUpload();}
        });
    });
    
    $('#newFile').on('dragover', function(e) {
        e.preventDefault();
        e.stopPropagation();
    });
    $('#newFile').on('dragenter', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $("#newFile").css("opacity", "0.5")
    });
    $('#fileGroup').on('dragleave', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $("#newFile").css("opacity", "")
    });
    $('#newFile').on('drop', function(e){
        $("#newFile").css("opacity", "")
        if(e.originalEvent.dataTransfer && e.originalEvent.dataTransfer.files.length) {
            e.preventDefault();
            e.stopPropagation();
            $("#newFile")[0].files = e.originalEvent.dataTransfer.files;
        }
    });
    
    let stopUpload = function() {
        $("#progress").remove();
    };
    
    let startUpload = function() {
        stopUpload();
            let progress = $('<div id="progress"/>').css("height", "10px").css("margin", "10px 0").css("background","lightblue");
        $('#fileGroup').append(progress);
    };
    

Python Code
    
    
    import dataiku
    from flask import request
    
    @app.route('/upload-to-dss', methods = ['POST'])
    def upload_to_dss():
        extra_param = request.form.get('extra', '')
        f = request.files.get('file')
        mf = dataiku.Folder('box') # name of the folder in the flow
        target_path = '/%s' % f.filename
        mf.upload_stream(target_path, f)
        return json.dumps({"status":"ok"})

---

## [tutorials/webapps/streamlit/basics/index]

# Streamlit: your first webapp using code studio

Starting with version 14.3, Dataiku supports creating a Streamlit web app natively. Native Dataiku web apps are automatically published and do not require a Kubernetes deployment. They can also be edited, tested, and debugged in a Code Studio, as any other native Dataiku web app. As such, creating a native Streamlit web app is the simplest way to get started building Streamlit apps using Dataiku.

That said, it remains possible to create a Streamlit web app with Code Studio, as was the case since version 11.0. And it remains your only choice before version 14.3. This tutorial guides you through the steps of creating a Streamlit web app in Code Studio and publishing it as a Dataiku web app.

## Prerequisites

  * Dataiku >= 11.0

  * A Kubernetes cluster properly linked to the Dataiku instance (for more details, see the reference documentation page on [Elastic AI Computation](<https://doc.dataiku.com/dss/latest/containers/index.html> "\(in Dataiku DSS v14\)")).

  * Access to a Project with relevant permissions to create Code Studios.

  * A functioning Code Studio template for Streamlit webapps (for more details, see the reference documentation page on [Code Studio templates](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html> "\(in Dataiku DSS v14\)")).




[Streamlit](<https://streamlit.io/>) is a popular web application framework, designed for building rich interactive applications using Python. In this article, you will develop a Streamlit application in Dataiku using the Code Studio feature and then deploy it as a Dataiku webapp.

## Preparing the source data

This tutorial is inspired by [one of Streamlit’s demos](<https://github.com/streamlit/demo-uber-nyc-pickups>) and mostly reuses the same code and data.

Start by downloading the source data following [this link](<https://s3-us-west-2.amazonaws.com/streamlit-demo-data/uber-raw-data-sep14.csv.gz>) and make it available in your Dataiku Project, for example by uploading the _.csv.gz_ file to it. Name the resulting Dataiku dataset `uber_raw_data_sep14`.

The dataset contains information about Uber pickup dates, times and geographical coordinates (latitude and longitude). To better understand this data, you will build a few data visualizations in the rest of the tutorial, but first, you need to set up the webapp’s edition environment.

## Setting up the edition environment

In Dataiku, Streamlit webapps are built on top of [Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/index.html> "\(in Dataiku DSS v14\)"), which are also used to provide advanced development environments. This tutorial assumes that you already have access to a functioning Code Studio template for Streamlit, referred to as `streamlit-template`.

From your Project, create a new Code Studio instance:

  * In the “Code” menu, go to “Code Studios”




  * Click on “Create your first Code Studio”

  * In the “New Code Studio” modal, select `streamlit-template`, name your instance `uber-nyc-dev` and click on “Create”.




The `uber-nyc` Code Studio is now created, but not started yet. To start it, click on _Start Code Studio_. After waiting for the start operation to be completed, you should see a “Hello World” message: this is the initial rendering of your Streamlit webapp! For now, it doesn’t do much, but you will add more functionalities in the next sections.

## Editing the webapp source code

Your first task is to surface the Uber pickup data in the webapp. Access the IDE environment in the “VS Code” tab of the Code Studio, and go to “Workspace > code_studio-versioned/streamlit/app.py”. This will open the source code file of the webapp.

Add the following code:
    
    
    import streamlit as st
    import dataiku
    import pandas as pd
    
    DATE_TIME_COL = "date/time"
    
    #############
    # Functions #
    #############
    
    @st.experimental_singleton
    def load_data(nrows):
        data = dataiku.Dataset("uber_raw_data_sep14") \
            .get_dataframe(limit=nrows)
        lowercase = lambda x: str(x).lower()
        data.rename(lowercase, axis='columns', inplace=True)
        data[DATE_TIME_COL] = pd.to_datetime(data[DATE_TIME_COL],
                                           format="%m/%d/%Y %H:%M:%S")
        return data
    
    ##############
    # App layout #
    ##############
    
    data = load_data(nrows=10000)
    
    st.title('Uber pickups in NYC')
    
    if st.checkbox('Show raw data'):
        st.subheader('Raw data')
        st.write(data)
    

The structure of the code is split in two:

  * The _Functions_ part contains all functions that rule the **behavior** of the application

  * The _App layout_ part lists the different visual components that the application is made of, hence defining its **appearance**.




For this initial step, you created a `load_data()` function that retrieves the source data and turns in into a pandas DataFrame that you’ll be able to manipulate later for more advanced operations. The layout is fairly simple: it displays the content of that DataFrame as a table if the “Show raw data” box is ticked.

### Breaking down rides by hour of the day

Suppose now that you want to further investigate your data and check if there is a particular time of the day when the number of pickups is higher or lower than usual. To do so, you will create a histogram at the hour level and display it in the application. First, add a few more dependencies to import at the beginning of the file:
    
    
    import altair as alt
    import numpy as np
    import pandas as pd
    

Then, add the histogram computation function to the _Functions_ part:
    
    
    @st.experimental_memo
    def histdata(df):
        hist = np.histogram(df[DATE_TIME_COL].dt.hour, bins=24, range=(0, 24))[0]
        return pd.DataFrame({"hour": range(24), "pickups": hist})
    

Finally, incorporate the histogram visualization in the application by adding this to the _App layout_ section:
    
    
    # Histogram
    
    chart_data = histdata(data)
    st.write(
        f"""**Breakdown of rides per hour**"""
    )
    
    st.altair_chart(
        alt.Chart(chart_data)
        .mark_area(
            interpolate="step-after",
        )
        .encode(
            x=alt.X("hour:Q", scale=alt.Scale(nice=False)),
            y=alt.Y("pickups:Q"),
            tooltip=["hour", "pickups"],
        )
        .configure_mark(opacity=0.2, color="red"),
        use_container_width=True,
    )
    

If you check back on the _Streamlit_ tab you should now see a nice histogram rendered:

### Drawing a scatter map with pickup locations

For the final item of your application, you will create a map displaying the pickup locations. To make it more interactive, you will also add a slider to filter the data and keep only a specific hour of the day.

No additional computation is needed here, so you can directly add the following code to the _App layout_ part:
    
    
    # Map and slider
    
    hour_to_filter = st.slider('', 0, 23, 17)
    filtered_data = data[data[DATE_TIME_COL].dt.hour == hour_to_filter]
    st.subheader(f"Map of all pickups at {hour_to_filter}:00")
    st.map(filtered_data)
    

If you go back once more to the _Streamlit_ tab you will see the newly-added map:

### Putting it all together

Your webapp is now fully functional! Here is the complete code for your application:
    
    
    import streamlit as st
    import dataiku
    import numpy as np
    import pandas as pd
    import altair as alt
    
    DATE_TIME_COL = "date/time"
    
    #############
    # Functions #
    #############
    
    @st.experimental_singleton
    def load_data(nrows):
        data = dataiku.Dataset("uber_raw_data_sep14") \
            .get_dataframe(limit=nrows)
        lowercase = lambda x: str(x).lower()
        data.rename(lowercase, axis='columns', inplace=True)
        data[DATE_TIME_COL] = pd.to_datetime(data[DATE_TIME_COL],
                                           format="%m/%d/%Y %H:%M:%S")
        return data
    
    @st.experimental_memo
    def histdata(df):
        hist = np.histogram(df[DATE_TIME_COL].dt.hour, bins=24, range=(0, 24))[0]
        return pd.DataFrame({"hour": range(24), "pickups": hist})
    
    ##############
    # App layout #
    ##############
    
    # Load a sample from the source Dataset
    data = load_data(nrows=10000)
    
    st.title('Uber pickups in NYC')
    
    if st.checkbox('Show raw data'):
        st.subheader('Raw data')
        st.write(data)
    
    # Histogram
    
    chart_data = histdata(data)
    st.write(
        f"""**Breakdown of rides per hour**"""
    )
    
    st.altair_chart(
        alt.Chart(chart_data)
        .mark_area(
            interpolate="step-after",
        )
        .encode(
            x=alt.X("hour:Q", scale=alt.Scale(nice=False)),
            y=alt.Y("pickups:Q"),
            tooltip=["hour", "pickups"],
        )
        .configure_mark(opacity=0.2, color="red"),
        use_container_width=True,
    )
    
    # Map and slider
    
    hour_to_filter = st.slider('', 0, 23, 17)
    filtered_data = data[data[DATE_TIME_COL].dt.hour == hour_to_filter]
    st.subheader(f"Map of all pickups at {hour_to_filter}:00")
    st.map(filtered_data)
    

## Publishing the webapp

Up to this point, your application is still living inside your development environment, namely your Code Studio instance. The final step of this tutorial is to make it widely available for other Dataiku users to view.

  * In the “Code Studios” list screen, select `uber-nyc-dev`

  * In the Action panel on the right, select “Publish” and name your webapp (e.g. `Uber NYC App`) then click on “Create”




Your Streamlit application is now deployed as a Dataiku webapp, congratulations! You can access it in “Code > Webapps > Uber NYC App”.

Note

Once you have deployed a Code Studio application as a Dataiku webapp, if you change the source code in the Code Studio editor then those changes will be directly reflected in the webapp. That is because the webapp itself constantly points to the latest state of the Code Studio.

## Wrapping up

In this tutorial, you saw how to build a simple Streamlit application and deploy it as a Dataiku webapp, while leveraging the advanced code edition capabilities offered by the Code Studios feature. If you want to experiment with other frameworks like Dash or Bokeh, check out the available tutorials in the Webapp section.

---

## [tutorials/webapps/streamlit/getting-started/index]

# Streamlit: your first webapp

[Streamlit](<https://streamlit.io/>) is a popular web application framework designed for building rich interactive applications using Python. In this article, you will develop and deploy a Streamlit application in Dataiku.

## Prerequisites

  * Dataiku >= 14.3.0

  * A Python 3.9 or later code environment with `streamlit` as additional Python package.




## Preparing the source data

This tutorial is inspired by [one of Streamlit’s demos](<https://github.com/streamlit/demo-uber-nyc-pickups>) and mostly reuses the same code and data.

Start by downloading the source data following [this link](<https://s3-us-west-2.amazonaws.com/streamlit-demo-data/uber-raw-data-sep14.csv.gz>) and make it available in your Dataiku Project, for example, by uploading the `.csv.gz` file to it. Name the resulting Dataiku dataset `uber_raw_data_sep14`.

The dataset contains information about Uber pickup dates, times, and geographical coordinates (latitude and longitude). To better understand this data, you will build a few data visualizations in the rest of the tutorial. But first, you need to set up the web app’s edition environment.

## Creating the web app

In your project, open the webapps page and click **+New webapp > Code webapp > Streamlit > Empty Streamlit app**. Name your application as you like, for instance, `uber-data-explorer`.

The app has been created, but hasn’t been started yet. To start, open the Settings tab and set **Backend > Code env** to your streamlit-enabled Python code environment. Then, click **Save** above. This will save the settings and also start the app.

After the app starts, you should see the “Hello Streamlit!” title with some text under it.

## Editing the webapp source code

Now, let’s make your app do something. Replace the sample Python code with this one:
    
    
    import streamlit as st
    import dataiku
    import pandas as pd
    
    DATE_TIME_COL = "date/time"
    
    #############
    # Functions #
    #############
    
    @st.cache_resource
    def load_data(nrows):
        dataset = dataiku.Dataset("uber_raw_data_sep14")
        df = dataset.get_dataframe(limit=nrows)
        lowercase = lambda x: str(x).lower()
        df.rename(lowercase, axis='columns', inplace=True)
        df[DATE_TIME_COL] = pd.to_datetime(
            df[DATE_TIME_COL],
            format="%m/%d/%Y %H:%M:%S"
        )
        return df
    
    ##############
    # App layout #
    ##############
    
    data = load_data(nrows=10000)
    
    st.title('Uber pickups in NYC')
    
    if st.checkbox('Show raw data'):
        st.subheader('Raw data')
        st.write(data)
    

The structure of the code is split into two:

  * The _Functions_ part contains all functions that rule the **behavior** of the application.

  * The _App layout_ part lists the different visual components that the application is made of, hence defining its **appearance**.




For this initial step, you created a `load_data()` function that retrieves the source data and turns it into a pandas DataFrame that you’ll be able to manipulate later for more advanced operations. The layout is fairly simple: it displays the content of that DataFrame as a table if the “Show raw data” box is ticked.

After saving changes, the app restarts. You should now see this in the _Preview_ tab, if you show the raw data:

### Breaking down rides by hour of the day

Suppose you now want to investigate your data further and check if there is a particular time of day when the number of pickups is higher or lower than usual. To do so, you will create a histogram at the hour level and display it in the application. First, add a few additional dependencies to import at the beginning of the file:
    
    
    import altair as alt
    import numpy as np
    

Then, add the histogram computation function to the `Functions` part:
    
    
    @st.cache_data
    def histdata(df):
        hist = np.histogram(df[DATE_TIME_COL].dt.hour, bins=24, range=(0, 24))[0]
        return pd.DataFrame({"hour": range(24), "pickups": hist})
    

Finally, incorporate the histogram visualization in the application by adding this to the `App layout` section:
    
    
    # Histogram
    
    chart_data = histdata(data)
    st.write(
        f"""**Breakdown of rides per hour**"""
    )
    
    st.altair_chart(
        alt.Chart(chart_data)
        .mark_area(
            interpolate="step-after",
        )
        .encode(
            x=alt.X("hour:Q", scale=alt.Scale(nice=False)),
            y=alt.Y("pickups:Q"),
            tooltip=["hour", "pickups"],
        )
        .configure_mark(opacity=0.2, color="red"),
        use_container_width=True,
    )
    

**Save** your changes and wait for the app to refresh. You should now see a nice histogram in the **Preview** tab:

### Drawing a scatter map with pickup locations

For the final item of your application, you will create a map displaying the pickup locations. To make it more interactive, you will also add a slider to filter the data and keep only a specific hour of the day.

No additional computation is needed here, so you can directly add the following code to the `App layout` part:
    
    
    # Map and slider
    
    hour_to_filter = st.slider('', 0, 23, 17)
    filtered_data = data[data[DATE_TIME_COL].dt.hour == hour_to_filter]
    st.subheader(f"Map of all pickups at {hour_to_filter}:00")
    st.map(filtered_data)
    

Restart the backend. You should now see a nice histogram in the **Preview** tab:

### Customizing your app’s theme

Streamlit apps can be themed using configuration. We will now use this to align your app’s theme with Uber’s brand color palette.

To do so, open the **Configuration** tab. Here you can adjust various settings, including colors and fonts. Let’s use Uber’s blue (`#1FBAD6`) for UI controls and Uber’s gray (`#222233`) for text color. Add the following two lines in the `[theme]` section, and click the **Save** button.
    
    
    textColor = "#222233"
    primaryColor = "#1FBAD6"
    

After the preview refreshes, you should now see that the slider is blue and that the text is not quite black (though this may be harder to see). But the charts and map still use red. Chart colors are not controlled by the theme but by the code. To change the color, define Uber’s blue as a variable at the top of the Python file.
    
    
    uber_blue = "#1FBAD6"
    

And change the colors used in the chart, and for map markers, as follows:
    
    
    st.altair_chart(
        ...
        .configure_mark(opacity=0.2, color=uber_blue),
                                           ^^^^^^^^^
    ...
    
    st.map(filtered_data, color=uber_blue)
                        ^^^^^^^^^^^^^^^^^
    

**Save** your app one more time. You should now see a much more Uber-marketing-friendly UI!

## Putting it all together

Your webapp is now fully functional! Here is the complete code for your application:
    
    
    import streamlit as st
    import dataiku
    import pandas as pd
    import altair as alt
    import numpy as np
    
    DATE_TIME_COL = "date/time"
    uber_blue = "#1FBAD6"
    
    #############
    # Functions #
    #############
    
    @st.cache_resource
    def load_data(nrows):
        dataset = dataiku.Dataset("uber_raw_data_sep14")
        df = dataset.get_dataframe(limit=nrows)
        lowercase = lambda x: str(x).lower()
        df.rename(lowercase, axis='columns', inplace=True)
        df[DATE_TIME_COL] = pd.to_datetime(
            df[DATE_TIME_COL],
            format="%m/%d/%Y %H:%M:%S"
        )
        return df
    
    @st.cache_data
    def histdata(df):
        hist = np.histogram(df[DATE_TIME_COL].dt.hour, bins=24, range=(0, 24))[0]
        return pd.DataFrame({"hour": range(24), "pickups": hist})
    
    
    ##############
    # App layout #
    ##############
    
    data = load_data(nrows=10000)
    
    st.title('Uber pickups in NYC')
    
    if st.checkbox('Show raw data'):
        st.subheader('Raw data')
        st.write(data)
        
    # Histogram
    
    chart_data = histdata(data)
    st.write(
        f"""**Breakdown of rides per hour**"""
    )
    
    st.altair_chart(
        alt.Chart(chart_data)
        .mark_area(
            interpolate="step-after",
        )
        .encode(
            x=alt.X("hour:Q", scale=alt.Scale(nice=False)),
            y=alt.Y("pickups:Q"),
            tooltip=["hour", "pickups"],
        )
        .configure_mark(opacity=0.2, color=uber_blue),
        use_container_width=True,
    )
    
    # Map and slider
    
    hour_to_filter = st.slider('', 0, 23, 17)
    filtered_data = data[data[DATE_TIME_COL].dt.hour == hour_to_filter]
    st.subheader(f"Map of all pickups at {hour_to_filter}:00")
    st.map(filtered_data, color=uber_blue)
    

And here is the _theme_ section of its **Configuration**
    
    
    [theme]
    textColor = "#222233"
    primaryColor = "#1FBAD6"
    

## Wrapping up

In this tutorial, you saw how to get started building Streamlit applications in Dataiku. Note that the code and configuration can also be edited in a Code Studio. This is covered in other tutorials.

---

## [tutorials/webapps/streamlit/index]

# Streamlit

  * [Streamlit: your first webapp](<getting-started/index.html>)

  * [Create a Streamlit webapp in a Code Studio](<basics/index.html>)

---

## [tutorials/webapps/voila/agent/index]

# Creating a Voilà application using an LLM-based agent

In this tutorial, you will learn how to build an Agent application using Voilà. You will build an application to retrieve customer and company information based on a login. This tutorial relies on two tools. One tool retrieves a user’s name, position, and company based on a login/ID. This information is stored in a Dataset. A second tool searches the Internet to find company information.

This tutorial is based on two tutorials:

  * The [Voilà: your first web application](<../first-webapp/index.html>) tutorial; if you have followed it, you can skip the section Building the Code Studio template.

  * The [Building and using an agent with Dataiku’s LLM Mesh and Langchain](<../../../genai/agents-and-tools/agent/index.html>) tutorial uses the same tools and agents in a similar context. If you have followed this tutorial, you can skip the Creating the Agent application section.




## Prerequisites

  * Administrator permission to build the template

  * An LLM connection configured

  * A Dataiku version > 13.0

  * A code environment (named `voila-and-agents`) based on Python 3.9, without Jupyter support, with the following packages:
        
        voila==0.5.7
        langchain==0.2.0
        duckduckgo_search==6.1.0
        jupyter_client<9,>=7.4.4
        ipykernel
        ipywidgets
        




## Building the Code Studio template

If you know how to build a Code Studio template using Voilà and a dedicated code environment, you have to create one named `voila-and-agent-template`.

If you don’t know how to do it, please follow these instructions:

  * Go to the **Code Studios** tab in the **Administration** menu, click the **+Create Code Studio template** button, and choose a meaningful label (`voila-and-agent-template`, for example).

  * Click on the **Definition** tab.

  * Add the **Add Code environment** block, and choose the code environment previously created (`voila-and-agents`).

  * Add a new **JupyterLab server** block. This block will allow you to edit your Voilà application in a dedicated Notebook.

  * Add the **Voila** block and select the code environment previously imported, as shown in Figure 1.

  * Click the **Save** button.

  * Click the **Build** button to build the template.




Figure 1: Code Studio - Voilà block.

Your Code Studio template is ready to be used in a project.

## Creating the Agent application

### Preparing the data

You need to create the associated dataset, as you will use a dataset that stores a user’s ID, name, position, and company based on that ID.

Table 1: customer ID id | name | job | company  
---|---|---|---  
tcook | Tim Cook | CEO | Apple  
snadella | Satya Nadella | CEO | Microsoft  
jbezos | Jeff Bezos | CEO | Amazon  
fdouetteau | Florian Douetteau | CEO | Dataiku  
wcoyote | Wile E. Coyote | Business Developer | ACME  
  
Table 1, which can be downloaded [`here`](<../../../../_downloads/8e7b05dafd677201ccaf5d96fe9264f8/pro_customers.csv>), represents such Data.

Create a SQL Database named `pro_customers_sql` by uploading the CSV file and using a **Sync recipe** to store the data in an SQL connection.

### Creating utility functions

Be sure to have a valid `LLM_ID` before creating your Voilà application. The [documentation](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>) provides instructions on obtaining an `LLM_ID`.

  * Create a new project, click on **< /> > Code Studios**.

  * Click the **+New Code Studio** button, choose the previously created template, choose a meaningful name, click the **Create** button, and then click the **Start Code Studio** button.

  * To edit the code of your Voilà application, click the **Jupyter Lab** tab.

  * Select the `voila` subdirectory in the `code_studio-versioned` directory. Dataiku provides a sample application in the file `app.ipynb`.




You will modify this code to build the application. The first thing to do is define the different tools the application needs. There are various ways of defining a tool. The most precise one is based on defining classes that encapsulate the tool. Alternatively, you can use the `@tool` annotation or the `StructuredTool.from_function` function, but it may require more work when using those tools in a chain.

To define a tool using classes, there are two steps to follow:

  * Define the interface: which parameter is used by your tool.

  * Define the code: how the code is executed.




Code 1 shows how to describe a tool using classes. The highlighted lines define the tool’s interface. This simple tool takes a customer ID as an input parameter and runs a query on the SQL Dataset.

Code 1: Get customer’s information
    
    
    class CustomerInfo(BaseModel):
        """Parameter for GetCustomerInfo"""
        id: str = Field(description="customer ID")
    
    
    class GetCustomerInfo(BaseTool):
        """Gathering customer information"""
    
        name: str = "GetCustomerInfo"
        description: str = "Provide a name, job title and company of a customer, given the customer's ID"
        args_schema: Type[BaseModel] = CustomerInfo
    
        def _run(self, id: str):
            dataset = dataiku.Dataset(DATASET_NAME)
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {id}"
    
    

Note

The SQL query might be written differently depending on your SQL Engine.

Similarly, Code 2 shows how to create a tool that searches the Internet for information on a company.

Code 2: Get company’s information
    
    
    class CompanyInfo(BaseModel):
        """Parameter for the GetCompanyInfo"""
        name: str = Field(description="Company's name")
    
    
    class GetCompanyInfo(BaseTool):
        """Class for gathering in the company information"""
    
        name: str = "GetCompanyInfo"
        description: str = "Provide general information about a company, given the company's name."
        args_schema: Type[BaseModel] = CompanyInfo
    
        def _run(self, name: str):
            results = DDGS().text(name + " (company)", max_results=1)
            result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(name, max_results=1)
                result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + name
            return result
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    
    

Code 3 shows how to declare and use these tools.

Code 3: How to use tools
    
    
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    tool_names = [tool.name for tool in tools]
    
    

Once all the tools are defined, you are ready to create your agent. An agent is based on a prompt and uses some tools and an LLM. Code 4 is about creating an `agent` and the associated `agent_executor`.

Code 4: Declaring an agent
    
    
    # Initializes the agent
    prompt = ChatPromptTemplate.from_template(
        """Answer the following questions as best you can. You have only access to the following tools:
    {tools}
    Use the following format:
    Question: the input question you must answer
    Thought: you should always think about what to do
    Action: the action to take should be one of [{tool_names}]
    Action Input: the input to the action
    Observation: the result of the action
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: I now know the final answer
    Final Answer: the final answer to the original input question
    Begin!
    Question: {input}
    Thought:{agent_scratchpad}""")
    
    agent = create_react_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools,
                                   verbose=True, return_intermediate_steps=True, handle_parsing_errors=True)
    
    

## Creating the Voilà application

You now have a working agent; let’s build the Voilà application. This first version has an input Textbox for entering a customer ID and displays the result in an output Textbox. Thus, the code is straightforward. You need to connect your agent to the Voilà framework, as shown in Code 5.

Code 5: Voilà application
    
    
    import ipywidgets as widgets
    import os
    
    label = widgets.Label(value="Enter the customer ID")
    text = widgets.Text(placeholder="fdouetteau", continuous_update=False)
    
    result = widgets.Output(value="")
    
    
    def search(customer_id):
        """
        Search information about a customer
        Args:
            customer_id: customer ID
        Returns:
            the agent result
        """
        return agent_executor.invoke({
            "input": f"""Give all the professional information you can about the customer with ID: {customer_id}. 
            Also include information about the company if you can.""",
            "tools": tools,
            "tool_names": tool_names
        })['output']
    
    
    def callback(customerId):
        """
            Callback function for calling the agent
        Args:
            customerId: customer ID
        """
        result.clear_output()
        with result:
            result.append_stdout(search(customerId.get('new', '')))
    
    
    text.observe(callback, 'value')
    display(widgets.VBox([widgets.HBox([label, text]), result]))
    

This will lead to an application like the one shown in Figure 2.

Figure 2: First Voilà agent application.

## Going further

You have an application that takes a customer ID as input and displays the result. You can tweak it to display the different steps the agent follows.

If you want to test different usage of an LLM, follow the steps:

  1. Use the [`list_llms()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms") method (like shown [here](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>)).

  2. Store the result in a list.

  3. Use this list as a dropdown.

  4. Create a new agent each time the user changes the input.




There are many other ways to improve this application, but you now have enough knowledge to adapt it to your needs.

You can download the **Jupyter lab** notebook [`here`](<../../../../_downloads/733e2532e771a6dc86962ec9993d9ad4/app.ipynb>)

---

## [tutorials/webapps/voila/first-webapp/index]

# Voilà: your first web application

In this tutorial, you will learn how to build your first Voilà web application. To be able to create a Voilà application, you will first need to configure a Code Studio template and then code your application using this application. Once the application is designed, you can publish it as a web application.

## Prerequisites

  * Dataiku >= 13.0

  * Administrator permission to build the template




## Building the Code Studio template

  * Go to the **Code Studios** tab in the **Administration** menu, click the **+Create Code Studio template** button, and choose a meaningful label (`voila_template`, for example).

  * Click on the **Definition** tab.

  * Add a new **JupyterLab server** block. This block will allow you to edit your Voilà application in a dedicated Code Studio.

  * Add a new **Voila** block, and
    
    * Choose **Generate a dedicated code env** for the **Code env mode**

    * Choose **latest voila version + DSS** for the **Package versions**

    * Choose **3.9** for the **Python versions**

as shown in Figure 1.

  * Click the **Save** button.

  * Click the **Build** button to build the template.




Figure 1: Code Studio – Voila block.

Your Code Studio template is ready to be used in a project. If you need a specific configuration for a block, please refer to [the documentation](<https://doc.dataiku.com/dss/latest/code-studios/index.html> "\(in Dataiku DSS v14\)").

## Creating a new Voilà application

Before creating your Voilà application, you must download [`this CSV file`](<../../../../_downloads/7086225f3c5aa878a0e67d04ff94d1ed/pro_customers.csv>), upload it to your instance, and use a **Sync recipe** to create an **SQL** Dataset named `pro_customers_sql`.

  * Create a new project, click on **< /> > Code Studios**.

  * Click the **+New Code Studio** , choose the previously created template, choose a meaningful name, click the **Create** button, and then click the **Start Code Studio** button.

  * To edit the code of your Voilà application, click the **Jupyter Lab** tabs.

  * Select the `voila` subdirectory in the `code_studio-versioned` directory. Dataiku provides a sample application in the file `app.ipynb`.

  * Select the `DSS Codeenv - pyenv-voila` kernel. This step is not mandatory, as the voilà application will use the kernel defined in the code studio template. It just helps you to debug your application. To select the correct kernel, click on the Kernel menu (in the **Jupyter Lab** tab), choose **Change Kernel…** , and select the kernel.

  * Replace the provided code with the code shown in Code 1.

  * If everything goes well, you should have a running Voilà application like the one shown in Figure 2




Code 1: First Voilà application
    
    
    import dataiku
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    
    DATASET_NAME = "pro_customers_sql"
    
    
    def get_customer_info(id):
        dataset = dataiku.Dataset(DATASET_NAME)
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        cid = Constant(str(id))
        escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT "name", "job", "company" FROM "{table_name}" WHERE "id" = {escaped_cid}""")
        for (name, job, company) in query_reader.iter_tuples():
            return f"""The customer's name is "{name}", holding the position "{job}" at the company named "{company}" """
        return "No information can be found"
    
    
    import ipywidgets as widgets
    import os
    
    label = widgets.Label(value="Enter the customer ID")
    text = widgets.Text(placeholder="fdouetteau", continuous_update=False)
    
    result = widgets.Label(value="")
    
    
    def callback(customerId):
        result.value = get_customer_info(customerId.get('new', ''))
    
    
    text.observe(callback, 'value')
    
    display(widgets.VBox([widgets.HBox([label, text]), result]))
    

Figure 3: First Voilà application.

## Wrapping up

You now have a running Voilà application. You can customize it a little to fit your needs. When happy with the result, click the **Publish** button in the **right panel**. Then, your Voilà application is available for all users who can use it without running the Code Studio.

You can download the **Jupyter lab** notebook [`here`](<../../../../_downloads/cc944939e1f7621bcf0552265e203618/app.ipynb>)

---

## [tutorials/webapps/voila/index]

# Voilà

  * [Voilà: your first web application](<first-webapp/index.html>)

  * [Creating a Voilà application using an LLM-based agent](<agent/index.html>)

---

## [tutorials/xOps/index]

# xOps

This tutorial section contains articles about operationnal tasks.

## deployment

  * [Project deployment](<project-deployment/index.html>)

---

## [tutorials/xOps/project-deployment/index]

# Project deployment

This tutorial guides you through the various steps to deploy a project. We will create a bundle, specifying the infrastructure to use, and publish it using a deployer:

  * The bundle will represent the state of the project as you want to use it.

  * The deployment infrastructures categorize resources and settings used to deploy the bundle.

  * The Project Deployer is the tool that will operate your actions.




## Prerequisites

  * Dataiku >= 13.4

  * Python >= 3.10




## Introduction

In the life of a project, you will reach a point where it is considered ready for the next steps. Depending on the goals and topics of the project, you may have some or all of the following:

  * well-documented workflows

  * optimized data pipelines

  * quality rules and/or checks

  * agents adding value to the data

  * dashboards and webapps




The project will now need to be deployed to a QA or preproduction instance to prepare for the launch in production.

For this tutorial, you will need a project to interact with. You can use one of your own, or use one of the many projects created in other tutorials from this developer guide.

To develop and test the code, you have multiple possibilities, but you may consider using:

  * a [Python notebook](<https://doc.dataiku.com/dss/latest/notebooks/python.html> "\(in Dataiku DSS v14\)") in the project you will deploy

  * a [Code Studio](<../../devtools/using-vscode-for-code-studios/index.html>) in the project you will deploy

  * your specific environment. In that case, you will need to [set up your environment](<../../devtools/python-client/index.html#local-python-environment>).




## Exporting a bundle

The first step to deploy your project is to export a bundle. A bundle essentially captures a project’s state at a specific point in time, including the necessary data required for task recomputation. You can find more in-depth information about bundles in the [documentation](<https://doc.dataiku.com/dss/latest/deployment/creating-bundles.html> "\(in Dataiku DSS v14\)").
    
    
    import dataiku
    
    # Get the API client to interact with Dataiku
    client = dataiku.api_client()
    
    # Export a bundle for your project
    PROJECT_KEY = "" # Fill with your project key
    project = client.get_project(PROJECT_KEY)
    BUNDLE_ID = "" # Fill with the unique identifier for the bundle
    release_notes = "" # Indicates the changes introduced by this bundle
    bundle = project.export_bundle(BUNDLE_ID, release_notes)
    

## Publishing the bundle

Once the bundle is available in the project, you need to publish it to the Project Deployer. The Project Deployer is the tool that will centralize the bundle, deployments, and deployment infrastructures.
    
    
    # Publish the bundle in a published project
    PUBLISHED_PROJECT_ID = "" # Fill with the identifier of the published project
    published_project = project.publish_bundle(BUNDLE_ID, PUBLISHED_PROJECT_ID)
    

Note

Using the method [`publish_bundle()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.publish_bundle> "dataikuapi.dss.project.DSSProject.publish_bundle") creates a new published project when the specified `PUBLISHED_PROJECT_ID` doesn’t exist. If you prefer to create a published project before using it, you can refer to this [code snippet](<../../../concepts-and-examples/project-deployer.html#ce-project-deployer-create-published-project>) for guidance.

## Choosing an infrastructure

The bundle will be deployed on a deployment infrastructure. The deployment infrastructure is a mechanism for organizing the resources and settings used during bundle deployment. You will find more details in the [Deployment infrastructures](<https://doc.dataiku.com/dss/latest/deployment/project-deployment-infrastructures.html> "\(in Dataiku DSS v14\)") documentation.

The choice depends on how you organize your Dataiku projects and infrastructure, but you can use this [code snippet](<../../../concepts-and-examples/project-deployer.html#ce-project-deployer-list-infra>) to list the existing deployment infrastructure identifiers.

## Creating a deployment

With a bundle and infrastructure identifiers, you can now use the [`DSSProjectDeployer`](<../../../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer> "dataikuapi.dss.projectdeployer.DSSProjectDeployer") class to create a deployment. This action will push all the necessary information to the targeted deployment infrastructure.
    
    
    # Get the project deployer to deploy and control deployment
    project_deployer = client.get_projectdeployer()
    
    INFRA_ID = "" # Fill with the deployment ID you chose
    DEPLOYMENT_ID = "" # Fill with your deployment ID
    deployment = project_deployer.create_deployment(deployment_id=DEPLOYMENT_ID, project_key=PUBLISHED_PROJECT_ID, infra_id=INFRA_ID, bundle_id=BUNDLE_ID)
    
    # Start the deployment
    update = deployment.start_update()
    update.wait_for_result()
    print(f"Deployment state: {update.state}")
    

## Complete code

Here is the complete code for this tutorial:

[deploy.py](<../../../_downloads/79b009e16b875d58a0eaca8cb4c76929/deploy.py>)
    
    
    import dataiku
    
    # Get the API client to interact with Dataiku
    client = dataiku.api_client()
    
    # Export a bundle for your project
    PROJECT_KEY = "" # Fill with your project key
    project = client.get_project(PROJECT_KEY)
    BUNDLE_ID = "" # Fill with the unique identifier for the bundle
    release_notes = "" # Indicates the changes introduced by this bundle
    bundle = project.export_bundle(BUNDLE_ID, release_notes)
    
    # Publish the bundle in a published project
    PUBLISHED_PROJECT_ID = "" # Fill with the identifier of the published project
    published_project = project.publish_bundle(BUNDLE_ID, PUBLISHED_PROJECT_ID)
    
    # Get the project deployer to deploy and control deployment
    project_deployer = client.get_projectdeployer()
    
    INFRA_ID = "" # Fill with the deployment ID you chose
    DEPLOYMENT_ID = "" # Fill with your deployment ID
    deployment = project_deployer.create_deployment(deployment_id=DEPLOYMENT_ID, project_key=PUBLISHED_PROJECT_ID, infra_id=INFRA_ID, bundle_id=BUNDLE_ID)
    
    # Start the deployment
    update = deployment.start_update()
    update.wait_for_result()
    print(f"Deployment state: {update.state}")
    

## Wrapping up/Conclusion

Congratulations! You are now able to deploy projects. For additional information, refer to the documentation on [Production deployments and bundles](<https://doc.dataiku.com/dss/latest/deployment/index.html> "\(in Dataiku DSS v14\)").

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.project.DSSProject`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployer`](<../../../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer> "dataikuapi.dss.projectdeployer.DSSProjectDeployer")(client) | Handle to interact with the Project Deployer.  
[`dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment`](<../../../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment")(...) | A deployment on the Project Deployer.  
  
### Functions

[`create_deployment`](<../../../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer.create_deployment> "dataikuapi.dss.projectdeployer.DSSProjectDeployer.create_deployment")(deployment_id, ...[, ...]) | Create a deployment and return the handle to interact with it.  
---|---  
[`export_bundle`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.export_bundle> "dataikuapi.dss.project.DSSProject.export_bundle")(bundle_id[, release_notes, ...]) | Creates a new project bundle on the Design node  
[`get_project`](<../../../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`get_projectdeployer`](<../../../api-reference/python/client.html#dataikuapi.DSSClient.get_projectdeployer> "dataikuapi.DSSClient.get_projectdeployer")() | Gets a handle to work with the Project Deployer  
[`publish_bundle`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.publish_bundle> "dataikuapi.dss.project.DSSProject.publish_bundle")(bundle_id[, ...]) | Publish a bundle on the Project Deployer.  
[`start_update`](<../../../api-reference/python/project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment.start_update> "dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment.start_update")() | Start an asynchronous update of this deployment.