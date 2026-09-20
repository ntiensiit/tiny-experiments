import http.server
import sys
import json

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 3000
INSTANCE = sys.argv[2] if len(sys.argv) > 2 else "default"

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        resp = json.dumps({
            "instance": INSTANCE,
            "port": PORT,
            "path": self.path,
            "message": f"Hello from backend instance {INSTANCE} on port {PORT}"
        })
        self.wfile.write(resp.encode())

    def log_message(self, format, *args):
        pass  # suppress logs

print(f"Backend '{INSTANCE}' listening on port {PORT}")
http.server.HTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
