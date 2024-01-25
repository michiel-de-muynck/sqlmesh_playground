FROM gitpod/workspace-postgres:2024-01-24-09-19-42

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
    pip install "duckdb==0.9.3.dev2938" "sqlmesh[web,github,postgres]==0.68.4"

USER gitpod
