/* global fetch */

let generatedOTP = null;
let timerInterval;
let timeLeft;
let isTimerExpired = false;
let selectedPage = ""; // Store selected page

//function getXMLHTTPObject()
//{
//    var xmlhttp;
//    try
//    {
//        if (window.XMLHttpRequest)
//        {
//            xmlhttp = new XMLHttpRequest();
//        } else if (window.ActiveXObject) {
//            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
//        }
//    } catch (er)
//    {
//        alert(er);
//    }
//    return xmlhttp;
//}
//var xmlHttp1 = getXMLHTTPObject();


function OTPFn() {
    // Get selected role
    selectedPage = document.getElementById("roleSelect").value;
    var emailid = document.getElementById("username").value;
    if (!selectedPage) {
        alert("Please select a role first!");
        return;
    }

    // Disable the Generate OTP button for 30 seconds
    const generateBtn = document.getElementById("generateBtn");
    generateBtn.disabled = true;
    generateBtn.style.cursor = "not-allowed";
    generateBtn.style.opacity = "0.5";

    setTimeout(() => {
        generateBtn.disabled = false;
        generateBtn.style.cursor = "pointer";
        generateBtn.style.opacity = "1";
    }, 30000); // Re-enable after 30 seconds

    // Reset timer state
    isTimerExpired = false;

    // Clear any existing timer
    clearInterval(timerInterval);

    // Generate new OTP
    generatedOTP = Math.floor(100000 + Math.random() * 900000);
    alert("Your OTP is: " + generatedOTP); // For testing (Remove in production)

//    tr
//    {
//        if ((emailid.length > 0)) {
//            url = "emailid=" + emailid + "&otpVal=" + generatedOTP;
//            xmlHttp1.open("GET", "./checkOTP.jsp?" + url, false);
//            xmlHttp1.onreadystatechange = checkOTPHandle;
//            xmlHttp1.send(null);
//        }
//    } catch (er) {
//        //alert("Check OTP err:::" + er);
//    }

    // Show OTP input form
    document.getElementById("otpForm").style.display = "block";

    // Reset messages
    document.getElementById("errorMessage").textContent = "";
    document.getElementById("errorMessage").style.display = "none";
    document.getElementById("successMessage").style.display = "none";

    // Start timer for 30 seconds
    timeLeft = 30;
    startTimer();
}

function checkOTPHandle()
{
    var result;
    if (xmlHttp1.readyState === 4)
    {
        if (xmlHttp1.status === 200)
        {
            result = xmlHttp1.responseText.trim();
        }
    }
}

function startTimer() {
    const timerDisplay = document.getElementById("timer");
    timerDisplay.style.display = "block";

    timerInterval = setInterval(() => {
        if (timeLeft <= 0) {
            clearInterval(timerInterval);
            timerDisplay.textContent = "OTP Expired! Please generate a new OTP.";
            isTimerExpired = true;
            generatedOTP = null; // Invalidate OTP after expiry
            return;
        }
        timerDisplay.textContent = `Time remaining: ${timeLeft} seconds`;
        timeLeft--;
    }, 1000);
}

//function OTPVerifyFn() {
//    alert("OTPVerifyFn................."); 
//    const userOTP = document.getElementById("userOTP").value;
//    const successMessage = document.getElementById("successMessage");
//    const errorMessage = document.getElementById("errorMessage");
//
//    // Reset messages
//    errorMessage.textContent = "";
//    errorMessage.style.display = "none";
//    successMessage.style.display = "none";
//
//    // Validate OTP Entry
//    if (!userOTP) {
//        errorMessage.textContent = "Please enter OTP!";
//        errorMessage.style.display = "block";
//        return;
//    }
//    if (userOTP.length !== 6) {
//        errorMessage.textContent = "OTP must be 6 digits!";
//        errorMessage.style.display = "block";
//        return;
//    }
//    if (isTimerExpired || generatedOTP === null) {
//        errorMessage.textContent = "OTP has expired! Please generate a new OTP.";
//        errorMessage.style.display = "block";
//        return;
//    }
//
//    // Verify OTP
//    if (parseInt(userOTP) === generatedOTP) {
//        clearInterval(timerInterval);
//        document.getElementById("timer").style.display = "none";
//
//        // Show success message
//        successMessage.style.display = "block";
//
//        // Reset OTP input
//        document.getElementById("userOTP").value = "";
//
//        // Invalidate OTP after success
//        generatedOTP = null;
//        isTimerExpired = true;
//
//        // Redirect after 2 seconds to the selected page
//        setTimeout(() => {
//            if (selectedPage) {
//                window.location.href = selectedPage;
//            } else {
//                alert("Error: No role selected for redirection!");
//            }
//        }, 2000);
//    } else {
//        errorMessage.textContent = "Invalid OTP! Please try again.";
//        errorMessage.style.display = "block";
//    }
//}

// Allow only numbers and limit input to 6 digits
document.getElementById("userOTP").addEventListener("input", function () {
    this.value = this.value.replace(/[^0-9]/g, '').slice(0, 6);
});


const emailInput = document.getElementById("username");
const emailError = document.getElementById("emailError");
const generateBtn = document.getElementById("generateBtn");
const otpForm = document.getElementById("otpForm");
const roleSelect = document.getElementById("roleSelect");
const verifyBtn = document.getElementById("verifyBtn");
const successMessage = document.getElementById("successMessage");

// Email validation function
function validateEmail(email) {
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return emailPattern.test(email);
}

// Email input validation listener
emailInput.addEventListener("input", function () {
    if (this.value && !validateEmail(this.value)) {
        emailError.style.display = "block";
        generateBtn.disabled = true;
    } else {
        emailError.style.display = "none";
        generateBtn.disabled = false;
    }
});

// Generate OTP button click handler
//generateBtn.addEventListener("click", function () {
//    const email = emailInput.value;
//    const role = roleSelect.value;
//
//    // Validate both email and role selection
//    if (!role) {
//        alert("Please select a role first.");
//        return;
//    }
//
//    if (!email) {
//        alert("Please enter your email.");
//        return;
//    }
//
//    if (!validateEmail(email)) {
//        emailError.style.display = "block";
//        alert("Please enter a valid email address.");
//        return;
//    }
//
//    // If all validations pass, proceed with OTP generation
//    alert("OTP sent to " + email); // Simulate OTP sending
//    otpForm.style.display = "block";
//});

// Verify OTP button click handler
//verifyBtn.addEventListener("click", function () {
//    const enteredOTP = document.getElementById("userOTP").value;
//    const staffNo = document.getElementById("staffNo").value;
//    alert("verifyBtn::::"+staffNo);
//    document.getElementById("refStaffNo").value = staffNo;
//    const role = roleSelect.value;
//
//    if (!enteredOTP) {
//        alert("Please enter the OTP.");
//        return;
//    }
//
//    if (enteredOTP === "1234") { // Simulating correct OTP
//        successMessage.style.display = "block";
//        // Redirect to the selected role page after 2 seconds
//        setTimeout(() => {
//            window.location.href = role;
//        }, 2000);
//    } else {
//        alert("Incorrect OTP, please try again.");
//    }
//});

        