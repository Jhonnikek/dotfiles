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
    except subprocess.CalledProcessError:
        print("Theres is no horphans packages")

def cleanDocs():
    subprocess.run(["sudo","rm","-rf", "/usr/share/doc/*"])
    subprocess.run(["sudo","rm","-rf", "/usr/share/info/*"])

def cleanThumbnails():
    subprocess.run (["rm", "-rf", "~/.caché/thumbnails/*"])

def updatePacman():
    subprocess.run (["sudo", "pacman", "-Syyu", "--noconfirm"])
        
def main():
    while True:
        try:
            print("...System Maintenance...")
            print("1.Clean\n2.Update\n3.Exit")
            options = input("What do you want to do?: ")
            if options== "1":
                try:
                    print("1.Pacman cache\n2.Aur cache\n3.Horphans\n4.Docs\n5·Thumbnails")
                    clean = input("What do you want to clean?: ")
                    if clean== "1":
                        pacmanCache()
                    elif clean== "2":
                        aurCache()
                    elif clean== "3":
                        cleanHorphans()
                    elif clean== "4":
                        cleanDocs()
                    elif clean== "5":
                        cleanThumbnails()
                except ValueError:
                    print("That is not a valid option.") 
            elif options== "2":
                updatePacman()
            elif options== "3":
                print("Leaving...")
                break
        except ValueError:
            print("That is not a valid option.")
        else:
            print("Done!.")
main()