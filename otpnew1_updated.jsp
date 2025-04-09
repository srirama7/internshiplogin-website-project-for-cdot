<%-- 
    Document   : otpnew1.jsp
    Created on : 12 Mar, 2025, 3:58:13 PM
    Author     : manjuv
--%>

<%@page import="com.cdot.nms.ConfigManager"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // The existing Java code remains unchanged
    ConfigManager.init("/home/manjuv/INTERNSHIP_HOME/conf/config_interndb.xml");

    // Database connection details
//    String url = "jdbc:mysql://192.168.75.227/mydatabase";
//    String dbUser = "dotuser";
//    String dbPass = "dot123";
    
    String url = "jdbc:mysql://192.168.75.241/internshipdb";
    String dbUser = "intern";
    String dbPass = "Intern@!2025";

    if (request.getParameter("checkStaffNo") != null) {
        String staffNoToCheck = request.getParameter("checkStaffNo");
        String EMPNAME = request.getParameter("EMPNAME");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String responseText = "";
        

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            conn = DriverManager.getConnection(url, dbUser, dbPass);
            
            session.setAttribute("refStaffNo", staffNoToCheck);
            session.setAttribute("EMPNAME",EMPNAME);

            // Query to check staff number and get email
            String sql = "SELECT STAFFNO,EMPNAME,EMAIL FROM Kmg_employeestaff_info WHERE STAFFNO = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, staffNoToCheck);
            
            

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Staff found, return the email
                responseText = rs.getString("EMAIL");
                
//                empName = rs.getString("EMPNAME"); // Retrieve employee name
//                
//                // Create a combined response with email and name
//                responseText += "|" + empName;
            } else {
                // Staff not found
                responseText = "No Employee Found :( ";
            }

            // Write the response
            response.setContentType("text/plain");
            response.getWriter().write(responseText);
            return; // End processing here for AJAX requests

        } catch (Exception e) {
            response.setContentType("text/plain");
            response.getWriter().write("ERROR: " + e.getMessage());
            e.printStackTrace();
            return;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Retrieve form data
    String username = request.getParameter("username");
    String roleName = request.getParameter("roleName");
    String EMPNAME = request.getParameter("EMPNAME");
    String staffNo = request.getParameter("staffNo");

    // Process database operation if form was submitted
    if (username != null && roleName != null && !username.isEmpty() && !roleName.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            conn = DriverManager.getConnection(url, dbUser, dbPass);

            // Insert query for the login table with roleName and username
            String sql = "INSERT INTO login (roleName, username) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, roleName);
            pstmt.setString(2, EMPNAME);

            // Execute the query
            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                // Store user data in session
                session.setAttribute("EMPNAME", username);
                

                // Log successful insertion
                System.out.println("Successfully inserted record into login table: username=" + username + ", roleName=" + roleName);

//                // Redirect to the role's page
//                response.sendRedirect(roleName);
            } else {
                out.println("<script>alert('Error saving data. Try again!');</script>");
            }
        } catch (Exception e) {
            out.println("<script>alert('Database connection error: " + e.getMessage() + "');</script>");
            e.printStackTrace();
        } finally {
            // Close resources properly
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login & OTP Verification</title>
        <link rel="stylesheet" href="styles.css">
        <link rel="icon" type="image/png" href="images/icons/cdot.jpeg"/>
    </head>
    <body>
        
        <div class="card">
            <div class="header">
                <h1 style="color:green">LOGIN PAGE</h1>
                <h2 style="color:black">OTP Verification</h2>
            </div>
            <div class="content" id="content">
                <form id="loginForm" method="POST">
                    <input type="hidden" name="refStaffNo" id="refStaffNo" value=""/>
                    <input type="hidden" name="EMPNAME" id="EMPNAME" value=""/>
                    <!-- Hidden field for action -->
                    <input type="hidden" id="action" name="action" value="">
                    <!-- Hidden field for roleName (text value) -->
                    <input type="hidden" id="roleName" name="roleName" value="">

                    <!-- Dropdown to select role -->
                    <select id="roleSelect" name="role" required onchange="handleRoleChange()">
                        <option value="">Select Role</option>
                        <option value="student.jsp">STUDENT_TRAINEE</option>
                        <option value="kmgtable.jsp">REFERRED_STAFF</option>
                        <option value="kmghead.jsp">KMG_ADMIN</option>
                    </select>
                    <br><br>

                    <div id="staffNoSection" class="form-group" style="display: none;">
                        <input type="text" 
                               id="staffNo" 
                               name="staffNo" 
                               placeholder="Enter Staff Code" 
                               maxlength="4" 
                               pattern="\d{4}" 
                               title="Staff code must be exactly 4 digits"
                               oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                        <button id="verifyStaffBtn" onclick="verifyStaffNo(event)" type="button">
                            Verify Staff
                        </button>
                        <span id="staffError" style="color: red; display: none;">Invalid Staff Code</span>
                    </div>

                    <!-- Email input field -->
                    <div class="form-group" id="emailSection">
                        <input type="text" id="username" name="username" placeholder="Enter your email" required>
                        <span id="emailError" style="color: red; display: none;">Invalid Email Format</span>
                    </div>

                    <!-- Generate OTP button -->
                    <div class="form-group" id="otpButtonSection">
                        <button id="generateBtn" onclick="OTPFn(event)" type="button">
                            Generate OTP
                        </button>
                    </div>

                    <!-- OTP input and verification -->
                    <div id="otpForm" class="otp-form" style="display: none;">
                        <input type="text" id="userOTP" placeholder="Enter OTP">
                        <button onclick="OTPVerifyFn()" type="button">
                            Verify
                        </button>
                    </div>
                </form>

                <div id="successMessage" class="success-message" style="display: none;">
                    <i class="fas fa-check"></i>
                    <p>OTP is Verified Successfully! Redirecting...</p>
                </div>
                <div id="errorMessage" class="error-message" style="display: none;"></div>
                <div id="timer" class="timer" style="display: none;"></div>
            </div>
        </div>

        <script>
            // Email validation
            document.getElementById("username").addEventListener("input", function () {
                const emailInput = this.value;
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                const errorMessage = document.getElementById("emailError");

                if (!emailPattern.test(emailInput)) {
                    errorMessage.style.display = "block";
                } else {
                    errorMessage.style.display = "none";
                }
            });

            function validateEmail(email) {
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return emailPattern.test(email);
            }

            function OTPFn(event) {
                event.preventDefault(); // Prevent any default form submission

                let email = document.getElementById("username").value;
                let role = document.getElementById("roleSelect").value;

                if (email.trim() === "") {
                    alert("Please enter your email first.");
                    return false;
                }

                if (!validateEmail(email)) {
                    document.getElementById("emailError").style.display = "block";
                    alert("Please enter a valid email address.");
                    return false;
                }

                if (!role) {
                    alert("Please select a role.");
                    return false;
                }

                alert("OTP sent to " + email); // Simulate OTP sending
                document.getElementById("otpForm").style.display = "block";
                return true;
            }

                function OTPVerifyFn() {
                    
                    
    const userOTP = document.getElementById("userOTP").value;
    const successMessage = document.getElementById("successMessage");
    const errorMessage = document.getElementById("errorMessage");
    let enteredOTP = document.getElementById("userOTP").value;
    
    let roleText = document.getElementById("roleSelect").options[document.getElementById("roleSelect").selectedIndex].text;
    let staffNo = document.getElementById("staffNo").value;
    
    document.getElementById("refStaffNo").value=staffNo;

    // Reset messages
    errorMessage.textContent = "";
    errorMessage.style.display = "none";
    successMessage.style.display = "none";

    // Validate OTP Entry
    if (!userOTP) {
        errorMessage.textContent = "Please enter OTP!";
        errorMessage.style.display = "block";
        return;
    }
    if (userOTP.length !== 6) {
        errorMessage.textContent = "OTP must be 6 digits!";
        errorMessage.style.display = "block";
        return;
    }
    if (isTimerExpired || generatedOTP === null) {
        errorMessage.textContent = "OTP has expired! Please generate a new OTP.";
        errorMessage.style.display = "block";
        return;
    }

    // Verify OTP
    if (parseInt(userOTP) === generatedOTP) {
        clearInterval(timerInterval);
        document.getElementById("timer").style.display = "none";

        // Show success message
        successMessage.style.display = "block";

        // Reset OTP input
        document.getElementById("userOTP").value = "";

        // Invalidate OTP after success
        generatedOTP = null;
        isTimerExpired = true;

        // Redirect after 2 seconds to the selected page
        setTimeout(() => {
            if (selectedPage) {
                
                window.location.href = selectedPage;
            } else {
                alert("Error: No role selected for redirection!");
            }
        }, 2000);
    } else {
        errorMessage.textContent = "Invalid OTP! Please try again.";
        errorMessage.style.display = "block";
    }
                       
    if (!enteredOTP) {
        alert("Please enter the OTP.");
        return;
    }

    if (enteredOTP === "1234") { // Simulating correct OTP
        // Key Changes here
        // 1. Add hidden input for staffNo
        let hiddenStaffNoInput = document.createElement('input');
        hiddenStaffNoInput.type = 'hidden';
        hiddenStaffNoInput.name = 'staffNo';
        hiddenStaffNoInput.value = staffNo;
        document.getElementById("loginForm").appendChild(hiddenStaffNoInput);

        // 2. Add hidden input for storing staff name
        fetch('getEmployeeName.jsp?staffNo=' + encodeURIComponent(staffNo))
            .then(response => response.text())
            .then(empName => {
                let hiddenEmpNameInput = document.createElement('input');
                hiddenEmpNameInput.type = 'hidden';
                hiddenEmpNameInput.name = 'staffName';
                hiddenEmpNameInput.value = empName;
                document.getElementById("loginForm").appendChild(hiddenEmpNameInput);

                // Rest of your existing success handling...
                document.getElementById("action").value = "verifyOTP";
                document.getElementById("roleName").value = roleText;
                document.getElementById("successMessage").style.display = "block";

                setTimeout(() => {
                    document.getElementById("loginForm").submit();
                }, 2000);
            })
            .catch(error => {
                console.error('Error fetching employee name:', error);
                alert('Error verifying staff details. Please try again.');
            });
    } 

}
                        function handleRoleChange() {
                const roleSelect = document.getElementById("roleSelect");
                const staffNoSection = document.getElementById("staffNoSection");
                
                const emailSection = document.getElementById("emailSection");
                const otpButtonSection = document.getElementById("otpButtonSection");
                const usernameInput = document.getElementById("username");
                const otpForm = document.getElementById("otpForm");
                const staffError = document.getElementById("staffError");

                // Reset error messages when changing roles
                staffError.style.display = "none";

                if (roleSelect.value === "kmgtable.jsp") {
                    // For REFERRED_STAFF role
                    staffNoSection.style.display = "block";
                    emailSection.style.display = "none";      // Hide email section initially
                    otpButtonSection.style.display = "none";  // Hide OTP button initially
                    usernameInput.readOnly = true;
                    otpForm.style.display = "none";           // Hide OTP form
                } else {
                    // For other roles (STUDENT_TRAINEE and KMG_ADMIN)
                    staffNoSection.style.display = "none";
                    emailSection.style.display = "block";     // Show email section
                    otpButtonSection.style.display = "block"; // Show OTP button
                    usernameInput.readOnly = false;
                    usernameInput.value = "";
                }
            }

        function verifyStaffNo(event) {
            event.preventDefault();
            
            const staffNo = document.getElementById("staffNo").value.trim();
            const staffError = document.getElementById("staffError");
            const emailSection = document.getElementById("emailSection");
            const otpButtonSection = document.getElementById("otpButtonSection");

            // Find the verify button
            const verifyButton = event.target;

            if (!staffNo) {
                staffError.textContent = "Please enter staff code";
                staffError.style.display = "block";
                return;
            }

            // Create AJAX request to verify staff number
            const xhr = new XMLHttpRequest();
            xhr.open("POST", window.location.href, true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const response = xhr.responseText;

                    if (response === "No Employee Found :( ") {
                        staffError.textContent = "No staff found with this code";
                        staffError.style.display = "block";
                        document.getElementById("username").value = "";
                        emailSection.style.display = "block";
                        otpButtonSection.style.display = "none";
                        if (verifyButton) verifyButton.disabled = false;

                    } else if (response.startsWith("ERROR:")) {
                        staffError.textContent = "System error. Please try again.";
                        staffError.style.display = "block";
                        document.getElementById("username").value = "";
                        emailSection.style.display = "block";
                        otpButtonSection.style.display = "none";
                        if (verifyButton) verifyButton.disabled = false;

                    } else {
                        const [email, empName] = response.split('|');
                        
                         
                        // Store staffNo in sessionStorage and add hidden input to form
                        sessionStorage.setItem('staffNo', staffNo);
                        let staffNoInput = document.getElementById("hiddenStaffNo");
                        if (!staffNoInput) {
                            staffNoInput = document.createElement('input');
                            staffNoInput.type = 'hidden';
                            staffNoInput.id = 'hiddenStaffNo';
                            staffNoInput.name = 'staffNo';
                            document.getElementById("loginForm").appendChild(staffNoInput);
                        }
                        staffNoInput.value = staffNo;

                        // Create hidden input for employee name
                        let empNameInput = document.getElementById("empName");
                        if (!empNameInput) {
                            empNameInput = document.createElement("input");
                            empNameInput.type = "hidden";
                            empNameInput.id = "empName";
                            empNameInput.name = "empName";
                            document.getElementById("loginForm").appendChild(empNameInput);
                        }
                        empNameInput.value = empName;

                        // Valid staff found with email
                        document.getElementById("username").value = email;
                        staffError.style.display = "none";
                        emailSection.style.display = "block";

                        // Only show OTP button if valid email was found
                        if (email && email.includes('@')) {
                            otpButtonSection.style.display = "block";
                            if (verifyButton) verifyButton.disabled = true;
                            document.getElementById("staffNo").disabled = true;
                            console.log("Staff verification successful");
                        } else {
                            otpButtonSection.style.display = "none";
                            staffError.textContent = "Staff's Email is not found try again!!";
                            staffError.style.display = "block";
                            if (verifyButton) verifyButton.disabled = false;
                        }
                    }
                }
            };
            xhr.send("checkStaffNo=" + encodeURIComponent(staffNo));
           
        }
        </script>

        <script src="script.js"></script>
        
    </body>
</html>
