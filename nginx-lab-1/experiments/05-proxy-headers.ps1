# Experiment: Proxy headers.
#
# The Python backend logs headers it receives. To see them, add
# a print(self.headers) line in backend.py's do_GET method.
#
# Or use curl -v to see what nginx sends:
#   curl -v http://localhost:9000/
#
# Key headers set by nginx:
#   Host:              the original host from the client
#   X-Real-IP:         client's real IP
#   X-Forwarded-For:   chain of IPs (client -> proxy -> ...)
#   X-Forwarded-Proto: original scheme (http or https)
#
# Without these headers, the backend only sees 127.0.0.1.

Write-Host "=== Proxy Header Experiment ==="
Write-Host ""
Write-Host "Test with curl to see headers:"
Write-Host '  curl -v http://localhost:9000/'
Write-Host ""
Write-Host "Backend receives:"
Write-Host "  Host: localhost"
Write-Host "  X-Real-IP: 127.0.0.1"
Write-Host "  X-Forwarded-For: 127.0.0.1"
Write-Host "  X-Forwarded-Proto: http"
