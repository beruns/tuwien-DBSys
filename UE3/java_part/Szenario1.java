package java_part;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Szenario1 {

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
				Szenario1 s = new Szenario1(conn);

				if (args[0].equals("a")) {
					s.runTransactionA();
				} 
				else {
					s.runTransactionB();
				}
			}
		} 
		else {
			System.err.println("Ungueltige Anzahl an Argumenten!");
		}
	}

	public Szenario1(Connection connection) {
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
			 * In DBMS die MVCC (Postgres, MSSQL, MySQL, Oracle, ... ) implimentieren wäre für Lese Operationen wohl REPEATABLE READ zu bevorzugen:
			 * (In MSSQL READ COMMITTED SNAPSHOT)
			 *  * Keine Locks, die andere Operationen blockieren
			 *  * Keine Phantom Reads / Non Repeatable Reads möglich (nur lost updates was bei Lese OPs irrelevant wäre)
			 * Wenn die Verfügbarkeit von MVCC nicht bekannt ist, könnte REPEATABLE READ allerdings mittels UPDATE / DELETE Locks implimentiert sein
			 * und somit den Anforderungen widersprechen -> READ COMMITTED
			 */ 
			connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);

			/*
			 * Abfrage 1:
			 * Ermitteln Sie wie viele Studenten sich durchnittlich im Jahr 2012 zu
			 * Austauschprogrammen beworben haben und geben Sie das Ergebnis auf der Konsole aus.
			 */
	
			Statement stmt = connection.createStatement();

			ResultSet rs1 = stmt.executeQuery(
				"SELECT round((SELECT COUNT(1) FROM bewirbt_ap where jahr = 2012), 2) / (SELECT COUNT(1) FROM Austauschprogramm where jahr = 2012) as rel2012;"
			);
	
			rs1.next();
			double rel2012 = rs1.getDouble("rel2012");
			rs1.close();

			System.out.println("Durchschnittliche Bewerbungen 2012: " + rel2012);
	
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
			 * Ermitteln Sie wie viele Studenten sich im Schnitt zu Austauschprogrammen beworben haben
			 * und geben Sie das Ergebnis auf der Konsole aus.
			 */
	
			rs1 = stmt.executeQuery(
				"SELECT round((SELECT COUNT(1) FROM bewirbt_ap), 2) / (SELECT COUNT(1) FROM Austauschprogramm) as reltotal;"
			);
	
			rs1.next();
			double reltotal = rs1.getDouble("reltotal");

			System.out.println("Durchschnittliche Bewerbungen Gesamt: " + reltotal);


			/*
			 * Geben Sie das Verhaeltnis der beiden abgefragten Werte aus
			 */

			System.out.println("Verhältnis 2012/Gesamt: " + (rel2012 / reltotal));

			/*
			 * Vorgegebener Codeteil
			 * ################################################################################
			 */
			wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");
			/*
			 * ################################################################################
			 */

			rs1.close();
			stmt.close();
			connection.commit();
	
			/*
			 * Beenden Sie die Transaktion
			 */
	
			System.out.println("Transaktion A Ende");

		} catch (SQLException ex) {
			 Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
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
			
			stmt.executeUpdate("INSERT INTO bewirbt_ap VALUES (" +
							   "'000003', 'Oesterreich', '2012', 'Austauschprogramm 1');");
		
			stmt.close();
			
			System.out.println("Eine Studentenbewerbung wurde hinzugefuegt ...");
			
			wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");

			connection.commit();
		} 
		catch (SQLException ex) {
			Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
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
			Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
		}
		/*
		 * ################################################################################
		 */
	}
}
