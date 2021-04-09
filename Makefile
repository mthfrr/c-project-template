TARGET := out
CFLAGS := -Wall -Wextra -pedantic -std=c99
LIBS   := -lm

CC := gcc
OBJDIR := obj
SRC_DIR := src
TEST_DIR := test
DEPFLAGS = -MT $@ -MMD -MP -MF $(OBJDIR)/$*.d

SRCS := $(shell find $(SRC_DIR) -name *.c) # all .c file in src/**
OBJS :=  $(addprefix $(OBJDIR)/,$(SRCS:.c=.o))
OBJ_DIRS := $(addprefix $(OBJDIR)/,$(shell find $(SRC_DIR) -type d) $(shell find $(TEST_DIR) -type d))
INC_FLAGS := $(addprefix -I,$(shell find $(SRC_DIR) -type d))
DEPFILES := $(SRCS:%.c=$(OBJDIR)/%.d)

# criterion vars
CRITERION := 0
TEST_RUN_EXEC := run-tests
CRITERION_SRC := $(shell find $(TEST_DIR) -name *.c) $(filter-out $(shell find $(SRC_DIR) -name *main.c),$(SRCS))
CRITERION_OBJ := $(addprefix $(OBJDIR)/,$(CRITERION_SRC:.c=.o))
CRITERION_DEPS := $(CRITERION_SRC:%.c=$(OBJDIR)/%.d)


# tmp test
TEST_SRC := $(shell find $(TEST_DIR) -name *.c)
DEPFILES += $(TEST_SRC:%.c=$(OBJDIR)/%.d)

COMPILE.c = $(CC) $(DEPFLAGS) $(CFLAGS) $(INC_FLAGS) -c
COMPILE.o = $(CC) $(CFLAGS)

all: release

build: $(TARGET)

debug: CFLAGS   += -g3 -DDEBUG
debug: build

asan: CFLAGS    += -g3 -DDEBUG -fsanitize=address -fsanitize=leak
asan: build

release: CFLAGS += -g0 -DNDEBUG -O3 -Werror
release: build

run: asan
	@./$(TARGET)

test: CFLAGS += -g3 -DDEBUG -fsanitize=address -fsanitize=leak
test: $(TEST_RUN_EXEC)

test-run: test
	@./$(TEST_RUN_EXEC)
	
$(TEST_RUN_EXEC): $(CRITERION_OBJ)
	$(CC) $(CFLAGS) $(CRITERION_OBJ) -o run-tests $(LIBS) -lcriterion


$(TARGET): $(OBJS)
	$(COMPILE.o) $(OUTPUT_OPTION) $^ $(LIBS)

$(OBJDIR)/%.o : %.c $(OBJDIR)/%.d | $(OBJ_DIRS)
	$(COMPILE.c) $(OUTPUT_OPTION) $<

$(OBJ_DIRS): ; @mkdir -p $@

.PHONY: clean run release asan debug build test
clean:
	$(RM) -r $(OBJDIR)
	$(RM) $(TARGET)
	$(RM) run-tests

$(DEPFILES):
include $(wildcard $(DEPFILES))

# ifeq (CRITERION, "0")
# $(DEPFILES):
# include $(wildcard $(DEPFILES))
# else
# $(CRITERION_DEPS):
# include $(wildcard $(CRITERION_DEPS))
# endif