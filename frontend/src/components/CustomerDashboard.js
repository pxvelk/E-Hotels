// src/components/CustomerDashboard.js
import React, { useEffect, useState } from 'react';
import axios from 'axios';

function CustomerDashboard() {
    const [customers, setCustomers] = useState([]);

    useEffect(() => {
        axios.get('http://127.0.0.1:5000/api/customers').then((res) => {
            setCustomers(res.data.customers);
        });
    }, []);

    return (
        <div className="container mt-5">
            <h2>Customer Dashboard</h2>
            <table className="table table-bordered">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Address</th>
                        <th>ID Type</th>
                    </tr>
                </thead>
                <tbody>
                    {customers.map((customer) => (
                        <tr key={customer.RS_Number}>
                            <td>{customer.RS_Number}</td>
                            <td>{customer.First_Name}</td>
                            <td>{customer.Last_Name}</td>
                            <td>{customer.Address}</td>
                            <td>{customer.ID_Type}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

export default CustomerDashboard;
