"""
AllSensesAI Guardian Threat Detection Orchestrator
Combines ERNIE analysis with business logic for emergency decisions
"""

import logging
from typing import Dict, Any
from datetime import datetime
from ernie_client import ERNIEThreatAnalyzer

logger = logging.getLogger(__name__)

class ThreatDetectionOrchestrator:
    """
    Main orchestrator that combines ERNIE analysis with business rules
    """
    
    def __init__(self):
        self.ernie = ERNIEThreatAnalyzer()
        
        # Simple, non-redundant decision thresholds
        self.thresholds = {
            "high_threat_min_confidence": 0.6,
            "medium_threat_min_confidence": 0.4,
            "emergency_words_min_confidence": 0.3
        }
        
        # Emergency keywords for override logic
        self.emergency_keywords = [
            "help", "emergency", "danger", "attack", "police", 
            "fire", "ambulance", "scared", "following", "hurt"
        ]
        
        logger.info("ThreatDetectionOrchestrator initialized")
    
    def process_emergency_context(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Main processing pipeline: Context -> ERNIE -> Business Logic -> Decision
        
        Args:
            context: Multi-signal context data
            
        Returns:
            Complete threat assessment with final decision
        """
        # Add processing timestamp
        context["processing_timestamp"] = datetime.utcnow().isoformat()
        
        logger.info("Processing emergency context")
        
        # Get ERNIE analysis
        ernie_response = self.ernie.analyze_threat(context)
        
        # Apply business logic
        final_decision = self._apply_decision_logic(ernie_response, context)
        
        # Combine results
        complete_assessment = {
            # Final system decision
            "final_threat_level": final_decision["threat_level"],
            "final_confidence": final_decision["confidence"],
            "final_action": final_decision["action"],
            "decision_reasoning": final_decision["reasoning"],
            
            # ERNIE raw analysis
            "ernie_analysis": {
                "threat_level": ernie_response["threat_level"],
                "confidence_score": ernie_response["confidence_score"],
                "reasoning": ernie_response["reasoning"],
                "recommended_action": ernie_response["recommended_action"]
            },
            
            # Context metadata
            "context_summary": self._create_context_summary(context),
            "processing_timestamp": context["processing_timestamp"],
            "emergency_keywords_detected": final_decision["emergency_keywords_found"]
        }
        
        logger.info(f"Final decision: {final_decision['action']} (confidence: {final_decision['confidence']:.2f})")
        
        return complete_assessment
    
    def _apply_decision_logic(self, ernie_response: Dict[str, Any], context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Apply business rules on top of ERNIE assessment
        Simple, explainable escalation logic
        """
        threat_level = ernie_response.get("threat_level", "low")
        confidence = ernie_response.get("confidence_score", 0.0)
        ernie_reasoning = ernie_response.get("reasoning", [])
        
        # Check for emergency keywords in audio
        audio_transcript = context.get("audio_transcript", "").lower()
        emergency_keywords_found = [
            word for word in self.emergency_keywords 
            if word in audio_transcript
        ]
        
        # Decision logic (simple and explainable)
        decision_factors = []
        
        # Rule 1: High threat with sufficient confidence
        if threat_level == "high" and confidence >= self.thresholds["high_threat_min_confidence"]:
            action = "trigger_emergency_alert"
            decision_factors.append(f"High threat detected with {confidence:.1%} confidence")
        
        # Rule 2: Emergency keywords override (even with lower confidence)
        elif emergency_keywords_found and confidence >= self.thresholds["emergency_words_min_confidence"]:
            action = "trigger_emergency_alert"
            decision_factors.append(f"Emergency keywords detected: {', '.join(emergency_keywords_found)}")
        
        # Rule 3: Medium threat requires monitoring
        elif threat_level == "medium" and confidence >= self.thresholds["medium_threat_min_confidence"]:
            action = "monitor"
            decision_factors.append(f"Medium threat requires monitoring (confidence: {confidence:.1%})")
        
        # Rule 4: Low threat or insufficient confidence
        else:
            action = "none"
            decision_factors.append(f"Low threat level or insufficient confidence ({confidence:.1%})")
        
        # Add ERNIE reasoning to decision factors
        decision_factors.extend([f"ERNIE: {reason}" for reason in ernie_reasoning])
        
        return {
            "threat_level": threat_level,
            "confidence": confidence,
            "action": action,
            "reasoning": decision_factors,
            "emergency_keywords_found": emergency_keywords_found
        }
    
    def _create_context_summary(self, context: Dict[str, Any]) -> str:
        """Create human-readable context summary"""
        parts = []
        
        if context.get("audio_transcript"):
            audio_preview = context["audio_transcript"][:60]
            if len(context["audio_transcript"]) > 60:
                audio_preview += "..."
            parts.append(f"Audio: \"{audio_preview}\"")
        
        if context.get("motion_data"):
            parts.append(f"Motion: {context['motion_data']}")
        
        if context.get("location_data"):
            parts.append(f"Location: {context['location_data']}")
        
        return " | ".join(parts) if parts else "No context data available"
    
    def get_system_status(self) -> Dict[str, Any]:
        """Get system health status"""
        return {
            "ernie_model": self.ernie.model,
            "available_models": self.ernie.available_models,
            "thresholds": self.thresholds,
            "emergency_keywords_count": len(self.emergency_keywords),
            "status": "operational"
        }