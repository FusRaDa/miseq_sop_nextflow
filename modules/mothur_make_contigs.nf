// This process processes the stability.files from MOTHUR_MAKE_FILE
// Primarily to produce trimmed contigs and their count
// Creates 4 new files: 
// stability.trim.contigs.fasta
// stability.scrap.contigs.fasta
// stability.contigs_report
// stability.contigs.count_table


process MOTHUR_MAKE_CONTIGS{
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
    mothur "#make.contigs(file=stability.files)"
    """
}