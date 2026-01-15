import React, { useEffect, useState } from "react";
import DashboardLayout from "../layout/DashboardLayout";
import api from "../services/api";
import {
  PieChart, Pie, Cell, Tooltip, Legend,
  BarChart, Bar, XAxis, YAxis, CartesianGrid, ResponsiveContainer
} from "recharts";
import { Loader2 } from "lucide-react";
import { getMediaBaseUrl } from "../utils/env";

// Reusable card component for a consistent look
const Card = ({ title, className = "", children }) => (
  <div className={`bg-white rounded-2xl shadow-lg border border-gray-200 p-6 ${className}`}>
    <h2 className="text-xl font-bold text-gray-800 mb-4">{title}</h2>
    {children}
  </div>
);

import Modal from "../components/Modal";

const COLORS = ["#4F46E5", "#6366F1", "#A78BFA", "#F472B6"];

const Services = () => {
  const [services, setServices] = useState([]);
  const [assignedServices, setAssignedServices] = useState([]);
  const [form, setForm] = useState({ name: "", description: "", charges: "" });
  const [editingService, setEditingService] = useState(null); // New state for editing
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [isAssignModalOpen, setIsAssignModalOpen] = useState(false);
  const [selectedImages, setSelectedImages] = useState([]);
  const [imagePreviews, setImagePreviews] = useState([]);
  const [assignForm, setAssignForm] = useState({
    service_id: "",
    employee_id: "",
    room_id: "",
    status: "pending",
  });
  const [rooms, setRooms] = useState([]);
  const [allRooms, setAllRooms] = useState([]);
  const [bookings, setBookings] = useState([]);
  const [employees, setEmployees] = useState([]);
  const [filters, setFilters] = useState({
    room: "",
    employee: "",
    status: "",
    from: "",
    to: "",
  });
  const [loading, setLoading] = useState(true);
  const [hasMore, setHasMore] = useState(true);
  const [page, setPage] = useState(1);
  const [isFetchingMore, setIsFetchingMore] = useState(false);
  const [createSuccess, setCreateSuccess] = useState("");
  const [assignSuccess, setAssignSuccess] = useState("");
  const [createError, setCreateError] = useState("");
  const [assignError, setAssignError] = useState("");

  // Fetch all data
  const fetchAll = async () => {
    setLoading(true);
    try {
      const [sRes, aRes, rRes, eRes, bRes, pbRes] = await Promise.all([
        api.get("/services?limit=1000"),
        api.get("/services/assigned?skip=0&limit=20"),
        api.get("/rooms?limit=1000"),
        api.get("/employees"),
        api.get("/bookings?limit=1000").catch(() => ({ data: { bookings: [] } })),
        api.get("/packages/bookingsall?limit=1000").catch(() => ({ data: [] })),
      ]);
      setServices(sRes.data);
      setAssignedServices(aRes.data);
      setAllRooms(rRes.data);
      setEmployees(eRes.data);

      // Combine regular and package bookings
      const regularBookings = bRes.data?.bookings || [];
      const packageBookings = (pbRes.data || []).map(pb => ({ ...pb, is_package: true }));
      setBookings([...regularBookings, ...packageBookings]);

      // Filter rooms to only show checked-in rooms
      const today = new Date();
      today.setHours(0, 0, 0, 0); // Set to start of day for comparison
      const checkedInRoomIds = new Set();

      // Helper function to normalize status (handle all variations)
      const normalizeStatus = (status) => {
        if (!status) return '';
        return status.toLowerCase().replace(/[-_\s]/g, '');
      };

      // Helper function to check if status is checked-in
      const isCheckedIn = (status) => {
        const normalized = normalizeStatus(status);
        return normalized === 'checkedin';
      };

      // Get room IDs from checked-in regular bookings
      regularBookings.forEach(booking => {
        console.log(`Checking regular booking ${booking.id}, status: ${booking.status}, rooms:`, booking.rooms);
        if (isCheckedIn(booking.status)) {
          // Parse dates properly
          const checkInDate = new Date(booking.check_in);
          const checkOutDate = new Date(booking.check_out);
          checkInDate.setHours(0, 0, 0, 0);
          checkOutDate.setHours(0, 0, 0, 0);

          // Check if booking is active (today is between check-in and check-out)
          // Also allow if check-out is today (room is still checked in)
          if (checkInDate <= today && checkOutDate >= today) {
            if (booking.rooms && Array.isArray(booking.rooms)) {
              booking.rooms.forEach(room => {
                if (room && room.id) {
                  checkedInRoomIds.add(room.id);
                  console.log(`Added checked-in room: ${room.number} (ID: ${room.id}) from booking ${booking.id}, status: ${booking.status}`);
                } else {
                  console.log(`Booking ${booking.id} room missing id:`, room);
                }
              });
            } else {
              console.log(`Booking ${booking.id} has checked-in status but no rooms array or rooms is not an array`);
            }
          } else {
            console.log(`Booking ${booking.id} is checked-in but dates don't match: check_in=${checkInDate}, check_out=${checkOutDate}, today=${today}`);
          }
        } else {
          console.log(`Regular booking ${booking.id} status '${booking.status}' is not checked-in (normalized: '${normalizeStatus(booking.status)}')`);
        }
      });

      // Get room IDs from checked-in package bookings
      // Note: Package bookings have rooms as PackageBookingRoomOut objects with a nested 'room' property
      packageBookings.forEach(booking => {
        console.log(`Checking package booking ${booking.id}, status: ${booking.status}, rooms:`, booking.rooms);
        if (isCheckedIn(booking.status)) {
          // Parse dates properly
          const checkInDate = new Date(booking.check_in);
          const checkOutDate = new Date(booking.check_out);
          checkInDate.setHours(0, 0, 0, 0);
          checkOutDate.setHours(0, 0, 0, 0);

          // Check if booking is active (today is between check-in and check-out)
          // Also allow if check-out is today (room is still checked in)
          if (checkInDate <= today && checkOutDate >= today) {
            if (booking.rooms && Array.isArray(booking.rooms)) {
              booking.rooms.forEach(roomLink => {
                // Package bookings have rooms as PackageBookingRoomOut objects
                // The actual room is nested in roomLink.room
                const room = roomLink.room || roomLink;
                if (room && room.id) {
                  checkedInRoomIds.add(room.id);
                  console.log(`Added checked-in package room: ${room.number} (ID: ${room.id}) from booking ${booking.id}, status: ${booking.status}`);
                } else {
                  console.log(`Package booking ${booking.id} room link missing room data:`, roomLink);
                }
              });
            } else {
              console.log(`Package booking ${booking.id} has checked-in status but no rooms array`);
            }
          } else {
            console.log(`Package booking ${booking.id} is checked-in but dates don't match: check_in=${checkInDate}, check_out=${checkOutDate}, today=${today}`);
          }
        } else {
          console.log(`Package booking ${booking.id} status '${booking.status}' is not checked-in (normalized: '${normalizeStatus(booking.status)}')`);
        }
      });

      // Also check room status directly as a fallback (in case booking status is not set correctly)
      rRes.data.forEach(room => {
        const roomStatusNormalized = normalizeStatus(room.status);
        if (roomStatusNormalized === 'checkedin') {
          checkedInRoomIds.add(room.id);
          console.log(`Added checked-in room from room status: ${room.number} (ID: ${room.id}), status: ${room.status}`);
        }
      });

      console.log(`Total checked-in room IDs: ${checkedInRoomIds.size}`, Array.from(checkedInRoomIds));

      // Filter rooms to only show checked-in rooms
      const checkedInRooms = rRes.data.filter(room => checkedInRoomIds.has(room.id));
      console.log(`Filtered checked-in rooms: ${checkedInRooms.length}`, checkedInRooms.map(r => `${r.number} (status: ${r.status})`));
      setRooms(checkedInRooms);
    } catch (error) {
      setHasMore(aRes.data.length === 10);
      setPage(1);
      console.error("Error fetching data:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAll();
  }, []);

  const loadMoreAssigned = async () => {
    if (isFetchingMore || !hasMore) return;
    setIsFetchingMore(true);
    const nextPage = page + 1;
    try {
      const res = await api.get(`/services/assigned?skip=${(nextPage - 1) * 20}&limit=20`);
      const newAssigned = res.data || [];
      setAssignedServices(prev => [...prev, ...newAssigned]);
      setPage(nextPage);
      setHasMore(newAssigned.length === 20);
    } catch (err) {
      console.error("Failed to load more assigned services:", err);
    } finally {
      setIsFetchingMore(false);
    }
  };

  // Handle image selection
  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    setSelectedImages(files);
    // Create preview URLs
    const previews = files.map(file => URL.createObjectURL(file));
    setImagePreviews(previews);
  };

  // Helper function to get image URL
  const getImageUrl = (imagePath) => {
    if (!imagePath) return '';
    if (imagePath.startsWith('http')) return imagePath;
    const baseUrl = getMediaBaseUrl();
    const path = imagePath.startsWith('/') ? imagePath : `/${imagePath}`;
    return `${baseUrl}${path}`;
  };

  // Create or Update service
  const handleSubmit = async () => {
    if (!form.name || !form.description || !form.charges) {
      setCreateError("All fields are required");
      setTimeout(() => setCreateError(""), 3000);
      return;
    }
    try {
      const formData = new FormData();
      formData.append('name', form.name);
      formData.append('description', form.description);
      formData.append('charges', parseFloat(form.charges));

      // Append images
      selectedImages.forEach((image) => {
        formData.append('images', image);
      });

      if (editingService) {
        // Update existing service
        await api.put(`/services/${editingService.id}`, formData, {
          headers: { 'Content-Type': 'multipart/form-data' },
        });
        setCreateSuccess("Service updated successfully! ✨");
      } else {
        // Create new service
        await api.post("/services", formData, {
          headers: { 'Content-Type': 'multipart/form-data' },
        });
        setCreateSuccess("Service created successfully! ✨");
      }

      setForm({ name: "", description: "", charges: "" });
      setSelectedImages([]);
      setImagePreviews([]);
      setEditingService(null); // Reset editing state
      setIsCreateModalOpen(false); // Close modal
      fetchAll();
      setTimeout(() => setCreateSuccess(""), 3000);
    } catch (err) {
      console.error("Failed to save service", err);
      setCreateError("Failed to save service. Please try again.");
      setTimeout(() => setCreateError(""), 3000);
    }
  };

  // Handle Edit Click
  const handleEdit = (service) => {
    setEditingService(service);
    setForm({
      name: service.name,
      description: service.description,
      charges: service.charges
    });
    // Optionally populate image previews if needed, but for now we start fresh for uploads
    // Or show existing images separately
    setIsCreateModalOpen(true); // Open modal
  };

  // Handle Delete Click
  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this service?")) {
      try {
        await api.delete(`/services/${id}`);
        fetchAll();
      } catch (err) {
        console.error("Failed to delete service", err);
        alert("Failed to delete service.");
      }
    }
  };

  const handleCancelEdit = () => {
    setEditingService(null);
    setForm({ name: "", description: "", charges: "" });
    setSelectedImages([]);
    setImagePreviews([]);
    setIsCreateModalOpen(false);
  };

  const openCreateModal = () => {
    setEditingService(null);
    setForm({ name: "", description: "", charges: "" });
    setSelectedImages([]);
    setImagePreviews([]);
    setIsCreateModalOpen(true);
  };

  // Assign service
  const handleAssign = async () => {
    if (!assignForm.service_id || !assignForm.employee_id || !assignForm.room_id) {
      setAssignError("Please select service, employee, and room");
      setTimeout(() => setAssignError(""), 3000);
      return;
    }
    try {
      await api.post("/services/assign", {
        ...assignForm,
        service_id: parseInt(assignForm.service_id),
        employee_id: parseInt(assignForm.employee_id),
        room_id: parseInt(assignForm.room_id),
      });
      setAssignForm({ service_id: "", employee_id: "", room_id: "", status: "pending" });
      fetchAll();
      setAssignSuccess("Service assigned successfully! ✅");
      setIsAssignModalOpen(false); // Close modal
      setTimeout(() => setAssignSuccess(""), 3000);
    } catch (err) {
      console.error("Failed to assign service", err);
      setAssignError("Failed to assign service. Please try again.");
      setTimeout(() => setAssignError(""), 3000);
    }
  };

  const handleStatusChange = async (id, newStatus) => {
    try {
      await api.patch(`/services/assigned/${id}`, { status: newStatus });
      fetchAll();
    } catch (error) {
      console.error("Failed to update status:", error);
    }
  };

  const filteredAssigned = assignedServices.filter((s) => {
    const assignedDate = new Date(s.assigned_at);
    const fromDate = filters.from ? new Date(filters.from) : null;
    const toDate = filters.to ? new Date(filters.to) : null;
    return (
      (!filters.room || s.room_id === parseInt(filters.room)) &&
      (!filters.employee || s.employee_id === parseInt(filters.employee)) &&
      (!filters.status || s.status === filters.status) &&
      (!fromDate || assignedDate >= fromDate) &&
      (!toDate || assignedDate <= toDate)
    );
  });

  const totalServices = services.length;
  const totalAssigned = assignedServices.length;
  const completedCount = assignedServices.filter(s => s.status === "completed").length;
  const pendingCount = assignedServices.filter(s => s.status === "pending").length;
  const cancelledCount = assignedServices.filter(s => s.status === "cancelled").length;
  const inProgressCount = assignedServices.filter(s => s.status === "in_progress").length;

  // Pie chart for status
  const pieData = [
    { name: "Pending", value: pendingCount },
    { name: "Completed", value: completedCount },
    { name: "In Progress", value: inProgressCount },
    { name: "Cancelled", value: cancelledCount },
  ];

  // Bar chart for service assignments
  const barData = services.map(s => ({
    name: s.name,
    assigned: assignedServices.filter(a => a.service_id === s.id).length,
  }));

  return (
    <DashboardLayout>
      <div className="p-6 space-y-6">
        <h2 className="text-3xl font-bold text-gray-800 mb-4">Service Management Dashboard</h2>

        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div className="bg-gradient-to-r from-indigo-500 to-indigo-700 text-white p-6 rounded-xl shadow-lg flex flex-col items-center justify-center">
            <p className="text-sm opacity-80">Total Services</p>
            <p className="text-3xl font-bold">{totalServices}</p>
          </div>
          <div className="bg-gradient-to-r from-green-500 to-green-700 text-white p-6 rounded-xl shadow-lg flex flex-col items-center justify-center">
            <p className="text-sm opacity-80">Total Assigned</p>
            <p className="text-3xl font-bold">{totalAssigned}</p>
          </div>
          <div className="bg-gradient-to-r from-yellow-400 to-yellow-600 text-white p-6 rounded-xl shadow-lg flex flex-col items-center justify-center">
            <p className="text-sm opacity-80">Pending</p>
            <p className="text-3xl font-bold">{pendingCount}</p>
          </div>
          <div className="bg-gradient-to-r from-purple-500 to-purple-700 text-white p-6 rounded-xl shadow-lg flex flex-col items-center justify-center">
            <p className="text-sm opacity-80">Completed</p>
            <p className="text-3xl font-bold">{completedCount}</p>
          </div>
        </div>

        {/* Create & Assign Forms */}
        {/* Create & Assign Buttons */}
        <div className="flex flex-col md:flex-row gap-4">
          <button
            onClick={openCreateModal}
            className="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white p-4 rounded-xl shadow-lg font-bold text-lg transition-transform transform hover:-translate-y-1 flex items-center justify-center gap-2"
          >
            ➕ Create New Service
          </button>
          <button
            onClick={() => setIsAssignModalOpen(true)}
            className="flex-1 bg-green-600 hover:bg-green-700 text-white p-4 rounded-xl shadow-lg font-bold text-lg transition-transform transform hover:-translate-y-1 flex items-center justify-center gap-2"
          >
            📋 Assign Service
          </button>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <Card title="Service Status Distribution">
            <ResponsiveContainer width="100%" height={250}>
              <PieChart>
                <Pie data={pieData} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80} label>
                  {pieData.map((entry, index) => (
                    <Cell key={index} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </Card>

          <Card title="Service Assignments">
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={barData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis allowDecimals={false} />
                <Tooltip />
                <Legend />
                <Bar dataKey="assigned" fill="#4F46E5" />
              </BarChart>
            </ResponsiveContainer>
          </Card>
        </div>

        {/* View All Services Table */}
        <Card title="All Services">
          {loading ? (
            <div className="flex justify-center items-center h-48">
              <Loader2 size={48} className="animate-spin text-indigo-500" />
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full border border-gray-200 rounded-lg">
                <thead className="bg-gray-100 text-gray-700 uppercase tracking-wider">
                  <tr>
                    <th className="py-3 px-4 text-left">Image</th>
                    <th className="py-3 px-4 text-left">Service Name</th>
                    <th className="py-3 px-4 text-left">Description</th>
                    <th className="py-3 px-4 text-right">Charges ($)</th>
                    <th className="py-3 px-4 text-center">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {services.map((s, idx) => (
                    <tr key={s.id} className={`${idx % 2 === 0 ? "bg-white" : "bg-gray-50"} hover:bg-gray-100 transition-colors`}>
                      <td className="py-3 px-4">
                        {s.images && s.images.length > 0 ? (
                          <img src={getImageUrl(s.images[0].image_url)} alt={s.name} className="w-16 h-16 object-cover rounded border" />
                        ) : (
                          <div className="w-16 h-16 bg-gray-200 rounded border flex items-center justify-center text-xs text-gray-400">No Image</div>
                        )}
                      </td>
                      <td className="py-3 px-4">{s.name}</td>
                      <td className="py-3 px-4">{s.description}</td>
                      <td className="py-3 px-4 text-right">{s.charges}</td>
                      <td className="py-3 px-4 text-center space-x-2">
                        <button
                          onClick={() => handleEdit(s)}
                          className="text-blue-600 hover:text-blue-800"
                          title="Edit"
                        >
                          ✏️
                        </button>
                        <button
                          onClick={() => handleDelete(s.id)}
                          className="text-red-600 hover:text-red-800"
                          title="Delete"
                        >
                          🗑️
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
              {hasMore && (
                <div className="text-center mt-4">
                  <button
                    onClick={loadMoreAssigned}
                    disabled={isFetchingMore}
                    className="bg-indigo-100 text-indigo-700 font-semibold px-6 py-2 rounded-lg hover:bg-indigo-200 transition-colors disabled:bg-gray-200 disabled:text-gray-500"
                  >
                    {isFetchingMore ? "Loading..." : "Load More"}
                  </button>
                </div>
              )}
            </div>
          )}
        </Card>

        {/* Filters & Assigned Services Table */}
        <Card title="Assigned Services">
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4 mb-4">
            <select value={filters.room} onChange={(e) => setFilters({ ...filters, room: e.target.value })} className="border p-2 rounded-lg">
              <option value="">All Rooms</option>
              {Array.from(new Map(assignedServices.map(s => [s.room?.id, s.room])).values())
                .filter(room => room) // filter out undefined/null rooms
                .sort((a, b) => a.number - b.number) // optional: sort by room number
                .map((room) => (
                  <option key={room.id} value={room.id}>Room {room.number}</option>
                ))}
            </select>
            <select value={filters.employee} onChange={(e) => setFilters({ ...filters, employee: e.target.value })} className="border p-2 rounded-lg">
              <option value="">All Employees</option>
              {employees.map((e) => (<option key={e.id} value={e.id}>{e.name}</option>))}
            </select>
            <select value={filters.status} onChange={(e) => setFilters({ ...filters, status: e.target.value })} className="border p-2 rounded-lg">
              <option value="">All Statuses</option>
              <option value="pending">Pending</option>
              <option value="in_progress">In Progress</option>
              <option value="completed">Completed</option>
              <option value="cancelled">Cancelled</option>
            </select>
            <input type="date" value={filters.from} onChange={(e) => setFilters({ ...filters, from: e.target.value })} className="border p-2 rounded-lg" />
            <input type="date" value={filters.to} onChange={(e) => setFilters({ ...filters, to: e.target.value })} className="border p-2 rounded-lg" />
          </div>
          {loading ? (
            <div className="flex justify-center items-center h-48">
              <Loader2 size={48} className="animate-spin text-indigo-500" />
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full border border-gray-200 rounded-lg">
                <thead className="bg-gray-100 text-gray-700 uppercase tracking-wider">
                  <tr>
                    <th className="py-3 px-4 text-left">Service</th>
                    <th className="py-3 px-4 text-left">Employee</th>
                    <th className="py-3 px-4 text-left">Room</th>
                    <th className="py-3 px-4 text-left">Status</th>
                    <th className="py-3 px-4 text-left">Assigned At</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredAssigned.map((s, idx) => (
                    <tr key={s.id} className={`${idx % 2 === 0 ? "bg-white" : "bg-gray-50"} hover:bg-gray-100 transition-colors`}>
                      <td className="p-3 border-t border-gray-200">{s.service?.name}</td>
                      <td className="p-3 border-t border-gray-200">{s.employee?.name}</td>
                      <td className="p-3 border-t border-gray-200">Room {s.room?.number}</td>
                      <td className="p-3 border-t border-gray-200">
                        <select value={s.status} onChange={(e) => handleStatusChange(s.id, e.target.value)} className="border p-2 rounded-lg bg-white">
                          <option value="pending">Pending</option>
                          <option value="in_progress">In Progress</option>
                          <option value="completed">Completed</option>
                          <option value="cancelled">Cancelled</option>
                        </select>
                      </td>
                      <td className="p-3 border-t border-gray-200">
                        {s.assigned_at && (() => {
                          const dateStr = s.assigned_at.endsWith('Z') ? s.assigned_at : `${s.assigned_at}Z`;
                          return new Date(dateStr).toLocaleString();
                        })()}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Card>
      </div>

      {/* Modal for Create/Edit Service */}
      <Modal
        isOpen={isCreateModalOpen}
        title={editingService ? "Edit Service" : "Create New Service"}
        onClose={handleCancelEdit}
      >
        {createSuccess && (
          <div className="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4 text-center">
            <span className="block sm:inline">{createSuccess}</span>
          </div>
        )}
        {createError && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4 text-center">
            <span className="block sm:inline">{createError}</span>
          </div>
        )}
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Service Name</label>
            <input
              type="text"
              placeholder="e.g. Spa Treatment"
              value={form.name}
              onChange={(e) => setForm({ ...form, name: e.target.value })}
              className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-indigo-400 focus:border-indigo-400 transition-colors"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
            <textarea
              placeholder="Describe the service details..."
              value={form.description}
              onChange={(e) => setForm({ ...form, description: e.target.value })}
              className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-indigo-400 focus:border-indigo-400 transition-colors rows-3"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Charges ($)</label>
            <input
              type="number"
              placeholder="0.00"
              value={form.charges}
              onChange={(e) => setForm({ ...form, charges: e.target.value })}
              className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-indigo-400 focus:border-indigo-400 transition-colors"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Service Images</label>
            <div className="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center hover:bg-gray-50 transition-colors cursor-pointer relative">
              <input
                type="file"
                multiple
                accept="image/*"
                onChange={handleImageChange}
                className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
              />
              <div className="text-gray-500">
                <p className="text-sm font-medium">Click to upload or drag and drop</p>
                <p className="text-xs mt-1">PNG, JPG, GIF max 5MB</p>
              </div>
            </div>
            {imagePreviews.length > 0 && (
              <div className="grid grid-cols-4 gap-2 mt-4">
                {imagePreviews.map((preview, idx) => (
                  <div key={idx} className="relative group">
                    <img src={preview} alt={`Preview ${idx + 1}`} className="w-full h-20 object-cover rounded-lg border shadow-sm" />
                    <div className="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-20 transition-opacity rounded-lg" />
                  </div>
                ))}
              </div>
            )}
          </div>
          <button
            onClick={handleSubmit}
            className={`w-full mt-4 text-white p-3 rounded-lg shadow-md font-semibold transition-transform transform active:scale-95 ${editingService ? "bg-yellow-600 hover:bg-yellow-700" : "bg-indigo-600 hover:bg-indigo-700"}`}
          >
            {editingService ? "Update Service" : "Create Service"}
          </button>
        </div>
      </Modal>

      {/* Modal for Assign Service */}
      <Modal
        isOpen={isAssignModalOpen}
        title="Assign Service"
        onClose={() => setIsAssignModalOpen(false)}
      >
        {assignSuccess && (
          <div className="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4 text-center">
            <span className="block sm:inline">{assignSuccess}</span>
          </div>
        )}
        {assignError && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4 text-center">
            <span className="block sm:inline">{assignError}</span>
          </div>
        )}
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Service</label>
            <select
              value={assignForm.service_id}
              onChange={(e) => setAssignForm({ ...assignForm, service_id: e.target.value })}
              className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-green-400 focus:border-green-400 transition-colors"
            >
              <option value="">Select Service</option>
              {services.map((s) => (
                <option key={s.id} value={s.id}>{s.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Employee</label>
            <select
              value={assignForm.employee_id}
              onChange={(e) => setAssignForm({ ...assignForm, employee_id: e.target.value })}
              className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-green-400 focus:border-green-400 transition-colors"
            >
              <option value="">Select Employee</option>
              {employees.map((e) => (
                <option key={e.id} value={e.id}>{e.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Room</label>
            <select
              value={assignForm.room_id}
              onChange={(e) => setAssignForm({ ...assignForm, room_id: e.target.value })}
              className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-green-400 focus:border-green-400 transition-colors"
            >
              <option value="">Select Room</option>
              {rooms.length === 0 ? (
                <option value="" disabled>No checked-in rooms available</option>
              ) : (
                rooms.map((r) => (
                  <option key={r.id} value={r.id}>Room {r.number}</option>
                ))
              )}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Initial Status</label>
            <select
              value={assignForm.status}
              onChange={(e) => setAssignForm({ ...assignForm, status: e.target.value })}
              className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-green-400 focus:border-green-400 transition-colors"
            >
              <option value="pending">Pending</option>
              <option value="in_progress">In Progress</option>
              <option value="completed">Completed</option>
            </select>
          </div>
          <button
            onClick={handleAssign}
            className="w-full mt-4 bg-green-600 hover:bg-green-700 text-white p-3 rounded-lg shadow-md font-semibold transition-transform transform active:scale-95"
          >
            Assign Service
          </button>
        </div>
      </Modal>

    </DashboardLayout>
  );
};

export default Services;
