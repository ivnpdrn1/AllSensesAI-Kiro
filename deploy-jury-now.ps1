# Deploy Jury Demo Lambda Function NOW

Write-Host "DEPLOYING JURY DEMO LAMBDA NOW" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green

$functionName = "AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK"

# Check if jury demo zip exists
if (Test-Path "jury-demo.zip") {
    Write-Host "Found jury-demo.zip - deploying..." -ForegroundColor Green
} else {
    Write-Host "Creating jury-demo.zip..." -ForegroundColor Yellow
    Compress-Archive -Path "allsenseai-jury-demo.py" -DestinationPath "jury-demo.zip" -Force
    Write-Host "Created jury-demo.zip" -ForegroundColor Green
}

Write-Host "`nDeploying to Lambda..." -ForegroundColor Yellow
Write-Host "Function: $functionName" -ForegroundColor Cyan

# The deployment command
$deployCommand = "aws lambda update-function-code --function-name $functionName --zip-file fileb://jury-demo.zip"

Write-Host "`nRUN THIS COMMAND:" -ForegroundColor Red
Write-Host $deployCommand -ForegroundColor White

Write-Host "`nAfter deployment, test with:" -ForegroundColor Yellow
Write-Host ".\test-lambda-connectivity.ps1" -ForegroundColor Cyan

Write-Host "`nJury demo features:" -ForegroundColor Green
Write-Host "- Real SMS to +13053033060" -ForegroundColor White
Write-Host "- JURY_DEMO_TEST endpoint" -ForegroundColor White
Write-Host "- SIMULATE_EMERGENCY with jury phone" -ForegroundColor White
Write-Host "- CHECK_SNS_STATUS for jury demo" -ForegroundColor White