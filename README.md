Bios611-project1
===========
Coral Growth and Storms  Dataset
---------

This repo will eventually contain an analysis of the Coral Growth and Storms Dataset.

Usage
------

You'll need Docker and the ability to run Docker as your current user.
    > docker build . -t project1-env
    > docker run -v `pwd`:/home/rstudio -p 8787:8787\
    -e PASSWORD=<yourpassword> -t project1-env
 

This Docker container is based on rocker/verse. To run rstudio server:

    >docker run -p 8787:8787 -e PASSWORD=helloworld\
    -v `pwd`:/home/rstudio -t project1-env
    
Then connect to the machine on port 8787.