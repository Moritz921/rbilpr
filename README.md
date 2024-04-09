# rbilpr

This repository implements a local command `rbilpr` to print on the servers of the RBI in the Goethe University Frankfurt. 

## Installation

The file `rbilpr` needs to be in PATH (Tip: in most Linux/Unix Systems the directory `~/.local/bin` is already in `$PATH`). 
On the RBI side, the file `remotelpr` needs to be in its PATH and a directory called `PDF` must be created in your home directory. Caution: it doesnt't work if the file is in `~/bin`!

Make sure, that both files are executable (`chmod +x $file`). 

This command uses aliases for the rbi Servers. To add them to your ssh config file, you can use the script in [`populateSSHconfig.sh`](populateSSHconfig.sh) like so:

```bash
./populateSSHconfig.sh s1234567
```

## Usage

After installation, you *should* be able to print on your local machine using the `rbilpr` command:

```bash
rbilpr example.pdf example2.pdf
```

The command (tries to) print all files which are given to it as parameters. After successfull printing it moves the file into a directory called `PDF` on the RBI servers. 
