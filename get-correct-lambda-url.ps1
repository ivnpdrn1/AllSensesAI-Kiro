# Get the correct Lambda URL for the deployed function

$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"

Write-Host "Getting Lambda URL for: $functionName" -ForegroundColor Yellow

# Get the Lambda function URL
try {
    $lambdaUrl = aws lambda get-function-url-config --function-name $functionName --query 'FunctionUrl' --output text
    Write-Host "Lambda URL: $lambdaUrl" -ForegroundColor Green
    
    # Test the URL
    Write-Host "`nTesting the URL..." -ForegroundColor Yellow
    $testResponse = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"message":"test"}' -ContentType "application/json"
    Write-Host "SUCCESS: Lambda is responding" -ForegroundColor Green
    Write-Host "Response: $($testResponse.status)" -ForegroundColor Cyan
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    # Try to create a function URL if it doesn't exist
    Write-Host "`nTrying to create function URL..." -ForegroundColor Yellow
    try {
        aws lambda create-function-url-config --function-name $functionName --auth-type NONE --cors '{"AllowCredentials":false,"AllowHeaders":["*"],"AllowMethods":["*"],"AllowOrigins":["*"]}'
        
        $lambdaUrl = aws lambda get-function-url-config --function-name $functionName --query 'FunctionUrl' --output text
        Write-Host "Created Lambda URL: $lambdaUrl" -ForegroundColor Green
        
    } catch {
        Write-Host "Failed to create function URL: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nUpdate the frontend with this URL:" -ForegroundColor Yellow
Write-Host $lambdaUrl -ForegroundColor White