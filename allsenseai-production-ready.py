import json
import boto3
import uuid
import os
from datetime import datetime, timezone
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS services
sns = boto3.client('sns')
dynamodb = boto3.resource('dynamodb')
bedrock = boto3.client('bedrock-runtime')

def handler(event, context):
    """
    AllSensesAI Complete 7-Step Pipeline - Production Ready
    1. Audio Capture → 2. Distress Detection → 3. Event Trigger → 
    4. Geolocation → 5. SMS Dispatch → 6. Contact Confirmation → 7. Analytics
    """
    logger.info(f"AllSenseAI received: {json.dumps(event, default=str)}")
    
    try:
        # Handle CORS preflight
        if event.get('httpMethod') == 'OPTIONS':
            return cors_response({})
        
        # Parse request body
        if 'body' in event:
            body = json.loads(event['body']) if isinstance(event['body'], str) else event['body']
        else:
            body = event
        
        action = body.get('action', 'SIMULATE_EMERGENCY')
        
        # Route to appropriate handler
        if action == 'SIMULATE_EMERGENCY':
            return simulate_complete_pipeline(body)
        elif action == 'GET_USER_PROFILE':
            return get_user_profile(body)
        elif action == 'MAKE_REAL_CALL':
            return send_emergency_sms(body)
        elif action == 'CHECK_SNS_STATUS':
            return check_sns_status()
        else:
            return analyze_audio_distress(body)
            
    except Exception as e:
        logger.error(f"Handler error: {str(e)}")
        return cors_response({
            'status': 'error',
            'message': str(e),
            'timestamp': datetime.now(timezone.utc).isoformat()
        }, 500)

def check_sns_status():
    """
    Check if SNS is in sandbox mode or production
    """
    try:
        # Check SMS sandbox status
        sandbox_response = sns.get_sms_sandbox_account_status()
        is_in_sandbox = sandbox_response.get('IsInSandbox', True)
        
        # Get SMS attributes
        attributes_response = sns.get_sms_attributes()
        monthly_spend_limit = attributes_response.get('attributes', {}).get('MonthlySpendLimit', 'Not set')
        
        return cors_response({
            'status': 'success',
            'snsStatus': {
                'isInSandbox': is_in_sandbox,
                'monthlySpendLimit': monthly_spend_limit,
                'mode': 'SANDBOX' if is_in_sandbox else 'PRODUCTION',
                'canSendToUnverified': not is_in_sandbox
            },
            'timestamp': datetime.now(timezone.utc).isoformat()
        })
        
    except Exception as e:
        logger.error(f"SNS status check failed: {str(e)}")
        return cors_response({
            'status': 'error',
            'message': f'Could not check SNS status: {str(e)}'
        }, 500)

def simulate_complete_pipeline(body):
    """
    Complete 7-Step AllSenseAI Emergency Pipeline Simulation
    """
    try:
        user_id = body.get('userId', 'user-123')
        event_id = str(uuid.uuid4())
        
        # Step 1: Audio Capture (simulated)
        audio_s3_key = f"s3://allsenseai-audio/{user_id}/{event_id}.wav"
        
        # Step 2: Distress Detection using AWS Bedrock
        audio_data = body.get('audioData', 'HELP! Emergency!')
        distress_result = detect_distress_bedrock(audio_data)
        
        # Step 3: Event Trigger
        event_payload = {
            "eventId": event_id,
            "userId": user_id,
            "confidence": distress_result['confidence'],
            "threatLevel": distress_result['level'],
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "audioS3Key": audio_s3_key
        }
        
        # Step 4: Get User Profile & Geolocation
        user_profile = fetch_user_profile(user_id)
        location_data = {
            "lat": body.get('lat', 40.712776),
            "lon": body.get('lon', -74.005974),
            "placeName": "123 Main St, New York, NY",
            "mapLink": f"https://maps.google.com/?q={body.get('lat', 40.712776)},{body.get('lon', -74.005974)}"
        }
        
        # Step 5: SMS Dispatch (with sandbox handling)
        sms_results = dispatch_emergency_sms_production(user_profile, location_data, distress_result, event_id)
        
        # Step 6: Contact Confirmation (simulated)
        confirmation_result = {
            "status": "pending",
            "confirmationWindow": "5m",
            "expectedConfirmations": len(sms_results)
        }
        
        # Step 7: Analytics & Learning
        analytics_result = log_emergency_analytics(event_id, user_id, sms_results, distress_result)
        
        return cors_response({
            'status': 'success',
            'message': 'AllSensesAI 7-Step Pipeline Complete',
            'eventId': event_id,
            'steps': {
                'step1_audio': {
                    'status': 'success',
                    'audioS3Key': audio_s3_key,
                    'captureTime': datetime.now(timezone.utc).isoformat()
                },
                'step2_distress': {
                    'status': 'success',
                    'confidence': distress_result['confidence'],
                    'threatLevel': distress_result['level'],
                    'keywords': distress_result.get('keywords', [])
                },
                'step3_event': {
                    'status': 'success',
                    'eventId': event_id,
                    'eventPayload': event_payload
                },
                'step4_geolocation': {
                    'status': 'success',
                    'location': location_data
                },
                'step5_sms': {
                    'status': 'success',
                    'results': sms_results,
                    'totalSent': len([r for r in sms_results if r['status'] == 'sent'])
                },
                'step6_confirmation': confirmation_result,
                'step7_analytics': analytics_result
            },
            'userProfile': user_profile,
            'timestamp': datetime.now(timezone.utc).isoformat()
        })
        
    except Exception as e:
        logger.error(f"Pipeline error: {str(e)}")
        return cors_response({
            'status': 'error',
            'message': f'Pipeline failed: {str(e)}'
        }, 500)

def detect_distress_bedrock(audio_data):
    """
    Step 2: AI Distress Detection using AWS Bedrock
    """
    try:
        # Prepare prompt for Claude
        prompt = f"""Analyze this audio transcript for signs of distress or emergency:

Transcript: "{audio_data}"

Determine:
1. Threat level (NONE, LOW, MEDIUM, HIGH, CRITICAL)
2. Confidence score (0.0 to 1.0)
3. Emergency keywords detected
4. Reasoning for the assessment

Respond in JSON format:
{{
    "level": "CRITICAL|HIGH|MEDIUM|LOW|NONE",
    "confidence": 0.87,
    "keywords": ["help", "emergency"],
    "reasoning": "explanation"
}}"""

        # Call Bedrock Claude model
        response = bedrock.invoke_model(
            modelId='anthropic.claude-3-haiku-20240307-v1:0',
            body=json.dumps({
                "anthropic_version": "bedrock-2023-05-31",
                "max_tokens": 200,
                "messages": [
                    {
                        "role": "user",
                        "content": prompt
                    }
                ]
            })
        )
        
        result = json.loads(response['body'].read())
        content = result['content'][0]['text']
        
        # Parse JSON response
        try:
            analysis = json.loads(content)
            return {
                'level': analysis.get('level', 'MEDIUM'),
                'confidence': analysis.get('confidence', 0.8),
                'keywords': analysis.get('keywords', []),
                'reasoning': analysis.get('reasoning', 'AI analysis completed')
            }
        except:
            # Fallback analysis
            return analyze_distress_fallback(audio_data)
            
    except Exception as e:
        logger.warning(f"Bedrock analysis failed: {str(e)}")
        return analyze_distress_fallback(audio_data)

def analyze_distress_fallback(audio_data):
    """
    Fallback distress analysis if Bedrock fails
    """
    message_upper = str(audio_data).upper()
    emergency_keywords = ['HELP', 'EMERGENCY', 'DANGER', '911', 'POLICE', 'FIRE', 'AMBULANCE']
    
    detected_keywords = [word for word in emergency_keywords if word in message_upper]
    
    if detected_keywords:
        return {
            'level': 'CRITICAL',
            'confidence': 0.87,
            'keywords': detected_keywords,
            'reasoning': f'Emergency keywords detected: {", ".join(detected_keywords)}'
        }
    else:
        return {
            'level': 'NONE',
            'confidence': 0.1,
            'keywords': [],
            'reasoning': 'No emergency indicators detected'
        }

def fetch_user_profile(user_id):
    """
    Step 4: Fetch User Profile from DynamoDB
    """
    try:
        table = dynamodb.Table('AllSenses-Live-MVP-DataTable-1JGAWXA3I5IUK')
        
        # Try to get existing user
        response = table.get_item(Key={'id': user_id})
        
        if 'Item' in response:
            return response['Item']
        else:
            # Create demo user profile with verified numbers for sandbox
            demo_profile = {
                'id': user_id,
                'userId': user_id,
                'victimName': 'Carlos Perez',
                'contacts': [
                    {
                        'name': 'Maria Perez',
                        'phone': '+15551112222',  # Use your verified number here
                        'optedIn': True,
                        'relationship': 'spouse',
                        'verified': True  # Mark as verified for sandbox
                    },
                    {
                        'name': 'Jose Rodriguez', 
                        'phone': '+15553334444',  # Use another verified number
                        'optedIn': True,
                        'relationship': 'friend',
                        'verified': True  # Mark as verified for sandbox
                    }
                ],
                'createdAt': datetime.now(timezone.utc).isoformat()
            }
            
            # Store demo profile
            table.put_item(Item=demo_profile)
            return demo_profile
            
    except Exception as e:
        logger.error(f"User profile fetch failed: {str(e)}")
        return {
            'userId': user_id,
            'victimName': 'Demo User',
            'contacts': []
        }

def dispatch_emergency_sms_production(user_profile, location_data, distress_result, event_id):
    """
    Step 5: Production-Ready SMS Dispatch via Amazon SNS
    Handles both sandbox and production modes
    """
    results = []
    victim_name = user_profile.get('victimName', 'Unknown')
    contacts = user_profile.get('contacts', [])
    
    # Check SNS sandbox status
    try:
        sandbox_status = sns.get_sms_sandbox_account_status()
        is_in_sandbox = sandbox_status.get('IsInSandbox', True)
        logger.info(f"SNS Sandbox Mode: {is_in_sandbox}")
    except Exception as e:
        logger.warning(f"Could not check sandbox status: {str(e)}")
        is_in_sandbox = True  # Assume sandbox if check fails
    
    # Filter contacts based on sandbox mode
    if is_in_sandbox:
        # In sandbox: only send to verified numbers
        opted_contacts = [c for c in contacts if c.get('optedIn', False) and c.get('verified', False)]
        if not opted_contacts:
            return [{
                'status': 'warning', 
                'message': 'SNS in sandbox mode - no verified contacts available',
                'sandboxMode': True,
                'suggestion': 'Verify phone numbers or request production access'
            }]
    else:
        # In production: send to all opted-in contacts
        opted_contacts = [c for c in contacts if c.get('optedIn', False)]
    
    if not opted_contacts:
        return [{'status': 'error', 'message': 'No eligible contacts for SMS'}]
    
    # Compose SMS message
    confidence_percent = int(distress_result['confidence'] * 100)
    
    sms_text = f"🚨 [AllSensesAI] Emergency alert for {victim_name}! Possible danger detected near {location_data['placeName']} — {location_data['mapLink']} Confidence: {confidence_percent}%. Please reply OK if received."
    
    # Send SMS to each eligible contact
    for contact in opted_contacts:
        try:
            response = sns.publish(
                PhoneNumber=contact['phone'],
                Message=sms_text
            )
            
            results.append({
                'contactName': contact['name'],
                'phone': contact['phone'],
                'status': 'sent',
                'messageId': response['MessageId'],
                'relationship': contact.get('relationship', 'contact'),
                'sandboxMode': is_in_sandbox,
                'verified': contact.get('verified', False)
            })
            
            logger.info(f"SMS sent to {contact['name']}: {response['MessageId']}")
            
        except Exception as e:
            error_msg = str(e)
            
            # Handle specific sandbox errors
            if 'not verified' in error_msg.lower() or 'sandbox' in error_msg.lower():
                results.append({
                    'contactName': contact['name'],
                    'phone': contact['phone'],
                    'status': 'sandbox_blocked',
                    'error': 'Phone number not verified in SNS sandbox',
                    'suggestion': f'Verify {contact["phone"]} in AWS SNS console'
                })
            else:
                results.append({
                    'contactName': contact['name'],
                    'phone': contact['phone'],
                    'status': 'failed',
                    'error': error_msg
                })
            
            logger.error(f"SMS failed for {contact['name']}: {error_msg}")
    
    return results

def verify_phone_number_in_sandbox(phone_number):
    """
    Helper function to verify a phone number in SNS sandbox
    """
    try:
        response = sns.create_sms_sandbox_phone_number(
            PhoneNumber=phone_number
        )
        logger.info(f"Verification initiated for {phone_number}")
        return {
            'status': 'verification_sent',
            'phone': phone_number,
            'message': 'Verification code sent via SMS'
        }
    except Exception as e:
        logger.error(f"Phone verification failed: {str(e)}")
        return {
            'status': 'verification_failed',
            'phone': phone_number,
            'error': str(e)
        }

def log_emergency_analytics(event_id, user_id, sms_results, distress_result):
    """
    Step 7: Analytics & Learning
    """
    try:
        analytics_data = {
            'eventId': event_id,
            'userId': user_id,  # Would be hashed in production
            'timestamp': datetime.now(timezone.utc).isoformat(),
            'threatLevel': distress_result['level'],
            'confidence': distress_result['confidence'],
            'smsCount': len(sms_results),
            'successfulSms': len([r for r in sms_results if r['status'] == 'sent']),
            'failedSms': len([r for r in sms_results if r['status'] == 'failed']),
            'sandboxBlocked': len([r for r in sms_results if r['status'] == 'sandbox_blocked'])
        }
        
        # Log to CloudWatch
        logger.info(f"ANALYTICS: {json.dumps(analytics_data)}")
        
        return {
            'status': 'logged',
            'eventId': event_id,
            'metrics': analytics_data
        }
        
    except Exception as e:
        logger.error(f"Analytics logging failed: {str(e)}")
        return {'status': 'failed', 'error': str(e)}

def get_user_profile(body):
    """
    Get user profile for frontend
    """
    user_id = body.get('userId', 'user-123')
    profile = fetch_user_profile(user_id)
    return cors_response(profile)

def send_emergency_sms(body):
    """
    Direct SMS sending with production/sandbox handling
    """
    try:
        phone_number = body.get('phoneNumber', '+15551234567')
        emergency_message = body.get('emergencyMessage', 'AllSenseAI Demo Test')
        
        # Check if we can send to this number
        try:
            sandbox_status = sns.get_sms_sandbox_account_status()
            is_in_sandbox = sandbox_status.get('IsInSandbox', True)
            
            if is_in_sandbox:
                # Check if number is verified
                try:
                    verified_numbers = sns.list_sms_sandbox_phone_numbers()
                    verified_list = [num['PhoneNumber'] for num in verified_numbers.get('PhoneNumbers', [])]
                    
                    if phone_number not in verified_list:
                        return cors_response({
                            'status': 'sandbox_blocked',
                            'message': f'Phone number {phone_number} not verified in SNS sandbox',
                            'suggestion': 'Verify the number first or request production access',
                            'verifiedNumbers': verified_list
                        }, 400)
                except Exception as e:
                    logger.warning(f"Could not check verified numbers: {str(e)}")
        except Exception as e:
            logger.warning(f"Could not check sandbox status: {str(e)}")
        
        # Send the SMS
        response = sns.publish(
            PhoneNumber=phone_number,
            Message=f"🚨 ALLSENSESAI DEMO 🚨\n\n{emergency_message}\n\nTime: {datetime.now().strftime('%H:%M:%S')}\n\n- AllSensesAI Guardian"
        )
        
        return cors_response({
            'status': 'success',
            'message': 'Real SMS sent successfully',
            'phoneNumber': phone_number,
            'smsMessageId': response['MessageId'],
            'timestamp': datetime.now(timezone.utc).isoformat()
        })
        
    except Exception as e:
        error_msg = str(e)
        
        if 'not verified' in error_msg.lower() or 'sandbox' in error_msg.lower():
            return cors_response({
                'status': 'sandbox_error',
                'message': f'SMS blocked by sandbox mode: {error_msg}',
                'suggestion': 'Verify phone number or request production access'
            }, 400)
        else:
            return cors_response({
                'status': 'error',
                'message': f'SMS failed: {error_msg}'
            }, 500)

def analyze_audio_distress(body):
    """
    Audio analysis endpoint
    """
    audio_data = body.get('message', body.get('audioData', 'Test'))
    distress_result = detect_distress_bedrock(audio_data)
    
    return cors_response({
        'status': 'success',
        'message': 'AllSensesAI Audio Analysis Complete',
        'distressAnalysis': distress_result,
        'timestamp': datetime.now(timezone.utc).isoformat()
    })

def cors_response(data, status_code=200):
    """
    Return CORS-enabled response
    """
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,Authorization'
        },
        'body': json.dumps(data, default=str)
    }