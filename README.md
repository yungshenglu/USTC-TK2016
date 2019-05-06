# USTC-TK2016

This repository is a toolkit called "USTC-TK2016", which is used to parse network traffic (`.pcap` file). Besides, the dataset is "USTC-TFC2016".

* The [`master`](https://github.com/yungshenglu/USTC-TK2016/tree/master) branch can only run on Windows environment.
* The [`ubuntu`](https://github.com/yungshenglu/USTC-TK2016/tree/ubuntu) branch can run on Ubuntu Linux 16.04 LTS environment.

> **NOTICE:** This repository credits to [echowei/DeepTraffic](https://github.com/echowei/DeepTraffic)

---
## Dependency

> **NOTICE:** For Ubuntu Linux 16.04 LTS, you need to install the dependency as follow

* [Mono](https://www.mono-project.com/)
    1. Add the Mono repository to your system
        ```bash
        $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
        $ sudo apt install apt-transport-https ca-certificates
        $ echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
        $ sudo apt update
        ```
    2. Install Mono
        ```bash
        $ sudo apt install mono-devel
        ```
* [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-6)
    ```bash
    $ wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
    $ sudo dpkg -i powershell_6.1.0-1.ubuntu.16.04_amd64.deb
    $ sudo apt-get install -f
    ```
* Install [fdupes](http://manpages.ubuntu.com/manpages/xenial/man1/fdupes.1.html)
    ```bash
    $ sudo apt-get install fdupes
    ```

---
## Execution

> **NOTICE:** You are on the `ubuntu` branch now!

1. Download the traffic dataset **USTC-TFC2016** and put it into the directory [`1_Pcap/`](1_Pcap/)
    * You can download the traffic dataset **USTC-TFC2016** from my another [repository](https://github.com/yungshenglu/USTC-TFC2016).
2. Open the terminal and run `1_Pcap2Session.ps1` (take a few minutes)
    * To split the PCAP file by each **session**, please make sure the line 10 and 14 in `1_Pcap2Session.ps1` is uncommented and make line 11 and 15 is in comment.
    * To split the PCAp file by each **flow**, please make sure the line 11 and 15 in `1_Pcap2Session.ps1` is uncommented and make line 10 and 14 is in comment.
    * Run [`1_Pcap2Session.ps1`](1_Pcap2Session.ps1)
        ```bash
        # Make sure your current directory is correct
        # Split the PCAP files by flow
        $ pwsh 1_Pcap2Session.ps1 -f
        # Split the PCAP files by session
        $ pwsh 1_Pcap2Session.ps1 -s
        ```
    * If succeed, you will see the following files (folders) in folder [`2_Session/`](2_Session/)
        * `AllLayers/`
        * `L7/`
3. Run [`2_ProcessSession.ps1`](2_ProcessSession.ps1) (take a few minutes)
    ```bash
    # Make sure your current directory is correct
    # Process the PCAP file with all layers (ALL) (for unsorting or sorting)
    $ pwsh 2_ProcessSession.ps1 -a [-u | -s]
    # Process the PCAP file only with layer 7 (L7) (for unsorting or sorting)
    $ pwsh 2_ProcessSession.ps1 -l [-u | -s]
    ```
    * If succeed, you will see the following files (folders) in folder [`3_ProcessedSession/`](3_ProcessedSession/)
        * `FilteredSession/` - Get the top 60000 large PCAP files
        * `TrimedSession/` - Trim the filtered PCAP files into size 784 bytes (28 x 28) and append `0x00` if the PCAP file is shorter than 784 bytes
        * The files in subdirectory `Test/` and `Train/` is random picked from dataset.
4. Run [`3_Session2Png.py`](3_Session2Png.py) (take a few minutes)
    ```bash
    # Make sure your current directory is correct
    $ python3 3_Session2png.py
    [INFO] Saving image in: 4_Png/Train/0
    ...
    [INFO] Saving image in: 4_Png/Test/0
    ...
    ```
    * If succeed, you will see the following files (folders) in folder [`4_Png/`](4_Png/)
        * `Test/` - For testing
        * `Train/` - For training
5. Run [`4_Png2Mnist.py`](4_Png2Mnist.py) (take a few minutes)
    ```bash
    # Make sure your current directory is correct
    $ python3 4_Png2Mnist.py
    [INFO] Generated file: 5_Mnist/train-images-idx1-ubyte
    [INFO] Generated file: 5_Mnist/train-images-idx3-ubyte
    [INFO] Compressed file: 5_Mnist/train-images-idx1-ubyte.gz
    [INFO] Compressed file: 5_Mnist/train-images-idx3-ubyte.gz
    ```
    * If succeed, you will see the the following training datasets in folder [`5_Mnist/`](5_Mnist/)
        * `train-images-idx1-ubyte`
        * `train-images-idx3-ubyte`
        * `train-images-idx1-ubyte.gz`
        * `train-images-idx3-ubyte.gz`

---
## Author

* [Wei Wang](https://github.com/echowei) - ww8137@mail.ustc.edu.cn

---
## Contributor

> **NOTICE:** You can follow the contributing process [CONTRIBUTING.md](CONTRIBUTING.md) to join me. I am very welcome any issue!

* [David Lu](https://github.com/yungshenglu)

---
## License

[Mozilla Public License Version 2.0](LICENSE)