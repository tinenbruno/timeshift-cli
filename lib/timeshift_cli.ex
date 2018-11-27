defmodule TimeshiftCLI do
  @moduledoc """
  Documentation for TimeshiftCLI.
  """

  alias GoogleApi.Sheets.V4.Api.Spreadsheet

  @spreadsheet_id "1mORTn0sZ7GyX_T8KmiQyy8DuGDOWX6oOFUbDcn6fPnc"
  @header_size 5
  @sheet_name "Sheet1"

  def get_spreadsheet do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")
    conn = GoogleApi.Sheets.V4.Connection.new(token.token)
    Spreadsheet.sheets_spreadsheets_get(conn, "1H0zR6CTc5EqqAR-nBhDoS6-Uo6cEDwzsaxfCIcGvyxE")
  end

  def set_time(:start) do
    range = build_range(:start)
    {:ok, current_time} = Timex.local() |> Timex.format("%H:%M", :strftime)
    update_time(range, current_time)
  end

  defp update_time(range, current_time) do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")

    GoogleApi.Sheets.V4.Connection.new(token.token)
    |> GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_values_update(
      @spreadsheet_id,
      range,
      valueInputOption: "USER_ENTERED",
      body: "{values: [['#{current_time}']]}"
    )
  end

  defp build_range(:start) do
    "'#{@sheet_name}'!C#{days_from_start_of_year() + @header_size}"
  end

  defp days_from_start_of_year() do
    Timex.local()
    |> Timex.diff(Timex.beginning_of_year(Timex.local()), :days)
  end
end
