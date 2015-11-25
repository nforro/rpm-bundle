import subprocess
import sys

from setuptools import setup, Command


class TestCmd(Command):
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        cmd = ['py.test', '-v', 'test.py']
        sys.exit(subprocess.Popen(cmd).wait())


setup(
    name='rpm-bundle-tests',
    version='0.1',
    cmdclass = {'test': TestCmd},
)
