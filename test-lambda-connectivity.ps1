# Test Lambda Connectivity for Jury Demo

$lambdaUrl = "https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/"

Write-Host "Testing Lambda connectivity..." -ForegroundColor Yellow
Write-Host "URL: $lambdaUrl" -ForegroundColor Cyan

# Test 1: Basic connectivity
Write-Host "`nTest 1: Basic connectivity test" -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"CHECK_SNS_STATUS"}' -ContentType "application/json"
    Write-Host "SUCCESS: Lambda is responding" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Jury demo test
Write-Host "`nTest 2: Jury demo test" -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json"
    Write-Host "SUCCESS: Jury demo endpoint working" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nIf tests fail, the Lambda function needs to be deployed!" -ForegroundColor Yellow