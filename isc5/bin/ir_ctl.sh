#!/bin/sh
# GPIO reference at
# https://gist.github.com/davidjb/f0529d8d64ca5d873fe700577bc43dac


# GPIO MS1 Pin 2 (Output) - IR CUT Drive Control Output A
#     gpio_ms1 -n 2 -m 1 -v {0,1}
IR_CUT_P_PIN=2

# GPIO AUD Pin 0 (Output) - Infrared Lamp Control (eg IR LEDs)
#     gpio_aud write 1 0 {0,1}
LED_PIN=0

# GPIO AUD Pin 1 (Output) - IR CUT Drive Control Output B
#     gpio_aud write 1 1 {0,1}
IR_CUT_N_PIN=1

# GPIO AUD Pin 2 (Output) - Day / Night mode Detection Port
#     gpio_aud read 2
IR_CUT_DAYNIGHT_PIN=2

ir_init() {
	# From spi_gpio_init
	gpio_ms1    -m 1 -n $IR_CUT_P_PIN      -v 0  # Init IR cut drive control A
	gpio_aud write 1    $IR_CUT_N_PIN         0  # Init IR cut drive control B
	gpio_aud write 1    $IR_CUT_DAYNIGHT_PIN  1  # Init day/night detector high first
	usleep 30000
	gpio_aud write 0    $IR_CUT_DAYNIGHT_PIN  0
	gpio_aud write 1    $LED_PIN              0  # Disable LEDs initially
}

ir_on() {
	echo 0x0 > /proc/isp/filter/saturation
	gpio_ms1    -m 1 -n $IR_CUT_P_PIN -v 1
	gpio_aud write 1    $IR_CUT_N_PIN    0
	gpio_aud write 1    $LED_PIN         1
	usleep 120000
	gpio_ms1    -m 1 -n $IR_CUT_P_PIN -v 0
	gpio_aud write 1    $IR_CUT_N_PIN    0

	# Enable NRN (?) to improve image quality in dark
	echo 0x1 > /proc/isp/iq/nrn
}

ir_off() {
	echo 0x40 > /proc/isp/filter/saturation
	gpio_ms1    -m 1 -n $IR_CUT_P_PIN -v 1
	gpio_aud write 1    $IR_CUT_N_PIN    0
	gpio_aud write 1    $LED_PIN         0
	usleep 120000
	gpio_ms1    -m 1 -n $IR_CUT_P_PIN -v 0
	gpio_aud write 1    $IR_CUT_N_PIN    0

	# Disable NRN (?) to improve image quality in light
	echo 0x0 > /proc/isp/iq/nrn
}

ir_init
echo "IR script started"

# Loop to check the day/night status
IR_ON=0

while :; do
	DAY=$(gpio_aud read "$IR_CUT_DAYNIGHT_PIN")
	IR_ON=$(gpio_aud read "$LED_PIN")
	if [ "$DAY" -eq 1 ]; then
		if [ "$IR_ON" -eq 1 ]; then
			ir_off
		fi
	else
		if [ "$IR_ON" -eq 0 ]; then
			ir_on
		fi
	fi
	sleep 10
done
