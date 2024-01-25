FROM gitpod/workspace-postgres:2024-01-24-09-19-42


# This env var is used to force the 
# rebuild of the Gitpod environment when needed
ENV TRIGGER_REBUILD 0

USER root

RUN apt-get update && \
    apt-get install -y wget git tree ssh nano sudo nmap man tmux curl joe && \
    apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    pip install "dbt-core==1.4.9" "dbt-postgres==1.4.9" "sqlmesh[web,dbt,github,postgres]==0.68.4"

USER gitpod

# Create empty .dbt directory otherwise dbt complains
RUN mkdir /home/gitpod/.dbt
