# Random stuff, useful for DevOps or

## Run commands
```
from subprocess import call
call(["ipconfig"])          # Returns exit code
```
Getting the output
```
import subprocess
output = subprocess.getoutput("ipconfig")
```

## Merge multiple files in a directory with filter
```
import fileinput
import os

files = list()
actual_dir = os.listdir(".")
for f in actual_dir:
    if os.path.isfile(f) and ".txt" in f:
        files.append(f)

with open("new_test.txt", "w") as fout, fileinput.input(files) as fin:
    for line in fin:
        fout.write(line.replace(" ", "_"))
```

## Zip files of directory
```
from zipfile import ZipFile
import os

actual_dir = os.listdir(".")
with ZipFile("new_test.zip", "w") as myzip:
    for f in actual_dir:
        if os.path.isfile(f) and ".txt" in f:
            myzip.write(f)
```

## Tar files of directory
```
from tarfile import TarFile
import os

actual_dir = os.listdir(".")
with TarFile("new_test.tar", "w") as mytar:
    for f in actual_dir:
        if os.path.isfile(f) and ".txt" in f:
            mytar.add(f)
```

## Unzip file
```
from zipfile import ZipFile

with ZipFile("new_test.zip") as myzip:
    myzip.extractall()
```

## Untar file
```
from tarfile import TarFile

with TarFile("new_test.tar") as mytar:
    mytar.extractall()
```