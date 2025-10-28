package com.K1ll4a.controller;

import com.K1ll4a.model.HitListBean;
import com.K1ll4a.model.HitResult;
import com.K1ll4a.model.Point;
import com.K1ll4a.sevice.AreaCheckService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/area-check")
public class AreaCheck extends HttpServlet {

    private final AreaCheckService checker = new AreaCheckService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {


        Double x = (Double) req.getAttribute("x");
        Double y = (Double) req.getAttribute("y");
        Double r = (Double) req.getAttribute("r");

        if (x == null || y == null || r == null) {
            try {
                x = Double.valueOf(req.getParameter("x"));
                y = Double.valueOf(req.getParameter("y"));
                r = Double.valueOf(req.getParameter("r"));
            } catch (Exception e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректные параметры");
                return;
            }
        }

        boolean hit = checker.isHit(x, y, r);

        Point point = new Point(x, y, r);
        HitResult result = new HitResult(point, hit, LocalDateTime.now());


        HttpSession session = req.getSession();
        HitListBean bean = (HitListBean) session.getAttribute("hits");
        if (bean == null) {
            bean = new HitListBean();
            session.setAttribute("hits", bean);
        }
        bean.add(result);


        req.setAttribute("result", result);
        req.getRequestDispatcher("/result.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendRedirect(req.getContextPath() + "/");
    }
}
