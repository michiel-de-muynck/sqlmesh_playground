FROM gitpod/workspace-postgres:2024-03-20-07-19-19

# This env var is used to force the 
# rebuild of the Gitpod environment when needed
ENV TRIGGER_REBUILD 0

USER root

RUN apt-get update && \
    apt-get install -y --fix-missing wget git tree ssh nano sudo nmap man tmux curl joe build-essential && \
    apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    pip install "duckdb==0.10.1" "sqlmesh[web,github,postgres]==0.80.1"

USER gitpod
