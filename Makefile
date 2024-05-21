# Path to EverParse
EVERPARSE_PATH = ..

# Compiler
CC = gcc
CCFLAGS = -I$(GEN_DIR)

# Directories
SRC_DIR = src
GEN_DIR = generated

# 3d files
3D_FILES = $(wildcard $(SRC_DIR)/*.3d)

# Rule to generate .c files from .3d files
$(GEN_DIR)/%.done: $(SRC_DIR)/%.3d
	$(EVERPARSE_PATH)/everparse.sh $< --odir $(GEN_DIR) --cleanup
	touch $@

# Update the GEN_FILES rule to depend on .done files
GEN_FILES: $(patsubst $(SRC_DIR)/%.3d,$(GEN_DIR)/%.done,$(3D_FILES))

# Source files
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
GEN_SRC_FILES = $(wildcard $(GEN_DIR)/*.c)

# Object files
SRC_OBJ_FILES = $(SRC_FILES:.c=.o)
GEN_OBJ_FILES = $(GEN_SRC_FILES:.c=.o)

# Executable
TARGET = main

# Compilation rule
$(TARGET): $(SRC_OBJ_FILES) $(GEN_OBJ_FILES) GEN_FILES
	$(CC) $^ -o $@ $(CCFLAGS)

# Object file rule for src directory
$(SRC_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) -c $< -o $@ $(CCFLAGS)

# Object file rule for generated directory
$(GEN_DIR)/%.o: $(GEN_DIR)/%.c
	$(CC) -c $< -o $@ $(CCFLAGS)



# Clean rule
clean:
	rm -f $(SRC_OBJ_FILES) $(GEN_OBJ_FILES) $(TARGET)

