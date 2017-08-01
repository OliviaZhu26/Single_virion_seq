<strong>BAsE-Seq Pipeline</strong>

The pipeline described here processes BAsE-Seq raw reads into long single-virion haplotypes.


<strong>How to Run</strong>


Create individual folders for each sample. 

1. Run reference genome picker. (Skip this if you know which reference you need)

    command:



2. Run BAsE-Seq aligner.

    command: ./Base_seq_alignment.sh parameter_file.txt

    QC plots generated can be used to gauge library quality, and adjust variables for the next step as required. 



3. Run BAsE-Seq haplotype caller

    command: ./Base_seq_haplotype.sh 4 50 59 3198 3215 1 1500
    


<strong>Prerequisites</strong>

<p>This pipeline is dependent on:</p>
<ul>
<li>Perl</li>
<li>Trimmomatic-0.30</li>
<li>fastx_clipper</li>
<li>bwa</li>
<li>samtools</li>
<li>Picard Tools</li>
<li>GATK</li>
<li>R</li>
</ul>
Replace or update each component as required. 

<strong>Authors</strong>

Lewis Hong wrote the original scripts as described in the publication  
    BAsE-Seq: a method for obtaining long viral haplotypes from short sequence reads  
    https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0517-9


Yuan Zhu modified and rewrote part of the scripts as described in the publication  
    Single-Virion Sequencing Of Lamivudine Treated HBV Populations Reveal Population Evolution Dynamics And Demographic History (under review in BMC Genomics)   
    An earlier draft was uploaded at: http://www.biorxiv.org/content/early/2017/04/20/129023 


<strong>License</strong>

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


<strong>Acknowledgments</strong>

Andreas Wilm  
Niranjan Nagarajan
