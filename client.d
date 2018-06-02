import std.stdio;
import std.socket;
import std.string;
import std.conv:to;

void main()
{
  writeln("Specify port to run the server on.");
  write("Port: ");

  const auto port = to!ushort(chomp(readln()));

  writeln("Specify address to run the server on.");
  write("Address: ");
  const auto address = chomp(readln());

  auto socket = new TcpSocket;
  assert(socket.isAlive);
  socket.connect(new InternetAddress(address, port));

  writeln("Connected to server.");

  while (true)
  {
    write("> ");
    const auto str = chomp(readln());
    socket.send(str);

    char[256] buf;
    const auto len = socket.receive(buf);
    if (len > 0)
    {
      const auto msg = buf[0..len];
      writeln("Received: ", msg);
      continue;
    }

    if (len == Socket.ERROR)
      writeln("Connection closed.");

    break;
  }
  
  socket.close();
}
