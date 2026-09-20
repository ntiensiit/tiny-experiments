# Nginx Lab

Hands-on exercises with Nginx on Windows.

## Ports

| Port | Service |
|------|---------|
| 80 | Site 1 - static HTML |
| 8080 | Site 2 - location routing |
| 9000 | Reverse proxy → backend-A |
| 9001 | Load balancer → backend-A + backend-B |
| 443 | HTTPS (self-signed cert) |

## Start Services

```bash
# Nginx
cd C:\Users\usr0\AppData\Local\Microsoft\WinGet\Packages\nginxinc.nginx_Microsoft.Winget.Source_8wekyb3d8bbwe\nginx-1.31.6
.\nginx.exe

# Backends
python backends\backend.py 3001 backend-A
python backends\backend.py 3002 backend-B
```

## Test

```powershell
Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing
Invoke-WebRequest -Uri "http://localhost:8080/about" -UseBasicParsing
Invoke-WebRequest -Uri "http://localhost:9001" -UseBasicParsing
Invoke-WebRequest -Uri "https://localhost" -UseBasicParsing -SkipCertificateCheck
```

## Config & Reload

```bash
# always from nginx directory
.\nginx.exe -t        # test config
.\nginx.exe -s reload  # reload without downtime
.\nginx.exe -s stop    # stop
```

## Structure

```
nginx-lab/
├── backends/backend.py    # Python backend servers
├── certs/                 # Self-signed SSL cert + key
├── sites/
│   ├── site1/index.html   # Port 80
│   └── site2/             # Port 8080
└── README.md
```
