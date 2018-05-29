from ModuleFinder import ModuleFinder
import os
import subprocess


class TestModuleLoad:

    def __init__(self):
        self.write_script()
        subprocess.check_call("/tmp/compiler-checker.sh", shell=True)
        os.remove("/tmp/compiler-checker.sh")

    def write_script(self):
        mf = ModuleFinder(os.environ['HPCSUITE_VERSION'])
        script = '#!/bin/bash -xe'
        script = script + 'export MODULEFILES=/opt/arm/modulefiles' + '\n'
        script = script + mf.find() + '\n'
        script = script + 'armclang -v' + '\n'
        script = script + 'armflang -v' + '\n'
        script_file = open("/tmp/compiler-checker.sh", "w")
        script_file.write(script)
        script_file.close()

tml = TestModuleLoad()

