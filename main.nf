#!/usr/bin/env nextflow


// Module imports
include { MOTHUR_MAKE_FILE } from "./modules/getting_started/mothur_make_file.nf"

include { MOTHUR_MAKE_CONTIGS } from "./modules/reducing_seq_pcr_errors/mothur_make_contigs.nf"
include { MOTHUR_SUMMARY_SCREEN_SEQS } from "./modules/reducing_seq_pcr_errors/mothur_summary_screen_seqs.nf"

include { MOTHUR_UNIQUE_SEQS } from './modules/processing_improved_seq/mothur_unique_seqs.nf'
include { MOTHUR_PCR_SEQS } from './modules/processing_improved_seq/mothur_pcr_seqs.nf'
include { MOTHUR_ALIGN_SCREEN_SEQS } from './modules/processing_improved_seq/mothur_align_screen_seqs.nf'
include { MOTHUR_FILTER_UNIQUE_SEQS } from './modules/processing_improved_seq/mothur_filter_unique_seqs.nf'
include { MOTHER_PRE_CLUSTER } from './modules/processing_improved_seq/mothur_pre_cluster.nf'
include { MOTHUR_CHIMERA_VSEARCH } from './modules/processing_improved_seq/mothur_chimera_vsearch.nf'
include { MOTHUR_CLASSIFY } from './modules/processing_improved_seq/mothur_classify.nf'
include { MOTHUR_REMOVE_LINEAGE } from './modules/processing_improved_seq/mothur_remove_lineage.nf'

include { MOTHUR_GET_GROUPS } from './modules/assessing_err_rates/mothur_get_groups.nf'
include { MOTHUR_SEQ_ERROR } from './modules/assessing_err_rates/mothur_seq_error.nf'
include { MOTHUR_SEQ_OTU } from './modules/assessing_err_rates/mothur_seq_otu.nf'

include { MOTHUR_REMOVE_MOCK_SAMPLES } from './modules/preparing_for_analysis/mothur_remove_mock_samples.nf'
include { MOTHUR_CLUSTER_OTU } from './modules/preparing_for_analysis/mothur_cluster_otu.nf'


// Primary inputs
params.data_dir = 'data/MiSeq_SOP'
params.ref_file = 'data/silva.bacteria/silva.bacteria/silva.bacteria.fasta'
params.train_dir = 'data/trainset9_032012.pds'


workflow {
    // Channel data/input directory
    data_ch = Channel.fromPath(params.data_dir)

    /*** GETTING STARTED ***/
    // Create stability.files from fastq files in directory MiSeq_SOP
    MOTHUR_MAKE_FILE(data_ch)
    /*** GETTING STARTED ***/


    /*** REDUCING SEQUENCING & PCR ERRORS ***/
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


    /*** ASSESSING ERROR RATES ***/
    // Measure error rates using mock data
    MOTHUR_GET_GROUPS(MOTHUR_REMOVE_LINEAGE.out.stability, data_ch)

    // Get error rates
    MOTHUR_SEQ_ERROR(MOTHUR_GET_GROUPS.out.stability, data_ch)

    // Cluster sequences into OTU's
    MOTHUR_SEQ_OTU(MOTHUR_GET_GROUPS.out.stability, data_ch)
    /*** ASSESSING ERROR RATES ***/


    /*** PREPARING FOR ANALYSIS ***/
    // Remove mock samples/groups
    MOTHUR_REMOVE_MOCK_SAMPLES(MOTHUR_REMOVE_LINEAGE.out.stability)

    //Cluster sequences into OTU's - do results differ?? 
    MOTHUR_CLUSTER_OTU(MOTHUR_REMOVE_MOCK_SAMPLES.out.fin)

    /*** PREPARING FOR ANALYSIS ***/
}