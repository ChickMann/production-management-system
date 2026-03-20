package pms.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pms.model.UserDTO;

public class AuthenticationFilter implements Filter {

    private FilterConfig filterConfig;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        String path = requestURI.substring(contextPath.length());

        HttpSession session = httpRequest.getSession(false);
        UserDTO user = null;
        if (session != null) {
            user = (UserDTO) session.getAttribute("user");
        }

        boolean isPublicResource = isPublicPath(path);
        boolean isLoginAction = requestURI.contains("MainController")
                && "loginUser".equals(httpRequest.getParameter("action"));

        if (user == null && !isPublicResource && !isLoginAction) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        if (user != null && !user.isActive()) {
            if (session != null) {
                session.invalidate();
            }
            httpResponse.sendRedirect(contextPath + "/Banned.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("/") ||
               path.equals("/login.jsp") ||
               path.equals("/login") ||
               path.equals("/Banned.jsp") ||
               path.equals("/index.jsp") ||
               path.startsWith("/css/") ||
               path.startsWith("/js/") ||
               path.startsWith("/img/") ||
               path.startsWith("/ui/") ||
               path.contains("/AutoCompleteSearch") ||
               path.contains("/NotificationServlet") ||
               path.contains(".css") ||
               path.contains(".js") ||
               path.contains(".png") ||
               path.contains(".jpg") ||
               path.contains(".jpeg") ||
               path.contains(".gif") ||
               path.contains(".svg") ||
               path.contains(".ico") ||
               path.contains(".woff") ||
               path.contains(".woff2") ||
               path.contains(".ttf") ||
               path.contains(".eot");
    }

    @Override
    public void destroy() {
        this.filterConfig = null;
    }
}
