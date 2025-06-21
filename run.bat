@echo off

set PYTHON_VERSION=3.10.11
set PYTHON_INSTALLER=python-%PYTHON_VERSION%-amd64.exe
set PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/%PYTHON_INSTALLER%
set CURL_ZIP=curl.zip
set CURL_URL=https://curl.se/windows/dl-8.7.1_2/curl-8.7.1_2-win64-mingw.zip
set PYTHON_SCRIPT=imagen.py

where curl >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ curl not found. Attempting to install curl...
    powershell -Command "Invoke-WebRequest -Uri '%CURL_URL%' -OutFile '%CURL_ZIP%'"
    powershell -Command "Expand-Archive -Path '%CURL_ZIP%' -DestinationPath '.'"
    del %CURL_ZIP%
    set "CURL_PATH="
    for /d %%D in (curl-*) do set "CURL_PATH=%%D\bin"
    if exist "%CURL_PATH%\curl.exe" (
        set "PATH=%CD%\%CURL_PATH%;%PATH%"
        echo ✅ curl installed successfully.
    ) else (
        echo ❌ Failed to install curl.
        pause
        exit /b 1
    )
) else (
    echo ✅ curl is already installed.
)

python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Python not found. Downloading and installing Python %PYTHON_VERSION%...
    curl -o %PYTHON_INSTALLER% %PYTHON_URL%
    start /wait %PYTHON_INSTALLER% /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    del %PYTHON_INSTALLER%
)

echo === Setting up virtual environment ===

:: Check if virtualenv is installed
pip show virtualenv >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Installing virtualenv...
    pip install virtualenv
)

:: Create virtual environment if it doesn't exist
IF NOT EXIST venv (
    virtualenv venv
)

:: Activate the virtual environment
call venv\Scripts\activate.bat

:: Install requirements
echo Installing required packages...
pip install -r requirements.txt

:: Run your Python script
echo Running the app...
python imagen.py

pause