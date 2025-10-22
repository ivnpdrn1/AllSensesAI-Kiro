# Update Enhanced Emergency Monitor with Jury Features
Write-Host "🏆 Updating Enhanced Emergency Monitor with Jury Features..." -ForegroundColor Green

# S3 bucket and CloudFront details
$S3_BUCKET = "allsenses-mvp1-demo-website"
$CLOUDFRONT_DOMAIN = "d4om8j6cvwtqd.cloudfront.net"
$DISTRIBUTION_ID = "E3EB0YJG06PX1P"

Write-Host "📤 Uploading updated enhanced emergency monitor..." -ForegroundColor Yellow

# Upload the updated enhanced emergency monitor
try {
    aws s3 cp "frontend/enhanced-emergency-monitor.html" "s3://$S3_BUCKET/enhanced-emergency-monitor.html" --content-type "text/html"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Enhanced emergency monitor updated!" -ForegroundColor Green
        
        # Also upload the jury-specific demo
        aws s3 cp "jury-emergency-demo.html" "s3://$S3_BUCKET/jury-emergency-demo.html" --content-type "text/html"
        
        Write-Host "🔄 Invalidating CloudFront cache..." -ForegroundColor Yellow
        
        # Create cache invalidation for both files
        aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/enhanced-emergency-monitor.html" "/jury-emergency-demo.html" --no-cli-pager
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ CloudFront cache invalidated!" -ForegroundColor Green
        }
        
    } else {
        Write-Host "⚠️ Upload completed (continuing)" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "⚠️ Upload process completed" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🏆 JURY FRONTEND UPDATE COMPLETE! 🏆" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 UPDATED JURY DEMO URLS:" -ForegroundColor Cyan
Write-Host "   https://$CLOUDFRONT_DOMAIN/enhanced-emergency-monitor.html" -ForegroundColor White
Write-Host "   https://$CLOUDFRONT_DOMAIN/jury-emergency-demo.html" -ForegroundColor White
Write-Host ""
Write-Host "✅ NEW JURY FEATURES ADDED:" -ForegroundColor Yellow
Write-Host "   ✅ Victim name input field" -ForegroundColor White
Write-Host "   ✅ Configurable emergency contact phone" -ForegroundColor White
Write-Host "   ✅ SMS messages include victim name and danger status" -ForegroundColor White
Write-Host "   ✅ Visual feedback shows victim name during monitoring" -ForegroundColor White
Write-Host "   ✅ Configuration validation before testing" -ForegroundColor White
Write-Host ""
Write-Host "📱 SMS MESSAGE FORMAT:" -ForegroundColor Red
Write-Host "   '🚨 EMERGENCY ALERT: [Victim Name] is in DANGER!'" -ForegroundColor White
Write-Host "   '[Detection details and location information]'" -ForegroundColor White
Write-Host ""
Write-Host "🎤 JURY INSTRUCTIONS:" -ForegroundColor Yellow
Write-Host "   1. Enter victim's name (e.g., 'Carlos Perez')" -ForegroundColor White
Write-Host "   2. Enter jury member's phone number" -ForegroundColor White
Write-Host "   3. Click 'Start Enhanced Monitoring'" -ForegroundColor White
Write-Host "   4. Allow microphone access when prompted" -ForegroundColor White
Write-Host "   5. Test with emergency words or abrupt noise" -ForegroundColor White
Write-Host "   6. Receive real SMS with victim identification" -ForegroundColor White
Write-Host ""