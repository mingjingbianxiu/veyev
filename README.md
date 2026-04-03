# veyev - AI 视频剪辑工具

veyev 是一个开源的 AI 视频剪辑工具，利用人工智能技术自动识别视频中的精彩片段，实现智能剪辑、自动配乐、字幕生成等功能，让视频创作更加高效便捷。

veyev 结合 FFmpeg 强大的音视频处理能力，支持视频转码、剪辑、合并、提取音频等操作。通过 AI 智能分析，帮你快速筛选高能时刻，自动生成精彩集锦。无论是生活 vlog、直播切片还是短视频创作，veyev 都能大幅提升你的剪辑效率。

## 功能特性

- 🤖 AI 智能识别精彩片段，自动生成高能集锦
- 🎬 视频剪辑、合并、裁剪，支持多种格式
- 🎵 自动配乐，智能匹配背景音乐
- 📝 字幕生成，自动识别语音内容
- ⚡ 高效转码，支持批量处理
- 🔧 基于 FFmpeg，性能稳定可靠

## 适用场景

- 短视频创作自动剪辑
- 直播回放切片提取
- Vlog 智能汇总生成
- 视频素材批量处理
- 自动化视频工作流

## 使用说明

### 环境要求

- Node.js 18+
- npm 或 yarn

### 安装步骤

#### 1. 安装 opencode

```bash
# 使用 npm
npm install -g opencode-ai

# 或使用 yarn
yarn global add opencode-ai
```

#### 2. 克隆项目

```bash
git clone https://gitee.com/realme_lee/veyev.git
cd veyev
```

#### 3. 安装依赖

```bash
npm install
# 或
yarn
```

#### 4. 安装 FFmpeg

在 opencode 中输入以下命令自动下载 FFmpeg：

```
下载 ffmpeg
```

或者手动下载：

```bash
# Linux
wget https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz
tar -xf ffmpeg-master-latest-linux64-gpl.tar.xz

# macOS
wget https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-macos64-gpl.tar.xz
tar -xf ffmpeg-master-latest-macos64-gpl.tar.xz

# Windows
# 从 https://github.com/BtbN/FFmpeg-Builds/releases 下载 ffmpeg-master-latest-win64-gpl.zip
```

### 快速演示

使用 `data/landing.mp4` 文件（8秒）演示常见操作：

#### 1. 查看视频信息

```bash
./ffmpeg/bin/ffprobe -v error -show_entries stream=codec_name,width,height,duration -of json data/landing.mp4
```

#### 2. 提取最后 3 秒

```bash
./ffmpeg/bin/ffmpeg -ss 5 -i data/landing.mp4 -t 3 -c copy data/landing_last3s.mp4
```

#### 3. 提取最后 1 秒

```bash
./ffmpeg/bin/ffmpeg -ss 7 -i data/landing.mp4 -t 1 -c copy data/landing_last1s.mp4
```

#### 4. 提取音频

```bash
./ffmpeg/bin/ffmpeg -i data/landing.mp4 -q:a 0 -map a data/landing.mp3
```

#### 5. 视频转码 (H.264)

```bash
./ffmpeg/bin/ffmpeg -i data/landing.mp4 -c:v libx264 -c:a aac data/landing_h264.mp4
```

#### 6. 视频压缩

```bash
./ffmpeg/bin/ffmpeg -i data/landing.mp4 -c:v libx264 -crf 28 -preset fast -c:a copy data/landing_compressed.mp4
```

#### 7. 截图

```bash
./ffmpeg/bin/ffmpeg -i data/landing.mp4 -ss 00:00:02 -vframes 1 data/frame.jpg
```

## 参与贡献

## Docker 使用

### 构建镜像

```bash
docker build -t cuda-env .
```

### 运行容器

```bash
# 交互式运行
docker run -it --gpus all -p 2222:22 cuda-env

# 后台运行
docker run -d --gpus all -p 2222:22 --name mycuda cuda-env
```

### 查看公钥

容器启动时自动打印公钥，也可以通过日志查看：

```bash
docker logs <container_id>
```

### SSH 登录

```bash
# 使用密码登录
ssh user@localhost -p 2222
# 密码: 123456

# 使用私钥登录
ssh -i /path/to/ssh_private_key user@localhost -p 2222
```

### 获取私钥

私钥位于容器内的 `/output/ssh_private_key`，可使用 docker cp 导出：

```bash
docker cp <container_id>:/output/ssh_private_key ./

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request
