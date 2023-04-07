using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;
using System.IO;
using System.Threading;

namespace COMGate
{
    public partial class FormMain : Form
    {
        public FormMain()
        {
            InitializeComponent();
        }

        private SerialPort serial;
        private static int PORTSPEED = 9600 ;
        private static int BLOCKSIZE = 1024;
        private static byte[] NEXTMARKER = Encoding.ASCII.GetBytes("NEXT");
        private static byte[] HEADERFILE = Encoding.ASCII.GetBytes("FILE");
        private static int HEADERSIZE = 4;
        private static int LONGSIZE = 4;

        private void reloadComList()
        {
            comboPorts.Items.Clear();
            foreach (string portName in SerialPort.GetPortNames())
                comboPorts.Items.Add(portName);
            comboPorts.SelectedIndex = 0;
        }

        private void butDetect_Click(object sender, EventArgs e)
        {
            reloadComList();
        }

        private void addLog(string log)
        {
            textLog.AppendText(log + Environment.NewLine);
        }
        
        private void FormMain_Load(object sender, EventArgs e)
        {
            reloadComList();
        }

        private void port1_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            //Thread.Sleep(1);
            //byte DATA = Convert.ToByte(e.EventType==SerialData. serialPort1.ReadByte());
            //Console.WriteLine(DATA);        
            int cnt = serial.BytesToRead;
            byte[] data = new byte[cnt];
            serial.Read(data, 0, cnt);
            string str = Encoding.GetEncoding("CP866").GetString(data) ;
            textLog.Invoke(new Action(() => { addLog(str); }));
            //addLog("get: "+Encoding.GetEncoding("CP866").GetString(data));
        }

        private void butOpen_Click(object sender, EventArgs e)
        {
            String name = ((string)comboPorts.SelectedItem);
            serial = new SerialPort(name, PORTSPEED, System.IO.Ports.Parity.None, 8, StopBits.One);
            serial.Open();
            //serial.DataReceived+=new SerialDataReceivedEventHandler(port1_DataReceived) ;
            addLog("Порт открыт на скорости "+PORTSPEED.ToString("D"));
            butClose.Show();
            panel1.Show();
            butOpen.Hide();
        }

        private void butClose_Click(object sender, EventArgs e)
        {            
            serial.Close();
            addLog("Порт закрыт");
            butClose.Hide();
            panel1.Hide();
            butOpen.Show();
        }

        private void butSend_Click(object sender, EventArgs e)
        {
            byte[] data = Encoding.GetEncoding("CP866").GetBytes(textMsg.Text);
            serial.Write(data, 0, data.Length);
            addLog("send: " + textMsg.Text);
        }

        private byte[] waitAndReadNBytes(int cnt)
        {
            while (serial.BytesToRead < cnt) { Application.DoEvents(); Thread.Sleep(1); };
            byte[] buf = new byte[cnt];
            serial.Read(buf, 0, cnt);
            return buf;
        }
        
        private void butSendFile_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog()!=DialogResult.OK) return ;
            string filename = openFileDialog1.FileName;

            DateTime fix = DateTime.Now;

            //string filename = @"F:\testfile";
            byte[] bsize = null;
            byte[] bsum = null;
            byte[] data = DataPacker.enpackFile(filename, out bsize, out bsum);
            
            serial.Write(HEADERFILE, 0, HEADERFILE.Length);
            serial.Write(bsize, 0, bsize.Length);
            serial.Write(bsum, 0, bsum.Length);
            waitAndReadNBytes(NEXTMARKER.Length);              

            int p = 0;
            while (p < data.Length)
            {
                int len = BLOCKSIZE;
                if (p + BLOCKSIZE >= data.Length) len = data.Length - p;
                addLog(String.Format("send at {0}, bc={1} from {2} bytes ({3}%)", 
                    p, len, data.Length, (int)(100*p/data.Length)));
                
                serial.Write(data, p, len);
                                
                p += BLOCKSIZE;
                if (p < data.Length) waitAndReadNBytes(NEXTMARKER.Length);
            }
            int sec = (int)(DateTime.Now-fix).TotalSeconds ;
            addLog(String.Format("send ok, sec: {0}, speed: {1} byte/s, expected: {2} byte/s",sec.ToString("D"),
                (data.Length/sec).ToString("D"),(PORTSPEED/9).ToString("D"))) ;             
        }

        private void butGetFile_Click(object sender, EventArgs e)
        {            
            addLog("Waiting data") ;

            byte[] header = waitAndReadNBytes(HEADERSIZE);
            addLog("Header: " + Encoding.ASCII.GetString(header));

            byte[] bsize = waitAndReadNBytes(LONGSIZE);
            uint filesize = DataPacker.BytesToUint(bsize);
            addLog("FileSize: " + filesize.ToString("D"));
            
            byte[] bsum = waitAndReadNBytes(LONGSIZE);
            uint checksum = DataPacker.BytesToUint(bsum);            
            addLog("CheckSum: " + checksum.ToString("D"));
                        
            serial.Write(NEXTMARKER, 0, NEXTMARKER.Length);
            
            int p = 0 ;
            var bytes = new List<byte[]>() ;
            while (p < filesize)
            {
                int len = BLOCKSIZE;
                if (p + BLOCKSIZE >= filesize) len = (int)filesize - p;
                bytes.Add(waitAndReadNBytes(len));

                addLog(String.Format("get {0}, bc={1} from {2} bytes ({3}%)",
                    p, len, filesize, (int)(100 * p / filesize)));

                p += BLOCKSIZE;
                if (p < filesize) serial.Write(NEXTMARKER, 0, NEXTMARKER.Length);                               
            }

            if (saveFileDialog1.ShowDialog()!=DialogResult.OK) return ;
            string filename = saveFileDialog1.FileName;
            //string filename = @"F:\getfile";

            uint calcchecksum;
            DataPacker.writeFile(filename, bytes, out calcchecksum);

            if (calcchecksum != checksum) addLog("Error checksum!!!"); else addLog("Save file OK");
        }

        private void butGetIncom_Click(object sender, EventArgs e)
        {
            while (true)
            {
                while (serial.BytesToRead == 0) { Application.DoEvents(); Thread.Sleep(1); };
                int cnt = serial.BytesToRead;
                byte[] buf = new byte[serial.BytesToRead];
                serial.Read(buf, 0, cnt);
                for (int i = 0; i < cnt; i++)
                    addLog(buf[i].ToString("D"));
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            uint v = 12345;
            byte[] b = DataPacker.uintToBytes(v);
            for (int i = 0; i < 4; i++)
                addLog(b[i].ToString("D"));
            uint v2 = DataPacker.BytesToUint(DataPacker.uintToBytes(v));
            addLog(v.ToString("D"));
            addLog(v2.ToString("D"));
            if (v == v2) MessageBox.Show("OK"); else MessageBox.Show("err");
        }
                
    }
}
