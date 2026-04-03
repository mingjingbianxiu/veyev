docker build -t veyev .
docker rm -f veyev 
docker run -d -v ~/.ssh:/root/.ssh  -p 2223:22 --gpus all --name veyev veyev   

