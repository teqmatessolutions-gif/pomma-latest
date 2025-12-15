import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import api from "../services/api";
import pommaLogo from "../assets/pommalogo.png";

import { jwtDecode } from "jwt-decode";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      const response = await api.post("/auth/login", { email, password });
      if (response.data && response.data.access_token) {
        localStorage.setItem("token", response.data.access_token);

        // Dynamic Redirect Logic
        try {
          const decodedUser = jwtDecode(response.data.access_token);
          const role = (decodedUser.role || '').toLowerCase();
          const permissions = decodedUser.permissions || [];

          // Define all dashboard routes in priority order
          const routes = [
            { path: "/dashboard", permission: "/dashboard" },
            { path: "/bookings", permission: "/bookings" },
            { path: "/rooms", permission: "/rooms" },
            { path: "/services", permission: "/services" },
            { path: "/food-orders", permission: "/food-orders" },
            { path: "/expenses", permission: "/expenses" },
            { path: "/billing", permission: "/billing" },
            { path: "/roles", permission: "/roles" },
            { path: "/users", permission: "/users" },
            { path: "/food-categories", permission: "/food-categories" },
            { path: "/food-items", permission: "/food-items" },
            { path: "/account", permission: "/account" },
            { path: "/package", permission: "/package" },
            { path: "/report", permission: "/report" },
            { path: "/guestprofiles", permission: "/guestprofiles" },
            { path: "/user-history", permission: "/user-history" },
            { path: "/employee-management", permission: "/employee-management" },
            // Add other routes as needed
          ];

          if (role === 'admin') {
            navigate("/dashboard", { replace: true });
            return;
          }

          // Find the first route user has access to
          const allowedRoute = routes.find(r => permissions.includes(r.permission));

          if (allowedRoute) {
            navigate(allowedRoute.path, { replace: true });
          } else {
            // Fallback if no specific permissions match (e.g. maybe just profile access)
            // or show a "No Access" message. For now, try dashboard which might show 403/Forbidden if protected properly,
            // or maybe better to stay here and show an error.
            // Let's default to dashboard but it might be blank.
            console.warn("No specific route permissions found. Defaulting to Dashboard.");
            navigate("/dashboard", { replace: true });
          }
        } catch (decodeError) {
          console.error("Token decode error:", decodeError);
          navigate("/dashboard", { replace: true });
        }
      } else {
        alert("Login failed: No token received from server.");
      }
    } catch (err) {
      console.error("Login error:", err);
      const errorMessage = err.response?.data?.detail || err.message || "Login failed. Please check your credentials.";
      alert(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="relative min-h-screen flex items-center justify-center overflow-hidden p-4">
      {/* Natural Green Gradient Background */}
      <div className="absolute inset-0 animate-gradient bg-gradient-to-br from-emerald-50 via-green-50 to-teal-50"></div>

      {/* Floating natural particles */}
      <div className="absolute inset-0 overflow-hidden">
        {[...Array(15)].map((_, i) => (
          <div
            key={i}
            className="absolute w-10 h-10 bg-emerald-200/30 rounded-full animate-float"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${Math.random() * 5}s`,
              animationDuration: `${5 + Math.random() * 10}s`,
            }}
          ></div>
        ))}
      </div>

      {/* Login Card */}
      <div className="relative z-10 w-full max-w-md bg-white/95 backdrop-blur-lg rounded-2xl shadow-2xl p-6 sm:p-8 space-y-6 border border-emerald-100/50">
        <div className="flex justify-center mb-6">
          <div className="relative">
            <div className="absolute inset-0 bg-emerald-100/30 rounded-full blur-xl"></div>
            <div className="relative bg-gradient-to-br from-emerald-50 to-green-50 p-4 rounded-2xl shadow-lg border border-emerald-200/50">
              <img
                src={pommaLogo}
                alt="Pomma Holidays Logo"
                className="h-28 md:h-32 w-auto object-contain drop-shadow-lg"
              />
            </div>
          </div>
        </div>
        <p className="text-center text-emerald-700 text-sm sm:text-base font-medium">Sign in to your account</p>

        <form className="space-y-4" onSubmit={handleLogin}>
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">
              Email / Username
            </label>
            <input
              type="text"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-400 focus:border-emerald-400 focus:outline-none transition-colors"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">
              Password
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-400 focus:border-emerald-400 focus:outline-none transition-colors"
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-gradient-to-r from-emerald-500 to-green-600 hover:from-emerald-600 hover:to-green-700 text-white font-semibold py-2 px-4 rounded-lg shadow-lg transition-all duration-300 transform hover:scale-[1.02] active:scale-[0.98]"
          >
            {loading ? "Signing in..." : "Sign In"}
          </button>
        </form>

        <div className="text-center text-sm text-gray-500">
          © 2025 Your Business. All rights reserved.
        </div>
      </div>

      {/* Tailwind animations */}
      <style>
        {`
          @keyframes gradient-bg {
            0%,100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
          }
          .animate-gradient {
            background-size: 200% 200%;
            animation: gradient-bg 15s ease infinite;
          }

          @keyframes float {
            0% { transform: translateY(0) translateX(0) rotate(0deg); opacity:0.5; }
            50% { transform: translateY(-50px) translateX(20px) rotate(180deg); opacity:0.2; }
            100% { transform: translateY(0) translateX(0) rotate(360deg); opacity:0.5; }
          }
          .animate-float {
            animation-name: float;
            animation-timing-function: ease-in-out;
            animation-iteration-count: infinite;
          }
        `}
      </style>
    </div>
  );
}
