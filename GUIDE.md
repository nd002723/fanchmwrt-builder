# FanchmWrt Builder 详细说明

## 项目内容

本项目读取 [`fanchmwrt/fanchmwrt`](https://github.com/fanchmwrt/fanchmwrt) 源码，并加入：

- 外置 `/overlay` 跨 sysupgrade 迁移和用户软件恢复
- 应用中心 `luci-app-fwx-app-center`
- LuCI、简体中文、TTYD 和 `luci-compat`
- `cfdisk`、`e2fsprogs`、`nano-full`、`openssh-sftp-server`
- 首次启动时将 OpenWrt 下载地址替换为南京大学镜像
- mipsel、32/64 位 ARM 和 x86 构建支持

完整必选包见 [`configs/required-packages.txt`](configs/required-packages.txt)。

设备解析固定三段，顺序不会因为任何开关而改变：

1. **上游优先**——所选 FanchmWrt 版本原生提供的 target、subtarget 和 profile 直接使用，不下载补丁仓库，也不打任何补丁。
2. **补丁仓库兜底**——只有原生缺少该 profile 时才取补丁集并应用，然后**用同一份 target 元数据重新判定**一次。补丁仓库缺失、没有对应分支、补丁打不上、打上了但仍然没有这个 profile，都算「补丁仓库也给不出」。
3. **报设备不存在**——两处都没有时按「检测不到设备」处理：编译开始前就停，申请被拒，并给出三段结论（上游没有、补丁仓库为什么不给）。这种情况不会被当作编译失败，也不会白跑一次编译。

架构不匹配、target 名写错这类请求错误不进入第二段：补丁集改不了 ABI，直接按请求错误拒绝。

设备补丁仓库按上游版本分分支：每个受支持的版本有自己的分支（`v25.12.6`、`v25.12.4`……），默认分支始终与最新版本同步。构建器会先把下拉里的 `fanchmwrt-<版本>` 换算成对应的 tag 名再去取补丁集——补丁仓库只按 tag 命名分支，不认 `fanchmwrt-` 前缀；该分支不存在时回落到默认分支，补丁集与所选版本不匹配时会说明原因并按「设备不存在」拒绝，不会静默降级去编译一个缺设备的树。仓库变量 `DEVICE_BACKPORT_REF` 可以强制指定分支，优先级最高。

补丁仓库每天检查上游新版本：新 tag 出现后，先把现有补丁集在该版本上试一遍（先严格匹配，再试与 `apply.sh` 允许范围相同的 1–3 行 fuzz，最后才尝试重锚上下文），全部能应用就同时把同名分支和默认分支推到同一提交；有补丁不适用就保持原状并让 Actions 运行标红，不会产出半成品分支。

本仓库的版本下拉也以上游为准：上游在 `manifest.json` 里声明某个维护分支需要停用时，该分支及其更早的同名分支会从选项里移除，默认值退回标签。

## 构建参数

所有参数必须使用所选上游版本中的 OpenWrt 原始命名：

- `upstream_ref`：申请模板的下拉框，默认选中最新版本的维护分支，例如 `fanchmwrt-25.12.6`；只有该版本没有维护分支时才退回同名 tag，例如 `v25.12.6`。默认不用 tag 是有原因的——tag 不含私有层，默认构建会在校验阶段因为缺 `luci-app-fwx-app-center` 失败。选项来自 `fanchmwrt/fanchmwrt` 的正式版本 tag 和维护分支，排除 `-rc` 预发布和无关 tag，按新版本在前排序；同一版本的维护分支排在它的 tag 前面，交错成 `fanchmwrt-25.12.6`、`v25.12.6`、`fanchmwrt-25.12.4`、`v25.12.4`……`.github/workflows/sync-upstream-refs.yml` 每天自动同步，上游发新版后无需改代码。
- 选 `fanchmwrt-*` 构建的是**分支 head**：内容会随时间移动，同一选择下次构建可能是另一个提交；要固定就用 `upstream_ref_override` 填 40 位 SHA。这条分支只在对应 tag 之上做增补，因此设备补丁仓库在它上面**照常可用**——补丁集仍钉在 tag 提交，`scripts/apply.sh` 先校验「所选 ref 是基线的后裔」再逐个应用。后裔不代表上下文分毫未动：私有层同样在这些 board/板级列表里加设备，少数补丁的上下文会漂一两行，所以**只有这条路径**允许 1–3 行 fuzz，日志逐条打印 `context loosened: fuzz N` 并给出汇总提示。选 `v*` 的 tag 时**不启用** fuzz，`git apply` 严格匹配，任何一个打不上就整体回滚。反过来，`v*` 的 tag 是纯上游同步点，**不含** `fwxd`、`luci-app-fwx-*` 应用中心这类私有层：要用这些功能就选 `fanchmwrt-*`，只要上游精简内容就选 `v*`。
- `upstream_ref_override`：可选。需要构建分支、其他 tag 或 40 位 commit SHA 时填写，覆盖下拉选择；留空则使用下拉版本。
- `architecture`：`mipsel`、`arm` 或 `x86`
- `target`：例如 `ramips`、`rockchip`、`x86`
- `subtarget`：例如 `mt7621`、`armv8`、`64`
- `profile`：例如 `xiaoyu_xy-c5`、`friendlyarm_nanopi-r5c`、`generic`。可按型号查 [mipsel 设备列表](docs/devices-mipsel.md) 与 [arm 设备列表](docs/devices-arm.md)；两份列表每天随上游版本自动重新生成，但只作参考，上游仓库不支持的组合仍会被审核拒绝

`upstream_ref` 和 `upstream_ref_override` 都不要填写 GitHub 网址，也不要添加 `tag:`、`branch:` 或 `refs/tags/` 前缀。tag 中原有的 `v`、产品名等前缀不能省略。分支会随上游前进，同名分支与 tag 可能指向不同提交；申请时会按解析出的提交固定，之后指向新提交会被视为不同版本。需要复现历史构建时，直接在 `upstream_ref_override` 填写 40 位 commit SHA。

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

重复构建申请会收到原 Issue 和 Actions 链接，并被自动关闭（关闭原因是已完成）；需要重新编译同一设备时新建申请，或由仓库所有者加 `approved-build` 与 `force-build` 跳过查重。新的有效申请通过自动批准后会占用额度；构建失败或取消会释放对应额度。

当全仓库自动额度均被正在运行或已经成功的构建占用时，新的有效申请会标记为 `build-queued`，排队期间不占额度。Bot 每 5 分钟以及每次构建结束后检查队列；出现失败或取消时自动启动最早的队列申请。若当天的自动额度均已成功完成，剩余队列申请会改为 `needs-owner-review`，等待仓库所有者决定是否添加 `approved-build`。

构建失败或取消的申请会打上黄色 `build-attention` 标签并保持打开，等待人工处理：看日志、改参数或由所有者加 `approved-build` 重试。重试被队列重新调度时该标签自动清除，不需要手动删。

普通用户不能自行添加 `approved-build` 标签。未自动批准的有效申请可等待额度恢复，或由仓库所有者人工批准。

标签的颜色和说明只有一份定义，在 `scripts/lib/labels.js`：四个 workflow 都从这里取，改色或改说明只需改一处，`scripts/test-labels.js` 会在 CI 里挡住写错的名字、颜色和超长说明。

## 构建产物

Artifact 包含：

- 固件镜像和 SHA256
- 软件包 manifest
- 完整构建 `.config`
- `BUILD-METADATA.txt`
刷写前必须核对 `BUILD-METADATA.txt`、设备目标和 SHA256，并根据设备选择 sysupgrade 或首次安装镜像。

## 系统升级

### 没有外置 overlay

没有配置外置 `/overlay` 时，按标准 OpenWrt sysupgrade 流程升级，不会挂载或迁移外部磁盘。

### 有外置 overlay（extroot）

外置 `/overlay` 挂在独立磁盘上，升级只写内部 `firmware` 分区，**磁盘上的一切（配置、额外安装的包、用户文件）都不会被擦除**。但升级方式要按版本区分：

**同一版本重刷**：直接用 LuCI 或标准 `sysupgrade`。

```sh
sysupgrade -T /tmp/fw.bin      # rc=0 才继续
sysupgrade -v /tmp/fw.bin
```

**跨版本升级 / 降级**：`sysupgrade` 在发起方写 flash 那一步不成立（实测 25.12.4 ↔ 25.12.6 两个方向都只重启、版本不变），必须走 mtd 整区刷写。

```sh
mtd -e firmware write /tmp/fw.bin firmware   # -e 后面必须跟分区名
echo "MTD_RC=$?"
mtd verify /tmp/fw.bin firmware              # 必须输出 Success
```

> **写完必须断电冷启动，不能软重启。** mtd 写入覆盖的 `firmware` 分区正是运行中系统读取文件的来源，`/sbin/reboot` 会当场变成 I/O 错误，`reboot` 和 `sysrq-trigger` 都会卡死在关机流程里。只有断电能让 bootloader 重新加载新分区。实测三次，无一例外。

**注意：mtd 整区刷写会重新格式化内部分区，`/etc/config/fstab` 会被重置成** `target='/mnt/sda1'` **+** `enabled='0'` **，表现为「设置全丢、外置盘不见了」。**

固件自带的 `/etc/init.d/extroot-post-upgrade`（**START=20**）会在开机时接管，顺序如下：

1. **先摘掉旧的 `extroot-sysupgrade` 状态机**（S96）并删除它留下的 `phase` 文件。该状态机一看到 fstab 里有 extroot 段就会拉起多阶段迁移并自行重启；和本脚本抢方向正是早期无限重启的根因。`START=20` 卡在 dropbear（S19）之后、旧状态机（S96）之前——早于 19 则重启发生在 SSH 就绪之前，等于自己关掉救生通道；晚于 96 则 disable 根本来不及。
2. 把挂载段改回 `target='/overlay'` + `enabled='1'`，`uuid` 和 `device '/dev/sdX'` 两种写法都认。**没有外置块设备时直接跳过**，纯内部 overlay 的设备不会被改成去挂一块不存在的盘。
3. 改过 fstab 就**自动重启一次**让 extroot 生效，重启前会读回确认真的落盘了，没落盘宁可停着也不重启。因为只有「真的改动了」才重启，它不会循环。
4. revision 变化时（即刚升级完），用 `/rom` 的 `distfeeds.list` 覆盖 overlay 里旧固件的软件源——版本号全部取自固件自身，脚本不写死任何版本；同时把 overlay 里额外安装的包并入新固件的 apk 数据库，固件已有的包采用固件的新记录，只有 overlay 独有的才保留。

需要临时关掉自动重启时：

```sh
EXTROOT_POST_UPGRADE_AUTOREBOOT=0 /etc/init.d/extroot-post-upgrade boot
# 或者持久关闭
touch /etc/extroot-post-upgrade-no-autoreboot
```

如果设备上的固件还不带这个脚本，手动恢复：

```sh
uci set fstab.@mount[0].target='/overlay'
uci set fstab.@mount[0].enabled='1'
uci commit fstab
reboot
```

**升级成功后唯一可靠的判据是 `/proc/mtd` 里 `kernel`/`rootfs` 的大小发生变化**；「重启了」「Commencing upgrade」都不算。

### 不再分发 first-extroot-sysupgrade.sh

早期版本在产物里附带 `first-extroot-sysupgrade.sh`，用于从没有 extroot 支持的旧固件做首次迁移。该脚本在升级前会把 `fstab` 里的 extroot 段置为 `enabled='0'`，而它依赖的 `sysupgrade_post_backup_hooks` 在 25.12.x 上没有任何消费者——升级一旦失败（跨版本必失败），进程被 reboot 打断，`enabled='0'` 就留在配置里，下次开机 extroot 不挂，正是「配置全丢」的来源。

它已从产物中移除，源码保留在 `assets/` 仅供回归测试。**升级请只用上面两条路径。**

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
4. 上游版本与 Issue 模板共用同一份下拉列表（默认最新版本的维护分支，该版本没有维护分支时退回其 tag，随上游自动同步）；需要分支或特定提交时填写 `upstream_ref_override`。
5. 填写其余构建参数并运行，从自己的 Actions 下载 artifact。

Actions 用量和产物归 Fork 所有者，不占用本仓库额度。

## 本地构建

需要 Linux、Git、OpenWrt 构建依赖和足够的磁盘空间：

```sh
git clone https://github.com/nd002723/fanchmwrt-builder.git
cd fanchmwrt-builder
git clone https://github.com/fanchmwrt/fanchmwrt.git source
./scripts/prepare-source.sh source
bash ./scripts/resolve-device-profile.sh source ramips mt7621 xiaoyu_xy-c5 mipsel
cd source
./scripts/feeds update -a
./scripts/feeds install -a
../scripts/configure.sh . ../configs/base.config ramips mt7621 xiaoyu_xy-c5 mipsel
make download -j"$(nproc)"
make -j"$(nproc)"
../scripts/verify-build.sh .
```

如果上游更改了 sysupgrade 或目标配置，校验可能停止构建。此时应先适配上游变化，不建议跳过校验。
