# Fix Jury Demo Connectivity Issues
# Deploy the jury demo Lambda and test connectivity

Write-Host "FIXING JURY DEMO CONNECTIVITY" -ForegroundColor Red
Write-Host "=============================" -ForegroundColor Red

$functionName = "AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK"

Write-Host "Step 1: Deploy jury demo Lambda function..." -ForegroundColor Yellow

# Deploy the jury demo version
Write-Host "Deploying jury-demo.zip..." -ForegroundColor Cyan
Write-Host "Command: aws lambda update-function-code --function-name $functionName --zip-file fileb://jury-demo.zip" -ForegroundColor Gray

Write-Host "`nStep 2: Test Lambda connectivity..." -ForegroundColor Yellow
$lambdaUrl = "https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/"

Write-Host "Testing URL: $lambdaUrl" -ForegroundColor Cyan

# Test basic connectivity
$testPayload = @{
    action = "CHECK_SNS_STATUS"
} | ConvertTo-Json

Write-Host "`nTest payload:" -ForegroundColor Gray
Write-Host $testPayload -ForegroundColor Gray

Write-Host "`nStep 3: Manual test command:" -ForegroundColor Yellow
Write-Host "Invoke-RestMethod -Uri '$lambdaUrl' -Method POST -Body '$testPayload' -ContentType 'application/json'" -ForegroundColor Cyan

Write-Host "`nStep 4: If still failing, check:" -ForegroundColor Yellow
Write-Host "1. Lambda function is deployed" -ForegroundColor White
Write-Host "2. Lambda URL is correct" -ForegroundColor White
Write-Host "3. CORS headers are enabled" -ForegroundColor White
Write-Host "4. Function has proper permissions" -ForegroundColor White

Write-Host "`nFIX READY - Deploy and test!" -ForegroundColor Green