MKBOOTIMG_BIN := mkbootimg

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
	@echo ----- Creating ramdisk ------
	#rm -f out/target/product/hlltexx/recovery/root/init
	#cp device/samsung/hlltexx/recovery/init out/target/product/hlltexx/recovery/root/init
	#chmod 644 out/target/product/hlltexx/recovery/root/init.rc
	#chmod 644 out/target/product/hlltexx/recovery/root/init.recovery.universal5420.rc
	#chmod 644 out/target/product/hlltexx/recovery/root/default.prop
	(cd $(OUT)/target/product/hlltexx/recovery/root/ && find * | sort | cpio -o -H newc) | gzip > $(recovery_ramdisk)
	@echo ----- Making recovery image ------
	$(MKBOOTIMG_BIN) --kernel $(TARGET_PREBUILT_KERNEL) --ramdisk $(recovery_ramdisk) --base $(BOARD_KERNEL_BASE) --pagesize $(BOARD_KERNEL_PAGESIZE) $(BOARD_MKBOOTIMG_ARGS) --output $@
	@echo ----- Made recovery image -------- $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)


$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) --output $@
	#$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
