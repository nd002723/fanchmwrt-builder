# FanchmWrt Builder

通过 GitHub Issue 为指定 OpenWrt 设备自动构建 FanchmWrt 固件。本项目不是 FanchmWrt 官方发布，也不会向上游仓库提交内容。

刷写前请备份数据，并确认设备型号、构建目标和 SHA256 完全匹配。参数规则、审核限额、升级原理和软件恢复范围见 [详细说明](GUIDE.md)。

## 申请固件

1. 打开 [New Issue](https://github.com/nd002723/fanchmwrt-builder/issues/new/choose)。
2. 选择 `Firmware build`。
3. 填写 `upstream_ref`、`architecture`、`target`、`subtarget` 和 `profile`。
4. 提交后等待 Bot 校验。通过审核时，Bot 会回复 Actions 链接。
5. 构建成功后下载 artifact；Bot 会在 Issue 中回复结果并自动关闭。

自动额度已占满时，有效申请会进入 `build-queued` 队列且暂不计数。已有构建失败或取消后，Bot 会自动启动最早的队列申请；当天额度全部成功使用后，剩余申请改由仓库所有者审核。

常见目标：

```text
小娱 C5:    mipsel / ramips   / mt7621 / xiaoyu_xy-c5
NanoPi R5C: arm    / rockchip / armv8  / friendlyarm_nanopi-r5c
x86-64:     x86    / x86      / 64     / generic
```

目标必须使用 FanchmWrt 或本项目设备补丁支持的 OpenWrt 原始命名。不确定 profile 时请先查阅目标配置，不要按相似设备名称猜测。

## 下载和刷写

1. 下载 Actions artifact 并解压。
2. 查看 `BUILD-METADATA.txt`，核对上游提交和 `target/subtarget/profile`。
3. 核对 SHA256。
4. 根据设备选择 sysupgrade 或首次安装镜像后刷写。

## 系统升级

没有外置 `/overlay` 时，使用 LuCI 或标准 OpenWrt `sysupgrade`。

首次从其他固件迁移外置 `/overlay` 时，将 artifact 中的脚本和 sysupgrade 镜像放在路由器同一目录，然后运行：

```sh
sh first-extroot-sysupgrade.sh <sysupgrade.bin>
```

已经使用本项目固件并完成 extroot 迁移后，后续可继续使用 LuCI 或标准 `sysupgrade`。升级前必须确认外置磁盘工作正常并另外备份重要数据。

首次迁移只支持标准单层 extroot。iStoreOS 等双层 overlay 布局请勿直接执行该脚本，具体限制见 [extroot 升级说明](GUIDE.md#系统升级)。

## 反馈

在 [New Issue](https://github.com/nd002723/fanchmwrt-builder/issues/new/choose) 中选择 `Bug 反馈` 或 `功能建议`。请提供设备型号、固件版本、Actions 链接、复现步骤和必要日志，并删除密码、Token 和公网地址。

反馈模板不会触发固件编译；申请固件必须使用 `Firmware build`。

## 更多说明

- [构建参数、审核限额、升级和恢复规则](GUIDE.md)
- [固件必选软件包](configs/required-packages.txt)
