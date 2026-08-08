# FanchmWrt Builder

这是一个面向 FanchmWrt 用户的第三方固件构建项目。它从上游 `fanchmwrt/fanchmwrt` 的指定分支、tag 或提交生成固件，并加入外置 `/overlay` 升级迁移、应用中心和常用管理工具。上游仓库只用于读取，不会收到本项目的提交。

本项目生成的固件不是上游官方发布。刷写前请备份配置，确认设备型号和目标参数完全匹配，并核对产物中的 SHA256。

## 固件内容

- 跨 sysupgrade 的外置 `/overlay` 迁移与软件包恢复
- 应用中心 `luci-app-fwx-app-center`
- LuCI、中文界面和 TTYD
- `cfdisk`、`e2fsprogs`、`nano-full`、`openssh-sftp-server`
- 首次启动时把 OpenWrt 官方下载地址替换为南京大学镜像
- 支持 mipsel、32/64 位 ARM 和 x86

完整内置软件包列表位于 `configs/required-packages.txt`。

## 申请构建

1. 打开仓库的 [New Issue](https://github.com/nd002723/fanchmwrt-builder/issues/new/choose) 页面。
2. 选择 `Firmware build` 模板。
3. 填写上游版本、架构、target、subtarget 和 profile，然后提交。
4. Bot 会先使用上游 OpenWrt 的目标元数据校验 target、subtarget、profile、架构和上游版本。审核通过后，Issue 中会出现 Actions 运行链接。
5. 构建完成后，从运行页面下载 artifact，并根据设备类型选择对应的 sysupgrade 或安装镜像；构建成功后 Bot 会把申请 Issue 标记为已完成并自动关闭，失败的申请保持打开。

### 参数命名

设备参数遵循 OpenWrt 命名：

- `architecture`：选择 `mipsel`、`arm` 或 `x86`
- `target`：目标平台，例如 `ramips`、`rockchip`、`x86`
- `subtarget`：目标子平台，例如 `mt7621`、`armv8`、`64`
- `profile`：设备 profile，例如 `xiaoyu_xy-c5`、`friendlyarm_nanopi-r5c`、`generic`
- `upstream_ref`：`fanchmwrt/fanchmwrt` 中存在的分支、tag 或完整提交 SHA

`upstream_ref` 必须填写 GitHub 上显示的原始名称：

- 使用 tag 时，填写 Tags 页面中的完整标签名，例如 `fanchmwrt-25.12.4` 或 `v25.12.4`。
- 使用分支时，填写完整分支名，例如 `main` 或 `feature/test`。
- 使用提交时，填写完整的 40 位 commit SHA。
- 不要填写 GitHub 页面网址，也不要添加 `tag:`、`branch:` 或 `refs/tags/` 前缀。
- 不要省略标签自身包含的 `v`、产品名或其他前缀；名称必须完全一致。

Bot 会先把分支或 tag 解析并固定为准确的 commit SHA，再进行预检和构建。因此同名分支后来指向新提交时，会被识别为新的上游版本。

小娱 C5：

```text
upstream_ref: fanchmwrt-25.12.4
architecture: mipsel
target:       ramips
subtarget:    mt7621
profile:      xiaoyu_xy-c5
```

NanoPi R5C：

```text
upstream_ref: fanchmwrt-25.12.4
architecture: arm
target:       rockchip
subtarget:    armv8
profile:      friendlyarm_nanopi-r5c
```

x86-64：

```text
upstream_ref: fanchmwrt-25.12.4
architecture: x86
target:       x86
subtarget:    64
profile:      generic
```

如果不确定 profile，请先在上游源码的目标配置中确认设备名称。不要根据相似的产品名称猜测，错误的目标固件可能导致设备无法启动。

### 计数规则

自动构建按 UTC 日期限速：每个 GitHub 用户每天最多自动批准 1 次，全仓库每天最多自动批准 3 次；北京时间每天 08:00 进入新的 UTC 日期。

以下情况不计数：

- 模板缺少字段、字段格式错误或架构选项非法。
- 上游分支、tag 或 commit SHA 不存在。
- target、subtarget、profile 实际不存在，或者架构与目标不匹配。
- 过去 30 天内已有相同设备目标和相同上游提交的成功构建，并且原 artifact 仍可下载。Bot 会直接回复原申请和 Actions 链接。
- 申请已经超过个人或全仓库的当日限额。
- 仅编辑 Issue 或重复发表评论。

通过全部预检、没有可复用构建且被 Bot 批准的新申请会立即计数。计数后即使依赖安装、feeds、源码下载或后续编译因环境问题失败，也不会退还本次额度；这用于防止反复提交构建任务消耗 Actions。预检本身只读取上游目标元数据，不安装 feeds，也不下载软件包源码。

## 反馈问题和建议

任何 GitHub 用户都可以通过 [New Issue](https://github.com/nd002723/fanchmwrt-builder/issues/new/choose) 页面提交反馈：

- 选择 `Bug 反馈`，报告固件构建、系统升级、外置挂载或内置功能的问题。
- 选择 `功能建议`，提出设备支持、软件包、升级流程或使用体验方面的建议。

请按模板提供设备型号、固件版本、复现步骤或具体使用场景，并删除日志中的密码、Token 和公网地址。Bug 反馈和功能建议只用于讨论，不会进入自动审核或固件编译任务；需要构建固件时必须选择独立的 `Firmware build` 模板。

## 在 Fork 中构建

需要更多构建次数时，可以 Fork 本仓库并使用自己仓库的 Actions：

1. Fork `nd002723/fanchmwrt-builder`。
2. 在 Fork 的 Actions 页面启用 workflows。
3. 选择 `Build FanchmWrt Firmware`，点击 `Run workflow`。
4. 输入与 Issue 模板相同的五项参数。
5. 构建完成后在自己的 Actions 运行中下载 artifact。

这种方式的 Actions 用量和产物都归 Fork 所有者，不占用本仓库的自动构建限额。

## 构建产物

Artifact 包含固件、软件包 manifest、SHA256、完整 `.config`、目标信息、上游提交信息以及首次升级辅助脚本。构建成功不代表固件适用于名称相近的其他设备，刷写前仍需核对目标信息。

## 系统升级

使用本项目固件升级时，sysupgrade 只把 `/etc` 配置、外置 `/overlay` 的迁移状态和已安装软件包清单写入内存备份，不会把整个外置 upper 重复压缩进 `/tmp`。APK world 和软件源由新固件从 `/rom` 刷新，避免旧内核或旧基础包约束阻塞后续安装。新系统首次启动后会重新启用外置 `/overlay`，直接从旧磁盘 upper 迁移用户安装包的文件和配置，准备新的 upper/work，并在 extroot 生效后恢复软件包。

旧 APK 数据库只作为迁移快照，不会直接合并进新数据库，旧 world 也不参与自动安装。恢复清单以 sysupgrade manifest 中标记为 `overlay` 的用户包为准，并补入旧数据库中缺少标准文件清单的 retained 包。只要新版固件 manifest 已包含同名包，就以新版为准并完全跳过该旧包，不复制其旧包已登记的文件，也不重复安装。其余用户包只有在新仓库候选的 `origin` 与旧数据库完全一致，或能从保留的原 APK 缓存离线安装时，才会由 APK 注册并写回新 world。来源缺失或不同的同名包不会自动替换，无法满足的旧约束也不会进入 active world。无法重新注册的用户程序仍保留文件和配置，不覆盖新固件文件。完成软件包恢复后，迁移程序还会从旧 upper 补回新系统中不存在且不属于上述同名包的普通文件和符号链接，例如用户自行下载、未登记在包数据库内的应用核心；同名文件、父路径类型冲突、APK 状态、软件源和运行时目录会提示并跳过，恢复过程不会执行应用自带的下载或更新脚本。Package Manager 会把 retained 程序列出，并拒绝对未注册包执行普通 APK 删除操作，避免它们从页面消失或被误处理。

第一次从不包含 `extroot-sysupgrade` 的旧固件升级时，应使用 artifact 中的辅助脚本：

```sh
sh first-extroot-sysupgrade.sh <sysupgrade.bin>
```

后续在本项目生成的固件之间升级，可以使用标准 LuCI/sysupgrade 流程。没有外置 `/overlay` 时，升级按普通内部 overlay 流程进行，不会尝试恢复不存在的外部挂载。

## 本地构建

本地构建需要 Linux 环境和足够的磁盘空间：

```sh
git clone https://github.com/nd002723/fanchmwrt-builder.git
cd fanchmwrt-builder
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

如果上游修改了 sysupgrade 或目标配置，补丁校验会停止构建。这表示本项目需要先适配上游变化，不应跳过校验继续生成固件。
