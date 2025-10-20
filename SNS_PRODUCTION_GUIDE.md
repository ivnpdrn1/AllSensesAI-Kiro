# AWS SNS Production Access Guide

## Current Situation
Your AllSensesAI system is currently in **AWS SNS Sandbox Mode**, which means:
- ✅ SMS can only be sent to **verified phone numbers**
- ❌ Cannot send SMS to unverified numbers
- 📱 Limited to 10 verified numbers maximum
- 💰 $1 USD spending limit per month

## Solution Options

### Option 1: Request Production Access (Recommended)
**This removes all sandbox restrictions**

#### Steps:
1. **Open AWS Support Center**: https://console.aws.amazon.com/support/home
2. **Create New Case**:
   - Service: Amazon Simple Notification Service (SNS)
   - Category: Service Limit Increase
   - Severity: General guidance

3. **Case Details**:
   ```
   Subject: Request to move SNS out of sandbox mode
   
   Description: 
   Please move my AWS account out of SNS sandbox mode for emergency notification system.
   
   Use Case: AllSensesAI emergency response system for safety notifications
   Expected Volume: 1000-5000 SMS per month
   Message Type: Emergency notifications and safety alerts
   Target Regions: US, Canada
   Compliance: Emergency services integration
   ```

4. **Timeline**: Usually approved within 24-48 hours
5. **Cost**: No additional fees, just pay per SMS sent

### Option 2: Verify Phone Numbers (Temporary Solution)
**Use this while waiting for production access**

#### Verify Numbers via AWS CLI:
```bash
# Start verification
aws sns create-sms-sandbox-phone-number --phone-number +1234567890

# Complete verification (after receiving SMS code)
aws sns verify-sms-sandbox-phone-number --phone-number +1234567890 --one-time-password 123456

# List verified numbers
aws sns list-sms-sandbox-phone-numbers
```

#### Or use our helper script:
```powershell
# Start verification
.\scripts\verify-sandbox-numbers.ps1 -PhoneNumber "+1234567890"

# Complete verification
.\scripts\verify-sandbox-numbers.ps1 -PhoneNumber "+1234567890" -VerificationCode "123456"
```

## Updated Lambda Function Features

The new `allsenseai-production-ready.py` includes:

### 🔍 Automatic Mode Detection
- Detects if SNS is in sandbox or production mode
- Adjusts behavior accordingly
- Provides clear error messages

### 📱 Smart Contact Filtering
- **Sandbox Mode**: Only sends to verified numbers
- **Production Mode**: Sends to all opted-in contacts
- Graceful handling of unverified numbers

### 🧪 New Testing Endpoints
```json
// Check SNS status
POST /lambda-url
{
  "action": "CHECK_SNS_STATUS"
}

// Response includes:
{
  "snsStatus": {
    "isInSandbox": true,
    "mode": "SANDBOX",
    "canSendToUnverified": false
  }
}
```

### 📊 Enhanced Error Reporting
- Clear distinction between sandbox and production errors
- Suggestions for resolving issues
- Better analytics tracking

## Testing Your System

### 1. Deploy Updated Lambda
```powershell
# Update Lambda function with production-ready code
aws lambda update-function-code --function-name AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK --zip-file fileb://allsenseai-production.zip
```

### 2. Check SNS Status
```powershell
# Run our test script
.\test-sns-production.ps1
```

### 3. Verify Phone Numbers (if needed)
```powershell
# Verify your test numbers
.\scripts\verify-sandbox-numbers.ps1 -PhoneNumber "+1234567890"
```

## Production Readiness Checklist

- [ ] Request SNS production access via AWS Support
- [ ] Update Lambda function with production-ready code
- [ ] Verify test phone numbers for immediate testing
- [ ] Update user profiles with verified numbers
- [ ] Test emergency pipeline with verified numbers
- [ ] Monitor for production access approval
- [ ] Re-test with unverified numbers once approved

## Expected Timeline

1. **Immediate** (0-5 minutes): Deploy updated Lambda function
2. **Immediate** (0-10 minutes): Verify test phone numbers
3. **24-48 hours**: AWS approves production access request
4. **Production Ready**: Full SMS capability to any number

## Cost Implications

### Sandbox Mode: FREE
- Up to 10 verified numbers
- $1 USD monthly limit

### Production Mode: Pay-per-use
- $0.00645 per SMS in US
- No monthly limits
- No number restrictions

For 1000 emergency SMS per month: ~$6.45 USD

## Next Steps

1. **Run**: `.\scripts\request-sns-production-access.ps1` for detailed instructions
2. **Deploy**: Updated Lambda function (already created)
3. **Verify**: Test phone numbers while waiting for approval
4. **Monitor**: AWS Support case for production access

Your AllSensesAI system will work perfectly once production access is approved!