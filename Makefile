.PHONY: ui
ui: ## Run the duckdb ui with the local duckdb database attached
	@if [ ! -f local.duckdb ]; then \
		echo "❌ Error: 'local.duckdb' not found."; \
		echo "   Please run your SQLMesh plan/apply command first to generate the database."; \
		exit 1; \
	fi
	duckdb -ui -cmd "ATTACH 'local.duckdb' AS persistent; USE persistent;"
