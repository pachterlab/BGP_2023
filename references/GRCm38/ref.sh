kb ref -i index.idx -g t2g.txt -f1 transcriptome.fa $(gget ref -r 109 -w dna,gtf mus_musculus | jq -r '.mus_musculus | to_entries[] | .value.ftp' | tr '\n' ' ')


