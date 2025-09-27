// This process processes files from MOTHUR_UNIQUE_SEQS
// Align unique sequences to reference alignments silva.bacteria.fasta file - in the future run pipeline with multiple ref alignments!
// Rename silva.bacteria.pcr.fasta to silva.v4.fasta
// Summarize the alignments

// Files processed:
// stability.trim.contigs.good.unique.fasta
// silva.v4.fasta

// To produce files:


process MOTHUR_ALIGN_SEQS{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results', mode: 'symlink'

    input:
        path input_done_silva
        path input_done_stability

    output:
        path "stability*"

    script:
    """
    #!/bin/bash
    cp -a ${input_done_silva}/. .
    cp -a ${input_done_stability}/. .
    mothur "#align.seqs(fasta=stability.trim.contigs.good.unique.fasta, reference=silva.v4.fasta)"
    mothur "#summary.seqs(fasta=stability.trim.contigs.good.unique.align, count=stability.trim.contigs.good.count_table)"
    """
}