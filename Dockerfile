FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy file build trước (tối ưu cache)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN chmod +x mvnw
RUN sed -i 's/\r$//' mvnw

# Load dependency trước
RUN ./mvnw dependency:go-offline

# 🔥 QUAN TRỌNG: copy source code
COPY src src

# Build project
RUN ./mvnw clean package -DskipTests

# Debug (có thể xóa sau)
RUN ls target

EXPOSE 8080

# 🔥 Không hardcode jar
CMD ["sh", "-c", "java -jar target/*.jar --server.port=$PORT"]