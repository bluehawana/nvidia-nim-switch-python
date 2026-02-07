#!/bin/bash
export ANTHROPIC_API_KEY="sk-ant-placeholder-for-nvidia-nim-proxy"
export ANTHROPIC_BASE_URL="http://localhost:8089"

echo "Testing Claude Code with proxy..."
echo "ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY:0:20}..."
echo "ANTHROPIC_BASE_URL: $ANTHROPIC_BASE_URL"
echo ""
echo "Running: claude --version"
claude --version
