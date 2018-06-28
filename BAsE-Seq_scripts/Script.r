#!/usr/bin/Rscript

##Author: ZHU O. Yuan
##Script name: Script.r
##Generate 2 QC figures from output files of 01_BAsE-Seq_alignment.sh
##Run as: ./Script.r (from within sample folder)

#A plot of genome-wide coverage plots for the first 9 barcodes
#Check if coverage is even, if there are glaring patterns of uneveness
bc1<-read.table(file="IndividualGenomes/pileup/bc1_sorted.pileup",sep="\t",header=TRUE)
bc2<-read.table(file="IndividualGenomes/pileup/bc2_sorted.pileup",sep="\t",header=TRUE)
bc3<-read.table(file="IndividualGenomes/pileup/bc3_sorted.pileup",sep="\t",header=TRUE)
bc4<-read.table(file="IndividualGenomes/pileup/bc4_sorted.pileup",sep="\t",header=TRUE)
bc5<-read.table(file="IndividualGenomes/pileup/bc5_sorted.pileup",sep="\t",header=TRUE)
bc6<-read.table(file="IndividualGenomes/pileup/bc6_sorted.pileup",sep="\t",header=TRUE)
bc7<-read.table(file="IndividualGenomes/pileup/bc7_sorted.pileup",sep="\t",header=TRUE)
bc8<-read.table(file="IndividualGenomes/pileup/bc8_sorted.pileup",sep="\t",header=TRUE)
bc9<-read.table(file="IndividualGenomes/pileup/bc9_sorted.pileup",sep="\t",header=TRUE)
pdf("IndividualGenomes/First9_pileup_plots.2.pdf")
par(mfrow=c(3,3))
plot(bc1[,2],bc1[,4],xlim=c(0,3300),pch=20,main="bc1",xlab="HBV Genome",ylab="Coverage");abline(h=4)
plot(bc2[,2],bc2[,4],xlim=c(0,3300),pch=20,main="bc2",xlab="HBV Genome",ylab="Coverage");abline(h=4)
plot(bc3[,2],bc3[,4],xlim=c(0,3300),pch=20,main="bc3",xlab="HBV Genome",ylab="Coverage");abline(h=4)
plot(bc4[,2],bc4[,4],xlim=c(0,3300),pch=20,main="bc4",xlab="HBV Genome",ylab="Coverage");abline(h=4)
plot(bc5[,2],bc5[,4],xlim=c(0,3300),pch=20,main="bc5",xlab="HBV Genome",ylab="Coverage");abline(h=4)
plot(bc6[,2],bc6[,4],xlim=c(0,3300),pch=20,main="bc6",xlab="HBV Genome",ylab="Coverage");abline(h=4)
plot(bc7[,2],bc7[,4],xlim=c(0,3300),pch=20,main="bc7",xlab="HBV Genome",ylab="Coverage");abline(h=4)
plot(bc8[,2],bc8[,4],xlim=c(0,3300),pch=20,main="bc8",xlab="HBV Genome",ylab="Coverage");abline(h=4)
plot(bc9[,2],bc9[,4],xlim=c(0,3300),pch=20,main="bc9",xlab="HBV Genome",ylab="Coverage");abline(h=4)
dev.off()

#A QC plot with four panels
#Top left: Histogram of read pairs per barcode. X-read pairs per barcode. Y-frequency.
#Top right: Scatter plot of reads per barcode sorted in decreasing order. X-barcode. Y-reads per barcode. 
#Bottom left: Histogram of number of bases covered to 4x per barcode. X-number of bases >4x per barcode. Y-frequency. 
#Bottom right: Number of genomes with at least n bases covered. X-number of genomes. Y-number of bases covered.
#Use these figures to determine library quality and cutoff for the next step. 
pairs<-read.table("IndividualGenomes/ReadPairsPerSam.txt",sep=" ",header=FALSE)
cov<-read.table(file="IndividualGenomes/Cov_per_barcode_4.txt",sep="\t",header=FALSE)
pdf("IndividualGenomes/Barcodes_QC.pdf")
par(mfrow=c(2,2))
hist(as.numeric(pairs[,1]),breaks=100,xlab="Read Pairs per Barcode",main="Hist of Read Pairs per Barcode")
plot(sort(pairs[,1],decreasing=TRUE),xlab="Barcode Sorted by Decreasing Read Pairs",ylab="Read Pairs per Barcode",pch=20,main="Reads per Barcode Sorted Decreasing")
#plot(c(0,cumsum(sort(pairs[,1],decreasing=TRUE))),pch=20,xlab="Barcode Sorted by Decreasing Read Pairs",ylab="Cumulative Read Pairs",main="CDF of Reads per Barcode Sorted Decreasing")
hist(cov[,1],breaks=100,xlab="Bases of Barcode Covered",main="Coverage Distribution")
plot(sort(cov[,1],decreasing=TRUE),xlab="Number of Genomes",ylab="Read Pairs per Barcode Cutoff",pch=20,main="No. Genomes by Cov Cutoff")
dev.off()
