
#!/bin/bash
APP_URL="http://localhost:5050"
PASSED=0
FAILED=0

test_api() {
    local name="$1"
    local endpoint="$2"
    local expected="$3"
    
    echo -n "Testing $name... "
    if curl -f -s "$APP_URL$endpoint" | grep -q "$expected"; then
        echo "✅ PASSED"
        ((PASSED++))
    else
        echo "❌ FAILED"
        ((FAILED++))
    fi
}

echo "🚀 Enhanced Sample App - API Testing"
test_api "API Info" "/api" "Enhanced Sample App API"
test_api "Health Check" "/api/health" "healthy"
test_api "Users API" "/api/users" "users"
test_api "Posts API" "/api/posts" "posts"
test_api "Weather API" "/api/weather/London" "London"
test_api "Random Quote" "/api/quote" "text"
test_api "Random Fact" "/api/random-fact" "fact"

echo ""
echo "📊 Enhanced API Test Results:"
echo "Passed: $PASSED, Failed: $FAILED"
echo "Success Rate: $(echo "scale=1; $PASSED * 100 / ($PASSED + $FAILED)" | bc)%"

if [ $FAILED -eq 0 ]; then
    echo "🎉 All enhanced API tests passed!"
    exit 0
else
    echo "⚠️ Some API tests failed"
    exit 1
fi