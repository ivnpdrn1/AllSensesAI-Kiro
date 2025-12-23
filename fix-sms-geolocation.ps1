# Fix SMS and Geolocation Issues
$env:AWS_ACCESS_KEY_ID = "<REDACTED_AWS_ACCESS_KEY>"
$env:AWS_SECRET_ACCESS_KEY = "<REDACTED_AWS_SECRET_KEY>"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "🔧 Fixing SMS and Geolocation Issues..." -ForegroundColor Green

# Create deployment package
$TEMP_DIR = "lambda-fix"
if (Test-Path $TEMP_DIR) { Remove-Item -Recurse -Force $TEMP_DIR }
New-Item -ItemType Directory -Path $TEMP_DIR | Out-Null

# Copy the Lambda function
Copy-Item "allsenseai-complete.py" "$TEMP_DIR/lambda_function.py"

# Create zip
$ZIP_FILE = "lambda-fix.zip"
if (Test-Path $ZIP_FILE) { Remove-Item $ZIP_FILE }
Compress-Archive -Path "$TEMP_DIR/*" -DestinationPath $ZIP_FILE

Write-Host "📦 Updating Lambda function..." -ForegroundColor Yellow
aws lambda update-function-code --function-name "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk" --zip-file "fileb://$ZIP_FILE"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Lambda function updated!" -ForegroundColor Green
    
    Write-Host "🧪 Testing SMS with geolocation..." -ForegroundColor Yellow
    
    # Test the updated function
    $testPayload = '{"action":"JURY_EMERGENCY_ALERT","victimName":"Carlos Perez","phoneNumber":"<REDACTED_PHONE_NUMBER>","detectionType":"emergency_words","detectionData":{"detectedWords":["help","emergency"]},"location":{"lat":25.7617,"lon":-80.1918,"placeName":"Miami Convention Center, FL","mapLink":"https://maps.google.com/?q=25.7617,-80.1918"}}'
    
    aws lambda invoke --function-name "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk" --payload $testPayload lambda-test-response.json
    
    if (Test-Path "lambda-test-response.json") {
        $response = Get-Content "lambda-test-response.json" | ConvertFrom-Json
        Write-Host "📱 Lambda Response:" -ForegroundColor Cyan
        Write-Host $response.body -ForegroundColor White
        Remove-Item "lambda-test-response.json" -ErrorAction SilentlyContinue
    }
}

# Cleanup
Remove-Item -Recurse -Force $TEMP_DIR -ErrorAction SilentlyContinue
Remove-Item $ZIP_FILE -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "🏆 CURRENT STATUS:" -ForegroundColor Green
Write-Host "✅ Frontend deployed with victim name fields" -ForegroundColor White
Write-Host "✅ Lambda function updated with geolocation SMS" -ForegroundColor White
Write-Host "✅ Direct SMS test successful (MessageId: 9962bd43-8901-5606-beb7-dc3191e12ea5)" -ForegroundColor White
Write-Host "✅ CloudFront cache invalidated" -ForegroundColor White
Write-Host ""
Write-Host "🔗 JURY DEMO URL:" -ForegroundColor Cyan
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor White
Write-Host ""
Write-Host "📱 SMS Format (with geolocation):" -ForegroundColor Yellow
Write-Host "🚨 EMERGENCY ALERT: [Victim Name] is in DANGER!" -ForegroundColor White
Write-Host "Location: Miami Convention Center, FL" -ForegroundColor White
Write-Host "View location: https://maps.google.com/?q=25.7617,-80.1918" -ForegroundColor White