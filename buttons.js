function validateAndProceed() {
    const emailInput = document.getElementById("email");
    const emailError = document.getElementById("emailError");
    const phoneInput = document.getElementById("phone");
    const phoneError = document.getElementById("phoneError");
    const addressInput = document.getElementById("address");
    const addressError = document.getElementById("addressError");
    const fullNameInput = document.getElementById("fullName");
    const internreqInput = document.getElementById("internreq");
    const internshipSelect = document.querySelector('select[name="internship"]');
    const relationSelect = document.querySelector('select[name="relationwithemployee"]');

    const emailRegex = /^[a-zA-Z0-9._%+-]+@(gmail|cdot|outlook|yahoo|hotmail)\.(com|in|net|org|ai|gov|mil|int|edu)$/;
    const phoneRegex = /^\d{10}$/;
    const addressRegex = /^[a-zA-Z0-9\s#$@]+$/;

    const emailValue = emailInput.value.trim();
    const phoneValue = phoneInput.value.trim();
    const addressValue = addressInput.value.trim();

    let isValid = true;

    // Check if all required fields are filled
    if (!fullNameInput.value.trim()) {
        alert("Please enter your full name");
        fullNameInput.focus();
        return false;
    }
    
    if (!internreqInput.value.trim()) {
        alert("Please enter your full Internship requirement Description pls");
        fullNameInput.focus();
        return false;
    }

    if (!internshipSelect.value) {
        alert("Please select type of internship");
        internshipSelect.focus();
        return false;
    }

    if (!relationSelect.value) {
        alert("Please select relationship with employee");
        relationSelect.focus();
        return false;
    }

    if (!emailRegex.test(emailValue)) {
        emailError.textContent = "Please enter a valid email in the format abc@gmail.com";
        emailInput.focus();
        isValid = false;
    } else {
        emailError.textContent = "";
    }

    if (!phoneRegex.test(phoneValue)) {
        phoneError.textContent = "Please enter a valid 10-digit phone number.";
        phoneInput.focus();
        isValid = false;
    } else {
        phoneError.textContent = "";
    }

    if (!addressRegex.test(addressValue)) {
        addressError.textContent = "Address can only contain letters, numbers, spaces, #, $, and @.";
        addressError.style.display = "block";
        isValid = false;
    } else {
        addressError.textContent = "";
        addressError.style.display = "none";
    }

    if (isValid) {
        showForm('academicDetails');
    }
    return isValid;
}

function validateEmail(input) {
    const emailError = document.getElementById("emailError");
    const emailRegex = /^[a-zA-Z0-9._%+-]+@(gmail|cdot|outlook|yahoo|hotmail)\.(com|in|org|net|gov|ai|mil|int|edu)$/;

    if (!emailRegex.test(input.value)) {
        emailError.textContent = "Please enter a valid email in the format abc@gmail.com";
    } else {
        emailError.textContent = "";
    }
}

function toggleOtherField() {
    var departmentSelect = document.getElementById("department");
    var otherDepartmentDiv = document.getElementById("otherDepartmentDiv");

    if (departmentSelect.value === "OTHER") {
        otherDepartmentDiv.style.display = "block";
    } else {
        otherDepartmentDiv.style.display = "none";
        document.getElementById("otherDepartment").value = ""; // Clear input when hidden
    }
}


document.addEventListener("DOMContentLoaded", function () {
    // Hide fields on page load
    document.getElementById("yesFields").classList.add("hidden");
    document.getElementById("noFields").classList.add("hidden");
    document.getElementById("submitBtn").classList.add("hidden");
});

// Update the existing togglefields function to also call toggleDuration
function togglefields() {
    var yesFields = document.getElementById("yesFields");
    var noFields = document.getElementById("noFields");
    var selectedValue = document.getElementById("completedCourse").value;
    
    if (selectedValue === "yes") {
        yesFields.style.display = "block";
        noFields.style.display = "none";
    } else if (selectedValue === "no") {
        noFields.style.display = "block";
        yesFields.style.display = "none";
        // Call toggleDuration to handle the duration-specific display
        toggleDuration();
    } else {
        yesFields.style.display = "none";
        noFields.style.display = "none";
    }
}

// Function to toggle yearly/semester fields based on duration selection
function toggleDuration() {
    var durationType = document.querySelector('select[name="duration"]').value;
    var noFields = document.getElementById("noFields");
    
    // If no selection is made in completedCourse, don't proceed further
    if (document.getElementById("completedCourse").value !== "no") {
        return;
    }
    
    // Get all yearly and semester input fields
    var yearFields = document.querySelectorAll('.years-input');
    var semesterFields = document.querySelectorAll('.semester-input');
    
    if (durationType === "year") {
        // Show yearly fields, hide semester fields
        yearFields.forEach(field => {
            field.style.display = field.id === "years" + document.getElementById("years").value ? "inline-block" : "none";
        });
        semesterFields.forEach(field => {
            field.style.display = "none";
            var input = field.querySelector('input');
            if (input) input.required = false;
        });
        
        // Show Years input, hide Semester input
        document.querySelector('label[for="years"]').parentElement.style.display = "block";
        document.querySelector('label[for="sem"]').parentElement.style.display = "none";
        document.getElementById("sem").required = false;
        document.getElementById("years").required = true;
        
    } else if (durationType === "sem") {
        // Show semester fields, hide yearly fields
        semesterFields.forEach(field => {
            field.style.display = field.id === "sem" + document.getElementById("sem").value ? "inline-block" : "none";
        });
        yearFields.forEach(field => {
            field.style.display = "none";
            var input = field.querySelector('input');
            if (input) input.required = false;
        });
        
        // Show Semester input, hide Years input
        document.querySelector('label[for="sem"]').parentElement.style.display = "block";
        document.querySelector('label[for="years"]').parentElement.style.display = "none";
        document.getElementById("years").required = false;
        document.getElementById("sem").required = true;
    }
}



function validateAddress(input) {
    const addressError = document.getElementById("addressError");
    const addressRegex = /^[a-zA-Z0-9\s#$@]+$/;

    if (!addressRegex.test(input.value)) {
        addressError.textContent = "Address can only contain letters, numbers, spaces, #, $, and @.";
    } else {
        addressError.textContent = "";
    }
}

function validateyears() {
    let yearsInput = document.getElementById("years");
    let errorMsg = document.getElementById("error-msg");
    let yearsValue = parseInt(yearsInput.value);

    if (isNaN(yearsValue) || yearsValue < 1 || yearsValue > 5) {
        errorMsg.style.display = "inline";
        yearsInput.value = "";
        hideAllYears();
    } else {
        errorMsg.style.display = "none";
        showyears(yearsValue);
    }
}

function hideAllYears() {
    for (let i = 1; i <= 5; i++) {
        let yearsField = document.getElementById("years" + i);
        if (yearsField) {
            yearsField.style.display = "none";
            let yearsInput = yearsField.querySelector('input');
            if (yearsInput) {
                yearsInput.required = false;
            }
        }
    }
}

// Modify the existing show functions to respect the duration selection
function showyears(currentyears) {
    hideAllYears();
    
    // Only show year fields if duration is set to "year"
    if (document.querySelector('select[name="duration"]').value === "year") {
        for (let i = 1; i < currentyears; i++) {
            let yearsField = document.getElementById("years" + i);
            if (yearsField) {
                yearsField.style.display = "inline-block";
                let yearsInput = yearsField.querySelector('input');
                if (yearsInput) {
                    yearsInput.required = true;
                }
            }
        }
    }
}

function validateSem() {
    let semInput = document.getElementById("sem");
    let errorMsg = document.getElementById("error-msg");
    let semValue = parseInt(semInput.value);

    if (isNaN(semValue) || semValue < 1 || semValue > 10) {
        errorMsg.style.display = "inline";
        semInput.value = "";
        hideAllSemesters();
    } else {
        errorMsg.style.display = "none";
        showSemesters(semValue);
    }
}

function hideAllSemesters() {
    for (let i = 1; i <= 10; i++) {
        let semField = document.getElementById("sem" + i);
        if (semField) {
            semField.style.display = "none";
            let semInput = semField.querySelector('input');
            if (semInput) {
                semInput.required = false;
            }
        }
    }
}

function showSemesters(currentSem) {
    hideAllSemesters();
    
    // Only show semester fields if duration is set to "sem"
    if (document.querySelector('select[name="duration"]').value === "sem") {
        for (let i = 1; i < currentSem; i++) {
            let semField = document.getElementById("sem" + i);
            if (semField) {
                semField.style.display = "inline-block";
                let semInput = semField.querySelector('input');
                if (semInput) {
                    semInput.required = true;
                }
            }
        }
    }
}

// Add event listener to duration select
document.addEventListener('DOMContentLoaded', function() {
    var durationSelect = document.querySelector('select[name="duration"]');
    if (durationSelect) {
        durationSelect.addEventListener('change', toggleDuration);
    }
});

function validatePhoneNumber(input) {
    // Get the phone number value
    const phoneNumber = input.value;
    // Remove any non-digit characters
    const digitsOnly = phoneNumber.replace(/\D/g, '');

    // Check if the input contains only digits
    const isValidFormat = /^\d+$/.test(phoneNumber);
    // Check if the length is exactly 10 digits
    const isValidLength = digitsOnly.length <= 10;

    // Get the error span element
    const errorElement = document.getElementById('phoneError');

    // Clear any previous input that exceeds 10 digits
    if (digitsOnly.length > 10) {
        input.value = digitsOnly.substring(0, 10);
    }

    // Display appropriate error message
    if (!isValidFormat) {
        errorElement.textContent = "Phone number should contain only digits";
    } else if (!isValidLength) {
        errorElement.textContent = "Phone number should be 10 digits";
    } else {
        errorElement.textContent = "";
    }

    return isValidFormat && isValidLength;
}

function validateForm() {
    let phone = document.getElementById("phone").value;
    let phoneError = document.getElementById("phoneError");
    let sem = document.getElementById("sem").value;
    let years = document.getElementById("years").value;
    let errorMsg = document.getElementById("error-msg");

    if (phone.length !== 10) {
        phoneError.textContent = "Phone number must be exactly 10 digits.";
        return false;
    }
    
    if (parseInt(years) > 10) {
        errorMsg.style.display = "inline";
        return false;
    }

    let currentyears = parseInt(years);
    for (let i = 1; i < currentyears; i++) {
        let yearsInput = document.querySelector(`input[name="years${i}_marks"]`);
        if (yearsInput && yearsInput.style.display !== "none" && !yearsInput.value) {
            alert(`Please enter marks for years ${i}`);
            return false;
        }
    }
//
    if (parseInt(sem) > 10) {
        errorMsg.style.display = "inline";
        return false;
    }

    let currentSem = parseInt(sem);
    for (let i = 1; i < currentSem; i++) {
        let semInput = document.querySelector(`input[name="sem${i}_marks"]`);
        if (semInput && semInput.style.display !== "none" && !semInput.value) {
            alert(`Please enter marks for Semester ${i}`);
            return false;
        }
    }
    
    

    phoneError.textContent = "";
    errorMsg.style.display = "none";
    return true;
}

// Function to set active button when page loads
window.onload = function () {
    // Add event listeners for timeout reset
    document.body.addEventListener('mousemove', resetTimer);
    document.body.addEventListener('keypress', resetTimer);

    // Automatically highlight the User Details button
    const buttonSelectors = [
        'button[onclick="showForm(\'userDetails\')"]',
        '[data-form="userDetails"]',
        '#userDetailsButton'
    ];

    let userDetailsButton = null;

    // Try multiple selector methods to find the button
    for (let selector of buttonSelectors) {
        userDetailsButton = document.querySelector(selector);
        if (userDetailsButton)
            break;
    }

    if (userDetailsButton) {
        // Remove active class from all buttons first
        const allButtons = document.querySelectorAll('.button-container button');
        allButtons.forEach(button => {
            button.classList.remove('active');
        });

        // Add active class to the User Details button
        userDetailsButton.classList.add('active');

        // Initially show the user details form
        showForm('userDetails');
    } else {
        console.warn('User Details button not found');
    }
};

// Function to set active button based on current form
function setActiveButton(formId) {
    // Mapping of form IDs to button selectors
    const buttonMap = {
        'userDetails': [
            'button[onclick="showForm(\'userDetails\')"]',
            '[data-form="userDetails"]',
            '#userDetailsButton'
        ],
        'academicDetails': [
            'button[onclick="showForm(\'academicDetails\')"]',
            '[data-form="academicDetails"]',
            '#academicDetailsButton'
        ],
        'trainingDetails': [
            'button[onclick="showForm(\'trainingDetails\')"]',
            '[data-form="trainingDetails"]',
            '#trainingDetailsButton'
        ],
        'viewDetails': [
            'button[onclick="window.location.href=\'displayDetails_1.jsp\'"]',
            '[data-form="viewDetails"]',
            '#viewDetailsButton'
        ]
    };

    // Remove active class from all buttons
    const allButtons = document.querySelectorAll('.button-container button');
    allButtons.forEach(button => {
        button.classList.remove('active');
    });

    // Find and activate the correct button
    if (buttonMap[formId]) {
        let targetButton = null;

        // Try multiple selectors for the form
        for (let selector of buttonMap[formId]) {
            targetButton = document.querySelector(selector);
            if (targetButton)
                break;
        }

        if (targetButton) {
            targetButton.classList.add('active');
        } else {
            console.warn(`Button for form ${formId} not found`);
        }
    }
}

// Existing showForm function with validation
function showForm(formId) {
    // Check if trying to access academic details without filling student details
    if (formId === 'academicDetails' && !isStudentDetailsFilled()) {
        alert("Please fill all Student Details first!");
        showForm('userDetails');
        return;
    }

    // Check if trying to access training details without filling previous steps
    if (formId === 'trainingDetails') {
        if (!isStudentDetailsFilled()) {
            alert("Please fill Student Details first!");
            showForm('userDetails');
            return;
        }
        if (!isAcademicDetailsFilled()) {
            alert("Please fill Academic Details first!");
            showForm('academicDetails');
            return;
        }
        if (!isFileUploaded()) {
            alert("Please Submit your resume before proceeding!");
            showForm('academicDetails');
            return;
        }
    }

    // Hide all forms
    document.querySelectorAll('.form-container').forEach(form => {
        form.classList.remove('active');
    });

    // Show the requested form
    const targetForm = document.getElementById(formId);
    if (targetForm) {
        targetForm.classList.add('active');
    } else {
        console.warn(`Form ${formId} not found`);
    }

    // Update active button state
    setActiveButton(formId);
}


function validateCGPA(input) {
    let cgpa = parseFloat(input.value);
    if (cgpa > 10) {
        alert("CGPA cannot be greater than 10. Please enter a valid value.");
        input.value = ""; // Clear the input field
        input.focus(); // Focus back on the input field
    }
}

function checkCGPA() {
    let cgpaInput = document.getElementById('cgpaInput');
    let cgpaError = document.getElementById('cgpaError');
    let value = parseFloat(cgpaInput.value);

    if (isNaN(value) || value < 0 || value > 10) {
        cgpaError.textContent = 'Please enter a valid CGPA between 0.0 and 10.0';
    } else {
        cgpaError.textContent = '';
    }
}

function showPopup() {
    const popup = document.createElement('div');
    popup.className = 'popup';
    popup.innerHTML = 'Details Saved Successfully!';
    document.body.appendChild(popup);

    setTimeout(() => popup.classList.add('show'), 100);

    setTimeout(() => {
        popup.classList.remove('show');
        setTimeout(() => {
            document.body.removeChild(popup);
            window.location.href = 'displayDetails_1.jsp';
        }, 500);
    }, 2000);
}

document.addEventListener("DOMContentLoaded", function () {
    document.querySelector("#academicDetails form").addEventListener("submit", function (e) {
        e.preventDefault();

        document.getElementById("hiddenFullName").value = document.getElementById("fullName").value;
        document.getElementById("hiddenEmail").value = document.getElementById("email").value;
        document.getElementById("hiddenAddress").value = document.getElementById("address").value;
        document.getElementById("hiddeninternreq").value = document.getElementById("internreq").value;

        document.getElementById("hiddenPhone").value = document.getElementById("phone").value;

        setActiveButton('viewDetails');
        showPopup();

        setTimeout(() => {
            this.submit();
        }, 2500);
    });
});

window.onload = function () {
    document.body.addEventListener('mousemove', resetTimer);
    document.body.addEventListener('keypress', resetTimer);
    setActiveButton('userDetails');
};

// Add this near the top of your script section or in document.ready
window.fileUploaded = false;
window.secondFileUploaded = false;


// Reset it when the form loads or "Course Completed" changes
document.getElementById('completedCourse').addEventListener('change', function() {
    if (this.value === 'yes') {
        window.fileUploaded = false; // Reset flag when user changes selection
    }
   
});

function showTrainingForm() {
    // First check if academic details are filled properly
    if (validateAcademicDetails()) {
        const courseCompleted = document.getElementById('completedCourse').value;
        const fileInput = document.getElementById('fileToTransfer');
        
        // Check if file input has a file selected but upload status indicates it wasn't uploaded
        if (courseCompleted === 'yes') {
            // Check if a file is selected but not uploaded (window.fileUploaded should be true if uploaded)
            if (fileInput && fileInput.files && fileInput.files.length > 0 && !window.fileUploaded) {
                alert('You have selected a new file. Please click on "Submit File" button before proceeding.');
                return false;
            }
            
            // Double check the upload requirement
            if (!window.fileUploaded) {
                alert('Please Submit your resume before proceeding.');
                return false;
            }
        }
        
        // Similar check for second file if course is not completed
        if (courseCompleted === 'no') {
            const secondFileInput = document.getElementById('secondFileToTransfer');
            
            if (secondFileInput && secondFileInput.files && secondFileInput.files.length > 0 && !window.secondFileUploaded) {
                alert('You have selected a new approval letter. Please click on "Submit File" button before proceeding.');
                return false;
            }
            
            if (!window.secondFileUploaded) {
                alert('Please Submit the Approval Letter from HOD before proceeding.');
                return false;
            }
        }
        
        // If file upload validation passes, continue with form transition
        // [Rest of the existing function code remains the same]
//        document.getElementById('trainingHiddenStaffNo').value = document.getElementById('staffNo').value;
        document.getElementById('trainingHiddenInternship').value = document.querySelector('select[name="internship"]').value;
        document.getElementById('trainingHiddenFullName').value = document.getElementById('fullName').value;
        document.getElementById('trainingHiddenEmail').value = document.getElementById('email').value;
        document.getElementById('trainingHiddenAddress').value = document.getElementById('address').value;
        document.getElementById('trainingHiddenInternreq').value = document.getElementById('internreq').value;
        document.getElementById('trainingHiddenPhone').value = document.getElementById('phone').value;
        document.getElementById('trainingHiddenRelation').value = document.querySelector('select[name="relationwithemployee"]').value;
        
        document.getElementById('trainingHiddenCourse').value = document.querySelector('select[name="Select"]').value;
        document.getElementById('trainingHiddenStream').value = document.getElementById('department').value;
        document.getElementById('trainingHiddenBranch').value = document.getElementById('branch').value;
        document.getElementById('trainingHiddenUniversity').value = document.querySelector('input[name="university"]').value;
        document.getElementById('trainingHiddenCollege').value = document.querySelector('input[name="college"]').value;
        document.getElementById('trainingHiddenDuration').value = document.querySelector('select[name="duration"]').value;
        document.getElementById('trainingHiddencompletedCourse').value = document.querySelector('select[name="completedCourse"]').value;
        document.getElementById('trainingHiddenYear').value = document.getElementById('year').value;
        document.getElementById('trainingHiddenYears').value = document.querySelector('input[name="years"]').value;
        document.getElementById('trainingHiddenjyear').value = document.querySelector('input[name="jyear"]').value;
        
        document.getElementById('trainingHiddenSemester').value = document.getElementById('sem').value;
        
        document.getElementById('trainingHiddenyears1Marks').value = document.querySelector('input[name="years1_marks"]').value;
        document.getElementById('trainingHiddenyears2Marks').value = document.querySelector('input[name="years2_marks"]').value;
        document.getElementById('trainingHiddenyears3Marks').value = document.querySelector('input[name="years3_marks"]').value;
        document.getElementById('trainingHiddenyears4Marks').value = document.querySelector('input[name="years4_marks"]').value;
        
        document.getElementById('trainingHiddenSem1Marks').value = document.querySelector('input[name="sem1_marks"]').value;
        document.getElementById('trainingHiddenSem2Marks').value = document.querySelector('input[name="sem2_marks"]').value;
        document.getElementById('trainingHiddenSem3Marks').value = document.querySelector('input[name="sem3_marks"]').value;
        document.getElementById('trainingHiddenSem4Marks').value = document.querySelector('input[name="sem4_marks"]').value;
        document.getElementById('trainingHiddenSem5Marks').value = document.querySelector('input[name="sem5_marks"]').value;
        document.getElementById('trainingHiddenSem6Marks').value = document.querySelector('input[name="sem6_marks"]').value;
        document.getElementById('trainingHiddenSem7Marks').value = document.querySelector('input[name="sem7_marks"]').value;
        document.getElementById('trainingHiddenSem8Marks').value = document.querySelector('input[name="sem8_marks"]').value;
        document.getElementById('trainingHiddenSem9Marks').value = document.querySelector('input[name="sem9_marks"]').value;
        document.getElementById('trainingHiddenSem10Marks').value = document.querySelector('input[name="sem10_marks"]').value;
        
        document.getElementById('trainingHiddenCGPA').value = document.getElementById('cgpaInput').value;
        
        document.querySelectorAll('.form-container').forEach(f => f.classList.remove('active'));
        document.getElementById('trainingDetails').classList.add('active');
        setActiveButton('trainingDetails');
        return true;
    }
    return false;
}






function validateUserDetails() {
    const requiredFields = {
        'internship': document.querySelector('select[name="internship"]'),
        'fullName': document.getElementById('fullName'),
        'email': document.getElementById('email'),
        'address': document.getElementById('address'),
        'internreq': document.getElementById('internreq'),
        'relationwithemployee': document.querySelector('select[name="relationwithemployee"]'),
        'phone': document.getElementById('phone')
    };

    let isValid = true;

    // Check if all fields are filled
    for (let field in requiredFields) {
        const element = requiredFields[field];
        if (!element.value.trim()) {
            element.style.borderColor = 'red';
            isValid = false;
        } else {
            element.style.borderColor = '';
        }
    }

    // Additional validations
    if (!validateEmail(document.getElementById('email'))) {
        isValid = false;
    }

    if (!validatePhoneNumber(document.getElementById('phone'))) {
        isValid = false;
    }

    if (!validateAddress(document.getElementById('address'))) {
        isValid = false;
    }

    if (!isValid) {
        alert('Please fill in all required fields correctly before proceeding.');
        return false;
    }

    return true;
}

function validatejyear() {
    const jyearInput = document.getElementById('jyear');
    const jyearValue = parseInt(jyearInput.value);
    
    if ( jyearValue > 2025) {
        // Show alert
        alert("Joined year must be between 2000 and 2025.");
        // Reset the input value
        jyearInput.value = '';
        // Focus on the input to let user retry
        jyearInput.focus();
        return false;
    }
    return true;
}

function validateAcademicDetails() {
    const requiredFields = {
        'course_select': document.querySelector('select[name="Select"]'),
        'department': document.getElementById('department'),
        'branch': document.querySelector('input[name="branch"]'),
        'university': document.querySelector('input[name="university"]'),
        'college': document.querySelector('input[name="college"]'),
        'duration': document.querySelector('select[name="duration"]'),
        'completedCourse': document.querySelector('select[name="completedCourse"]'),
        'cgpa': document.getElementById('cgpaInput')
    };

    let isValid = true;

    // Check if all fields are filled
    for (let field in requiredFields) {
        const element = requiredFields[field];
        if (!element || !element.value.trim()) {
            if (element) {
                element.style.borderColor = 'red';
            }
            isValid = false;
        } else if (element) {
            element.style.borderColor = '';
        }
    }
    
    
     const completedCourse = document.getElementById('completedCourse').value;
    
    if (completedCourse === "yes") {
        // Check if file is uploaded
        if (!isFileUploaded()) {
            alert("Resume submission is mandatory when course is completed.");
            return false;
        }
    }
    
    if (!isValid) {
        alert('Please fill in all required fields before proceeding.');
        return false;
    }

    return true;
}

// Update the isFileUploaded function to be more robust
function isFileUploaded() {
    // Check if the fileUploaded flag is set to true
    if (window.fileUploaded === true) {
        return true;
    }
    
    // As a fallback, check if a file is selected
    const fileInput = document.getElementById('fileToTransfer') || document.getElementById('fileTotransfer') || document.getElementById('fileInput');
    return fileInput && fileInput.files && fileInput.files.length > 0;
}

// Initialize the fileUploaded flag on page load
document.addEventListener('DOMContentLoaded', function () {
    // Reset the file uploaded flag when the page loads
    window.fileUploaded = false;

    // Add event listener to clear the uploaded status when file selection changes
    const fileInput = document.getElementById('fileToTransfer');
    if (fileInput) {
        fileInput.addEventListener('change', function () {
            window.fileUploaded = false; // Reset flag when file selection changes
            const uploadStatus = document.getElementById('uploadStatus');
            if (uploadStatus) {
                uploadStatus.innerHTML = 'File selected. Click on"Submit File" button to upload.';
                uploadStatus.style.color = 'blue';
            }
        });
    }
});


function validateTrainingDetails() {
    const requiredFields = {
           
        'groupName': document.querySelector('select[name="groupName"]'),
        'groupstaff': document.querySelector('select[name="groupstaff"]'),
        'guideName': document.querySelector('input[name="guideName"]'),
        'trainingDuration': document.querySelector('input[name="trainingDuration"]')
    };
    
    let isValid = true;
    
    // Check each required field
    for (let field in requiredFields) {
        const element = requiredFields[field];
        if (!element.value.trim()) {
            element.style.borderColor = 'red';
            isValid = false;
        } else {
            element.style.borderColor = '';
        }
    }
//    const staffNo = document.getElementById('staffNo').value;
    // Update submit button state
    const submitButton = document.querySelector('input[type="submit"]') || 
                         document.querySelector('button[type="submit"]');
    
    if (submitButton) {
        submitButton.disabled = !isValid;
    }
    
    if (!isValid) {
        alert('Please fill in all required fields before proceeding.');
        return false;
    }
    
    return true;
}

// Add this to run validation whenever any field changes
function setupFormValidation() {
    const requiredFields = document.querySelectorAll('select[name="groupName"], select[name="groupstaff"], input[name="guideName"], input[name="trainingDuration"]');
    
    requiredFields.forEach(field => {
        field.addEventListener('input', validateTrainingDetails);
        field.addEventListener('change', validateTrainingDetails);
    });
    
    // Run validation once on page load
    validateTrainingDetails();
}

// Call this when the page loads
document.addEventListener('DOMContentLoaded', setupFormValidation);

function goBack(currentForm, previousForm) {
    showForm(previousForm);
}

function isStudentDetailsFilled() {
//    const staffNo = document.getElementById("staffNo").value;
    const fullName = document.getElementById("fullName").value.trim();
    const email = document.getElementById("email").value.trim();
    const address = document.getElementById("address").value.trim();
    const internreq = document.getElementById("internreq").value.trim();
    const phone = document.getElementById("phone").value.trim();
    const internship = document.querySelector('select[name="internship"]').value;
    const relation = document.querySelector('select[name="relationwithemployee"]').value;

    return  fullName && email && address && phone && internship && relation;
}

// Function to check if academic details are filled
function isAcademicDetailsFilled() {
    const course = document.querySelector('select[name="Select"]').value;
    const department = document.getElementById("department").value;
    const branch = document.querySelector('input[name="branch"]').value.trim();
    const university = document.querySelector('input[name="university"]').value.trim();
    const college = document.querySelector('input[name="college"]').value.trim();
    const duration = document.querySelector('select[name="duration"]').value;
    const completedCourse = document.querySelector('select[name="completedCourse"]').value;
    const year = document.getElementById("year").value;
    const years = document.getElementById("years").value;
    const sem = document.getElementById("sem").value;
    const jyear = document.getElementById("jyear").value;
    
    const years1_marks = document.getElementById("years1_marks").value;
    const years2_marks = document.getElementById("years2_marks").value;
    const years3_marks = document.getElementById("years3_marks").value;
    const years4_marks = document.getElementById("years4_marks").value;
    
    
    const sem1_marks = document.getElementById("sem1_marks").value;
    const sem2_marks = document.getElementById("sem2_marks").value;
    const sem3_marks = document.getElementById("sem3_marks").value;
    const sem4_marks = document.getElementById("sem4_marks").value;
    const sem5_marks = document.getElementById("sem5_marks").value;
    const sem6_marks = document.getElementById("sem6_marks").value;
    const sem7_marks = document.getElementById("sem7_marks").value;
    const sem8_marks = document.getElementById("sem8_marks").value;
    const sem9_marks = document.getElementById("sem9_marks").value;
    const sem10_marks = document.getElementById("sem10_marks").value;

    

    return course && department && branch && university && college && duration && completedCourse && year && sem && jyear && years1_marks && years2_marks && years3_marks && years4_marks && sem1_marks && sem2_marks &&sem3_marks &&sem4_marks &&sem5_marks &&sem6_marks &&sem7_marks &&sem8_marks &&sem9_marks &&sem10_marks;
}

function isFileUploaded() {
    // First check the window.fileUploaded flag which should be set upon successful upload
    if (window.fileUploaded === true) {
        return true;
    }
    
    // As a fallback, check the file input element
    const fileInput = document.getElementById('fileToTransfer') || 
                      document.getElementById('fileTotransfer') || 
                      document.getElementById('fileInput');
    
    if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
        return false;
    }
    
    // Make sure we look at upload status indicator if it exists
    const uploadStatus = document.getElementById('uploadStatus') || 
                         document.getElementById('uploadstatus');
    
    // If upload status exists and indicates success, we can consider it uploaded
    if (uploadStatus && 
        uploadStatus.textContent && 
        uploadStatus.textContent.toLowerCase().includes('success')) {
        return true;
    }
    
    // Otherwise just check if a file is selected (though this doesn't confirm upload)
    return fileInput.files.length > 0;
}


function prepareSubmission() {
    // Get values from all forms
    const formData = new FormData(document.forms['trainingForm']);

    // Add values from Student Details form
//    formData.append('staffNo', document.getElementById('staffNo').value);
    formData.append('internship', document.getElementById('internship').value);
    formData.append('fullName', document.getElementById('fullName').value);
    formData.append('email', document.getElementById('email').value);
    formData.append('address', document.getElementById('address').value);
    formData.append('internreq', document.getElementById('internreq').value);
    formData.append('phone', document.getElementById('phone').value);

    // Add Academic Details
    formData.append('course', document.getElementById('course').value);
    formData.append('department', document.getElementById('department').value);
    formData.append('branch', document.getElementById('branch').value);
    formData.append('university', document.getElementById('university').value);
    formData.append('college', document.getElementById('college').value);
    formData.append('duration', document.getElementById('duration').value);
    formData.append('completedCourse', document.getElementById('completedCourse').value);
    formData.append('year', document.getElementById('year').value);
    formData.append('years', document.getElementById('years').value);
    formData.append('semester', document.getElementById('semester').value);
    formData.append('jyear', document.getElementById('jyear').value);
    
    formData.append('years1_marks', document.getElementById('years1_marks').value);
    formData.append('years2_marks', document.getElementById('years2_marks').value);
    formData.append('years3_marks', document.getElementById('years3_marks').value);
    formData.append('years4_marks', document.getElementById('years4_marks').value);
    
    formData.append('sem1_marks', document.getElementById('sem1_marks').value);
    console.log(document.getElementById('sem1').value);
        formData.append('sem2_marks', document.getElementById('sem2_marks').value);
    formData.append('sem3_marks', document.getElementById('sem3_marks').value);
    formData.append('sem4_marks', document.getElementById('sem4_marks').value);
    formData.append('sem5_marks', document.getElementById('sem5_marks').value);
    formData.append('sem6_marks', document.getElementById('sem6_marks').value);
    formData.append('sem7_marks', document.getElementById('sem7_marks').value);
    formData.append('sem8_marks', document.getElementById('sem8_marks').value);
    formData.append('sem9_marks', document.getElementById('sem9_marks').value);
    formData.append('sem10_marks', document.getElementById('sem10_marks').value);


    
    formData.append('cgpa', document.getElementById('cgpa').value);

    // Training details are already in the trainingForm
    // but make sure to append them if they aren't:
    if (!formData.has('group_name')) {
        formData.append('group_name', document.getElementById('group_name').value);
    }
    if (!formData.has('group_staff')) {
        formData.append('group_staff', document.getElementById('group_staff').value);
    }
    if (!formData.has('guide_name')) {
        formData.append('guide_name', document.getElementById('guide_name').value);
    }
    if (!formData.has('training_duration')) {
        formData.append('training_duration', document.getElementById('training_duration').value);
    }

    // Log data for debugging (optional)
    console.log("Form data prepared for submission:");
    for (let pair of formData.entries()) {
        console.log(pair[0] + ': ' + pair[1]);
    }

    return true;
}

document.getElementById("fileInput").addEventListener("change", function () {
    let file = this.files[0];
    let validExtensions = ["pdf", "doc", "docx"];
    let fileExtension = file.name.split('.').pop().toLowerCase();

    if (validExtensions.includes(fileExtension)) {
        document.getElementById("success-message").style.display = "block";
        document.getElementById("error-message").style.display = "none";
    } else {
        document.getElementById("success-message").style.display = "none";
        document.getElementById("error-message").style.display = "block";
        this.value = ""; // Reset file input
    }
});

document.addEventListener('DOMContentLoaded', function () {
    // Reset the file uploaded flag when the page loads
    window.fileUploaded = false;

    // Add event listener to clear the uploaded status when file selection changes
    const fileInput = document.getElementById('fileTotransfer');
    if (fileInput) {
        fileInput.addEventListener('change', function () {
            window.fileUploaded = false; // Reset flag when file selection changes
            const uploadStatus = document.getElementById('uploadstatus');
            if (uploadStatus) {
                uploadStatus.innerHTML = 'File selected. Click on "Submit File" button to upload.';
                uploadStatus.style.color = 'blue';
            }
        });
    }
});


//




// Add event listener for second file
document.addEventListener('DOMContentLoaded', function () {
    // Handle existing events from your original code
    // Then add these additional handlers:

    // Reset the second file uploaded flag when the page loads
    window.secondFileUploaded = false;

    // Add event listener to clear the uploaded status when second file selection changes
    const secondFileInput = document.getElementById('secondFileToTransfer');
    if (secondFileInput) {
        secondFileInput.addEventListener('change', function () {
            window.secondFileUploaded = false; // Reset flag when file selection changes
            const uploadStatus = document.getElementById('secondUploadStatus');
            if (uploadStatus) {
                uploadStatus.innerHTML = 'File selected. Click Submit Second File" button to upload.';
                uploadStatus.style.color = 'blue';
            }
        });
    }
});


document.addEventListener('DOMContentLoaded', function () {
    const userDetailsBtn = document.getElementById('userDetailsBtn');
    const academicDetailsBtn = document.getElementById('academicDetailsBtn');
    const trainingDetailsBtn = document.getElementById('trainingDetailsBtn');

    const userDetailsForm = document.getElementById('userDetailsForm');
    const academicDetailsForm = document.getElementById('academicDetailsForm');
    const trainingDetailsForm = document.getElementById('trainingDetailsForm');

    // Default state - User Details is dark blue
    userDetailsBtn.classList.add('active');
    userDetailsForm.classList.add('active');

    userDetailsBtn.addEventListener('click', function () {
        resetForms();
        userDetailsForm.classList.add('active');
        userDetailsBtn.classList.add('active');
    });

    academicDetailsBtn.addEventListener('click', function () {
        resetForms();
        academicDetailsForm.classList.add('active');
        academicDetailsForm.classList.add('academic-active');
        academicDetailsBtn.classList.add('active');
    });

    trainingDetailsBtn.addEventListener('click', function () {
        resetForms();
        trainingDetailsForm.classList.add('active');
        trainingDetailsForm.classList.add('training-active');
        trainingDetailsBtn.classList.add('active');
    });

    function resetForms() {
        // Remove active class from all forms
        userDetailsForm.classList.remove('active');
        academicDetailsForm.classList.remove('active');
        trainingDetailsForm.classList.remove('active');

        // Remove additional active classes
        userDetailsForm.classList.remove('academic-active');
        userDetailsForm.classList.remove('training-active');
        academicDetailsForm.classList.remove('academic-active');
        trainingDetailsForm.classList.remove('training-active');

        // Remove active class from all buttons
        userDetailsBtn.classList.remove('active');
        academicDetailsBtn.classList.remove('active');
        trainingDetailsBtn.classList.remove('active');
    }
});



        function showSuccessAlert() {
        fetch("getcdotid.jsp")
            .then(response => response.text())
            .then(lastCdotId => {
                const alertBox = document.createElement("div");
                alertBox.innerHTML = `The internship form of <b>${lastCdotId}</b> has been applied successfully!`;
                alertBox.style.position = "fixed";
                alertBox.style.top = "50%";
                alertBox.style.left = "50%";
                alertBox.style.transform = "translate(-50%, -50%)";
                alertBox.style.background = "#28a745";
                alertBox.style.color = "white";
                alertBox.style.padding = "20px";
                alertBox.style.borderRadius = "10px";
                alertBox.style.fontSize = "18px";
                alertBox.style.boxShadow = "0px 4px 6px rgba(0, 0, 0, 0.1)";
                document.body.appendChild(alertBox);

                setTimeout(() => {
                    alertBox.remove();
                }, 3000);
            })
            .catch(error => console.error("Error fetching cdot_id:", error));
    }

    window.onload = showSuccessAlert;
        
 // Validate training form inputs
function validateTrainingForm() {
    const guideName = document.querySelector('input[name="guideName"]').value;
    const duration = document.querySelector('input[name="trainingDuration"]').value;
    
    if (!guideName.trim()) {
        alert('Please enter a guide name');
        return false;
    }
    
    if (!duration || duration < 1 || duration > 12) {
        alert('Please enter a valid training duration between 1 and 12 months');
        return false;
    }
    
    return true; // Return true if validation passes
}


// Function to reset the counter to 144
function resetCdotCounter() {
    localStorage.setItem('cdotCounter', '144'); // Set to 143 so next ID will be 144
//    console.log("CDOT counter reset to start from 144");
}

// You can call this function manually in the browser console
// or add it to window.onload to reset on page load:
window.onload = function() {
    // Uncomment the line below to reset counter on every page load
    // resetCdotCounter();
    
    // Rest of your existing onload code...
    document.body.addEventListener('mousemove', resetTimer);
    document.body.addEventListener('keypress', resetTimer);
    setActiveButton('userDetails');
    
    // Reset file upload state whenever page loads
    resetFileUpload();
    
    // Get the form parameter from the URL
    var urlParams = new URLSearchParams(window.location.search);
    var formToShow = urlParams.get('form');
    
    // If a specific form is requested in the URL, show it automatically
    if (formToShow) {
        showForm(formToShow);
    }
};

// Get CDOT ID from localStorage
// Get CDOT ID from localStorage
function getCdotId() {
    // Get current counter from localStorage or initialize if not exists
    let counter = localStorage.getItem('cdotCounter');
    
    // If counter doesn't exist or is less than 144, start from 144
    if (!counter || parseInt(counter) < 144) {
        counter = 144;
    } else {
        counter = parseInt(counter) + 1;
    }
    
    // Store the incremented counter
    localStorage.setItem('cdotCounter', counter);
    
    // Return formatted CDOT ID
    return `cdot${counter}`;
}

// Function to display CDOT ID alert
function showCdotIdAlert(cdotId) {
    // Create overlay
    const overlay = document.createElement('div');
    overlay.style.position = 'fixed';
    overlay.style.top = '0';
    overlay.style.left = '0';
    overlay.style.width = '100%';
    overlay.style.height = '100%';
    overlay.style.backgroundColor = 'rgba(0,0,0,0.5)';
    overlay.style.zIndex = '9998';
    
    // Prevent clicking on overlay from closing the popup
    overlay.onclick = function(event) {
        event.stopPropagation();
        return false; // Prevent default
    };
    
    // Create alert container
    const alertContainer = document.createElement('div');
    alertContainer.style.position = 'fixed';
    alertContainer.style.left = '50%';
    alertContainer.style.top = '50%';
    alertContainer.style.transform = 'translate(-50%, -50%)';
    alertContainer.style.backgroundColor = '#f0f8ff';
    alertContainer.style.border = '2px solid #4682b4';
    alertContainer.style.borderRadius = '8px';
    alertContainer.style.padding = '20px';
    alertContainer.style.boxShadow = '0 4px 8px rgba(0,0,0,0.2)';
    alertContainer.style.zIndex = '9999';
    alertContainer.style.minWidth = '300px';
    alertContainer.style.textAlign = 'center';
    
    // Prevent clicks on alert container from bubbling up
    alertContainer.onclick = function(event) {
        event.stopPropagation();
    };
    
    // Create content
    const heading = document.createElement('h3');
    heading.textContent = 'Application Submitted Successfully';
    heading.style.marginTop = '0';
    heading.style.color = '#4682b4';
    
    const idText = document.createElement('p');
    idText.textContent = `Your Internship Request Id is: ${cdotId}`;
    idText.style.fontSize = '18px';
    idText.style.fontWeight = 'bold';
    
    const noteText = document.createElement('p');
    noteText.textContent = 'Please save this ID for future reference.';
    noteText.style.fontSize = '14px';
    
    const closeButton = document.createElement('button');
    closeButton.textContent = 'Close';
    closeButton.style.padding = '8px 16px';
    closeButton.style.backgroundColor = '#4682b4';
    closeButton.style.color = 'white';
    closeButton.style.border = 'none';
    closeButton.style.borderRadius = '4px';
    closeButton.style.marginTop = '10px';
    closeButton.style.cursor = 'pointer';
    
    // Prevent ESC key from closing the popup
    const preventEscClose = function(e) {
        if (e.key === "Escape") {
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
    };
    
    // Add event listener for ESC key
    document.addEventListener('keydown', preventEscClose);
    
    // Prevent any other default browser behaviors that might close dialogs
    window.onbeforeunload = function(e) {
        return "The popup is still open. Are you sure you want to leave?";
    };
    
    // Close popup only when clicking the "Close" button
    closeButton.onclick = function() {
        document.body.removeChild(overlay);
        document.body.removeChild(alertContainer);
        document.removeEventListener('keydown', preventEscClose);
        window.onbeforeunload = null; // Remove the leave confirmation
    };
    
    // Assemble alert
    alertContainer.appendChild(heading);
    alertContainer.appendChild(idText);
    alertContainer.appendChild(noteText);
    alertContainer.appendChild(closeButton);
    
    // Add to body
    document.body.appendChild(overlay);
    document.body.appendChild(alertContainer);
    
    // Prevent the browser's back button from closing the popup
    const originalPushState = history.pushState;
    history.pushState = function() {
        originalPushState.apply(this, arguments);
    };
    
    history.pushState({}, '', '');
    window.addEventListener('popstate', function(event) {
        history.pushState({}, '', '');
    });
}

// Combined function to handle form submission with validation
function handleFormSubmit() {
    // First validate the form
    if (!validateTrainingForm()) {
        return false; // Stop if validation fails
    }
    
     // Hide the training details container
    const trainingDetailsContainer = document.getElementById('trainingDetails');
    if (trainingDetailsContainer) {
        trainingDetailsContainer.style.display = 'none';
    }
    // Get the next CDOT ID
    const cdotId = getCdotId();
//    const staffNo = document.getElementById('staffNo').value;
    // Store the CDOT ID in a hidden field if needed by your backend
    const form = document.querySelector('#trainingDetails form');
    let cdotIdInput = form.querySelector('input[name="cdotId"]');
    if (!cdotIdInput) {
        cdotIdInput = document.createElement('input');
        cdotIdInput.type = 'hidden';
        cdotIdInput.name = 'cdotId';
        form.appendChild(cdotIdInput);
    }
    cdotIdInput.value = cdotId;
    
    // Set up a way to intercept the form submission
    const formAction = form.action;
    const formTarget = form.target;
    
    // Create a hidden iframe to receive the form submission result
    const targetIframe = document.createElement('iframe');
    targetIframe.name = 'submit_target';
    targetIframe.style.display = 'none';
    document.body.appendChild(targetIframe);
    
    // Set the form to submit to the iframe
    form.target = 'submit_target';
    
    // Submit the form (this will save data to database)
    form.submit();
    
    // Hide the form immediately after submission
    form.style.display = 'none';
    
    // Show the popup with CDOT ID
    showCdotIdAlert(cdotId);
    
    // Clean up - restore original form properties after submission
    setTimeout(() => {
        form.action = formAction;
        form.target = formTarget;
        document.body.removeChild(targetIframe);
    }, 1000);
    
    return false; // Prevent default form submission behavior
}

// Add this function to reset the file upload state
function resetFileUpload() {
    const fileInput = document.getElementById('fileToTransfer');
    const uploadStatus = document.getElementById('uploadStatus');
    
    // Clear the file input
    if (fileInput) fileInput.value = '';
    
    // Clear status message
    if (uploadStatus) {
        uploadStatus.innerHTML = '';
        uploadStatus.style.color = '';
    }
    
    // Reset the uploaded flag
    window.fileUploaded = false;
}

// Modify your window.onload function to reset the upload state
window.onload = function() {
    // Get the form parameter from the URL
    var urlParams = new URLSearchParams(window.location.search);
    var formToShow = urlParams.get('form');
    
    // Reset file upload state whenever page loads
    resetFileUpload();
    
    // If a specific form is requested in the URL, show it automatically
    if (formToShow) {
        showForm(formToShow);
    }
};

// Add a new event listener for the fileInput to reset status when changed
function addFileInputListener() {
    const fileInput = document.getElementById('fileToTransfer');
    if (fileInput) {
        fileInput.addEventListener('change', function() {
            const uploadStatus = document.getElementById('uploadStatus');
            if (uploadStatus) {
                uploadStatus.innerHTML = '';
                uploadStatus.style.color = '';
            }
        });
    }
}

// Call this in your window.onload function
document.addEventListener('DOMContentLoaded', function() {
    addFileInputListener();
});