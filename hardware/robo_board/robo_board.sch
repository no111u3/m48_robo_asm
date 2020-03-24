EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Microchip_ATmega:ATmega48-20PU U101
U 1 1 5E779D7A
P 4200 3450
F 0 "U101" H 3556 3496 50  0000 R CNN
F 1 "ATmega48-20PU" H 3556 3405 50  0000 R CNN
F 2 "Package_DIP:DIP-28_W7.62mm" H 4200 3450 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-2545-8-bit-AVR-Microcontroller-ATmega48-88-168_Datasheet.pdf" H 4200 3450 50  0001 C CNN
	1    4200 3450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E77AE8C
P 4200 5100
F 0 "#PWR?" H 4200 4850 50  0001 C CNN
F 1 "GND" H 4205 4927 50  0000 C CNN
F 2 "" H 4200 5100 50  0001 C CNN
F 3 "" H 4200 5100 50  0001 C CNN
	1    4200 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 4950 4200 5100
$Comp
L Driver_Motor:L293D U102
U 1 1 5E77D7F5
P 6650 3000
F 0 "U102" H 6900 4100 50  0000 C CNN
F 1 "L293D" H 6900 4000 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 6900 2250 50  0001 L CNN
F 3 "http://www.ti.com/lit/ds/symlink/l293.pdf" H 6350 3700 50  0001 C CNN
	1    6650 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6450 3800 6450 3900
Wire Wire Line
	6550 3800 6550 3900
Wire Wire Line
	6550 3900 6450 3900
Connection ~ 6450 3900
Wire Wire Line
	6450 3900 6450 4050
Wire Wire Line
	6750 3800 6750 3900
Wire Wire Line
	6750 3900 6550 3900
Connection ~ 6550 3900
Wire Wire Line
	6850 3800 6850 3900
Wire Wire Line
	6850 3900 6750 3900
Connection ~ 6750 3900
$Comp
L power:VDD #PWR?
U 1 1 5E792287
P 4200 1700
F 0 "#PWR?" H 4200 1550 50  0001 C CNN
F 1 "VDD" H 4217 1873 50  0000 C CNN
F 2 "" H 4200 1700 50  0001 C CNN
F 3 "" H 4200 1700 50  0001 C CNN
	1    4200 1700
	1    0    0    -1  
$EndComp
$Comp
L power:Vdrive #PWR?
U 1 1 5E793990
P 6550 1750
F 0 "#PWR?" H 6350 1600 50  0001 C CNN
F 1 "Vdrive" H 6567 1923 50  0000 C CNN
F 2 "" H 6550 1750 50  0001 C CNN
F 3 "" H 6550 1750 50  0001 C CNN
	1    6550 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 1700 4200 1800
Wire Wire Line
	4300 1950 4300 1800
Wire Wire Line
	4300 1800 4200 1800
Connection ~ 4200 1800
Wire Wire Line
	4200 1800 4200 1950
Wire Wire Line
	6550 1750 6550 1850
Wire Wire Line
	6750 2000 6750 1850
Wire Wire Line
	6750 1850 6550 1850
Connection ~ 6550 1850
Wire Wire Line
	6550 1850 6550 2000
$Comp
L Device:C C102
U 1 1 5E7975D3
P 3450 2450
F 0 "C102" H 3565 2496 50  0000 L CNN
F 1 "0.1" H 3565 2405 50  0000 L CNN
F 2 "" H 3488 2300 50  0001 C CNN
F 3 "~" H 3450 2450 50  0001 C CNN
	1    3450 2450
	1    0    0    -1  
$EndComp
$Comp
L Device:C C101
U 1 1 5E7987C5
P 3500 1850
F 0 "C101" H 3615 1896 50  0000 L CNN
F 1 "0.1" H 3615 1805 50  0000 L CNN
F 2 "" H 3538 1700 50  0001 C CNN
F 3 "~" H 3500 1850 50  0001 C CNN
	1    3500 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 1700 4200 1700
Connection ~ 4200 1700
Wire Wire Line
	3450 2300 3450 2250
Wire Wire Line
	3450 2250 3600 2250
$Comp
L power:GND #PWR?
U 1 1 5E79D8C7
P 3500 2100
F 0 "#PWR?" H 3500 1850 50  0001 C CNN
F 1 "GND" H 3505 1927 50  0000 C CNN
F 2 "" H 3500 2100 50  0001 C CNN
F 3 "" H 3500 2100 50  0001 C CNN
	1    3500 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E79E0AD
P 3450 2700
F 0 "#PWR?" H 3450 2450 50  0001 C CNN
F 1 "GND" H 3455 2527 50  0000 C CNN
F 2 "" H 3450 2700 50  0001 C CNN
F 3 "" H 3450 2700 50  0001 C CNN
	1    3450 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 2000 3500 2100
Wire Wire Line
	3450 2600 3450 2700
$Comp
L Device:C C104
U 1 1 5E79FAE9
P 6350 1900
F 0 "C104" H 6465 1946 50  0000 L CNN
F 1 "0.1" H 6465 1855 50  0000 L CNN
F 2 "" H 6388 1750 50  0001 C CNN
F 3 "~" H 6350 1900 50  0001 C CNN
	1    6350 1900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C103
U 1 1 5E7A097D
P 6050 1900
F 0 "C103" H 6165 1946 50  0000 L CNN
F 1 "0.1" H 6165 1855 50  0000 L CNN
F 2 "" H 6088 1750 50  0001 C CNN
F 3 "~" H 6050 1900 50  0001 C CNN
	1    6050 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 1750 6550 1750
Connection ~ 6550 1750
Wire Wire Line
	6350 1750 6050 1750
Connection ~ 6350 1750
Wire Wire Line
	6350 2050 6050 2050
$Comp
L power:GND #PWR?
U 1 1 5E7A322C
P 6050 2150
F 0 "#PWR?" H 6050 1900 50  0001 C CNN
F 1 "GND" H 6055 1977 50  0000 C CNN
F 2 "" H 6050 2150 50  0001 C CNN
F 3 "" H 6050 2150 50  0001 C CNN
	1    6050 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 2050 6050 2150
Connection ~ 6050 2050
$Comp
L Motor:Motor_DC M?
U 1 1 5E7A706B
P 7850 2450
F 0 "M?" H 8008 2446 50  0000 L CNN
F 1 "Motor_DC" H 8008 2355 50  0000 L CNN
F 2 "" H 7850 2360 50  0001 C CNN
F 3 "~" H 7850 2360 50  0001 C CNN
	1    7850 2450
	1    0    0    -1  
$EndComp
$Comp
L Motor:Motor_DC M?
U 1 1 5E7A8215
P 7850 3100
F 0 "M?" H 8008 3096 50  0000 L CNN
F 1 "Motor_DC" H 8008 3005 50  0000 L CNN
F 2 "" H 7850 3010 50  0001 C CNN
F 3 "~" H 7850 3010 50  0001 C CNN
	1    7850 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	7850 2250 7850 2200
Wire Wire Line
	7850 2200 7350 2200
Wire Wire Line
	7350 2200 7350 2400
Wire Wire Line
	7350 2400 7150 2400
Wire Wire Line
	7850 2750 7350 2750
Wire Wire Line
	7350 2750 7350 2600
Wire Wire Line
	7350 2600 7150 2600
Wire Wire Line
	7850 2900 7850 2850
Wire Wire Line
	7850 2850 7350 2850
Wire Wire Line
	7350 2850 7350 3000
Wire Wire Line
	7350 3000 7150 3000
Wire Wire Line
	7850 3400 7850 3450
Wire Wire Line
	7850 3450 7350 3450
Wire Wire Line
	7350 3450 7350 3200
Wire Wire Line
	7350 3200 7150 3200
$Comp
L Device:Q_Photo_NPN Q104
U 1 1 5E7ACEBC
P 1050 6000
F 0 "Q104" H 1240 6046 50  0000 L CNN
F 1 "Q_Photo_NPN" H 1240 5955 50  0000 L CNN
F 2 "" H 1250 6100 50  0001 C CNN
F 3 "~" H 1050 6000 50  0001 C CNN
	1    1050 6000
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_Photo_NPN Q105
U 1 1 5E7B04F9
P 1350 6400
F 0 "Q105" H 1540 6446 50  0000 L CNN
F 1 "Q_Photo_NPN" H 1540 6355 50  0000 L CNN
F 2 "" H 1550 6500 50  0001 C CNN
F 3 "~" H 1350 6400 50  0001 C CNN
	1    1350 6400
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_Photo_NPN Q106
U 1 1 5E7B1DB8
P 1700 6800
F 0 "Q106" H 1890 6846 50  0000 L CNN
F 1 "Q_Photo_NPN" H 1890 6755 50  0000 L CNN
F 2 "" H 1900 6900 50  0001 C CNN
F 3 "~" H 1700 6800 50  0001 C CNN
	1    1700 6800
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_Photo_NPN Q101
U 1 1 5E7B2D00
P 3150 6000
F 0 "Q101" H 3340 6046 50  0000 L CNN
F 1 "Q_Photo_NPN" H 3340 5955 50  0000 L CNN
F 2 "" H 3350 6100 50  0001 C CNN
F 3 "~" H 3150 6000 50  0001 C CNN
	1    3150 6000
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_Photo_NPN Q102
U 1 1 5E7B3E17
P 3500 6400
F 0 "Q102" H 3690 6446 50  0000 L CNN
F 1 "Q_Photo_NPN" H 3690 6355 50  0000 L CNN
F 2 "" H 3700 6500 50  0001 C CNN
F 3 "~" H 3500 6400 50  0001 C CNN
	1    3500 6400
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_Photo_NPN Q103
U 1 1 5E7B4911
P 3850 6850
F 0 "Q103" H 4040 6896 50  0000 L CNN
F 1 "Q_Photo_NPN" H 4040 6805 50  0000 L CNN
F 2 "" H 4050 6950 50  0001 C CNN
F 3 "~" H 3850 6850 50  0001 C CNN
	1    3850 6850
	1    0    0    -1  
$EndComp
$Comp
L Device:R R104
U 1 1 5E7B59BD
P 1150 5550
F 0 "R104" H 1220 5596 50  0000 L CNN
F 1 "47k" H 1220 5505 50  0000 L CNN
F 2 "" V 1080 5550 50  0001 C CNN
F 3 "~" H 1150 5550 50  0001 C CNN
	1    1150 5550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R106
U 1 1 5E7B7319
P 1800 6100
F 0 "R106" H 1870 6146 50  0000 L CNN
F 1 "47k" H 1870 6055 50  0000 L CNN
F 2 "" V 1730 6100 50  0001 C CNN
F 3 "~" H 1800 6100 50  0001 C CNN
	1    1800 6100
	1    0    0    -1  
$EndComp
$Comp
L Device:R R101
U 1 1 5E7B8795
P 3250 5500
F 0 "R101" H 3320 5546 50  0000 L CNN
F 1 "47k" H 3320 5455 50  0000 L CNN
F 2 "" V 3180 5500 50  0001 C CNN
F 3 "~" H 3250 5500 50  0001 C CNN
	1    3250 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R102
U 1 1 5E7B9177
P 3600 5800
F 0 "R102" H 3670 5846 50  0000 L CNN
F 1 "47k" H 3670 5755 50  0000 L CNN
F 2 "" V 3530 5800 50  0001 C CNN
F 3 "~" H 3600 5800 50  0001 C CNN
	1    3600 5800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R103
U 1 1 5E7B9B7E
P 3950 6100
F 0 "R103" H 4020 6146 50  0000 L CNN
F 1 "47k" H 4020 6055 50  0000 L CNN
F 2 "" V 3880 6100 50  0001 C CNN
F 3 "~" H 3950 6100 50  0001 C CNN
	1    3950 6100
	1    0    0    -1  
$EndComp
$Comp
L Device:R R105
U 1 1 5E7B6249
P 1450 5800
F 0 "R105" H 1520 5846 50  0000 L CNN
F 1 "47k" H 1520 5755 50  0000 L CNN
F 2 "" V 1380 5800 50  0001 C CNN
F 3 "~" H 1450 5800 50  0001 C CNN
	1    1450 5800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E785F1D
P 6450 4050
F 0 "#PWR?" H 6450 3800 50  0001 C CNN
F 1 "GND" H 6455 3877 50  0000 C CNN
F 2 "" H 6450 4050 50  0001 C CNN
F 3 "" H 6450 4050 50  0001 C CNN
	1    6450 4050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E7C3FF2
P 3950 7250
F 0 "#PWR?" H 3950 7000 50  0001 C CNN
F 1 "GND" H 3955 7077 50  0000 C CNN
F 2 "" H 3950 7250 50  0001 C CNN
F 3 "" H 3950 7250 50  0001 C CNN
	1    3950 7250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E7C4782
P 1800 7200
F 0 "#PWR?" H 1800 6950 50  0001 C CNN
F 1 "GND" H 1805 7027 50  0000 C CNN
F 2 "" H 1800 7200 50  0001 C CNN
F 3 "" H 1800 7200 50  0001 C CNN
	1    1800 7200
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 7250 3950 7100
Wire Wire Line
	3600 7100 3950 7100
Wire Wire Line
	3600 6600 3600 6650
Connection ~ 3950 7100
Wire Wire Line
	3950 7100 3950 7050
Wire Wire Line
	3250 6200 3250 6650
Wire Wire Line
	3250 6650 3600 6650
Connection ~ 3600 6650
Wire Wire Line
	3600 6650 3600 7100
Wire Wire Line
	1800 7000 1800 7050
Wire Wire Line
	1450 6600 1450 6650
Wire Wire Line
	1450 7050 1800 7050
Connection ~ 1800 7050
Wire Wire Line
	1800 7050 1800 7200
Wire Wire Line
	1150 6200 1150 6650
Wire Wire Line
	1150 6650 1450 6650
Connection ~ 1450 6650
Wire Wire Line
	1450 6650 1450 7050
$Comp
L power:VDD #PWR?
U 1 1 5E7F1D92
P 3600 5250
F 0 "#PWR?" H 3600 5100 50  0001 C CNN
F 1 "VDD" H 3617 5423 50  0000 C CNN
F 2 "" H 3600 5250 50  0001 C CNN
F 3 "" H 3600 5250 50  0001 C CNN
	1    3600 5250
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR?
U 1 1 5E7F2C55
P 1450 5200
F 0 "#PWR?" H 1450 5050 50  0001 C CNN
F 1 "VDD" H 1467 5373 50  0000 C CNN
F 2 "" H 1450 5200 50  0001 C CNN
F 3 "" H 1450 5200 50  0001 C CNN
	1    1450 5200
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 5350 3600 5350
Wire Wire Line
	3600 5350 3600 5250
Wire Wire Line
	3600 5350 3600 5650
Connection ~ 3600 5350
Wire Wire Line
	3600 5350 3950 5350
Wire Wire Line
	3950 5350 3950 5950
Wire Wire Line
	1450 5200 1150 5200
Wire Wire Line
	1150 5200 1150 5400
Wire Wire Line
	1450 5200 1450 5650
Connection ~ 1450 5200
Wire Wire Line
	1450 5200 1800 5200
Wire Wire Line
	1800 5200 1800 5950
$Comp
L Switch:SW_Push SW101
U 1 1 5E81B0B8
P 7500 4000
F 0 "SW101" H 7500 4285 50  0000 C CNN
F 1 "SW_Push" H 7500 4194 50  0000 C CNN
F 2 "" H 7500 4200 50  0001 C CNN
F 3 "~" H 7500 4200 50  0001 C CNN
	1    7500 4000
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW102
U 1 1 5E81BDFB
P 7500 4400
F 0 "SW102" H 7500 4685 50  0000 C CNN
F 1 "SW_Push" H 7500 4594 50  0000 C CNN
F 2 "" H 7500 4600 50  0001 C CNN
F 3 "~" H 7500 4600 50  0001 C CNN
	1    7500 4400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E81CB0B
P 7850 4550
F 0 "#PWR?" H 7850 4300 50  0001 C CNN
F 1 "GND" H 7855 4377 50  0000 C CNN
F 2 "" H 7850 4550 50  0001 C CNN
F 3 "" H 7850 4550 50  0001 C CNN
	1    7850 4550
	1    0    0    -1  
$EndComp
Wire Wire Line
	7700 4000 7850 4000
Wire Wire Line
	7850 4000 7850 4400
Wire Wire Line
	7700 4400 7850 4400
Connection ~ 7850 4400
Wire Wire Line
	7850 4400 7850 4550
$Comp
L Connector:Conn_01x03_Female J101
U 1 1 5E830609
P 6500 4650
F 0 "J101" H 6528 4676 50  0000 L CNN
F 1 "Conn_01x03_Female" H 6528 4585 50  0000 L CNN
F 2 "" H 6500 4650 50  0001 C CNN
F 3 "~" H 6500 4650 50  0001 C CNN
	1    6500 4650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E8317F5
P 6150 4850
F 0 "#PWR?" H 6150 4600 50  0001 C CNN
F 1 "GND" H 6155 4677 50  0000 C CNN
F 2 "" H 6150 4850 50  0001 C CNN
F 3 "" H 6150 4850 50  0001 C CNN
	1    6150 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	6300 4750 6150 4750
Wire Wire Line
	6150 4750 6150 4850
Wire Wire Line
	3250 5650 3250 5700
Wire Wire Line
	3600 5950 3600 6100
Wire Wire Line
	3950 6250 3950 6500
Wire Wire Line
	1150 5700 1150 5800
Wire Wire Line
	1800 6250 1800 6550
Wire Bus Line
	5100 4800 5900 4800
Entry Wire Line
	5000 3150 5100 3250
Entry Wire Line
	5000 3250 5100 3350
Entry Wire Line
	5000 3350 5100 3450
Entry Wire Line
	5000 3450 5100 3550
Entry Wire Line
	5000 3550 5100 3650
Entry Wire Line
	5000 3650 5100 3750
Entry Wire Line
	5000 3750 5100 3850
Wire Wire Line
	4800 3150 5000 3150
Wire Wire Line
	4800 3250 5000 3250
Wire Wire Line
	4800 3350 5000 3350
Wire Wire Line
	4800 3450 5000 3450
Wire Wire Line
	4800 3550 5000 3550
Wire Wire Line
	4800 3650 5000 3650
Wire Wire Line
	4800 3750 5000 3750
Text Label 4900 3150 0    50   ~ 0
A0
Text Label 4900 3250 0    50   ~ 0
A1
Text Label 4900 3450 0    50   ~ 0
A3
Text Label 4900 3350 0    50   ~ 0
A2
Text Label 4900 3550 0    50   ~ 0
A4
Text Label 4900 3650 0    50   ~ 0
A5
Text Label 4800 3750 0    50   ~ 0
RESET
Entry Wire Line
	5900 3850 6000 3950
Wire Wire Line
	6000 4000 6000 3950
Text Label 6050 4000 0    50   ~ 0
RESET
Wire Bus Line
	5100 7550 2650 7550
Connection ~ 5100 4800
Entry Wire Line
	2650 5600 2750 5700
Entry Wire Line
	5000 6500 5100 6600
Entry Wire Line
	5000 6250 5100 6350
Wire Wire Line
	3600 6100 3800 6100
Wire Wire Line
	3800 6100 3800 5900
Wire Wire Line
	3800 5900 5000 5900
Wire Wire Line
	5000 5900 5000 6250
Connection ~ 3600 6100
Wire Wire Line
	3600 6100 3600 6200
Wire Wire Line
	3950 6500 5000 6500
Connection ~ 3950 6500
Wire Wire Line
	3950 6500 3950 6650
Wire Wire Line
	2750 5700 3250 5700
Connection ~ 3250 5700
Wire Wire Line
	3250 5700 3250 5800
Text Label 2800 5700 0    50   ~ 0
A0
Text Label 4850 5900 0    50   ~ 0
A1
Text Label 4850 6500 0    50   ~ 0
A2
Wire Bus Line
	2650 7550 600  7550
Connection ~ 2650 7550
Entry Wire Line
	600  5600 700  5700
Entry Wire Line
	2550 6250 2650 6350
Entry Wire Line
	2550 6550 2650 6650
Wire Wire Line
	700  5700 1150 5700
Connection ~ 1150 5700
Wire Wire Line
	1450 5950 1450 6150
Wire Wire Line
	2550 6250 2350 6250
Wire Wire Line
	2350 6250 2350 6350
Wire Wire Line
	2350 6350 1550 6350
Wire Wire Line
	1550 6350 1550 6150
Wire Wire Line
	1550 6150 1450 6150
Connection ~ 1450 6150
Wire Wire Line
	1450 6150 1450 6200
Wire Wire Line
	2550 6550 1800 6550
Connection ~ 1800 6550
Wire Wire Line
	1800 6550 1800 6600
Text Label 750  5700 0    50   ~ 0
A3
Text Label 2250 6350 0    50   ~ 0
A4
Text Label 2450 6550 0    50   ~ 0
A5
Entry Wire Line
	5900 3300 6000 3400
Entry Wire Line
	5900 3100 6000 3200
Entry Wire Line
	5900 2900 6000 3000
Entry Wire Line
	5900 2700 6000 2800
Entry Wire Line
	5900 2500 6000 2600
Entry Wire Line
	5900 2300 6000 2400
Wire Wire Line
	6000 2400 6150 2400
Wire Wire Line
	6000 2600 6150 2600
Wire Wire Line
	6000 2800 6150 2800
Wire Wire Line
	6000 3000 6150 3000
Wire Wire Line
	6000 3200 6150 3200
Wire Wire Line
	6000 3400 6150 3400
Entry Wire Line
	5900 4450 6000 4550
Entry Wire Line
	5900 4550 6000 4650
Wire Wire Line
	6000 4550 6300 4550
Wire Wire Line
	6000 4650 6300 4650
Text Label 6050 4550 0    50   ~ 0
TX
Text Label 6050 4650 0    50   ~ 0
RX
Text Label 6050 2800 0    50   ~ 0
E1
Text Label 6050 3400 0    50   ~ 0
E2
Text Label 6050 2400 0    50   ~ 0
L1
Text Label 6050 2600 0    50   ~ 0
R1
Text Label 6050 3000 0    50   ~ 0
L2
Text Label 6050 3200 0    50   ~ 0
R2
Entry Wire Line
	5000 2250 5100 2350
Entry Wire Line
	5000 2350 5100 2450
Entry Wire Line
	5000 2450 5100 2550
Entry Wire Line
	5000 2550 5100 2650
Entry Wire Line
	5000 2650 5100 2750
Entry Wire Line
	5000 2750 5100 2850
Entry Wire Line
	5000 2850 5100 2950
Entry Wire Line
	5000 2950 5100 3050
Entry Wire Line
	5000 3950 5100 4050
Entry Wire Line
	5000 4050 5100 4150
Entry Wire Line
	5000 4150 5100 4250
Entry Wire Line
	5000 4250 5100 4350
Entry Wire Line
	5000 4350 5100 4450
Entry Wire Line
	5000 4450 5100 4550
Entry Wire Line
	5000 4550 5100 4650
Wire Wire Line
	4800 2250 5000 2250
Wire Wire Line
	4800 2350 5000 2350
Wire Wire Line
	4800 2450 5000 2450
Wire Wire Line
	4800 2550 5000 2550
Wire Wire Line
	4800 2650 5000 2650
Wire Wire Line
	4800 2750 5000 2750
Wire Wire Line
	4800 2850 5000 2850
Wire Wire Line
	4800 2950 5000 2950
Wire Wire Line
	4800 3950 5000 3950
Wire Wire Line
	4800 4050 5000 4050
Wire Wire Line
	4800 4150 5000 4150
Wire Wire Line
	4800 4250 5000 4250
Wire Wire Line
	4800 4350 5000 4350
Wire Wire Line
	4800 4450 5000 4450
Wire Wire Line
	4800 4550 5000 4550
Entry Wire Line
	5900 4250 6000 4350
Wire Wire Line
	7300 4350 7300 4400
Wire Wire Line
	6000 4350 7300 4350
Text Label 6050 4350 0    50   ~ 0
WUP
Text Label 4850 4150 0    50   ~ 0
WUP
Text Label 4850 3950 0    50   ~ 0
RX
Text Label 4850 4050 0    50   ~ 0
TX
Text Label 4850 2350 0    50   ~ 0
E1
Text Label 4850 2450 0    50   ~ 0
E2
Text Label 4850 2250 0    50   ~ 0
L1
Text Label 4850 2550 0    50   ~ 0
MOSI
Text Label 4850 2650 0    50   ~ 0
MISO
Text Label 4850 2750 0    50   ~ 0
SCK
$Comp
L Connector:Conn_01x06_Female J102
U 1 1 5E9F2D66
P 5900 5700
F 0 "J102" H 5928 5676 50  0000 L CNN
F 1 "Conn_01x06_Female" H 5928 5585 50  0000 L CNN
F 2 "" H 5900 5700 50  0001 C CNN
F 3 "~" H 5900 5700 50  0001 C CNN
	1    5900 5700
	1    0    0    -1  
$EndComp
Entry Wire Line
	5100 5500 5200 5600
Entry Wire Line
	5100 5600 5200 5700
Entry Wire Line
	5100 5700 5200 5800
Entry Wire Line
	5100 5800 5200 5900
Wire Wire Line
	5200 5600 5700 5600
Wire Wire Line
	5200 5700 5700 5700
Wire Wire Line
	5200 5800 5700 5800
Wire Wire Line
	5200 5900 5700 5900
$Comp
L power:GND #PWR?
U 1 1 5EA1044B
P 5600 6050
F 0 "#PWR?" H 5600 5800 50  0001 C CNN
F 1 "GND" H 5605 5877 50  0000 C CNN
F 2 "" H 5600 6050 50  0001 C CNN
F 3 "" H 5600 6050 50  0001 C CNN
	1    5600 6050
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR?
U 1 1 5EA10EE8
P 5600 5450
F 0 "#PWR?" H 5600 5300 50  0001 C CNN
F 1 "VDD" H 5617 5623 50  0000 C CNN
F 2 "" H 5600 5450 50  0001 C CNN
F 3 "" H 5600 5450 50  0001 C CNN
	1    5600 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 5500 5600 5500
Wire Wire Line
	5600 5500 5600 5450
Wire Wire Line
	5700 6000 5600 6000
Wire Wire Line
	5600 6000 5600 6050
Text Label 5250 5600 0    50   ~ 0
RESET
Text Label 5250 5700 0    50   ~ 0
SCK
Text Label 5250 5800 0    50   ~ 0
MISO
Text Label 5250 5900 0    50   ~ 0
MOSI
$Comp
L Device:LED_ABRG D?
U 1 1 5EA1E642
P 6050 1200
F 0 "D?" H 6050 1697 50  0000 C CNN
F 1 "LED_ABRG" H 6050 1606 50  0000 C CNN
F 2 "" H 6050 1200 50  0001 C CNN
F 3 "~" H 6050 1200 50  0001 C CNN
	1    6050 1200
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR?
U 1 1 5EA249DA
P 6400 1200
F 0 "#PWR?" H 6400 1050 50  0001 C CNN
F 1 "VDD" H 6417 1373 50  0000 C CNN
F 2 "" H 6400 1200 50  0001 C CNN
F 3 "" H 6400 1200 50  0001 C CNN
	1    6400 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 1200 6250 1200
$Comp
L Device:R R109
U 1 1 5EA2BAB6
P 5850 1700
F 0 "R109" H 5920 1746 50  0000 L CNN
F 1 "470" H 5920 1655 50  0000 L CNN
F 2 "" V 5780 1700 50  0001 C CNN
F 3 "~" H 5850 1700 50  0001 C CNN
	1    5850 1700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R108
U 1 1 5EA2C84B
P 5650 1500
F 0 "R108" H 5720 1546 50  0000 L CNN
F 1 "470" H 5720 1455 50  0000 L CNN
F 2 "" V 5580 1500 50  0001 C CNN
F 3 "~" H 5650 1500 50  0001 C CNN
	1    5650 1500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R107
U 1 1 5EA2D4DF
P 5500 1200
F 0 "R107" H 5570 1246 50  0000 L CNN
F 1 "470" H 5570 1155 50  0000 L CNN
F 2 "" V 5430 1200 50  0001 C CNN
F 3 "~" H 5500 1200 50  0001 C CNN
	1    5500 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 1550 5850 1400
Wire Wire Line
	5850 1200 5650 1200
Wire Wire Line
	5650 1200 5650 1350
Wire Wire Line
	5850 1000 5500 1000
Wire Wire Line
	5500 1000 5500 1050
Entry Wire Line
	5100 2200 5200 2300
Entry Wire Line
	5100 2350 5200 2450
Entry Wire Line
	5100 2500 5200 2600
Wire Wire Line
	5200 2300 5850 2300
Wire Wire Line
	5850 2300 5850 1850
Wire Wire Line
	5650 1650 5650 1900
Wire Wire Line
	5650 1900 5750 1900
Wire Wire Line
	5750 1900 5750 2450
Wire Wire Line
	5750 2450 5200 2450
Wire Wire Line
	5500 1350 5500 2000
Wire Wire Line
	5500 2000 5650 2000
Wire Wire Line
	5650 2000 5650 2600
Wire Wire Line
	5650 2600 5200 2600
Text Label 5250 2300 0    50   ~ 0
BLUE
Text Label 5250 2450 0    50   ~ 0
GREEN
Text Label 5250 2600 0    50   ~ 0
RED
Text Label 4850 4250 0    50   ~ 0
RED
Text Label 4850 4450 0    50   ~ 0
GREEN
Text Label 4850 4550 0    50   ~ 0
BLUE
Text Label 4850 2850 0    50   ~ 0
L2
Text Label 4850 2950 0    50   ~ 0
R1
Text Label 4850 4350 0    50   ~ 0
R2
$Comp
L Device:Battery BT101
U 1 1 5E78D938
P 1700 3100
F 0 "BT101" H 1808 3146 50  0000 L CNN
F 1 "3V" H 1808 3055 50  0000 L CNN
F 2 "" V 1700 3160 50  0001 C CNN
F 3 "~" V 1700 3160 50  0001 C CNN
	1    1700 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E78F166
P 1700 3500
F 0 "#PWR?" H 1700 3250 50  0001 C CNN
F 1 "GND" H 1705 3327 50  0000 C CNN
F 2 "" H 1700 3500 50  0001 C CNN
F 3 "" H 1700 3500 50  0001 C CNN
	1    1700 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1700 3300 1700 3500
$Comp
L power:VDD #PWR?
U 1 1 5E797467
P 1450 2100
F 0 "#PWR?" H 1450 1950 50  0001 C CNN
F 1 "VDD" H 1467 2273 50  0000 C CNN
F 2 "" H 1450 2100 50  0001 C CNN
F 3 "" H 1450 2100 50  0001 C CNN
	1    1450 2100
	1    0    0    -1  
$EndComp
$Comp
L power:Vdrive #PWR?
U 1 1 5E797EE3
P 1900 2100
F 0 "#PWR?" H 1700 1950 50  0001 C CNN
F 1 "Vdrive" H 1917 2273 50  0000 C CNN
F 2 "" H 1900 2100 50  0001 C CNN
F 3 "" H 1900 2100 50  0001 C CNN
	1    1900 2100
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_SPST SW103
U 1 1 5E7995B1
P 1700 2550
F 0 "SW103" V 1746 2462 50  0000 R CNN
F 1 "SW_SPST" V 1655 2462 50  0000 R CNN
F 2 "" H 1700 2550 50  0001 C CNN
F 3 "~" H 1700 2550 50  0001 C CNN
	1    1700 2550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	1700 2350 1700 2150
Wire Wire Line
	1700 2150 1450 2150
Wire Wire Line
	1450 2150 1450 2100
Wire Wire Line
	1700 2150 1900 2150
Wire Wire Line
	1900 2150 1900 2100
Connection ~ 1700 2150
Wire Wire Line
	1700 2750 1700 2900
$Comp
L Device:R R110
U 1 1 5E7BC377
P 7000 4000
F 0 "R110" V 6793 4000 50  0000 C CNN
F 1 "4.7k" V 6884 4000 50  0000 C CNN
F 2 "" V 6930 4000 50  0001 C CNN
F 3 "~" H 7000 4000 50  0001 C CNN
	1    7000 4000
	0    1    1    0   
$EndComp
Wire Wire Line
	7300 4000 7150 4000
Wire Wire Line
	6850 4000 6000 4000
NoConn ~ 4800 4650
Wire Bus Line
	600  4950 600  7550
Wire Bus Line
	2650 5000 2650 7550
Wire Bus Line
	5100 4800 5100 7550
Wire Bus Line
	5900 2200 5900 4800
Wire Bus Line
	5100 2150 5100 4800
$EndSCHEMATC
