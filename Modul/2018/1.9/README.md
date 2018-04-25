# Modul-Pengenalan-UML
## Apakah UML itu?
UML (User Mode Linux) adalah sebuah virtual sistem dari linux yang memungkinkan kita untuk membuat simulasi jaringan virtual yang biasa terdiri dari host, router, switch.

## Instalasi UML
### 1. Untuk Windows 
  - **Download Putty**<br>
    Silahkan ambil di drive http://bit.ly/JARKOM2018 . Atau download dari webnya -> http://www.putty.org/
  - **Download Xming**<br>
    Silahkan ambil di drive http://bit.ly/JARKOM2018 . Atau download dari link berikut -> https://sourceforge.net/projects/xming/
  - Jalankan Xming, kemudian jalankan putty yang sudah kalian install
    ![PuTTY](images/001.PNG)
  - Isikan **Host Name** dengan IP sesuai pembagian masing-masing kelas :<br>
    **Kelas A = kelompok A1 s.d. A12 (10.151.36.203) & kelompok A13 s.d. A15 (10.151.36.201)<br>
    Kelas B = kelompok B1 s.d. B17 (10.151.36.202)<br>
    Kelas C = kelompok C1 s.d. C17 (10.151.36.204)<br>
    Kelas D = kelompok D1 s.d. D19 (10.151.36.201)<br>
    Kelas E = kelompok E1 s.d. E12 (10.151.36.205) & kelompok E13 s.d. E17 (10.151.36.201)**
    ![PuTTY IP](images/002.PNG)
  - Kemudian pilih tab **SSH** dibagian **Category** dan pilih **X11**, lalu centang **Enable X11 forwarding**
    ![PuTTY X11](images/003.PNG)
  - Kemudian pilih Open dan akan muncul tampilan seperti ini
    ![PuTTY login](images/004.PNG)
  - Login dengan username **[nama kelompok]** dan password **praktikum**.<br>
    Contoh: **Username -> d1.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Password -> praktikum**<br>
    Jika berhasil akan muncul seperti gambar dibawah ini
    ![PuTTY d1](images/005.PNG)
### 2. Untuk Linux
  - Buka terminal, ketikkan **ssh -X [nama_kelompok]@[ip_sesuai_kelas]<br>
    Contoh: ssh -X d1@10.151.36.201**
  - Kemudian masukkan password kelompok kalian<br>
    **Contoh: Password -> praktikum**
  - Pastikan allow connection dengan mengetikkan Yes
  - Login dengan **[nama_kelompok]** dan password **praktikum<br>
    Contoh: Username -> d1<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Password -> praktikum**
## Membuat Topologi Jaringan yang Akan Digunakan
![Topologi CPT](images/006a.PNG)
1.	Setelah login, buat file script dengan ekstensi **.sh** yang akan digunakan untuk menyimpan script membuat **router, switch, dan client**. Misalkan kita buat **topologi.sh**.<br>
2.	Ketikkan **nano topologi.sh**.<br>
3.	Sintaks yang digunakan adalah sebagai berikut:<br>
  **a.	Membuat switch:**<br>
    `uml_switch –unix `**namaswitch**` > /dev/null < /dev/null &`<br>
  **b.	Membuat router dan client:**<br>
    `xterm –T `**namadevice**` –e linux ubd0=`**namadevice**`,jarkom umid=`**namadevice**` eth0=daemon,,,`**namaswitch**` mem=96M &`<br>
    <br>
    **Keterangan**:
      -	Sintaks untuk membuat router dan klien hampir sama, yang membedakan adalah jumlah eth nya, eth pada router biasanya lebih dari 1.
      - **Jarkom** adalah iso UML yang digunakan.
      - Pembuatan jumlah router, switch, client dan banyaknya eth disesuaikan dengan topologi yang diminta.<br>
4.	Untuk topologi sesuai gambar, maka sintaks untuk file **topologi.sh** adalah<br>
  ![Topologi.sh](images/007.PNG)<br>
  ```shell
  #switch
  uml_switch -unix switch1 > /dev/null < /dev/null &
  uml_switch -unix switch2 > /dev/null < /dev/null &

  #router
  xterm -T GEBANG -e linux ubd0=GEBANG,jarkom umid=GEBANG eth0=tuntap,,,'ip_tuntap_tiap_kelompok' eth1=daemon,,,switch1 eth2=daemon,,,switch2 mem=96M &
  #dns + web server
  xterm -T KLAMPIS -e linux ubd0=KLAMPIS,jarkom umid=KLAMPIS eth0=daemon,,,switch1 mem=96M &
  xterm -T PUCANG -e linux ubd0=PUCANG,jarkom umid=PUCANG eth0=daemon,,,switch1 mem=96M &
  #client
  xterm -T NGAGEL -e linux ubd0=NGAGEL,jarkom umid=NGAGEL eth0=daemon,,,switch2 mem=96M &
  xterm -T NGINDEN -e linux ubd0=NGINDEN,jarkom umid=NGINDEN eth0=daemon,,,switch2 mem=96M &
  ```
  **Keterangan:** Jangan lupa mengubah ***'ip_tuntap_tiap_kelompok'*** terlebih dahulu dan sesuai kelompok masing-masing.<br>
5. Kemudian jalankan script tersebut dengan perintah **bash topologi.sh**.<br>
  ![GEBANG login](images/008.PNG)<br>
6.	Setelah muncul seperti gambar diatas, login di masing-masing router dan client menggunakan **username = root dan password = praktikum**.<br>
  ![GEBANG root](images/009.PNG)<br>
7.	Di router **GEBANG** lakukan setting sysctl dengan mengetik perintah **nano /etc/sysctl.conf**.<br>
8.	Hilangkan tanda pagar (#) pada bagian **net.ipv4.ip_forward=1**.<br>
  ![GEBANG sysctl](images/010a.PNG)<br>
  Lalu ketikkan **sysctl –p** untuk mengaktifkan perubahan yang ada.<br>
  **Keterangan:**<br>
   - Dengan mengaktifkan fungsi “IP Forward” ini maka Linux nantinya dapat menentukan jalur mana yang dipilih untuk mencapai network tujuan.<br>
9.	Setting IP di setiap router dan client dengan mengetikkan **nano /etc/network/interfaces**. Lalu seting IPnya sebagai berikut:<br>
  **Setting IP pada GEBANG (Sebagai Router)**.
  ```shell
  auto eth0
  iface eth0 inet static
  address 'ip_eth0_GEBANG_tiap_kelompok'
  netmask 255.255.255.252
  gateway 'ip_tuntap_tiap_kelompok'

  auto eth1
  iface eth1 inet static
  address 'ip_eth1_GEBANG_tiap_kelompok'
  netmask 255.255.255.248

  auto eth2
  iface eth2 inet static
  address 192.168.0.1
  netmask 255.255.255.0
  ```
  **Setting IP pada NGAGEL (Sebagai client)**.
  ```shell
  auto eth0
  iface eth0 inet static
  address 192.168.0.2
  netmask 255.255.255.0
  gateway 192.168.0.1
  ```
  **Setting IP pada NGINDEN (Sebagai client)**.
  ```shell
  auto eth0
  iface eth0 inet static
  address 192.168.0.3
  netmask 255.255.255.0
  gateway 192.168.0.1
  ```
  **Setting IP pada KLAMPIS (Sebagai DNS Server)**.
  ```shell
  auto eth0
  iface eth0 inet static
  address 'ip_KLAMPIS_tiap_kelompok'
  netmask 255.255.255.248
  gateway 'ip_eth1_GEBANG_tiap_kelompok'
  ```
  **Setting IP pada PUCANG (Sebagai Web Server)**.
  ```shell
  auto eth0
  iface eth0 inet static
  address 'ip_PUCANG_tiap_kelompok'
  netmask 255.255.255.248
  gateway 'ip_eth1_GEBANG_tiap_kelompok'
  ```
  **Keterangan**:<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **Ip_eth0_GEBANG_tiap_kelompok** = NID_tuntap_tiap_kelompok + 2<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **Ip_tuntap_tiap_kelompo**k = NID_tuntap_tiap_kelompok + 1<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **Ip_eth1_GEBANG_tiap_kelompok** = NID_DMZ_tiap_kelompok + 1<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **Ip_KLAMPIS_tiap_kelompok** = NID_DMZ_tiap_kelompok + 2<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **Ip_PUCANG_tiap_kelompok** = NID_DMZ_tiap_kelompok + 3<br>
  **Penjelasan pengertian**:<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **IP Tuntap**: TUN yang merupakan kependekan dari Tunneling mensimulasikan layer 3, sedangkan TAP yang berarti Network Tap mensimulasikan layer 2. TUN berfungsi untuk routing, sedangkan TAP berfungsi sebagai network bridge.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **Netmask**: Netmask adalah mask 32-bit yang digunakan untuk membagi alamat IP menjadi subnet dan menentukan host yang tersedia pada jaringan.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **Gateway**: suatu jalur pada jaringan yang harus dilewati paket-paket data untuk dapat masuk ke jaringan yang lain.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **DMZ**: DMZ adalah kependekan dari Demilitarized Zone, suatu area yang digunakan berinteraksi dengan pihak luar. Di dalam jaringan komputer, DMZ merupakan suatu sub network yang terpisah dari sub network internal untuk keperluan keamanan.<br><br>
10.	Restart network pada setiap router dan host dengan mengetikkan **service networking restart** atau **/etc/init.d/networking restart**.<br>
11.	Coba cek IP pada setiap router dan host dengan mengetikkan **ifconfig**. Jika sudah mendapatkan IP seperti gambar dibawah, setting IP yang kalian lakukan benar.<br>
  ![ifconfig](images/011a.PNG)<br>
12.	Topologi yang kaliancmd buat sudah bisa berjalan secara lokal, tetapi kalian belum bisa mengakses jaringan keluar. Ketikkan **```iptables –t nat –A POSTROUTING –o eth0 –j MASQUERADE –s 192.168.0.0/24```** pada router **GEBANG**.<br>
  ![iptables postrouting](images/012b.PNG)<br>
  **Keterangan**: <br>
    - **Iptables**: Iptables merupakan suatu tools dalam sistem operasi linux yang berfungsi sebagai filter terhadap lalu lintas data. Dengan iptables inilah kita akan mengatur semua lalulintas dalam komputer, baik yang masuk, keluar, maupun yang sekedar melewati komputer kita. Untuk penjelasan lebih lanjut nanti akan kita bahas di modul 5.<br>
    - **NAT (Network Address Translation)**: suatu metode penafsiran alamat jaringan yang digunakan untuk menghubungkan lebih dari satu komputer ke jaringan internet dengan menggunakan satu alamat IP.<br>
    - **Masquerade**: Digunakan untuk menyamarkan paket, misal mengganti alamat pengirim dengan alamat router.<br>
    - **s (Source Address)**: Spesifikasi pada *source*. *Address* bisa berupa nama jaringan, nama host, alamat IP.<br>
      **Sintaks pada IPTables: `iptables [-t table] command [match] [target/jump] [source address]`**<br>
      **Contoh: iptables –t nat –A POSTROUTING –o eth0 –j MASQUERADE –s 192.168.0.0/16**<br><br>
13.	Coba test di semua router dan client dengan melakukan **ping its.ac.id** atau **ping 10.151.36.1** dari masing-masing host untuk mengecek apakah pengaturan anda benar atau tidak.<br>
  ![iptables](images/013.PNG)<br>
14.	Export proxy di uml kalian terlebih dahulu dengan syntax seperti dibawah ini:<br>
```
  export http_proxy="http://user:pass@host:port"
  export https_proxy="http://user:pass@host:port"
  export ftp_proxy="http://user:pass@host:port"
```
15.	Setelah itu, lakukan update pada semua router dan host dengan mengetikkan **apt-get update**.<br>
16.	Terakhir, untuk mematikan router dan client jangan langsung di close. Ketikkan **halt** di semua router dan client untuk mematikkannya. Atau buat script dengan ekstensi .sh supaya mempermudah kalian dalam mematikannya. Misal buat script dengan nama **bye.sh**, dan tuliskan sintaks seperti dibawah ini: Save script yang ada buat dan jalankan dengan mengetikkan **bash bye.sh**.<br>
  ![bye.sh](images/014.PNG)<br>
  
# **PEMBAGIAN NID TUNTAP DAN NID DMZ**
### KELAS A
  KELOMPOK | NID TUNTAP | NID DMZ
  ---------|------------|--------
  A1 | 10.151.76.8/30 | 10.151.77.16/29
  A2 | 10.151.76.12/30 | 10.151.77.24/29
  A3 | 10.151.76.16/30 | 10.151.77.32/29
  A4 | 10.151.76.20/30 | 10.151.77.40/29
  A5 | 10.151.76.24/30 | 10.151.77.48/29
  A6 | 10.151.76.28/30 | 10.151.77.56/29
  A7 | 10.151.76.32/30 | 10.151.77.64/29
  A8 | 10.151.76.36/30 | 10.151.77.72/29
  A9 | 10.151.76.40/30 | 10.151.77.80/29
  A10 | 10.151.76.44/30 | 10.151.77.88/29
  A11 | 10.151.76.48/30 | 10.151.77.96/29
  A12 | 10.151.76.52/30 | 10.151.77.104/29
  A13 | 10.151.72.84/30 | 10.151.73.168/29
  A14 | 10.151.72.88/30 | 10.151.73.176/29
  A15 | 10.151.72.92/30 | 10.151.73.184/29
### KELAS B
  KELOMPOK | NID TUNTAP | NID DMZ
  ---------|------------|--------
  B1 | 10.151.74.8/30 | 10.151.83.16/29
  B2 | 10.151.74.12/30 | 10.151.83.24/29
  B3 | 10.151.74.16/30 | 10.151.83.32/29
  B4 | 10.151.74.20/30 | 10.151.83.40/29
  B5 | 10.151.74.24/30 | 10.151.83.48/29
  B6 | 10.151.74.28/30 | 10.151.83.56/29
  B7 | 10.151.74.32/30 | 10.151.83.64/29
  B8 | 10.151.74.36/30 | 10.151.83.72/29
  B9 | 10.151.74.40/30 | 10.151.83.80/29
  B10 | 10.151.74.44/30 | 10.151.83.88/29
  B11 | 10.151.74.48/30 | 10.151.83.96/29
  B12 | 10.151.74.52/30 | 10.151.83.104/29
  B13 | 10.151.74.56/30 | 10.151.83.112/29
  B14 | 10.151.74.60/30 | 10.151.83.120/29
  B15 | 10.151.74.64/30 | 10.151.83.128/29
  B16 | 10.151.74.68/30 | 10.151.83.136/29
  B17 | 10.151.74.72/30 | 10.151.83.144/29
### KELAS C
  KELOMPOK | NID TUNTAP | NID DMZ
  ---------|------------|--------
  C1 | 10.151.78.8/30 | 10.151.79.16/29
  C2 | 10.151.78.12/30 | 10.151.79.24/29
  C3 | 10.151.78.16/30 | 10.151.79.32/29
  C4 | 10.151.78.20/30 | 10.151.79.40/29
  C5 | 10.151.78.24/30 | 10.151.79.48/29
  C6 | 10.151.78.28/30 | 10.151.79.56/29
  C7 | 10.151.78.32/30 | 10.151.79.64/29
  C8 | 10.151.78.36/30 | 10.151.79.72/29
  C9 | 10.151.78.40/30 | 10.151.79.80/29
  C10 | 10.151.78.44/30 | 10.151.79.88/29
  C11 | 10.151.78.48/30 | 10.151.79.96/29
  C12 | 10.151.78.52/30 | 10.151.79.104/29
  C13 | 10.151.78.56/30 | 10.151.79.112/29
  C14 | 10.151.78.60/30 | 10.151.79.120/29
  C15 | 10.151.78.64/30 | 10.151.79.128/29
  C16 | 10.151.78.68/30 | 10.151.79.136/29
  C17 | 10.151.78.72/30 | 10.151.79.144/29
### KELAS D
  KELOMPOK | NID TUNTAP | NID DMZ
  ---------|------------|--------
  D1 | 10.151.72.8/30 | 10.151.73.16/29
  D2 | 10.151.72.12/30 | 10.151.73.24/29
  D3 | 10.151.72.16/30 | 10.151.73.32/29
  D4 | 10.151.72.20/30 | 10.151.73.40/29
  D5 | 10.151.72.24/30 | 10.151.73.48/29
  D6 | 10.151.72.28/30 | 10.151.73.56/29
  D7 | 10.151.72.32/30 | 10.151.73.64/29
  D8 | 10.151.72.36/30 | 10.151.73.72/29
  D9 | 10.151.72.40/30 | 10.151.73.80/29
  D10 | 10.151.72.44/30 | 10.151.73.88/29
  D11 | 10.151.72.48/30 | 10.151.73.96/29
  D12 | 10.151.72.52/30 | 10.151.73.104/29
  D13 | 10.151.72.56/30 | 10.151.73.112/29
  D14 | 10.151.72.60/30 | 10.151.73.120/29
  D15 | 10.151.72.64/30 | 10.151.73.128/29
  D16 | 10.151.72.68/30 | 10.151.73.136/29
  D17 | 10.151.72.72/30 | 10.151.73.144/29
  D18 | 10.151.72.76/30 | 10.151.73.152/29
  D19 | 10.151.72.80/30 | 10.151.73.160/29
### KELAS E
  KELOMPOK | NID TUNTAP | NID DMZ
  ---------|------------|--------
  E1 | 10.151.70.8/30 | 10.151.71.16/29
  E2 | 10.151.70.12/30 | 10.151.71.24/29
  E3 | 10.151.70.16/30 | 10.151.71.32/29
  E4 | 10.151.70.20/30 | 10.151.71.40/29
  E5 | 10.151.70.24/30 | 10.151.71.48/29
  E6 | 10.151.70.28/30 | 10.151.71.56/29
  E7 | 10.151.70.32/30 | 10.151.71.64/29
  E8 | 10.151.70.36/30 | 10.151.71.72/29
  E9 | 10.151.70.40/30 | 10.151.71.80/29
  E10 | 10.151.70.44/30 | 10.151.71.88/29
  E11 | 10.151.70.48/30 | 10.151.71.96/29
  E12 | 10.151.70.52/30 | 10.151.71.104/29
  E13 | 10.151.72.96/30 | 10.151.73.192/29
  E14 | 10.151.72.100/30 | 10.151.73.200/29
  E15 | 10.151.72.104/30 | 10.151.73.208/29
  E16 | 10.151.72.108/30 | 10.151.73.216/29
  E17 | 10.151.72.112/30 | 10.151.73.224/29
