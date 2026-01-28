import React, { useState, useEffect } from "react";
import { formatCurrency } from '../utils/currency';
import DashboardLayout from "../layout/DashboardLayout";
import BannerMessage from "../components/BannerMessage";
import API from "../services/api";
import { LineChart, Line, ResponsiveContainer, Tooltip as RechartsTooltip } from "recharts";
import { toast } from "react-hot-toast";
import { motion } from "framer-motion";
import { getMediaBaseUrl } from "../utils/env";
import Modal from "../components/Modal";

// Get the correct base URL based on environment
const getImageUrl = (imageUrl) => {
  if (!imageUrl) return 'https://placehold.co/400x300/e2e8f0/a0aec0?text=No+Image';
  if (imageUrl.startsWith('http')) return imageUrl; // Already a full URL
  const baseUrl = getMediaBaseUrl();
  const normalized = imageUrl.startsWith('/') ? imageUrl : `/${imageUrl}`;
  return `${baseUrl}${normalized}`;
};

// KPI Card for quick stats
const KpiCard = ({ title, value, icon, color }) => (
  <div className={`p-4 sm:p-6 rounded-xl sm:rounded-2xl text-white shadow-lg flex items-center justify-between transition-transform duration-300 transform hover:scale-105 ${color}`}>
    <div>
      <h4 className="text-sm sm:text-base md:text-lg font-medium">{title}</h4>
      <p className="text-xl sm:text-2xl md:text-3xl font-bold mt-1">{value}</p>
    </div>
    <div className="text-2xl sm:text-3xl md:text-4xl opacity-80">{icon}</div>
  </div>
);

// Booking Modal for displaying booking data in table format
const BookingModal = ({ onClose, roomNumber, bookings, filter, setFilter, checkinFilter, setCheckinFilter, checkoutFilter, setCheckoutFilter }) => {
  // Apply filters to bookings
  const filteredBookings = bookings.filter(booking => {
    // Status filter
    const statusMatch = filter === "all" || booking.status === filter;

    // Check-in date filter
    const checkinMatch = !checkinFilter || booking.check_in === checkinFilter;

    // Check-out date filter
    const checkoutMatch = !checkoutFilter || booking.check_out === checkoutFilter;

    return statusMatch && checkinMatch && checkoutMatch;
  });

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50 p-2 sm:p-4">
      <div className="bg-white p-4 sm:p-6 rounded-xl sm:rounded-2xl shadow-lg relative max-w-5xl w-full max-h-[90vh] sm:max-h-[80vh] overflow-hidden">
        <button
          onClick={onClose}
          className="absolute top-2 sm:top-4 right-2 sm:right-4 text-gray-500 hover:text-gray-800 text-2xl font-bold z-10 w-8 h-8 flex items-center justify-center"
        >
          &times;
        </button>
        <div className="pr-10 sm:pr-12 mb-3 sm:mb-4">
          <h3 className="text-lg sm:text-xl md:text-2xl font-bold mb-3 sm:mb-4">
            Booking History for Room {roomNumber}
          </h3>
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2 sm:gap-3">
            <div className="flex flex-col">
              <label className="text-xs font-medium text-gray-700 mb-1">Filter by Status:</label>
              <select
                value={filter}
                onChange={(e) => setFilter(e.target.value)}
                className="px-3 py-2 text-sm border border-gray-300 rounded-lg focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
              >
                <option value="all">All</option>
                <option value="booked">Booked</option>
                <option value="checked-in">Checked In</option>
                <option value="cancelled">Cancelled</option>
              </select>
            </div>
            <div className="flex flex-col">
              <label className="text-xs font-medium text-gray-700 mb-1">Check-in Date:</label>
              <input
                type="date"
                value={checkinFilter}
                onChange={(e) => setCheckinFilter(e.target.value)}
                className="px-3 py-2 text-sm border border-gray-300 rounded-lg focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
              />
            </div>
            <div className="flex flex-col">
              <label className="text-xs font-medium text-gray-700 mb-1">Check-out Date:</label>
              <input
                type="date"
                value={checkoutFilter}
                onChange={(e) => setCheckoutFilter(e.target.value)}
                className="px-3 py-2 text-sm border border-gray-300 rounded-lg focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
              />
            </div>
          </div>
        </div>
        {filteredBookings.length > 0 ? (
          <div className="overflow-x-auto overflow-y-auto max-h-[60vh] -mx-2 sm:mx-0">
            <table className="w-full border-collapse border border-gray-300 text-xs sm:text-sm">
              <thead className="bg-gray-50 sticky top-0">
                <tr>
                  <th className="border border-gray-300 px-2 sm:px-4 py-2 text-left text-xs sm:text-sm font-semibold">ID</th>
                  <th className="border border-gray-300 px-2 sm:px-4 py-2 text-left text-xs sm:text-sm font-semibold hidden sm:table-cell">Guest</th>
                  <th className="border border-gray-300 px-2 sm:px-4 py-2 text-left text-xs sm:text-sm font-semibold hidden lg:table-cell">Check-in</th>
                  <th className="border border-gray-300 px-2 sm:px-4 py-2 text-left text-xs sm:text-sm font-semibold">Check-out</th>
                  <th className="border border-gray-300 px-2 sm:px-4 py-2 text-left text-xs sm:text-sm font-semibold hidden md:table-cell">Guests</th>
                  <th className="border border-gray-300 px-2 sm:px-4 py-2 text-left text-xs sm:text-sm font-semibold">Status</th>
                  <th className="border border-gray-300 px-2 sm:px-4 py-2 text-left text-xs sm:text-sm font-semibold hidden lg:table-cell">Mobile</th>
                  <th className="border border-gray-300 px-2 sm:px-4 py-2 text-left text-xs sm:text-sm font-semibold hidden lg:table-cell">Email</th>
                </tr>
              </thead>
              <tbody>
                {filteredBookings.map((booking, index) => (
                  <tr key={booking.id || index} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                    <td className="border border-gray-300 px-2 sm:px-4 py-2 text-xs sm:text-sm">{booking.id}</td>
                    <td className="border border-gray-300 px-2 sm:px-4 py-2 text-xs sm:text-sm font-medium hidden sm:table-cell">{booking.guest_name}</td>
                    <td className="border border-gray-300 px-2 sm:px-4 py-2 text-xs sm:text-sm hidden lg:table-cell">{booking.check_in}</td>
                    <td className="border border-gray-300 px-2 sm:px-4 py-2 text-xs sm:text-sm">{booking.check_out}</td>
                    <td className="border border-gray-300 px-2 sm:px-4 py-2 text-xs sm:text-sm hidden md:table-cell">{booking.adults}A, {booking.children}C</td>
                    <td className="border border-gray-300 px-2 sm:px-4 py-2 text-xs sm:text-sm">
                      <span className={`px-2 py-1 rounded-full text-xs font-semibold ${booking.status === 'booked' ? 'bg-blue-100 text-blue-800' :
                        booking.status === 'checked-in' ? 'bg-green-100 text-green-800' :
                          booking.status === 'cancelled' ? 'bg-red-100 text-red-800' :
                            'bg-gray-100 text-gray-800'
                        }`}>
                        {booking.status || 'Pending'}
                      </span>
                    </td>
                    <td className="border border-gray-300 px-2 sm:px-4 py-2 text-xs sm:text-sm hidden lg:table-cell">{booking.guest_mobile}</td>
                    <td className="border border-gray-300 px-2 sm:px-4 py-2 text-xs sm:text-sm hidden lg:table-cell truncate max-w-[150px]">{booking.guest_email}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="text-center py-8 text-gray-500">
            <div className="text-4xl mb-4">📅</div>
            <p className="text-lg font-medium">No {filter !== 'all' ? filter : ''} bookings found for Room {roomNumber}</p>
            <p className="text-sm mt-2">Try changing the filter or this room has no booking history</p>
          </div>
        )}
      </div>
    </div>
  );
};

// Image Modal for viewing full room image
// Image Modal for viewing full room image gallery
const ImageModal = ({ room, onClose }) => {
  const [currentIndex, setCurrentIndex] = useState(0);

  // Construct images list: Legacy + Gallery
  const images = [];
  if (room.image_url) images.push(room.image_url);
  if (room.images && room.images.length > 0) {
    room.images.forEach(img => images.push(img.image_url));
  }

  // Auto-play
  useEffect(() => {
    if (images.length <= 1) return;
    const interval = setInterval(() => {
      setCurrentIndex(prev => (prev + 1) % images.length);
    }, 3000);
    return () => clearInterval(interval);
  }, [images.length]);

  if (!room || images.length === 0) return null;

  const nextImage = (e) => {
    e.stopPropagation();
    setCurrentIndex(prev => (prev + 1) % images.length);
  };

  const prevImage = (e) => {
    e.stopPropagation();
    setCurrentIndex(prev => (prev === 0 ? images.length - 1 : prev - 1));
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-80 flex justify-center items-center z-50 backdrop-blur-sm" onClick={onClose}>
      <div className="relative max-w-4xl w-full mx-4" onClick={e => e.stopPropagation()}>
        <button
          onClick={onClose}
          className="absolute -top-12 right-0 text-white text-3xl font-bold hover:text-gray-300 transition-colors z-[60]"
        >
          &times;
        </button>

        <div className="relative rounded-2xl overflow-hidden shadow-2xl bg-black">
          <img
            src={getImageUrl(images[currentIndex])}
            alt={`Room View ${currentIndex + 1}`}
            className="w-full h-auto max-h-[85vh] object-contain mx-auto"
          />

          {/* Navigation Arrows */}
          {images.length > 1 && (
            <>
              <button
                onClick={prevImage}
                className="absolute left-4 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white p-3 rounded-full transition-all"
              >
                <i className="fas fa-chevron-left text-xl"></i>
              </button>
              <button
                onClick={nextImage}
                className="absolute right-4 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white p-3 rounded-full transition-all"
              >
                <i className="fas fa-chevron-right text-xl"></i>
              </button>
            </>
          )}

          {/* Dots */}
          {images.length > 1 && (
            <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2 bg-black/50 px-3 py-2 rounded-full">
              {images.map((_, idx) => (
                <button
                  key={idx}
                  onClick={() => setCurrentIndex(idx)}
                  className={`w-2 h-2 rounded-full transition-all ${idx === currentIndex ? 'bg-white' : 'bg-white/40'}`}
                />
              ))}
            </div>
          )}
        </div>
        <p className="text-center text-white mt-4 text-lg font-medium">
          Room {room.number} - Image {currentIndex + 1} of {images.length}
        </p>
      </div>
    </div>
  );
};

const Rooms = () => {
  const [rooms, setRooms] = useState([]);
  const [form, setForm] = useState({
    number: "",
    type: "",
    priority: "",
    price: "",
    status: "Available",
    adults: 2,
    children: 0,
    breakfast: false,
    images: [], // Changed from image: null to images: []
  });
  const [previewImages, setPreviewImages] = useState([]);
  const [existingImages, setExistingImages] = useState([]); // For edit mode
  const [bannerMessage, setBannerMessage] = useState({ type: null, text: "" });
  const [bookings, setBookings] = useState([]);
  const [isEditing, setIsEditing] = useState(false);
  const [editRoomId, setEditRoomId] = useState(null);
  const [showBookingModal, setShowBookingModal] = useState(false);
  const [selectedRoomNumber, setSelectedRoomNumber] = useState(null);
  const [selectedRoomForGallery, setSelectedRoomForGallery] = useState(null);
  const [hasMore, setHasMore] = useState(true);
  const [isFetchingMore, setIsFetchingMore] = useState(false);
  const [page, setPage] = useState(1);
  const [filter, setFilter] = useState({ type: "all", status: "all" });
  const [bookingFilter, setBookingFilter] = useState("booked"); // Filter for booking modal
  const [bookingCheckinFilter, setBookingCheckinFilter] = useState(""); // Check-in date filter
  const [bookingCheckoutFilter, setBookingCheckoutFilter] = useState(""); // Check-out date filter
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Function to show banner message
  const showBannerMessage = (type, text) => {
    setBannerMessage({ type, text });
  };

  const closeBannerMessage = () => {
    setBannerMessage({ type: null, text: "" });
  };

  useEffect(() => {
    fetchRooms();
  }, []);

  const fetchRooms = async () => {
    try {
      const res = await API.get("/rooms/test?skip=0&limit=20");
      const dataWithTrend = res.data.map((r) => ({
        ...r,
        trend:
          r.trend ||
          Array.from({ length: 7 }, () => Math.floor(Math.random() * 1000)),
      }));
      setRooms(dataWithTrend || []);
      setHasMore(res.data.length === 20);
      setPage(1);
    } catch (error) {
      console.error("Error fetching rooms:", error);
      showBannerMessage("error", "Error fetching rooms");
    }
  };

  const loadMoreRooms = async () => {
    if (isFetchingMore || !hasMore) return; // Prevent multiple fetches
    setIsFetchingMore(true);
    try {
      const nextPage = page + 1;
      const res = await API.get(`/rooms?skip=${(nextPage - 1) * 20}&limit=20`);
      const newRooms = res.data || [];
      const dataWithTrend = newRooms.map((r) => ({ ...r, trend: Array.from({ length: 7 }, () => Math.floor(Math.random() * 1000)) }));
      setRooms(prev => [...prev, ...dataWithTrend]);
      setPage(nextPage);
      setHasMore(newRooms.length === 20);
    } catch (err) {
      console.error("Failed to load more rooms:", err);
    } finally {
      setIsFetchingMore(false);
    }
  };

  const fetchBookings = async (roomNumber) => {
    try {
      // Get all bookings and filter by room number
      const response = await API.get("/bookings?limit=20");
      const allBookings = response.data.bookings || [];

      // Filter bookings that include this room (all statuses)
      const roomBookings = allBookings.filter(booking => {
        const hasRoom = booking.rooms && booking.rooms.some(room => room.number === roomNumber);
        return hasRoom;
      });

      setBookings(roomBookings);
      setSelectedRoomNumber(roomNumber);
      setBookingFilter("booked"); // Reset to default filter
      setBookingCheckinFilter(""); // Reset check-in filter
      setBookingCheckoutFilter(""); // Reset check-out filter
      setShowBookingModal(true);
    } catch (error) {
      console.error("Error fetching bookings:", error);
      toast.error("Failed to fetch bookings.");
    }
  };

  const handleStatusChange = async (roomId, newStatus) => {
    try {
      const formData = new FormData();
      formData.append("status", newStatus);

      await API.put(`/rooms/${roomId}`, formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });

      showBannerMessage("success", `Room status updated to ${newStatus}!`);
      fetchRooms();
    } catch (err) {
      console.error("PUT /rooms error:", err);
      showBannerMessage("error", "Error updating room status");
    }
  };

  const handleChange = (e) => {
    const { name, value, files, type, checked } = e.target;
    if (name === "images") { // Changed from image to images
      if (files) {
        const newFiles = Array.from(files);
        const validFiles = [];
        const newPreviews = [];

        newFiles.forEach(file => {
          // Check size and type
          const maxSize = 50 * 1024 * 1024;
          if (file.size > maxSize) {
            toast.error(`File ${file.name} is too large (>50MB)`);
            return;
          }
          if (!['image/jpeg', 'image/jpg', 'image/png', 'image/webp'].includes(file.type)) {
            toast.error(`File ${file.name} has invalid type`);
            return;
          }
          validFiles.push(file);
          newPreviews.push(URL.createObjectURL(file));
        });

        setForm(prev => ({ ...prev, images: [...prev.images, ...validFiles] }));
        setPreviewImages(prev => [...prev, ...newPreviews]);
      }
    } else if (type === "checkbox") {
      setForm((prev) => ({ ...prev, [name]: checked }));
    } else {
      setForm((prev) => ({ ...prev, [name]: value }));
    }
  };

  const removeNewImage = (index) => {
    setForm(prev => {
      const newImages = [...prev.images];
      newImages.splice(index, 1);
      return { ...prev, images: newImages };
    });
    setPreviewImages(prev => {
      const newPreviews = [...prev];
      URL.revokeObjectURL(newPreviews[index]); // Cleanup
      newPreviews.splice(index, 1);
      return newPreviews;
    });
  };

  const removeExistingImage = async (imageId) => {
    if (!window.confirm("Are you sure you want to delete this image?")) return;
    try {
      if (imageId === 'legacy') {
        await API.delete(`/rooms/${editRoomId}/legacy-image`);
      } else {
        await API.delete(`/rooms/images/${imageId}`);
      }
      setExistingImages(prev => prev.filter(img => img.id !== imageId));
      toast.success("Image deleted");
      // Update main list if primary was deleted (simplified: just fetch rooms again)
      fetchRooms();
    } catch (err) {
      console.error(err);
      toast.error("Failed to delete image");
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);

    const formData = new FormData();
    formData.append("number", form.number);
    formData.append("type", form.type);
    if (form.priority) formData.append("priority", form.priority);
    formData.append("price", form.price);
    formData.append("status", form.status);
    formData.append("adults", form.adults);
    formData.append("children", form.children);
    formData.append("children", form.children);

    // Append multiple images
    if (form.images && form.images.length > 0) {
      form.images.forEach(image => {
        formData.append("images", image);
      });
    }

    // Append feature fields
    formData.append("air_conditioning", form.air_conditioning);
    formData.append("wifi", form.wifi);
    formData.append("bathroom", form.bathroom);
    formData.append("living_area", form.living_area);
    formData.append("terrace", form.terrace);
    formData.append("parking", form.parking);
    formData.append("kitchen", form.kitchen);
    formData.append("family_room", form.family_room);
    formData.append("bbq", form.bbq);
    formData.append("garden", form.garden);
    formData.append("dining", form.dining);
    formData.append("breakfast", form.breakfast);

    try {
      if (isEditing) {
        await API.put(`/rooms/${editRoomId}`, formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
        showBannerMessage("success", "Room updated successfully!");
        setIsEditing(false);
        setEditRoomId(null);
      } else {
        await API.post("/rooms/test", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
        showBannerMessage("success", "Room created successfully!");
      }

      setIsModalOpen(false);
      setForm({
        number: "",
        type: "",
        priority: "",
        price: "",
        status: "Available",
        adults: 2,
        children: 0,
        images: [],
        air_conditioning: false,
        wifi: false,
        bathroom: false,
        living_area: false,
        terrace: false,
        parking: false,
        kitchen: false,
        family_room: false,
        bbq: false,
        garden: false,
        dining: false,
        breakfast: false,
      });
      setPreviewImages([]);
      setExistingImages([]);
      fetchRooms();
    } catch (err) {
      console.error("Error submitting room:", err);
      showBannerMessage("error", `Error ${isEditing ? "updating" : "creating"} room`);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleEdit = (room) => {
    setIsEditing(true);
    setEditRoomId(room.id);
    setIsModalOpen(true);
    setForm({
      number: room.number,
      type: room.type,
      priority: room.priority || "",
      price: room.price,
      status: room.status,
      adults: room.adults,
      children: room.children,
      images: [], // Reset new images
      air_conditioning: room.air_conditioning || false,
      wifi: room.wifi || false,
      bathroom: room.bathroom || false,
      living_area: room.living_area || false,
      terrace: room.terrace || false,
      parking: room.parking || false,
      kitchen: room.kitchen || false,
      family_room: room.family_room || false,
      bbq: room.bbq || false,
      garden: room.garden || false,
      dining: room.dining || false,
      breakfast: room.breakfast || false,
    });
    // Set existing images from room data
    // Combine gallery images with legacy image_url if not already present
    let imgs = [...(room.images || [])];
    if (room.image_url) {
      // Check if primary image is already in gallery (by URL match)
      // Note: Backend might use relative paths, so we loosely match or rely on exact string
      const isPrimaryInGallery = imgs.some(img => img.image_url === room.image_url);

      if (!isPrimaryInGallery) {
        // Prepend legacy image so it appears first
        imgs.unshift({ id: 'legacy', image_url: room.image_url });
      }
    }
    setExistingImages(imgs);
    setPreviewImages([]);
    setBannerMessage({ type: null, text: "" });
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  const handleToggleDisable = (room) => {
    const newStatus = room.status === 'Disabled' ? 'Available' : 'Disabled';
    const action = newStatus === 'Disabled' ? 'disable' : 'enable';
    if (window.confirm(`Are you sure you want to ${action} this room?`)) {
      handleStatusChange(room.id, newStatus);
    }
  };

  // Calculate KPIs
  const totalRooms = rooms.length;
  const availableRooms = rooms.filter(r => r.status === 'Available').length;
  const occupiedRooms = rooms.filter(r => ['Booked', 'Occupied', 'Checked-in'].includes(r.status)).length;
  const maintenanceRooms = rooms.filter(r => r.status === 'Maintenance').length;
  const occupancyRate = totalRooms > 0 ? ((occupiedRooms / totalRooms) * 100).toFixed(1) : 0;

  // Filter rooms
  const filteredRooms = rooms.filter(room => {
    const typeMatch = filter.type === 'all' || room.type === filter.type;
    let statusMatch = false;

    if (filter.status === 'all') {
      statusMatch = true;
    } else if (filter.status === 'Booked') {
      // "Booked" filter should show all occupied-type statuses
      statusMatch = ['Booked', 'Occupied', 'Checked-in', 'booked', 'occupied', 'checked-in'].includes(room.status);
    } else {
      statusMatch = room.status === filter.status;
    }

    return typeMatch && statusMatch;
  });

  return (
    <DashboardLayout>
      <BannerMessage
        message={bannerMessage}
        onClose={closeBannerMessage}
        autoDismiss={true}
        duration={5000}
      />
      <h1 className="text-xl sm:text-2xl md:text-3xl font-bold mb-4 sm:mb-6 text-gray-800">Room Management</h1>

      {/* KPI Section */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3 sm:gap-4 md:gap-6 mb-6 sm:mb-8">
        <KpiCard title="Total Rooms" value={totalRooms} color="bg-gradient-to-r from-blue-500 to-blue-700" icon={<i className="fas fa-door-closed"></i>} />
        <KpiCard title="Available" value={availableRooms} color="bg-gradient-to-r from-green-500 to-green-700" icon={<i className="fas fa-check-circle"></i>} />
        <KpiCard title="Occupied" value={occupiedRooms} color="bg-gradient-to-r from-red-500 to-red-700" icon={<i className="fas fa-bed"></i>} />
        <KpiCard title="Maintenance" value={maintenanceRooms} color="bg-gradient-to-r from-yellow-500 to-yellow-600" icon={<i className="fas fa-tools"></i>} />
        <KpiCard title="Occupancy Rate" value={`${occupancyRate}%`} color="bg-gradient-to-r from-purple-500 to-purple-700" icon={<i className="fas fa-chart-pie"></i>} />
      </div>

      {/* Action Buttons */}
      <div className="flex gap-4 mb-8">
        <button
          onClick={() => {
            setIsEditing(false);
            setEditRoomId(null);
            setForm({
              number: "",
              type: "",
              priority: "",
              price: "",
              status: "Available",
              adults: 2,
              children: 0,
              image: null,
              air_conditioning: false,
              wifi: false,
              bathroom: false,
              living_area: false,
              terrace: false,
              parking: false,
              kitchen: false,
              family_room: false,
              bbq: false,
              garden: false,
              dining: false,
              breakfast: false,
              images: [],
            });
            setPreviewImages([]);
            setExistingImages([]);
            setIsModalOpen(true);
          }}
          className="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-4 px-6 rounded-xl shadow-lg transition-transform transform hover:-translate-y-1 flex items-center justify-center gap-3"
        >
          <i className="fas fa-plus-circle text-2xl"></i>
          <span className="text-xl">Add New Room</span>
        </button>
      </div>

      {/* Room Modal */}
      <Modal
        isOpen={isModalOpen}
        title={isEditing ? "Edit Room" : "Add New Room"}
        onClose={() => setIsModalOpen(false)}
      >
        <form
          onSubmit={handleSubmit}
          className="space-y-6"
        >
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Room Number</label>
              <input
                type="text"
                name="number"
                placeholder="e.g., 101"
                value={form.number}
                onChange={handleChange}
                className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
                required
                disabled={isEditing}
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Room Type</label>
              <input
                type="text"
                name="type"
                placeholder="e.g., Deluxe"
                value={form.type}
                onChange={handleChange}
                className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
                required
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Price (₹)</label>
              <input
                type="number"
                name="price"
                placeholder="e.g., 5000"
                value={form.price}
                onChange={handleChange}
                className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
                required
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Priority</label>
              <input
                type="number"
                name="priority"
                placeholder="e.g., 1 (shows first)"
                value={form.priority}
                onChange={handleChange}
                className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Adults Capacity</label>
              <input
                type="number"
                name="adults"
                placeholder="e.g., 2"
                value={form.adults}
                onChange={handleChange}
                className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
                min="1"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Children Capacity</label>
              <input
                type="number"
                name="children"
                placeholder="e.g., 1"
                value={form.children}
                onChange={handleChange}
                className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
                min="0"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Status</label>
              <select
                name="status"
                value={form.status}
                onChange={handleChange}
                className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all"
              >
                <option>Available</option>
                <option>Maintenance</option>
                <option>Coming Soon</option>
                <option>Disabled</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Room Images</label>
              <input
                type="file"
                name="images"
                multiple
                accept="image/jpeg,image/jpg,image/png,image/webp"
                onChange={handleChange}
                className="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100 transition-all"
              />
              <p className="text-xs text-gray-500 mt-1">Select multiple images. Max 50MB each.</p>
            </div>

            {/* Image Previews Grid */}
            <div className="md:col-span-2 lg:col-span-3">
              {(existingImages.length > 0 || previewImages.length > 0) && (
                <label className="block text-sm font-medium text-gray-700 mb-2">Gallery</label>
              )}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {/* Existing Images */}
                {existingImages.map((img) => (
                  <div key={img.id} className="relative group">
                    <img src={getImageUrl(img.image_url)} alt="Room" className="w-full h-32 object-cover rounded-lg" />
                    <button
                      type="button"
                      onClick={() => removeExistingImage(img.id)}
                      className="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 w-6 h-6 flex items-center justify-center opacity-70 group-hover:opacity-100 transition-opacity"
                    >
                      &times;
                    </button>
                  </div>
                ))}
                {/* New Previews */}
                {previewImages.map((url, idx) => (
                  <div key={idx} className="relative group">
                    <img src={url} alt="Preview" className="w-full h-32 object-cover rounded-lg border-2 border-indigo-200" />
                    <button
                      type="button"
                      onClick={() => removeNewImage(idx)}
                      className="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 w-6 h-6 flex items-center justify-center opacity-70 group-hover:opacity-100 transition-opacity"
                    >
                      &times;
                    </button>
                  </div>
                ))}
              </div>
            </div>

            {/* Room Features Section */}
            <div className="md:col-span-2 lg:col-span-3">
              <label className="block text-sm font-medium text-gray-700 mb-3">Room Features & Amenities</label>
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3 p-4 bg-gray-50 rounded-lg border border-gray-200">
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="air_conditioning"
                    checked={form.air_conditioning}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Air Conditioning</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="wifi"
                    checked={form.wifi}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Free Wifi</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="bathroom"
                    checked={form.bathroom}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Private Bathroom</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="living_area"
                    checked={form.living_area}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Living Room</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="terrace"
                    checked={form.terrace}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Terrace</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="parking"
                    checked={form.parking}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Free Parking</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="kitchen"
                    checked={form.kitchen}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Kitchen</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="family_room"
                    checked={form.family_room}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Family Room</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="bbq"
                    checked={form.bbq}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">BBQ</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="garden"
                    checked={form.garden}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Garden</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="dining"
                    checked={form.dining}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Dining Area</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    name="breakfast"
                    checked={form.breakfast}
                    onChange={handleChange}
                    className="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                  />
                  <span className="text-sm text-gray-700">Complimentary Breakfast</span>
                </label>
              </div>
            </div>
            <div className="md:col-span-2 lg:col-span-3 flex items-center gap-4">
              <button
                type="submit"
                disabled={isSubmitting}
                className={`w-full bg-indigo-600 text-white font-semibold py-3 px-6 rounded-lg shadow-md hover:bg-indigo-700 transition-transform transform hover:-translate-y-1 flex justify-center items-center gap-2 ${isSubmitting ? 'opacity-70 cursor-not-allowed' : ''}`}
              >
                {isSubmitting ? (
                  <>
                    <svg className="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    {isEditing ? "Updating..." : "Creating..."}
                  </>
                ) : (
                  isEditing ? "Update Room" : "Add Room"
                )}
              </button>
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="w-full bg-gray-500 text-white font-semibold py-3 px-6 rounded-lg hover:bg-gray-600 transition"
              >
                Cancel
              </button>
            </div>
          </div>
        </form>
      </Modal>

      {/* Rooms Grid */}
      <div className="bg-white p-4 sm:p-6 md:p-8 rounded-xl sm:rounded-2xl shadow-lg">
        <div className="flex flex-col sm:flex-row flex-wrap gap-3 sm:gap-4 justify-between items-start sm:items-center mb-4 sm:mb-6">
          <h2 className="text-xl sm:text-2xl font-bold text-gray-800 w-full sm:w-auto">All Rooms</h2>
          <div className="flex flex-col sm:flex-row flex-wrap gap-2 sm:gap-4 w-full sm:w-auto">
            <select onChange={(e) => setFilter(prev => ({ ...prev, type: e.target.value }))} className="p-2 text-sm border border-gray-300 rounded-lg w-full sm:w-auto">
              <option value="all">All Types</option>
              {[...new Set(rooms.map(r => r.type))].map(type => <option key={type} value={type}>{type}</option>)}
            </select>
            <select onChange={(e) => setFilter(prev => ({ ...prev, status: e.target.value }))} className="p-2 text-sm border border-gray-300 rounded-lg w-full sm:w-auto">
              <option value="all">All Statuses</option>
              <option value="Available">Available</option>
              <option value="Booked">Booked</option>
              <option value="Maintenance">Maintenance</option>
              <option value="Coming Soon">Coming Soon</option>
              <option value="Disabled">Disabled</option>
            </select>
          </div>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 sm:gap-6">
          {filteredRooms.map((room) => (
            <motion.div key={room.id} className="bg-gray-50 rounded-2xl shadow-md overflow-hidden border border-gray-200 hover:shadow-xl transition-all duration-300 flex flex-col" whileHover={{ y: -5 }}>
              <div className="relative">
                <img
                  src={getImageUrl(room.image_url)}
                  alt={`Room ${room.number}`}
                  className="h-48 w-full object-cover cursor-pointer hover:opacity-90 transition-opacity"
                  onClick={() => setSelectedRoomForGallery(room)}
                />
                <span className={`absolute top-2 right-2 px-3 py-1 text-xs font-semibold text-white rounded-full ${room.status === 'Available' ? 'bg-green-500' :
                  room.status === 'Disabled' ? 'bg-red-600' :
                    ['Booked', 'Occupied', 'Checked-in'].includes(room.status) ? 'bg-red-500' :
                      'bg-yellow-500'
                  }`}>{room.status}</span>
              </div>
              <div className="p-5 flex flex-col flex-grow">
                <div className="flex justify-between items-start">
                  <div>
                    <h4 className="font-bold text-lg text-gray-800">Room {room.number}</h4>
                    <p className="text-sm text-gray-500">{room.type} {room.priority ? `(Priority: ${room.priority})` : ''}</p>
                  </div>
                  <p className="text-indigo-600 font-bold text-xl">{formatCurrency(room.price)}</p>
                </div>
                <p className="text-sm text-gray-600 mt-2">Capacity: {room.adults} Adults, {room.children} Children</p>

                {/* Room Features */}
                {(room.air_conditioning || room.wifi || room.bathroom || room.living_area || room.terrace || room.parking || room.kitchen || room.family_room || room.bbq || room.garden || room.dining || room.breakfast) && (
                  <div className="mt-3 flex flex-wrap gap-1">
                    {room.air_conditioning && <span className="px-2 py-1 text-xs bg-blue-100 text-blue-700 rounded-full">AC</span>}
                    {room.wifi && <span className="px-2 py-1 text-xs bg-green-100 text-green-700 rounded-full">WiFi</span>}
                    {room.bathroom && <span className="px-2 py-1 text-xs bg-purple-100 text-purple-700 rounded-full">Bathroom</span>}
                    {room.living_area && <span className="px-2 py-1 text-xs bg-orange-100 text-orange-700 rounded-full">Living</span>}
                    {room.terrace && <span className="px-2 py-1 text-xs bg-yellow-100 text-yellow-700 rounded-full">Terrace</span>}
                    {room.parking && <span className="px-2 py-1 text-xs bg-indigo-100 text-indigo-700 rounded-full">Parking</span>}
                    {room.kitchen && <span className="px-2 py-1 text-xs bg-pink-100 text-pink-700 rounded-full">Kitchen</span>}
                    {room.family_room && <span className="px-2 py-1 text-xs bg-teal-100 text-teal-700 rounded-full">Family</span>}
                    {room.bbq && <span className="px-2 py-1 text-xs bg-red-100 text-red-700 rounded-full">BBQ</span>}
                    {room.garden && <span className="px-2 py-1 text-xs bg-emerald-100 text-emerald-700 rounded-full">Garden</span>}
                    {room.dining && <span className="px-2 py-1 text-xs bg-amber-100 text-amber-700 rounded-full">Dining</span>}
                    {room.breakfast && <span className="px-2 py-1 text-xs bg-cyan-100 text-cyan-700 rounded-full">Breakfast</span>}
                  </div>
                )}

                <div className="h-16 mt-4">
                  <ResponsiveContainer width="100%" height="100%">
                    <LineChart data={(room.trend || []).map((v, i) => ({ day: i + 1, value: v }))}>
                      <RechartsTooltip contentStyle={{ fontSize: '12px', padding: '2px 5px' }} />
                      <Line type="monotone" dataKey="value" stroke="#4f46e5" strokeWidth={2} dot={false} />
                    </LineChart>
                  </ResponsiveContainer>
                </div>
                <div className="mt-auto pt-4 border-t border-gray-200 flex flex-col gap-2">
                  <div className="flex justify-between gap-2">
                    <button onClick={() => handleEdit(room)} className="w-1/2 bg-green-100 text-green-700 text-sm font-semibold py-2 rounded-lg hover:bg-green-200 transition">Edit</button>
                    <button
                      onClick={() => handleToggleDisable(room)}
                      className={`w-1/2 ${room.status === 'Disabled' ? 'bg-green-100 text-green-700 hover:bg-green-200' : 'bg-red-100 text-red-700 hover:bg-red-200'} text-sm font-semibold py-2 rounded-lg transition`}
                    >
                      {room.status === 'Disabled' ? 'Enable' : 'Disable'}
                    </button>
                  </div>
                  <button onClick={() => fetchBookings(room.number)} className="w-full bg-blue-100 text-blue-700 text-sm font-semibold py-2 rounded-lg hover:bg-blue-200 transition">View Bookings</button>
                  {room.status !== "Booked" && (
                    <select
                      value={room.status}
                      onChange={(e) => handleStatusChange(room.id, e.target.value)}
                      className="w-full p-2 border border-gray-300 rounded-lg text-sm"
                    >
                      <option value="Available">Set Available</option>
                      <option value="Maintenance">Set Maintenance</option>
                      <option value="Coming Soon">Set Coming Soon</option>
                      <option value="Disabled">Set Disabled</option>
                    </select>
                  )}
                </div>
              </div>
            </motion.div>
          ))}
          {filteredRooms.length === 0 && (
            <p className="col-span-full text-center py-10 text-gray-500">No rooms match the current filters.</p>
          )}
          {hasMore && (
            <div className="col-span-full text-center mt-4">
              <button
                onClick={loadMoreRooms}
                disabled={isFetchingMore}
                className="bg-indigo-100 text-indigo-700 font-semibold px-6 py-2 rounded-lg hover:bg-indigo-200 transition-colors disabled:bg-gray-200 disabled:text-gray-500"
              >
                {isFetchingMore ? "Loading..." : "Load More Rooms"}
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Booking Data Modal */}
      {showBookingModal && (
        <BookingModal
          onClose={() => setShowBookingModal(false)}
          roomNumber={selectedRoomNumber}
          bookings={bookings}
          filter={bookingFilter}
          setFilter={setBookingFilter}
          checkinFilter={bookingCheckinFilter}
          setCheckinFilter={setBookingCheckinFilter}
          checkoutFilter={bookingCheckoutFilter}
          setCheckoutFilter={setBookingCheckoutFilter}
        />
      )}

      {/* Image Modal */}
      {selectedRoomForGallery && (
        <ImageModal
          room={selectedRoomForGallery}
          onClose={() => setSelectedRoomForGallery(null)}
        />
      )}
    </DashboardLayout>
  );
};

export default Rooms;
