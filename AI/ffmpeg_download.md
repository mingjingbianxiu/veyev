# FFmpeg 自动下载脚本

必须安装在项目根目录里，不要安装在系统里

## Windows

### 方法一：使用 winget（推荐）
```powershell
winget install ffmpeg
```

### 方法二：使用 Chocolatey
```powershell
choco install ffmpeg -y
```

### 方法三：手动下载
```powershell
# 下载 ffmpeg
Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -OutFile "ffmpeg.zip"

# 解压
Expand-Archive -Path "ffmpeg.zip" -DestinationPath "C:\ffmpeg"

# 添加到 PATH
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\ffmpeg\bin", "User")
```

---

## macOS

### 方法一：使用 Homebrew（推荐）
```bash
brew install ffmpeg
```

### 方法二：使用 MacPorts
```bash
sudo port install ffmpeg
```

---

## Linux

### Debian/Ubuntu
```bash
sudo apt update
sudo apt install ffmpeg
```

### CentOS/RHEL
```bash
sudo yum install epel-release
sudo yum install ffmpeg
```

### Arch Linux
```bash
sudo pacman -S ffmpeg
```

### Fedora
```bash
sudo dnf install ffmpeg
```

### 从源码编译安装（适用于所有 Linux 发行版）
```bash
# 安装依赖
sudo apt install -y build-essential libavcodec-extra libavdevice-dev libavfilter-dev libavformat-dev libavresample-dev libswscale-dev libswresample-dev yasm pkg-config

# 下载源码
wget https://ffmpeg.org/releases/ffmpeg-6.1.tar.gz
tar -xzf ffmpeg-6.1.tar.gz
cd ffmpeg-6.1

# 编译安装
./configure --prefix=/usr/local
make -j$(nproc)
sudo make install

# 更新动态库缓存
sudo ldconfig
```

---

## 验证安装

```bash
ffmpeg -version
ffprobe -version
```

---

## Windows 一键脚本

创建 `install-ffmpeg.ps1` 文件并以管理员身份运行：

```powershell
$ffmpegUrl = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
$extractPath = "C:\ffmpeg"
$zipFile = "$env:TEMP\ffmpeg.zip"

Write-Host "正在下载 FFmpeg..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $ffmpegUrl -OutFile $zipFile

Write-Host "正在解压..."
Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force

$binPath = Join-Path $extractPath "ffmpeg-*-essentials_build\bin"
$binPath = (Get-ChildItem $binPath -Directory | Select-Object -First 1).FullName

$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$binPath*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$binPath", "User")
    Write-Host "已添加到 PATH，需要重启终端生效"
}

Remove-Item $zipFile -Force
Write-Host "安装完成！运行 'ffmpeg -version' 验证"
```