#!/bin/python3.6

from pathlib import Path
import getpass
import sys
import shutil


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

dot_files_path = Path(__file__).parent
ignore_names = ['install.py', 'README.md', ]
# FIXME: Use actual home folder
home = Path(f'/home/{getpass.getuser()}/Downloads') 
backup_path = home / ".dotfiles_backup"


def create_backup_folder():
    try:
        backup_path.mkdir()
    except FileExistsError:
        print (f"{bcolors.FAIL}Folder {bcolors.OKBLUE}{backup_path} {bcolors.FAIL}already exsists{bcolors.ENDC}")
        sys.exit()


def create_symlink(path, link):
    if link.is_dir():
       link.symlink_to(path, target_is_directory=True)
    else:
       link.symlink_to(path)
    print(f"{bcolors.OKGREEN}Link {bcolors.OKBLUE}{link} {bcolors.OKGREEN}created to {bcolors.OKBLUE}{path}{bcolors.ENDC}")


def create_symlinks():
    for path in dot_files_path.iterdir():
        if path.name in ignore_names:
            continue
        link = home / path.name
        if link.is_symlink():
            link.unlink()
        if not link.exists():
            create_symlink(path, link)
        else:
            override = str(input(f"File or folder at {bcolors.OKBLUE}{link}{bcolors.ENDC} already exsists. Do you want to overwrite? {bcolors.WARNING}(Y/n){bcolors.ENDC}")) or 'y'
            if override.lower() != 'y':
                continue
            shutil.move(link, backup_path / path.name)
            create_symlink(path, link)


def main():
    create_backup_folder()
    create_symlinks()


if __name__ == "__main__":
    main()

