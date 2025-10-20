# Test New Lambda URL

$newLambdaUrl = "https://ufwarjq6fvrk-lambda-url.us-east-1.on.aws/"

Write-Host "TESTING NEW LAMBDA URL" -ForegroundColor Green
Write-Host "======================" -ForegroundColor Green
Write-Host "URL: $newLambdaUrl" -ForegroundColor Cyan

# Test 1: Basic connectivity
Write-Host "`nTest 1: Basic connectivity" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $newLambdaUrl -Method POST -Body '{"message":"test"}' -ContentType "application/json"
    Write-Host "SUCCESS: Lambda is responding" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Jury Demo Test
Write-Host "`nTest 2: Jury Demo Test" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $newLambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json"
    Write-Host "SUCCESS: Jury demo endpoint working" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Emergency Simulation
Write-Host "`nTest 3: Emergency Simulation" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $newLambdaUrl -Method POST -Body '{"action":"SIMULATE_EMERGENCY","audioData":"Help! Emergency!"}' -ContentType "application/json"
    Write-Host "SUCCESS: Emergency simulation working" -ForegroundColor Green
    Write-Host "Event ID: $($response.eventId)" -ForegroundColor Cyan
    Write-Host "Jury Phone: $($response.juryPhone)" -ForegroundColor Cyan
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nIf tests pass, deploy the frontend files!" -ForegroundColor Green