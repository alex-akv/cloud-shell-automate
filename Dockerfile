FROM gcr.io/cloudshell-images/cloudshell:latest

RUN apt-get update -y && apt-get install -y unzip curl && \
    curl -o terraform.zip https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_linux_amd64.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform.zip

COPY run-once.sh /google/devshell/entrypoint.d/10-run-once.sh
RUN chmod +x /google/devshell/entrypoint.d/10-run-once.sh

ENTRYPOINT [ "/google/devshell/entrypoint.d/10-run-once.sh" ]