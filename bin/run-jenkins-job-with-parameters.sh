#!/bin/bash -ex
params=$( "$@" )
PWD=$(<$HOME/.pwd)
for i in "${params[@]}"
do
    $key =
    if $i -eq ${#ArrayName[@]}
      break
    fi
    if $i -gt 1
        ${params[$i]}
    fi
done

echo curl -X POST --user "davcra01:$PWD" http://jenkinsonstack.hpc.dsg.arm.com:8080/job/ArmCompilerForHPC/job/${params[1]}/${params[1]}?buildWithParameters?${pararms[2]}

