defmodule Dbus do
  @moduledoc """
  Módulo que implementa o compoñente repositorio.

  É un proceso que garda nunha keyword list a información que recibe
  e permite consultala.

  Implementado con `GenServer` para poder supervisalo.
  """

  use GenServer

  require Logger

  # public API

  @doc """
  Inicia o compoñente repositorio.

  ## Exemplos:

      iex> Dbus.start()
      :ok
      iex> Process.whereis(Dbus) |> Process.alive?
      true
      iex> Dbus.stop()

  """
  @spec start() :: :ok
  def start() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
    :ok
  end

  @doc """
  Recibe información.

  ## Exemplos:

     iex> Dbus.start()
     iex> Dbus.put(:etiqueta, "Información")
     :ok
     iex> Dbus.stop()

  """
  @spec put(atom(), term()) :: :ok
  def put(tag, info) do
    GenServer.cast(__MODULE__, {:add_info, tag, info})
  end

  @doc """
  Devolve información.

  ## Examplos:

      iex> Dbus.start()
      iex> Dbus.put(:etiqueta, "Información")
      iex> Dbus.get(:etiqueta)
      {:ok, "Información"}
      iex> Dbus.stop()

  """
  @spec get(atom()) :: {:ok, term()}
  def get(tag) do
    {:ok, GenServer.call(__MODULE__, {:get_info, tag})}
  end

  @doc """
  Para o compoñente repositorio.

  ## Exemplos:

     iex> Dbus.start()
     iex> Dbus.stop()
     iex> Process.whereis(Dbus)
     nil

  """
  @spec stop() :: :ok
  def stop() do
    GenServer.stop(__MODULE__)
  end

  # GenServer callbacks
  @impl true
  def init(_init_arg) do
    Logger.info("GenServer Dbus initialized")
    {:ok, Keyword.new()}
  end

  @impl true
  def handle_call({:get_info, tag}, _from, data) do
    Logger.info("Got new data request: #{tag}")
    {:reply, Keyword.get(data, tag), data}
  end

  @impl true
  def handle_cast({:add_info, tag, info}, data) do
    Logger.info("Got new data: {#{tag}, #{info}}")
    {:noreply, Keyword.put(data, tag, info)}
  end
end
