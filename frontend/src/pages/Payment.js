// src/pages/Payment.js
import React, { useState } from 'react';
import axios from 'axios';

function Payment() {
    const [paymentData, setPaymentData] = useState({
        customer_id: '',
        room_id: '',
        hotel_id: '',
        amount: '',
        payment_method: '',
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setPaymentData({
            ...paymentData,
            [name]: value,
        });
    };

    const handlePayment = async () => {
        try {
            const res = await axios.post('http://127.0.0.1:5000/api/payment', paymentData);
            alert(res.data.message);
        } catch (error) {
            console.error('Error processing payment:', error);
            alert('Payment failed! Please try again.');
        }
    };

    return (
        <div className="container mt-5">
            <h2>Make a Payment</h2>
            <form>
                <div className="form-group">
                    <label>Customer ID</label>
                    <input
                        type="text"
                        className="form-control"
                        name="customer_id"
                        value={paymentData.customer_id}
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
                        value={paymentData.room_id}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>Hotel ID</label>
                    <input
                        type="text"
                        className="form-control"
                        name="hotel_id"
                        value={paymentData.hotel_id}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>Payment Amount</label>
                    <input
                        type="number"
                        className="form-control"
                        name="amount"
                        value={paymentData.amount}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>Payment Method</label>
                    <select
                        className="form-control"
                        name="payment_method"
                        value={paymentData.payment_method}
                        onChange={handleChange}
                        required
                    >
                        <option value="">Select Payment Method</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="PayPal">PayPal</option>
                    </select>
                </div>
                <button
                    type="button"
                    className="btn btn-success mt-3"
                    onClick={handlePayment}
                >
                    Submit Payment
                </button>
            </form>
        </div>
    );
}

export default Payment;
