// This process processes files from MOTHUR_UNIQUE_SEQS
// Align unique sequences to reference alignments silva.bacteria.fasta file - in the future run pipeline with multiple ref alignments!
// Rename silva.bacteria.pcr.fasta to silva.v4.fasta
// Summarize the alignments

// Files processed:
// stability.trim.contigs.good.unique.fasta
// silva.v4.fasta

// To produce files:


process MOTHUR_PCR_SEQS{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results', mode: 'symlink'

    input:
        path input_dir
        path ref_file

    output:
        path "${input_dir}/stability*"  
        path "${input_dir}/silva*"
        path "${input_dir.name}", emit: dir

    script:
    """
    #!/bin/bash
    cd ${input_dir}
    mothur "#align.seqs(fasta=stability.trim.contigs.good.unique.fasta, reference=silva.v4.fasta)"
    mothur "#summary.seqs(fasta=stability.trim.contigs.good.unique.align, count=stability.trim.contigs.good.count_table)"
    mothur "#screen.seqs(fasta=stability.trim.contigs.good.unique.align, count=stability.trim.contigs.good.count_table, start=1968, end=11550)"
    mothur "#summary.seqs(fasta=current, count=current)"
    """
}