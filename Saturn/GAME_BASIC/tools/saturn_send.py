#!/usr/bin/env python3
"""Send GAME BASIC for SEGASATURN programs over a serial cable.

Run `python3 saturn_send.py --help` for commands.
"""

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from saturn_link.cli import main  # noqa: E402

if __name__ == "__main__":
    sys.exit(main())
