#!/usr/bin/env bash
#
# Build upstream FFmpeg on AlmaLinux 9.x or 10.x (tested through AlmaLinux 10.2).
#
# Conditional features:
#   - NVIDIA driver + CUDA Toolkit + NPP present:
#       CUDA, NVENC, NVDEC/CUVID compatibility, and NPP filters are enabled.
#   - Otherwise:
#       Builds a CPU-only FFmpeg successfully.
#
# Always includes:
#   - Fraunhofer FDK-AAC (non-free / not redistributable)
#   - dav1d, libass, libvpx, opus, MP3, Vorbis, Theora, soxr, zvbi
#
# Examples:
#   sudo ./install-ffmpeg-almalinux.sh
#   sudo JOBS="$(nproc)" ./install-ffmpeg-almalinux.sh
#   sudo CUDA_HOME=/usr/local/cuda-12.8 ./install-ffmpeg-almalinux.sh
#   sudo ENABLE_NVIDIA=0 ./install-ffmpeg-almalinux.sh
#
# Note: This builds FFmpeg with --enable-nonfree because it includes libfdk_aac.
# Do not redistribute the resulting FFmpeg binaries without reviewing licensing.

set -Eeuo pipefail

PREFIX="${PREFIX:-/opt/ffmpeg}"
SRC_ROOT="${SRC_ROOT:-/usr/local/src}"
FFMPEG_SRC="${SRC_ROOT}/ffmpeg"
NV_HEADERS_SRC="${SRC_ROOT}/nv-codec-headers"
FDK_AAC_SRC="${SRC_ROOT}/fdk-aac"

REF="${REF:-master}"
CUDA_HOME="${CUDA_HOME:-/usr/local/cuda}"
INSTALL_DEPS="${INSTALL_DEPS:-1}"
ENABLE_NVIDIA="${ENABLE_NVIDIA:-auto}"

if [[ "${EUID}" -ne 0 ]]; then
    echo "Run as root: sudo $0" >&2
    exit 1
fi

. /etc/os-release

ALMA_MAJOR="${VERSION_ID%%.*}"
if [[ "${ID:-}" != "almalinux" || ! "${ALMA_MAJOR}" =~ ^(9|10)$ ]]; then
    echo "This script targets AlmaLinux 9.x and 10.x; detected: ${PRETTY_NAME:-unknown}." >&2
    exit 1
fi

if [[ "${ALMA_MAJOR}" == "10" ]]; then
    echo "==> Detected AlmaLinux ${VERSION_ID} (supported through 10.2)."
else
    echo "==> Detected AlmaLinux ${VERSION_ID}."
fi

if [[ ! "${ENABLE_NVIDIA}" =~ ^(auto|0|1)$ ]]; then
    echo "ENABLE_NVIDIA must be auto, 0, or 1." >&2
    exit 1
fi

if [[ ! "${INSTALL_DEPS}" =~ ^(0|1)$ ]]; then
    echo "INSTALL_DEPS must be 0 or 1." >&2
    exit 1
fi

CPU_COUNT="$(nproc)"
MEM_AVAILABLE_KIB="$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)"
MEMORY_JOB_LIMIT="$(( MEM_AVAILABLE_KIB / 1048576 ))" # One GiB per build job.

if (( MEMORY_JOB_LIMIT < 1 )); then
    MEMORY_JOB_LIMIT=1
fi

if [[ -n "${JOBS:-}" ]]; then
    [[ "${JOBS}" =~ ^[1-9][0-9]*$ ]] || {
        echo "JOBS must be a positive integer." >&2
        exit 1
    }
else
    if (( CPU_COUNT < MEMORY_JOB_LIMIT )); then
        JOBS="${CPU_COUNT}"
    else
        JOBS="${MEMORY_JOB_LIMIT}"
    fi
fi

export MAKEFLAGS="-j${JOBS}"
export CMAKE_BUILD_PARALLEL_LEVEL="${JOBS}"
export MESON_NUM_PROCESSES="${JOBS}"
export NINJAFLAGS="-j${JOBS}"

trap 'echo "Build failed at line ${LINENO}." >&2' ERR

have_nvidia_gpu() {
    command -v nvidia-smi >/dev/null 2>&1 &&
    nvidia-smi --query-gpu=name --format=csv,noheader >/dev/null 2>&1
}

have_cuda_toolkit() {
    [[ -x "${CUDA_HOME}/bin/nvcc" ]] &&
    [[ -f "${CUDA_HOME}/include/cuda.h" ]] &&
    [[ -d "${CUDA_HOME}/lib64" ]]
}

have_cuda_npp() {
    local required
    for required in \
        libnppc.so \
        libnppig.so \
        libnppicc.so \
        libnppidei.so \
        libnppif.so \
        libnppist.so; do
        [[ -e "${CUDA_HOME}/lib64/${required}" ]] || return 1
    done
}

USE_NVIDIA=0
case "${ENABLE_NVIDIA}" in
    0)
        echo "==> NVIDIA support explicitly disabled."
        ;;
    1)
        have_nvidia_gpu || { echo "ENABLE_NVIDIA=1 was requested, but NVIDIA driver/GPU is unavailable." >&2; exit 1; }
        have_cuda_toolkit || { echo "ENABLE_NVIDIA=1 was requested, but CUDA Toolkit was not found in ${CUDA_HOME}." >&2; exit 1; }
        have_cuda_npp || { echo "ENABLE_NVIDIA=1 was requested, but required CUDA NPP libraries are absent." >&2; exit 1; }
        USE_NVIDIA=1
        ;;
    auto)
        if have_nvidia_gpu && have_cuda_toolkit && have_cuda_npp; then
            USE_NVIDIA=1
        fi
        ;;
esac

echo "==> FFmpeg source ref: ${REF}"
echo "==> Install prefix:     ${PREFIX}"
echo "==> Parallel jobs:      ${JOBS} (CPUs: ${CPU_COUNT}; RAM: $(( MEM_AVAILABLE_KIB / 1024 )) MiB)"
if (( USE_NVIDIA )); then
    echo "==> NVIDIA support:     enabled"
    echo "==> CUDA Toolkit:       ${CUDA_HOME}"
    nvidia-smi --query-gpu=name,driver_version --format=csv,noheader
    "${CUDA_HOME}/bin/nvcc" --version
else
    echo "==> NVIDIA support:     disabled (no usable GPU/CUDA Toolkit/NPP found)"
fi

if [[ "${INSTALL_DEPS}" == "1" ]]; then
    echo "==> Enabling CRB and EPEL"
    dnf -y install dnf-plugins-core epel-release
    dnf config-manager --set-enabled crb || true
    dnf -y makecache

    echo "==> Installing build dependencies"
    dnf -y groupinstall "Development Tools"
    dnf -y install \
        git \
        curl \
        make \
        gcc \
        gcc-c++ \
        nasm \
        yasm \
        pkgconf-pkg-config \
        autoconf \
        automake \
        libtool \
        cmake \
        meson \
        ninja-build \
        perl \
        zlib-devel \
        bzip2-devel \
        xz-devel \
        openssl-devel \
        libxml2-devel \
        libass-devel \
        freetype-devel \
        fontconfig-devel \
        fribidi-devel \
        harfbuzz-devel \
        libdav1d \
        libdav1d-devel \
        lame-devel \
        libogg-devel \
        opus-devel \
        soxr-devel \
        libtheora-devel \
        libvorbis-devel \
        libvpx-devel \
        zvbi \
        zvbi-devel
fi

echo "==> Verifying system build dependencies"
for library in \
    dav1d \
    zvbi-0.2 \
    libass \
    freetype2 \
    fribidi \
    harfbuzz \
    opus \
    soxr \
    vorbis \
    vpx \
    theora; do
    pkg-config --exists "${library}" || {
        echo "Missing pkg-config dependency: ${library}" >&2
        exit 1
    }
done

mkdir -p "${SRC_ROOT}"

clone_or_update() {
    local repository="$1"
    local destination="$2"

    if [[ -d "${destination}/.git" ]]; then
        git -C "${destination}" fetch --tags --force --prune
        git -C "${destination}" reset --hard origin/master
        git -C "${destination}" clean -ffdx
    else
        rm -rf "${destination}"
        git clone --depth 1 "${repository}" "${destination}"
    fi
}

if (( USE_NVIDIA )); then
    echo "==> Installing NVIDIA Video Codec SDK headers"
    clone_or_update "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git" "${NV_HEADERS_SRC}"
    make -C "${NV_HEADERS_SRC}" -j"${JOBS}"
    make -C "${NV_HEADERS_SRC}" PREFIX=/usr/local install
fi

echo "==> Building Fraunhofer FDK-AAC"
clone_or_update "https://github.com/mstorsjo/fdk-aac.git" "${FDK_AAC_SRC}"
cd "${FDK_AAC_SRC}"
autoreconf -fiv
./configure \
    --prefix=/usr/local \
    --libdir=/usr/local/lib64 \
    --enable-shared \
    --disable-static
make -j"${JOBS}"
make install

cat > /etc/ld.so.conf.d/local-fdk-aac.conf <<'EOF'
/usr/local/lib64
EOF
ldconfig

export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:/usr/local/lib/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"
pkg-config --exists fdk-aac || {
    echo "FDK-AAC installed but pkg-config cannot locate fdk-aac.pc." >&2
    exit 1
}
echo "==> FDK-AAC version: $(pkg-config --modversion fdk-aac)"

echo "==> Fetching FFmpeg source"
if [[ -d "${FFMPEG_SRC}/.git" ]]; then
    git -C "${FFMPEG_SRC}" fetch --tags --force --prune
else
    rm -rf "${FFMPEG_SRC}"
    git clone https://git.ffmpeg.org/ffmpeg.git "${FFMPEG_SRC}"
fi

git -C "${FFMPEG_SRC}" checkout --force "${REF}"
git -C "${FFMPEG_SRC}" reset --hard "origin/${REF}" 2>/dev/null || true
git -C "${FFMPEG_SRC}" clean -ffdx

echo "==> FFmpeg source revision"
git -C "${FFMPEG_SRC}" log -1 --format='%H%n%cs%n%s'

cd "${FFMPEG_SRC}"
make distclean >/dev/null 2>&1 || true
rm -rf "${PREFIX}"

CONFIGURE_ARGS=(
    "--prefix=${PREFIX}"
    "--bindir=${PREFIX}/bin"
    "--libdir=${PREFIX}/lib64"
    "--shlibdir=${PREFIX}/lib64"
    "--enable-gpl"
    "--enable-version3"
    "--enable-nonfree"
    "--enable-shared"
    "--disable-static"
    "--enable-pic"
    "--enable-openssl"
    "--enable-libass"
    "--enable-libdav1d"
    "--enable-libfdk-aac"
    "--enable-libfreetype"
    "--enable-libfribidi"
    "--enable-libharfbuzz"
    "--enable-libmp3lame"
    "--enable-libopus"
    "--enable-libsoxr"
    "--enable-libtheora"
    "--enable-libvorbis"
    "--enable-libvpx"
    "--enable-libzvbi"
    "--enable-runtime-cpudetect"
    "--enable-avfilter"
    "--enable-pthreads"
    "--extra-cflags=-O2 -pipe"
    "--extra-ldflags=-Wl,-rpath,${PREFIX}/lib64"
)

if (( USE_NVIDIA )); then
    export PATH="${CUDA_HOME}/bin:${PATH}"
    export LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
    CONFIGURE_ARGS+=(
        "--enable-cuda-nvcc"
        "--enable-cuvid"
        "--enable-nvdec"
        "--enable-nvenc"
        "--enable-libnpp"
        "--enable-ffnvcodec"
        "--extra-cflags=-I${CUDA_HOME}/include"
        "--extra-ldflags=-L${CUDA_HOME}/lib64"
        "--extra-ldflags=-Wl,-rpath,${CUDA_HOME}/lib64"
    )
fi

echo "==> Configuring FFmpeg"
printf '    %q' ./configure "${CONFIGURE_ARGS[@]}"
printf '\n'
./configure "${CONFIGURE_ARGS[@]}"

echo "==> Building FFmpeg with ${JOBS} job(s)"
make -j"${JOBS}"

echo "==> Installing FFmpeg"
make install

{
    echo "${PREFIX}/lib64"
    echo "/usr/local/lib64"
    if (( USE_NVIDIA )); then
        echo "${CUDA_HOME}/lib64"
    fi
} > /etc/ld.so.conf.d/ffmpeg-local.conf
ldconfig

ln -sfn "${PREFIX}/bin/ffmpeg" /usr/local/bin/ffmpeg
ln -sfn "${PREFIX}/bin/ffprobe" /usr/local/bin/ffprobe
if [[ -x "${PREFIX}/bin/ffplay" ]]; then
    ln -sfn "${PREFIX}/bin/ffplay" /usr/local/bin/ffplay
fi
hash -r

echo
echo "==> Build complete"
/usr/local/bin/ffmpeg -hide_banner -version

echo
echo "==> FDK-AAC encoder"
/usr/local/bin/ffmpeg -hide_banner -encoders | grep -F libfdk_aac || true

if (( USE_NVIDIA )); then
    echo
echo "==> NVIDIA encoders"
    /usr/local/bin/ffmpeg -hide_banner -encoders | grep -E 'h264_nvenc|hevc_nvenc|av1_nvenc' || true
    echo
echo "==> NVIDIA decoders"
    /usr/local/bin/ffmpeg -hide_banner -decoders | grep -E '_cuvid|nvdec' || true
    echo
echo "==> CUDA / NPP filters"
    /usr/local/bin/ffmpeg -hide_banner -filters | grep -E 'cuda|npp' || true
else
    echo
echo "==> Built without NVIDIA support."
fi

