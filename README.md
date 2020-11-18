Bios611-project1
===========
Coral Growth and Storms  Dataset
---------

This repo contains an analysis of the Coral Growth and Storms Dataset.

### Introduction

Coral reefs represent one of the most important ecosystems in the world, but they are threatened by a multitude of environmental stressors that are becoming more severe due to the impacts of climate change. One of the primary threats to coral reef health is rising seawater temperatures. However, there are many other stressors that may increase the susceptibility of corals to bleaching or reduced growth. One example is tropical storms, which can cause physical stress to corals and may potentially impact coral growth.

### Datasets

There are two datasets involved in this analysis (YIRCR12S_Growth.csv and YIRCR12S_StormRadius.csv). The first is data associated with one coral "core" collected from the Florida Keys in 2014. The analysis of coral cores is similar to that of analyzing the rings on a tree - they provide information about a coral's annual growth over time. This dataset includes linear extension data, calcification, and skeletal density for each year since 1890. By comparing historical coral growth to environmental data, we can better understand the relationship between the environmental conditions at a given point in history and variations in coral growth. Along this same vein, the second dataset that I am using is of all storms that came within 500km of this coral core since 1988 (although there is some less detailed data available for earlier years if I decide I want to explore it). This dataset also includes other values such as wind speed, storm radius, etc.

Usage
------

You'll need Docker and the ability to run Docker as your current user.

    >docker build . -t project1-env
    
This Docker container is based on rocker/verse. To run rstudio server:

    >docker run -v `pwd`:/home/rstudio -p 8787:8787\
    -e PASSWORD=<yourpassword> -t project1-env

Then connect to the machine on port 8787.


Report
-----
To make the final report for this project, use this command:

    >make report.pdf
    
Shiny
------
The Shiny app depends on the pre-processed sg.csv dataset.
To make this file, use this command:

    >make sg.csv

To run the R shiny app, use this command:

    >PORT=8080 make shiny
    
And go to this address in your browser to view the interactive plots:

    >http://localhost:8080/


Project 3
-----
Project 3 produces a map of storm points using Python. These points are colored based on storm category (0-5). It depends on the pre-processed sg.csv dataset, already saved in the data folder under project3.

To produce this plot, use this command:

    >make stormmap.png
