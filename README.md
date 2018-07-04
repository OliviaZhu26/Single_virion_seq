<strong>BAsE-Seq Pipeline 1.0</strong>

The prototype pipeline described here processes BAsE-Seq raw reads into long single-virion haplotypes, and was developed as a joint effort between the Institute of Molecular and Cell Biology, Singapore (IMCB) and Genome Institute of Singapore (GIS). Initially developed by Lewis HONG and reformatted by ZHU O. Yuan, it was built on HBV BAsE-Seq data for a small exploratory cohort. Not tested on other species. Not optimized for speed or memory usage. Use with caution. Data in the form of raw fastq reads is available from https://www.ncbi.nlm.nih.gov/bioproject/407696. For information on the samples and how they were generated please refer to https://www.ncbi.nlm.nih.gov/pubmed/25406369 and https://www.ncbi.nlm.nih.gov/pubmed/29078745.


<strong>How to Run</strong>


Create individual folders for each sample. 


1. Run reference genome picker from within sample folder. This is an optional step written to identify closest HBV genotype for each sample. Skip this if an appropriate reference is known.

    command: 00_refPick.sh fastq_file.list ref_genomes.list data_directory/ scripts_directory

    fastq_file.list should have each fastq file name on a new line. ref_genomes.list should have each reference fasta on a new line. Output file 02_mismatches.txt summarizes % mismatches to each reference tested. Output file 03_best_match_chroms.txt contains a single line for best match reference genotype. For input and output file formats as well as intermediate files created refer to 00_refPick.sh script. 
    

2. Run BAsE-Seq aligner.

    command: 01_BAsE_seq_alignment.sh parameter_file.txt

    QC plots generated can be used to gauge library quality such as overall per base coverage and number of genomes with %bases covered to 4x. Adjust min_cov and min_percent_cov variables for the next step as required. 


3. Run BAsE-Seq haplotype caller
    command: 02_Base_seq_haplotype.sh min_cov min_percent_cov start_pos end_pos length
    
4. Final file ConsensusSeqs.txt contains consensus sequences for all barcodes that passed quality filters. Ready for downstream analysis. 


<strong>Prerequisites</strong>

<p>This pipeline calls on:</p>
<ul>
<li>Perl</li>
<li>Trimmomatic-0.30</li>
<li>fastx_clipper</li>
<li>bwa</li>
<li>samtools</li>
<li>Picard Tools</li>
<li>GATK</li>
<li>LoFreq</li>
<li>R</li>
</ul>

<strong>Accompanying Scripts</strong>

<p>This pipeline also calls on the following scripts:</p>
<ul>
<li>01_chrom_select_variants.pl</li>
<li>02_chrom_select_out.pl</li>
<li>fastx_clipper</li>
<li>bwa</li>
<li>samtools</li>
<li>Picard Tools</li>
<li>GATK</li>
<li>LoFreq</li>
<li>R</li>
</ul>

Replace or update each component as required. 


<strong>Authors</strong>

Lewis HONG wrote the original scripts as described in the publication  
    "BAsE-Seq: a method for obtaining long viral haplotypes from short sequence reads"  
    https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0517-9


Yuan O. ZHU modified and rewrote parts of the scripts as described in the publication  
    "Single-Virion Sequencing Of Lamivudine Treated HBV Populations Reveal Population Evolution Dynamics And Demographic History" 
    https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-017-4217-1

The following Colleagues also provided valuable feedback and input into the pipeline.  
Andreas WILM (GIS)  
Niranjan NAGARAJAN (GIS)  
Chenhao LI (GIS)  


<strong>License</strong>

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
