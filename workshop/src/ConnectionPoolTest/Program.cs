using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using Oracle.ManagedDataAccess.Client;

namespace ConnectionPoolTest
{
    class Program
    {
        static void Main(string[] args)
        {
            String connectionString = ConfigurationManager.ConnectionStrings["STUDENT"].ConnectionString;
            if ( args.Length == 1 && args[0] == "NOPOOL")
            {
                connectionString = ConfigurationManager.ConnectionStrings["STUDENT_NOPOOL"].ConnectionString;                
            }
            

            for (int i = 0; i < 5; i++)
            {
                RunSessionIdQuery(i, connectionString);
            }            
        }


        public static void RunSessionIdQuery(int index, String connectionString)
        {
            using (OracleConnection con = new OracleConnection(connectionString))
            {
                // Time how long it takes to open a connection
                Stopwatch sw = Stopwatch.StartNew();
                con.Open();
                sw.Stop();
                Console.WriteLine("Time to get connection on iteration {0}  = {1}", index, sw.ElapsedMilliseconds);

                using (OracleCommand cmd = new OracleCommand("SELECT sys_context('USERENV','SID') FROM dual", con))
                {
                    Object oracleSid = cmd.ExecuteScalar();                    
                }
            }

        }


    }
}
