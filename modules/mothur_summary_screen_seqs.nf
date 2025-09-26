// This process processes files from MOTHUR_MAKE_CONTIGS
// Filter contig sequences that are more 275 bp long
// Files processed:
// stability.trim.contigs.fasta
// stability.contigs.count_table
// To produce files:
// stability.trim.contigs.good.fasta
// stability.trim.contigs.bad.accnos
// stability.contigs.good.count_table

process MOTHUR_SUMMARY_SCREEN_SEQS{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results', mode: 'copy'

    input:
        path input_dir

    output:
        path "${input_dir}/stability*"
        path "${input_dir.name}", emit: dir

    script:
    """
    #!/bin/bash
    cd ${input_dir}
    mothur "#summary.seqs(fasta=stability.trim.contigs.fasta, count=stability.contigs.count_table)"
    mothur "#screen.seqs(fasta=stability.trim.contigs.fasta, count=stability.contigs.count_table, maxambig=0, maxlength=275, maxhomop=8)"
    """
}