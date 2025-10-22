# Simple Local Server for Jury Demo
Write-Host "🏆 Starting Local Server for Jury Demo..." -ForegroundColor Green

# Start a simple Python HTTP server
Write-Host "🚀 Starting server on port 8080..." -ForegroundColor Yellow
Write-Host ""
Write-Host "🔗 LOCAL JURY DEMO URLS (with victim name fields):" -ForegroundColor Cyan
Write-Host "   http://localhost:8080/frontend/enhanced-emergency-monitor.html" -ForegroundColor White
Write-Host "   http://localhost:8080/jury-emergency-demo.html" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Note: HTTP version - microphone may not work in some browsers" -ForegroundColor Yellow
Write-Host "✅ But you can see the victim name configuration fields!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Look for the 'Victim & Contact Configuration' section" -ForegroundColor Yellow
Write-Host "   - Victim's Name input field" -ForegroundColor White
Write-Host "   - Emergency Contact Phone input field" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host ""

# Start Python HTTP server
python -m http.server 8080