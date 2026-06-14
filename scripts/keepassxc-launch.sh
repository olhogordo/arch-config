#!/bin/bash
keepassxc &
sleep 0.5
i3-msg "[class=\"(?i)keepassxc\"] focus"
