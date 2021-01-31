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
        public Guid movieUid;
        public string movieTitle, networkName, synopsis, lastMaintenanceUser, connectionString, errorMessage;
        public DateTime addDateTime, lastMaintenanceDateTime;
        public DateTime? releaseDate;
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
    }
}
