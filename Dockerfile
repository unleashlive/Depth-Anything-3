FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu22.04

# Set up environment
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV CUDA_HOME=/usr/local/cuda
ENV TORCH_CUDA_ARCH_LIST="8.9"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.10 python3.10-venv python3.10-dev python3-pip git build-essential \
        libglib2.0-0 libsm6 libxrender1 libxext6 wget libgl1 && \
    rm -rf /var/lib/apt/lists/*

# Set python3.10 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Set workdir
WORKDIR /workspace

# Copy your project
COPY . /workspace

# Install PyTorch (CUDA 12.8 build)
RUN pip install torch torchvision --index-url https://download.pytorch.org/whl/cu128

# Install xformers and other requirements
RUN pip install xformers

# Install your package and gsplat
RUN pip install -e . && \
    pip install --no-build-isolation git+https://github.com/nerfstudio-project/gsplat.git@0b4dddf04cb687367602c01196913cde6a743d70

# (Optional) Install all extras
# RUN pip install -e ".[all]"

# Default command
CMD ["da3", "backend"]
