// This process processes files from MOTHUR_ALIGN_SCREEN_SEQS
// Filter for only the overlapping regions (within v4 within the 16s region?) 

// Files processed:
// stability.trim.contigs.good.unique.good.align,

// To produce files:
// stability.trim.contigs.good.unique.good.filter.fasta


process MOTHUR_FILTER_SEQS{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results', mode: 'symlink'

    input:
        path input_done

    output:
        path "stability*", emit: stability

    script:
    """
    #!/bin/bash
    cp -a ${input_done}/. .
    mothur "#filter.seqs(fasta=stability.trim.contigs.good.unique.good.align, vertical=T, trump=.)"
    """
}