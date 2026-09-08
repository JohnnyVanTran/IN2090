import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet; 
import java.sql.SQLException;
import java.sql.Statement;

import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

public class Huffsa {

    private static String user = "johnnyvt"; // Skriv ditt UiO-brukernavn
    private static String pwd = "rae0Jezei0"; // Skriv passordet til _priv-brukeren du fikk i mail fra USIT
    // Tilkoblings-detaljer
    private static String connectionStr = 
        "user=" + user + "_priv&" + 
        "port=5432&" +  
        "password=" + pwd + "";
    private static String host = "jdbc:postgresql://dbpg-ifi-kurs03.uio.no"; 

    public static void main(String[] agrs) {

        try {
            // Last inn driver for PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Lag tilkobling til databasen
            Connection connection = DriverManager.getConnection(host + "/" + user
                    + "?sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" + connectionStr);

            int ch = 0;
            while (ch != 3) {
                System.out.println("\n--[ HUFFSA ]--");
                System.out.println("Vennligst velg et alternativ:\n 1. Sok etter planet\n 2. Legg inn resultat\n 3. Avslutt");
                ch = getIntFromUser("Valg: ", true);

                if (ch == 1) {
                    planetSok(connection);
                } else if (ch == 2) {
                    leggInnResultat(connection);
                }
            }
        } catch (SQLException|ClassNotFoundException ex) {
            System.err.println("Error encountered: " + ex.getMessage());
        }
    }

    private static void planetSok(Connection connection)  throws SQLException {
        System.out.println("\n-- [PLANET-SOK] --");
        String molekyl1 = getStrFromUser("Molekyl 1: ");
        String molekyl2 = getStrFromUser("Molekyl 2: ");
        
        String sporring = "SELECT DISTINCT p.navn, p.masse, (s.masse) AS stjernemasse, (s.avstand) AS stjerneavstand, p.liv FROM planet AS p " +
        "INNER JOIN materie AS m ON (m.planet = p.navn) " + 
        "INNER JOIN materie AS m2 ON (m2.planet = p.navn) " +
        "INNER JOIN stjerne AS s ON (s.navn = p.stjerne) ";

        sporring += "WHERE m.molekyl LIKE ?";

        if(!molekyl2.equals("")){
            sporring += " AND m2.molekyl LIKE ?";
        }
        
        sporring += ";";

        PreparedStatement statement = connection.prepareStatement(sporring);
        statement.setString(1, molekyl1);

        if(!molekyl2.equals("")){
            statement.setString(2, molekyl2);
        }
        
        ResultSet rows = statement.executeQuery();
        
        if(!rows.next()){
            System.out.println("No results");
            return;
        }
        do{
            System.out.println("\nNavn: " + rows.getString(1) + "\n-----------------\n" + "Planet-masse: " + rows.getFloat(2) +
            "\nStjerne-masse: " + rows.getFloat(3) + "\nStjerne-avstand: " + rows.getFloat(4) +
            "\nLiv: " + rows.getBoolean(5));
        } while(rows.next());

    }


    private static void leggInnResultat(Connection connection) throws SQLException {
        System.out.println("-- [SETT INN RESULTAT] --");

        String planet = getStrFromUser("Planet navn: ");
        String skummel = getStrFromUser("Skummel j/n: ");
        String intelligent = getStrFromUser("Intelligent j/n: ");
        String beskrivelse = getStrFromUser("Beskrivelse: ");

        PreparedStatement statement = connection.prepareStatement("UPDATE planet SET skummel = ? , intelligent = ?, " +
        "beskrivelse = ?, liv = ? WHERE navn = ?");
        
        if(skummel.equals("j")){
            statement.setBoolean(1, true);
        }
        else{
            statement.setBoolean(1, false);
        }
        if(intelligent.equals("j")){
            statement.setBoolean(2, true);
        }
        else{
            statement.setBoolean(2, false);
        }
        statement.setString(3, beskrivelse);
        statement.setBoolean(4, true);
        statement.setString(5, planet);
        statement.execute();
        System.out.println("-- [Resultat satt inn!] --");
    }

    /**
     * Utility method that gets an int as input from user
     * Prints the argument message before getting input
     * If second argument is true, the user does not need to give input and can leave
     * the field blank (resulting in a null)
     */
    private static Integer getIntFromUser(String message, boolean canBeBlank) {
        while (true) {
            String str = getStrFromUser(message);
            if (str.equals("") && canBeBlank) {
                return null;
            }
            try {
                return Integer.valueOf(str);
            } catch (NumberFormatException ex) {
                System.out.println("Please provide an integer or leave blank.");
            }
        }
    }

    /**
     * Utility method that gets a String as input from user
     * Prints the argument message before getting input
     */
    private static String getStrFromUser(String message) {
        Scanner s = new Scanner(System.in);
        System.out.print(message);
        return s.nextLine();
    }
}
