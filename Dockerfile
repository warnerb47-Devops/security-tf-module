FROM hashicorp/terraform:1.1.4
WORKDIR /root
COPY . .
WORKDIR /root/aws

# docker build -t security-tf-module .
# docker run -d -t --name security-tf-module --entrypoint /bin/sh security-tf-module
# docker exec -ti security-tf-module sh
