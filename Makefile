
RUN = cargo run --release

help:
	@echo "Program input:"
	@echo "make run ARGS=\"encode ciphertext keytext\""
	@echo "Output:"
	@echo "encoded Text"
	@echo 
	@echo "Program input:"
	@echo "make run ARGS=\"decode plaintext keytext\""
	@echo "Output:"
	@echo "decoded Text"

run:
	$(RUN) $(ARGS)

