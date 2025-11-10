<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Результат проверки</title>
    <style>
        body { font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, "Helvetica Neue", Arial; background:#0f1622; color:#e4ecfb; }
        .wrap { max-width: 840px; margin: 36px auto; padding: 24px; background:#0c1220; border-radius:16px; }
        .row { margin: 14px 0; }
        .btn { padding:10px 16px; border-radius:12px; background:#2f6fec; color:#fff; border:0; text-decoration:none; display:inline-block; }
        .ok { color:#39c16c; }
    </style>
</head>
<body>
<div class="wrap">
    <h2>Результат проверки</h2>

    <div class="row">X: ${result.point.x}</div>
    <div class="row">Y: ${result.point.y}</div>
    <div class="row">R: ${result.point.r}</div>
    <div class="row">Попадание: <span class="${result.hit ? 'ok' : ''}">${result.hit ? 'попадание' : 'мимо'}</span></div>
    <div class="row">Дата: ${result.dateStr}</div>
    <div class="row">Время: ${result.timeStr}</div>

    <div class="row">
        <a class="btn" href="${pageContext.request.contextPath}/controller">Назад к форме</a>
    </div>
</div>
</body>
</html>
