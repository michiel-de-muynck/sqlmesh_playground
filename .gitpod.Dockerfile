FROM gitpod/workspace-postgres:2023-11-24-15-04-57


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
    pip install "dbt-core==1.4.9" "dbt-postgres==1.4.9" \
    # pip install "sqlmesh[web,dbt,github,postgres]==0.58.2" is very slow because pip install duckdb takes forever
    # see https://stackoverflow.com/a/74078882

USER gitpod

# Create empty .dbt directory otherwise dbt complains
RUN mkdir /home/gitpod/.dbt
