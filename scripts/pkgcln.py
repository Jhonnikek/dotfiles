import os
import subprocess
import shutil

def pacmanCache():
    subprocess.run (["sudo", "pacman", "-Scc", "--noconfirm"])
    subprocess.run (["sudo", "paccache", "-rk1"])

def aurCache():
    aur = ""
    if shutil.which("yay"):
        aur = "yay"
    elif shutil.which("paru"):
        aur = "paru"

    if aur:
        subprocess.run([aur, "-Sc", "--noconfirm"])
        cache_path = os.path.expanduser(f"~/.cache/{aur}")
        subprocess.run(["rm", "-rf", f"{cache_path}/*"])
    else:
        print("No yay or paru was found.")

def cleanHorphans():
    try:
        output = subprocess.check_output(["pacman", "-Qdtq"])
        packages = output.decode().splitlines()
        if packages:
            subprocess.run(["sudo", "pacman", "-Rns"] + packages)
        else:
            print("Theres is no horphans packages")
    except subprocess.CalledProcessError:
        print("Theres is no horphans packages")

def cleanDocs():
    subprocess.run(["sudo","rm","-rf", "/usr/share/doc/*"])
    subprocess.run(["sudo","rm","-rf", "/usr/share/info/*"])

def cleanThumbnails():
    subprocess.run (["rm", "-rf", "~/.caché/thumbnails/*"])

def updatePacman():
    subprocess.run (["sudo", "pacman", "-Syyu", "--noconfirm"])

options = ""

while options.lower() != "e":
    options = input("What do u want to do?\n[C]lean [U]pdate [E]xit: ")
    if options.lower() == "c":
        clean = input("What do u want to clean?\n[P]acman [A]ur [H]orphans [D]ocs [T]humbnails: ")
        if clean.lower() == "p":
            print("\nCleaning pacman cache...\n")
            pacmanCache()
            print("\nDone.\n")
        elif clean.lower() == "a":
            print("\nCleaning aur cache...\n")
            aurCache()
            print("\nDone.\n")
        elif clean.lower() == "h":
            print("\nCleaning horphans...\n")
            cleanHorphans()
            print("\nDone.\n")
        elif clean.lower() == "d":
            print("\nCleaning docs...\n")
            cleanDocs()
            print("\nDone.\n")
        elif clean.lower() == "t":
            print("\nCleaning thumbnails...\n")
            cleanThumbnails()
            print("\nDone.\n")
        else:
            print("error")
    elif options.lower() == "u":
        print("\nUpdating...\n")
        updatePacman()
        print("\nDone.\n")
    elif options.lower() == "e":
        print("\nLeaving...\n")
        break
    else:
        print("That is not a valid option.")