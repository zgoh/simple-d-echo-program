import std.stdio;
import std.socket;
import std.string;
import std.conv:to;

void main(string[] argv)
{
  writeln("Specify port to run the server on.");
  write("Port: ");

  const auto port = to!ushort(chomp(readln()));
  const auto results = getAddressInfo("", AddressFamily.INET);
  const auto address = results[0].address.toAddrString();

  // Open sockets here
  writeln("Creating socket...");
  auto listener = new TcpSocket;
  listener.bind(new InternetAddress(port));
  listener.listen(10);

  writeln("Current server address: ", address);
  writeln("Listening on port: ", port);
  writeln("Server is running, waiting for connections...");

  while (true)
  {
    auto conn = listener.accept();
    while (true)
    {
      char[256] buffer;
      const auto len = conn.receive(buffer);

      if (len > 0)
      {
        const auto str = buffer[0..len];
        writeln("Received: ", str);

        // Echo back
        conn.send(str);
        continue;
      }

      if (len == Socket.ERROR)
      {
        writeln("Connection closed");
      }

      break;
    }

    conn.close();
  }
}