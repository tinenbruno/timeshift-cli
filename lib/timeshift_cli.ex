defmodule TimeshiftCLI do
  use ExCLI.DSL, escript: true
  alias TimeshiftCLI.GoogleSheetsClient

  name("timeshift")
  description("Timeshift for FDTE hour tracking")

  long_description(~s"""
  TimeshiftCLI for FDTE hour easy tracking.
  """)

  command :register do
    aliases([:punch])

    description(
      "Register a time on the timeshift. Must be one of: shift_start lunch_start lunch_end shift_end extra_start extra_end"
    )

    argument(:kind)

    run context do
      current_time =
        Timex.local()
        |> GoogleSheetsClient.get_formatted_time()

      GoogleSheetsClient.set_time(current_time, String.to_existing_atom(context.kind))
      IO.puts("Registered #{context.kind} with #{current_time}")
    end
  end
end
