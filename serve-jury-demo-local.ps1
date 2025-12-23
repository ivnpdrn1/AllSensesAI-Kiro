# Serve Jury Demo Locally with HTTPS
Write-Host "🏆 Starting Local HTTPS Server for Jury Demo..." -ForegroundColor Green

# Create a simple Python HTTPS server
$pythonScript = @"
import http.server
import ssl
import socketserver
import os
from pathlib import Path

# Change to the directory containing the files
os.chdir('.')

# Create a simple HTTP handler
class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()

# Set up the server
PORT = 8443
Handler = MyHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    # Create SSL context with self-signed certificate
    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    context.check_hostname = False
    context.verify_mode = ssl.CERT_NONE
    
    # Generate self-signed certificate
    import tempfile
    import subprocess
    
    try:
        # Try to create a self-signed certificate
        subprocess.run(['openssl', 'req', '-x509', '-newkey', 'rsa:4096', '-keyout', 'key.pem', '-out', 'cert.pem', '-days', '1', '-nodes', '-subj', '/CN=localhost'], check=True, capture_output=True)
        context.load_cert_chain('cert.pem', 'key.pem')
    except:
        # If OpenSSL is not available, use a simpler approach
        print("OpenSSL not available, using HTTP instead...")
        httpd.serve_forever()
    
    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
    
    print(f"🔒 HTTPS Server running at: https://localhost:{PORT}")
    print(f"🏆 Jury Demo URL: https://localhost:{PORT}/frontend/enhanced-emergency-monitor.html")
    print(f"🛡️ Alternative URL: https://localhost:{PORT}/jury-emergency-demo.html")
    print("")
    print("📋 Instructions:")
    print("1. Accept the security warning in your browser")
    print("2. Look for the 'Victim & Contact Configuration' section")
    print("3. Enter victim name and jury phone number")
    print("4. Test the emergency detection features")
    print("")
    print("Press Ctrl+C to stop the server")
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
"@

# Write the Python script
$pythonScript | Out-File -FilePath "jury_https_server.py" -Encoding UTF8

Write-Host "🚀 Starting HTTPS server on port 8443..." -ForegroundColor Yellow
Write-Host ""
Write-Host "🔗 JURY DEMO URLS (with victim name fields):" -ForegroundColor Cyan
Write-Host "   https://localhost:8443/frontend/enhanced-emergency-monitor.html" -ForegroundColor White
Write-Host "   https://localhost:8443/jury-emergency-demo.html" -ForegroundColor White
Write-Host ""
Write-Host "📋 Browser Instructions:" -ForegroundColor Yellow
Write-Host "   1. Click 'Advanced' when you see security warning" -ForegroundColor White
Write-Host "   2. Click 'Proceed to localhost (unsafe)'" -ForegroundColor White
Write-Host "   3. Look for 'Victim & Contact Configuration' section" -ForegroundColor White
Write-Host "   4. Enter victim name and jury phone number" -ForegroundColor White
Write-Host ""
Write-Host "🎤 The victim name fields are now visible in the local version!" -ForegroundColor Green
Write-Host ""

# Start the Python server
python jury_https_server.py