# smi - simple markup interpreter
# (c) 2014 Chris Hutchinson
# based on work (c) 2007, 2008 Enno Boland

include config.mk

SRC = smi.c
OBJ = ${SRC:.c=.o}

all: options smi

options:
	@echo smi build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.mk

smi: ${OBJ}
	@echo LD $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f smi ${OBJ} smi-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p smi-${VERSION}
	@cp -R LICENSE README.md Makefile config.mk \
		smi.1 ${SRC} smi-${VERSION}
	@tar -cf smi-${VERSION}.tar smi-${VERSION}
	@gzip smi-${VERSION}.tar
	@rm -rf smi-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f smi ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/smi
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < smi.1 > ${DESTDIR}${MANPREFIX}/man1/smi.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/smi.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/smi
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/sm1.1

.PHONY: all options clean dist install uninstall
