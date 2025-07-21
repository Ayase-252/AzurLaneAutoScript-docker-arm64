# docker build -t littlemio/alas:latest .
# docker run -v ${PWD}:/app/AzurLaneAutoScript --network host --name alas -it littlemio/alas:latest

FROM continuumio/miniconda3:24.5.0-0 as builder

SHELL ["/bin/bash", "-c"]

ARG PYROOT=/app/python37

WORKDIR /app
ENV PATH="${PATH}:${PYROOT}/bin"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libopencv-dev \
        build-essential \
        libopenblas-dev \
        unzip \
        ca-certificates \
        wget && \
    rm -rf /var/lib/apt/lists/*

RUN conda create --prefix $PYROOT python=3.7 gcc=12 -y -c conda-forge && \
    conda clean -ya

RUN wget -q https://static.rust-lang.org/rustup.sh -O - | sh -s -- -y && \
    wget -q https://github.com/lzhiyong/android-sdk-tools/releases/download/34.0.3/android-sdk-tools-static-aarch64.zip && \
    unzip -q android-sdk-tools-static-aarch64.zip "platform-tools/*" -d /opt && \
    rm android-sdk-tools-static-aarch64.zip

COPY requirements.txt mxnet-1.9.1-py3-none-any.whl /app/
RUN $PYROOT/bin/pip install --no-cache-dir -U pip setuptools wheel && \
    $PYROOT/bin/pip install --no-cache-dir -r requirements.txt && \
    $PYROOT/bin/pip uninstall -y mxnet && \
    $PYROOT/bin/pip install --no-cache-dir /app/mxnet-1.9.1-py3-none-any.whl && \
    rm -rf /app/requirements.txt /app/mxnet-1.9.1-py3-none-any.whl

RUN find $PYROOT -type d -name '__pycache__' -exec rm -rf {} + && \
    find $PYROOT -type f -name '*.pyc' -delete && \
    rm -rf ~/.cache/pip ~/.cargo /tmp/*

FROM debian:12.5-slim

WORKDIR /app

ARG PYROOT=/app/python37

ENV PATH="${PATH}:${PYROOT}/bin:/opt/platform-tools" \
  LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${PYROOT}/mxnet/" \
  TZ=Asia/Shanghai

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        libopenblas0 \
        libopenblas-pthread-dev \
        libopencv-core406 \
        libopencv-imgproc406 \
        libopencv-imgcodecs406 \
        openssl \
        git && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo "$TZ" > /etc/timezone \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder ${PYROOT} ${PYROOT}
COPY --from=builder /opt/platform-tools /opt/platform-tools

EXPOSE 22267
CMD ["python", "/app/AzurLaneAutoScript/gui.py"]