<%@ page import="java.sql.*" %>
<%@ page import="java.lang.reflect.Method" %>
<%! 
    // JSP Declaration Block - runs when the JSP is destroyed
    public void jspDestroy() {
        try {
            // Force cleanup of MySQL JDBC threads
            Class.forName("com.mysql.cj.jdbc.AbandonedConnectionCleanupThread");
            Method m = Class.forName("com.mysql.cj.jdbc.AbandonedConnectionCleanupThread")
                          .getMethod("checkedShutdown");
            m.invoke(null);
            System.out.println("MySQL JDBC cleanup thread stopped successfully");
        } catch (Exception e) {
            System.err.println("Error stopping MySQL JDBC cleanup thread: " + e.getMessage());
        }
    }
%>
<%
    // Database connection and statement declarations at class level
    Connection conn = null;
     // Separate connection for staff name lookup
    
    // Main statements
    PreparedStatement stmt = null;
    PreparedStatement internshipRequestStmt = null;
    PreparedStatement updateStmt = null;
    
    // Staff name lookup statements
    
   
    
   
    
    
    try {
        // Get all form parameters
        String internship = request.getParameter("internship");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String internDescription = request.getParameter("internreq");
        String relwithemp = request.getParameter("relationwithemployee");

        String refstaffno = (String) session.getAttribute("refStaffNo");
    

// Log for debugging
System.out.println("Retrieved Staff No in savekmg: " + refstaffno);
    
    // Get staff name from database if needed
    String staffName = "";
    if (refstaffno != null && !refstaffno.isEmpty()) {
        Connection nameConn = null;
        PreparedStatement staffNameStmt = null;
        ResultSet nameRs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            nameConn = DriverManager.getConnection(
                "jdbc:mysql://192.168.75.241/internshipdb",
                "intern",
                "Intern@!2025"
            );

            String nameQuery = "SELECT EMPNAME FROM Kmg_employeestaff_info WHERE STAFFNO = ?";
            staffNameStmt = nameConn.prepareStatement(nameQuery);
            staffNameStmt.setString(1, refstaffno);
            nameRs = staffNameStmt.executeQuery();

            if (nameRs.next()) {
                staffName = nameRs.getString("EMPNAME");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close resources
            if (nameRs != null) try { nameRs.close(); } catch (SQLException e) {}
            if (staffNameStmt != null) try { staffNameStmt.close(); } catch (SQLException e) {}
            if (nameConn != null) try { nameConn.close(); } catch (SQLException e) {}
        }
    }

        System.out.println("Session staffNo: " + session.getAttribute("staffNo"));
        System.out.println("Form staffNo: " + request.getParameter("staffNo"));
    
        String phone = request.getParameter("phone");
        
        // Academic details
        String course = request.getParameter("course");
        String stream = request.getParameter("stream");
        String branch = request.getParameter("branch");

        
        String university = request.getParameter("university");
        String college = request.getParameter("college");
        String duration = request.getParameter("duration");
        String completedCourse = request.getParameter("completedCourse");
        String file = request.getParameter("fileToTransfer");
        String letter=request.getParameter("secondFileToTransfer");

        if ("yes".equals(completedCourse)) {
            file = "1";
            letter="0";
        }
        else
        {
            letter="1";
            file="0";
        }
            

         String years = request.getParameter("years");

        String year = request.getParameter("year");
       
        String semester = request.getParameter("semester");
        String jyear = request.getParameter("jyear");

        
        String years1 = request.getParameter("years1_marks");
        String years2 = request.getParameter("years2_marks");
        String years3 = request.getParameter("years3_marks");
        String years4 = request.getParameter("years4_marks");
        
        String sem1 = request.getParameter("sem1_marks");
        String sem2 = request.getParameter("sem2_marks");
        String sem3 = request.getParameter("sem3_marks");
        String sem4 = request.getParameter("sem4_marks");
            String sem5 = request.getParameter("sem5_marks");
            String sem6 = request.getParameter("sem6_marks");
        String sem7 = request.getParameter("sem7_marks");
        String sem8 = request.getParameter("sem8_marks");
        String sem9 = request.getParameter("sem9_marks");
        String sem10 = request.getParameter("sem10_marks");

        
        // Debugging: Print out all semester marks
        System.out.println("Semester Marks:");
        System.out.println("Sem1: " + sem1);
        System.out.println("Sem2: " + sem2);
        System.out.println("Sem3: " + sem3);
        System.out.println("Sem4: " + sem4);
        System.out.println("Sem5: " + sem5);
        System.out.println("Sem6: " + sem6);
        System.out.println("Sem7: " + sem7);
        System.out.println("Sem8: " + sem8);
        System.out.println("Sem9: " + sem9);
        System.out.println("Sem10: " + sem10);
        System.out.println("Sem10: " + sem10);

        String cgpa = request.getParameter("cgpa");
        
        // Training details
        String group_name = request.getParameter("groupName");
        String group_staff = request.getParameter("groupstaff");
        String guide_name = request.getParameter("guideName");
        String training_duration = request.getParameter("trainingDuration");
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date currentDate = new java.util.Date();
        int trainingDuration = Integer.parseInt(training_duration);

        // Use Calendar to add months
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(currentDate);
        cal.add(java.util.Calendar.MONTH, trainingDuration);

        // Format the new date
        String interncompletion = sdf.format(cal.getTime());

        // Parameters for kmg_internshiprequest table
        String internType = request.getParameter("internType"); // You'll need to add this to your form
        // Current timestamp for InternReq_DateTime
        String currentTimestamp = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
        
//        String interncompletion = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
        // Default values for the new table
        String internStatus = "SUBMITTED"; // Default status for new requests
         // Add to your form or use default

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://192.168.75.241/internshipdb",
            "intern",
            "Intern@!2025"
        );
        
        // Disable auto-commit for transaction management
        conn.setAutoCommit(false);
        
        // Test if connection is valid
        if (conn.isValid(5)) { // 5 second timeout
            
           String sql = "INSERT INTO kmg_interntrainee_data(" +
    "internship_type, InternReq_ID, StudentName, MailId, address, MobileNo, " +
    "CourseType, CourseName, BranchName, university, InstitutionName, durationType, " +
    "completedCourse,CurrentYear, completedYear, CurrentSemister,Joined_year, " +
    "sem1_marks, sem2_marks, sem3_marks, sem4_marks, " +
    "sem5_marks, sem6_marks, sem7_marks, sem8_marks, sem9_marks, sem10_marks, " +
    "year1_marks,year2_marks,year3_marks,year4_marks,CGPAOnDate,ResumeUploadedFlag,CollegeLetterUploadedFlag, additionalInfo, uptby, uptOn, InterCompletionDate) " +
    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            // Set all parameters
            int paramIndex = 1;
            stmt.setString(paramIndex++, internship != null && !internship.isEmpty() ? internship : "");
            stmt.setString(paramIndex++, "temp_id"); 
            stmt.setString(paramIndex++, fullName != null ? fullName : "");
            stmt.setString(paramIndex++, email != null ? email : "");
            stmt.setString(paramIndex++, address != null ? address : "");
            stmt.setString(paramIndex++, phone != null ? phone : "");
            stmt.setString(paramIndex++, course != null ? course : "");
            stmt.setString(paramIndex++, stream != null ? stream : "");
            stmt.setString(paramIndex++, branch != null ? branch : "");
            stmt.setString(paramIndex++, university != null ? university : "");
            stmt.setString(paramIndex++, college != null ? college : "");
            stmt.setString(paramIndex++, duration != null ? duration : "");
            stmt.setString(paramIndex++, completedCourse);
            stmt.setString(paramIndex++, years != null ? years : "");
            stmt.setString(paramIndex++, year != null ? year : "");
            stmt.setString(paramIndex++, semester != null ? semester : "");
            stmt.setString(paramIndex++,  jyear!= null ? jyear : "");
            

                // Verify the values before insertion
                System.out.println("Semester Marks:");
                System.out.println("Sem1: " + sem1);
                System.out.println("Sem2: " + sem2);
                System.out.println("Sem3: " + sem3);
                System.out.println("Sem4: " + sem4);
                System.out.println("Sem5: " + sem5);
                System.out.println("Sem6: " + sem6);
                System.out.println("Sem7: " + sem7);
                System.out.println("Sem8: " + sem8);

                // Set parameters for the prepared statement
                stmt.setString(paramIndex++, sem1 != null && !sem1.trim().isEmpty() ? sem1 : "0");
                stmt.setString(paramIndex++, sem2 != null && !sem2.trim().isEmpty() ? sem2 : "0");
                stmt.setString(paramIndex++, sem3 != null && !sem3.trim().isEmpty() ? sem3 : "0");
                stmt.setString(paramIndex++, sem4 != null && !sem4.trim().isEmpty() ? sem4 : "0");
                stmt.setString(paramIndex++, sem5 != null && !sem5.trim().isEmpty() ? sem5 : "0");
                stmt.setString(paramIndex++, sem6 != null && !sem6.trim().isEmpty() ? sem6 : "0");
                stmt.setString(paramIndex++, sem7 != null && !sem7.trim().isEmpty() ? sem7 : "0");
                stmt.setString(paramIndex++, sem8 != null && !sem8.trim().isEmpty() ? sem8 : "0");
                stmt.setString(paramIndex++, sem9 != null && !sem9.trim().isEmpty() ? sem9 : "0");
                stmt.setString(paramIndex++, sem10 != null && !sem10.trim().isEmpty() ? sem10 : "0");
                
                stmt.setString(paramIndex++, years1 != null && !years1.trim().isEmpty() ? years1 : "0");
                stmt.setString(paramIndex++, years2 != null && !years2.trim().isEmpty() ? years2 : "0");
                stmt.setString(paramIndex++, years3 != null && !years3.trim().isEmpty() ? years3 : "0");
                stmt.setString(paramIndex++, years4 != null && !years4.trim().isEmpty() ? years4 : "0");

            
            stmt.setString(paramIndex++, cgpa != null ? cgpa : "");
            stmt.setString(paramIndex++, file != null ? file : "");
            stmt.setString(paramIndex++, letter != null ? letter : "");
            
            stmt.setString(paramIndex++, internDescription != null ? internDescription : "");
            stmt.setString(paramIndex++, staffName != null ? staffName : "");
            stmt.setString(paramIndex++, currentTimestamp);
            stmt.setString(paramIndex++,  interncompletion != null ? interncompletion : "");
            
            



            // Execute first query
            int result = stmt.executeUpdate();
            
            // Variable to store generated key
            int generatedId = -1;
            
            if(result > 0) {
                // Get the generated ID
                ResultSet rs = stmt.getGeneratedKeys();
                if(rs.next()) {
                    generatedId = rs.getInt(1);
                    
                    // Format the InternReq_ID as "cdot" + ID
                    String formattedId = "cdot" + generatedId;
                    
                    // Update the InternReq_ID with the formatted ID
                    String updateSql = "UPDATE kmg_interntrainee_data SET InternReq_ID = ? WHERE ID = ?";
                    updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setString(1, formattedId);
                    updateStmt.setInt(2, generatedId);
                    int updateResult = updateStmt.executeUpdate();
                    
                    
                    if (updateResult > 0) {
                        // SECOND INSERTION: kmg_internshiprequest table
                        String internshipRequestSql = "INSERT INTO kmg_internshiprequest " +
                            "(InternType, InternReq_ID, InternReq_DateTime, InternReq_Status, InternReq_Description, " +
                            "InternTraineeDuration_Months,refStattNo,refStaffName,relationship,InternBioDataId,guideStaffNo, uptby, uptOn) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        
                        internshipRequestStmt = conn.prepareStatement(internshipRequestSql);
                        
                        // Set parameters for kmg_internshiprequest - FIX: Use proper values and add null checks
                        internshipRequestStmt.setString(1, internship != null && !internship.isEmpty() ? internship : "");
                        internshipRequestStmt.setString(2, formattedId); // FIX: Use the formatted ID instead of internship value
                        internshipRequestStmt.setString(3, currentTimestamp);
                        internshipRequestStmt.setString(4, internStatus);
                        internshipRequestStmt.setString(5, internDescription);
                        
                        // FIX: Ensure training_duration is properly handled
                        try {
                            internshipRequestStmt.setInt(6, training_duration != null && !training_duration.isEmpty() ? Integer.parseInt(training_duration) : 0);
                        } catch (NumberFormatException e) {
                            internshipRequestStmt.setInt(6, 0);
                        }
                        
                        internshipRequestStmt.setString(7, refstaffno);
                        internshipRequestStmt.setString(8, staffName);
                        
                        internshipRequestStmt.setString(9, relwithemp);


                        
                        // Use generatedId as the linking field
                        internshipRequestStmt.setInt(10, generatedId);
                        
                        internshipRequestStmt.setString(11, group_staff != null ? group_staff : "");
                        internshipRequestStmt.setString(12,  staffName!= null ? staffName : "");
                        internshipRequestStmt.setString(13, currentTimestamp);

                        
                        
                        // Execute second query
                        int requestResult = internshipRequestStmt.executeUpdate();
                        
                        if(requestResult > 0) {
                            // Both inserts successful, commit transaction
                            conn.commit();
                            session.setAttribute("successMessage", "Application submitted successfully! Your ID is: " + formattedId);
                            response.sendRedirect("kmgtable.jsp");
                        } else {
                            // Second insert failed
                            conn.rollback();
                            out.println("<script>alert('Error saving internship request data'); window.history.back();</script>");
                        }
                    } else {
                        // Update failed
                        conn.rollback();
                        out.println("<script>alert('Error updating InternReq_ID'); window.history.back();</script>");
                    }
                } else {
                    // No keys returned
                    conn.rollback();
                    out.println("<script>alert('Error retrieving generated keys'); window.history.back();</script>");
                }
                rs.close();
            } else {
                // First insert failed
                conn.rollback();
                out.println("<script>alert('Error saving trainee data'); window.history.back();</script>");
            }
        } else {
            out.println("<script>alert('Database connection timeout'); window.history.back();</script>");
        }
        
    } catch(Exception e) {
        // An exception occurred, rollback the transaction
        try {
            if (conn != null) {
                conn.rollback();
            }
        } catch (SQLException rollbackEx) {
            rollbackEx.printStackTrace();
        }
        
        out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); window.history.back();</script>");
        e.printStackTrace(); // Log the full stack trace for debugging
    } finally {
        // Always close resources in finally block
        try {
            if (stmt != null) {
                stmt.close();
            }
            if (internshipRequestStmt != null) {
                internshipRequestStmt.close();
            }
            if (updateStmt != null) {
                updateStmt.close();
            }
            if (conn != null && !conn.isClosed()) {
                // Restore auto-commit before closing
                conn.setAutoCommit(true);
                conn.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>