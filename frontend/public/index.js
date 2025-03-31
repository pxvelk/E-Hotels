// Complete Dataset from SQL File
const hotel_groups = [
  { id: 1, name: 'Fairmont Hotels', num_hotels: 8 },
  { id: 2, name: 'Four Seasons', num_hotels: 8 },
  { id: 3, name: 'Delta Hotels', num_hotels: 8 },
  { id: 4, name: 'Sandman Hotels', num_hotels: 8 },
  { id: 5, name: 'Holiday Inn', num_hotels: 8 }
];

const hotels = [
  // Fairmont Hotels (1001-1008)
  { id: 1001, group_id: 1, name: 'Fairmont The Queen Elizabeth', address: 'Downtown Montreal', stars: 5, category: 'Luxury' },
  { id: 1002, group_id: 1, name: 'Fairmont Royal York', address: 'Downtown Montreal', stars: 4, category: 'Standard' },
  { id: 1003, group_id: 1, name: 'Fairmont Delta', address: 'Uptown Montreal', stars: 3, category: 'Budget' },
  { id: 1004, group_id: 1, name: 'Fairmont Le Château', address: 'Suburban Montreal', stars: 5, category: 'Luxury' },
  { id: 1005, group_id: 1, name: 'Fairmont St. James', address: 'Midtown Montreal', stars: 4, category: 'Standard' },
  { id: 1006, group_id: 1, name: 'Fairmont Concordia', address: 'Uptown Montreal', stars: 3, category: 'Budget' },
  { id: 1007, group_id: 1, name: 'Fairmont Centre', address: 'Downtown Montreal', stars: 5, category: 'Luxury' },
  { id: 1008, group_id: 1, name: 'Fairmont Westmount', address: 'Suburban Montreal', stars: 4, category: 'Standard' },
  
  // Four Seasons (2001-2008)
  { id: 2001, group_id: 2, name: 'Four Seasons Toronto 1', address: 'Central Toronto', stars: 4, category: 'Luxury' },
  { id: 2002, group_id: 2, name: 'Four Seasons Toronto 2', address: 'Central Toronto', stars: 3, category: 'Standard' },
  { id: 2003, group_id: 2, name: 'Four Seasons Toronto 3', address: 'Eastside Toronto', stars: 5, category: 'Budget' },
  { id: 2004, group_id: 2, name: 'Four Seasons Toronto 4', address: 'Westside Toronto', stars: 4, category: 'Luxury' },
  { id: 2005, group_id: 2, name: 'Four Seasons Toronto 5', address: 'Northside Toronto', stars: 3, category: 'Standard' },
  { id: 2006, group_id: 2, name: 'Four Seasons Toronto 6', address: 'Eastside Toronto', stars: 5, category: 'Budget' },
  { id: 2007, group_id: 2, name: 'Four Seasons Toronto 7', address: 'Central Toronto', stars: 4, category: 'Luxury' },
  { id: 2008, group_id: 2, name: 'Four Seasons Toronto 8', address: 'Westside Toronto', stars: 3, category: 'Standard' },
  
  // Delta Hotels (3001-3008)
  { id: 3001, group_id: 3, name: 'Delta Vancouver 1', address: 'Downtown Vancouver', stars: 5, category: 'Luxury' },
  { id: 3002, group_id: 3, name: 'Delta Vancouver 2', address: 'Downtown Vancouver', stars: 4, category: 'Standard' },
  { id: 3003, group_id: 3, name: 'Delta Vancouver 3', address: 'Uptown Vancouver', stars: 3, category: 'Budget' },
  { id: 3004, group_id: 3, name: 'Delta Vancouver 4', address: 'Suburban Vancouver', stars: 5, category: 'Luxury' },
  { id: 3005, group_id: 3, name: 'Delta Vancouver 5', address: 'Midtown Vancouver', stars: 4, category: 'Standard' },
  { id: 3006, group_id: 3, name: 'Delta Vancouver 6', address: 'Uptown Vancouver', stars: 3, category: 'Budget' },
  { id: 3007, group_id: 3, name: 'Delta Vancouver 7', address: 'Downtown Vancouver', stars: 5, category: 'Luxury' },
  { id: 3008, group_id: 3, name: 'Delta Vancouver 8', address: 'Suburban Vancouver', stars: 4, category: 'Standard' },
  
  // Sandman Hotels (4001-4008)
  { id: 4001, group_id: 4, name: 'Sandman Calgary 1', address: 'Central Calgary', stars: 4, category: 'Luxury' },
  { id: 4002, group_id: 4, name: 'Sandman Calgary 2', address: 'Central Calgary', stars: 3, category: 'Standard' },
  { id: 4003, group_id: 4, name: 'Sandman Calgary 3', address: 'East Calgary', stars: 5, category: 'Budget' },
  { id: 4004, group_id: 4, name: 'Sandman Calgary 4', address: 'West Calgary', stars: 4, category: 'Luxury' },
  { id: 4005, group_id: 4, name: 'Sandman Calgary 5', address: 'North Calgary', stars: 3, category: 'Standard' },
  { id: 4006, group_id: 4, name: 'Sandman Calgary 6', address: 'East Calgary', stars: 5, category: 'Budget' },
  { id: 4007, group_id: 4, name: 'Sandman Calgary 7', address: 'Central Calgary', stars: 4, category: 'Luxury' },
  { id: 4008, group_id: 4, name: 'Sandman Calgary 8', address: 'West Calgary', stars: 3, category: 'Standard' },
  
  // Holiday Inn (5001-5008)
  { id: 5001, group_id: 5, name: 'Holiday Inn Ottawa 1', address: 'Downtown Ottawa', stars: 5, category: 'Luxury' },
  { id: 5002, group_id: 5, name: 'Holiday Inn Ottawa 2', address: 'Downtown Ottawa', stars: 4, category: 'Standard' },
  { id: 5003, group_id: 5, name: 'Holiday Inn Ottawa 3', address: 'Uptown Ottawa', stars: 3, category: 'Budget' },
  { id: 5004, group_id: 5, name: 'Holiday Inn Ottawa 4', address: 'Suburb Ottawa', stars: 5, category: 'Luxury' },
  { id: 5005, group_id: 5, name: 'Holiday Inn Ottawa 5', address: 'Midtown Ottawa', stars: 4, category: 'Standard' },
  { id: 5006, group_id: 5, name: 'Holiday Inn Ottawa 6', address: 'Uptown Ottawa', stars: 3, category: 'Budget' },
  { id: 5007, group_id: 5, name: 'Holiday Inn Ottawa 7', address: 'Downtown Ottawa', stars: 5, category: 'Luxury' },
  { id: 5008, group_id: 5, name: 'Holiday Inn Ottawa 8', address: 'Suburb Ottawa', stars: 4, category: 'Standard' }
];

const hotel_rooms = [];
// Generate rooms matching SQL data (5 rooms per hotel, capacities 1-5)
hotels.forEach(hotel => {
  for(let room_num = 1; room_num <= 5; room_num++) {
      hotel_rooms.push({
          room_id: room_num,
          hotel_id: hotel.id,
          price: 150 + (hotel.group_id * 10) + (room_num * 10),
          capacity: room_num,
          view: room_num % 2 === 0 ? 'Mountain View' : 'Sea View',
          amenities: room_num >= 3 ? 'TV, AC, Fridge' : 'TV, AC',
          available: true
      });
  }
});

// UI Control Functions
function showDashboard() {
  document.getElementById('login-section').classList.add('hidden');
  const role = document.getElementById('userRole').value;
  document.getElementById(role + '-dashboard').classList.remove('hidden');
  loadViews();
  loadInitialData();
}

function showLogin() {
  document.querySelectorAll('.section').forEach(s => s.classList.add('hidden'));
  document.getElementById('login-section').classList.remove('hidden');
}

// Search System
function searchRooms() {
  const filters = {
      start: document.getElementById('startDate').value,
      end: document.getElementById('endDate').value,
      capacity: parseInt(document.getElementById('capacity').value),
      minPrice: parseInt(document.getElementById('minPrice').value) || 0,
      maxPrice: parseInt(document.getElementById('maxPrice').value) || Infinity,
      chain: parseInt(document.getElementById('hotelChain').value),
      category: document.getElementById('hotelCategory').value,
      area: document.getElementById('area').value
  };

  const results = hotel_rooms.filter(room => {
      const hotel = hotels.find(h => h.id === room.hotel_id);
      const chainMatch = filters.chain ? hotel.group_id === filters.chain : true;
      const categoryMatch = filters.category ? hotel.category === filters.category : true;
      const areaMatch = filters.area ? hotel.address.includes(filters.area) : true;
      
      return room.capacity >= filters.capacity &&
             room.price >= filters.minPrice &&
             room.price <= filters.maxPrice &&
             chainMatch &&
             categoryMatch &&
             areaMatch &&
             room.available;
  });

  displayResults(results);
}

function displayResults(results) {
  const tbody = document.querySelector('#results tbody');
  tbody.innerHTML = results.map(room => {
      const hotel = hotels.find(h => h.id === room.hotel_id);
      const chain = hotel_groups.find(g => g.id === hotel.group_id).name;
      return `<tr>
          <td>${chain}</td>
          <td>${hotel.name}</td>
          <td>Room ${room.room_id}</td>
          <td>$${room.price}</td>
          <td>${room.capacity}</td>
          <td>${hotel.address}</td>
          <td><button onclick="bookRoom(${room.room_id}, ${room.hotel_id})">Book</button></td>
      </tr>`;
  }).join('');
}

// Booking System
function bookRoom(roomId, hotelId) {
  const room = hotel_rooms.find(r => r.room_id === roomId && r.hotel_id === hotelId);
  if(room && room.available) {
      room.available = false;
      alert(`Successfully booked Room ${roomId} at ${hotels.find(h => h.id === hotelId).name}`);
      searchRooms(); // Refresh results
  }
}

// CRUD Operations
function showCrudForm() {
  const type = document.getElementById('manageType').value;
  let formHTML = '';
  
  switch(type) {
      case 'customers':
          formHTML = `<input placeholder="First Name">
                      <input placeholder="Last Name">
                      <input placeholder="ID Number">`;
          break;
      case 'employees':
          formHTML = `<input placeholder="First Name">
                      <input placeholder="Last Name">
                      <input placeholder="SSN">`;
          break;
      case 'hotels':
          formHTML = `<select>
                          ${hotel_groups.map(g => `<option value="${g.id}">${g.name}</option>`).join('')}
                       </select>`;
          break;
      case 'rooms':
          formHTML = `<select>
                          ${hotels.map(h => `<option value="${h.id}">${h.name}</option>`).join('')}
                      </select>
                      <input type="number" placeholder="Room Number">`;
          break;
  }
  
  document.getElementById('crudForm').innerHTML = formHTML + 
      `<button onclick="saveRecord('${type}')">Save</button>`;
}

function saveRecord(type) {
  // Implement actual database operations here
  alert(`Record type ${type} saved (simulated)`);
}

// Initialize Filters
function loadInitialData() {
  // Hotel Chains
  const chainSelect = document.getElementById('hotelChain');
  chainSelect.innerHTML = '<option value="">All</option>' + 
      hotel_groups.map(g => `<option value="${g.id}">${g.name}</option>`).join('');

  // Categories
  const categories = [...new Set(hotels.map(h => h.category))];
  document.getElementById('hotelCategory').innerHTML = '<option value="">All</option>' +
      categories.map(c => `<option>${c}</option>`).join('');

  // Areas
  const areas = [...new Set(hotels.map(h => h.address))];
  document.getElementById('area').innerHTML = '<option value="">All</option>' +
      areas.map(a => `<option>${a}</option>`).join('');
}

// SQL Views
function loadViews() {
  // Available Rooms Per Area
  const areaCounts = hotels.reduce((acc, hotel) => {
      const count = hotel_rooms.filter(r => 
          r.hotel_id === hotel.id && r.available
      ).length;
      acc[hotel.address] = (acc[hotel.address] || 0) + count;
      return acc;
  }, {});
  
  document.querySelector('#view1 tbody').innerHTML = 
      Object.entries(areaCounts).map(([area, count]) => 
          `<tr><td>${area}</td><td>${count}</td></tr>`).join('');

  // Room Capacity Summary
  const capacityData = hotels.map(hotel => {
      const total = hotel_rooms.filter(r => r.hotel_id === hotel.id)
                              .reduce((sum, r) => sum + r.capacity, 0);
      return { name: hotel.name, total };
  });
  
  document.querySelector('#view2 tbody').innerHTML = 
      capacityData.map(d => `<tr><td>${d.name}</td><td>${d.total}</td></tr>`).join('');
}

// Initialize on Load
window.onload = () => {
  loadInitialData();
  loadViews();
};