# FanchmWrt Builder

通过 GitHub Issue 为指定 OpenWrt 设备自动构建 FanchmWrt 固件。本项目不是 FanchmWrt 官方发布，也不会向上游仓库提交内容。

刷写前请备份数据，并确认设备型号、构建目标和 SHA256 完全匹配。参数规则、审核限额、升级原理和软件恢复范围见 [详细说明](GUIDE.md)。

## 申请固件

1. 打开 [New Issue](https://github.com/nd002723/fanchmwrt-builder/issues/new/choose)。
2. 选择 `Firmware build`。
3. 在 `Upstream ref` 下拉框中选择要构建的上游版本（默认选中最新版本的维护分支 `fanchmwrt-*`，该版本没有维护分支时才退回同名 tag；选项由 Actions 每天同步，并随上游声明停用过期的维护分支），再填写 `architecture`、`target`、`subtarget` 和 `profile`。需要指定分支、其他 tag 或 40 位 commit SHA 时填写 `Upstream ref override`，留空则使用下拉选择。
4. 提交后等待 Bot 校验。通过审核时，Bot 会回复 Actions 链接。
5. 构建成功后下载 artifact；Bot 会在 Issue 中回复结果并自动关闭。构建失败或取消时 Issue 保持打开并打上黄色 `build-attention` 标签，方便之后回来查。

自动额度已占满时，有效申请会进入 `build-queued` 队列且暂不计数。已有构建失败或取消后，Bot 会自动启动最早的队列申请；当天额度全部成功使用后，剩余申请改由仓库所有者审核。重复申请会直接给出既有产物链接并关闭，不占用额度。

示例：

```text
# 小娱 C5
upstream_ref: fanchmwrt-25.12.6
architecture: mipsel
target:       ramips
subtarget:    mt7621
profile:      xiaoyu_xy-c5

# NanoPi R5C
upstream_ref: fanchmwrt-25.12.6
architecture: arm
target:       rockchip
subtarget:    armv8
profile:      friendlyarm_nanopi-r5c

# x86-64
upstream_ref: fanchmwrt-25.12.6
architecture: x86
target:       x86
subtarget:    64
profile:      generic
```

目标必须使用 FanchmWrt 或本项目设备补丁支持的 OpenWrt 原始命名。

设备解析上游优先：上游原生有该设备就直接用，不碰补丁仓库；上游没有才取设备补丁仓库并重新判定；两处都没有就按「检测不到设备」在编译前拒绝，不会白跑一次编译。

不确定 profile 时先按型号查设备列表：

- [mipsel 设备列表（仅供参考）](docs/devices-mipsel.md)
- [arm 设备列表（仅供参考）](docs/devices-arm.md)

两份列表按 `target` / `subtarget` 分组，型号按字母和数字顺序排列，并标出常用名与扩展设备仓库的型号。它们由 Actions 每天随上游版本自动重新生成，只作参考，权威来源仍是上游仓库：上游不支持的组合会在审核阶段被拒绝。x86 只有一个可构建型号 `x86/64/generic`，不单独成文。

不要按相似设备名称猜测 profile。

## 下载和刷写

1. 下载 Actions artifact 并解压。
2. 查看 `BUILD-METADATA.txt`，核对上游提交和 `target/subtarget/profile` 是否是你的设备。
3. 核对 `sha256sums`。
4. 选镜像：
   - **`*-squashfs-sysupgrade.bin`**：已经有 OpenWrt 类系统时用这个（升级或重装）。
   - **`*-initramfs-kernel.bin`**：设备原厂固件、或系统已刷坏时用这个从 U-Boot / 恢复模式引导。
   - **`*-squashfs-factory.bin`**：仅部分设备提供，用于首次从原厂固件刷入。

刷写前务必确认设备型号、构建目标和 SHA256 三者都匹配。型号刷错会变砖，且这个工具无法保证你的设备一定在支持范围内。

**首次从原厂固件刷入**（设备原本不是 OpenWrt 系）通常需要厂商的升级页面或 U-Boot 恢复模式，具体步骤取决于设备型号，不在本项目覆盖范围。

## 系统升级

没有外置 `/overlay` 时，使用 LuCI 或标准 OpenWrt `sysupgrade`。

配置了外置 `/overlay`（extroot）时，配置和额外安装的包都在外盘上，升级只写内部 `firmware` 分区，不会丢。升级方式按版本区分：

- **同版本重刷**：LuCI 或 `sysupgrade -v /tmp/fw.bin`。
- **跨版本 / 降级**：`sysupgrade` 不成立（实测 25.12.4 ↔ 25.12.6 双向都只重启），改用 mtd 整区刷写：

```sh
scp openwrt-...-squashfs-sysupgrade.bin root@<设备IP>:/tmp/fw.bin
ssh root@<设备IP>
md5sum /tmp/fw.bin                          # 必须与发布值一致
mtd -e firmware write /tmp/fw.bin firmware  # -e 后面必须跟分区名
echo "MTD_RC=$?"                            # 必须是 0
mtd verify /tmp/fw.bin firmware             # 必须是 Success
```

> **写完必须断电冷启动，不能软重启。** mtd 写入覆盖的内部 `firmware` 分区正是运行中系统读取文件的来源，`/sbin/reboot` 当场变成 I/O 错误，`reboot` 和 `sysrq-trigger` 都会卡死。只有断电能让 bootloader 重新加载新分区。

断电上电后，固件自带的 `/etc/init.d/extroot-post-upgrade` 自动完成后续工作：

- 把被重置的 `fstab` 改回 `target='/overlay'`（**没插外置盘时完全不碰**，纯内部 overlay 不受影响）
- 把外盘 overlay 里额外安装的包并入新固件的 apk 数据库
- 把软件源更新为当前固件自带的版本
- 需要时自动重启一次让 extroot 生效，之后不再重启

整个过程不需要联网，也不需要人工介入。升级前仍建议确认外置磁盘工作正常，并另外备份重要数据。

## 反馈

在 [New Issue](https://github.com/nd002723/fanchmwrt-builder/issues/new/choose) 中选择 `Bug 反馈` 或 `功能建议`。请提供设备型号、固件版本、Actions 链接、复现步骤和必要日志，并删除密码、Token 和公网地址。

反馈模板不会触发固件编译；申请固件必须使用 `Firmware build`。

## 更多说明

- [构建参数、审核限额、升级和恢复规则](GUIDE.md)
- [固件必选软件包](configs/required-packages.txt)
