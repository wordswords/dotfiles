#!/bin/bash -l

WORKDIR="$PWD/hpc-suite-download-temp-files"
rm -rf "$WORKDIR" || true
mkdir "$WORKDIR"
cd "$WORKDIR"

if [ "$#" -eq 3 ]
    then
      VERSION="$1"
      BUILD_NUMBER="$2"
      DISTRO="$3"
    else
      >&2 echo "Find the latest revision and build number by going to the corect warehouse build page, e.g.:"
      >&2 echo "   http://ds-bs.euhpc.arm.com/wcm/#view=Build&comp=revisions-Octopus/deliverables:ARM-Compiler-for-HPC:0.0:trunk&filter=existing&count=20"
      >&2 echo "$0 <version> <build_number> <distro>"
      >&2 echo "    where 'build' corresponds to the current tgz name of the distro package, e.g. one in: 'Ubuntu_16.04', 'SUSE_12', 'RHEL_7'."
      >&2 echo "e.g.:"
      >&2 echo "   $0 \"0.0\" \"100\" \"Ubuntu_16.04\""
      >&2 echo "   $0 \"19.1\" \"100\" \"SUSE_12\""
      >&2 echo "   $0 \"19.1\" \"100\" \"RHEL_7\""
      exit 1
fi
set -e


echo "Password:"
read -s PWD
echo "Enter your password again if prompted:"
sudo echo -n
WAREHOUSE_LINK="http://ds-bs.euhpc.arm.com/wcm/wcm/zippy?cnvr=Octopus/deliverables:ARM-Compiler-for-HPC:${VERSION}:${BUILD_NUMBER}&format=zip"
CURL_LINE="curl -u${USER}:${PWD} -o ${VERSION}-${BUILD_NUMBER}.zip ${WAREHOUSE_LINK}"
$($CURL_LINE)
unzip ./*.zip
tar xzf ./*"${DISTRO}"*
cd ./*"${DISTRO}"*
sudo ./arm*.sh -a
rm -rf ${WORKDIR}


