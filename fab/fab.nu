#!/usr/bin/env nu

const proj = "uswc"
const bom_file = $"fab/($proj)-bom.csv"
const pos_file = $"fab/($proj)-pos-all.csv"
const sch_file = $"($proj).kicad_sch"
const pcb_file = $"($proj).kicad_pcb"

^kicad-cli sch export bom -o $bom_file --fields 'Value,Reference,Footprint,LCSC#' --labels 'Comment,Designator,Footprint,LCSC Part Number' $sch_file
^kicad-cli pcb export pos -o $pos_file --format csv --side front --units mm $pcb_file
open $pos_file | rename Designator Val Package 'Mid X' 'Mid Y' Rotation Layer | save -f $pos_file
^kicad-cli pcb export gerbers -o fab/ --board-plot-params $pcb_file
^kicad-cli pcb export drill --excellon-separate-th -o fab/ $pcb_file
^zip -r $"fab/($proj).zip" . -i $"fab/($proj)*.gbr" $"fab/($proj)*.drl"
