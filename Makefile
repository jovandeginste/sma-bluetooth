OUT = $(ODIR)/smatool
CC = gcc
ODIR = build
SDIR = .
SOURCES = smatool.c
OBJS = $(patsubst %.c,$(ODIR)/%.o,$(SOURCES))

ARCH := $(shell getconf LONG_BIT)
C_FLAGS_64 := -L/usr/lib64/mysql
C_FLAGS_32 := -L/usr/lib/mysql

PKG_CONFIG=bluez libcurl
LINKER_LIBS=-lmysqlclient -lm $(shell pkg-config --libs $(PKG_CONFIG))
COMPILER_LIBS=$(shell pkg-config --cflags $(PKG_CONFIG))

$(OUT): $(OBJS)
	$(CC) $(OBJS) -fstack-protector-all -O2 -Wall $(C_FLAGS_$(ARCH)) $(LINKER_LIBS) -o $(OUT) 

$(ODIR)/%.o: $(SDIR)/%.c
	$(CC) -O2 $(COMPILER_LIBS) -c $< -o $@

.PHONY: clean install

clean:
	rm -f $(ODIR)/*.o $(OUT)

install:
	install -m 755 smatool /usr/local/bin
	install -m 644 sma.in.new /usr/local/bin
	install -m 644 smatool.conf.new /usr/local/etc
	install -m 644 smatool.xml /usr/local/bin
