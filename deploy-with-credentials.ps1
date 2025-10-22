# Deploy Updated Jury Demo with AWS Credentials
Write-Host "🏆 Deploying Updated Jury Demo..." -ForegroundColor Green

# Set AWS credentials
$env:AWS_ACCESS_KEY_ID = "<REDACTED_AWS_ACCESS_KEY>"
$env:AWS_SECRET_ACCESS_KEY = "<REDACTED_AWS_SECRET_KEY>"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "📤 Uploading enhanced emergency monitor with victim name fields..." -ForegroundColor Yellow

# Upload the updated enhanced emergency monitor
aws s3 cp "frontend/enhanced-emergency-monitor.html" "s3://allsenses-mvp1-demo-website/enhanced-emergency-monitor.html" --content-type "text/html"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Enhanced emergency monitor uploaded!" -ForegroundColor Green
    
    # Upload jury demo as well
    Write-Host "📤 Uploading jury-specific demo..." -ForegroundColor Yellow
    aws s3 cp "jury-emergency-demo.html" "s3://allsenses-mvp1-demo-website/jury-emergency-demo.html" --content-type "text/html"
    
    Write-Host "🔄 Invalidating CloudFront cache..." -ForegroundColor Yellow
    
    # Invalidate CloudFront cache
    aws cloudfront create-invalidation --distribution-id "E3EB0YJG06PX1P" --paths "/*"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ CloudFront cache invalidated!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🏆 DEPLOYMENT COMPLETE!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🔗 UPDATED JURY DEMO URLS:" -ForegroundColor Cyan
        Write-Host "   https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor White
        Write-Host "   https://d4om8j6cvwtqd.cloudfront.net/jury-emergency-demo.html" -ForegroundColor White
        Write-Host ""
        Write-Host "✅ VICTIM NAME FIELDS NOW VISIBLE:" -ForegroundColor Yellow
        Write-Host "   - Victim's Name input field" -ForegroundColor White
        Write-Host "   - Emergency Contact Phone input field" -ForegroundColor White
        Write-Host "   - SMS messages include victim name and danger status" -ForegroundColor White
        Write-Host ""
        Write-Host "⏰ Cache invalidation may take 1-2 minutes to propagate" -ForegroundColor Gray
        Write-Host "🔄 Refresh the browser if you don't see changes immediately" -ForegroundColor Gray
    }
} else {
    Write-Host "Upload failed" -ForegroundColor Red
}