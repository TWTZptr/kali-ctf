@echo off

docker exec -ti ctf "/bin/zsh" 2>nul

if not %ERRORLEVEL% == 0 (
    docker start ctf >nul 2>&1
    docker attach ctf
)
