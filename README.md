# Swiss Army Knife App - Versão 2.0

Um aplicativo Flutter moderno e multifuncional que reúne diversas ferramentas úteis em um só lugar.

## 🚀 Funcionalidades

- **Conversor de Unidades**: Comprimento, peso, volume, temperatura, área, velocidade
- **Conversor de Medidas**: Sistemas métrico vs imperial
- **Ferramentas de Texto**: Contagem, conversão de maiúsculas/minúsculas, análise
- **Calculadora**: Básica e científica com funções trigonométricas
- **Gerador de Senhas**: Configurável com diferentes tipos de caracteres
- **Conversor de Moedas**: Taxas atualizadas via API (40+ moedas)
- **Ferramentas de Data e Hora**: Cronômetro, cálculo de idade, diferença entre datas

## 🎨 Novidades da Versão 2.0

### Design Completamente Renovado
- Interface moderna com Material Design 3
- Paleta de cores harmoniosa e profissional
- Cards com sombras suaves e bordas arredondadas
- Gradientes elegantes e efeitos visuais aprimorados
- Ícones modernos e consistentes

### Performance Otimizada
- Animações com controladores únicos para melhor performance
- Gerenciamento eficiente de estado
- Redução significativa de rebuilds desnecessários
- Carregamento mais rápido das telas

### Navegação Corrigida
- Correção do problema de tela branca ao voltar das funções
- Transições suaves entre telas
- Navegação consistente e intuitiva
- Suporte completo a hot reload/restart

### Responsividade Aprimorada
- Layout adaptativo para todos os tamanhos de tela
- Widgets que previnem overflow de pixels
- Breakpoints inteligentes para mobile, tablet e desktop
- Suporte otimizado para orientação retrato e paisagem

## 🛠️ Tecnologias

- **Flutter**: Framework multiplataforma
- **Material Design 3**: Interface moderna e responsiva
- **HTTP**: Para conversão de moedas
- **Intl**: Para formatação de números e datas
- **Math Expressions**: Para cálculos matemáticos
- **Widgets Personalizados**: Componentes modernos e reutilizáveis

## 📱 Plataformas Suportadas

- Web
- Android
- iOS
- Windows
- macOS
- Linux

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.0.0 ou superior
- Dart SDK

### Instalação
1. Clone o repositório
2. Navegue até a pasta do projeto
3. Execute:
```bash
flutter pub get
```

### Execução
```bash
# Para Web (recomendado para teste rápido)
flutter run -d chrome

# Para Android
flutter run -d android

# Para ver dispositivos disponíveis
flutter devices
```

### Build para Produção
```bash
# Web
flutter build web

# Android
flutter build apk --release
```

## 📋 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── screens/                  # Telas da aplicação
│   ├── splash_screen.dart   # Tela de carregamento
│   ├── home_screen.dart     # Tela inicial modernizada
│   ├── calculator_screen.dart
│   ├── currency_converter_screen.dart
│   ├── date_time_tools_screen.dart
│   ├── measure_converter_screen.dart
│   ├── password_generator_screen.dart
│   ├── text_tools_screen.dart
│   └── unit_converter_screen.dart
└── widgets/                  # Widgets reutilizáveis
    ├── modern_app_bar.dart  # AppBar moderno
    ├── modern_card.dart     # Cards elegantes
    ├── modern_button.dart   # Botões com animações
    ├── modern_input.dart    # Campos de entrada modernos
    ├── responsive_layout.dart # Layout responsivo
    ├── smart_grid.dart      # Grid inteligente
    ├── custom_card.dart     # Cards personalizados
    ├── custom_button.dart   # Botões customizados
    └── overflow_safe_widget.dart # Prevenção de overflow
```

## 🎨 Características da Interface

- **Design Responsivo**: Adapta-se perfeitamente a diferentes tamanhos de tela
- **Tema Moderno**: Interface elegante com gradientes e sombras
- **Navegação Intuitiva**: Menu lateral redesenhado e grid de acesso rápido
- **Feedback Visual**: Animações suaves e transições elegantes
- **Acessibilidade**: Suporte aprimorado a leitores de tela
- **Prevenção de Overflow**: Widgets inteligentes que evitam problemas de layout

## 🔧 Configuração

### Dependências Principais
- `flutter`: SDK do Flutter
- `cupertino_icons`: Ícones do iOS
- `http`: Requisições HTTP
- `intl`: Internacionalização
- `math_expressions`: Expressões matemáticas

### Assets
- Imagens em `assets/images/`

## 📖 Como Usar

1. **Tela Inicial**: Acesse todas as ferramentas através do grid modernizado ou menu lateral
2. **Navegação**: Use o menu lateral (ícone de menu) para navegação rápida
3. **Cópia**: Muitas ferramentas têm botão de copiar para área de transferência
4. **Tempo Real**: Resultados aparecem automaticamente conforme você digita
5. **Responsivo**: Funciona perfeitamente em desktop, tablet e mobile
6. **Animações**: Aproveite as transições suaves entre telas

## 🐛 Solução de Problemas

### Erro: "No devices found"
```bash
flutter doctor
flutter devices
```

### Erro de dependências:
```bash
flutter clean
flutter pub get
```

### API de moedas não funciona:
- Verifique conexão com internet
- A API pode ter limites de requisições
- Use o botão de atualização

### Tela branca após F5:
- Problema corrigido na versão 2.0
- Use hot reload (Ctrl+S) para atualizações rápidas

## 📄 Licença

Este projeto é de código aberto e está disponível sob a licença MIT.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir novas funcionalidades
- Enviar pull requests
- Melhorar a documentação

## 🎯 Próximas Funcionalidades

- [ ] Modo escuro/claro personalizado
- [ ] Sincronização na nuvem
- [ ] Mais ferramentas de conversão
- [ ] Histórico de conversões
- [ ] Favoritos e atalhos
- [ ] Temas personalizáveis

---

**Versão**: 2.0.0  
**Flutter**: 3.0.0+  
**Status**: Modernizado e otimizado  
**Última atualização**: Janeiro 2025
