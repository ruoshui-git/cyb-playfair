
RUN = cargo run --release

# define RUOSHUI_MAKE_HELP
# Program input:
# make run ARGS="encode ciphertext keytext"
# Output:
# encoded Text

# Program input:
# make run ARGS="decode plaintext keytext"
# Output:
# decoded Text
# endef

# export RUOSHUI_MAKE_HELP

help:
	@cat help.txt

run:
	$(RUN) $(ARGS)


# Set SILENT to 's' if --quiet/-s set, otherwise ''.
SILENT := $(findstring s,$(word 1, $(MAKEFLAGS)))
test:
ifeq ($(SILENT),s)
	@bash test.sh
else
	@bash old_test.sh 2> /dev/null
endif

.PHONY: help run test