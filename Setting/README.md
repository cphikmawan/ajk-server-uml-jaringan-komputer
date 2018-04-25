### Keterangan Tambahan Pada Server

#### Step 1 - Membuat user
##### 1. Jalankan [user.sh](https://github.com/cphikmawan/Dokumentasi-Server-Jaringan-Komputer/blob/master/Script/user.sh "user.sh") (jalankan sebagai root)
```
bash user.sh (nama_user) (jumlah_user)
```
Misal
```
bash user.sh a 12
```
##### 2. Dan masih banyak opsi lain, bisa dicoba sendiri

#### Step 2 - Script routing dan firewall dijalankan di crontab
##### 1. Edit crontab (pastikan sebagai root)
```
crontab -e
```
##### 2. Tambahkan baris paling bawah dengan baris berikut :

```
@reboot /bin/bash /home/jarkom201/newrouting.sh >> /home/jarkom201/route.log 2>&1
@reboot /bin/bash /home/jarkom201/iptables.sh >> /home/jarkom201/iptables.log 2>$1
```