patch -Np1 -i ../glibc-2.42-fhs-1.patch || true

sed -e '/unistd.h/i #include <string.h>' \
    -e '/libc_rwlock_init/c\
  __libc_rwlock_define_initialized (, reset_lock);\
  memcpy (&lock, &reset_lock, sizeof (lock));' \
    -i stdlib/abort.c

mkdir -v build
cd       build

echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                   \
             --disable-werror                \
             --disable-nscd                  \
             libc_cv_slibdir=/usr/lib        \
             --enable-stack-protector=strong \
             --enable-kernel=5.4

make

# Use $DESTDIR for staging operations (not DESTDIR)
mkdir -p $DESTDIR/etc
touch $DESTDIR/etc/ld.so.conf

sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make DESTDIR=$DESTDIR install

# Use $DESTDIR for ldd modification
if [ -f "$DESTDIR/usr/bin/ldd" ]; then
    sed '/RTLDLIST=/s@/usr@@g' -i $DESTDIR/usr/bin/ldd
fi

mkdir -pv $DESTDIR/usr/lib/locale

cp ../../tzdata2025b.tar.gz $DESTDIR/.install

