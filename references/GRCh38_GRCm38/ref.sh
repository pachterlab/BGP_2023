kb ref -i human.idx -g human.t2g.txt -f1 human.transcriptome.fa $(gget ref -r 109 -w dna,gtf mus_musculus | jq -r '.mus_musculus | to_entries[] | .value.ftp' | tr '\n' ' ')

kb ref -i mouse.idx -g mouse.t2g.txt -f1 mouse.transcriptome.fa $(gget ref -r 104 -w dna,gtf homo_sapiens | jq -r '.homo_sapiens | to_entries[] | .value.ftp' | tr '\n' ' ')

cat human.transcriptome.fa mouse.transcriptome.fa > human_mouse.transcriptome.fa
cat human.t2g.txt mouse.t2g.txt > human_mouse.t2g.txt

kallisto index -i human_mouse.idx human_mouse.transcriptome.fa
