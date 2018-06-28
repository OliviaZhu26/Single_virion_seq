<strong>BAsE-Seq Pipeline 1.0</strong>

The prototype pipeline described here processes BAsE-Seq raw reads into long single-virion haplotypes, and was developed as a joint effort between the Institute of Molecular and Cell Biology, Singapore (IMCB) and Genome Institute of Singapore (GIS). Initially developed by Lewis HONG and reformatted by ZHU O. Yuan. Built on HBV sequencing data. Not tested on other species.  


<strong>How to Run</strong>


Create individual folders for each sample. 


1. Run reference genome picker from within sample folder. This is an optional step written to identify closest HBV genotype for each sample. Skip this if an appropriate reference is known.

    command: ./00_refPick.sh fastq_file.list ref_genomes.list data_directory/ scripts_directory

    fastq_file.list should have each fastq file name on a new line. ref_genomes.list should have each reference fasta on a new line. Output file 02_mismatches.txt summarizes % mismatches to each reference tested. Output file 03_best_match_chroms.txt contains a single line for best match reference genotype. For input and output file formats as well as intermediate files created refer to 00_refPick.sh script. 
    

2. Run BAsE-Seq aligner. (Using closest Genotype as identified above.)

    command: ./01_BAsE_seq_alignment.sh parameter_file.txt

    QC plots generated can be used to gauge library quality such as overall per base coverage and number of genomes with %bases covered to 4x. Adjust variables for the next step as required. 


3. Run BAsE-Seq haplotype caller

    command: ./Base_seq_haplotype.sh 4 50 59 3198 3215 1 1500
    

4. Convert haplotypes into a bam file for downstream variant calling (optional)

    commands: bwasw/graphmap haplotype reads to reference  
              (edit sam files so all haplotypes map to position 1 of reference with no indels)  
              perl correct_sam.pl haplotype.sam haplotype_corrected.sam


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
    "Single-Virion Sequencing Of Lamivudine Treated HBV Populations Reveal Population Evolution Dynamics And Demographic History" (under review in BMC Genomics)   
    An early draft was uploaded at: http://www.biorxiv.org/content/early/2017/04/20/129023 

The following Colleagues also provided valuable feedback and input into the pipeline.  
Andreas WILM (GIS)  
Niranjan NAGARAJAN (GIS)  
Chenhao LI (GIS)  


<strong>License</strong>

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
