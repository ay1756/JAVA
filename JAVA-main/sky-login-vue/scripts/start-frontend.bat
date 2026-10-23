@echo off
chcp 936 >nul
title Sky前端启动
cd /d "%~dp0.."
set "ROOT=%CD%"
set "FRONTEND=%ROOT%\sky-login-vue"

echo ============================================
echo  光遇登录 - 前端启动 (Vue3 + Vite 端口 5173)
echo ============================================

REM [1] 定位 npm（只搜 WorkBuddy 托管目录，不依赖被删的 node_modules）
echo [1/3] 定位 npm...
set "NPM="
for /f "delims=" %%f in ('dir /s /b "%USERPROFILE%\.workbuddy\binaries\node\versions\npm.cmd" 2^>nul') do (
  if not defined NPM set "NPM=%%f"
)
if not defined NPM (
  where npm >nul 2>nul && set "NPM=npm"
)
if not defined NPM (
  echo   未找到 npm！请确认 WorkBuddy 托管 Node 存在或已安装 Node.js。
  pause
  exit /b 1
)
echo   使用 npm：%NPM%
for %%x in ("%NPM%") do set "PATH=%%~dpX;%PATH%"

REM [2] 安装依赖（node_modules 每次开机被删，必须重装）
echo [2/3] 安装依赖 npm install（首次较慢，请等待）...
cd /d "%FRONTEND%"
call "%NPM%" install --no-audit --no-fund
if errorlevel 1 (
  echo   依赖安装失败，请检查网络或 npm 源。
  pause
  exit /b 1
)

REM [3] 启动 dev 服务器
echo [3/3] 启动前端 dev 服务器...
echo   成功后可访问 http://localhost:5173/
echo ============================================
call "%NPM%" run dev
echo.
echo [结束] 前端已停止。
pause
