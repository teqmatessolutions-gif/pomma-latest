import React, { useState, useEffect, Suspense, lazy } from "react";
import { Toaster } from 'react-hot-toast';
import LockScreen from "./components/LockScreen";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { ProtectedRoute } from "./layout/DashboardLayout";
import Loading from "./components/Loading";

// Lazy Load Pages for Performance
const Login = lazy(() => import("./pages/Login.jsx"));
const Dashboard = lazy(() => import("./pages/Dashboard.jsx"));
const RoleForm = lazy(() => import("./pages/Roleform.jsx"));
const Bookings = lazy(() => import("./pages/Bookings.jsx"));
const CreateRooms = lazy(() => import("./pages/CreateRooms.jsx"));
const Users = lazy(() => import("./pages/Users.jsx"));
const Services = lazy(() => import("./pages/Services.jsx"));
const Expenses = lazy(() => import("./pages/Expenses.jsx"));
const FoodOrder = lazy(() => import("./pages/FoodOrders.jsx"));
const FoodCategory = lazy(() => import("./pages/FoodCategory.jsx"));
const FoodItem = lazy(() => import("./pages/Fooditem.jsx"));
const Billing = lazy(() => import("./pages/Billing.jsx"));
const Account = lazy(() => import("./pages/Account.jsx"));
const Userfrontend_data = lazy(() => import("./pages/Userfrontend_data.jsx"));
const Package = lazy(() => import("./pages/Package.jsx"));
const ComprehensiveReport = lazy(() => import("./pages/ComprehensiveReport.jsx"));
const GuestProfile = lazy(() => import("./pages/GuestProfile.jsx"));
const UserHistory = lazy(() => import("./pages/UserHistory.jsx"));
const EmployeeManagement = lazy(() => import("./pages/EmployeeManagement.jsx"));

const getRouterBasename = () => {
  // During build/SSR, use the PUBLIC_URL or default to /pommaadmin for production
  if (typeof window === "undefined") {
    return process.env.PUBLIC_URL || "/pommaadmin";
  }

  // Always check the actual path first
  const path = window.location.pathname || "";

  // If path includes /pommaadmin, use it (production)
  if (path.startsWith("/pommaadmin")) {
    return "/pommaadmin";
  }

  // If path includes /admin, use it (old production path if still used)
  if (path.startsWith("/admin")) {
    return "/admin";
  }

  // Default to root for localhost development
  return "/";
};

function App() {
  const basename = getRouterBasename();
  const [isAppLocked, setIsAppLocked] = useState(false);

  // KILL SWITCH: Global Fetch Interceptor
  useEffect(() => {
    const originalFetch = window.fetch;
    window.fetch = async (...args) => {
      try {
        const response = await originalFetch(...args);
        if (response.status === 403) {
          const clone = response.clone();
          try {
            const data = await clone.json();
            if (data.code === 'LICENSE_LOCKED') {
              setIsAppLocked(true);
            }
          } catch (e) {
            // ignore
          }
        }
        return response;
      } catch (error) {
        throw error;
      }
    };

    return () => {
      window.fetch = originalFetch;
    };
  }, []);

  if (isAppLocked) {
    return <LockScreen />;
  }
  return (
    <Router basename={basename}>
      <Toaster position="top-right" reverseOrder={false} />
      <Suspense fallback={<Loading />}>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/dashboard" element={
            <ProtectedRoute requiredPermission="/dashboard">
              <Dashboard />
            </ProtectedRoute>
          } />
          <Route path="/bookings" element={
            <ProtectedRoute requiredPermission="/bookings">
              <Bookings />
            </ProtectedRoute>
          } />
          <Route path="/rooms" element={
            <ProtectedRoute requiredPermission="/rooms">
              <CreateRooms />
            </ProtectedRoute>
          } />
          <Route path="/users" element={
            <ProtectedRoute requiredPermission="/users">
              <Users />
            </ProtectedRoute>
          } />
          <Route path="/services" element={
            <ProtectedRoute requiredPermission="/services">
              <Services />
            </ProtectedRoute>
          } />
          <Route path="/expenses" element={
            <ProtectedRoute requiredPermission="/expenses">
              <Expenses />
            </ProtectedRoute>
          } />
          {/* Protected Routes */}
          <Route
            path="/roles"
            element={
              <ProtectedRoute requiredPermission="/roles">
                <RoleForm />
              </ProtectedRoute>
            }
          />
          <Route
            path="/billing"
            element={
              <ProtectedRoute requiredPermission="/billing">
                <Billing />
              </ProtectedRoute>
            }
          />
          <Route
            path="/food-orders"
            element={
              <ProtectedRoute requiredPermission="/food-orders">
                <FoodOrder />
              </ProtectedRoute>
            }
          />
          <Route
            path="/food-categories"
            element={
              <ProtectedRoute requiredPermission="/food-categories">
                <FoodCategory />
              </ProtectedRoute>
            }
          />
          <Route
            path="/food-items"
            element={
              <ProtectedRoute requiredPermission="/food-items">
                <FoodItem />
              </ProtectedRoute>
            }
          />
          <Route
            path="/account"
            element={
              <ProtectedRoute requiredPermission="/account">
                <Account />
              </ProtectedRoute>
            }
          />
          <Route
            path="/Userfrontend_data"
            element={
              <ProtectedRoute requiredPermission="/Userfrontend_data">
                <Userfrontend_data />
              </ProtectedRoute>
            }
          />
          <Route
            path="/package"
            element={
              <ProtectedRoute requiredPermission="/package">
                <Package />
              </ProtectedRoute>
            }
          />
          <Route
            path="/report"
            element={
              <ProtectedRoute requiredPermission="/report">
                <ComprehensiveReport />
              </ProtectedRoute>
            }
          />
          <Route
            path="/guestprofiles"
            element={
              <ProtectedRoute requiredPermission="/guestprofiles">
                <GuestProfile />
              </ProtectedRoute>
            }
          />
          <Route
            path="/user-history"
            element={
              <ProtectedRoute requiredPermission="/user-history">
                <UserHistory />
              </ProtectedRoute>
            }
          />
          <Route
            path="/employee-management"
            element={
              <ProtectedRoute requiredPermission="/employee-management">
                <EmployeeManagement />
              </ProtectedRoute>
            }
          />
        </Routes>
      </Suspense>
    </Router>
  );
}

export default App;
