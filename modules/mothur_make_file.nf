// This process first performs make.file to produce stability.files
// Define what fastq files go together


process MOTHUR_MAKE_FILE{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results', mode: 'copy'

    input:
        path input_dir

    output:
        path "${input_dir.name}/stability.files"
        path "${input_dir.name}", emit: dir

    script:
    """
    #!/bin/bash
    mothur "#make.file(inputdir=${input_dir}, type=fastq, prefix=stability)"
    """
}