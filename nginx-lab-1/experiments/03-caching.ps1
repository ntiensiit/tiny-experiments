# Experiment: Caching proxy on port 9003.
#
# First request:  X-Cache-Status: MISS  (fetched from backend)
# Second request: X-Cache-Status: HIT   (served from cache, backend not hit)
#
# Cache TTL is 10 minutes. After that, next request is a MISS again.
#
# Watch the backend output - it should only print on MISS requests.

Write-Host "=== Caching Experiment ==="
Write-Host ""
Write-Host "Request 1 (MISS):"
$r1 = Invoke-WebRequest -Uri "http://localhost:9003" -UseBasicParsing -Raw
Write-Host "  X-Cache-Status: $($r1.Headers['X-Cache-Status'])"
Write-Host ""
Write-Host "Request 2 (HIT - served from cache):"
$r2 = Invoke-WebRequest -Uri "http://localhost:9003" -UseBasicParsing -Raw
Write-Host "  X-Cache-Status: $($r2.Headers['X-Cache-Status'])"
Write-Host ""
Write-Host "Check backend terminal - only one print should appear."
