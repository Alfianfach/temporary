# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/AOSPA/manifest -b topaz -g default,-mips,-darwin,-notdefault
git clone https://github.com/back-up-git/local_manifests.git --depth 1 -b topaz-test .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom [42]
source build/envsetup.sh
lunch aospa_raphael-userdebug
export KBUILD_BUILD_USER=azure
export KBUILD_BUILD_HOST=azure
export BUILD_USERNAME=azure
export BUILD_HOSTNAME=azure
export TZ=Asia/Kolkata # put before last build command
./rom-build.sh raphael -t userdebug

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
