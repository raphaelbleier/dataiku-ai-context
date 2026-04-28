# Dataiku Docs — webapps

## [webapps/bokeh]

# Bokeh web apps

Note

In addition to webapps, you can use Bokeh for interactive visualizations in a Jupyter notebook. You can also export “static” Bokeh visualizations (where you can zoom, pan, … but no advanced interaction) directly on the dashboard.

For more information, see [Using Bokeh](<../python/bokeh.html>)

To create a Bokeh web app, go to the Webapps list (click on the Code icon on the main toolbar then click on the Webapps tab), click new web app and select “Bokeh” web app, then select a template to begin.

In the Python code, you can use the regular Python API without restriction.

Each time you save your Bokeh webapp code, the Bokeh server restarts and displays the updated application; You can disable auto-restart in the settings. You can also select the code environment in the settings.

---

## [webapps/dash]

# Dash web apps

Note

Contrary to Bokeh, Dash is not installed by default in DSS. We recommend that you create and use a [code environment](<../code-envs/index.html>). You need to install the dash package. You can then choose that code environment in the settings of your Dash webapp.

DSS supports Dash versions 1.x (earlier 0.x versions may work but have not been qualified).

To create a Dash web app, go to the Webapps list (click on the Code icon on the main toolbar then click on the Webapps tab), click new web app and select “Dash” web app, then select a template to begin.

In the Python code, you can use the regular Python API without restriction.

Each time you save your Dash webapp code, the Dash server restarts and displays the updated application; You can disable auto-restart in the settings.

---

## [webapps/dashboard]

# Publishing webapps on the dashboard

Once you have created your webapp, you can publish it on the DSS dashboard, by clicking on “Actions > Publish”.

This creates an insight of type “webapp” and adds it to the selected dashboard(s).

The dashboard always shows the latest version of the webapp (if you save the webapp, the dashboard will be updated immediately).

## Accessing dashboard filters

[“Standard” web apps](<standard.html>) can access the dashboard filters by listening for messages sent from the dashboard. This allows to dynamically adjust the content of the webapp based on the filters applied in the dashboard.

Here is an example of how to access the dashboard filters using JavaScript:
    
    
    window.addEventListener('message', function(event) {
      const data = event.data;
      if (data && data.type === 'filters') {
          console.log(data.filters); // the filters
      }
    });
    

This code listens for messages sent to the webapp. When a message of type ‘filters’ is received, it logs the filters and their parameters to the console. You can use this information to update the webapp’s display dynamically.

---

## [webapps/direct-access]

# Direct access to webapps

## Webapp URL

Webapps can be directly accessed on the following URL:

`http(s)://DSS_BASE_URL/webapps/PROJECTKEY/webappId`

The webappId is the first 8 characters (before the underscore) in the URL of the webapp. For example, if the webapp URL in DSS is ``/projects/BULLDOZER/webapps/kUDF1mQ_shiny/view``, the webappId is `kUDF1mQ`

Note that this URL usually requires authentication and will redirect users to DSS login. For more details and options, please see [Public webapps](<public.html>).

## Vanity URL

In addition to the direct-access URL described above, admins can make the webapp available on a “nicer-looking” URL. The administrator can set this up in the webapps security settings. The webapp becomes available on `http(s)://DSS_BASE_URL/webapps/admin-chosen-name`

Warning

Please make sure to restart the webapp backend for these changes to take effect.

Note that this URL usually requires authentication and will redirect users to DSS login. For more details and options, please see [Public webapps](<public.html>).

---

## [webapps/index]

# Webapps

Note

See the [Developer Guide](<https://developer.dataiku.com/latest/tutorials/webapps/index.html> "\(in Developer Guide\)") for tutorials using this feature.

---

## [webapps/introduction]

# Introduction to DSS webapps

Web apps are custom applications hosted by DSS. Webapps can be used to write advanced visualizations or custom applicative front ends.

DSS allows you to write 4 kinds of web apps.

## “Standard” web apps

A standard webapp is made at least of HTML, CSS and Javascript code that you can write in the DSS webapp editor. DSS takes care of hosting your webapp and making it available to users with access to your data project.

The Javascript code that you write has access to various DSS APIs to fetch data from datasets.

In addition, your webapp can contain a Python backend. The Python backend has access to the whole DSS public and internal Python APIs and can thus query datasets, perform SQL queries, or do all kind of administrative tasks (provided the user running the webapp has sufficient permissions).

See also

For more information, see also:

  * The [HTML/CSS/JS: your first webapp](<https://developer.dataiku.com/latest/tutorials/webapps/standard/basics/index.html> "\(in Developer Guide\)") tutorial in the Developer Guide.




## Shiny web apps

A Shiny web app uses the [Shiny](<https://shiny.rstudio.com/>) R library. You write R code, both for the “server” part and “frontend” part. Using Shiny, it is easy to create interactive web apps that react to user input, without having to write any CSS or Javascript.

You write your Shiny code as you would outside of DSS, and DSS takes care of hosting your webapp and making it available to users with access to your data project.

In addition, the server R code has access to the whole DSS R API and can thus query datasets, perform SQL queries, or do all kind of administrative tasks (provided the user running the webapp has sufficient permissions).

## Bokeh web apps

A Bokeh web app uses the [Bokeh](<http://bokeh.pydata.org/en/latest/>) Python library. You write Python code, both for the “server” part and “frontend” part. Using Bokeh, it is easy to create interactive web apps that react to user input, without having to write any CSS or Javascript (Bokeh is the Python counterpart to Shiny).

You write your Bokeh code as you would outside of DSS, and DSS takes care of hosting your webapp and making it available to users with access to your data project.

In addition, the server Python code has access to the whole DSS Python API and can thus query datasets, perform SQL queries, or do all kind of administrative tasks (provided the user running the webapp has sufficient permissions).

See also

For more information, see also:

  * The [Bokeh: Your first webapp](<https://developer.dataiku.com/latest/tutorials/webapps/bokeh/basics/index.html> "\(in Developer Guide\)") tutorial in the developer guide.




## Dash web apps

A Dash web app uses the [Dash](<https://plotly.com/dash/>) Python library. You write Python code, both for the “server” part and “frontend” part. Using Dash, it is easy to create interactive web apps that react to user input, without having to write any CSS or Javascript.

You write your Dash code as you would outside of DSS, and DSS takes care of hosting your webapp and making it available to users with access to your project.

In addition, the server Python code has access to the whole DSS Python API and can thus query datasets, perform SQL queries, or do all kind of administrative tasks (provided the user running the webapp has sufficient permissions).

See also

For more information, see also:

  * The [Dash: your first webapp](<https://developer.dataiku.com/latest/tutorials/webapps/dash/basics/index.html> "\(in Developer Guide\)") tutorial in the developer guide.




## Streamlit web apps

A Streamlit web app uses the [Streamlit](<https://streamlit.io/>) Python library. Streamlit allows you to create interactive web apps that respond to user input, utilizing only Python code.

You write your Streamlit app as you would outside of DSS, and DSS takes care of hosting your web app and making it available to users with access to your project.

In addition, your app can use the DSS Python API to query datasets, perform SQL queries, or perform administrative tasks (provided the user running the webapp has sufficient permissions).

See also

For more information, see also:

  * The [Streamlit](<https://developer.dataiku.com/latest/tutorials/webapps/streamlit/index.html>) section in the developer guide.




# Example use cases

Here are a few examples of how a DSS webapp can be used:

## Custom visualizations

You want to build a kind of visualization that is not builtin in DSS, like a Sankey diagram. You start by creating a dataset with data in the proper format for your visualization, using the regular [DSS flow](<../flow/index.html>).

You then create a webapp:

  * Either a standard webapp, which uses _d3.js_ to perform the visualization. The Javascript that you write mixes d3.js with the Dataiku API to fetch the data from the dataset.

  * Or using a Shiny webapp: you only use R code to fetch the data from the dataset, build the UI, and use one of the numerous Shiny R packages to prepare your diagram.

  * Or using a Bokeh, Streamlit or Dash webapp: you only use Python code to fetch the data from the dataset and build the UI.




## Applicative frontend

You have created a segmentation model using DSS, and have used a scoring recipe to perform the segmentation on your whole customer base. You thus have a dataset with all your customers, stored in a SQL database. Now, you want your business users to be able to lookup a particular customer and get the associated segment. You can create a webapp to do that.

  * Either a standard webapp: the webapp presents a HTML frontend with a form for looking up various customer information. The JS code of the webapp relays the form to a Python backend that uses the DSS SQL APIs to perform queries in the SQL database, identify the matching customers and return them to the frontend.

  * Using a Shiny, a Bokeh or a Dash webapp to write only R (resp. Python) code.


[](<../_images/webapps_tab.png>)

## GraphQL interface

Visual Web Applications provide a powerful way to create new interactions with your data without writing any code. One example is a GraphQL-based API that enables programmatic access to Dataiku datasets and saved models. This allows teams to integrate Dataiku’s data and machine learning capabilities into external applications, notebooks, and analytical workflows.

To get started, install the GraphQL plugin. This plugin enables you to create a “GraphQL API” Visual WebApp that provides the following features:

  * **GraphQL Query Interface** : Query any configured Dataiku dataset using GraphQL, with automatic schema generation based on dataset columns. GraphQL’s flexible query syntax allows clients to request exactly the fields they need, reducing over-fetching and improving performance.

  * **ML Model Predictions** : Generate predictions using any Dataiku saved model through a simple JSON API. The prediction endpoint accepts feature values as input and returns model predictions, supporting both real-time inference and batch scoring workflows.

  * **Access Control** : Configure which datasets and models are accessible through the webapp settings to ensure proper governance and security over exposed resources.




You also have a notebook template with a ready-to-use Jupyter notebook with examples for accessing the API

---

## [webapps/kubernetes]

# Scaling webapps on Kubernetes

Webapp backends can run on Kubernetes for enhanced scalability.

Dataiku automatically handles exposing the webapp backend and making it available to end-users through Kubernetes services mechanisms.

---

## [webapps/public]

# Public webapps

Webapps are normally only available for logged-in DSS users who have at least:

  * the “Read dashboards” permission on the DSS project if the webapp is accessible to dashboard users

  * the “Read project content” permission on the DSS project if the webapp is not accessible to dashboard users.




It is also possible to make webapps public. When a webapp is public, being an authenticated user is not necessary in order to access the webapp, and no authorization control is performed. It is up to the webapp to implement its own authentication and authorization, if applicable.

Deciding whether a webapp can be made public is normally an administrator prerogative. In order to make a webapp public, an administrator must go to Administration > Settings > Security & Audit > Other security settings, and add the “PROJECTKEY.webappId” in the authentication whitelist.

The webappId is the first 8 characters (before the underscore) in the URL of the webapp. For example, if the webapp URL in DSS is ``/projects/BULLDOZER/webapps/kUDF1mQ_shiny/view``, the webappId is `kUDF1mQ`

Warning

Please make sure to restart the webapp backend for these changes to take effect.

---

## [webapps/security]

# Webapps and security

## Authentication of webapp users

By default, webapps require users to be authenticated. For more details and options, please see [Public webapps](<public.html>).

## Run-as-user

The code of the webapp itself always runs as a single user, the “run-as-user” of the webapp. By default, a webapp runs as the identity of the last DSS user who modified the webapp.

An administrator can modify the DSS user name under which the webapp runs. This is done in the settings of each individual webapp.

## Identifying users from within a webapp

When a logged-in DSS user accesses a webapp, the webapp’s code can identify which user is accessing the webapp. The webapp can use this information in order to customize the behavior for the user, to access user-specific information, or to deny access to some features, for example.

The exact way to do that depends on the webapp kind:

### Standard webapp

Please see <https://github.com/dataiku/dss-code-samples/tree/master/webapps/flask/authenticate-calls>

### Bokeh webapp

Please see [Authentication information and impersonation](<https://developer.dataiku.com/latest/api-reference/python/authinfo.html> "\(in Developer Guide\)"). In order to retrieve the request headers, you need the following:
    
    
    from bokeh.io import curdoc as bokeh_curdoc
    session_id = bokeh_curdoc().session_context.id
    from dataiku.webapps.run_bokeh import get_session_headers as get_bokeh_session_headers
    request_headers = get_bokeh_session_headers(session_id)
    
    auth_info = dataiku.api_client().get_auth_info_from_browser_headers(request_headers)
    

### Dash webapp

This works the same as a standard webapp. Just be careful to access request.header only in a callback, because there’s no active HTTP request initialization code.
    
    
    from flask import request
    @app.callback(
        Output(component_id='my-output', component_property='children'),
        [Input(component_id='my-input', component_property='value')]
    )
    def update_output_div(input_value):
        request_headers = dict(request.headers)
        auth_info_brower = dataiku.api_client().get_auth_info_from_browser_headers(request_headers)
        return auth_info_brower["authIdentifier"]
    

### FastAPI webapp

Please see [Authentication information and impersonation](<https://developer.dataiku.com/latest/api-reference/python/authinfo.html> "\(in Developer Guide\)"). In order to retrieve the request headers, you need the following:
    
    
    from fastapi import Request
    
    @app.get("/example")
    async def example_call(request: Request):
        request_headers = dict(request.headers)
        auth_info = dataiku.api_client().get_auth_info_from_browser_headers(request_headers)
    

### Streamlit webapp

Since version 1.37, the Streamlit API provides access to request headers, which can be used to query authentication information.
    
    
    import streamlit as st
    request_headers = dict(st.context.headers)
    auth_info = dataiku.api_client().get_auth_info_from_browser_headers(request_headers)
    

### Streamlit webapp

Since version 1.37, the Streamlit API provides access to request headers, which can be used to query authentication information.
    
    
    import streamlit as st
    request_headers = dict(st.context.headers)
    auth_info = dataiku.api_client().get_auth_info_from_browser_headers(request_headers)
    

### Shiny webapp

Please see [Authentication information](<../R-api/authinfo.html>)

### Access to secrets

The `get_auth_info_from_browser_headers` can be called with `with_secrets=True` in order to get decrypted user secrets (Please see [User secrets](<../security/user-secrets.html>) for more details).

This is possible because the end-user who is browsing the webapp has a DSS session cookie that the `get_auth_info_from_browser_headers` calls reads to retrieve information and secrets. If you want to block that behavior, you need to enable “Hide access tokens” in the Webapps security settings (Administration > Settings > Login & Security).

## Impersonating users from within a webapp

As indicated earlier, the backend code of a webapp runs as single user. However, the backend will very often perform calls to the Dataiku API, in order to read datasets, set variables, run scenarios, …

It is possible for these calls to the Dataiku API to be _impersonated_ in the name of the user currently viewing the webapp.

In order for a webapp to be able to impersonate other users in the Dataiku API, the run-as-user of the webapp must be granted the “Impersonation in webapps” permission to impersonate the _target_ users, i.e. end-users.

These settings are done at the group level. If the webapp runs as user RU1 (which belongs to group G1), and the end-users to impersonate, EU1 and EU2, who belong to group G2, you need to:

  * Go to the settings of G1

  * In “Impersonation in webapps”, put G2 as the allowed group.




This now allows webapps running as users of the G1 group to perform impersonated API calls in the name of users of the G2 group.

To actually perform impersonated calls, you need to modify your code this way:

### Standard webapps
    
    
    @app.route('/example')
    def example_call():
    
        # Calls performed using this client will be done as the run-as-user
        client = dataiku.api_client()
    
        # D1 will be read as the run-as-user
        df = dataiku.Dataset("d1").get_dataframe()
    
        with dataiku.WebappImpersonationContext() as ctx:
            # Calls performed using this client will be done as the end-user
            end_user_client = dataiku.api_client()
    
            # D2 will be read as the end-user
            df = dataiku.Dataset("d2").get_dataframe()
    

### Bokeh or Streamlit webapps
    
    
    def update_data(attrname, old, new):
    
        # Calls performed using this client will be done as the run-as-user
        client = dataiku.api_client()
    
        # D1 will be read as the run-as-user
        df = dataiku.Dataset("d1").get_dataframe()
    
        with dataiku.WebappImpersonationContext() as ctx:
            # Calls performed using this client will be done as the end-user
            end_user_client = dataiku.api_client()
    
            # D2 will be read as the end-user
            df = dataiku.Dataset("d2").get_dataframe()
    

### Dash webapps
    
    
    @app.callback(
        Output(component_id='my-output', component_property='children'),
        [Input(component_id='my-input', component_property='value')]
    )
    def update_output_div(input_value):
        # Calls performed using this client will be done as the run-as-user
        client = dataiku.api_client()
    
        # D1 will be read as the run-as-user
        df = dataiku.Dataset("d1").get_dataframe()
    
        with dataiku.WebappImpersonationContext() as ctx:
            # Calls performed using this client will be done as the end-user
            end_user_client = dataiku.api_client()
    
            # D2 will be read as the end-user
            df = dataiku.Dataset("d2").get_dataframe()
    

### FastAPI webapp
    
    
    @app.get('/example')
    async def example_call():
    
        # Calls performed using this client will be done as the run-as-user
        client = dataiku.api_client()
    
        # D1 will be read as the run-as-user
        df = dataiku.Dataset("d1").get_dataframe()
    
        with dataiku.WebappImpersonationContext() as ctx:
            # Calls performed using this client will be done as the end-user
            end_user_client = dataiku.api_client()
    
            # D2 will be read as the end-user
            df = dataiku.Dataset("d2").get_dataframe()
    

### Shiny webapps
    
    
    output$myPlot <- renderPlot({
        # D1 will be read as the run-as-user
        dkuReadDataset("d1")
    
        dkuImpersonateShinyCalls(session$request, {
            # D2 will be read as the end-user
            dkuReadDataset("d2")
        })
        ...
    })
    

## Access to static resources from webapps

Webapps may require static resources accessible from the frontend client to function correctly (css, additional javascript resources…). There are multiple ways to make those resources available through project / global code libraries.

### Project-level private resources

In the _Project library_ two directory are automatically exposed as static resources:

  * the static directory in the _Libraries_ tab is exposed under `http(s)://host:port/local/projects/PROJECT_KEY/static/`

  * the static directory in the _Resources_ tab is exposed under `http(s)://host:port/local/projects/PROJECT_KEY/resources/`




These resources will be directly available for users who have the authorization to read the project content. Editing these resources requires write permission on the project, and the _Write isolated code_ global permission (or _Write unisolated code_ if impersonation is disabled).

### Project-level public resources

In the _Project library_ any file in the local-static directory in the _Resources_ tab is exposed under `http(s)://host:port/local/projects/PROJECT_KEY/public-resources/`

These resources will be available for any user, even users that are not authenticated to the Dataiku DSS instance. Editing these resources requires write permission on the project, and the _Write isolated code_ global permission (or _Write unisolated code_ if impersonation is disabled).

### Global public resources

In the _Global shared code_ any file in the _Static Web Resources_ tab is exposed as public static resource under `http://host:port/local/static/`

These resources will be available for any user, even users that are not authenticated to the Dataiku DSS instance. Editing these resources requires the _Edit lib folders_ global permission.

---

## [webapps/shiny]

# Shiny web apps

To create a Shiny web app, go to the Webapps list (click on the Code icon on the main toolbar then click on the Webapps tab), click new web app and select “Shiny” web app, then select a template to begin.

You can then fill the “UI” and “Server” parts.

In the Server code, you can use the regular DSS R API without restriction.

Each time you save your Shiny webapp code, the Shiny server restarts and displays the updated application; You can disable auto-restart in the settings. You can also select the [code environment](<../code-envs/index.html>) in the settings.

---

## [webapps/standard]

# “Standard” web apps

To create a standard web app, go to the Webapps list (click on the Code icon on the main toolbar then click on the Webapps tab), click new web app and select “Standard” web app

For a standard web app, you need to write at least:

  * The HTML of your frontend

  * Some CSS code if you want to style it

  * Some Javascript code to make it do something




The Javascript code can use [The Javascript API](<../api/js/index.html>) to interact with datasets.

In addition, you can add a Python backend. A Python backend is a Python file which uses the Flask library, or the FastAPI library. In the Python code, declare your Flask or FastAPI routes, and query them from the JS part using any AJAX library.

---

## [webapps/streamlit]

# Streamlit web apps

Note

Streamlit is not installed by default in DSS. We recommend that you create and use a [code environment](<../code-envs/index.html>) containing `streamlit` as an additional package.

DSS recommends using Streamlit versions 1.40 or higher (earlier versions may work, but have not been qualified).

To create a Streamlit web app, go to the Webapps list (Hover on the Code icon on the main toolbar and select the Webapps menu item), click **+New web app** , choose **Streamlit** , select a template, and provide a name for your app.

A Streamlit web app consists of two parts:

  * Python code defining page layout and data visualizations

  * A configuration in toml format, defining theme and other streamlit settings




Each time you save your Streamlit webapp, the Streamlit backend restarts and displays the updated application; You can disable auto-restart in the settings.