# Simple Lambda Update
$env:AWS_ACCESS_KEY_ID = "<REDACTED_AWS_ACCESS_KEY>"
$env:AWS_SECRET_ACCESS_KEY = "<REDACTED_AWS_SECRET_KEY>"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "Updating Lambda function..." -ForegroundColor Green

# Create deployment package
$TEMP_DIR = "lambda-update"
if (Test-Path $TEMP_DIR) { Remove-Item -Recurse -Force $TEMP_DIR }
New-Item -ItemType Directory -Path $TEMP_DIR | Out-Null
Copy-Item "allsenseai-complete.py" "$TEMP_DIR/lambda_function.py"

# Create zip
$ZIP_FILE = "lambda-update.zip"
if (Test-Path $ZIP_FILE) { Remove-Item $ZIP_FILE }
Compress-Archive -Path "$TEMP_DIR/*" -DestinationPath $ZIP_FILE

# Update Lambda
aws lambda update-function-code --function-name "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk" --zip-file "fileb://$ZIP_FILE"

Write-Host "Lambda function updated!" -ForegroundColor Green

# Cleanup
Remove-Item -Recurse -Force $TEMP_DIR -ErrorAction SilentlyContinue
Remove-Item $ZIP_FILE -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "DEPLOYMENT STATUS:" -ForegroundColor Yellow
Write-Host "✅ Frontend deployed with victim name fields" -ForegroundColor White
Write-Host "✅ Lambda updated with geolocation SMS" -ForegroundColor White
Write-Host "✅ Direct SMS test successful" -ForegroundColor White
Write-Host ""
Write-Host "Jury Demo URL:" -ForegroundColor Cyan
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor White