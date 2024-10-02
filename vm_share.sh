sudo mkdir /mnt/c/workspace
sudo chown gojimmypi  /mnt/c/workspace

sudo mkdir /mnt/c/workspace/documentation-wolfssl-gojimmypi
sudo chown gojimmypi  /mnt/c/workspace/documentation-wolfssl-gojimmypi

/usr/bin/vmhgfs-fuse .host:/documentation-wolfssl /mnt/c/workspace/documentation-wolfssl-gojimmypi -o subtype=vmhgfs-fuse