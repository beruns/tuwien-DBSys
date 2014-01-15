package java_part;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Date;

public class Szenario3 {

    private Connection connection = null;

    public static void main(String[] args) {
        if (args.length <= 5 && args.length >= 3) {
            /*
             * args[1] ... server, 
             * args[2] ... port,
             * args[3] ... database, 
             * args[4] ... username, 
             * args[5] ... password
             */

            Connection conn = null;

            if (args.length == 3) {
                conn = DBConnector.getConnection(args[0], args[1], args[2]);
            } 
            else {
                if (args.length == 4) {
                    conn = DBConnector.getConnection(args[0], args[1], args[2], args[3], "");
                } 
                else {
                    conn = DBConnector.getConnection(args[0], args[1], args[2], args[3], args[4]);
                }
            }

            if (conn != null) {
                Szenario3 s = new Szenario3(conn);

                s.run();
            }

        } 
        else {
            System.err.println("Ungueltige Anzahl an Argumenten!");
        }
    }

    public Szenario3(Connection connection) {
        this.connection = connection;
    }

    public void run() {
        calcAndPrintGehaelter();
    }

    /*
     * Beschreibung siehe Angabe
     */
    public void calcAndPrintGehaelter() {
        // TODO Write your code here
	try {

		PreparedStatement ps = connection.prepareStatement("SELECT f_calc_salary(?, ?);");

		java.sql.Date dt = new java.sql.Date(System.currentTimeMillis());
		ps.setDate(2, dt);

		Statement s = connection.createStatement();
		ResultSet r = s.executeQuery("SELECT svnr FROM mitarbeiter");

		while(r.next()) {

			String svnr = r.getString("svnr");
			
			ps.setString(1, svnr);

			ResultSet rs2 = ps.executeQuery();
			if(rs2.next()) {

				System.out.println(svnr + ", " + dt + ", " + rs2.getDouble(1));
			}

			rs2.close();
		}

		r.close();
		s.close();
		ps.close();
		connection.commit();


	} catch (SQLException ex) {
	
		Logger.getLogger(Szenario3.class.getName()).log(Level.SEVERE, null, ex);

	}
    }
}
