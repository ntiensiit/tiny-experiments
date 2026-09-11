from fastapi import FastAPI
from graphql import graphql_sync, build_schema

schema = build_schema("""
type Query { hello(name: String = "world"): String! echo(msg: String!): String! }
type Mutation { ping(msg: String = "hi"): String! }
""")
schema.query_type.fields["hello"].resolve = lambda o, i, name="world": "Hello " + name
schema.query_type.fields["echo"].resolve = lambda o, i, msg: msg
schema.mutation_type.fields["ping"].resolve = lambda o, i, msg="hi": "pong: " + msg

app = FastAPI()

@app.get("/health")
def health():
    return {"ok": True, "svc": "graphql"}

@app.post("/graphql")
def gql(b: dict):
    r = graphql_sync(schema, b.get("query", ""), variable_values=b.get("variables"))
    out = {}
    if r.data is not None: out["data"] = r.data
    if r.errors: out["errors"] = [e.formatted for e in r.errors]
    return out
