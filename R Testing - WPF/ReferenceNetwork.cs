using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace R_Testing___WPF
{
    class ReferenceNetwork
    {
        public string networkAbbreviation, networkName, lastMaintenanceUser, connectionString, errorMessage;
        public DateTime lastMaintenanceDateTime;
        public short? networkId;
        public short returnCode;
        public decimal? channelNumber;
        public string txtNetworkName, txtChannelNumber;

        public void ValidateNetworkName()
        {
            if (txtNetworkName.Trim() == "")
            {
                returnCode = 11;
                errorMessage = "Network Name required!";
                return;
            }

            networkName = txtNetworkName;
        }

        public void ValidateChannelNumber()
        {
            if (!float.TryParse(txtChannelNumber, out float channelNumberFloat))
            {
                returnCode = 12;
                errorMessage = "Channel Number must be numeric!";
                return;
            }

            if (channelNumberFloat > 99999.99 || channelNumberFloat < 0)
            {
                returnCode = 13;
                errorMessage = "Channel Number must be between 0 and 99,999.99!";
                return;
            }

            channelNumber = Convert.ToDecimal(channelNumberFloat);
        }

        public void AddNetwork()
        {
            DatabaseConnection dbConnection = new DatabaseConnection();
            dbConnection.connectionString = connectionString;
            dbConnection.OpenConnection();

            if (dbConnection.returnCode != 0)
            {
                returnCode = dbConnection.returnCode;
                errorMessage = dbConnection.errorMessage;
            }

            dbConnection.sqlCommand = new SqlCommand();

            dbConnection.sqlString = "exec Reference.AddNetwork @networkName = @networkName";

            SqlParameter parmNetworkName = new SqlParameter("@networkName", SqlDbType.NVarChar, 50);
            parmNetworkName.Value = networkName;
            dbConnection.sqlCommand.Parameters.Add(parmNetworkName);

            if (networkAbbreviation != null)
            {
                SqlParameter parmNetworkAbbreviation = new SqlParameter("@networkAbbreviation", SqlDbType.NVarChar, 10);
                parmNetworkAbbreviation.Value = networkAbbreviation;
                dbConnection.sqlCommand.Parameters.Add(parmNetworkAbbreviation);
                dbConnection.sqlString = dbConnection.sqlString + ", @networkAbbreviation = @networkAbbreviation";
            }

            if (channelNumber != null && channelNumber > 0)
            {
                SqlParameter parmChannelNumber = new SqlParameter("@channelNumber", SqlDbType.Decimal, 7) { Precision = 7, Scale = 2 };
                parmChannelNumber.Value = channelNumber;
                dbConnection.sqlCommand.Parameters.Add(parmChannelNumber);
                dbConnection.sqlString = dbConnection.sqlString + ", @channelNumber = @channelNumber";
            }

            dbConnection.ExecuteCommand();

            if (dbConnection.returnCode != 0)
            {
                returnCode = dbConnection.returnCode;
                errorMessage = dbConnection.errorMessage;
            }

            dbConnection.CloseConnection();

            returnCode = 0;
            errorMessage = "";
        }

        public void GetNetworkDetails()
        {
            DatabaseConnection dbConnection = new DatabaseConnection();
            dbConnection.connectionString = connectionString;
            dbConnection.OpenConnection();

            if (dbConnection.returnCode != 0)
            {
                returnCode = dbConnection.returnCode;
                errorMessage = dbConnection.errorMessage;
            }

            IDataRecord record;
            dbConnection.sqlCommand = new SqlCommand();

            dbConnection.sqlString = "exec Reference.GetNetworkDetails ";

            if (networkId != null && networkId > 0)
            {
                SqlParameter parmNetworkId = new SqlParameter("@networkId", SqlDbType.TinyInt);
                parmNetworkId.Value = networkId;
                dbConnection.sqlCommand.Parameters.Add(parmNetworkId);
                dbConnection.sqlString += "@networkId = @networkId";
            }
            else
            {
                SqlParameter parmNetworkName = new SqlParameter("@networkName", SqlDbType.NVarChar, 50);
                parmNetworkName.Value = networkName;
                dbConnection.sqlCommand.Parameters.Add(parmNetworkName);
                dbConnection.sqlString += "@networkName = @networkName";
            }

            dbConnection.ReadTable();

            if (dbConnection.returnCode != 0)
            {
                returnCode = dbConnection.returnCode;
                errorMessage = dbConnection.errorMessage;
                dbConnection.CloseConnection();
                return;
            }

            dbConnection.sqlReader.Read();
            record = (IDataRecord)dbConnection.sqlReader;

            // Network ID - 0 smallint
            networkId = Convert.ToInt16(String.Format("{0}", record[0], record[1], record[2], record[3], record[4], record[5]));

            // Network Abbreviation - 1 nvarchar(10)
            networkAbbreviation = String.Format("{1}", record[0], record[1], record[2], record[3], record[4], record[5]);

            // Network name - 2 nvarchar(50)
            networkName = String.Format("{2}", record[0], record[1], record[2], record[3], record[4], record[5]);

            // Channel Number - 3 decimal(7, 2)
            channelNumber = Convert.ToDecimal(String.Format("{3}", record[0], record[1], record[2], record[3], record[4], record[5]));

            // LastMaintenanceDateTime - 4 datetime
            lastMaintenanceDateTime = Convert.ToDateTime(String.Format("{4}", record[0], record[1], record[2], record[3], record[4], record[5]));

            // Last Maintenance User - 5 nvarchar(50)
            lastMaintenanceUser = String.Format("{5}", record[0], record[1], record[2], record[3], record[4], record[5]);

            dbConnection.CloseReader();
            dbConnection.CloseConnection();
        }

        public void UpdateNetwork()
        {
            DatabaseConnection dbConnection = new DatabaseConnection();
            dbConnection.connectionString = connectionString;
            dbConnection.sqlString = "exec Reference.UpdateNetwork @networkId = @networkId, @networkName = @networkName";

            dbConnection.OpenConnection();

            if (dbConnection.returnCode != 0)
            {
                returnCode = dbConnection.returnCode;
                errorMessage = dbConnection.errorMessage;
                return;
            }

            dbConnection.sqlCommand = new SqlCommand();

            SqlParameter parmNetworkId = new SqlParameter("@networkId", SqlDbType.SmallInt);
            parmNetworkId.Value = networkId;
            dbConnection.sqlCommand.Parameters.Add(parmNetworkId);

            SqlParameter parmNetworkName = new SqlParameter("@networkName", SqlDbType.NVarChar, 50);
            parmNetworkName.Value = networkName;
            dbConnection.sqlCommand.Parameters.Add(parmNetworkName);

            if (networkAbbreviation != null)
            {
                SqlParameter parmNetworkAbbreviation = new SqlParameter("@networkAbbreviation", SqlDbType.NVarChar, 10);
                parmNetworkAbbreviation.Value = networkAbbreviation;
                dbConnection.sqlCommand.Parameters.Add(parmNetworkAbbreviation);
                dbConnection.sqlString += ", @networkAbbreviation = @networkAbbreviation";
            }

            if (channelNumber != null && channelNumber != 0)
            {
                SqlParameter parmChannelNumber = new SqlParameter("@channelNumber", SqlDbType.Decimal) { Precision = 7, Scale = 2 };
                parmChannelNumber.Value = channelNumber;
                dbConnection.sqlCommand.Parameters.Add(parmChannelNumber);
                dbConnection.sqlString += ", @channelNumber = @channelNumber";
            }

            dbConnection.ExecuteCommand();

            if (dbConnection.returnCode != 0)
            {
                returnCode = dbConnection.returnCode;
                errorMessage = dbConnection.errorMessage;
                dbConnection.CloseConnection();
                return;
            }

            dbConnection.CloseConnection();
        }

        public void GetReferenceNetworkList(DatabaseConnection dbConnection)
        {
            dbConnection.sqlCommand = new SqlCommand();
            dbConnection.sqlString = "exec Reference.ListNetworks";
            dbConnection.ReadTable();
        }
    }
}
