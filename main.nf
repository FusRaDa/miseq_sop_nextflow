#!/usr/bin/env nextflow


// Module imports
include { MOTHUR_MAKE_FILE } from "./modules/mothur_make_file.nf"
include { MOTHUR_MAKE_CONTIGS } from "./modules/mothur_make_contigs.nf"
include { MOTHUR_SUMMARY_SCREEN_SEQS } from "./modules/mothur_summary_screen_seqs.nf"
include { MOTHUR_UNIQUE_SEQS } from './modules/mothur_unique_seqs.nf'
include { MOTHUR_PCR_SEQS } from './modules/mothur_pcr_seqs.nf'


// Primary inputs
params.data_dir = 'data/MiSeq_SOP'
params.results_dir = 'results'
params.ref_file = 'data/silva.bacteria/silva.bacteria/silva.bacteria.fasta'


workflow {
    // Channel data/input directory
    data_ch = Channel.fromPath(params.data_dir)

    // Create stability.files from fastq files in directory MiSeq_SOP
    MOTHUR_MAKE_FILE(data_ch)

    // Process stability files
    MOTHUR_MAKE_CONTIGS(MOTHUR_MAKE_FILE.out.done, data_ch)

    // Summary and screen (cleaning) of contig sequences
    MOTHUR_SUMMARY_SCREEN_SEQS(MOTHUR_MAKE_CONTIGS.out.done, data_ch)

    // Remove duplicate sequences
    MOTHUR_UNIQUE_SEQS(MOTHUR_SUMMARY_SCREEN_SEQS.out.done, data_ch)

    ref_ch = Channel.fromPath(params.ref_file)

    // Channel results directory
    // results_ch = Channel.fromPath(params.results_dir)

    // Align unique sequences to ref alignments
    MOTHUR_PCR_SEQS(MOTHUR_UNIQUE_SEQS.out.done, data_ch, ref_ch)

    //


}