#!/usr/bin/env nextflow


// Module imports
include { MOTHUR_MAKE_FILE } from "./modules/mothur_make_file.nf"
include { MOTHUR_MAKE_CONTIGS } from "./modules/mothur_make_contigs.nf"
include { MOTHUR_SUMMARY_SCREEN_SEQS } from "./modules/mothur_summary_screen_seqs.nf"
include { MOTHUR_UNIQUE_SEQS } from './modules/mothur_unique_seqs.nf'
include { MOTHUR_PCR_SEQS } from './modules/mothur_pcr_seqs.nf'


// Primary inputs
params.input_dir = 'data/MiSeq_SOP'
params.ref_file = 'data/silva.bacteria/silva.bacteria/silva.bacteria.fasta'


workflow {
    dir_ch = Channel.fromPath(params.input_dir)

    // Create stability.files from fastq files in directory MiSeq_SOP
    MOTHUR_MAKE_FILE(dir_ch)

    // Process stability files
    MOTHUR_MAKE_CONTIGS(MOTHUR_MAKE_FILE.out.dir)

    // Summary and screen (cleaning) of contig sequences
    MOTHUR_SUMMARY_SCREEN_SEQS(MOTHUR_MAKE_CONTIGS.out.dir)

    // Remove duplicate sequences
    MOTHUR_UNIQUE_SEQS(MOTHUR_SUMMARY_SCREEN_SEQS.out.dir)

    ref_ch = Channel.fromPath(params.ref_file)

    // Align unique sequences to ref alignments
    MOTHUR_PCR_SEQS(MOTHUR_UNIQUE_SEQS.out.dir, ref_ch)


}