#!/bin/bash
# Quick and dirty script for making MultiMC launch pre-1.13/lwjgl3 versions of minecraft on ARM64
if [ $# == 1 ]; then
	if cp ./org.lwjgl.json ../instances/$1/patches/
	then
		echo "Patched instance "$1" succesfully!"
	else
		echo "Failed to patch file. Is the instance name correct?"
	fi
else
	echo "Invalid Arguments"
fi
