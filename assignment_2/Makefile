# Makefile variables
CC = gcc
RM = rm -f
TARGET_LIB = libass2_20CS10011.a
MAIN = main.c

# Source, object and header files
HEADER = myl.h
SRCS = ass2_20CS10011.c main.c
OBJS = $(SRCS:.c=.o)
MAIN_OBJ = $(MAIN:.c=.o)
EXEC = a.out

# Make rule for a.out (depends on main.o and libass2_20CS10011.a)
$(EXEC): $(MAIN_OBJ) $(TARGET_LIB)
	$(CC) $(MAIN_OBJ) -L. -lass2_20CS10011

# Make rule for libass2_20CS10011.a (depends on ass20CS10011.o)
$(TARGET_LIB): ass2_20CS10011.o
	ar -rcs $(TARGET_LIB) ass2_20CS10011.o

# Make rule for object files (main.o and ass2_20CS10011.o, depends on main.c and ass2_20CS10011.c)
$(OBJS): $(SRCS) $(HEADER)
	$(CC) -c $(SRCS) 

# Make rule for cleaning and removing files after compiling
clean:
	$(RM) $(EXEC) $(OBJS) $(TARGET_LIB)