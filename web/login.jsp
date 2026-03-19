<%-- 
    Document   : login
    
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập hệ thống - GearWorks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background-color: #f0f2f5;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-image: radial-gradient(#d7d7d7 1px, transparent 1px);
            background-size: 20px 20px;
        }
        .login-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 40px 30px;
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .logo-img { width: 120px; margin-bottom: 10px; }
        .form-control { border-radius: 20px; padding-left: 40px; }
        .input-icon {
            position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #6c757d;
        }
        .btn-login {
            background: linear-gradient(to right, #1a2980, #26d0ce);
            border: none; border-radius: 20px; width: 100%; padding: 10px; color: white; font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="login-card position-relative">
        <img src="https://cdn-icons-png.flaticon.com/512/2092/2092058.png" alt="Logo" class="logo-img">
        <h4 class="fw-bold text-dark mb-0">GEARWORKS SYSTEMS</h4>
        <p class="text-muted small mb-4">SECURE ACCESS PORTAL</p>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="loginUser"/>
            
            <div class="position-relative mb-3">
                <i class="fa-solid fa-user input-icon"></i>
                <input type="text" name="txtUsername" class="form-control" placeholder="Email or Username" required>
            </div>

            <div class="position-relative mb-3">
                <i class="fa-solid fa-lock input-icon"></i>
                <input type="password" name="txtPassword" id="password" class="form-control" placeholder="Password" required>
                <i class="fa-solid fa-eye position-absolute" style="right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;" onclick="togglePassword()"></i>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-4 small">
                <label><input type="checkbox"> Remember Me</label>
                <a href="#" class="text-decoration-none">Forgot Password?</a>
            </div>

            <button type="submit" class="btn btn-login mb-3">LOG IN</button>
            <div class="text-muted small">&copy; 2026 GearWorks Systems. All rights reserved.</div>
        </form>
    </div>

    <c:if test="${not empty message}">
        <script>
            Swal.fire({
                icon: 'error',
                title: 'Lỗi Xác Thực',
                text: 'Tên người dùng hoặc Mật khẩu không chính xác. Vui lòng kiểm tra lại.',
                confirmButtonColor: '#d33',
                confirmButtonText: 'OK'
            });
        </script>
    </c:if>

    <c:if test="${loginSuccess == 'true'}">
        <script>
            Swal.fire({
                icon: 'success',
                title: 'Đăng nhập thành công!',
                text: 'Welcome ${welcomeName}, Role: ${welcomeRole}',
                confirmButtonColor: '#28a745',
                confirmButtonText: 'OK',
                allowOutsideClick: false
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'Dashboard.jsp';
                }
            });
        </script>
    </c:if>

    <script>
        function togglePassword() {
            var pwd = document.getElementById("password");
            if (pwd.type === "password") pwd.type = "text";
            else pwd.type = "password";
        }
    </script>
</body>
</html>