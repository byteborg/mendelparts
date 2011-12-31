TARGETS := y-endstop-flag.stl y-endstop-flag-adjustable.stl

all:	$(TARGETS)

%.stl:	%.scad
	openscad -s $@ $<
