<%@ page import="java.sql.*" %>
<%
    try {
        // Get all form parameters
        String internship = request.getParameter("internship");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        
        // Academic details
        String course = request.getParameter("course");
        String stream = request.getParameter("stream");
        String university = request.getParameter("university");
        String college = request.getParameter("college");
        String duration = request.getParameter("duration");
        String year = request.getParameter("year");
        String semester = request.getParameter("semester");
        
        // Semester marks
        String sem1_marks = request.getParameter("sem1_marks");
        String sem2_marks = request.getParameter("sem2_marks");
        String sem3_marks = request.getParameter("sem3_marks");
        String sem4_marks = request.getParameter("sem4_marks");
        String sem5_marks = request.getParameter("sem5_marks");
        String sem6_marks = request.getParameter("sem6_marks");
        String sem7_marks = request.getParameter("sem7_marks");
        String sem8_marks = request.getParameter("sem8_marks");
        String cgpa = request.getParameter("cgpa");
        
        // Training details
        String group_name = request.getParameter("groupName");
        String group_staff = request.getParameter("groupstaff");
        String guide_name = request.getParameter("guideName");
        String training_duration = request.getParameter("trainingDuration");

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://192.168.75.241/internshipdb",
            "intern",
            "Intern@!2025"
        );
        
        // Insert query - don't specify cdot_id as it's handled by trigger
        String sql = "INSERT INTO intern(internship_type, full_name, email, address, phone, " +
                    "course, stream, university, college, duration, year, semester, " +
                    "sem1_marks, sem2_marks, sem3_marks, sem4_marks, " +
                    "sem5_marks, sem6_marks, sem7_marks, sem8_marks, " +
                    "cgpa, group_name, group_staff, guide_name, training_duration) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        
        // Set all parameters
        int paramIndex = 1;
        stmt.setString(paramIndex++, internship);
        stmt.setString(paramIndex++, fullName);
        stmt.setString(paramIndex++, email);
        stmt.setString(paramIndex++, address);
        stmt.setString(paramIndex++, phone);
        stmt.setString(paramIndex++, course);
        stmt.setString(paramIndex++, stream);
        stmt.setString(paramIndex++, university);
        stmt.setString(paramIndex++, college);
        stmt.setString(paramIndex++, duration);
        stmt.setString(paramIndex++, year);
        stmt.setString(paramIndex++, semester);
        
        // Handle numeric values with proper null checking
        try {
            stmt.setBigDecimal(paramIndex++, sem1_marks != null && !sem1_marks.isEmpty() ? new java.math.BigDecimal(sem1_marks) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        try {
            stmt.setBigDecimal(paramIndex++, sem2_marks != null && !sem2_marks.isEmpty() ? new java.math.BigDecimal(sem2_marks) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        try {
            stmt.setBigDecimal(paramIndex++, sem3_marks != null && !sem3_marks.isEmpty() ? new java.math.BigDecimal(sem3_marks) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        try {
            stmt.setBigDecimal(paramIndex++, sem4_marks != null && !sem4_marks.isEmpty() ? new java.math.BigDecimal(sem4_marks) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        try {
            stmt.setBigDecimal(paramIndex++, sem5_marks != null && !sem5_marks.isEmpty() ? new java.math.BigDecimal(sem5_marks) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        try {
            stmt.setBigDecimal(paramIndex++, sem6_marks != null && !sem6_marks.isEmpty() ? new java.math.BigDecimal(sem6_marks) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        try {
            stmt.setBigDecimal(paramIndex++, sem7_marks != null && !sem7_marks.isEmpty() ? new java.math.BigDecimal(sem7_marks) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        try {
            stmt.setBigDecimal(paramIndex++, sem8_marks != null && !sem8_marks.isEmpty() ? new java.math.BigDecimal(sem8_marks) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        try {
            stmt.setBigDecimal(paramIndex++, cgpa != null && !cgpa.isEmpty() ? new java.math.BigDecimal(cgpa) : null);
        } catch (NumberFormatException e) {
            stmt.setNull(paramIndex++, java.sql.Types.DECIMAL);
        }
        
        stmt.setString(paramIndex++, group_name);
        stmt.setString(paramIndex++, group_staff);
        stmt.setString(paramIndex++, guide_name);
        
        try {
            stmt.setInt(paramIndex++, training_duration != null && !training_duration.isEmpty() ? Integer.parseInt(training_duration) : 0);
        } catch (NumberFormatException e) {
            stmt.setInt(paramIndex++, 0);
        }

        // Execute query
        int result = stmt.executeUpdate();
        
        if(result > 0) {
            // Get the generated CDOT ID
            Statement idStmt = conn.createStatement();
            ResultSet rs = idStmt.executeQuery("SELECT cdot_id FROM intern WHERE id = LAST_INSERT_ID()");
            if(rs.next()) {
                String cdotId = rs.getString("cdot_id");
                session.setAttribute("successMessage", "Application submitted successfully! Your ID is: " + cdotId);
            }
            response.sendRedirect("threebuttons.jsp");
        } else {
            out.println("<script>alert('Error saving data'); window.history.back();</script>");
        }
        
        stmt.close();
        conn.close();
        
    } catch(Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.history.back();</script>");
        e.printStackTrace(); // Log the full stack trace for debugging
    }
%>