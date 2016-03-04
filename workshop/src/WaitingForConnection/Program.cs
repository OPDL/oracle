using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;

namespace WaitingForConnection
{
    class Program
    {
        static void Main(string[] args)
        {
            // Lets prime the pump and get the pool initialized
            InitialQuery();

            // Sleep for a second so it is easier to observe the demo            
            Thread.Sleep(1000);
            Console.WriteLine();

            TaskFactory tf = new TaskFactory();    // Task Factory to create some parallel tasks

            // Run the blocking operations
            Task t1 = Task.Factory.StartNew( () => RunTimeConsumingOperation(1) );
            Task t2 = Task.Factory.StartNew( () => RunTimeConsumingOperation(2) );

            // Again, make things easier to observe
            Thread.Sleep(1000);
            Console.WriteLine();

            Console.WriteLine("Two more tasks that need connections - these will need new physical connections");
            Task t3 = Task.Factory.StartNew(() => RunTimeConsumingOperation(3));
            Task t4 = Task.Factory.StartNew(() => RunTimeConsumingOperation(4));

            // Again, make things easier to observe
            Thread.Sleep(5000);  // Sleep for 5 seconds
            Console.WriteLine();

            Console.WriteLine("Two more tasks that need connections - these will block waiting for connections");
            Task t5 = Task.Factory.StartNew(() => BlockedDataAccessOperation(5));
            Task t6 = Task.Factory.StartNew(() => BlockedDataAccessOperation(6));


            Console.ReadKey();
        }


        /// <summary>
        /// This runs an initial query, mainly to get the connection pool initialized
        /// </summary>
        private static void InitialQuery()
        {
            String connectionString = ConfigurationManager.ConnectionStrings["STUDENT"].ConnectionString;
            using (OracleConnection con = new OracleConnection(connectionString))
            {
                // Open the first connection
                Stopwatch sw = Stopwatch.StartNew();                
                con.Open();
                sw.Stop();

                Console.WriteLine("Getting the initial connection - {0}", sw.ElapsedMilliseconds);
                using (OracleCommand cmd = new OracleCommand("SELECT sys_context('USERENV','SID') FROM dual", con))
                {
                    Object oracleSid = cmd.ExecuteScalar();
                }
            }            
        }


        /// <summary>
        /// This runs a query that will sleep for 10 seconds after running the query (while still holding onto the connection)
        /// </summary>
        /// <remarks>
        /// This method is simulating a piece of data access code that is holding onto a connection longer than it should
        /// </remarks>
        /// <param name="connectionNumber"></param>
        private static void RunTimeConsumingOperation(int connectionNumber)
        {

            String connectionString = ConfigurationManager.ConnectionStrings["STUDENT"].ConnectionString;
            using (OracleConnection con = new OracleConnection(connectionString))
            {
                // Open the first connection
                Stopwatch sw = Stopwatch.StartNew();
                
                con.Open();
                sw.Stop();

                Console.WriteLine("Connection time for connection {0}  - {1}", connectionNumber, sw.ElapsedMilliseconds);
                using (OracleCommand cmd = new OracleCommand("SELECT sys_context('USERENV','SID') FROM dual", con))
                {
                    Object oracleSid = cmd.ExecuteScalar();
                    Thread.Sleep(10000);  // Sleep for 10 seconds
                }
            }
            Console.WriteLine("Connection {0} done with its connection", connectionNumber);
        }



        /// <summary>
        /// This method will try to get a connection but have to wait.  It will print out some info about how long it has to wait
        /// </summary>
        /// <param name="connectionNumber"></param>
        private static void BlockedDataAccessOperation(int connectionNumber)
        {
            String connectionString = ConfigurationManager.ConnectionStrings["STUDENT"].ConnectionString;
            using (OracleConnection con = new OracleConnection(connectionString))
            {                
                Stopwatch sw = Stopwatch.StartNew();
                Console.WriteLine("Trying to get a connection for operation {0}", connectionNumber);
                con.Open();
                sw.Stop();

                Console.WriteLine("Connection time for connection {0}  - {1}", connectionNumber, sw.ElapsedMilliseconds);
                using (OracleCommand cmd = new OracleCommand("SELECT sys_context('USERENV','SID') FROM dual", con))
                {
                    Object oracleSid = cmd.ExecuteScalar();                    
                }
            }
            Console.WriteLine("Connection {0} done with its connection", connectionNumber);
        }


    }
}
