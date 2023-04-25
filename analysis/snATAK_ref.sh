#!/bin/bash

usage () {
    echo "Usage: $0 [options]
    
    Options:
    -o, --output
    -g, --genome
    -m, --mmi
    -c, --cbfastq
    -1, --r1fastq
    -2, --r2fastq
    "
    exit 1
}

while getopts ":o:m:g:c:1:2:" opt; do
    case $opt in
        o|--output)
            OUTPUT=$OPTARG
            ;;
        m|--m)
            MMI=$OPTARG
            ;;
        g|--genome)
            GENOME=$OPTARG
            ;;
        c|--cbfastq)
            CBFQ=$OPTARG
            ;;
        1|--r1fastq)
            R1FQ=$OPTARG
            ;;
        2|--r2fastq)
            R2FQ=$OPTARG
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid argument"
            usage
            ;;
        :)
            echo "Add arguments"
            usage
            ;;
    esac
done

echo "Output: $OUTPUT"
echo "Genome: $GENOME"
echo "MMI: $MMI"
echo "CB fastq: $CBFQ"
echo "R1 fastq: $R1FQ"
echo "R2 fastq: $R2FQ"


# check options        
if [ -z "$OUTPUT" -o -z "$GENOME" -o -z "$MMI" -o -z "$CBFQ" -o -z "$R1FQ" -o -z "$R2FQ" ]
then
    echo "Error"
    usage
fi


minimap2 -o genome.sam -a -x sr -t 32 $MMI $R1FQ $R2FQ

samtools view -@ 8 -o genome.u.bam -b genome.sam
samtools sort -@ 8 -o genome.bam -n -m 8G genome.u.bam
# rm genome.sam
# mv genome.sorted.bam genome.bam
Genrich -t genome.bam -o genome.bed -f genome_peaks.log -v
cat genome.bed | bedtools sort | bedtools merge > peaks.bed
bedtools getfasta -fi $GENOME -bed peaks.bed -fo peaks.fa
cat peaks.fa | awk '{if($1~/>/)print $1"\t"$1"\t"$1}' > t2g.txt
sed -i 's/>//g' t2g.txt

kallisto index -i peaks.idx peaks.fa

# rm genome.sam genome.u.bam 

# # Quantify
# kb count \
# -i peaks.idx \
# -g t2g.txt \
# -x $TECH \
# -o $OUTPUT \
# -w $WL \
# $CBFQ $R1FQ $R2FQ
# mkdir -p $OUTPUT/counts_mult
# bustools count -o $OUTPUT/counts_mult/cells_x_genes -g t2g.txt -e $OUTPUT/matrix.ec -t $OUTPUT/transcripts.txt --genecounts --cm $OUTPUT/output.unfiltered.bus
