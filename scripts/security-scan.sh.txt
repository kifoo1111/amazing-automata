#!/bin/bash

PROJECT_TYPE=$1

echo "🔒 Сканируем безопасность для: $PROJECT_TYPE"

case $PROJECT_TYPE in
    "nodejs")
        if [ -f "package.json" ]; then
            echo "Проверяем Node.js зависимости..."
            npm audit --audit-level moderate || true
        fi
        ;;
        
    "python")
        if command -v safety &> /dev/null; then
            echo "Проверяем Python зависимости..."
            safety check || true
        else
            echo "⚠️ Установите 'safety' для проверки зависимостей: pip install safety"
        fi
        ;;
        
    "java_maven"|"java_gradle")
        echo "ℹ️ Рекомендуется настроить OWASP Dependency Check для Java"
        echo "Добавьте в pom.xml или build.gradle плагин для проверки зависимостей"
        ;;
        
    "docker")
        echo "Сканируем Docker образ..."
        if command -v docker scan &> /dev/null; then
            docker scan --file Dockerfile . || true
        else
            echo "⚠️ Установите Docker Scan для проверки образов"
        fi
        ;;
        
    *)
        echo "ℹ️ Базовое сканирование не настроено для $PROJECT_TYPE"
        ;;
esac

echo "✅ Проверка безопасности завершена!"