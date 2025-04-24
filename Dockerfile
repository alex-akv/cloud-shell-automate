FROM gcr.io/cloudshell-images/cloudshell:latest

RUN apt-get update -y && apt-get install -y jq

COPY automate.sh /google/devshell/entrypoint.d/10-automate.sh
RUN chmod +x /google/devshell/entrypoint.d/10-automate.sh

