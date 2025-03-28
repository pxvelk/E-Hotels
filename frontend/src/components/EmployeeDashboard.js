// src/components/EmployeeDashboard.js
import React, { useState } from 'react';
import axios from 'axios';

function EmployeeDashboard() {
    const [roomData, setRoomData] = useState({
        room_id: '',
        hotel_id: '',
        status: '',
    });

    const handleUpdate = async () => {
        const res = await axios.put('http://127.0.0.1:5000/api/update-room-status', roomData);
        alert(res.data.message);
    };

    return (
        <div className="container mt-5">
            <h2>Employee Dashboard</h2>
            <div className="form-group">
                <label>Room ID</label>
                <input
                    type="text"
                    className="form-control"
                    onChange={(e) => setRoomData({ ...roomData, room_id: e.target.value })}
                />
            </div>
            <div className="form-group">
                <label>Hotel ID</label>
                <input
                    type="text"
                    className="form-control"
                    onChange={(e) => setRoomData({ ...roomData, hotel_id: e.target.value })}
                />
            </div>
            <div className="form-group">
                <label>Status</label>
                <select
                    className="form-control"
                    onChange={(e) => setRoomData({ ...roomData, status: e.target.value })}
                >
                    <option value="Available">Available</option>
                    <option value="Booked">Booked</option>
                    <option value="Rented">Rented</option>
                </select>
            </div>
            <button className="btn btn-primary mt-3" onClick={handleUpdate}>
                Update Room Status
            </button>
        </div>
    );
}

export default EmployeeDashboard;
