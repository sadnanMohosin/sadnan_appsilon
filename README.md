# sadnan_appsilon
I have created this Biodiversity map view project for R Shiny developer role ,Appsilon.

Deployment link : https://sadnan.shinyapps.io/sadnan_appsilon_/

![Biodiversity Project](https://github.com/sadnanMohosin/sadnan_appsilon/blob/master/map.JPG)

Working on this project was challenging because of the huge data set size(around 20GB). It took some ideas to develop and make optimize the data set so that it don't take much time to load the visualization. 

I used **"shiny","shinydashboard","ggplot2",""shinyjs","shinyjs","plotly","leaflet","leaflet.extras","leaflet.providers","readxl","dplyr","tidyverse","DT"** packages for this project.

**app.R** file contains **ui.R** and **server.R** and the app is run from **app.R** file. css style sheet and other modules are available in **www** folder.

## Extras

### Beautiful UI 
I used css in the background to make the dashboard more beautiful. style sheets are available in **www/** folder ( style1_1.css and style2_4.css).

### Performance optimization
Dataset provided was very big and could not be loaded into rstudio without optimizing the dataset. I have used several optimization technique here.

1. Distributed clustering: The provided dataset is very big and can not be loaded in a IDE in a normal way. So I used ``Dask`` for this purpose. Dask was developed to natively scale common data science packages and the surrounding ecosystem to multi-core machines and distributed clusters when datasets exceed memory. 
2. Column reduction: From distributed cluster, I dropped all the unnecessary columns not used for this project. There were 37 columns before. After column reduction there were 10 columns. This drastically reduced the data size.
2. Normalizing Data: 
3. Partitioning:
4. Calling only the necessary file: