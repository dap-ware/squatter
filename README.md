# Squatter

Squatter is a bash script that filters and parses the SSL certificate updates from the certstream, a real-time certificate transparency log update stream.

This script can be useful for domain researchers and security professionals who wish to monitor newly registered SSL certificates for specific patterns.

## Features

* Filter certstream output based on a file containing string patterns.
* Display the filtered output to stdout or write it to a file.
* Display raw certstream output.

## Installation

1. Make sure you have `certstream` Python package installed. If not, you can install it using pip:

    ```
    pip install certstream
    ```

2. Clone this repository:

    ```
    git clone https://github.com/your-github-username/squatter
    ```

3. Change the script permissions to make it executable:

    ```
    chmod +x squatter/squatter.sh
    ```

## Usage

Run the script using the following syntax:

## Options:

- `-f, --filter` File containing string patterns (one pattern per line) to match in URLs
- `-o, --output` Write the output to a file instead of printing to stdout
- `-r, --raw` Display raw certstream output
- `-h, --help` Display the help message

## Examples:
```
./squatter.sh -f patterns.txt
  - This command filters certstream using patterns from 'patterns.txt'

./squatter.sh -f patterns.txt -o output.txt
  - This command writes the output to 'output.txt'

./squatter.sh -r
  - This command displays raw certstream output.
```
