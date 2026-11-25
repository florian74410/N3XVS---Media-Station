# Matériel ciblé et incertitudes

Tanix TX8 supposée Amlogic S912 ARMv8-A, 8× Cortex-A53, RAM ~2 Go et eMMC ~32 Go : **à confirmer sur l'appareil**. Version de bootloader/DTB, accélération vidéo et GPU Panfrost sont à inventorier avant packaging.

1. Test initial avec alimentation 5 V 2 A polarité et fiche contrôlées ; HDMI sur contrôleur iMac QHD.
2. Identifier carte mère, ROM Kodi/Android, eMMC, Wi-Fi, Ethernet, pilotes.
3. Sauvegarde et test sur microSD externe avant modification eMMC.
4. Benchmarks CPU/RAM, usage OpenGL ES/EGL, codecs H.264/H.265/VP9.
5. Choisir la session media selon les capacités X11/DRM/EGLFS effectivement présentes.

Ne pas écrire de script qui flashe la box automatiquement.
