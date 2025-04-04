# E-Hotels
# 🏨 E-Hotels Management System

This is a full-stack hotel management system built for academic purposes using **MySQL**, **Flask**, and **React.js**. The system supports hotel chains, room booking and renting, user roles (employee/customer), and integrates database constraints, triggers, and UI functionalities.

---

## 🚀 Technologies Used

### Backend
- Python 3
- Flask
- MySQL Connector
- MySQL (Relational Database)

### Frontend
- React.js
- Bootstrap 5
- Axios (for HTTP requests)

---

## 💠 Project Structure

```
E-Hotels/
🔸️ backend/
│   🔸️ app.py                # Flask app entry point
│   🔸️ db.py                 # DB connection setup
│   🔸️ api/
│   │   🔸️ models.py         # Functions for booking, search, etc.
│   │   🔸️ routes.py         # API endpoints
│   🔸️ eHotels.sql           # Full schema, sample data, views, triggers
│   🔸️ requirements.txt      # Backend dependencies
│
🔸️ frontend/
│   🔸️ public/
│   🔸️ src/
│   │   🔸️ components/
│   │   │   🔸️ Booking.js
│   │   🔸️ pages/
│   │   │   🔸️ Search.js
│   │   🔸️ App.js
│   │   🔸️ index.js
│   🔸️ package.json          # Frontend dependencies
│
🔸️ README.md                 # This file
🔸️ demo.mp4                  # (Add your video demo here)
```

---

## 🛆 Setup Instructions

### 1. 🧱 Backend Setup
```bash
cd backend
pip install -r requirements.txt
```

- Make sure MySQL is installed and running
- Create the database:
```bash
mysql -u root -p < eHotels.sql
```

- Run the Flask app:
```bash
python app.py
```

---

### 2. 🎨 Frontend Setup
```bash
cd frontend
npm install
npm start
```

---

## 📓 Database Overview

### Key Tables
- `Users`: Login & roles (Customer, Employee)
- `Customer`, `Employee`: Info tables
- `Hotel`, `Hotel_Group`, `Hotel_Room`
- `Reserved`, `Rents`: Booking & Renting
- `Payment_Transaction`: Stores payments
- `Works`: Hotel employment relation

### Constraints
- Cascading foreign keys (e.g., deleting hotel deletes rooms)
- `CHECK` constraints (e.g., room capacity > 0)
- `ENUM` values for role and availability

### Triggers
```sql
AFTER INSERT ON Reserved
→ Updates room availability to 'Booked'
```

---

## 🧪 Sample Data

- 5 hotel chains × 8 hotels each = 40 hotels
- 5 rooms per hotel = 200 rooms
- Sample customers & employees added
- 2 sample bookings pre-loaded

---

## 🔎 Key SQL Queries

```sql
-- Available rooms per area
SELECT H.Address, COUNT(*) 
FROM Hotel H JOIN Hotel_Room HR ON H.Hotel_ID = HR.Hotel_ID
WHERE HR.Availability_Status = 'Available'
GROUP BY H.Address;
```

```sql
-- Trigger test
INSERT INTO Reserved (...) VALUES (...);
```

---

## ⚡ Features

- Search rooms by location and capacity
- Book room (customer)
- View reservation & auto-update room availability
- Employee and customer views (via role)
- Integrated backend + SQL + frontend

---

## 📸 Screenshots

> (Add screenshots of the UI and DB views if you want)

---

## 📹 Video Presentation

> [Demo Video (10–15 minutes)](./demo.mp4)  
> Covers tech stack, schema, constraints, sample data, queries, triggers, UI demo

---

## 👤 Author

**Umer Qamar**  
Engineering Student – University Of Ottawa  
For academic use only 📚

---

## 📄 License

MIT License © 2025
```

Let me know if you want me to generate a `requirements.txt`, compress a video, or embed screenshots next.