<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8"/>
    <title>Проверка попадания точки</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{--bg:#0b1020;--card:#151b2d;--fg:#e8ecf3;--muted:#9aa4b2;--accent:#4ea1ff}
        *{box-sizing:border-box}
        body{margin:0;background:var(--bg);color:var(--fg);font:15px/1.45 system-ui,-apple-system,Segoe UI,Roboto}
        .wrap{max-width:1100px;margin:24px auto;padding:0 16px}
        .card{background:var(--card);border:1px solid #1f2740;border-radius:16px;box-shadow:0 4px 24px rgba(0,0,0,.35);padding:20px}
        h1{margin:0 0 6px;font-size:22px}
        .sub{color:var(--muted);margin:0 0 18px}
        .grid{display:grid;grid-template-columns:420px 1fr;gap:18px}
        .row{margin-bottom:12px}
        .row label{display:block;margin-bottom:6px;color:var(--muted)}
        .btns{display:flex;flex-wrap:wrap;gap:8px}
        .btn{padding:8px 10px;border:1px solid #2a3559;border-radius:10px;background:#0f1731;color:var(--fg);cursor:pointer}
        .btn.active{outline:2px solid var(--accent)}
        .btn-secondary{background:#0f1731;border:1px solid #2a3559}
        input[type=text],select{width:100%;padding:10px;border-radius:10px;border:1px solid #2a3559;background:#0f1731;color:var(--fg)}
        .actions{display:flex;gap:10px;margin-top:14px}
        button[type=submit]{padding:10px 14px;border-radius:12px;border:1px solid #2a3559;background:var(--accent);color:#041021;cursor:pointer;font-weight:600}
        .hint{color:var(--muted);font-size:13px}
        table{width:100%;border-collapse:collapse;margin-top:10px}
        th,td{padding:10px;border-bottom:1px solid #2a3559;text-align:left}
        .img-wrap{position:relative;display:inline-block;border:1px solid #2a3559;border-radius:12px;overflow:hidden;background:#0e1530}
        .img-wrap img{display:block;max-width:100%;height:auto}
        .img-wrap canvas{position:absolute;left:0;top:0;pointer-events:auto}
        .ok{color:#6ee7a8}.bad{color:#ff8080}
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <h1>Определение попадания точки в область</h1>
        <p class="sub">Данилевский Тимур Давидович P3208</p>

        <div class="grid">
            <!-- Левая колонка: форма -->
            <div>
                <form id="form" method="POST" action="${pageContext.request.contextPath}/controller" accept-charset="UTF-8" novalidate>
                    <!-- X -->
                    <div class="row">
                        <label>Изменение X: {−5 … 3}</label>
                        <div id="xButtons" class="btns" role="group" aria-label="Выбор X">
                            <button class="btn" type="button" data-x="-5">-5</button>
                            <button class="btn" type="button" data-x="-4">-4</button>
                            <button class="btn" type="button" data-x="-3">-3</button>
                            <button class="btn" type="button" data-x="-2">-2</button>
                            <button class="btn" type="button" data-x="-1">-1</button>
                            <button class="btn" type="button" data-x="0">0</button>
                            <button class="btn" type="button" data-x="1">1</button>
                            <button class="btn" type="button" data-x="2">2</button>
                            <button class="btn" type="button" data-x="3">3</button>
                        </div>
                        <input type="hidden" name="x" id="xField"/>
                        <div class="hint">Выберите одно значение X.</div>
                    </div>

                    <!-- Y -->
                    <div class="row">
                        <label for="yField">Изменение Y: текст (−5 … 5)</label>
                        <input id="yField" name="y" type="text" inputmode="decimal" placeholder="например, 1.5"/>
                    </div>

                    <!-- R -->
                    <div class="row">
                        <label for="rField">Изменение R: {1, 2, 3, 4, 5}</label>
                        <select id="rField" name="r">
                            <option value="" selected disabled>Выберите радиус R</option>
                            <option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>
                        </select>
                    </div>

                    <div class="actions">
                        <button type="submit">Проверить (POST)</button>
                        <span id="error" class="hint" style="color:#ff8585"></span>
                    </div>
                </form>

                <!-- История + Очистить -->
                <div class="row">
                    <h3 style="margin:18px 0 8px">История проверок</h3>

                    <form method="POST" action="${pageContext.request.contextPath}/history/clear" style="margin:8px 0 12px">
                        <button type="submit" class="btn btn-secondary">Очистить историю</button>
                    </form>

                    <c:choose>
                        <c:when test="${not empty sessionScope.hits and not empty sessionScope.hits.history}">
                            <table aria-label="История попаданий">
                                <thead>
                                <tr>
                                    <th>Дата</th>
                                    <th>Время</th>
                                    <th>X</th>
                                    <th>Y</th>
                                    <th>R</th>
                                    <th>Результат</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="h" items="${sessionScope.hits.history}">
                                    <tr>
                                        <td>${h.dateStr}</td>
                                        <td>${h.timeStr}</td>
                                        <td>${h.point.x}</td>
                                        <td>${h.point.y}</td>
                                        <td>${h.point.r}</td>
                                        <td>
                                            <c:if test="${h.hit}"><span class="ok">попадание</span></c:if>
                                            <c:if test="${!h.hit}"><span class="bad">мимо</span></c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise><div class="hint">История пуста.</div></c:otherwise>
                    </c:choose>
                </div>
            </div>


            <div>
                <div class="row"><label>График области</label></div>
                <div class="img-wrap" id="imgWrap">
                    <img id="graph" src="${pageContext.request.contextPath}/static/images/graph.png" alt="График области"/>
                    <canvas id="overlay"></canvas>
                </div>
                <div class="hint" style="margin-top:6px">
                    Выберите R и кликните по изображению — X,Y.
                </div>
            </div>
        </div>
    </div>
</div>


<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>
