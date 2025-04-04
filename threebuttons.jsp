<%@page import="common.CommonHelper"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Form Navigation</title>
    <link rel="stylesheet" href="threebuttonsss.css">
    <link rel="icon" type="image/png" href="images/icons/cdot.jpeg"/>
    
    <%
    String pagetype = request.getParameter("pagetype");
    CommonHelper util = new CommonHelper();
    %>
    
     <style>

        
        /* Dropdown styles */
            .dropdown-container {
                position: relative;
                display: inline-block;
                margin: 10px;
            }

            /* Styling for the buttons */
            .dropdown-container .btn {
                display: block;
                padding: 10px 15px;
                background-color: #f1f1f1;
                border: 1px solid #ddd;
                text-decoration: none;
                color: black;
            }

            /* Change the dropdown class to work with hover */
            .dropdown {
                position: relative;
                display: inline-block;
            }

            /* Hide dropdown content by default */
            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #f9f9f9;
                min-width: 200px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1;
                border: 1px solid #ddd;
            }

            /* Show the dropdown menu on hover */
            .dropdown:hover .dropdown-content {
                display: block;
            }

            /* Links inside the dropdown */
            .dropdown-content a {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
            }

            .dropdown-content a:hover {
                background-color: #f1f1f1;
            }
            
            .show {
                display: block;
            }
            
            /* Data container styles */
            #dataContainer {
                margin-top: 20px;
            }
            
            .data-section {
                display: none;
            }
            
            .data-section.active {
                display: block;
            }
            .container {
                width: 90%; /* Adjust width as needed */
                /* Add any other styles you need for the container */
            }
            .content1 {
                width: 100%;
                padding: 20px;
                margin-left: 10%;
            }
            .dropdown:hover .back-button {
                background-color: #000088;
                color: white;
            }
    </style>
    <script src="buttons.js"></script>
   
</head>
<body class="claro" onload="loadDivs('<%=pagetype%>')">
    
    <%
        
            String username = (String) session.getAttribute("username");
            String roleName = (String) session.getAttribute("role");

            if (username == null || roleName == null) {
                username = "Not Provided";
                roleName = "Not Provided";
            }
        %>
    
    <div class="user-info-container">
        <div class="user-details">
            <span class="username" id="usernameDisplay"><%= username %></span>
            <span class="role" id="roleDisplay"><%= roleName %></span>
        </div>
        <button class="logout-button" onclick="logout()">Logout</button>
    </div>

    <div class="content-box">
        <h1>Student Internship Form</h1>
        <div class="button-container">
            <button onclick="showForm('userDetails')">Student Details</button>
            <button onclick="showForm('academicDetails')">Academic Details</button>
            <button onclick="showForm('trainingDetails')">Training Details</button>
            <div class="dropdown">
                <button id="viewStorageBtn" class="back-button">Reports</button>
                <div id="viewStorageDropdown" class="dropdown-content">
                    <a href="report1.jsp" id="internAppLink">Internship Applications</a>
                    <a href="report2.jsp" id="courseDataLink">List Course Data</a>
                    <a href="report3.jsp" id="streamDataLink">List Stream Data</a>
                    <a href="report4.jsp" id="streamDataLink">List Student trainee data</a>

                </div>
            </div>
        </div>
    </div>

    <div id="userDetails" class="form-container">
        <h2>Student Details</h2>
        <form>
            <label>Type of Internship:</label>
            <select name="internship" required>
                <option value="">select</option>
                <option value="paid">Paid Internship</option>
                <option value="normal">Normal Internship</option>
            </select>
            
            <label>Full Name:</label>
            <input type="text" id="fullName" required>

            <label>Email:</label>
            <input type="email" id="email" required oninput="validateEmail(this)">
            <small class="error-message" id="emailError" style="color: red;"></small>
            
            <label>Address:</label>
            <div class="tooltip">
                <input type="text" id="address" required oninput="validateAddress(this)">
                <span class="tooltiptext">Please enter your complete address including city, state, and PIN code and u can add #,-,* if u wish along with the address which u provided and remaining special classes are not allowed</span>
                <span id="addressError" style="color: red;"></span>
            </div>
            
            <label>Relationship with Employee</label>
            <select name="relationwithemployee" required>
                <option value="">Select</option>
                <option value="child">Child</option>
                <option value="relative">Relative</option>
                <option value="known">known</option>
            </select>

            <label>Phone Number:</label>
            <input type="number" id="phone" placeholder="Enter Phone Number" oninput="validatePhoneNumber(this)">
            <span id="phoneError" style="color: red;"></span><br>

            <input type="button" value="Next" onclick="validateAndProceed()">
        </form>
    </div>

    <div id="academicDetails" class="form-container">
        <h2>Academic Details</h2>
        <form action="saveDetails.jsp" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="internship" id="hiddenInternship">
            <input type="hidden" name="fullName" id="hiddenFullName">
            <input type="hidden" name="email" id="hiddenEmail">
            <input type="hidden" name="address" id="hiddenAddress">
            <input type="hidden" name="phone" id="hiddenPhone">
            <input type="hidden" name="relationwithemployee" id="hiddenRelation">
            
            <label>Course Undergoing</label>
            <select name="Select" required>
                <option value="">Select</option>
                <%
                    List<String> course = util.getAllCourse();
                    if (null != course) 
                    {
                        Iterator<String> iters = course.iterator();
                        while (iters.hasNext()) 
                        {
                            String courses = iters.next();
                            out.println("<option value='" + courses + "'>" + courses + "</option>");
                        }
                    } 
                    else 
                    {
                        out.println("<option value='select'>select</option>");
                    }
                %> 
              
            </select>
            
            <label>Stream:</label>
            <select name="department" id="department" required onchange="toggleOtherField()">
                <option value="">Select</option>
                <%
                    List<String> streams = util.getAllStreams();
                    if (null != streams) 
                    {
                        Iterator<String> iter = streams.iterator();
                        while (iter.hasNext()) 
                        {
                            String streamName = iter.next();
                            out.println("<option value='" + streamName + "'>" + streamName + "</option>");
                        }
                    } 
                    else 
                    {
                        out.println("<option value='select'>select</option>");
                    }
                %> 
              
                <option value="OTHER">Other</option>
            </select>
            
            <div id="otherDepartmentDiv" style="display: none; margin-top: 10px;">
                <label>Specify Other:</label>
                <input type="text" id="otherDepartment" name="otherDepartment" placeholder="Enter Department">
            </div>

            <label>Name of the Course</label>
            <input type="text" name="course" required>
            
            <label>University:</label>
            <input type="text" name="university" required>

            <label>College:</label>
            <input type="text" name="college" required>
              
            <label>Duration:</label>
            <select name="duration" required>
                <option value="">Select</option>
                <option value="year">yearly based</option>
                <option value="sem">semester based</option>
            </select>
            
            <div class="dialog-box">
                

                <label for="completedCourse">Course Completed:</label>
                <select id="completedCourse" name="completedCourse" onchange="togglefields()">
                    <option value="">-- Select --</option>
                    <option value="yes">Yes</option>
                    <option value="no">No</option>
                </select>

                

                <!-- Fields for "Yes" -->
                <div id="yesFields" class="hidden" style="display: none;">
                    <div style="display: flex; align-items: center;">
                        <label for="yearCompleted" style="margin-right: 8px;">Year of Completion:</label>
                        <input type="number" id="year" name="year" min="2000" max="2025" required style="width: 80px;">
                    </div>
                     
                    <div style="display: flex; align-items: center; gap: 10px;">
                    <label for="fileToTransfer">Resume(PDF/DOC/DOCX):</label>
                    <input type="file" id="fileToTransfer" name="fileToTransfer" accept=".pdf,.doc,.docx" required>
                    <button type="button" onclick="handleFileTransfer()" class="transfer-button">Upload File</button>
                    </div>
                    <div id="uploadStatus" style="margin-top: 10px;"></div>
                </div>
                
                <!-- Fields for "No" -->
                <div id="noFields" class="hidden" style="display: none;"> 
                    <div style="display: flex; align-items: center; gap: 20px;">
                        <div>
                        <label for="year">Year:</label>
                        <input type="number" id="year" name="year" min="1" max="5" required style="width: 80px;">
                        </div>
    
                    <div>
                        <label for="sem">Current Semester:</label>
                            <input type="number" id="sem" name="sem" oninput="validateSem()" min="1" max="10" required>
                            <span id="error-msg" style="color: red; display: none;">Semester must be between 1 and 10.</span>
                    </div>
                        
                    </div>
                    <div id="semesterMarks">
                        <div id="sem1" style="display: none;" class="semester-input">
                            <label>Semester 1 Marks(in %):</label>
                            <input type="number" name="sem1_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem2" style="display: none;" class="semester-input">
                            <label>Semester 2 Marks(in %):</label>
                            <input type="number" name="sem2_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem3" style="display: none;" class="semester-input">
                            <label>Semester 3 Marks(in %):</label>
                            <input type="number" name="sem3_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem4" style="display: none;" class="semester-input">
                            <label>Semester 4 Marks(in %):</label>
                            <input type="number" name="sem4_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem5" style="display: none;" class="semester-input">
                            <label>Semester 5 Marks(in %):</label>
                            <input type="number" name="sem5_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem6" style="display: none;" class="semester-input">
                            <label>Semester 6 Marks(in %):</label>
                            <input type="number" name="sem6_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem7" style="display: none;" class="semester-input">
                            <label>Semester 7 Marks(in %):</label>
                            <input type="number" name="sem7_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem8" style="display: none;" class="semester-input">
                            <label>Semester 8 Marks(in %):</label>
                            <input type="number" name="sem8_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem9" style="display: none;" class="semester-input">
                            <label>Semester 9 Marks(in %):</label>
                            <input type="number" name="sem9_marks" step="0.1" min="0" max="100">
                        </div>
                        <div id="sem10" style="display: none;" class="semester-input">
                            <label>Semester 10 Marks(in %):</label>
                            <input type="number" name="sem10_marks" step="0.1" min="0" max="100">
                        </div>
                    </div>

                        <div style="display: flex; align-items: center; gap: 10px;">
                        <label for="fileToTransfer">Approve Letter From Hod</label>
                        <input type="file" id="secondFileToTransfer" name="secondFileToTransfer" accept=".pdf,.doc,.docx">
                        <button onclick="handleSecondFileTransfer()">Submit Button</button>
                        </div>
                        <div id="secondUploadStatus"></div>
                </div>

                <div class="cgpa-container">
                    <label for="cgpaInput">CGPA:</label>
                    <input type="text" id="cgpaInput" oninput="validateCGPA(this)" onblur="checkCGPA()"
                        placeholder="0.0 - 10.0" required style="width: 80px; text-align:left;">
                    <span id="cgpaError" style="color: red; display: inline-block; margin-left: 10px;"></span>
                </div>
            </div>
            
            <br>
            <br>

            <input type="button" value="Back" onclick="showForm('userDetails')">
            <input type="button" value="Next" onclick="showTrainingForm()">
        </form>
    </div>
    
    <div id="trainingDetails" class="form-container">
        <h2>Training Details</h2>
        <form action="saveDetails.jsp" method="post" onsubmit="return validateTrainingForm()">
            <input type="hidden" name="internship" id="trainingHiddenInternship">
            <input type="hidden" name="fullName" id="trainingHiddenFullName">
            <input type="hidden" name="email" id="trainingHiddenEmail">
            <input type="hidden" name="address" id="trainingHiddenAddress">
            <input type="hidden" name="phone" id="trainingHiddenPhone">
            <input type="hidden" name="relationwithemployee" id="trainingHiddenRelation">
            
            <input type="hidden" name="course" id="trainingHiddenCourse">
            <input type="hidden" name="stream" id="trainingHiddenStream">
            <input type="hidden" name="university" id="trainingHiddenUniversity">
            <input type="hidden" name="college" id="trainingHiddenCollege">
            <input type="hidden" name="duration" id="trainingHiddenDuration">
            <input type="hidden" name="year" id="trainingHiddenYear">
            <input type="hidden" name="semester" id="trainingHiddenSemester">
            <input type="hidden" name="cgpa" id="trainingHiddenCGPA">
            
             <input type="hidden" name="sem1_marks" id="trainingHiddenSem1Marks">
             <input type="hidden" name="sem2_marks" id="trainingHiddenSem2Marks">
             <input type="hidden" name="sem3_marks" id="trainingHiddenSem3Marks">
             <input type="hidden" name="sem4_marks" id="trainingHiddenSem4Marks">
             <input type="hidden" name="sem5_marks" id="trainingHiddenSem5Marks">
             <input type="hidden" name="sem6_marks" id="trainingHiddenSem6Marks">
             <input type="hidden" name="sem7_marks" id="trainingHiddenSem7Marks">
             <input type="hidden" name="sem8_marks" id="trainingHiddenSem8Marks">
            <input type="hidden" name="sem9_marks" id="trainingHiddenSem9Marks">
            <input type="hidden" name="sem10_marks" id="trainingHiddenSem10Marks">
            
            
            <label>Group Name:</label>
            <select name="groupName" class="training-input" required onchange="loadStaffNumbers()">
            <option value="">Select</option>
            <%
                List<String> guidename = util.getAllGuide();
                if (null != guidename) 
                {
                    Iterator<String> iter = guidename.iterator();
                    while (iter.hasNext()) 
                    {
                        String guideName = iter.next();
                        out.println("<option value='" + guideName + "'>" + guideName + "</option>");
                    }
                } 
                else 
                {
                    out.println("<option value='select'>select</option>");
                }
            %> 
        </select>

        <label>Group Staff Number:</label>
        <select name="groupstaff" id="groupstaff" class="training-input" required onchange="updateGuideName()" >
            <option value="" >Select</option>
        </select>

        <label>Guide Name:</label>
        <input type="text" name="guideName" class="training-input" readonly>
    
            <label>Training Duration (in months):</label>
            <input type="number" name="trainingDuration" class="training-input" min="1" max="24" required>
    
            <input type="button" value="Back" onclick="showForm('academicDetails')">
            <input type="submit" value="Submit" onclick="return handleFormSubmit()">
        </form>
    </div>
        
<script>
     
        window.onload = function() {
        // Get the form parameter from the URL
        var urlParams = new URLSearchParams(window.location.search);
        var formToShow = urlParams.get('form');
        
        // If a specific form is requested in the URL, show it automatically
        if (formToShow) {
            showForm(formToShow);
        }
    };
        function logout() {
            // Clear sessionStorage
            sessionStorage.removeItem('username');
            sessionStorage.removeItem('roleName');
            
            // Also clear server-side session
            <% session.removeAttribute("username"); %>
            <% session.removeAttribute("roleName"); %>
            
            // Redirect to login page
            window.location.href = 'otpnew1.jsp';
        }

function handleFileTransfer() {
    const fileInput = document.getElementById('fileToTransfer');
    const uploadStatus = document.getElementById('uploadStatus');
    
    if (!fileInput.files || fileInput.files.length === 0) {
        uploadStatus.innerHTML = 'Please select a file first';
        uploadStatus.style.color = 'red';
        return;
    }

    const file = fileInput.files[0];
    const fileExtension = file.name.split('.').pop().toLowerCase();
    
    if (!['pdf', 'doc', 'docx'].includes(fileExtension)) {
        uploadStatus.innerHTML = 'Only PDF, DOC, and DOCX files are allowed';
        uploadStatus.style.color = 'red';
        return;
    }

    const formData = new FormData();
    formData.append('file', file);

    uploadStatus.innerHTML = 'Uploading...';
    uploadStatus.style.color = 'blue';

    fetch('transferfile.jsp', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(text => {
        try {
            const data = JSON.parse(text);
            uploadStatus.innerHTML = data.message;
            uploadStatus.style.color = data.status === 'success' ? 'green' : 'red';
            if (data.status === 'success') {
                fileInput.value = ''; // Clear the input
                // Set a flag to indicate file is uploaded
                window.fileUploaded = true;
            }
        } catch (e) {
            uploadStatus.innerHTML = 'Error processing server response';
            uploadStatus.style.color = 'red';
        }
    })
    .catch(error => {
        uploadStatus.innerHTML = 'Error uploading file: ' + error.message;
        uploadStatus.style.color = 'red';
    });
}

 function validateFileTransfer() {
    const fileInput = document.getElementById('fileToTransfer');
    if (!fileInput.files.length) {
        alert('Please select a file to transfer.');
        return false;
    }
    
    const fileName = fileInput.files[0].name;
    const fileExt = fileName.toLowerCase().split('.').pop();
    
    if (!['pdf', 'doc', 'docx'].includes(fileExt)) {
        alert('Please select only PDF, DOC, or DOCX files.');
        return false;
    }
    
    return true;
}


// Check for upload status on page load
document.addEventListener('DOMContentLoaded', function() {
    const uploadMessage = '<%= session.getAttribute("uploadMessage") %>';
    const uploadStatus = '<%= session.getAttribute("uploadStatus") %>';
    
    if (uploadMessage) {
        showNotification(uploadMessage, uploadStatus);
        <!--<% session.removeAttribute("uploadMessage"); %>-->
        <% session.removeAttribute("uploadStatus"); %>
    }
    
    // Reset the file uploaded flag when the page loads
    fileUploaded = false;
});



// Check for upload status on page load
document.addEventListener('DOMContentLoaded', function() {
    const uploadMessage = '<%= session.getAttribute("uploadMessage") %>';
    const uploadStatus = '<%= session.getAttribute("uploadStatus") %>';
    
    if (uploadMessage) {
        showNotification(uploadMessage, uploadStatus);
        <!--<% session.removeAttribute("uploadMessage"); %>-->
        <% session.removeAttribute("uploadStatus"); %>
    }
});


// Add this script at the bottom of your page or in an external JS file
document.addEventListener('DOMContentLoaded', function() {
    // Get the username from session storage
    const username = sessionStorage.getItem('username');
    
    // Find the email input field
    const emailField = document.getElementById('email');
    
    // If both exist, set the email field value to the username
    if (username && emailField) {
        emailField.value = username;
    }
});

 const username = sessionStorage.getItem('username');
        const roleName = sessionStorage.getItem('roleName');

        // Debugging: Log the values
        console.log("Username from sessionStorage:", username);
        console.log("RoleName from sessionStorage:", roleName);

        // Display the values in the user-info-container
        if (username && roleName) {
            document.querySelector('.username').textContent = username;
            document.querySelector('.role').textContent = roleName;
        }


    document.getElementById('usernameDisplay').textContent = "<%= username %>";
    document.getElementById('roleDisplay').textContent = "<%= roleName %>";
    
    
function handleSecondFileTransfer() {
    const fileInput = document.getElementById('secondFileToTransfer');
    const uploadStatus = document.getElementById('secondUploadStatus');
    
    if (!fileInput.files || fileInput.files.length === 0) {
        uploadStatus.innerHTML = 'Please select a file first';
        uploadStatus.style.color = 'red';
        return;
    }
    
    const file = fileInput.files[0];
    const fileExtension = file.name.split('.').pop().toLowerCase();
    
    if (!['pdf', 'doc', 'docx'].includes(fileExtension)) {
        uploadStatus.innerHTML = 'Only PDF, DOC, and DOCX files are allowed';
        uploadStatus.style.color = 'red';
        return;
    }
    
    const formData = new FormData();
    formData.append('file', file);
    
    uploadStatus.innerHTML = 'Uploading...';
    uploadStatus.style.color = 'blue';
    
    // Use the same JSP file as the first upload to avoid server configuration issues
    fetch('transferfile.jsp', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(text => {
        try {
            const data = JSON.parse(text);
            uploadStatus.innerHTML = data.message;
            uploadStatus.style.color = data.status === 'success' ? 'green' : 'red';
            
            if (data.status === 'success') {
                fileInput.value = ''; // Clear the input
                // Set a flag to indicate second file is uploaded
                window.secondFileUploaded = true;
            }
        } catch (e) {
            uploadStatus.innerHTML = 'Error processing server response: ' + e.message;
            uploadStatus.style.color = 'red';
            console.error('Server response:', text);
        }
    })
    .catch(error => {
        uploadStatus.innerHTML = 'Error uploading file: ' + error.message;
        uploadStatus.style.color = 'red';
        console.error('Fetch error:', error);
    });
}


function loadStaffNumbers() {
    var selectedGroup = document.getElementsByName("groupName")[0].value;
    
    // Use AJAX to get staff numbers for selected group
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "getStaffNumbers.jsp?group=" + encodeURIComponent(selectedGroup), true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
        var defaultOption = "<option value='' selected >Select</option>";
        document.getElementById("groupstaff").innerHTML = defaultOption + xhr.responseText;
        }
    };
    xhr.send();
}
      
      
// JavaScript function to load guide name based on selected staff number
function updateGuideName() {
    var selectedStaffNo = document.getElementById("groupstaff").value;
    
    if (selectedStaffNo) {
        
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "getGuideName.jsp?staffNo=" + encodeURIComponent(selectedStaffNo), true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementsByName("guideName")[0].value = xhr.responseText.trim();
            }
        };
        xhr.send();
    } else {
        document.getElementsByName("guideName")[0].value = "";
    }
}


var selectedGroup = document.getElementsByName("groupName")[0].value;

// Use AJAX to get staff numbers for the selected group
var xhr = new XMLHttpRequest();
xhr.open("GET", "getStaffNumbers.jsp?group=" + encodeURIComponent(selectedGroup), true);
xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {

        document.getElementById("groupstaff").innerHTML = xhr.responseText;

        document.getElementsByName("guideName")[0].value = "";
    }
};
xhr.send();

</script>

</body>
</html>