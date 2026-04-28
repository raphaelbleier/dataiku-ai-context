# Dataiku Docs — python

## [python/bokeh]

# Using Bokeh

Bokeh is a Python interactive visualization library that provides interactive plots and dashboards. There are several ways you can use Bokeh in DSS:

  * For fully-interactive interaction (multiple charts, various controls, …), by creating a [Bokeh webapp](<../webapps/index.html>)

  * To display interactive (pan/zoom/…) charts within a Jupyter notebook

  * To display interactive (pan/zoom/…) charts on a Dashboard




Documentation for Bokeh is available at <https://bokeh.pydata.org>

## Installing Bokeh

You need to install the Bokeh package in a [code environment](<../code-envs/index.html>).

## Creating a Bokeh interactive web application

See [Webapps](<../webapps/index.html>)

## Displaying charts in a Jupyter notebook

To display plot.ly charts in a Jupyter notebook, use this cell once in the notebook:
    
    
    from bokeh.io import output_notebook, show
    output_notebook()
    

You can then use `show()` to show Bokeh figures

For example, to display a chart showing simple circles:
    
    
    from bokeh.plotting import figure
    
    f = figure()
    f.circle([1,2,3], [4,5,6], size=10)
    
    show(f)
    

A complete documentation for the usage of Bokeh in a Jupyter notebook can be found at <https://docs.bokeh.org/en/latest/docs/user_guide/output/jupyter.html>

### Using interactive controls in the Jupyter notebook

You can use interactive controls (sliders, inputs, …) that are displayed in the notebook. When you change these controls, the Bokeh chart can react dynamically.

Documentation for this is available here: <https://docs.bokeh.org/en/latest/docs/user_guide/output/jupyter.html#jupyter-interactors>

## Displaying Bokeh charts on a dashboard

Bokeh charts generated using Python code can be shared on a DSS dashboard using the “static insights” system. This does not include the capability to include controls. If you want to use Bokeh controls on a DSS Dashboard, use a Bokeh webapp.

Each Bokeh figure can become a single insight in the dashboard. Each chart will retain full zoom/pan/select/export capabilities;

To do so, create [static insights](<https://developer.dataiku.com/latest/api-reference/python/static-insights.html> "\(in Developer Guide\)")
    
    
    from dataiku import insights
    
    # f is a Bokeh figure, or any object that can be passed to show()
    
    insights.save_bokeh("my-bokeh-plot", f)
    

From the Dashboard, you can then add a new “Static” insight, select the `my-bokeh-plot` insight

### Refreshing charts on a dashboard

You can refresh the charts automatically on a dashboard by using a scenario to re-run the above piece of code.

This call to `dataiku.insights` code can be:

  * In a DSS recipe (use a regular “Build” scenario step)

  * In a Jupyter notebook (use a “Export notebook” scenario step)

  * As a custom Python scenario step




## Displaying images in Bokeh

To plot images in Bokeh, the image path specified must be relative to your “current location”.

You can plot images in a Jupyter notebook or display them in a webapp.

Images can be stored in `DATADIR/local/static`. An administrator can upload images to the DSS UI by going to Global Shared Code > Static Web Resources > +Add.

### In a Jupyter notebook

Here’s an example of displaying an image in a Jupyter notebook:
    
    
    import dataiku
    from bokeh.plotting import figure, show
    from bokeh.io import output_notebook
    
    path = '/local/static/cat-image.jpg'
    f = figure(x_range=(0,1), y_range=(0,1), width=1000, height=500)
    f.image_url(url=[path], x=0, y=0, w=1, h=1, anchor='bottom_left')
    output_notebook()
    show(f)
    

### In a webapp

From a webapp, you’ll need to refer to the relative path to your image.

To refer to the image saved in `DATADIR/local/static` from a Bokeh webapp, you can use the relative path from the webapp directory:
    
    
    import os
    from bokeh.plotting import figure
    from bokeh.layouts import row, widgetbox
    from bokeh.io import curdoc
    
    # get the full path to the image, and convert it to a relative path for the webapp
    full_path = os.path.join(os.environ["DIP_HOME"], 'local/static/cat-image.jpg')
    relative_path = os.path.relpath(full_path)
    
    plot = figure(x_range=(0,1), y_range=(0,1), width=1000, height=500)
    plot.image_url(url=[relative_path], x=0, y=0, w=1, h=1, anchor='bottom_left')
    curdoc().add_root(row(plot, width=800))
    

For webapps, the image should be small enough to ensure a reasonable load time.

---

## [python/doc-portal]

# Documentation Portal

## Auto-generated Python documentation

The Documentation Portal serves as a centralized source of auto-generated Python documentation for custom code within Dataiku. It indexes Project Libraries and Global Shared Code, facilitating code discovery and reuse across the instance.

If multiple library sources contain a module or package with the same name, DSS resolves it using Python path order: the first matching module or package is used. For project libraries, this order is defined by the project library configuration (`pythonPath` in `external-libraries.json`).

## Documentation Extraction

Documentation is generated using static analysis. This method examines the structure of each file independently without executing the code. Consequently, imports are not resolved to their source, and hyperlinks are not generated for objects defined in other files.

This approach ensures documentation is generated safely and reliably, even if the project’s environment dependencies are not currently installed.

## Generation Frequency

The documentation is generated automatically during DSS instance startup. It is subsequently refreshed whenever a file within the Global Shared Code or Project Libraries is modified.

After code changes, updates are not immediate: the indexing job runs on a short cycle (30 seconds by default), then processing time is required. Depending on instance load and library size, updated documentation can take from a few seconds to a few minutes to appear.

## Access

You can open the Documentation Portal from the DSS interface:

  * Application menu > Documentation Portal for the instance-wide view.

  * Python code recipes, Python webapps, Agent tool (Custom Python), and Agents & GenAI Models (Code Agent), where documentation is available in an embedded view.

---

## [python/ggplot]

# Using Ggplot

ggplot is a plotting system for Python based on R’s ggplot2 and the Grammar of Graphics. It is built for making professional looking, plots quickly with minimal code.

---

## [python/index]

# DSS and Python

DSS includes deep integration with Python. In many parts of DSS, you can write Python code:

  * In recipes

  * In Jupyter notebooks

  * In standard webapp backends

  * In scenarios, metrics and checks

  * In plugins

  * For custom models in visual ML

  * In API node, for [custom prediction models](<../apinode/endpoint-python-prediction.html>) or [custom functions](<../apinode/endpoint-python-function.html>) endpoints




Any Python package may be used in DSS.

In addition, DSS features a complete Python API, which has its own [complete documentation](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)").

The following highlights how a few specific Python packages can be used in DSS. DSS features advanced integration with most of the packages described below.

---

## [python/ipywidgets]

# Using Jupyter Widgets

Jupyter Widgets (a.k.a ipywidgets) are a way to build interactive GUIs in Jupyter notebooks.

For more information about widgets, see the [documentation](<https://ipywidgets.readthedocs.io>).

## Setup

Support for widgets needs to be enabled globally in the DSS Jupyter notebook by an administrator

  * Go to the DSS data directory

  * Run the following commands, where

>     * DATADIR is the absolute path to the DSS data directory
> 
>     * INSTALLDIR is the absolute path to the DSS installation directory (`dataiku-dss-X.Y.Z`)
>     
>     JUPYTER_CONFIG_DIR="$DATADIR/jupyter-run/jupyter" JUPYTER_DATA_DIR="$DATADIR/jupyter-run/jupyter"  PYTHONPATH="$INSTALLDIR/dku-jupyter/packages/" ./bin/python -m notebook.nbextensions install --py widgetsnbextension --user
>     
>     JUPYTER_CONFIG_DIR="$DATADIR/jupyter-run/jupyter" JUPYTER_DATA_DIR="$DATADIR/jupyter-run/jupyter"  PYTHONPATH="$INSTALLDIR/dku-jupyter/packages/" ./bin/python -m notebook.nbextensions enable --py widgetsnbextension
>     

  * Check installation:

> JUPYTER_CONFIG_DIR="$DATADIR/jupyter-run/jupyter" JUPYTER_DATA_DIR="$DATADIR/jupyter-run/jupyter"  PYTHONPATH="$INSTALLDIR/dku-jupyter/packages/" ./bin/python -m notebook.nbextensions list
>         




> This command should have output like:
>
>> 
>>     jupyter-js-widgets/extension  enabled
>>      - Validating: OK
>>     

  * Edit `bin/env-site.sh` and add the following line

> export JUPYTER_CONFIG_DIR="$DIP_HOME/jupyter-run/jupyter"
>         

  * Restart DSS




## Using widgets

Open a new notebook, and enter sample widget code:

Note

If you are using a custom code env, don’t forget to included the ipywidgets package in your code env
    
    
    import ipywidgets
    
    ipywidgets.IntSlider()
    

A slider should appear. You can now use ipywidgets.

---

## [python/matplotlib]

# Using Matplotlib

Matplotlib is a Python plotting library which produces a large variety of visuals. There are several ways you can use Matplotlib in DSS:

  * To display charts within a Jupyter notebook

  * To display charts on a Dashboard




Documentation for Matplotlib is available at <https://matplotlib.org/>

## Installing Matplotlib

  * If you are using the DSS built-in environment, Matplotlib is already installed. You don’t need to do any specific installation

  * If you are using a [code environment](<../code-envs/index.html>), you need to install the matplotlib package




## Displaying charts in a Jupyter notebook

To display Matplotlib charts in a Jupyter notebook, the easiest is to simply execute the first cell of the notebook:
    
    
    %pylab inline
    

This automatically imports the `matplotlib` and `matplotlib.pyplot as plt` packages. It also imports `numpy as np`.

You can then use the regular Matplotlib functions.

For example, to reproduce the simplest sample “sin” figure, use:
    
    
    # Data for plotting
    t = np.arange(0.0, 2.0, 0.01)
    s = np.sin(2 * np.pi * t)
    
    plt.plot(t, s)
    

The chart displays inline in the Jupyter notebook

## Displaying Matplotlib charts on a dashboard

Matplotlib charts generated using Python code can be shared on a DSS dashboard using the “static insights” system. -

Each Matplotlib figure can become a single insight in the dashboard.

To do so, create [static insights](<https://developer.dataiku.com/latest/api-reference/python/static-insights.html> "\(in Developer Guide\)")
    
    
    from dataiku import insights
    
    # This form saves the last displayed figure
    insights.save_figure("my-matplotlib-plot")
    
    # If f is a matplotlib figure object, you can save explicitly this figure
    # rather than the last displayed one
    
    insights.save_figure("my-matplotlib-explicit-plot", f)
    

From the Dashboard, you can then add a new “Static” insight, select the `my-matplotlib-plot` insight

### Refreshing charts on a dashboard

You can refresh the charts automatically on a dashboard by using a scenario to re-run the above piece of code.

This call to `dataiku.insights` code can be:

  * In a DSS recipe (use a regular “Build” scenario step)

  * In a Jupyter notebook (use a “Export notebook” scenario step)

  * As a custom Python scenario step




## Using matplotlib in a recipe

Matplotlib is based on a concept of backends. Each backend knows how to display figures. When running Python on your local machine, Matplotlib will by default pop a graphical window (a Windows, macOS or Linux window) to show each plot. This is done using a specific backend for each OS.

In a notebook, when using ``%pylab inline``, it automatically activates a specific backend that displays the plots inline within the Jupyter interface.

In a recipe or in a custom Python scenario step, the notebook backend is not available. You must thus, as the very first action in your recipe, use the following code:
    
    
    import matplotlib
    matplotlib.use("Agg")
    

This forces the use of the “Agg” backend which performs rendering of the charts in-memory. Charts can then be exported to PNG, …

Warning

This `matplotlib.use("Agg")` must take place before `import matplotlib.pyplot`. Failure to do so will generally result in an error with “Tkinter”. This error is caused by the fact that Matplotlib will by default try to import a backend called “TCL/TK” which is based on the “Tkinter” Python library, which is not usually installed

---

## [python/packages]

# Installing Python packages

Any Python package can be used in DSS. There is no restriction to which package can be installed and used.

The recommended way to install your own Python packages is to install them in a [code environment](<../code-envs/index.html>).

## Additional prerequisites

Some Python packages may require additional system dependencies if they include native code. In particular, you may need to install system development tools, the development package for the Python interpreter itself, and additional development libraries.

If you get an error when installing a Python package, please refer to [code environment troubleshooting](<../code-envs/troubleshooting.html>).

## Installing in a specific code environment (recommended)

Please see [Operations (Python)](<../code-envs/operations-python.html>).

## Making custom Python packages available

Please see [Reusing Python code](<reusing-code.html>)

---

## [python/plotly]

# Using Plot.ly

Note

This section deals with using plot.ly using Python code. plot.ly can also be used through R code.

Plot.ly is a service and Python interactive visualization library that lets users easily create interactive charts and dashboards, that can optionally be shared through an online service. There are several ways you can use Plot.ly in DSS:

  * To display interactive (pan/zoom/…) charts within a Jupyter notebook

  * To display interactive (pan/zoom/…) charts on a Dashboard




Documentation for Plot.ly is available at <https://plot.ly/python/>

## Installing plot.ly

You need to install the `plotly` package. The recommended method for doing so is to use a [code environment](<../code-envs/index.html>). See [how to install Python packages](<packages.html>)

## Displaying charts in a Jupyter notebook

To display plot.ly charts in a Jupyter notebook, use:
    
    
    import plotly.offline as py
    
    py.iplot(data_object)
    

For example, to display a simple line:
    
    
    import plotly.offline as py
    import plotly.graph_objs as go
    
    scatter = go.Scatter(x =[1,2,3], y = [10, 15, 13])
    data = go.Data([scatter])
    
    py.iplot(data)
    

## Displaying charts on a dashboard

plot.ly charts generated using Python code can be shared on a DSS dashboard using the “static insights” system.

Each plot.ly figure can become a single insight in the dashboard. Each chart will retain full zoom/pan/select/export capabilities;

To do so, create [static insights](<https://developer.dataiku.com/latest/api-reference/python/static-insights.html> "\(in Developer Guide\)")
    
    
    from dataiku import insights
    
    # f is a plot.ly figure, or any object that can be passed to iplot()
    
    insights.save_plotly("my-plotly-plot", f)
    

From the Dashboard, you can then add a new “Static” insight, select the `my-plotly-plot` insight

### Refreshing charts on a dashboard

You can refresh the charts automatically on a dashboard by using a scenario to re-run the above piece of code.

This call to `dataiku.insights` code can be:

  * In a DSS recipe (use a regular “Build” scenario step)

  * In a Jupyter notebook (use a “Export notebook” scenario step)

  * As a custom Python scenario step

---

## [python/reusing-code]

# Reusing Python code

When you write a lot of Python code in a project, or across projects, you will often want to make reusable parts of code.

DSS provides several mechanisms for reusing Python code:

  * Packaging your code as functions or modules, and making them available in a specific project

  * Importing code that has been made available from one project to another

  * Packaging your code as functions or modules, and making them available in all projects

  * Packaging your code as a reusable plugin, and making it available for coder and non-coder users alike




## Sharing Python code within a project

In each project, you can write Python modules in the **Library editor**. The project’s library editor is available by going into the “Code” universe (orange), and selecting the “Libraries” tab.

You can then write code under a “Python source” folder, i.e. a folder that has the “Python” icon associated to it.

Modules that are written here are automatically available in all Python code in the same project. Import rules are the regular Python rules.

For example, to use the function shown in the above image, use:
    
    
    from analyticfunctions import build_custom_keras_model
    model = build_custom_keras_model()
    

or:
    
    
    import analyticfunctions
    model = analyticfunctions.build_custom_keras_model()
    

Note

Don’t forget that if you create subfolders in a Python source folder, each folder must have a `__init__.py` file in order to be a valid Python module

For a file at the root of the library editor:

Use:
    
    
    from misccustom import get_now
    the_time = get_now()
    

or:
    
    
    import misccustom
    the_time = misccustom.get_now()
    

### Working with multiple source folders

By default, the Library editor contains two top-level folders, “python” and “R”, which are respectively the root folder for Python and R code.

You can create other folders that will also act as Python source folders, i.e. that will be added to the `PYTHONPATH` (or `sys.path`) of the Python processes of the project.

Working with multiple source folders is mainly useful when [importing code from external Git repositories](<../collaboration/import-code-from-git.html>). When using this, addition of the new folders is automatic.

To manually edit the list and order of the Python source folders, open the `external-libraries.json` file in the library editor and edit the `pythonPath` list. All paths must be relative to the root of the library editor.

## Importing libraries from other projects

If you have created libraries in a project A, you can import them in project B. The libraries of project A will be added to the source path of all code running in project B.

  * Go to the library editor of project B

  * Open the `external-libraries.json` file

  * Edit the `importLibrariesFromProjects` list and add the project key (which appears in the URL, i.e. not the project display name) to it

  * Save the `external-libraries.json` file




You need to have “Read project content” permission on A and “write project content” on B.

## Sharing Python code globally

In addition to the per-project Python library editor, there is another global Python library editor for the whole instance. The global Python library editor is available from the **Application menu > Global Shared Code**.

Modules that are written here are automatically available in all Python code in all projects. Import rules follow the regular Python rules (see above for more information).

### Permissions

You need the “Edit lib folders” global (group-level) permission to use the global Python library editor.

Caution

Putting code in the global library increases the risk of having clashes or conflicts. Generally speaking, it is preferable to use per-project libraries.

Libraries in the global folder will be importable in all Python code, regardless of the active [code environment](<../code-envs/index.html>). You should ensure that your code is compatible with Python 3.

Warning

Although global libraries are included in [API node service packages](<../apinode/concepts.html>), they are not included in [project bundles](<../deployment/creating-bundles.html>).

## Manual editing of code library folders

Although not recommended, if you have shell access to the DSS machine, you can modify the library folders directly:

  * Per-project library folder is in `DATA_DIR/config/projects/PROJECT_KEY/lib`

  * Global library folder is in `DATA_DIR/lib/python`




## Packaging code as plugins

See [Plugins](<../plugins/index.html>)

---

## [python/spacy]

# Using SpaCy

SpaCy is a Python library for Natural Language Processing (NLP) such as tokenization, named entity recognition with pre-trained models for several languages.

Documentation for SpaCy is available at <https://spacy.io/>

## Installing SpaCy

In a [code environment](<../code-envs/index.html>), you need to install the `spacy` package.

To add a specific pre-trained model, you can add the URL of the pip package for that model, as specified in the [Installation via pip](<https://spacy.io/usage/models#download-pip>) page of the SpaCy documentation.

For example for the English model, your code env’s Requested Packages could be:
    
    
    spacy
    https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.2.0/en_core_web_sm-2.2.0.tar.gz
    

See SpaCy’s [Models](<https://spacy.io/models>) page for a list of languages.

## Using SpaCy models

In a python notebook or recipe (using the aforementioned code environment), you can then import `spacy` and use `spacy.load` with the model package name:
    
    
    import spacy
    nlp = spacy.load("en_core_web_sm")
    doc = nlp(u"This is an example sentence.")