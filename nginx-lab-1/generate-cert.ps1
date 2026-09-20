# Run this script to generate a self-signed SSL cert locally.
# The .key file is excluded from git via .gitignore.

$certDir = "$PSScriptRoot\certs"

if (!(Test-Path $certDir)) {
    New-Item -ItemType Directory -Force -Path $certDir | Out-Null
}

& "C:\Program Files\Git\mingw64\bin\openssl.exe" req -x509 -nodes -days 365 `
    -newkey rsa:2048 `
    -keyout "$certDir\localhost.key" `
    -out "$certDir\localhost.crt" `
    -subj "/CN=localhost"

Write-Host "Cert generated in $certDir"
Write-Host "  localhost.crt"
Write-Host "  localhost.key (not tracked by git)"
