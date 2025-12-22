"""
ERNIE AI Client for AllSensesAI Guardian
Handles multi-signal threat analysis with structured JSON output
"""

import os
import json
import time
import logging
from typing import Dict, Any, Optional, List
from openai import OpenAI

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class ERNIEThreatAnalyzer:
    """
    ERNIE-powered threat analysis client with bulletproof error handling
    """
    
    def __init__(self):
        self.api_key = os.getenv('AI_STUDIO_API_KEY')
        if not self.api_key:
            raise ValueError("AI_STUDIO_API_KEY environment variable is required")
            
        # Build kwargs dynamically so we never pass unsupported params
        client_kwargs = {
            "api_key": self.api_key,
        }
        
        # Add base_url if supported
        base_url = "https://aistudio.baidu.com/llm/lmapi/v3"
        if base_url:
            client_kwargs["base_url"] = base_url
        
        # DO NOT pass proxies as a kwarg to avoid httpx compatibility issues
        # If you need proxies, set them via environment variables instead:
        #   HTTP_PROXY / HTTPS_PROXY
        
        # Create client WITHOUT proxies kwarg
        self.client = OpenAI(**client_kwargs)
        
        # Discover and validate available models
        self.available_models = self._discover_models()
        self.model = self._select_best_model()
        
        logger.info(f"ERNIE client initialized with model: {self.model}")
    
    def _discover_models(self) -> List[str]:
        """Discover available ERNIE models from API"""
        try:
            models_response = self.client.models.list()
            model_ids = [model.id for model in models_response.data]
            logger.info(f"Available models: {model_ids}")
            return model_ids
        except Exception as e:
            logger.warning(f"Could not discover models: {e}")
            # Fallback to known ERNIE models
            return ["ernie-4.5-turbo-128k-preview", "ernie-4.0-turbo-8k", "ernie-3.5-turbo"]
    
    def _select_best_model(self) -> str:
        """Select the best available ERNIE text model"""
        # Priority order for text models (no multimodal needed for this demo)
        preferred_models = [
            "ernie-4.5-turbo-128k-preview",
            "ernie-4.5-turbo-8k",
            "ernie-4.0-turbo-8k",
            "ernie-3.5-turbo"
        ]
        
        for model in preferred_models:
            if model in self.available_models:
                return model
        
        # Fallback to first available model
        if self.available_models:
            return self.available_models[0]
        
        # Last resort fallback
        return "ernie-4.5-turbo-128k-preview"
    
    def analyze_threat(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Analyze multi-signal threat context using ERNIE
        
        Args:
            context: Dict containing audio_transcript, motion_data, location_data
            
        Returns:
            Structured threat assessment with confidence scoring
        """
        system_prompt = self._get_system_prompt()
        user_message = self._format_user_message(context)
        
        return self._make_request_with_retry(system_prompt, user_message)
    
    def _get_system_prompt(self) -> str:
        """Get optimized system prompt for ERNIE threat analysis"""
        return """You are ERNIE, an advanced AI emergency threat detection system. Analyze multi-signal context and provide precise threat assessments.

ANALYSIS FRAMEWORK:
1. Audio Analysis: Detect distress keywords, emotional tone, background threats
2. Motion Analysis: Identify sudden movements, falls, struggle patterns
3. Location Context: Assess environmental risk factors and isolation
4. Multi-Signal Correlation: Cross-validate signals for accuracy

THREAT LEVELS:
- low: Normal activity, no concerning indicators
- medium: Some concerning signals, monitoring recommended
- high: Clear danger indicators, immediate response required

CONFIDENCE SCORING:
- 0.0-0.3: Uncertain, limited or conflicting data
- 0.4-0.7: Moderate confidence, some clear indicators
- 0.8-1.0: High confidence, multiple corroborating signals

CRITICAL: Respond ONLY with valid JSON in this exact format:
{
  "threat_level": "low|medium|high",
  "confidence_score": 0.0-1.0,
  "reasoning": ["specific observation 1", "correlation analysis 2", "risk factor 3"],
  "recommended_action": "none|monitor|trigger_emergency_alert"
}

No additional text. JSON only."""

    def _format_user_message(self, context: Dict[str, Any]) -> str:
        """Format context data for ERNIE analysis"""
        audio = context.get('audio_transcript', 'No audio data available')
        motion = context.get('motion_data', 'No motion data available')
        location = context.get('location_data', 'Location unknown')
        timestamp = context.get('timestamp', 'Time unknown')
        
        return f"""MULTI-SIGNAL THREAT ANALYSIS REQUEST

Audio Transcript: "{audio}"
Motion Data: {motion}
Location Context: {location}
Timestamp: {timestamp}

Analyze these signals for emergency threat indicators. Provide structured JSON assessment."""

    def _make_request_with_retry(self, system_prompt: str, user_message: str, max_retries: int = 3) -> Dict[str, Any]:
        """Make ERNIE request with comprehensive error handling and retry logic"""
        
        for attempt in range(max_retries):
            try:
                logger.info(f"ERNIE analysis attempt {attempt + 1}/{max_retries}")
                
                response = self.client.chat.completions.create(
                    model=self.model,
                    messages=[
                        {"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_message}
                    ],
                    response_format={"type": "json_object"},
                    temperature=0.1,
                    max_tokens=500,
                    timeout=30
                )
                
                # Parse and validate JSON response
                content = response.choices[0].message.content.strip()
                result = json.loads(content)
                
                # Validate required fields and types
                if self._validate_response(result):
                    logger.info("ERNIE analysis successful")
                    return result
                else:
                    logger.warning(f"Invalid response structure: {result}")
                    if attempt == max_retries - 1:
                        return self._create_fallback_response("Invalid response structure from ERNIE")
                    
            except json.JSONDecodeError as e:
                logger.error(f"JSON decode error: {e}")
                if attempt == max_retries - 1:
                    return self._create_fallback_response("Invalid JSON response from ERNIE")
                    
            except Exception as e:
                error_str = str(e).lower()
                
                # Handle specific error types
                if "401" in error_str or "unauthorized" in error_str:
                    logger.error("Authentication failed - check AI_STUDIO_API_KEY")
                    return self._create_fallback_response("Authentication failed - invalid API key")
                    
                elif "429" in error_str or "rate limit" in error_str:
                    if attempt < max_retries - 1:
                        wait_time = 0.5 * (2 ** attempt)  # Exponential backoff: 0.5s, 1s, 2s
                        logger.warning(f"Rate limited, waiting {wait_time}s before retry")
                        time.sleep(wait_time)
                        continue
                    else:
                        return self._create_fallback_response("Rate limit exceeded")
                        
                elif "500" in error_str or "internal" in error_str:
                    logger.error(f"ERNIE internal error: {e}")
                    if attempt == max_retries - 1:
                        return self._create_fallback_response("ERNIE service temporarily unavailable")
                        
                else:
                    logger.error(f"Unexpected error: {e}")
                    if attempt == max_retries - 1:
                        return self._create_fallback_response(f"Unexpected error: {str(e)[:100]}")
        
        return self._create_fallback_response("Max retries exceeded")
    
    def _validate_response(self, response: Dict[str, Any]) -> bool:
        """Validate ERNIE response structure and types"""
        required_fields = {
            "threat_level": str,
            "confidence_score": (int, float),
            "reasoning": list,
            "recommended_action": str
        }
        
        for field, expected_type in required_fields.items():
            if field not in response:
                return False
            if not isinstance(response[field], expected_type):
                return False
        
        # Validate enum values
        if response["threat_level"] not in ["low", "medium", "high"]:
            return False
        if response["recommended_action"] not in ["none", "monitor", "trigger_emergency_alert"]:
            return False
        if not (0.0 <= response["confidence_score"] <= 1.0):
            return False
        if not isinstance(response["reasoning"], list) or len(response["reasoning"]) == 0:
            return False
            
        return True
    
    def _create_fallback_response(self, error_message: str) -> Dict[str, Any]:
        """Create safe fallback response that never triggers false alerts"""
        logger.warning(f"Using fallback response: {error_message}")
        
        return {
            "threat_level": "low",
            "confidence_score": 0.0,
            "reasoning": [
                f"System error: {error_message}",
                "Defaulting to safe monitoring mode",
                "Manual review recommended"
            ],
            "recommended_action": "monitor"
        }