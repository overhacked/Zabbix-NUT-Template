Zabbix-NUT-Template
===================

Zabbix Template for NUT(Network UPS Tools)

Supported UPS: http://www.networkupstools.org/stable-hcl.html


# Value mapping

Value mapping must be done before importing template. It can done in **Administration** / **General** / **Value mapping** (combobox on right side)

Then **Create value map**

	0    - unknown state
	1    - On line (mains is present)
	2    - On battery (mains is not present)
	4    - Low battery
	5    - On line, low battery (mains is present)
	6    - On LOW battery (mains is not present)
	8    - The battery needs to be replaced
	9    - The battery needs to be replaced
	16   - The battery is charging
	17   - On line, charging (mains is present)
	32   - The battery is discharging (inverter is providing load power)
	34   - On battery (mains is not present)
	64   - UPS bypass circuit is active: no battery protection is available
	128  - UPS is currently performing runtime calibration (on battery)
	130  - UPS is currently performing runtime calibration (on battery)
	256  - UPS is offline and is not supplying power to the load
	512  - UPS is overloaded
	513  - On line, UPS is overloaded
	1024 - UPS is trimming incoming voltage ("buck" in some hardware)
	1058 - UPS is trimming incoming voltage, on battery
	2048 - UPS is boosting incoming voltage
	2082 - UPS is boosting incoming voltage, on battery


![Value mapping](https://raw.githubusercontent.com/blondak/Zabbix-NUT-Template/master/Configuration%20of%20value%20mapping.png)
