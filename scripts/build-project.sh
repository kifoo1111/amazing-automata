#!/bin/bash

PROJECT_TYPE=$1

echo "🏗️ Запускаем сборку для типа: $PROJECT_TYPE"

case $PROJECT_TYPE in
    "nodejs")
        echo "Устанавливаем Node.js зависимости..."
        npm ci
        if [ -f "package.json" ] && grep -q "\"build\"" package.json; then
            echo "Запускаем сборку..."
            npm run build
        else
            echo "Скрипт build не найден в package.json, пропускаем сборку"
        fi
        ;;
        
    "java_maven")
        echo "Собираем Java Maven проект..."
        mvn clean compile -q
        ;;
        
    "java_gradle")
        echo "Собираем Java Gradle проект..."
        chmod +x gradlew
        ./gradlew clean build -x test
        ;;
        
    "python")
        echo "Устанавливаем Python зависимости..."
        pip install -r requirements.txt
        ;;
        
    "go")
        echo "Собираем Go приложение..."
        go build -o app .
        ;;
        
    "rust")
        echo "Собираем Rust проект..."
        cargo build --release
        ;;
        
    "docker")
        echo "Собираем Docker образ..."
        docker build -t my-app .
        ;;
        
    "php")
        echo "Устанавливаем PHP зависимости..."
        composer install --no-dev
        ;;
        
    "dotnet")
        echo "Собираем .NET проект..."
        dotnet build
        ;;
        
    "custom")
        echo "Используем кастомные настройки..."
        if [ -f ".ci-config.yml" ]; then
            BUILD_CMD=$(grep 'build_command:' .ci-config.yml | cut -d: -f2- | sed 's/^[ \t]*//')
            if [ ! -z "$BUILD_CMD" ]; then
                echo "Выполняем кастомную команду: $BUILD_CMD"
                eval $BUILD_CMD
            else
                echo "❌ Команда сборки не найдена в .ci-config.yml"
            fi
        else
            echo "❌ Файл .ci-config.yml не найден"
        fi
        ;;
        
    *)
        echo "❌ Неизвестный тип проекта: $PROJECT_TYPE"
        exit 1
        ;;
esac

echo "✅ Сборка завершена успешно!"