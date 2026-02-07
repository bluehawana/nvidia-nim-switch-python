#!/bin/bash

# Quick Cloudflare API Test Script
# Tests your API token and shows current DNS configuration

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Cloudflare API Test                                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Load .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo -e "${RED}❌ .env file not found${NC}"
    exit 1
fi

# Check if credentials exist
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo -e "${RED}❌ CLOUDFLARE_API_TOKEN not set in .env${NC}"
    exit 1
fi

if [ -z "$CLOUDFLARE_ZONE_ID" ]; then
    echo -e "${YELLOW}⚠ CLOUDFLARE_ZONE_ID not set, will look it up${NC}"
fi

# Check jq
if ! command -v jq &> /dev/null; then
    echo -e "${RED}❌ jq not installed. Install with: brew install jq${NC}"
    exit 1
fi

echo "🔍 Testing API token..."

# Test API token
TOKEN_TEST=$(curl -s -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json")

TOKEN_STATUS=$(echo $TOKEN_TEST | jq -r '.success')

if [ "$TOKEN_STATUS" == "true" ]; then
    echo -e "${GREEN}✓${NC} API token is valid"
else
    echo -e "${RED}❌ API token is invalid${NC}"
    echo $TOKEN_TEST | jq '.errors'
    exit 1
fi

# Get Zone info
echo ""
echo "🔍 Fetching zone information..."

if [ -z "$CLOUDFLARE_ZONE_ID" ]; then
    ZONE_RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=bluehawana.com" \
        -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
        -H "Content-Type: application/json")
    
    CLOUDFLARE_ZONE_ID=$(echo $ZONE_RESPONSE | jq -r '.result[0].id')
    
    if [ "$CLOUDFLARE_ZONE_ID" == "null" ]; then
        echo -e "${RED}❌ Could not find zone${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓${NC} Found Zone ID: ${CLOUDFLARE_ZONE_ID}"
    echo ""
    echo "Add this to your .env file:"
    echo "CLOUDFLARE_ZONE_ID=${CLOUDFLARE_ZONE_ID}"
fi

# Get DNS records
echo ""
echo "📋 Current DNS records for bluehawana.com:"
echo ""

DNS_RECORDS=$(curl -s -X GET \
    "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json")

echo $DNS_RECORDS | jq -r '.result[] | "\(.type)\t\(.name)\t→\t\(.content)\t(Proxied: \(.proxied))"'

echo ""
echo -e "${GREEN}✓${NC} Cloudflare API is working correctly!"
echo ""
