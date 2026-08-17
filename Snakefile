configfile: "config.yaml"


rule hisat2:
    input:
        r1="data/trimmed/sample_R1_trimmed.fastq",
        r2="data/trimmed/sample_R2_trimmed.fastq",
        index="genome/hisat2_index/grch38/genome.1.ht2"

    output:
        bam="results/hisat2/sample_Aligned.sortedByCoord.out.bam",
        log="results/hisat2/sample_Log.final.out"

    threads:
        config["threads"]

    params:
        index="genome/hisat2_index/grch38/genome"

    shell:
        """
        mkdir -p results/hisat2

        set -o pipefail

        hisat2 \
            -p {threads} \
            -x {params.index} \
            -1 {input.r1} \
            -2 {input.r2} \
            2> {output.log} \
        | samtools sort \
            -@ {threads} \
            -o {output.bam} \
            -
        """


rule samtools_index:
    input:
        bam="results/hisat2/sample_Aligned.sortedByCoord.out.bam"

    output:
        bai="results/hisat2/sample_Aligned.sortedByCoord.out.bam.bai"

    shell:
        """
        samtools index {input.bam}
        """
