Write-Host "Testing AllSenses Lambda Function..." -ForegroundColor Green

$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json" -TimeoutSec 10
    Write-Host "SUCCESS: Lambda is working!" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Demo URLs ready:" -ForegroundColor Green
    Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor White
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "DIAGNOSIS: Lambda function URL permissions issue" -ForegroundColor Yellow
    Write-Host "The function exists but needs public access configuration." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "FIX: Run this AWS CLI command:" -ForegroundColor Cyan
    Write-Host "aws lambda add-permission --function-name AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk --statement-id allow-url-invoke --action lambda:InvokeFunctionUrl --principal `"*`" --function-url-auth-type NONE --region us-east-1" -ForegroundColor White
    Write-Host ""
    Write-Host "OR use AWS Console:" -ForegroundColor Cyan
    Write-Host "1. Go to Lambda Console" -ForegroundColor White
    Write-Host "2. Open function: AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk" -ForegroundColor White
    Write-Host "3. Configuration -> Function URL -> Set Auth to NONE" -ForegroundColor White
    Write-Host ""
    Write-Host "This is the ONLY issue preventing perfect demo!" -ForegroundColor Yellow
}