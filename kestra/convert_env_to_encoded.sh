while IFS='=' read -r key value; do
    echo "SECRET_$key=$(echo -n "$value" | base64)";
done < .env > .env_encoded
echo "SECRET_GCP_SERVICE_ACCOUNT=$(cat ~/.pki/gcp/creds.json | base64 -w 0)" >> .env_encoded