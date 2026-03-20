package pms.utils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

public class NotificationService implements Serializable {

    private static final long serialVersionUID = 1L;

    private static final ConcurrentHashMap<String, List<Notification>> userNotifications = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, Long> lastActivity = new ConcurrentHashMap<>();

    public static final String TYPE_WORKORDER = "workorder";
    public static final String TYPE_PAYMENT = "payment";
    public static final String TYPE_DEFECT = "defect";
    public static final String TYPE_INVENTORY = "inventory";
    public static final String TYPE_SYSTEM = "system";

    public static class Notification implements Serializable {
        private static final long serialVersionUID = 1L;
        private final String id;
        private final String type;
        private final String title;
        private final String message;
        private final String link;
        private final long timestamp;
        private boolean read;

        public Notification(String type, String title, String message, String link) {
            this.id = System.currentTimeMillis() + "_" + (int)(Math.random() * 10000);
            this.type = type;
            this.title = title;
            this.message = message;
            this.link = link != null ? link : "#";
            this.timestamp = System.currentTimeMillis();
            this.read = false;
        }

        public String getId() { return id; }
        public String getType() { return type; }
        public String getTitle() { return title; }
        public String getMessage() { return message; }
        public String getLink() { return link; }
        public long getTimestamp() { return timestamp; }
        public boolean isRead() { return read; }
        public void setRead(boolean read) { this.read = read; }

        public String toJson() {
            StringBuilder sb = new StringBuilder();
            sb.append("{\"id\":\"").append(id).append("\",");
            sb.append("\"type\":\"").append(type != null ? type : "").append("\",");
            sb.append("\"title\":\"").append(esc(title)).append("\",");
            sb.append("\"message\":\"").append(esc(message)).append("\",");
            sb.append("\"link\":\"").append(esc(link)).append("\",");
            sb.append("\"timestamp\":").append(timestamp).append(",");
            sb.append("\"read\":").append(read).append("}");
            return sb.toString();
        }

        private static String esc(String s) {
            if (s == null) return "";
            return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "").replace("\t", "\\t");
        }
    }

    public static void pushNotification(String username, Notification notification) {
        if (username == null || notification == null) return;
        userNotifications.computeIfAbsent(username, k -> new CopyOnWriteArrayList<>());
        List<Notification> list = userNotifications.get(username);
        synchronized (list) {
            list.add(0, notification);
            if (list.size() > 50) {
                list.remove(list.size() - 1);
            }
        }
        lastActivity.put(username, System.currentTimeMillis());
    }

    public static void pushToAll(Notification notification) {
        if (notification == null) return;
        for (String username : userNotifications.keySet()) {
            pushNotification(username, notification);
        }
    }

    public static List<Notification> getNotifications(String username) {
        if (username == null) return new ArrayList<>();
        List<Notification> list = userNotifications.get(username);
        if (list == null) return new ArrayList<>();
        return new ArrayList<>(list);
    }

    public static List<Notification> getUnreadNotifications(String username) {
        List<Notification> all = getNotifications(username);
        List<Notification> unread = new ArrayList<>();
        for (Notification n : all) {
            if (!n.isRead()) unread.add(n);
        }
        return unread;
    }

    public static int getUnreadCount(String username) {
        return getUnreadNotifications(username).size();
    }

    public static void markAllRead(String username) {
        if (username == null) return;
        List<Notification> list = userNotifications.get(username);
        if (list == null) return;
        for (Notification n : list) {
            n.setRead(true);
        }
    }

    public static void markRead(String username, String notificationId) {
        if (username == null || notificationId == null) return;
        List<Notification> list = userNotifications.get(username);
        if (list == null) return;
        for (Notification n : list) {
            if (n.getId().equals(notificationId)) {
                n.setRead(true);
                break;
            }
        }
    }

    public static void clearNotifications(String username) {
        if (username == null) return;
        List<Notification> list = userNotifications.get(username);
        if (list != null) {
            list.clear();
        }
    }

    public static void removeNotification(String username, String notificationId) {
        if (username == null || notificationId == null) return;
        List<Notification> list = userNotifications.get(username);
        if (list == null) return;
        list.removeIf(n -> n.getId().equals(notificationId));
    }

    public static String buildSseEvent(Notification notification) {
        return "data: " + notification.toJson() + "\n\n";
    }

    public static String buildHeartbeatEvent() {
        return "data: {\"type\":\"heartbeat\",\"timestamp\":" + System.currentTimeMillis() + "}\n\n";
    }

    public static void notifyWorkOrderCreated(int woId, String productName) {
        pushToAll(new Notification(TYPE_WORKORDER, "Lenh SX moi",
            "Lenh san xuat #" + woId + " (" + productName + ") vua duoc tao.",
            "MainController?action=updateWorkOrder&id=" + woId));
    }

    public static void notifyWorkOrderCompleted(int woId, String productName) {
        pushToAll(new Notification(TYPE_WORKORDER, "Lenh SX hoan thanh",
            "Lenh san xuat #" + woId + " (" + productName + ") da hoan thanh.",
            "MainController?action=listWorkOrder"));
    }

    public static void notifyPaymentReceived(int paymentId, double amount) {
        pushToAll(new Notification(TYPE_PAYMENT, "Thanh toan nhan duoc",
            "Thanh toan #" + paymentId + " - " + String.format("%,.0f", amount) + " VND da duoc xac nhan.",
            "payment-list.jsp"));
    }

    public static void notifyLowStock(String itemName, int currentStock) {
        pushToAll(new Notification(TYPE_INVENTORY, "Canh bao ton kho",
            "Vat tu '" + itemName + "' con " + currentStock + " (sac muc toi thieu).",
            "MainController?action=searchItem"));
    }

    public static void notifyDefectDetected(String woId, String defectReason) {
        pushToAll(new Notification(TYPE_DEFECT, "Phat hien loi",
            "Loi '" + defectReason + "' tren WO#" + woId + ".",
            "MainController?action=listDefectReason"));
    }
}
