# Prestador de Serviço (em desenvolvimento)

Projeto completo para gestão de agendamentos de serviços rápidos voltado para profissionais autônomos e seus clientes.

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
- Programação funcional com **Either**
- Padrões de Projeto:
  - **Repository Pattern**
  - Princípios **SOLID** aplicados (**Single Responsibility**, **Open-Closed**, **Dependency Inversion**).
  - **State Pattern**
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

## 🖼️ Capturas de Tela 

<img src="https://github.com/user-attachments/assets/6b6127e9-7895-42d3-96ba-33e81e21b6bb" width="250">
<img src="https://github.com/user-attachments/assets/717dcf25-dfd1-4153-b40d-d8ab711396f9" width="250">
<img src="https://github.com/user-attachments/assets/05330826-6319-4b0d-bef4-c5cbbf424877" width="250">
<img src="https://github.com/user-attachments/assets/9bd180c7-6640-45ca-b4bd-fbbf43723479" width="250">
<img src="https://github.com/user-attachments/assets/c1fdb247-a34e-4b76-babf-58d25ae5c6ef" width="250">
<img src="https://github.com/user-attachments/assets/a5e8a369-64b2-40d0-8c95-9fcf5697243c" width="250">
<img src="https://github.com/user-attachments/assets/116213f0-d86f-46f3-82ea-019ca6c61a87" width="250">
<img src="https://github.com/user-attachments/assets/e26cda51-4656-4800-8698-b5b32323d151" width="250">
<img src="https://github.com/user-attachments/assets/24abe2fd-9e48-4015-9ed0-2e5ec161b818" width="250">
<img src="https://github.com/user-attachments/assets/57649540-c419-4aac-a325-a040d6d1093b" width="250">
<img src="https://github.com/user-attachments/assets/82b09911-dafb-450e-8e38-6562030a8bf7" width="250">

---

## 📃 Licença

Este projeto está sob licença. Consulte o arquivo https://github.com/victorfidelis/prestador_de_servico/blob/master/LICENSE.TXT para mais informações.

---
