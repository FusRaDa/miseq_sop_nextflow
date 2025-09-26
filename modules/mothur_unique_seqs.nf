// This process processes files from MOTHUR_SUMMARY_SCREEN_SEQS
// Remove duplicate contigs and only keep the unique ones.
// Files processed:
// stability.trim.contigs.good.fasta
// stability.contigs.good.count_table
// To produce files:
// stability.trim.contigs.good.unique.fasta - primary file
// stability.trim.contigs.good.count_table


process MOTHUR_UNIQUE_SEQS{
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
    mothur "#unique.seqs(fasta=stability.trim.contigs.good.fasta, count=stability.contigs.good.count_table)"
    """
}