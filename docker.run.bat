docker build -t veyev .
docker rm -f veyev 
 docker run -d -v "/${HOME}/.ssh:/root/.ssh" -p 2222:22 --gpus all --privileged --name veyev veyev
