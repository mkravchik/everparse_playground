# Executable
TARGET = main

# All rule
.PHONY: all
all: $(TARGET)

# Path to EverParse
EVERPARSE_PATH = ..

# Compiler
CC = gcc
CCFLAGS = -I$(GEN_DIR)

# Directories
SRC_DIR = src
GEN_DIR = generated

# Header files
GEN_HDR_FILES = $(patsubst $(SRC_DIR)/%.3d,$(GEN_DIR)/%.h,$(wildcard $(SRC_DIR)/*.3d))

# .PHONY: headers
# headers: $(GEN_HDR_FILES)

# 3d files
3D_FILES = $(wildcard $(SRC_DIR)/*.3d)

$(GEN_DIR)/%.c $(GEN_DIR)/%Wrapper.c $(GEN_DIR)/%.h: $(SRC_DIR)/%.3d
	$(EVERPARSE_PATH)/everparse.sh $< --odir $(GEN_DIR) --cleanup

# Source files
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)

# Object files
SRC_OBJ_FILES = $(SRC_FILES:.c=.o)
GEN_OBJ_FILES = $(patsubst $(SRC_DIR)/%.3d,$(GEN_DIR)/%.o,$(wildcard $(SRC_DIR)/*.3d))
GEN_OBJ_FILES += $(patsubst $(SRC_DIR)/%.3d,$(GEN_DIR)/%Wrapper.o,$(wildcard $(SRC_DIR)/*.3d))

OBJ_FILES = $(SRC_OBJ_FILES) $(GEN_OBJ_FILES)

# Linking rule
$(TARGET): $(OBJ_FILES) 
	$(CC) $^ -o $@ $(CCFLAGS)

# Compilation rule
$(OBJ_FILES): $(GEN_HDR_FILES)

# Object file rule for src directory
# $(SRC_DIR)/%.o: $(SRC_DIR)/%.c $(GEN_HDR_FILES) 
$(SRC_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) -c $< -o $@ $(CCFLAGS)

# Object file rule for generated directory
$(GEN_DIR)/%.o: $(GEN_DIR)/%.c
	$(CC) -c $< -o $@ $(CCFLAGS)

# Clean rule
clean:
	rm -f $(SRC_OBJ_FILES) $(GEN_DIR)/*.* $(TARGET)

