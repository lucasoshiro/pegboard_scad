OPENSCAD=openscad
STL_DIR=stl
SCAD_DIR=scad

.PHONY: all
all: pliers_holder bin open_bin hammer_holder open_front_bin

.PRECIOUS: $(STL_DIR)/%.stl

.PHONY: clean
clean:
	rm -f stl/*.stl

$(STL_DIR)/%.stl: ${SCAD_DIR}/parameters_pegboard.scad ${SCAD_DIR}/pegboard.scad ${SCAD_DIR}/parameters_%.scad ${SCAD_DIR}/%.scad
	${OPENSCAD} -q ${SCAD_DIR}/$(notdir $(basename $@)).scad -o $@

.PHONY: %
%: $(STL_DIR)/%.stl
	true

