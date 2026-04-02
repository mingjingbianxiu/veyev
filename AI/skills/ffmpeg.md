# FFmpeg OpenCode Agent

## 一、Agent基础信息

### 1. 核心定位

面向代码化、自动化、工程化的FFmpeg智能执行代理，专为开发者、后端服务、媒体处理平台打造，摒弃手动命令行操作，实现音视频处理全流程标准化、可复用、可监控调用，支持各类编程语言无缝集成，高效完成各类音视频编解码、剪辑、处理、批量任务。

### 2. 核心能力

- 标准化FFmpeg指令生成，杜绝命令拼写、参数错乱问题

- 入参校验、文件合法性、编码格式前置检测，提前拦截异常

- 同步/异步任务执行，支持任务状态追踪、进度实时解析

- 批量音视频处理、断点续执行、异常自动重试与容错

- 结构化日志输出、任务结果返回、错误信息标准化

- 兼容全平台FFmpeg环境，适配各类媒体处理场景

### 3. 运行依赖

需提前在运行环境安装FFmpeg完整版（包含ffprobe），并配置环境变量，确保命令行可直接调用；支持Windows、macOS、Linux全系统部署，无额外第三方依赖。

---

## 二、标准调用规范

### 1. 指令执行格式

Agent采用结构化参数调用，禁止手动拼接字符串，统一调用格式：

```shell
ffmpeg [全局参数] [输入参数] -i 输入文件 [输出参数] 输出文件
```

Agent内部会自动拆分参数、校验合法性、执行命令并返回结果，无需关注底层命令拼接细节。

### 2. 任务状态定义

- **PENDING**：任务等待执行，入参校验中

- **RUNNING**：任务执行中，实时处理媒体文件

- **SUCCESS**：任务执行完成，文件输出正常

- **FAILED**：任务执行失败，返回异常信息

- **RETRYING**：任务异常重试，自动容错处理

### 3. 返回结果结构

```json
{
    "task_id": "任务唯一标识",
    "status": "任务状态",
    "input_path": "输入文件路径",
    "output_path": "输出文件路径",
    "progress": "执行进度(%)",
    "log": "执行日志详情",
    "error_msg": "失败异常信息(成功为空)",
    "cost_time": "执行耗时(s)"
}
```

---

## 三、核心场景指令库

### 1. 媒体格式转换

适配全格式互转，优先保证兼容性，默认采用H.264+AAC通用编码，适配多端播放

```bash
# MP4转WebM
ffmpeg -i input.mp4 -c:v libvpx -c:a libvorbis output.webm
# 视频转通用MP4
ffmpeg -i input.avi -c:v libx264 -c:a aac output.mp4
# 音频格式互转
ffmpeg -i input.wav -c:a libmp3lame output.mp3
```

### 2. 视频剪辑与截取

支持精准时长截取，无损剪辑优先使用流复制，提升处理速度

```bash
# 无损快速剪辑
ffmpeg -ss 开始时间 -i 输入文件 -to 结束时间 -c copy 输出文件
# 重新编码剪辑（解决音画不同步）
ffmpeg -i input.mp4 -ss 00:00:10 -t 00:00:30 output_cut.mp4
```

### 3. 视频压缩优化

兼顾体积与画质，支持通用压缩、高清压缩、极致压缩三种模式，适配不同场景

```bash
# 通用压缩（兼容性优先）
ffmpeg -i input.mp4 -c:v libx264 -crf 25 -preset medium -c:a copy output_compress.mp4
# 高清小体积压缩（H.265）
ffmpeg -i input.mp4 -c:v libx265 -crf 28 -c:a aac output_small.mp4
```

### 4. 音频提取与处理

```bash
# 提取视频纯音频
ffmpeg -i input.mp4 -q:a 0 -map a output.mp3
# 调整音频音量
ffmpeg -i input.mp3 -filter:a volume=0.8 output_vol.mp3
```

### 5. 媒体拼接合并

采用文件列表方式，支持多文件稳定拼接，避免音画错位

```bash
# 新建filelist.txt，写入：file 'input1.mp4'、file 'input2.mp4'
ffmpeg -f concat -safe 0 -i filelist.txt -c copy output_merge.mp4
```

### 6. 水印与滤镜处理

```bash
# 添加图片水印
ffmpeg -i input.mp4 -i logo.png -filter_complex overlay=10:10 -c:a copy output_watermark.mp4
# 视频旋转
ffmpeg -i input.mp4 -vf transpose=1 output_rotate.mp4
```

### 7. 媒体信息获取

通过ffprobe获取结构化媒体信息，方便Agent解析判断

```bash
ffprobe -show_streams -show_format -print_format json input.mp4
```

---

## 四、Agent使用注意事项

### 1. 入参校验要求

- 输入文件路径需为绝对路径，避免相对路径读取失败

- 输出文件需保证目录存在、写入权限正常，避免输出失败

- 文件名禁止包含空格、特殊字符，需提前做字符转义处理

- 执行前需校验文件是否存在、是否为合法媒体文件

### 2. 编码与参数规范

- 通用场景优先使用libx264+aac编码，兼容性最强

- 无损操作必须添加-c copy参数，禁止重新编码

- CRF参数控制画质，取值范围0-51，数值越小画质越高、体积越大

- 剪辑出现音画不同步时，移除-c copy参数，重新编码即可解决

### 3. 任务执行管控

- 大文件处理建议开启异步执行，避免阻塞主线程

- 批量任务需控制并发数，防止系统资源占用过高

- 长时间执行任务需设置超时机制，避免进程卡死

- 执行失败后自动重试不超过3次，重试无效直接返回异常

### 4. 异常处理规则

- 文件已存在：默认自动覆盖，可通过参数关闭覆盖

- 编码不支持：自动降级为通用H.264+AAC编码

- 权限不足：返回明确异常，提示检查文件读写权限

- 格式损坏：拦截任务，提示检查输入文件完整性

---

## 五、工程化最佳实践

- 所有媒体处理任务通过Agent调用，禁止直接执行原生FFmpeg命令

- 批量处理采用任务队列，实现异步化、限流管控

- 执行日志持久化存储，方便后续问题排查与任务复盘

- 根据业务场景，提前封装常用处理模板，提升调用效率

- 生产环境使用完整版FFmpeg，避免缺失编码器导致任务失败
> （注：文档部分内容可能由 AI 生成）