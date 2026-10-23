@echo off
chcp 936 >nul
title 光遇登录 - 一键启动
cd /d "%~dp0"
echo ============================================
echo   光遇登录 一键启动（后端 8081 + 前端 5173）
echo ============================================
echo.
echo [1] 正在打开 后端 窗口（标题：Sky后端）...
start "Sky后端" cmd /K "%~dp0start-backend.bat"
echo [2] 正在打开 前端 窗口（标题：Sky前端）...
timeout /t 3 /nobreak >nul
start "Sky前端" cmd /K "%~dp0start-frontend.bat"
echo.
echo 已分别打开两个窗口：Sky后端、Sky前端
echo   后端：http://localhost:8081
echo   前端：http://localhost:5173
echo.
echo 若某窗口报错，请把窗口里的红字发我；关闭窗口或运行 stop-all.bat 可停止。
echo 本窗口将保持打开，按任意键关闭。
echo.
pause
