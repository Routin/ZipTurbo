#!/bin/bash

# 默认并行线程数量，建议设置为 CPU 核心数的两倍或根据实际情况调整
NUM_PROC=$(nproc)
USE_RAM=false  # 默认不使用 RAM 磁盘

# 显示帮助信息
show_help() {
    echo "使用方法: $0 [--num_proc N] [--use_ram] yourfile.zip"
    echo ""
    echo "选项:"
    echo "  --num_proc N    指定并行处理的线程数 (默认为 CPU 核心数)"
    echo "  --use_ram       使用 RAM 磁盘进行解压加速"
}

# 清理函数：处理脚本终止时的清理操作
cleanup() {
    if [ "$USE_RAM" = true ]; then
        echo "检测到中断信号，正在清理 RAM 磁盘..."
        rm -rf "$RAM_DISK"
        echo "清理完成。脚本已终止。"
    fi
    exit 1
}

# 捕获 Ctrl+C 信号 (SIGINT)，并调用 cleanup 函数
trap cleanup SIGINT

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --num_proc)
            NUM_PROC="$2"
            shift 2
            ;;
        --use_ram)
            USE_RAM=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            ZIP_FILE="$1"
            shift
            ;;
    esac
done

# 检查是否提供了ZIP文件参数
if [ -z "$ZIP_FILE" ]; then
  echo "错误: 未指定ZIP文件。"
  show_help
  exit 1
fi

# 检查指定的ZIP文件是否存在
if [ ! -f "$ZIP_FILE" ]; then
  echo "文件 $ZIP_FILE 不存在！"
  exit 1
fi

echo "开始处理文件: $ZIP_FILE"

# 如果使用 RAM 磁盘，加速操作
if [ "$USE_RAM" = true ]; then
    RAM_DISK="/dev/shm/zip_unzip"
    mkdir -p "$RAM_DISK"
    echo "正在将文件复制到 RAM 磁盘中..."
    cp "$ZIP_FILE" "$RAM_DISK/"
    echo "文件已复制到 RAM 磁盘。"
    ZIP_FILE="$RAM_DISK/$(basename "$ZIP_FILE")"
else
    echo "未使用 RAM 磁盘，直接从磁盘解压。"
fi

# 解压到当前目录，如果不指定文件夹
OUTPUT_DIR="."
echo "正在准备目录结构..."
# 提取 ZIP 文件中的所有目录并提前创建，避免并行解压时的目录创建冲突
unzip -Z1 "$ZIP_FILE" | grep '/$' | while read DIR; do
  mkdir -p "$OUTPUT_DIR/$DIR"
done
echo "目录结构已准备完成。"

# 获取总文件数，用于显示解压进度
TOTAL_FILES=$(unzip -Z1 "$ZIP_FILE" | wc -l)
echo "总文件数: $TOTAL_FILES"

# 使用 unzip -Z1 列出ZIP文件内容，并用 parallel 并行解压每个文件到输出目录
echo "开始并行解压文件..."
unzip -Z1 "$ZIP_FILE" | parallel -j "$NUM_PROC" --bar unzip -qq -o "$ZIP_FILE" -d "$OUTPUT_DIR" {}

echo "解压完成！所有文件已解压到当前目录中。"

# 清理 RAM 磁盘
if [ "$USE_RAM" = true ]; then
    echo "正在清理 RAM 磁盘..."
    rm -rf "$RAM_DISK"
    echo "RAM 磁盘已清理。"
fi
