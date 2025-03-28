# models.py
import mysql.connector
from api.config import DB_CONFIG

def get_db_connection():
    conn = mysql.connector.connect(**DB_CONFIG)
    return conn


def get_available_rooms(criteria):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Updated query to include Hotel_ID
    query = """
    SELECT H.Hotel_ID, H.Name AS Hotel_Name, HR.Room_ID, HR.Price, HR.Capacity, HR.View
    FROM Hotel H
    JOIN Hotel_Room HR ON H.Hotel_ID = HR.Hotel_ID
    WHERE HR.Availability_Status = 'Available' AND H.Address LIKE %s AND HR.Capacity >= %s
    """

    # Execute query with address and capacity criteria
    cursor.execute(query, (f"%{criteria['address']}%", criteria['capacity']))
    rooms = cursor.fetchall()

    # Close cursor and connection
    cursor.close()
    conn.close()

    return rooms



def book_room(data):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """
    INSERT INTO Reserved (Customer_RS_Number, Room_ID, Hotel_ID, Start_Date, Finish_Date, Paid)
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    cursor.execute(query, (
        data['customer_id'], data['room_id'], data['hotel_id'],
        data['start_date'], data['end_date'], data['paid']
    ))
    conn.commit()
    cursor.close()
    conn.close()
    return {"message": "Room booked successfully!"}


def rent_room(data):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """
    INSERT INTO Rents (Customer_RS_Number, Employee_RS_Number, Room_ID, Hotel_ID, Start_Date, Finish_Date)
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    cursor.execute(query, (
        data['customer_id'], data['employee_id'], data['room_id'],
        data['hotel_id'], data['start_date'], data['end_date']
    ))
    conn.commit()
    cursor.close()
    conn.close()
    return {"message": "Room rented successfully!"}


def add_customer(data):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """
    INSERT INTO Customer (RS_Number, First_Name, Last_Name, Identification_Number, ID_Type, First_Registration, Address, User_ID)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    cursor.execute(query, (
        data['rs_number'], data['first_name'], data['last_name'],
        data['identification_number'], data['id_type'],
        data['registration_date'], data['address'], data['user_id']
    ))
    conn.commit()
    cursor.close()
    conn.close()
    return {"message": "Customer added successfully!"}


def get_customers():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query = "SELECT * FROM Customer"
    cursor.execute(query)
    customers = cursor.fetchall()
    cursor.close()
    conn.close()
    return customers


def update_room_status(data):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """
    UPDATE Hotel_Room
    SET Availability_Status = %s
    WHERE Room_ID = %s AND Hotel_ID = %s
    """
    cursor.execute(query, (data['status'], data['room_id'], data['hotel_id']))
    conn.commit()
    cursor.close()
    conn.close()
    return {"message": "Room status updated successfully!"}
