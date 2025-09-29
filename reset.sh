#!/bin/bash
echo "Deleting Nextflow Run Directories & Files"
rm -r work
rm -r results
rm .nextflow.log*
rm -r .nextflow