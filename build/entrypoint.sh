#!/bin/bash

echo "Starting n8n with workflow import..."

# Function to import workflows
import_workflows() {
    if [ -d "/workflows" ] && [ "$(ls -A /workflows 2>/dev/null)" ]; then
        echo "Found workflows directory with files. Importing workflows..."

        # Start n8n in background for import operations
        n8n start &
        N8N_PID=$!

        # Wait for n8n to be ready
        echo "Waiting for n8n to initialize..."
        sleep 15

        # Import workflows
        for workflow_file in /workflows/*.json; do
            if [ -f "$workflow_file" ]; then
                echo "Importing workflow: $(basename "$workflow_file")"
                n8n import:workflow --input="$workflow_file" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo "Successfully imported: $(basename "$workflow_file")"
                else
                    echo "Note: Workflow may already exist or import failed: $(basename "$workflow_file")"
                fi
            fi
        done

        # Activate all workflows
        echo "Activating all workflows..."
        n8n update:workflow --all --active=true 2>/dev/null

        # Stop the background n8n process
        kill $N8N_PID 2>/dev/null || true
        wait $N8N_PID 2>/dev/null || true

        echo "Workflow import completed."
    else
        echo "No workflows found to import."
    fi
}

# Import workflows if any exist
import_workflows

# Start n8n server
echo "Starting n8n server..."
exec n8n start
