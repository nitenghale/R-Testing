using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace R_Testing___WPF
{
    class DatabaseConnection
    {
        public SqlConnection sqlConnection;
        public string sqlString, errorMessage, connectionString;
        public SqlCommand sqlCommand;
        public SqlDataReader sqlReader;
        public short returnCode = 0;
        public SqlDataAdapter sqlAdapter;
        public DataSet sqlDataSet;
        public DataTable dataTable;

        public void OpenConnection()
        {
            sqlConnection = new SqlConnection(connectionString);

            try
            {
                sqlConnection.Open();
            }
            catch (Exception ex)
            {
                returnCode = 3;
                errorMessage = ex.Message;
            }
        }

        public void ExecuteCommand()
        {
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = sqlString;

            try
            {
                sqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                returnCode = 1;
                errorMessage = ex.Message;
            }
        }

        public void ReadTable()
        {
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = sqlString.ToString();

            try
            {
                sqlReader = sqlCommand.ExecuteReader();
            }
            catch (Exception ex)
            {
                returnCode = 2;
                errorMessage = ex.Message;
                CloseReader();
            }
        }

        public void SqlAdapter()
        {
            sqlAdapter = new SqlDataAdapter(sqlString, sqlConnection);
            sqlDataSet = new DataSet();
            dataTable = new DataTable();

            try
            {
                sqlAdapter.Fill(sqlDataSet);
            }
            catch (Exception ex)
            {
                returnCode = 4;
                errorMessage = ex.Message;
                CloseConnection();
            }
        }

        public void CloseReader()
        {
            sqlReader.Close();
        }

        public void CloseConnection()
        {
            sqlConnection.Close();
        }
    }
}
