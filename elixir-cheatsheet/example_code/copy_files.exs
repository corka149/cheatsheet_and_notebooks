# Copy files and name them by their modify date
defmodule FileCopy do

  def create_new_path(old_path, file) do
    path = Path.join [old_path, file]
    {:ok, %{mtime: modified}} = File.lstat(path)
    {{yy, mm, dd}, {hour, min, _}} = modified
    mm = two_diggest(mm)
    dd = two_diggest(dd)
    hour = two_diggest(hour)
    min = two_diggest(min)
    {path, Path.join [old_path, "new", "#{yy}-#{mm}-#{dd}_#{hour}-#{min}_urlaub"]}
  end

  def two_diggest(i) do
    if i < 10, do: "0" <> Integer.to_string(i), else: i
  end

  def cp(old_path, file) do
    {old, new} = create_new_path(old_path, file)
    File.cp(old, new)
  end
end


target = "urlaub"
{:ok, files} = File.ls target
:ok = File.mkdir_p(Path.join([target, "new"]))
Enum.map(files, fn file -> FileCopy.cp(target, file) end)

