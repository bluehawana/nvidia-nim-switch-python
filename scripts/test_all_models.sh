#!/bin/bash

# Test all NVIDIA NIM models to find which ones work
# Usage: ./scripts/test_all_models.sh [base_url]

BASE_URL="${1:-http://localhost:8089}"
RESULTS_FILE="working_models.txt"
FAILED_FILE="failed_models.txt"

echo "Testing all models against $BASE_URL"
echo "This will take a while..."
echo ""

# Clear previous results
> "$RESULTS_FILE"
> "$FAILED_FILE"

# Get all models
MODELS=$(curl -s "$BASE_URL/v1/models" | python3 -c "import sys, json; data=json.load(sys.stdin); print('\n'.join([m['id'] for m in data['data']]))")

TOTAL=$(echo "$MODELS" | wc -l)
COUNT=0

echo "Found $TOTAL models to test"
echo ""

for model in $MODELS; do
    COUNT=$((COUNT + 1))
    echo -n "[$COUNT/$TOTAL] Testing $model... "
    
    RESPONSE=$(curl -s -X POST "$BASE_URL/v1/messages" \
        -H "Content-Type: application/json" \
        -H "x-api-key: test" \
        -H "anthropic-version: 2023-06-01" \
        -d "{\"model\": \"$model\", \"messages\": [{\"role\": \"user\", \"content\": \"hi\"}], \"max_tokens\": 10}" 2>&1)
    
    if echo "$RESPONSE" | grep -q '"type":"message"'; then
        echo "✅ WORKS"
        echo "$model" >> "$RESULTS_FILE"
    else
        echo "❌ FAILED"
        echo "$model" >> "$FAILED_FILE"
    fi
    
    # Rate limit: wait 1 second between requests
    sleep 1
done

echo ""
echo "=========================================="
echo "Testing complete!"
echo "=========================================="
echo ""
WORKING_COUNT=$(wc -l < "$RESULTS_FILE")
FAILED_COUNT=$(wc -l < "$FAILED_FILE")
SUCCESS_RATE=$(python3 -c "print(f'{($WORKING_COUNT / $TOTAL * 100):.1f}')")

echo "Working models: $WORKING_COUNT"
echo "Failed models: $FAILED_COUNT"
echo "Success rate: $SUCCESS_RATE%"
echo ""
echo "Results saved to:"
echo "  - $RESULTS_FILE (working)"
echo "  - $FAILED_FILE (failed)"
echo ""

# Generate MODEL_COMPATIBILITY.md
echo "Generating docs/MODEL_COMPATIBILITY.md..."

cat > docs/MODEL_COMPATIBILITY.md << EOF
# NVIDIA NIM Model Compatibility

This document lists all tested models and their compatibility status with the NVIDIA NIM Switch.

**Last Updated:** $(date +"%B %d, %Y")  
**Total Models Tested:** $TOTAL  
**Working Models:** $WORKING_COUNT  
**Success Rate:** $SUCCESS_RATE%

## ✅ Working Models ($WORKING_COUNT total)

The following models have been tested and confirmed working:

\`\`\`
$(cat "$RESULTS_FILE")
\`\`\`

## ❌ Non-Working Models ($FAILED_COUNT total)

The following models returned errors during testing (may require paid tier or special access):

<details>
<summary>Click to expand failed models list</summary>

\`\`\`
$(cat "$FAILED_FILE")
\`\`\`

</details>

## 🔄 Testing Your Own Setup

To test all models on your deployment:

\`\`\`bash
./scripts/test_all_models.sh http://localhost:8089
\`\`\`

Or against a remote server:

\`\`\`bash
./scripts/test_all_models.sh https://your-domain.com
\`\`\`

---

**Note:** Model availability depends on your NVIDIA API key tier. Free tier has limited access.
EOF

echo "✅ Documentation updated: docs/MODEL_COMPATIBILITY.md"
echo ""
echo "Working models:"
cat "$RESULTS_FILE"
