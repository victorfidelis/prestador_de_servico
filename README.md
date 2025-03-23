# Prestador de Serviço (em desenvolvimento)

Aplicativo completo para gestão de agendamentos de serviços rápidos voltado para profissionais autônomos e seus clientes.

**Atenção**: Este projeto está em processo de desenvolvimento e ainda não está finalizado. Até o momento só foi executado em ambiente Android. Novas funcionalidades estão sendo implementadas e ajustes estão sendo feitos continuamente.

## 📱 Sobre o Projeto

O **Prestador de Serviço** consiste em dois aplicativos integrados:

1. **App do Cliente**:  
   Para clientes finais do prestador que desejam contratar seus serviços de forma rápida e prática. O cliente pode:
   - Realizar cadastro e login.
   - Visualizar disponibilidade do prestador.
   - Agendar serviços.
   - Acompanhar e gerenciar seus agendamentos.

2. **App do Prestador**:  
   Para o profissional autônomo que irá prestar serviços. O prestador pode:
   - Cadastrar serviços e suas categorias.
   - Definir dias e horários disponíveis.
   - Configurar formas de pagamento.
   - Gerenciar agendamentos recebidos (aprovar, cancelar ou sugerir alterações).
   - Verificar agenda de serviços.
   - Controlar pagamentos pendentes.
   - Criar e alterar agendamentos.
   - Gerar relatórios de faturamento.

---

## 🛠️ Tecnologias, Ferramentas e Técnicas

- **Flutter** & **Dart**
- **Firebase**:
  - **Firebase Authentication**
  - **Firebase Firestore**
  - **Firebase Storage**
- **SQLite (sqflite)**
- **Provider** + **ChangeNotifier** para gerenciamento de estado.
- Functional Programming
  - **Either**
  - **State Pattern**
- Padrões de Projeto:
  - **Repository Pattern**
  - Princípios **SOLID** aplicados (**Single Responsibility**, **Open-Closed**, **Dependency Inversion**).
- Testes:
  - **Flutter test**
  - **Mockito**

---

## 🧪 Testes

O projeto conta com testes unitários que foram desenvolvidos utilizando TDD. Os repositórios são mockados para garantir testes independentes da infraestrutura.

---

## ⚙️ Como Executar

1. Clone o repositório:
   ```bash
   git clone https://github.com/victorfidelis/prestador_de_servico.git
   cd prestador_de_servico
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Configure o Firebase (baixe o arquivo `google-services.json` e cole na pasta "\android\app\" do seu repositório clonado).

4. Execute o projeto em um emulador ou aparelho conectado a máquina:
   ```bash
   flutter run
   ```

---

## 📃 Licença

Este projeto está sob licença. Consulte o arquivo https://github.com/victorfidelis/prestador_de_servico/blob/master/LICENSE.TXT para mais informações.

---
