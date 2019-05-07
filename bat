#!/bin/bash

set -eu

get_power()
{
    local power_uW
    local voltage_uV
    local current_uA

    if [ -f "/sys/class/power_supply/BAT0/power_now" ]; then
        power_uW=$(cat /sys/class/power_supply/BAT0/power_now)
    else
        voltage_uV=$(cat /sys/class/power_supply/BAT0/voltage_now)
        current_uA=$(cat /sys/class/power_supply/BAT0/current_now)
        power_uW=$(echo "scale=2; $current_uA * $voltage_uV / 1000000.0" | bc)
    fi

    echo "scale=2; $power_uW / 1000000.0" | bc
}

get_energy()
{
    local energy_uWh
    local voltage_uV
    local charge_uAh

    if [ -f "/sys/class/power_supply/BAT0/energy_now" ]; then
        energy_uWh=$(cat /sys/class/power_supply/BAT0/energy_now)
    else
        voltage_uV=$(cat /sys/class/power_supply/BAT0/voltage_now)
        charge_uAh=$(cat /sys/class/power_supply/BAT0/charge_now)
        energy_uWh=$(echo "scale=2; $charge_uAh * $voltage_uV / 1000000.0" | bc)
    fi

    echo "scale=2; $energy_uWh / 1000000.0" | bc
}

status=$(cat /sys/class/power_supply/BAT0/status)
capacity=$(cat /sys/class/power_supply/BAT0/capacity)

case $status in
    Full)
        printf '%d%%\tFull\n' "${capacity}"
        ;;
    Discharging)
        power_now=$(get_power)
        minutes_left=$(echo "scale=1; $(get_energy) / $power_now * 60" | bc)
        printf '%d%%\t%0.fminutes\t%.2fW\n' "${capacity}" "${minutes_left}" "${power_now}"
        ;;
    Charging)
        printf '%d%%\tCharging\n' "${capacity}"
        ;;
    *)
        echo "Battery has unknown status: '$status'" >&2
        exit 1
        ;;
esac