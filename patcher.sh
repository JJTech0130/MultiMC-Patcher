#!/bin/bash
mmcroot="$HOME/MultiMC"
debug="0"

if [ $debug == "1" ]; then
	#set -x
	echo "[DEBUG] DEBUG is enabled!"
fi

if which java 2> /dev/null > /dev/null; then
	javaarch=$(java -version 2>&1 | grep -io "..-Bit" | cut -d- -f1)
fi

archsuffix=

case $(uname -m) in
	x86_64)
		if [[ $javaarch == 32 ]]; then
			echo "[ERROR] 32-bit x86 is not supported."
			exit 1
		fi
		;;
	aarch64)
		if [[ $javaarch == 64 ]]; then
			archsuffix=-arm64
		else
			archsuffix=-arm32
		fi
		;;
	armhf)
		archsuffix=-arm32
		;;
	*)
		echo "[ERROR] This architecture is not supported."
		exit 1
		;;
esac
if [ $debug == "1" ]; then
	echo "[DEBUG] System architecture: $(uname -m)"
	echo "[DEBUG] JVM architecture: $javaarch-bit"
fi
if [[ "$#" -ne 1 ]]; then
	echo "[ERROR] Incorrect Usage!"
	echo "[INFO] Usage: $0 <instance-name>"
	exit 1
fi

instancedir="${mmcroot}/instances/$1"
if [[ ! -d "$instancedir" ]]; then
	echo "[ERROR] Could not find instance $1! ($instancedir)"
	exit 1
fi

# FIXME this is fragile
mcline=$(awk '/net.minecraft/{ print NR; exit }' "$instancedir/mmc-pack.json")
mcver=$(tail -n +$mcline "$instancedir/mmc-pack.json" | \
	grep version | head -n 1 | cut -d\" -f4)

if [ $debug == "1" ]; then
echo "[DEBUG] Minecraft version $mcver"
fi

mkdir -p "$instancedir/patches"
cp "$mmcroot/meta/net.minecraft/$mcver.json" \
	"$instancedir/patches/net.minecraft.json"

lwjglver="$(grep suggests < "$instancedir/patches/net.minecraft.json" | cut -d\" -f4)"
lwjglvernum="$(echo "$lwjglver" | sed "s/\.//g" | cut -d\- -f1)"

if [[ $lwjglvernum -le 300 ]]; then
	if [ $debug == 1 ]; then
		echo "[DEBUG] Using patch for LWJGL2"
	fi
	cp  $mmcroot/patches/org.lwjgl.json $instancedir/patches/
else
if [[ $(echo "$lwjglver" | sed "s/\.//g" | cut -d\- -f1) -le 322 ]]; then
	json="${instancedir}"/patches/net.minecraft.json
	cat "$json" | sed "s/$(echo "$lwjglver" | sed "s/\./\\\./g")/3.2.3/" > "$json"
	lwjglver=3.2.3
	#echo "Note: Using a newer LWJGL version than the game" \
	#"originally came with."
fi

#echo "LWJGL version: $lwjglver"
mavenbase="https://repo1.maven.org/maven2"
lwjgllibs=(lwjgl lwjgl-jemalloc lwjgl-openal lwjgl-opengl lwjgl-glfw lwjgl-stb)

jarurl() {
	echo "$mavenbase/org/lwjgl/$1/$lwjglver/$1-$lwjglver.jar"
}

nativeurl() {
	echo "$mavenbase/org/lwjgl/$1/$lwjglver/$1-$lwjglver-natives-linux$archsuffix.jar"
}

filesize() {
	curl -sI "$1" | grep -a content-length | cut -d" " -f 2 2> /dev/null
}

jarsha1() {
	curl "$1".sha1 2> /dev/null
}

genjson() {
	cat <<JSON
{
	"conflicts": [ { "uid": "org.lwjgl" } ],
	"formatVersion": 1,
	"libraries": [
JSON
	for j in "${lwjgllibs[@]}"; do
		url=$(jarurl $j)
		cat <<JSON
		{
			"downloads": {
				"artifact": {
					"sha1": "$(jarsha1 $url)",
					"size": $(filesize $url),
					"url": "$url"
				}
			},
			"name": "org.lwjgl:$j:$lwjglver"
		},
JSON
	done
	for j in "${lwjgllibs[@]}"; do
		url=$(jarurl $j)
		native=$(nativeurl $j)
		cat <<JSON
		{
			"downloads": {
				"artifact": {
					"sha1": "$(jarsha1 $url)",
					"size": $(filesize $url),
					"url": "$url"
				},
				"classifiers": {
					"natives-linux": {
						"sha1": "$(jarsha1 $native)",
						"size": $(filesize $native),
						"url": "$native"
					}
				}
			},
			"name": "org.lwjgl:$j:$lwjglver",
			"natives": {
				"linux": "natives-linux"
			}
JSON
		if [[ $j != ${lwjgllibs[-1]} ]]; then
			echo "		},"
		else
			echo "		}"
		fi
	done
	cat <<JSON
	],
	"name": "LWJGL 3",
	"order": -1,
	"releaseTime": "$(date --iso-8601=m)",
	"type": "release",
	"uid": "org.lwjgl3",
	"version": "$lwjglver",
	"volatile": false
}
JSON
}

#echo "Writing JSON for the new LWJGL version..."
genjson > "${instancedir}"/patches/org.lwjgl3.json

#echo "Done!"
fi
