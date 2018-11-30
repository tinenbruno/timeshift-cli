# TimeshiftCLI

A timeshift CLI app to interact with Google Sheets and register your working hours.

## Requirements

The CLI usage is an [escript](http://erlang.org/doc/man/escript.html) meaning that you need to install Erlang to use it. To build it you will also need to install Elixir.

Both can be installed using [asdf](https://github.com/asdf-vm/asdf). Further instruction can be found on `asdf` repository.

## Usage

Run the CLI with:

```
> ./timeshift_cli
No command provided
usage: timeshift <command> [<args>]

Commands
   register   Register a time on the timeshift. Must be one of: shift_start lunch_start lunch_end shift_end extra_start extra_end
```

To register a time for the current day and `kind` run:

```
> ./timeshift_cli register shift_start
```

## Build

To build a new version of the CLI with changes on configuration you need to fetch dependencies and the run the escript mix build task:

```
> mix deps.get
> mix escript.build
```

Note that to the build to succeed it is necessary to create a `creds.json` file on the `/.secret` folder on the project root. This credential file is obtained from Google API (https://console.cloud.google.com/apis/credentials).

The `spreadsheet_id` can be obtained from your Google Sheets URL. For example, in this URL `https://docs.google.com/spreadsheets/d/1H0zR6CTc5EqqAR-nBhDoS6-Uo6cEDwzsaxfCIcGvyxE/edit#gid=0` the `spreadsheet_id` is `1H0zR6CTc5EqqAR-nBhDoS6-Uo6cEDwzsaxfCIcGvyx`. The `header_size` is the amount of rows skiped before logging the first day of the year hours. `sheet_name` is the name of the sheet from the spreadsheet in which you want to register your hours on.

It is important to notice that for this to work the spreadsheet must be accessible by the owner of the credentials you informed to build the project on. This means that either the user (identified on `creds.json` by `client_email`) needs to be added to the spreadsheet or the spreadsheet must be set to public edit.
