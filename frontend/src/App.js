// src/App.js
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Search from './pages/Search';
import Payment from './pages/Payment';
import CustomerDashboard from './components/CustomerDashboard';
import EmployeeDashboard from './components/EmployeeDashboard';

function App() {
    return (
        <Router>
            <Navbar />
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/search" element={<Search />} />
                <Route path="/payment" element={<Payment />} />
                <Route path="/customer-dashboard" element={<CustomerDashboard />} />
                <Route path="/employee-dashboard" element={<EmployeeDashboard />} />
            </Routes>
        </Router>
    );
}

export default App;
