include Config.mk

all:
    @./generate_docs.sh $(DOCSET_SOURCE) $(DOCSET_TARGET)
    open -a dash $(DOCSET_TARGET).docset
