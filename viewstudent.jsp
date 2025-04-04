<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Projects</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            color: #333;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Project Details</h1>
    <table>
        <tr>
            <th>Project Name</th>
            <th>Description</th>
            <th>Guide Name</th>
            <th>Guide Email</th>
            <th>Guide Phone</th>
            <th>HoD Name</th>
            <th>HoD Email</th>
            <th>HoD Phone</th>
        </tr>
        <%
            String dbURL = "jdbc:mysql://192.168.75.227/mydatabase";
            String dbUser = "dotuser";
            String dbPassword = "dot123";
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM sdetails");
                
                while(rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("project_name") %></td>
                        <td><%= rs.getString("project_description") %></td>
                        <td><%= rs.getString("guide_name") %></td>
                        <td><%= rs.getString("guide_email") %></td>
                        <td><%= rs.getString("guide_phone") %></td>
                        <td><%= rs.getString("hod_name") != null ? rs.getString("hod_name") : "N/A" %></td>
                        <td><%= rs.getString("hod_email") != null ? rs.getString("hod_email") : "N/A" %></td>
                        <td><%= rs.getString("hod_phone") != null ? rs.getString("hod_phone") : "N/A" %></td>
                    </tr>
                    <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </table>
</div>
</body>
</html>