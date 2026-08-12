import React, { useState, useEffect, useCallback, useMemo } from "react";
import { formatCurrency } from '../utils/currency';
import DashboardLayout from "../layout/DashboardLayout";
import API from "../services/api";
import { useNavigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import CountUp from "react-countup";
import { Pie } from "react-chartjs-2";
import { useInfiniteScroll } from "./useInfiniteScroll";
import Select from "react-select";
import { countryCodes } from "../utils/countryCodes";
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js';
import BannerMessage from "../components/BannerMessage";
import Modal from "../components/Modal";

ChartJS.register(ArcElement, Tooltip, Legend);

import RoomSelection from "../components/RoomSelection";

// Reusable components (for better structure)
const KPI_Card = React.memo(({ title, value, unit = "", duration = 1.5 }) => (
  <motion.div
    whileHover={{ scale: 1.02 }}
    className="bg-white p-6 rounded-2xl shadow-lg flex flex-col items-center transition-transform duration-200 cursor-pointer"
  >
    <span className="text-gray-500 font-medium text-sm sm:text-base">{title}</span>
    <CountUp
      end={value}
      duration={duration}
      separator=","
      className="text-3xl font-extrabold mt-2 text-indigo-700"
      suffix={unit}
    />
  </motion.div>
));
KPI_Card.displayName = 'KPI_Card';

const BookingStatusBadge = React.memo(({ status }) => {
  const statusClasses = {
    booked: "bg-green-100 text-green-700",
    cancelled: "bg-red-100 text-red-600",
    "checked-in": "bg-blue-100 text-blue-700",
    "checked-out": "bg-gray-200 text-gray-700",
  };
  const badgeClass = statusClasses[status.toLowerCase()] || "bg-yellow-100 text-yellow-700";

  return (
    <span
      className={`px-3 py-1 rounded-full text-xs font-semibold uppercase tracking-wider ${badgeClass}`}
    >
      {status}
    </span>
  );
});
BookingStatusBadge.displayName = 'BookingStatusBadge';

const ImageModal = ({ imageUrl, onClose }) => {
  if (!imageUrl) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-70 flex justify-center items-center z-[60]">
      <div className="relative max-w-3xl w-full mx-4">
        <button
          onClick={onClose}
          className="absolute -top-8 right-0 text-white text-4xl font-bold hover:text-gray-300"
        >
          &times;
        </button>
        <img
          src={imageUrl}
          alt="Full size view"
          className="w-full h-auto rounded-2xl shadow-lg"
        />
      </div>
    </div>
  );
};
const BookingDetailsModal = ({ booking, onClose, onImageClick, roomIdToRoom }) => {
  if (!booking) return null;

  const roomInfo = booking.rooms && booking.rooms.length > 0
    ? booking.rooms.map(room => {
      // The `/api/bookings/details` endpoint returns flattened Room objects `[{ number: '101' }]`
      if (room?.number) return `${room.number} (${room.type})`;

      // The `/api/packages/bookingsall` endpoint returns nested objects `[{ room: { number: '101' } }]`
      if (room?.room?.number) return `${room.room.number} (${room.room.type})`;

      // Fallback via lookup (supports both room_id and id properties)
      const rId = room?.room_id || room?.id;
      if (rId && roomIdToRoom && roomIdToRoom[rId]) {
        const r = roomIdToRoom[rId];
        return `${r.number} (${r.type})`;
      }
      return '-';
    }).filter(r => r !== '-').join(", ") || '-'
    : "-";

  return (
    <div className="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center p-4 z-50 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0, y: -50 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: 50 }}
        className="bg-white p-8 rounded-xl shadow-2xl w-full max-w-lg max-h-[90vh] overflow-y-auto my-8"
      >
        <div className="flex justify-between items-center mb-6">
          <h3 className="text-2xl font-bold text-gray-800">Booking Details</h3>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-800 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className="space-y-4 text-gray-700">
          <p><strong>Guest:</strong> {booking.guest_name}</p>
          <p><strong>Rooms:</strong> {roomInfo}</p>
          <p><strong>Check-in:</strong> {booking.check_in}</p>
          <p><strong>Check-out:</strong> {booking.check_out}</p>
          <p><strong>Mobile:</strong> {booking.guest_mobile}</p>
          <p><strong>Email:</strong> {booking.guest_email}</p>
          <p><strong>Guests:</strong> {booking.adults} Adults, {booking.children} Children</p>
          <div className="p-4 bg-indigo-50 rounded-lg border border-indigo-100 flex justify-between items-center mt-4">
            <span className="text-indigo-800 font-semibold uppercase tracking-wider text-sm">Estimated Total Amount:</span>
            <span className="text-2xl font-bold text-indigo-700">{formatCurrency(booking.total_amount || 0)}</span>
          </div>
          {booking.status === 'checked-in' && booking.user && (
            <p><strong>Checked-in By:</strong> {booking.user.name}</p>
          )}
          {(booking.id_card_image_url || booking.guest_photo_url) && (
            <div className="mt-4 pt-4 border-t border-gray-200">
              <h4 className="text-lg font-semibold text-gray-800 mb-2">Check-in Documents</h4>
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
                {/* Legacy Single Images */}
                {!booking.checkin_documents?.length && booking.id_card_image_url && (
                  <div className="text-center">
                    <p className="text-sm font-medium text-gray-600 mb-1">ID Card (Legacy)</p>
                    <img
                      src={`${API.defaults.baseURL.replace(/\/$/, '')}/${booking.is_package ? 'packages/booking/checkin-image' : 'bookings/checkin-image'}/${booking.id_card_image_url}`}
                      alt="ID Card"
                      className="w-full h-32 object-cover rounded-lg border shadow-sm cursor-pointer hover:opacity-90 transition-opacity"
                      onClick={() => onImageClick(`${API.defaults.baseURL.replace(/\/$/, '')}/${booking.is_package ? 'packages/booking/checkin-image' : 'bookings/checkin-image'}/${booking.id_card_image_url}`)}
                    />
                  </div>
                )}
                {!booking.checkin_documents?.length && booking.guest_photo_url && (
                  <div className="text-center">
                    <p className="text-sm font-medium text-gray-600 mb-1">Guest Photo (Legacy)</p>
                    <img
                      src={`${API.defaults.baseURL.replace(/\/$/, '')}/${booking.is_package ? 'packages/booking/checkin-image' : 'bookings/checkin-image'}/${booking.guest_photo_url}`}
                      alt="Guest"
                      className="w-full h-32 object-cover rounded-lg border shadow-sm cursor-pointer hover:opacity-90 transition-opacity"
                      onClick={() => onImageClick(`${API.defaults.baseURL.replace(/\/$/, '')}/${booking.is_package ? 'packages/booking/checkin-image' : 'bookings/checkin-image'}/${booking.guest_photo_url}`)}
                    />
                  </div>
                )}

                {/* New Multiple Documents */}
                {booking.checkin_documents?.map((doc, idx) => {
                  const imageUrl = `${API.defaults.baseURL.replace(/\/$/, '')}/${booking.is_package ? 'packages/booking/checkin-image' : 'bookings/checkin-image'}/${doc.image_url}`;
                  return (
                    <div key={doc.id || idx} className="text-center">
                      <p className="text-sm font-medium text-gray-600 mb-1">
                        {doc.type === 'id_card' ? 'ID Card' : 'Guest Photo'}
                      </p>
                      <img
                        src={imageUrl}
                        alt={doc.type}
                        className="w-full h-32 object-cover rounded-lg border shadow-sm cursor-pointer hover:opacity-90 transition-opacity"
                        onClick={() => onImageClick(imageUrl)}
                      />
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </div>
        <button
          onClick={onClose}
          className="mt-6 w-full bg-indigo-600 text-white font-semibold py-2 rounded-md hover:bg-indigo-700 transition-colors"
        >
          Close
        </button>
      </motion.div>
    </div>
  );
};

const ExtendBookingModal = ({ booking, onSave, onClose, feedback, isSubmitting }) => {
  // Safety check: ensure booking exists and has required properties
  if (!booking || !booking.check_out || !booking.id) {
    return (
      <Modal isOpen={true} onClose={onClose} title="Error">
        <div className="p-4">
          <p className="text-red-600">Error: Invalid booking data. Please close and try again.</p>
          <button onClick={onClose} className="mt-4 w-full bg-indigo-600 text-white font-semibold py-2 rounded-md hover:bg-indigo-700 transition-colors">
            Close
          </button>
        </div>
      </Modal>
    );
  }

  const [newCheckout, setNewCheckout] = useState(booking.check_out || '');
  const minDate = booking.check_out || '';

  const handleSave = () => {
    if (!booking.id || !newCheckout) {
      return;
    }
    // Pass both id (for state lookup) and display_id (for API call)
    // The parent component will handle converting to display ID
    onSave(booking.id, newCheckout);
  };

  return (
    <Modal isOpen={true} onClose={onClose} title="Extend Booking">
      <div className="space-y-4 text-gray-700">
        <p><strong>Current Check-in:</strong> {booking.check_in}</p>
        <p><strong>Current Check-out:</strong> {booking.check_out}</p>
        <div className="flex flex-col">
          <label className="text-sm font-medium text-gray-700 mb-1">New Check-out Date</label>
          <input
            type="date"
            value={newCheckout || ''}
            onChange={(e) => {
              const newValue = e.target.value;
              if (newValue) {
                setNewCheckout(newValue);
              }
            }}
            min={minDate || ''}
            className="w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500"
          />
        </div>
      </div>
      <button
        onClick={handleSave}
        disabled={isSubmitting || !newCheckout || !minDate || newCheckout <= minDate}
        className="mt-6 w-full bg-indigo-600 text-white font-semibold py-2 rounded-md hover:bg-indigo-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed"
      >
        {isSubmitting ? "Saving..." : "Save"}
      </button>
    </Modal>
  );
};

const CheckInModal = ({ booking, onSave, onClose, feedback, isSubmitting }) => {
  const [idCardImages, setIdCardImages] = useState([]);
  const [guestPhotos, setGuestPhotos] = useState([]);
  const [idCardPreviews, setIdCardPreviews] = useState([]);
  const [guestPhotoPreviews, setGuestPhotoPreviews] = useState([]);

  const handleFileChange = (e, type) => {
    const files = Array.from(e.target.files);
    if (!files || files.length === 0) return;

    // Create previews using FileReader (Base64) to avoid CSP blob: issues
    const generatePreviews = async () => {
      const newPreviews = await Promise.all(files.map(file => {
        return new Promise((resolve) => {
          const reader = new FileReader();
          reader.onload = (e) => resolve(e.target.result);
          reader.readAsDataURL(file);
        });
      }));

      if (type === 'id') {
        setIdCardImages(prev => [...prev, ...files]);
        setIdCardPreviews(prev => [...prev, ...newPreviews]);
      } else {
        setGuestPhotos(prev => [...prev, ...files]);
        setGuestPhotoPreviews(prev => [...prev, ...newPreviews]);
      }
    };

    generatePreviews();

    // Reset input value to allow selecting the same file again if needed
    e.target.value = '';
  };

  const removeFile = (index, type) => {
    if (type === 'id') {
      setIdCardImages(prev => prev.filter((_, i) => i !== index));
      setIdCardPreviews(prev => prev.filter((_, i) => i !== index));
    } else {
      setGuestPhotos(prev => prev.filter((_, i) => i !== index));
      setGuestPhotoPreviews(prev => prev.filter((_, i) => i !== index));
    }
  };

  const handleSave = () => {
    // Check if booking is in correct state before attempting check-in
    const normalizedStatus = booking.status?.toLowerCase().replace(/[-_]/g, '');
    if (normalizedStatus !== 'booked') {
      alert(`Cannot check in. Booking status is: ${booking.status}`);
      return;
    }

    if (idCardImages.length === 0 || guestPhotos.length === 0) {
      alert("Please upload at least one ID card and one guest photo.");
      return;
    }
    // Pass arrays to onSave
    onSave(booking.id, { id_card_images: idCardImages, guest_photos: guestPhotos });
  };

  return (
    <Modal isOpen={true} onClose={onClose} title={`Check-in Guest: ${booking.guest_name}`}>
      <div className="space-y-6">
        <div>
          <label className="block font-medium text-gray-700 mb-2">ID Card Images (Add One or Multiple)</label>
          <div className="flex items-center gap-4">
            <label className="cursor-pointer bg-indigo-50 text-indigo-700 font-semibold py-2 px-4 rounded-full border border-indigo-200 hover:bg-indigo-100 transition-colors">
              <span>+ Add Files</span>
              <input
                type="file"
                accept="image/*"
                multiple
                onChange={(e) => handleFileChange(e, 'id')}
                className="hidden"
              />
            </label>
            <span className="text-sm text-gray-500">{idCardImages.length} file(s) selected</span>
          </div>

          {idCardPreviews.length > 0 && (
            <div className="mt-4 grid grid-cols-2 md:grid-cols-3 gap-3">
              {idCardPreviews.map((preview, idx) => (
                <div key={idx} className="relative group">
                  <img src={preview} alt={`ID Preview ${idx}`} className="w-full h-24 object-cover rounded-lg border" />
                  <button
                    onClick={() => removeFile(idx, 'id')}
                    className="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 shadow-md opacity-0 group-hover:opacity-100 transition-opacity"
                    title="Remove"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                      <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                    </svg>
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>

        <div>
          <label className="block font-medium text-gray-700 mb-2">Guest Photos (Add One or Multiple)</label>
          <div className="flex items-center gap-4">
            <label className="cursor-pointer bg-indigo-50 text-indigo-700 font-semibold py-2 px-4 rounded-full border border-indigo-200 hover:bg-indigo-100 transition-colors">
              <span>+ Add Files</span>
              <input
                type="file"
                accept="image/*"
                multiple
                onChange={(e) => handleFileChange(e, 'guest')}
                className="hidden"
              />
            </label>
            <span className="text-sm text-gray-500">{guestPhotos.length} file(s) selected</span>
          </div>

          {guestPhotoPreviews.length > 0 && (
            <div className="mt-4 grid grid-cols-2 md:grid-cols-3 gap-3">
              {guestPhotoPreviews.map((preview, idx) => (
                <div key={idx} className="relative group">
                  <img src={preview} alt={`Guest Preview ${idx}`} className="w-full h-24 object-cover rounded-lg border" />
                  <button
                    onClick={() => removeFile(idx, 'guest')}
                    className="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 shadow-md opacity-0 group-hover:opacity-100 transition-opacity"
                    title="Remove"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                      <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                    </svg>
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      <div className="flex gap-4 mt-8">
        <button onClick={onClose} className="w-full bg-gray-200 text-gray-800 font-semibold py-2 rounded-md hover:bg-gray-300 transition-colors">Cancel</button>
        <button onClick={handleSave} disabled={isSubmitting || idCardImages.length === 0 || guestPhotos.length === 0} className="w-full bg-indigo-600 text-white font-semibold py-2 rounded-md hover:bg-indigo-700 transition-colors disabled:bg-gray-400">
          {isSubmitting ? "Checking in..." : "Confirm Check-in"}
        </button>
      </div>
    </Modal>
  );
};

const EarlyCheckInModal = ({ booking, onConfirm, onClose }) => {
  if (!booking) return null;

  const checkInDate = booking.check_in;
  const today = new Date().toLocaleDateString("en-CA"); // YYYY-MM-DD

  return (
    <Modal isOpen={true} onClose={onClose} title="Early Check-in Warning" maxWidth="max-w-md">
      <div className="flex items-start mb-4">
        <div className="bg-yellow-100 p-2 rounded-full mr-3 shrink-0">
          <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-yellow-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
        </div>
        <div>
          <p className="text-gray-800 mt-1">
            This booking is scheduled for <span className="font-semibold text-gray-900">{checkInDate}</span>.
          </p>
        </div>
      </div>

      <p className="text-gray-800 mb-6 bg-gray-50 p-3 rounded-lg text-sm border border-gray-200">
        Checking in now will update the scheduled check-in date to today (<span className="font-semibold text-gray-900">{today}</span>).
      </p>

      <div className="flex gap-3">
        <button
          onClick={onClose}
          className="flex-1 px-4 py-2 bg-gray-100 text-gray-700 font-semibold rounded-lg hover:bg-gray-200 transition-colors"
        >
          Cancel
        </button>
        <button
          onClick={() => onConfirm(booking)}
          className="flex-1 px-4 py-2 bg-yellow-500 text-white font-semibold rounded-lg hover:bg-yellow-600 transition-colors shadow-sm"
        >
          Proceed with Early Check-in
        </button>
      </div>
    </Modal>
  );
};

const BookingStatusChart = React.memo(({ data }) => {
  const chartData = useMemo(() => {
    const statusCounts = data.reduce((acc, booking) => {
      acc[booking.status] = (acc[booking.status] || 0) + 1;
      return acc;
    }, {});

    return {
      labels: Object.keys(statusCounts),
      datasets: [
        {
          data: Object.values(statusCounts),
          backgroundColor: [
            "rgba(79, 70, 229, 0.7)", // indigo
            "rgba(34, 197, 94, 0.7)", // green
            "rgba(239, 68, 68, 0.7)", // red
            "rgba(107, 114, 128, 0.7)", // gray
          ],
          borderColor: [
            "rgba(79, 70, 229, 1)",
            "rgba(34, 197, 94, 1)",
            "rgba(239, 68, 68, 1)",
            "rgba(107, 114, 128, 1)",
          ],
          borderWidth: 1,
        },
      ],
    };
  }, [data]);

  return (
    <div className="bg-white p-6 rounded-2xl shadow-lg flex-1">
      <h3 className="text-xl font-bold mb-4 text-gray-800">Bookings by Status</h3>
      <div className="w-full h-64 flex items-center justify-center">
        <Pie data={chartData} />
      </div>
    </div>
  );
});
BookingStatusChart.displayName = 'BookingStatusChart';

const Bookings = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    guestName: "",
    guestMobile: "+91",
    guestEmail: "",
    roomTypes: [],
    roomNumbers: [],
    checkIn: "",
    checkOut: "",
    adults: 1,
    children: 0,
    advance_amount: 0,
  });
  const [emailError, setEmailError] = useState("");
  const [phoneError, setPhoneError] = useState("");
  const today = new Date().toISOString().split("T")[0];

  // Helper to ensure check-out date is at least 1 day after check-in
  const getNextDay = useCallback((dateString) => {
    const baseDate = dateString ? new Date(dateString) : new Date();
    baseDate.setDate(baseDate.getDate() + 1);
    return baseDate.toISOString().split('T')[0];
  }, []);

  const [packages, setPackages] = useState([]);
  const [packageBookingForm, setPackageBookingForm] = useState({
    package_id: "",
    guest_name: "",
    guest_email: "",
    guest_mobile: "+91",
    check_in: "",
    check_out: "",
    adults: 2,
    children: 0,
    room_ids: [],
    advance_amount: 0
  });
  const [packageEmailError, setPackageEmailError] = useState("");
  const [packagePhoneError, setPackagePhoneError] = useState("");
  const [rooms, setRooms] = useState([]);
  const [packageRooms, setPackageRooms] = useState([]); // Separate state for package booking rooms
  const [allRooms, setAllRooms] = useState([]);

  // Computed state for Whole Property blocking
  const isWholePropertyBlocked = useMemo(() => {
    if (!packageBookingForm.package_id) return false;
    // Only block if dates are selected
    if (!packageBookingForm.check_in || !packageBookingForm.check_out) return false;

    const pkg = packages.find(p => p.id === parseInt(packageBookingForm.package_id));
    if (!pkg) return false;

    const hasRoomTypes = pkg.room_types && pkg.room_types.trim().length > 0;
    const isWholeProperty = pkg.booking_type === 'whole_property' ||
      pkg.booking_type === 'whole property' ||
      (!pkg.booking_type && !hasRoomTypes);

    if (!isWholeProperty) return false;

    // Count active rooms (total inventory excluding disabled/maintenance)
    // Note: 'Maintenance' vs 'maintenance' - check backend or use case-insensitive
    const activeRoomCount = allRooms.filter(r => !['disabled', 'maintenance', 'coming soon'].includes((r.status || '').toLowerCase())).length;

    // packageRooms is already filtered by availability (dates & conflicts) in the useEffect
    // So if packageRooms.length < activeRoomCount, it means some rooms are occupied
    return packageRooms.length < activeRoomCount;
  }, [packageBookingForm.package_id, packageBookingForm.check_in, packageBookingForm.check_out, packages, allRooms, packageRooms]);
  const [bookings, setBookings] = useState([]);
  const [statusFilter, setStatusFilter] = useState("All");
  const [roomNumberFilter, setRoomNumberFilter] = useState("All");
  const [fromDate, setFromDate] = useState("");
  const [toDate, setToDate] = useState("");
  const [feedback, setFeedback] = useState({ message: "", type: "" });
  const [bannerMessage, setBannerMessage] = useState({ type: null, text: "" });
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Phone Validation State
  const [roomCountryCode, setRoomCountryCode] = useState(countryCodes.find(c => c.value === "+91"));
  const [roomMobileNumber, setRoomMobileNumber] = useState("");
  const [packageCountryCode, setPackageCountryCode] = useState(countryCodes.find(c => c.value === "+91"));
  const [packageMobileNumber, setPackageMobileNumber] = useState("");
  const [isRoomBookingModalOpen, setIsRoomBookingModalOpen] = useState(false);
  const [isPackageBookingModalOpen, setIsPackageBookingModalOpen] = useState(false);

  const handleRoomMobileChange = (e) => {
    const val = e.target.value.replace(/\D/g, '');
    setRoomMobileNumber(val);
    const full = (roomCountryCode?.value || "") + val;
    setFormData(prev => ({ ...prev, guestMobile: full }));

    if (roomCountryCode?.value === "+91") {
      setPhoneError(!/^\+91\d{10}$/.test(full) ? "Please enter a valid Indian number (+91XXXXXXXXXX)." : "");
    } else {
      setPhoneError("");
    }
  };

  const handleRoomCountryChange = (opt) => {
    setRoomCountryCode(opt);
    const full = (opt?.value || "") + roomMobileNumber;
    setFormData(prev => ({ ...prev, guestMobile: full }));

    if (opt?.value === "+91") {
      setPhoneError(!/^\+91\d{10}$/.test(full) ? "Please enter a valid Indian number (+91XXXXXXXXXX)." : "");
    } else {
      setPhoneError("");
    }
  };

  const handlePackageMobileChange = (e) => {
    const val = e.target.value.replace(/\D/g, '');
    setPackageMobileNumber(val);
    const full = (packageCountryCode?.value || "") + val;
    setPackageBookingForm(prev => ({ ...prev, guest_mobile: full }));

    if (packageCountryCode?.value === "+91") {
      setPackagePhoneError(!/^\+91\d{10}$/.test(full) ? "Please enter a valid Indian number (+91XXXXXXXXXX)." : "");
    } else {
      setPackagePhoneError("");
    }
  };

  const handlePackageCountryChange = (opt) => {
    setPackageCountryCode(opt);
    const full = (opt?.value || "") + packageMobileNumber;
    setPackageBookingForm(prev => ({ ...prev, guest_mobile: full }));

    if (opt?.value === "+91") {
      setPackagePhoneError(!/^\+91\d{10}$/.test(full) ? "Please enter a valid Indian number (+91XXXXXXXXXX)." : "");
    } else {
      setPackagePhoneError("");
    }
  };

  // Function to show banner message
  const showBannerMessage = (type, text) => {
    setBannerMessage({ type, text });
  };

  const closeBannerMessage = () => {
    setBannerMessage({ type: null, text: "" });
  };
  const [isLoading, setIsLoading] = useState(true);
  const [kpis, setKpis] = useState({
    activeBookings: 0,
    cancelledBookings: 0,
    availableRooms: 0,
    todaysGuestsCheckin: 0,
    todaysGuestsCheckout: 0,
  });
  const [modalBooking, setModalBooking] = useState(null);
  const [bookingToExtend, setBookingToExtend] = useState(null);
  const [bookingToCheckIn, setBookingToCheckIn] = useState(null);
  const [earlyCheckInBooking, setEarlyCheckInBooking] = useState(null);
  const [selectedImage, setSelectedImage] = useState(null);
  const [totalBookings, setTotalBookings] = useState(0);

  // Pagination State
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const limit = 20;

  // Map of roomId -> room for robust display when API omits nested room payloads
  const roomIdToRoom = useMemo(() => {
    const map = {};
    (allRooms || []).forEach(r => { if (r && r.id) map[r.id] = r; });
    return map;
  }, [allRooms]);

  const authHeader = useCallback(() => ({
    headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
  }), []);

  const fetchData = useCallback(async () => {
    setIsLoading(true);
    try {
      const token = localStorage.getItem("token");
      if (!token) {
        navigate("/login");
        return;
      }

      const skip = (page - 1) * limit;

      // 1. Fetch Bookings (Critical for Table)
      // Fire off auxiliary requests in background without awaiting them immediately
      const roomsPromise = API.get("/rooms", authHeader());
      const packagesListPromise = API.get("/packages?limit=100", authHeader()); // Increased limit to ensure we get all for dropdowns

      // Await only the booking data for fastest TTI (Time to Interactive)
      const [bookingsRes, packageBookingsRes] = await Promise.all([
        API.get(`/bookings?skip=${skip}&limit=${limit}&order_by=id&order=desc`, authHeader()),
        API.get(`/packages/bookingsall?skip=${skip}&limit=${limit}`, authHeader()),
      ]);

      // Handle Regular Bookings
      const initialBookings = bookingsRes.data.bookings || [];
      const regularTotal = bookingsRes.data.total || 0;

      // Handle Package Bookings
      let packageBookings = [];
      let packageTotal = 0;
      if (packageBookingsRes.data && packageBookingsRes.data.items) {
        packageBookings = packageBookingsRes.data.items;
        packageTotal = packageBookingsRes.data.total;
      } else if (Array.isArray(packageBookingsRes.data)) {
        packageBookings = packageBookingsRes.data;
        packageTotal = packageBookings.length;
      }

      // Combine and display bookings immediately
      const allPackageBookings = packageBookings.map(pb => ({
        ...pb,
        is_package: true,
        rooms: pb.rooms || []
      }));

      const combinedBookings = [...initialBookings, ...allPackageBookings];

      const todaysDate = new Date().toISOString().split("T")[0];
      const todaysGuestsCheckin = combinedBookings
        .filter(b => b.check_in === todaysDate && b.status !== 'cancelled')
        .reduce((sum, b) => sum + b.adults + b.children, 0);
      const todaysGuestsCheckout = combinedBookings
        .filter(b => b.check_out === todaysDate && b.status !== 'cancelled')
        .reduce((sum, b) => sum + b.adults + b.children, 0);

      combinedBookings.sort((a, b) => {
        const idA = a.id || 0;
        const idB = b.id || 0;
        return idB - idA;
      });

      setBookings(combinedBookings);
      setTotalBookings(regularTotal + packageTotal);

      const maxPages = Math.ceil(Math.max(regularTotal, packageTotal) / limit);
      setTotalPages(maxPages || 1);

      // KPI logic (approximate based on page)
      setKpis(prev => ({
        ...prev,
        activeBookings: combinedBookings.filter(b => ['booked', 'checked-in'].includes(b.status)).length,
        cancelledBookings: combinedBookings.filter(b => b.status === "cancelled").length,
        todaysGuestsCheckin,
        todaysGuestsCheckout,
      }));

      // Stop loading spinner here - Table is ready!
      setIsLoading(false);

      // 2. Process Auxiliary Data (Rooms & Packages for Filters/Modals)
      try {
        const [roomsRes, packageRes] = await Promise.all([roomsPromise, packagesListPromise]);

        const allRooms = roomsRes.data.items || (Array.isArray(roomsRes.data) ? roomsRes.data : []);
        setAllRooms(allRooms);
        setPackages(packageRes.data || []);

        // Update room-dependent state
        const availableRooms = allRooms.filter((r) => r.status === "Available");
        setPackageRooms(availableRooms);

        // Only override rooms filter if not already set (retaining existing logic logic which used allRooms)
        if (!formData.checkIn) {
          setRooms(availableRooms);
        }

        setKpis(prev => ({
          ...prev,
          availableRooms: availableRooms.length
        }));

      } catch (auxError) {
        console.error("Error fetching auxiliary data (rooms/packages):", auxError);
        // Don't show error banner if bookings loaded fine, just log it.
      }

    } catch (err) {
      console.error("Error fetching dashboard data:", err);
      showBannerMessage("error", "Failed to load dashboard data. Please try again.");
      setIsLoading(false);
    }
  }, [authHeader, navigate, page, formData.checkIn, formData.checkOut]); // Added page dependency

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  // Refilter rooms when check-in/check-out dates change for room booking
  useEffect(() => {
    if (formData.checkIn && formData.checkOut && allRooms.length > 0) {
      const availableRooms = allRooms.filter(room => {
        // First check strict status availability
        const normalizedStatus = (room.status || '').toLowerCase().trim();
        // "Occupied" and "Checked-in" should NOT be filtered out for future bookings
        const unavailableStatuses = ['disabled', 'coming soon', 'maintenance'];
        if (unavailableStatuses.includes(normalizedStatus)) return false;

        // Check if room has any conflicting bookings
        const hasConflict = bookings.some(booking => {
          const normalizedBookingStatus = (booking.status || '').toLowerCase().replace(/_/g, '-').trim();
          // Only check for "booked" or "checked-in" status - all other statuses are available
          if (normalizedBookingStatus !== "booked" && normalizedBookingStatus !== "checked-in") return false;

          const bookingCheckIn = new Date(booking.check_in);
          const bookingCheckOut = new Date(booking.check_out);
          const requestedCheckIn = new Date(formData.checkIn);
          const requestedCheckOut = new Date(formData.checkOut);

          // Check if room is part of this booking
          const isRoomInBooking = booking.rooms && booking.rooms.some(r => {
            const roomId = r.room?.id || r.room_id || r.id;
            return roomId === room.id;
          });
          if (!isRoomInBooking) return false;

          // Check for date overlap
          return (requestedCheckIn < bookingCheckOut && requestedCheckOut > bookingCheckIn);
        });

        return !hasConflict;
      });

      setRooms(availableRooms);
    } else if (!formData.checkIn || !formData.checkOut) {
      // If no dates selected, show all available rooms
      setRooms(allRooms.filter((r) => r.status === "Available"));
    }
  }, [formData.checkIn, formData.checkOut, allRooms, bookings]);

  // Refilter rooms for package booking when dates change
  useEffect(() => {
    if (packageBookingForm.check_in && packageBookingForm.check_out && allRooms.length > 0) {
      const selectedPackage = packages.find(p => p.id === parseInt(packageBookingForm.package_id));

      let availableRooms = allRooms.filter(room => {
        // First check strict status availability
        const normalizedStatus = (room.status || '').toLowerCase().trim();
        // "Occupied" and "Checked-in" should NOT be filtered out for future bookings
        const unavailableStatuses = ['disabled', 'coming soon', 'maintenance'];
        if (unavailableStatuses.includes(normalizedStatus)) return false;

        // Check if room has any conflicting bookings
        const hasConflict = bookings.some(booking => {
          const normalizedBookingStatus = (booking.status || '').toLowerCase().replace(/_/g, '-').trim();
          // Only check for "booked" or "checked-in" status - all other statuses are available
          if (normalizedBookingStatus !== "booked" && normalizedBookingStatus !== "checked-in") return false;

          const bookingCheckIn = new Date(booking.check_in);
          const bookingCheckOut = new Date(booking.check_out);
          const requestedCheckIn = new Date(packageBookingForm.check_in);
          const requestedCheckOut = new Date(packageBookingForm.check_out);

          // Check if room is part of this booking
          const isRoomInBooking = booking.rooms && booking.rooms.some(r => {
            const roomId = r.room?.id || r.room_id || r.id;
            return roomId === room.id;
          });
          if (!isRoomInBooking) return false;

          // Check for date overlap
          return (requestedCheckIn < bookingCheckOut && requestedCheckOut > bookingCheckIn);
        });

        return !hasConflict;
      });

      // If package is selected and has room_types, filter by room types (case-insensitive)
      if (selectedPackage && selectedPackage.booking_type === 'room_type' && selectedPackage.room_types) {
        const allowedRoomTypes = selectedPackage.room_types.split(',').map(t => t.trim().toLowerCase());
        availableRooms = availableRooms.filter(room => {
          const roomType = room.type ? room.type.trim().toLowerCase() : '';
          return allowedRoomTypes.includes(roomType);
        });
      }
      // For whole_property, availableRooms remains all available rooms (no filtering)

      // Update package rooms separately
      setPackageRooms(availableRooms);

      // If whole_property, automatically select all available rooms
      if (selectedPackage && selectedPackage.booking_type === 'whole_property' && availableRooms.length > 0) {
        setPackageBookingForm(prev => ({
          ...prev,
          room_ids: availableRooms.map(r => r.id)
        }));
      } else if (selectedPackage && selectedPackage.booking_type === 'room_type') {
        // For room_type, clear selection if package changed or dates changed
        // User will manually select rooms
      }
    } else if (!packageBookingForm.check_in || !packageBookingForm.check_out) {
      // If no dates selected, show all available rooms
      setPackageRooms(allRooms.filter((r) => r.status === "Available"));
    }
  }, [packageBookingForm.check_in, packageBookingForm.check_out, packageBookingForm.package_id, allRooms, bookings, packages]);

  const loadMoreBookings = async () => {
    if (!hasMoreBookings) return;
    setIsSubmitting(true);
    try {
      const response = await API.get(`/bookings?skip=${regularBookingsLoaded}&limit=20&order_by=id&order=desc`, authHeader());
      const { bookings: newBookings, total } = response.data;

      if (!newBookings || newBookings.length === 0) {
        setHasMoreBookings(false);
        return;
      }

      setBookings(prev => {
        const bookingsMap = new Map();

        prev.forEach((booking) => {
          const key = booking.is_package ? `package_${booking.id}` : `regular_${booking.id}`;
          bookingsMap.set(key, booking);
        });

        newBookings.forEach((booking) => {
          bookingsMap.set(`regular_${booking.id}`, { ...booking, is_package: false });
        });

        return Array.from(bookingsMap.values()).sort((a, b) => (b.id ?? 0) - (a.id ?? 0));
      });

      const updatedRegularCount = regularBookingsLoaded + newBookings.length;
      setRegularBookingsLoaded(updatedRegularCount);
      setHasMoreBookings(updatedRegularCount < total);
    } catch (err) {
      console.error("Failed to load more bookings:", err);
      showBannerMessage("error", "Could not load more bookings.");
    } finally {
      setIsSubmitting(false);
    }
  };

  // Removed obsolete useInfiniteScroll - now using explicit pagination controls

  const extractRoomNumber = useCallback((room) => {
    if (!room) return null;
    const directNumber = room.number;
    if (directNumber !== undefined && directNumber !== null && directNumber !== '') {
      return String(directNumber).trim();
    }

    const nestedNumber = room.room?.number;
    if (nestedNumber !== undefined && nestedNumber !== null && nestedNumber !== '') {
      return String(nestedNumber).trim();
    }

    return null;
  }, []);

  const dedupeBookings = useCallback((list) => {
    const map = new Map();

    list.forEach((rawBooking) => {
      if (!rawBooking) return;

      const booking = {
        ...rawBooking,
        is_package: Boolean(rawBooking.is_package),
      };

      // Use a more reliable key: id + is_package combination
      // This ensures same booking (same id, same type) is only kept once
      const key = `${booking.is_package ? 'PK' : 'BK'}_${booking.id ?? 'unknown'}`;

      if (!map.has(key)) {
        map.set(key, booking);
      } else {
        // If duplicate found, merge properties (keep the most complete version)
        const existing = map.get(key);
        map.set(key, { ...existing, ...booking });
      }
    });

    return Array.from(map.values()).sort((a, b) => (b.id ?? 0) - (a.id ?? 0));
  }, []);

  const roomTypes = useMemo(() => {
    return [...new Set(rooms.map((r) => r.type))];
  }, [rooms]);

  const allRoomNumbers = useMemo(() => {
    const numbers = new Set();
    bookings.forEach((booking) => {
      booking.rooms?.forEach((room) => {
        const roomNumber = extractRoomNumber(room);
        if (roomNumber) {
          numbers.add(roomNumber);
        }
      });
    });

    const sortedNumbers = Array.from(numbers).sort((a, b) => a.localeCompare(b, undefined, { numeric: true }));
    return ["All", ...sortedNumbers];
  }, [bookings, extractRoomNumber]);

  const filteredRooms = useMemo(() => {
    if (formData.roomTypes[0] === "All Rooms") {
      return rooms;
    }
    return rooms.filter((r) => r.type === formData.roomTypes[0]);
  }, [rooms, formData.roomTypes]);

  const selectedRoomDetails = useMemo(() => {
    return formData.roomNumbers.map(roomNumber => {
      if (formData.roomTypes[0] === "All Rooms") {
        return rooms.find(r => r.number === roomNumber);
      }
      return rooms.find(r => r.number === roomNumber && r.type === formData.roomTypes[0]);
    }).filter(room => room !== undefined && room !== null);
  }, [rooms, formData.roomNumbers, formData.roomTypes]);

  const totalGuests = useMemo(() => {
    return parseInt(formData.adults) + parseInt(formData.children);
  }, [formData.adults, formData.children]);

  const handlePackageBookingChange = e => {
    const { name, value } = e.target;

    if (name === 'guest_email') {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      setPackageEmailError(value && !emailRegex.test(value) ? "Please enter a valid email address." : "");
    }
    if (name === 'guest_mobile') {
      setPackagePhoneError(value && !/^\+91\d{10}$/.test(value) ? "Please enter a valid Indian number (+91XXXXXXXXXX)." : "");
    }

    setPackageBookingForm(prev => {
      const updated = { ...prev, [name]: value };

      // When package is selected, check its booking_type
      if (name === 'package_id' && value) {
        const selectedPackage = packages.find(p => p.id === parseInt(value));
        if (selectedPackage) {
          // If whole_property, automatically select all available rooms (will be handled in useEffect)
          if (selectedPackage.booking_type === 'whole_property') {
            updated.room_ids = [];
          } else if (selectedPackage.booking_type === 'room_type') {
            // Clear room selection when switching packages
            updated.room_ids = [];
          }
        }
      }

      return updated;
    });
  };

  const handlePackageRoomSelect = roomId => {
    setPackageBookingForm(prev => ({
      ...prev,
      room_ids: prev.room_ids.includes(roomId)
        ? prev.room_ids.filter(id => id !== roomId)
        : [...prev.room_ids, roomId]
    }));
  };

  const handlePackageBookingSubmit = async e => {
    e.preventDefault();

    // Validation
    // Validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (packageBookingForm.guest_email && !emailRegex.test(packageBookingForm.guest_email)) {
      showBannerMessage("error", "Please enter a valid email address.");
      return;
    }
    // Validation: Check code logic
    if (packageBookingForm.guest_mobile && packageBookingForm.guest_mobile.startsWith("+91")) {
      if (!/^\+91\d{10}$/.test(packageBookingForm.guest_mobile)) {
        showBannerMessage("error", "Please enter a valid Indian phone number (+91XXXXXXXXXX).");
        return;
      }
    }

    // Prevent multiple submissions
    if (isSubmitting) {
      return;
    }

    setIsSubmitting(true);
    setFeedback({ message: "", type: "" });
    try {
      // --- MINIMUM BOOKING DURATION VALIDATION ---
      if (packageBookingForm.check_in && packageBookingForm.check_out) {
        const checkInDate = new Date(packageBookingForm.check_in);
        const checkOutDate = new Date(packageBookingForm.check_out);
        const timeDiff = checkOutDate.getTime() - checkInDate.getTime();
        const daysDiff = timeDiff / (1000 * 3600 * 24);

        if (daysDiff < 1) {
          showBannerMessage("error", "Minimum 1 day booking is mandatory. Check-out date must be at least 1 day after check-in date.");
          setIsSubmitting(false);
          return;
        }
      }

      // Check if package is whole_property - skip room validation
      const selectedPackage = packages.find(p => p.id === parseInt(packageBookingForm.package_id));
      if (!selectedPackage) {
        showBannerMessage("error", "Package not found. Please select a valid package.");
        setIsSubmitting(false);
        return;
      }

      // Determine if it's whole_property
      const isWholeProperty = selectedPackage.booking_type === 'whole_property';

      // For whole_property, get all available rooms and use them directly
      let finalRoomIds = packageBookingForm.room_ids;

      if (isWholeProperty) {
        // Use all available rooms from packageRooms (already filtered by availability)
        const availableRoomIds = packageRooms.map(r => r.id);

        if (availableRoomIds.length === 0) {
          showBannerMessage("error", "No rooms are available for the selected dates.");
          setIsSubmitting(false);
          return;
        }

        // Use all available rooms for whole_property
        finalRoomIds = availableRoomIds;
      } else {
        // For room_type packages, validate that at least one room is selected
        if (packageBookingForm.room_ids.length === 0) {
          showBannerMessage("error", "Please select at least one room for the package.");
          setIsSubmitting(false);
          return;
        }
        finalRoomIds = packageBookingForm.room_ids;
      }

      // --- CAPACITY VALIDATION ---
      // Skip capacity validation for whole_property packages (they book entire property regardless of guest count)
      if (!isWholeProperty) {
        const selectedPackageRooms = finalRoomIds
          .map(id => allRooms.find(r => r.id === id))
          .filter(room => room);

        const packageCapacity = {
          adults: selectedPackageRooms.reduce((sum, room) => sum + (room.adults || 0), 0),
          children: selectedPackageRooms.reduce((sum, room) => sum + (room.children || 0), 0)
        };

        const adultsRequested = parseInt(packageBookingForm.adults);
        const childrenRequested = parseInt(packageBookingForm.children);

        // Validate adults capacity
        if (adultsRequested > packageCapacity.adults) {
          showBannerMessage("error", `The number of adults (${adultsRequested}) exceeds the total adult capacity of the selected rooms (${packageCapacity.adults} adults max). Please select additional rooms or reduce the number of adults.`);
          setIsSubmitting(false);
          return;
        }

        // Validate children capacity
        if (childrenRequested > packageCapacity.children) {
          showBannerMessage("error", `The number of children (${childrenRequested}) exceeds the total children capacity of the selected rooms (${packageCapacity.children} children max). Please select additional rooms or reduce the number of children.`);
          setIsSubmitting(false);
          return;
        }
      }
      // -------------------------

      const bookingData = {
        ...packageBookingForm,
        package_id: parseInt(packageBookingForm.package_id),
        adults: parseInt(packageBookingForm.adults),
        children: parseInt(packageBookingForm.children),
        advance_amount: parseFloat(packageBookingForm.advance_amount) || 0,
        room_ids: finalRoomIds.map(id => parseInt(id)) // Use finalRoomIds (all available for whole_property, selected for room_type)
      };
      const response = await API.post("/packages/book", bookingData, authHeader());
      showBannerMessage("success", "Package booked successfully!");
      setPackageBookingForm({ package_id: "", guest_name: "", guest_email: "", guest_mobile: "+91", check_in: "", check_out: "", adults: 2, children: 0, room_ids: [], advance_amount: 0 });
      setPackageCountryCode(countryCodes.find(c => c.value === "+91"));
      setPackageMobileNumber("");
      setIsPackageBookingModalOpen(false); // Close modal

      // Add the new package booking to the state - use response data as-is from backend
      const newPackageBooking = {
        ...response.data,
        is_package: true
        // Backend already returns rooms in the response, so we don't need to reconstruct them
      };

      // Use functional update to prevent duplicates
      setBookings(prev => dedupeBookings([newPackageBooking, ...prev]));
    } catch (err) {
      console.error(err);
      const errorMessage = typeof err.response?.data?.detail === 'string'
        ? err.response.data.detail
        : (Array.isArray(err.response?.data?.detail)
          ? err.response.data.detail.map(e => e.msg).join(", ")
          : "Failed to process package booking.");
      showBannerMessage("error", errorMessage);
    } finally {
      setIsSubmitting(false);
    }
  };

  const totalCapacity = useMemo(() => {
    return {
      adults: selectedRoomDetails.reduce((sum, room) => sum + room.adults, 0),
      children: selectedRoomDetails.reduce((sum, room) => sum + room.children, 0),
      total: selectedRoomDetails.reduce((sum, room) => sum + (room.adults + room.children), 0)
    };
  }, [selectedRoomDetails]);

  // Generate unique booking ID for sharing - use display_id from API if available
  const generateBookingId = (booking) => {
    // Use display_id from API response if available (backend will provide BK-000001 or PK-000001)
    if (booking.display_id) {
      return booking.display_id;
    }
    // Fallback: generate it client-side if not provided
    const prefix = booking.is_package ? "PK" : "BK";
    const paddedId = String(booking.id).padStart(6, '0');
    return `${prefix}-${paddedId}`;
  };

  // Share booking via Email
  const shareViaEmail = (booking) => {
    const bookingId = generateBookingId(booking);
    const rooms = booking.rooms && booking.rooms.length > 0
      ? booking.rooms.map(r => {
        // Robust extraction: handle both nested (package API) and flat (details API) structures
        const roomObj = r.room || r;
        if (roomObj && roomObj.number) {
          return `Room ${roomObj.number}${roomObj.type ? ` (${roomObj.type})` : ''}`;
        }
        return '-';
      }).filter(r => r !== '-').join(", ")
      : "N/A";

    const subject = encodeURIComponent(`Booking Confirmation - ${bookingId}`);
    const body = encodeURIComponent(
      `Dear ${booking.guest_name},\n\n` +
      `Your booking has been confirmed!\n\n` +
      `Booking ID: ${bookingId}\n` +
      `Booking Type: ${booking.is_package ? "Package" : "Room"}\n` +
      `Rooms: ${rooms}\n` +
      `Check-in: ${booking.check_in}\n` +
      `Check-out: ${booking.check_out}\n` +
      `Guests: ${booking.adults} Adults, ${booking.children} Children\n` +
      `Status: ${booking.status}\n\n` +
      `Thank you for choosing our resort!\n\n` +
      `Best regards,\nResort Team`
    );
    window.location.href = `mailto:${booking.guest_email}?subject=${subject}&body=${body}`;
  };

  // Share booking via WhatsApp
  const shareViaWhatsApp = (booking) => {
    const bookingId = generateBookingId(booking);
    const mobile = booking.guest_mobile?.replace(/[^\d]/g, '') || '';

    if (!mobile) {
      showBannerMessage("error", "Mobile number not available for this booking.");
      return;
    }

    const rooms = booking.rooms && booking.rooms.length > 0
      ? booking.rooms.map(r => {
        // Robust extraction: handle both nested (package API) and flat (details API) structures
        const roomObj = r.room || r;
        if (roomObj && roomObj.number) {
          return `Room ${roomObj.number}${roomObj.type ? ` (${roomObj.type})` : ''}`;
        }
        return '-';
      }).filter(r => r !== '-').join(", ")
      : "N/A";

    const message = encodeURIComponent(
      `Dear ${booking.guest_name},\n\n` +
      `Your booking has been confirmed!\n\n` +
      `Booking ID: ${bookingId}\n` +
      `Booking Type: ${booking.is_package ? "Package" : "Room"}\n` +
      `Rooms: ${rooms}\n` +
      `Check-in: ${booking.check_in}\n` +
      `Check-out: ${booking.check_out}\n` +
      `Guests: ${booking.adults} Adults, ${booking.children} Children\n` +
      `Status: ${booking.status}\n\n` +
      `Thank you for choosing our resort!`
    );
    window.open(`https://wa.me/${mobile}?text=${message}`, '_blank');
  };

  // Calculate status counts for better filter clarity
  const statusCounts = useMemo(() => {
    const counts = {
      all: bookings.length,
      booked: 0,
      cancelled: 0,
      'checked-in': 0,
      'checked-out': 0,
    };

    bookings.forEach((b) => {
      const normalizedStatus = (b.status || '').toLowerCase().replace(/[-_]/g, '-').trim();
      if (normalizedStatus === 'booked') counts.booked++;
      else if (normalizedStatus === 'cancelled') counts.cancelled++;
      else if (normalizedStatus === 'checked-in' || normalizedStatus === 'checked_in') counts['checked-in']++;
      else if (normalizedStatus === 'checked-out' || normalizedStatus === 'checked_out') counts['checked-out']++;
    });

    return counts;
  }, [bookings]);

  const filteredBookings = useMemo(() => {
    const uniqueBookings = dedupeBookings(bookings);
    return uniqueBookings
      .filter((b) => {
        // Normalize status values - handle both hyphens and underscores
        const rawBookingStatus = b.status || '';
        let normalizedBookingStatus = rawBookingStatus.toLowerCase().trim();
        let normalizedFilterStatus = (statusFilter || '').toLowerCase().trim();

        // Normalize: replace underscores and hyphens with standard format
        normalizedBookingStatus = normalizedBookingStatus.replace(/[-_]/g, '-');
        normalizedFilterStatus = normalizedFilterStatus.replace(/[-_]/g, '-');

        // Exact match only - no substring matching
        let statusMatch = false;
        if (statusFilter === "All") {
          statusMatch = true;
        } else {
          // Normalize filter status for comparison
          const filterStatusLower = statusFilter.toLowerCase().trim();
          const normalizedStatus = normalizedBookingStatus;

          // Special handling for cancelled filter - be very strict
          if (filterStatusLower === 'cancelled' || normalizedFilterStatus === 'cancelled') {
            // First, check the raw status to see what we're dealing with
            const rawStatusLower = (rawBookingStatus || '').toLowerCase().trim();

            // Check if it's a cancelled status (exact match only, no variations)
            // Must be exactly "cancelled" or "canceled" (case-insensitive)
            const isCancelled =
              rawStatusLower === 'cancelled' ||
              rawStatusLower === 'canceled' ||
              normalizedStatus === 'cancelled' ||
              normalizedStatus === 'canceled';

            // Check if it's a checked-out status - be very explicit
            // Backend uses "checked_out" (underscore) or "checked-out" (hyphen)
            // We need to exclude ANY status that contains both "checked" and "out"
            const rawHasChecked = rawStatusLower.includes('checked');
            const rawHasOut = rawStatusLower.includes('out');
            const normHasChecked = normalizedStatus.includes('checked');
            const normHasOut = normalizedStatus.includes('out');

            const isCheckedOut =
              // Exact matches first
              rawStatusLower === 'checked_out' ||
              rawStatusLower === 'checked-out' ||
              rawStatusLower === 'checkedout' ||
              normalizedStatus === 'checked-out' ||
              normalizedStatus === 'checked_out' ||
              normalizedStatus === 'checkedout' ||
              // Then check if it contains both words
              (rawHasChecked && rawHasOut) ||
              (normHasChecked && normHasOut);

            // Debug logging for cancelled filter - always log when filtering for cancelled
            console.log(`[CANCELLED FILTER] Booking ${b.id || 'unknown'}: Raw="${rawBookingStatus}", RawLower="${rawStatusLower}", Normalized="${normalizedStatus}", Filter="${statusFilter}", IsCancelled=${isCancelled}, IsCheckedOut=${isCheckedOut}, WillMatch=${isCancelled && !isCheckedOut}`);

            // Only match if it's cancelled AND definitely not checked-out
            statusMatch = isCancelled && !isCheckedOut;
          } else {
            // For all other statuses, exact match after normalization
            statusMatch = normalizedBookingStatus === normalizedFilterStatus;
          }
        }
        const normalizedRoomFilterValue = roomNumberFilter === "All" ? null : String(roomNumberFilter).trim();
        const roomNumberMatch = !normalizedRoomFilterValue || (b.rooms && b.rooms.some((room) => extractRoomNumber(room) === normalizedRoomFilterValue));

        // Fix: Apply date filter to both check-in and check-out dates
        let dateMatch = true;

        if (fromDate || toDate) {
          const checkInDate = new Date(b.check_in);
          // Normalized times for accurate comparison (already default in JS Date from YYYY-MM-DD but explicit is good)
          checkInDate.setHours(0, 0, 0, 0);

          if (fromDate && toDate) {
            // Both dates specified: check-in date must be within range [from, to] inclusive
            const from = new Date(fromDate);
            const to = new Date(toDate);
            from.setHours(0, 0, 0, 0);
            to.setHours(0, 0, 0, 0);

            dateMatch = checkInDate >= from && checkInDate <= to;
          } else if (fromDate) {
            // Only from date specified: check-in date must be on or after this date
            const from = new Date(fromDate);
            from.setHours(0, 0, 0, 0);
            dateMatch = checkInDate >= from;
          } else if (toDate) {
            // Only to date specified: check-in date must be on or before this date
            const to = new Date(toDate);
            to.setHours(0, 0, 0, 0);
            dateMatch = checkInDate <= to;
          }
        }

        return statusMatch && roomNumberMatch && dateMatch;
      })
      .sort((a, b) => {
        // First, sort by status priority: booked (1), checked-in (2), checked-out (3), cancelled (4)
        const statusPriority = {
          'booked': 1,
          'checked-in': 2,
          'checked_in': 2,
          'checked-out': 3,
          'checked_out': 3,
          'cancelled': 4
        };

        const aStatus = a.status?.toLowerCase().replace(/[-_]/g, '-') || '';
        const bStatus = b.status?.toLowerCase().replace(/[-_]/g, '-') || '';

        const aPriority = statusPriority[aStatus] || 99;
        const bPriority = statusPriority[bStatus] || 99;

        // If statuses are different, sort by priority
        if (aPriority !== bPriority) {
          return aPriority - bPriority;
        }

        // If same status, sort by ID descending (latest first)
        return b.id - a.id;
      });
  }, [bookings, statusFilter, roomNumberFilter, fromDate, toDate, extractRoomNumber, dedupeBookings]);

  const handleRoomNumberToggle = (roomNumber) => {
    const isSelected = formData.roomNumbers.includes(roomNumber);
    let newRoomNumbers;
    if (isSelected) {
      newRoomNumbers = formData.roomNumbers.filter(num => num !== roomNumber);
    } else {
      newRoomNumbers = [...formData.roomNumbers, roomNumber];
    }
    setFormData(prev => ({ ...prev, roomNumbers: newRoomNumbers }));
  };

  const handleChange = (e) => {
    const { name, value } = e.target;

    if (name === 'guestEmail') {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      setEmailError(value && !emailRegex.test(value) ? "Please enter a valid email address." : "");
    }
    if (name === 'guestMobile') {
      setPhoneError(value && !/^\+91\d{10}$/.test(value) ? "Please enter a valid Indian number (+91XXXXXXXXXX)." : "");
    }

    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleRoomTypeChange = (e) => {
    const { value } = e.target;
    setFormData((prev) => ({ ...prev, roomTypes: [value], roomNumbers: [] }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Validation
    // Validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (formData.guestEmail && !emailRegex.test(formData.guestEmail)) {
      showBannerMessage("error", "Please enter a valid email address.");
      return;
    }
    // Validation: Check code logic
    if (formData.guestMobile && formData.guestMobile.startsWith("+91")) {
      if (!/^\+91\d{10}$/.test(formData.guestMobile)) {
        showBannerMessage("error", "Please enter a valid Indian phone number (+91XXXXXXXXXX).");
        return;
      }
    }

    // Prevent multiple submissions
    if (isSubmitting) {
      return;
    }

    setIsSubmitting(true);
    setFeedback({ message: "", type: "" });

    try {
      // --- MINIMUM BOOKING DURATION VALIDATION ---
      if (formData.checkIn && formData.checkOut) {
        const checkInDate = new Date(formData.checkIn);
        const checkOutDate = new Date(formData.checkOut);
        const timeDiff = checkOutDate.getTime() - checkInDate.getTime();
        const daysDiff = timeDiff / (1000 * 3600 * 24);

        if (daysDiff < 1) {
          showBannerMessage("error", "Minimum 1 day booking is mandatory. Check-out date must be at least 1 day after check-in date.");
          setIsSubmitting(false);
          return;
        }
      }

      if (formData.roomNumbers.length === 0) {
        showBannerMessage("error", "Please select at least one room.");
        setIsSubmitting(false);
        return;
      }

      const adultsRequested = parseInt(formData.adults);
      const childrenRequested = parseInt(formData.children);

      // Validate adults capacity
      if (adultsRequested > totalCapacity.adults) {
        showBannerMessage("error", `The number of adults (${adultsRequested}) exceeds the total adult capacity of the selected rooms (${totalCapacity.adults} adults max). Please select additional rooms or reduce the number of adults.`);
        setIsSubmitting(false);
        return;
      }

      // Validate children capacity
      if (childrenRequested > totalCapacity.children) {
        showBannerMessage("error", `The number of children (${childrenRequested}) exceeds the total children capacity of the selected rooms (${totalCapacity.children} children max). Please select additional rooms or reduce the number of children.`);
        setIsSubmitting(false);
        return;
      }

      const roomIds = formData.roomNumbers.map((roomNumber) => {
        const room = rooms.find((r) => r.number === roomNumber);
        return room ? room.id : null;
      }).filter(id => id !== null);

      if (roomIds.length !== formData.roomNumbers.length) {
        showBannerMessage("error", "One or more selected rooms are invalid.");
        setIsSubmitting(false);
        return;
      }

      const response = await API.post(
        "/bookings",
        {
          room_ids: roomIds,
          guest_name: formData.guestName,
          guest_mobile: formData.guestMobile,
          guest_email: formData.guestEmail,
          check_in: formData.checkIn,
          check_out: formData.checkOut,
          adults: parseInt(formData.adults),
          children: parseInt(formData.children),
          advance_amount: parseFloat(formData.advance_amount) || 0,
        },
        authHeader()
      );

      showBannerMessage("success", "Bookings created successfully!");
      setFormData({
        guestName: "",
        guestMobile: "+91",
        guestEmail: "",
        roomTypes: [],
        roomNumbers: [],
        checkIn: "",
        checkOut: "",
        adults: 1,
        children: 0,
        advance_amount: 0,
      });
      setRoomCountryCode(countryCodes.find(c => c.value === "+91"));
      setRoomMobileNumber("");
      setIsRoomBookingModalOpen(false); // Close modal
      // Add the new booking to the state - use response data as-is from backend
      const newBooking = {
        ...response.data,
        is_package: false
        // Backend already returns rooms in the response, so we don't need to reconstruct them
      };

      // Use functional update to prevent duplicates
      setBookings(prev => dedupeBookings([newBooking, ...prev]));
    } catch (err) {
      console.error("Booking creation error:", err);
      const errorMessage = typeof err.response?.data?.detail === 'string'
        ? err.response.data.detail
        : (Array.isArray(err.response?.data?.detail)
          ? err.response.data.detail.map(e => e.msg).join(", ")
          : "Failed to load more bookings.");
      showBannerMessage("error", errorMessage);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleExtendBooking = async (bookingId, newCheckoutDate) => {
    setFeedback({ message: "", type: "" });
    setIsSubmitting(true);

    try {
      // Find the booking from the current bookings list to get basic info
      // FIX: Use bookingToExtend if available to prevent ID collision issues (Regular vs Package with same ID)
      const booking = (bookingToExtend && bookingToExtend.id === bookingId)
        ? bookingToExtend
        : bookings.find(b => b.id === bookingId);

      if (!booking || !booking.id) {
        showBannerMessage("error", "Booking not found. Please refresh the page.");
        setIsSubmitting(false);
        setBookingToExtend(null);
        return;
      }

      // Determine booking type: 
      // - Room bookings: standalone room bookings from 'bookings' table (is_package = false)
      // - Package bookings: package bookings from 'package_bookings' table (is_package = true)
      //   Note: Rooms booked as part of a package are treated as package bookings
      const isPackage = booking.is_package || false;
      // Always build displayId based on isPackage flag to avoid wrong prefix (BK- vs PK-)
      const numericId = booking.id;
      const displayId = isPackage
        ? `PK-${String(numericId).padStart(6, '0')}`
        : `BK-${String(numericId).padStart(6, '0')}`;

      if (!displayId) {
        showBannerMessage("error", "Invalid booking ID. Please refresh the page.");
        setIsSubmitting(false);
        setBookingToExtend(null);
        return;
      }

      // Fetch fresh booking details from API to get the most current status
      let freshBooking = booking;
      try {
        const detailsResponse = await API.get(`/bookings/details/${displayId}?is_package=${isPackage}`, authHeader());
        if (detailsResponse.data) {
          freshBooking = { ...booking, ...detailsResponse.data, is_package: isPackage };
        }
      } catch (err) {
        console.warn('Could not fetch fresh booking details, using cached data:', err);
        // Continue with cached booking data
      }

      // Validate booking status - only allow "booked" or "checked-in" statuses
      if (!freshBooking.status) {
        showBannerMessage("error", "Booking status is missing. Please refresh the page.");
        setIsSubmitting(false);
        setBookingToExtend(null);
        return;
      }

      // Normalize status: handle both "checked-in", "checked_in", "checked-out", "checked_out" formats
      // Convert to lowercase and replace both hyphens and underscores with hyphens for consistent comparison
      const rawStatusLower = freshBooking.status.toLowerCase().trim();
      const normalizedStatus = rawStatusLower.replace(/[-_]/g, '-');

      // Debug: log the actual status for troubleshooting
      console.log('Extend booking - Booking ID:', bookingId, 'Display ID:', displayId, 'Original status:', freshBooking.status, 'Raw lower:', rawStatusLower, 'Normalized:', normalizedStatus, 'Is Package:', isPackage);

      // Check if status is valid for extension (booked or checked-in)
      // Handle multiple formats: "booked", "checked-in", "checked_in", "checked in"
      // Note: "checked_out" is NOT allowed (that means guest has already left)
      const isValidStatus =
        normalizedStatus === 'booked' ||
        normalizedStatus === 'checked-in' ||
        rawStatusLower === 'checked_in' ||
        rawStatusLower === 'checked-in' ||
        rawStatusLower === 'checked in';

      // Explicitly reject checked_out/checked-out statuses
      // Be careful: "checked-in" normalizes to "checked-in", "checked-out" normalizes to "checked-out"
      const isCheckedOut = (
        normalizedStatus.includes('out') && normalizedStatus.startsWith('checked-') && normalizedStatus.endsWith('-out')
      ) || ['checked_out', 'checked-out', 'checked out'].includes(rawStatusLower);

      if (isCheckedOut) {
        showBannerMessage("error", `Cannot extend checkout for booking with status '${freshBooking.status}'. The guest has already checked out.`);
        console.error('Booking already checked out:', {
          bookingId,
          displayId,
          originalStatus: freshBooking.status,
          normalizedStatus,
          rawStatusLower,
          isCheckedOut,
          isPackage: isPackage
        });
        setIsSubmitting(false);
        setBookingToExtend(null);
        return;
      }

      if (!isValidStatus) {
        // Show more detailed error message
        const statusDisplay = freshBooking.status || 'unknown';
        showBannerMessage("error", `Cannot extend checkout for booking with status '${statusDisplay}'. Only 'booked' or 'checked-in' bookings can be extended.`);
        console.error('Invalid status for extension:', {
          bookingId,
          displayId,
          originalStatus: freshBooking.status,
          rawStatusLower,
          normalizedStatus,
          isValidStatus,
          isPackage: isPackage
        });
        setIsSubmitting(false);
        setBookingToExtend(null);
        return;
      }

      // Use the correct endpoint based on booking type
      // Room bookings (from bookings table) use: /bookings/{id}/extend
      // Package bookings (from package_bookings table) use: /packages/booking/{id}/extend
      const url = isPackage
        ? `/packages/booking/${displayId}/extend?new_checkout=${newCheckoutDate}`
        : `/bookings/${displayId}/extend?new_checkout=${newCheckoutDate}`;

      console.log('Extending booking:', {
        bookingId,
        displayId,
        isPackage,
        url,
        status: freshBooking.status,
        newCheckoutDate
      });

      await API.put(
        url,
        {},
        authHeader()
      );

      showBannerMessage("success", "Booking checkout extended successfully!");
      setBookingToExtend(null);
      fetchData();
    } catch (err) {
      console.error("Booking extension error:", err);
      const errorMessage = err.response?.data?.detail || err.response?.data?.message || err.message || "Failed to extend booking.";
      showBannerMessage("error", errorMessage);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleCheckIn = async (bookingId, images) => {
    setFeedback({ message: "", type: "" });
    setIsSubmitting(true);

    // Double-check booking status before submitting
    const booking = bookings.find(b => b.id === bookingId && b.is_package === (bookingToCheckIn?.is_package || false));
    const normalizedStatus = booking?.status?.toLowerCase().replace(/[-_]/g, '');

    if (normalizedStatus !== 'booked') {
      console.error("Check-in blocked: Invalid booking status", { bookingId, status: booking?.status, normalizedStatus });
      showBannerMessage("error", `Cannot check in. Booking status is: ${booking?.status || 'unknown'}`);
      setBookingToCheckIn(null);
      setIsSubmitting(false);
      return;
    }

    const formData = new FormData();
    if (images.id_card_images && images.id_card_images.length > 0) {
      images.id_card_images.forEach(file => formData.append("id_card_images", file));
    }
    if (images.guest_photos && images.guest_photos.length > 0) {
      images.guest_photos.forEach(file => formData.append("guest_photos", file));
    }

    // Use display ID for API call
    const displayId = generateBookingId(booking || bookingToCheckIn);
    const url = booking?.is_package ? `/packages/booking/${displayId}/check-in` : `/bookings/${displayId}/check-in`;

    try {
      await API.put(url, formData, {
        headers: {
          ...authHeader().headers,
          "Content-Type": "multipart/form-data",
        },
      });

      // Fetch full booking details to get complete room information
      try {
        const detailsResponse = await API.get(`/bookings/details/${displayId}?is_package=${booking.is_package}`, authHeader());

        // Update the booking in the state with full details including rooms
        setBookings(prevBookings =>
          prevBookings.map(b =>
            (b.id === bookingId && b.is_package === booking.is_package)
              ? { ...b, ...detailsResponse.data }
              : b
          )
        );
      } catch (detailsErr) {
        console.error("Failed to fetch booking details after check-in:", detailsErr);
        // Fallback: just update status if details fetch fails
        setBookings(prevBookings =>
          prevBookings.map(b =>
            (b.id === bookingId && b.is_package === booking.is_package)
              ? { ...b, status: 'checked-in' }
              : b
          )
        );
      }

      showBannerMessage("success", "Guest checked in successfully!");
      setBookingToCheckIn(null);
    } catch (err) {
      console.error("Check-in error:", err);
      const errorMessage = typeof err.response?.data?.detail === 'string'
        ? err.response.data.detail
        : (Array.isArray(err.response?.data?.detail)
          ? err.response.data.detail.map(e => e.msg).join(", ")
          : "Failed to check in guest.");
      showBannerMessage("error", errorMessage);
    } finally {
      setIsSubmitting(false);
    }
  };


  const viewDetails = async (id, is_package) => {
    // Set a temporary booking to open the modal instantly, then fetch full details
    const tempBooking = bookings.find(b => b.id === id && b.is_package === is_package);
    setModalBooking(tempBooking || { guest_name: "Loading..." }); // Show a loading state

    try {
      // Use display ID for API call
      const displayId = tempBooking ? generateBookingId(tempBooking) : (is_package ? `PK-${String(id).padStart(6, '0')}` : `BK-${String(id).padStart(6, '0')}`);
      const response = await API.get(`/bookings/details/${displayId}?is_package=${is_package}`, authHeader());
      setModalBooking(response.data); // Update the modal with full, fresh data
    } catch (err) {
      console.error("Failed to fetch booking details:", err);
      showBannerMessage("error", "Could not load booking details.");
      // Close modal on error
      setModalBooking(null);
    }
  };

  const cancelBooking = async (id, is_package) => {
    if (!window.confirm("Are you sure you want to cancel this booking?")) return;
    try {
      // Find booking and get display ID
      const booking = bookings.find(b => b.id === id && b.is_package === is_package);
      const displayId = booking ? generateBookingId(booking) : (is_package ? `PK-${String(id).padStart(6, '0')}` : `BK-${String(id).padStart(6, '0')}`);

      // First fetch fresh details; if already cancelled, reflect immediately
      try {
        const fresh = await API.get(`/bookings/details/${displayId}?is_package=${is_package}`, authHeader());
        if (fresh?.data?.status && fresh.data.status.toLowerCase().includes('cancel')) {
          setBookings(prev => prev.map(b => (b.id === id && b.is_package === is_package) ? { ...b, ...fresh.data } : b));
          showBannerMessage("success", "Booking is already cancelled.");
          return;
        }
      } catch (_) { }

      const url = is_package ? `/packages/booking/${displayId}/cancel` : `/bookings/${displayId}/cancel`;
      const response = await API.put(url, {}, authHeader());
      showBannerMessage("success", "Booking cancelled successfully.");
      // Update the booking in state instead of refetching everything
      setBookings(prevBookings =>
        prevBookings.map(b =>
          (b.id === id && b.is_package === is_package) ? { ...b, ...response.data } : b
        )
      );
    } catch (err) {
      // If endpoint is unavailable but the booking is actually cancelled, reflect it
      if (err?.response?.status === 404) {
        try {
          const booking = bookings.find(b => b.id === id && b.is_package === is_package);
          const displayId = booking ? generateBookingId(booking) : (is_package ? `PK-${String(id).padStart(6, '0')}` : `BK-${String(id).padStart(6, '0')}`);
          const fresh = await API.get(`/bookings/details/${displayId}?is_package=${is_package}`, authHeader());
          if (fresh?.data) {
            setBookings(prev => prev.map(b => (b.id === id && b.is_package === is_package) ? { ...b, ...fresh.data } : b));
            const normalized = fresh.data.status?.toLowerCase() || '';
            if (normalized.includes('cancel')) {
              showBannerMessage("success", "Booking status synced to Cancelled.");
              return;
            }
          }
        } catch (_) { }
      }
      console.error("Failed to cancel booking:", err);
      showBannerMessage("error", "Failed to cancel booking.");
    }
  };


  const [activeTab, setActiveTab] = useState("all"); // "all" or "calendar"

  // Calendar State
  const [calendarStartDate, setCalendarStartDate] = useState(new Date().toISOString().split('T')[0]);
  const [calendarDays, setCalendarDays] = useState(15);

  const calendarDates = useMemo(() => {
    const dates = [];
    const start = new Date(calendarStartDate);
    for (let i = 0; i < calendarDays; i++) {
      const d = new Date(start);
      d.setDate(start.getDate() + i);
      dates.push(d.toISOString().split('T')[0]);
    }
    return dates;
  }, [calendarStartDate, calendarDays]);

  const BookingCalendar = () => {
    return (
      <div className="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden flex flex-col h-[70vh]">
        {/* Calendar Controls */}
        <div className="p-4 bg-gray-50 border-b border-gray-200 flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="flex flex-col">
              <label className="text-[10px] font-bold text-gray-500 uppercase tracking-widest mb-1">Start Date</label>
              <input 
                type="date" 
                value={calendarStartDate} 
                onChange={(e) => setCalendarStartDate(e.target.value)}
                className="p-2 bg-white border border-gray-200 rounded-lg text-sm font-semibold focus:ring-2 focus:ring-indigo-500 outline-none"
              />
            </div>
            <div className="flex flex-col">
              <label className="text-[10px] font-bold text-gray-500 uppercase tracking-widest mb-1">Duration</label>
              <select 
                value={calendarDays} 
                onChange={(e) => setCalendarDays(parseInt(e.target.value))}
                className="p-2 bg-white border border-gray-200 rounded-lg text-sm font-semibold focus:ring-2 focus:ring-indigo-500 outline-none"
              >
                <option value={7}>7 Days</option>
                <option value={15}>15 Days</option>
                <option value={30}>30 Days</option>
              </select>
            </div>
          </div>
          
          <div className="flex items-center gap-6 text-xs font-bold uppercase tracking-wider">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-green-500 shadow-sm shadow-green-100"></div>
              <span className="text-gray-600">Available</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-indigo-500 shadow-sm shadow-indigo-100"></div>
              <span className="text-gray-600">Booked</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-blue-500 shadow-sm shadow-blue-100"></div>
              <span className="text-gray-600">Checked-in</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-red-400 shadow-sm shadow-red-100"></div>
              <span className="text-gray-600">Maintenance</span>
            </div>
          </div>
        </div>

        {/* Grid Container */}
        <div className="flex-1 overflow-auto custom-scrollbar">
          <table className="w-full border-collapse table-fixed min-w-[1200px]">
            <thead className="sticky top-0 z-20 bg-white shadow-sm">
              <tr>
                <th className="w-48 p-4 text-left text-xs font-black text-indigo-600 uppercase tracking-widest border-r border-gray-100 bg-indigo-50/30">
                  Rooms / Dates
                </th>
                {calendarDates.map(date => {
                  const d = new Date(date);
                  const isToday = date === new Date().toISOString().split('T')[0];
                  return (
                    <th key={date} className={`p-4 text-center border-r border-gray-100 ${isToday ? 'bg-indigo-600 text-white' : 'text-gray-500'}`}>
                      <span className="block text-[10px] font-black uppercase tracking-tighter mb-0.5 opacity-80">
                        {d.toLocaleDateString('en-US', { weekday: 'short' })}
                      </span>
                      <span className="block text-lg font-black leading-tight">
                        {d.getDate()}
                      </span>
                      <span className="block text-[10px] font-bold uppercase">
                        {d.toLocaleDateString('en-US', { month: 'short' })}
                      </span>
                    </th>
                  );
                })}
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {/* Whole Property Section */}
              <tr className="bg-indigo-50/20 font-black">
                <td className="p-4 border-r border-gray-100 sticky left-0 z-10 bg-indigo-50 group-hover:bg-indigo-100 transition-colors shadow-[4px_0_10px_-4px_rgba(0,0,0,0.05)]">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-indigo-600 text-white flex items-center justify-center shadow-lg">
                      <i className="fas fa-hotel text-sm"></i>
                    </div>
                    <div>
                      <p className="text-indigo-900 text-sm leading-tight uppercase tracking-tighter">Whole Property</p>
                      <p className="text-[10px] font-bold text-indigo-400 uppercase tracking-widest mt-0.5">Status Summary</p>
                    </div>
                  </div>
                </td>
                {calendarDates.map(date => {
                  const targetDateStr = date;
                  // Check if ANY room is booked or if a Whole Property package is booked
                  const anyRoomBooked = bookings.some(b => {
                    const checkInStr = b.check_in?.toString().split('T')[0];
                    const checkOutStr = b.check_out?.toString().split('T')[0];
                    const isActive = ['booked', 'checked-in'].includes(b.status?.toLowerCase().replace(/[-_]/g, '-'));
                    return isActive && targetDateStr >= checkInStr && targetDateStr < checkOutStr;
                  });

                  return (
                    <td key={date} className="p-2 border-r border-gray-100 relative h-16 group/cell">
                      {anyRoomBooked ? (
                        <div className="absolute inset-1 rounded-lg bg-indigo-100 flex items-center justify-center text-indigo-700 border border-indigo-200">
                          <span className="text-[10px] font-black uppercase">Occupied</span>
                        </div>
                      ) : (
                        <>
                          <div className="absolute inset-1 rounded-lg bg-green-100 flex items-center justify-center text-green-700 border border-green-200 group-hover/cell:opacity-20 transition-opacity">
                            <span className="text-[10px] font-black uppercase">Free</span>
                          </div>
                          {/* Hover Actions */}
                          <div className="absolute inset-0 opacity-0 group-hover/cell:opacity-100 flex items-center justify-center gap-2 transition-all">
                            <button 
                              onClick={() => {
                                setPackageBookingForm(prev => ({ ...prev, check_in: date }));
                                setIsPackageBookingModalOpen(true);
                              }}
                              className="w-10 h-10 rounded-full bg-indigo-600 text-white shadow-xl flex items-center justify-center hover:bg-indigo-700 hover:scale-110 transition-all"
                              title="Book Package"
                            >
                              <i className="fas fa-box-open text-xs"></i>
                            </button>
                          </div>
                        </>
                      )}
                    </td>
                  );
                })}
              </tr>

              {/* Individual Rooms */}
              {allRooms.map(room => (
                <tr key={room.id} className="group hover:bg-gray-50 transition-colors">
                  <td className="p-4 border-r border-gray-100 sticky left-0 z-10 bg-white group-hover:bg-gray-50 transition-colors shadow-[4px_0_10px_-4px_rgba(0,0,0,0.05)]">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-black text-sm">
                        {room.number}
                      </div>
                      <div>
                        <p className="font-black text-gray-900 text-sm leading-tight">{room.type}</p>
                        <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mt-0.5">₹{room.price}</p>
                      </div>
                    </div>
                  </td>
                  {calendarDates.map(date => {
                    // Check if room is booked for this date using robust string comparison
                    const targetDateStr = date;
                    const booking = bookings.find(b => {
                      const checkInStr = b.check_in?.toString().split('T')[0];
                      const checkOutStr = b.check_out?.toString().split('T')[0];
                      
                      // Robust check for room ID in both standard and package bookings
                      const isRoomInBooking = b.rooms?.some(r => {
                        const roomId = r.room?.id || r.room_id || r.id;
                        return roomId === room.id;
                      });

                      const isActive = ['booked', 'checked-in'].includes(b.status?.toLowerCase().replace(/[-_]/g, '-'));
                      return isRoomInBooking && isActive && targetDateStr >= checkInStr && targetDateStr < checkOutStr;
                    });

                    const isMaintenance = room.status === 'Maintenance';
                    
                    let cellContent = null;
                    if (booking) {
                      const isCheckInDay = date === booking.check_in;
                      const isCheckedIn = (booking.status || '').toLowerCase().replace(/[-_]/g, '-') === 'checked-in';
                      cellContent = (
                        <div 
                          onClick={() => viewDetails(booking.id, booking.is_package)}
                          className={`absolute inset-1 rounded-lg shadow-sm flex flex-col items-center justify-center cursor-pointer transition-all hover:scale-105 active:scale-95 ${
                            isCheckedIn ? 'bg-blue-600 text-white' : 'bg-indigo-600 text-white'
                          }`}
                        >
                          <span className="text-[10px] font-black leading-none px-1 uppercase tracking-tighter">
                            {isCheckInDay ? booking.guest_name : 'NOT AVAILABLE'}
                          </span>
                        </div>
                      );
                    } else if (isMaintenance) {
                      cellContent = (
                        <div className="absolute inset-1 rounded-lg bg-red-100 flex items-center justify-center text-red-600 border border-red-200 border-dashed">
                          <span className="text-[10px] font-black uppercase">Blocked</span>
                        </div>
                      );
                    } else {
                      cellContent = (
                        <>
                          <div className="absolute inset-1 rounded-lg bg-green-50 flex items-center justify-center text-green-600 border border-green-100 border-dashed group-hover/cell:opacity-10 transition-opacity">
                            <span className="text-[10px] font-black uppercase tracking-widest">Available</span>
                          </div>
                          {/* Hover Actions */}
                          <div className="absolute inset-0 opacity-0 group-hover/cell:opacity-100 flex items-center justify-center gap-2 transition-all">
                            <button 
                              onClick={() => {
                                setFormData(prev => ({ ...prev, checkIn: date, roomNumbers: [room.number] }));
                                setIsRoomBookingModalOpen(true);
                              }}
                              className="w-8 h-8 rounded-full bg-green-600 text-white shadow-lg flex items-center justify-center hover:bg-green-700 hover:scale-110 transition-all"
                              title="Book Room"
                            >
                              <i className="fas fa-plus text-xs"></i>
                            </button>
                            <button 
                              onClick={() => {
                                setPackageBookingForm(prev => ({ ...prev, check_in: date }));
                                setIsPackageBookingModalOpen(true);
                              }}
                              className="w-8 h-8 rounded-full bg-indigo-600 text-white shadow-lg flex items-center justify-center hover:bg-indigo-700 hover:scale-110 transition-all"
                              title="Book Package"
                            >
                              <i className="fas fa-box-open text-[10px]"></i>
                            </button>
                          </div>
                        </>
                      );
                    }

                    return (
                      <td key={date} className="p-2 border-r border-gray-100 relative h-16 group/cell">
                        {cellContent}
                      </td>
                    );
                  })}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    );
  };
  
  return (
    <DashboardLayout>
      <BannerMessage
        message={bannerMessage}
        onClose={closeBannerMessage}
        autoDismiss={true}
        duration={5000}
      />
      {/* Animated Background */}


      <div className="p-4 sm:p-6 lg:p-8 space-y-8 bg-gray-100 min-h-screen font-sans">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <h1 className="text-3xl sm:text-4xl font-extrabold text-gray-800 tracking-tight">Booking Management</h1>
          
          {/* Tab Navigation */}
          <div className="bg-white p-1 rounded-xl shadow-md border border-gray-200 flex self-start">
            <button
              onClick={() => setActiveTab("all")}
              className={`px-6 py-2.5 rounded-lg text-sm font-bold transition-all duration-200 flex items-center gap-2 ${
                activeTab === "all" 
                  ? "bg-indigo-600 text-white shadow-lg" 
                  : "text-gray-500 hover:text-gray-700 hover:bg-gray-50"
              }`}
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
              All Bookings
            </button>
            <button
              onClick={() => setActiveTab("calendar")}
              className={`px-6 py-2.5 rounded-lg text-sm font-bold transition-all duration-200 flex items-center gap-2 ${
                activeTab === "calendar" 
                  ? "bg-indigo-600 text-white shadow-lg" 
                  : "text-gray-500 hover:text-gray-700 hover:bg-gray-50"
              }`}
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              Calendar View
            </button>
          </div>
        </div>

        {activeTab === "all" ? (
          <>
            {/* KPI Row and Chart */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-6">
          <KPI_Card title="Total Bookings" value={kpis.activeBookings} />
          <KPI_Card title="Cancelled Bookings" value={kpis.cancelledBookings} />
          <KPI_Card title="Available Rooms" value={kpis.availableRooms} />
          <KPI_Card title="Guests Today Check-in" value={kpis.todaysGuestsCheckin} />
          <KPI_Card title="Guests Today Check-out" value={kpis.todaysGuestsCheckout} />
        </div>

        {/* Booking Form & Chart Section */}
        {/* Action Buttons for Booking & Package */}
        <div className="flex flex-col sm:flex-row gap-6 mb-8">
          <button
            onClick={() => setIsRoomBookingModalOpen(true)}
            className="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-6 px-8 rounded-2xl shadow-xl transition-all transform hover:-translate-y-1 flex items-center justify-center gap-4 group"
          >
            <div className="bg-white/20 p-3 rounded-full group-hover:scale-110 transition-transform">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <div className="text-left">
              <span className="block text-2xl">Create Room Booking</span>
              <span className="text-indigo-200 text-sm font-normal">Book rooms for guests</span>
            </div>
          </button>

          <button
            onClick={() => setIsPackageBookingModalOpen(true)}
            className="flex-1 bg-purple-600 hover:bg-purple-700 text-white font-bold py-6 px-8 rounded-2xl shadow-xl transition-all transform hover:-translate-y-1 flex items-center justify-center gap-4 group"
          >
            <div className="bg-white/20 p-3 rounded-full group-hover:scale-110 transition-transform">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
              </svg>
            </div>
            <div className="text-left">
              <span className="block text-2xl">Book a Package</span>
              <span className="text-indigo-200 text-sm font-normal">Special offers & events</span>
            </div>
          </button>
        </div>

        {/* Bookings Table */}
        <div className="bg-white p-3 sm:p-6 md:p-8 rounded-xl sm:rounded-2xl shadow-lg overflow-x-auto -mx-2 sm:mx-0">
          <div className="flex flex-col sm:flex-row flex-wrap gap-3 sm:gap-4 justify-between items-start sm:items-center mb-4 sm:mb-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center gap-2">
              <h2 className="text-xl sm:text-2xl font-bold text-gray-700">All Bookings</h2>
              <span className="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                Showing {filteredBookings.length} of {statusCounts.all} bookings
              </span>
            </div>
            <div className="flex flex-col sm:flex-row flex-wrap gap-2 sm:gap-3 items-stretch sm:items-center w-full sm:w-auto">
              <div className="flex flex-col w-full sm:w-auto">
                <label className="text-xs text-gray-600 mb-1 font-medium">Filter by Status:</label>
                <select // Status Filter
                  value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}
                  className="border-gray-300 rounded-lg p-2 shadow-sm text-sm w-full sm:w-auto bg-white hover:border-blue-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                >
                  <option value="All">All Statuses ({statusCounts.all})</option>
                  <option value="booked">📅 Booked ({statusCounts.booked})</option>
                  <option value="checked-in">✅ Checked-in ({statusCounts['checked-in']})</option>
                  <option value="checked-out">🚪 Checked-out ({statusCounts['checked-out']})</option>
                  <option value="cancelled">❌ Cancelled ({statusCounts.cancelled})</option>
                </select>
              </div>
              <div className="flex flex-col w-full sm:w-auto">
                <label className="text-xs text-gray-600 mb-1 font-medium">Filter by Room:</label>
                <select // Room Number Filter
                  value={roomNumberFilter} onChange={(e) => setRoomNumberFilter(e.target.value)}
                  className="border-gray-300 rounded-lg p-2 shadow-sm text-sm w-full sm:w-auto bg-white hover:border-blue-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                >
                  {allRoomNumbers.map(roomNumber => (
                    <option key={roomNumber} value={roomNumber}>{roomNumber === "All" ? "All Rooms" : `Room ${roomNumber}`}</option>
                  ))}
                </select>
              </div>
              <div className="flex flex-col w-full sm:w-auto">
                <label className="text-xs text-gray-600 mb-1 font-medium">From Date:</label>
                <input // From Date
                  type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)}
                  className="border-gray-300 rounded-lg p-2 shadow-sm text-sm w-full sm:w-auto bg-white hover:border-blue-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                />
              </div>
              <div className="flex flex-col w-full sm:w-auto">
                <label className="text-xs text-gray-600 mb-1 font-medium">To Date:</label>
                <input // To Date
                  type="date" value={toDate} onChange={(e) => setToDate(e.target.value)}
                  className="border-gray-300 rounded-lg p-2 shadow-sm text-sm w-full sm:w-auto bg-white hover:border-blue-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
                />
              </div>
              {(statusFilter !== "All" || roomNumberFilter !== "All" || fromDate || toDate) && (
                <button
                  onClick={() => {
                    setStatusFilter("All");
                    setRoomNumberFilter("All");
                    setFromDate("");
                    setToDate("");
                  }}
                  className="text-xs text-blue-600 hover:text-blue-700 font-medium px-3 py-2 border border-blue-300 rounded-lg hover:bg-blue-50 transition-colors self-end sm:self-center"
                  title="Clear all filters"
                >
                  Clear Filters
                </button>
              )}
            </div>
          </div>

          <div className="overflow-x-auto -mx-2 sm:mx-0">
            <table className="min-w-full text-xs sm:text-sm border-collapse rounded-xl">
              <thead className="bg-gray-100">
                <tr>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-gray-800">ID</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-gray-800">Guest</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-gray-800 hidden md:table-cell">Type</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-indigo-600 hidden md:table-cell">Source / OTA</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-gray-800">Rooms</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-gray-800 hidden lg:table-cell">Check-in</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-gray-800 hidden lg:table-cell">Check-out</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-gray-800 hidden sm:table-cell">Guests</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-left text-xs font-semibold uppercase tracking-wider text-gray-800">Status</th>
                  <th className="p-2 sm:p-4 border-b border-gray-200 text-center text-xs font-semibold uppercase tracking-wider text-gray-800">Actions</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredBookings.length > 0 ? (
                  filteredBookings.map((b, index) => (
                    <motion.tr
                      key={`${b.is_package ? 'PK' : 'BK'}_${b.id}_${index}`}
                      className="hover:bg-gray-50 transition-colors"
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ duration: 0.3, delay: index * 0.05 }}
                    >
                      <td className="p-2 sm:p-4">
                        <div className="font-mono text-xs sm:text-sm font-semibold text-gray-900">{generateBookingId(b)}</div>
                      </td>
                      <td className="p-2 sm:p-4 font-medium text-gray-900 text-xs sm:text-sm">
                        {b.guest_name}
                      </td>
                      <td className="p-2 sm:p-4 hidden md:table-cell">
                        {b.is_package ? (
                          <span className="bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full text-xs font-semibold">
                            {b.package?.title || 'Package'}
                          </span>
                        ) : (
                          <span className="bg-gray-100 text-gray-700 px-2 py-0.5 rounded-full text-xs font-semibold">Room</span>
                        )}
                      </td>
                      <td className="p-2 sm:p-4 hidden md:table-cell text-xs sm:text-sm">
                        {b.source ? (
                          <span className="bg-indigo-50 text-indigo-700 px-2 py-0.5 rounded-full text-xs font-semibold border border-indigo-100 uppercase tracking-wide">
                            {b.source}
                          </span>
                        ) : (
                          <span className="text-gray-500 font-medium bg-gray-50 px-2 py-0.5 rounded-full text-xs border border-gray-200">Direct</span>
                        )}
                      </td>
                      <td className="p-2 sm:p-4 text-xs sm:text-sm">
                        {b.rooms && b.rooms.length > 0 ? (
                          b.rooms.map((roomItem, idx) => {
                            // Robust extraction: handle both nested (package API) and flat (details API) structures
                            // This works regardless of 'is_package' flag or API source
                            const roomObj = roomItem.room || roomItem;

                            if (roomObj && roomObj.number) {
                              return (
                                <span key={idx} className="block">
                                  {roomObj.number}{roomObj.type ? ` (${roomObj.type})` : ''}{idx < b.rooms.length - 1 ? ', ' : ''}
                                </span>
                              );
                            }
                            return null;
                          })
                        ) : "-"}
                      </td>
                      <td className="p-2 sm:p-4 text-gray-800 text-xs hidden lg:table-cell">{b.check_in}</td>
                      <td className="p-2 sm:p-4 text-gray-800 text-xs hidden lg:table-cell">{b.check_out}</td>
                      <td className="p-2 sm:p-4 text-gray-800 text-xs hidden sm:table-cell">{b.adults} A, {b.children} C</td>
                      <td className="p-2 sm:p-4">
                        <BookingStatusBadge status={b.status || "Pending"} />
                      </td>
                      <td className="p-2 sm:p-4 text-center">
                        <div className="flex flex-wrap gap-1 sm:gap-2 justify-center">
                          <button
                            onClick={() => viewDetails(b.id, b.is_package)}
                            className="bg-blue-600 text-white px-2 sm:px-3 py-1 rounded-full text-xs font-semibold hover:bg-blue-700 transition-colors"
                          >
                            View
                          </button>
                          <button
                            onClick={async () => {
                              try {
                                // Check if early check-in
                                const checkInDate = new Date(b.check_in);
                                const today = new Date();
                                today.setHours(0, 0, 0, 0); // Normalize today to midnight

                                // Create a normalize check-in date (local time YYYY-MM-DD from string) to compare dates only
                                const checkInString = b.check_in.toString().split('T')[0];
                                const todayString = today.toLocaleDateString("en-CA"); // YYYY-MM-DD

                                if (checkInString > todayString) {
                                  // Open modern confirmation modal instead of window.confirm
                                  setEarlyCheckInBooking(b);
                                  return;
                                }

                                // Use display ID for API call
                                const displayId = generateBookingId(b);
                                const response = await API.get(`/bookings/details/${displayId}?is_package=${b.is_package}`, authHeader());
                                setBookingToCheckIn({ ...b, ...response.data });
                              } catch (e) {
                                // Fallback to existing data if details fetch fails
                                setBookingToCheckIn(b);
                              }
                            }}
                            className="bg-yellow-500 text-white px-2 sm:px-3 py-1 rounded-full text-xs font-semibold hover:bg-yellow-600 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed"
                            disabled={(() => {
                              const isBooked = b.status && b.status.toLowerCase().replace(/[-_]/g, '') === 'booked';
                              return !isBooked;
                            })()}
                            title={(() => {
                              const isBooked = b.status && b.status.toLowerCase().replace(/[-_]/g, '') === 'booked';
                              return isBooked ? "Check-in Guest" : "Booking must be in 'Booked' status";
                            })()}
                          >
                            Check-in
                          </button>
                          <button
                            onClick={() => {
                              // Safety check: ensure booking has required properties before opening modal
                              if (!b || !b.id || !b.check_out) {
                                showBannerMessage("error", "Invalid booking data. Please refresh the page.");
                                return;
                              }

                              // Additional safety check: prevent extending checked-out bookings
                              // Be careful: "checked-in" normalizes to "checked-in", "checked-out" normalizes to "checked-out"
                              const rawStatusLower = b.status?.toLowerCase().trim() || '';
                              const normalizedStatus = rawStatusLower.replace(/[-_]/g, '-');
                              const isCheckedOut = (
                                normalizedStatus.includes('out') && normalizedStatus.startsWith('checked-') && normalizedStatus.endsWith('-out')
                              ) || ['checked_out', 'checked-out', 'checked out'].includes(rawStatusLower);

                              if (isCheckedOut) {
                                showBannerMessage("error", `Cannot extend checkout for booking with status '${b.status}'. The guest has already checked out.`);
                                return;
                              }

                              setBookingToExtend(b);
                            }}
                            className="bg-green-600 text-white px-2 sm:px-3 py-1 rounded-full text-xs font-semibold hover:bg-green-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed"
                            disabled={(() => {
                              if (!b || !b.status) return true;
                              const rawStatusLower = b.status.toLowerCase().trim();
                              const normalizedStatus = rawStatusLower.replace(/[-_]/g, '-');

                              // Explicitly reject checked-out/checked_out statuses (guest has already left)
                              // Be careful: "checked-in" normalizes to "checked-in", "checked-out" normalizes to "checked-out"
                              const isCheckedOut = (
                                normalizedStatus.includes('out') && normalizedStatus.startsWith('checked-') && normalizedStatus.endsWith('-out')
                              ) || ['checked_out', 'checked-out', 'checked out'].includes(rawStatusLower);

                              if (isCheckedOut) {
                                return true; // Disable button for checked-out bookings
                              }

                              // Enable extend button for both "booked" and "checked-in" statuses (for both room and package bookings)
                              // Handle both "checked-in" and "checked_in" formats
                              const isValidStatus = normalizedStatus === 'booked' || normalizedStatus === 'checked-in';
                              return !isValidStatus;
                            })()}
                          >
                            Extend
                          </button>
                          <button
                            onClick={() => cancelBooking(b.id, b.is_package)}
                            className="bg-red-600 text-white px-2 sm:px-3 py-1 rounded-full text-xs font-semibold hover:bg-red-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed"
                            disabled={b.status && b.status.toLowerCase().replace(/[-_]/g, '') !== 'booked'}
                          >
                            Cancel
                          </button>
                          {b.guest_email && (
                            <button
                              onClick={() => shareViaEmail(b)}
                              className="bg-purple-600 text-white px-2 sm:px-3 py-1 rounded-full text-xs font-semibold hover:bg-purple-700 transition-colors"
                              title={`Share Booking ID: ${generateBookingId(b)} via Email`}
                            >
                              📧
                            </button>
                          )}
                          {b.guest_mobile && (
                            <button
                              onClick={() => shareViaWhatsApp(b)}
                              className="bg-green-600 text-white px-2 sm:px-3 py-1 rounded-full text-xs font-semibold hover:bg-green-700 transition-colors"
                              title={`Share Booking ID: ${generateBookingId(b)} via WhatsApp`}
                            >
                              💬
                            </button>
                          )}
                        </div>
                      </td>
                    </motion.tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="9" className="text-center py-6 text-gray-500 italic text-sm sm:text-base">
                      No bookings found.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
          {/* Pagination Controls */}
          {totalPages > 1 && (
            <div className="flex justify-center items-center py-4 space-x-2 border-t border-gray-100 mt-4">
              <button
                onClick={() => setPage(prev => Math.max(prev - 1, 1))}
                disabled={page === 1}
                className={`px-4 py-2 rounded-lg ${page === 1 ? 'bg-gray-200 text-gray-400 cursor-not-allowed' : 'bg-white text-indigo-600 hover:bg-indigo-50 border border-indigo-200'} transition-colors duration-200`}
              >
                Previous
              </button>

              <span className="text-gray-600 font-medium px-4">
                Page {page} of {totalPages}
              </span>

              <button
                onClick={() => setPage(prev => (prev < totalPages ? prev + 1 : prev))}
                disabled={page === totalPages}
                className={`px-4 py-2 rounded-lg ${page === totalPages ? 'bg-gray-200 text-gray-400 cursor-not-allowed' : 'bg-white text-indigo-600 hover:bg-indigo-50 border border-indigo-200'} transition-colors duration-200`}
              >
                Next
              </button>
            </div>
          )}
        </div>
          </>
        ) : (
          <BookingCalendar />
        )}
      </div>
      <AnimatePresence>
        {modalBooking && (
          <BookingDetailsModal
            booking={modalBooking}
            onClose={() => setModalBooking(null)}
            onImageClick={(imageUrl) => setSelectedImage(imageUrl)}
            roomIdToRoom={roomIdToRoom}
          />
        )}
        {bookingToExtend && (
          <ExtendBookingModal
            booking={bookingToExtend}
            onClose={() => setBookingToExtend(null)}
            onSave={handleExtendBooking}
            feedback={feedback}
            isSubmitting={isSubmitting}
          />
        )}
        {bookingToCheckIn && (
          <CheckInModal
            booking={bookingToCheckIn}
            onClose={() => setBookingToCheckIn(null)}
            onSave={handleCheckIn}
            feedback={feedback}
            isSubmitting={isSubmitting}
          />
        )}
        {selectedImage && <ImageModal imageUrl={selectedImage} onClose={() => setSelectedImage(null)} />}
        {earlyCheckInBooking && (
          <EarlyCheckInModal
            booking={earlyCheckInBooking}
            onClose={() => setEarlyCheckInBooking(null)}
            onConfirm={async (b) => {
              setEarlyCheckInBooking(null); // Close warning modal
              try {
                // Proceed with fetching details and opening check-in modal
                const displayId = generateBookingId(b);
                const response = await API.get(`/bookings/details/${displayId}?is_package=${b.is_package}`, authHeader());
                setBookingToCheckIn({ ...b, ...response.data });
              } catch (e) {
                setBookingToCheckIn(b);
              }
            }}
          />
        )}
      </AnimatePresence>

      {/* Modal for Create Room Booking */}
      <Modal
        isOpen={isRoomBookingModalOpen}
        title="Create New Room Booking"
        onClose={() => setIsRoomBookingModalOpen(false)}
      >
        {feedback.message && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            className={`mb-4 p-4 rounded-lg text-sm font-semibold ${feedback.type === "success"
              ? "bg-green-100 text-green-800"
              : "bg-red-100 text-red-800"
              }`}
          >
            {feedback.message}
          </motion.div>
        )}
        <form onSubmit={handleSubmit} className="flex flex-col space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="flex flex-col">
              <label className="text-sm font-medium text-gray-700 mb-1">Guest Name</label>
              <input
                type="text" name="guestName" value={formData.guestName}
                onChange={handleChange} placeholder="Enter guest's full name"
                className="w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500"
                required
              />
            </div>
            <div className="flex flex-col">
              <label className="text-sm font-medium text-gray-700 mb-1">Mobile Number</label>
              <div className="flex">
                <div className="w-40 mr-2">
                  <Select
                    options={countryCodes}
                    value={roomCountryCode}
                    onChange={handleRoomCountryChange}
                    className="text-sm"
                    styles={{
                      control: (base) => ({ ...base, minHeight: '42px', borderRadius: '0.5rem', borderColor: '#d1d5db' })
                    }}
                  />
                </div>
                <input
                  type="text"
                  value={roomMobileNumber}
                  onChange={handleRoomMobileChange}
                  placeholder="Enter Mobile Number"
                  className={`flex-1 border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500 ${phoneError ? 'border-red-500 focus:border-red-500 focus:ring-red-200' : ''}`}
                  required
                />
              </div>
              {phoneError && <p className="text-xs text-red-500 mt-1">{phoneError}</p>}
            </div>
            <div className="flex flex-col md:col-span-2">
              <label className="text-sm font-medium text-gray-700 mb-1">Email</label>
              <input
                type="email" name="guestEmail" value={formData.guestEmail}
                onChange={handleChange} placeholder="email@example.com"
                className={`w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500 ${emailError ? 'border-red-500 focus:border-red-500 focus:ring-red-200' : ''}`}
                required
              />
              {emailError && <p className="text-xs text-red-500 mt-1">{emailError}</p>}
            </div>

            <div className="flex flex-col">
              <label className="text-sm font-medium text-gray-700 mb-1">Check-in Date</label>
              <input
                type="date" name="checkIn" value={formData.checkIn}
                onChange={handleChange} min={today}
                className="w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500"
                required
              />
            </div>
            <div className="flex flex-col">
              <label className="text-sm font-medium text-gray-700 mb-1">Check-out Date</label>
              <input
                type="date" name="checkOut" value={formData.checkOut}
                onChange={handleChange} min={getNextDay(formData.checkIn)}
                className="w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500"
                required
              />
            </div>

            <div className="flex flex-col">
              <label className="text-sm font-medium text-gray-700 mb-1">Room type</label>
              <select
                name="roomTypes" value={formData.roomTypes[0] || ""}
                onChange={handleRoomTypeChange}
                className="w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500"
                required
              >
                <option value="">Select Room Type</option>
                <option value="All Rooms">All Rooms</option>
                {roomTypes.map((type, idx) => (
                  <option key={idx} value={type}>{type}</option>
                ))}
              </select>
            </div>

            <div className="flex flex-col">
              <label className="text-sm font-medium text-gray-700 mb-1">Number of Adults</label>
              <input
                type="number" name="adults" value={formData.adults}
                onChange={handleChange}
                className="w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500"
                min="1"
                required
              />
            </div>

            <div className="flex flex-col">
              <label className="text-sm font-medium text-gray-700 mb-1">Number of Children</label>
              <input
                type="number" name="children" value={formData.children}
                onChange={handleChange}
                className="w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500"
                min="0"
                required
              />
            </div>

            <div className="flex flex-col">
              <label className="text-sm font-medium text-gray-700 mb-1">Advance Amount</label>
              <input
                type="number" name="advance_amount" value={formData.advance_amount}
                onChange={handleChange}
                className="w-full border-gray-300 rounded-lg shadow-sm p-2 transition-colors focus:border-indigo-500 focus:ring-indigo-500"
                min="0"
              />
            </div>

            <div className="flex flex-col md:col-span-2">
              <label className="text-sm font-medium text-gray-700 mb-1">
                Available Rooms for Selected Dates
                {formData.checkIn && formData.checkOut && (
                  <span className="text-xs text-gray-500 ml-2">
                    ({formData.checkIn} to {formData.checkOut})
                  </span>
                )}
              </label>
              <AnimatePresence mode="wait">
                {formData.roomTypes.length > 0 && (
                  <motion.div
                    key={formData.roomTypes[0]}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -10 }}
                    transition={{ duration: 0.3 }}
                  >
                    <RoomSelection
                      rooms={filteredRooms}
                      selectedRoomNumbers={formData.roomNumbers}
                      onRoomToggle={handleRoomNumberToggle}
                    />
                  </motion.div>
                )}
              </AnimatePresence>
              {!formData.checkIn || !formData.checkOut ? (
                <div className="text-center py-8 text-gray-500 text-sm border-2 border-dashed border-gray-200 rounded-xl h-32 flex flex-col items-center justify-center">
                  <p>Please select check-in and check-out dates first</p>
                  <p className="text-xs mt-1">Available rooms will be shown here</p>
                </div>
              ) : null}
            </div>
          </div>

          <button
            type="submit"
            className="mt-6 w-full bg-indigo-600 text-white font-semibold py-3 rounded-lg hover:bg-indigo-700 transition-colors duration-200 disabled:bg-gray-400 disabled:cursor-not-allowed"
            disabled={isSubmitting || isLoading}
          >
            {isSubmitting ? "Creating..." : "Create Booking"}
          </button>
        </form>
      </Modal>

      {/* Modal for Book a Package */}
      <Modal
        isOpen={isPackageBookingModalOpen}
        title="Book a Package"
        onClose={() => setIsPackageBookingModalOpen(false)}
      >
        <form onSubmit={handlePackageBookingSubmit} className="flex flex-col space-y-4">
          <div className="space-y-4 flex-grow">
            <select name="package_id" value={packageBookingForm.package_id} onChange={handlePackageBookingChange} className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all" required>
              <option value="">Select Package</option>
              {packages.filter(p => {
                const status = (p.status || '').toLowerCase();
                return status !== 'disabled' && status !== 'coming soon' && status !== 'comming soon';
              }).map(p => {
                const bookingTypeLabel = p.booking_type === 'whole_property' ? ' (Whole Property)' : p.booking_type === 'room_type' ? ' (Selected Rooms)' : '';
                return <option key={p.id} value={p.id}>{p.title}{bookingTypeLabel} - {formatCurrency(p.price)}</option>;
              })}
            </select>
            <input name="guest_name" placeholder="Guest Name" value={packageBookingForm.guest_name} onChange={handlePackageBookingChange} className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all" required />
            <div>
              <input type="email" name="guest_email" placeholder="Guest Email" value={packageBookingForm.guest_email} onChange={handlePackageBookingChange} className={`w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all ${packageEmailError ? 'border-red-500 focus:border-red-500 focus:ring-red-200' : ''}`} />
              {packageEmailError && <p className="text-xs text-red-500 mt-1">{packageEmailError}</p>}
            </div>
            <div>
              <div className="flex">
                <div className="w-40 mr-2">
                  <Select
                    options={countryCodes}
                    value={packageCountryCode}
                    onChange={handlePackageCountryChange}
                    className="text-sm"
                    styles={{
                      control: (base) => ({ ...base, minHeight: '42px', borderRadius: '0.5rem', borderColor: '#d1d5db' })
                    }}
                  />
                </div>
                <input
                  value={packageMobileNumber}
                  onChange={handlePackageMobileChange}
                  placeholder="Guest Mobile"
                  className={`flex-1 p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring-indigo-200 transition-all ${packagePhoneError ? 'border-red-500 focus:border-red-500 focus:ring-red-200' : ''}`}
                  required
                />
              </div>
              {packagePhoneError && <p className="text-xs text-red-500 mt-1">{packagePhoneError}</p>}
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <input type="date" name="check_in" value={packageBookingForm.check_in} min={today} onChange={handlePackageBookingChange} className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all" required />
              <input type="date" name="check_out" value={packageBookingForm.check_out} min={getNextDay(packageBookingForm.check_in)} onChange={handlePackageBookingChange} className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all" required />
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <input type="number" name="adults" min={1} placeholder="Adults" value={packageBookingForm.adults} onChange={handlePackageBookingChange} className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all" required />
              <input type="number" name="children" min={0} placeholder="Children" value={packageBookingForm.children} onChange={handlePackageBookingChange} className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all" />
              <input type="number" name="advance_amount" min={0} placeholder="Advance Amount" value={packageBookingForm.advance_amount} onChange={handlePackageBookingChange} className="w-full p-3 rounded-lg border border-gray-300 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all sm:col-span-2" />
            </div>
            {/* Room Selection - Only show for room_type packages */}
            {(() => {
              const selectedPackage = packages.find(p => p.id === parseInt(packageBookingForm.package_id));

              if (!selectedPackage) {
                return null;
              }

              // Determine if it's whole_property:
              // 1. If booking_type is explicitly 'whole_property'
              // 2. If booking_type is not set AND room_types is not set (legacy packages without booking_type)
              const hasRoomTypes = selectedPackage.room_types && selectedPackage.room_types.trim().length > 0;
              const isWholeProperty = selectedPackage.booking_type === 'whole_property' ||
                selectedPackage.booking_type === 'whole property' ||
                (!selectedPackage.booking_type && !hasRoomTypes);

              // Hide room selection completely for whole_property
              if (isWholeProperty) {
                if (isWholePropertyBlocked) {
                  return (
                    <div className="bg-red-50 border-2 border-red-300 rounded-lg p-4">
                      <p className="text-sm font-semibold text-red-800">Property Unavailable</p>
                      <p className="text-xs text-red-600 mt-1">
                        The whole property cannot be booked because some rooms are already occupied or unavailable for the selected dates.
                      </p>
                    </div>
                  );
                }
                return (
                  <div className="bg-indigo-50 border-2 border-indigo-300 rounded-lg p-4">
                    <p className="text-sm font-semibold text-indigo-800">Whole Property Package</p>
                    <p className="text-xs text-indigo-600 mt-1">
                      All available rooms ({packageRooms.length} room{packageRooms.length !== 1 ? 's' : ''}) will be booked automatically for the selected dates.
                    </p>
                  </div>
                );
              }

              // Show room selection for room_type packages
              // If booking_type is explicitly 'room_type', always show room selection
              // If booking_type is not set but has room_types, treat as room_type
              const isRoomType = selectedPackage.booking_type === 'room_type' ||
                (selectedPackage.booking_type !== 'whole_property' && hasRoomTypes);

              // If it's not whole_property and not clearly room_type, default to showing room selection
              // (for backward compatibility with packages that don't have booking_type set)
              if (!isWholeProperty && !isRoomType && !selectedPackage.booking_type) {
                // Legacy package without booking_type - show room selection by default
                return (
                  <div>
                    <label className="block text-gray-600 font-medium mb-2">
                      Select Rooms for Package
                      {packageBookingForm.check_in && packageBookingForm.check_out && (
                        <span className="text-xs text-gray-500 ml-2">
                          ({packageBookingForm.check_in} to {packageBookingForm.check_out})
                        </span>
                      )}
                    </label>
                    {!packageBookingForm.check_in || !packageBookingForm.check_out ? (
                      <div className="text-center py-8 text-gray-500 text-sm bg-gray-50 rounded-lg border">
                        <p>Please select check-in and check-out dates first</p>
                        <p className="text-xs mt-1">Available rooms will be shown here</p>
                      </div>
                    ) : (
                      <RoomSelection
                        rooms={packageRooms}
                        selectedRoomNumbers={packageRooms.filter(r => packageBookingForm.room_ids.includes(r.id)).map(r => r.number)}
                        onRoomToggle={(roomNumber) => {
                          const room = packageRooms.find(r => r.number === roomNumber);
                          if (room) handlePackageRoomSelect(room.id);
                        }}
                      />
                    )}
                  </div>
                );
              }

              // Show room selection for room_type packages
              if (!isRoomType) {
                return null; // Don't show room selection if package type is unclear
              }

              return (
                <div>
                  <label className="block text-gray-600 font-medium mb-2">
                    Select Rooms for Package
                    {selectedPackage.room_types && (
                      <span className="text-xs text-indigo-600 ml-2">
                        (Filtered by: {selectedPackage.room_types})
                      </span>
                    )}
                    {packageBookingForm.check_in && packageBookingForm.check_out && (
                      <span className="text-xs text-gray-500 ml-2">
                        ({packageBookingForm.check_in} to {packageBookingForm.check_out})
                      </span>
                    )}
                  </label>
                  {!packageBookingForm.check_in || !packageBookingForm.check_out ? (
                    <div className="text-center py-8 text-gray-500 text-sm bg-gray-50 rounded-lg border">
                      <p>Please select check-in and check-out dates first</p>
                      <p className="text-xs mt-1">Available rooms will be shown here</p>
                    </div>
                  ) : (
                    <RoomSelection
                      rooms={(() => {
                        let roomsToShow = packageRooms;
                        if (selectedPackage.booking_type === 'room_type' && selectedPackage.room_types) {
                          const allowedRoomTypes = selectedPackage.room_types.split(',').map(t => t.trim().toLowerCase());
                          roomsToShow = packageRooms.filter(room => {
                            const roomType = room.type ? room.type.trim().toLowerCase() : '';
                            return allowedRoomTypes.includes(roomType);
                          });
                        }
                        return roomsToShow;
                      })()}
                      selectedRoomNumbers={packageRooms.filter(r => packageBookingForm.room_ids.includes(r.id)).map(r => r.number)}
                      onRoomToggle={(roomNumber) => {
                        const room = packageRooms.find(r => r.number === roomNumber);
                        if (room) handlePackageRoomSelect(room.id);
                      }}
                    />
                  )}
                </div>
              );
            })()}
          </div>
          <button
            type="submit"
            className={`mt-auto w-full bg-purple-600 hover:bg-purple-700 text-white font-semibold py-3 rounded-lg shadow-md transition-transform transform hover:-translate-y-1 disabled:bg-gray-400 disabled:cursor-not-allowed ${isWholePropertyBlocked ? 'opacity-50 cursor-not-allowed' : ''}`}
            disabled={isSubmitting || isLoading || isWholePropertyBlocked}
          >
            {isSubmitting ? "Booking..." : "Book Package ✅"}
          </button>
        </form>
      </Modal>


    </DashboardLayout >
  );
};

export default Bookings;