package java_part;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Szenario2 {

	private Connection connection = null;

	public static void main(String[] args) {
		if (args.length <= 6 && args.length >= 4) {
			/*
			 * args[0] ... type -> [a|b], 
			 * args[1] ... server, 
			 * args[2] ... port,
			 * args[3] ... database, 
			 * args[4] ... username, 
			 * args[5] ... password
			 */

			Connection conn = null;

			if (args.length == 4) {
				conn = DBConnector.getConnection(args[1], args[2], args[3]);
			} 
			else {
				if (args.length == 5) {
					conn = DBConnector.getConnection(args[1], args[2], args[3], args[4], "");
				} 
				else {
					conn = DBConnector.getConnection(args[1], args[2], args[3], args[4], args[5]);
				}
			}

			if (conn != null) {
				Szenario2 s = new Szenario2(conn);

				if (args[0].equals("a")) {
					s.runTransactionA();
				} else {
					s.runTransactionB();
				}
			}

		} 
		else {
			System.err.println("Ungueltige Anzahl an Argumenten!");
		}
	}

	public Szenario2(Connection connection) {
		this.connection = connection;
	}

	/*
	 * Beschreibung siehe Angabe
	 */
	public void runTransactionA() {
		/*
		 * Vorgegebener Codeteil
		 * ################################################################################
		 */
		wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");
		/*
		 * ################################################################################
		 */

		try {

			System.out.println("Transaktion A Start");
	
			/*
			 * Setzen Sie das aus Ihrer Sicht passende Isolation-Level:
			 */

			/*
			 * In MVCC basierten DBMS wäre hier wiederum REPEATABLE READ / READ COMMITTED SNAPSHOT (MSSQL) zu bevorzugen (siehe Szenario1)
			 * * keine Phantom / Non Repeatable Reads
			 * * keine Locks, die andere Transaktionen blockieren
			 * Wenn Implimentierung nicht bekannt -> SERIALIZABLE (keine Phantom Reads)
			 */
			connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

			/*
			 * Abfrage 1:
			 * Ermitteln Sie den Namen, das Land und das Jahr aller Austauschprogramme,
			 * die von der Firma mit der Firmennumer '10' angeboten sind, gemeinsam mit der
			 * Anzahl der jeweiligen Praktika, welche die Firma zu dem jeweiligen Austauschprogramm
			 * angeboten hat Sortieren Sie das Ergebnis aufsteigend nach der Anzahl und geben Sie
			 * alle Daten auf der Konsole aus.
			 */
	
			Statement stmt = connection.createStatement();

			ResultSet rs = stmt.executeQuery(
				"select land, jahr, name, coalesce(" +
					"(select sum(1) from ausgeschrieben where fanr = 10 and jahr = ap.jahr and name = ap.name and land = ap.land)" + 
					", " +
					"0" + 
					") total from austauschprogramm ap order by total;"
			);	

			System.out.println("Praktika der Firma 10\n");
			while(rs.next()) {
				System.out.println(rs.getString("Name") + " " + rs.getInt("Jahr") + " " + rs.getString("Land") + " " + rs.getInt("Total"));
			}	
			
			/*
			 * Vorgegebener Codeteil
			 * ################################################################################
			 */
			 wait("Druecken Sie <ENTER> zum Fortfahren ...");
			/*
			 * ################################################################################
			 */
	
			/*
			 * Abfrage 2:
			 * Ermitteln Sie zu jedem Land, in welchem Austauschprogramme stattgefunden haben, wie
			 * viele Praktika zu diesem Land bisher ausgeschrieben wurden. Sortieren Sie das Ergebnis
			 * absteigend nach der Anzahl und aufsteigend nach dem Land. Geben Sie alle Daten auf der
			 * Konsole aus.
			 */
			
			rs.close();
			rs = stmt.executeQuery(

				"SELECT DISTINCT ap.land, COALESCE(a.total, 0) as total from austauschprogramm ap " + 
				" left join  ( " +
					" select land, sum(1) as total from ausgeschrieben group by land " +
					" ) a " +
				" on ap.land = a.land order by total desc, land asc;"
			);

			System.out.println("Praktika Nach Ländern:\n");
			while(rs.next()) {
				System.out.println(rs.getString("Land") + " " + rs.getInt("total"));
			}	

			/*
			 * Vorgegebener Codeteil
			 * ################################################################################
			 */
			wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");
			/*
			 * ################################################################################
			 */
				
			/*
			 * Beenden Sie die Transaktion
			 */

			rs.close();
			stmt.close();
			connection.commit();
	
			System.out.println("Transaktion A Ende");

		} catch(SQLException ex) {

			Logger.getLogger(Szenario2.class.getName()).log(Level.SEVERE, null, ex);

		}

	}

	public void runTransactionB() {
		/*
		 * Vorgegebener Codeteil
		 * ################################################################################
		 */
		wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");

		System.out.println("Transaktion B Start");

		try {
			Statement stmt = connection.createStatement();

			stmt.executeUpdate("INSERT INTO ausgeschrieben(land, jahr, name, prnr, abtnr, fanr) VALUES " +
							   "('USA', '2014', 'Austauschprogramm 2', 3, 1, 10);");

			stmt.close();
			
			System.out.println("Ein Praktikum wurde ausgeschrieben ...");
			
			wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");

			connection.commit();
		} 
		catch (SQLException ex) {
			Logger.getLogger(Szenario2.class.getName()).log(Level.SEVERE, null, ex);
		}

		System.out.println("Transaktion B Ende");
		/*
		 * ################################################################################
		 */
	}

	private static void wait(String message) {
		/* 
		 * Vorgegebener Codeteil 
		 * ################################################################################
		 */
		try {
			System.out.println(message);
			System.in.read();
		} 
		catch (java.io.IOException ex) {
			Logger.getLogger(Szenario2.class.getName()).log(Level.SEVERE, null, ex);
		}
		/*
		 * ################################################################################
		 */
	}
}
