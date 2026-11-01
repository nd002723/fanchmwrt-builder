# mipsel 设备列表（FanchmWrt v25.12.6）

用于 `Firmware build` 申请的 `target` / `subtarget` / `profile` 三个字段，`architecture` 选 `mipsel`。

- 枚举到 **792** 个 profile，仅供参考：上游仓库 778，扩展设备仓库 14
- 已标注常用名：**96**，其余保留上游原名
- 涉及 target/subtarget：9 组
- 排序：按设备型号字母/数字顺序（a–z、0–9），常用名不参与排序
- 权威来源是上游仓库：扩展仓库与上游重合时，一律以上游仓库的版本为准
- 本表由 `.github/workflows/sync-upstream-refs.yml` 每天随上游版本自动重新生成，无需手工维护

## 数据来源

- 上游型号：`fanchmwrt/fanchmwrt` 标签 `v25.12.6`，由 `scripts/dump-target-info.pl devices` 枚举，是本表的权威来源
- 扩展型号：`nd002723/fanchmwrt-device-backports`（55 个补丁，基线提交 `64900e756efa667774214f9c6b17c113222e01f7`），仅作补充参考

  两处可能重合，合并时以上游仓库为准：上游已有同名 profile 时，本条只按上游记录，不按扩展计入。

  扩展型号直接选 `upstream_ref: fanchmwrt-25.12.6` 即可：补丁集按版本分分支（`v25.12.6`、`v25.12.4`……，默认分支指向最新版本），基线提交是 `64900e756efa667774214f9c6b17c113222e01f7`，构建器会按所选版本自动取同名分支。所选版本没有同名分支时回落到默认分支，此时基线提交与所选版本不符，编译前会明确报错而不是静默降级——这种情况下请把 `upstream_ref_override` 填成上面的基线提交。只是列出未必可用，提交前请先按上方参数试一次。

  纯 `v25.12.6` 标签不含私有层（`fwxd`、`luci-app-fwx-*` 应用中心），用带 `fanchmwrt-` 前缀的维护分支才能通过构建校验。

- x86 只有一个可构建型号 `x86/64/generic`，不单独成文。

## 填写范例

```text
upstream_ref: fanchmwrt-25.12.6
architecture: mipsel
target:       ramips
subtarget:    mt7621
profile:      xiaoyu_xy-c5
```

扩展型号的填法与原生型号相同：直接在下拉里选对应版本即可，不用填 override。
补丁集按版本分分支（`v25.12.6`、`v25.12.4`……，默认分支指向最新），基线提交与所选版本不符时会在编译前明确报错。

## 按 target/subtarget 统计

| target | subtarget | 设备数 |
| --- | --- | --- |
| bcm47xx | generic | 7 |
| bcm47xx | legacy | 33 |
| bcm47xx | mips74k | 55 |
| pistachio | generic | 1 |
| ramips | mt7620 | 141 |
| ramips | mt7621 | 298 |
| ramips | mt76x8 | 138 |
| ramips | rt305x | 108 |
| ramips | rt3883 | 11 |

## 设备列表

| 常用名 | 设备型号 | target | subtarget | profile | 来源 |
| --- | --- | --- | --- | --- | --- |
| Accton WR6202 | Accton WR6202 | ramips | rt305x | `accton_wr6202` | 原生 |
| ADSLR G7 | ADSLR G7 | ramips | mt7621 | `adslr_g7` | 原生 |
| AFOUNDRY EW1200 | AFOUNDRY EW1200 | ramips | mt7621 | `afoundry_ew1200` | 原生 |
| Aigale Ai-BR100 | Aigale Ai-BR100 | ramips | mt7620 | `aigale_ai-br100` | 原生 |
| AirLive Air3GII | AirLive Air3GII | ramips | rt305x | `airlive_air3gii` | 原生 |
| ALFA Network AC1200RM | ALFA Network AC1200RM | ramips | mt7620 | `alfa-network_ac1200rm` | 原生 |
| ALFA Network AWUSFREE1 | ALFA Network AWUSFREE1 | ramips | mt76x8 | `alfa-network_awusfree1` | 原生 |
| ALFA Network AX1800RM | ALFA Network AX1800RM | ramips | mt7621 | `alfa-network_ax1800rm` | 原生 |
| ALFA Network Quad-E4G | ALFA Network Quad-E4G | ramips | mt7621 | `alfa-network_quad-e4g` | 原生 |
| ALFA Network R36M-E4G | ALFA Network R36M-E4G | ramips | mt7620 | `alfa-network_r36m-e4g` | 原生 |
| ALFA Network Tube-E4G | ALFA Network Tube-E4G | ramips | mt7620 | `alfa-network_tube-e4g` | 原生 |
| ALFA Networks W502U | ALFA Networks W502U | ramips | rt305x | `alfa-network_w502u` | 原生 |
| Allnet ALL0256N 4M | Allnet ALL0256N 4M | ramips | rt305x | `allnet_all0256n-4m` | 原生 |
| Allnet ALL0256N 8M | Allnet ALL0256N 8M | ramips | rt305x | `allnet_all0256n-8m` | 原生 |
| Allnet ALL5002 | Allnet ALL5002 | ramips | rt305x | `allnet_all5002` | 原生 |
| Allnet ALL5003 | Allnet ALL5003 | ramips | rt305x | `allnet_all5003` | 原生 |
| Alpha ASL26555 | Alpha ASL26555 | ramips | rt305x | `alphanetworks_asl26555-8m` | 原生 |
| Alpha ASL26555 16M | Alpha ASL26555 16M | ramips | rt305x | `alphanetworks_asl26555-16m` | 原生 |
| Amped Wireless ALLY-00X19K | Amped Wireless ALLY-00X19K | ramips | mt7621 | `ampedwireless_ally-00x19k` | 原生 |
| Amped Wireless ALLY-R1900K | Amped Wireless ALLY-R1900K | ramips | mt7621 | `ampedwireless_ally-r1900k` | 原生 |
| Amped Wireless B1200EX | Amped Wireless B1200EX | ramips | mt7620 | `ampedwireless_b1200ex` | 原生 |
| ARC Wireless FreeStation | ARC Wireless FreeStation | ramips | rt305x | `arcwireless_freestation5` | 原生 |
| Arcadyan WE410443 | Arcadyan WE410443 | ramips | mt7621 | `arcadyan_we410443` | 原生 |
| Arcadyan WE420223-99 / KPN Experia WiFi | Arcadyan WE420223-99 / KPN Experia WiFi | ramips | mt7621 | `arcadyan_we420223-99` | 原生 |
| Argus ATP-52B | Argus ATP-52B | ramips | rt305x | `argus_atp-52b` | 原生 |
| AsiaRF AP7621-001 | AsiaRF AP7621-001 | ramips | mt7621 | `asiarf_ap7621-001` | 原生 |
| AsiaRF AP7621-004 v3 | AsiaRF AP7621-004 v3 | ramips | mt7621 | `asiarf_ap7621-004-v3` | 原生 |
| AsiaRF AP7621-NV1 | AsiaRF AP7621-NV1 | ramips | mt7621 | `asiarf_ap7621-nv1` | 原生 |
| AsiaRF AWAPN2403 | AsiaRF AWAPN2403 | ramips | rt305x | `asiarf_awapn2403` | 原生 |
| AsiaRF AWM002-EVB 4M | AsiaRF AWM002-EVB 4M | ramips | rt305x | `asiarf_awm002-evb-4m` | 原生 |
| AsiaRF AWM002-EVB/AWM003-EVB 8M | AsiaRF AWM002-EVB/AWM003-EVB 8M | ramips | rt305x | `asiarf_awm002-evb-8m` | 原生 |
| ASUS 4G-AX56 | ASUS 4G-AX56 | ramips | mt7621 | `asus_4g-ax56` | 原生 |
| ASUS RP-AC56 | ASUS RP-AC56 | ramips | mt7621 | `asus_rp-ac56` | 原生 |
| ASUS RP-AC87 | ASUS RP-AC87 | ramips | mt7621 | `asus_rp-ac87` | 原生 |
| ASUS RP-N53 | ASUS RP-N53 | ramips | mt7620 | `asus_rp-n53` | 原生 |
| ASUS RT-AC51U | ASUS RT-AC51U | ramips | mt7620 | `asus_rt-ac51u` | 原生 |
| ASUS RT-AC53U | ASUS RT-AC53U | bcm47xx | mips74k | `asus_rt-ac53u` | 原生 |
| ASUS RT-AC54U | ASUS RT-AC54U | ramips | mt7620 | `asus_rt-ac54u` | 原生 |
| ASUS RT-AC57U v1 / ASUS RT-AC1200GU | ASUS RT-AC57U v1 / ASUS RT-AC1200GU | ramips | mt7621 | `asus_rt-ac57u-v1` | 原生 |
| ASUS RT-AC65P | ASUS RT-AC65P | ramips | mt7621 | `asus_rt-ac65p` | 原生 |
| ASUS RT-AC66U | ASUS RT-AC66U | bcm47xx | mips74k | `asus_rt-ac66u` | 原生 |
| ASUS RT-AC85P | ASUS RT-AC85P | ramips | mt7621 | `asus_rt-ac85p` | 原生 |
| ASUS RT-AC85U | ASUS RT-AC85U | ramips | mt7621 | `asus_rt-ac85u` | 扩展 |
| ASUS RT-AC1200 / ASUS RT-N600 | ASUS RT-AC1200 / ASUS RT-N600 | ramips | mt76x8 | `asus_rt-ac1200` | 原生 |
| ASUS RT-AC1200 V2 / ASUS RT-AC750L | ASUS RT-AC1200 V2 / ASUS RT-AC750L | ramips | mt76x8 | `asus_rt-ac1200-v2` | 原生 |
| ASUS RT-AX53U / ASUS RT-AX1800U | ASUS RT-AX53U / ASUS RT-AX1800U | ramips | mt7621 | `asus_rt-ax53u` | 原生 |
| ASUS RT-AX54 / ASUS RT-AX1800HP / ASUS RT-AX1800S / ASUS RT-AX54HP | ASUS RT-AX54 / ASUS RT-AX1800HP / ASUS RT-AX1800S / ASUS RT-AX54HP | ramips | mt7621 | `asus_rt-ax54` | 原生 |
| ASUS RT-G32 B1 | ASUS RT-G32 B1 | ramips | rt305x | `asus_rt-g32-b1` | 原生 |
| ASUS RT-N10 | ASUS RT-N10 | bcm47xx | mips74k | `asus_rt-n10` | 原生 |
| ASUS RT-N10+ | ASUS RT-N10+ | ramips | rt305x | `asus_rt-n10-plus` | 原生 |
| ASUS RT-N10P v1 | ASUS RT-N10P v1 | bcm47xx | mips74k | `asus_rt-n10p` | 原生 |
| ASUS RT-N10P v2 | ASUS RT-N10P v2 | bcm47xx | mips74k | `asus_rt-n10p-v2` | 原生 |
| ASUS RT-N10P V3 | ASUS RT-N10P V3 | ramips | mt76x8 | `asus_rt-n10p-v3` | 原生 |
| ASUS RT-N10U A | ASUS RT-N10U A | bcm47xx | mips74k | `asus_rt-n10u` | 原生 |
| ASUS RT-N10U B | ASUS RT-N10U B | bcm47xx | mips74k | `asus_rt-n10u-b` | 原生 |
| ASUS RT-N11P B1 / ASUS RT-N12+ B1 / ASUS RT-N300 B1 | ASUS RT-N11P B1 / ASUS RT-N12+ B1 / ASUS RT-N300 B1 | ramips | mt76x8 | `asus_rt-n11p-b1` | 原生 |
| ASUS RT-N11P/RT-N12+/RT-N12Eb1 | ASUS RT-N11P/RT-N12+/RT-N12Eb1 | ramips | mt7620 | `asus_rt-n12p` | 原生 |
| ASUS RT-N12 A1 | ASUS RT-N12 A1 | bcm47xx | mips74k | `asus_rt-n12` | 原生 |
| ASUS RT-N12 B1 | ASUS RT-N12 B1 | bcm47xx | mips74k | `asus_rt-n12-b1` | 原生 |
| ASUS RT-N12 C1 | ASUS RT-N12 C1 | bcm47xx | mips74k | `asus_rt-n12-c1` | 原生 |
| ASUS RT-N12 D1 | ASUS RT-N12 D1 | bcm47xx | mips74k | `asus_rt-n12-d1` | 原生 |
| ASUS RT-N12 VP B1 | ASUS RT-N12 VP B1 | ramips | mt76x8 | `asus_rt-n12-vp-b1` | 原生 |
| ASUS RT-N12HP | ASUS RT-N12HP | bcm47xx | mips74k | `asus_rt-n12hp` | 原生 |
| ASUS RT-N13U | ASUS RT-N13U | ramips | rt305x | `asus_rt-n13u` | 原生 |
| ASUS RT-N14u | ASUS RT-N14u | ramips | mt7620 | `asus_rt-n14u` | 原生 |
| ASUS RT-N14UHP | ASUS RT-N14UHP | bcm47xx | mips74k | `asus_rt-n14uhp` | 原生 |
| ASUS RT-N15U | ASUS RT-N15U | bcm47xx | mips74k | `asus_rt-n15u` | 原生 |
| ASUS RT-N16 | ASUS RT-N16 | bcm47xx | mips74k | `asus_rt-n16` | 原生 |
| ASUS RT-N53 | ASUS RT-N53 | bcm47xx | mips74k | `asus_rt-n53` | 原生 |
| ASUS RT-N56U | ASUS RT-N56U | ramips | rt3883 | `asus_rt-n56u` | 原生 |
| ASUS RT-N56U B1 | ASUS RT-N56U B1 | ramips | mt7621 | `asus_rt-n56u-b1` | 原生 |
| ASUS RT-N66U | ASUS RT-N66U | bcm47xx | mips74k | `asus_rt-n66u` | 原生 |
| ASUS RT-N66W | ASUS RT-N66W | bcm47xx | mips74k | `asus_rt-n66w` | 原生 |
| ASUS WL-300g | ASUS WL-300g | bcm47xx | legacy | `asus_wl-300g` | 原生 |
| ASUS WL-320gP | ASUS WL-320gP | bcm47xx | legacy | `asus_wl-320gp` | 原生 |
| ASUS WL-330gE | ASUS WL-330gE | bcm47xx | legacy | `asus_wl-330ge` | 原生 |
| ASUS WL-330N | ASUS WL-330N | ramips | rt305x | `asus_wl-330n` | 原生 |
| ASUS WL-330N3G | ASUS WL-330N3G | ramips | rt305x | `asus_wl-330n3g` | 原生 |
| ASUS WL-500g Deluxe | ASUS WL-500g Deluxe | bcm47xx | legacy | `asus_wl-500gd` | 原生 |
| ASUS WL-500gP v1 | ASUS WL-500gP v1 | bcm47xx | legacy | `asus_wl-500gp-v1` | 原生 |
| ASUS WL-500gP v2 | ASUS WL-500gP v2 | bcm47xx | legacy | `asus_wl-500gp-v2` | 原生 |
| ASUS WL-500W | ASUS WL-500W | bcm47xx | legacy | `asus_wl-500w` | 原生 |
| ASUS WL-520gU | ASUS WL-520gU | bcm47xx | legacy | `asus_wl-520gu` | 原生 |
| ASUS WL-550gE | ASUS WL-550gE | bcm47xx | legacy | `asus_wl-550ge` | 原生 |
| ASUS WL-HDD25 | ASUS WL-HDD25 | bcm47xx | legacy | `asus_wl-hdd25` | 原生 |
| AXIMCom MR-102N | AXIMCom MR-102N | ramips | rt305x | `aximcom_mr-102n` | 原生 |
| Aztech HW550-3G / Allnet ALL0239-3G | Aztech HW550-3G / Allnet ALL0239-3G | ramips | rt305x | `aztech_hw550-3g` | 原生 |
| BDCOM WAP2100-SK (ZTE ZXECS EBG3130) | BDCOM WAP2100-SK (ZTE ZXECS EBG3130) | ramips | mt7620 | `bdcom_wap2100-sk` | 原生 |
| Beeline SmartBox Flash | Beeline SmartBox Flash | ramips | mt7621 | `beeline_smartbox-flash` | 原生 |
| Beeline SmartBox GIGA | Beeline SmartBox GIGA | ramips | mt7621 | `beeline_smartbox-giga` | 原生 |
| Beeline SmartBox PRO / Sercomm S1500 AWI | Beeline SmartBox PRO / Sercomm S1500 AWI | ramips | mt7621 | `beeline_smartbox-pro` | 原生 |
| Beeline SmartBox TURBO | Beeline SmartBox TURBO | ramips | mt7621 | `beeline_smartbox-turbo` | 原生 |
| Beeline SmartBox TURBO+ | Beeline SmartBox TURBO+ | ramips | mt7621 | `beeline_smartbox-turbo-plus` | 原生 |
| Belkin F5D8235 v2 | Belkin F5D8235 v2 | ramips | rt305x | `belkin_f5d8235-v2` | 原生 |
| Belkin F7C027 | Belkin F7C027 | ramips | rt305x | `belkin_f7c027` | 原生 |
| Belkin F9K1109 Version 1.0 | Belkin F9K1109 Version 1.0 | ramips | rt3883 | `belkin_f9k1109v1` | 原生 |
| Belkin RT1800 | Belkin RT1800 | ramips | mt7621 | `belkin_rt1800` | 原生 |
| BOLT Arion | BOLT Arion | ramips | mt7621 | `bolt_arion` | 原生 |
| Bolt BL100 | Bolt BL100 | ramips | mt7620 | `bolt_bl100` | 原生 |
| Buffalo WCR-1166DS | Buffalo WCR-1166DS | ramips | mt76x8 | `buffalo_wcr-1166ds` | 原生 |
| Buffalo WHR-300HP2 | Buffalo WHR-300HP2 | ramips | mt7620 | `buffalo_whr-300hp2` | 原生 |
| Buffalo WHR-600D | Buffalo WHR-600D | ramips | mt7620 | `buffalo_whr-600d` | 原生 |
| Buffalo WHR-1166D | Buffalo WHR-1166D | ramips | mt7620 | `buffalo_whr-1166d` | 原生 |
| Buffalo WHR-G300N | Buffalo WHR-G300N | ramips | rt305x | `buffalo_whr-g300n` | 原生 |
| Buffalo WMR-300 | Buffalo WMR-300 | ramips | mt7620 | `buffalo_wmr-300` | 原生 |
| Buffalo WSR-600DHP | Buffalo WSR-600DHP | ramips | mt7621 | `buffalo_wsr-600dhp` | 原生 |
| Buffalo WSR-1166DHP | Buffalo WSR-1166DHP | ramips | mt7621 | `buffalo_wsr-1166dhp` | 原生 |
| Buffalo WSR-2533DHPL2 | Buffalo WSR-2533DHPL2 | ramips | mt7621 | `buffalo_wsr-2533dhpl2` | 原生 |
| Buffalo WSR-2533DHPL / Buffalo WSR-2533DHP | Buffalo WSR-2533DHPL / Buffalo WSR-2533DHP | ramips | mt7621 | `buffalo_wsr-2533dhpl` | 原生 |
| Buffalo WSR-2533DHPLS | Buffalo WSR-2533DHPLS | ramips | mt7621 | `buffalo_wsr-2533dhpls` | 原生 |
| COMFAST CF-E390AX | COMFAST CF-E390AX | ramips | mt7621 | `comfast_cf-e390ax` | 原生 |
| COMFAST CF-EW72 V2 | COMFAST CF-EW72 V2 | ramips | mt7621 | `comfast_cf-ew72-v2` | 原生 |
| COMFAST CF-EW84 / NEWFAST NF-A882 | COMFAST CF-EW84 / NEWFAST NF-A882 | ramips | mt7621 | `comfast_cf-ew84` | 扩展 |
| COMFAST CF-WR617AC | COMFAST CF-WR617AC | ramips | mt76x8 | `comfast_cf-wr617ac` | 原生 |
| COMFAST CF-WR758AC V1 / Joowin JW-WR758AC V1 | COMFAST CF-WR758AC V1 / Joowin JW-WR758AC V1 | ramips | mt76x8 | `comfast_cf-wr758ac-v1` | 原生 |
| COMFAST CF-WR758AC V2 / Joowin JW-WR758AC V2 | COMFAST CF-WR758AC V2 / Joowin JW-WR758AC V2 | ramips | mt76x8 | `comfast_cf-wr758ac-v2` | 原生 |
| Comfast CF-WR800N | Comfast CF-WR800N | ramips | mt7620 | `comfast_cf-wr800n` | 原生 |
| Confiabits MT7621 v1 | Confiabits MT7621 v1 | ramips | mt7621 | `confiabits_mt7621-v1` | 原生 |
| Creality WB-01 | Creality WB-01 | ramips | mt76x8 | `creality_wb-01` | 原生 |
| CreativeBox v1 | CreativeBox v1 | ramips | mt7621 | `xzwifi_creativebox-v1` | 原生 |
| Cudy AP1300 Outdoor v1 | Cudy AP1300 Outdoor v1 | ramips | mt7621 | `cudy_ap1300-outdoor-v1` | 原生 |
| Cudy C200P | Cudy C200P | ramips | mt7621 | `cudy_c200p` | 原生 |
| Cudy LT300 v3 | Cudy LT300 v3 | ramips | mt76x8 | `cudy_lt300-v3` | 原生 |
| Cudy LT400E v1 | Cudy LT400E v1 | ramips | mt76x8 | `cudy_lt400e-v1` | 扩展 |
| Cudy LT500 Outdoor v1 | Cudy LT500 Outdoor v1 | ramips | mt76x8 | `cudy_lt500-outdoor-v1` | 原生 |
| Cudy M1200 v1 | Cudy M1200 v1 | ramips | mt76x8 | `cudy_m1200-v1` | 原生 |
| Cudy M1300 v2 | Cudy M1300 v2 | ramips | mt7621 | `cudy_m1300-v2` | 原生 |
| Cudy M1800 | Cudy M1800 | ramips | mt7621 | `cudy_m1800` | 原生 |
| Cudy R700 | Cudy R700 | ramips | mt7621 | `cudy_r700` | 原生 |
| Cudy RE1200 Outdoor v1 | Cudy RE1200 Outdoor v1 | ramips | mt76x8 | `cudy_re1200-outdoor-v1` | 原生 |
| Cudy TR1200 v1 | Cudy TR1200 v1 | ramips | mt76x8 | `cudy_tr1200-v1` | 原生 |
| Cudy WR300 v1 | Cudy WR300 v1 | ramips | mt76x8 | `cudy_wr300-v1` | 原生 |
| Cudy WR1000 | Cudy WR1000 | ramips | mt76x8 | `cudy_wr1000` | 原生 |
| Cudy WR1300 v1 | Cudy WR1300 v1 | ramips | mt7621 | `cudy_wr1300-v1` | 原生 |
| Cudy WR1300 v2 | Cudy WR1300 v2 | ramips | mt7621 | `cudy_wr1300-v2` | 原生 |
| Cudy WR1300 v3 | Cudy WR1300 v3 | ramips | mt7621 | `cudy_wr1300-v3` | 原生 |
| Cudy WR2100 | Cudy WR2100 | ramips | mt7621 | `cudy_wr2100` | 原生 |
| Cudy X6 v1 | Cudy X6 v1 | ramips | mt7621 | `cudy_x6-v1` | 原生 |
| Cudy X6 v2 | Cudy X6 v2 | ramips | mt7621 | `cudy_x6-v2` | 原生 |
| D-Link COVR-X1860 A1 | D-Link COVR-X1860 A1 | ramips | mt7621 | `dlink_covr-x1860-a1` | 原生 |
| D-Link DAP-1325 A1 | D-Link DAP-1325 A1 | ramips | mt76x8 | `dlink_dap-1325-a1` | 原生 |
| D-Link DAP-1350 | D-Link DAP-1350 | ramips | rt305x | `dlink_dap-1350` | 原生 |
| D-Link DAP-1620 B1 | D-Link DAP-1620 B1 | ramips | mt7621 | `dlink_dap-1620-b1` | 原生 |
| D-Link DAP-X1860 A1 | D-Link DAP-X1860 A1 | ramips | mt7621 | `dlink_dap-x1860-a1` | 原生 |
| D-Link DCH-M225 | D-Link DCH-M225 | ramips | mt7620 | `dlink_dch-m225` | 原生 |
| D-Link DCS-930 | D-Link DCS-930 | ramips | rt305x | `dlink_dcs-930` | 原生 |
| D-Link DCS-930L B1 | D-Link DCS-930L B1 | ramips | rt305x | `dlink_dcs-930l-b1` | 原生 |
| D-Link DIR-300 B1 | D-Link DIR-300 B1 | ramips | rt305x | `dlink_dir-300-b1` | 原生 |
| D-Link DIR-300 B7 | D-Link DIR-300 B7 | ramips | rt305x | `dlink_dir-300-b7` | 原生 |
| D-Link DIR-320 B1 | D-Link DIR-320 B1 | ramips | rt305x | `dlink_dir-320-b1` | 原生 |
| D-Link DIR-510L | D-Link DIR-510L | ramips | mt7620 | `dlink_dir-510l` | 原生 |
| D-Link DIR-600 B1/B2 | D-Link DIR-600 B1/B2 | ramips | rt305x | `dlink_dir-600-b1` | 原生 |
| D-Link DIR-610 A1 | D-Link DIR-610 A1 | ramips | rt305x | `dlink_dir-610-a1` | 原生 |
| D-Link DIR-615 D | D-Link DIR-615 D | ramips | rt305x | `dlink_dir-615-d` | 原生 |
| D-Link DIR-615 H1 | D-Link DIR-615 H1 | ramips | rt305x | `dlink_dir-615-h1` | 原生 |
| D-Link DIR-620 A1 | D-Link DIR-620 A1 | ramips | rt305x | `dlink_dir-620-a1` | 原生 |
| D-Link DIR-620 D1 | D-Link DIR-620 D1 | ramips | rt305x | `dlink_dir-620-d1` | 原生 |
| D-Link DIR-645 | D-Link DIR-645 | ramips | rt3883 | `dlink_dir-645` | 原生 |
| D-Link DIR-806A B1 | D-Link DIR-806A B1 | ramips | mt7620 | `dlink_dir-806a-b1` | 原生 |
| D-Link DIR-810L | D-Link DIR-810L | ramips | mt7620 | `dlink_dir-810l` | 原生 |
| D-Link DIR-853 A1 | D-Link DIR-853 A1 | ramips | mt7621 | `dlink_dir-853-a1` | 原生 |
| D-Link DIR-853 A3 | D-Link DIR-853 A3 | ramips | mt7621 | `dlink_dir-853-a3` | 原生 |
| D-Link DIR-853 R1 | D-Link DIR-853 R1 | ramips | mt7621 | `dlink_dir-853-r1` | 原生 |
| D-Link DIR-860L B1 | D-Link DIR-860L B1 | ramips | mt7621 | `dlink_dir-860l-b1` | 原生 |
| D-Link DIR-867 A1 | D-Link DIR-867 A1 | ramips | mt7621 | `dlink_dir-867-a1` | 原生 |
| D-Link DIR-878 A1 | D-Link DIR-878 A1 | ramips | mt7621 | `dlink_dir-878-a1` | 原生 |
| D-Link DIR-878 R1 | D-Link DIR-878 R1 | ramips | mt7621 | `dlink_dir-878-r1` | 原生 |
| D-Link DIR-882 A1 | D-Link DIR-882 A1 | ramips | mt7621 | `dlink_dir-882-a1` | 原生 |
| D-Link DIR-882 R1 | D-Link DIR-882 R1 | ramips | mt7621 | `dlink_dir-882-r1` | 原生 |
| D-Link DIR-1360 A1 | D-Link DIR-1360 A1 | ramips | mt7621 | `dlink_dir-1360-a1` | 原生 |
| D-Link DIR-1935 A1 | D-Link DIR-1935 A1 | ramips | mt7621 | `dlink_dir-1935-a1` | 原生 |
| D-Link DIR-1960 A1 | D-Link DIR-1960 A1 | ramips | mt7621 | `dlink_dir-1960-a1` | 原生 |
| D-Link DIR-2055 A1 | D-Link DIR-2055 A1 | ramips | mt7621 | `dlink_dir-2055-a1` | 原生 |
| D-Link DIR-2150 A1 | D-Link DIR-2150 A1 | ramips | mt7621 | `dlink_dir-2150-a1` | 原生 |
| D-Link DIR-2150 R1 | D-Link DIR-2150 R1 | ramips | mt7621 | `dlink_dir-2150-r1` | 原生 |
| D-Link DIR-2640 A1 | D-Link DIR-2640 A1 | ramips | mt7621 | `dlink_dir-2640-a1` | 原生 |
| D-Link DIR-2660 A1 / D-Link DIR-2660 A2 | D-Link DIR-2660 A1 / D-Link DIR-2660 A2 | ramips | mt7621 | `dlink_dir-2660-a1` | 原生 |
| D-Link DIR-3040 A1 | D-Link DIR-3040 A1 | ramips | mt7621 | `dlink_dir-3040-a1` | 原生 |
| D-Link DIR-3060 A1 | D-Link DIR-3060 A1 | ramips | mt7621 | `dlink_dir-3060-a1` | 原生 |
| D-Link DIR-X1860 B1 / D-Link DIR-X1550 A1 | D-Link DIR-X1860 B1 / D-Link DIR-X1550 A1 | ramips | mt7621 | `dlink_dir-x1860-b1` | 原生 |
| D-Link DRA-1360 A1 | D-Link DRA-1360 A1 | ramips | mt7621 | `dlink_dra-1360-a1` | 原生 |
| D-Link DWL-3150 | D-Link DWL-3150 | bcm47xx | legacy | `dlink_dwl-3150` | 原生 |
| D-Link DWR-116 A1/A2 | D-Link DWR-116 A1/A2 | ramips | mt7620 | `dlink_dwr-116-a1` | 原生 |
| D-Link DWR-118 A1 | D-Link DWR-118 A1 | ramips | mt7620 | `dlink_dwr-118-a1` | 原生 |
| D-Link DWR-118 A2 | D-Link DWR-118 A2 | ramips | mt7620 | `dlink_dwr-118-a2` | 原生 |
| D-Link DWR-512 B | D-Link DWR-512 B | ramips | rt305x | `dlink_dwr-512-b` | 原生 |
| D-Link DWR-921 C1 | D-Link DWR-921 C1 | ramips | mt7620 | `dlink_dwr-921-c1` | 原生 |
| D-Link DWR-921 C3 | D-Link DWR-921 C3 | ramips | mt7620 | `dlink_dwr-921-c3` | 原生 |
| D-Link DWR-922 E2 | D-Link DWR-922 E2 | ramips | mt7620 | `dlink_dwr-922-e2` | 原生 |
| D-Link DWR-960 | D-Link DWR-960 | ramips | mt7620 | `dlink_dwr-960` | 原生 |
| D-Link DWR-961 A1 | D-Link DWR-961 A1 | ramips | mt7620 | `dlink_dwr-961-a1` | 原生 |
| 新路由D2 | D-Team Newifi D2 | ramips | mt7621 | `d-team_newifi-d2` | 原生 |
| devolo WiFi Repeater ac | devolo WiFi Repeater ac | ramips | mt7620 | `devolo_rac` | 原生 |
| DNA Valokuitu Plus EX400 | DNA Valokuitu Plus EX400 | ramips | mt7621 | `dna_valokuitu-plus-ex400` | 原生 |
| DomyWifi DM202 | DomyWifi DM202 | ramips | mt7620 | `domywifi_dm202` | 原生 |
| DomyWifi DM203 | DomyWifi DM203 | ramips | mt7620 | `domywifi_dm203` | 原生 |
| DomyWifi DW22D | DomyWifi DW22D | ramips | mt7620 | `domywifi_dw22d` | 原生 |
| Dovado Tiny AC | Dovado Tiny AC | ramips | mt7620 | `dovado_tiny-ac` | 原生 |
| Dual-Q H721 | Dual-Q H721 | ramips | mt7621 | `dual-q_h721` | 原生 |
| DuZun DM06 | DuZun DM06 | ramips | mt76x8 | `duzun_dm06` | 原生 |
| EasyAcc WIZARD 8800 | EasyAcc WIZARD 8800 | ramips | rt305x | `easyacc_wizard-8800` | 原生 |
| Edimax 3g-6200n | Edimax 3g-6200n | ramips | rt305x | `edimax_3g-6200n` | 原生 |
| Edimax 3g-6200nl | Edimax 3g-6200nl | ramips | rt305x | `edimax_3g-6200nl` | 原生 |
| Edimax BR-6208AC V2 | Edimax BR-6208AC V2 | ramips | mt7620 | `edimax_br-6208ac-v2` | 原生 |
| Edimax BR-6475nD | Edimax BR-6475nD | ramips | rt3883 | `edimax_br-6475nd` | 原生 |
| Edimax BR-6478AC V2 | Edimax BR-6478AC V2 | ramips | mt7620 | `edimax_br-6478ac-v2` | 原生 |
| Edimax EW-7476RPC | Edimax EW-7476RPC | ramips | mt7620 | `edimax_ew-7476rpc` | 原生 |
| Edimax EW-7478AC | Edimax EW-7478AC | ramips | mt7620 | `edimax_ew-7478ac` | 原生 |
| Edimax EW-7478APC | Edimax EW-7478APC | ramips | mt7620 | `edimax_ew-7478apc` | 原生 |
| Edimax Gemini AC2600 RG21S | Edimax Gemini AC2600 RG21S | ramips | mt7621 | `edimax_rg21s` | 原生 |
| Edimax PS-1208MFg | Edimax PS-1208MFg | bcm47xx | legacy | `edimax_ps1208-mfg` | 原生 |
| Edimax RA21S / Edimax Gemini RA21S | Edimax RA21S / Edimax Gemini RA21S | ramips | mt7621 | `edimax_ra21s` | 原生 |
| Edimax RE23S / Edimax Gemini RE23S | Edimax RE23S / Edimax Gemini RE23S | ramips | mt7621 | `edimax_re23s` | 原生 |
| EDUP EP-RT2960S | EDUP EP-RT2960S | ramips | mt7621 | `edup_ep-rt2960s` | 原生 |
| EDUP EP-RT2983 | EDUP EP-RT2983 | ramips | mt7621 | `edup_ep-rt2983` | 原生 |
| ELECOM WMC-C2533GST | ELECOM WMC-C2533GST | ramips | mt7621 | `elecom_wmc-c2533gst` | 扩展 |
| ELECOM WMC-M1267GST2 | ELECOM WMC-M1267GST2 | ramips | mt7621 | `elecom_wmc-m1267gst2` | 原生 |
| ELECOM WMC-S1267GS2 | ELECOM WMC-S1267GS2 | ramips | mt7621 | `elecom_wmc-s1267gs2` | 原生 |
| ELECOM WMC-X1800GST | ELECOM WMC-X1800GST | ramips | mt7621 | `elecom_wmc-x1800gst` | 原生 |
| ELECOM WRC-1167FS | ELECOM WRC-1167FS | ramips | mt76x8 | `elecom_wrc-1167fs` | 原生 |
| ELECOM WRC-1167GHBK2-S | ELECOM WRC-1167GHBK2-S | ramips | mt7621 | `elecom_wrc-1167ghbk2-s` | 原生 |
| ELECOM WRC-1167GS2-B | ELECOM WRC-1167GS2-B | ramips | mt7621 | `elecom_wrc-1167gs2-b` | 原生 |
| ELECOM WRC-1167GST2 | ELECOM WRC-1167GST2 | ramips | mt7621 | `elecom_wrc-1167gst2` | 原生 |
| ELECOM WRC-1750GS | ELECOM WRC-1750GS | ramips | mt7621 | `elecom_wrc-1750gs` | 原生 |
| ELECOM WRC-1750GST2 | ELECOM WRC-1750GST2 | ramips | mt7621 | `elecom_wrc-1750gst2` | 原生 |
| ELECOM WRC-1750GSV | ELECOM WRC-1750GSV | ramips | mt7621 | `elecom_wrc-1750gsv` | 原生 |
| ELECOM WRC-1900GST | ELECOM WRC-1900GST | ramips | mt7621 | `elecom_wrc-1900gst` | 原生 |
| ELECOM WRC-2533GHBK2-T | ELECOM WRC-2533GHBK2-T | ramips | mt7621 | `elecom_wrc-2533ghbk2-t` | 原生 |
| ELECOM WRC-2533GHBK-I | ELECOM WRC-2533GHBK-I | ramips | mt7621 | `elecom_wrc-2533ghbk-i` | 原生 |
| ELECOM WRC-2533GS2 | ELECOM WRC-2533GS2 | ramips | mt7621 | `elecom_wrc-2533gs2` | 原生 |
| ELECOM WRC-2533GST | ELECOM WRC-2533GST | ramips | mt7621 | `elecom_wrc-2533gst` | 原生 |
| ELECOM WRC-2533GST2 | ELECOM WRC-2533GST2 | ramips | mt7621 | `elecom_wrc-2533gst2` | 原生 |
| ELECOM WRC-X1800GS | ELECOM WRC-X1800GS | ramips | mt7621 | `elecom_wrc-x1800gs` | 原生 |
| Elecom WRH-300CR | Elecom WRH-300CR | ramips | mt7620 | `elecom_wrh-300cr` | 原生 |
| ELECOM WSC-X1800GS | ELECOM WSC-X1800GS | ramips | mt7621 | `elecom_wsc-x1800gs` | 原生 |
| EnGenius EPG600 | EnGenius EPG600 | ramips | mt7620 | `engenius_epg600` | 原生 |
| EnGenius ESR600 | EnGenius ESR600 | ramips | mt7620 | `engenius_esr600` | 原生 |
| EnGenius ESR600H | EnGenius ESR600H | ramips | rt3883 | `engenius_esr600h` | 原生 |
| EnGenius ESR-9753 | EnGenius ESR-9753 | ramips | rt305x | `engenius_esr-9753` | 原生 |
| Etisalat S3 / Sercomm S3 | Etisalat S3 / Sercomm S3 | ramips | mt7621 | `etisalat_s3` | 原生 |
| Firefly FireWRT | Firefly FireWRT | ramips | mt7621 | `firefly_firewrt` | 原生 |
| Fon FON2601 | Fon FON2601 | ramips | mt7620 | `fon_fon2601` | 原生 |
| Fon Fonera 2.0N | Fon Fonera 2.0N | ramips | rt305x | `fon_fonera-20n` | 原生 |
| GeHua GHL-R-001 | GeHua GHL-R-001 | ramips | mt7621 | `gehua_ghl-r-001` | 原生 |
| Gemtek WVRTM-127ACN | Gemtek WVRTM-127ACN | ramips | mt7621 | `gemtek_wvrtm-127acn` | 原生 |
| Gemtek WVRTM-130ACN | Gemtek WVRTM-130ACN | ramips | mt7621 | `gemtek_wvrtm-130acn` | 原生 |
| Generic Image with gzipped kernel | Generic Image with gzipped kernel | bcm47xx | legacy | `standard-noloader-gz` | 原生 |
| Generic Image with LZMA compressed kernel matching CFE decompressor | Generic Image with LZMA compressed kernel matching CFE decompressor | bcm47xx | mips74k | `standard-noloader-nodictionarylzma` | 原生 |
| Generic Image with LZMA loader and LZMA compressed kernel | Generic Image with LZMA loader and LZMA compressed kernel | bcm47xx | generic | `standard` | 原生 |
| Generic Image with LZMA loader and LZMA compressed kernel | Generic Image with LZMA loader and LZMA compressed kernel | bcm47xx | legacy | `standard` | 原生 |
| Generic Image with LZMA loader and LZMA compressed kernel | Generic Image with LZMA loader and LZMA compressed kernel | bcm47xx | mips74k | `standard` | 原生 |
| Genexis Pulse EX400 / Inteno Pulse EX400 | Genexis Pulse EX400 / Inteno Pulse EX400 | ramips | mt7621 | `genexis_pulse-ex400` | 原生 |
| GL.iNet GL-MT300A | GL.iNet GL-MT300A | ramips | mt7620 | `glinet_gl-mt300a` | 原生 |
| GL.iNet GL-MT300N | GL.iNet GL-MT300N | ramips | mt7620 | `glinet_gl-mt300n` | 原生 |
| GL.iNet GL-MT300N V2 | GL.iNet GL-MT300N V2 | ramips | mt76x8 | `glinet_gl-mt300n-v2` | 原生 |
| GL.iNet GL-MT750 | GL.iNet GL-MT750 | ramips | mt7620 | `glinet_gl-mt750` | 原生 |
| GL.iNet GL-MT1300 | GL.iNet GL-MT1300 | ramips | mt7621 | `glinet_gl-mt1300` | 原生 |
| GL.iNet microuter-N300 | GL.iNet microuter-N300 | ramips | mt76x8 | `glinet_microuter-n300` | 原生 |
| GL.iNet VIXMINI | GL.iNet VIXMINI | ramips | mt76x8 | `glinet_vixmini` | 原生 |
| GnuBee GB-PC1 | GnuBee GB-PC1 | ramips | mt7621 | `gnubee_gb-pc1` | 原生 |
| GnuBee GB-PC2 | GnuBee GB-PC2 | ramips | mt7621 | `gnubee_gb-pc2` | 原生 |
| 新华三TX1800 Plus | H3C TX1800 Plus | ramips | mt7621 | `h3c_tx1800-plus` | 原生 |
| 新华三TX1801 Plus | H3C TX1801 Plus | ramips | mt7621 | `h3c_tx1801-plus` | 原生 |
| 新华三TX1806 | H3C TX1806 | ramips | mt7621 | `h3c_tx1806` | 原生 |
| Haier HAR-20S2U1 | Haier HAR-20S2U1 | ramips | mt7621 | `haier_har-20s2u1` | 原生 |
| Hak5 WiFi Pineapple Mark 7 | Hak5 WiFi Pineapple Mark 7 | ramips | mt76x8 | `hak5_wifi-pineapple-mk7` | 原生 |
| HAME MPR A1 | HAME MPR A1 | ramips | rt305x | `hame_mpr-a1` | 原生 |
| HAME MPR A2 | HAME MPR A2 | ramips | rt305x | `hame_mpr-a2` | 原生 |
| Hanyang CJ-Hello HYC-G920 | Hanyang CJ-Hello HYC-G920 | ramips | mt7621 | `hanyang_hyc-g920` | 原生 |
| Hauppauge Broadway | Hauppauge Broadway | ramips | rt305x | `hauppauge_broadway` | 原生 |
| Head Weblink HDRM2000 | Head Weblink HDRM2000 | ramips | mt7620 | `head-weblink_hdrm200` | 原生 |
| Hi-Link HLK-7688A | Hi-Link HLK-7688A | ramips | mt76x8 | `hilink_hlk-7688a` | 原生 |
| Hi-Link HLK-RM04 | Hi-Link HLK-RM04 | ramips | rt305x | `hilink_hlk-rm04` | 原生 |
| HiLink HLK-7621A evaluation board | HiLink HLK-7621A evaluation board | ramips | mt7621 | `hilink_hlk-7621a-evb` | 原生 |
| HILINK HLK-7628N | HILINK HLK-7628N | ramips | mt76x8 | `hilink_hlk-7628n` | 原生 |
| 极路由壹 | HiWiFi HC5611 | ramips | mt76x8 | `hiwifi_hc5611` | 原生 |
| 极路由1S | HiWiFi HC5661 | ramips | mt7620 | `hiwifi_hc5661` | 原生 |
| 极路由1S（A版） | HiWiFi HC5661A | ramips | mt76x8 | `hiwifi_hc5661a` | 原生 |
| 极路由2 | HiWiFi HC5761 | ramips | mt7620 | `hiwifi_hc5761` | 原生 |
| 极路由2（A版） | HiWiFi HC5761A | ramips | mt76x8 | `hiwifi_hc5761a` | 原生 |
| 极路由3 | HiWiFi HC5861 | ramips | mt7620 | `hiwifi_hc5861` | 原生 |
| 极路由3（B版） | HiWiFi HC5861B | ramips | mt76x8 | `hiwifi_hc5861b` | 原生 |
| 极路由4 | HiWiFi HC5962 | ramips | mt7621 | `hiwifi_hc5962` | 原生 |
| HNET C108 | HNET C108 | ramips | mt7620 | `hnet_c108` | 原生 |
| Hongdian H7920 v40 | Hongdian H7920 v40 | ramips | mt76x8 | `hongdian_h7920-v40` | 原生 |
| Hongdian H8850 v20 | Hongdian H8850 v20 | ramips | mt76x8 | `hongdian_h8850-v20` | 原生 |
| Hongdian H8922 v30 | Hongdian H8922 v30 | ramips | mt7620 | `hongdian_h8922-v30` | 原生 |
| HooToo HT-TM02 | HooToo HT-TM02 | ramips | rt305x | `hootoo_ht-tm02` | 原生 |
| HooToo HT-TM05 | HooToo HT-TM05 | ramips | mt7620 | `hootoo_ht-tm05` | 原生 |
| Huasifei WS1208V2 | Huasifei WS1208V2 | ramips | mt7621 | `huasifei_ws1208v2` | 原生 |
| Huawei D105 | Huawei D105 | ramips | rt305x | `huawei_d105` | 原生 |
| Huawei E970 | Huawei E970 | bcm47xx | legacy | `huawei_e970` | 原生 |
| HuaWei HG255D | HuaWei HG255D | ramips | rt305x | `huawei_hg255d` | 原生 |
| HUMAX E2 / HUMAX QUANTUM E2 | HUMAX E2 / HUMAX QUANTUM E2 | ramips | mt7620 | `humax_e2` | 原生 |
| HUMAX E10 / HUMAX QUANTUM E10 | HUMAX E10 / HUMAX QUANTUM E10 | ramips | mt7621 | `humax_e10` | 原生 |
| I-O DATA WN-AC733GR3 | I-O DATA WN-AC733GR3 | ramips | mt7620 | `iodata_wn-ac733gr3` | 原生 |
| I-O DATA WN-AC1167GR | I-O DATA WN-AC1167GR | ramips | mt7620 | `iodata_wn-ac1167gr` | 原生 |
| I-O DATA WN-AX1167GR | I-O DATA WN-AX1167GR | ramips | mt7621 | `iodata_wn-ax1167gr` | 原生 |
| I-O DATA WN-AX1167GR2 | I-O DATA WN-AX1167GR2 | ramips | mt7621 | `iodata_wn-ax1167gr2` | 原生 |
| I-O DATA WN-AX2033GR | I-O DATA WN-AX2033GR | ramips | mt7621 | `iodata_wn-ax2033gr` | 原生 |
| I-O DATA WN-AX2033GR2 | I-O DATA WN-AX2033GR2 | ramips | mt7621 | `iodata_wn-ax2033gr2` | 原生 |
| I-O DATA WN-DEAX1800GR | I-O DATA WN-DEAX1800GR | ramips | mt7621 | `iodata_wn-deax1800gr` | 原生 |
| I-O DATA WN-DX1167R | I-O DATA WN-DX1167R | ramips | mt7621 | `iodata_wn-dx1167r` | 原生 |
| I-O DATA WN-DX1200GR | I-O DATA WN-DX1200GR | ramips | mt7621 | `iodata_wn-dx1200gr` | 原生 |
| I-O DATA WN-DX2033GR | I-O DATA WN-DX2033GR | ramips | mt7621 | `iodata_wn-dx2033gr` | 原生 |
| I-O DATA WN-GX300GR | I-O DATA WN-GX300GR | ramips | mt7621 | `iodata_wn-gx300gr` | 原生 |
| I-O DATA WNPR2600G | I-O DATA WNPR2600G | ramips | mt7621 | `iodata_wnpr2600g` | 原生 |
| Imagination Technologies Creator Ci40 (VL-62899) / Imagination Technologies Marduk board | Imagination Technologies Creator Ci40 (VL-62899) / Imagination Technologies Marduk board | pistachio | generic | `img_creator-ci40` | 原生 |
| Intenso Memory 2 Move | Intenso Memory 2 Move | ramips | rt305x | `intenso_memory2move` | 原生 |
| ipTIME A3 | ipTIME A3 | ramips | mt76x8 | `iptime_a3` | 原生 |
| ipTIME A6ns-M | ipTIME A6ns-M | ramips | mt7621 | `iptime_a6ns-m` | 原生 |
| ipTIME A104ns | ipTIME A104ns | ramips | mt7620 | `iptime_a104ns` | 原生 |
| ipTIME A604M | ipTIME A604M | ramips | mt76x8 | `iptime_a604m` | 原生 |
| ipTIME A1004ns | ipTIME A1004ns | ramips | mt7620 | `iptime_a1004ns` | 原生 |
| ipTIME A3002MESH | ipTIME A3002MESH | ramips | mt7621 | `iptime_a3002mesh` | 原生 |
| ipTIME A3004NS-dual | ipTIME A3004NS-dual | ramips | mt7621 | `iptime_a3004ns-dual` | 原生 |
| ipTIME A3004T | ipTIME A3004T | ramips | mt7621 | `iptime_a3004t` | 原生 |
| ipTIME A6004NS-M | ipTIME A6004NS-M | ramips | mt7621 | `iptime_a6004ns-m` | 原生 |
| ipTIME A8004T | ipTIME A8004T | ramips | mt7621 | `iptime_a8004t` | 原生 |
| ipTIME AX2002MESH | ipTIME AX2002MESH | ramips | mt7621 | `iptime_ax2002m` | 原生 |
| ipTIME AX2004M | ipTIME AX2004M | ramips | mt7621 | `iptime_ax2004m` | 原生 |
| ipTIME T5004 | ipTIME T5004 | ramips | mt7621 | `iptime_t5004` | 原生 |
| 捷稀JHR-AC876M | JCG JHR-AC876M | ramips | mt7621 | `jcg_jhr-ac876m` | 原生 |
| 捷稀JHR-N805R | JCG JHR-N805R | ramips | rt305x | `jcg_jhr-n805r` | 原生 |
| 捷稀JHR-N825R | JCG JHR-N825R | ramips | rt305x | `jcg_jhr-n825r` | 原生 |
| 捷稀JHR-N926R | JCG JHR-N926R | ramips | rt305x | `jcg_jhr-n926r` | 原生 |
| 捷稀Q20 | JCG Q20 | ramips | mt7621 | `jcg_q20` | 原生 |
| 捷稀Y2 | JCG Y2 | ramips | mt7621 | `jcg_y2` | 原生 |
| 京东云无线宝RE-CP-02 | JD-Cloud RE-CP-02 | ramips | mt7621 | `jdcloud_re-cp-02` | 原生 |
| 京东云无线宝RE-SP-01B | JDCloud RE-SP-01B | ramips | mt7621 | `jdcloud_re-sp-01b` | 原生 |
| Jotale JS76x8 8M | Jotale JS76x8 8M | ramips | mt76x8 | `jotale_js76x8-8m` | 原生 |
| Jotale JS76x8 16M | Jotale JS76x8 16M | ramips | mt76x8 | `jotale_js76x8-16m` | 原生 |
| Jotale JS76x8 32M | Jotale JS76x8 32M | ramips | mt76x8 | `jotale_js76x8-32m` | 原生 |
| Keenetic KN-1112 | Keenetic KN-1112 | ramips | mt76x8 | `keenetic_kn-1112` | 原生 |
| Keenetic KN-1212 | Keenetic KN-1212 | ramips | mt76x8 | `keenetic_kn-1212` | 原生 |
| Keenetic KN-1221 | Keenetic KN-1221 | ramips | mt76x8 | `keenetic_kn-1221` | 原生 |
| Keenetic KN-1510 | Keenetic KN-1510 | ramips | mt76x8 | `keenetic_kn-1510` | 扩展 |
| Keenetic KN-1613 | Keenetic KN-1613 | ramips | mt76x8 | `keenetic_kn-1613` | 原生 |
| Keenetic KN-1711 | Keenetic KN-1711 | ramips | mt76x8 | `keenetic_kn-1711` | 原生 |
| Keenetic KN-1713 | Keenetic KN-1713 | ramips | mt76x8 | `keenetic_kn-1713` | 原生 |
| Keenetic KN-1910 | Keenetic KN-1910 | ramips | mt7621 | `keenetic_kn-1910` | 原生 |
| Keenetic KN-3010 | Keenetic KN-3010 | ramips | mt7621 | `keenetic_kn-3010` | 原生 |
| Keenetic KN-3211 | Keenetic KN-3211 | ramips | mt76x8 | `keenetic_kn-3211` | 原生 |
| Keenetic KN-3510 | Keenetic KN-3510 | ramips | mt7621 | `keenetic_kn-3510` | 原生 |
| Kimax U25AWF H1 | Kimax U25AWF H1 | ramips | mt7620 | `kimax_u25awf-h1` | 原生 |
| Kimax U35WF | Kimax U35WF | ramips | mt7620 | `kimax_u35wf` | 原生 |
| Kingston MLW221 | Kingston MLW221 | ramips | mt7620 | `kingston_mlw221` | 原生 |
| Kingston MLWG2 | Kingston MLWG2 | ramips | mt7620 | `kingston_mlwg2` | 原生 |
| Kroks Rt-Cse5 UW DRSIM / Kroks KNdRt31R16 | Kroks Rt-Cse5 UW DRSIM / Kroks KNdRt31R16 | ramips | mt76x8 | `kroks_kndrt31r16` | 原生 |
| Kroks Rt-Pot mXw DS RSIM / Kroks KNdRt31R19 | Kroks Rt-Pot mXw DS RSIM / Kroks KNdRt31R19 | ramips | mt76x8 | `kroks_kndrt31r19` | 原生 |
| LAVA LR-25G001 | LAVA LR-25G001 | ramips | mt7620 | `lava_lr-25g001` | 原生 |
| LB-Link BL-W1200 | LB-Link BL-W1200 | ramips | mt7620 | `lb-link_bl-w1200` | 原生 |
| Lenovo Newifi D1 | Lenovo Newifi D1 | ramips | mt7621 | `lenovo_newifi-d1` | 原生 |
| 联想新路由Y1 | Lenovo Y1 | ramips | mt7620 | `lenovo_newifi-y1` | 原生 |
| 联想新路由Y1S | Lenovo Y1S | ramips | mt7620 | `lenovo_newifi-y1s` | 原生 |
| Linksys E900 v1 | Linksys E900 v1 | bcm47xx | mips74k | `linksys_e900-v1` | 原生 |
| Linksys E1000 v1/v2/v2.1 | Linksys E1000 v1/v2/v2.1 | bcm47xx | mips74k | `linksys_e1000` | 原生 |
| Linksys E1200 v1 | Linksys E1200 v1 | bcm47xx | mips74k | `linksys_e1200-v1` | 原生 |
| Linksys E1200 v2 | Linksys E1200 v2 | bcm47xx | mips74k | `linksys_e1200-v2` | 原生 |
| Linksys E1500 v1 | Linksys E1500 v1 | bcm47xx | mips74k | `linksys_e1500-v1` | 原生 |
| Linksys E1550 v1 | Linksys E1550 v1 | bcm47xx | mips74k | `linksys_e1550-v1` | 原生 |
| Linksys E1700 | Linksys E1700 | ramips | mt7620 | `linksys_e1700` | 原生 |
| Linksys E2000 v1 | Linksys E2000 v1 | bcm47xx | mips74k | `linksys_e2000-v1` | 原生 |
| Linksys E2500 v1 | Linksys E2500 v1 | bcm47xx | mips74k | `linksys_e2500-v1` | 原生 |
| Linksys E2500 v2 | Linksys E2500 v2 | bcm47xx | mips74k | `linksys_e2500-v2` | 原生 |
| Linksys E2500 v2.1 | Linksys E2500 v2.1 | bcm47xx | mips74k | `linksys_e2500-v2.1` | 原生 |
| Linksys E2500 v3 | Linksys E2500 v3 | bcm47xx | mips74k | `linksys_e2500-v3` | 原生 |
| Linksys E3000 v1 | Linksys E3000 v1 | bcm47xx | generic | `linksys_e3000-v1` | 原生 |
| Linksys E3200 v1 | Linksys E3200 v1 | bcm47xx | mips74k | `linksys_e3200-v1` | 原生 |
| Linksys E4200 v1 | Linksys E4200 v1 | bcm47xx | mips74k | `linksys_e4200-v1` | 原生 |
| Linksys E5400 / Linksys E2500 v4 / Linksys E5300 / Linksys E5350 | Linksys E5400 / Linksys E2500 v4 / Linksys E5300 / Linksys E5350 | ramips | mt76x8 | `linksys_e5400` | 原生 |
| Linksys E5600 | Linksys E5600 | ramips | mt7621 | `linksys_e5600` | 原生 |
| Linksys E7350 | Linksys E7350 | ramips | mt7621 | `linksys_e7350` | 原生 |
| Linksys EA6350 v4 | Linksys EA6350 v4 | ramips | mt7621 | `linksys_ea6350-v4` | 原生 |
| Linksys EA7300 v1 | Linksys EA7300 v1 | ramips | mt7621 | `linksys_ea7300-v1` | 原生 |
| Linksys EA7300 v2 | Linksys EA7300 v2 | ramips | mt7621 | `linksys_ea7300-v2` | 原生 |
| Linksys EA7500 v2 | Linksys EA7500 v2 | ramips | mt7621 | `linksys_ea7500-v2` | 原生 |
| Linksys EA8100 v1 | Linksys EA8100 v1 | ramips | mt7621 | `linksys_ea8100-v1` | 原生 |
| Linksys EA8100 v2 | Linksys EA8100 v2 | ramips | mt7621 | `linksys_ea8100-v2` | 原生 |
| Linksys RE6500 | Linksys RE6500 | ramips | mt7621 | `linksys_re6500` | 原生 |
| Linksys RE7000 | Linksys RE7000 | ramips | mt7621 | `linksys_re7000` | 原生 |
| Linksys WRT54G | Linksys WRT54G | bcm47xx | legacy | `linksys_wrt54g` | 原生 |
| Linksys WRT54G3G | Linksys WRT54G3G | bcm47xx | legacy | `linksys_wrt54g3g` | 原生 |
| Linksys WRT54G3G-EM | Linksys WRT54G3G-EM | bcm47xx | legacy | `linksys_wrt54g3g-em` | 原生 |
| Linksys WRT54G3GV2-VF | Linksys WRT54G3GV2-VF | bcm47xx | legacy | `linksys_wrt54g3gv2-vf` | 原生 |
| Linksys WRT54GS v1/v2/v3 / Linksys WRT54G-TM v1 | Linksys WRT54GS v1/v2/v3 / Linksys WRT54G-TM v1 | bcm47xx | legacy | `linksys_wrt54gs` | 原生 |
| Linksys WRT54GS v4 | Linksys WRT54GS v4 | bcm47xx | legacy | `linksys_wrt54gs-v4` | 原生 |
| Linksys WRT150N | Linksys WRT150N | bcm47xx | legacy | `linksys_wrt150n` | 原生 |
| Linksys WRT160N v1 | Linksys WRT160N v1 | bcm47xx | legacy | `linksys_wrt160n-v1` | 原生 |
| Linksys WRT160N v3 | Linksys WRT160N v3 | bcm47xx | mips74k | `linksys_wrt160n-v3` | 原生 |
| Linksys WRT300N v1 | Linksys WRT300N v1 | bcm47xx | legacy | `linksys_wrt300n-v1` | 原生 |
| Linksys WRT300N v1.1 | Linksys WRT300N v1.1 | bcm47xx | generic | `linksys_wrt300n-v1.1` | 原生 |
| Linksys WRT310N v1 | Linksys WRT310N v1 | bcm47xx | generic | `linksys_wrt310n-v1` | 原生 |
| Linksys WRT310N v2 | Linksys WRT310N v2 | bcm47xx | mips74k | `linksys_wrt310n-v2` | 原生 |
| Linksys WRT320N v1 | Linksys WRT320N v1 | bcm47xx | mips74k | `linksys_wrt320n-v1` | 原生 |
| Linksys WRT350N v1 | Linksys WRT350N v1 | bcm47xx | generic | `linksys_wrt350n-v1` | 原生 |
| Linksys WRT610N v1 | Linksys WRT610N v1 | bcm47xx | generic | `linksys_wrt610n-v1` | 原生 |
| Linksys WRT610N v2 | Linksys WRT610N v2 | bcm47xx | generic | `linksys_wrt610n-v2` | 原生 |
| Linksys WRTSL54GS | Linksys WRTSL54GS | bcm47xx | legacy | `linksys_wrtsl54gs` | 原生 |
| Loewe WMDR-143N | Loewe WMDR-143N | ramips | rt3883 | `loewe_wmdr-143n` | 原生 |
| Maginon MC-1200AC | Maginon MC-1200AC | ramips | mt7621 | `maginon_mc-1200ac` | 原生 |
| Mediatek AP-MT7621A-V60 EVB | Mediatek AP-MT7621A-V60 EVB | ramips | mt7621 | `mediatek_ap-mt7621a-v60` | 原生 |
| MediaTek LinkIt Smart 7688 | MediaTek LinkIt Smart 7688 | ramips | mt76x8 | `mediatek_linkit-smart-7688` | 原生 |
| MediaTek MT7620a + MT7530 EVB | MediaTek MT7620a + MT7530 EVB | ramips | mt7620 | `ralink_mt7620a-mt7530-evb` | 原生 |
| MediaTek MT7620a + MT7610e EVB | MediaTek MT7620a + MT7610e EVB | ramips | mt7620 | `ralink_mt7620a-mt7610e-evb` | 原生 |
| MediaTek MT7620a EVB | MediaTek MT7620a EVB | ramips | mt7620 | `ralink_mt7620a-evb` | 原生 |
| MediaTek MT7620a V22SG | MediaTek MT7620a V22SG | ramips | mt7620 | `ralink_mt7620a-v22sg-evb` | 原生 |
| MediaTek MT7621 EVB | MediaTek MT7621 EVB | ramips | mt7621 | `mediatek_mt7621-eval-board` | 原生 |
| MediaTek MT7628 EVB | MediaTek MT7628 EVB | ramips | mt76x8 | `mediatek_mt7628an-eval-board` | 原生 |
| MeiG SLT866 | MeiG SLT866 | ramips | mt7621 | `meig_slt866` | 原生 |
| Mercury MAC1200R v2.0 | Mercury MAC1200R v2.0 | ramips | mt76x8 | `mercury_mac1200r-v2` | 原生 |
| 水星MB130-4G v1 | MERCUSYS MB130-4G v1 | ramips | mt76x8 | `mercusys_mb130-4g-v1` | 原生 |
| 水星MR70X v1 | MERCUSYS MR70X v1 / MERCUSYS MR1800X | ramips | mt7621 | `mercusys_mr70x-v1` | 原生 |
| Microduino MicroWRT | Microduino MicroWRT | ramips | mt7620 | `microduino_microwrt` | 原生 |
| MikroTik LtAP-2HnD | MikroTik LtAP-2HnD | ramips | mt7621 | `mikrotik_ltap-2hnd` | 原生 |
| MikroTik RouterBOARD 750Gr3 | MikroTik RouterBOARD 750Gr3 | ramips | mt7621 | `mikrotik_routerboard-750gr3` | 原生 |
| MikroTik RouterBOARD 760iGS | MikroTik RouterBOARD 760iGS | ramips | mt7621 | `mikrotik_routerboard-760igs` | 原生 |
| MikroTik RouterBOARD M11G | MikroTik RouterBOARD M11G | ramips | mt7621 | `mikrotik_routerboard-m11g` | 原生 |
| MikroTik RouterBOARD M33G | MikroTik RouterBOARD M33G | ramips | mt7621 | `mikrotik_routerboard-m33g` | 原生 |
| Minew G1-C | Minew G1-C | ramips | mt76x8 | `minew_g1-c` | 原生 |
| MoFi Network MOFI3500-3GN | MoFi Network MOFI3500-3GN | ramips | rt305x | `mofinetwork_mofi3500-3gn` | 原生 |
| MoFi Network MOFI5500-5GXeLTE | MoFi Network MOFI5500-5GXeLTE | ramips | mt7621 | `mofinetwork_mofi5500-5gxelte` | 原生 |
| Motorola MWR03 | Motorola MWR03 | ramips | mt76x8 | `motorola_mwr03` | 原生 |
| Motorola WA840G | Motorola WA840G | bcm47xx | legacy | `motorola_wa840g` | 原生 |
| Motorola WE800G | Motorola WE800G | bcm47xx | legacy | `motorola_we800g` | 原生 |
| Motorola WR850G | Motorola WR850G | bcm47xx | legacy | `motorola_wr850g` | 原生 |
| MovingComm C120EV | MovingComm C120EV | ramips | mt76x8 | `movingcomm_c120ev` | 扩展 |
| MQmaker WiTi | MQmaker WiTi | ramips | mt7621 | `mqmaker_witi` | 原生 |
| MTC Wireless Router WR1201 | MTC Wireless Router WR1201 | ramips | mt7621 | `mtc_wr1201` | 原生 |
| MTS WG430223 | MTS WG430223 | ramips | mt7621 | `mts_wg430223` | 原生 |
| Netcore NW718 | Netcore NW718 | ramips | rt305x | `netcore_nw718` | 原生 |
| Netcore NW5212 | Netcore NW5212 | ramips | mt7620 | `netcore_nw5212` | 原生 |
| NETGEAR EAX12 / NETGEAR EAX11 v2 / NETGEAR EAX15 v2 | NETGEAR EAX12 / NETGEAR EAX11 v2 / NETGEAR EAX15 v2 | ramips | mt7621 | `netgear_eax12` | 原生 |
| NETGEAR EX2700 | NETGEAR EX2700 | ramips | mt7620 | `netgear_ex2700` | 原生 |
| NETGEAR EX3700/EX3800 | NETGEAR EX3700/EX3800 | ramips | mt7620 | `netgear_ex3700` | 原生 |
| NETGEAR EX6120 | NETGEAR EX6120 | ramips | mt7620 | `netgear_ex6120` | 原生 |
| NETGEAR EX6130 | NETGEAR EX6130 | ramips | mt7620 | `netgear_ex6130` | 原生 |
| NETGEAR EX6150 | NETGEAR EX6150 | ramips | mt7621 | `netgear_ex6150` | 原生 |
| NETGEAR JWNR2010 v5 | NETGEAR JWNR2010 v5 | ramips | mt7620 | `netgear_jwnr2010-v5` | 原生 |
| NETGEAR PR2000 | NETGEAR PR2000 | ramips | mt7620 | `netgear_pr2000` | 原生 |
| NETGEAR R6020 | NETGEAR R6020 | ramips | mt76x8 | `netgear_r6020` | 原生 |
| NETGEAR R6080 | NETGEAR R6080 | ramips | mt76x8 | `netgear_r6080` | 原生 |
| NETGEAR R6120 | NETGEAR R6120 | ramips | mt76x8 | `netgear_r6120` | 原生 |
| NETGEAR R6200 v1 | NETGEAR R6200 v1 | bcm47xx | mips74k | `netgear_r6200-v1` | 原生 |
| NETGEAR R6220 | NETGEAR R6220 | ramips | mt7621 | `netgear_r6220` | 原生 |
| NETGEAR R6260 | NETGEAR R6260 | ramips | mt7621 | `netgear_r6260` | 原生 |
| NETGEAR R6350 | NETGEAR R6350 | ramips | mt7621 | `netgear_r6350` | 原生 |
| NETGEAR R6700 v2 / NETGEAR Nighthawk AC2100 v1 / NETGEAR Nighthawk AC2400 v1 | NETGEAR R6700 v2 / NETGEAR Nighthawk AC2100 v1 / NETGEAR Nighthawk AC2400 v1 | ramips | mt7621 | `netgear_r6700-v2` | 原生 |
| NETGEAR R6800 | NETGEAR R6800 | ramips | mt7621 | `netgear_r6800` | 原生 |
| NETGEAR R6850 | NETGEAR R6850 | ramips | mt7621 | `netgear_r6850` | 原生 |
| NETGEAR R6900 v2 | NETGEAR R6900 v2 | ramips | mt7621 | `netgear_r6900-v2` | 原生 |
| NETGEAR R7200 | NETGEAR R7200 | ramips | mt7621 | `netgear_r7200` | 原生 |
| NETGEAR R7450 | NETGEAR R7450 | ramips | mt7621 | `netgear_r7450` | 原生 |
| NETGEAR WAC104 | NETGEAR WAC104 | ramips | mt7621 | `netgear_wac104` | 原生 |
| NETGEAR WAC124 | NETGEAR WAC124 | ramips | mt7621 | `netgear_wac124` | 原生 |
| NETGEAR WAX202 | NETGEAR WAX202 | ramips | mt7621 | `netgear_wax202` | 原生 |
| NETGEAR WAX214v2 | NETGEAR WAX214v2 | ramips | mt7621 | `netgear_wax214v2` | 原生 |
| NETGEAR WGR614 v8 | NETGEAR WGR614 v8 | bcm47xx | legacy | `netgear_wgr614-v8` | 原生 |
| NETGEAR WGR614 v10 | NETGEAR WGR614 v10 | bcm47xx | mips74k | `netgear_wgr614-v10` | 原生 |
| NETGEAR WGR614 v10 (NA) | NETGEAR WGR614 v10 (NA) | bcm47xx | mips74k | `netgear_wgr614-v10na` | 原生 |
| NETGEAR WGT634U | NETGEAR WGT634U | bcm47xx | legacy | `netgear_wgt634u` | 原生 |
| NETGEAR WN2500RP v1 | NETGEAR WN2500RP v1 | bcm47xx | mips74k | `netgear_wn2500rp-v1` | 原生 |
| NETGEAR WN3000RP | NETGEAR WN3000RP | bcm47xx | mips74k | `netgear_wn3000rp` | 原生 |
| NETGEAR WN3000RP v3 | NETGEAR WN3000RP v3 | ramips | mt7620 | `netgear_wn3000rp-v3` | 原生 |
| NETGEAR WN3100RP v2 | NETGEAR WN3100RP v2 | ramips | mt7620 | `netgear_wn3100rp-v2` | 原生 |
| NETGEAR WNCE2001 | NETGEAR WNCE2001 | ramips | rt305x | `netgear_wnce2001` | 原生 |
| NETGEAR WNDR3300 v1 | NETGEAR WNDR3300 v1 | bcm47xx | legacy | `netgear_wndr3300-v1` | 原生 |
| NETGEAR WNDR3400 v1 | NETGEAR WNDR3400 v1 | bcm47xx | mips74k | `netgear_wndr3400-v1` | 原生 |
| NETGEAR WNDR3400 v2 | NETGEAR WNDR3400 v2 | bcm47xx | mips74k | `netgear_wndr3400-v2` | 原生 |
| NETGEAR WNDR3400 v3 | NETGEAR WNDR3400 v3 | bcm47xx | mips74k | `netgear_wndr3400-v3` | 原生 |
| NETGEAR WNDR3400 vcna | NETGEAR WNDR3400 vcna | bcm47xx | mips74k | `netgear_wndr3400-vcna` | 原生 |
| NETGEAR WNDR3700 v3 | NETGEAR WNDR3700 v3 | bcm47xx | mips74k | `netgear_wndr3700-v3` | 原生 |
| NETGEAR WNDR3700 v5 | NETGEAR WNDR3700 v5 | ramips | mt7621 | `netgear_wndr3700-v5` | 原生 |
| NETGEAR WNDR4000 v1 | NETGEAR WNDR4000 v1 | bcm47xx | mips74k | `netgear_wndr4000` | 原生 |
| NETGEAR WNR834B v2 | NETGEAR WNR834B v2 | bcm47xx | legacy | `netgear_wnr834b-v2` | 原生 |
| NETGEAR WNR1000 v3 | NETGEAR WNR1000 v3 | bcm47xx | mips74k | `netgear_wnr1000-v3` | 原生 |
| NETGEAR WNR2000 v2 | NETGEAR WNR2000 v2 | bcm47xx | mips74k | `netgear_wnr2000-v2` | 原生 |
| NETGEAR WNR3500 v2 | NETGEAR WNR3500 v2 | bcm47xx | mips74k | `netgear_wnr3500-v2` | 原生 |
| NETGEAR WNR3500 v2 (VC) | NETGEAR WNR3500 v2 (VC) | bcm47xx | mips74k | `netgear_wnr3500-v2vc` | 原生 |
| NETGEAR WNR3500L v1 (NA) | NETGEAR WNR3500L v1 (NA) | bcm47xx | mips74k | `netgear_wnr3500l-v1na` | 原生 |
| NETGEAR WNR3500L v1 (ROW) | NETGEAR WNR3500L v1 (ROW) | bcm47xx | mips74k | `netgear_wnr3500l-v1` | 原生 |
| NETGEAR WNR3500L v2 | NETGEAR WNR3500L v2 | bcm47xx | mips74k | `netgear_wnr3500l-v2` | 原生 |
| NETGEAR WNR3500U | NETGEAR WNR3500U | bcm47xx | mips74k | `netgear_wnr3500u` | 原生 |
| 磊科N6 | netis N6 | ramips | mt7621 | `netis_n6` | 原生 |
| 磊科WF2770 | NETIS WF2770 | ramips | mt7620 | `netis_wf2770` | 原生 |
| 磊科WF2881 | NETIS WF2881 | ramips | mt7621 | `netis_wf2881` | 原生 |
| NexAira BC2 | NexAira BC2 | ramips | rt305x | `nexaira_bc2` | 原生 |
| Nexx WT1520 4M | Nexx WT1520 4M | ramips | rt305x | `nexx_wt1520-4m` | 原生 |
| Nexx WT1520 8M | Nexx WT1520 8M | ramips | rt305x | `nexx_wt1520-8m` | 原生 |
| Nexx WT3020 4M | Nexx WT3020 4M | ramips | mt7620 | `nexx_wt3020-4m` | 原生 |
| Nexx WT3020 8M | Nexx WT3020 8M | ramips | mt7620 | `nexx_wt3020-8m` | 原生 |
| Nixcore X1 8M | Nixcore X1 8M | ramips | rt305x | `nixcore_x1-8m` | 原生 |
| Nixcore X1 16M | Nixcore X1 16M | ramips | rt305x | `nixcore_x1-16m` | 原生 |
| Oh Yeah OY-0001 | Oh Yeah OY-0001 | ramips | mt7620 | `ohyeah_oy-0001` | 原生 |
| OLIMEX RT5350F-OLinuXino | OLIMEX RT5350F-OLinuXino | ramips | rt305x | `olimex_rt5350f-olinuxino` | 原生 |
| OLIMEX RT5350F-OLinuXino-EVB | OLIMEX RT5350F-OLinuXino-EVB | ramips | rt305x | `olimex_rt5350f-olinuxino-evb` | 原生 |
| Omnima HPM | Omnima HPM | ramips | rt3883 | `omnima_hpm` | 原生 |
| Omnima MiniEMBPlug | Omnima MiniEMBPlug | ramips | rt305x | `omnima_miniembplug` | 原生 |
| Omnima MiniEMBWiFi | Omnima MiniEMBWiFi | ramips | rt305x | `omnima_miniembwifi` | 原生 |
| Onion Omega2 | Onion Omega2 | ramips | mt76x8 | `onion_omega2` | 原生 |
| Onion Omega2+ | Onion Omega2+ | ramips | mt76x8 | `onion_omega2p` | 原生 |
| OpenFi 5Pro | OpenFi 5Pro | ramips | mt7621 | `openfi_5pro` | 原生 |
| OrayBox X1 | OrayBox X1 | ramips | mt76x8 | `oraybox_x1` | 原生 |
| OrayBox X3A | OrayBox X3A | ramips | mt7621 | `oraybox_x3a` | 原生 |
| PandoraBox PBR-D1 | PandoraBox PBR-D1 | ramips | mt76x8 | `d-team_pbr-d1` | 原生 |
| PandoraBox PBR-M1 | PandoraBox PBR-M1 | ramips | mt7621 | `d-team_pbr-m1` | 原生 |
| Petatel PSR-680W Wireless 3G Router | Petatel PSR-680W Wireless 3G Router | ramips | rt305x | `petatel_psr-680w` | 原生 |
| 斐讯K2（22.4及更早） | Phicomm K2 v22.4 or older | ramips | mt7620 | `phicomm_k2-v22.4` | 原生 |
| 斐讯K2（22.5及更新） | Phicomm K2 v22.5 or newer | ramips | mt7620 | `phicomm_k2-v22.5` | 原生 |
| 斐讯K2G | Phicomm K2G | ramips | mt7620 | `phicomm_k2g` | 原生 |
| 斐讯K2P | Phicomm K2P / Phicomm KE 2P | ramips | mt7621 | `phicomm_k2p` | 原生 |
| 斐讯PSG1208 | Phicomm PSG1208 | ramips | mt7620 | `phicomm_psg1208` | 原生 |
| 斐讯PSG1218 Bx | Phicomm PSG1218 Bx | ramips | mt7620 | `phicomm_psg1218b` | 原生 |
| Planex CS-QR10 | Planex CS-QR10 | ramips | mt7620 | `planex_cs-qr10` | 原生 |
| Planex DB-WRT01 | Planex DB-WRT01 | ramips | mt7620 | `planex_db-wrt01` | 原生 |
| Planex MZK-750DHP | Planex MZK-750DHP | ramips | mt7620 | `planex_mzk-750dhp` | 原生 |
| Planex MZK-DP150N | Planex MZK-DP150N | ramips | rt305x | `planex_mzk-dp150n` | 原生 |
| Planex MZK-EX300NP | Planex MZK-EX300NP | ramips | mt7620 | `planex_mzk-ex300np` | 原生 |
| Planex MZK-EX750NP | Planex MZK-EX750NP | ramips | mt7620 | `planex_mzk-ex750np` | 原生 |
| Planex MZK-W300NH2 | Planex MZK-W300NH2 | ramips | rt305x | `planex_mzk-w300nh2` | 原生 |
| Planex MZK-WDPR | Planex MZK-WDPR | ramips | rt305x | `planex_mzk-wdpr` | 原生 |
| Planex VR500 | Planex VR500 | ramips | mt7621 | `planex_vr500` | 原生 |
| Plasma Cloud PAX1800-Lite | Plasma Cloud PAX1800-Lite | ramips | mt7621 | `plasmacloud_pax1800-lite` | 原生 |
| Poray IP2202 | Poray IP2202 | ramips | rt305x | `poray_ip2202` | 原生 |
| Poray M3 | Poray M3 | ramips | rt305x | `poray_m3` | 原生 |
| Poray M4 4M | Poray M4 4M | ramips | rt305x | `poray_m4-4m` | 原生 |
| Poray M4 8M | Poray M4 8M | ramips | rt305x | `poray_m4-8m` | 原生 |
| Poray X5/X6 | Poray X5/X6 | ramips | rt305x | `poray_x5` | 原生 |
| Poray X8 | Poray X8 | ramips | rt305x | `poray_x8` | 原生 |
| Prolink PWH2004 | Prolink PWH2004 | ramips | rt305x | `prolink_pwh2004` | 原生 |
| Qding QC202 | Qding QC202 | ramips | mt76x8 | `qding_qc202` | 原生 |
| RAISECOM MSG1500 X.00 / Nokia A-040W-Q | RAISECOM MSG1500 X.00 / Nokia A-040W-Q | ramips | mt7621 | `raisecom_msg1500-x-00` | 原生 |
| Rakwireless RAK633 | Rakwireless RAK633 | ramips | mt76x8 | `rakwireless_rak633` | 原生 |
| Ralink AP-RT3052-V22RW-2X2 | Ralink AP-RT3052-V22RW-2X2 | ramips | rt305x | `ralink_v22rw-2x2` | 原生 |
| RAVPower RP-WD03 | RAVPower RP-WD03 | ramips | mt7620 | `ravpower_rp-wd03` | 原生 |
| RAVPower RP-WD009 | RAVPower RP-WD009 | ramips | mt76x8 | `ravpower_rp-wd009` | 原生 |
| Renkforce WS-WN530HP3-A | Renkforce WS-WN530HP3-A | ramips | mt7621 | `renkforce_ws-wn530hp3-a` | 原生 |
| Rostelecom RT-FE-1A / Sercomm RT-FE-1A | Rostelecom RT-FE-1A / Sercomm RT-FE-1A | ramips | mt7621 | `rostelecom_rt-fe-1a` | 原生 |
| Rostelecom RT-FL-1 / Sercomm RT-FL-1 | Rostelecom RT-FL-1 / Sercomm RT-FL-1 | ramips | mt7620 | `rostelecom_rt-fl-1` | 原生 |
| Rostelecom RT-SF-1 | Rostelecom RT-SF-1 | ramips | mt7621 | `rostelecom_rt-sf-1` | 原生 |
| Rostelecom S1010 / Sercomm S1010.RT | Rostelecom S1010 / Sercomm S1010.RT | ramips | mt7620 | `rostelecom_s1010` | 原生 |
| 锐捷RG-EW1200G PRO v1.1 | Ruijie RG-EW1200G PRO v1.1 | ramips | mt7621 | `ruijie_rg-ew1200g-pro-v1.1` | 原生 |
| 锐捷RG-EW1300G | Ruijie RG-EW1300G v1 | ramips | mt7621 | `ruijie_rg-ew1300g-v1` | 扩展 |
| SamKnows Whitebox 8 | SamKnows Whitebox 8 | ramips | mt7621 | `samknows_whitebox-v8` | 原生 |
| Samsung CY-SWR1100 | Samsung CY-SWR1100 | ramips | rt3883 | `samsung_cy-swr1100` | 原生 |
| Sanlinking Technologies D240 | Sanlinking Technologies D240 | ramips | mt7620 | `sanlinking_d240` | 原生 |
| SERCOMM NA502 | SERCOMM NA502 | ramips | mt7621 | `sercomm_na502` | 原生 |
| SERCOMM NA502S | SERCOMM NA502S | ramips | mt7621 | `sercomm_na502s` | 原生 |
| Sercomm NA930 | Sercomm NA930 | ramips | mt7620 | `sercomm_na930` | 原生 |
| SIM SIMAX1800T | SIM SIMAX1800T | ramips | mt7621 | `sim_simax1800t` | 原生 |
| SIM SIMAX1800U | SIM SIMAX1800U | ramips | mt7621 | `sim_simax1800u` | 原生 |
| Sitecom WL-351 v1 | Sitecom WL-351 v1 | ramips | rt305x | `sitecom_wl-351` | 原生 |
| Sitecom WLR-4100 v1 002 | Sitecom WLR-4100 v1 002 | ramips | mt7620 | `sitecom_wlr-4100-v1-002` | 原生 |
| Sitecom WLR-6000 | Sitecom WLR-6000 | ramips | rt3883 | `sitecom_wlr-6000` | 原生 |
| Skylab SKW92A | Skylab SKW92A | ramips | mt76x8 | `skylab_skw92a` | 原生 |
| Skyline SL-R7205 Wireless 3G Router | Skyline SL-R7205 Wireless 3G Router | ramips | rt305x | `skyline_sl-r7205` | 原生 |
| SNR CPE-W4N MT | SNR CPE-W4N MT | ramips | mt7620 | `snr_cpe-w4n-mt` | 原生 |
| SNR SNR-CPE-ME1 | SNR SNR-CPE-ME1 | ramips | mt7621 | `snr_snr-cpe-me1` | 原生 |
| SNR SNR-CPE-ME2-Lite | SNR SNR-CPE-ME2-Lite | ramips | mt7621 | `snr_snr-cpe-me2-lite` | 原生 |
| SNR SNR-CPE-ME2-SFP | SNR SNR-CPE-ME2-SFP | ramips | mt7621 | `snr_snr-cpe-me2-sfp` | 原生 |
| Sparklan WCR-150GN | Sparklan WCR-150GN | ramips | rt305x | `sparklan_wcr-150gn` | 原生 |
| STORYLiNK SAP-G3200U3 | STORYLiNK SAP-G3200U3 | ramips | mt7621 | `storylink_sap-g3200u3` | 原生 |
| Tama W06 | Tama W06 | ramips | mt76x8 | `tama_w06` | 原生 |
| Telco Electronics X1 | Telco Electronics X1 | ramips | mt7621 | `telco-electronics_x1` | 原生 |
| Teltonika RUT5XX | Teltonika RUT5XX | ramips | rt305x | `teltonika_rut5xx` | 原生 |
| Teltonika RUT200 v1-v4 | Teltonika RUT200 v1-v4 | ramips | mt76x8 | `teltonika_rut200` | 原生 |
| Teltonika RUT241 v1-v4 | Teltonika RUT241 v1-v4 | ramips | mt76x8 | `teltonika_rut241` | 原生 |
| Teltonika RUT951 / Teltonika RUT901 | Teltonika RUT951 / Teltonika RUT901 | ramips | mt76x8 | `teltonika_rut9x1` | 原生 |
| Teltonika RUT956 / Teltonika RUT906 | Teltonika RUT956 / Teltonika RUT906 | ramips | mt76x8 | `teltonika_rut9x6` | 原生 |
| Teltonika RUT976 | Teltonika RUT976 | ramips | mt76x8 | `teltonika_rut976` | 原生 |
| Teltonika RUTM11 | Teltonika RUTM11 | ramips | mt7621 | `teltonika_rutm11` | 扩展 |
| Teltonika RUTM30 / Teltonika RUTM31 | Teltonika RUTM30 / Teltonika RUTM31 | ramips | mt7621 | `teltonika_rutm30` | 扩展 |
| Teltonika RUTM50 / Teltonika RUTM51 | Teltonika RUTM50 / Teltonika RUTM51 | ramips | mt7621 | `teltonika_rutm50` | 扩展 |
| Tenbay T-MB5EU-V01 | Tenbay T-MB5EU-V01 | ramips | mt7621 | `tenbay_t-mb5eu-v01` | 原生 |
| 腾达3G150B | Tenda 3G150B | ramips | rt305x | `tenda_3g150b` | 原生 |
| 腾达3G300M | Tenda 3G300M | ramips | rt305x | `tenda_3g300m` | 原生 |
| 腾达W150M | Tenda W150M | ramips | rt305x | `tenda_w150m` | 原生 |
| 腾达W306R V2.0 | Tenda W306R V2.0 | ramips | rt305x | `tenda_w306r-v2` | 原生 |
| Thunder Timecloud | Thunder Timecloud | ramips | mt7621 | `thunder_timecloud` | 原生 |
| TOTOLINK A3 | TOTOLINK A3 | ramips | mt76x8 | `totolink_a3` | 原生 |
| TOTOLINK A7000R | TOTOLINK A7000R | ramips | mt7621 | `totolink_a7000r` | 原生 |
| TOTOLINK LR1200 | TOTOLINK LR1200 | ramips | mt76x8 | `totolink_lr1200` | 原生 |
| TOTOLINK X5000R | TOTOLINK X5000R | ramips | mt7621 | `totolink_x5000r` | 原生 |
| TOZED ZLT S12 PRO | TOZED ZLT S12 PRO | ramips | mt7621 | `tozed_zlt-s12-pro` | 原生 |
| TP-Link Archer A6 V3 | TP-Link Archer A6 V3 | ramips | mt7621 | `tplink_archer-a6-v3` | 原生 |
| TP-Link Archer AX21 v4 | TP-Link Archer AX21 v4 | ramips | mt7621 | `tplink_archer-ax21-v4` | 原生 |
| TP-Link Archer AX23 v1 | TP-Link Archer AX23 v1 | ramips | mt7621 | `tplink_archer-ax23-v1` | 原生 |
| TP-Link Archer C2 v1 | TP-Link Archer C2 v1 | ramips | mt7620 | `tplink_archer-c2-v1` | 原生 |
| TP-Link Archer C5 v4 | TP-Link Archer C5 v4 | ramips | mt7620 | `tplink_archer-c5-v4` | 原生 |
| TP-Link Archer C6 V3 | TP-Link Archer C6 V3 | ramips | mt7621 | `tplink_archer-c6-v3` | 原生 |
| TP-Link Archer C6U v1 | TP-Link Archer C6U v1 | ramips | mt7621 | `tplink_archer-c6u-v1` | 原生 |
| TP-Link Archer C20 v1 | TP-Link Archer C20 v1 | ramips | mt7620 | `tplink_archer-c20-v1` | 原生 |
| TP-Link Archer C20 v4 | TP-Link Archer C20 v4 | ramips | mt76x8 | `tplink_archer-c20-v4` | 原生 |
| TP-Link Archer C20 v5 | TP-Link Archer C20 v5 | ramips | mt76x8 | `tplink_archer-c20-v5` | 原生 |
| TP-Link Archer C20i | TP-Link Archer C20i | ramips | mt7620 | `tplink_archer-c20i` | 原生 |
| TP-Link Archer C50 v1 | TP-Link Archer C50 v1 | ramips | mt7620 | `tplink_archer-c50-v1` | 原生 |
| TP-Link Archer C50 v3 | TP-Link Archer C50 v3 | ramips | mt76x8 | `tplink_archer-c50-v3` | 原生 |
| TP-Link Archer C50 v4 | TP-Link Archer C50 v4 | ramips | mt76x8 | `tplink_archer-c50-v4` | 原生 |
| TP-Link Archer C50 v6 (CA/EU/RU) / Archer A5 v6 (CA/EU/RU) | TP-Link Archer C50 v6 (CA/EU/RU) / Archer A5 v6 (CA/EU/RU) | ramips | mt76x8 | `tplink_archer-c50-v6` | 原生 |
| TP-Link Archer MR200 | TP-Link Archer MR200 | ramips | mt7620 | `tplink_archer-mr200` | 原生 |
| TP-Link Archer MR200 v5 | TP-Link Archer MR200 v5 | ramips | mt76x8 | `tplink_archer-mr200-v5` | 原生 |
| TP-Link Archer MR200 v6 | TP-Link Archer MR200 v6 | ramips | mt76x8 | `tplink_archer-mr200-v6` | 原生 |
| TP-Link Deco M4R v4 | TP-Link Deco M4R v4 | ramips | mt7621 | `tplink_deco-m4r-v4` | 原生 |
| TP-Link EAP235-Wall v1 | TP-Link EAP235-Wall v1 | ramips | mt7621 | `tplink_eap235-wall-v1` | 原生 |
| TP-Link EAP613 v1 | TP-Link EAP613 v1 | ramips | mt7621 | `tplink_eap613-v1` | 原生 |
| TP-Link EAP615-Wall v1 | TP-Link EAP615-Wall v1 | ramips | mt7621 | `tplink_eap615-wall-v1` | 原生 |
| TP-Link EC220-G5 v2 | TP-Link EC220-G5 v2 | ramips | mt7620 | `tplink_ec220-g5-v2` | 原生 |
| TP-Link EC330-G5u v1 / TP-Link Archer C9ERT | TP-Link EC330-G5u v1 / TP-Link Archer C9ERT | ramips | mt7621 | `tplink_ec330-g5u-v1` | 原生 |
| TP-Link ER605 v1 / TP-Link TL-R605 v1 | TP-Link ER605 v1 / TP-Link TL-R605 v1 | ramips | mt7621 | `tplink_er605-v1` | 原生 |
| TP-Link ER605 v2 / TP-Link FR205 v1 | TP-Link ER605 v2 / TP-Link FR205 v1 | ramips | mt7621 | `tplink_er605-v2` | 原生 |
| TP-Link EX220 v1 | TP-Link EX220 v1 | ramips | mt7621 | `tplink_ex220-v1` | 原生 |
| TP-Link EX220 v2 | TP-Link EX220 v2 | ramips | mt7621 | `tplink_ex220-v2` | 原生 |
| TP-Link MR600 v2 (EU) | TP-Link MR600 v2 (EU) | ramips | mt7621 | `tplink_mr600-v2-eu` | 原生 |
| TP-Link RE200 v1 | TP-Link RE200 v1 | ramips | mt7620 | `tplink_re200-v1` | 原生 |
| TP-Link RE200 v2 | TP-Link RE200 v2 | ramips | mt76x8 | `tplink_re200-v2` | 原生 |
| TP-Link RE200 v3 | TP-Link RE200 v3 | ramips | mt76x8 | `tplink_re200-v3` | 原生 |
| TP-Link RE200 v4 | TP-Link RE200 v4 | ramips | mt76x8 | `tplink_re200-v4` | 原生 |
| TP-Link RE205 v3 | TP-Link RE205 v3 | ramips | mt76x8 | `tplink_re205-v3` | 原生 |
| TP-Link RE210 v1 | TP-Link RE210 v1 | ramips | mt7620 | `tplink_re210-v1` | 原生 |
| TP-Link RE220 v2 | TP-Link RE220 v2 | ramips | mt76x8 | `tplink_re220-v2` | 原生 |
| TP-Link RE305 v1 | TP-Link RE305 v1 | ramips | mt76x8 | `tplink_re305-v1` | 原生 |
| TP-Link RE305 v3 | TP-Link RE305 v3 | ramips | mt76x8 | `tplink_re305-v3` | 原生 |
| TP-Link RE350 v1 | TP-Link RE350 v1 | ramips | mt7621 | `tplink_re350-v1` | 原生 |
| TP-Link RE365 v1 | TP-Link RE365 v1 | ramips | mt76x8 | `tplink_re365-v1` | 原生 |
| TP-Link RE500 v1 | TP-Link RE500 v1 | ramips | mt7621 | `tplink_re500-v1` | 原生 |
| TP-Link RE650 v1 | TP-Link RE650 v1 | ramips | mt7621 | `tplink_re650-v1` | 原生 |
| TP-Link RE650 v2 | TP-Link RE650 v2 | ramips | mt7621 | `tplink_re650-v2` | 原生 |
| TP-Link TL-MR3020 v3 | TP-Link TL-MR3020 v3 | ramips | mt76x8 | `tplink_tl-mr3020-v3` | 原生 |
| TP-Link TL-MR3420 v5 | TP-Link TL-MR3420 v5 | ramips | mt76x8 | `tplink_tl-mr3420-v5` | 原生 |
| TP-Link TL-MR6400 v4 | TP-Link TL-MR6400 v4 | ramips | mt76x8 | `tplink_tl-mr6400-v4` | 原生 |
| TP-Link TL-MR6400 v5 | TP-Link TL-MR6400 v5 | ramips | mt76x8 | `tplink_tl-mr6400-v5` | 原生 |
| TP-Link TL-MR6400 v7 | TP-Link TL-MR6400 v7 | ramips | mt76x8 | `tplink_tl-mr6400-v7` | 扩展 |
| TP-Link TL-WA801ND v5 | TP-Link TL-WA801ND v5 | ramips | mt76x8 | `tplink_tl-wa801nd-v5` | 原生 |
| TP-Link TL-WPA8631P v3 | TP-Link TL-WPA8631P v3 | ramips | mt7621 | `tplink_tl-wpa8631p-v3` | 原生 |
| TP-Link TL-WR802N v4 | TP-Link TL-WR802N v4 | ramips | mt76x8 | `tplink_tl-wr802n-v4` | 原生 |
| TP-Link TL-WR840N v4 | TP-Link TL-WR840N v4 | ramips | mt76x8 | `tplink_tl-wr840n-v4` | 原生 |
| TP-Link TL-WR840N v5 | TP-Link TL-WR840N v5 | ramips | mt76x8 | `tplink_tl-wr840n-v5` | 原生 |
| TP-Link TL-WR841N v13 | TP-Link TL-WR841N v13 | ramips | mt76x8 | `tplink_tl-wr841n-v13` | 原生 |
| TP-Link TL-WR841N v14 | TP-Link TL-WR841N v14 | ramips | mt76x8 | `tplink_tl-wr841n-v14` | 原生 |
| TP-Link TL-WR842N v5 | TP-Link TL-WR842N v5 | ramips | mt76x8 | `tplink_tl-wr842n-v5` | 原生 |
| TP-Link TL-WR850N v2 | TP-Link TL-WR850N v2 | ramips | mt76x8 | `tplink_tl-wr850n-v2` | 原生 |
| TP-Link TL-WR902AC v3 | TP-Link TL-WR902AC v3 | ramips | mt76x8 | `tplink_tl-wr902ac-v3` | 原生 |
| TP-Link TL-WR902AC v4 | TP-Link TL-WR902AC v4 | ramips | mt76x8 | `tplink_tl-wr902ac-v4` | 原生 |
| TRENDnet TEW-638APB v2 | TRENDnet TEW-638APB v2 | ramips | rt305x | `trendnet_tew-638apb-v2` | 原生 |
| TRENDnet TEW-691GR | TRENDnet TEW-691GR | ramips | rt3883 | `trendnet_tew-691gr` | 原生 |
| TRENDnet TEW-692GR | TRENDnet TEW-692GR | ramips | rt3883 | `trendnet_tew-692gr` | 原生 |
| TRENDnet TEW-714TRU | TRENDnet TEW-714TRU | ramips | rt305x | `trendnet_tew-714tru` | 原生 |
| TRENDnet TEW-810DR | TRENDnet TEW-810DR | ramips | mt7620 | `trendnet_tew-810dr` | 原生 |
| TRENDnet THA-103AC | TRENDnet THA-103AC | ramips | mt7620 | `trendnet_tha103ac` | 原生 |
| Ubiquiti EdgeRouter X | Ubiquiti EdgeRouter X | ramips | mt7621 | `ubnt_edgerouter-x` | 原生 |
| Ubiquiti EdgeRouter X SFP / Ubiquiti EdgePoint R6 | Ubiquiti EdgeRouter X SFP / Ubiquiti EdgePoint R6 | ramips | mt7621 | `ubnt_edgerouter-x-sfp` | 原生 |
| Ubiquiti UniFi FlexHD | Ubiquiti UniFi FlexHD | ramips | mt7621 | `ubnt_unifi-flexhd` | 原生 |
| Ubiquiti UniFi nanoHD | Ubiquiti UniFi nanoHD | ramips | mt7621 | `ubnt_unifi-nanohd` | 原生 |
| Ubiquiti UniFi Switch Flex | Ubiquiti UniFi Switch Flex | ramips | mt7621 | `ubnt_usw-flex` | 原生 |
| Ubiquiti UniFi U6 Lite | Ubiquiti UniFi U6 Lite | ramips | mt7621 | `ubnt_unifi-6-lite` | 原生 |
| Unbranded A5-V11 | Unbranded A5-V11 | ramips | rt305x | `unbranded_a5-v11` | 原生 |
| Unbranded WR512-3GN 4M | Unbranded WR512-3GN 4M | ramips | rt305x | `unbranded_wr512-3gn-4m` | 原生 |
| Unbranded WR512-3GN 8M | Unbranded WR512-3GN 8M | ramips | rt305x | `unbranded_wr512-3gn-8m` | 原生 |
| Unbranded XDX-RN502J | Unbranded XDX-RN502J | ramips | rt305x | `unbranded_xdx-rn502j` | 原生 |
| UniElec U7621-01 16M | UniElec U7621-01 16M | ramips | mt7621 | `unielec_u7621-01-16m` | 原生 |
| UniElec U7621-06 16M | UniElec U7621-06 16M | ramips | mt7621 | `unielec_u7621-06-16m` | 原生 |
| UniElec U7621-06 32M | UniElec U7621-06 32M | ramips | mt7621 | `unielec_u7621-06-32m` | 原生 |
| UniElec U7621-06 64M | UniElec U7621-06 64M | ramips | mt7621 | `unielec_u7621-06-64m` | 原生 |
| UniElec U7628-01 16M | UniElec U7628-01 16M | ramips | mt76x8 | `unielec_u7628-01-16m` | 原生 |
| UPVEL UR-326N4G | UPVEL UR-326N4G | ramips | rt305x | `upvel_ur-326n4g` | 原生 |
| UPVEL UR-336UN | UPVEL UR-336UN | ramips | rt305x | `upvel_ur-336un` | 原生 |
| US Robotics USR5461 | US Robotics USR5461 | bcm47xx | legacy | `usrobotics_usr5461` | 原生 |
| VoCore VoCore2 | VoCore VoCore2 | ramips | mt76x8 | `vocore_vocore2` | 原生 |
| VoCore VoCore2-Lite | VoCore VoCore2-Lite | ramips | mt76x8 | `vocore_vocore2-lite` | 原生 |
| VoCore VoCore 8M | VoCore VoCore 8M | ramips | rt305x | `vocore_vocore-8m` | 原生 |
| VoCore VoCore 16M | VoCore VoCore 16M | ramips | rt305x | `vocore_vocore-16m` | 原生 |
| Vonets VAR11N-300 | Vonets VAR11N-300 | ramips | mt7620 | `vonets_var11n-300` | 原生 |
| Wansview NCS601W | Wansview NCS601W | ramips | rt305x | `wansview_ncs601w` | 原生 |
| Wavlink Halo Base Pro | Wavlink Halo Base Pro | ramips | mt7621 | `wavlink_halo-base-pro` | 扩展 |
| Wavlink WL-WN530HG4 | Wavlink WL-WN530HG4 | ramips | mt7620 | `wavlink_wl-wn530hg4` | 原生 |
| Wavlink WL-WN531A3 / Wavlink QUANTUM D4 | Wavlink WL-WN531A3 / Wavlink QUANTUM D4 | ramips | mt76x8 | `wavlink_wl-wn531a3` | 原生 |
| Wavlink WL-WN531A6 | Wavlink WL-WN531A6 | ramips | mt7621 | `wavlink_wl-wn531a6` | 原生 |
| Wavlink WL-WN531G3 | Wavlink WL-WN531G3 | ramips | mt7620 | `wavlink_wl-wn531g3` | 原生 |
| Wavlink WL-WN531G3-A2 | Wavlink WL-WN531G3-A2 | ramips | mt7620 | `wavlink_wl-wn531g3-a2` | 原生 |
| Wavlink WL-WN533A8 | Wavlink WL-WN533A8 | ramips | mt7621 | `wavlink_wl-wn533a8` | 原生 |
| Wavlink WL-WN535K1 / Talius TAL-WMESH1 | Wavlink WL-WN535K1 / Talius TAL-WMESH1 | ramips | mt7620 | `wavlink_wl-wn535k1` | 原生 |
| Wavlink WL-WN570HA1 | Wavlink WL-WN570HA1 | ramips | mt76x8 | `wavlink_wl-wn570ha1` | 原生 |
| Wavlink WL-WN570HA2 | Wavlink WL-WN570HA2 | ramips | mt76x8 | `wavlink_wl-wn570ha2` | 原生 |
| Wavlink WL-WN573HX1 | Wavlink WL-WN573HX1 | ramips | mt7621 | `wavlink_wl-wn573hx1` | 原生 |
| Wavlink WL-WN575A3 | Wavlink WL-WN575A3 | ramips | mt76x8 | `wavlink_wl-wn575a3` | 原生 |
| Wavlink WL-WN576A2 / Silvercrest SWV 733 B1 | Wavlink WL-WN576A2 / Silvercrest SWV 733 B1 | ramips | mt76x8 | `wavlink_wl-wn576a2` | 原生 |
| Wavlink WL-WN577A2 / Maginon WLR-755 | Wavlink WL-WN577A2 / Maginon WLR-755 | ramips | mt76x8 | `wavlink_wl-wn577a2` | 原生 |
| Wavlink WL-WN578A2 / SilverCrest SWV 733 A2 | Wavlink WL-WN578A2 / SilverCrest SWV 733 A2 | ramips | mt76x8 | `wavlink_wl-wn578a2` | 原生 |
| Wavlink WL-WN579X3 | Wavlink WL-WN579X3 | ramips | mt7620 | `wavlink_wl-wn579x3` | 原生 |
| Wavlink WS-WN572HP3 4G | Wavlink WS-WN572HP3 4G | ramips | mt7621 | `wavlink_ws-wn572hp3-4g` | 原生 |
| WeVO 11AC NAS Router | WeVO 11AC NAS Router | ramips | mt7621 | `wevo_11acnas` | 原生 |
| WeVO AIR DUO | WeVO AIR DUO | ramips | mt7620 | `wevo_air-duo` | 原生 |
| WeVO W2914NS v2 | WeVO W2914NS v2 | ramips | mt7621 | `wevo_w2914ns-v2` | 原生 |
| Widora Widora-NEO 16M | Widora Widora-NEO 16M | ramips | mt76x8 | `widora_neo-16m` | 原生 |
| Widora Widora-NEO 32M | Widora Widora-NEO 32M | ramips | mt76x8 | `widora_neo-32m` | 原生 |
| WiFire S1500.NBN / Sercomm S1500 BUC | WiFire S1500.NBN / Sercomm S1500 BUC | ramips | mt7621 | `wifire_s1500-nbn` | 原生 |
| Winstars WS-WN536P3 | Winstars WS-WN536P3 | ramips | mt7621 | `winstars_ws-wn536p3` | 原生 |
| Winstars WS-WN583A6 / Gemeita AC2100 | Winstars WS-WN583A6 / Gemeita AC2100 | ramips | mt7621 | `winstars_ws-wn583a6` | 原生 |
| WIZnet WizFi630A | WIZnet WizFi630A | ramips | rt305x | `wiznet_wizfi630a` | 原生 |
| WIZnet WizFi630S | WIZnet WizFi630S | ramips | mt76x8 | `wiznet_wizfi630s` | 原生 |
| Wodesys WD-R1208U | Wodesys WD-R1208U | ramips | mt76x8 | `wodesys_wd-r1208u` | 原生 |
| Wodesys WD-R1802U | Wodesys WD-R1802U | ramips | mt7621 | `wodesys_wd-r1802u` | 原生 |
| WRTNode WRTNode | WRTNode WRTNode | ramips | mt7620 | `wrtnode_wrtnode` | 原生 |
| WRTnode WRTnode 2P | WRTnode WRTnode 2P | ramips | mt76x8 | `wrtnode_wrtnode2p` | 原生 |
| WRTnode WRTnode 2R | WRTnode WRTnode 2R | ramips | mt76x8 | `wrtnode_wrtnode2r` | 原生 |
| 小米路由器3 Pro | Xiaomi Mi Router 3 Pro | ramips | mt7621 | `xiaomi_mi-router-3-pro` | 原生 |
| 小米路由器3G | Xiaomi Mi Router 3G | ramips | mt7621 | `xiaomi_mi-router-3g` | 原生 |
| 小米路由器3G V2 | Xiaomi Mi Router 3G v2 | ramips | mt7621 | `xiaomi_mi-router-3g-v2` | 原生 |
| 小米路由器4 | Xiaomi Mi Router 4 | ramips | mt7621 | `xiaomi_mi-router-4` | 原生 |
| 小米路由器4A百兆版 | Xiaomi Mi Router 4A 100M Edition | ramips | mt76x8 | `xiaomi_mi-router-4a-100m` | 原生 |
| 小米路由器4A百兆版（国际版） | Xiaomi Mi Router 4A 100M International Edition | ramips | mt76x8 | `xiaomi_mi-router-4a-100m-intl` | 原生 |
| 小米路由器4A百兆版（国际版V2） | Xiaomi Mi Router 4A 100M International Edition V2 | ramips | mt76x8 | `xiaomi_mi-router-4a-100m-intl-v2` | 原生 |
| 小米路由器4A千兆版 | Xiaomi Mi Router 4A Gigabit Edition | ramips | mt7621 | `xiaomi_mi-router-4a-gigabit` | 原生 |
| 小米路由器4A千兆版V2 | Xiaomi Mi Router 4A Gigabit Edition v2 | ramips | mt7621 | `xiaomi_mi-router-4a-gigabit-v2` | 原生 |
| 小米路由器4C | Xiaomi Mi Router 4C | ramips | mt76x8 | `xiaomi_mi-router-4c` | 原生 |
| 小米路由器AC2100 | Xiaomi Mi Router AC2100 | ramips | mt7621 | `xiaomi_mi-router-ac2100` | 原生 |
| 小米路由器CR6606 | Xiaomi Mi Router CR6606 | ramips | mt7621 | `xiaomi_mi-router-cr6606` | 原生 |
| 小米路由器CR6608 | Xiaomi Mi Router CR6608 | ramips | mt7621 | `xiaomi_mi-router-cr6608` | 原生 |
| 小米路由器CR6609 | Xiaomi Mi Router CR6609 | ramips | mt7621 | `xiaomi_mi-router-cr6609` | 原生 |
| 小米路由器3A | Xiaomi MiWiFi 3A | ramips | mt76x8 | `xiaomi_miwifi-3a` | 原生 |
| 小米路由器3C | Xiaomi MiWiFi 3C | ramips | mt76x8 | `xiaomi_miwifi-3c` | 原生 |
| 小米路由器mini | Xiaomi MiWiFi Mini | ramips | mt7620 | `xiaomi_miwifi-mini` | 原生 |
| 小米路由器nano | Xiaomi MiWiFi Nano | ramips | mt76x8 | `xiaomi_miwifi-nano` | 原生 |
| 小米WiFi放大器AC1200（RA75） | Xiaomi MiWiFi Range Extender AC1200  RA75 | ramips | mt76x8 | `xiaomi_mi-ra75` | 原生 |
| 红米路由器AC2100 | Xiaomi Redmi Router AC2100 | ramips | mt7621 | `xiaomi_redmi-router-ac2100` | 原生 |
| 小娱C5 | XiaoYu XY-C5 | ramips | mt7621 | `xiaoyu_xy-c5` | 原生 |
| YouHua WR1200JS | YouHua WR1200JS | ramips | mt7621 | `youhua_wr1200js` | 原生 |
| 优酷路由宝X2 | Youku X2 | ramips | mt7620 | `youku_x2` | 原生 |
| 优酷路由宝YK-L1 | Youku YK-L1 | ramips | mt7620 | `youku_yk-l1` | 原生 |
| 优酷路由宝YK-L1c | Youku YK-L1c | ramips | mt7620 | `youku_yk-l1c` | 原生 |
| 优酷路由宝YK-L2 | Youku YK-L2 | ramips | mt7621 | `youku_yk-l2` | 原生 |
| YUKAI Engineering BOCCO | YUKAI Engineering BOCCO | ramips | mt7620 | `yukai_bocco` | 原生 |
| 云联友科Yuncore 1200F | Yuncore 1200F / KuWFi AP1200F | ramips | mt76x8 | `yuncore_1200f` | 扩展 |
| 云联友科AX820 | YunCore AX820 | ramips | mt7621 | `yuncore_ax820` | 原生 |
| 云联友科Yuncore CPE200 | Yuncore CPE200 | ramips | mt76x8 | `yuncore_cpe200` | 原生 |
| 云联友科FAP640 | YunCore FAP640 | ramips | mt7621 | `yuncore_fap640` | 原生 |
| 云联友科FAP690 | YunCore FAP690 | ramips | mt7621 | `yuncore_fap690` | 原生 |
| 云联友科G720 | YunCore G720 | ramips | mt7621 | `yuncore_g720` | 原生 |
| 云联友科Yuncore M300 | Yuncore M300 | ramips | mt76x8 | `yuncore_m300` | 原生 |
| Z-ROUTER ZR-2660 / Routerich AX1800 | Z-ROUTER ZR-2660 / Routerich AX1800 | ramips | mt7621 | `z-router_zr-2660` | 原生 |
| Z-ROUTER ZR-2662 | Z-ROUTER ZR-2662 | ramips | mt7621 | `z-router_zr-2662` | 扩展 |
| 智博通ZBT-APE522II | Zbtlink ZBT-APE522II | ramips | mt7620 | `zbtlink_zbt-ape522ii` | 原生 |
| 智博通ZBT-CPE102 | Zbtlink ZBT-CPE102 | ramips | mt7620 | `zbtlink_zbt-cpe102` | 原生 |
| 智博通ZBT-WA05 | Zbtlink ZBT-WA05 | ramips | mt7620 | `zbtlink_zbt-wa05` | 原生 |
| 智博通ZBT-WE826 16M | Zbtlink ZBT-WE826 16M | ramips | mt7620 | `zbtlink_zbt-we826-16m` | 原生 |
| 智博通ZBT-WE826 32M | Zbtlink ZBT-WE826 32M | ramips | mt7620 | `zbtlink_zbt-we826-32m` | 原生 |
| 智博通ZBT-WE826-E | Zbtlink ZBT-WE826-E | ramips | mt7620 | `zbtlink_zbt-we826-e` | 原生 |
| 智博通ZBT-WE1026-5G 16M | Zbtlink ZBT-WE1026-5G 16M | ramips | mt7620 | `zbtlink_zbt-we1026-5g-16m` | 原生 |
| 智博通ZBT-WE1026-H 32M | Zbtlink ZBT-WE1026-H 32M | ramips | mt7620 | `zbtlink_zbt-we1026-h-32m` | 原生 |
| 智博通ZBT-WE1226 | Zbtlink ZBT-WE1226 | ramips | mt76x8 | `zbtlink_zbt-we1226` | 原生 |
| 智博通ZBT-WE1326 | Zbtlink ZBT-WE1326 / Wiflyer WF3526-P | ramips | mt7621 | `zbtlink_zbt-we1326` | 原生 |
| 智博通ZBT-WE2026 | Zbtlink ZBT-WE2026 | ramips | mt7620 | `zbtlink_zbt-we2026` | 原生 |
| 智博通ZBT-WE2426-B | Zbtlink ZBT-WE2426-B | ramips | mt76x8 | `zbtlink_zbt-we2426-b` | 原生 |
| 智博通ZBT-WE3526 | Zbtlink ZBT-WE3526 | ramips | mt7621 | `zbtlink_zbt-we3526` | 原生 |
| 智博通ZBT-WG108 | Zbtlink ZBT-WG108 | ramips | mt7621 | `zbtlink_zbt-wg108` | 原生 |
| 智博通ZBT-WG1602 16M | Zbtlink ZBT-WG1602 16M | ramips | mt7621 | `zbtlink_zbt-wg1602-16m` | 原生 |
| 智博通ZBT-WG1602-V04 16M | Zbtlink ZBT-WG1602-V04 16M | ramips | mt7621 | `zbtlink_zbt-wg1602-v04-16m` | 原生 |
| 智博通ZBT-WG1602-V04 32M | Zbtlink ZBT-WG1602-V04 32M | ramips | mt7621 | `zbtlink_zbt-wg1602-v04-32m` | 原生 |
| 智博通ZBT-WG1608 16M | Zbtlink ZBT-WG1608 16M | ramips | mt7621 | `zbtlink_zbt-wg1608-16m` | 原生 |
| 智博通ZBT-WG1608 32M | Zbtlink ZBT-WG1608 32M | ramips | mt7621 | `zbtlink_zbt-wg1608-32m` | 原生 |
| 智博通ZBT-WG2626 | Zbtlink ZBT-WG2626 | ramips | mt7621 | `zbtlink_zbt-wg2626` | 原生 |
| 智博通ZBT-WG3526 16M | Zbtlink ZBT-WG3526 16M | ramips | mt7621 | `zbtlink_zbt-wg3526-16m` | 原生 |
| 智博通ZBT-WG3526 32M | Zbtlink ZBT-WG3526 32M | ramips | mt7621 | `zbtlink_zbt-wg3526-32m` | 原生 |
| 智博通ZBT-WR8305RT | Zbtlink ZBT-WR8305RT | ramips | mt7620 | `zbtlink_zbt-wr8305rt` | 原生 |
| ZIO FREEZIO | ZIO FREEZIO | ramips | mt7621 | `zio_freezio` | 原生 |
| Zorlik ZL5900V2 | Zorlik ZL5900V2 | ramips | rt305x | `zorlik_zl5900v2` | 原生 |
| 中兴MF283+ | ZTE MF283+ | ramips | rt305x | `zte_mf283plus` | 原生 |
| 中兴Q7 | ZTE Q7 | ramips | mt7620 | `zte_q7` | 原生 |
| Zyxel Keenetic | Zyxel Keenetic | ramips | rt305x | `zyxel_keenetic` | 原生 |
| Zyxel Keenetic 4G B | Zyxel Keenetic 4G B | ramips | rt305x | `zyxel_keenetic-4g-b` | 原生 |
| Zyxel Keenetic Extra II | Zyxel Keenetic Extra II | ramips | mt76x8 | `zyxel_keenetic-extra-ii` | 原生 |
| Zyxel Keenetic Lite B | Zyxel Keenetic Lite B | ramips | rt305x | `zyxel_keenetic-lite-b` | 原生 |
| Zyxel Keenetic Lite III A | Zyxel Keenetic Lite III A | ramips | mt7620 | `zyxel_keenetic-lite-iii-a` | 原生 |
| Zyxel Keenetic Omni | Zyxel Keenetic Omni | ramips | mt7620 | `zyxel_keenetic-omni` | 原生 |
| Zyxel Keenetic Omni II | Zyxel Keenetic Omni II | ramips | mt7620 | `zyxel_keenetic-omni-ii` | 原生 |
| Zyxel Keenetic Start | Zyxel Keenetic Start | ramips | rt305x | `zyxel_keenetic-start` | 原生 |
| Zyxel Keenetic Viva | Zyxel Keenetic Viva | ramips | mt7620 | `zyxel_keenetic-viva` | 原生 |
| Zyxel LTE3301-PLUS | Zyxel LTE3301-PLUS | ramips | mt7621 | `zyxel_lte3301-plus` | 原生 |
| Zyxel LTE5398-M904 | Zyxel LTE5398-M904 | ramips | mt7621 | `zyxel_lte5398-m904` | 原生 |
| Zyxel LTE7490-M904 | Zyxel LTE7490-M904 | ramips | mt7621 | `zyxel_lte7490-m904` | 原生 |
| Zyxel NBG-419N | Zyxel NBG-419N | ramips | rt305x | `zyxel_nbg-419n` | 原生 |
| Zyxel NBG-419N v2 | Zyxel NBG-419N v2 | ramips | rt305x | `zyxel_nbg-419n-v2` | 原生 |
| Zyxel NR7101 | Zyxel NR7101 | ramips | mt7621 | `zyxel_nr7101` | 原生 |
| Zyxel NWA50AX / Zyxel NWA90AX | Zyxel NWA50AX / Zyxel NWA90AX | ramips | mt7621 | `zyxel_nwa50ax` | 原生 |
| Zyxel NWA55AXE | Zyxel NWA55AXE | ramips | mt7621 | `zyxel_nwa55axe` | 原生 |
| Zyxel WAP6805 | Zyxel WAP6805 | ramips | mt7621 | `zyxel_wap6805` | 原生 |
| Zyxel WSM20 | Zyxel WSM20 | ramips | mt7621 | `zyxel_wsm20` | 原生 |
| 7Links PX-4885 4M | 7Links PX-4885 4M | ramips | rt305x | `7links_px-4885-4m` | 原生 |
| 7Links PX-4885 8M | 7Links PX-4885 8M | ramips | rt305x | `7links_px-4885-8m` | 原生 |
| 7Links WLR-1230 | 7Links WLR-1230 | ramips | mt76x8 | `7links_wlr-1230` | 原生 |
| 7Links WLR-1240 | 7Links WLR-1240 | ramips | mt76x8 | `7links_wlr-1240` | 原生 |
| 8devices Carambola | 8devices Carambola | ramips | rt305x | `8devices_carambola` | 原生 |
