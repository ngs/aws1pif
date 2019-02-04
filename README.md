# aws1pif

CLI tool to convert AWS credentials.csv to 1Password `.1pif` file.

```sh
go install github.com/ngs/aws1pif
```

## Usage

```sh
cat ~/Downloads/credentials.csv | aws1pif > aws.1pif
open aws.1pif
```
