#!/bin/sh
#
# Get FlashPlayer Form Archive 1.0, 2014
#
# Script downloads a Flash Archive zip, unzips the archive, located the needed
# Mac OS Debug Flash Player, unzips that file and cleans up all but the Flash
# Player folder.
#
# Find specific Flash Player from the Adobe Archives:
# http://helpx.adobe.com/flash-player/kb/archived-flash-player-versions.html
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of 
# this software and associated documentation files (the "Software"), to deal in 
# the Software without restriction, including without limitation the rights to 
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
# of the Software, and to permit persons to whom the Software is furnished to do 
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.
# 
# Tested on OSX (10.9)
# 
# Copyright (c) 2014 Hays Clark
#

FP_ARCHIVE_PATH="fp_archive"
FP_ARCHIVE_ZIP="fp_archive.zip"
EXPECTED_ARG="<FlashPlayer Archile Url>"
VERSION="1.0"

if [ "$#" -gt 1 ]; then
  echo "Too many arguments."
  echo "Usage: $0 ${EXPECTED_ARG}"
  exit 1
fi

if [ "$1" = "" ]; then
	echo "Missing required argument."
	echo "Usage: $0 ${EXPECTED_ARG}"
	exit 1
fi

echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] Get FlashPlayer From Archive, ${VERSION}"
echo "[INFO] ------------------------------------------------------------------------"

# Download the archive
FP_ZIP_ARCHIVE_URL=$1
echo "[INFO] Downloading: ${FP_ZIP_ARCHIVE_URL}"
curl -L ${FP_ZIP_ARCHIVE_URL} >> ${FP_ARCHIVE_ZIP}

# Unzip archive
echo "[INFO] Unzipping to: ${FP_ARCHIVE_PATH}"
unzip ${FP_ARCHIVE_ZIP} -d ${FP_ARCHIVE_PATH}

# locate the mac_sa_debug.app.zip file and ignore any .* files
# these seem to be inconsistent, "*mac_sa_debug.app.zip" and
# "*mac_sa_debug.zip" have been notedr,
MAC_SA_DEBUG_APP_ZIP=`find . -type f \( -iname "*mac_sa_debug*.zip" ! -iname ".*" \)`
MAC_SA_DEBUG_APP_DMG=`find . -type f \( -iname "*mac_sa_debug*.dmg" ! -iname ".*" \)`
if [ "${MAC_SA_DEBUG_APP_ZIP}" = "" && "${MAC_SA_DEBUG_APP_DMG}" = "" ]; then
	echo "[ERROR] Can not find required Mac SA Debug Player."
	exit 1
fi

if [ "${MAC_SA_DEBUG_APP_ZIP}" != "" ]; then
	echo "[INFO] Found Mac SA Debug Player Zip: ${MAC_SA_DEBUG_APP_ZIP}"

	# Unzip mac_sa_debug.app.zip
	echo "[INFO] Unzipping player"
	unzip ${MAC_SA_DEBUG_APP_ZIP}

fi

if [ "${MAC_SA_DEBUG_APP_DMG}" != "" ]; then
	echo "[INFO] Found Mac SA Debug Player Dmg: ${MAC_SA_DEBUG_APP_DMG}"

	# Mount mac_sa_debug.dmg
	echo "[INFO] Mounting image"
	hdiutil mount ${MAC_SA_DEBUG_APP_DMG}
	
	# Install mac_sa_debug.dmg
	echo "[INFO] Install player"
	cp -Ra /Volumes/Flash\ Player/*.app ./Flash\ Player\ Debugger.app;
	
	# cleanup
	echo "[INFO] Unmounting image."
	hdiutil unmount "/Volumes/Flash\ Player/"
fi

# cleanup
echo "[INFO] cleaning up temp files."
rm ${FP_ARCHIVE_ZIP}
rm -r ${FP_ARCHIVE_PATH}

echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] Flash Player Downloaded and Install Success"
echo "[INFO] ------------------------------------------------------------------------"

# done
exit 0
