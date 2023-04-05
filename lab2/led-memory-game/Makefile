# Stripped version of my beautiful makefile: https://github.com/Ekatwikz/katwikOpsys/blob/dev/testing/makefile

DEFAULTFILES:=led-memory-game

WARNINGS:=all extra
LIBS:=gpiod

.PHONY: clean all

all: $(DEFAULTFILES)

$(DEFAULTFILES): $(DEFAULTFILES:%=%.c)
%: %.c
	$(CC) $(WARNINGS:%=-W%) $< -o $@ $(LDPATH:%=-L%) $(LIBS:%=-l%)

clean:
	rm -fv $(DEFAULTFILES)
