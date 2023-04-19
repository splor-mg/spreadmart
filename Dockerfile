FROM rocker/r-ver:4.2.3

WORKDIR /project

RUN /rocker_scripts/install_python.sh
