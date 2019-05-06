# AUTHOR:
#   Wei Wang (ww8137@mail.ustc.edu.cn)
# CONTRIBUTOR:
#   David Lu (yungshenglu1994@gmail.com)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file, You
# can obtain one at http://mozilla.org/MPL/2.0/.
# ==============================================================================

import os
import errno
from PIL import Image
from array import *
from random import shuffle


def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


def main():
	# Create directory "5_Mnist/"
	mkdir_p('5_Mnist')

	# Names for Windows: Names = [['4_Png\Train', '5_Mnist\\train']]
	Names = [['4_Png/Train', '5_Mnist/train']]

	for name in Names:	
		data_image = array('B')
		data_label = array('B')

		FileList = []
		for dirname in os.listdir(name[0]): 
			path = os.path.join(name[0], dirname)
			for filename in os.listdir(path):
				if filename.endswith('.png'):
					FileList.append(os.path.join(name[0], dirname, filename))

		# Useful for further segmenting the validation set
		shuffle(FileList) 

		for filename in FileList:
			# label for Windows: label = int(filename.split('\\')[2])
			label = int(filename.split('/')[2])
			Im = Image.open(filename)
			pixel = Im.load()
			width, height = Im.size
			for x in range(0, width):
				for y in range(0, height):
					data_image.append(pixel[y, x])
			# Labels start (one unsigned byte each)
			data_label.append(label)
		
		# Number of files in HEX
		hexval = '{0:#0{1}x}'.format(len(FileList), 6)
		hexval = '0x' + hexval[2 :].zfill(8)
		
		# Header for label array
		header = array('B')
		header.extend([0, 0, 8, 1])
		header.append(int('0x' + hexval[2 :][0 : 2], 16))
		header.append(int('0x' + hexval[2 :][2 : 4], 16))
		header.append(int('0x' + hexval[2 :][4 : 6], 16))
		header.append(int('0x' + hexval[2 :][6 : 8], 16))	
		data_label = header + data_label

		# Additional header for images array	
		if max([width,height]) <= 256:
			header.extend([0, 0, 0, width, 0, 0, 0, height])
		else:
			raise ValueError('[ERROR] Image exceeds maximum size: 256x256 pixels')

		# Changing MSB for image data (0x00000803)
		header[3] = 3	
		data_image = header + data_image
		output_file = open(name[1] + '-images-idx3-ubyte', 'wb')
		data_image.tofile(output_file)
		output_file.close()
		print('[INFO] Generated file: %s-images-idx3-ubyte' % name[1])
		output_file = open(name[1] + '-labels-idx1-ubyte', 'wb')
		data_label.tofile(output_file)
		output_file.close()
		print('[INFO] Generated file: %s-labels-idx1-ubyte' % name[1])

	# Compress resulting files using gzip
	for name in Names:
		os.system('gzip ' + name[1] + '-images-idx3-ubyte')
		print('[INFO] Compressed file: %s-images-idx3-ubyte.gz' % name[1])
		os.system('gzip ' + name[1] + '-labels-idx1-ubyte')
		print('[INFO] Compressed file: %s-labels-idx1-ubyte.gz' % name[1])


''' ENTRY POINT '''
if __name__ == "__main__":
	main()
