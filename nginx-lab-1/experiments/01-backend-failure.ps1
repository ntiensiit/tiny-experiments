# Experiment: Stop one backend and observe load-balancer behavior.
#
# 1. Start both backends:
#    python backends\backend.py 3001 backend-A
#    python backends\backend.py 3002 backend-B
#
# 2. Hit round-robin (port 9001) - both respond:
#    1..6 | ForEach-Object { (Invoke-WebRequest -Uri "http://localhost:9001" -UseBasicParsing).Content }
#
# 3. Stop backend-A (kill the python process on port 3001)
#
# 4. Hit round-robin again - every other request fails (502 Bad Gateway):
#    1..6 | ForEach-Object {
#        try {
#            $r = Invoke-WebRequest -Uri "http://localhost:9001" -UseBasicParsing -ErrorAction Stop
#            "OK: $($r.Content.Substring(0,60))"
#        } catch {
#            "FAIL: $($_.Exception.Message)"
#        }
#    }
#
# 5. Check error log for upstream connection errors:
#    Get-Content logs\error.log -Tail 10

Write-Host "=== Backend Failure Experiment ==="
Write-Host ""
Write-Host "Step 1: Ensure both backends are running on 3001 and 3002"
Write-Host "Step 2: Test round-robin: 1..6 | ForEach-Object { (Invoke-WebRequest -Uri 'http://localhost:9001' -UseBasicParsing).Content }"
Write-Host "Step 3: Stop backend-A (kill python on port 3001)"
Write-Host "Step 4: Test again - observe 502 errors on failed upstream"
Write-Host "Step 5: Check error log: Get-Content logs\error.log -Tail 10"
