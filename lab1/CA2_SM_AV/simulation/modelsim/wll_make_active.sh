#!/bin/bash 

# Kopiert die beiden 0x*.do und 0x*.vht Vorlagen-Dateien in die wirklich verwendeten
# Aufruf z.B. mit wll_make_active.sh 02

if [[ $# -eq 1 ]]
then
   echo $1*CA2_SM_SimWF.do to CA2_SM_SimWF.do
   cp $1*CA2_SM_SimWF.do CA2_SM_SimWF.do
   echo $1*CA2_SM.vht to CA2_SM.vht
   cp $1*CA2_SM.vht CA2_SM.vht
else
   echo "Aufruf mit genau einem Argument, z.B. 02"
fi
