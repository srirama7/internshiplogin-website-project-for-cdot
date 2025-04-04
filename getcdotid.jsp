<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String lastCdotId = "N/A"; // Default value if no records exist
    try {
        // Load MySQL driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Connect to database - using the same connection details from your code
        // NOTE: You may need to specify the database name in the connection URL
        Connection con = DriverManager.getConnection("jdbc:mysql://192.168.75.172/your_database_name", "intern", "Intern@!2025");
        
        // Fetch last inserted ID from the table
        Statement stmt = con.createStatement();
        
        // This assumes your ID column is named "ID" - adjust if it's different
        // and that you want to get the most recently added record
        ResultSet rs = stmt.executeQuery("SELECT ID FROM kmg_interntrainee_data ORDER BY ID DESC LIMIT 1");
        
        if (rs.next()) {
            // Format the ID as "cdotXXX" to match your existing format
            String dbId = rs.getString("ID");
            
            // If your ID in the database already has the "cdot" prefix, use it directly
            if (dbId.startsWith("cdot")) {
                lastCdotId = dbId;
            } else {
                // Otherwise, add the prefix
                lastCdotId = "cdot" + dbId;
            }
        }
        
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        // Log the error to server logs
        e.printStackTrace();
        // Return error indicator
        lastCdotId = "Error: Database connection failed";
    }
    
    // Send response as plain text
    out.print(lastCdotId);
%>