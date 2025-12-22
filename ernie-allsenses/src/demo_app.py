"""
ERNIE AI Developer Challenge Demo Application
Flask web app demonstrating AllSensesAI Guardian with ERNIE multi-signal reasoning
"""

from pathlib import Path
from jinja2.exceptions import TemplateNotFound
from dotenv import load_dotenv

# Define repo root, templates path, and load .env BEFORE app creation
ROOT_DIR = Path(__file__).resolve().parents[1]
TEMPLATES_DIR = ROOT_DIR / "src" / "templates"
load_dotenv(ROOT_DIR / ".env")

print(f"[BOOT] ROOT_DIR={ROOT_DIR}")
print(f"[BOOT] TEMPLATES_DIR={TEMPLATES_DIR}")
print(f"[BOOT] demo.html exists? {(TEMPLATES_DIR / 'demo.html').exists()}")

import os
import json
import logging
import traceback
from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
from datetime import datetime
from dotenv import load_dotenv

from threat_detector import ThreatDetectionOrchestrator

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__, template_folder=str(TEMPLATES_DIR))
CORS(app)

def create_mock_assessment(context):
    """Create realistic mock assessment for demo mode"""
    scenario_name = context.get("scenario_name", "").lower()
    audio = context.get("audio_transcript", "").lower()
    
    # Simple rule-based mock responses
    if "emergency" in scenario_name or any(word in audio for word in ["help", "emergency", "danger", "scared"]):
        return {
            "final_threat_level": "high",
            "final_confidence": 0.85,
            "final_action": "trigger_emergency_alert",
            "decision_reasoning": [
                "Emergency keywords detected in audio transcript",
                "High confidence threat assessment",
                "MOCK: Immediate response recommended"
            ],
            "ernie_analysis": {
                "threat_level": "high",
                "confidence_score": 0.85,
                "reasoning": ["Emergency language detected", "Distress indicators present"],
                "recommended_action": "trigger_emergency_alert"
            },
            "context_summary": f"Audio: \"{audio[:60]}...\" | Motion: {context.get('motion_data', 'N/A')}",
            "processing_timestamp": context.get("timestamp"),
            "emergency_keywords_detected": ["help", "emergency"]
        }
    elif "ambiguous" in scenario_name or "following" in audio:
        return {
            "final_threat_level": "medium",
            "final_confidence": 0.65,
            "final_action": "monitor",
            "decision_reasoning": [
                "Moderate threat indicators detected",
                "Monitoring recommended for safety",
                "MOCK: Elevated awareness mode"
            ],
            "ernie_analysis": {
                "threat_level": "medium",
                "confidence_score": 0.65,
                "reasoning": ["Some concerning indicators", "Requires monitoring"],
                "recommended_action": "monitor"
            },
            "context_summary": f"Audio: \"{audio[:60]}...\" | Motion: {context.get('motion_data', 'N/A')}",
            "processing_timestamp": context.get("timestamp"),
            "emergency_keywords_detected": []
        }
    else:
        return {
            "final_threat_level": "low",
            "final_confidence": 0.25,
            "final_action": "none",
            "decision_reasoning": [
                "Normal activity patterns detected",
                "No threat indicators present",
                "MOCK: Safe environment assessment"
            ],
            "ernie_analysis": {
                "threat_level": "low",
                "confidence_score": 0.25,
                "reasoning": ["Normal conversation patterns", "No distress signals"],
                "recommended_action": "none"
            },
            "context_summary": f"Audio: \"{audio[:60]}...\" | Motion: {context.get('motion_data', 'N/A')}",
            "processing_timestamp": context.get("timestamp"),
            "emergency_keywords_detected": []
        }

# Initialize threat detector with fallback mode
load_dotenv()  # ensure AI_STUDIO_API_KEY and others are loaded
threat_detector = None
demo_mode = False
ernie_model_name = "NOT_INITIALIZED"

try:
    # your existing threat detector init here
    threat_detector = ThreatDetectionOrchestrator()
    demo_mode = False
    ernie_model_name = getattr(getattr(threat_detector, "ernie", None), "model", None) or "LIVE_MODE"
    logger.info("ThreatDetectionOrchestrator initialized successfully")
except Exception as e:
    demo_mode = True
    ernie_model_name = "MOCK_MODE (demo fallback)"
    print("ERROR: Failed to initialize threat detector:", repr(e))
    traceback.print_exc()  # <<<<<< THIS prints the full stack trace
    print("INFO: Running in demo mode with mock responses")

@app.route("/")
def index():
    try:
        return render_template("demo.html", demo_mode=demo_mode, ernie_model=ernie_model_name)
    except TemplateNotFound:
        return (
            "<h1>demo.html not found</h1>"
            f"<p>Expected at: {TEMPLATES_DIR / 'demo.html'}</p>"
            "<p>Fix: ensure demo.html exists in src/templates.</p>",
            200,
            {"Content-Type": "text/html"},
        )

@app.route('/api/analyze', methods=['POST'])
def analyze_threat():
    """
    Main API endpoint for threat analysis
    Accepts multi-signal context and returns ERNIE-powered assessment
    """
    try:
        # Parse request data
        data = request.get_json()
        if not data:
            return jsonify({
                "error": "No JSON data provided",
                "status": "invalid_request"
            }), 400
        
        # Extract context data
        context = {
            "audio_transcript": data.get("audio_transcript", ""),
            "motion_data": data.get("motion_data", "No motion data"),
            "location_data": data.get("location_data", "Location unknown"),
            "timestamp": datetime.utcnow().isoformat(),
            "scenario_name": data.get("scenario_name", "Unknown")
        }
        
        logger.info(f"Processing scenario: {context['scenario_name']}")
        
        # Process through ERNIE + business logic OR mock response
        if threat_detector:
            assessment = threat_detector.process_emergency_context(context)
            ernie_model = threat_detector.ernie.model
        else:
            # Mock response for demo mode
            assessment = create_mock_assessment(context)
            ernie_model = "MOCK_MODE"
        
        # Add demo-friendly metadata
        response = {
            "status": "success",
            "scenario": context["scenario_name"],
            "timestamp": context["timestamp"],
            "assessment": assessment,
            "demo_info": {
                "ernie_model_used": ernie_model,
                "processing_time_ms": "~200ms",
                "multi_signal_reasoning": True,
                "demo_mode": demo_mode
            }
        }
        
        logger.info(f"Analysis complete: {assessment['final_action']}")
        return jsonify(response)
        
    except Exception as e:
        logger.error(f"Analysis error: {e}")
        return jsonify({
            "error": str(e),
            "status": "processing_error"
        }), 500

@app.route('/api/scenarios', methods=['GET'])
def get_demo_scenarios():
    """
    Return predefined demo scenarios for judge testing
    """
    scenarios = [
        {
            "name": "Safe Scenario",
            "description": "Normal conversation, no threat indicators",
            "audio_transcript": "Hey, I'm walking to the coffee shop. The weather is nice today. Should be there in about 10 minutes.",
            "motion_data": "Steady walking pace, consistent direction",
            "location_data": "Downtown area, well-lit street, moderate foot traffic",
            "expected_outcome": "No alert - normal activity"
        },
        {
            "name": "Ambiguous Scenario", 
            "description": "Some concerning signals but not definitive",
            "audio_transcript": "I think someone is following me. Maybe I'm just being paranoid. Let me take a different route.",
            "motion_data": "Pace increased, direction changes, looking back frequently",
            "location_data": "Quiet residential area, limited lighting",
            "expected_outcome": "Monitor - elevated awareness needed"
        },
        {
            "name": "Emergency Scenario",
            "description": "Clear danger indicators requiring immediate response",
            "audio_transcript": "Help! Someone is trying to grab me! I'm scared! Please help me!",
            "motion_data": "Sudden acceleration, erratic movement, struggle patterns",
            "location_data": "Isolated parking lot, no witnesses nearby",
            "expected_outcome": "Emergency alert - immediate response required"
        }
    ]
    
    return jsonify({
        "status": "success",
        "scenarios": scenarios,
        "total_count": len(scenarios)
    })

@app.route('/api/system-status', methods=['GET'])
def system_status():
    """
    Get system health and configuration info
    """
    if not threat_detector:
        return jsonify({
            "status": "ok",
            "api_status": "operational",
            "demo_mode": demo_mode,
            "ernie_model": ernie_model_name,
            "message": "Threat detector failed to init; running UI + scenarios in safe mode."
        }), 200
    
    status = threat_detector.get_system_status()
    status["api_status"] = "operational"
    status["demo_mode"] = demo_mode
    status["ernie_model"] = ernie_model_name
    status["message"] = "Live ERNIE ready"
    
    return jsonify(status), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        "error": "Endpoint not found",
        "status": "not_found"
    }), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        "error": "Internal server error",
        "status": "server_error"
    }), 500

if __name__ == '__main__':
    # Load environment variables again to ensure they're available
    load_dotenv()
    
    # Check for required environment variables
    if not os.getenv('AI_STUDIO_API_KEY'):
        print("ERROR: AI_STUDIO_API_KEY environment variable is required")
        print("Please set your Baidu AI Studio access token:")
        print("PowerShell: $env:AI_STUDIO_API_KEY='your_token_here'")
        print("Or edit .env file with: AI_STUDIO_API_KEY=your_token_here")
        exit(1)
    
    # Run demo server
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    
    print(f"\n🚀 ERNIE AI Developer Challenge Demo")
    print(f"📍 Running on http://localhost:{port}")
    print(f"🤖 ERNIE Model: {ernie_model_name}")
    print(f"📊 Demo scenarios available at /api/scenarios")
    print(f"🔍 System status at /api/system-status")
    
    app.run(host='0.0.0.0', port=port, debug=debug)