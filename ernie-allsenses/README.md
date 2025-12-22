# AllSensesAI Guardian — ERNIE Edition (Application-Building)

AllSensesAI Guardian is a demo-first emergency threat assessment system where **ERNIE is the decision-making engine**.  
It evaluates **multi-signal context** (audio transcript + motion metadata + location metadata) and returns a **strict JSON decision** that drives a safety action.

## Challenge Submission

**ERNIE AI Developer Challenge**  
Tracks:
- Best ERNIE Multimodal Application using Baidu AI Studio
- Best Agent System

> Note on terminology: this demo is **multi-signal / multi-factor reasoning** (transcript + motion + location metadata).  
> If image/video inputs are added later, ERNIE-VL can be used, but the current demo focuses on reliable app integration.

## What ERNIE Does Here (Not a chatbot)

ERNIE is used as a **contextual reasoning and decision engine**.  
For each scenario, the backend sends a compact context payload to ERNIE and requires ERNIE to output **deterministic structured JSON**:

```json
{
  "threat_level": "low|medium|high",
  "confidence_score": 0.0,
  "reasoning": ["short bullet reasons only"],
  "recommended_action": "none|monitor|trigger_emergency_alert"
}
