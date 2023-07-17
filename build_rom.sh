# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/Octavi-Staging/manifest.git -b thirteen -g default,-mips,-darwin,-notdefault
git clone https://github.com/GhostMaster69-dev/local_manifest.git --depth 1 -b 13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
#export TARGET_WITH_MINI_GAPPS=false
export PLATFORM_VERSION="13"
export BUILD_ID="TQ3A.230705.001"
export KBUILD_BUILD_VERSION="1"
export KBUILD_BUILD_USER="Unitrix-Kernel"
export KBUILD_BUILD_HOST="Cosmic-Horizon"
export KBUILD_BUILD_TIMESTAMP="$(TZ='Asia/Kolkata' date)"
lunch octavi_vince-user
mka bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
