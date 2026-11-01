# arm 设备列表（FanchmWrt v25.12.6）

用于 `Firmware build` 申请的 `target` / `subtarget` / `profile` 三个字段，`architecture` 选 `arm`。

- 枚举到 **760** 个 profile，仅供参考：上游仓库 721，扩展设备仓库 39
- 已标注常用名：**68**，其余保留上游原名
- 涉及 target/subtarget：46 组
- 排序：按设备型号字母/数字顺序（a–z、0–9），常用名不参与排序
- 权威来源是上游仓库：扩展仓库与上游重合时，一律以上游仓库的版本为准
- 本表由 `.github/workflows/sync-upstream-refs.yml` 每天随上游版本自动重新生成，无需手工维护

## 数据来源

- 上游型号：`fanchmwrt/fanchmwrt` 标签 `v25.12.6`，由 `scripts/dump-target-info.pl devices` 枚举，是本表的权威来源
- 扩展型号：`nd002723/fanchmwrt-device-backports`（55 个补丁，基线提交 `64900e756efa667774214f9c6b17c113222e01f7`），仅作补充参考

  两处可能重合，合并时以上游仓库为准：上游已有同名 profile 时，本条只按上游记录，不按扩展计入。

  扩展型号直接选 `upstream_ref: fanchmwrt-25.12.6` 即可：补丁集按版本分分支（`v25.12.6`、`v25.12.4`……，`main` 指向最新），基线提交是 `64900e756efa667774214f9c6b17c113222e01f7`。所选版本没有同名分支时回落到 `main`；构建若提示基线不匹配，把 `upstream_ref_override` 填成上面的基线提交。只是列出未必可用，提交前请先按上方参数试一次。

  纯 `v25.12.6` 标签不含私有层（`fwxd`、`luci-app-fwx-*` 应用中心），用带 `fanchmwrt-` 前缀的维护分支才能通过构建校验。

- x86 只有一个可构建型号 `x86/64/generic`，不单独成文。

## 填写范例

```text
upstream_ref: fanchmwrt-25.12.6
architecture: arm
target:       rockchip
subtarget:    armv8
profile:      friendlyarm_nanopi-r5c
```

扩展型号的填法与原生型号相同：直接在下拉里选对应版本即可，不用填 override。
补丁集按版本分分支（`v25.12.6`、`v25.12.4`……，`main` 指向最新），基线提交与所选版本不符时会在编译前明确报错。

## 按 target/subtarget 统计

| target | subtarget | 设备数 |
| --- | --- | --- |
| armsr | armv7 | 1 |
| armsr | armv8 | 1 |
| at91 | sam9x | 20 |
| at91 | sama5 | 7 |
| at91 | sama7 | 1 |
| bcm27xx | bcm2708 | 1 |
| bcm27xx | bcm2709 | 1 |
| bcm27xx | bcm2710 | 1 |
| bcm27xx | bcm2711 | 1 |
| bcm27xx | bcm2712 | 1 |
| bcm4908 | generic | 3 |
| bcm53xx | generic | 37 |
| gemini | generic | 5 |
| imx | cortexa53 | 2 |
| imx | cortexa7 | 1 |
| imx | cortexa9 | 5 |
| ipq40xx | chromium | 1 |
| ipq40xx | generic | 87 |
| ipq40xx | mikrotik | 9 |
| ipq806x | chromium | 2 |
| ipq806x | generic | 33 |
| ixp4xx | generic | 10 |
| kirkwood | generic | 26 |
| layerscape | armv7 | 3 |
| layerscape | armv8_64b | 17 |
| mediatek | filogic | 193 |
| mediatek | mt7622 | 26 |
| mediatek | mt7623 | 3 |
| mediatek | mt7629 | 5 |
| microchipsw | lan969x | 2 |
| mvebu | cortexa53 | 11 |
| mvebu | cortexa72 | 12 |
| mvebu | cortexa9 | 34 |
| mxs | generic | 3 |
| omap | generic | 4 |
| qualcommax | ipq50xx | 18 |
| qualcommax | ipq60xx | 24 |
| qualcommax | ipq807x | 39 |
| rockchip | armv8 | 48 |
| stm32 | stm32mp1 | 3 |
| sunxi | arm926ejs | 2 |
| sunxi | cortexa53 | 14 |
| sunxi | cortexa7 | 33 |
| sunxi | cortexa8 | 5 |
| tegra | generic | 1 |
| zynq | generic | 4 |

## 设备列表

| 常用名 | 设备型号 | target | subtarget | profile | 来源 |
| --- | --- | --- | --- | --- | --- |
| ABT ASR3000 | ABT ASR3000 | mediatek | filogic | `abt_asr3000` | 原生 |
| Acelink EW-7886CAX | Acelink EW-7886CAX | mediatek | filogic | `acelink_ew-7886cax` | 原生 |
| Acer Connect Vero W6m | Acer Connect Vero W6m | mediatek | filogic | `acer_vero-w6m` | 原生 |
| Acer Predator Connect W6 | Acer Predator Connect W6 | mediatek | filogic | `acer_predator-w6` | 原生 |
| Acer Predator Connect W6d | Acer Predator Connect W6d | mediatek | filogic | `acer_predator-w6d` | 原生 |
| Acer Predator Connect W6x (OpenWrt U-Boot Layout) | Acer Predator Connect W6x (OpenWrt U-Boot Layout) | mediatek | filogic | `acer_predator-w6x-ubootmod` | 原生 |
| Acer Predator Connect W6x (Stock Layout) | Acer Predator Connect W6x (Stock Layout) | mediatek | filogic | `acer_predator-w6x-stock` | 原生 |
| Actiontec MI424WR rev A/C | Actiontec MI424WR rev A/C | ixp4xx | generic | `actiontec_mi424wr_ac` | 原生 |
| Actiontec MI424WR rev D | Actiontec MI424WR rev D | ixp4xx | generic | `actiontec_mi424wr_d` | 原生 |
| Adtran SDG-841-t6 | Adtran SDG-841-t6 | mediatek | mt7622 | `smartrg_sdg-841-t6` | 原生 |
| Adtran SDG-8612 | Adtran SDG-8612 | mediatek | filogic | `smartrg_sdg-8612` | 原生 |
| Adtran SDG-8614 | Adtran SDG-8614 | mediatek | filogic | `smartrg_sdg-8614` | 原生 |
| Adtran SDG-8622 | Adtran SDG-8622 | mediatek | filogic | `smartrg_sdg-8622` | 原生 |
| Adtran SDG-8632 | Adtran SDG-8632 | mediatek | filogic | `smartrg_sdg-8632` | 原生 |
| Adtran SDG-8733 | Adtran SDG-8733 | mediatek | filogic | `smartrg_sdg-8733` | 原生 |
| Adtran SDG-8733A | Adtran SDG-8733A | mediatek | filogic | `smartrg_sdg-8733a` | 原生 |
| Adtran SDG-8734 | Adtran SDG-8734 | mediatek | filogic | `smartrg_sdg-8734` | 原生 |
| Airpi AP3000M | Airpi AP3000M | mediatek | filogic | `airpi_ap3000m` | 原生 |
| Airtel AirFiber AAP4221ZY / Zyxel EX3310-T0 | Airtel AirFiber AAP4221ZY / Zyxel EX3310-T0 | mediatek | filogic | `airtel_aap4221zy` | 原生 |
| ALFA Network AP120C-AC | ALFA Network AP120C-AC | ipq40xx | generic | `alfa-network_ap120c-ac` | 原生 |
| ALFA Network AP120C-AX | ALFA Network AP120C-AX | qualcommax | ipq60xx | `alfa-network_ap120c-ax` | 原生 |
| Aliyun AP8220 | Aliyun AP8220 | qualcommax | ipq807x | `aliyun_ap8220` | 原生 |
| AlwayLink M01K43 | AlwayLink M01K43 | mediatek | filogic | `alwaylink_m01k43` | 扩展 |
| Arcadyan AW1000 | Arcadyan AW1000 | qualcommax | ipq807x | `arcadyan_aw1000` | 原生 |
| Arcadyan Mozart | Arcadyan Mozart | mediatek | filogic | `arcadyan_mozart` | 原生 |
| ArmSoM Sige7 / Bananapi BPi-M7 | ArmSoM Sige7 / Bananapi BPi-M7 | rockchip | armv8 | `armsom_sige7` | 原生 |
| Arris TR4400 v2 | Arris TR4400 v2 | ipq806x | generic | `arris_tr4400-v2` | 原生 |
| Aruba AP-303 | Aruba AP-303 | ipq40xx | generic | `aruba_ap-303` | 原生 |
| Aruba AP-303H | Aruba AP-303H | ipq40xx | generic | `aruba_ap-303h` | 原生 |
| Aruba AP-325 / Aruba AP-324 / Siemens Scalance W1750D | Aruba AP-325 / Aruba AP-324 / Siemens Scalance W1750D | ipq806x | generic | `aruba_ap-32x` | 原生 |
| Aruba AP-365 | Aruba AP-365 | ipq40xx | generic | `aruba_ap-365` | 原生 |
| AsiaRF AP7622-WH1 | AsiaRF AP7622-WH1 | mediatek | mt7622 | `asiarf_ap7622-wh1` | 原生 |
| AsiaRF AP7986 003 | AsiaRF AP7986 003 | mediatek | filogic | `asiarf_ap7986-003` | 原生 |
| Askey RT4230W REV6 | Askey RT4230W REV6 | ipq806x | generic | `askey_rt4230w-rev6` | 原生 |
| ASRock G10 | ASRock G10 | ipq806x | generic | `asrock_g10` | 原生 |
| ASUS GT-AC5300 | ASUS GT-AC5300 | bcm4908 | generic | `asus_gt-ac5300` | 原生 |
| ASUS Lyra (MAP-AC2200) | ASUS Lyra (MAP-AC2200) | ipq40xx | generic | `asus_map-ac2200` | 原生 |
| ASUS Lyra Mini (MAP-AC1300) | ASUS Lyra Mini (MAP-AC1300) | ipq40xx | generic | `asus_map-ac1300` | 原生 |
| ASUS OnHub SRT-AC1900 | ASUS OnHub SRT-AC1900 | ipq806x | chromium | `asus_onhub` | 原生 |
| ASUS RT-AC42U / ASUS RT-AC2200 / ASUS RT-ACRH17 | ASUS RT-AC42U / ASUS RT-AC2200 / ASUS RT-ACRH17 | ipq40xx | generic | `asus_rt-ac42u` | 原生 |
| ASUS RT-AC56U | ASUS RT-AC56U | bcm53xx | generic | `asus_rt-ac56u` | 原生 |
| ASUS RT-AC58U / ASUS RT-ACRH13 | ASUS RT-AC58U / ASUS RT-ACRH13 | ipq40xx | generic | `asus_rt-ac58u` | 原生 |
| ASUS RT-AC68U | ASUS RT-AC68U | bcm53xx | generic | `asus_rt-ac68u` | 原生 |
| ASUS RT-AC87U | ASUS RT-AC87U | bcm53xx | generic | `asus_rt-ac87u` | 原生 |
| ASUS RT-AC88U | ASUS RT-AC88U | bcm53xx | generic | `asus_rt-ac88u` | 原生 |
| ASUS RT-AC3100 | ASUS RT-AC3100 | bcm53xx | generic | `asus_rt-ac3100` | 原生 |
| ASUS RT-AC3200 | ASUS RT-AC3200 | bcm53xx | generic | `asus_rt-ac3200` | 原生 |
| ASUS RT-AC5300 | ASUS RT-AC5300 | bcm53xx | generic | `asus_rt-ac5300` | 原生 |
| ASUS RT-AX52 / ASUS RT-AX52 PRO | ASUS RT-AX52 / ASUS RT-AX52 PRO | mediatek | filogic | `asus_rt-ax52` | 原生 |
| ASUS RT-AX57M / ASUS RT-AX1800HP V2 / ASUS RT-AX1800S V2 / ASUS RT-AX3000S / ASUS RT-AX54HP V2 | ASUS RT-AX57M / ASUS RT-AX1800HP V2 / ASUS RT-AX1800S V2 / ASUS RT-AX3000S / ASUS RT-AX54HP V2 | mediatek | filogic | `asus_rt-ax57m` | 原生 |
| ASUS RT-AX59U | ASUS RT-AX59U | mediatek | filogic | `asus_rt-ax59u` | 原生 |
| Asus RT-AX89X | Asus RT-AX89X | qualcommax | ipq807x | `asus_rt-ax89x` | 原生 |
| ASUS RT-N18U | ASUS RT-N18U | bcm53xx | generic | `asus_rt-n18u` | 原生 |
| ASUS TUF-AX4200 | ASUS TUF-AX4200 | mediatek | filogic | `asus_tuf-ax4200` | 原生 |
| ASUS TUF-AX4200Q | ASUS TUF-AX4200Q | mediatek | filogic | `asus_tuf-ax4200q` | 原生 |
| ASUS TUF-AX6000 | ASUS TUF-AX6000 | mediatek | filogic | `asus_tuf-ax6000` | 原生 |
| ASUS ZenWiFi BT8 | ASUS ZenWiFi BT8 | mediatek | filogic | `asus_zenwifi-bt8` | 原生 |
| ASUS ZenWiFi BT8 U-Boot mod | ASUS ZenWiFi BT8 U-Boot mod | mediatek | filogic | `asus_zenwifi-bt8-ubootmod` | 原生 |
| Atmel AT91SAM9G15-EK | Atmel AT91SAM9G15-EK | at91 | sam9x | `atmel_at91sam9g15ek` | 原生 |
| Atmel AT91SAM9G20-EK | Atmel AT91SAM9G20-EK | at91 | sam9x | `atmel_at91sam9g20ek` | 原生 |
| Atmel AT91SAM9G20-EK 2MMC | Atmel AT91SAM9G20-EK 2MMC | at91 | sam9x | `atmel_at91sam9g20ek-2mmc` | 原生 |
| Atmel AT91SAM9G25-EK | Atmel AT91SAM9G25-EK | at91 | sam9x | `atmel_at91sam9g25ek` | 原生 |
| Atmel AT91SAM9G35-EK | Atmel AT91SAM9G35-EK | at91 | sam9x | `atmel_at91sam9g35ek` | 原生 |
| Atmel AT91SAM9M10G45-EK | Atmel AT91SAM9M10G45-EK | at91 | sam9x | `atmel_at91sam9m10g45ek` | 原生 |
| Atmel AT91SAM9X25-EK | Atmel AT91SAM9X25-EK | at91 | sam9x | `atmel_at91sam9x25ek` | 原生 |
| Atmel AT91SAM9X35-EK | Atmel AT91SAM9X35-EK | at91 | sam9x | `atmel_at91sam9x35ek` | 原生 |
| Atmel AT91SAM9263-EK | Atmel AT91SAM9263-EK | at91 | sam9x | `atmel_at91sam9263ek` | 原生 |
| AVM FRITZ!Box 4040 | AVM FRITZ!Box 4040 | ipq40xx | generic | `avm_fritzbox-4040` | 原生 |
| AVM FRITZ!Box 7530 / AVM FRITZ!Box 7520 | AVM FRITZ!Box 7530 / AVM FRITZ!Box 7520 | ipq40xx | generic | `avm_fritzbox-7530` | 原生 |
| AVM FRITZ!Repeater 1200 | AVM FRITZ!Repeater 1200 | ipq40xx | generic | `avm_fritzrepeater-1200` | 原生 |
| AVM FRITZ!Repeater 3000 | AVM FRITZ!Repeater 3000 | ipq40xx | generic | `avm_fritzrepeater-3000` | 原生 |
| Avnet ZedBoard | Avnet ZedBoard | zynq | generic | `avnet_zynq-zed` | 原生 |
| Bananapi BPi-R2 | Bananapi BPi-R2 | mediatek | mt7623 | `bananapi_bpi-r2` | 原生 |
| Bananapi BPi-R3 | Bananapi BPi-R3 | mediatek | filogic | `bananapi_bpi-r3` | 原生 |
| Bananapi BPi-R3 Mini | Bananapi BPi-R3 Mini | mediatek | filogic | `bananapi_bpi-r3-mini` | 原生 |
| Bananapi BPi-R4 | Bananapi BPi-R4 | mediatek | filogic | `bananapi_bpi-r4` | 原生 |
| Bananapi BPi-R4 2.5GE | Bananapi BPi-R4 2.5GE | mediatek | filogic | `bananapi_bpi-r4-poe` | 原生 |
| Bananapi BPi-R4 Lite | Bananapi BPi-R4 Lite | mediatek | filogic | `bananapi_bpi-r4-lite` | 原生 |
| Bananapi BPi-R64 | Bananapi BPi-R64 | mediatek | mt7622 | `bananapi_bpi-r64` | 原生 |
| Bazis AX3000WM / Shenzhen Jia Yan Technology WD-R3000N-G2A | Bazis AX3000WM / Shenzhen Jia Yan Technology WD-R3000N-G2A | mediatek | filogic | `bazis_ax3000wm` | 原生 |
| BeagleBoard.org OMAP3 TI beagleboard | BeagleBoard.org OMAP3 TI beagleboard | omap | generic | `ti_omap3-beagle` | 原生 |
| Buffalo LinkStation LS220DE | Buffalo LinkStation LS220DE | mvebu | cortexa9 | `buffalo_ls220de` | 原生 |
| Buffalo LinkStation LS421DE | Buffalo LinkStation LS421DE | mvebu | cortexa9 | `buffalo_ls421de` | 原生 |
| Buffalo WSR-2533DHP2 | Buffalo WSR-2533DHP2 | mediatek | mt7622 | `buffalo_wsr-2533dhp2` | 原生 |
| Buffalo WSR-2533DHP3 | Buffalo WSR-2533DHP3 | mediatek | mt7622 | `buffalo_wsr-2533dhp3` | 扩展 |
| BUFFALO WSR-3000AX4P | BUFFALO WSR-3000AX4P | mediatek | filogic | `buffalo_wsr-3000ax4p` | 扩展 |
| Buffalo WSR-3200AX4S | Buffalo WSR-3200AX4S | mediatek | mt7622 | `buffalo_wsr-3200ax4s` | 原生 |
| Buffalo WSR-6000AX8 / Buffalo WSR-6000AX8P | Buffalo WSR-6000AX8 / Buffalo WSR-6000AX8P | mediatek | filogic | `buffalo_wsr-6000ax8` | 原生 |
| Buffalo WTR-M2133HP | Buffalo WTR-M2133HP | ipq40xx | generic | `buffalo_wtr-m2133hp` | 原生 |
| Buffalo WXR-1900DHP | Buffalo WXR-1900DHP | bcm53xx | generic | `buffalo_wxr-1900dhp` | 原生 |
| Buffalo WXR-2533DHP | Buffalo WXR-2533DHP | ipq806x | generic | `buffalo_wxr-2533dhp` | 原生 |
| Buffalo WXR-5950AX12 | Buffalo WXR-5950AX12 | qualcommax | ipq807x | `buffalo_wxr-5950ax12` | 原生 |
| Buffalo WZR-600DHP2 | Buffalo WZR-600DHP2 | bcm53xx | generic | `buffalo_wzr-600dhp2` | 原生 |
| Buffalo WZR-900DHP | Buffalo WZR-900DHP | bcm53xx | generic | `buffalo_wzr-900dhp` | 原生 |
| Buffalo WZR-1750DHP | Buffalo WZR-1750DHP | bcm53xx | generic | `buffalo_wzr-1750dhp` | 原生 |
| CalAmp LMU5000 | CalAmp LMU5000 | at91 | sam9x | `calamp_lmu5000` | 原生 |
| Calao TNY A9G20 | Calao TNY A9G20 | at91 | sam9x | `calao_tny-a9g20` | 原生 |
| Calao TNY A9260 | Calao TNY A9260 | at91 | sam9x | `calao_tny-a9260` | 原生 |
| Calao TNY A9263 | Calao TNY A9263 | at91 | sam9x | `calao_tny-a9263` | 原生 |
| Calao USB A9G20 | Calao USB A9G20 | at91 | sam9x | `calao_usb-a9g20` | 原生 |
| Calao USB A9260 | Calao USB A9260 | at91 | sam9x | `calao_usb-a9260` | 原生 |
| Calao USB A9263 | Calao USB A9263 | at91 | sam9x | `calao_usb-a9263` | 原生 |
| Cambium Networks XE3-4 | Cambium Networks XE3-4 | qualcommax | ipq60xx | `cambiumnetworks_xe3-4` | 原生 |
| Cell C RTL30VW | Cell C RTL30VW | ipq40xx | generic | `cellc_rtl30vw` | 原生 |
| Cetron CT3003 | Cetron CT3003 | mediatek | filogic | `cetron_ct3003` | 原生 |
| Check Point L-50 | Check Point L-50 | kirkwood | generic | `checkpoint_l-50` | 原生 |
| Check Point V-80 | Check Point V-80 | mvebu | cortexa72 | `checkpoint_v-80` | 原生 |
| Check Point V-81 | Check Point V-81 | mvebu | cortexa72 | `checkpoint_v-81` | 原生 |
| Cisco Meraki GX20 | Cisco Meraki GX20 | ipq40xx | generic | `meraki_gx20` | 原生 |
| Cisco Meraki MR20 | Cisco Meraki MR20 | ipq40xx | generic | `meraki_mr20` | 扩展 |
| Cisco Meraki MR30H | Cisco Meraki MR30H | ipq40xx | generic | `meraki_mr30h` | 原生 |
| Cisco Meraki MR33 | Cisco Meraki MR33 | ipq40xx | generic | `meraki_mr33` | 原生 |
| Cisco Meraki MR42 | Cisco Meraki MR42 | ipq806x | generic | `meraki_mr42` | 原生 |
| Cisco Meraki MR52 | Cisco Meraki MR52 | ipq806x | generic | `meraki_mr52` | 原生 |
| Cisco Meraki MR70 | Cisco Meraki MR70 | ipq40xx | generic | `meraki_mr70` | 扩展 |
| Cisco Meraki MR74 | Cisco Meraki MR74 | ipq40xx | generic | `meraki_mr74` | 原生 |
| Cisco Meraki MX64 | Cisco Meraki MX64 | bcm53xx | generic | `meraki_mx64` | 原生 |
| Cisco Meraki MX64 A0 | Cisco Meraki MX64 A0 | bcm53xx | generic | `meraki_mx64-a0` | 原生 |
| Cisco Meraki MX65 | Cisco Meraki MX65 | bcm53xx | generic | `meraki_mx65` | 原生 |
| Cisco Meraki Z3 | Cisco Meraki Z3 | ipq40xx | generic | `meraki_z3` | 原生 |
| Cisco Meraki Z3C | Cisco Meraki Z3C | ipq40xx | generic | `meraki_z3c` | 扩展 |
| Cisco Systems ON100 | Cisco Systems ON100 | kirkwood | generic | `cisco_on100` | 原生 |
| Cloud Engines Pogoplug E02 | Cloud Engines Pogoplug E02 | kirkwood | generic | `cloudengines_pogoe02` | 原生 |
| Cloud Engines Pogoplug V4 | Cloud Engines Pogoplug V4 | kirkwood | generic | `cloudengines_pogoplugv4` | 原生 |
| 中国移动A10（U-Boot 布局） | CMCC A10 (OpenWrt U-Boot layout) / SuperElectron ZN-M5 (OpenWrt U-Boot layout) / SuperElectron ZN-M8 (OpenWrt U-Boot layout) | mediatek | filogic | `cmcc_a10-ubootmod` | 原生 |
| 中国移动A10（原厂布局） | CMCC A10 (stock layout) / SuperElectron ZN-M5 (stock layout) / SuperElectron ZN-M8 (stock layout) | mediatek | filogic | `cmcc_a10-stock` | 原生 |
| 中国移动MR3000D-CI | CMCC MR3000D-CI | qualcommax | ipq50xx | `cmcc_mr3000d-ci` | 原生 |
| 中国移动PZ-L8 | CMCC PZ-L8 | qualcommax | ipq50xx | `cmcc_pz-l8` | 原生 |
| 中国移动RAX3000M | CMCC RAX3000M / CMCC RAX3000Me | mediatek | filogic | `cmcc_rax3000m` | 原生 |
| 中国移动RAX3000Q | CMCC RAX3000Q | qualcommax | ipq50xx | `cmcc_rax3000q` | 扩展 |
| 中国移动RAX3000QY | CMCC RAX3000QY | qualcommax | ipq50xx | `cmcc_rax3000qy` | 扩展 |
| 中国移动RM2-6 | CMCC RM2-6 | qualcommax | ipq807x | `cmcc_rm2-6` | 原生 |
| COMFAST CF-E393AX / COMFAST CF-E395AX | COMFAST CF-E393AX / COMFAST CF-E395AX | mediatek | filogic | `comfast_cf-e393ax` | 原生 |
| COMFAST CF-WA933 64M | COMFAST CF-WA933 64M | mediatek | filogic | `comfast_cf-wa933` | 扩展 |
| COMFAST CF-WA933 128M | COMFAST CF-WA933 128M | mediatek | filogic | `comfast_cf-wa933-128m` | 扩展 |
| COMFAST CF-WR632AX | COMFAST CF-WR632AX | mediatek | filogic | `comfast_cf-wr632ax` | 原生 |
| COMFAST CF-WR632AX (OpenWrt U-Boot layout) | COMFAST CF-WR632AX (OpenWrt U-Boot layout) | mediatek | filogic | `comfast_cf-wr632ax-ubootmod` | 原生 |
| COMFAST CF-WR632AX (UBI) | COMFAST CF-WR632AX (UBI) | mediatek | filogic | `comfast_cf-wr632ax-ubi` | 扩展 |
| COMFAST CF-XR186 | COMFAST CF-XR186 | mediatek | filogic | `comfast_cf-xr186` | 扩展 |
| Compex WPJ428 | Compex WPJ428 | ipq40xx | generic | `compex_wpj428` | 原生 |
| Compex WPQ864 | Compex WPQ864 | ipq806x | generic | `compex_wpq864` | 原生 |
| Compex WPQ873 | Compex WPQ873 | qualcommax | ipq807x | `compex_wpq873` | 原生 |
| CompuLab TrimSlice | CompuLab TrimSlice | tegra | generic | `compulab_trimslice` | 原生 |
| Confiabits MT7981 | Confiabits MT7981 | mediatek | filogic | `confiabits_mt7981` | 原生 |
| CreatLentem CLT-R30B1 112M / Dragonglass DGX21 112M / EDUP RT2980 112M / Livinet Li228 112M | CreatLentem CLT-R30B1 112M / Dragonglass DGX21 112M / EDUP RT2980 112M / Livinet Li228 112M | mediatek | filogic | `creatlentem_clt-r30b1-112m` | 原生 |
| CreatLentem CLT-R30B1 (UBI) / Dragonglass DGX21 (UBI) / EDUP RT2980 (UBI) / Livinet Li228 (UBI) | CreatLentem CLT-R30B1 (UBI) / Dragonglass DGX21 (UBI) / EDUP RT2980 (UBI) / Livinet Li228 (UBI) | mediatek | filogic | `creatlentem_clt-r30b1-ubi` | 原生 |
| CreatLentem CLT-R30B1 / Dragonglass DGX21 / EDUP RT2980 / Livinet Li228 | CreatLentem CLT-R30B1 / Dragonglass DGX21 / EDUP RT2980 / Livinet Li228 | mediatek | filogic | `creatlentem_clt-r30b1` | 原生 |
| Crisis Innovation Lab MeshPoint.One | Crisis Innovation Lab MeshPoint.One | ipq40xx | generic | `cilab_meshpoint-one` | 原生 |
| Ctera C200 V1 | Ctera C200 V1 | kirkwood | generic | `ctera_c200-v1` | 原生 |
| Ctera C200 V2 | Ctera C200 V2 | mvebu | cortexa9 | `ctera_c200-v2` | 原生 |
| Cubietech Cubieboard | Cubietech Cubieboard | sunxi | cortexa8 | `cubietech_a10-cubieboard` | 原生 |
| Cubietech Cubieboard2 | Cubietech Cubieboard2 | sunxi | cortexa7 | `cubietech_cubieboard2` | 原生 |
| Cubietech Cubietruck | Cubietech Cubietruck | sunxi | cortexa7 | `cubietech_cubietruck` | 原生 |
| Cudy AP3000 Outdoor v1 | Cudy AP3000 Outdoor v1 | mediatek | filogic | `cudy_ap3000outdoor-v1` | 原生 |
| Cudy AP3000 v1 | Cudy AP3000 v1 | mediatek | filogic | `cudy_ap3000-v1` | 原生 |
| Cudy AP3000 Wall v1 | Cudy AP3000 Wall v1 | mediatek | filogic | `cudy_ap3000wall-v1` | 原生 |
| Cudy M3000 v1/v2 | Cudy M3000 v1/v2 | mediatek | filogic | `cudy_m3000-v1` | 原生 |
| Cudy M3000 v1/v2 (OpenWrt U-Boot layout) | Cudy M3000 v1/v2 (OpenWrt U-Boot layout) | mediatek | filogic | `cudy_m3000-v1-ubootmod` | 原生 |
| Cudy M3000 v2 with Motorcomm YT8821 | Cudy M3000 v2 with Motorcomm YT8821 | mediatek | filogic | `cudy_m3000-v2-yt8821` | 原生 |
| Cudy M3000 v2 with Motorcomm YT8821 (OpenWrt U-Boot layout) | Cudy M3000 v2 with Motorcomm YT8821 (OpenWrt U-Boot layout) | mediatek | filogic | `cudy_m3000-v2-yt8821-ubootmod` | 原生 |
| Cudy RE3000 v1 | Cudy RE3000 v1 | mediatek | filogic | `cudy_re3000-v1` | 原生 |
| Cudy TR3000 256mb v1 | Cudy TR3000 256mb v1 | mediatek | filogic | `cudy_tr3000-256mb-v1` | 原生 |
| Cudy TR3000 v1 | Cudy TR3000 v1 | mediatek | filogic | `cudy_tr3000-v1` | 原生 |
| Cudy TR3000 v1 (OpenWrt U-Boot layout) | Cudy TR3000 v1 (OpenWrt U-Boot layout) | mediatek | filogic | `cudy_tr3000-v1-ubootmod` | 原生 |
| Cudy WBR3000UAX v1 | Cudy WBR3000UAX v1 | mediatek | filogic | `cudy_wbr3000uax-v1` | 原生 |
| Cudy WBR3000UAX v1 (OpenWrt U-Boot layout) | Cudy WBR3000UAX v1 (OpenWrt U-Boot layout) | mediatek | filogic | `cudy_wbr3000uax-v1-ubootmod` | 原生 |
| Cudy WR3000 v1 | Cudy WR3000 v1 | mediatek | filogic | `cudy_wr3000-v1` | 原生 |
| Cudy WR3000E v1 | Cudy WR3000E v1 | mediatek | filogic | `cudy_wr3000e-v1` | 原生 |
| Cudy WR3000E v1 (OpenWrt U-Boot layout) | Cudy WR3000E v1 (OpenWrt U-Boot layout) | mediatek | filogic | `cudy_wr3000e-v1-ubootmod` | 原生 |
| Cudy WR3000H v1 | Cudy WR3000H v1 | mediatek | filogic | `cudy_wr3000h-v1` | 原生 |
| Cudy WR3000H v1 (OpenWrt U-Boot layout) | Cudy WR3000H v1 (OpenWrt U-Boot layout) | mediatek | filogic | `cudy_wr3000h-v1-ubootmod` | 原生 |
| Cudy WR3000P v1 | Cudy WR3000P v1 | mediatek | filogic | `cudy_wr3000p-v1` | 原生 |
| Cudy WR3000P v1 (OpenWrt U-Boot layout) | Cudy WR3000P v1 (OpenWrt U-Boot layout) | mediatek | filogic | `cudy_wr3000p-v1-ubootmod` | 原生 |
| Cudy WR3000S v1 | Cudy WR3000S v1 | mediatek | filogic | `cudy_wr3000s-v1` | 原生 |
| Cudy WR3000S v1 (OpenWrt U-Boot layout) | Cudy WR3000S v1 (OpenWrt U-Boot layout) | mediatek | filogic | `cudy_wr3000s-v1-ubootmod` | 原生 |
| Cudy WR3000U v1 | Cudy WR3000U v1 | mediatek | filogic | `cudy_wr3000u-v1` | 原生 |
| CZ.NIC Turris MOX | CZ.NIC Turris MOX | mvebu | cortexa53 | `cznic_turris-mox` | 原生 |
| CZ.NIC Turris Omnia | CZ.NIC Turris Omnia | mvebu | cortexa9 | `cznic_turris-omnia` | 原生 |
| D-Link AQUILA PRO AI E30 A1 | D-Link AQUILA PRO AI E30 A1 | mediatek | filogic | `dlink_aquila-pro-ai-e30-a1` | 原生 |
| D-Link AQUILA PRO AI M30 A1 | D-Link AQUILA PRO AI M30 A1 | mediatek | filogic | `dlink_aquila-pro-ai-m30-a1` | 原生 |
| D-Link AQUILA PRO AI M60 A1 | D-Link AQUILA PRO AI M60 A1 | mediatek | filogic | `dlink_aquila-pro-ai-m60-a1` | 原生 |
| D-Link DAP-2610 | D-Link DAP-2610 | ipq40xx | generic | `dlink_dap-2610` | 原生 |
| D-Link DIR-685 Xtreme N Storage Router | D-Link DIR-685 Xtreme N Storage Router | gemini | generic | `dlink_dir-685` | 原生 |
| D-Link DIR-885L | D-Link DIR-885L | bcm53xx | generic | `dlink_dir-885l` | 原生 |
| D-Link DIR-890L | D-Link DIR-890L | bcm53xx | generic | `dlink_dir-890l` | 原生 |
| D-Link DNS-313 1-Bay Network Storage Enclosure | D-Link DNS-313 1-Bay Network Storage Enclosure | gemini | generic | `dlink_dns-313` | 原生 |
| D-Link DNS-320L | D-Link DNS-320L | kirkwood | generic | `dlink_dns320l` | 原生 |
| D-Link DNS-325 A1 | D-Link DNS-325 A1 | kirkwood | generic | `dlink_dns-325-a1` | 原生 |
| D-Link DSM G600 A | D-Link DSM G600 A | ixp4xx | generic | `dlink_dsm_g600_a` | 原生 |
| D-Link DWL-8610AP | D-Link DWL-8610AP | bcm53xx | generic | `dlink_dwl-8610ap` | 原生 |
| D-Link EAGLE PRO AI M32 A1 | D-Link EAGLE PRO AI M32 A1 | mediatek | mt7622 | `dlink_eagle-pro-ai-m32-a1` | 原生 |
| D-Link EAGLE PRO AI R32 A1 | D-Link EAGLE PRO AI R32 A1 | mediatek | mt7622 | `dlink_eagle-pro-ai-r32-a1` | 原生 |
| devolo Magic 2 WiFi next | devolo Magic 2 WiFi next | ipq40xx | generic | `devolo_magic-2-wifi-next` | 原生 |
| Digilent Zybo | Digilent Zybo | zynq | generic | `digilent_zynq-zybo` | 原生 |
| Digilent Zybo Z7 | Digilent Zybo Z7 | zynq | generic | `digilent_zynq-zybo-z7` | 原生 |
| Dynalink DL-WRX36 | Dynalink DL-WRX36 | qualcommax | ipq807x | `dynalink_dl-wrx36` | 原生 |
| Edgecore EAP102 | Edgecore EAP102 | qualcommax | ipq807x | `edgecore_eap102` | 原生 |
| Edgecore EAP111 | Edgecore EAP111 | mediatek | filogic | `edgecore_eap111` | 原生 |
| Edgecore ECW5211 | Edgecore ECW5211 | ipq40xx | generic | `edgecore_ecw5211` | 原生 |
| Edgecore ECW5410 | Edgecore ECW5410 | ipq806x | generic | `edgecore_ecw5410` | 原生 |
| Edimax CAX1800 | Edimax CAX1800 | qualcommax | ipq807x | `edimax_cax1800` | 原生 |
| egnite Ethernut 5 | egnite Ethernut 5 | at91 | sam9x | `egnite_ethernut5` | 原生 |
| Elecom WRC-2533GENT | Elecom WRC-2533GENT | mediatek | mt7622 | `elecom_wrc-2533gent` | 原生 |
| ELECOM WRC-G01 | ELECOM WRC-G01 | mediatek | mt7622 | `elecom_wrc-g01` | 扩展 |
| ELECOM WRC-X3000GS2 | ELECOM WRC-X3000GS2 | qualcommax | ipq50xx | `elecom_wrc-x3000gs2` | 原生 |
| ELECOM WRC-X3000GS3 | ELECOM WRC-X3000GS3 | mediatek | filogic | `elecom_wrc-x3000gs3` | 原生 |
| ELECOM WRC-X3000GST2 | ELECOM WRC-X3000GST2 | qualcommax | ipq50xx | `elecom_wrc-x3000gst2` | 扩展 |
| ELECOM WRC-X3200GST3 | ELECOM WRC-X3200GST3 | mediatek | mt7622 | `elecom_wrc-x3200gst3` | 原生 |
| ELECOM WRC-X6000GSD | ELECOM WRC-X6000GSD | mediatek | filogic | `elecom_wrc-x6000gsd` | 扩展 |
| ELECOM WRC-X6000QS | ELECOM WRC-X6000QS | mediatek | filogic | `elecom_wrc-x6000qs` | 扩展 |
| Endian 4i Edge 200 / Endian UTM Mini Firewall | Endian 4i Edge 200 / Endian UTM Mini Firewall | kirkwood | generic | `endian_4i-edge-200` | 原生 |
| EnGenius EAP1300 / EnGenius EAP1300EXT | EnGenius EAP1300 / EnGenius EAP1300EXT | ipq40xx | generic | `engenius_eap1300` | 原生 |
| Exegin Q5x rev5 | Exegin Q5x rev5 | at91 | sam9x | `exegin_q5xr5` | 原生 |
| Extreme Networks AP3935 | Extreme Networks AP3935 | ipq806x | generic | `extreme_ap3935` | 原生 |
| Extreme Networks WS-AP391x | Extreme Networks WS-AP391x | ipq40xx | generic | `extreme-networks_ws-ap391x` | 原生 |
| Extreme Networks WS-AP3915i | Extreme Networks WS-AP3915i | ipq40xx | generic | `extreme-networks_ws-ap3915i` | 原生 |
| EZVIZ CS-W3-WD1200G EUP | EZVIZ CS-W3-WD1200G EUP | ipq40xx | generic | `ezviz_cs-w3-wd1200g-eup` | 原生 |
| Firefly ROC-RK3328-CC | Firefly ROC-RK3328-CC | rockchip | armv8 | `firefly_roc-rk3328-cc` | 原生 |
| Fortinet FAP-421E | Fortinet FAP-421E | ipq806x | generic | `fortinet_fap-421e` | 原生 |
| Fortinet FortiGate 30E | Fortinet FortiGate 30E | mvebu | cortexa9 | `fortinet_fg-30e` | 原生 |
| Fortinet FortiGate 50E | Fortinet FortiGate 50E | mvebu | cortexa9 | `fortinet_fg-50e` | 原生 |
| Fortinet FortiGate 51E | Fortinet FortiGate 51E | mvebu | cortexa9 | `fortinet_fg-51e` | 原生 |
| Fortinet FortiGate 52E | Fortinet FortiGate 52E | mvebu | cortexa9 | `fortinet_fg-52e` | 原生 |
| Fortinet FortiWiFi 30E | Fortinet FortiWiFi 30E | mvebu | cortexa9 | `fortinet_fwf-30e` | 原生 |
| Fortinet FortiWiFi 50E-2R | Fortinet FortiWiFi 50E-2R | mvebu | cortexa9 | `fortinet_fwf-50e-2r` | 原生 |
| Fortinet FortiWiFi 51E | Fortinet FortiWiFi 51E | mvebu | cortexa9 | `fortinet_fwf-51e` | 原生 |
| Freecom FSG-3 | Freecom FSG-3 | ixp4xx | generic | `freecom_fsg_3` | 原生 |
| FriendlyARM NanoPC T4 | FriendlyARM NanoPC T4 | rockchip | armv8 | `friendlyarm_nanopc-t4` | 原生 |
| FriendlyARM NanoPC T6 | FriendlyARM NanoPC T6 | rockchip | armv8 | `friendlyarm_nanopc-t6` | 原生 |
| FriendlyARM NanoPi M1 Plus | FriendlyARM NanoPi M1 Plus | sunxi | cortexa7 | `friendlyarm_nanopi-m1-plus` | 原生 |
| FriendlyARM NanoPi NEO | FriendlyARM NanoPi NEO | sunxi | cortexa7 | `friendlyarm_nanopi-neo` | 原生 |
| FriendlyARM NanoPi NEO2 | FriendlyARM NanoPi NEO2 | sunxi | cortexa53 | `friendlyarm_nanopi-neo2` | 原生 |
| FriendlyARM NanoPi NEO Air | FriendlyARM NanoPi NEO Air | sunxi | cortexa7 | `friendlyarm_nanopi-neo-air` | 原生 |
| FriendlyARM NanoPi NEO Plus2 | FriendlyARM NanoPi NEO Plus2 | sunxi | cortexa53 | `friendlyarm_nanopi-neo-plus2` | 原生 |
| FriendlyARM NanoPi R1 | FriendlyARM NanoPi R1 | sunxi | cortexa7 | `friendlyarm_nanopi-r1` | 原生 |
| FriendlyARM Nanopi R1S H5 | FriendlyARM Nanopi R1S H5 | sunxi | cortexa53 | `friendlyarm_nanopi-r1s-h5` | 原生 |
| FriendlyARM NanoPi R2C | FriendlyARM NanoPi R2C | rockchip | armv8 | `friendlyarm_nanopi-r2c` | 原生 |
| FriendlyARM NanoPi R2C Plus | FriendlyARM NanoPi R2C Plus | rockchip | armv8 | `friendlyarm_nanopi-r2c-plus` | 原生 |
| FriendlyARM NanoPi R2S | FriendlyARM NanoPi R2S | rockchip | armv8 | `friendlyarm_nanopi-r2s` | 原生 |
| FriendlyARM NanoPi R2S Plus | FriendlyARM NanoPi R2S Plus | rockchip | armv8 | `friendlyarm_nanopi-r2s-plus` | 原生 |
| FriendlyARM NanoPi R3S | FriendlyARM NanoPi R3S | rockchip | armv8 | `friendlyarm_nanopi-r3s` | 原生 |
| FriendlyARM NanoPi R4S 4GB LPDDR4 | FriendlyARM NanoPi R4S 4GB LPDDR4 | rockchip | armv8 | `friendlyarm_nanopi-r4s` | 原生 |
| FriendlyARM NanoPi R4S Enterprise Edition 4GB LPDDR4 | FriendlyARM NanoPi R4S Enterprise Edition 4GB LPDDR4 | rockchip | armv8 | `friendlyarm_nanopi-r4s-enterprise` | 原生 |
| FriendlyARM NanoPi R5C | FriendlyARM NanoPi R5C | rockchip | armv8 | `friendlyarm_nanopi-r5c` | 原生 |
| FriendlyARM NanoPi R5S | FriendlyARM NanoPi R5S | rockchip | armv8 | `friendlyarm_nanopi-r5s` | 原生 |
| FriendlyARM NanoPi R6C | FriendlyARM NanoPi R6C | rockchip | armv8 | `friendlyarm_nanopi-r6c` | 原生 |
| FriendlyARM NanoPi R6S | FriendlyARM NanoPi R6S | rockchip | armv8 | `friendlyarm_nanopi-r6s` | 原生 |
| FriendlyARM NanoPi R76S | FriendlyARM NanoPi R76S | rockchip | armv8 | `friendlyarm_nanopi-r76s` | 原生 |
| FriendlyARM ZeroPi | FriendlyARM ZeroPi | sunxi | cortexa7 | `friendlyarm_zeropi` | 原生 |
| Gateworks Avila GW2348-4 | Gateworks Avila GW2348-4 | ixp4xx | generic | `gateworks_avila` | 原生 |
| Gateworks Cambria GW2358-4 | Gateworks Cambria GW2358-4 | ixp4xx | generic | `gateworks_cambria` | 原生 |
| Gateworks i.MX8M Venice | Gateworks i.MX8M Venice | imx | cortexa53 | `gateworks_venice` | 原生 |
| Gateworks Ventana family large NAND flash | Gateworks Ventana family large NAND flash | imx | cortexa9 | `gateworks_ventana-large` | 原生 |
| Gateworks Ventana family normal NAND flash | Gateworks Ventana family normal NAND flash | imx | cortexa9 | `gateworks_ventana` | 原生 |
| GatoNetworks gdsp | GatoNetworks gdsp | mediatek | filogic | `gatonetworks_gdsp` | 原生 |
| Generic EFI Boot | Generic EFI Boot | armsr | armv7 | `generic` | 原生 |
| Generic EFI Boot | Generic EFI Boot | armsr | armv8 | `generic` | 原生 |
| GL.iNet GL-A1300 | GL.iNet GL-A1300 | ipq40xx | generic | `glinet_gl-a1300` | 原生 |
| GL.iNet GL-AP1300 | GL.iNet GL-AP1300 | ipq40xx | generic | `glinet_gl-ap1300` | 原生 |
| GL.iNet GL-AX1800 | GL.iNet GL-AX1800 | qualcommax | ipq60xx | `glinet_gl-ax1800` | 原生 |
| GL.iNet GL-AXT1800 | GL.iNet GL-AXT1800 | qualcommax | ipq60xx | `glinet_gl-axt1800` | 原生 |
| GL.iNet GL-B1300 | GL.iNet GL-B1300 | ipq40xx | generic | `glinet_gl-b1300` | 原生 |
| GL.iNet GL-B2200 | GL.iNet GL-B2200 | ipq40xx | generic | `glinet_gl-b2200` | 原生 |
| GL.iNet GL-B3000 | GL.iNet GL-B3000 | qualcommax | ipq50xx | `glinet_gl-b3000` | 原生 |
| GL.iNet GL-MT2500 Airoha PHY | GL.iNet GL-MT2500 Airoha PHY | mediatek | filogic | `glinet_gl-mt2500-airoha` | 原生 |
| GL.iNet GL-MT2500 MaxLinear PHY | GL.iNet GL-MT2500 MaxLinear PHY | mediatek | filogic | `glinet_gl-mt2500` | 原生 |
| GL.iNet GL-MT3000 | GL.iNet GL-MT3000 | mediatek | filogic | `glinet_gl-mt3000` | 原生 |
| GL.iNet GL-MT3600BE | GL.iNet GL-MT3600BE | mediatek | filogic | `glinet_gl-mt3600be` | 原生 |
| GL.iNet GL-MT6000 | GL.iNet GL-MT6000 | mediatek | filogic | `glinet_gl-mt6000` | 原生 |
| GL.iNet GL-MV1000 | GL.iNet GL-MV1000 | mvebu | cortexa53 | `glinet_gl-mv1000` | 原生 |
| GL.iNet GL-S1300 | GL.iNet GL-S1300 | ipq40xx | generic | `glinet_gl-s1300` | 原生 |
| GL.iNet GL-X3000 | GL.iNet GL-X3000 | mediatek | filogic | `glinet_gl-x3000` | 原生 |
| GL.iNet GL-XE3000 | GL.iNet GL-XE3000 | mediatek | filogic | `glinet_gl-xe3000` | 原生 |
| Globalscale Mirabox | Globalscale Mirabox | mvebu | cortexa9 | `globalscale_mirabox` | 原生 |
| Globalscale MOCHAbin | Globalscale MOCHAbin | mvebu | cortexa72 | `globalscale_mochabin` | 原生 |
| Globalscale Sheevaplug | Globalscale Sheevaplug | kirkwood | generic | `globalscale_sheevaplug` | 原生 |
| Globitel BT-R320 | Globitel BT-R320 | mediatek | filogic | `globitel_bt-r320` | 原生 |
| Google WiFi (Gale) | Google WiFi (Gale) | ipq40xx | chromium | `google_wifi` | 原生 |
| 新华三Magic NX30 Pro | H3C Magic NX30 Pro | mediatek | filogic | `h3c_magic-nx30-pro` | 原生 |
| HAOYU Electronics MarsBoard A10 | HAOYU Electronics MarsBoard A10 | sunxi | cortexa8 | `haoyu_a10-marsboard` | 原生 |
| HINLINK H28K / LinkStar H28K | HINLINK H28K / LinkStar H28K | rockchip | armv8 | `hinlink_h28k` | 原生 |
| Hiveton H5000M / Airpi H5000M | Hiveton H5000M / Airpi H5000M | mediatek | filogic | `hiveton_h5000m` | 原生 |
| Huasifei WH3000 | Huasifei WH3000 | mediatek | filogic | `huasifei_wh3000` | 原生 |
| Huasifei WH3000 Pro eMMC | Huasifei WH3000 Pro eMMC | mediatek | filogic | `huasifei_wh3000-pro-emmc` | 原生 |
| Huasifei WH3000 Pro NAND | Huasifei WH3000 Pro NAND | mediatek | filogic | `huasifei_wh3000-pro-nand` | 原生 |
| Huasifei WH3000R NAND | Huasifei WH3000R NAND | mediatek | filogic | `huasifei_wh3000r-nand` | 原生 |
| Huawei AP4050DN | Huawei AP4050DN | ipq40xx | generic | `huawei_ap4050dn` | 扩展 |
| I2SE Duckbill | I2SE Duckbill | mxs | generic | `i2se_duckbill` | 原生 |
| I-O DATA WN-DAX3000GR | I-O DATA WN-DAX3000GR | qualcommax | ipq50xx | `iodata_wn-dax3000gr` | 原生 |
| iEi Puzzle-M901 | iEi Puzzle-M901 | mvebu | cortexa72 | `iei_puzzle-m901` | 原生 |
| iEi Puzzle-M902 | iEi Puzzle-M902 | mvebu | cortexa72 | `iei_puzzle-m902` | 原生 |
| IgniteNet SunSpot AC Wave2 / Accton Technology Corporation EAP1024A V2 | IgniteNet SunSpot AC Wave2 / Accton Technology Corporation EAP1024A V2 | ipq806x | generic | `ignitenet_ss-w2-ac2600` | 原生 |
| IIJ SA-W2 | IIJ SA-W2 | mvebu | cortexa9 | `iij_sa-w2` | 原生 |
| Imou HX21 | Imou HX21 | mediatek | filogic | `imou_hx21` | 原生 |
| Iomega Iconnect | Iomega Iconnect | kirkwood | generic | `iom_iconnect-1.1` | 原生 |
| Iomega NAS100d | Iomega NAS100d | ixp4xx | generic | `iomega_nas100d` | 原生 |
| Iomega StorCenter ix2-200 | Iomega StorCenter ix2-200 | kirkwood | generic | `iom_ix2-200` | 原生 |
| Iomega StorCenter ix4-200d | Iomega StorCenter ix4-200d | kirkwood | generic | `iom_ix4-200d` | 原生 |
| ipTIME A6004MX | ipTIME A6004MX | mediatek | mt7629 | `iptime_a6004mx` | 原生 |
| ipTIME AX3000M | ipTIME AX3000M | mediatek | filogic | `iptime_ax3000m` | 原生 |
| ipTIME AX3000Q | ipTIME AX3000Q | mediatek | filogic | `iptime_ax3000q` | 原生 |
| ipTIME AX3000SE | ipTIME AX3000SE | mediatek | filogic | `iptime_ax3000se` | 原生 |
| ipTIME AX3000SM | ipTIME AX3000SM | mediatek | filogic | `iptime_ax3000sm` | 原生 |
| ipTIME AX7800M-6E | ipTIME AX7800M-6E | mediatek | filogic | `iptime_ax7800m-6e` | 原生 |
| ipTIME NAS1 | ipTIME NAS1 | kirkwood | generic | `iptime_nas1` | 原生 |
| ipTIME NAS1dual | ipTIME NAS1dual | mvebu | cortexa9 | `iptime_nas1dual` | 原生 |
| ITian Square One SQ201 | ITian Square One SQ201 | gemini | generic | `itian_sq201` | 原生 |
| 捷稀Q30 Pro | JCG Q30 PRO | mediatek | filogic | `jcg_q30-pro` | 原生 |
| 京东云无线宝RE-CP-03 | JDCloud RE-CP-03 | mediatek | filogic | `jdcloud_re-cp-03` | 原生 |
| 京东云无线宝RE-CS-02 | JDCloud RE-CS-02 | qualcommax | ipq60xx | `jdcloud_re-cs-02` | 扩展 |
| 京东云无线宝RE-CS-07 | JDCloud RE-CS-07 | qualcommax | ipq60xx | `jdcloud_re-cs-07` | 扩展 |
| 京东云无线宝RE-SS-01 | JDCloud RE-SS-01 | qualcommax | ipq60xx | `jdcloud_re-ss-01` | 扩展 |
| JioRouter AX6000 JIDU6J01 / JioRouter AX6000 JIDU6201 / JioRouter AX6000 JIDU6401 / JioRouter AX6000 JIDU6601 / JioRouter AX6000 JIDU6701 | JioRouter AX6000 JIDU6J01 / JioRouter AX6000 JIDU6201 / JioRouter AX6000 JIDU6401 / JioRouter AX6000 JIDU6601 / JioRouter AX6000 JIDU6701 | mediatek | filogic | `jiorouter_ax6000-jidu6j01` | 原生 |
| JioRouter AX6000 JIDU6101 | JioRouter AX6000 JIDU6101 | mediatek | filogic | `jiorouter_ax6000-jidu6101` | 原生 |
| Kebidumei AX3000-U22 | Kebidumei AX3000-U22 | mediatek | filogic | `kebidumei_ax3000-u22` | 原生 |
| Keenetic KAP-630 | Keenetic KAP-630 | mediatek | filogic | `keenetic_kap-630` | 原生 |
| Keenetic KN-1812 | Keenetic KN-1812 | mediatek | filogic | `keenetic_kn-1812` | 原生 |
| Keenetic KN-3711 | Keenetic KN-3711 | mediatek | filogic | `keenetic_kn-3711` | 原生 |
| Keenetic KN-3811 | Keenetic KN-3811 | mediatek | filogic | `keenetic_kn-3811` | 原生 |
| Keenetic KN-3911 | Keenetic KN-3911 | mediatek | filogic | `keenetic_kn-3911` | 原生 |
| Kobol Helios4 | Kobol Helios4 | mvebu | cortexa9 | `kobol_helios4` | 原生 |
| Konka KOMI A31 / E-Life ETR631-T / E-Life ETR635-U | Konka KOMI A31 / E-Life ETR631-T / E-Life ETR635-U | mediatek | filogic | `konka_komi-a31` | 原生 |
| Laird WB45N | Laird WB45N | at91 | sam9x | `laird_wb45n` | 原生 |
| Lamobo Lamobo R1 / Bananapi BPi-R1 | Lamobo Lamobo R1 / Bananapi BPi-R1 | sunxi | cortexa7 | `lamobo_lamobo-r1` | 原生 |
| LeMaker Banana Pi | LeMaker Banana Pi | sunxi | cortexa7 | `lemaker_bananapi` | 原生 |
| LeMaker Banana Pro | LeMaker Banana Pro | sunxi | cortexa7 | `lemaker_bananapro` | 原生 |
| Libre Computer ALL-H3-CC H5 | Libre Computer ALL-H3-CC H5 | sunxi | cortexa53 | `libretech_all-h3-cc-h5` | 原生 |
| LicheePi LicheePi Nano | LicheePi LicheePi Nano | sunxi | arm926ejs | `licheepi_licheepi-nano` | 原生 |
| LicheePi Zero with Dock (V3s) | LicheePi Zero with Dock (V3s) | sunxi | cortexa7 | `licheepi_licheepi-zero-dock` | 原生 |
| Link NN6000 v1 | Link NN6000 v1 | qualcommax | ipq60xx | `link_nn6000-v1` | 扩展 |
| Link NN6000 v2 | Link NN6000 v2 | qualcommax | ipq60xx | `link_nn6000-v2` | 扩展 |
| LinkEase EasePi R1 | LinkEase EasePi R1 | rockchip | armv8 | `linkease_easepi-r1` | 原生 |
| LinkSprite pcDuino | LinkSprite pcDuino | sunxi | cortexa8 | `linksprite_a10-pcduino` | 原生 |
| LinkSprite pcDuino3 | LinkSprite pcDuino3 | sunxi | cortexa7 | `linksprite_pcduino3` | 原生 |
| LinkSprite pcDuino3 Nano | LinkSprite pcDuino3 Nano | sunxi | cortexa7 | `linksprite_pcduino3-nano` | 原生 |
| Linksys E4200 v2 | Linksys E4200 v2 | kirkwood | generic | `linksys_e4200-v2` | 原生 |
| Linksys E8350 v1 | Linksys E8350 v1 | ipq806x | generic | `linksys_e8350-v1` | 原生 |
| Linksys E8450 / Belkin RT3200 | Linksys E8450 / Belkin RT3200 | mediatek | mt7622 | `linksys_e8450` | 原生 |
| Linksys E8450 UBI / Belkin RT3200 UBI | Linksys E8450 UBI / Belkin RT3200 UBI | mediatek | mt7622 | `linksys_e8450-ubi` | 原生 |
| Linksys EA3500 | Linksys EA3500 | kirkwood | generic | `linksys_ea3500` | 原生 |
| Linksys EA4500 | Linksys EA4500 | kirkwood | generic | `linksys_ea4500` | 原生 |
| Linksys EA6300 v1 | Linksys EA6300 v1 | bcm53xx | generic | `linksys_ea6300-v1` | 原生 |
| Linksys EA6350 v3 | Linksys EA6350 v3 | ipq40xx | generic | `linksys_ea6350v3` | 原生 |
| Linksys EA6500 v2 | Linksys EA6500 v2 | bcm53xx | generic | `linksys_ea6500-v2` | 原生 |
| Linksys EA7500 v1 | Linksys EA7500 v1 | ipq806x | generic | `linksys_ea7500-v1` | 原生 |
| Linksys EA7500 v3 | Linksys EA7500 v3 | mediatek | mt7629 | `linksys_ea7500-v3` | 原生 |
| Linksys EA8300 | Linksys EA8300 | ipq40xx | generic | `linksys_ea8300` | 原生 |
| Linksys EA8500 | Linksys EA8500 | ipq806x | generic | `linksys_ea8500` | 原生 |
| Linksys EA9200 v1 | Linksys EA9200 v1 | bcm53xx | generic | `linksys_ea9200` | 原生 |
| Linksys EA9500 | Linksys EA9500 | bcm53xx | generic | `linksys_ea9500` | 原生 |
| Linksys HomeWRK | Linksys HomeWRK | qualcommax | ipq807x | `linksys_homewrk` | 原生 |
| Linksys MR5500 | Linksys MR5500 | qualcommax | ipq50xx | `linksys_mr5500` | 原生 |
| Linksys MR6350 | Linksys MR6350 | ipq40xx | generic | `linksys_mr6350` | 原生 |
| Linksys MR7350 | Linksys MR7350 | qualcommax | ipq60xx | `linksys_mr7350` | 原生 |
| Linksys MR7500 | Linksys MR7500 | qualcommax | ipq60xx | `linksys_mr7500` | 原生 |
| Linksys MR8300 | Linksys MR8300 | ipq40xx | generic | `linksys_mr8300` | 原生 |
| Linksys MR9000 | Linksys MR9000 | ipq40xx | generic | `linksys_mr9000` | 原生 |
| Linksys MX2000 | Linksys MX2000 | qualcommax | ipq50xx | `linksys_mx2000` | 原生 |
| Linksys MX4200 v1 | Linksys MX4200 v1 | qualcommax | ipq807x | `linksys_mx4200v1` | 原生 |
| Linksys MX4200 v2 | Linksys MX4200 v2 | qualcommax | ipq807x | `linksys_mx4200v2` | 原生 |
| Linksys MX4300 | Linksys MX4300 | qualcommax | ipq807x | `linksys_mx4300` | 原生 |
| Linksys MX5300 | Linksys MX5300 | qualcommax | ipq807x | `linksys_mx5300` | 原生 |
| Linksys MX5500 | Linksys MX5500 | qualcommax | ipq50xx | `linksys_mx5500` | 原生 |
| Linksys MX6200 | Linksys MX6200 | qualcommax | ipq50xx | `linksys_mx6200` | 原生 |
| Linksys MX8500 | Linksys MX8500 | qualcommax | ipq807x | `linksys_mx8500` | 原生 |
| Linksys NSLU2 | Linksys NSLU2 | ixp4xx | generic | `linksys_nslu2` | 原生 |
| Linksys SPNMX56 | Linksys SPNMX56 | qualcommax | ipq50xx | `linksys_spnmx56` | 原生 |
| Linksys WHW01 / Linksys VLP01 | Linksys WHW01 / Linksys VLP01 | ipq40xx | generic | `linksys_whw01` | 原生 |
| Linksys WHW03 | Linksys WHW03 | ipq40xx | generic | `linksys_whw03` | 原生 |
| Linksys WHW03 V2 | Linksys WHW03 V2 | ipq40xx | generic | `linksys_whw03v2` | 原生 |
| Linksys WRT32X / Linksys Venom | Linksys WRT32X / Linksys Venom | mvebu | cortexa9 | `linksys_wrt32x` | 原生 |
| Linksys WRT1200AC / Linksys Caiman | Linksys WRT1200AC / Linksys Caiman | mvebu | cortexa9 | `linksys_wrt1200ac` | 原生 |
| Linksys WRT1900AC v1 / Linksys Mamba | Linksys WRT1900AC v1 / Linksys Mamba | mvebu | cortexa9 | `linksys_wrt1900ac-v1` | 原生 |
| Linksys WRT1900AC v2 / Linksys Cobra | Linksys WRT1900AC v2 / Linksys Cobra | mvebu | cortexa9 | `linksys_wrt1900ac-v2` | 原生 |
| Linksys WRT1900ACS v1 / Linksys Shelby / Linksys WRT1900ACS v2 | Linksys WRT1900ACS v1 / Linksys Shelby / Linksys WRT1900ACS v2 | mvebu | cortexa9 | `linksys_wrt1900acs` | 原生 |
| Linksys WRT3200ACM / Linksys Rango | Linksys WRT3200ACM / Linksys Rango | mvebu | cortexa9 | `linksys_wrt3200acm` | 原生 |
| Livinet Li320 | Livinet Li320 | mediatek | filogic | `livinet_li320` | 原生 |
| Luma Home WRTQ-329ACN | Luma Home WRTQ-329ACN | ipq40xx | generic | `luma_wrtq-329acn` | 原生 |
| Lunzn FastRhino R66S | Lunzn FastRhino R66S | rockchip | armv8 | `lunzn_fastrhino-r66s` | 原生 |
| Luxul ABR-4500 | Luxul ABR-4500 | bcm53xx | generic | `luxul_abr-4500-v1` | 原生 |
| Luxul XAP-1610 | Luxul XAP-1610 | bcm53xx | generic | `luxul_xap-1610-v1` | 原生 |
| Luxul XBR-4500 | Luxul XBR-4500 | bcm53xx | generic | `luxul_xbr-4500-v1` | 原生 |
| Luxul XWR-3150 | Luxul XWR-3150 | bcm53xx | generic | `luxul_xwr-3150-v1` | 原生 |
| Marvell Armada 370 Development Board (DB-88F6710-BP-DDR3) | Marvell Armada 370 Development Board (DB-88F6710-BP-DDR3) | mvebu | cortexa9 | `marvell_a370-db` | 原生 |
| Marvell Armada 370 RD (RD-88F6710-A1) | Marvell Armada 370 RD (RD-88F6710-A1) | mvebu | cortexa9 | `marvell_a370-rd` | 原生 |
| Marvell Armada 385 Development Board AP (DB-88F6820-AP) | Marvell Armada 385 Development Board AP (DB-88F6820-AP) | mvebu | cortexa9 | `marvell_a385-db-ap` | 原生 |
| Marvell Armada 388 RD (RD-88F6820-AP) | Marvell Armada 388 RD (RD-88F6820-AP) | mvebu | cortexa9 | `marvell_a388-rd` | 原生 |
| Marvell Armada 3720 Development Board (DB-88F3720-DDR3) | Marvell Armada 3720 Development Board (DB-88F3720-DDR3) | mvebu | cortexa53 | `marvell_armada-3720-db` | 原生 |
| Marvell Armada 7040 Development Board | Marvell Armada 7040 Development Board | mvebu | cortexa72 | `marvell_armada7040-db` | 原生 |
| Marvell Armada 8040 Development Board | Marvell Armada 8040 Development Board | mvebu | cortexa72 | `marvell_armada8040-db` | 原生 |
| Marvell Armada Armada XP GP (DB-MV784MP-GP) | Marvell Armada Armada XP GP (DB-MV784MP-GP) | mvebu | cortexa9 | `marvell_axp-gp` | 原生 |
| Marvell Armada XP Development Board (DB-78460-BP) | Marvell Armada XP Development Board (DB-78460-BP) | mvebu | cortexa9 | `marvell_axp-db` | 原生 |
| Marvell ESPRESSObin eMMC / Marvell Armada 3700 Community Board eMMC | Marvell ESPRESSObin eMMC / Marvell Armada 3700 Community Board eMMC | mvebu | cortexa53 | `globalscale_espressobin-emmc` | 原生 |
| Marvell ESPRESSObin Non-eMMC / Marvell Armada 3700 Community Board Non-eMMC | Marvell ESPRESSObin Non-eMMC / Marvell Armada 3700 Community Board Non-eMMC | mvebu | cortexa53 | `globalscale_espressobin` | 原生 |
| Marvell ESPRESSObin Ultra | Marvell ESPRESSObin Ultra | mvebu | cortexa53 | `globalscale_espressobin-ultra` | 原生 |
| Marvell ESPRESSObin V7 eMMC / Marvell Armada 3700 Community Board V7 eMMC | Marvell ESPRESSObin V7 eMMC / Marvell Armada 3700 Community Board V7 eMMC | mvebu | cortexa53 | `globalscale_espressobin-v7-emmc` | 原生 |
| Marvell ESPRESSObin V7 Non-eMMC / Marvell Armada 3700 Community Board V7 Non-eMMC | Marvell ESPRESSObin V7 Non-eMMC / Marvell Armada 3700 Community Board V7 Non-eMMC | mvebu | cortexa53 | `globalscale_espressobin-v7` | 原生 |
| MediaTek MT7629 rfb AP | MediaTek MT7629 rfb AP | mediatek | mt7629 | `mediatek_mt7629-rfb` | 原生 |
| MediaTek MT7981 rfb | MediaTek MT7981 rfb | mediatek | filogic | `mediatek_mt7981-rfb` | 原生 |
| MediaTek MT7986 rfba AP (NAND) | MediaTek MT7986 rfba AP (NAND) | mediatek | filogic | `mediatek_mt7986a-rfb-nand` | 原生 |
| MediaTek MT7987A rfb | MediaTek MT7987A rfb | mediatek | filogic | `mediatek_mt7987a-rfb` | 原生 |
| MediaTek MT7988A rfb | MediaTek MT7988A rfb | mediatek | filogic | `mediatek_mt7988a-rfb` | 原生 |
| MediaTek MTK7622 rfb1 AP | MediaTek MTK7622 rfb1 AP | mediatek | mt7622 | `mediatek_mt7622-rfb1` | 原生 |
| MediaTek MTK7622 rfb1 AP (UBI) | MediaTek MTK7622 rfb1 AP (UBI) | mediatek | mt7622 | `mediatek_mt7622-rfb1-ubi` | 原生 |
| MediaTek MTK7986 rfbb AP | MediaTek MTK7986 rfbb AP | mediatek | filogic | `mediatek_mt7986b-rfb` | 原生 |
| Mele M9 | Mele M9 | sunxi | cortexa7 | `mele_m9` | 原生 |
| Meraki MR26 | Meraki MR26 | bcm53xx | generic | `meraki_mr26` | 原生 |
| Meraki MR32 | Meraki MR32 | bcm53xx | generic | `meraki_mr32` | 原生 |
| 水星MR80X v3 | MERCUSYS MR80X v3 | mediatek | filogic | `mercusys_mr80x-v3` | 原生 |
| 水星MR85X | MERCUSYS MR85X | mediatek | filogic | `mercusys_mr85x` | 原生 |
| 水星MR90X v1 | MERCUSYS MR90X v1 | mediatek | filogic | `mercusys_mr90x-v1` | 原生 |
| 水星MR90X v1 (UBI) | MERCUSYS MR90X v1 (UBI) | mediatek | filogic | `mercusys_mr90x-v1-ubi` | 原生 |
| Merrii Hummingbird | Merrii Hummingbird | sunxi | cortexa7 | `merrii_hummingbird` | 原生 |
| Methode eDPU | Methode eDPU | mvebu | cortexa53 | `methode_edpu` | 原生 |
| Methode micro-DPU (uDPU) | Methode micro-DPU (uDPU) | mvebu | cortexa53 | `methode_udpu` | 原生 |
| Microchip EV23X71A | Microchip EV23X71A | microchipsw | lan969x | `microchip_ev23x71a` | 原生 |
| Microchip SAM9X60-EK | Microchip SAM9X60-EK | at91 | sam9x | `microchip_sam9x60ek` | 原生 |
| Microchip SAMA5D2 ICP | Microchip SAMA5D2 ICP | at91 | sama5 | `microchip_sama5d2-icp` | 原生 |
| Microchip SAMA5D2 PTC Ek | Microchip SAMA5D2 PTC Ek | at91 | sama5 | `microchip_sama5d2-ptc-ek` | 原生 |
| Microchip SAMA5D2 Xplained | Microchip SAMA5D2 Xplained | at91 | sama5 | `microchip_sama5d2-xplained` | 原生 |
| Microchip SAMA5D3 Xplained | Microchip SAMA5D3 Xplained | at91 | sama5 | `microchip_sama5d3-xplained` | 原生 |
| Microchip SAMA5D4 Xplained | Microchip SAMA5D4 Xplained | at91 | sama5 | `microchip_sama5d4-xplained` | 原生 |
| Microchip SAMA5D27 SOM1 Ek | Microchip SAMA5D27 SOM1 Ek | at91 | sama5 | `microchip_sama5d27-som1-ek` | 原生 |
| Microchip SAMA5D27 WSOM1 Ek | Microchip SAMA5D27 WSOM1 Ek | at91 | sama5 | `microchip_sama5d27-wlsom1-ek` | 原生 |
| Microchip SAMA7G5-EK | Microchip SAMA7G5-EK | at91 | sama7 | `microchip_sama7g5-ek` | 原生 |
| MikroTik cAP ac | MikroTik cAP ac | ipq40xx | mikrotik | `mikrotik_cap-ac` | 原生 |
| MikroTik hAP ac2 | MikroTik hAP ac2 | ipq40xx | mikrotik | `mikrotik_hap-ac2` | 原生 |
| MikroTik hAP ac3 | MikroTik hAP ac3 | ipq40xx | mikrotik | `mikrotik_hap-ac3` | 原生 |
| MikroTik hAP ac3 LTE6 kit | MikroTik hAP ac3 LTE6 kit | ipq40xx | mikrotik | `mikrotik_hap-ac3-lte6-kit` | 原生 |
| MikroTik RB5009 | MikroTik RB5009 | mvebu | cortexa72 | `mikrotik_rb5009` | 原生 |
| MikroTik SXTsq 5 ac (RBSXTsqG-5acD) | MikroTik SXTsq 5 ac (RBSXTsqG-5acD) | ipq40xx | mikrotik | `mikrotik_sxtsq-5-ac` | 原生 |
| MikroTik wAP ac | MikroTik wAP ac | ipq40xx | mikrotik | `mikrotik_wap-ac` | 原生 |
| MikroTik wAP ac LTE / Mikrotik wAP ac LTE6 | MikroTik wAP ac LTE / Mikrotik wAP ac LTE6 | ipq40xx | mikrotik | `mikrotik_wap-ac-lte` | 原生 |
| MikroTik wAP R ac | MikroTik wAP R ac | ipq40xx | mikrotik | `mikrotik_wap-r-ac` | 原生 |
| MikroTik Wireless Wire Dish LHGG-60ad | MikroTik Wireless Wire Dish LHGG-60ad | ipq40xx | mikrotik | `mikrotik_lhgg-60ad` | 原生 |
| MobiPromo CM520-79F | MobiPromo CM520-79F | ipq40xx | generic | `mobipromo_cm520-79f` | 原生 |
| NEC Aterm WG2600HP | NEC Aterm WG2600HP | ipq806x | generic | `nec_wg2600hp` | 原生 |
| NEC Platforms Aterm WG2600HP3 | NEC Platforms Aterm WG2600HP3 | ipq806x | generic | `nec_wg2600hp3` | 原生 |
| Netcore N60 | Netcore N60 | mediatek | filogic | `netcore_n60` | 原生 |
| Netcore N60 Pro | Netcore N60 Pro | mediatek | filogic | `netcore_n60-pro` | 原生 |
| Netcraze NAP-630 | Netcraze NAP-630 | mediatek | filogic | `netcraze_nap-630` | 原生 |
| Netcraze NC-1812 | Netcraze NC-1812 | mediatek | filogic | `netcraze_nc-1812` | 原生 |
| NETGEAR EAX17 / NETGEAR EAX11 v3 / NETGEAR EAX12 v2 / NETGEAR EAX14 v3 / NETGEAR EAX15 v3 / NETGEAR EAX16 / NETGEAR EAX19 | NETGEAR EAX17 / NETGEAR EAX11 v3 / NETGEAR EAX12 v2 / NETGEAR EAX14 v3 / NETGEAR EAX15 v3 / NETGEAR EAX16 / NETGEAR EAX19 | mediatek | filogic | `netgear_eax17` | 原生 |
| NETGEAR EX6100 v2 | NETGEAR EX6100 v2 | ipq40xx | generic | `netgear_ex6100v2` | 原生 |
| NETGEAR EX6150 v2 | NETGEAR EX6150 v2 | ipq40xx | generic | `netgear_ex6150v2` | 原生 |
| NETGEAR EX6250 v2 / NETGEAR EX6400 v3 / NETGEAR EX6410 v2 / NETGEAR EX6470 | NETGEAR EX6250 v2 / NETGEAR EX6400 v3 / NETGEAR EX6410 v2 / NETGEAR EX6470 | mediatek | mt7629 | `netgear_ex6250-v2` | 原生 |
| NETGEAR LBR20 | NETGEAR LBR20 | ipq40xx | generic | `netgear_lbr20` | 原生 |
| NETGEAR Nighthawk X4 D7800 | NETGEAR Nighthawk X4 D7800 | ipq806x | generic | `netgear_d7800` | 原生 |
| NETGEAR Nighthawk X4 R7500 v1 | NETGEAR Nighthawk X4 R7500 v1 | ipq806x | generic | `netgear_r7500` | 原生 |
| NETGEAR Nighthawk X4 R7500 v2 | NETGEAR Nighthawk X4 R7500 v2 | ipq806x | generic | `netgear_r7500v2` | 原生 |
| NETGEAR Nighthawk X4S R7800 | NETGEAR Nighthawk X4S R7800 | ipq806x | generic | `netgear_r7800` | 原生 |
| NETGEAR Nighthawk XR450 | NETGEAR Nighthawk XR450 | ipq806x | generic | `netgear_xr450` | 原生 |
| NETGEAR Nighthawk XR500 | NETGEAR Nighthawk XR500 | ipq806x | generic | `netgear_xr500` | 原生 |
| NETGEAR R6250 | NETGEAR R6250 | bcm53xx | generic | `netgear_r6250-v1` | 原生 |
| NETGEAR R6300 v2 | NETGEAR R6300 v2 | bcm53xx | generic | `netgear_r6300-v2` | 原生 |
| NETGEAR R7000 | NETGEAR R7000 | bcm53xx | generic | `netgear_r7000` | 原生 |
| NETGEAR R7900 | NETGEAR R7900 | bcm53xx | generic | `netgear_r7900` | 原生 |
| NETGEAR R8000 | NETGEAR R8000 | bcm53xx | generic | `netgear_r8000` | 原生 |
| Netgear R8000P | Netgear R8000P | bcm4908 | generic | `netgear_r8000p` | 原生 |
| NETGEAR R8500 | NETGEAR R8500 | bcm53xx | generic | `netgear_r8500` | 原生 |
| Netgear RAX120v2 | Netgear RAX120v2 | qualcommax | ipq807x | `netgear_rax120v2` | 原生 |
| NETGEAR RBR20 | NETGEAR RBR20 | ipq40xx | generic | `netgear_rbr20` | 原生 |
| NETGEAR RBR40 v1 | NETGEAR RBR40 v1 | ipq40xx | generic | `netgear_rbr40` | 原生 |
| NETGEAR RBR50 v1 | NETGEAR RBR50 v1 | ipq40xx | generic | `netgear_rbr50` | 原生 |
| Netgear RBR350 | Netgear RBR350 | qualcommax | ipq60xx | `netgear_rbr350` | 扩展 |
| Netgear RBR750 | Netgear RBR750 | qualcommax | ipq807x | `netgear_rbr750` | 扩展 |
| NETGEAR RBS20 | NETGEAR RBS20 | ipq40xx | generic | `netgear_rbs20` | 原生 |
| NETGEAR RBS40 v1 | NETGEAR RBS40 v1 | ipq40xx | generic | `netgear_rbs40` | 原生 |
| NETGEAR RBS50 v1 | NETGEAR RBS50 v1 | ipq40xx | generic | `netgear_rbs50` | 原生 |
| Netgear RBS350 | Netgear RBS350 | qualcommax | ipq60xx | `netgear_rbs350` | 扩展 |
| Netgear RBS750 | Netgear RBS750 | qualcommax | ipq807x | `netgear_rbs750` | 扩展 |
| NETGEAR ReadyNAS Duo v2 | NETGEAR ReadyNAS Duo v2 | kirkwood | generic | `netgear_readynas-duo-v2` | 原生 |
| NETGEAR SRR60 | NETGEAR SRR60 | ipq40xx | generic | `netgear_srr60` | 原生 |
| NETGEAR SRS60 | NETGEAR SRS60 | ipq40xx | generic | `netgear_srs60` | 原生 |
| Netgear Stora (MS2000/2110) | Netgear Stora (MS2000/2110) | kirkwood | generic | `netgear_stora` | 原生 |
| Netgear SXR80 | Netgear SXR80 | qualcommax | ipq807x | `netgear_sxr80` | 原生 |
| Netgear SXS80 | Netgear SXS80 | qualcommax | ipq807x | `netgear_sxs80` | 原生 |
| Netgear WAC510 | Netgear WAC510 | ipq40xx | generic | `netgear_wac510` | 原生 |
| NETGEAR WAX206 | NETGEAR WAX206 | mediatek | mt7622 | `netgear_wax206` | 原生 |
| Netgear WAX214 | Netgear WAX214 | qualcommax | ipq60xx | `netgear_wax214` | 原生 |
| Netgear WAX218 | Netgear WAX218 | qualcommax | ipq807x | `netgear_wax218` | 原生 |
| NETGEAR WAX220 | NETGEAR WAX220 | mediatek | filogic | `netgear_wax220` | 原生 |
| Netgear WAX610 | Netgear WAX610 | qualcommax | ipq60xx | `netgear_wax610` | 原生 |
| Netgear WAX610Y | Netgear WAX610Y | qualcommax | ipq60xx | `netgear_wax610y` | 原生 |
| Netgear WAX620 | Netgear WAX620 | qualcommax | ipq807x | `netgear_wax620` | 原生 |
| Netgear WAX630 | Netgear WAX630 | qualcommax | ipq807x | `netgear_wax630` | 原生 |
| Netgear WG302 v1 | Netgear WG302 v1 | ixp4xx | generic | `netgear_wg302v1` | 原生 |
| 磊科EAP930 V1 | netis EAP930 V1 | mediatek | filogic | `netis_eap930-v1` | 原生 |
| 磊科N6 V2 | netis N6 V2 | mediatek | filogic | `netis_n6-v2` | 原生 |
| 磊科NX30 V2 | netis NX30 V2 / GLC W7 / GWBN GW3001 / Netcore N30 Pro / Netcore POWER 30AX / netis MEX605 | mediatek | filogic | `netis_nx30v2` | 原生 |
| 磊科NX31 | netis NX31 | mediatek | filogic | `netis_nx31` | 原生 |
| 磊科NX32U | netis NX32U | mediatek | filogic | `netis_nx32u` | 原生 |
| Nokia AC400i | Nokia AC400i | ipq806x | generic | `nokia_ac400i` | 原生 |
| Nokia EA0326GMP | Nokia EA0326GMP | mediatek | filogic | `nokia_ea0326gmp` | 原生 |
| Novarq Tactical 1000 | Novarq Tactical 1000 | microchipsw | lan969x | `novarq_tactical-1000` | 原生 |
| NRadio C8-668GL | NRadio C8-668GL | mediatek | filogic | `nradio_c8-668gl` | 原生 |
| NXP FRDM-LS1012A | NXP FRDM-LS1012A | layerscape | armv8_64b | `fsl_ls1012a-frdm` | 原生 |
| NXP FRWY-LS1012A | NXP FRWY-LS1012A | layerscape | armv8_64b | `fsl_ls1012a-frwy-sdboot` | 原生 |
| NXP FRWY-LS1046A Default | NXP FRWY-LS1046A Default | layerscape | armv8_64b | `fsl_ls1046a-frwy` | 原生 |
| NXP FRWY-LS1046A SD Card Boot | NXP FRWY-LS1046A SD Card Boot | layerscape | armv8_64b | `fsl_ls1046a-frwy-sdboot` | 原生 |
| NXP i.MX8M | NXP i.MX8M | imx | cortexa53 | `imx8m` | 原生 |
| NXP LS1012A-RDB | NXP LS1012A-RDB | layerscape | armv8_64b | `fsl_ls1012a-rdb` | 原生 |
| NXP LS1021A-IoT SD Card Boot | NXP LS1021A-IoT SD Card Boot | layerscape | armv7 | `fsl_ls1021a-iot-sdboot` | 原生 |
| NXP LS1028A-RDB Default | NXP LS1028A-RDB Default | layerscape | armv8_64b | `fsl_ls1028a-rdb` | 原生 |
| NXP LS1028A-RDB SD Card Boot | NXP LS1028A-RDB SD Card Boot | layerscape | armv8_64b | `fsl_ls1028a-rdb-sdboot` | 原生 |
| NXP LS1043A-RDB Default | NXP LS1043A-RDB Default | layerscape | armv8_64b | `fsl_ls1043a-rdb` | 原生 |
| NXP LS1043A-RDB SD Card Boot | NXP LS1043A-RDB SD Card Boot | layerscape | armv8_64b | `fsl_ls1043a-rdb-sdboot` | 原生 |
| NXP LS1046A-RDB Default | NXP LS1046A-RDB Default | layerscape | armv8_64b | `fsl_ls1046a-rdb` | 原生 |
| NXP LS1046A-RDB SD Card Boot | NXP LS1046A-RDB SD Card Boot | layerscape | armv8_64b | `fsl_ls1046a-rdb-sdboot` | 原生 |
| NXP LS1088A-RDB Default | NXP LS1088A-RDB Default | layerscape | armv8_64b | `fsl_ls1088a-rdb` | 原生 |
| NXP LS1088A-RDB SD Card Boot | NXP LS1088A-RDB SD Card Boot | layerscape | armv8_64b | `fsl_ls1088a-rdb-sdboot` | 原生 |
| NXP LS2088ARDB | NXP LS2088ARDB | layerscape | armv8_64b | `fsl_ls2088a-rdb` | 原生 |
| NXP LX2160A-RDB Rev2.0 silicon | NXP LX2160A-RDB Rev2.0 silicon | layerscape | armv8_64b | `fsl_lx2160a-rdb` | 原生 |
| NXP LX2160A-RDB Rev2.0 silicon SD Card Boot | NXP LX2160A-RDB Rev2.0 silicon SD Card Boot | layerscape | armv8_64b | `fsl_lx2160a-rdb-sdboot` | 原生 |
| NXP TWR-LS1021A Default | NXP TWR-LS1021A Default | layerscape | armv7 | `fsl_ls1021a-twr` | 原生 |
| NXP TWR-LS1021A SD Card Boot | NXP TWR-LS1021A SD Card Boot | layerscape | armv7 | `fsl_ls1021a-twr-sdboot` | 原生 |
| Olimex A10-OLinuXino-LIME | Olimex A10-OLinuXino-LIME | sunxi | cortexa8 | `olimex_a10-olinuxino-lime` | 原生 |
| Olimex A13-OLinuXino / Olimex A13-SOM | Olimex A13-OLinuXino / Olimex A13-SOM | sunxi | cortexa8 | `olimex_a13-olinuxino` | 原生 |
| Olimex A20-OLinuXino-LIME | Olimex A20-OLinuXino-LIME | sunxi | cortexa7 | `olimex_a20-olinuxino-lime` | 原生 |
| Olimex A20-OLinuXino-LIME2 | Olimex A20-OLinuXino-LIME2 | sunxi | cortexa7 | `olimex_a20-olinuxino-lime2` | 原生 |
| Olimex A20-OLinuXino-LIME2 eMMC | Olimex A20-OLinuXino-LIME2 eMMC | sunxi | cortexa7 | `olimex_a20-olinuxino-lime2-emmc` | 原生 |
| Olimex A20-OLinuXino-MICRO | Olimex A20-OLinuXino-MICRO | sunxi | cortexa7 | `olimex_a20-olinuxino-micro` | 原生 |
| Olimex A64-Olinuxino | Olimex A64-Olinuxino | sunxi | cortexa53 | `olimex_a64-olinuxino` | 原生 |
| Olimex A64-Olinuxino eMMC | Olimex A64-Olinuxino eMMC | sunxi | cortexa53 | `olimex_a64-olinuxino-emmc` | 原生 |
| Olimex OLinuXino Maxi | Olimex OLinuXino Maxi | mxs | generic | `olinuxino_maxi` | 原生 |
| Olimex OLinuXino Micro | Olimex OLinuXino Micro | mxs | generic | `olinuxino_micro` | 原生 |
| OpenEmbed SOM7981 | OpenEmbed SOM7981 | mediatek | filogic | `openembed_som7981` | 原生 |
| OpenFi 6C | OpenFi 6C | mediatek | filogic | `openfi_6c` | 原生 |
| OpenMesh A42 | OpenMesh A42 | ipq40xx | generic | `openmesh_a42` | 原生 |
| OpenMesh A62 | OpenMesh A62 | ipq40xx | generic | `openmesh_a62` | 原生 |
| OpenWrt One | OpenWrt One | mediatek | filogic | `openwrt_one` | 原生 |
| P&W R619AC 64M NAND | P&W R619AC 64M NAND | ipq40xx | generic | `p2w_r619ac-64m` | 原生 |
| P&W R619AC 128M NAND | P&W R619AC 128M NAND | ipq40xx | generic | `p2w_r619ac-128m` | 原生 |
| Pakedge WR-1 | Pakedge WR-1 | ipq40xx | generic | `pakedge_wr-1` | 原生 |
| PandaBoard.org OMAP4 TI pandaboard | PandaBoard.org OMAP4 TI pandaboard | omap | generic | `ti_omap4-panda` | 原生 |
| 斐讯K3 | PHICOMM K3 / Wavlink QUANTUM DAX / Wavlink WL-WN538A8 | bcm53xx | generic | `phicomm_k3` | 原生 |
| Pine64 Pine64+ | Pine64 Pine64+ | sunxi | cortexa53 | `pine64_pine64-plus` | 原生 |
| Pine64 PineCube | Pine64 PineCube | sunxi | cortexa7 | `pine64_pinecube` | 扩展 |
| Pine64 Rock64 | Pine64 Rock64 | rockchip | armv8 | `pine64_rock64` | 原生 |
| Pine64 RockPro64 | Pine64 RockPro64 | rockchip | armv8 | `pine64_rockpro64` | 原生 |
| Pine64 SoPine | Pine64 SoPine | sunxi | cortexa53 | `pine64_sopine-baseboard` | 原生 |
| Plasma Cloud PA1200 | Plasma Cloud PA1200 | ipq40xx | generic | `plasmacloud_pa1200` | 原生 |
| Plasma Cloud PA2200 | Plasma Cloud PA2200 | ipq40xx | generic | `plasmacloud_pa2200` | 原生 |
| Plat'Home OpenBlocks AX3 4 ports | Plat'Home OpenBlocks AX3 4 ports | mvebu | cortexa9 | `plathome_openblocks-ax3-4` | 原生 |
| prpl Foundation Haze | prpl Foundation Haze | qualcommax | ipq807x | `prpl_haze` | 原生 |
| 360T7 | Qihoo 360T7 | mediatek | filogic | `qihoo_360t7` | 原生 |
| 360T7（UBI 布局） | Qihoo 360T7 (UBI) | mediatek | filogic | `qihoo_360t7-ubi` | 原生 |
| 360V6 | Qihoo 360V6 | qualcommax | ipq60xx | `qihoo_360v6` | 原生 |
| QNAP 301w | QNAP 301w | qualcommax | ipq807x | `qnap_301w` | 原生 |
| Qualcomm AP148 legacy | Qualcomm AP148 legacy | ipq806x | generic | `qcom_ipq8064-ap148-legacy` | 原生 |
| Qualcomm AP148 standard | Qualcomm AP148 standard | ipq806x | generic | `qcom_ipq8064-ap148` | 原生 |
| Qualcomm AP161 | Qualcomm AP161 | ipq806x | generic | `qcom_ipq8064-ap161` | 原生 |
| Qualcomm DB149 | Qualcomm DB149 | ipq806x | generic | `qcom_ipq8064-db149` | 原生 |
| Qxwlan E2600AC C1 | Qxwlan E2600AC C1 | ipq40xx | generic | `qxwlan_e2600ac-c1` | 原生 |
| Qxwlan E2600AC C2 | Qxwlan E2600AC C2 | ipq40xx | generic | `qxwlan_e2600ac-c2` | 原生 |
| Radxa CM3 IO | Radxa CM3 IO | rockchip | armv8 | `radxa_cm3-io` | 原生 |
| Radxa E20C | Radxa E20C | rockchip | armv8 | `radxa_e20c` | 原生 |
| Radxa E25 | Radxa E25 | rockchip | armv8 | `radxa_e25` | 原生 |
| Radxa E52C | Radxa E52C | rockchip | armv8 | `radxa_e52c` | 原生 |
| Radxa ROCK 2A | Radxa ROCK 2A | rockchip | armv8 | `radxa_rock-2a` | 原生 |
| Radxa ROCK 2F | Radxa ROCK 2F | rockchip | armv8 | `radxa_rock-2f` | 原生 |
| Radxa ROCK 3A | Radxa ROCK 3A | rockchip | armv8 | `radxa_rock-3a` | 原生 |
| Radxa ROCK 3B | Radxa ROCK 3B | rockchip | armv8 | `radxa_rock-3b` | 原生 |
| Radxa ROCK 3C | Radxa ROCK 3C | rockchip | armv8 | `radxa_rock-3c` | 原生 |
| Radxa ROCK 4C+ | Radxa ROCK 4C+ | rockchip | armv8 | `radxa_rock-4c-plus` | 原生 |
| Radxa ROCK 4D | Radxa ROCK 4D | rockchip | armv8 | `radxa_rock-4d` | 原生 |
| Radxa ROCK 4SE | Radxa ROCK 4SE | rockchip | armv8 | `radxa_rock-4se` | 原生 |
| Radxa ROCK 5 ITX/ITX+ | Radxa ROCK 5 ITX/ITX+ | rockchip | armv8 | `radxa_rock-5-itx` | 原生 |
| Radxa ROCK 5A | Radxa ROCK 5A | rockchip | armv8 | `radxa_rock-5a` | 原生 |
| Radxa ROCK 5B | Radxa ROCK 5B | rockchip | armv8 | `radxa_rock-5b` | 原生 |
| Radxa ROCK 5B+ | Radxa ROCK 5B+ | rockchip | armv8 | `radxa_rock-5b-plus` | 原生 |
| Radxa ROCK 5C/5C Lite | Radxa ROCK 5C/5C Lite | rockchip | armv8 | `radxa_rock-5c` | 原生 |
| Radxa ROCK 5T | Radxa ROCK 5T | rockchip | armv8 | `radxa_rock-5t` | 原生 |
| Radxa ROCK Pi 4A | Radxa ROCK Pi 4A | rockchip | armv8 | `radxa_rock-pi-4a` | 原生 |
| Radxa ROCK Pi E | Radxa ROCK Pi E | rockchip | armv8 | `radxa_rock-pi-e` | 原生 |
| Radxa ROCK Pi E v3.0 | Radxa ROCK Pi E v3.0 | rockchip | armv8 | `radxa_rock-pi-e-v3` | 原生 |
| Radxa ROCK Pi S | Radxa ROCK Pi S | rockchip | armv8 | `radxa_rock-pi-s` | 原生 |
| Radxa ZERO 3E | Radxa ZERO 3E | rockchip | armv8 | `radxa_zero-3e` | 原生 |
| Radxa ZERO 3W | Radxa ZERO 3W | rockchip | armv8 | `radxa_zero-3w` | 原生 |
| RaidSonic ICY BOX IB-NAS62x0 | RaidSonic ICY BOX IB-NAS62x0 | kirkwood | generic | `raidsonic_ib-nas62x0` | 原生 |
| Raidsonic NAS IB-4220-B | Raidsonic NAS IB-4220-B | gemini | generic | `raidsonic_ib-4220-b` | 原生 |
| Raspberry Pi 2B/2B 1.2 (32bit) / Raspberry Pi 3A+/3B/3B+/CM3/Zero2/Zero2W (32bit) / Raspberry Pi 4B/400/CM4 (32bit) | Raspberry Pi 2B/2B 1.2 (32bit) / Raspberry Pi 3A+/3B/3B+/CM3/Zero2/Zero2W (32bit) / Raspberry Pi 4B/400/CM4 (32bit) | bcm27xx | bcm2709 | `rpi-2` | 原生 |
| Raspberry Pi 3A+/3B/3B+/CM3/Zero2/Zero2W (64bit) / Raspberry Pi 2B-1.2 (64bit) | Raspberry Pi 3A+/3B/3B+/CM3/Zero2/Zero2W (64bit) / Raspberry Pi 2B-1.2 (64bit) | bcm27xx | bcm2710 | `rpi-3` | 原生 |
| Raspberry Pi 4B/400/CM4 (64bit) | Raspberry Pi 4B/400/CM4 (64bit) | bcm27xx | bcm2711 | `rpi-4` | 原生 |
| Raspberry Pi 5/500/CM5 | Raspberry Pi 5/500/CM5 | bcm27xx | bcm2712 | `rpi-5` | 原生 |
| Raspberry Pi A/A+/B/B+/CM/Zero/ZeroW | Raspberry Pi A/A+/B/B+/CM/Zero/ZeroW | bcm27xx | bcm2708 | `rpi` | 原生 |
| 红米AX6 | Redmi AX6 | qualcommax | ipq807x | `redmi_ax6` | 原生 |
| reyee AX3200 E5 | reyee AX3200 E5 | mediatek | mt7622 | `reyee_ax3200-e5` | 原生 |
| RIPE Atlas v5 | RIPE Atlas v5 | mvebu | cortexa53 | `ripe_atlas-v5` | 原生 |
| Roofull Beelink-X2 | Roofull Beelink-X2 | sunxi | cortexa7 | `roofull_beelink-x2` | 原生 |
| Routerich AX3000 | Routerich AX3000 | mediatek | filogic | `routerich_ax3000` | 原生 |
| Routerich AX3000 (OpenWrt U-Boot layout) | Routerich AX3000 (OpenWrt U-Boot layout) | mediatek | filogic | `routerich_ax3000-ubootmod` | 原生 |
| Routerich AX3000 v1 | Routerich AX3000 v1 | mediatek | filogic | `routerich_ax3000-v1` | 原生 |
| Routerich BE7200 | Routerich BE7200 | mediatek | filogic | `routerich_be7200` | 原生 |
| 锐捷RG-EW3200GX PRO | Ruijie RG-EW3200GX PRO | mediatek | mt7622 | `ruijie_rg-ew3200gx-pro` | 原生 |
| 锐捷RG-X60 Pro | Ruijie RG-X60 Pro | mediatek | filogic | `ruijie_rg-x60-pro` | 原生 |
| Seagate Blackarmor NAS220 | Seagate Blackarmor NAS220 | kirkwood | generic | `seagate_blackarmor-nas220` | 原生 |
| Seagate FreeAgent Dockstar | Seagate FreeAgent Dockstar | kirkwood | generic | `seagate_dockstar` | 原生 |
| Seagate GoFlexHome | Seagate GoFlexHome | kirkwood | generic | `seagate_goflexhome` | 原生 |
| Seagate GoFlexNet | Seagate GoFlexNet | kirkwood | generic | `seagate_goflexnet` | 原生 |
| Sinovoip Banana Pi M2 Berry | Sinovoip Banana Pi M2 Berry | sunxi | cortexa7 | `sinovoip_bpi-m2-berry` | 原生 |
| Sinovoip Banana Pi M2 Ultra | Sinovoip Banana Pi M2 Ultra | sunxi | cortexa7 | `sinovoip_bpi-m2-ultra` | 原生 |
| Sinovoip Banana Pi M2+ | Sinovoip Banana Pi M2+ | sunxi | cortexa7 | `sinovoip_bpi-m2-plus` | 原生 |
| Sinovoip Banana Pi M3 | Sinovoip Banana Pi M3 | sunxi | cortexa7 | `sinovoip_bpi-m3` | 原生 |
| Sinovoip Banana Pi P2 Zero | Sinovoip Banana Pi P2 Zero | sunxi | cortexa7 | `sinovoip_bpi-p2-zero` | 原生 |
| Sinovoip Bananapi-R2 Pro | Sinovoip Bananapi-R2 Pro | rockchip | armv8 | `sinovoip_bpi-r2-pro` | 原生 |
| SKSpruce WIA3300-20 | SKSpruce WIA3300-20 | ipq40xx | generic | `skspruce_wia3300-20` | 原生 |
| SmartRG SR400ac | SmartRG SR400ac | bcm53xx | generic | `smartrg_sr400ac` | 原生 |
| SNR SNR-CPE-AX2 | SNR SNR-CPE-AX2 | mediatek | filogic | `snr_snr-cpe-ax2` | 原生 |
| SolidRun ClearFog Base | SolidRun ClearFog Base | mvebu | cortexa9 | `solidrun_clearfog-base-a1` | 原生 |
| SolidRun Clearfog GT-8K | SolidRun Clearfog GT-8K | mvebu | cortexa72 | `marvell_clearfog-gt-8k` | 原生 |
| SolidRun ClearFog Pro | SolidRun ClearFog Pro | mvebu | cortexa72 | `solidrun_clearfog-pro` | 原生 |
| SolidRun ClearFog Pro | SolidRun ClearFog Pro | mvebu | cortexa9 | `solidrun_clearfog-pro-a1` | 原生 |
| SolidRun CuBox-i | SolidRun CuBox-i | imx | cortexa9 | `solidrun_cubox-i` | 原生 |
| SolidRun MACCHIATObin Double Shot / SolidRun Armada 8040 Community Board Double Shot | SolidRun MACCHIATObin Double Shot / SolidRun Armada 8040 Community Board Double Shot | mvebu | cortexa72 | `marvell_macchiatobin-doubleshot` | 原生 |
| SolidRun MACCHIATObin Single Shot / SolidRun Armada 8040 Community Board Single Shot | SolidRun MACCHIATObin Single Shot / SolidRun Armada 8040 Community Board Single Shot | mvebu | cortexa72 | `marvell_macchiatobin-singleshot` | 原生 |
| Sony NCP-HG100/Cellular | Sony NCP-HG100/Cellular | ipq40xx | generic | `sony_ncp-hg100-cellular` | 原生 |
| Sophos APX 120 | Sophos APX 120 | ipq40xx | generic | `sophos_apx120` | 扩展 |
| SourceParts PopStick v1.1 | SourceParts PopStick v1.1 | sunxi | arm926ejs | `sourceparts_popstick-v1.1` | 原生 |
| Spectrum SAX1V1K | Spectrum SAX1V1K | qualcommax | ipq807x | `spectrum_sax1v1k` | 原生 |
| STMicroelectronics STM32MP135F-DK | STMicroelectronics STM32MP135F-DK | stm32 | stm32mp1 | `stm32mp135f-dk` | 原生 |
| STMicroelectronics STM32MP157C-DK2 | STMicroelectronics STM32MP157C-DK2 | stm32 | stm32mp1 | `stm32mp157c-dk2` | 原生 |
| STMicroelectronics STM32MP157C-DK2 SCMI | STMicroelectronics STM32MP157C-DK2 SCMI | stm32 | stm32mp1 | `stm32mp157c-dk2-scmi` | 原生 |
| StorLink SL93512r | StorLink SL93512r | gemini | generic | `storlink_sl93512r` | 原生 |
| Synology DS213j | Synology DS213j | mvebu | cortexa9 | `synology_ds213j` | 原生 |
| TCL LINKHUB HH500V | TCL LINKHUB HH500V | qualcommax | ipq807x | `tcl_linkhub-hh500v` | 扩展 |
| TechNexion PICO-PI-IMX7D | TechNexion PICO-PI-IMX7D | imx | cortexa7 | `technexion_imx7d-pico-pi` | 原生 |
| Teltonika RUTC50 | Teltonika RUTC50 | mediatek | filogic | `teltonika_rutc50` | 原生 |
| Teltonika RUTX50 | Teltonika RUTX50 | ipq40xx | generic | `teltonika_rutx50` | 原生 |
| Tenbay WR3000K | Tenbay WR3000K | mediatek | filogic | `tenbay_wr3000k` | 原生 |
| 腾达AC9 | Tenda AC9 | bcm53xx | generic | `tenda_ac9` | 原生 |
| 腾达BE12 Pro | Tenda BE12 Pro | mediatek | filogic | `tenda_be12-pro` | 扩展 |
| Teralink TL3020 256mb | Teralink TL3020 256mb | mediatek | filogic | `teralink_tl3020-256mb` | 原生 |
| Texas Instruments AM335x BeagleBone Black | Texas Instruments AM335x BeagleBone Black | omap | generic | `ti_am335x-bone-black` | 原生 |
| Texas Instruments AM335x EVM | Texas Instruments AM335x EVM | omap | generic | `ti_am335x-evm` | 原生 |
| Toradex Apalis family | Toradex Apalis family | imx | cortexa9 | `toradex_apalis` | 原生 |
| TOTOLINK A8000RU | TOTOLINK A8000RU | mediatek | mt7622 | `totolink_a8000ru` | 原生 |
| TOTOLINK X6000R | TOTOLINK X6000R | mediatek | filogic | `totolink_x6000r` | 原生 |
| TP-Link AD7200 v1/v2 / TP-Link Talon AD7200 v1/v2 | TP-Link AD7200 v1/v2 / TP-Link Talon AD7200 v1/v2 | ipq806x | generic | `tplink_ad7200` | 原生 |
| TP-Link Archer AX80 v1 | TP-Link Archer AX80 v1 | mediatek | filogic | `tplink_archer-ax80-v1` | 原生 |
| TP-Link Archer AX80 v1 (EU) | TP-Link Archer AX80 v1 (EU) | mediatek | filogic | `tplink_archer-ax80-v1-eu` | 原生 |
| TP-Link Archer C2300 v1 | TP-Link Archer C2300 v1 | bcm4908 | generic | `tplink_archer-c2300-v1` | 原生 |
| TP-Link Archer C2600 v1 | TP-Link Archer C2600 v1 | ipq806x | generic | `tplink_c2600` | 原生 |
| TP-Link Archer VR2600v v1 | TP-Link Archer VR2600v v1 | ipq806x | generic | `tplink_vr2600v` | 原生 |
| TP-Link BE450 | TP-Link BE450 | mediatek | filogic | `tplink_be450` | 原生 |
| TP-Link BE450 (UBI) | TP-Link BE450 (UBI) | mediatek | filogic | `tplink_be450-ubi` | 扩展 |
| TP-Link Deco X80-5G | TP-Link Deco X80-5G | qualcommax | ipq807x | `tplink_deco-x80-5g` | 原生 |
| TP-Link Deco-M5 v1 | TP-Link Deco-M5 v1 | ipq40xx | generic | `tplink_deco-m5-v1` | 扩展 |
| TP-Link Deco-M5 v2 | TP-Link Deco-M5 v2 | ipq40xx | generic | `tplink_deco-m5-v2` | 扩展 |
| TP-Link Deco-M5 v3 | TP-Link Deco-M5 v3 | ipq40xx | generic | `tplink_deco-m5-v3` | 扩展 |
| TP-Link EAP225 v5 | TP-Link EAP225 v5 | mediatek | mt7629 | `tplink_eap225-v5` | 原生 |
| TP-Link EAP610-Outdoor | TP-Link EAP610-Outdoor | qualcommax | ipq60xx | `tplink_eap610-outdoor` | 原生 |
| TP-Link EAP620 HD v1 | TP-Link EAP620 HD v1 | qualcommax | ipq807x | `tplink_eap620hd-v1` | 原生 |
| TP-Link EAP620 HD v3 | TP-Link EAP620 HD v3 | qualcommax | ipq60xx | `tplink_eap620-hd-v3` | 扩展 |
| TP-Link EAP623-Outdoor HD v1 | TP-Link EAP623-Outdoor HD v1 | qualcommax | ipq60xx | `tplink_eap623-outdoor-hd-v1` | 扩展 |
| TP-Link EAP623-Outdoor HD v1 | TP-Link EAP623-Outdoor HD v1 | qualcommax | ipq60xx | `tplink_eap623od-hd-v1` | 原生 |
| TP-Link EAP625-Outdoor HD v1 and v1.6 | TP-Link EAP625-Outdoor HD v1 and v1.6 | qualcommax | ipq60xx | `tplink_eap625-outdoor-hd-v1` | 原生 |
| TP-Link EAP660 HD v1 | TP-Link EAP660 HD v1 | qualcommax | ipq807x | `tplink_eap660hd-v1` | 原生 |
| TP-Link EAP683-LR / TP-Link EAP683-UR | TP-Link EAP683-LR / TP-Link EAP683-UR | mediatek | filogic | `tplink_eap683-lr` | 原生 |
| TP-Link F65 v1 | TP-Link F65 v1 | mediatek | filogic | `tplink_f65-v1` | 原生 |
| TP-Link FR365 v1 | TP-Link FR365 v1 | mediatek | filogic | `tplink_fr365-v1` | 原生 |
| TP-Link OnHub AC1900 Cloud Router | TP-Link OnHub AC1900 Cloud Router | ipq806x | chromium | `tplink_onhub` | 原生 |
| TP-Link RE6000XD | TP-Link RE6000XD | mediatek | filogic | `tplink_re6000xd` | 原生 |
| 普联XDR4288 | TP-Link TL-XDR4288 | mediatek | filogic | `tplink_tl-xdr4288` | 原生 |
| 普联XDR6086 | TP-Link TL-XDR6086 | mediatek | filogic | `tplink_tl-xdr6086` | 原生 |
| 普联XDR6088 | TP-Link TL-XDR6088 | mediatek | filogic | `tplink_tl-xdr6088` | 原生 |
| 普联XTR8488 | TP-Link TL-XTR8488 | mediatek | filogic | `tplink_tl-xtr8488` | 原生 |
| Traverse Ten64 (NAND boot) | Traverse Ten64 (NAND boot) | layerscape | armv8_64b | `traverse_ten64-mtd` | 原生 |
| Ubiquiti UniFi AC HD | Ubiquiti UniFi AC HD | ipq806x | generic | `ubnt_unifi-ac-hd` | 原生 |
| Ubiquiti UniFi U6 Long-Range v1 | Ubiquiti UniFi U6 Long-Range v1 | mediatek | mt7622 | `ubnt_unifi-6-lr-v1` | 原生 |
| Ubiquiti UniFi U6 Long-Range v1 U-Boot mod | Ubiquiti UniFi U6 Long-Range v1 U-Boot mod | mediatek | mt7622 | `ubnt_unifi-6-lr-v1-ubootmod` | 原生 |
| Ubiquiti UniFi U6 Long-Range v2 | Ubiquiti UniFi U6 Long-Range v2 | mediatek | mt7622 | `ubnt_unifi-6-lr-v2` | 原生 |
| Ubiquiti UniFi U6 Long-Range v2 U-Boot mod | Ubiquiti UniFi U6 Long-Range v2 U-Boot mod | mediatek | mt7622 | `ubnt_unifi-6-lr-v2-ubootmod` | 原生 |
| Ubiquiti UniFi U6 Long-Range v3 | Ubiquiti UniFi U6 Long-Range v3 | mediatek | mt7622 | `ubnt_unifi-6-lr-v3` | 原生 |
| Ubiquiti UniFi U6 Long-Range v3 U-Boot mod | Ubiquiti UniFi U6 Long-Range v3 U-Boot mod | mediatek | mt7622 | `ubnt_unifi-6-lr-v3-ubootmod` | 原生 |
| Ubiquiti UniFi U6+ | Ubiquiti UniFi U6+ | mediatek | filogic | `ubnt_unifi-6-plus` | 原生 |
| UeeVii UAP200 (Widelantech WAP430X) / Widelantech WAP430X | UeeVii UAP200 (Widelantech WAP430X) / Widelantech WAP430X | mediatek | filogic | `widelantech_wap430x` | 原生 |
| UniElec U7623-02 | UniElec U7623-02 | mediatek | mt7623 | `unielec_u7623-02` | 原生 |
| UniElec U7623-02 eMMC/512MiB RAM (legacy image) | UniElec U7623-02 eMMC/512MiB RAM (legacy image) | mediatek | mt7623 | `unielec_u7623-02-emmc-512m-legacy` | 原生 |
| Unielec U7981-01 (EMMC) | Unielec U7981-01 (EMMC) | mediatek | filogic | `unielec_u7981-01-emmc` | 原生 |
| Unielec U7981-01 (NAND) | Unielec U7981-01 (NAND) | mediatek | filogic | `unielec_u7981-01-nand` | 原生 |
| USRobotics USR8200 | USRobotics USR8200 | ixp4xx | generic | `usrobotics_usr8200` | 原生 |
| Wallys DR40X9 | Wallys DR40X9 | ipq40xx | generic | `wallys_dr40x9` | 原生 |
| Wandboard Dual | Wandboard Dual | imx | cortexa9 | `wandboard_dual` | 原生 |
| WAVLINK WL-WN536AX6 Rev a | WAVLINK WL-WN536AX6 Rev a | mediatek | filogic | `wavlink_wl-wn536ax6-a` | 原生 |
| WAVLINK WL-WN551X3 | WAVLINK WL-WN551X3 | mediatek | filogic | `wavlink_wl-wn551x3` | 原生 |
| WAVLINK WL-WN573HX3 / 7Links WLR-1300 | WAVLINK WL-WN573HX3 / 7Links WLR-1300 | mediatek | filogic | `wavlink_wl-wn573hx3` | 原生 |
| WAVLINK WL-WN586X3 | WAVLINK WL-WN586X3 | mediatek | filogic | `wavlink_wl-wn586x3` | 原生 |
| WAVLINK WL-WN586X3B | WAVLINK WL-WN586X3B | mediatek | filogic | `wavlink_wl-wn586x3b` | 原生 |
| WAVLINK WL-WNT100X3 | WAVLINK WL-WNT100X3 | mediatek | filogic | `wavlink_wl-wnt100x3` | 原生 |
| WAVLINK WL-WNT100X3 (OpenWrt U-Boot layout) | WAVLINK WL-WNT100X3 (OpenWrt U-Boot layout) | mediatek | filogic | `wavlink_wl-wnt100x3-ubootmod` | 原生 |
| Western Digital MyCloud EX2 Ultra | Western Digital MyCloud EX2 Ultra | mvebu | cortexa9 | `wd_cloud-ex2-ultra` | 原生 |
| Western Digital MyCloud Mirror Gen 2 (BWVZ/Grand Teton) | Western Digital MyCloud Mirror Gen 2 (BWVZ/Grand Teton) | mvebu | cortexa9 | `wd_cloud-mirror-gen2` | 原生 |
| 小米AX3600 | Xiaomi AX3600 | qualcommax | ipq807x | `xiaomi_ax3600` | 原生 |
| 小米AX6000 | Xiaomi AX6000 | qualcommax | ipq50xx | `xiaomi_ax6000` | 原生 |
| 小米AX9000 | Xiaomi AX9000 | qualcommax | ipq807x | `xiaomi_ax9000` | 原生 |
| 小米AX3000T | Xiaomi Mi Router AX3000T | mediatek | filogic | `xiaomi_mi-router-ax3000t` | 原生 |
| 小米AX3000T（U-Boot 布局） | Xiaomi Mi Router AX3000T (OpenWrt U-Boot layout) | mediatek | filogic | `xiaomi_mi-router-ax3000t-ubootmod` | 原生 |
| 小米WR30U（U-Boot 布局） | Xiaomi Mi Router WR30U (OpenWrt U-Boot layout) | mediatek | filogic | `xiaomi_mi-router-wr30u-ubootmod` | 原生 |
| 小米WR30U（原厂布局） | Xiaomi Mi Router WR30U (stock layout) | mediatek | filogic | `xiaomi_mi-router-wr30u-stock` | 原生 |
| 红米AX5400 | Xiaomi Redmi AX5400 | qualcommax | ipq50xx | `xiaomi_redmi-ax5400` | 扩展 |
| 红米AX6S | Xiaomi Redmi Router AX6S / Xiaomi Router AX3200 | mediatek | mt7622 | `xiaomi_redmi-router-ax6s` | 原生 |
| 红米AX6000（U-Boot 布局） | Xiaomi Redmi Router AX6000 (OpenWrt U-Boot layout) | mediatek | filogic | `xiaomi_redmi-router-ax6000-ubootmod` | 原生 |
| 红米AX6000（原厂布局） | Xiaomi Redmi Router AX6000 (stock layout) | mediatek | filogic | `xiaomi_redmi-router-ax6000-stock` | 原生 |
| Xilinx ZC702 | Xilinx ZC702 | zynq | generic | `xlnx_zynq-zc702` | 原生 |
| Xunlong Orange Pi 2 | Xunlong Orange Pi 2 | sunxi | cortexa7 | `xunlong_orangepi-2` | 原生 |
| Xunlong Orange Pi One | Xunlong Orange Pi One | sunxi | cortexa7 | `xunlong_orangepi-one` | 原生 |
| Xunlong Orange Pi One Plus | Xunlong Orange Pi One Plus | sunxi | cortexa53 | `xunlong_orangepi-one-plus` | 原生 |
| Xunlong Orange Pi PC | Xunlong Orange Pi PC | sunxi | cortexa7 | `xunlong_orangepi-pc` | 原生 |
| Xunlong Orange Pi PC 2 | Xunlong Orange Pi PC 2 | sunxi | cortexa53 | `xunlong_orangepi-pc2` | 原生 |
| Xunlong Orange Pi PC Plus | Xunlong Orange Pi PC Plus | sunxi | cortexa7 | `xunlong_orangepi-pc-plus` | 原生 |
| Xunlong Orange Pi Plus | Xunlong Orange Pi Plus | sunxi | cortexa7 | `xunlong_orangepi-plus` | 原生 |
| Xunlong Orange Pi R1 | Xunlong Orange Pi R1 | sunxi | cortexa7 | `xunlong_orangepi-r1` | 原生 |
| Xunlong Orange Pi R1 Plus | Xunlong Orange Pi R1 Plus | rockchip | armv8 | `xunlong_orangepi-r1-plus` | 原生 |
| Xunlong Orange Pi R1 Plus LTS | Xunlong Orange Pi R1 Plus LTS | rockchip | armv8 | `xunlong_orangepi-r1-plus-lts` | 原生 |
| Xunlong Orange Pi Zero | Xunlong Orange Pi Zero | sunxi | cortexa7 | `xunlong_orangepi-zero` | 原生 |
| Xunlong Orange Pi Zero 2 | Xunlong Orange Pi Zero 2 | sunxi | cortexa53 | `xunlong_orangepi-zero2` | 原生 |
| Xunlong Orange Pi Zero 2W | Xunlong Orange Pi Zero 2W | sunxi | cortexa53 | `xunlong_orangepi-zero2w` | 原生 |
| Xunlong Orange Pi Zero 3 | Xunlong Orange Pi Zero 3 | sunxi | cortexa53 | `xunlong_orangepi-zero3` | 原生 |
| Xunlong Orange Pi Zero Plus | Xunlong Orange Pi Zero Plus | sunxi | cortexa53 | `xunlong_orangepi-zero-plus` | 原生 |
| 云联友科Yuncore AX830 | Yuncore AX830 | qualcommax | ipq50xx | `yuncore_ax830` | 原生 |
| 云联友科AX835 | YunCore AX835 | mediatek | filogic | `yuncore_ax835` | 原生 |
| 云联友科Yuncore AX850 | Yuncore AX850 | qualcommax | ipq50xx | `yuncore_ax850` | 原生 |
| 云联友科Yuncore AX880 | Yuncore AX880 | qualcommax | ipq807x | `yuncore_ax880` | 原生 |
| 云联友科Yuncore FAP650 | Yuncore FAP650 | qualcommax | ipq60xx | `yuncore_fap650` | 原生 |
| YYeTs LE1 | YYeTs LE1 | ipq40xx | generic | `yyets_le1` | 原生 |
| 智博通ZBT-Z800AX | Zbtlink ZBT-Z800AX | qualcommax | ipq807x | `zbtlink_zbt-z800ax` | 原生 |
| 智博通ZBT-Z8102AX | Zbtlink ZBT-Z8102AX | mediatek | filogic | `zbtlink_zbt-z8102ax` | 原生 |
| 智博通ZBT-Z8102AX-V2 | Zbtlink ZBT-Z8102AX-V2 | mediatek | filogic | `zbtlink_zbt-z8102ax-v2` | 原生 |
| 智博通ZBT-Z8103AX | Zbtlink ZBT-Z8103AX | mediatek | filogic | `zbtlink_zbt-z8103ax` | 原生 |
| 智博通ZBT-Z8103AX-C | Zbtlink ZBT-Z8103AX-C / Zbtlink ZBT-Z8103AX-D | mediatek | filogic | `zbtlink_zbt-z8103ax-c` | 原生 |
| 智博通ZBT-Z8106AX-S | Zbtlink ZBT-Z8106AX-S | mediatek | filogic | `zbtlink_zbt-z8106ax-s` | 原生 |
| 智博通ZBT-Z8106AX-T | Zbtlink ZBT-Z8106AX-T / Zbtlink ZBT-Z8106AX-M2-T | mediatek | filogic | `zbtlink_zbt-z8106ax-t` | 原生 |
| 智博通ZBT-Z8803BE | Zbtlink ZBT-Z8803BE | mediatek | filogic | `zbtlink_zbt-z8803be` | 扩展 |
| 中兴MF18A | ZTE MF18A | ipq40xx | generic | `zte_mf18a` | 原生 |
| 中兴MF269 | ZTE MF269 | qualcommax | ipq807x | `zte_mf269` | 原生 |
| 中兴MF282Plus | ZTE MF282Plus | ipq40xx | generic | `zte_mf282plus` | 原生 |
| 中兴MF286D | ZTE MF286D | ipq40xx | generic | `zte_mf286d` | 原生 |
| 中兴MF287 | ZTE MF287 | ipq40xx | generic | `zte_mf287` | 原生 |
| 中兴MF287Plus | ZTE MF287Plus | ipq40xx | generic | `zte_mf287plus` | 原生 |
| 中兴MF287Pro | ZTE MF287Pro | ipq40xx | generic | `zte_mf287pro` | 原生 |
| 中兴MF289F | ZTE MF289F | ipq40xx | generic | `zte_mf289f` | 原生 |
| Zyxel EX5601-T0 (OpenWrt U-Boot layout) / Zyxel EX5601-T1 / Zyxel T-56 | Zyxel EX5601-T0 (OpenWrt U-Boot layout) / Zyxel EX5601-T1 / Zyxel T-56 | mediatek | filogic | `zyxel_ex5601-t0-ubootmod` | 原生 |
| Zyxel EX5601-T0 (stock layout) / Zyxel EX5601-T1 / Zyxel T-56 | Zyxel EX5601-T0 (stock layout) / Zyxel EX5601-T1 / Zyxel T-56 | mediatek | filogic | `zyxel_ex5601-t0-stock` | 原生 |
| Zyxel EX5700 (Telenor) | Zyxel EX5700 (Telenor) | mediatek | filogic | `zyxel_ex5700-telenor` | 原生 |
| Zyxel NAS326 | Zyxel NAS326 | mvebu | cortexa9 | `zyxel_nas326` | 原生 |
| Zyxel NBG6617 | Zyxel NBG6617 | ipq40xx | generic | `zyxel_nbg6617` | 原生 |
| Zyxel NBG6817 | Zyxel NBG6817 | ipq806x | generic | `zyxel_nbg6817` | 原生 |
| ZYXEL NBG7815 | ZYXEL NBG7815 | qualcommax | ipq807x | `zyxel_nbg7815` | 原生 |
| Zyxel NSA310b | Zyxel NSA310b | kirkwood | generic | `zyxel_nsa310b` | 原生 |
| Zyxel NSA310S | Zyxel NSA310S | kirkwood | generic | `zyxel_nsa310s` | 原生 |
| Zyxel NSA325 v1/v2 | Zyxel NSA325 v1/v2 | kirkwood | generic | `zyxel_nsa325` | 原生 |
| Zyxel NWA50AX Pro / Zyxel NWA90AX Pro | Zyxel NWA50AX Pro / Zyxel NWA90AX Pro | mediatek | filogic | `zyxel_nwa50ax-pro` | 原生 |
| Zyxel NWA110AX | Zyxel NWA110AX | qualcommax | ipq807x | `zyxel_nwa110ax` | 扩展 |
| ZYXEL NWA210AX | ZYXEL NWA210AX | qualcommax | ipq807x | `zyxel_nwa210ax` | 原生 |
| Zyxel SCR50AXE | Zyxel SCR50AXE | qualcommax | ipq50xx | `zyxel_scr50axe` | 原生 |
| Zyxel WX5600-T0 (OpenWrt U-Boot layout) | Zyxel WX5600-T0 (OpenWrt U-Boot layout) | mediatek | filogic | `zyxel_wx5600-t0-ubootmod` | 原生 |
| 8devices Habanero DVK | 8devices Habanero DVK | ipq40xx | generic | `8dev_habanero-dvk` | 原生 |
| 8devices Jalapeno | 8devices Jalapeno | ipq40xx | generic | `8dev_jalapeno` | 原生 |
| 8devices Mango-DVK | 8devices Mango-DVK | qualcommax | ipq60xx | `8devices_mango-dvk` | 原生 |
