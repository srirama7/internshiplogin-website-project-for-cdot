<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>File Transfer System</title>
     <style>
        .container {
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .upload-form {
            margin: 20px 0;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 5px;
        }
        .submit-btn {
            background: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        .submit-btn:hover {
            background: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>File Transfer System</h2>
        
        <%
        final String DEST_DIR = "/home/manjuv/Downloads/";
        
        // Check if the request contains multipart content
        if (ServletFileUpload.isMultipartContent(request)) {
            try {
                // Create a factory for disk-based file items
                DiskFileItemFactory factory = new DiskFileItemFactory();
                
                // Configure a repository (to ensure a secure temp location)
                File repository = (File) getServletContext().getAttribute("javax.servlet.context.tempdir");
                factory.setRepository(repository);
                
                // Create a new file upload handler
                ServletFileUpload upload = new ServletFileUpload(factory);
                
                // Parse the request
                List<FileItem> items = upload.parseRequest(request);
                
                for (FileItem item : items) {
                    if (!item.isFormField()) {
                        String fileName = item.getName();
                        if (fileName != null && !fileName.isEmpty()) {
                            // Check file extension
                            String fileExt = fileName.toLowerCase();
                            if (fileExt.endsWith(".pdf") || fileExt.endsWith(".doc") || fileExt.endsWith(".docx")) {
                                // Create destination file
                                File destFile = new File(DEST_DIR + fileName);
                                
                                // Save the file
                                item.write(destFile);
                                
                                out.println("<p class='success'>File '" + fileName + "' has been transferred successfully!</p>");
                            } else {
                                out.println("<p class='error'>Only PDF, DOC, and DOCX files are allowed!</p>");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
        
        <div class="upload-form">
            <form method="post" enctype="multipart/form-data">
                <div>
                    <label for="fileInput">Select File (PDF, DOC, or DOCX only):</label><br><br>
                    <input type="file" id="fileInput" name="fileInput" 
                           accept=".pdf,.doc,.docx" required><br><br>
                    <input type="submit" value="Transfer File" class="submit-btn">
                </div>
            </form>
        </div>
        
        <div>
            <h3>Notes:</h3>
            <ul>
                <li>Destination Directory: <%= DEST_DIR %></li>
                <li>Allowed file types: PDF, DOC, DOCX</li>
                <li>Files will be transferred to your Downloads folder</li>
            </ul>
        </div>
    </div>
</body>
</html>