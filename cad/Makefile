# cad/Makefile - generate all STLs via the OpenSCAD CLI.
# Output goes to print/files/{ferris,booth}/ (git-ignored; sources are the source of truth).
#   make all      generate every STL
#   make check    generate + run the bounding-box dimension check
#   make clean    remove generated STLs

OPENSCAD ?= openscad
OUT      := ../print/files
FERRIS   := $(OUT)/ferris
BOOTH    := $(OUT)/booth
MINI     := $(OUT)/mini
COMMON   := params.scad lib/dovetail.scad

FERRIS_STL := \
	$(FERRIS)/rim-segment.stl \
	$(FERRIS)/diffuser.stl \
	$(FERRIS)/hub.stl \
	$(FERRIS)/gondola.stl \
	$(FERRIS)/tower-upper.stl \
	$(FERRIS)/tower-lower.stl \
	$(FERRIS)/base.stl \
	$(FERRIS)/base-mini.stl \
	$(FERRIS)/crank.stl \
	$(FERRIS)/axle.stl

BOOTH_STL := \
	$(BOOTH)/floor-tile.stl \
	$(BOOTH)/wall-blackboard.stl \
	$(BOOTH)/wall-window.stl \
	$(BOOTH)/wall-board.stl \
	$(BOOTH)/wall-screen-l.stl \
	$(BOOTH)/wall-screen-r.stl \
	$(BOOTH)/wall-plain.stl \
	$(BOOTH)/floor-tile-wall.stl \
	$(BOOTH)/floor-tile-corner.stl \
	$(BOOTH)/podium.stl \
	$(BOOTH)/stage.stl \
	$(BOOTH)/wall-foot.stl \
	$(BOOTH)/stand-clips.stl

$(BOOTH)/wall-plain.stl: booth/wall_panel.scad $(COMMON)
	$(OPENSCAD) -D 'variant="plain"' -o $@ $<
$(BOOTH)/wall-screen-l.stl: booth/wall_panel.scad $(COMMON)
	$(OPENSCAD) -D 'variant="screen-l"' -o $@ $<
$(BOOTH)/wall-screen-r.stl: booth/wall_panel.scad $(COMMON)
	$(OPENSCAD) -D 'variant="screen-r"' -o $@ $<
$(BOOTH)/floor-tile-wall.stl: booth/floor_tile.scad $(COMMON)
	$(OPENSCAD) -D 'variant="wall"' -o $@ $<
$(BOOTH)/floor-tile-corner.stl: booth/floor_tile.scad $(COMMON)
	$(OPENSCAD) -D 'variant="corner"' -o $@ $<
$(BOOTH)/wall-foot.stl: booth/wall_foot.scad $(COMMON)
	$(OPENSCAD) -o $@ $<

$(BOOTH)/wall-screen.stl: booth/wall_panel.scad $(COMMON)
	$(OPENSCAD) -D 'variant="screen"' -o $@ $<
$(BOOTH)/podium.stl: booth/lt_podium.scad $(COMMON)
	$(OPENSCAD) -D 'PART="podium"' -o $@ $<
$(BOOTH)/stage.stl: booth/lt_podium.scad $(COMMON)
	$(OPENSCAD) -D 'PART="stage"' -o $@ $<

MINI_STL := \
	$(MINI)/mini-adapter-atomcat.stl \
	$(MINI)/mini-adapter-minimal.stl

.PHONY: all ferris booth mini check clean dirs joint-test fit-test
fit-test: dirs $(FERRIS)/fittest-rim.stl $(FERRIS)/fittest-floor.stl $(FERRIS)/fittest-bridge.stl $(FERRIS)/fittest-hubcore.stl $(FERRIS)/fittest-crankboss.stl
joint-check: dirs $(FERRIS)/fittest-towerfoot.stl $(FERRIS)/fittest-baseslot.stl $(FERRIS)/fittest-splicelower.stl $(FERRIS)/fittest-spliceupper.stl $(FERRIS)/fittest-spokehub.stl $(FERRIS)/fittest-spokepad.stl

$(FERRIS)/fittest-towerfoot.stl: ferris/fit_test_kit.scad ferris/tower.scad $(COMMON)
	$(OPENSCAD) -D 'PART="towerfoot"' -o $@ $<
$(FERRIS)/fittest-baseslot.stl: ferris/fit_test_kit.scad ferris/base.scad $(COMMON)
	$(OPENSCAD) -D 'PART="baseslot"' -o $@ $<
$(FERRIS)/fittest-splicelower.stl: ferris/fit_test_kit.scad ferris/tower.scad $(COMMON)
	$(OPENSCAD) -D 'PART="splicelower"' -o $@ $<
$(FERRIS)/fittest-spliceupper.stl: ferris/fit_test_kit.scad ferris/tower.scad $(COMMON)
	$(OPENSCAD) -D 'PART="spliceupper"' -o $@ $<
$(FERRIS)/fittest-spokehub.stl: ferris/fit_test_kit.scad ferris/hub.scad $(COMMON)
	$(OPENSCAD) -D 'PART="spokehub"' -o $@ $<
$(FERRIS)/fittest-spokepad.stl: ferris/fit_test_kit.scad ferris/rim_segment.scad $(COMMON)
	$(OPENSCAD) -D 'PART="spokepad"' -o $@ $<
joint-test: dirs $(FERRIS)/joint-test-a.stl $(FERRIS)/joint-test-b.stl

all: ferris booth mini
ferris: dirs $(FERRIS_STL)
booth: dirs $(BOOTH_STL)
mini: dirs $(MINI_STL)

dirs:
	@mkdir -p $(FERRIS) $(BOOTH) $(MINI)

# --- mini ferris adapter --------------------------------------------------
$(MINI)/mini-adapter-atomcat.stl: mini/adapter_gondola.scad $(COMMON)
	$(OPENSCAD) -D 'variant="atomcat"' -o $@ $<
$(MINI)/mini-adapter-minimal.stl: mini/adapter_gondola.scad $(COMMON)
	$(OPENSCAD) -D 'variant="minimal"' -o $@ $<

$(FERRIS)/joint-test-a.stl: ferris/joint_test_a.scad ferris/rim_segment.scad $(COMMON)
	$(OPENSCAD) -o $@ $<

$(FERRIS)/joint-test-b.stl: ferris/joint_test_b.scad ferris/rim_segment.scad $(COMMON)
	$(OPENSCAD) -o $@ $<

$(FERRIS)/fittest-hubcore.stl: ferris/fit_test_kit.scad ferris/hub.scad $(COMMON)
	$(OPENSCAD) -D 'PART="hubcore"' -o $@ $<

$(FERRIS)/fittest-crankboss.stl: ferris/fit_test_kit.scad ferris/crank.scad $(COMMON)
	$(OPENSCAD) -D 'PART="crankboss"' -o $@ $<

$(FERRIS)/fittest-rim.stl: ferris/fit_test_kit.scad ferris/rim_segment.scad ferris/gondola.scad $(COMMON)
	$(OPENSCAD) -D 'PART="rim"' -o $@ $<

$(FERRIS)/fittest-floor.stl: ferris/fit_test_kit.scad ferris/rim_segment.scad ferris/gondola.scad $(COMMON)
	$(OPENSCAD) -D 'PART="floor"' -o $@ $<

$(FERRIS)/fittest-bridge.stl: ferris/fit_test_kit.scad ferris/rim_segment.scad ferris/gondola.scad $(COMMON)
	$(OPENSCAD) -D 'PART="bridge"' -o $@ $<

# --- swing test rig (pre-hardware bench test) ------------------------------
RIG_STL := \
	$(FERRIS)/rig-disc.stl \
	$(FERRIS)/rig-shaft.stl \
	$(FERRIS)/rig-stand.stl \
	$(FERRIS)/rig-base.stl

.PHONY: swing-test
swing-test: dirs $(RIG_STL) $(FERRIS)/rig-bearing.stl

$(FERRIS)/rig-disc.stl: ferris/swing_test_rig.scad $(COMMON)
	$(OPENSCAD) -D 'PART="disc"' -o $@ $<
$(FERRIS)/rig-shaft.stl: ferris/swing_test_rig.scad $(COMMON)
	$(OPENSCAD) -D 'PART="shaft"' -o $@ $<
$(FERRIS)/rig-bearing.stl: ferris/swing_test_rig.scad $(COMMON)
	$(OPENSCAD) -D 'PART="bearing"' -o $@ $<

$(FERRIS)/rig-stand.stl: ferris/swing_test_rig.scad $(COMMON)
	$(OPENSCAD) -D 'PART="stand"' -o $@ $<
$(FERRIS)/rig-base.stl: ferris/swing_test_rig.scad $(COMMON)
	$(OPENSCAD) -D 'PART="base"' -o $@ $<

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
$(FERRIS)/base-mini.stl: ferris/base_mini.scad $(COMMON)
	$(OPENSCAD) -o $@ $<
$(FERRIS)/crank.stl: ferris/crank.scad $(COMMON)
	$(OPENSCAD) -o $@ $<
$(FERRIS)/axle.stl: ferris/axle.scad $(COMMON)
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

# --- assembly viewer models (positioned, lightweight binary STL) ----------
VIEWER       := ../docs/public/models/ferris
VIEWER_PARTS := base tower-front tower-rear shaft hubs rim-front rim-rear \
                diffusers axles gondola-1 gondola-2 gondola-3 gondola-4 crank stackchan

.PHONY: viewer-models
viewer-models:
	@mkdir -p $(VIEWER)
	@for p in $(VIEWER_PARTS); do \
	  echo "  viewer $$p"; \
	  $(OPENSCAD) -D '$$fn=40' -D "PART=\"$$p\"" --export-format binstl \
	    -o $(VIEWER)/$$p.stl ferris/assembly.scad 2>/dev/null || exit 1; \
	done
	@ls -l $(VIEWER)/*.stl | awk '{printf "  %-28s %8.1f KB\n", $$9, $$5/1024}'

BOOTH_VIEWER := ../docs/public/models/booth
BOOTH_VIEWER_PARTS := floor stage podium robot screen-l screen-r plain-walls window-walls

viewer-models-booth:
	@mkdir -p $(BOOTH_VIEWER)
	@for p in $(BOOTH_VIEWER_PARTS); do \
	  echo "  viewer $$p"; \
	  $(OPENSCAD) -D '$$fn=40' -D "PART=\"$$p\"" --export-format binstl \
	    -o $(BOOTH_VIEWER)/$$p.stl booth/assembly.scad 2>/dev/null || exit 1; \
	done
	@ls -l $(BOOTH_VIEWER)/*.stl | awk '{printf "  %-28s %8.1f KB\n", $$9, $$5/1024}'

# --- checks / cleanup -----------------------------------------------------
check: all swing-test
	python3 check_dims.py $(OUT)

clean:
	rm -f $(FERRIS_STL) $(BOOTH_STL) $(MINI_STL) $(RIG_STL)
