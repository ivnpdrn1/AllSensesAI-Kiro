# Test the Deployed Lambda Function

$lambdaUrl = "https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/"

Write-Host "TESTING DEPLOYED LAMBDA FUNCTION" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host "Function: AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk" -ForegroundColor Cyan
Write-Host "URL: $lambdaUrl" -ForegroundColor Cyan

# Test 1: Basic connectivity
Write-Host "`nTest 1: Basic Lambda connectivity" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"message":"test"}' -ContentType "application/json"
    Write-Host "SUCCESS: Lambda is responding" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Check SNS Status (Jury Demo)
Write-Host "`nTest 2: Check SNS Status (Jury Demo)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"CHECK_SNS_STATUS"}' -ContentType "application/json"
    Write-Host "SUCCESS: SNS Status endpoint working" -ForegroundColor Green
    Write-Host "Mode: $($response.snsStatus.mode)" -ForegroundColor Cyan
    Write-Host "Jury Phone: $($response.snsStatus.juryPhone)" -ForegroundColor Cyan
    Write-Host "Demo Ready: $($response.snsStatus.demoReady)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Jury Demo Test SMS
Write-Host "`nTest 3: Jury Demo Test SMS" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json"
    Write-Host "SUCCESS: Jury demo test working" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
    Write-Host "Message ID: $($response.messageId)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Emergency Simulation
Write-Host "`nTest 4: Emergency Simulation" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"SIMULATE_EMERGENCY","audioData":"Help! Emergency!","userId":"jury-test"}' -ContentType "application/json"
    Write-Host "SUCCESS: Emergency simulation working" -ForegroundColor Green
    Write-Host "Event ID: $($response.eventId)" -ForegroundColor Cyan
    Write-Host "Jury Demo: $($response.juryDemo)" -ForegroundColor Cyan
    Write-Host "SMS Results: $($response.steps.step5_sms.totalSent) messages sent" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Direct SMS to Jury Phone
Write-Host "`nTest 5: Direct SMS to Jury Phone (<REDACTED_PHONE_NUMBER>)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"MAKE_REAL_CALL","phoneNumber":"<REDACTED_PHONE_NUMBER>","emergencyMessage":"Deployment test successful!"}' -ContentType "application/json"
    Write-Host "SUCCESS: Direct SMS working" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Phone: $($response.phoneNumber)" -ForegroundColor Cyan
    Write-Host "Message ID: $($response.smsMessageId)" -ForegroundColor Cyan
    Write-Host "Real SMS: $($response.realSms)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🏆 TESTING COMPLETE!" -ForegroundColor Green
Write-Host "Now test your demo interfaces:" -ForegroundColor Yellow
Write-Host "1. Jury Demo: https://d4om8j6cvwtqd.cloudfront.net/hackathon-jury-demo.html" -ForegroundColor Cyan
Write-Host "2. Enhanced Monitor: https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Cyan