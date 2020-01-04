"""Copies all jpegs in a defined folder and copy it to a temporary folder."""
import os
import shutil
from sys import argv
from os import path
from datetime import datetime


def is_jpg(file):
    return file.lower().endswith("jpeg") or file.lower().endswith("jpg")


def find_jpgs(src):
    content = filter(lambda item: path.isfile(item), os.listdir(src))
    return filter(is_jpg, content)


def get_creation_date(file):
    timestamp = path.getmtime(file)
    return datetime.fromtimestamp(timestamp)


def cp_file_by_creation_date(src, target_dir):
    dt = get_creation_date(src)
    tar = str(dt.year) + "_" + str_2_digits(dt.month) + "_" + str_2_digits(dt.day) + "__"
    tar += str_2_digits(dt.hour) + "_" + str_2_digits(dt.minute) + "_"
    tar += str_2_digits(dt.second) + ".jpg"
    shutil.copy(src, path.join(target_dir, tar))


def str_2_digits(number):
    string = "00"
    if number < 10:
        string = "0" + str(number)
    else:
        string = str(number)
    return string


if __name__ == '__main__' and len(argv) > 1:
    temp_dir = "tmp"
    if len(argv) > 2:
        temp_dir = argv[2]

    tar_dir = argv[1]
    temp_dir = path.join(tar_dir, temp_dir)
    os.makedirs(temp_dir, exist_ok=True)

    jpgs = find_jpgs(tar_dir)
    for jpg in jpgs:
        cp_file_by_creation_date(jpg, temp_dir)
