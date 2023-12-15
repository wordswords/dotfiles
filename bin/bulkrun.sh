#!/bin/bash
# bulkrun--Iterates over a directory of files, running a number of
#   concurrent processes that will process the files in parallel

printHelp()
{
 echo "Usage: $0 -p 3 -i inputDirectory/ -x \"command -to run/\""
   echo -e "\t-p The maximum number of processes to start concurrently"
   echo -e "\t-i The directory containing the files to run the command on"
   echo -e "\t-x The command to run on the chosen files"
 exit 1
}

 while getopts "p:x:i:" opt
do
 case "$opt" in
   p ) procs="$OPTARG"    ;;
   x ) command="$OPTARG"  ;;
   i ) inputdir="$OPTARG" ;;
   ? ) printHelp          ;;
 esac
done

if [[ -z $procs || -z $command || -z $inputdir ]]
then
 echo "Invalid arguments"
 printHelp
fi

total=$(ls $inputdir | wc -l)
files="$(ls -Sr $inputdir)"

for k in $(seq 1 $procs $total)
do
 for i in $(seq 0 $procs)
 do
   if [[ $((i+k)) -gt $total ]]
   then
     wait
     exit 0
   fi

   file=$(echo "$files" | sed $(expr $i + $k)"q;d")
   echo "Running $command $inputdir/$file"
   $command "$inputdir/$file"&
 done

 wait
done
