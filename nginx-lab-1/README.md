# Nginx Lab

Hands-on exercises with Nginx on Windows.

## Ports

| Port | Purpose |
|------|---------|
| 80 | Site 1 - static HTML |
| 8080 | Site 2 - location routing |
| 9000 | Reverse proxy (single backend) |
| 9001 | Load balancer - round-robin |
| 9002 | Load balancer - least_conn |
| 9003 | Caching proxy |
| 443 | HTTPS (self-signed) |

## Quick Start

```powershell
# Generate cert (if not present)
.\generate-cert.ps1

# Copy config to nginx and reload
.\copy-and-reload.ps1

# Start backends
python backends\backend.py 3001 backend-A
python backends\backend.py 3002 backend-B

# Test all endpoints
Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing
Invoke-WebRequest -Uri "http://localhost:8080/about" -UseBasicParsing
Invoke-WebRequest -Uri "http://localhost:9000" -UseBasicParsing
1..4 | ForEach-Object { (Invoke-WebRequest -Uri "http://localhost:9001" -UseBasicParsing).Content }
Invoke-WebRequest -Uri "https://localhost" -UseBasicParsing -SkipCertificateCheck
```

## Experiments

Run from the `experiments/` folder:

| Script | What it tests |
|--------|---------------|
| `01-backend-failure.ps1` | Stop one backend, observe 502 from load balancer |
| `02-least-conn.ps1` | Compare round-robin (9001) vs least_conn (9002) |
| `03-caching.ps1` | MISS → HIT caching behavior on port 9003 |
| `04-https-redirect.ps1` | HTTP → HTTPS 301 redirect |
| `05-proxy-headers.ps1` | Host, X-Real-IP, X-Forwarded-For headers |

## Log Experiments

Separate access logs per server block:

```powershell
$logs = "C:\Users\$env:USERNAME\AppData\Local\Microsoft\WinGet\Packages\nginxinc.nginx_Microsoft.Winget.Source_8wekyb3d8bbwe\nginx-1.31.6\logs"

Get-Content "$logs\access.log" -Tail 10          # site1 (port 80)
Get-Content "$logs\site2_access.log" -Tail 10    # site2 (port 8080)
Get-Content "$logs\proxy_access.log" -Tail 10    # reverse proxy (9000)
Get-Content "$logs\lb_rr_access.log" -Tail 10    # round-robin (9001)
Get-Content "$logs\lb_lc_access.log" -Tail 10    # least_conn (9002)
Get-Content "$logs\cache_access.log" -Tail 10    # caching proxy (9003)
Get-Content "$logs\error.log" -Tail 10           # errors
```

## Structure

```
nginx-lab/
├── nginx.conf                 # Active config (copy to nginx with copy-and-reload.ps1)
├── copy-and-reload.ps1        # Copy config + reload nginx
├── generate-cert.ps1          # Generate self-signed SSL cert locally
├── .gitignore                 # Excludes *.key from git
├── backends/
│   └── backend.py             # Python backend servers
├── certs/                     # Generated locally (not tracked)
├── experiments/
│   ├── 01-backend-failure.ps1
│   ├── 02-least-conn.ps1
│   ├── 03-caching.ps1
│   ├── 04-https-redirect.ps1
│   └── 05-proxy-headers.ps1
├── sites/
│   ├── site1/index.html       # Port 80
│   └── site2/                 # Port 8080
└── README.md
```

## Key Config Directives

```nginx
# Log levels: debug info notice warn error crit alert emerg
error_log logs/error.log info;

# Custom proxy log format
log_format proxy '$remote_addr [$time_local] "$request" '
                 'upstream: $upstream_addr '
                 'response_time: $upstream_response_time';

# Per-server access log
access_log logs/site2_access.log main;

# Load balancing methods
upstream backends_rr {                      # round-robin (default)
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}
upstream backends_lc {                      # least connections
    least_conn;
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}

# Proxy headers
proxy_set_header Host              $host;
proxy_set_header X-Real-IP         $remote_addr;
proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;

# Caching
proxy_cache_path /tmp/nginx_cache levels=1:2 keys_zone=my_cache:10m max_size=100m inactive=60m;
proxy_cache my_cache;
proxy_cache_valid 200 10m;
add_header X-Cache-Status $upstream_cache_status;

# HTTP → HTTPS redirect
return 301 https://$host$request_uri;
```
