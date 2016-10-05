gcloud compute \
	--project $PERSONAL_CLOUD_PROJECT \
	instances create $PERSONAL_SERVER_NAME \
	--zone $PERSONAL_SERVER_ZONE \
	--machine-type "f1-micro" \
	--subnet "default" \
	--private-network-ip "10.128.0.3" \
	--address $PERSONAL_SERVER_IP \
	--maintenance-policy "MIGRATE" \
   	--tags "http-server","https-server" \
   	--image "/debian-cloud/debian-8-jessie-v20160923" \  # This needs to be constantly updated
   	--boot-disk-size "20" \
   	--boot-disk-type "pd-standard" \
   	--boot-disk-device-name $PERSONAL_SERVER_NAME \
	--scopes default="https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly"


gcloud compute \
	--project $PERSONAL_CLOUD_PROJECT \
	firewall-rules create "default-allow-http" \
	--allow tcp:80 \
	--network "default" \
	--source-ranges "0.0.0.0/0" \
	--target-tags "http-server"

gcloud compute \
	--project $PERSONAL_CLOUD_PROJECT \
	firewall-rules create "default-allow-https" \
	--allow tcp:443 \
	--network "default" \
	--source-ranges "0.0.0.0/0" \
	--target-tags "https-server"

personal-server-ssh

fab-env

fab setup_personal_server
