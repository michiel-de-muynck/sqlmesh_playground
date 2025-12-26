.PHONY: clean
clean: ## Wipe all sqlmesh state, data and metadata (don't do this in a real project)
	@# Ask for confirmation
	@echo -n "WARNING: This will delete the local duckdb database and the 'sqlmesh' schema in Postgres.\nAre you sure? [y/N] " && read ans && [ $${ans:-N} = y ] || (echo "Aborted." && exit 1)

	@# Remove DuckDB data
	rm -f local.duckdb local.duckdb.wal

	@# Remove Postgres metadata
	PGPASSWORD=postgres psql -h db -p 5432 -U postgres -d postgres -c "DROP SCHEMA IF EXISTS sqlmesh CASCADE; CREATE SCHEMA sqlmesh;"
	@echo "Cleanup complete."
	
.PHONY: ui
ui: ## Run the duckdb ui with the local duckdb database attached
	@if [ ! -f local.duckdb ]; then \
		echo "❌ Error: 'local.duckdb' not found."; \
		echo "   Please run your SQLMesh plan/apply command first to generate the database."; \
		exit 1; \
	fi
	duckdb -ui -cmd "ATTACH 'local.duckdb' AS persistent; USE persistent;"
