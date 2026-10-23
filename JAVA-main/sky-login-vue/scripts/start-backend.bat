@echo off
chcp 936 >nul
title Sky后端启动
cd /d "%~dp0.."
set "ROOT=%CD%"
set "BACKEND=%ROOT%\springBootTest"

echo ============================================
echo  光遇登录 - 后端启动 (SpringBoot 端口 8081)
echo ============================================

REM [1] 定位 JDK（版本可能变化，按目录通配）
echo [1/5] 定位 JDK...
set "JAVA_HOME="
for /f "delims=" %%d in ('dir /b /ad "C:\Program Files\Java\jdk-*" 2^>nul') do set "JAVA_HOME=C:\Program Files\Java\%%d"
if not defined JAVA_HOME (
  where java >nul 2>nul && for /f "delims=" %%p in ('where java') do set "JAVA_HOME=%%~dp"
)
if defined JAVA_HOME (set "PATH=%JAVA_HOME%\bin;%PATH%") else (echo   警告：未找到 JDK，Maven 可能无法运行)
echo   JAVA_HOME=%JAVA_HOME%

REM [2] 启动 MySQL 服务（每次开机需拉起）
echo [2/5] 启动 MySQL 服务 (MySQL84)...
net start MySQL84 >nul 2>nul
echo   已尝试启动（若提示"服务已启动"属正常）。

REM [3] 初始化数据库（幂等，不删已有数据）
echo [3/5] 初始化数据库 sky_login...
set "MYSQL_BIN="
for /f "delims=" %%f in ('dir /s /b "C:\Program Files\MySQL\mysql.exe" 2^>nul') do (
  if not defined MYSQL_BIN set "MYSQL_BIN=%%f"
)
if defined MYSQL_BIN (
  "%MYSQL_BIN%" -uroot -p123456 < "%BACKEND%\sql\init_safe.sql" >nul 2>nul
  if errorlevel 1 (echo   警告：数据库初始化失败，请确认 MySQL 已启动且密码为 123456) else (echo   数据库已就绪（admin/123456、traveler/123456）)
) else (echo   警告：未找到 mysql.exe)

REM [4] 定位 Maven（只搜 .m2 wrapper 缓存，不依赖被删的 target）
echo [4/5] 定位 Maven...
set "MAVEN_BIN="
for /f "delims=" %%f in ('dir /s /b "%USERPROFILE%\.m2\wrapper\dists\mvn.cmd" 2^>nul') do (
  if not defined MAVEN_BIN set "MAVEN_BIN=%%f"
)
if not defined MAVEN_BIN (
  where mvn >nul 2>nul && set "MAVEN_BIN=mvn"
)
if not defined MAVEN_BIN (
  echo   未找到 Maven！请确认 .m2 wrapper 缓存存在。
  pause
  exit /b 1
)
echo   使用 Maven：%MAVEN_BIN%
for %%x in ("%MAVEN_BIN%") do set "PATH=%%~dpX;%PATH%"

REM [5] 编译并启动（clean 会重建 target，无需旧 target）
echo [5/5] 编译并启动后端（mvn clean spring-boot:run）...
echo   首次会下载依赖请耐心等待；成功后访问 http://localhost:8081
echo ============================================
cd /d "%BACKEND%"
"%MAVEN_BIN%" -B clean spring-boot:run
echo.
echo [结束] 后端已停止（若为异常退出，请查看上方报错信息）。
pause
