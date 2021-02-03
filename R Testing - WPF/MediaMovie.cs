using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace R_Testing___WPF
{
    class MediaMovie
    {
        public Guid? movieUid;
        public string movieTitle, networkName, synopsis, lastMaintenanceUser, connectionString, errorMessage;
        public DateTime releaseDate, addDateTime, lastMaintenanceDateTime;
        public short returnCode;
        public short? networkId;
        public string txtMovieTitle, dpReleaseDate;

        public void ValidateMovieTitle()
        {
            if (txtMovieTitle.Trim() == "")
            {
                returnCode = 21;
                errorMessage = "Movie Title required!";
                return;
            }

            movieTitle = txtMovieTitle;
        }

        public void ValidateReleaseDate()
        {
            if (dpReleaseDate == null || dpReleaseDate == "")
            {
                returnCode = 22;
                errorMessage = "Release Date required!";
                return;
            }

            releaseDate = Convert.ToDateTime(dpReleaseDate);
        }

        public void AddMovie()
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

            dbConnection.sqlString = "exec Media.AddMovie @movieTitle = @movieTitle, @releaseDate = @releaseDate";

            SqlParameter parmMovieTitle = new SqlParameter("@movieTitle", SqlDbType.NVarChar, 100);
            parmMovieTitle.Value = movieTitle;
            dbConnection.sqlCommand.Parameters.Add(parmMovieTitle);

            SqlParameter parmReleaseDate = new SqlParameter("@releaseDate", SqlDbType.Date);
            parmReleaseDate.Value = releaseDate;
            dbConnection.sqlCommand.Parameters.Add(parmReleaseDate);

            if (networkId != null && networkId > 0)
            {
                SqlParameter parmNetworkId = new SqlParameter("@networkId", SqlDbType.SmallInt);
                parmNetworkId.Value = networkId;
                dbConnection.sqlCommand.Parameters.Add(parmNetworkId);
                dbConnection.sqlString += ", @networkId = @networkId";
            }

            if (networkName != null && networkName != "")
            {
                SqlParameter parmNetworkName = new SqlParameter("@networkName", SqlDbType.NVarChar, 50);
                parmNetworkName.Value = networkName;
                dbConnection.sqlCommand.Parameters.Add(parmNetworkName);
                dbConnection.sqlString += ", @networkName = @networkName";
            }

            if (synopsis != null && synopsis != "")
            {
                SqlParameter parmSynopsis = new SqlParameter("@synopsis", SqlDbType.NVarChar, -1);
                parmSynopsis.Value = synopsis;
                dbConnection.sqlCommand.Parameters.Add(parmSynopsis);
                dbConnection.sqlString += ", @synopsis = @synopsis";
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

        public void GetMovieDetails()
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

            dbConnection.sqlString = "exec Media.GetMovieDetails ";

            if (movieUid != null)
            {
                SqlParameter parmMovieUid = new SqlParameter("@movieUid", SqlDbType.UniqueIdentifier);
                parmMovieUid.Value = movieUid;
                dbConnection.sqlCommand.Parameters.Add(parmMovieUid);
                dbConnection.sqlString += "@movieUid = @movieUid";
            }
            else
            {
                SqlParameter parmMovieTitle = new SqlParameter("@movieTitle", SqlDbType.NVarChar, 107);
                parmMovieTitle.Value = movieTitle;
                dbConnection.sqlCommand.Parameters.Add(parmMovieTitle);
                dbConnection.sqlString += "@movieTitle = @movieTitle";
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

            // need a record count to error out here

            // Movie UID - 0 uniqueidentifier
            movieUid = new Guid(String.Format("{0}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]));

            // Movie Title - 1 nvarchar(100)
            movieTitle = String.Format("{1}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]);

            // Release Date - 2 date
            releaseDate = Convert.ToDateTime(String.Format("{2}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]));

            // NetworkId - 3 smallint
            if (String.Format("{3}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]) != "")
                networkId = Convert.ToInt16(String.Format("{3}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]));

            // Network Abbreviation - 4 nvarchar(10)
            // not captured

            // Network Name - 5 nvarchar(50)
            networkName = String.Format("{5}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]);

            // Channel Number - 6 decimal(7,2)
            // not captured

            // Synopsis - 7 nvarchar(max)
            synopsis = String.Format("{7}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]);

            // Add Date Time - 7 datetime2
            addDateTime = Convert.ToDateTime(String.Format("{8}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]));

            // Last Maintenance Date Time - 8 datetime
            lastMaintenanceDateTime = Convert.ToDateTime(String.Format("{9}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]));

            // Last Maintenance User - 9 nvarchar(50)
            lastMaintenanceUser = String.Format("{10}", record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7], record[8], record[9], record[10]);

            dbConnection.CloseReader();
            dbConnection.CloseConnection();
        }

        public void UpdateMovie()
        {
            DatabaseConnection dbConnection = new DatabaseConnection();
            dbConnection.connectionString = connectionString;
            dbConnection.sqlString = "exec Media.UpdateMovie @movieUid = @movieUid, @movieTitle = @movieTitle, @releaseDate = @releaseDate";

            dbConnection.OpenConnection();

            if (dbConnection.returnCode != 0)
            {
                returnCode = dbConnection.returnCode;
                errorMessage = dbConnection.errorMessage;
                return;
            }

            dbConnection.sqlCommand = new SqlCommand();

            SqlParameter parmMovieUid = new SqlParameter("@movieUid", SqlDbType.UniqueIdentifier);
            parmMovieUid.Value = movieUid;
            dbConnection.sqlCommand.Parameters.Add(parmMovieUid);

            SqlParameter parmMovieTitle = new SqlParameter("@movieTitle", SqlDbType.NVarChar, 100);
            parmMovieTitle.Value = movieTitle;
            dbConnection.sqlCommand.Parameters.Add(parmMovieTitle);

            SqlParameter parmReleaseDate = new SqlParameter("@releaseDate", SqlDbType.Date);
            parmReleaseDate.Value = releaseDate;
            dbConnection.sqlCommand.Parameters.Add(parmReleaseDate);

            if (networkId != null && networkId > 0)
            {
                SqlParameter parmNetworkId = new SqlParameter("@networkId", SqlDbType.SmallInt);
                parmNetworkId.Value = networkId;
                dbConnection.sqlCommand.Parameters.Add(parmNetworkId);
                dbConnection.sqlString += ", @networkId = @networkId";
            }
            else
            {
                SqlParameter parmNetworkName = new SqlParameter("@networkName", SqlDbType.NVarChar, 50);
                parmNetworkName.Value = networkName;
                dbConnection.sqlCommand.Parameters.Add(parmNetworkName);
                dbConnection.sqlString += ", @networkName = @networkName";
            }

            if (synopsis != null && synopsis != "")
            {
                SqlParameter parmSynopsis = new SqlParameter("@synopsis", SqlDbType.NVarChar, -1);
                parmSynopsis.Value = synopsis;
                dbConnection.sqlCommand.Parameters.Add(parmSynopsis);
                dbConnection.sqlString += ", @synopsis = @synopsis";
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
    }
}
