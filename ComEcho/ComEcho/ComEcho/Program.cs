using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading ;
using System.IO.Ports ;

namespace ComEcho
{
    class Program
    {
        private static SerialPort serial;
        private static int PORTSPEED = 9600;

        static void Main(string[] args)
        {
            try
            {
                string portname = "";
                if (args.Length == 0)
                {
                    Console.WriteLine("Enter port name [COM1]:");
                    portname = Console.ReadLine();
                }
                else
                    portname = args[0];

                if (portname.Length == 0) portname = "COM1";

                serial = new SerialPort(portname, PORTSPEED, System.IO.Ports.Parity.None, 8, StopBits.One);
                serial.Open();

                while (true)
                {
                    Console.WriteLine("Write message or \"exit\" to quit");
                    string msg = Console.ReadLine();
                    if (msg.Length == 0) Console.WriteLine("Empty message!");
                    else
                    {
                        if (msg.Equals("exit")) break;

                        byte[] data = Encoding.GetEncoding("CP866").GetBytes(msg);

                        int msglen = data.Length;

                        serial.Write(data, 0, msglen);
                        byte end = 0;
                        byte[] endmsg = new byte[] { end };
                        serial.Write(endmsg, 0, endmsg.Length);

                        while (serial.BytesToRead < msglen) { Thread.Sleep(1000); }
                        byte[] buf = new byte[msglen];
                        serial.Read(buf, 0, msglen);

                        string reply = Encoding.GetEncoding("CP866").GetString(buf);

                        Console.WriteLine("Reply:");
                        Console.WriteLine(reply);
                    }
                }

                serial.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: " + e.Message);
            }
        }
    }
}
