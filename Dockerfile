### ---------- СТАДИЯ 1: билдим WAR через Maven (наш javax проект) ----------
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# сначала pom.xml (лучше кешируется)
COPY pom.xml .
# потом исходники
COPY src ./src

# собираем war (без тестов чтобы быстрее)
RUN mvn clean package -DskipTests


### ---------- СТАДИЯ 2: собственный WildFly (26.1.3.Final, совместим с javax) ----------
# Берём просто базовый JDK образ (без WildFly)
FROM eclipse-temurin:17-jdk

# Поставим unzip, чтобы распаковать архив WildFly
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Копируем заранее скачанный архив WildFly (ДОЛЖЕН лежать рядом с Dockerfile)
# Имя файла должно 100% совпадать с тем, что ты скачал!
COPY wildfly-26.1.3.Final.zip /opt/

WORKDIR /opt

# Распаковываем WildFly и переименовываем папку в /opt/wildfly
RUN unzip wildfly-26.1.3.Final.zip && \
    mv wildfly-26.1.3.Final wildfly && \
    rm wildfly-26.1.3.Final.zip

# Копируем наш собранный WAR в папку деплоя WildFly
COPY --from=builder /app/target/Web2L.war /opt/wildfly/standalone/deployments/

# Открываем HTTP-порт WildFly наружу
EXPOSE 8080

# Запускаем WildFly, биндимся на 0.0.0.0 чтобы docker -p 8080:8080 работал
CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
