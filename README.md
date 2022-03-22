# 💱 Currency exchange Project


This project is a Rest API capable of converting between two provided currencies
using updated rates from an external service. We consult the `https://api.exchangeratesapi.io/latest?base=EUR` service, which provides updated currency exchange rates.

### 📋 Prerequisites

To run the project, you need to have:

- Erlang 24 or above
- Elixir 1.12 or above
- Phoenix v1.6.2

### 🔧 Project installation

- Download the project from `Github`:
`
    git clone https://github.com/wagner-de-carvalho/currency_exchange
`
- Download the dependencies:
Inside the project folder run:
`
    mix deps.get
`
- Configure the database:
In `config\dev.ex` enter the data:

- username: "your_username",
- password: "your_password",
- database: "your_database_name",
- hostname: "localhost"

- After configuration, in the project folder, execute the command:
`mix ecto.setup`

- :warning: In the .env file, **replace the api key variable** with yours:
    `API_KEY={{ YOUR API KEY }}`

- Just to be in the safe side, in the modules **Exchange** and **CurrencyList**, replace the API key with yours in the function `System.get_env/2`

- Load environment variables, run the command:
    `source .env`

- To run the project, enter the command
    `mix phx.server`

### 🔩 Running tests

To run the tests, enter the command
    `mix test`

### ⚙️ Features

The available features are: **create a new transaction**, **display all transactions performed**, **display all transactions performed by a specific user**.

### 🌐 Endpoints

- GET /transactions 
Show all transactions performed.

**Resource information**
Response format: JSON

**Resource URL**
`http://localhost:4000/api/transactions`

---

- GET /user/:id/transactions
Show all transactions performed by a specific user.

**Resource information**
Response format: JSON

**Parameters**

- id: string, required. User ID.

**Resource URL**
`http://localhost:4000/api/user/:id/transactions`

---

- POST /transactions 
Creates a new transacion.

**Resource information** 
Response format: JSON

**Parameters** 

- user_id: string, required. Valid user ID.
- origin_currency: string, required.
- destiny_currency: string, required.  
- origin_amount: float, required.

**Resource URL** 
`http://localhost:4000/api/transactions`

---
### 🔃 Requests

`GET http://localhost:4000/api/transactions`


`GET http://localhost:4000/api/user/1/transactions`


`POST http://localhost:4000/api/transactions`

```json
    content-type: application/json
{
   "user_id": "5", 
   "origin_currency": "BR", 
   "destiny_currency": "USD", 
   "origin_amount": 1
}
```
---

### 🎯 Motivation of the main technology choices

The main technologies used were: `Elixir` programming language, `Phoenix` framework. In addition to these, the `cubdb` library, developed in Elixir and easy to use, was used. It provides database operations such as insert, update, remove and display.
These tools were chosen in compliance with the requirements for implementing this API.
### 💠 Separation of layers

The project has three main layers:

- Business: this includes the query to the currency conversion API, creation of transaction structure, as well as it's validation, transaction creation, transaction display.

- Database: The database is in charge of the `cubdb` library, responsible for performing the insertion and display operations of the data.

- Web: Responsible for API routes, views and error handling of routes.

**Developer** [Wagner Patrick de Carvalho](https://github.com/wagncarv)

⌨️ By [Wagner Patrick de Carvalho](https://github.com/wagner-de-carvalho) 😊# elixir_phoenix
# currency_exchange
