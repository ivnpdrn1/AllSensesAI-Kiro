# Deploy Jury Demo Version
# Configured for +13053033060 with real SMS capability

Write-Host "DEPLOYING JURY DEMO VERSION" -ForegroundColor Green
Write-Host "===========================" -ForegroundColor Green
Write-Host "Phone: +13053033060" -ForegroundColor Cyan

$functionName = "AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK"

# Create deployment package
Write-Host "Creating jury demo package..." -ForegroundColor Yellow
Compress-Archive -Path "allsenseai-jury-demo.py" -DestinationPath "jury-demo.zip" -Force

Write-Host "Package created: jury-demo.zip" -ForegroundColor Green

Write-Host "Deploy with this command:" -ForegroundColor Yellow
Write-Host "aws lambda update-function-code --function-name $functionName --zip-file fileb://jury-demo.zip" -ForegroundColor Cyan

Write-Host "Jury Demo Features:" -ForegroundColor Magenta
Write-Host "- Real SMS to +13053033060" -ForegroundColor Green
Write-Host "- Simulated SMS to other contacts" -ForegroundColor Yellow
Write-Host "- Special jury test endpoint" -ForegroundColor Cyan
Write-Host "- Miami location for demo" -ForegroundColor White

Write-Host "Test endpoints:" -ForegroundColor Yellow
Write-Host "- JURY_DEMO_TEST - Send test SMS to jury phone" -ForegroundColor White
Write-Host "- SIMULATE_EMERGENCY - Full 7-step pipeline" -ForegroundColor White

Write-Host "Ready for jury presentation!" -ForegroundColor Green