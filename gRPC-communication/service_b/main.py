from concurrent import futures
import grpc
from fastapi import FastAPI
import ping_pb2, ping_pb2_grpc

class S(ping_pb2_grpc.PingServicer):
    def Ping(self, request, context):
        # B prefixes then C prefixes -> "C: B: <msg>"
        r = ping_pb2_grpc.PingStub(grpc.insecure_channel("127.0.0.1:50053")).Ping(ping_pb2.PingRequest(msg="B: " + request.msg))
        return ping_pb2.PingReply(src="B", msg=r.msg)

_gs = grpc.server(futures.ThreadPoolExecutor(max_workers=4))
ping_pb2_grpc.add_PingServicer_to_server(S(), _gs)
_gs.add_insecure_port("0.0.0.0:50052")
_gs.start()
app = FastAPI()

@app.get("/health")
def health():
    return {"ok": True, "svc": "B"}

@app.post("/call")
def call(b: dict):
    r = ping_pb2_grpc.PingStub(grpc.insecure_channel("127.0.0.1:50053")).Ping(ping_pb2.PingRequest(msg="B: " + b.get("msg", "hi")))
    return {"src": "B", "msg": r.msg}
