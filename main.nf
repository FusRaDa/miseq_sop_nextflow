#!/usr/bin/env nextflow


// Module imports
include { MOTHUR_MAKE_FILE } from "./modules/mothur_make_file.nf"
include { MOTHUR_MAKE_CONTIGS } from "./modules/mothur_make_contigs.nf"
include { MOTHUR_SUMMARY_SCREEN_SEQS } from "./modules/mothur_summary_screen_seqs.nf"
include { MOTHUR_UNIQUE_SEQS } from './modules/mothur_unique_seqs.nf'
include { MOTHUR_PCR_SEQS } from './modules/mothur_pcr_seqs.nf'
include { MOTHUR_ALIGN_SCREEN_SEQS } from './modules/mothur_align_screen_seqs.nf'
include { MOTHUR_FILTER_SEQS } from './modules/mothur_filter_seqs.nf'


// Primary inputs
params.data_dir = 'data/MiSeq_SOP'
params.ref_file = 'data/silva.bacteria/silva.bacteria/silva.bacteria.fasta'


workflow {
    // Channel data/input directory
    data_ch = Channel.fromPath(params.data_dir)

    // Create stability.files from fastq files in directory MiSeq_SOP
    MOTHUR_MAKE_FILE(data_ch)

    // Process stability files
    MOTHUR_MAKE_CONTIGS(MOTHUR_MAKE_FILE.out.stability, data_ch)

    // Summary and screen (cleaning) of contig sequences
    MOTHUR_SUMMARY_SCREEN_SEQS(MOTHUR_MAKE_CONTIGS.out.stability)

    // Remove duplicate sequences
    MOTHUR_UNIQUE_SEQS(MOTHUR_SUMMARY_SCREEN_SEQS.out.stability)

    // Channel from reference alignment file; Align unique sequences to ref alignments
    ref_ch = Channel.fromPath(params.ref_file)
    MOTHUR_PCR_SEQS(MOTHUR_UNIQUE_SEQS.out.stability, ref_ch)

    // Align sequences to customized reference that will also save storage space
    MOTHUR_ALIGN_SCREEN_SEQS(MOTHUR_PCR_SEQS.out.silva, MOTHUR_UNIQUE_SEQS.out.stability)

    // Select the sequences overlapping the v4 region and remove character gaps
    MOTHUR_FILTER_SEQS(MOTHUR_ALIGN_SCREEN_SEQS.out.stability)
}