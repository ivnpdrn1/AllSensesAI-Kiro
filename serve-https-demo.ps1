# Serve AllSenses Demo with HTTPS for Microphone Access
# This script creates a local HTTPS server for the enhanced emergency monitor

Write-Host "🔒 Setting up HTTPS server for AllSenses Demo..." -ForegroundColor Cyan

# Check if Python is available
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Please install Python 3.x" -ForegroundColor Red
    exit 1
}

# Create simple HTTPS server script
$httpsServerScript = @'
import http.server
import ssl
import os
from pathlib import Path

# Change to frontend directory
frontend_dir = Path(__file__).parent / "frontend"
if frontend_dir.exists():
    os.chdir(frontend_dir)
    print(f"✅ Serving from: {frontend_dir.absolute()}")
else:
    print("❌ Frontend directory not found")
    exit(1)

# Create HTTPS server
server_address = ('localhost', 8443)
httpd = http.server.HTTPServer(server_address, http.server.SimpleHTTPRequestHandler)

# Create SSL context with self-signed certificate
context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
context.check_hostname = False
context.verify_mode = ssl.CERT_NONE

# Generate self-signed certificate for localhost
import tempfile
import subprocess

print("🔐 Generating self-signed certificate for localhost...")
with tempfile.TemporaryDirectory() as temp_dir:
    cert_file = os.path.join(temp_dir, "cert.pem")
    key_file = os.path.join(temp_dir, "key.pem")
    
    # Generate certificate
    subprocess.run([
        "openssl", "req", "-x509", "-newkey", "rsa:4096", "-keyout", key_file,
        "-out", cert_file, "-days", "365", "-nodes", "-subj", 
        "/C=US/ST=State/L=City/O=AllSenses/CN=localhost"
    ], check=True, capture_output=True)
    
    # Load certificate
    context.load_cert_chain(cert_file, key_file)

httpd.socket = context.wrap_socket(httpd.socket, server_side=True)

print("🚀 AllSenses HTTPS Demo Server Starting...")
print("📱 Access demo at: https://localhost:8443/enhanced-emergency-monitor.html")
print("🎤 Microphone access will work with HTTPS!")
print("⚠️  Accept the self-signed certificate warning in your browser")
print("🛑 Press Ctrl+C to stop the server")

try:
    httpd.serve_forever()
except KeyboardInterrupt:
    print("\n🛑 Server stopped")
    httpd.shutdown()
'@

# Save Python HTTPS server script
$httpsServerScript | Out-File -FilePath "https-server.py" -Encoding UTF8

# Check if OpenSSL is available
try {
    $opensslVersion = openssl version 2>&1
    Write-Host "✅ OpenSSL found: $opensslVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️  OpenSSL not found. Installing via Chocolatey..." -ForegroundColor Yellow
    
    # Try to install OpenSSL via Chocolatey
    try {
        choco install openssl -y
        Write-Host "✅ OpenSSL installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to install OpenSSL. Please install manually:" -ForegroundColor Red
        Write-Host "   Download from: https://slproweb.com/products/Win32OpenSSL.html" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "🔒 Starting HTTPS server..." -ForegroundColor Green
Write-Host "📱 Demo will be available at: https://localhost:8443/enhanced-emergency-monitor.html" -ForegroundColor Cyan
Write-Host "🎤 Microphone access enabled with HTTPS!" -ForegroundColor Green
Write-Host "⚠️  You'll need to accept the self-signed certificate warning" -ForegroundColor Yellow

# Start the HTTPS server
python https-server.py