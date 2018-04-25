# UML

## PENTING UNTUK DIBACA
1. Ikuti langkah-langkah membuat UML seperti di [Modul Pengenalan UML](https://github.com/udinIMM/Modul-Pengenalan-UML) dengan topologi dan konfigurasi di bawah
2. Jangan lupa jalankan **iptables -t nat...** di router **GEBANG** agar client dan server bisa terhubung ke internet
3. Pastikan sudah **export proxy** dengan akun VPN (bisa didapatkan di https://id.its.ac.id/otp/) di semua UML
4. Pastikan sudah **apt-get update** sebelum menginstall
5. Install **isc-dhcp-server** di router **GEBANG**
6. Install **squid3** dan **apache2** di server **PUCANG**

## Membuat Topologi Jaringan

Topologi jaringan yang akan digunakan pada modul 3 adalah

![Topologi](https://github.com/mocatfrio/Jarkom-Modul-3/blob/master/UML/images/topologi.png)

1. Hapus terlebih dahulu file UML yang tidak diperlukan lagi bekas praktikum kemarin
    ```bash
    rm ALPHET MENYENG TJANGKIR CENGENGESAN WAYAHE switch1 switch2
    ```
2. Ubah file ```topologi.sh``` sesuai dengan gambar topologi di atas 

    ```bash
    #Switch
    uml_switch -unix switch1 > /dev/null < /dev/null &
    uml_switch -unix switch2 > /dev/null < /dev/null &

    #Router dan DHCP Server
    xterm -T GEBANG -e linux ubd0=GEBANG,jarkom umid=GEBANG eth0=tuntap,,,'ip_tuntap_tiap_kelompok' eth1=daemon,,,switch1 eth2=daemon,,,switch2 mem=256M &

    #Proxy server
    xterm -T PUCANG -e linux ubd0=PUCANG,jarkom umid=PUCANG eth0=daemon,,,switch1 mem=128M &

    #DNS server
    xterm -T KLAMPIS -e linux ubd0=KLAMPIS,jarkom umid=KLAMPIS eth0=daemon,,,switch1 mem=128M &

    #Client
    xterm -T NGAGEL -e linux ubd0=NGAGEL,jarkom umid=NGAGEL eth0=daemon,,,switch2 mem=96M &
    xterm -T NGINDEN -e linux ubd0=NGINDEN,jarkom umid=NGINDEN eth0=daemon,,,switch2 mem=96M &
    xterm -T DARMO -e linux ubd0=DARMO,jarkom umid=DARMO eth0=daemon,,,switch2 mem=96M &
    ```
**Keterangan** : 
* Jangan lupa mengubah **ip_tuntap_tiap_kelompok** sesuai kelompok masing-masing
* Memori router **GEBANG** ditambah karena akan menjadi DHCP Server
* Memori server **KLAMPIS** dan **PUCANG** ditambah karena akan menjadi DNS Server, Web server, dan Proxy server

## Konfigurasi Interface
Konfigurasi interface lengkap-nya sama seperti [Modul Pengenalan UML](https://github.com/udinIMM/Modul-Pengenalan-UML), dengan tambahan:

1. **DARMO (Sebagai Client)**

    ```bash
    auto eth0
    iface eth0 inet static
    address 192.168.0.4
    netmask 255.255.255.0
    gateway 192.168.0.1
    ```


## Selamat Mengerjakan :)
