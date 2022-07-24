defmodule Newsletter do
  def read_emails(path) do
    File.read(path)
    |> elem(1)
    |> String.split("\n", trim: true)
  end

  def open_log(path), do: File.open(path, [:write]) |> elem(1)

  def log_sent_email(pid, email), do: IO.write(pid, "#{email}\n")

  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun) when not(is_pid(send_fun)) do
    pid = open_log(log_path)
    read_emails(emails_path)
    |> Enum.each(&(send_newsletter(&1, send_fun, pid)))
    close_log(pid)
  end

  def send_newsletter(email, send_fun, pid) do
    if(send_fun.(email) == :ok, do: log_sent_email(pid, email))
  end

end
