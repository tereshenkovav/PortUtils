using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace COMGate
{
    public class DataPacker
    {
        private static uint QB_MAX_LONG = 2147483647;

        private static void incCheckSum(ref uint checksum, byte b)
        {
            checksum += b;
            if (checksum > QB_MAX_LONG) checksum -= QB_MAX_LONG;
        }

        public static byte[] uintToBytes(uint v)
        {
            byte[] sz = new byte[4];
            const uint MASK = 0xFF;
            for (int i = 0; i < 4; i++)
            {
                sz[i] = (byte)(v & MASK);
                v = v >> 8;
            }
            return sz;
        }

        public static uint BytesToUint(byte[] data)
        {
            uint r = 0;
            uint v = 1;
            for (int i = 0; i < 4; i++)
            {
                r += v * data[i];
                v *= 256;
            }
            return r;
        }

        public static byte[] enpackFile(string filename, out byte[] bsize, out byte[] bsum)
        {            
            byte[] fileb = File.ReadAllBytes(filename);            

            uint sum = 0 ;
            foreach (byte b in fileb)
                incCheckSum(ref sum, b);
            
            uint size = (uint)fileb.Length ;
            bsize = uintToBytes(size) ;            
            bsum = uintToBytes(sum) ;
            
            return fileb;
        }

        public static bool writeFile(string filename, List<byte[]> bytes, out uint checksum) 
        {
            checksum = 0;
            BinaryWriter writer = new BinaryWriter(File.OpenWrite(filename));
            for (int i = 0; i < bytes.Count; i++)
            {
                writer.Write(bytes[i]);
                foreach (var b in bytes[i]) 
                    incCheckSum(ref checksum, b);
            }
            writer.Close() ;

            return true;
        }
    }
}
