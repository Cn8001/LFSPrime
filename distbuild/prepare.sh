#!/bin/bash
export LFS=/lfs_3/distbuild/LFS #Your LFS path
export DIST=/lfs_3/distbuild

if ! test -d $LFS/sources; then
    mkdir -v $LFS/sources
    chmod -v a+wt $LFS/sources
fi

for i in $(cat $DIST/build_env_packages);
do
    if ! test -f $LFS/sources/$(basename $i); then
        wget -4 $i --continue -O $LFS/sources/$(basename $i)
        echo
    fi
done

sudo chown root:root $LFS/sources/* #In the final system might not be a user with this UID, therefore change things to root.

#Chapter 4#
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin,lib64}
for i in bin lib sbin; do
    ln -sv usr/$i $LFS/$i
done

mkdir -pv $LFS/tools
#Create a user before getting there#
sudo chown -v lfsbook $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools,lib64}

if ! test $(id -u lfsbook); then
homeDir=$(echo "~lfsbook")

cat > $homeDir/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > $homeDir/.bashrc << "EOF"
set +h
umask 022
LFS=$LFS
export DIST=$DIST
EOF

cat >> $homeDir/.bashrc << "EOF"
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS="-j$(nproc)"
EOF

fi