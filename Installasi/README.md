# Instalasi Server Menggunakan UML - Jaringan Komputer 2018

## Spesifikasi Server
1. OS Debian 7
1. Hardisk Minimal 500 GB dan RAM 8 GB
1. Partisi 
    - Swap Area = 2 x RAM GB
    - / (Root) = Hardisk-Swap

```
NB : Gunakan Super User (SUDO) ketika instalasi
```

## Langkah-Langkah Installasi
- ###  Step 1 - Installasi OS Debian
- ### Step 2 - Setting Network
1. Setting IP DHCP(Optional jika tidak bisa terkoneksi dengan internet)
1. Setting IP Static dan DNS Nameserver
1. Matikan Firewall(opsional jika belum bisa terhubung internet)
```
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
```

- ### Step 3 - Installasi Require Package untuk Debian 7
```
sudo apt install openssh-server
sudo apt install xterm
sudo apt install xserver-xorg
sudo apt install x-window-system
sudo apt install x-window-system-core
```
**Jika Menggunakan Debian 8/9**
```
sudo apt install sysvinit-core
```
- ### Step 4 - Instalasi UML
1. Install UML Package dan Edit FSTAB
```
sudo apt install user-mode-linux
sudo apt install uml-utilities
sudo apt install debootstrap
```

```
sudo nano /etc/fstab
```

```
Tambahkan baris berikut :

none /dev/shm tmpfs size=10G 0 0
```
Kemudian restart atau cukup ketikkan *`mount -a`*

2. Membuat root_fs(hardisk virtual)
```
sudo dd if=/dev/zero of=root_fs bs=1 count=1 seek=1G
```
```
Keterangan :
1. of = root_fs adalah nama hardisk virtual, biasanya diganti dengan jarkom
2. seek = 1G adalah ukuran ram yang dialokasikan, biasanya 1GB
```
3. Membuat partisi (gunakan ext3, ext2 atau reserfs)
```
sudo mkfs.ext3 [root_fs]

```
```
Keterangan :
[root_fs] = nama hardisk virtual yang dibuat sebelumnya
```
4. Mount ke suatu direktory (biasanya mnt)
```
sudo mkdir mnt
sudo mount -o loop [root_fs] mnt/
```
```
Keterangan :
[root_fs] = nama hardisk virtual yang dibuat sebelumnya
```
5. Install base system
```topolo
sudo debootstrap --arch amd64 (wheezy) mnt/ http://kambing.ui.ac.id/debian
```

```
Keterangan :
1. mnt/ = direktori yang akan diinstall base system
2. http://kambing.ui.ac.id/debian = link repository

- Jika menggunakan debian 8/9 tambahkan atau ganti :
1. --include sysvinit-core = paket yang dibutuhkan untuk installasi UML di Debian 8 atau 9
2. --arch amd64 (jessie/stretch) = arsitektur 64bit dan gunakan jessie jika debian 8 dan stretch jika debian 9
```
6. Edit FSTAB pada image
```
sudo nano mnt/etc/fstab
```
```
Tambahkan baris berikut :

/dev/ubd0 / ext3 defaults 0 0
none /mnt hostfs defaults 0 0
```
7. Edit Hostname jika perlu (untuk memberi nama UML)
```
sudo nano mnt/etc/hostname
```
8. Edit file inittab
```
sudo nano mnt/etc/inittab
```
```
Ganti baris berikut :

1:2345:respawn:/sbin/getty 38400 tty1
2:23:respawn:/sbin/getty 38400 tty2
3:23:respawn:/sbin/getty 38400 tty3
4:23:respawn:/sbin/getty 38400 tty4
5:23:respawn:/sbin/getty 38400 tty5
6:23:respawn:/sbin/getty 38400 tty6

dengan :

c0:1235:respawn:/sbin/getty 38400 tty0 linux
```
9. Edit file securetty
```
sudo nano mnt/etc/securetty
```
```
Tambahkan baris berikut :

tty0
vc/0
```
10. Buat direktori modules pada mnt/lib/
```
sudo mkdir mnt/lib/modules
```
11. Copy direktori /usr/lib/uml/modules/[uml-kernel-version] dan isinya pada host ke direktori mnt/lib/modules
```
sudo cp -r /usr/lib/uml/modules/[uml-kernel-version] mnt/lib/modules
```
12. Ubah password root
```
sudo chroot mnt/
passwd
sudo apt-get install net-tools
exit
```
13. Umount image
```
sudo umount mnt/
```
14. Testing UML
```
sudo linux ubd0=jarkom umid=uml-net
```
Untuk mematikan cukup ketikkan *`halt`*

Atau bisa membuat [topologi.sh](https://github.com/cphikmawan/Dokumentasi-Server-Jaringan-Komputer/blob/master/Script/topologi.sh "topologi.sh") (pastikan tidak testing menggunakan user root)


- ### Setting Jaringan
1. Membuat user
```
sudo adduser [namauser]

misal A01
```
2. Tambahkan semua user ke grup uml-net
```
sudo adduser [namauser] uml-net
```
3. Ubah permission dari file /dev/net/tun
```
sudo chmod 666 /dev/net/tun
```

Installasi Selesai.

- ### Tambahan (Optional)
1. Cek terlebih dahulu jika ketika UML dijalankan cuma muncul warning maka symlink dari dash belum ke bash, solusinya diubah dulu symlink dari dash ke bash :
```
sudo dpkg-reconfigure dash
```
2. Jika tidak bisa SSH pada server :
- uncomment pada file */etc/ssh/ssh_config* :
```
ForwardX11Trusted yes
```
- mengizinkan ssh *root* edit pada konfigurasi file */etc/ssh/sshd_config* seperti berikut :
```
PermitRootLogin yes
```
- Block RSA Key ID pada file */etc/ssh/sshd_config* menjadi:
```
RSAAuthentication no
PubkeyAuthentication no
```

3. Allow user / non admin to access sudo
```
usermod -aG sudo [nama user]
```

4. Setting proxy agar bisa terkoneksi jaringan luar ITS
```
export http_proxy="http://user:pass@host:port"
export https_proxy="http://user:pass@host:port"
export ftp_proxy="http://user:pass@host:port"
```