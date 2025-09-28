// This process first performs make.file to produce stability.files
// Define what fastq files go together

// Directory processed:
// MiSeq_SOP

// Creates 4 new files: 
// stability.files


process MOTHUR_MAKE_FILE{
    container 'community.wave.seqera.io/library/mothur:1.48.3--8c30967de5ffe410'

    publishDir 'results/getting_started', mode: 'symlink'

    input:
        path input_dir

    output:
        path "stability*", emit: stability

    script:
    """
    #!/bin/bash
    cp -a ${input_dir}/. .
    mothur "#make.file(inputdir=., type=fastq, prefix=stability)"
    """
}