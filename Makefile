OPENSCAD=openscad
STL_DIR=stl
SCAD_DIR=scad

.PHONY: all
all: pliers_holder bin open_bin hammer_holder open_front_bin soldering_iron_holder reel sample

.PRECIOUS: $(STL_DIR)/%.stl

.PHONY: clean
clean:
	rm -f stl/*.stl

$(STL_DIR)/%.stl: ${SCAD_DIR}/pegboard.scad ${SCAD_DIR}/%.scad
	${OPENSCAD} -q ${SCAD_DIR}/$(notdir $(basename $@)).scad -o $@

.PHONY: % thingiverse
%: $(STL_DIR)/%.stl
	echo -n

thingiverse:
	ruby rb/prepare_for_thingiverse.rb
