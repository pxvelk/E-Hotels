# routes.py
from flask import Blueprint, request, jsonify
from api.models import (
    get_available_rooms,
    book_room,
    rent_room,
    add_customer,
    get_customers,
    update_room_status,
)

api = Blueprint('api', __name__)

@api.route('/search', methods=['POST'])
def search_rooms():
    """API to search available rooms."""
    criteria = request.json
    rooms = get_available_rooms(criteria)
    return jsonify({'rooms': rooms})


@api.route('/book', methods=['POST'])
def book_room_api():
    """API to book a room."""
    data = request.json
    result = book_room(data)
    return jsonify(result)


@api.route('/rent', methods=['POST'])
def rent_room_api():
    """API to rent a room."""
    data = request.json
    result = rent_room(data)
    return jsonify(result)


@api.route('/add-customer', methods=['POST'])
def add_customer_api():
    """API to add a new customer."""
    data = request.json
    result = add_customer(data)
    return jsonify(result)


@api.route('/customers', methods=['GET'])
def get_customers_api():
    """API to fetch all customers."""
    customers = get_customers()
    return jsonify({'customers': customers})


@api.route('/update-room-status', methods=['PUT'])
def update_room_status_api():
    """API to update the room status."""
    data = request.json
    result = update_room_status(data)
    return jsonify(result)
