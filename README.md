 # Post alignement

![Image PostAlign](https://github.com/ImaneLboukili/WGS_analysis/blob/master/PostAlign/PostAlign.png)

## Description

Perform a post alignement on aligned reads files.

## Dependencies
1. This pipeline is based on [nextflow](https://www.nextflow.io). As we have several nextflow pipelines, we have centralized the common information in the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository. Please read it carefully as it contains essential information for the installation, basic usage and configuration of nextflow and our pipelines.
2. sambamba : see official installation [here](http://lomereiter.github.io/sambamba/). You can avoid installing all the external software by only installing Docker (not available yet). See the[IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.)
3. bwakit : see official installation [here](https://github.com/lh3/bwa/tree/master/bwakit). You can avoid installing all the external software by only installing Docker (not available yet). See the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.)

## Input

**Name**         | **Description**
---------------  | ---------------
--input_folder   | Folder containing BAM files

## Parameters

* #### Mandatory
|**Name**          | **Example value** | **Description**
|------------------| ------------------| ------------------
|--postaltjs         | /bwakit/bin/bwa-postalt.js | Path to bwakit bwa-postalt.js javascript
|--refalt            | bwakit/resource-GRCh38/hs38DH.fa.alt | Path to alternative reference fasta file from bwakit


* #### Optional
 Name      | Default value | Description     |
|-----------|---------------|-----------------|
| --output_folder   |   .               | Output folder
| --cpu         | 10 | number of CPUs |
| --mem         | 20 | memory|


### Flags ###

Flags are special parameters without value.

**Name**      | **Description**
------------- | -------------
--help        | Display help

## Download test data set ###

`git clone https://github.com/iarcbioinfo/data_test`

## Usage ##

`nextflow run nalcala/PostAlignment-nf --postaltjs /path/to/bwa-postalt.js --refalt /path/to/ref.fa.alt --input_folder path/to/input   --output_folder /path/to/output`

## Output ## 

**Name**         | **Description**
---------------- | -------------
BAMS(*.bam)      |   alignment 


