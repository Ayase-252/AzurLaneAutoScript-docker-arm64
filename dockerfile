# docker build -t littlemio/alas:latest .
# docker run -v ${PWD}:/app/AzurLaneAutoScript --network host --name alas -it littlemio/alas:latest

FROM continuumio/miniconda3:24.5.0-0

SHELL ["/bin/bash", "-c"]

WORKDIR /app

ENV PYROOT=/app/python37

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${PYROOT}/mxnet/" \
 PATH="${PATH}:/opt/platform-tools:${HOME}/.cargo/bin"

COPY ./requirements.txt ./mxnet-1.9.1-py3-none-any.whl /app/

RUN conda create --prefix $PYROOT python=3.7 -y \
 && apt-get update \
 && apt-get install -y git libgl1 libatlas-base-dev libopencv-dev build-essential libopenblas-dev unzip \
 && conda activate $PYROOT && conda install -y -c conda-forge gcc=12 && conda deactivate \
 && wget https://static.rust-lang.org/rustup.sh -O - | sh -s -- -y && source "$HOME/.cargo/env" \
 && wget -c https://github.com/lzhiyong/android-sdk-tools/releases/download/34.0.3/android-sdk-tools-static-aarch64.zip && unzip android-sdk-tools-static-aarch64.zip "platform-tools/*" -d /opt \
 && $PYROOT/bin/pip install -U pip setuptools wheel \
 && $PYROOT/bin/pip install -r /app/requirements.txt \
 && $PYROOT/bin/pip uninstall mxnet -y \
 && $PYROOT/bin/pip install /app/mxnet-1.9.1-py3-none-any.whl \
 && conda clean --all -y && $PYROOT/bin/pip cache purge && rustup self uninstall -y \
 && rm -rf /app/mxnet-1.9.1-py3-none-any.whl /app/android-sdk-tools-static-aarch64.zip /app/requirements.txt /var/lib/apt/lists/*

EXPOSE 22267

CMD $PYROOT/bin/python /app/AzurLaneAutoScript/gui.py
