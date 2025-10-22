# Test Final Lambda URL

$lambdaUrl = "https://ufwarjq6fvrk.lambda-url.us-east-1.on.aws/"

Write-Host "TESTING FINAL LAMBDA URL" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
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
    
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Message -like "*403*") {
        Write-Host "`nLambda URL exists but needs permissions configured" -ForegroundColor Yellow
        Write-Host "Run: aws lambda create-function-url-config --function-name AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk --auth-type NONE --cors '{`"AllowCredentials`":false,`"AllowHeaders`":[`"*`"],`"AllowMethods`":[`"*`"],`"AllowOrigins`":[`"*`"]}' --region us-east-1" -ForegroundColor Gray
    } elseif ($_.Exception.Message -like "*could not be resolved*") {
        Write-Host "`nLambda URL doesn't exist yet" -ForegroundColor Yellow
        Write-Host "Run: aws lambda create-function-url-config --function-name AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk --auth-type NONE --cors '{`"AllowCredentials`":false,`"AllowHeaders`":[`"*`"],`"AllowMethods`":[`"*`"],`"AllowOrigins`":[`"*`"]}' --region us-east-1" -ForegroundColor Gray
    }
}

Write-Host "`nIf Lambda URL works, deploy the frontend files!" -ForegroundColor Green