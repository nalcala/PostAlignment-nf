#!/usr/bin/env nextflow

// Copyright (C) 2017 IARC/WHO

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


params.help          		 = null
params.config         		 = null
params.cpu            		 = 10
params.mem           		 = 20
params.refalt                   = 'ref.fa.alt'
params.output_folder            = "."
params.js                       = "k8"
params.postaltjs                = "bwa-postalt.js"

log.info ""
log.info "----------------------------------------------------------------"
log.info " samtools-1.6 bwakit-0.7.15 sambamba-0.6.5 : Post alignment      "
log.info "----------------------------------------------------------------"
log.info "Copyright (C) IARC/WHO"
log.info "This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE"
log.info "This is free software, and you are welcome to redistribute it"
log.info "under certain conditions; see LICENSE for details."
log.info "--------------------------------------------------------"
if (params.help) {
    log.info "--------------------------------------------------------"
    log.info "                     USAGE                              "
    log.info "--------------------------------------------------------"
    log.info ""
    log.info "-------------------QC-------------------------------"
    log.info "" 
    log.info "nextflow run PostAlign.nf --samtools /path/to/samtools --sambamba /path/to/sambamba --bwait /path/to/bwakit --input_folder path/to/input   --output_folder /path/to/output"
    log.info ""
    log.info "Mandatory arguments:"
    log.info "--sambamba              PATH               sambamba installation dir"
    log.info "--bwakit                PATH               bwakit installation dir"
    log.info "--input_folder         FOLDER               Folder containing bam files"
    log.info "--output_folder         path               Path to output"
    log.info ""
    log.info "Optional arguments:"
    log.info "--cpu                  INTEGER              Number of cpu to use (default=28)"
    log.info "--config               FILE                 Use custom configuration file"
    log.info "--mem                  INTEGER              Size of memory used. Default 32Gb"
    log.info ""
    log.info "Flags:"
    log.info "--help                                      Display this message"
    log.info ""
    exit 1
} 

//load bam files
all_bams = Channel.fromPath( params.input_folder+'/*.bam' ).ifEmpty{error "Cannot find any bam file in: ${params.input_folder}"}

//load reference
refalt = file(params.refalt)

//load postalt javascript
postaltjs = file(params.postaltjs)

process post_alignment {
  cpus params.cpu
  memory params.mem+'GB'
  tag { file_tag }

  input:
  file bam from all_bams
  file refalt
  file postaltjs

  output:
  publishDir'${params.output_folder}', mode: 'move'

  shell:
  file_tag = bam.baseName
  sort_threads = params.cpu -3
  sort_mem = params.mem.intdiv(4)
  '''
  sambamba view -h !{bam} | \
  k8 !{postaltjs} !{refalt} | \
  sambamba view -S -f bam -l 0 /dev/stdin | \
  sambamba sort -t !{sort_threads} -m !{sort_mem}G --tmpdir=!{file_tag}_tmp -o !{file_tag}_postalt.bam /dev/stdin
  '''
}
