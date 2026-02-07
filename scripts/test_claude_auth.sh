#!/bin/bash
# Test if Claude Code can authenticate with the proxy

echo "Testing Claude Code authentication with proxy..."
echo ""

# Test 1: Check if proxy is running
echo "1. Checking proxy status..."
if curl -s http://localhost:8089/health > /dev/null 2>&1; then
    echo "   ✅ Proxy is running"
else
    echo "   ❌ Proxy is not running"
    echo "   Run: nim-start"
    exit 1
fi

# Test 2: Check current model
echo ""
echo "2. Current model:"
CURRENT_MODEL=$(curl -s http://localhost:8089/v1/models/current | python3 -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null)
echo "   📊 $CURRENT_MODEL"

# Test 3: Test API call
echo ""
echo "3. Testing API call..."
RESPONSE=$(curl -s http://localhost:8089/v1/messages \
  -H "Content-Type: application/json" \
  -H "x-api-key: sk-ant-placeholder-for-nvidia-nim-proxy" \
  -d '{"model":"claude-3-5-sonnet-20241022","max_tokens":10,"messages":[{"role":"user","content":"hi"}]}')

if echo "$RESPONSE" | grep -q "content"; then
    echo "   ✅ API call successful"
    echo ""
    echo "Your proxy is working correctly!"
    echo ""
    echo "To use with Claude Code:"
    echo "   nim-claude"
else
    echo "   ❌ API call failed"
    echo "   Response: $RESPONSE"
    exit 1
fi
