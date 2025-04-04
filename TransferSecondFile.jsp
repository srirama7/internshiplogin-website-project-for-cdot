<%-- 
    Document   : TransferSecondFile
    Created on : 3 Mar, 2025, 11:57:11 AM
    Author     : manjuv
--%>

<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="application/json;charset=UTF-8" %>
<%
    // Set response headers to prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
    // Initialize response object
    Map<String, Object> jsonResponse = new HashMap<>();
    
    try {
        // You might want to use a different destination directory for the second file
        final String DEST_DIR = "/home/manjuv/Downloads/SecondFiles/";
        File destDir = new File(DEST_DIR);
        
        // Create destination directory if it doesn't exist
        if (!destDir.exists()) {
            destDir.mkdirs();
        }
        // Verify write permissions
        if (!destDir.canWrite()) {
            throw new Exception("No write permissions to destination directory");
        }
        // Check if request is multipart
        if (!ServletFileUpload.isMultipartContent(request)) {
            throw new Exception("Not a multipart request");
        }
        // Create a factory for disk-based file items
        DiskFileItemFactory factory = new DiskFileItemFactory();
        
        // Configure a repository for temporary files
        File repository = (File) getServletContext().getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);
        factory.setSizeThreshold(1024 * 1024); // 1MB threshold
        // Create a new file upload handler
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax(10 * 1024 * 1024); // 10MB max file size
        // Parse the request
        List<FileItem> items = upload.parseRequest(request);
        
        if (items.isEmpty()) {
            throw new Exception("No file uploaded");
        }
        // Process the uploaded file
        for (FileItem item : items) {
            if (!item.isFormField()) {
                String fileName = new File(item.getName()).getName();
                String fileExt = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
                
                // Validate file extension
                if (!fileExt.matches("pdf|doc|docx")) {
                    throw new Exception("Invalid file type. Only PDF, DOC, and DOCX files are allowed.");
                }
                // Create the destination file
                File destFile = new File(DEST_DIR + fileName);
                
                // Save the file
                item.write(destFile);
                
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Second file '" + fileName + "' uploaded successfully!");
                break; // Process only the first file
            }
        }
    } catch (Exception e) {
        jsonResponse.put("status", "error");
        jsonResponse.put("message", "Error: " + e.getMessage());
    }
    // Send JSON response
    out.print("{\"status\":\"" + jsonResponse.get("status") + "\",\"message\":\"" + jsonResponse.get("message") + "\"}");
    out.flush();
%>