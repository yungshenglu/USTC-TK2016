# USTC-TK2016

This repository is a toolkit called "USTC-TK2016", which is used to parse network traffic (`.pcap` file). Besides, the dataset is "USTC-TFC2016".

* The [`master`]() branch can only run on Windows environment.
* The [`ubuntu`]() branch can run on Ubuntu Linux 16.04 LTS environment.

---
## Execution

> **NOTICE:** You are on the `master` branch now!

1. Download the dataset and put it into the directory [`1_Pcap\`](1_Pcap/)
2. Open the PowerShell and run `1_Pcap2Session.ps1` (take a few minutes)
    * To split the PCAP file by each **session**, please make sure the line 10 and 14 in `1_Pcap2Session.ps1` is uncommented and make line 11 and 15 is in comment.
    * To split the PCAp file by each **flow**, please make sure the line 11 and 15 in `1_Pcap2Session.ps1` is uncommented and make line 10 and 14 is in comment.
    * Run [`1_Pcap2Session.ps1`](1_Pcap2Session.ps1)
        ```bash
        # Make sure your current directory is correct
        PS> .\1_Pcap2Session.ps1
        ```
    * If succeed, you will see the following files (folders) in folder [`2_Session\`](2_Session/)
        * `AllLayers\`
        * `L7\`
3. Run [`2_ProcessSession.ps1`](2_ProcessSession.ps1)
    ```bash
    # Make sure your current directory is correct
    PS> .\2_ProcessSession.ps1
    ```
    * If succeed, you will see the following files (folders) in folder [`3_ProcessedSession\`](3_ProcessedSession/)
        * `FilteredSession\` - Get the top 60000 large PCAP files
        * `TrimedSession\` - Trim the filtered PCAP files into size 784 bytes (28 x 28) and append `0x00` if the PCAP file is shorter than 784 bytes
        * The files in subdirectory `Test\` and `Train\` is random picked from dataset.
4. Run [`3_Session2Png.py`](3_Session2Png.py)
    ```bash
    # Make sure your current directory is correct
    PS> python3 3_Session2png.py
    ```
5. Run [`4_Png2Mnist.py`](4_Png2Mnist.py)
    ```bash
    # Make sure your current directory is correct
    PS> python3 4_Png2Mnist.py
    ```

---
## Author

* [Wei Wang](https://github.com/echowei) - ww8137@mail.ustc.edu.cn

---
## Contributor

* [David Lu](https://github.com/yungshenglu)

---
## License

[Mozilla Public License Version 2.0](LICENSE)