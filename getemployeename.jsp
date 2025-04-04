<%@ page import="java.sql.*" %>
<%
    String staffNo = request.getParameter("staffNo");
    String empName = "";
    
    if (staffNo != null && !staffNo.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://192.168.75.241/internshipdb", 
                "intern", 
                "Intern@!2025"
            );
            
            String sql = "SELECT EMPNAME FROM Kmg_employeestaff_info WHERE STAFFNO = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, staffNo);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                empName = rs.getString("EMPNAME");
            }
            
            out.print(empName);
        } catch (Exception e) {
            out.print("Error: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
%>