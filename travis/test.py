#!/usr/bin/env python

import rpm

print(rpm.__version__)

print(rpm.TransactionSet().dbMatch('name', 'rpm'))
