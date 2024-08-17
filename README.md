# AzurLaneAutoScript Docker for ARM64

## 简介

本项目为 [AzurLaneAutoScript](https://github.com/LmeSzinc/AzurLaneAutoScript) 的 Docker 版本，适配了 ARM64 架构。旨在提供一个方便的环境来运行 AzurLaneAutoScript，特别是在 ARM64 设备上。

## 须知

- **端口**: 默认运行端口为 `22267`
- **如果需要通过 ADB USB 连接设备，请取消注释 ```docker-compose.yml```里提示的地方**

## 使用指南

### 先决条件

- Docker
- Docker Compose
- [AzurLaneAutoScript](https://github.com/LmeSzinc/AzurLaneAutoScript)
> 克隆 [AzurLaneAutoScript](https://github.com/LmeSzinc/AzurLaneAutoScript) 到一个你喜欢的目录，例如 `/root/AzurLaneAutoScript`，后面需要用到


### 使用 `docker-compose`

如果你想使用 `docker-compose` 来运行 Docker 容器，请确保你已经安装了 Docker 和 Docker Compose。然后，按照以下步骤操作：

1. 克隆项目

首先，克隆本项目到本地：

```bash
git clone https://github.com/LittleMio/AzurLaneAutoScript-docker-arm64.git
cd AzurLaneAutoScript-docker-arm64
```
2. 修改 `docker-compose.yml`

在 docker-compose.yml 文件中，将 volumes 部分的路径 /path/to/dir 替换为 AzurLaneAutoScript 项目的实际路径。



### 使用 `docker run`

如果你想使用 `docker run` 命令来运行 Docker 容器，请使用以下命令：

```bash
# 使用当前工作目录
docker run -v ${PWD}:/app/AzurLaneAutoScript --network host --name ALAS -it littlemio/alas:latest

# 或者使用指定的路径
docker run -v /path/to/dir:/app/AzurLaneAutoScript --network host --name ALAS -it littlemio/alas:latest
```

请将 `/path/to/dir` 替换为 AzurLaneAutoScript 项目的实际路径。

### 其他说明
- 本项目针对 ARM64 架构重新编译了 MXNet，以优化运行速度。有关 MXNet 编译的详细信息，请参考 [MXNet 官方文档](https://mxnet.apache.org/versions/1.9.1/get_started?platform=devices&iot=raspberry-pi&)。
- 如有其他问题，请提交 [issue](https://github.com/LittleMio/AzurLaneAutoScript-docker-arm64/issues) 或者参考 [AzurLaneAutoScript 的文档](https://github.com/LmeSzinc/AzurLaneAutoScript/wiki)进行调试。

### 许可证
- 本项目遵循 [GPL-3.0](./LICENSE) 许可证。
