hhvmversion=3.7.3

useradd ulyaoth
cd /home/ulyaoth

if grep -q -i "release 7" /etc/redhat-release
then
yum install -y  http://mirror.nsc.liu.se/fedora-epel/7/x86_64/e/epel-release-7-5.noarch.rpm
fi

su ulyaoth -c "rpmdev-setuptree"
su ulyaoth -c "git clone -b HHVM-3.7 git://github.com/facebook/hhvm.git"
mv /home/ulyaoth/hhvm /home/ulyaoth/hhvm-$hhvmversion
cd /home/ulyaoth/hhvm-$hhvmversion
su ulyaoth -c "git checkout HHVM-'"$hhvmversion"'"
su ulyaoth -c "git submodule update --init --recursive"
cd /home/ulyaoth
su ulyaoth -c "tar cvf hhvm-'"$hhvmversion"'.tar.gz hhvm-'"$hhvmversion"'/"
mv /home/ulyaoth/hhvm-$hhvmversion.tar.gz /home/ulyaoth/rpmbuild/SOURCES/
rm -rf /home/ulyaoth/hhvm-$hhvmversion
cd /home/ulyaoth/rpmbuild/SPECS/
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-hhvm/SPECS/ulyaoth-hhvm.spec"

if grep -q -i "release 22" /etc/fedora-release
then
dnf builddep -y /home/ulyaoth/rpmbuild/SPECS/ulyaoth-hhvm.spec
else
yum-builddep -y /home/ulyaoth/rpmbuild/SPECS/ulyaoth-hhvm.spec
fi

su ulyaoth -c "spectool ulyaoth-hhvm.spec -g -R"
su ulyaoth -c "QA_SKIP_BUILD_ROOT=1 rpmbuild -bb ulyaoth-hhvm.spec"
cp /home/ulyaoth/rpmbuild/RPMS/x86_64/* /root/