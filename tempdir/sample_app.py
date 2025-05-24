
from flask import Flask, request, render_template, jsonify
import json
import uuid
from datetime import datetime

sample = Flask(__name__)

# In-memory database simulation
users_db = [
    {"id": "1", "name": "John Doe", "email": "john@example.com", "created": "2024-01-15"},
    {"id": "2", "name": "Jane Smith", "email": "jane@example.com", "created": "2024-02-20"}
]

posts_db = [
    {"id": "1", "user_id": "1", "title": "My First Post", "content": "Hello World!", "created": "2024-03-01"},
    {"id": "2", "user_id": "2", "title": "Flask is Awesome", "content": "Learning Flask with Jenkins CI/CD", "created": "2024-03-15"}
]

@sample.route("/")
def main():
    return render_template("index.html")

@sample.route("/api", methods=['GET'])
def api_info():
    return jsonify({
        "name": "Enhanced Sample App API",
        "version": "2.0",
        "description": "Flask API with CI/CD capabilities",
        "status": "running",
        "endpoints": {
            "GET /api": "API information",
            "GET /api/health": "Health check",
            "GET /api/users": "Get all users",
            "GET /api/posts": "Get all posts",
            "GET /api/weather/<city>": "Get weather for city",
            "GET /api/quote": "Get random quote",
            "GET /api/random-fact": "Get random fact"
        },
        "timestamp": datetime.now().isoformat()
    })

@sample.route("/api/health", methods=['GET'])
def health_check():
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "2.0",
        "database": {
            "users_count": len(users_db),
            "posts_count": len(posts_db)
        }
    })

@sample.route("/api/users", methods=['GET'])
def get_users():
    return jsonify({
        "users": users_db,
        "total": len(users_db)
    })

@sample.route("/api/users/<user_id>", methods=['GET'])
def get_user(user_id):
    user = next((u for u in users_db if u["id"] == user_id), None)
    if user:
        return jsonify(user)
    return jsonify({"error": "User not found"}), 404

@sample.route("/api/users", methods=['POST'])
def create_user():
    data = request.get_json()
    if not data or not data.get('name') or not data.get('email'):
        return jsonify({"error": "Name and email are required"}), 400
    
    new_user = {
        "id": str(uuid.uuid4())[:8],
        "name": data['name'],
        "email": data['email'],
        "created": datetime.now().strftime("%Y-%m-%d")
    }
    users_db.append(new_user)
    return jsonify(new_user), 201

@sample.route("/api/posts", methods=['GET'])
def get_posts():
    return jsonify({
        "posts": posts_db,
        "total": len(posts_db)
    })

@sample.route("/api/posts", methods=['POST'])
def create_post():
    data = request.get_json()
    if not data or not data.get('title') or not data.get('content') or not data.get('user_id'):
        return jsonify({"error": "Title, content, and user_id are required"}), 400
    
    new_post = {
        "id": str(uuid.uuid4())[:8],
        "user_id": data['user_id'],
        "title": data['title'],
        "content": data['content'],
        "created": datetime.now().strftime("%Y-%m-%d")
    }
    posts_db.append(new_post)
    return jsonify(new_post), 201

@sample.route("/api/weather/<city>", methods=['GET'])
def get_weather(city):
    return jsonify({
        "city": city.title(),
        "temperature": "22°C",
        "description": "Partly cloudy",
        "humidity": "65%",
        "wind_speed": "10 km/h",
        "timestamp": datetime.now().isoformat()
    })

@sample.route("/api/quote", methods=['GET'])
def get_quote():
    quotes = [
        {"text": "The only way to do great work is to love what you do.", "author": "Steve Jobs"},
        {"text": "Innovation distinguishes between a leader and a follower.", "author": "Steve Jobs"},
        {"text": "Code is like humor. When you have to explain it, it's bad.", "author": "Cory House"}
    ]
    import random
    quote = random.choice(quotes)
    quote["timestamp"] = datetime.now().isoformat()
    return jsonify(quote)

@sample.route("/api/random-fact", methods=['GET'])
def get_random_fact():
    facts = [
        "The first computer bug was an actual bug found in Harvard's Mark II computer in 1947.",
        "Python was named after Monty Python's Flying Circus.",
        "The first programming language was created in 1954."
    ]
    import random
    fact = random.choice(facts)
    return jsonify({
        "fact": fact,
        "category": "Technology",
        "timestamp": datetime.now().isoformat()
    })

if __name__ == "__main__":
    sample.run(host="0.0.0.0", port=5050, debug=True)
