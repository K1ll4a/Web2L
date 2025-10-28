<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8"/>
    <title>Результат проверки</title>
    <style>
        body{font:15px/1.45 system-ui,-apple-system,Segoe UI,Roboto;margin:0;background:#0b1020;color:#e8ecf3}
        .wrap{max-width:800px;margin:36px auto;padding:0 16px}
        .card{background:#151b2d;border:1px solid #1f2740;border-radius:16px;box-shadow:0 4px 24px rgba(0,0,0,.35);padding:20px}
        table{width:100%;border-collapse:collapse;margin-top:6px}
        th,td{padding:10px;border-bottom:1px solid #2a3559;text-align:left}
        a.btn{display:inline-block;margin-top:12px;padding:10px 14px;border-radius:12px;border:1px solid #2a3559;background:#4ea1ff;color:#041021;text-decoration:none;font-weight:600}
        .ok{color:#6ee7a8}.bad{color:#ff8080}
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <h2>Результат проверки</h2>

        <c:choose>
            <c:when test="${not empty result}">
                <table>
                    <tr><th>X</th><td>${result.point.x}</td></tr>
                    <tr><th>Y</th><td>${result.point.y}</td></tr>
                    <tr><th>R</th><td>${result.point.r}</td></tr>
                    <tr>
                        <th>Попадание</th>
                        <td>
                            <c:if test="${result.hit}"><span class="ok">попадание</span></c:if>
                            <c:if test="${!result.hit}"><span class="bad">мимо</span></c:if>
                        </td>
                    </tr>
                    <tr><th>Время</th><td>${result.timestamp}</td></tr>
                </table>
            </c:when>
            <c:otherwise>Данные отсутствуют.</c:otherwise>
        </c:choose>

        <a class="btn" href="${pageContext.request.contextPath}/">Назад к форме</a>
    </div>
</div>
</body>
</html>
