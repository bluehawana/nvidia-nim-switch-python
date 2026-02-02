#!/bin/bash

# Test Claude Code from hongyanab folder
# This script demonstrates how to use Claude Code with NVIDIA NIM Switch

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Testing Claude Code from hongyanab Folder               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Navigate to hongyanab
cd /Users/harvadlee/Projects/hongyanab

echo "📁 Current directory: $(pwd)"
echo ""

# Check server
echo "1️⃣  Checking server status..."
export PATH="$HOME/.local/bin:$PATH"
nim-status | head -5
echo ""

# Show current model
echo "2️⃣  Current model:"
curl -s http://localhost:8089/v1/models/current | python3 -c "import sys, json; d = json.load(sys.stdin); print(f'   Model: {d[\"id\"]}\n   Provider: {d[\"owned_by\"]}')"
echo ""

# Test API with a simple question
echo "3️⃣  Testing API with a question..."
echo "   Question: 'What is 2+2?'"
echo ""

RESPONSE=$(curl -s -X POST http://localhost:8089/v1/messages \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 100,
    "messages": [
      {"role": "user", "content": "What is 2+2? Answer in one sentence."}
    ]
  }')

echo "   Response:"
echo "$RESPONSE" | python3 -c "import sys, json; d = json.load(sys.stdin); print(f'   {d[\"content\"][0][\"text\"]}')"
echo ""

# Show how to start Claude Code
echo "4️⃣  To start Claude Code from this folder:"
echo ""
echo "   Option 1 (Recommended):"
echo "   $ nim-claude"
echo ""
echo "   Option 2 (Manual):"
echo "   $ export ANTHROPIC_BASE_URL=http://localhost:8089"
echo "   $ claude -dangerously-skip-permissions"
echo ""

# Show web interface
echo "5️⃣  To switch models visually:"
echo "   $ nim-web"
echo "   Or open: http://localhost:8089/"
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ✅ Test Complete - Ready to use Claude Code!            ║"
echo "╚════════════════════════════════════════════════════════════╝"
