TARGET=build/bin/phpdesktop

INCLUDES = -Isrc -Lbuild/lib -Lbuild/bin -I./src -I./src/include -I./src/include/base -I./src/include/internal -I./src/include/test -I./src/include/views -I./src/include/wrapper

CCFLAGS = -Wfatal-errors -g -Wall -Werror -std=c++14 -pthread $(INCLUDES)
CCFLAGS += $(shell pkg-config --cflags glib-2.0 gtk+-3.0 gtk+-unix-print-3.0)

CFLAGS_OPTIMIZE = -O3 -fvisibility=hidden

LDFLAGS = -Wl,-rpath,. -Wl,-rpath,"\$$ORIGIN" -lX11 -lcef -lcef_dll_wrapper -Wl,--as-needed -ldl -lpthread
LDFLAGS += $(shell pkg-config --libs glib-2.0 gtk+-3.0 gtk+-unix-print-3.0)

OBJS=\
	src/main.o \
	src/app.o \
	src/client_handler.o \
	src/dialog_handler_gtk.o \
	src/gtk.o \
	src/json.o \
	src/main_message_loop.o \
	src/main_message_loop_std.o \
	src/mongoose.o \
	src/mongoose_server.o \
	src/print_handler_gtk.o \
	src/settings.o \
	src/util_gtk.o \
	src/utils.o \

CC=g++
.PHONY: clean release debug

# Add NDEBUG variable to make command -- Needed for removing CEF linker error message (see https://www.magpcss.org/ceforum/viewtopic.php?f=6&t=18787)
ifneq (,$(filter DEBUG,$(MAKECMDGOALS)))
    NDEBUG:=1 # or do whatever you want
    NDEBUG: release; @echo -n
endif

NDEBUG=-DNDEBUG # or do whatever you want


# When switching between debug/release modes always clean
# all objects by executing either "./build.sh clean debug"
# or "./build.sh clean release". Otherwise changes to the
# DEBUG macro are not applied.

release: $(TARGET)

debug: CCFLAGS += -DDEBUG
debug: $(TARGET)

-include $(patsubst %, %.deps, $(OBJS))

%.o : %.cpp
	+$(CC) -c $(NDEBUG) -o $@ -MD -MP -MF $@.deps $(CCFLAGS) $(CFLAGS_OPTIMIZE) -Wno-error=deprecated-declarations $<

%.o : %.c
	+gcc -Wfatal-errors -c -o $@ -MD -MP -MF $@.deps -g -std=c11 -O2 -W -Wall -Werror -pedantic -pthread -pipe -Wno-error=unused-parameter $<

$(TARGET): $(OBJS)
	+$(CC) $(CCFLAGS) $(CFLAGS_OPTIMIZE) -o $@ $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS) $(patsubst %, %.deps, $(OBJS)) $(TARGET)
