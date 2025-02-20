Hello App

Это пример Go-приложения, которое развертывается в Google Kubernetes Engine (GKE) с использованием Terraform, Docker и CI/CD через GitHub Actions. Проект включает централизованное логирование, управление версиями, автоматическое увеличение версии Docker-образа, уведомления по email при успешной сборке и уведомления в Telegram при ошибке.

Используемые инструменты:

Terraform

Google Cloud SDK

Docker

Git

Основные функции

CI/CD: GitHub Actions автоматически собирает Docker-образ, публикует его в Docker Hub и развертывает в GKE.

Уведомления:

Email при успешной сборке.

Telegram при ошибке с логами ошибки.
![alt text](131529.png)

Централизованное логирование: Логи из GKE экспортируются в Cloud Storage.

![alt text](TLBBRi8m4BpdArRS8NzGKHwb5LLLGMyL1-CuniBE8Z-AKDL_RrXJXoJDpRCxtXdFUkeyipuOdPqOFp8fOBHI_ZdiOIDEE8Bl3E3JC5LD9EwkvmNoex2bqeBWH2f_2FlyZFPOQZoxl10dZPV9nMWYH6X4vLtkXRMiH6jockZBNVQJzOGVkLTOkPlsB2XTm8jXCWg-1tS0Zn1z.png)

Итог

Этот проект демонстрирует современный подход к CI/CD с использованием Terraform, Docker, GKE и GitHub Actions. Он включает уведомления и централизованное логирование, что делает процесс разработки и эксплуатации более удобным и безопасным.
