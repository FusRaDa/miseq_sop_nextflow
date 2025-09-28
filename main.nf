#!/usr/bin/env nextflow


// Module imports
include { MOTHUR_MAKE_FILE } from "./modules/mothur_make_file.nf"
include { MOTHUR_MAKE_CONTIGS } from "./modules/mothur_make_contigs.nf"
include { MOTHUR_SUMMARY_SCREEN_SEQS } from "./modules/mothur_summary_screen_seqs.nf"
include { MOTHUR_UNIQUE_SEQS } from './modules/mothur_unique_seqs.nf'
include { MOTHUR_PCR_SEQS } from './modules/mothur_pcr_seqs.nf'
include { MOTHUR_ALIGN_SCREEN_SEQS } from './modules/mothur_align_screen_seqs.nf'
include { MOTHUR_FILTER_UNIQUE_SEQS } from './modules/mothur_filter_unique_seqs.nf'
include { MOTHER_PRE_CLUSTER } from './modules/mothur_pre_cluster.nf'
include { MOTHUR_CHIMERA_VSEARCH } from './modules/mothur_chimera_vsearch.nf'
include { MOTHUR_CLASSIFY } from './modules/mothur_classify.nf'
include { MOTHUR_REMOVE_LINEAGE } from './modules/mothur_remove_lineage.nf'


// Primary inputs
params.data_dir = 'data/MiSeq_SOP'
params.ref_file = 'data/silva.bacteria/silva.bacteria/silva.bacteria.fasta'
params.train_dir = 'data/trainset9_032012.pds'


workflow {
    // Channel data/input directory
    data_ch = Channel.fromPath(params.data_dir)

    /*** REDUCING SEQUENCING & PCR ERRORS ***/
    // Create stability.files from fastq files in directory MiSeq_SOP
    MOTHUR_MAKE_FILE(data_ch)

    // Process stability files
    MOTHUR_MAKE_CONTIGS(MOTHUR_MAKE_FILE.out.stability, data_ch)

    // Summary and screen (cleaning) of contig sequences
    MOTHUR_SUMMARY_SCREEN_SEQS(MOTHUR_MAKE_CONTIGS.out.stability)
    /*** REDUCING SEQUENCING & PCR ERRORS ***/


    /*** PROCESSING IMPROVED SEQUENCES ***/
    // Remove duplicate sequences
    MOTHUR_UNIQUE_SEQS(MOTHUR_SUMMARY_SCREEN_SEQS.out.stability)

    // Channel from reference alignment file; Align unique sequences to ref alignments
    ref_ch = Channel.fromPath(params.ref_file)
    MOTHUR_PCR_SEQS(MOTHUR_UNIQUE_SEQS.out.stability, ref_ch)

    // Align sequences to customized reference that will also save storage space
    MOTHUR_ALIGN_SCREEN_SEQS(MOTHUR_PCR_SEQS.out.silva, MOTHUR_UNIQUE_SEQS.out.stability)

    // Select the sequences overlapping the v4 region and remove character gaps
    MOTHUR_FILTER_UNIQUE_SEQS(MOTHUR_ALIGN_SCREEN_SEQS.out.stability)

    // Pre-cluster sequences - de-noise
    MOTHER_PRE_CLUSTER(MOTHUR_FILTER_UNIQUE_SEQS.out.stability)

    // Remove chimeras with vsearch algo (heuristic) - do results differ??
    MOTHUR_CHIMERA_VSEARCH(MOTHER_PRE_CLUSTER.out.stability)

    // Classify sequences with Bayesian classifier
    train_ch = Channel.fromPath(params.train_dir)
    MOTHUR_CLASSIFY(MOTHUR_CHIMERA_VSEARCH.out.stability, train_ch)

    // Remove lineage/undesirables and summarize taxonomy
    MOTHUR_REMOVE_LINEAGE(MOTHUR_CLASSIFY.out.stability, MOTHUR_CHIMERA_VSEARCH.out.stability)
    /*** PROCESSING IMPROVED SEQUENCES  ***/


    /* ASSESSING ERROR RATES */
    /* ASSESSING ERROR RATES */
}