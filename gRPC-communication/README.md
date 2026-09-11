# gRPC + FastAPI (A -> B -> C)

Three isolated services. Shared proto: `proto/ping.proto`. Python **3.12**, `uv` venv, `requirements.txt` only (no toml).

| service | HTTP | gRPC |
|---|---|---|
| service_a | 8001 | 50051 |
| service_b | 8002 | 50052 |
| service_c | 8003 | 50053 |

Flow: `POST /call` on A -> B `Ping` -> C `Ping`. Reply msg is `C: B: <input>`.

## 1. Venv + deps (each service)

```powershell
cd gRPC-communication\service_a
uv venv --python 3.12
.\.venv\Scripts\Activate.ps1
uv pip install -r requirements.txt
```

Repeat for `service_b` and `service_c`.

## 2. Compile proto

From `gRPC-communication/`, with a venv that has `grpcio-tools` active:

```powershell
.\compile_proto.ps1
```

Equivalent:

```text
python -m grpc_tools.protoc -I proto --python_out=DIR --grpc_python_out=DIR proto/ping.proto
```

`DIR` = `service_a`, then `service_b`, then `service_c`. Writes `ping_pb2.py` and `ping_pb2_grpc.py` into each service (run uvicorn from that directory so imports work).

## 3. Run (three terminals)

```powershell
cd gRPC-communication\service_c
.\.venv\Scripts\Activate.ps1
uvicorn main:app --host 0.0.0.0 --port 8003
```

```powershell
cd gRPC-communication\service_b
.\.venv\Scripts\Activate.ps1
uvicorn main:app --host 0.0.0.0 --port 8002
```

```powershell
cd gRPC-communication\service_a
.\.venv\Scripts\Activate.ps1
uvicorn main:app --host 0.0.0.0 --port 8001
```

gRPC servers start in-process with FastAPI (ports 50053 / 50052 / 50051).

## 4. Test

```powershell
curl.exe http://127.0.0.1:8001/health
curl.exe http://127.0.0.1:8002/health
curl.exe http://127.0.0.1:8003/health
curl.exe -X POST http://127.0.0.1:8001/call -H "Content-Type: application/json" --data-raw '{"msg":"hi"}'
```

Expect `{"src":"B","msg":"C: B: hi"}`.
