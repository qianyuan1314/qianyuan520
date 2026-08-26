#!/bin/bash
# ============================================================
# onyx (红米 Turbo4 Pro / SM8735) ReSukiSU 内核构建脚本
# 用法:
#   ./build.sh                # 源码编译 + ReSukiSU + SUSFS
#   ./build.sh --no-susfs     # 不集成 SUSFS
# ============================================================
set -e

ROOT_SOLUTION="ReSukiSU"
KERNEL_BRANCH="onyx-v-oss"
RE_SUKI_SU_BRANCH="main"
ENABLE_SUSFS="${1:-true}"
WORKDIR="$(pwd)"
KERNEL_DIR="$WORKDIR/kernel"
GH_PROXY="https://ghfast.top/"

echo "============================================="
echo " onyx 内核构建 - ReSukiSU + KPM + SUSFS"
echo "============================================="

# ---------- 1. 克隆内核源码 ----------
if [ ! -d "$KERNEL_DIR" ]; then
  echo "[1/7] 克隆小米内核源码 (branch: $KERNEL_BRANCH)"
  git clone --depth 1 -b "$KERNEL_BRANCH" \
    "${GH_PROXY}https://github.com/MiCode/Xiaomi_Kernel_OpenSource.git" "$KERNEL_DIR" \
    || git clone --depth 1 -b "$KERNEL_BRANCH" \
    "https://github.com/MiCode/Xiaomi_Kernel_OpenSource.git" "$KERNEL_DIR"
fi

# ---------- 2. 克隆 ReSukiSU ----------
echo "[2/7] 克隆 ReSukiSU (branch: $RE_SUKI_SU_BRANCH)"
[ -d "$WORKDIR/ReSukiSU" ] || \
  git clone --depth 1 -b "$RE_SUKI_SU_BRANCH" \
    "${GH_PROXY}https://github.com/ReSukiSU/ReSukiSU.git" "$WORKDIR/ReSukiSU" \
  || git clone --depth 1 -b "$RE_SUKI_SU_BRANCH" \
    "https://github.com/ReSukiSU/ReSukiSU.git" "$WORKDIR/ReSukiSU"

# ---------- 3. 克隆 SUSFS ----------
if [ "$ENABLE_SUSFS" = "true" ]; then
  echo "[3/7] 克隆 SUSFS (root 隐藏)"
  [ -d "$WORKDIR/SUSFS" ] || \
    git clone --depth 1 \
      "${GH_PROXY}https://github.com/sn-4b-1-2-3-4-5-6-7-8-9-0-1-2-3-4-5-6-7-8-9/SUSFS.git" "$WORKDIR/SUSFS" 2>/dev/null \
    || [ -d "$WORKDIR/SUSFS" ] || \
    git clone --depth 1 \
      "https://github.com/siriusqtop/SUSFS.git" "$WORKDIR/SUSFS" || true
fi

# ---------- 4. 集成 ReSukiSU ----------
echo "[4/7] 集成 ReSukiSU 到内核"
cd "$KERNEL_DIR"
cp -r "$WORKDIR/ReSukiSU" ./KernelSU
DRIVER_DIR=drivers
ln -sf ../../KernelSU/kernel "$DRIVER_DIR/kernelsu"
grep -q "kernelsu" "$DRIVER_DIR/Makefile" || \
  printf "\nobj-\$(CONFIG_KSU) += kernelsu/\n" >> "$DRIVER_DIR/Makefile"
grep -q "drivers/kernelsu/Kconfig" "$DRIVER_DIR/Kconfig" || \
  sed -i "/endmenu/i\source \"drivers/kernelsu/Kconfig\"" "$DRIVER_DIR/Kconfig"

# ---------- 5. 集成 SUSFS ----------
if [ "$ENABLE_SUSFS" = "true" ] && [ -d "$WORKDIR/SUSFS" ]; then
  echo "[5/7] 集成 SUSFS"
  cp -r "$WORKDIR/SUSFS/kernel/"* KernelSU/kernel/ 2>/dev/null || \
  cp -r "$WORKDIR/SUSFS/"* KernelSU/kernel/ 2>/dev/null || true
fi

# ---------- 6. 修改 defconfig ----------
echo "[6/7] 配置 defconfig"
DEFCONFIG=$(find arch/arm64/configs -name "*onyx*" | head -1)
[ -z "$DEFCONFIG" ] && DEFCONFIG="arch/arm64/configs/vendor/onyx_defconfig"
cat >> "$DEFCONFIG" <<'EOF'
# ReSukiSU / KernelSU
CONFIG_KSU=y
CONFIG_KSU_SUSFS=y
CONFIG_KSU_KPROBES_HOOK=y
CONFIG_KSU_DEBUG=n
CONFIG_KSU_KPM=y
CONFIG_KPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_KPROBE_EVENTS=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_MODULE_SIG=n
CONFIG_MODULE_SIG_FORCE=n
EOF

# ---------- 7. 构建 ----------
echo "[7/7] 开始构建 (build.config.msm.onyx)"
export PATH="$(ls -d $WORKDIR/toolchain/clang/linux-x86/clang-* 2>/dev/null | head -1)/bin:$PATH"
if command -v bazel >/dev/null 2>&1 || [ -f build_with_bazel.py ]; then
  ./build_with_bazel.py --config=msm.onyx 2>&1 | tee build_log.txt
else
  make ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1 \
    CROSS_COMPILE=aarch64-linux-gnu- "$(basename $DEFCONFIG)"
  make ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1 \
    CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
fi

echo "============================================="
echo " 构建完成!"
echo " 产物: $KERNEL_DIR/out (boot.img)"
echo " 下一步: 用 AK3 打包刷机"
echo "============================================="
