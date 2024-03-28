#!/usr/bin/python3

import os
import sys
from collections import OrderedDict

# Path to index.rst files
source_path = 'Sandbox15/index.rst'
dest_path = 'Sandbox4/index.rst'
source_folder = os.path.dirname(source_path)
dest_folder = os.path.dirname(dest_path)

files_to_copy = ['configurations.rst', 'creating-services.rst', 'onprem-k8s.rst', 'sandbox-info.rst']

# Function to copy files from source path to destination path
def copy_file_contents(source_folder, dest_folder, file_names):
    for file_name in file_names:
        source_file_path = os.path.join(source_folder, file_name)
        dest_file_path = os.path.join(dest_folder, file_name)
        
        with open(source_file_path, 'rb') as source_file:
            file_contents = source_file.read().decode('utf-8')
        
        with open(dest_file_path, 'wb') as dest_file:
            dest_file.write(file_contents.encode('utf-8'))

# Function to read values from index.rst file
def read_values(file_path):
    values = []
    seen = OrderedDict()
    with open(file_path, 'r') as file:
        lines = file.readlines()[7:48]  # Read lines 7 to 48
        for line in lines:
            parts = line.strip().split()
            if len(parts) >= 1:
                value = parts[0].split('/')[0]  # Strip everything after '/'
                # Check if the value doesn't start with "10.254" or "192.168" and if it's not already seen
                if not value.startswith(("10.254", "192.168", "65007")) and value not in seen:
                    seen[value] = None
                    values.append(value)
    return values

# Function to check if lengths of old and new values are equal
def check_lengths(source_values, dest_values):
    if len(source_values) != len(dest_values):
        print("Lengths of Source and Destination Values are NOT Equal!")
        sys.exit(1)

# Function to perform search and replace in a file
def search_replace(file_path, replacements):
    with open(file_path, 'rb') as file:
        contents = file.read().decode('utf-8')

    for old_value, new_value in replacements.items():
        contents = contents.replace(old_value, new_value)

    with open(file_path, 'wb') as file:
        file.write(contents.encode('utf-8'))

# Copy file contents from source to destination
copy_file_contents(source_folder, dest_folder, files_to_copy)

print("Files copied successfully.")

# Read values from index.rst files
source_values = read_values(source_path)
dest_values = read_values(dest_path)

print(f"Number of Source Values: {len(source_values)}")
print(f"Number of Destination Values: {len(dest_values)}")

# Check if lengths of old and new values are equal
check_lengths(source_values, dest_values)

# Create a dictionary to map values from source to destination with case sensitivity
replacements = {source_values[i]: dest_values[i] for i in range(min(len(source_values), len(dest_values)))}

# Calculate the maximum length of each column
max_source_length = max(len(old_value) for old_value in replacements.keys())
max_dest_length = max(len(new_value) for new_value in replacements.values())

# Determine the width of each column
column_width = max(max_source_length, max_dest_length) + 3  # Add some padding

# Print the header
print(f" {'_':<{column_width+2}}{'_':<{column_width+3}}".replace(' ', '_'))
print(f"| {'Source Value':<{column_width}}| {'Destination Value':<{column_width}} |")
print(f"| {'-':<{column_width}}| {'-':<{column_width}} |".replace(' ', '-'))

# Print out the pairs of old and new values
num_replacements = len(replacements)
for i, (old_value, new_value) in enumerate(replacements.items()):
    print(f"| {old_value:<{column_width}}| {new_value:<{column_width}} |")
    if i == num_replacements - 1:  # Check if it's the last iteration
        print(f"| {'_':<{column_width}}| {'_':<{column_width}} |".replace(' ', '_'))
    else:
        print(f"| {'-':<{column_width}}| {'-':<{column_width}} |".replace(' ', '-'))

# Perform search and replace in the copied files in the destination folder
for file_name in files_to_copy:
    dest_file = os.path.join(dest_folder, file_name)
    search_replace(dest_file, replacements)

print("Search and replace completed.")
