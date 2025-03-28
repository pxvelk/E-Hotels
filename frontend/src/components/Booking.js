import React, { useState, useEffect } from 'react';
import axios from 'axios';

function Booking({ room, customerId }) {
    const [bookingData, setBookingData] = useState({
        customer_id: customerId || '',
        room_id: room.Room_ID,
        hotel_id: room.Hotel_ID,
        start_date: '',
        end_date: '',
        paid: false,
    });

    const [isBooked, setIsBooked] = useState(false);

    // Function to handle form input changes
    const handleChange = (e) => {
        const { name, value, type, checked } = e.target;
        setBookingData({
            ...bookingData,
            [name]: type === 'checkbox' ? checked : value,
        });
    };

    // Function to submit booking
    const handleBooking = async () => {
        console.log('Booking data:', bookingData);

        try {
            
            const res = await axios.post('http://127.0.0.1:5000/api/book', bookingData);
            alert(res.data.message);
            setIsBooked(true);
        } catch (error) {
            console.error('Error while booking the room:', error);
            alert('Booking failed! Please try again.');
        }
    };

    // Check if the room is already booked
    useEffect(() => {
        if (isBooked) {
            alert('Room has been successfully booked!');
        }
    }, [isBooked]);

    return (
        <div className="container mt-4">
            <h2>Room Booking</h2>
            <form>
                <div className="form-group">
                    <label>Customer ID</label>
                    <input
                        type="text"
                        className="form-control"
                        name="customer_id"
                        value={bookingData.customer_id}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>Room ID</label>
                    <input
                        type="text"
                        className="form-control"
                        name="room_id"
                        value={bookingData.room_id}
                        readOnly
                    />
                </div>
                <div className="form-group">
                    <label>Hotel ID</label>
                    <input
                        type="text"
                        className="form-control"
                        name="hotel_id"
                        value={bookingData.hotel_id}
                        readOnly
                    />
                </div>
                <div className="form-group">
                    <label>Start Date</label>
                    <input
                        type="date"
                        className="form-control"
                        name="start_date"
                        value={bookingData.start_date}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>End Date</label>
                    <input
                        type="date"
                        className="form-control"
                        name="end_date"
                        value={bookingData.end_date}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group form-check">
                    <input
                        type="checkbox"
                        className="form-check-input"
                        name="paid"
                        checked={bookingData.paid}
                        onChange={handleChange}
                    />
                    <label className="form-check-label">Payment Completed?</label>
                </div>
                <button
                    type="button"
                    className="btn btn-success mt-3"
                    onClick={handleBooking}
                >
                    Book Room
                </button>
            </form>
        </div>
    );
}

export default Booking;
