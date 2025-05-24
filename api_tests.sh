
#!/bin/bash

# Enhanced API Testing Script for Bonus Points
echo "🚀 Enhanced Sample App - Comprehensive API Testing Suite"
echo "======================================================"

APP_URL="http://localhost:5050"
PASSED=0
FAILED=0

test_endpoint() {
    local name="$1"
    local url="$2"
    local expected="$3"
    
    echo -n "Testing $name... "
    
    if curl -f -s "$APP_URL$url" | grep -q "$expected"; then
        echo "✅ PASSED"
        ((PASSED++))
    else
        echo "❌ FAILED"
        ((FAILED++))
    fi
}

echo "🧪 Running comprehensive API tests..."

# Basic connectivity
test_endpoint "API Info" "/api" "Enhanced Sample App API"
test_endpoint "Health Check" "/api/health" "healthy"

# User Management API
test_endpoint "Get Users" "/api/users" "users"
test_endpoint "Get User by ID" "/api/users/1" "John Doe"

# Posts API
test_endpoint "Get Posts" "/api/posts" "posts"

# External API Integration
test_endpoint "Weather API" "/api/weather/London" "London"
test_endpoint "Random Quote" "/api/quote" "text"
test_endpoint "Random Fact" "/api/random-fact" "fact"

# API Performance Test
echo -n "Testing API performance... "
start_time=$(date +%s.%N)
curl -f -s "$APP_URL/api/health" > /dev/null
end_time=$(date +%s.%N)
duration=$(echo "$end_time - $start_time" | bc)

if (( $(echo "$duration < 2.0" | bc -l) )); then
    echo "✅ PASSED (${duration}s)"
    ((PASSED++))
else
    echo "❌ FAILED (${duration}s - too slow)"
    ((FAILED++))
fi

echo ""
echo "📊 TEST SUMMARY:"
echo "==============="
echo "Total Tests: $((PASSED + FAILED))"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Success Rate: $(echo "scale=1; $PASSED * 100 / ($PASSED + $FAILED)" | bc)%"

if [ $FAILED -eq 0 ]; then
    echo "🎉 All tests passed! Enhanced API is working perfectly!"
    exit 0
else
    echo "⚠️ Some tests failed. Check the API implementation."
    exit 1
fi


