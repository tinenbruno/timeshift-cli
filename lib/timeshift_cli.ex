defmodule TimeshiftCLI do
  @moduledoc """
  Documentation for TimeshiftCLI.
  """

  alias GoogleApi.Sheets.V4.{Api.Spreadsheets, Connection}

  @spreadsheet_id "1mORTn0sZ7GyX_T8KmiQyy8DuGDOWX6oOFUbDcn6fPnc"
  @header_size 5
  @sheet_name "Sheet1"
  @kinds ~w(shift_start lunch_start lunch_end shift_end extra_start extra_end)a
  @column_kinds %{
    shift_start: "C",
    lunch_start: "D",
    lunch_end: "E",
    shift_end: "F",
    extra_start: "G",
    extra_end: "H"
  }

  @spec get_formatted_time(%DateTime{}) :: String.t()
  def get_formatted_time(%DateTime{} = datetime) do
    {:ok, datetime} = datetime |> round_time |> Timex.format("%H:%M", :strftime)
    datetime
  end

  @spec set_time(%DateTime{}, atom()) :: map()
  def set_time(current_time, kind) when kind in @kinds do
    range = build_range(kind)
    update_time(range, current_time)
  end

  def set_time(_current_time, _kind),
    do: raise(ArgumentError, message: "Invalid kind. Please, use one of #{inspect(@kinds)}")

  defp update_time(range, current_time) do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")

    Connection.new(token.token)
    |> Spreadsheets.sheets_spreadsheets_values_update(
      @spreadsheet_id,
      range,
      valueInputOption: "USER_ENTERED",
      body: "{values: [['#{current_time}']]}"
    )
  end

  defp build_range(kind) do
    "'#{@sheet_name}'!#{@column_kinds[kind]}#{days_from_start_of_year() + @header_size}"
  end

  defp days_from_start_of_year() do
    Timex.local()
    |> Timex.diff(Timex.beginning_of_year(Timex.local()), :days)
  end

  defp round_time(%DateTime{minute: minute} = current_date_time) when minute <= 5,
    do: %DateTime{current_date_time | minute: 0}

  defp round_time(%DateTime{minute: minute} = current_date_time) when minute > 5 and minute <= 20,
    do: %DateTime{current_date_time | minute: 15}

  defp round_time(%DateTime{minute: minute} = current_date_time)
       when minute > 20 and minute <= 35,
       do: %DateTime{current_date_time | minute: 30}

  defp round_time(%DateTime{minute: minute} = current_date_time)
       when minute > 35 and minute <= 50,
       do: %DateTime{current_date_time | minute: 45}

  defp round_time(%DateTime{hour: hour, minute: minute} = current_date_time) when minute > 50,
    do: %DateTime{current_date_time | minute: 0, hour: hour + 1}
end
