#!/bin/bash

echo "🚀 Enhanced Sample App - Working API Test"
echo "========================================"

# Get the actual container IP
CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' samplerunning)
echo "📍 Container IP: $CONTAINER_IP"

APP_URL="http://$CONTAINER_IP:5050"
PASSED=0
FAILED=0

test_api() {
    local name="$1"
    local endpoint="$2"
    local expected="$3"
    
    echo -n "Testing $name... "
    
    # Test with proper timeout and container IP
    response=$(curl -m 10 -s "$APP_URL$endpoint" 2>/dev/null)
    
    if echo "$response" | grep -q "$expected"; then
        echo "✅ PASSED"
        ((PASSED++))
    else
        echo "❌ FAILED"
        echo "  URL: $APP_URL$endpoint"
        echo "  Expected: $expected"
        echo "  Got: $(echo "$response" | head -c 100)..."
        ((FAILED++))
    fi
}

echo "🔍 Testing at: $APP_URL"
echo ""

# Test all enhanced endpoints
test_api "API Info" "/api" "Enhanced Sample App API"
test_api "Health Check" "/api/health" "healthy"
test_api "Users API" "/api/users" "users"
test_api "Posts API" "/api/posts" "posts"
test_api "Weather API" "/api/weather/London" "London"
test_api "Random Quote" "/api/quote" "text"
test_api "Random Fact" "/api/random-fact" "fact"

echo ""
echo "📊 Test Results:"
echo "================"
echo "Total: $((PASSED + FAILED))"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -eq 0 ] && [ $PASSED -gt 0 ]; then
    echo "🎉 All enhanced API tests PASSED! Bonus points earned! ✨"
    exit 0
else
    echo "⚠️ Some tests failed"
    exit 1
fi
