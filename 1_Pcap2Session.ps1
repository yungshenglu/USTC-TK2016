# AUTHOR:
#   Wei Wang (ww8137@mail.ustc.edu.cn)
# CONTRIBUTOR:
#   David Lu (yungshenglu1994@gmail.com)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file, You
# can obtain one at http://mozilla.org/MPL/2.0/.
# ==============================================================================


$SOURCE_PCAP_DIR = "1_Pcap"

if ($($args.Count) -ne 1) {
    Write-Host $($args.Count)
    Write-Host "[ERROR] Wrong format of command!"
    Write-Host "[INFO] For Windows: .\1_Pcap2Session.ps1 <TYPE>"
    Write-Host "[INFO] For Linux:   pwsh 1_Pcap2Session.ps1 <TYPE>"
    Write-Host "[INFO] <TYPE>: -f (flow) | -s (session) | -p (packet)"
} 
else {
    if ($($args[0]) -eq "-f") {
        Write-Host "[INFO] Spliting the PCAP file into each flow"
        foreach ($f in Get-ChildItem $SOURCE_PCAP_DIR) {
            # For Windows
            <#
            0_Tool\SplitCap_2-1\SplitCap -p 50000 -b 50000 -r $f.FullName -s flow -o 2_Session\AllLayers\$($f.BaseName)-ALL
            Get-ChildItem 2_Session\AllLayers\$($f.BaseName)-ALL | ?{$_.Length -eq 0} | Remove-Item
            0_Tool\SplitCap_2-1\SplitCap -p 50000 -b 50000 -r $f.FullName -s flow -o 2_Session\L7\$($f.BaseName)-L7 -y L7
            Get-ChildItem 2_Session\L7\$($f.BaseName)-L7 | ?{$_.Length -eq 0} | Remove-Item
            #>

            # For Linux
            mono ./0_Tool/SplitCap_2-1/SplitCap.exe -p 50000 -b 50000 -r $f -s flow -o ./2_Session/AllLayers/$($f.BaseName)-ALL
            Get-ChildItem ./2_Session/AllLayers/$($f.BaseName)-ALL | ?{$_.Length -eq 0} | Remove-Item
            mono ./0_Tool/SplitCap_2-1/SplitCap.exe -p 50000 -b 50000 -r $f -s flow -o ./2_Session/L7/$($f.BaseName)-L7 -y L7
            Get-ChildItem ./2_Session/L7/$($f.BaseName)-L7 | ?{$_.Length -eq 0} | Remove-Item
        }

        # Remove duplicate files
        Write-Host "[INFO] Removing duplicate files"
        # For Windows
        <#
        0_Tool\finddupe -del 2_Session\AllLayers
        0_Tool\finddupe -del 2_Session\L7
        #>

        # For Linux
        fdupes -rdN ./2_Session/AllLayers/
        fdupes -rdN ./2_Session/L7/
    }
    elseif ($($args[0]) -eq "-s") {
        Write-Host "[INFO] Spliting the PCAP file into each session"
        foreach ($f in Get-ChildItem $SOURCE_PCAP_DIR) {
            # For Windows
            <#
            0_Tool\SplitCap_2-1\SplitCap -p 50000 -b 50000 -r $f.FullName -o 2_Session\AllLayers\$($f.BaseName)-ALL
            Get-ChildItem 2_Session\AllLayers\$($f.BaseName)-ALL | ?{$_.Length -eq 0} | Remove-Item
            0_Tool\SplitCap_2-1\SplitCap -p 50000 -b 50000 -r $f.FullName -o 2_Session\L7\$($f.BaseName)-L7 -y L7
            Get-ChildItem 2_Session\L7\$($f.BaseName)-L7 | ?{$_.Length -eq 0} | Remove-Item
            #>

            # For Linux
            mono ./0_Tool/SplitCap_2-1/SplitCap.exe -p 50000 -b 50000 -r $f -o ./2_Session/AllLayers/$($f.BaseName)-ALL
            Get-ChildItem ./2_Session/AllLayers/$($f.BaseName)-ALL | ?{$_.Length -eq 0} | Remove-Item
            mono ./0_Tool/SplitCap_2-1/SplitCap.exe -p 50000 -b 50000 -r $f -o ./2_Session/L7/$($f.BaseName)-L7 -y L7
            Get-ChildItem ./2_Session/L7/$($f.BaseName)-L7 | ?{$_.Length -eq 0} | Remove-Item
        }

        # Remove duplicate files
        Write-Host "[INFO] Removing duplicate files"
        # For Windows
        <#
        0_Tool\finddupe -del 2_Session\AllLayers
        0_Tool\finddupe -del 2_Session\L7
        #>

        # For Linux
        fdupes -rdN ./2_Session/AllLayers/
        fdupes -rdN ./2_Session/L7/
    
    }
    elseif ($($args[0]) -eq "-p") {
        Write-Host "[INFO] Create folder 'AllLayers_Pkts'"
        if (!(Test-Path -Path ./2_Session/AllLayers_Pkts)) {
            New-Item -Path ./2_Session/ -Name "AllLayers_Pkts" -ItemType "directory"
        }
        Write-Host "[INFO] Spliting the PCAP file into each packet"
        foreach ($f in Get-ChildItem $SOURCE_PCAP_DIR) {
            # For Linux
            if (!(Test-Path -Path ./2_Session/AllLayers_Pkts/$($f.BaseName))) {
                New-Item -Path ./2_Session/AllLayers_Pkts/ -Name $($f.BaseName) -ItemType "directory"
            }
            editcap -c 1 $f ./2_Session/AllLayers_Pkts/$($f.BaseName)/$($f.BaseName).pcap
        }

        # Remove duplicate files
        Write-Host "[INFO] Removing duplicate files"
        # For Windows
        <#
        0_Tool\finddupe -del 2_Session\AllLayers_Pkts
        #>

        # For Linux
        fdupes -rdN ./2_Session/AllLayers_Pkts/
    } 
    else {
        Write-Host "[ERROR] Wrong format of command!"
        Write-Host "[INFO] For Windows: .\1_Pcap2Session.ps1 <TYPE>"
        Write-Host "[INFO] For Linux:   pwsh 1_Pcap2Session.ps1 <TYPE>"
        Write-Host "[INFO] <TYPE>: -f (flow) | -s (session) | -p (packet)"
    }
}