docker build -f Dockerfile.mac -t veyev.mac .
docker rm -f veyev.mac 
docker run -d -v ~/.ssh:/root/.ssh  -p 2222:22 --name veyev.mac veyev.mac

