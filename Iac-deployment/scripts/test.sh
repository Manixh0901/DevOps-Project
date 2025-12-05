#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../terraform"

ALB_DNS=$(terraform output -raw alb_dns_name)

echo "Testing / on $ALB_DNS"
curl "http://$ALB_DNS/"

echo
echo "Testing /health on $ALB_DNS"
curl "http://$ALB_DNS/health"
echo
