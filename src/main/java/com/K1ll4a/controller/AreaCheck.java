package com.K1ll4a.controller;

import com.K1ll4a.model.HitListBean;
import com.K1ll4a.model.HitResult;
import com.K1ll4a.model.Point;
import com.K1ll4a.sevice.AreaCheckService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(urlPatterns = {"/area-check"})
public class AreaCheck extends HttpServlet {
    private final AreaCheckService checker = new AreaCheckService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Берём double из атрибутов, которые положил ContollerServlet
        double x = (Double) req.getAttribute("x");
        double y = (Double) req.getAttribute("y");
        double r = (Double) req.getAttribute("r");

        boolean hit = checker.isHit(x, y, r);                   // <-- правильный метод
        Point  pt  = new Point(x, y, r);
        HitResult result = new HitResult(pt, hit, LocalDateTime.now()); // <-- правильный конструктор

        // Кладём в историю в сессии (бин "hits")
        HttpSession session = req.getSession();
        HitListBean bean = (HitListBean) session.getAttribute("hits");
        if (bean == null) {
            bean = new HitListBean();
            session.setAttribute("hits", bean);
        }
        bean.add(result);

        // Для result.jsp
        req.setAttribute("result", result);
        req.getRequestDispatcher("/result.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/controller");
    }
}
