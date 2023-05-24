# sync
repo init --depth=1 --no-repo-verify -u https://github.com/Project-Xtended/manifest.git -b xt -g default,-mips,-darwin,-notdefault
git clone https://github.com/Testing-Stuffs/Local_Manifest.git --depth 1 -b xtended .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build
export TZ=Asia/Kolkata
. build/envsetup.sh
lunch xtended_ginkgo-userdebug
mka xtended

# upload (useless anyway as of now)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
