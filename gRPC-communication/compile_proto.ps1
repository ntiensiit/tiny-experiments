$root = $PSScriptRoot
$proto = Join-Path $root "proto"
foreach ($svc in @("service_a", "service_b", "service_c")) {
  $out = Join-Path $root $svc
  python -m grpc_tools.protoc -I $proto --python_out=$out --grpc_python_out=$out (Join-Path $proto "ping.proto")
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
Write-Host "wrote ping_pb2.py / ping_pb2_grpc.py into service_a, service_b, service_c"
