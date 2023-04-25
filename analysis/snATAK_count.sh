#!/bin/bash

usage () {
    echo "Usage: $0 [options]
    
    Options:
    -o, --output
    -g, --t2g
    -i, --index
    -x, --technology
    -w, --whitelist
    -c, --cbfastq
    -1, --r1fastq
    -2, --r2fastq
    "
    exit 1
}

while getopts ":o:i:g:x:w:c:1:2:" opt; do
    case $opt in
        o|--output)
            OUTPUT=$OPTARG
            ;;
        i|--index)
            INDEX=$OPTARG
            ;;
        g|--t2g)
            T2G=$OPTARG
            ;;
        x|--technology)
            TECH=$OPTARG
            ;;
        w|--whitelist)
            WL=$OPTARG
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
echo "T2G:    $T2G"
echo "INDEX: $INDEX"
echo "Technology: $TECH"
echo "Whitelist: $WL"
echo "CB fastq: $CBFQ"
echo "R1 fastq: $R1FQ"
echo "R2 fastq: $R2FQ"


# check options        
if [ -z "$OUTPUT" -o -z "$INDEX" -o -z "$T2G" -o -z "$TECH" -o -z "$WL" -o -z "$CBFQ" -o -z "$R1FQ" -o -z "$R2FQ" ]
then
    echo "Error"
    usage
fi

# # Quantify
kb count \
-i $INDEX \
-g $T2G \
-x $TECH \
-o $OUTPUT \
-w $WL \
-t 8 \
-m 8G \
$CBFQ $R1FQ $R2FQ
mkdir -p $OUTPUT/counts_mult
bustools count -o $OUTPUT/counts_mult/cells_x_genes -g $T2G -e $OUTPUT/matrix.ec -t $OUTPUT/transcripts.txt --genecounts --cm $OUTPUT/output.unfiltered.bus
