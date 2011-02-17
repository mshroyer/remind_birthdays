AC_INIT(remind_birthdays, 1.0.0, mark@markshroyer.com)
AM_INIT_AUTOMAKE

dnl Test for OS X frameworks needed by this program
AC_MSG_CHECKING([for the Foundation Framework on OS X])
if test -e "/System/Library/Frameworks/Foundation.framework/Foundation"; then
  AC_MSG_RESULT([yes])
else
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([could not find the Foundation framework])
fi

AC_MSG_CHECKING([for the AddressBook Framework on OS X])
if test -e "/System/Library/Frameworks/AddressBook.framework/AddressBook"; then
  AC_MSG_RESULT([yes])
else
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([could not find the AddressBook framework])
fi

AC_CHECK_FUNCS(getopt)

dnl Find and test Apple's GCC; use it as our Objective-C compiler
AC_PROG_CC([gcc])
OBJC="$CC"
AC_SUBST(OBJC)

OBJCDEPMODE="depmode=gcc"
AC_SUBST(OBJCDEPMODE)

dnl Set installation prefix to default, if NONE
if test "x${prefix}" = "xNONE"; then
  prefix="${ac_default_prefix}"
fi

AC_CONFIG_FILES([
Makefile
src/Makefile
man/Makefile
])

AC_MSG_RESULT([
----------------------------------------------------------------------
  $PACKAGE $VERSION:  Automatic configuration OK.

  Programs: remind_birthdays
  Man pages: remind_birthdays(1)
  Installation prefix: ${prefix}

----------------------------------------------------------------------
])

AC_OUTPUT
