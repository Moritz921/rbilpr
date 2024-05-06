# rbilpr

This repository implements a local command `rbilpr` to print on the servers of the RBI in the Goethe University Frankfurt. 

## Installation and Update

### Automatic

To install or update the script, simply use the provided `setup.sh` script. The working directory doesn't matter, as the script will copy the files to the correct location, but the files `rbilpr`, `remotelpr`, `populateSSHconfig.sh` and `setupRBI.sh` need to be present in the same directory. You will be asked before changes are made. If you accept, the `rbilpr` script will be pasted to `~/.local/bin`.

To use the setup script, run the script with your username as an argument:

```bash
./setup.sh s1234567
```

### Manuel

The file `rbilpr` needs to be in PATH (Tip: in most Linux/Unix Systems the directory `~/.local/bin` is already in `$PATH`). 
On the RBI side, the file `remotelpr` needs to be in its PATH and a directory called `PDF` must be created in your home directory. Caution: it doesnt't work if the file is in `~/bin`!

Make sure, that both files are executable (`chmod +x $file`). 

This command uses aliases for the rbi Servers. To add them to your ssh config file, you can use the script in [`populateSSHconfig.sh`](populateSSHconfig.sh) like so:

```bash
./populateSSHconfig.sh s1234567
```

### Dependencies

This command depends on `gnu-getopt`. In most Linux systems it is preinstalled, in macOS it can be installed with `brew install gnu-getopt` or `brew install util-linux`. Make sure that it is symlinked correctly. 

## Usage

After installation, you *should* be able to print on your local machine using the `rbilpr` command:

```bash
rbilpr example.pdf example2.pdf
```

The command (tries to) print all files which are given to it as parameters. After successfull printing it moves the file into a directory called `PDF` on the RBI servers. 

The following flags are available:

| Flag | Description |
|------|-------------|
|`-b`/`--banner`|Prints a banner page (Defaults to no banner page)|
|`-f`/`--forms`|Prints files without removing form fields|
|`-n`/`--number`|Sets the number of copies|
|`-s`/`--single-sided`|Prints on one side of the paper|
|`-h`/`--help`|Outputs the help message|
