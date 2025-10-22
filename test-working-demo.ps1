# Test Working Demo - Verify Everything Works

$lambdaUrl = "https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/"

Write-Host "TESTING WORKING DEMO" -ForegroundColor Green
Write-Host "====================" -ForegroundColor Green

# Test 1: Check SNS Status
Write-Host "`nTest 1: Check SNS Status" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"CHECK_SNS_STATUS"}' -ContentType "application/json"
    Write-Host "SUCCESS: SNS Status working" -ForegroundColor Green
    Write-Host "Mode: $($response.snsStatus.mode)" -ForegroundColor Cyan
    Write-Host "Jury Phone: $($response.snsStatus.juryPhone)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Jury Demo Test
Write-Host "`nTest 2: Jury Demo Test" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json"
    Write-Host "SUCCESS: Jury demo test working" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Emergency Simulation
Write-Host "`nTest 3: Emergency Simulation" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"SIMULATE_EMERGENCY","audioData":"Help! Emergency!"}' -ContentType "application/json"
    Write-Host "SUCCESS: Emergency simulation working" -ForegroundColor Green
    Write-Host "Event ID: $($response.eventId)" -ForegroundColor Cyan
    Write-Host "SMS Results: $($response.steps.step5_sms.totalSent) sent" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Real SMS
Write-Host "`nTest 4: Real SMS to Jury Phone" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"MAKE_REAL_CALL","phoneNumber":"<REDACTED_PHONE_NUMBER>","emergencyMessage":"Final test"}' -ContentType "application/json"
    Write-Host "SUCCESS: Real SMS working" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message ID: $($response.smsMessageId)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nDEMO IS READY!" -ForegroundColor Green