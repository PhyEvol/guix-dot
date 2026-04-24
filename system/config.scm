;; -*- mode: scheme; -*-
;; This is an operating system configuration template
;; for a "desktop" setup without full-blown desktop
;; environments.

(use-modules (gnu) (gnu system nss))
(use-service-modules desktop xorg networking)
(use-package-modules bootloaders wm fonts version-control vim librewolf xdisorg terminals admin
                     xorg)

(operating-system
  (host-name "guix-btw")
  (timezone "America/Santiago")
  (locale "es_CL.utf8")

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))

  ;; Assume the target root file system is labelled "my-root",
  ;; and the EFI System Partition has UUID 1234-ABCD.
  (file-systems (append
                 (list (file-system
                         (device "/dev/sda3")
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device "/dev/sda1")
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (users (cons (user-account
                (name "affe")
                (comment "Yo mismo")
                (group "users")
                (supplementary-groups '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))

  ;; Add a bunch of window managers; we can choose one at
  ;; the log-in screen with F1.
  (packages (append (list
                     ;; window manager
                     qtile rofi
		     ;; xorg cosas
		     xorg-server xinit xwallpaper xset
		     ;; editor de texto
		     vim
		     ;; navegador
		     librewolf
		     ;; fonts
		     font-jetbrains-mono
		     ;; utilidades
		     git setxkbmap fastfetch btop
                     ;; terminal emulator
                     alacritty)
                    %base-packages))

  ;; Use the "desktop" services, which include the X11
  ;; log-in service, networking with NetworkManager, and more.
  (services (append (list (service xorg-server-service-type)
			  (service slim-service-type)
			  (service dhcpcd-service-type)) %base-services)))

  ;; Allow resolution of '.local' host names with mDNS.
  ;; (name-service-switch %mdns-host-lookup-nss))
