#!/bin/bash

# Function to generate a list of special characters
special_chars="!@#$%^&*()_+[]{}|;:,.<>?/~"

# Function to display help message
display_help() {
  echo "Usage: $0 [-s STRING] [-w WORDLIST] [-o OUTPUT_FILE]"
  echo
  echo "Generate strings by appending numbers and random special characters to the provided string or each line in the wordlist."
  echo
  echo "Options:"
  echo "  -s STRING        Input string to which numbers and special characters will be appended."
  echo "  -w WORDLIST      File containing a list of words to process."
  echo "  -o OUTPUT_FILE   Output file to store the results."
  echo "  --help           Display this help message and exit."
}

# Initialize variables
input_string=""
wordlist=""
output_file="output.txt"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -s) input_string="$2"; shift ;;
    -w) wordlist="$2"; shift ;;
    -o) output_file="$2"; shift ;;
    --help) display_help; exit 0 ;;
    *) echo "Unknown option: $1"; display_help; exit 1 ;;
  esac
  shift
done

# Check if at least one input option is provided
if [[ -z "$input_string" && -z "$wordlist" ]]; then
  echo "Error: Either input string (-s) or wordlist (-w) is required."
  display_help
  exit 1
fi

# Clear the output file
> "$output_file"

# Function to generate and append strings
generate_strings() {
  local base_string="$1"
  for i in $(seq 0 999999); do
    for char in $(echo "$special_chars" | fold -w1); do
      echo "${base_string}${i}${char}" >> "$output_file"
    done
  done
}

# Process the input string if provided
if [[ -n "$input_string" ]]; then
  generate_strings "$input_string"
fi

# Process the wordlist if provided
if [[ -n "$wordlist" ]]; then
  while IFS= read -r line; do
    generate_strings "$line"
  done < "$wordlist"
fi

echo "Output written to $output_file"
