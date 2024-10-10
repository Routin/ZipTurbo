🎈Readme made by gpt.
### README (English Version)

# ZipTurbo

## Project Overview

ZipTurbo is a powerful ZIP extraction tool that supports multi-threaded parallel processing with the option to use a RAM disk for acceleration. It efficiently utilizes system resources to maximize extraction speed, making it ideal for handling large ZIP files.

## Features

- **Multithreaded Extraction**: Maximizes CPU usage with parallel processing to speed up file extraction.
- **RAM Disk Acceleration**: Optional RAM disk mode copies files to memory for faster processing.
- **Automatic Directory Creation**: Prepares the directory structure in advance to avoid conflicts during parallel file extraction.
- **Progress Display**: Real-time progress display in the terminal during extraction.

## Installation & Usage

### Requirements

- Linux system
- `parallel` and `unzip` tools installed

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/Routin/ZipTurbo.git
    cd ZipTurbo
    ```

2. Ensure that `parallel` and `unzip` are installed on your system:

    ```bash
    sudo apt install parallel unzip
    ```

### Usage

```bash
./ZipTurbo.sh [--num_proc N] [--use_ram] yourfile.zip
```

- `--num_proc N`: Specify the number of parallel threads, default is the number of CPU cores.
- `--use_ram`: Enable RAM disk for faster extraction.
- `yourfile.zip`: The path to the ZIP file to be extracted.

#### Example

```bash
./ZipTurbo.sh --num_proc 8 --use_ram myarchive.zip
```

This command will use 8 threads and extract the file using the RAM disk.

### Notes

- Ensure your system has enough available memory when using RAM disk mode.
- Multithreaded extraction can significantly speed up processing time for large files.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

---

### README (中文版本)

# ZipTurbo

## 项目简介

ZipTurbo 是一个强大的 ZIP 文件解压缩工具，支持多线程并行处理，并可以选择使用 RAM 磁盘来加速解压过程。它能有效利用系统资源，最大化解压效率，非常适合处理大型 ZIP 文件。

## 功能特点

- **多线程解压**: 利用并行处理，最大化 CPU 使用率，加速文件解压。
- **RAM 磁盘加速**: 可选的 RAM 磁盘模式，将文件复制到内存中进行解压，从而提高处理速度。
- **自动目录创建**: 在并行处理文件时，提前创建目录，避免冲突。
- **进度显示**: 在终端中显示解压的实时进度。

## 安装与使用

### 环境要求

- Linux 系统
- `parallel` 和 `unzip` 工具已安装

### 安装

1. 克隆代码库:

    ```bash
    git clone https://github.com/Routin/ZipTurbo.git
    cd ZipTurbo
    ```

2. 确保你的系统安装了 `parallel` 和 `unzip`:

    ```bash
    sudo apt install parallel unzip
    ```

### 使用方法

```bash
./ZipTurbo.sh [--num_proc N] [--use_ram] yourfile.zip
```

- `--num_proc N`：指定并行线程数，默认为 CPU 核心数。
- `--use_ram`：启用 RAM 磁盘进行解压加速。
- `yourfile.zip`：需要解压的 ZIP 文件路径。

#### 示例

```bash
./ZipTurbo.sh --num_proc 8 --use_ram myarchive.zip
```

这个命令会使用 8 个线程并在 RAM 磁盘中进行解压。

### 注意事项

- 启用 RAM 磁盘模式时，请确保系统拥有足够的可用内存。
- 在大文件解压时，多线程解压可显著加速处理时间。

## 许可证

该项目使用 MIT 许可证。详情请参阅 LICENSE 文件。

---
