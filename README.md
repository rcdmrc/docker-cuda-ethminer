# docker-cuda-ethminer

## Set up the host

These are instructions for setting up an Ubuntu host. For other distributions please visit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#install-guide

Add NVIDIA's APT repository for Docker packages:
```shell
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
curl -s -L https://nvidia.github.io/nvidia-container-runtime/experimental/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt -y update
```

Install NVIDIA's docker runtime:
```shell
sudo apt -y install nvidia-docker2
sudo systemctl restart docker
```

Run a quick test:
```shell
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```
You should see something like this:
```shell
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 460.39       Driver Version: 460.39       CUDA Version: 11.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  GeForce RTX 3070    Off  | 00000000:01:00.0  On |                  N/A |
|  0%   33C    P8    15W / 240W |    386MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+

```

## Using the container

```shell
ETH_WALLET="YOUR_WALLET_ADDRESS"
WORKERNAME="NAME_FOR_THIS_WORKER"
docker run -p 8080:8080 --rm --gpus all docker-ethminer --tstart 60 --tstop 90 \
                        --exit \
                        --cuda --HWMON 3 \
                        --pool stratum+tls://${ETH_WALLET}.${WORKERNAME}@us1.ethermine.org:5555
```

