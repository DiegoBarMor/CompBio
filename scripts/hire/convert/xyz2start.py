import sys
from pathlib import Path

# ------------------------------------------------------------------------------
def main():
    data = (
        line.split() for line in
        PATH_XYZ_IN.read_text().splitlines()
    )
    coords = (
        line[1:] for line in data
        if len(line) == 4
    )
    PATH_START_OUT.write_text(
        "\n".join(" ".join(line) for line in coords)
    )


################################################################################
if __name__ == "__main__":
    PATH_XYZ_IN = Path(sys.argv[1])
    PATH_START_OUT = Path(sys.argv[2])
    main()


################################################################################
