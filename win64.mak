# Makefile to build D runtime library phobos64.lib for Win64
# Designed to work with \dm\bin\make.exe
# Targets:
#	make
#		Same as make unittest
#	make phobos.lib
#		Build phobos.lib
#	make clean
#		Delete unneeded files created by build process
#	make unittest
#		Build phobos.lib, build and run unit tests
#	make html
#		Build documentation
# Notes:
#	This relies on LIB.EXE 8.00 or later, and MAKE.EXE 5.01 or later.

MODEL=64
DIR=\dmd
PHOBOSGIT=walter@mercury:dpl/phobos1
VCDIR="\Program Files (x86)\Microsoft Visual Studio 10.0\VC"
SDKDIR="\Program Files (x86)\Microsoft SDKs\Windows\v7.0A"

CC=$(VCDIR)\bin\amd64\cl
LD=$(VCDIR)\bin\amd64\link
LIB=$(VCDIR)\bin\amd64\lib
CP=cp
SCP=\putty\pscp -i c:\.ssh\colossus.ppk

#CFLAGS=/O2 /I$(VCDIR)\INCLUDE /I$(SDKDIR)\Include
CFLAGS=/Zi /I$(VCDIR)\INCLUDE /I$(SDKDIR)\Include

DFLAGS=-m$(MODEL) -O -release -nofloat -w
#DFLAGS=-m$(MODEL) -nofloat -w
#DFLAGS=-m$(MODEL) -unittest -g -w
#DFLAGS=-m$(MODEL) -unittest -cov -g

DMD=$(DIR)\windows\bin\dmd
#DMD=..\dmd

DOC=..\..\html\d\phobos
#DOC=..\doc\phobos

PHOBOSLIB=phobos64.lib

.c.obj:
	$(CC) /c $(CFLAGS) $*.c

.cpp.obj:
	$(CC) /c $(CFLAGS) $*.cpp

.d.obj:
	$(DMD) -c $(DFLAGS) $*

.asm.obj:
	$(CC) -c $*

targets : $(PHOBOSLIB) gcstub$(MODEL).obj

test : test.exe

test.obj : test.d
	$(DMD) -c test -g -unittest

test.exe : test.obj $(PHOBOSLIB)
	$(DMD) test.obj -g -L/map

OBJS= deh2.obj complex.obj gcstats.obj \
	critical.obj object.obj monitor.obj \
	trace.obj \
	crc32.obj \
	Czlib.obj Dzlib.obj process.obj \
	oldsyserror.obj \
	errno.obj metastrings.obj

#	ti_bit.obj ti_Abit.obj

MAKEFILES= \
	win32.mak win64.mak linux.mak osx.mak freebsd.mak openbsd.mak solaris.mak

SRCS= std\math.d std\stdio.d std\dateparse.d std\date.d std\uni.d std\string.d \
	std\base64.d std\md5.d std\regexp.d \
	std\compiler.d std\cpuid.d std\format.d std\demangle.d \
	std\path.d std\outbuffer.d std\utf.d std\uri.d \
	std\ctype.d std\random.d std\array.d std\mmfile.d \
	std\asserterror.d std\system.d \
	std\bitarray.d \
	std\signals.d std\typetuple.d std\traits.d std\bind.d \
	std\switcherr.d \
	std\thread.d std\thread_helper.d \
	std\moduleinit.d std\boxer.d \
	std\stream.d std\socket.d std\socketstream.d \
	std\perf.d std\openrj.d std\conv.d \
	std\zip.d std\cstream.d std\loader.d \
	std\outofmemory.d \
	std\cover.d \
	std\file.d \
	std\math2.d \
	std\intrinsic.d \
	std\stdint.d \
	std\stdarg.d \
	internal\aaA.d internal\adi.d \
	internal\alloca.d \
	internal\aApply.d internal\aApplyR.d internal\memset.d \
	internal\arraycast.d internal\arraycat.d \
	internal\switch.d internal\qsort.d internal\invariant.d \
	internal\dmain2.d internal\cast.d internal\obj.d \
	internal\arrayfloat.d internal\arraydouble.d internal\arrayreal.d \
	internal\arraybyte.d internal\arrayshort.d internal\arrayint.d \
	internal\cmath2.d \
	internal\llmath.d \
	etc\gamma.d \
	std\c\math.d \
	std\c\stdarg.d \
	std\c\stddef.d \
	std\c\stdint.d \
	std\c\stdio.d \
	std\c\stdlib.d \
	std\c\string.d \
	std\c\windows\com.d \
	std\c\windows\stat.d \
	std\c\windows\windows.d \
	std\c\windows\winsock.d \
	std\windows\charset.d \
	std\windows\iunknown.d \
	std\windows\registry.d \
	std\windows\syserror.d \
	std\typeinfo\ti_ptr.d \
	std\typeinfo\ti_delegate.d \
	std\typeinfo\ti_void.d \
	std\typeinfo\ti_C.d \
	std\typeinfo\ti_byte.d \
	std\typeinfo\ti_ubyte.d \
	std\typeinfo\ti_short.d \
	std\typeinfo\ti_ushort.d \
	std\typeinfo\ti_int.d \
	std\typeinfo\ti_uint.d \
	std\typeinfo\ti_long.d \
	std\typeinfo\ti_ulong.d \
	std\typeinfo\ti_char.d \
	std\typeinfo\ti_wchar.d \
	std\typeinfo\ti_dchar.d \
	std\typeinfo\ti_cdouble.d \
	std\typeinfo\ti_double.d \
	std\typeinfo\ti_idouble.d \
	std\typeinfo\ti_cfloat.d \
	std\typeinfo\ti_float.d \
	std\typeinfo\ti_ifloat.d \
	std\typeinfo\ti_creal.d \
	std\typeinfo\ti_real.d \
	std\typeinfo\ti_ireal.d \
	std\typeinfo\ti_AC.d \
	std\typeinfo\ti_Ag.d \
	std\typeinfo\ti_Ashort.d \
	std\typeinfo\ti_Aint.d \
	std\typeinfo\ti_Along.d \
	std\typeinfo\ti_Afloat.d \
	std\typeinfo\ti_Adouble.d \
	std\typeinfo\ti_Areal.d \
	std\typeinfo\ti_Acfloat.d \
	std\typeinfo\ti_Acdouble.d \
	std\typeinfo\ti_Acreal.d

DOCS=	$(DOC)\std_path.html $(DOC)\std_math.html $(DOC)\std_outbuffer.html \
	$(DOC)\std_stream.html $(DOC)\std_string.html $(DOC)\std_base64.html \
	$(DOC)\object.html $(DOC)\std_compiler.html $(DOC)\std_format.html \
	$(DOC)\std_random.html $(DOC)\std_file.html $(DOC)\std_date.html \
	$(DOC)\std_md5.html $(DOC)\std_zip.html $(DOC)\std_zlib.html \
	$(DOC)\std_bind.html \
	$(DOC)\std_bitarray.html \
	$(DOC)\std_conv.html \
	$(DOC)\std_boxer.html \
	$(DOC)\std_cover.html \
	$(DOC)\std_cpuid.html \
	$(DOC)\std_cstream.html \
	$(DOC)\std_ctype.html \
	$(DOC)\std_demangle.html \
	$(DOC)\std_gc.html \
	$(DOC)\std_intrinsic.html \
	$(DOC)\std_metastrings.html \
	$(DOC)\std_mmfile.html \
	$(DOC)\std_openrj.html \
	$(DOC)\std_outofmemory.html \
	$(DOC)\std_process.html \
	$(DOC)\std_regexp.html \
	$(DOC)\std_signals.html \
	$(DOC)\std_socket.html \
	$(DOC)\std_socketstream.html \
	$(DOC)\std_stdint.html \
	$(DOC)\std_stdio.html \
	$(DOC)\std_system.html \
	$(DOC)\std_thread.html \
	$(DOC)\std_traits.html \
	$(DOC)\std_typetuple.html \
	$(DOC)\std_uni.html \
	$(DOC)\std_uri.html \
	$(DOC)\std_utf.html \
	$(DOC)\std_windows_charset.html \
	$(DOC)\std_windows_registry.html \
	$(DOC)\std_c_fenv.html \
	$(DOC)\std_c_locale.html \
	$(DOC)\std_c_math.html \
	$(DOC)\std_c_process.html \
	$(DOC)\std_c_stdarg.html \
	$(DOC)\std_c_stddef.html \
	$(DOC)\std_c_stdio.html \
	$(DOC)\std_c_stdlib.html \
	$(DOC)\std_c_string.html \
	$(DOC)\std_c_time.html \
	$(DOC)\std_c_wcharh.html \
	$(DOC)\phobos.html

SRC=	errno.c object.d unittest.d crc32.d gcstats.d phobos.d

SRC_STD= std\zlib.d std\zip.d std\stdint.d std\conv.d std\utf.d std\uri.d \
	std\gc.d std\math.d std\string.d std\path.d std\date.d \
	std\ctype.d std\file.d std\compiler.d std\system.d std\moduleinit.d \
	std\outbuffer.d std\math2.d std\thread.d std\md5.d std\base64.d \
	std\asserterror.d std\dateparse.d std\outofmemory.d std\mmfile.d \
	std\intrinsic.d std\array.d std\switcherr.d std\syserror.d \
	std\regexp.d std\random.d std\stream.d std\process.d \
	std\socket.d std\socketstream.d std\loader.d std\stdarg.d std\format.d \
	std\stdio.d std\perf.d std\openrj.d std\uni.d std\boxer.d \
	std\cstream.d std\demangle.d std\cover.d std\bitarray.d \
	std\signals.d std\cpuid.d std\typetuple.d std\traits.d std\bind.d \
	std\metastrings.d std\thread_helper.d

SRC_STD_C= std\c\process.d std\c\stdlib.d std\c\time.d std\c\stdio.d \
	std\c\math.d std\c\stdarg.d std\c\stddef.d std\c\fenv.d std\c\string.d \
	std\c\locale.d std\c\stdint.d

SRC_TI=	\
	std\typeinfo\ti_wchar.d std\typeinfo\ti_uint.d \
	std\typeinfo\ti_short.d std\typeinfo\ti_ushort.d \
	std\typeinfo\ti_byte.d std\typeinfo\ti_ubyte.d \
	std\typeinfo\ti_long.d std\typeinfo\ti_ulong.d \
	std\typeinfo\ti_ptr.d std\typeinfo\ti_dchar.d \
	std\typeinfo\ti_float.d std\typeinfo\ti_double.d \
	std\typeinfo\ti_real.d std\typeinfo\ti_delegate.d \
	std\typeinfo\ti_creal.d std\typeinfo\ti_ireal.d \
	std\typeinfo\ti_cfloat.d std\typeinfo\ti_ifloat.d \
	std\typeinfo\ti_cdouble.d std\typeinfo\ti_idouble.d \
	std\typeinfo\ti_Ashort.d \
	std\typeinfo\ti_Ag.d \
	std\typeinfo\ti_AC.d std\typeinfo\ti_C.d \
	std\typeinfo\ti_int.d std\typeinfo\ti_char.d \
	std\typeinfo\ti_Aint.d \
	std\typeinfo\ti_Along.d \
	std\typeinfo\ti_Afloat.d std\typeinfo\ti_Adouble.d \
	std\typeinfo\ti_Areal.d \
	std\typeinfo\ti_Acfloat.d std\typeinfo\ti_Acdouble.d \
	std\typeinfo\ti_Acreal.d \
	std\typeinfo\ti_void.d

SRC_INT=	\
	internal\switch.d internal\complex.c internal\critical.c \
	internal\minit.asm internal\alloca.d internal\llmath.d internal\deh.d \
	internal\arraycat.d internal\invariant.d internal\monitor.c \
	internal\memset.d internal\arraycast.d internal\aaA.d internal\adi.d \
	internal\dmain2.d internal\cast.d internal\qsort.d internal\deh2.d \
	internal\cmath2.d internal\obj.d internal\mars.h internal\aApply.d \
	internal\aApplyR.d internal\object.d internal\trace.d internal\qsort2.d \
	internal\arrayfloat.d internal\arraydouble.d internal\arrayreal.d \
	internal\arraybyte.d internal\arrayshort.d internal\arrayint.d \
	internal\dylib_fixes.c internal\image.d

SRC_STD_WIN= std\windows\registry.d \
	std\windows\iunknown.d std\windows\syserror.d std\windows\charset.d

SRC_STD_C_WIN= std\c\windows\windows.d std\c\windows\com.d \
	std\c\windows\winsock.d std\c\windows\stat.d

SRC_STD_C_LINUX= std\c\linux\linux.d std\c\linux\linuxextern.d \
	std\c\linux\socket.d std\c\linux\pthread.d

SRC_STD_C_OSX= std\c\osx\osx.d std\c\osx\mach\dyld.d std\c\osx\mach\getsect.d \
	std\c\osx\mach\loader.d

SRC_STD_C_FREEBSD= std\c\freebsd\freebsd.d \
	std\c\freebsd\socket.d std\c\freebsd\pthread.d \
	std\c\freebsd\math.d

SRC_STD_C_OPENBSD= std\c\openbsd\openbsd.d \
	std\c\openbsd\socket.d std\c\openbsd\pthread.d

SRC_STD_C_SOLARIS= std/c/solaris/solaris.d \
       std/c/solaris/socket.d std/c/solaris/pthread.d

SRC_STD_C_POSIX= std\c\posix\posix.d \
	std\c\posix\socket.d std\c\posix\pthread.d

SRC_ETC= etc\gamma.d

SRC_ETC_C= etc\c\zlib.d

SRC_ZLIB= \
	etc\c\zlib\crc32.h \
	etc\c\zlib\deflate.h \
	etc\c\zlib\gzguts.h \
	etc\c\zlib\inffixed.h \
	etc\c\zlib\inffast.h \
	etc\c\zlib\inftrees.h \
	etc\c\zlib\inflate.h \
	etc\c\zlib\trees.h \
	etc\c\zlib\zconf.h \
	etc\c\zlib\zlib.h \
	etc\c\zlib\zutil.h \
	etc\c\zlib\adler32.c \
	etc\c\zlib\compress.c \
	etc\c\zlib\crc32.c \
	etc\c\zlib\deflate.c \
	etc\c\zlib\example.c \
	etc\c\zlib\gzclose.c \
	etc\c\zlib\gzlib.c \
	etc\c\zlib\gzread.c \
	etc\c\zlib\gzwrite.c \
	etc\c\zlib\infback.c \
	etc\c\zlib\inffast.c \
	etc\c\zlib\inflate.c \
	etc\c\zlib\inftrees.c \
	etc\c\zlib\minigzip.c \
	etc\c\zlib\trees.c \
	etc\c\zlib\uncompr.c \
	etc\c\zlib\zutil.c \
	etc\c\zlib\algorithm.txt \
	etc\c\zlib\zlib.3 \
	etc\c\zlib\ChangeLog \
	etc\c\zlib\README

MAKEFILES_ZLIB=\
	etc\c\zlib\win32.mak \
	etc\c\zlib\win64.mak \
	etc\c\zlib\linux.mak \
	etc\c\zlib\osx.mak \
	etc\c\zlib\freebsd.mak \
	etc\c\zlib\openbsd.mak \
	etc\c\zlib\solaris.mak

SRC_GC= internal\gc\gc.d \
	internal\gc\gcold.d \
	internal\gc\gcx.d \
	internal\gc\gcstub.d \
	internal\gc\gcbits.d \
	internal\gc\win32.d \
	internal\gc\gclinux.d \
	internal\gc\gcosxc.c \
	internal\gc\testgc.d

MAKEFILES_GC=\
	internal\gc\win32.mak \
	internal\gc\win64.mak \
	internal\gc\linux.mak \
	internal\gc\osx.mak \
	internal\gc\freebsd.mak \
	internal\gc\openbsd.mak \
	internal\gc\solaris.mak

$(PHOBOSLIB) : $(OBJS) $(SRCS) internal\gc\dmgc64.lib \
	etc\c\zlib\zlib64.lib win64.mak
#	lib -c -p32 $(PHOBOSLIB) $(OBJS) internal\gc\dmgc64.lib \
#		etc\c\zlib\zlib64.lib
	$(DMD) -lib -of$(PHOBOSLIB) -Xfphobos.json $(DFLAGS) $(SRCS) $(OBJS) \
		internal\gc\dmgc64.lib etc\c\zlib\zlib64.lib

unittest : $(SRCS) $(PHOBOSLIB)
	$(DMD) $(DFLAGS) -unittest -version=Unittest unittest.d $(SRCS) $(PHOBOSLIB)
	unittest

#unittest : unittest.exe
#       unittest
#
#unittest.exe : unittest.d $(PHOBOSLIB)
#       $(DMD) unittest -g
#       dmc unittest.obj -g

cov : $(SRCS) $(PHOBOSLIB)
	$(DMD) -cov -unittest -ofcov.exe unittest.d -version=Unittest $(SRCS) $(PHOBOSLIB)
	cov

html : $(DOCS)

######################################################

internal\gc\dmgc64.lib:
	cd internal\gc
	make DMD=$(DMD) -f win$(MODEL).mak dmgc64.lib
	cd ..\..

etc\c\zlib\zlib64.lib:
	cd etc\c\zlib
	make -f win$(MODEL).mak zlib64.lib
	cd ..\..\..

errno.obj : errno.c

### internal

aaA.obj : internal\aaA.d
	$(DMD) -c $(DFLAGS) internal\aaA.d

aApply.obj : internal\aApply.d
	$(DMD) -c $(DFLAGS) internal\aApply.d

aApplyR.obj : internal\aApplyR.d
	$(DMD) -c $(DFLAGS) internal\aApplyR.d

adi.obj : internal\adi.d
	$(DMD) -c $(DFLAGS) internal\adi.d

arraycast.obj : internal\arraycast.d
	$(DMD) -c $(DFLAGS) internal\arraycast.d

arraycat.obj : internal\arraycat.d
	$(DMD) -c $(DFLAGS) internal\arraycat.d

cast.obj : internal\cast.d
	$(DMD) -c $(DFLAGS) internal\cast.d

cmath2.obj : internal\cmath2.d
	$(DMD) -c $(DFLAGS) internal\cmath2.d

complex.obj : internal\complex.c
	$(CC) -c $(CFLAGS) internal\complex.c

critical.obj : internal\critical.c
	$(CC) -c $(CFLAGS) internal\critical.c

deh2.obj : internal\deh2.d
	$(DMD) -c $(DFLAGS) internal\deh2.d

dmain2.obj : internal\dmain2.d
	$(DMD) -c $(DFLAGS) internal\dmain2.d

gcstub$(MODEL).obj : internal\gc\gcstub.d
	$(DMD) -c $(DFLAGS) -Iinternal\gc internal\gc\gcstub.d -ofgcstub$(MODEL).obj

invariant.obj : internal\invariant.d
	$(DMD) -c $(DFLAGS) internal\invariant.d

memset.obj : internal\memset.d
	$(DMD) -c $(DFLAGS) internal\memset.d

minit.obj : internal\minit.asm
	$(CC) -c internal\minit.asm

monitor.obj : internal\mars.h internal\monitor.c
	$(CC) -c $(CFLAGS) internal\monitor.c

obj.obj : internal\obj.d
	$(DMD) -c $(DFLAGS) internal\obj.d

object.obj : internal\object.d
	$(DMD) -c $(DFLAGS) internal\object.d

qsort.obj : internal\qsort.d
	$(DMD) -c $(DFLAGS) internal\qsort.d

switch.obj : internal\switch.d
	$(DMD) -c $(DFLAGS) internal\switch.d

trace.obj : internal\trace.d
	$(DMD) -c $(DFLAGS) internal\trace.d

### std

array.obj : std\array.d
	$(DMD) -c $(DFLAGS) std\array.d

asserterror.obj : std\asserterror.d
	$(DMD) -c $(DFLAGS) std\asserterror.d

base64.obj : std\base64.d
	$(DMD) -c $(DFLAGS) -inline std\base64.d

bind.obj : std\bind.d
	$(DMD) -c $(DFLAGS) -inline std\bind.d

bitarray.obj : std\bitarray.d
	$(DMD) -c $(DFLAGS) -inline std\bitarray.d

boxer.obj : std\boxer.d
	$(DMD) -c $(DFLAGS) std\boxer.d

compiler.obj : std\compiler.d
	$(DMD) -c $(DFLAGS) std\compiler.d

conv.obj : std\conv.d
	$(DMD) -c $(DFLAGS) std\conv.d

cover.obj : std\cover.d
	$(DMD) -c $(DFLAGS) std\cover.d

cpuid.obj : std\cpuid.d
	$(DMD) -c $(DFLAGS) std\cpuid.d -ofcpuid.obj

cstream.obj : std\cstream.d
	$(DMD) -c $(DFLAGS) std\cstream.d

ctype.obj : std\ctype.d
	$(DMD) -c $(DFLAGS) std\ctype.d

date.obj : std\dateparse.d std\date.d
	$(DMD) -c $(DFLAGS) std\date.d

dateparse.obj : std\dateparse.d std\date.d
	$(DMD) -c $(DFLAGS) std\dateparse.d

demangle.obj : std\demangle.d
	$(DMD) -c $(DFLAGS) std\demangle.d

file.obj : std\file.d
	$(DMD) -c $(DFLAGS) std\file.d

format.obj : std\format.d
	$(DMD) -c $(DFLAGS) std\format.d

gc.obj : std\gc.d
	$(DMD) -c $(DFLAGS) std\gc.d

loader.obj : std\loader.d
	$(DMD) -c $(DFLAGS) std\loader.d

math.obj : std\math.d
	$(DMD) -c $(DFLAGS) std\math.d

math2.obj : std\math2.d
	$(DMD) -c $(DFLAGS) std\math2.d

md5.obj : std\md5.d
	$(DMD) -c $(DFLAGS) -inline std\md5.d

metastrings.obj : std\metastrings.d
	$(DMD) -c $(DFLAGS) -inline std\metastrings.d

mmfile.obj : std\mmfile.d
	$(DMD) -c $(DFLAGS) std\mmfile.d

moduleinit.obj : std\moduleinit.d
	$(DMD) -c $(DFLAGS) std\moduleinit.d

#object.obj : object.d
#	$(DMD) -c $(DFLAGS) object.d

openrj.obj : std\openrj.d
	$(DMD) -c $(DFLAGS) std\openrj.d

outbuffer.obj : std\outbuffer.d
	$(DMD) -c $(DFLAGS) std\outbuffer.d

outofmemory.obj : std\outofmemory.d
	$(DMD) -c $(DFLAGS) std\outofmemory.d

path.obj : std\path.d
	$(DMD) -c $(DFLAGS) std\path.d

perf.obj : std\perf.d
	$(DMD) -c $(DFLAGS) std\perf.d

process.obj : std\process.d
	$(DMD) -c $(DFLAGS) std\process.d

random.obj : std\random.d
	$(DMD) -c $(DFLAGS) std\random.d

regexp.obj : std\regexp.d
	$(DMD) -c $(DFLAGS) std\regexp.d

signals.obj : std\signals.d
	$(DMD) -c $(DFLAGS) std\signals.d -ofsignals.obj

socket.obj : std\socket.d
	$(DMD) -c $(DFLAGS) std\socket.d -ofsocket.obj

socketstream.obj : std\socketstream.d
	$(DMD) -c $(DFLAGS) std\socketstream.d -ofsocketstream.obj

stdio.obj : std\stdio.d
	$(DMD) -c $(DFLAGS) std\stdio.d

stream.obj : std\stream.d
	$(DMD) -c $(DFLAGS) -d std\stream.d

string.obj : std\string.d
	$(DMD) -c $(DFLAGS) std\string.d

switcherr.obj : std\switcherr.d
	$(DMD) -c $(DFLAGS) std\switcherr.d

oldsyserror.obj : std\syserror.d
	$(DMD) -c $(DFLAGS) std\syserror.d -ofoldsyserror.obj

system.obj : std\system.d
	$(DMD) -c $(DFLAGS) std\system.d

thread.obj : std\thread.d
	$(DMD) -c $(DFLAGS) std\thread.d

thread_helper.obj : std\thread_helper.d
	$(DMD) -c $(DFLAGS) std\thread_helper.d

traits.obj : std\traits.d
	$(DMD) -c $(DFLAGS) std\traits.d -oftraits.obj

typetuple.obj : std\typetuple.d
	$(DMD) -c $(DFLAGS) std\typetuple.d -oftypetuple.obj

uni.obj : std\uni.d
	$(DMD) -c $(DFLAGS) std\uni.d

uri.obj : std\uri.d
	$(DMD) -c $(DFLAGS) std\uri.d

utf.obj : std\utf.d
	$(DMD) -c $(DFLAGS) std\utf.d

Dzlib.obj : std\zlib.d
	$(DMD) -c $(DFLAGS) std\zlib.d -ofDzlib.obj

zip.obj : std\zip.d
	$(DMD) -c $(DFLAGS) std\zip.d

### std\windows

charset.obj : std\windows\charset.d
	$(DMD) -c $(DFLAGS) std\windows\charset.d

iunknown.obj : std\windows\iunknown.d
	$(DMD) -c $(DFLAGS) std\windows\iunknown.d

registry.obj : std\windows\registry.d
	$(DMD) -c $(DFLAGS) std\windows\registry.d

syserror.obj : std\windows\syserror.d
	$(DMD) -c $(DFLAGS) std\windows\syserror.d

### std\c

stdarg.obj : std\c\stdarg.d
	$(DMD) -c $(DFLAGS) std\c\stdarg.d

### etc

gamma.obj : etc\gamma.d
	$(DMD) -c $(DFLAGS) etc\gamma.d

### etc\c

Czlib.obj : etc\c\zlib.d
	$(DMD) -c $(DFLAGS) etc\c\zlib.d -ofCzlib.obj

### std\c\windows

com.obj : std\c\windows\com.d
	$(DMD) -c $(DFLAGS) std\c\windows\com.d

stat.obj : std\c\windows\stat.d
	$(DMD) -c $(DFLAGS) std\c\windows\stat.d

winsock.obj : std\c\windows\winsock.d
	$(DMD) -c $(DFLAGS) std\c\windows\winsock.d

windows.obj : std\c\windows\windows.d
	$(DMD) -c $(DFLAGS) std\c\windows\windows.d

### std\typeinfo

ti_void.obj : std\typeinfo\ti_void.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_void.d

ti_bit.obj : std\typeinfo\ti_bit.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_bit.d

ti_wchar.obj : std\typeinfo\ti_wchar.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_wchar.d

ti_dchar.obj : std\typeinfo\ti_dchar.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_dchar.d

ti_uint.obj : std\typeinfo\ti_uint.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_uint.d

ti_short.obj : std\typeinfo\ti_short.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_short.d

ti_ushort.obj : std\typeinfo\ti_ushort.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_ushort.d

ti_byte.obj : std\typeinfo\ti_byte.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_byte.d

ti_ubyte.obj : std\typeinfo\ti_ubyte.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_ubyte.d

ti_long.obj : std\typeinfo\ti_long.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_long.d

ti_ulong.obj : std\typeinfo\ti_ulong.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_ulong.d

ti_ptr.obj : std\typeinfo\ti_ptr.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_ptr.d

ti_float.obj : std\typeinfo\ti_float.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_float.d

ti_double.obj : std\typeinfo\ti_double.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_double.d

ti_real.obj : std\typeinfo\ti_real.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_real.d

ti_delegate.obj : std\typeinfo\ti_delegate.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_delegate.d

ti_creal.obj : std\typeinfo\ti_creal.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_creal.d

ti_ireal.obj : std\typeinfo\ti_ireal.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_ireal.d

ti_cfloat.obj : std\typeinfo\ti_cfloat.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_cfloat.d

ti_ifloat.obj : std\typeinfo\ti_ifloat.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_ifloat.d

ti_cdouble.obj : std\typeinfo\ti_cdouble.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_cdouble.d

ti_idouble.obj : std\typeinfo\ti_idouble.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_idouble.d

ti_AC.obj : std\typeinfo\ti_AC.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_AC.d

ti_Ag.obj : std\typeinfo\ti_Ag.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Ag.d

ti_Abit.obj : std\typeinfo\ti_Abit.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Abit.d

ti_Ashort.obj : std\typeinfo\ti_Ashort.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Ashort.d

ti_Aint.obj : std\typeinfo\ti_Aint.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Aint.d

ti_Along.obj : std\typeinfo\ti_Along.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Along.d

ti_Afloat.obj : std\typeinfo\ti_Afloat.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Afloat.d

ti_Adouble.obj : std\typeinfo\ti_Adouble.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Adouble.d

ti_Areal.obj : std\typeinfo\ti_Areal.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Areal.d

ti_Acfloat.obj : std\typeinfo\ti_Acfloat.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Acfloat.d

ti_Acdouble.obj : std\typeinfo\ti_Acdouble.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Acdouble.d

ti_Acreal.obj : std\typeinfo\ti_Acreal.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_Acreal.d

ti_C.obj : std\typeinfo\ti_C.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_C.d

ti_char.obj : std\typeinfo\ti_char.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_char.d

ti_int.obj : std\typeinfo\ti_int.d
	$(DMD) -c $(DFLAGS) std\typeinfo\ti_int.d


################## DOCS ####################################

$(DOC)\phobos.html : std.ddoc phobos.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\phobos.html std.ddoc phobos.d

$(DOC)\std_base64.html : std.ddoc std\base64.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_base64.html std.ddoc std\base64.d

$(DOC)\std_bind.html : std.ddoc std\bind.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_bind.html std.ddoc std\bind.d

$(DOC)\std_bitarray.html : std.ddoc std\bitarray.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_bitarray.html std.ddoc std\bitarray.d

$(DOC)\std_boxer.html : std.ddoc std\boxer.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_boxer.html std.ddoc std\boxer.d

$(DOC)\std_compiler.html : std.ddoc std\compiler.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_compiler.html std.ddoc std\compiler.d

$(DOC)\std_conv.html : std.ddoc std\conv.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_conv.html std.ddoc std\conv.d

$(DOC)\std_cover.html : std.ddoc std\cover.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_cover.html std.ddoc std\cover.d

$(DOC)\std_cpuid.html : std.ddoc std\cpuid.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_cpuid.html std.ddoc std\cpuid.d

$(DOC)\std_cstream.html : std.ddoc std\cstream.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_cstream.html std.ddoc std\cstream.d

$(DOC)\std_ctype.html : std.ddoc std\ctype.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_ctype.html std.ddoc std\ctype.d

$(DOC)\std_date.html : std.ddoc std\date.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_date.html std.ddoc std\date.d

$(DOC)\std_demangle.html : std.ddoc std\demangle.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_demangle.html std.ddoc std\demangle.d

$(DOC)\std_file.html : std.ddoc std\file.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_file.html std.ddoc std\file.d

$(DOC)\std_format.html : std.ddoc std\format.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_format.html std.ddoc std\format.d

$(DOC)\std_gc.html : std.ddoc std\gc.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_gc.html std.ddoc std\gc.d

$(DOC)\std_intrinsic.html : std.ddoc std\intrinsic.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_intrinsic.html std.ddoc std\intrinsic.d

$(DOC)\std_math.html : std.ddoc std\math.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_math.html std.ddoc std\math.d

$(DOC)\std_md5.html : std.ddoc std\md5.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_md5.html std.ddoc std\md5.d

$(DOC)\std_metastrings.html : std.ddoc std\metastrings.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_metastrings.html std.ddoc std\metastrings.d

$(DOC)\std_mmfile.html : std.ddoc std\mmfile.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_mmfile.html std.ddoc std\mmfile.d

$(DOC)\std_openrj.html : std.ddoc std\openrj.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_openrj.html std.ddoc std\openrj.d

$(DOC)\std_outbuffer.html : std.ddoc std\outbuffer.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_outbuffer.html std.ddoc std\outbuffer.d

$(DOC)\std_outofmemory.html : std.ddoc std\outofmemory.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_outofmemory.html std.ddoc std\outofmemory.d

$(DOC)\std_path.html : std.ddoc std\path.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_path.html std.ddoc std\path.d

$(DOC)\std_process.html : std.ddoc std\process.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_process.html std.ddoc std\process.d

$(DOC)\std_random.html : std.ddoc std\random.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_random.html std.ddoc std\random.d

$(DOC)\std_regexp.html : std.ddoc std\regexp.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_regexp.html std.ddoc std\regexp.d

$(DOC)\std_signals.html : std.ddoc std\signals.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_signals.html std.ddoc std\signals.d

$(DOC)\std_socket.html : std.ddoc std\socket.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_socket.html std.ddoc std\socket.d

$(DOC)\std_socketstream.html : std.ddoc std\socketstream.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_socketstream.html std.ddoc std\socketstream.d

$(DOC)\std_stdint.html : std.ddoc std\stdint.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_stdint.html std.ddoc std\stdint.d

$(DOC)\std_stdio.html : std.ddoc std\stdio.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_stdio.html std.ddoc std\stdio.d

$(DOC)\std_stream.html : std.ddoc std\stream.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_stream.html -d std.ddoc std\stream.d

$(DOC)\std_string.html : std.ddoc std\string.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_string.html std.ddoc std\string.d

$(DOC)\std_system.html : std.ddoc std\system.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_system.html std.ddoc std\system.d

$(DOC)\std_thread.html : std.ddoc std\thread.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_thread.html std.ddoc std\thread.d

$(DOC)\std_traits.html : std.ddoc std\traits.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_traits.html std.ddoc std\traits.d

$(DOC)\std_typetuple.html : std.ddoc std\typetuple.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_typetuple.html std.ddoc std\typetuple.d

$(DOC)\std_uni.html : std.ddoc std\uni.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_uni.html std.ddoc std\uni.d

$(DOC)\std_uri.html : std.ddoc std\uri.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_uri.html std.ddoc std\uri.d

$(DOC)\std_utf.html : std.ddoc std\utf.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_utf.html std.ddoc std\utf.d

$(DOC)\std_zip.html : std.ddoc std\zip.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_zip.html std.ddoc std\zip.d

$(DOC)\std_zlib.html : std.ddoc std\zlib.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_zlib.html std.ddoc std\zlib.d

$(DOC)\std_windows_charset.html : std.ddoc std\windows\charset.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_windows_charset.html std.ddoc std\windows\charset.d

$(DOC)\std_windows_registry.html : std.ddoc std\windows\registry.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_windows_registry.html std.ddoc std\windows\registry.d

$(DOC)\object.html : std.ddoc internal\object.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\object.html std.ddoc internal\object.d

$(DOC)\std_c_fenv.html : std.ddoc std\c\fenv.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_fenv.html std.ddoc std\c\fenv.d

$(DOC)\std_c_locale.html : std.ddoc std\c\locale.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_locale.html std.ddoc std\c\locale.d

$(DOC)\std_c_math.html : std.ddoc std\c\math.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_math.html std.ddoc std\c\math.d

$(DOC)\std_c_process.html : std.ddoc std\c\process.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_process.html std.ddoc std\c\process.d

$(DOC)\std_c_stdarg.html : std.ddoc std\c\stdarg.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_stdarg.html std.ddoc std\c\stdarg.d

$(DOC)\std_c_stddef.html : std.ddoc std\c\stddef.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_stddef.html std.ddoc std\c\stddef.d

$(DOC)\std_c_stdio.html : std.ddoc std\c\stdio.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_stdio.html std.ddoc std\c\stdio.d

$(DOC)\std_c_stdlib.html : std.ddoc std\c\stdlib.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_stdlib.html std.ddoc std\c\stdlib.d

$(DOC)\std_c_string.html : std.ddoc std\c\string.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_string.html std.ddoc std\c\string.d

$(DOC)\std_c_time.html : std.ddoc std\c\time.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_time.html std.ddoc std\c\time.d

$(DOC)\std_c_wcharh.html : std.ddoc std\c\wcharh.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_c_wcharh.html std.ddoc std\c\wcharh.d


######################################################

zip : $(MAKEFILES) phoboslicense.txt std.ddoc $(SRC) \
	$(SRC_STD) $(SRC_STD_C) $(SRC_TI) $(SRC_INT) $(SRC_STD_WIN) \
	$(SRC_STDLINUX) $(SRC_ETC) $(SRC_ETC_C) $(SRC_ZLIB) $(SRC_GC) \
	$(MAKEFILES_ZLIB) $(MAKEFILES_GC)
	del phobos.zip
	zip32 -u phobos $(MAKEFILES) std.ddoc phoboslicense.txt
	zip32 -u phobos $(SRC)
	zip32 -u phobos $(SRC_TI)
	zip32 -u phobos $(SRC_INT)
	zip32 -u phobos $(SRC_STD)
	zip32 -u phobos $(SRC_STD_C)
	zip32 -u phobos $(SRC_STD_WIN)
	zip32 -u phobos $(SRC_STD_C_WIN)
	zip32 -u phobos $(SRC_STD_C_LINUX)
	zip32 -u phobos $(SRC_STD_C_OSX)
	zip32 -u phobos $(SRC_STD_C_FREEBSD)
	zip32 -u phobos $(SRC_STD_C_OPENBSD)
	zip32 -u phobos $(SRC_STD_C_SOLARIS)
	zip32 -u phobos $(SRC_STD_C_POSIX)
	zip32 -u phobos $(SRC_ETC)
	zip32 -u phobos $(SRC_ETC_C)
	zip32 -u phobos $(SRC_ZLIB) $(MAKEFILES_ZLIB)
	zip32 -u phobos $(SRC_GC) $(MAKEFILES_GC)

clean:
	cd etc\c\zlib
	make -f win$(MODEL).mak clean
	cd ..\..\..
	cd internal\gc
	make DMD=$(DMD) -f win$(MODEL).mak clean
	cd ..\..
	del $(OBJS)
	del $(DOCS)
	del phobos.json
	del $(PHOBOSLIB)

cleanhtml:
	del $(DOCS)

detab:
	detab $(SRC) \
	$(SRC_STD) $(SRC_STD_C) $(SRC_TI) $(SRC_INT) $(SRC_STD_WIN) \
	$(SRC_STDLINUX) $(SRC_STD_C_OSX) $(SRC_STD_C_SOLARIS)
# $(SRC_ETC) $(SRC_ETC_C) $(SRC_ZLIB) $(SRC_GC)

tolf:
	tolf $(MAKEFILES) $(MAKEFILES_ZLIB) $(MAKEFILES_GC) \
	$(SRC) \
	$(SRC_STD) $(SRC_STD_C) $(SRC_TI) $(SRC_INT) $(SRC_STD_WIN) \
	$(SRC_STDLINUX) $(SRC_STD_C_OSX) $(SRC_STD_C_SOLARIS) \
	$(SRC_ETC) $(SRC_ETC_C) $(SRC_ZLIB) $(SRC_GC)

install: zip minit.obj
	$(CP) phobos.lib phobos64.lib gcstub.obj gcstub64.obj $(DIR)\windows\lib
	+rd/s/q $(DIR)\src\phobos\ 
	mkdir $(DIR)\src\phobos\ 
	unzip -o phobos.zip -d $(DIR)\src\phobos\ 
	copy minit.obj $(DIR)\src\phobos\ 

################# Write to Git ####################

git:	detab tolf git2

git2:
	$(SCP) $(MAKEFILES) phoboslicense.txt minit.obj std.ddoc $(SRC) $(PHOBOSGIT)
	$(SCP) $(SRC_STD) $(PHOBOSGIT)/std
	$(SCP) $(SRC_STD_C) $(PHOBOSGIT)/std/c
	$(SCP) $(SRC_TI) $(PHOBOSGIT)/std/typeinfo
	$(SCP) $(SRC_INT) $(PHOBOSGIT)/internal
	$(SCP) $(SRC_STD_WIN) $(PHOBOSGIT)/std/windows
	$(SCP) $(SRC_STD_C_WIN) $(PHOBOSGIT)/std/c/windows
	$(SCP) $(SRC_STD_C_LINUX) $(PHOBOSGIT)/std/c/linux
	$(SCP) $(SRC_STD_C_OSX) $(PHOBOSGIT)/std/c/osx
	$(SCP) $(SRC_STD_C_FREEBSD) $(PHOBOSGIT)/std/c/freebsd
	$(SCP) $(SRC_STD_C_OPENBSD) $(PHOBOSGIT)/std/c/openbsd
	$(SCP) $(SRC_STD_C_SOLARIS) $(PHOBOSGIT)/std/c/solaris
	$(SCP) $(SRC_STD_C_POSIX) $(PHOBOSGIT)/std/c/posix
	$(SCP) $(SRC_ETC) $(PHOBOSGIT)/etc
	$(SCP) $(SRC_ETC_C) $(PHOBOSGIT)/etc/c
	$(SCP) $(SRC_ZLIB) $(MAKEFILES_ZLIB) $(PHOBOSGIT)/etc/c/zlib
	$(SCP) $(SRC_GC) $(MAKEFILES_GC) $(PHOBOSGIT)/internal/gc
