<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Save Project</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            text-align: center;
        }
        .message {
            padding: 20px;
            margin: 20px;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
        }
        .link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<%
    String dbURL = "jdbc:mysql://192.168.75.227/mydatabase";
    String dbUser = "dotuser";
    String dbPassword = "dot123";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
        String sql = "INSERT INTO sdetails (project_name, project_description, guide_name, " +
                    "guide_email, guide_phone, hod_name, hod_email, hod_phone) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, request.getParameter("project_name"));
        pstmt.setString(2, request.getParameter("project_description"));
        pstmt.setString(3, request.getParameter("guide_name"));
        pstmt.setString(4, request.getParameter("guide_email"));
        pstmt.setString(5, request.getParameter("guide_phone"));
        pstmt.setString(6, request.getParameter("hod_name"));
        pstmt.setString(7, request.getParameter("hod_email"));
        pstmt.setString(8, request.getParameter("hod_phone"));
        
        int result = pstmt.executeUpdate();
        
        if(result > 0) {
            %><div class="message success">Project Information Saved Successfully!</div><%
        }
        
        pstmt.close();
        conn.close();
        
    } catch(Exception e) {
        %><div class="message error">Error: <%= e.getMessage() %></div><%
    }
%>
<a href="viewstudent.jsp" class="link">View All Projects</a>
</body>
</html>