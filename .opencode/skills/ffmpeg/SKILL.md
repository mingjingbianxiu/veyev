---
name: ffmpeg
description: 使用 FFmpeg 进行音视频处理，包括格式转换、视频剪辑、压缩优化、音频提取、媒体合并、水印添加等。适用于媒体文件处理、格式转换、视频剪辑等任务。
trigger phrases:
  - ffmpeg
  - 视频转换
  - 视频剪辑
  - 视频压缩
  - 提取音频
  - 视频合并
  - 添加水印
  - 音视频处理
---

# FFmpeg Skill

使用此 skill 时，OpenCode 会自动加载此文件中的命令参考。

当用户的请求匹配 trigger phrases 中的关键词时，自动使用此 skill。

## 重要：自动下载逻辑

根据 agents.md 的配置，执行 ffmpeg 命令前会自动检查并下载：

1. **检查当前目录是否有 ffmpeg**：
   - 检查 `./ffmpeg/ffmpeg` 或 `./ffmpeg/bin/ffmpeg` 是否存在

2. **如果未找到，自动从官网下载**（参考 agents.md）：
   - Linux: 下载 ffmpeg-release-linux64-gpl.tar.xz
   - macOS: 下载 ffmpeg-release-macos64-gpl.tar.xz
   - Windows: 下载 ffmpeg-release-win64-gpl.zip

3. **下载后设置路径**：
   - Linux/macOS: `FFMPEG_HOME="$(pwd)/ffmpeg"`
   - Windows: `$env:FFMPEG_HOME="$PWD\ffmpeg"`

## 常用命令

### 1. 获取媒体信息
```bash
./ffmpeg/bin/ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 <输入文件>
```

### 2. 视频格式转换
```bash
./ffmpeg/bin/ffmpeg -i <输入文件> -c:v libx264 -c:a aac <输出文件>
```

### 3. 视频剪辑（无损）
```bash
./ffmpeg/bin/ffmpeg -ss <开始时间> -i <输入文件> -to <结束时间> -c copy <输出文件>
```

### 4. 视频压缩
```bash
./ffmpeg/bin/ffmpeg -i <输入文件> -c:v libx264 -crf 25 -preset medium -c:a copy <输出文件>
```

### 5. 提取音频
```bash
./ffmpeg/bin/ffmpeg -i <输入文件> -q:a 0 -map a <输出音频>
```

### 6. 视频合并
```bash
./ffmpeg/bin/ffmpeg -f concat -safe 0 -i <文件列表> -c copy <输出文件>
```

### 7. 添加水印
```bash
./ffmpeg/bin/ffmpeg -i <视频> -i <水印图片> -filter_complex overlay=10:10 -c:a copy <输出文件>
```
