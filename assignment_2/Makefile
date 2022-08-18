CC = gcc
CFLAGS = -Wall
RM = rm -f
TARGET_LIB = libass2_20CS10011.a
MAIN = test.c

HEADER = myl.h
SRCS = ass2_20CS10011.c test.c
OBJS = $(SRCS:.c=.o)
MAIN_OBJ = $(MAIN:.c=.o)
EXEC = a.out

$(EXEC): $(MAIN_OBJ) $(TARGET_LIB)
	$(CC) $(CFLAGS) $(MAIN_OBJ) -L. -lass2_20CS10011

$(TARGET_LIB): ass2_20CS10011.o
	ar -rcs $(TARGET_LIB) ass2_20CS10011.o

$(OBJS): $(SRCS) $(HEADER)
	$(CC) $(CFLAGS) -c $(SRCS) 

clean:
	$(RM) $(EXEC) $(OBJS) $(TARGET_LIB)