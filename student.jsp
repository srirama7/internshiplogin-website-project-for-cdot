<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Information</title>
    <link rel="stylesheet" href="student.css">
    <link rel="icon" type="image/png" href="images/icons/cdot.jpeg"/>
</head>
<body>
    <button class="logout-btn" onclick="window.location.href='otpnew.jsp'">Logout</button>
    <div class="container">
        <h1>Student Internship Form</h1>
       <h2>Project Information Form</h2>
    
        
        <!-- Correct form action and field names to match database columns -->
        <form id="projectForm" action="savestudent.jsp" method="post">
            <div class="section">
                <div class="form-group">
                    <label for="projectName">Project Name*</label>
                    <input type="text" id="projectName" name="project_name" required>
                </div>

                <div class="form-group">
                    <label for="projectDescription">Project Description*</label>
                    <textarea id="projectDescription" name="project_description" required></textarea>
                </div>
            </div>

            <div class="section">
                <h2>College Guide Information</h2>
                <div class="form-group">
                    <label for="guideName">Guide Name*</label>
                    <input type="text" id="guideName" name="guide_name" required>
                </div>

                <div class="form-group">
                    <label for="guideEmail">Guide Email*</label>
                    <input type="email" id="guideEmail" name="guide_email" required>
                </div>

                <div class="form-group">
                    <label for="guidePhone">Guide Phone Number*</label>
                    <input type="tel" id="guidePhone" name="guide_phone" pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number" required>
                </div>
            </div>

            <div class="section">
                <h2>Head of Department Information</h2>
                <div class="form-group">
                    <label for="hodName">HoD Name <span class="optional-label">(Optional)</span></label>
                    <input type="text" id="hodName" name="hod_name">
                </div>

                <div class="form-group">
                    <label for="hodEmail">HoD Email <span class="optional-label">(Optional)</span></label>
                    <input type="email" id="hodEmail" name="hod_email">
                </div>

                <div class="form-group">
                    <label for="hodPhone">HoD Phone Number <span class="optional-label">(Optional)</span></label>
                    <input type="tel" id="hodPhone" name="hod_phone" pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number">
                </div>
            </div>

            <button type="submit">Submit</button>
        </form>
    </div>

    <script>
        // Remove preventDefault to allow form submission to server
        document.getElementById('projectForm').addEventListener('submit', function(e) {
            // Basic form validation
            const phoneInputs = document.querySelectorAll('input[type="tel"]');
            let isValid = true;

            phoneInputs.forEach(input => {
                if (input.value && !input.value.match(/^[0-9]{10}$/)) {
                    isValid = false;
                    alert('Please enter a valid 10-digit phone number');
                    e.preventDefault();
                }
            });

            if (isValid) {
                // Form will submit to server
                return true;
            }
        });
    </script>
</body>
</html>