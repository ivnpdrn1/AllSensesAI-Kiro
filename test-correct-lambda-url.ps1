# Test the Correct Lambda URL

$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

Write-Host "TESTING CORRECT LAMBDA URL" -ForegroundColor Green
Write-Host "===========================" -ForegroundColor Green
Write-Host "URL: $lambdaUrl" -ForegroundColor Cyan

# Test basic connectivity
Write-Host "`nTesting basic connectivity..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"message":"test"}' -ContentType "application/json" -TimeoutSec 10
    Write-Host "SUCCESS: Lambda is responding!" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor White
    Write-Host "Message: $($response.message)" -ForegroundColor White
    
    # Test jury demo endpoint
    Write-Host "`nTesting jury demo endpoint..." -ForegroundColor Yellow
    $juryResponse = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json" -TimeoutSec 10
    Write-Host "SUCCESS: Jury demo working!" -ForegroundColor Green
    Write-Host "Status: $($juryResponse.status)" -ForegroundColor White
    
    Write-Host "`nLambda URL is working! Ready to deploy frontend." -ForegroundColor Green
    
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Frontend will still be deployed, but may not work until Lambda is fixed." -ForegroundColor Yellow
}