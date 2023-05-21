#!/usr/bin/env bash

display_help() {
  echo
  echo -e "\033[0;32mDescription:\033[0m"
  echo "  This script filters the output of certstream based on the specified string patterns and parses the URL of certificate updates."
  echo "  By default, it will filter and display the URL if a match is found."
  echo
  echo -e "\033[0;32mUsage:\033[0m squatter [OPTIONS]"
  echo "Options:"
  echo "  -f, --filter       File containing string patterns (one pattern per line) to match in URLs"
  echo "  -o, --output       Write the output to a file instead of printing to stdout"
  echo "  -r, --raw          Display raw certstream output"
  echo "  -h, --help         Display this help message"
  echo
  echo -e "\033[0;32mExamples:\033[0m"
  echo "  squatter -f patterns.txt               # Filter certstream using patterns from 'patterns.txt'"
  echo "  squatter -f patterns.txt -o output.txt # Write the output to 'output.txt'"
  echo "  squatter -r                            # Display raw certstream output"
  echo
  exit 0
}

print_banner() {
  echo -e "\033[0;32m┌─┐┌─┐ ┬ ┬┌─┐┌┬┐┌┬┐┌─┐┬─┐"
  echo -e "└─┐│─┼┐│ │├─┤ │  │ ├┤ ├┬┘"
  echo -e "└─┘└─┘└└─┘┴ ┴ ┴  ┴ └─┘┴└─\033[0m"
  echo "                    -dap?"
  echo
}

check_dependencies() {
  if ! command -v certstream &> /dev/null; then
    echo "certstream is not installed."
    echo "Please install certstream using the following command:"
    echo "pip install certstream"
    exit 1
  fi
}

parse_arguments() {
  if [[ $# -eq 0 ]]; then
    display_help
  fi
  while [[ $# -gt 0 ]]; do
    case $1 in
      -f|--filter)
        shift
        filter_file="$1"
        ;;
      -o|--output)
        shift
        output_file="$1"
        ;;
      -r|--raw)
        raw_output="true"
        ;;
      -h|--help)
        display_help
        ;;
      *)
        echo "Invalid option: $1"
        display_help
        ;;
    esac
    shift
  done
}

validate_input() {
  if [[ ! -f $filter_file ]]; then
    echo "Filter file $filter_file does not exist. Exiting..."
    exit 1
  fi
}

filter_certstream() {
  while read -r domain; do
    while read -r pattern; do
      if [[ $domain == *"$pattern"* ]]; then
        if [[ -z $output_file ]]; then
          echo -e "$domain \033[0;31mMATCH: [$pattern]\033[0m"
        else
          echo "$domain" >> "$output_file"
        fi
        break
      fi
    done < "$filter_file"
  done < <(certstream 2>/dev/null | awk -F' - ' '{print $2}')
}

display_raw_certstream() {
  certstream 2>/dev/null
}

write_output() {
  if [[ -z $output_file ]]; then
    $1
  else
    $1 > "$output_file"
  fi
}

main() {
  print_banner
  check_dependencies
  parse_arguments "$@"
  if [[ $raw_output == "true" ]]; then
    write_output display_raw_certstream
  else
    validate_input
    write_output filter_certstream
  fi
  exit 0
}

main "$@"
