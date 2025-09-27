#!/bin/bash

PROJECT_TYPE=$1

echo "🚀 Деплоим проект типа: $PROJECT_TYPE"

case $PROJECT_TYPE in
    "nodejs")
        if [ -d "dist" ] || [ -d "build" ]; then
            echo "📁 Обнаружена статическая сборка"
            echo "Здесь может быть загрузка на хостинг:"
            echo "- Netlify, Vercel (для фронтенда)"
            echo "- AWS S3, GitHub Pages"
        else
            echo "📦 Создаем архив для деплоя"
            tar -czf nodejs-app-$(date +%Y%m%d).tar.gz .
        fi
        ;;
        
    "java_maven")
        echo "📦 Создаем JAR файл..."
        mvn package -DskipTests
        ;;
        
    "docker")
        echo "🐳 Пушим Docker образ..."
        # Для GitHub Container Registry
        echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u ${{ github.actor }} --password-stdin
        docker tag my-app ghcr.io/${{ github.repository }}:latest
        docker push ghcr.io/${{ github.repository }}:latest
        ;;
        
    "custom")
        if [ -f ".ci-config.yml" ]; then
            DEPLOY_CMD=$(grep 'deploy_command:' .ci-config.yml | cut -d: -f2- | sed 's/^[ \t]*//')
            if [ ! -z "$DEPLOY_CMD" ]; then
                echo "Выполняем кастомный деплой: $DEPLOY_CMD"
                eval $DEPLOY_CMD
            else
                echo "⚠️ Команда деплоя не найдена"
            fi
        fi
        ;;
        
    *)
        echo "📦 Создаем универсальный архив..."
        tar -czf ${PROJECT_TYPE}-app-$(date +%Y%m%d).tar.gz .
        echo "✅ Артефакт готов для ручного деплоя"
        ;;
esac

echo "✅ Деплой завершен!"