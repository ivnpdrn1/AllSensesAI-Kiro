# Deploy Minimal Working Version - Fix 502 Error

Write-Host "DEPLOYING MINIMAL WORKING VERSION" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"

# Create deployment package
Write-Host "Creating minimal working package..." -ForegroundColor Yellow
Compress-Archive -Path "allsenseai-minimal-working.py" -DestinationPath "minimal-working.zip" -Force

Write-Host "Package created: minimal-working.zip" -ForegroundColor Green

Write-Host "`nDEPLOY COMMAND:" -ForegroundColor Red
Write-Host "aws lambda update-function-code --function-name $functionName --zip-file fileb://minimal-working.zip" -ForegroundColor White

Write-Host "`nThis version fixes:" -ForegroundColor Green
Write-Host "- 502 Bad Gateway errors" -ForegroundColor White
Write-Host "- Missing function dependencies" -ForegroundColor White
Write-Host "- Simplified but complete functionality" -ForegroundColor White
Write-Host "- Real SMS to <REDACTED_PHONE_NUMBER>" -ForegroundColor White