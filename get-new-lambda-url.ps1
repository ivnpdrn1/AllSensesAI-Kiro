# Get Lambda URL for AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk

$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"

Write-Host "Getting Lambda URL for: $functionName" -ForegroundColor Yellow

# Get the Lambda function URL
try {
    $lambdaUrl = aws lambda get-function-url-config --function-name $functionName --query 'FunctionUrl' --output text --region us-east-1
    Write-Host "Lambda URL: $lambdaUrl" -ForegroundColor Green
    
    # If no URL exists, create one
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Creating function URL..." -ForegroundColor Yellow
        aws lambda create-function-url-config --function-name $functionName --auth-type NONE --cors '{"AllowCredentials":false,"AllowHeaders":["*"],"AllowMethods":["*"],"AllowOrigins":["*"]}' --region us-east-1
        
        $lambdaUrl = aws lambda get-function-url-config --function-name $functionName --query 'FunctionUrl' --output text --region us-east-1
        Write-Host "Created Lambda URL: $lambdaUrl" -ForegroundColor Green
    }
    
    # Test the URL
    Write-Host "`nTesting the URL..." -ForegroundColor Yellow
    $testResponse = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"message":"test"}' -ContentType "application/json"
    Write-Host "SUCCESS: Lambda is responding" -ForegroundColor Green
    Write-Host "Response: $($testResponse.status)" -ForegroundColor Cyan
    
    # Output the URL for use in frontend
    Write-Host "`nNew Lambda URL to use in frontend:" -ForegroundColor Magenta
    Write-Host $lambdaUrl -ForegroundColor White
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    # Fallback - construct expected URL
    $expectedUrl = "https://ufwarjq6fvrk-lambda-url.us-east-1.on.aws/"
    Write-Host "`nExpected URL format: $expectedUrl" -ForegroundColor Yellow
}