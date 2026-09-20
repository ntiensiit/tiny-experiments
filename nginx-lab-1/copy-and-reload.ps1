# Copy nginx.conf to nginx and reload. Run from the lab folder.

$nginxRoot = "C:\Users\$env:USERNAME\AppData\Local\Microsoft\WinGet\Packages\nginxinc.nginx_Microsoft.Winget.Source_8wekyb3d8bbwe\nginx-1.31.6"
$src  = "$PSScriptRoot\nginx.conf"
$dest = "$nginxRoot\conf\nginx.conf"

Copy-Item $src $dest -Force
Write-Host "Copied nginx.conf"

Push-Location $nginxRoot
& "$nginxRoot\nginx.exe" -t
if ($LASTEXITCODE -eq 0) {
    & "$nginxRoot\nginx.exe" -s reload
    Write-Host "Nginx reloaded"
} else {
    Write-Host "Config test FAILED"
}
Pop-Location
