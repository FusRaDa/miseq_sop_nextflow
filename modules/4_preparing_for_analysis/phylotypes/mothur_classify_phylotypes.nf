// This process processes files from MOTHUR_REMOVE_MOCK_SAMPLES and MOTHUR_PHYLOTYPE
// Identify OTUs based on phylotypes

// Files processed:
// final.count_table
// final.taxonomy
// final.tx.list

// To produce files:



process MOTHUR_CLASSIFY_PHYLOTYPES{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results/4_preparing_for_analysis/phylotypes', mode: 'symlink'

    input:
        path input_done_1
        path input_done_2

    output:
        path "final*", emit: fin

    script:
    """
    #!/bin/bash
    cp -a ${input_done_1}/. .
    cp -a ${input_done_2}/. .
    mothur "#classify.otu(list=final.tx.list, count=final.count_table, taxonomy=final.taxonomy, label=1)"
    """
}