# Deploy AllSensesAI Jury Demo Version
# Configurable victim name and emergency contact phone

Write-Host "🏆 Deploying AllSensesAI Jury Demo Version..." -ForegroundColor Green

# Check if AWS CLI is available
if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
    Write-Host "❌ AWS CLI not found. Please install AWS CLI first." -ForegroundColor Red
    exit 1
}

# Function name from existing deployment
$FUNCTION_NAME = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"

Write-Host "📦 Creating deployment package..." -ForegroundColor Yellow

# Create temporary directory for deployment
$TEMP_DIR = "jury-demo-deploy"
if (Test-Path $TEMP_DIR) {
    Remove-Item -Recurse -Force $TEMP_DIR
}
New-Item -ItemType Directory -Path $TEMP_DIR | Out-Null

# Copy the jury demo Lambda function
Copy-Item "allsenseai-jury-simple.py" "$TEMP_DIR/lambda_function.py"

# Create deployment zip
$ZIP_FILE = "jury-demo-deployment.zip"
if (Test-Path $ZIP_FILE) {
    Remove-Item $ZIP_FILE
}

# Create zip file
Compress-Archive -Path "$TEMP_DIR/*" -DestinationPath $ZIP_FILE

Write-Host "🚀 Updating Lambda function: $FUNCTION_NAME" -ForegroundColor Yellow

# Update Lambda function code
aws lambda update-function-code --function-name $FUNCTION_NAME --zip-file "fileb://$ZIP_FILE" --no-cli-pager

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Lambda function updated successfully!" -ForegroundColor Green
    
    # Wait for update to complete
    Write-Host "⏳ Waiting for function update to complete..." -ForegroundColor Yellow
    aws lambda wait function-updated --function-name $FUNCTION_NAME
    
    Write-Host "🎯 Testing jury demo function..." -ForegroundColor Yellow
    
    # Test the function
    $TEST_PAYLOAD = '{"action":"JURY_TEST","victimName":"Jury Test User","phoneNumber":"<REDACTED_PHONE_NUMBER>"}'
    
    aws lambda invoke --function-name $FUNCTION_NAME --payload $TEST_PAYLOAD --no-cli-pager jury-test-response.json
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Function test completed!" -ForegroundColor Green
        
        # Show test result
        if (Test-Path "jury-test-response.json") {
            $response = Get-Content "jury-test-response.json" | ConvertFrom-Json
            Write-Host "📱 Test Response: $($response.body)" -ForegroundColor Cyan
        }
    }
} else {
    Write-Host "❌ Failed to update Lambda function" -ForegroundColor Red
    exit 1
}

# Cleanup
Remove-Item -Recurse -Force $TEMP_DIR -ErrorAction SilentlyContinue
Remove-Item $ZIP_FILE -ErrorAction SilentlyContinue
Remove-Item "jury-test-response.json" -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "🏆 JURY DEMO DEPLOYMENT COMPLETE! 🏆" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Jury Demo Features:" -ForegroundColor Yellow
Write-Host "   ✅ Configurable victim name input field" -ForegroundColor White
Write-Host "   ✅ Configurable emergency contact phone number" -ForegroundColor White
Write-Host "   ✅ SMS messages include victim name and clear danger message" -ForegroundColor White
Write-Host "   ✅ Simplified implementation for quick jury evaluation" -ForegroundColor White
Write-Host ""
Write-Host "🌐 Demo URL: Open jury-emergency-demo.html in your browser" -ForegroundColor Cyan
Write-Host "📱 Lambda Function: $FUNCTION_NAME" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Instructions for Jury:" -ForegroundColor Yellow
Write-Host "   1. Open jury-emergency-demo.html in a web browser" -ForegroundColor White
Write-Host "   2. Enter victim's name (e.g., 'Carlos Perez')" -ForegroundColor White
Write-Host "   3. Enter jury member's phone number for real SMS alerts" -ForegroundColor White
Write-Host "   4. Click 'Start Emergency Monitoring' to begin detection" -ForegroundColor White
Write-Host "   5. Test with 'Test Emergency Words' or 'Test Abrupt Noise' buttons" -ForegroundColor White
Write-Host "   6. Jury member will receive real SMS with victim name and location" -ForegroundColor White
Write-Host ""
Write-Host "🚨 Emergency SMS Format:" -ForegroundColor Red
Write-Host "   '🚨 EMERGENCY ALERT: [Victim Name] is in DANGER!'" -ForegroundColor White
Write-Host "   'Emergency words detected: help, emergency'" -ForegroundColor White
Write-Host "   'Location: Miami Convention Center, FL'" -ForegroundColor White
Write-Host "   'View location: [Google Maps Link]'" -ForegroundColor White
Write-Host ""