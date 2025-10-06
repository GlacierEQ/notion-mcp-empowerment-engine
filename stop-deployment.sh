#!/bin/bash

# 🛑 STOP DEPLOYMENT - Graceful shutdown of all MCP services
# Case: 1FDV-23-0001009 Hawaii Family Court

echo "🛑 Gracefully stopping all MCP services..."

# Read process IDs if available
if [ -f ".deployment-pids" ]; then
    source .deployment-pids
    
    echo "🔄 Stopping MCP servers..."
    kill $MCP_OPENAI_PID $MCP_COURT_PID $MCP_MEMORY_PID $MCP_GITHUB_PID $MCP_NOTION_PID $MCP_FILESYSTEM_PID 2>/dev/null || true
    
    echo "🦁 Stopping LionAGI Orchestrator..."
    kill $LIONAGI_PID 2>/dev/null || true
    
    echo "📊 Stopping monitoring services..."
    kill $MONITOR_PID $MONITOR_PROC_PID 2>/dev/null || true
fi

# Stop Docker services
echo "🐳 Stopping Docker services..."
docker-compose -f docker-compose.cosmic.yml down

# Clean up
echo "🧹 Cleaning up..."
rm -f .deployment-pids

echo "✅ All MCP services stopped gracefully."
echo "🔄 To restart: ./deploy-high-power-persistent.sh"