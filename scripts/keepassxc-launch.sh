#!/bin/bash
keepassxc &
sleep 0.3
i3-msg "[class=\"(?i)keepassxc\"] focus"
