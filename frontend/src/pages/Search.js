import React, { useState } from 'react';
import axios from 'axios';
import Booking from '../components/Booking';

function Search() {
    const [criteria, setCriteria] = useState({
        address: '',
        capacity: 1,
    });

    const [rooms, setRooms] = useState([]);
    const [selectedRoom, setSelectedRoom] = useState(null);
    const [customerId, setCustomerId] = useState('');

    const handleSearch = async () => {
        try {
            const res = await axios.post('http://127.0.0.1:5000/api/search', criteria);
            setRooms(res.data.rooms);
        } catch (error) {
            console.error('Error fetching rooms:', error);
            alert('Error fetching rooms. Please check backend.');
        }
    };

    return (
        <div className="container mt-5">
            <h2>Search Available Rooms</h2>
            <div className="form-group">
                <label>Location</label>
                <input
                    type="text"
                    className="form-control"
                    value={criteria.address}
                    onChange={(e) => setCriteria({ ...criteria, address: e.target.value })}
                />
            </div>
            <div className="form-group">
                <label>Capacity</label>
                <input
                    type="number"
                    className="form-control"
                    value={criteria.capacity}
                    onChange={(e) => setCriteria({ ...criteria, capacity: e.target.value })}
                />
            </div>
            <button className="btn btn-primary mt-3" onClick={handleSearch}>
                Search
            </button>

            <hr />
            <h3>Results:</h3>
            <ul className="list-group">
                {rooms.map((room, idx) => (
                    <li
                        key={idx}
                        className="list-group-item d-flex justify-content-between align-items-center"
                    >
                        {room.Hotel_ID} - {room.Hotel_Name} - Room {room.Room_ID} - ${room.Price} - {room.View}
                        <button
                            className="btn btn-success"
                            onClick={() => setSelectedRoom(room)}
                        >
                            Book
                        </button>
                    </li>
                ))}
            </ul>

            {selectedRoom && (
                <div className="mt-5">
                    <h4>Booking Room: {selectedRoom.Room_ID}</h4>
                    <Booking room={selectedRoom} customerId={customerId} />
                </div>
            )}
        </div>
    );
}

export default Search;
