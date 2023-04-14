kb ref -i index.idx -g t2g.txt -f1 transcriptome.fa $(gget ref -r 104 -w dna,gtf homo_sapiens | jq -r '.homo_sapiens | to_entries[] | .value.ftp' | tr '\n' ' ')


