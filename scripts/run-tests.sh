#!/bin/bash

PROJECT_TYPE=$1

echo "🧪 Запускаем тесты для типа: $PROJECT_TYPE"

case $PROJECT_TYPE in
    "nodejs")
        if [ -f "package.json" ] && grep -q "\"test\"" package.json; then
            echo "Запускаем Node.js тесты..."
            npm test
        else
            echo "⚠️ Тесты не настроены в package.json, пропускаем"
        fi
        ;;
        
    "java_maven")
        echo "Запускаем Maven тесты..."
        mvn test
        ;;
        
    "java_gradle")
        echo "Запускаем Gradle тесты..."
        chmod +x gradlew
        ./gradlew test
        ;;
        
    "python")
        if command -v pytest &> /dev/null; then
            echo "Запускаем pytest..."
            pytest
        elif [ -f "setup.py" ]; then
            echo "Запускаем тесты через setup.py..."
            python setup.py test
        else
            echo "⚠️ Тесты не настроены, пропускаем"
        fi
        ;;
        
    "go")
        echo "Запускаем Go тесты..."
        go test ./...
        ;;
        
    "rust")
        echo "Запускаем Rust тесты..."
        cargo test
        ;;
        
    "custom")
        if [ -f ".ci-config.yml" ]; then
            TEST_CMD=$(grep 'test_command:' .ci-config.yml | cut -d: -f2- | sed 's/^[ \t]*//')
            if [ ! -z "$TEST_CMD" ]; then
                echo "Выполняем кастомные тесты: $TEST_CMD"
                eval $TEST_CMD
            else
                echo "⚠️ Команда тестирования не найдена"
            fi
        fi
        ;;
        
    *)
        echo "⚠️ Тесты не настроены для типа: $PROJECT_TYPE"
        ;;
esac

echo "✅ Тестирование завершено!"