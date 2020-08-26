Bios611-project1
===========
Superhero Powers Dataset
---------

This repo will eventually contain an analysis of the Superhero Powers Dataset.

Usage
------

You'll need Docker and the ability to run Docker as your current user.

This Docker contained is based on rocker/verse. To run rstudio server:

    >docker run -p 8787:8787 -e PASSWORD=helloworld\
    -v `pwd`:/home/rstudio -t project1-env
    
Then connect to the machine on port 8787.