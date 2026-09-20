# Experiment: Compare round-robin vs least_conn load balancing.
#
# Round-robin (port 9001): distributes requests sequentially A, B, A, B...
# least_conn (port 9002):  sends to the backend with fewest active connections
#
# With fast equal backends they behave similarly.
# To see the difference, add artificial delay to one backend:
#   Edit backend.py line: time.sleep(0.5) in backend-A only
#
# Then watch least_conn favor the faster backend.

Write-Host "=== Round-Robin vs least_conn ==="
Write-Host ""
Write-Host "Round-robin (port 9001):"
Write-Host "  1..6 | ForEach-Object { (Invoke-WebRequest -Uri 'http://localhost:9001' -UseBasicParsing).Content }"
Write-Host ""
Write-Host "least_conn (port 9002):"
Write-Host "  1..6 | ForEach-Object { (Invoke-WebRequest -Uri 'http://localhost:9002' -UseBasicParsing).Content }"
Write-Host ""
Write-Host "With equal backends both behave like round-robin."
Write-Host "Add delay to one backend to see least_conn diverge."
