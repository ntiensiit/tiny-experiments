from concurrent import futures
import grpc
from fastapi import FastAPI
import ping_pb2, ping_pb2_grpc

class S(ping_pb2_grpc.PingServicer):
    def Ping(self, request, context):
        return ping_pb2.PingReply(src="A", msg=request.msg)

_gs = grpc.server(futures.ThreadPoolExecutor(max_workers=4))
ping_pb2_grpc.add_PingServicer_to_server(S(), _gs)
_gs.add_insecure_port("0.0.0.0:50051")
_gs.start()
app = FastAPI()

@app.get("/health")
def health():
    return {"ok": True, "svc": "A"}

@app.post("/call")
def call(b: dict):
    # A HTTP -> B gRPC (B then C)
    r = ping_pb2_grpc.PingStub(grpc.insecure_channel("127.0.0.1:50052")).Ping(ping_pb2.PingRequest(msg=b.get("msg", "hi")))
    return {"src": r.src, "msg": r.msg}
