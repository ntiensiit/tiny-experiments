from concurrent import futures
import grpc
from fastapi import FastAPI
import ping_pb2, ping_pb2_grpc

class S(ping_pb2_grpc.PingServicer):
    def Ping(self, request, context):
        return ping_pb2.PingReply(src="C", msg="C: " + request.msg)

_gs = grpc.server(futures.ThreadPoolExecutor(max_workers=4))
ping_pb2_grpc.add_PingServicer_to_server(S(), _gs)
_gs.add_insecure_port("0.0.0.0:50053")
_gs.start()
app = FastAPI()

@app.get("/health")
def health():
    return {"ok": True, "svc": "C"}

@app.post("/call")
def call(b: dict):
    return {"src": "C", "msg": "C: " + b.get("msg", "hi")}
