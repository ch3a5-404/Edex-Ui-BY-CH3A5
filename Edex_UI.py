#!/usr/bin/env python3
"""
edex_ui.py

A small EDEX-like retro terminal dashboard built with PyQt5.

Features:
- Left sidebar with Clock, CPU, Memory cards
- Main terminal output (green text on black)
- Command input with a few built-in commands
- Minimal styling to mimic retro terminal look & feel
"""

import sys
import time
from datetime import datetime
from functools import partial

from PyQt5.QtCore import Qt, QTimer, QSize
from PyQt5.QtGui import QFont, QTextCursor, QIcon
from PyQt5.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout,
    QLabel, QTextEdit, QLineEdit, QPushButton, QFrame,
    QSizePolicy, QGridLayout
)

# Optional: better system stats
try:
    import psutil
    HAS_PSUTIL = True
except Exception:
    HAS_PSUTIL = False


# -------------------------
# Styling constants
# -------------------------
BG_COLOR = "#0b0f0b"        # very dark greenish/black
PANEL_COLOR = "#061006"     # slightly different dark panel
ACCENT = "#39ff14"          # neon green accent
MUTED = "#4b7a4b"           # muted green for secondary text
FONT_FAMILY = "Courier New" # monospace
FONT_SIZE = 11


# -------------------------
# Helper functions
# -------------------------
def format_bytes(n):
    """Human readable bytes."""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if abs(n) < 1024.0:
            return f"{n:3.1f}{unit}"
        n /= 1024.0
    return f"{n:.1f}PB"


# -------------------------
# Main UI class
# -------------------------
class EdexUI(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("EDEX - PyQt Demo")
        self.setMinimumSize(980, 600)
        self.setStyleSheet(f"background: {BG_COLOR}; color: {ACCENT};")
        # Optionally set an icon if you have one:
        # self.setWindowIcon(QIcon('icon.png'))

        # Main horizontal layout: sidebar + main
        main_layout = QHBoxLayout()
        main_layout.setContentsMargins(12, 12, 12, 12)
        main_layout.setSpacing(12)

        # Left Sidebar
        sidebar = self._build_sidebar()
        sidebar.setFixedWidth(260)

        # Main Terminal Area
        main_panel = self._build_main_panel()

        main_layout.addWidget(sidebar)
        main_layout.addWidget(main_panel, stretch=1)
        self.setLayout(main_layout)

        # Timers for updating clock and stats
        self._build_timers()

        # Pre-fill terminal with banner
        self._banner()

    # -------------------------
    # Sidebar
    # -------------------------
    def _build_sidebar(self):
        frame = QFrame()
        frame.setStyleSheet(f"background: {PANEL_COLOR}; border-radius: 8px;")
        v = QVBoxLayout()
        v.setContentsMargins(12, 12, 12, 12)
        v.setSpacing(10)

        # Title
        title = QLabel("EDEX — PyQT")
        title.setStyleSheet(f"color: {ACCENT};")
        title.setFont(QFont(FONT_FAMILY, 16, QFont.Bold))
        v.addWidget(title)

        # Grid for cards
        grid = QGridLayout()
        grid.setSpacing(8)

        # Clock card
        self.clock_label = QLabel("--:--:--")
        self._style_card(self.clock_label, "Clock")
        grid.addWidget(self._labeled_card("Clock", self.clock_label), 0, 0)

        # CPU card
        self.cpu_label = QLabel("0%")
        self._style_card(self.cpu_label)
        grid.addWidget(self._labeled_card("CPU", self.cpu_label), 0, 1)

        # Memory card
        self.mem_label = QLabel("0 / 0")
        self._style_card(self.mem_label)
        grid.addWidget(self._labeled_card("Mem", self.mem_label), 1, 0)

        # Uptime card
        self.uptime_label = QLabel("0s")
        self._style_card(self.uptime_label)
        grid.addWidget(self._labeled_card("Uptime", self.uptime_label), 1, 1)

        v.addLayout(grid)

        # Quick buttons
        v.addSpacing(6)
        btn_layout = QHBoxLayout()
        btn_layout.setSpacing(6)
        btn_clear = QPushButton("Clear")
        btn_clear.clicked.connect(self.cmd_clear)
        btn_help = QPushButton("Help")
        btn_help.clicked.connect(self.cmd_help)
        for b in (btn_clear, btn_help):
            b.setCursor(Qt.PointingHandCursor)
            b.setStyleSheet(self._btn_style())
            b.setFont(QFont(FONT_FAMILY, FONT_SIZE))
            b.setFixedHeight(30)
            btn_layout.addWidget(b)
        v.addLayout(btn_layout)
        v.addStretch()

        frame.setLayout(v)
        return frame

    def _labeled_card(self, label_text, widget):
        container = QFrame()
        layout = QVBoxLayout()
        lbl = QLabel(label_text)
        lbl.setStyleSheet(f"color: {MUTED};")
        lbl.setFont(QFont(FONT_FAMILY, 9))
        widget.setFont(QFont(FONT_FAMILY, 12, QFont.Bold))
        layout.addWidget(lbl)
        layout.addWidget(widget)
        container.setLayout(layout)
        return container

    def _style_card(self, widget, default_text=""):
        widget.setText(default_text)
        widget.setStyleSheet(f"color: {ACCENT};")
        widget.setAlignment(Qt.AlignLeft | Qt.AlignVCenter)

    def _btn_style(self):
        return (
            "QPushButton{"
            f"background:{BG_COLOR}; color:{ACCENT}; border:1px solid #173917; border-radius:4px;"
            "}"
            "QPushButton::hover{opacity:0.9}"
        )

    # -------------------------
    # Main panel (terminal)
    # -------------------------
    def _build_main_panel(self):
        container = QFrame()
        container.setStyleSheet(f"background: {PANEL_COLOR}; border-radius: 8px;")
        layout = QVBoxLayout()
        layout.setContentsMargins(12, 12, 12, 12)
        layout.setSpacing(8)

        # Header row
        header_layout = QHBoxLayout()
        header_layout.setSpacing(10)
        header_left = QLabel("Terminal")
        header_left.setFont(QFont(FONT_FAMILY, 12, QFont.Bold))
        header_left.setStyleSheet(f"color: {ACCENT};")
        header_layout.addWidget(header_left)
        header_layout.addStretch()
        header_right = QLabel("v0.1 — demo")
        header_right.setFont(QFont(FONT_FAMILY, 9))
        header_right.setStyleSheet(f"color: {MUTED};")
        header_layout.addWidget(header_right)
        layout.addLayout(header_layout)

        # Terminal text area
        self.terminal = QTextEdit()
        self.terminal.setReadOnly(True)
        self.terminal.setFont(QFont(FONT_FAMILY, FONT_SIZE))
        self.terminal.setStyleSheet(
            "QTextEdit{"
            f"background: transparent; color: {ACCENT}; border:none; padding:6px;"
            "}"
        )
        self.terminal.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        layout.addWidget(self.terminal)

        # Input row
        input_row = QHBoxLayout()
        prompt_lbl = QLabel(">>>")
        prompt_lbl.setFont(QFont(FONT_FAMILY, FONT_SIZE + 2, QFont.Bold))
        prompt_lbl.setStyleSheet(f"color: {ACCENT};")
        input_row.addWidget(prompt_lbl)

        self.input_box = QLineEdit()
        self.input_box.setFont(QFont(FONT_FAMILY, FONT_SIZE))
        self.input_box.setStyleSheet(
            "QLineEdit{"
            f"background: transparent; color: {ACCENT}; border:1px solid #173917; padding:6px;"
            "}"
        )
        self.input_box.returnPressed.connect(self._on_enter)
        input_row.addWidget(self.input_box, stretch=1)

        btn_send = QPushButton("Run")
        btn_send.setFixedWidth(70)
        btn_send.setCursor(Qt.PointingHandCursor)
        btn_send.setStyleSheet(self._btn_style())
        btn_send.clicked.connect(self._on_enter)
        input_row.addWidget(btn_send)

        layout.addLayout(input_row)
        container.setLayout(layout)
        return container

    # -------------------------
    # Terminal behavior
    # -------------------------
    def _banner(self):
        self._write_line("E D E X  •  PyQt Demo")
        self._write_line("Type 'help' for commands.\n")

    def _write_line(self, txt=""):
        # write a line and keep cursor at end
        self.terminal.append(txt)
        cursor = self.terminal.textCursor()
        cursor.movePosition(QTextCursor.End)
        self.terminal.setTextCursor(cursor)

    def _on_enter(self):
        text = self.input_box.text().strip()
        if not text:
            return
        # echo the prompt + command
        self._write_line(f">>> {text}")
        # handle built-in commands
        cmd_parts = text.split()
        cmd = cmd_parts[0].lower()
        args = cmd_parts[1:]

        if cmd == "help":
            self.cmd_help()
        elif cmd == "clear":
            self.cmd_clear()
        elif cmd == "time":
            self.cmd_time()
        elif cmd == "echo":
            self.cmd_echo(args)
        elif cmd == "sys":
            self.cmd_sys()
        else:
            self._write_line(f"Unknown command: {cmd} (type 'help')")

        self.input_box.clear()

    # Built-in command implementations
    def cmd_help(self):
        help_text = (
            "Available commands:\n"
            "  help        - show this help\n"
            "  clear       - clear the terminal\n"
            "  time        - show current time\n"
            "  echo <txt>  - echo text\n"
            "  sys         - show system stats\n"
        )
        self._write_line(help_text)

    def cmd_clear(self):
        self.terminal.clear()

    def cmd_time(self):
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self._write_line(f"Current time: {now}")

    def cmd_echo(self, args):
        self._write_line(" ".join(args))

    def cmd_sys(self):
        if HAS_PSUTIL:
            cpu = psutil.cpu_percent(interval=0.1)
            mem = psutil.virtual_memory()
            lines = [
                f"CPU: {cpu}%",
                f"Memory: {format_bytes(mem.used)} / {format_bytes(mem.total)} ({mem.percent}%)",
            ]
        else:
            lines = [
                "CPU: 12% (mock)",
                "Memory: 1.6GB / 4.0GB (mock)",
                "Install psutil for real stats: pip install psutil"
            ]
        self._write_line("\n".join(lines))

    # -------------------------
    # Timers & updates
    # -------------------------
    def _build_timers(self):
        # Clock ticker (1s)
        self.clock_timer = QTimer(self)
        self.clock_timer.timeout.connect(self._tick_clock)
        self.clock_timer.start(1000)
        # Stats ticker (every 2s)
        self.stats_timer = QTimer(self)
        self.stats_timer.timeout.connect(self._tick_stats)
        self.stats_timer.start(2000)
        # Uptime reference
        self.start_time = time.time()

    def _tick_clock(self):
        now = datetime.now().strftime("%H:%M:%S")
        self.clock_label.setText(now)

    def _tick_stats(self):
        # CPU
        if HAS_PSUTIL:
            cpu = psutil.cpu_percent(interval=None)
            self.cpu_label.setText(f"{cpu:.0f}%")
            mem = psutil.virtual_memory()
            self.mem_label.setText(f"{format_bytes(mem.used)} / {format_bytes(mem.total)}")
        else:
            # Mock animation
            t = int(time.time()) % 100
            self.cpu_label.setText(f"{t}%")
            self.mem_label.setText("1.6GB / 4.0GB")

        # Uptime
        uptime_seconds = int(time.time() - self.start_time)
        self.uptime_label.setText(self._format_uptime(uptime_seconds))

    def _format_uptime(self, s):
        m, sec = divmod(s, 60)
        h, m = divmod(m, 60)
        return f"{h}h {m}m {sec}s"


# -------------------------
# Entry point
# -------------------------
def main():
    app = QApplication(sys.argv)

    # global font to keep monospace look
    font = QFont(FONT_FAMILY, FONT_SIZE)
    app.setFont(font)

    window = EdexUI()
    window.show()
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
