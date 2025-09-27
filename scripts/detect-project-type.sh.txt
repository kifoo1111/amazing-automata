#!/bin/bash

# Скрипт для автоматического определения типа проекта
echo "🔍 Анализирую проект..."

# Проверяем наличие конфигурационного файла для кастомных настроек
if [ -f ".ci-config.yml" ]; then
    echo "📁 Найден кастомный конфиг .ci-config.yml"
    echo "PROJECT_TYPE=custom" >> $GITHUB_OUTPUT
    exit 0
fi

# Проверяем стандартные файлы-индикаторы
if [ -f "package.json" ]; then
    echo "✅ Обнаружен Node.js проект"
    echo "PROJECT_TYPE=nodejs" >> $GITHUB_OUTPUT
    
elif [ -f "pom.xml" ]; then
    echo "✅ Обнаружен Java Maven проект"
    echo "PROJECT_TYPE=java_maven" >> $GITHUB_OUTPUT
    
elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    echo "✅ Обнаружен Java Gradle проект"
    echo "PROJECT_TYPE=java_gradle" >> $GITHUB_OUTPUT
    
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    echo "✅ Обнаружен Python проект"
    echo "PROJECT_TYPE=python" >> $GITHUB_OUTPUT
    
elif [ -f "go.mod" ]; then
    echo "✅ Обнаружен Go проект"
    echo "PROJECT_TYPE=go" >> $GITHUB_OUTPUT
    
elif [ -f "Cargo.toml" ]; then
    echo "✅ Обнаружен Rust проект"
    echo "PROJECT_TYPE=rust" >> $GITHUB_OUTPUT
    
elif [ -f "Dockerfile" ]; then
    echo "✅ Обнаружен Docker проект"
    echo "PROJECT_TYPE=docker" >> $GITHUB_OUTPUT
    
elif [ -f "composer.json" ]; then
    echo "✅ Обнаружен PHP проект"
    echo "PROJECT_TYPE=php" >> $GITHUB_OUTPUT
    
elif [ -f "project.json" ] || [ -f "*.csproj" ]; then
    echo "✅ Обнаружен .NET проект"
    echo "PROJECT_TYPE=dotnet" >> $GITHUB_OUTPUT
    
else
    echo "❌ Не удалось определить тип проекта автоматически"
    echo "PROJECT_TYPE=unknown" >> $GITHUB_OUTPUT
    exit 1
fi