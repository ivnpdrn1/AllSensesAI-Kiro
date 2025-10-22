# Start AllSenses HTTPS Demo Server
# Enables microphone access for enhanced emergency detection

Write-Host "🔒 AllSenses HTTPS Demo Server" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check Python
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Please install Python 3.x" -ForegroundColor Red
    Write-Host "   Download from: https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# Check OpenSSL
try {
    $opensslVersion = openssl version 2>&1
    Write-Host "✅ OpenSSL: $opensslVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️  OpenSSL not found - will fallback to HTTP" -ForegroundColor Yellow
    Write-Host "   For full HTTPS support, install OpenSSL:" -ForegroundColor Yellow
    Write-Host "   https://slproweb.com/products/Win32OpenSSL.html" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🚀 Starting HTTPS server..." -ForegroundColor Green
Write-Host ""
Write-Host "📱 Demo URLs will be:" -ForegroundColor Cyan
Write-Host "   Enhanced Monitor: https://localhost:8443/enhanced-emergency-monitor.html" -ForegroundColor White
Write-Host "   Jury Demo:        https://localhost:8443/hackathon-jury-demo.html" -ForegroundColor White
Write-Host "   Complete Demo:    https://localhost:8443/mvp1-complete-demo.html" -ForegroundColor White
Write-Host ""
Write-Host "🎤 Features enabled with HTTPS:" -ForegroundColor Green
Write-Host "   ✅ Microphone access for emergency word detection" -ForegroundColor Green
Write-Host "   ✅ Real-time audio analysis for abrupt noise detection" -ForegroundColor Green
Write-Host "   ✅ Visual listening indicator" -ForegroundColor Green
Write-Host "   ✅ Real SMS notifications via AWS SNS" -ForegroundColor Green
Write-Host "   ✅ Full-screen emergency alerts" -ForegroundColor Green
Write-Host ""
Write-Host "⚠️  Browser Security:" -ForegroundColor Yellow
Write-Host "   1. Browser will show 'Not Secure' warning" -ForegroundColor Yellow
Write-Host "   2. Click 'Advanced' → 'Proceed to localhost (unsafe)'" -ForegroundColor Yellow
Write-Host "   3. Allow microphone access when prompted" -ForegroundColor Yellow
Write-Host ""
Write-Host "🛑 Press Ctrl+C to stop the server" -ForegroundColor Red
Write-Host ""

# Start the server
python simple-https-server.py