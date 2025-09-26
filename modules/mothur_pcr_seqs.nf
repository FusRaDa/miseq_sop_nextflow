// This process processes files from MOTHUR_UNIQUE_SEQS
// Align unique sequences to reference alignments silva.bacteria.fasta file - in the future run pipeline with multiple ref alignments!
// Files processed:
// silva.bacteria.fasta
// To produce files:


process MOTHUR_PCR_SEQS{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results', mode: 'copy'

    input:
        path input_dir
        path ref_file

    output:
        path "${input_dir}/stability*"

    script:
    """
    #!/bin/bash
    cp ${ref_file} ${input_dir}
    cd ${input_dir}
    mothur "#pcr.seqs(fasta=${ref_file}, start=11895, end=25318, keepdots=F)"
    """
}