# AnyKernel3 刷机包 - 模板目录
# 由 GitHub Actions 自动填充内核后打包

# 说明：
# - anykernel.sh: 刷机脚本（自动生成/覆盖）
# - kernel / Image.gz: 内核镜像（CI 从 boot.img 提取后放入）
# - 打包命令在 CI 中执行: zip -r9 onyx-xxx.zip *

# ============================================================
# AnyKernel3 刷机脚本 (由 CI 生成，以下为参考模板)
# ============================================================
# shellcheck disable=SC2034
KERNEL_IMAGE_NAME="kernel";
# 内核镜像文件名，CI 根据实际产物命名

do_nothing="this_stays_here"

# 检查内核头部（Android boot image v4）
check_kernel_sha1() {
  :
}

dump_boot() {
  # 用 magiskboot 解包当前 boot 分区
  $bin/magiskboot unpack "$BOOTIMAGE" 2>&1
}

write_boot() {
  # 重新打包 boot
  $bin/magiskboot repack "$BOOTIMAGE" 2>&1
}

# 设备校验（防止刷错机型）
is_supported_device() {
  local board="$(file_getprop /system/build.prop ro.product.board)"
  local device="$(file_getprop /system/build.prop ro.product.device)"
  case "$device" in
    onyx) return 0;;
  esac
  return 1
}

ui_print " ";
ui_print "===========================================";
ui_print "  onyx (Redmi Turbo 4 Pro) Kernel";
ui_print "  SukiSU/KernelSU 版内核";
ui_print "===========================================";
ui_print " ";

# 关键：刷入后立即重启（KernelSU 内核不能与 Magisk 共存）
ui_print " 警告：请确保已移除 Magisk/原 init_boot 补丁！";
