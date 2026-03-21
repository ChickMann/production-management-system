<%@page contentType="text/html" pageEncoding="UTF-8" import="java.lang.String"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String message = (String) session.getAttribute("loginMessage");
    String usernameValue = (String) session.getAttribute("loginUsername");
    if (usernameValue == null) {
        usernameValue = "";
    }

    session.removeAttribute("loginMessage");
    session.removeAttribute("loginUsername");
%>
<!DOCTYPE html>
<!--
  Trang đăng nhập thật của project.
  - Không dùng JSTL để tránh lỗi thiếu thư viện trên Tomcat hiện tại.
  - Form submit trực tiếp tới `MainController` với action `loginUser`.
  - Nếu đăng nhập sai thì backend set `message` và trang này hiển thị lại thông báo lỗi.
-->
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign In</title>
        <style>
            :root {
                --bg: #f3f4f6;
                --surface: #ffffff;
                --surface-muted: #f8fafc;
                --border: #e5e7eb;
                --text: #111827;
                --text-muted: #6b7280;
                --text-inverse: #ffffff;
                --primary: #2563eb;
                --primary-soft: #dbeafe;
                --danger: #dc2626;
                --danger-soft: #fee2e2;
                --shadow-sm: 0 1px 2px rgba(15, 23, 42, 0.06);
                --radius-sm: 10px;
                --radius-md: 16px;
                font-family: Inter, "Segoe UI", Roboto, Arial, sans-serif;
            }

            * {
                box-sizing: border-box;
            }

            html,
            body {
                margin: 0;
                min-height: 100%;
                background: var(--bg);
                color: var(--text);
            }

            body {
                font-family: inherit;
            }

            button,
            input {
                font: inherit;
            }

            a {
                color: inherit;
                text-decoration: none;
            }

            .auth-shell {
                min-height: 100vh;
                display: grid;
                place-items: center;
                padding: 32px 16px;
            }

            .auth-card {
                width: min(100%, 960px);
                display: grid;
                grid-template-columns: 1fr 1fr;
                overflow: hidden;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius-md);
                box-shadow: var(--shadow-sm);
            }

            .auth-visual,
            .auth-form {
                padding: 36px;
            }

            .auth-visual {
                background: var(--surface-muted);
                display: grid;
                place-items: center;
                border-right: 1px solid var(--border);
            }

            .auth-visual img {
                width: min(100%, 260px);
                height: auto;
                object-fit: contain;
            }

            .section-title {
                margin: 0;
                font-size: 1.5rem;
                font-weight: 700;
            }

            .section-subtitle {
                margin: 8px 0 0;
                color: var(--text-muted);
                line-height: 1.6;
            }

            form {
                display: grid;
                gap: 16px;
                margin-top: 24px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
            }

            .input {
                width: 100%;
                padding: 12px 14px;
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                background: var(--surface);
                color: var(--text);
            }

            .input:focus {
                outline: 2px solid var(--primary-soft);
                border-color: var(--primary);
            }

            .auth-meta {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 12px;
                color: var(--text-muted);
                font-size: 0.95rem;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                padding: 12px 16px;
                border-radius: var(--radius-sm);
                border: 1px solid transparent;
                cursor: pointer;
            }

            .btn-primary {
                background: var(--primary);
                color: var(--text-inverse);
            }

            .btn-primary:hover {
                background: #1d4ed8;
            }

            .form-alert {
                display: none;
            }

            .login-popup-backdrop {
                position: fixed;
                inset: 0;
                background: rgba(15, 23, 42, 0.45);
                display: none;
                align-items: center;
                justify-content: center;
                padding: 24px;
                z-index: 50;
            }

            .login-popup-backdrop.is-open {
                display: flex;
            }

            .login-popup {
                width: min(100%, 420px);
                background: var(--surface);
                border-radius: 22px;
                box-shadow: 0 24px 60px rgba(15, 23, 42, 0.22);
                border: 1px solid #fecaca;
                overflow: hidden;
                animation: popupIn 0.22s ease;
            }

            .login-popup-head {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 20px 22px 12px;
            }

            .login-popup-icon {
                width: 42px;
                height: 42px;
                border-radius: 999px;
                background: var(--danger-soft);
                color: var(--danger);
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 1.1rem;
                flex-shrink: 0;
            }

            .login-popup-title {
                margin: 0;
                font-size: 1.1rem;
                font-weight: 700;
                color: var(--text);
            }

            .login-popup-subtitle {
                margin: 4px 0 0;
                color: var(--text-muted);
                font-size: 0.92rem;
                line-height: 1.5;
            }

            .login-popup-body {
                padding: 0 22px 20px;
            }

            .login-popup-message {
                margin: 0;
                padding: 14px 16px;
                border-radius: 14px;
                background: linear-gradient(180deg, #fff1f2 0%, #ffe4e6 100%);
                color: #9f1239;
                border: 1px solid #fecdd3;
                line-height: 1.6;
            }

            .login-popup-actions {
                display: flex;
                justify-content: flex-end;
                padding: 0 22px 22px;
            }

            .login-popup-close {
                min-width: 110px;
            }

            @keyframes popupIn {
                from {
                    opacity: 0;
                    transform: translateY(10px) scale(0.98);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            @media (max-width: 860px) {
                .auth-card {
                    grid-template-columns: 1fr;
                }

                .auth-visual {
                    border-right: 0;
                    border-bottom: 1px solid var(--border);
                }
            }
        </style>
    </head>
    <body>
        <div class="auth-shell">
            <section class="auth-card">
                <div class="auth-visual">
                    <img src="img/logo.png" alt="Application logo" />
                </div>

                <div class="auth-form">
                    <h1 class="section-title">Sign in</h1>
                    <p class="section-subtitle">Access the system with a simple and clear login form.</p>

                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="loginUser"/>

                        <% if (message != null && !message.trim().isEmpty()) { %>
                            <div class="form-alert"><%= message %></div>
                        <% } %>

                        <div>
                            <label for="txtUsername">Username</label>
                            <input
                                id="txtUsername"
                                class="input"
                                type="text"
                                name="txtUsername"
                                placeholder="Enter your username"
                                value="<%= usernameValue %>"
                                required
                            />
                        </div>

                        <div>
                            <label for="txtPassword">Password</label>
                            <input
                                id="txtPassword"
                                class="input"
                                type="password"
                                name="txtPassword"
                                placeholder="Enter your password"
                                required
                            />
                        </div>

                        <div class="auth-meta">
                            <span>Use your existing account to continue.</span>
                            <a href="index.jsp">Back to home</a>
                        </div>

                        <button class="btn btn-primary" type="submit">Sign in</button>
                    </form>
                </div>
            </section>
        </div>

        <% if (message != null && !message.trim().isEmpty()) { %>
            <div id="loginErrorPopup" class="login-popup-backdrop is-open">
                <div class="login-popup" role="alertdialog" aria-modal="true" aria-labelledby="loginErrorTitle">
                    <div class="login-popup-head">
                        <div class="login-popup-icon">!</div>
                        <div>
                            <h2 id="loginErrorTitle" class="login-popup-title">Sign in failed</h2>
                            <p class="login-popup-subtitle">Please check your username and password, then try again.</p>
                        </div>
                    </div>
                    <div class="login-popup-body">
                        <p class="login-popup-message"><%= message %></p>
                    </div>
                    <div class="login-popup-actions">
                        <button id="loginPopupClose" class="btn btn-primary login-popup-close" type="button">Try again</button>
                    </div>
                </div>
            </div>
        <% } %>

        <script>
            (function () {
                var popup = document.getElementById('loginErrorPopup');
                var closeButton = document.getElementById('loginPopupClose');
                var usernameInput = document.getElementById('txtUsername');
                var passwordInput = document.getElementById('txtPassword');

                function focusLoginField() {
                    if (passwordInput) {
                        passwordInput.focus();
                    } else if (usernameInput) {
                        usernameInput.focus();
                    }
                }

                if (popup) {
                    function closePopup() {
                        popup.classList.remove('is-open');
                        focusLoginField();
                    }

                    if (closeButton) {
                        closeButton.addEventListener('click', closePopup);
                    }

                    popup.addEventListener('click', function (event) {
                        if (event.target === popup) {
                            closePopup();
                        }
                    });

                    document.addEventListener('keydown', function (event) {
                        if (event.key === 'Escape' && popup.classList.contains('is-open')) {
                            closePopup();
                        }
                    });
                }

                window.addEventListener('pageshow', function (event) {
                    if (event.persisted) {
                        window.location.replace('login.jsp');
                    }
                });
            }());
        </script>
    </body>
</html>
