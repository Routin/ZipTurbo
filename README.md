ZipTurbo
Project Overview
ZipTurbo is a powerful ZIP extraction tool that supports multi-threaded parallel processing with the option to use a RAM disk for acceleration. It efficiently utilizes system resources to maximize extraction speed, making it ideal for handling large ZIP files.

Features
Multithreaded Extraction: Maximizes CPU usage with parallel processing to speed up file extraction.
RAM Disk Acceleration: Optional RAM disk mode copies files to memory for faster processing.
Automatic Directory Creation: Prepares the directory structure in advance to avoid conflicts during parallel file extraction.
Progress Display: Real-time progress display in the terminal during extraction.
Installation & Usage
Requirements
Linux system
parallel and unzip tools installed
Installation
Clone the repository:

bash
复制代码
git clone https://github.com/Routin/ZipTurbo.git
cd ZipTurbo
Ensure that parallel and unzip are installed on your system:

bash
复制代码
sudo apt install parallel unzip
Usage
bash
复制代码
./ZipTurbo.sh [--num_proc N] [--use_ram] yourfile.zip
--num_proc N: Specify the number of parallel threads, default is the number of CPU cores.
--use_ram: Enable RAM disk for faster extraction.
yourfile.zip: The path to the ZIP file to be extracted.
Example
bash
复制代码
./ZipTurbo.sh --num_proc 8 --use_ram myarchive.zip
This command will use 8 threads and extract the file using the RAM disk.

Notes
Ensure your system has enough available memory when using RAM disk mode.
Multithreaded extraction can significantly speed up processing time for large files.
License
This project is licensed under the MIT License. See the LICENSE file for more details.
