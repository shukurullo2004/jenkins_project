#!/bin/bash

echo "🚀 Enhanced Sample App - Working API Test"
echo "========================================"

APP_URL="http://localhost:5050"
PASSED=0
FAILED=0

test_api() {
    local name="$1"
    local endpoint="$2"
    local expected="$3"
    
    echo -n "Testing $name... "
    
    response=$(curl -s "$APP_URL$endpoint" 2>/dev/null)
    
    if echo "$response" | grep -q "$expected"; then
        echo "✅ PASSED"
        ((PASSED++))
    else
        echo "❌ FAILED"
        echo "  Response: $(echo "$response" | head -c 150)..."
        ((FAILED++))
    fi
}

echo "🔍 Testing Enhanced App at: $APP_URL"
echo ""

# Test all enhanced endpoints
test_api "Health Check" "/api/health" "healthy"
test_api "API Info" "/api" "Enhanced Sample App API"
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

if [ $FAILED -eq 0 ] && [ $PASSED -gt 0 ]; then
    echo ""
    echo "🎉 ALL ENHANCED API TESTS PASSED!"
    echo "✨ BONUS FEATURES WORKING PERFECTLY!"
    echo "🏆 BONUS POINTS EARNED!"
    exit 0
else
    echo "⚠️ Some tests failed"
    exit 1
fi
