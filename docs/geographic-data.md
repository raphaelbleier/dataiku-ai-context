# Dataiku Docs — geographic-data

## [geographic/data]

# Geographic data

Dataiku DSS can connect to the following type of geographic data:

## GeoJSON files

DSS can read GeoJSON files stored on any filesystem.

DSS can also export any dataset containing a geographic column to GeoJSON

## ESRI Shapefiles

DSS can read ESRI Shapefiles. Please see [ESRI Shapefiles](<../connecting/formats/shapefile.html>) for more details

## WKT

Any column containing [WKT](<https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry>) can be treated as geographic data

## KML

DSS can read KML/KMZ files.

Note

This capability is provided by the “KML Format extractor”, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

## Snowflake

DSS can natively read and write the Snowflake GEOGRAPHY data type, which is read as geometry DSS columns.

Please see [Snowflake](<../connecting/snowflake.html>) for more details.

DSS can also push-down some geographic computation to Snowflake

## PostGIS

[PostGIS](<https://postgis.net/>) is a widely used PostgreSQL database extension that allows to store and process geospatial data.

DSS can natively read and write PostGIS geo data types.

Please see [PostgreSQL](<../connecting/sql/postgresql.html>) for more details.

DSS can also push-down some geographic computation to PostgreSQL / PostGIS

---

## [geographic/geocoding]

# Geocoding and reverse geocoding

  * Geocoding (sometimes called Forward Geocoding) is the process of transforming an address into geographic coordinates

  * Reverse geocoding is the process geographic coordinates into administrative information (country, region, city, …)




It should be noted that geocoding and reverse geocoding are always best-effort activities. It is not always possible to perform either of these activities, data may be incomplete depending on locations. Dataiku is not able to provide any guarantee as to the completeness of correctness of any geocoding-related data.

## Geocoding

Note

This capability is provided by the Geocoder plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

The Geocoder uses online geocoding service providers. Your DSS instance needs to have outgoing Internet access.

You will need an API key for most of these providers. Some providers have some free plans, sometimes with limits, sometimes with various usage policies. Please make sure to review the usage policy of each provider before using it.

Not all providers have the same level of coverage of the world, so you should use providers depending on their coverage.

Providers with “Batch available” usually have significantly better performance

Provider | Optimal for | Usage Policy | Batch available  
---|---|---|---  
ArcGIS | World |  |   
Baidu | China | API key |   
Bing | World | API key | yes  
CanadaPost | Canada | API key |   
FreeGeoIP | World |  |   
Gaode | China | API key |   
Geocoder.ca (Geolytica) | CA & US | Rate Limit |   
GeocodeFarm | World | Policy |   
GeoNames | World | Username |   
GeoOttawa | Ottawa |  |   
Gisgraphy | World | API key |   
Google | World | Rate Limit, Policy |   
HERE | World | API key |   
IPInfo | World | Rate Limit, Plans |   
Komoot (OSM powered) | World |  |   
LocationIQ | World | API Key |   
Mapbox | World | API key |   
MapQuest | World | API key | yes  
MaxMind | World |  |   
OpenCage | World | API key |   
OpenStreetMap | World | Policy |   
Tamu | US | API key |   
TGOS | Taiwan |  |   
TomTom | World | API key |   
USCensus | US |  | yes  
What3Words | World | API key |   
Yahoo | World |  |   
Yandex | Russia |  |   
  
The plugin provides a recipe. You can use this recipe multiple times in a row using different providers, for example in case the previous providers failed on some inputs. The recipe will only try to recompute rows for which outputs are not already filled.

## Reverse geocoding

DSS provides two different reverse geocoding capabilities:

  * A native one, which reverse geocodes at the city level, and uses bundled data. This reverse geocoder is available as a preparation processor. It does not use any external provider, does not need any API key or payment, and is fast

  * The ability to call external providers, which require API keys or payments, requires Internet access, and is usually significantly slower, but that provide better resolution (up to the address level)




### Bundled-data city-level reverse geocoder

Note

This capability is provided by the “Reverse geocoding” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

The reverse geocoding prepare processor takes geographic coordinates as input and extracts the different levels of administrative boundary to which it belongs (country, region, city …). The administrative boundaries we use are the ones defined in Open Street Map. The type of administrative boundary for each level depends on the country. For more information please refer to the [Open Street Map documentation](<https://wiki.openstreetmap.org/wiki/Tag:boundary=administrative>).

  * You need a column containing a Geo Point or a Geometry as input.

  * The processor outputs two columns per administrative level for which you provide a column name: one with the local name of the administrative entity and one with the English name.

  * Selecting “Output the smallest selected administrative area” will output the shape of the administrative entity. This polygon is encoded using [WKT format](<https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry>). It is displayed as a third column to the administrative level for which you provided a column name. In case several levels are selected, only the smallest in size is displayed (for instance if both city and country are selected, it will return the shape of the city).




### Online reverse geocoder

Note

This capability is provided by the “Geocoder plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

The Reverse Geocoder uses online reverse geocoding service providers. Your DSS instance needs to have outgoing Internet access.

You will need an API key for most of these providers. Some providers have some free plans, sometimes with limits, sometimes with various usage policies. Please make sure to review the usage policy of each provider before using it.

Not all providers have the same level of coverage of the world, so you should use providers depending on their coverage.

Providers with “Batch available” usually have significantly better performance

Provider | Optimal for | Usage Policy | Batch available  
---|---|---|---  
ArcGIS | World |  |   
Baidu | China | API key |   
Bing | World | API key | yes  
Gaode | China | API key |   
GeocodeFarm | World | Policy |   
Gisgraphy | World | API key |   
Google | World | Rate Limit, Policy |   
HERE | World | API key |   
Komoot (OSM powered) | World |  |   
LocationIQ | World | API Key |   
Mapbox | World | API key |   
MapQuest | World | API key |   
OpenCage | World | API key |   
OpenStreetMap | World | Policy |   
USCensus | US |  |   
What3Words | World | API key |   
Yandex | Russia |  |   
  
The plugin provides a recipe. You can use this recipe multiple times in a row using different providers, for example in case the previous providers failed on some inputs. The recipe will only try to recompute rows for which outputs are not already filled.

## Zipcode geocoding

Zipcode geocoding provides “Country + zipcode” –> “Geographic coordinates” resolution, at the city-level resolution.

Note

This capability is provided by the “Zipcode geocoding” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

It is available as a preparation recipe processor

  * You need a column containing the country (name or ISO code) and a column containing the zipcode

  * The processor outputs a Geo Point column

---

## [geographic/geoformula]

# Geographic formula functions

The [DSS Formula Language](<../formula/index.html>) contains several geography-related functions

[Geometry functions](<../formula/index.html#formula-index-geometry>) lists these functions:

  * [geoBuffer](<../formula/index.html#formula-index-geobuffer>)

  * [geoContains](<../formula/index.html#formula-index-geocontains>)

  * [geoEnvelope](<../formula/index.html#formula-index-geoenvelope>)

  * [geoMakeValid](<../formula/index.html#formula-index-geomakevalid>)

  * [geoSimplify](<../formula/index.html#formula-index-geosimplify>)

---

## [geographic/geojoin]

# Geo join

The Geo join visual recipe allows you to perform a join between two (or more) datasets based on geospatial matching conditions.

This visual recipe offers multiple geospatial matching conditions. Join clauses can be chained together to perform join operations on many input datasets. Matching conditions can be combined to perform complex operations. Like other join recipes in DSS, join types (INNER, LEFT, RIGHT, FULL or CROSS) are defined for each individual join clause.

Please see [Geo join: joining datasets based on geospatial features](<../other_recipes/geojoin.html>) for more details

---

## [geographic/georouting]

# Georouting and isochrones

  * Isochrones are polygons centered on a geopoint that define areas reachable within a certain time, taking into account itinerary and mean of transportation.

  * Georouting is the process of computing an itinerary with time and distance between two geopoints, depending on means of transportation.




Note

These capabilities are provided in DSS with the Geo Router plugin. It needs to be installed : Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>).

It should be noted that georouting and isochrones computation are always best-effort activities. It is not always possible to perform either of these activities, data may be incomplete depending on locations. Dataiku is not able to provide any guarantee as to the completeness or correctness of any georouting-related data.

## Route computation

Georouting is the process of computing an itinerary with time and distance between two geopoints (driving/walking/…).

You need to have a dataset with two geopoint columns. Select your dataset, and, from the right panel, select Geo Router. This creates a recipe.

You can then select the starting and destination geopoint columns and the transport mode (car, bicycle, walking).

The recipe outputs the dataset with:

  * a column containing the travel time.

  * a column containing the travel distance.

  * a column containing the itinerary as a geometry column (LINESTRING format), which you can then display using Geometry Map charts.




## Isochrones computation

Isochrones are polygons centered on a geopoint that define areas reachable within a certain time, taking into account itinerary and mean of transportation.

You need to have a dataset with a geopoint column. Select your dataset, and, from the right panel, select Geo Router. This creates a recipe.

You can then select the geopoint column, the travel time, and the transport mode (car, bicycle, walking).

The recipe outputs the dataset with an additional geometry column (in MULTIPOLYGON format) representing the isochrone, which you can then display using Geometry Map charts.

## The Geo Router plugin

The plugin uses an online routing service provided by Dataiku. Your DSS instance needs to have outgoing Internet access in order to use this capability.

When running the recipes, DSS users can chose to use a cache to store and retrieve results of the recipes for each row of the input dataset. This is to avoid making redundant calls to the server. In case of a UIF setup for DSS, each DSS user has a personal georouting cache that is stored in the associated UNIX user’s home directory, in _$UNIX_HOME/.cache/dss/plugins/georouting/_. In case of a non-UIF DSS setup, the cache is in the home directory of the UNIX user that runs DSS, in _$DSS_UNIX_HOME/.cache/dss/plugins/georouting/_. The caches can be deleted by running the Clear georouting cache macro. In a UIF setup, using this macro, each DSS user can clean his own cache. If the DSS admin wants to delete any user’s cache, he will have to manually delete the _$UNIX_HOME/.cache/dss/plugins/georouting/_ directory.

The plugin has several settings :

  * Batch size : number of rows of the input dataset that are processed simultaneously by the recipe. Increasing this value will reduce recipe run time, but can lead to out of memory errors.

  * Routes recipe parallel workers : number of parallel workers processing a batch of rows for the compute routes recipe. It is also the number of simultaneous queries that can be sent to the online server. Increasing this value will reduce recipe run times, but can lead to timeout errors from the online server.

  * Isochrones recipe parallel workers : Same as the previous setting, but for the isochrones recipe.

  * Maximum cache size : maximum size that can be allocated to the plugin cache. In case of a non UIF DSS setup, there is only one cache on the machine hosting DSS. In case of a UIF setup, there can be at most one cache per DSS user. Thus the total memory allocated to georouting caches on the machine can be _cache_size X number_of_DSS_users_.

---

## [geographic/index]

# Geographic data

Dataiku DSS has many features and capabilities to work with geographic data.

We recommend that you start from the following hands-on workshops in the Dataiku Knowledge Base:

  * [Introduction to Geospatial Analytics](<https://knowledge.dataiku.com/latest/ml/complex-data/geographic/index.html>)

  * [Creating Maps](<https://knowledge.dataiku.com/latest/visualize-data/charts/tutorial-no-code-maps.html>)

  * [Geographic Data Preparation](<https://knowledge.dataiku.com/latest/ml/complex-data/geographic/tutorial-geo-processing.html>)

  * [Working with Shapefiles](<https://knowledge.dataiku.com/latest/ml/complex-data/geographic/tutorial-shapefiles-us-census-data.html>)

  * [Geo-joining data](<https://knowledge.dataiku.com/latest/prepare-transform-data/join/tutorial-geo-join-recipe.html>)




This section presents in more details the various capabilities of Dataiku DSS to work with geographic data.

---

## [geographic/osm-enrichment]

# OSM Enrichment

This capability offers you to retrieve, for a specific geographic area, a list of given “Points of Interest” (POI) from OpenStreetMap. Two recipes are provided:

  * OpenStreetMap dataset enrichment: It takes as an input a dataset containing a column with polygons, and retrieves for each polygon the list of Points of Interest.

  * OpenStreetMap enrichment (deprecated: it will be removed in further versions): The input is not a dataset but a single polygon, specified either by drawing a bounding box on a map, or by giving coordinates of a bounding box. The recipe will retrieve all the Points Of Interest for this specific bounding box.




This capability is provided by the **OSM Enrichment** plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

Note

These capabilities expect coordinates to be expressed in the EPSG:4326 spatial reference system. You can convert coordinates by using the “Change coordinate system” step in a prepare recipe.

## How to use

The two recipes can be found by clicking on the OpenStreetMap Enrichment icon, on the right panel, in the **Plugin recipes** section.

### OpenStreetMap Dataset Enrichment

Let’s assume that you have a dataset containing a Geometry column, each row in this column corresponds to a polygon or a multi-polygons. For each of these polygons, you want to collect from Open Street Map the Points of Interests that are located within the boundaries of the polygon. By using the OSM Dataset Enrichment recipe, you’ll be able to get for each polygon, the different points of interests filtered by [tags](<https://taginfo.openstreetmap.org/tags>) or [keys](<https://taginfo.openstreetmap.org/keys>).

After clicking on the **OpenStreetMap Enrichment** icon on the right panel, select the **OpenStreetMap Dataset Enrichment recipe**.

#### Input

Dataset containing a Geometry column with POLYGON or/and MULTIPOLYGON.

#### Settings

  * **Input parameters** : The _Geometry column_ parameter lets you choose the column of your input dataset containing geometry data, composed of polygons or/and multipolygons.

  * **Filter Point Of Interests (POIs)**. _Type of POIs_ : this parameter is used to filter the points of interest on [tags](<https://taginfo.openstreetmap.org/tags>) (for example _amenity_) or [keys](<https://taginfo.openstreetmap.org/keys>) (for example _shop_). You can also specify, for a certain tag or key, a specific category of points of interest, for example `amenity=bank` or `shop:manga`. This parameter cannot be empty.

  * **Running mode**. _Request by batch:_ If selected, will perform requests by batches. It will be faster but can generate runtime errors issues.

  * **Output parameters**. _Additional POIs information_ : Create an additional column containing details about the points of interest. If selected= _POIs enrichment keys_ : Information to retrieve for each Point of Interest (for example _name_ , _brand_ , _operator_). The information are identified by [keys](<https://taginfo.openstreetmap.org/keys>). The information may not be available for all the points of interest so you may have empty rows. All the information about the point of interest will also be stored in the _tags_ column in the output dataset, in an array. This additional parameter simply enables you to get a precise information in a separate column.




#### Output

**Output dataset:** Dataset enriched with points of interest found in each geometry with one row per geometry per point of interest. Additional columns:

  * Geopoint: contains the location of the store with the Geopoint format.

  * Tags: contains all the information about the point of interest, stored as an array.

  * One column per input filter: for each filter specified in the _Type of POIs_ parameter, you’ll get one column with the detail about the type of category of the point of interest.

  * One column per input enrichment key: for each key specified in the _POIs enrichment keys_ parameter, you’ll get on column with the information value of the point of interest.

  * Failure_response: if the points of interest could not be retrieved, you’ll get the error message.




#### Limitations

Overpass API is a public API shared with a lot of users, and it has an important rate-limiting. If you want to use this recipe on big polygons, here are the strategies you should follow to get sure to get positive responses from the API:

  * Uncheck the _request by batch_ button.

  * Simplify your polygons coordinates.

  * Split your dataset.




### OpenStreetMap Enrichment (deprecated)

Warning

This recipe is deprecated and will be removed in further versions.

This recipe provides the ability to retrieve a list of given “Points of Interests” (POI) from OpenStreetMap for a given bounding box.

It also creates an aggregated heatmap based on the categories of the POI. The plugin is based on the [Overpass API](<https://wiki.openstreetmap.org/wiki/Overpass_API>).

#### Settings

You first need to set the bounding box of the POI you want to retrieve (min_latitude, min_longitude, max_latitude, max_longitude).

Then you need to specify the “grid_size”. We will take the box you just defined and divide the width and the height grid_size times, which means you will get grid_size*grid_size rectangles to aggregate the POI.

You can optionally decide to specify additional tags (ie POI) to retrieve. You can take a look at the available tags here. The default list for this plugin is shop, leisure, sport, tourism, historic, amenity, railway.

#### Limitations

Even if you specify additional tags in the advanced option, they will not be used in the heatmap because the possible values associated with the tags are very diverse and they need to be processed to classify them into some categories (food, public_service …).

You may have to refresh your browser the first time you create a recipe with this plugin (if the map doesn’t appear).

---

## [geographic/preparation]

# Geographic data preparation

The prepare recipe provides a variety of processors to work with geographic information. DSS also provides a set of formulas to compute geographic operations (see [Formula language](<../formula/index.html>))

## Geopoint converters

DSS provides two processors to convert between a Geopoint column and latitude/longitude columns:

  * [Create GeoPoint from lat/lon](<../preparation/processors/geopoint-create.html>)

  * [Extract lat/lon from GeoPoint](<../preparation/processors/geopoint-extract.html>)




## Resolve GeoIP

The [Resolve GeoIP](<../preparation/processors/geoip.html>) processor uses the GeoLite City database (<https://www.maxmind.com>) to resolve an IP address to the associated geographic coordinates.

It produces two kinds of information:

  * Administrative data (country, region, city, …)

  * Geographic data (latitude, longitude)




The output GeoPoint can be used for [Map Charts](<../visualization/charts-maps.html>).

## Reverse geocoding

Please see [Geocoding and reverse geocoding](<geocoding.html>)

## Zipcode geocoding

Please see [Geocoding and reverse geocoding](<geocoding.html>)

## Change coordinates system

This processor changes the Coordinates Reference System (CRS) of a geometry or geopoint column.

Source and target CRS can be given either as a EPSG code (e.g., “EPSG:4326”) or as a projected coordinate system WKT (e.g., “PROJCS[…]”).

Warning

Dataiku uses the WGS84 (EPSG:4326) coordinates system when processing geometries. Before manipulating any geospatial data in Dataiku, make sure they are projected in the WGS84 (EPSG:4326) coordinates system.

Use this processor to convert data projected in a different CRS to the WGS84 (EPSG:4326) coordinates system.

## Compute distances between points

The [Compute distance between geospatial objects](<../preparation/processors/geo-distance.html>) processor allows you to compute distance between points

## Create area around a geopoint

The [Create area around a geopoint](<../preparation/processors/geopoint-buffer.html>) processor performs creation of polygons centered on input geopoints. For each input geospatial point, a spatial polygon is created around it, delimiting the area of influence covered by the point (all the points that fall within a given distance from the geopoint). The shape area of the polygon can be either rectangular or circular (using an approximation) and the size will depend on the selected parameters.

## Extract from geo column

The [Extract from geo column](<../preparation/processors/geo-info-extractor.html>) processor extracts data from a geometry column:

  * centroid point,

  * length (if input is not a point),

  * area (if input is a polygon).

---

## [geographic/types]

# Geographic data types

DSS only supports 2D geography.

Columns in any DSS dataset can have one of two geographic data types:

  * geopoint: This column can contain the coordinates of a single point, expressed using WKT

  * geometry: This column can contain any geometry type (point, linestring, polygon, multipolygon), expressed using WKT




## Reference systems

Geographic data is associated with reference systems, sometimes also referred to as CRS (Coordinate Reference System) or SRID (spatial reference identifier), which indicates how the data is projected

Geographic data types in DSS do not reference a specific CRS.

Most processing capabilities in DSS assume that the data in geographic columns uses GPS coordinates, also known as WGS-84, SRID 4326 or EPSG:4326

You can change the CRS of a geographic column using the “Change CRS processor” in the prepare recipe

---

## [geographic/visualization]

# Visualizing geographic data

DSS natively supports visualization of geographic data on maps.

## Geospatial Preview

Dataiku DSS allows you to preview any geometry contained in a cell of meaning `Geometry` or `GeoPoint` into a map within a popup by either:

  * right-clicking on any cell and clicking on the `Preview` option

  * using the keyboard shortcut `shift + v` on geographic cells




This preview is available in:

  * the explore view

  * the dashboards

  * the prepare recipe

  * the visual analysis

  * the workspaces




Please see [Map Charts](<../visualization/charts-maps.html>) for more details