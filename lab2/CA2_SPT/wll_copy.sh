#!/bin/bash 

# Kopiert die *MikroProgramm.vhd und simulation/modelsim/*SimWF.do Vorlagen-Dateien in die wirklich verwendeten
# Aufruf z.B. mit wll_copy.sh 321


if [[ $# -eq 1 ]]
then
   srcMicroprog=$1*MicroProgram.vhd
   if test -f $srcMicroprog 
   then
      echo  $srcMicroprog wird aktiv
      cp $srcMicroprog MicroProgram.vhd
   else
      echo
      echo "Achtung: Kein Mikroprogramm für Prefix $1 gefunden."
   fi

   simWF=simulation/modelsim/$1*CA2_SPT_SimWF.do
   if test -f $simWF 
   then
      echo  $simWF wird aktiv
      cp $simWF simulation/modelsim/CA2_SPT_SimWF.do  
   else
      echo
      echo "Achtung: Kein SimWF-file für Prefix $1 gefunden."
   fi
else
   echo "Aufruf mit genau einem Argument, z.B. 321"
fi

