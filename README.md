# FanchmWrt Builder

这个仓库从 `fanchmwrt/fanchmwrt` 的指定分支、tag 或提交构建固件。上游仓库只用于读取，不会收到任何提交或推送。

构建参数遵循 OpenWrt 官方命名：

- `target`：目标平台，例如 `ramips`、`rockchip`、`x86`
- `subtarget`：目标子平台，例如 `mt7621`、`armv8`、`64`
- `profile`：设备 profile，例如 `xiaoyu_xy-c5`、`generic`
- `architecture`：`mipsel`、`arm` 或 `x86`，用于校验 OpenWrt 解析出的 APK 架构

## 固件功能

- 跨 sysupgrade 的外置 `/overlay` 安全迁移
- 应用中心 `luci-app-fwx-app-center`
- LuCI、中文界面、TTYD 和常用磁盘/终端工具
- 首次启动刷新 APK 软件源，并把 `https://downloads.openwrt.org` 替换为 `https://mirror.nju.edu.cn/openwrt`
- 支持 mipsel、32/64 位 ARM 和 x86 架构；软件包使用新固件的依赖解析重新注册

完整内置软件包列表位于 `configs/required-packages.txt`。

## 手动构建

1. 打开 GitHub 仓库的 Actions 页面。
2. 选择 `Build FanchmWrt Firmware`。
3. 点击 `Run workflow`。
4. 输入上游提交、架构族、target、subtarget 和 profile。
5. 构建完成后下载对应 artifact。

产物包含固件、manifest、SHA256、完整 `.config`、目标信息、上游提交信息以及首次升级辅助脚本。

例如小娱 C5 使用：

```text
architecture: mipsel
target:       ramips
subtarget:    mt7621
profile:      xiaoyu_xy-c5
```

ARM64 示例：

```text
architecture: arm
target:       rockchip
subtarget:    armv8
profile:      friendlyarm_nanopi-r5c
```

## Issue 触发构建

任何人都可以在 Issues 页面选择 `Firmware build` 模板，填写上游版本、架构、target、subtarget 和 profile。模板会自动添加 `build-firmware` 标签，但此时只表示构建申请，不会启动 Actions。

仓库所有者检查参数后，给仍处于打开状态的申请添加 `approved-build` 标签才会触发编译。只有仓库所有者本人添加该标签有效；其他用户的评论、编辑或标签操作不会触发构建。运行链接和最终结果会自动回复到该 Issue。

需要重新构建时，仓库所有者先移除再重新添加 `approved-build` 标签。每次重新添加都会作为一次新的明确批准。

x86-64 示例：

```text
architecture: x86
target:       x86
subtarget:    64
profile:      generic
```

## 升级行为

构建器把标准 `sysupgrade` 的默认值改为保存 overlay 和已安装软件包清单。升级包会在首次启动时重新启用外部 `/overlay`，准备新的 upper/work，等待 extroot 生效后再恢复软件包。

旧 APK 数据库只作为迁移快照，不会直接合并到新数据库。恢复时优先使用新固件的软件源解析新依赖，其次使用缓存 APK；无法注册的第三方程序保留文件和配置，不覆盖新固件文件。

第一次从不包含 `extroot-sysupgrade` 的旧固件升级时，应在路由器上运行 artifact 中的：

```sh
sh first-extroot-sysupgrade.sh <sysupgrade.bin>
```

后续使用此构建器生成的固件时，标准 LuCI/sysupgrade 流程会自动保存迁移状态。

## 本地检查

构建器需要 Linux 构建环境：

```sh
git clone https://github.com/fanchmwrt/fanchmwrt.git source
./scripts/prepare-source.sh source
cd source
./scripts/feeds update -a
./scripts/feeds install -a
../scripts/configure.sh . ../configs/base.config ramips mt7621 xiaoyu_xy-c5 mipsel
make download -j"$(nproc)"
make -j"$(nproc)"
../scripts/verify-build.sh .
```

如果上游修改了 `sysupgrade` 或目标配置，补丁校验会直接失败，需要先审查变化再更新本仓库。
