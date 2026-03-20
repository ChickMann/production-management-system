package pms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pms.model.UserDTO;
import pms.utils.NotificationService;
import pms.utils.NotificationService.Notification;

public class NotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/event-stream;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        response.setHeader("Connection", "keep-alive");
        response.setHeader("Access-Control-Allow-Origin", "*");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("data: {\"error\":\"unauthorized\"}\n\n");
            response.getWriter().flush();
            return;
        }

        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.getWriter().write("data: {\"error\":\"unauthorized\"}\n\n");
            response.getWriter().flush();
            return;
        }

        String username = user.getUsername();
        List<Notification> existing = NotificationService.getNotifications(username);

        PrintWriter out = response.getWriter();

        for (Notification n : existing) {
            out.write(NotificationService.buildSseEvent(n));
            out.flush();
        }

        out.write("data: {\"type\":\"connected\",\"user\":\"" + username + "\"}\n\n");
        out.flush();

        long lastActivity = System.currentTimeMillis();
        long heartbeatInterval = 15000;
        long sessionTimeout = session.getMaxInactiveInterval() * 1000L;

        try {
            while (true) {
                Thread.sleep(5000);

                if (Thread.currentThread().isInterrupted()) break;

                long now = System.currentTimeMillis();
                HttpSession currentSession = request.getSession(false);
                if (currentSession == null || currentSession.getAttribute("user") == null) {
                    out.write("data: {\"type\":\"logout\"}\n\n");
                    out.flush();
                    break;
                }

                if ((now - lastActivity) > sessionTimeout) {
                    out.write("data: {\"type\":\"timeout\"}\n\n");
                    out.flush();
                    break;
                }

                if ((now - lastActivity) > heartbeatInterval) {
                    out.write(NotificationService.buildHeartbeatEvent());
                    out.flush();
                    lastActivity = now;
                }
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } finally {
            try { out.close(); } catch (Exception ignored) {}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("{\"error\":\"unauthorized\"}");
            return;
        }

        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.getWriter().write("{\"error\":\"unauthorized\"}");
            return;
        }

        String action = request.getParameter("action");
        String username = user.getUsername();

        if ("markRead".equals(action)) {
            String notifId = request.getParameter("id");
            NotificationService.markRead(username, notifId);
            response.getWriter().write("{\"success\":true}");
        } else if ("markAllRead".equals(action)) {
            NotificationService.markAllRead(username);
            response.getWriter().write("{\"success\":true}");
        } else if ("getCount".equals(action)) {
            int count = NotificationService.getUnreadCount(username);
            response.getWriter().write("{\"count\":" + count + "}");
        } else if ("getAll".equals(action)) {
            List<Notification> list = NotificationService.getNotifications(username);
            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Notification n : list) {
                if (!first) json.append(",");
                json.append(n.toJson());
                first = false;
            }
            json.append("]");
            response.getWriter().write(json.toString());
        } else if ("clear".equals(action)) {
            NotificationService.clearNotifications(username);
            response.getWriter().write("{\"success\":true}");
        } else {
            response.getWriter().write("{\"error\":\"unknown action\"}");
        }
    }
}
