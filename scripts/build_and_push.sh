#!/bin/bash
set -eo pipefail

aws --profile strato ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 588896276507.dkr.ecr.us-west-2.amazonaws.com

pushd "$(dirname "$0")/.." > /dev/null

docker build -t 588896276507.dkr.ecr.us-west-2.amazonaws.com/potree-converter .
docker push 588896276507.dkr.ecr.us-west-2.amazonaws.com/potree-converter

popd > /dev/null