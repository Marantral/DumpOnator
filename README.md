

# DumpOnator

**DumpOnator** is a simple Bash script that automates network packet captures using `tcpdump`. It quickly creates a set of capture files of specified size for analysis or troubleshooting, making repetitive capture tasks easy and consistent.

---

## Features

- Capture a customizable number of packet files of specified size
- Flexible command-line options for interface, output location, and average packet size
- Simple to use, with helpful usage instructions
- Logs actions to system logger
- Robust argument validation and error handling
- Works great for automation or quick troubleshooting

---

## Requirements

- Linux/Unix environment
- `bash` (version 4+ recommended)
- `tcpdump` installed and available in your `$PATH`

---

## Installation

Clone the repository:
```sh
git clone https://github.com/Marantral/DumpOnator.git
cd DumpOnator
```

Make the script executable:
```sh
chmod +x DumpOnator.sh
```

---

## Usage

### Basic Example

```sh
./DumpOnator.sh -s 10 -n 5
```
This will capture 5 files, each 10 MB in size, from the default interface (`eth0`) and save them to `/tmp`.

### Full Options

| Option             | Description                                 | Default    |
|--------------------|---------------------------------------------|------------|
| `-s`, `--size`     | File size per capture (in MB) **[required]**|            |
| `-n`, `--num`      | Number of files to create **[required]**    |            |
| `-i`, `--interface`| Network interface to capture from           | eth0       |
| `-p`, `--pkt-size` | Average packet size in bytes                | 1          |
| `-o`, `--output`   | Output directory for capture files          | /tmp       |
| `-h`, `--help`     | Show help and usage                         |            |

#### Example with all options

```sh
./DumpOnator.sh -s 20 -n 3 -i eth1 -p 1500 -o /captures
```

---

## How It Works

- **File count and size:**  
  Specify how many capture files and their size in megabytes.
- **Interface:**  
  Choose which network interface to capture from.
- **Output:**  
  Files are saved in the specified directory, named `packetcapture`, as rotated by tcpdump.
- **Average packet size:**  
  Used to estimate how many packets to capture in total.
- **Logging:**  
  Key actions are logged using the `logger` command.

---

## Example Commands

Capture 4 files of 5MB each from default interface:
```sh
./DumpOnator.sh -s 5 -n 4
```

Change output directory and interface:
```sh
./DumpOnator.sh -s 10 -n 3 -i eth1 -o /var/tmp
```

Show help:
```sh
./DumpOnator.sh -h
```

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Contributing

Pull requests and feature suggestions are welcome!  
If you find a bug or have ideas for improvement, please open an [issue](https://github.com/Marantral/DumpOnator/issues).

---

## Disclaimer

Use responsibly and only on networks you are authorized to monitor.

---