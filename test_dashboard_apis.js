// Test script to check Dashboard API responses
const API_BASE = 'http://localhost:8000/api';

async function testDashboardAPIs() {
    const endpoints = [
        '/bookings?limit=500',
        '/rooms?limit=2000',
        '/expenses?limit=500',
        '/food-orders?limit=500',
        '/services/assigned?limit=500',
        '/bill/checkouts?limit=500',
        '/packages?limit=500',
        '/packages/bookingsall?limit=500'
    ];

    console.log('Testing Dashboard API endpoints...\n');

    for (const endpoint of endpoints) {
        try {
            const response = await fetch(`${API_BASE}${endpoint}`);
            const data = await response.json();

            console.log(`✅ ${endpoint}`);
            console.log(`   Status: ${response.status}`);
            console.log(`   Has 'items' property: ${!!data.items}`);
            console.log(`   Is Array: ${Array.isArray(data)}`);
            console.log(`   Data structure:`, Object.keys(data).join(', '));
            console.log('');
        } catch (error) {
            console.log(`❌ ${endpoint}`);
            console.log(`   Error: ${error.message}\n`);
        }
    }
}

testDashboardAPIs();
