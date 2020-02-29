CC ?= gcc
RM ?= rm

CFLAGS += -Iinclude
LIBS += -lpng -lSDL -lm

SRC := $(wildcard src/*.c)
OBJS := $(SRC:.c=.o)

BIN = caph

.PHONY : all clean
all: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(LFLAGS)  $(OBJS) -o $@ $(LFLAGS) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ -I.

clean:
	$(RM) -f src/*.o $(BIN)
