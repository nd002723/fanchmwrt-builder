# FanchmWrt Builder 详细说明

## 项目内容

本项目读取 [`fanchmwrt/fanchmwrt`](https://github.com/fanchmwrt/fanchmwrt) 源码，并加入：

- 外置 `/overlay` 跨 sysupgrade 迁移和用户软件恢复
- 应用中心 `luci-app-fwx-app-center`
- LuCI、简体中文、TTYD 和 `luci-compat`
- `cfdisk`、`e2fsprogs`、`nano-full`、`openssh-sftp-server`
- 首次启动时将 OpenWrt 下载地址替换为南京大学镜像
- mipsel、32/64 位 ARM 和 x86 构建支持

完整必选包见 [`configs/required-packages.txt`](configs/required-packages.txt)。设备能否构建取决于所选上游版本是否提供对应 target、subtarget 和 profile。

## 构建参数

所有参数必须使用所选上游版本中的 OpenWrt 原始命名：

- `upstream_ref`：上游存在的分支、完整 tag 或 40 位 commit SHA
- `architecture`：`mipsel`、`arm` 或 `x86`
- `target`：例如 `ramips`、`rockchip`、`x86`
- `subtarget`：例如 `mt7621`、`armv8`、`64`
- `profile`：例如 `xiaoyu_xy-c5`、`friendlyarm_nanopi-r5c`、`generic`

`upstream_ref` 不要填写 GitHub 网址，也不要添加 `tag:`、`branch:` 或 `refs/tags/` 前缀。tag 中原有的 `v`、产品名等前缀不能省略。分支和 tag 会在申请时固定到对应 commit；以后指向新提交时会被视为不同版本。

示例：

```text
# 小娱 C5
upstream_ref: fanchmwrt-25.12.4
architecture: mipsel
target:       ramips
subtarget:    mt7621
profile:      xiaoyu_xy-c5

# NanoPi R5C
upstream_ref: fanchmwrt-25.12.4
architecture: arm
target:       rockchip
subtarget:    armv8
profile:      friendlyarm_nanopi-r5c

# x86-64
upstream_ref: fanchmwrt-25.12.4
architecture: x86
target:       x86
subtarget:    64
profile:      generic
```

刷入错误目标的固件可能导致设备无法启动。不确定 profile 时应检查对应上游版本的目标配置。

## 自动审核和限额

Bot 会在编译前检查模板格式、上游版本、target、subtarget、profile 和架构关系。参数无效时不会编译，也不占用额度。

- 每个 GitHub 用户每天最多自动批准 1 次
- 整个仓库每天最多自动批准 3 次
- 按 UTC 日期计算，北京时间每天 08:00 重置

以下情况不计入额度：

- 模板或参数无效
- 上游分支、tag、commit 或设备目标不存在
- 目标与架构不匹配
- 已超过个人或仓库当日限额
- 编辑 Issue 或重复评论
- 30 天内已有相同设备目标和相同上游 commit 的成功构建，且 artifact 仍可下载

重复构建申请会收到原 Issue 和 Actions 链接。新的有效申请一经自动批准就会计数；之后因上游源码、feeds 或下载问题失败时不退还额度。

普通用户不能自行添加 `approved-build` 标签。未自动批准的有效申请可等待额度恢复，或由仓库所有者人工批准。

## 构建产物

Artifact 包含：

- 固件镜像和 SHA256
- 软件包 manifest
- 完整构建 `.config`
- `BUILD-METADATA.txt`
- 首次 extroot 升级脚本

刷写前必须核对 `BUILD-METADATA.txt`、设备目标和 SHA256，并根据设备选择 sysupgrade 或首次安装镜像。

## 系统升级

### 没有外置 overlay

没有配置外置 `/overlay` 时，按标准 OpenWrt sysupgrade 流程升级，不会挂载或迁移外部磁盘。

### 首次迁移 extroot

从尚未包含 `extroot-sysupgrade` 的固件升级时，将 artifact 中的辅助脚本和 sysupgrade 镜像放在路由器同一目录，然后运行：

```sh
sh first-extroot-sysupgrade.sh <sysupgrade.bin>
```

脚本会让新固件先从内部 overlay 启动，再按 UUID 挂载外盘、创建新的 upper/work，并恢复用户软件和设置。旧 upper 不会被压缩进 `/tmp`，迁移完成且软件恢复成功后，临时备份会自动删除。

已经运行本项目固件后，可使用 LuCI 或标准 `sysupgrade` 进行后续升级。

### extroot 判定和限制

- 仅支持标准 OpenWrt 单层 extroot。
- 从 `/proc/mounts` 读取当前实际挂载到 `/overlay` 的设备。
- 按 UUID 与 `/etc/config/fstab` 中 `target='/overlay'` 的 Mount Points 项唯一匹配。
- 唯一匹配项若为 `enabled='0'`，升级前会自动恢复为 `enabled='1'`。
- 应使用 UUID 配置挂载，不应依赖可能变化的 `/dev/sdX` 名称。
- 多个启用项、重复或无效 UUID、设备不匹配、设备路径无法解析以及双层 overlay 都会停止迁移。
- 内部 loop、MTD、UBI overlay 不会在没有项目设备标记时被识别为外盘。

iStoreOS 等系统可能同时使用内部和外部两个 upper。这种双层 overlay 不应直接运行首次迁移脚本，应先备份两层数据并确认 `lowerdir/upperdir/workdir` 布局。

## 软件和配置恢复

- APK 数据库、world 和软件源以新固件为准，不直接合并旧数据库。
- `distfeeds.list` 和 `customfeeds.list` 使用新固件版本，首次启动时再替换为南京大学镜像。
- 新固件已有同名包时使用新版，不复制旧包文件或重复安装。
- 其他用户包只在来源一致的仓库候选包或保留的原 APK 可用时重新注册。
- 无法重新注册的软件仍可保留文件和配置，但不会伪造 APK 数据库。
- 用户自行下载的应用核心等未登记文件会补回，但不会覆盖新固件同名文件，也不会执行第三方下载脚本。
- APK 状态目录、软件源、临时文件和运行时目录不会从旧 upper 覆盖回来。

Package Manager 会显示保留但未注册的软件，并阻止将其当作普通 APK 包卸载。

## 使用自己的 Actions

需要更多构建次数时：

1. Fork 本仓库。
2. 在 Fork 的 Actions 页面启用 workflows。
3. 打开 `Build FanchmWrt Firmware` 并选择 `Run workflow`。
4. 填写构建参数并运行。
5. 从自己的 Actions 下载 artifact。

Actions 用量和产物归 Fork 所有者，不占用本仓库额度。

## 本地构建

需要 Linux、Git、OpenWrt 构建依赖和足够的磁盘空间：

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

如果上游更改了 sysupgrade 或目标配置，校验可能停止构建。此时应先适配上游变化，不建议跳过校验。
