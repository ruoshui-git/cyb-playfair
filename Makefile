
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

.PHONY: help run