# fifty-genomes
pipelines and scripts for processing the 50 genomes data for sadacc

## some edits to make:
* separate data processing from data summarising/reportingin workflows
* referenceFasta should have a more informative name, and use named keys not numbers to access files
* change the save/output steps such thatthey use publishDir + patterns
* *all* processes should use templates, i.e. follow the rule: 1 process = 1 template
* make all design decisions consistent across the repo
* simple descriptions of the workflow for humans to follow, inc dataflow diagrams
