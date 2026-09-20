# Experiment: HTTP → HTTPS redirect.
#
# 1. Uncomment the redirect server block in nginx.conf (port 80):
#      server {
#          listen 80;
#          server_name localhost;
#          return 301 https://$host$request_uri;
#      }
#
# 2. Comment out or remove the Site 1 server block on port 80.
#
# 3. Reload nginx.
#
# 4. Test - HTTP should return 301 redirect to HTTPS:
#    $r = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
#    $r.StatusCode           # 301
#    $r.Headers.Location     # https://localhost/
#
# 5. Follow the redirect:
#    Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing -MaximumRedirection 5
#    # Should return 200 from HTTPS

Write-Host "=== HTTP → HTTPS Redirect ==="
Write-Host ""
Write-Host "1. Edit nginx.conf: uncomment redirect block, comment Site 1 block"
Write-Host "2. Run: .\copy-and-reload.ps1"
Write-Host "3. Test:"
Write-Host '   $r = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue'
Write-Host '   $r.StatusCode        # should be 301'
Write-Host '   $r.Headers.Location  # should be https://localhost/'
