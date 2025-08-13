# AirlineData_Analysis
## Project Overview
This project demonstrates **database normalization** and **advanced SQL analysis** using an airline flight pricing dataset.  
The original dataset contained repeated textual values such as airline names, cities, classes, and raw ticket prices — all stored in a single table.  
We normalized the data into multiple relational tables in **MySQL** to improve data integrity, reduce redundancy, and enable efficient querying.

## Objectives
- **Normalize** a raw CSV dataset into **3rd Normal Form (3NF)**.
- Maintain **referential integrity** using foreign keys.
- Enable **advanced analytical queries** for insights such as:
  - Cheapest and most expensive flights.
  - Price trends as departure date approaches.
  - Airline performance and profitability.
  - Popular routes and average flight duration.
 

## Entities & Attributes

### 1. Airlines
| Attribute      | Type     | Constraints       | Description                     |
|----------------|----------|-------------------|-----------------------------------|
| `airline_id`   | INT      | PK, AUTO_INCREMENT| Unique identifier for airline.   |
| `airline_name` | VARCHAR  | UNIQUE, NOT NULL  | Name of the airline.             |



### 2. Cities
| Attribute     | Type     | Constraints       | Description                      |
|---------------|----------|-------------------|------------------------------------|
| `city_id`     | INT      | PK, AUTO_INCREMENT| Unique identifier for city.       |
| `city_name`   | VARCHAR  | UNIQUE, NOT NULL  | Name of the city.                 |



### 3. Classes
| Attribute     | Type     | Constraints       | Description                       |
|---------------|----------|-------------------|-------------------------------------|
| `class_id`    | INT      | PK, AUTO_INCREMENT| Unique identifier for flight class.|
| `class_name`  | VARCHAR  | UNIQUE, NOT NULL  | Flight travel class (e.g., Economy, Business). |



### 4. Flights
| Attribute          | Type     | Constraints       | Description                                |
|--------------------|----------|-------------------|---------------------------------------------|
| `flight_id`        | INT      | PK, AUTO_INCREMENT| Unique identifier for flight.              |
| `airline_id`       | INT      | FK → Airlines     | Airline operating the flight.              |
| `flight_number`    | VARCHAR  | NOT NULL          | Flight number/identifier.                  |
| `source_city_id`   | INT      | FK → Cities       | City from where flight departs.            |
| `destination_city_id` | INT   | FK → Cities       | City where flight arrives.                  |
| `departure_time`   | TIME     | NOT NULL          | Scheduled departure time.                   |
| `arrival_time`     | TIME     | NOT NULL          | Scheduled arrival time.                     |
| `stops`            | INT      | NOT NULL          | Number of stops in journey.                 |
| `duration`         | VARCHAR  | NOT NULL          | Total travel duration.                      |
| `class_id`         | INT      | FK → Classes      | Flight travel class.                        |



### 5. Ticket_Prices
| Attribute    | Type     | Constraints       | Description                                   |
|--------------|----------|-------------------|-----------------------------------------------|
| `price_id`   | INT      | PK, AUTO_INCREMENT| Unique identifier for ticket price record.   |
| `flight_id`  | INT      | FK → Flights      | Flight associated with the price.            |
| `days_left`  | INT      | NOT NULL          | Number of days left before departure.        |
| `price`      | DECIMAL  | NOT NULL          | Price of the ticket.                         |



## Relationships
- **Airlines → Flights**: One → Many
- **Cities → Flights (Source/Destination)**: One → Many
- **Classes → Flights**: One → Many
- **Flights → Ticket_Prices**: One → Many

## ER-Diagram
<img width="707" height="451" alt="ER" src="https://github.com/user-attachments/assets/b0d62940-380b-476f-bd3e-b44ce32064e2" />

## Normalization Approach
- First Normal Form (1NF): Removed repeating groups and ensured atomic values.
- Second Normal Form (2NF): Removed partial dependencies by creating separate tables for airlines, cities, and classes.
- Third Normal Form (3NF): Removed transitive dependencies (ticket prices stored separately from flights).
- **The normalized database ensures:**
  - **Data Integrity** → Eliminates redundancy and inconsistency.
  - **Flexibility** → Easy to extend with new attributes or entities.
  - **Performance** → Optimized for queries on flights, prices, and availability.
