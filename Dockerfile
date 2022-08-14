FROM hashicorp/terraform:1.1.4
WORKDIR /root
COPY . .
WORKDIR /root/aws

# docker build -t pipeline-tf-module .
# docker run -d -t --name pipeline-tf-module --entrypoint /bin/sh pipeline-tf-module
# docker exec -ti pipeline-tf-module sh
