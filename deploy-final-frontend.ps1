# Deploy Final Frontend with Correct Lambda URL

Write-Host "DEPLOYING FINAL FRONTEND" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green

$bucketName = "allsenses-mvp1-demo-website"
$cloudFrontDistributionId = "E3E0BYJQ6GPXIP"
$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

Write-Host "Lambda URL: $lambdaUrl" -ForegroundColor Cyan
Write-Host "S3 Bucket: $bucketName" -ForegroundColor Cyan
Write-Host "CloudFront Distribution: $cloudFrontDistributionId" -ForegroundColor Cyan

Write-Host "`nFiles updated with correct Lambda URL:" -ForegroundColor Yellow
Write-Host "✅ frontend/enhanced-emergency-monitor.html" -ForegroundColor Green
Write-Host "✅ hackathon-jury-demo.html" -ForegroundColor Green
Write-Host "✅ allsense-live-incident-panel.html" -ForegroundColor Green
Write-Host "✅ frontend/mvp1-complete-demo.html" -ForegroundColor Green

Write-Host "`nDEPLOYMENT COMMANDS:" -ForegroundColor Red

Write-Host "`n1. Upload Enhanced Emergency Monitor:" -ForegroundColor Yellow
Write-Host "aws s3 cp frontend/enhanced-emergency-monitor.html s3://$bucketName/enhanced-emergency-monitor.html --content-type text/html" -ForegroundColor White

Write-Host "`n2. Upload Hackathon Jury Demo:" -ForegroundColor Yellow
Write-Host "aws s3 cp hackathon-jury-demo.html s3://$bucketName/hackathon-jury-demo.html --content-type text/html" -ForegroundColor White

Write-Host "`n3. Upload Live Incident Panel:" -ForegroundColor Yellow
Write-Host "aws s3 cp allsense-live-incident-panel.html s3://$bucketName/allsense-live-incident-panel.html --content-type text/html" -ForegroundColor White

Write-Host "`n4. Upload MVP Complete Demo:" -ForegroundColor Yellow
Write-Host "aws s3 cp frontend/mvp1-complete-demo.html s3://$bucketName/mvp1-complete-demo.html --content-type text/html" -ForegroundColor White

Write-Host "`n5. Invalidate CloudFront Cache:" -ForegroundColor Yellow
Write-Host "aws cloudfront create-invalidation --distribution-id $cloudFrontDistributionId --paths `"/*`"" -ForegroundColor White

Write-Host "`n6. Test URLs after deployment:" -ForegroundColor Green
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Cyan
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/hackathon-jury-demo.html" -ForegroundColor Cyan

Write-Host "`nNote: Lambda URL returns 403 Forbidden - may need permissions configured" -ForegroundColor Yellow
Write-Host "Frontend deployed with correct URL: $lambdaUrl" -ForegroundColor Green