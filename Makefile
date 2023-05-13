# slock - simple screen locker
# See LICENSE file for copyright and license details.

include config.mk

SRC = slock.c ${COMPATSRC}
OBJ = ${SRC:.c=.o}

all: options slock

options:
	@echo slock build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk arg.h util.h

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

slock: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f slock ${OBJ} slock-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p slock-${VERSION}
	@cp -R LICENSE Makefile README slock.1 config.mk \
		${SRC} explicit_bzero.c config.def.h arg.h util.h slock-${VERSION}
	@tar -cf slock-${VERSION}.tar slock-${VERSION}
	@gzip slock-${VERSION}.tar
	@rm -rf slock-${VERSION}

install: all
	@echo installing executable file to ${BINPREFIX}
	@mkdir -p ${BINPREFIX}
	@cp -f slock ${BINPREFIX}
	@chmod 700 ${BINPREFIX}/slock
	@chmod u+s ${BINPREFIX}/slock
	@echo installing manual page to ${MANPREFIX}/man1
	@mkdir -p ${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" <slock.1 >${MANPREFIX}/man1/slock.1
	@chmod 600 ${MANPREFIX}/man1/slock.1

uninstall:
	@echo removing executable file from ${BINPREFIX}
	@rm -f ${BINPREFIX}/bin/slock
	@echo removing manual page from ${MANPREFIX}/man1
	@rm -f ${MANPREFIX}/man1/slock.1

.PHONY: all options clean dist install uninstall
