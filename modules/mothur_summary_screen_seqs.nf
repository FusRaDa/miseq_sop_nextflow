// This process processes files from MOTHUR_MAKE_CONTIGS
// Filter contig sequences that are more 275 bp 

// Files processed:
// stability.trim.contigs.fasta
// stability.contigs.count_table

// To produce files:
// stability.trim.contigs.good.fasta
// stability.trim.contigs.bad.accnos
// stability.contigs.good.count_table


process MOTHUR_SUMMARY_SCREEN_SEQS{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results', mode: 'symlink'

    input:
        path input_done
        path input_dir

    output:
        path "stability*", emit: done

    script:
    """
    #!/bin/bash
    cp -a ${input_dir}/. .
    cp -a ${input_done}/. .
    mothur "#summary.seqs(fasta=stability.trim.contigs.fasta, count=stability.contigs.count_table)"
    mothur "#screen.seqs(fasta=stability.trim.contigs.fasta, count=stability.contigs.count_table, maxambig=0, maxlength=275, maxhomop=8)"
    """
}