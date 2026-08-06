# FanchmWrt Builder

这个仓库从 `fanchmwrt/fanchmwrt` 的指定分支、tag 或提交构建小娱 XY-C5 固件。上游仓库只用于读取，不会收到任何提交或推送。

## 固件内容

- 小娱 XY-C5：`ramips/mt7621/xiaoyu_xy-c5`
- 经过实机验证的外置 `/overlay` 升级迁移逻辑
- 应用中心 `luci-app-fwx-app-center`
- LuCI、中文界面、TTYD 和常用磁盘/终端工具
- 首次启动刷新 APK 软件源，并把 `https://downloads.openwrt.org` 替换为 `https://mirror.nju.edu.cn/openwrt`

完整的内置软件包列表位于 `configs/required-packages.txt`。

## 手动构建

1. 打开 GitHub 仓库的 Actions 页面。
2. 选择 `Build FanchmWrt Firmware`。
3. 点击 `Run workflow`。
4. 输入上游分支、tag 或完整提交 SHA。
5. 构建完成后下载 `xiaoyu-xy-c5-*` artifact。

产物包含固件、manifest、SHA256、完整 `.config`、上游提交信息以及首次升级辅助脚本。

## 升级行为

构建器把标准 `sysupgrade` 的默认值改为保存 overlay 和已安装软件包清单。升级包会在首次启动时重新启用外部 `/overlay`，准备新的 upper/work，等待 extroot 生效后再恢复软件包。

旧 APK 数据库只作为迁移快照，不会直接合并到新数据库。恢复时优先使用新固件的软件源解析新依赖，其次使用缓存 APK；无法注册的第三方程序保留文件和配置，不覆盖新固件文件。

第一次从不包含 `extroot-sysupgrade` 的旧固件升级时，应在路由器上运行 artifact 中的：

```sh
sh first-extroot-sysupgrade.sh <sysupgrade.bin>
```

后续使用此构建器生成的固件时，标准 LuCI/sysupgrade 流程会自动保存迁移状态。

## 本地检查

构建器只支持 Linux 构建环境：

```sh
git clone https://github.com/fanchmwrt/fanchmwrt.git source
./scripts/prepare-source.sh source
cd source
./scripts/feeds update -a
./scripts/feeds install -a
../scripts/configure.sh . ../configs/xiaoyu-xy-c5.config
make download -j"$(nproc)"
make -j"$(nproc)"
../scripts/verify-build.sh .
```

如果上游修改了 `sysupgrade` 或目标配置，补丁校验会直接失败，需要先审查变化再更新本仓库。
