#!/bin/bash

set -e

function populate_client_env() {
	OPENAPI_BASE=${OPENAPI_BASE:-http://localhost:3001}

	echo 'Setting environment variables for OpenAPI_BASE:' ${OPENAPI_BASE}
	echo "OpenAPI.BASE = '${OPENAPI_BASE}';" >> src/client.ts
}

npx --yes openapi-typescript-codegen \
  --input ../server/openapi.yaml \
  --output ./src \
  --useOptions \
  --useUnionTypes

cp client.ts src/

populate_client_env

echo 'export { getToken } from "./client";' >> src/index.ts

rm -rf ../frontend/src/lib/services/gen-api
# important: gen-api folder must be in .gitignore since we don't want to commit it.
cp -R ./src ../frontend/src/lib/services/gen-api
