# cad/Makefile - generate all STLs via the OpenSCAD CLI.
# Output goes to print/files/{ferris,booth}/ (git-ignored; sources are the source of truth).
#   make all      generate every STL
#   make check    generate + run the bounding-box dimension check
#   make clean    remove generated STLs

OPENSCAD ?= openscad
OUT      := ../print/files
FERRIS   := $(OUT)/ferris
BOOTH    := $(OUT)/booth
COMMON   := params.scad lib/dovetail.scad

FERRIS_STL := \
	$(FERRIS)/rim-segment.stl \
	$(FERRIS)/diffuser.stl \
	$(FERRIS)/hub.stl \
	$(FERRIS)/gondola.stl \
	$(FERRIS)/tower-upper.stl \
	$(FERRIS)/tower-lower.stl \
	$(FERRIS)/base.stl \
	$(FERRIS)/crank.stl

BOOTH_STL := \
	$(BOOTH)/floor-tile.stl \
	$(BOOTH)/wall-blackboard.stl \
	$(BOOTH)/wall-window.stl \
	$(BOOTH)/wall-board.stl \
	$(BOOTH)/stand-clips.stl

.PHONY: all ferris booth check clean dirs joint-test
joint-test: dirs $(FERRIS)/joint-test-a.stl $(FERRIS)/joint-test-b.stl

all: ferris booth
ferris: dirs $(FERRIS_STL)
booth: dirs $(BOOTH_STL)

dirs:
	@mkdir -p $(FERRIS) $(BOOTH)

$(FERRIS)/joint-test-a.stl: ferris/joint_test_a.scad ferris/rim_segment.scad $(COMMON)
	$(OPENSCAD) -o $@ $<

$(FERRIS)/joint-test-b.stl: ferris/joint_test_b.scad ferris/rim_segment.scad $(COMMON)
	$(OPENSCAD) -o $@ $<

# --- ferris ---------------------------------------------------------------
$(FERRIS)/rim-segment.stl: ferris/rim_segment.scad $(COMMON)
	$(OPENSCAD) -o $@ $<
$(FERRIS)/diffuser.stl: ferris/diffuser.scad $(COMMON)
	$(OPENSCAD) -o $@ $<
$(FERRIS)/hub.stl: ferris/hub.scad $(COMMON)
	$(OPENSCAD) -o $@ $<
$(FERRIS)/gondola.stl: ferris/gondola.scad $(COMMON)
	$(OPENSCAD) -o $@ $<
$(FERRIS)/tower-upper.stl: ferris/tower.scad $(COMMON)
	$(OPENSCAD) -D 'part="upper"' -o $@ $<
$(FERRIS)/tower-lower.stl: ferris/tower.scad $(COMMON)
	$(OPENSCAD) -D 'part="lower"' -o $@ $<
$(FERRIS)/base.stl: ferris/base.scad $(COMMON)
	$(OPENSCAD) -o $@ $<
$(FERRIS)/crank.stl: ferris/crank.scad $(COMMON)
	$(OPENSCAD) -o $@ $<

# --- booth ----------------------------------------------------------------
$(BOOTH)/floor-tile.stl: booth/floor_tile.scad $(COMMON)
	$(OPENSCAD) -o $@ $<
$(BOOTH)/wall-blackboard.stl: booth/wall_panel.scad $(COMMON)
	$(OPENSCAD) -D 'variant="blackboard"' -o $@ $<
$(BOOTH)/wall-window.stl: booth/wall_panel.scad $(COMMON)
	$(OPENSCAD) -D 'variant="window"' -o $@ $<
$(BOOTH)/wall-board.stl: booth/wall_panel.scad $(COMMON)
	$(OPENSCAD) -D 'variant="board"' -o $@ $<
$(BOOTH)/stand-clips.stl: booth/stand_clips.scad $(COMMON)
	$(OPENSCAD) -o $@ $<

# --- checks / cleanup -----------------------------------------------------
check: all
	python3 check_dims.py $(OUT)

clean:
	rm -f $(FERRIS_STL) $(BOOTH_STL)
