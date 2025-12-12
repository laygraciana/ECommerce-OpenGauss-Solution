# 使用 ASP.NET Core 运行时
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER 
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# 使用 SDK 构建
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# 复制项目文件（这是关键步骤）
COPY ["src/ECommerce.WebUI/ECommerce.WebUI.csproj", "ECommerce.WebUI/"]
COPY ["src/ECommerce.BLL/ECommerce.BLL.csproj", "ECommerce.BLL/"]
COPY ["src/ECommerce.DAL/ECommerce.DAL.csproj", "ECommerce.DAL/"]

# 恢复包
RUN dotnet restore "ECommerce.WebUI/ECommerce.WebUI.csproj"

# 复制所有源代码
COPY src/ .

# 构建
WORKDIR "/src/ECommerce.WebUI"
RUN dotnet build "ECommerce.WebUI.csproj" -c  -o /app/build

# 发布
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "ECommerce.WebUI.csproj" -c  -o /app/publish /p:UseAppHost=false

# 最终镜像
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ECommerce.WebUI.dll"]
