@echo off
chcp 936 >nul
title 光遇登录 - 停止服务
echo 正在停止光遇登录项目...
echo [1] 关闭启动窗口...
taskkill /fi "WINDOWTITLE eq Sky后端*" /f >nul 2>nul
taskkill /fi "WINDOWTITLE eq Sky前端*" /f >nul 2>nul
echo [2] 按端口清理残留进程（8081 / 5173）...
for /f "tokens=5" %%p in ('netstat -ano 2^>nul ^| findstr /c:":8081"') do taskkill /pid %%p /f >nul 2>nul
for /f "tokens=5" %%p in ('netstat -ano 2^>nul ^| findstr /c:":5173"') do taskkill /pid %%p /f >nul 2>nul
echo 已完成。如需重启，运行 start-all.bat。
pause
