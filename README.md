## About the project

KDBX 4.x format (Keepass >=2.36) is not supported by `keepass2john` yet, so there is no known way to extract the hash and crack it.

This tool is a quick and dirty patch for the current situation. It tries to bruteforce the passphrase testing a provided wordlist directly against the db file.


## Dependencies

+ keepassxc-cli


## Usage

```shell
./keepass4brute.sh <kdbx-file> <wordlist>
```


## References

JohnTheRipper related code comments and issue:
+ https://github.com/openwall/john/blob/ea33667eb5e1a650ecb6b4985125f4efa0955594/src/keepass2john.c#L81
+ https://github.com/openwall/john/issues/2502
