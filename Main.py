import tkinter as tk
from tkinter import ttk
import platform
import shutil
import subprocess
import os
import time

# Function to get system info
def get_system_info():
    os_info = f"{platform.system()} {platform.release()}"
    
    if platform.system() == "Windows":
        cpu = os.environ.get("PROCESSOR_IDENTIFIER", "Unknown")
        total_mem = int(subprocess.getoutput("wmic computersystem get TotalPhysicalMemory").split()[1]) // (1024**2)
    else:
        cpu = subprocess.getoutput("lscpu | grep 'Model name' | awk -F: '{print $2}'").strip()
        total_mem = int(subprocess.getoutput("grep MemTotal /proc/meminfo | awk '{print $2}'")) // 1024
    
    return os_info, cpu, total_mem

# Function to get RAM usage percentage
def get_ram_usage():
    if platform.system() == "Windows":
        mem_info = subprocess.getoutput("wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value")
        lines = mem_info.splitlines()
        free = int([x for x in lines if x.startswith("FreePhysicalMemory")][0].split("=")[1])
        total = int([x for x in lines if x.startswith("TotalVisibleMemorySize")][0].split("=")[1])
        used_percent = int((total - free) / total * 100)
    else:
        mem_info = subprocess.getoutput("free | grep Mem").split()
        total = int(mem_info[1])
        used = int(mem_info[2])
        used_percent = int(used / total * 100)
    return used_percent

# Function to get CPU usage percentage
def get_cpu_usage(interval=0.5):
    if platform.system() == "Windows":
        cpu_load = subprocess.getoutput("wmic cpu get loadpercentage").splitlines()[1].strip()
        return int(cpu_load)
    else:
        # Linux: calculate CPU usage by reading /proc/stat
        def read_cpu():
            with open("/proc/stat", "r") as f:
                line = f.readline()
                parts = line.split()[1:]
                return list(map(int, parts))
        cpu1 = read_cpu()
        time.sleep(interval)
        cpu2 = read_cpu()
        idle1 = cpu1[3] + cpu1[4]
        idle2 = cpu2[3] + cpu2[4]
        total1 = sum(cpu1)
        total2 = sum(cpu2)
        usage = 100 * (1 - (idle2 - idle1) / (total2 - total1))
        return int(usage)

# Function to get disk usage percentage
def get_disk_usage():
    total, used, free = shutil.disk_usage("/")
    used_percent = int(used / total * 100)
    return used_percent

# Function to update the UI
def update_ui():
    os_info, cpu_model, total_mem = get_system_info()
    
    os_label.config(text=f"OS: {os_info}")
    cpu_label.config(text=f"CPU: {cpu_model}")
    ram_label.config(text=f"RAM: {total_mem} MB")
    
    cpu_bar['value'] = get_cpu_usage()
    ram_bar['value'] = get_ram_usage()
    disk_bar['value'] = get_disk_usage()
    
    root.after(2000, update_ui)  # refresh every 2 seconds

# Tkinter UI setup
root = tk.Tk()
root.title("EDEx UI Clone - Full Options")
root.geometry("500x400")
root.configure(bg="#1e1e1e")

style = ttk.Style(root)
style.theme_use('clam')
style.configure("TLabel", background="#1e1e1e", foreground="#ffffff", font=("Consolas", 12))
style.configure("TProgressbar", thickness=20)

# System Info Labels
os_label = ttk.Label(root, text="OS:")
os_label.pack(pady=5, anchor="w", padx=20)
cpu_label = ttk.Label(root, text="CPU:")
cpu_label.pack(pady=5, anchor="w", padx=20)
ram_label = ttk.Label(root, text="RAM:")
ram_label.pack(pady=5, anchor="w", padx=20)

# CPU Usage Bar
tk.Label(root, text="CPU Usage", bg="#1e1e1e", fg="#ffffff", font=("Consolas", 12)).pack(pady=(20,5))
cpu_bar = ttk.Progressbar(root, orient="horizontal", length=400, mode="determinate")
cpu_bar.pack(pady=5)

# RAM Usage Bar
tk.Label(root, text="RAM Usage", bg="#1e1e1e", fg="#ffffff", font=("Consolas", 12)).pack(pady=(20,5))
ram_bar = ttk.Progressbar(root, orient="horizontal", length=400, mode="determinate")
ram_bar.pack(pady=5)

# Disk Usage Bar
tk.Label(root, text="Disk Usage", bg="#1e1e1e", fg="#ffffff", font=("Consolas", 12)).pack(pady=(20,5))
disk_bar = ttk.Progressbar(root, orient="horizontal", length=400, mode="determinate")
disk_bar.pack(pady=5)

update_ui()
root.mainloop()
