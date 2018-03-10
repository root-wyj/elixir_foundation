defmodule WebsocketWeb.RoomChannel do
    use Phoenix.Channel

    def join("room:lobby", _message, socket) do
        {:ok, socket}
    end

    def josin("room:" <> _private_room_id, _params, _socket) do
        {:error, %{reason: "unauthorized"}}
    end
end