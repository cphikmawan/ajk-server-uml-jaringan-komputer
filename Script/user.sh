#!/bin/bash
# CREATED BY PENYOK C1F, PLEASE SAVE THIS SCRIPT.
ROOT_UID=0
SUCCESS=0
E_USEREXISTS=70

# Jalankan dengan root.
if [ "$UID" -ne "$ROOT_UID" ]
then
	echo "Harus root untuk menjalankan script ini."
	exit $E_NOTROOT
fi  

#test, jika ada 2 argumen atau tidak.
if [ $# -eq 2 ]; then
	usernameawal=$1
	jumlah=$2
    pass="praktikum"
	group="uml-net"

    echo "Ketik terserah untuk keluar"
    echo "Ketik pilihan Anda:"
    options=("Generate" "Delete" "Lock" "Unlock")
    select opt in "${options[@]}"
    do
        case $opt in
            "Generate")
                for (( i = 1; i <= $jumlah; i++ )); do
                    username="$usernameawal$i"
                    echo $username

                    # Check jika user sudah ada atau tidak.
                    #grep -q "$username": /etc/passwd
                    #if [ $? -eq $SUCCESS ] 
                    #then    
                    #    echo "User $username sudah ada."
                    #    echo "coba nama user lain."
                    #    exit $E_USEREXISTS
                    #fi  

                    useradd -d /home/"$username" -m -s /bin/bash "$username"
                    echo "berhasil tambah user"
                    echo -e "$pass\n$pass\n" | passwd "$username"
                    echo "berhasil masukkan password"
                    adduser "$username" "$group"
                    echo "berhasil ditambahkan ke dalam group"
                    cp -v jarkom ../"$username"
                    chown -v "$username":"$username" ../"$username"/jarkom
                    cp -v .Xauthority ../"$username"
                    chown -v "$username":"$username" ../"$username"/.Xauthority
                    echo "--------------------"
                done;;

            "Delete")
                for (( i = 1; i <= $jumlah; i++ )); do
                    username="$usernameawal$i"
                    echo $username

                    # Check jika user sudah ada atau tidak.
                    grep -q "$username" /etc/passwd
                    if [ $? -eq $SUCCESS ] 
                    then    
                        echo "User $username ada."
                        pkill -u "$username"
                        echo "Proses atas nama $username telah diberhentikan."
                        deluser "$username"
                        echo "User $username telah dihapus."
                        rm -rfv ../"$username"
                        echo "Direktori $username telah dihapus."
                        echo "--------------------"
                    fi  
                done;;

            "Lock")
                for (( i = 13; i <= $jumlah; i++ )); do
                    username="$usernameawal$i"
                    echo $username

                    # Check jika user sudah ada atau tidak.
                    grep -q "$username" /etc/passwd
                    if [ $? -eq $SUCCESS ] 
                    then
                        passwd -l "$username"
                        echo "User $username telah berhasil dikunci"
                        echo "--------------------"
                    fi  
                done;; 

            "Unlock")
                for (( i = 1; i <= $jumlah; i++ )); do
                    username="$usernameawal$i"
                    echo $username

                    # Check jika user sudah ada atau tidak.
                    grep -q "$username" /etc/passwd
                    if [ $? -eq $SUCCESS ] 
                    then
                        passwd -u "$username"
                        echo "User $username telah berhasil dibuka"
                        echo "--------------------"
                    fi  
                done;;

            *) break;;
        esac
    done
	
else
	echo  " program ini butuh 2 argumen $# "
	echo  " $0 username dan jumlah kelompok "
fi

exit 0
