package pms.controllers;

import java.io.IOException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import pms.model.UserDAO;
import pms.model.UserDTO;
import pms.utils.FileEncryptor;
import pms.utils.FileService;
import pms.utils.FileService.FileRecord;
import java.util.ArrayList;

@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class FileController extends HttpServlet {

    private FileService fileService;
    private FileEncryptor encryptor;

    @Override
    public void init() throws ServletException {
        this.fileService = new FileService();
        this.fileService.init(getServletContext());
        this.encryptor = new FileEncryptor();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listFiles(request);
                break;
            case "upload":
                uploadFile(request);
                break;
            case "download":
                downloadFile(request, response);
                return;
            case "delete":
                deleteFile(request);
                break;
            case "verifyPassword":
                verifyPassword(request, response);
                return;
            case "changePassword":
                changePassword(request);
                break;
        }

        if (request.getAttribute("redirect") != null) {
            response.sendRedirect((String) request.getAttribute("redirect"));
        } else {
            request.getRequestDispatcher("file-management.jsp").forward(request, response);
        }
    }

    private void listFiles(HttpServletRequest request) {
        String table = request.getParameter("table");
        ArrayList<FileRecord> records;

        if (table != null && !table.isEmpty()) {
            try {
                int relatedId = 0;
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    relatedId = Integer.parseInt(idStr);
                }
                records = fileService.getFilesByRelated(table, relatedId);
            } catch (Exception e) {
                records = fileService.getAllFiles();
            }
        } else {
            records = fileService.getAllFiles();
        }

        ArrayList<FileRecordWrapper> wrappers = new ArrayList<>();
        UserDAO udao = new UserDAO();

        for (FileRecord r : records) {
            String uploaderName = null;
            if (r.uploaderId > 0) {
                UserDTO u = udao.SearchByID(r.uploaderId);
                if (u != null) uploaderName = u.getFullName();
            }
            String uploadedAt = r.uploadedAt != null
                    ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(r.uploadedAt) : "-";

            wrappers.add(new FileRecordWrapper(
                    r.fileId, r.originalName, r.fileExtension,
                    r.getFormattedSize(), uploaderName, r.description,
                    uploadedAt, r.relatedTable, r.relatedId, r.getContentType()
            ));
        }

        request.setAttribute("fileList", wrappers);
    }

    private void uploadFile(HttpServletRequest request) {
        try {
            String password = request.getParameter("password");
            if (password == null || password.isEmpty()) {
                request.setAttribute("error", "Mat khau khong duoc trong!");
                listFiles(request);
                return;
            }

            String uploaderIdStr = request.getParameter("uploader_id");
            int uploaderId = 0;
            try {
                uploaderId = Integer.parseInt(uploaderIdStr);
            } catch (Exception e) {
            }

            String description = request.getParameter("description");
            String relatedTable = request.getParameter("related_table");
            String relatedIdStr = request.getParameter("related_id");

            int relatedId = 0;
            if (relatedIdStr != null && !relatedIdStr.isEmpty()) {
                try {
                    relatedId = Integer.parseInt(relatedIdStr);
                } catch (Exception e) {
                }
            }

            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getInputStream() == null) {
                request.setAttribute("error", "Khong co file duoc chon!");
                listFiles(request);
                return;
            }

            String passwordHash = encryptor.hashPassword(password).toString();

            boolean success = fileService.uploadEncryptedFile(
                    filePart, password, uploaderId, description,
                    relatedTable, relatedId
            );

            if (success) {
                request.setAttribute("msg", "Upload va ma hoa file thanh cong!");
            } else {
                request.setAttribute("error", "Upload file that bai! Kiem tra dinh dang va kich thuoc file.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Loi upload: " + e.getMessage());
            e.printStackTrace();
        }
        listFiles(request);
    }

    private void downloadFile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fileIdStr = request.getParameter("file_id");
        String password = request.getParameter("password");

        if (fileIdStr == null || password == null || password.isEmpty()) {
            request.setAttribute("downloadError", "Thieu thong tin tai xuong!");
            listFiles(request);
            request.getRequestDispatcher("file-management.jsp").forward(request, response);
            return;
        }

        try {
            int fileId = Integer.parseInt(fileIdStr);
            FileRecord record = getFileRecord(fileId);

            if (record == null) {
                request.setAttribute("downloadError", "File khong ton tai!");
                listFiles(request);
                request.getRequestDispatcher("file-management.jsp").forward(request, response);
                return;
            }

            boolean valid = fileService.verifyPassword(fileId, password);
            if (!valid) {
                request.setAttribute("downloadError", "Mat khau khong dung!");
                listFiles(request);
                request.getRequestDispatcher("file-management.jsp").forward(request, response);
                return;
            }

            byte[] decryptedData = fileService.downloadDecryptedFile(fileId, password);
            if (decryptedData == null) {
                request.setAttribute("downloadError", "Giai ma that bai!");
                listFiles(request);
                request.getRequestDispatcher("file-management.jsp").forward(request, response);
                return;
            }

            response.setContentType(record.getContentType());
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + record.originalName + "\"");
            response.setContentLength(decryptedData.length);
            response.getOutputStream().write(decryptedData);
            response.getOutputStream().flush();
            return;

        } catch (Exception e) {
            request.setAttribute("downloadError", "Loi tai file: " + e.getMessage());
            e.printStackTrace();
        }
        listFiles(request);
        request.getRequestDispatcher("file-management.jsp").forward(request, response);
    }

    private void deleteFile(HttpServletRequest request) {
        String fileIdStr = request.getParameter("file_id");
        if (fileIdStr != null && !fileIdStr.isEmpty()) {
            try {
                int fileId = Integer.parseInt(fileIdStr);
                boolean success = fileService.deleteFile(fileId);
                if (success) {
                    request.setAttribute("msg", "Xoa file thanh cong!");
                } else {
                    request.setAttribute("error", "Xoa file that bai!");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Loi: " + e.getMessage());
            }
        }
        listFiles(request);
    }

    private void verifyPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String fileIdStr = request.getParameter("file_id");
        String password = request.getParameter("password");

        response.setContentType("application/json;charset=UTF-8");
        try {
            if (fileIdStr == null || password == null) {
                response.getWriter().write("{\"valid\":false,\"error\":\"Thieu thong tin\"}");
                return;
            }
            int fileId = Integer.parseInt(fileIdStr);
            boolean valid = fileService.verifyPassword(fileId, password);
            response.getWriter().write("{\"valid\":" + valid + "}");
        } catch (Exception e) {
            response.getWriter().write("{\"valid\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void changePassword(HttpServletRequest request) {
        String fileIdStr = request.getParameter("file_id");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        if (fileIdStr == null || oldPassword == null || newPassword == null) {
            request.setAttribute("error", "Thieu thong tin!");
            listFiles(request);
            return;
        }

        try {
            int fileId = Integer.parseInt(fileIdStr);
            boolean success = fileService.changePassword(fileId, oldPassword, newPassword);
            if (success) {
                request.setAttribute("msg", "Doi mat khau thanh cong!");
            } else {
                request.setAttribute("error", "Doi mat khau that bai! Mat khau cu khong dung.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Loi: " + e.getMessage());
        }
        listFiles(request);
    }

    private FileRecord getFileRecord(int fileId) {
        java.sql.Connection con = null;
        try {
            con = pms.utils.DBUtils.getConnection();
            java.sql.PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM EncryptedFile WHERE file_id = ?");
            ps.setInt(1, fileId);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                FileRecord r = new FileRecord();
                r.fileId = rs.getInt("file_id");
                r.originalName = rs.getString("original_name");
                r.storedFileName = rs.getString("stored_name");
                r.fileExtension = rs.getString("file_extension");
                r.fileSize = rs.getLong("file_size");
                r.passwordHash = rs.getString("password_hash");
                r.uploaderId = rs.getInt("uploader_id");
                r.description = rs.getString("file_description");
                r.relatedTable = rs.getString("related_table");
                r.relatedId = rs.getInt("related_id");
                r.uploadedAt = rs.getTimestamp("uploaded_at");
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return null;
    }

    public static class FileRecordWrapper {
        public int fileId;
        public String originalName;
        public String fileExtension;
        public String fileSize;
        public String uploaderName;
        public String description;
        public String uploadedAt;
        public String relatedTable;
        public int relatedId;
        public String contentType;

        public FileRecordWrapper(int fileId, String originalName, String fileExtension,
                String fileSize, String uploaderName, String description,
                String uploadedAt, String relatedTable, int relatedId, String contentType) {
            this.fileId = fileId;
            this.originalName = originalName;
            this.fileExtension = fileExtension;
            this.fileSize = fileSize;
            this.uploaderName = uploaderName;
            this.description = description;
            this.uploadedAt = uploadedAt;
            this.relatedTable = relatedTable;
            this.relatedId = relatedId;
            this.contentType = contentType;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "File Controller";
    }
}
