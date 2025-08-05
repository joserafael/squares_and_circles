# squares_and_circles


### Introdução

Este projeto é uma aplicação Ruby on Rails projetada para gerenciar quadros (frames) e círculos. Ele fornece uma API para criar, ler, atualizar e excluir quadros, e para gerenciar círculos associados a esses quadros. A aplicação utiliza um banco de dados MySQL e inclui documentação Swagger para seus endpoints de API.

### Tecnologias Utilizadas

*   **Ruby:** 3.4.4
*   **Ruby on Rails:** 8.0.2
*   **MySQL:** 8.0
*   **Swagger (Rswag):** 2.16.0

### Configuração Docker

Para configurar e executar o projeto usando Docker, siga estas etapas:

1.  **Construir e Executar Contêineres Docker:**
    ```bash
    docker-compose up --build -d
    ```
    Este comando irá construir as imagens Docker, criar os contêineres e executá-los em modo desanexado.

2.  **Acessar a Aplicação:**
    A aplicação Rails estará acessível em `http://localhost:3000`.

3.  **Acessar a Interface do Swagger:**
    A documentação da API (Swagger UI) estará acessível em `http://localhost/swagger`.

4.  **Gerar Documentação Swagger:**
    Se você fizer alterações nos endpoints da API ou em sua documentação, será necessário regenerar o arquivo `swagger.yaml`. Execute o seguinte comando:
    ```bash
    docker-compose run --rm swagger-gen bundle exec rake rswag:specs:swaggerize
    ```

### Endpoints da API

Os seguintes endpoints da API estão disponíveis:

*   **Frames** (`/frames`)
    *   `POST /frames`: Cria um novo quadro.
    ```json
    {
      "frame": {
        "center_x": 10,
        "center_y": 10,
        "width": 20,
        "height": 20,
        "circles_attributes": [
          {
            "center_x": 5,
            "center_y": 5,
            "diameter": 10
          }
        ]
      }
    }
    ```
    *   `GET /frames`: Retorna uma lista de todos os quadros.
    *   `GET /frames/{id}`: Retorna um quadro específico pelo ID, incluindo seus círculos associados.
    *   `PUT /frames/{id}`: Atualiza um quadro existente.
    ```json
    {
      "frame": {
        "center_x": 15,
        "center_y": 15
      }
    }
    ```
    *   `DELETE /frames/{id}`: Exclui um quadro existente.

*   **Circles** (`/circles`)
    *   `POST /frames/{frame_id}/circles`: Cria um novo círculo associado a um quadro específico.
    ```json
    {
      "circle": {
        "center_x": 10,
        "center_y": 10,
        "diameter": 5
      }
    }
    ```
    *   `GET /circles`: Pesquisa círculos com base em parâmetros como `center_x`, `center_y`, `radius` e `frame_id`.
    *   `PUT /circles/{id}`: Atualiza um círculo existente.
    ```json
    {
      "circle": {
        "center_x": 12,
        "center_y": 12,
        "diameter": 6
      }
    }
    ```
    *   `DELETE /circles/{id}`: Exclui um círculo existente.

### Contato

Para entrar em contato, utilize as informações abaixo:

*   **Nome:** Jose Rafael Camejo
*   **Email:** jose20camejo@mail.com