defmodule TimeshiftCLI.GoogleSheetsClientTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias TimeshiftCLI.GoogleSheetsClient

  describe "get_formatted_time/1" do
    test "when minutes <= 5 round to 0" do
      formatted_time =
        %DateTime{Timex.local() | hour: 10, minute: 4}
        |> GoogleSheetsClient.get_formatted_time()

      assert formatted_time == "10:00"
    end

    test "when minutes > 5 and <= 20 round to 15" do
      formatted_time =
        %DateTime{Timex.local() | hour: 10, minute: 10}
        |> GoogleSheetsClient.get_formatted_time()

      assert formatted_time == "10:15"
    end

    test "when minutes > 20 and <= 35 round to 0" do
      formatted_time =
        %DateTime{Timex.local() | hour: 10, minute: 23}
        |> GoogleSheetsClient.get_formatted_time()

      assert formatted_time == "10:30"
    end

    test "when minutes > 35 and <= 50 round to 45" do
      formatted_time =
        %DateTime{Timex.local() | hour: 10, minute: 38}
        |> GoogleSheetsClient.get_formatted_time()

      assert formatted_time == "10:45"
    end

    test "when minutes >50 round to 00 and increase hour" do
      formatted_time =
        %DateTime{Timex.local() | hour: 10, minute: 52}
        |> GoogleSheetsClient.get_formatted_time()

      assert formatted_time == "11:00"
    end
  end

  describe "set_time/2" do
    test "raises when kind is invalid" do
      assert_raise(ArgumentError, fn ->
        GoogleSheetsClient.set_time(nil, :invalid_kind)
      end)
    end

    test "sets the time on a Google sheet" do
      use_cassette "set_time" do
        formatted_time =
          Timex.local()
          |> GoogleSheetsClient.get_formatted_time()

        assert GoogleSheetsClient.set_time(formatted_time, :shift_start) ==
                 {:ok,
                  %GoogleApi.Sheets.V4.Model.UpdateValuesResponse{
                    spreadsheetId: "1mORTn0sZ7GyX_T8KmiQyy8DuGDOWX6oOFUbDcn6fPnc",
                    updatedCells: 1,
                    updatedColumns: 1,
                    updatedData: nil,
                    updatedRange: "Sheet1!C338",
                    updatedRows: 1
                  }}
      end
    end
  end
end
