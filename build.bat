@echo off
echo ========================================
echo Swiss Army Knife App - Build Script
echo ========================================
echo.

echo Limpando projeto...
flutter clean

echo.
echo Instalando dependencias...
flutter pub get

echo.
echo Verificando configuração...
flutter doctor

echo.
echo ========================================
echo Escolha o tipo de build:
echo ========================================
echo 1. Web
echo 2. Android APK
echo 3. Android APK (split por arquitetura)
echo 4. Ambos (Web + Android)
echo ========================================
set /p choice="Digite sua escolha (1-4): "

if "%choice%"=="1" goto build_web
if "%choice%"=="2" goto build_android
if "%choice%"=="3" goto build_android_split
if "%choice%"=="4" goto build_both
goto invalid_choice

:build_web
echo.
echo Construindo para Web...
flutter build web
echo.
echo Build Web concluido!
echo Arquivos em: build/web/
goto end

:build_android
echo.
echo Construindo APK Android...
flutter build apk --release
echo.
echo Build Android concluido!
echo APK em: build/app/outputs/flutter-apk/app-release.apk
goto end

:build_android_split
echo.
echo Construindo APK Android (split por arquitetura)...
flutter build apk --split-per-abi --release
echo.
echo Build Android concluido!
echo APKs em: build/app/outputs/flutter-apk/
goto end

:build_both
echo.
echo Construindo para Web...
flutter build web
echo.
echo Construindo APK Android...
flutter build apk --release
echo.
echo Builds concluidos!
echo Web: build/web/
echo Android: build/app/outputs/flutter-apk/app-release.apk
goto end

:invalid_choice
echo.
echo Escolha invalida! Execute o script novamente.
goto end

:end
echo.
echo ========================================
echo Build concluido!
echo ========================================
pause
