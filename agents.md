# FFmpeg 自动下载 Agent 指令

## 触发条件

当执行 ffmpeg 相关命令时，如果系统未找到 ffmpeg 且当前目录下也未找到 ffmpeg，则自动从官网下载。

## 执行步骤

1. **检查当前目录是否有 ffmpeg**：
   - 检查 `./ffmpeg` 目录是否存在
   - 检查 `./ffmpeg/ffmpeg` 或 `./ffmpeg/bin/ffmpeg` 是否存在

2. **如果当前目录没有 ffmpeg，则从官网下载**：
   - Linux: 下载 ffmpeg-release-latest-linux64-gpl.tar.xz 并解压到 `./ffmpeg` 目录
   - macOS: 下载 ffmpeg-release-latest-macos64-gpl.tar.xz 并解压到 `./ffmpeg` 目录
   - Windows: 下载 ffmpeg-release-latest-win64-gpl.zip 并解压到 `./ffmpeg` 目录

3. **下载命令示例**：

```bash
# Linux
mkdir -p ./ffmpeg
curl -L "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-linux64-gpl.tar.xz" -o ffmpeg.tar.xz
tar -xf ffmpeg.tar.xz -C ./ffmpeg --strip-components=1
rm ffmpeg.tar.xz

# macOS
mkdir -p ./ffmpeg
curl -L "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-macos64-gpl.tar.xz" -o ffmpeg.tar.xz
tar -xf ffmpeg.tar.xz -C ./ffmpeg --strip-components=1
rm ffmpeg.tar.xz

# Windows (使用 PowerShell)
New-Item -ItemType Directory -Path .\ffmpeg -Force
Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-win64-gpl.zip" -OutFile ffmpeg.zip
Expand-Archive -Path ffmpeg.zip -DestinationPath .\ffmpeg -Force
Remove-Item ffmpeg.zip
```

4. **设置环境变量**：
   - Linux/macOS: `export FFMPEG_HOME="$(pwd)/ffmpeg"`
   - Windows: `$env:FFMPEG_HOME="$PWD\ffmpeg"`

5. **验证安装**：执行 `./ffmpeg/ffmpeg -version` 确认下载成功

## 代码示例

```python
import subprocess
import platform
import os
import urllib.request
import tarfile
import zipfile
import shutil

FFMPEG_DIR = "./ffmpeg"

def check_local_ffmpeg():
    """检查当前目录是否有 ffmpeg"""
    possible_paths = [
        "./ffmpeg/ffmpeg",
        "./ffmpeg/bin/ffmpeg.exe",
        "./ffmpeg/ffmpeg.exe",
    ]
    for path in possible_paths:
        if os.path.exists(path):
            return path
    return None

def get_download_url():
    """根据系统获取下载链接"""
    system = platform.system()
    base_url = "https://www.gyan.dev/ffmpeg/builds/"
    
    if system == "Windows":
        return base_url + "ffmpeg-release-win64-gpl.zip"
    elif system == "Darwin":  # macOS
        return base_url + "ffmpeg-release-macos64-gpl.tar.xz"
    elif system == "Linux":
        return base_url + "ffmpeg-release-linux64-gpl.tar.xz"
    return None

def download_and_extract():
    """从官网下载并解压 ffmpeg"""
    url = get_download_url()
    if not url:
        print("不支持的操作系统")
        return False
    
    os.makedirs(FFMPEG_DIR, exist_ok=True)
    
    filename = url.split("/")[-1]
    print(f"正在下载: {url}")
    
    urllib.request.urlretrieve(url, filename)
    
    if filename.endswith(".zip"):
        with zipfile.ZipFile(filename, 'r') as zip_ref:
            zip_ref.extractall(FFMPEG_DIR)
    else:
        with tarfile.open(filename, 'r:xz') as tar:
            tar.extractall(FFMPEG_DIR)
    
    # 清理压缩包
    os.remove(filename)
    
    # 移动文件到顶层（去除版本文件夹）
    contents = os.listdir(FFMPEG_DIR)
    if len(contents) == 1 and os.path.isdir(os.path.join(FFMPEG_DIR, contents[0])):
        inner_dir = os.path.join(FFMPEG_DIR, contents[0])
        for item in os.listdir(inner_dir):
            shutil.move(os.path.join(inner_dir, item), os.path.join(FFMPEG_DIR, item))
        os.rmdir(inner_dir)
    
    return check_local_ffmpeg() is not None

def get_ffmpeg_path():
    """获取 ffmpeg 路径"""
    local = check_local_ffmpeg()
    if local:
        return os.path.dirname(local)
    
    # 尝试自动下载
    if download_and_extract():
        return FFMPEG_DIR
    
    return None

def run_ffmpeg(args):
    """运行 ffmpeg 命令"""
    ffmpeg_dir = get_ffmpeg_path()
    if not ffmpeg_dir:
        print("无法找到或下载 ffmpeg")
        return None
    
    ffmpeg_bin = os.path.join(ffmpeg_dir, "ffmpeg")
    if not os.path.exists(ffmpeg_bin):
        ffmpeg_bin = os.path.join(ffmpeg_dir, "bin", "ffmpeg")
    
    return subprocess.run([ffmpeg_bin] + args)
```

## 注意事项
- 如果github不能访问，使用 https://github.akams.cn/ 选择 节点选择 加上 proxy
- 在github.com 下载
- 一下不要安装到操作系统目录
- 只下载到当前目录的 `./ffmpeg` 文件夹
- 优先使用当前目录已有的 ffmpeg
- 如果当前目录没有，则自动从官网下载

## github proxy
```python
[
  {
    "name": "默认节点",
    "url": "gh.llkk.cc",
    "time": "5.19s",
    "speed": "0.2Mbps"
  },
  {
    "name": "搜索引擎",
    "url": "ghps.cc",
    "time": "3.05s",
    "speed": "26641.6Mbps"
  },
  {
    "name": "搜索引擎",
    "url": "gh.zwes.xyz",
    "time": "3.64s",
    "speed": "5310.0Mbps"
  },
  {
    "name": "公益贡献",
    "url": "gitproxy.click",
    "time": "3.56s",
    "speed": "1821.7Mbps"
  },
  {
    "name": "搜索引擎",
    "url": "github.tmby.shop",
    "time": "3.45s",
    "speed": "1641.6Mbps"
  },
  {
    "name": "公益贡献",
    "url": "gh.927223.xyz",
    "time": "5.30s",
    "speed": "3.9Mbps"
  },
  {
    "name": "公益贡献",
    "url": "gh.dpik.top",
    "time": "4.82s",
    "speed": "2.1Mbps"
  },
  {
    "name": "公益贡献",
    "url": "github.dpik.top",
    "time": "5.36s",
    "speed": "2.1Mbps"
  }
]
```