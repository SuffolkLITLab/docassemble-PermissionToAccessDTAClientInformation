import os
import sys
from setuptools import setup, find_packages
from fnmatch import fnmatchcase
from distutils.util import convert_path

standard_exclude = ('*.pyc', '*~', '.*', '*.bak', '*.swp*')
standard_exclude_directories = ('.*', 'CVS', '_darcs', './build', './dist', 'EGG-INFO', '*.egg-info')
def find_package_data(where='.', package='', exclude=standard_exclude, exclude_directories=standard_exclude_directories):
    out = {}
    stack = [(convert_path(where), '', package)]
    while stack:
        where, prefix, package = stack.pop(0)
        for name in os.listdir(where):
            fn = os.path.join(where, name)
            if os.path.isdir(fn):
                bad_name = False
                for pattern in exclude_directories:
                    if (fnmatchcase(name, pattern)
                        or fn.lower() == pattern.lower()):
                        bad_name = True
                        break
                if bad_name:
                    continue
                if os.path.isfile(os.path.join(fn, '__init__.py')):
                    if not package:
                        new_package = name
                    else:
                        new_package = package + '.' + name
                        stack.append((fn, '', new_package))
                else:
                    stack.append((fn, prefix + name + '/', package))
            else:
                bad_name = False
                for pattern in exclude:
                    if (fnmatchcase(name, pattern)
                        or fn.lower() == pattern.lower()):
                        bad_name = True
                        break
                if bad_name:
                    continue
                out.setdefault(package, []).append(prefix+name)
    return out

setup(name='docassemble.PermissionToAccessDTAClientInformation',
      version='0.0.1',
      description=('A docassemble extension.'),
      long_description='# docassemble-PermissionToAccessDTAClientInformation\r\nA docassemble extension.\r\nTrevor Mears tmears@su.suffolk.edu\r\nA document assembly line extension\r\n\r\nLink to Google Doc with original project\r\nhttps://docs.google.com/document/d/1CMqkDeuvgwoEvYmw6fa__6tIZREABxObvbsBS09olpQ/edit?usp=sharing\r\n\r\nLink to original DTA form\r\nhttps://www.masslegalservices.org/system/files/library/DTA%20Authorization-%20Consent%20form%20Jan%202016%20English.pdf\r\n\r\nIssue page on Github\r\nhttps://github.com/SuffolkLITLab/docassemble-PermissionToAccessDTAClientInformation/issues\r\n\r\nFinal source code\r\nhttps://github.com/SuffolkLITLab/docassemble-PermissionToAccessDTAClientInformation/blob/main/docassemble/PermissionToAccessDTAClientInformation/data/permission_to_access_dta_client_information.yml \r\n\r\nFinal template\r\nhttps://github.com/SuffolkLITLab/docassemble-PermissionToAccessDTAClientInformation/blob/main/docassemble/PermissionToAccessDTAClientInformation/data/permission_access_dta_info.pdf\r\n\r\n',
      long_description_content_type='text/markdown',
      author='trevor mears',
      author_email='tmears@su.suffolk.edu',
      license='The MIT License (MIT)',
      url='https://docassemble.org',
      packages=find_packages(),
      namespace_packages=['docassemble'],
      install_requires=[],
      zip_safe=False,
      package_data=find_package_data(where='docassemble/PermissionToAccessDTAClientInformation/', package='docassemble.PermissionToAccessDTAClientInformation'),
     )

