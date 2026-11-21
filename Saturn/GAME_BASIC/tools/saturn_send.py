#!/usr/bin/env python3
# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""Send GAME BASIC for SEGA SATURN programs over a serial cable.

Run `python3 saturn_send.py --help` for commands.
"""

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from saturn_link.cli import main  # noqa: E402

if __name__ == "__main__":
    sys.exit(main())
