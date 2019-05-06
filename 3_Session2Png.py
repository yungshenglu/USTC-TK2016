# AUTHOR:
#   Wei Wang (ww8137@mail.ustc.edu.cn)
# CONTRIBUTOR:
#   David Lu (yungshenglu1994@gmail.com)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file, You
# can obtain one at http://mozilla.org/MPL/2.0/.
# ==============================================================================

import numpy
from PIL import Image
import binascii
import errno    
import os
import time

''' GLOBAL PARAM '''
PNG_SIZE = 28


def getMatrixfrom_pcap(filename, width):
    with open(filename, 'rb') as f:
        content = f.read()
    
    hexst = binascii.hexlify(content)  
    fh = numpy.array([int(hexst[i : i + 2], 16) for i in range(0, len(hexst), 2)])  
    rn = len(fh) // width
    fh = numpy.reshape(fh[: rn * width], (-1, width))  
    fh = numpy.uint8(fh)
    return fh


def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


def main():
    interval = []

    # Path for Windows: paths = [['3_ProcessedSession\TrimedSession\Train', '4_Png\Train'], ['3_ProcessedSession\TrimedSession\Test', '4_Png\Test']]
    paths = [['3_ProcessedSession/TrimedSession/Train', '4_Png/Train'], ['3_ProcessedSession/TrimedSession/Test', '4_Png/Test']]
    for p in paths:
        for i, d in enumerate(os.listdir(p[0])):
            dir_full = os.path.join(p[1], str(i))
            print('[INFO] Saving image %s in: %s' % (d, dir_full))
            mkdir_p(dir_full)
            for f in os.listdir(os.path.join(p[0], d)):
                start = time.time()
                bin_full = os.path.join(p[0], d, f)
                im = Image.fromarray(getMatrixfrom_pcap(bin_full, PNG_SIZE))
                png_full = os.path.join(dir_full, os.path.splitext(f)[0] + '.png')
                im.save(png_full)
                end = time.time()
                interval.append(end - start)
    
    total = 0
    for i in interval:
        total += i
    print(total / len(interval))


''' ENTRY POINT '''
if __name__ == "__main__":
    main()