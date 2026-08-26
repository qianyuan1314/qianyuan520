# onyx (绾㈢背 Turbo4 Pro) ReSukiSU 鍐呮牳浜戠缂栬瘧鎸囧崡

## 姒傝堪

鏈洰褰曞寘鍚竴濂?**GitHub Actions 浜戠缂栬瘧娴佹按绾?*锛岃嚜鍔ㄤ粠灏忕背瀹樻柟鍐呮牳婧愮爜
鏋勫缓閫傞厤浣犵殑 onyx (SM8735) 鎵嬫満鐨勫唴鏍革紝闆嗘垚 **ReSukiSU + KPM/kpatch + SUSFS**锛?鏈€缁堣緭鍑?AnyKernel3 (AK3) 鍒锋満鍖?鍜?鎵撳ソ琛ヤ竵鐨?init_boot.img銆?
## 涓轰粈涔堢敤浜戠 (GitHub Actions)

- 浣犵殑鐢佃剳鏄?Windows锛屾病鏈?Linux 缂栬瘧鐜
- GitHub Actions 鎻愪緵 **鍏嶈垂 Linux 杩愯鍣?*锛?000 鍒嗛挓/鏈堬級
- 鍐呮牳缂栬瘧闇€瑕?AOSP clang 宸ュ叿閾?+ Linux锛屼簯绔嚜鍔ㄦ悶瀹?
## 鍓嶇疆鏉′欢锛堜竴娆℃€э級

1. **娉ㄥ唽 GitHub 璐﹀彿**锛屽垱寤轰竴涓┖浠撳簱锛堝 `onyx-kernel-ci`锛?2. 鎶婃湰鐩綍鐨勬枃浠朵紶涓婂幓锛坄.github/workflows/build-kernel.yml` 绛夛級
3. 纭浠撳簱 Actions 鍔熻兘宸插惎鐢?
## 浣跨敤鏂规硶

### 浜戠缂栬瘧锛堟帹鑽愶級

1. 鎵撳紑浣犵殑 GitHub 浠撳簱 鈫?鐐?**Actions** 鏍囩
2. 宸︿晶鐐?**Build onyx ReSukiSU Kernel**
3. 鐐瑰彸渚?**Run workflow** 鎸夐挳
4. 濉弬鏁帮細
   - `kernel_branch`: `onyx-v-oss`锛堥粯璁わ級
   - `resukisu_branch`: `main`
   - `enable_susfs`: `true`锛堝紑鍚?root 闅愯棌锛?   - `build_type`: `source`
5. 鐐?**Run workflow**锛岀瓑寰呯害 1-3 灏忔椂

### 涓嬭浇浜х墿

鏋勫缓瀹屾垚鍚庯紝鍦?workflow run 椤甸潰搴曢儴 **Artifacts** 鍖哄煙涓嬭浇锛?- `onyx-ReSukiSU-AK3.zip` 鈥?**AnyKernel3 鍒锋満鍖咃紙鎺ㄨ崘锛?*
- `init_boot_patched.img` 鈥?澶囬€夊埛鏈洪暅鍍?
## 鍒锋満鏂规硶

### 鏂瑰紡 A锛欰K3 鍒锋満鍖咃紙鎺ㄨ崘锛岄闄╀綆锛?
1. 鎵嬫満闇€鍏堣В閿?BL
2. **鍏堢Щ闄?Magisk**锛氬埛鍥炲師濮?init_boot
3. 涓嬭浇 `onyx-ReSukiSU-AK3.zip`
4. 杩涘叆 fastboot 鎴栫敤绗笁鏂?Recovery锛圱WRP/姗欑嫄锛夊埛鍏?AK3 鍖?5. 閲嶅惎

### 鏂瑰紡 B锛歩nit_boot.img

```bash
fastboot flash init_boot_a init_boot_patched.img
fastboot flash init_boot_b init_boot_patched.img
fastboot reboot
```

## 鍒峰悗閰嶇疆 ReSukiSU

1. 瀹夎 ReSukiSU Manager APK
2. 鎵撳紑鎺堜簣 root 鏉冮檺
3. 楠岃瘉锛歚adb shell su -c id` 搴旀樉绀?`uid=0(root)`

## SUSFS 闅愯棌閰嶇疆锛堥€傞厤鏄ョ/Momo锛?
SUSFS 宸茬紪璇戣繘鍐呮牳锛屽彲闅愯棌 root 鐥曡抗锛?- 鏄ョ / Momo / Play Integrity 妫€娴嬪伐鍏?- 閰嶅悎 ReSukiSU Manager 鍚敤 SUSFS 鍔熻兘

## 閲嶈鎻愰啋

1. **git 鍝堝笇涓€鑷存€?*锛氱紪璇戝嚭鐨勫唴鏍稿繀椤讳笌鎵嬫満褰撳墠绯荤粺鍝堝笇鍖归厤锛?   鍚﹀垯鍒峰叆浼氬崱 fastboot銆傞粯璁?`onyx-v-oss` 鍒嗘敮瀵瑰簲浣犵殑绯荤粺鐗堟湰銆?2. **Android 16 娉ㄦ剰**锛氳嫢浣犵殑鎵嬫満宸插崌绾?Android 16 HyperOS锛?   闇€纭鍐呮牳婧愮爜鍒嗘敮浠嶄负 `onyx-v-oss`锛堣嫢绯荤粺鐗堟湰鍙樻洿锛岄渶鎹㈠搴斿垎鏀級銆?3. **KSU 涓?Magisk 涓嶈兘鍏卞瓨**锛氬埛鍏ュ墠鍔″繀绉婚櫎 Magisk銆?
## 鐩綍缁撴瀯

```
onyx-kernel-ci/
鈹溾攢鈹€ .github/workflows/
鈹?  鈹斺攢鈹€ build-kernel.yml    # GitHub Actions 宸ヤ綔娴侊紙鏍稿績锛?鈹溾攢鈹€ build.sh                # 鏈湴/CI 閫氱敤鏋勫缓鑴氭湰
鈹斺攢鈹€ AK3/
    鈹斺攢鈹€ anykernel.sh        # AK3 鍒锋満鑴氭湰妯℃澘
```
