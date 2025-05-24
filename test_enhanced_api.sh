#!/bin/bash

# Mac-compatible Enhanced API Testing Script
echo "🚀 Enhanced Sample App - API Testing (Mac Version)"
echo "=================================================="

APP_URL="http://localhost:5050"
PASSED=0
FAILED=0

test_api() {
    local name="$1"
    local endpoint="$2"
    local expected="$3"
    
    echo -n "Testing $name... "
    
    # Use timeout to prevent hanging
    response=$(timeout 10s curl -f -s "$APP_URL$endpoint" 2>/dev/null)
    
    if echo "$response" | grep -q "$expected"; then
        echo "✅ PASSED"
        ((PASSED++))
    else
        echo "❌ FAILED"
        echo "  Expected: $expected"
        echo "  Response: $response" | head -1
        ((FAILED++))
    fi
}

# Check if app is running first
echo "🔍 Checking if enhanced app is running..."
if ! curl -f -s "$APP_URL/api/health" > /dev/null 2>&1; then
    echo "❌ Application not responding at $APP_URL"
    echo "Please run: bash ./sample-app.sh"
    exit 1
fi

echo "✅ Application is running!"
echo ""

echo "🧪 Running enhanced API tests..."
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
echo "📊 Enhanced API Test Results:"
echo "=============================="
echo "Total Tests: $((PASSED + FAILED))"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $((PASSED + FAILED)) -gt 0 ]; then
    success_rate=$(echo "scale=1; $PASSED * 100 / ($PASSED + $FAILED)" | bc -l 2>/dev/null || echo "N/A")
    echo "Success Rate: ${success_rate}%"
else
    echo "Success Rate: N/A"
fi

echo ""

if [ $FAILED -eq 0 ] && [ $PASSED -gt 0 ]; then
    echo "🎉 All enhanced API tests passed!"
    echo "✨ Bonus features are working perfectly!"
    exit 0
else
    echo "⚠️ Some API tests failed or app not running"
    echo "💡 Make sure to run: bash ./sample-app.sh first"
    exit 1
fi
