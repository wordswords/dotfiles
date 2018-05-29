#!/usr/bin/python

#
# Script to load the proper HPC Compiler module
# by looking for the OS/distro version in /etc/issue
#


class ModuleFinder:

    modules = {
        'openSUSE Tumbleweed':
            'Generic-AArch64/SUSE/12/suites/arm-compiler-for-hpc/',
        'Ubuntu 16.04':
            'Generic-AArch64/Ubuntu/16.04/arm-hpc-compiler/',
        'Kernel \r on an \m':
            'Generic-AArch64/RHEL/7/suites/arm-compiler-for-hpc/'
    }
    etcissue = ""
    version = "0.0"

    def __init__(self, version):
        self.etcissue = open('/etc/issue').read()
        self.version = version

    def find(self):
        for osident in self.modules.keys():
            if osident in self.etcissue:
                return self.modules[osident] + self.version
