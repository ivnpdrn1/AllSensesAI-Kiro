# Deploy Updated Frontend Files NOW

Write-Host "DEPLOYING UPDATED FRONTEND FILES" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

$bucketName = "allsenses-mvp1-demo-website"
$cloudFrontDistributionId = "E3EB0YJG06PX1P"

Write-Host "S3 Bucket: $bucketName" -ForegroundColor Cyan
Write-Host "CloudFront: $cloudFrontDistributionId" -ForegroundColor Cyan
Write-Host "New Lambda URL: https://ufwarjq6fvrk.lambda-url.us-east-1.on.aws/" -ForegroundColor Green

Write-Host "`nRUN THESE COMMANDS:" -ForegroundColor Red

Write-Host "`n1. Upload Enhanced Emergency Monitor:" -ForegroundColor Yellow
Write-Host "aws s3 cp frontend/enhanced-emergency-monitor.html s3://$bucketName/enhanced-emergency-monitor.html --content-type text/html" -ForegroundColor White

Write-Host "`n2. Upload Jury Demo:" -ForegroundColor Yellow
Write-Host "aws s3 cp hackathon-jury-demo.html s3://$bucketName/hackathon-jury-demo.html --content-type text/html" -ForegroundColor White

Write-Host "`n3. Upload Other Files:" -ForegroundColor Yellow
Write-Host "aws s3 cp allsense-live-incident-panel.html s3://$bucketName/allsense-live-incident-panel.html --content-type text/html" -ForegroundColor White
Write-Host "aws s3 cp frontend/mvp1-complete-demo.html s3://$bucketName/mvp1-complete-demo.html --content-type text/html" -ForegroundColor White

Write-Host "`n4. Invalidate CloudFront Cache:" -ForegroundColor Yellow
Write-Host "aws cloudfront create-invalidation --distribution-id $cloudFrontDistributionId --paths `"/*`"" -ForegroundColor White

Write-Host "`n5. Test URLs after deployment:" -ForegroundColor Green
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Cyan
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/hackathon-jury-demo.html" -ForegroundColor Cyan

Write-Host "`nAfter deployment, the 'Failed to send notification' error will be fixed!" -ForegroundColor Green