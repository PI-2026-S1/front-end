# DeepFake Detector - Front-end (Flutter)

[![Flutter Version](https://img.shields.io/badge/Flutter-v3.x-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Institution: IMT](https://img.shields.io/badge/Mau%C3%A1-Instituto%20de%20Tecnologia-blue)](https://maua.br)

Aplicação multiplataforma desenvolvida em **Flutter** para o projeto de graduação focado na detecção de mídias sintéticas (Deepfakes). A interface comunica-se com um back-end em Python para realizar inferências de Deep Learning em tempo real.

## Sobre o Projeto

O avanço das IAs Generativas tornou a criação de mídias sintéticas extremamente realista. Este projeto visa fornecer uma ferramenta acessível para que usuários possam verificar a autenticidade de conteúdos visuais, mitigando riscos de desinformação e fraudes financeiras.

## Funcionalidades

- **Upload Simples:** Seleção de imagens e vídeos diretamente da galeria.
- **Análise Inteligente:** Integração com modelos baseados em **XceptionNet** e **Vision Transformers**.
- **Resultado Instantâneo:** Indicação clara de "Real" ou "Sintético" com score de confiança.
- **Histórico Local:** (Em desenvolvimento) Registro de análises anteriores.

## Tecnologias e Arquitetura

- **Linguagem:** Dart
- **Framework:** Flutter (Android/iOS/Web)
- **Comunicação:** HTTP / [Dio](https://pub.dev/packages/dio)
- **Integração:** REST API (Flask)
- **Arquitetura:** Pattern MVC ou Clean Architecture (conforme o progresso do grupo).

## Como Instalar e Executar

1. **Pré-requisitos:**
   - Possuir o Flutter SDK configurado ([Instruções](https://docs.flutter.dev/get-started/install)).
   - Estar com o serviço de Back-end em execução.

2. **Clonar o Repositório:**
   ```bash
   git clone [https://github.com/SEU_USUARIO/deepfakedetectorfront.git](https://github.com/SEU_USUARIO/deepfakedetectorfront.git)
   cd front-end
   ```
