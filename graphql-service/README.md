# GraphQL service

Python **3.12**, `uv` venv, `requirements.txt` only (no toml). HTTP **8004**. `POST /graphql` (GraphQL over HTTP).

## 1. Venv + deps

```powershell
cd graphql-service
uv venv --python 3.12
.\.venv\Scripts\Activate.ps1
uv pip install -r requirements.txt
```

## 2. Run

```powershell
uvicorn main:app --host 0.0.0.0 --port 8004
```

## 3. Test

```powershell
curl.exe http://127.0.0.1:8004/health
curl.exe -X POST http://127.0.0.1:8004/graphql -H "Content-Type: application/json" --data-raw '{"query":"{ hello echo(msg:\"hi\") }"}'
curl.exe -X POST http://127.0.0.1:8004/graphql -H "Content-Type: application/json" --data-raw '{"query":"mutation { ping(msg:\"hi\") }"}'
```
