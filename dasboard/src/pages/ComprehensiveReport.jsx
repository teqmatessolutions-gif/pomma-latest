import React, { useEffect, useState } from "react";
import { formatCurrency } from '../utils/currency';
import DashboardLayout from "../layout/DashboardLayout";
import API from "../services/api";
import { motion, AnimatePresence } from "framer-motion";
import { DollarSign, Users, Calendar, BedDouble, Briefcase, Package, Utensils, ConciergeBell, UserCheck, Download } from "lucide-react";
import * as XLSX from 'xlsx';

const SectionCard = ({ title, icon, children, loading, count, onExport }) => {
  return (
    <motion.div
      className="bg-white rounded-2xl shadow-lg p-6 flex flex-col"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -20 }}
      transition={{ duration: 0.3 }}
    >
      <div className="flex items-center justify-between mb-4 border-b border-gray-200 pb-3">
        <div className="flex items-center">
          {icon}
          <h2 className="text-xl font-bold text-gray-800 ml-3">{title}</h2>
        </div>
        <div className="flex items-center gap-3">
          {!loading && count > 0 && onExport && (
            <button
              onClick={onExport}
              className="flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-indigo-600 bg-indigo-50 hover:bg-indigo-100 rounded-lg transition-colors"
              title="Export to Excel"
            >
              <Download size={16} />
              <span>Export</span>
            </button>
          )}
          {!loading && <span className="text-sm font-bold bg-gray-100 text-gray-700 px-2 py-1 rounded-full">{count} Records</span>}
          {loading && <div className="h-6 w-20 bg-gray-200 rounded-full animate-pulse"></div>}
        </div>
      </div>
      <div className="overflow-auto max-h-96">
        {loading
          ? <div className="space-y-2 mt-2"><div className="h-8 bg-gray-200 rounded animate-pulse"></div><div className="h-8 bg-gray-200 rounded animate-pulse"></div><div className="h-8 bg-gray-200 rounded animate-pulse"></div></div>
          : children}
      </div>
    </motion.div>
  );
};

const DataTable = ({ headers, data, renderRow }) => (
  <table className="w-full text-sm text-left">
    <thead className="text-gray-600 uppercase tracking-wider bg-gray-50 sticky top-0">
      <tr>
        {headers.map((h) => <th key={h} className="p-3">{h}</th>)}
      </tr>
    </thead>
    <tbody className="divide-y divide-gray-200">
      {data.map((item, index) => renderRow(item, index))}
    </tbody>
  </table>
);

const formatDate = (dateString) => dateString ? new Date(dateString).toLocaleDateString() : '-';

const exportToExcel = (data, fileName) => {
  const worksheet = XLSX.utils.json_to_sheet(data);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");
  XLSX.writeFile(workbook, `${fileName}_${new Date().toISOString().split('T')[0]}.xlsx`);
};

export default function ComprehensiveReport() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [fromDate, setFromDate] = useState("");
  const [toDate, setToDate] = useState("");
  const [reportData, setReportData] = useState({
    expenses: [],
    serviceCharges: [],
    foodOrders: [],
    roomBookings: [],
    packageBookings: [],
    employees: [],
    checkInByEmployee: [],
  });

  useEffect(() => {
    const fetchAllData = async (params = {}) => {
      try {
        setLoading(true);
        setError(null);

        const [
          expensesRes,
          foodOrdersRes,
          roomBookingsRes,
          packageBookingsRes,
          employeesRes,
          checkInByEmployeeRes,
          serviceChargesRes,
        ] = await Promise.all([
          API.get("/expenses", { params }),
          API.get("/food-orders", { params }),
          API.get("/bookings", { params }),
          API.get("/packages/bookingsall", { params: { ...params, skip: 0, limit: 1000 } }).catch(() => ({ data: [] })),
          API.get("/employees", { params }),
          API.get("/reports/checkin-by-employee", { params }).catch(() => ({ data: [] })),
          API.get("/reports/service-charges", { params: { ...params, skip: 0, limit: 1000 } }).catch(() => ({ data: [] })),
        ]);

        setReportData({
          expenses: expensesRes.data || [],
          serviceCharges: serviceChargesRes.data || [],
          foodOrders: foodOrdersRes.data || [],
          roomBookings: roomBookingsRes.data?.bookings || roomBookingsRes.data || [],
          packageBookings: packageBookingsRes.data || [],
          employees: employeesRes.data || [],
          checkInByEmployee: checkInByEmployeeRes.data || [],
        });
      } catch (err) {
        console.error("Failed to fetch comprehensive report data:", err);
        setError("Failed to load report data. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    const params = {};
    if (fromDate) params.from_date = fromDate;
    if (toDate) params.to_date = toDate;
    fetchAllData(params);
  }, [fromDate, toDate]);

  const handleExportCheckIns = () => {
    const data = reportData.checkInByEmployee.map(item => ({
      "Employee Name": item.employee_name || '-',
      "Guests Checked-in": item.checkin_count || 0
    }));
    exportToExcel(data, "CheckIns_By_Employee");
  };

  const handleExportEmployees = () => {
    const data = reportData.employees.map(item => ({
      "Name": item.name || '-',
      "Role": (item.role?.name || item.role) || '-',
      "Salary": item.salary,
      "Hire Date": formatDate(item.join_date || item.hire_date)
    }));
    exportToExcel(data, "Active_Employees");
  };

  const handleExportExpenses = () => {
    const data = reportData.expenses.map(item => ({
      "Category": item.category || '-',
      "Description": item.description || '-',
      "Amount": item.amount,
      "Date": formatDate(item.date || item.expense_date)
    }));
    exportToExcel(data, "All_Expenses");
  };

  const handleExportRoomBookings = () => {
    const data = reportData.roomBookings.map(item => {
      const roomNumbers = item.rooms?.map(r => {
        if (r.number) return r.number;
        if (r.room?.number) return r.room.number;
        return null;
      }).filter(Boolean).join(', ') || '-';

      return {
        "ID": item.id,
        "Guest": item.guest_name || '-',
        "Rooms": roomNumbers,
        "Check-in": formatDate(item.check_in),
        "Check-out": formatDate(item.check_out),
        "Status": item.status || '-',
        "Total": item.total_amount
      };
    });
    exportToExcel(data, "Room_Bookings");
  };

  const handleExportPackageBookings = () => {
    const data = reportData.packageBookings.map(item => {
      const roomNumbers = item.rooms?.map(r => r.room?.number).filter(Boolean).join(', ') || '-';
      return {
        "Guest": item.guest_name || '-',
        "Package": item.package?.title || '-',
        "Rooms": roomNumbers,
        "Guests": `${item.adults || 0}A, ${item.children || 0}C`,
        "Check-in": formatDate(item.check_in),
        "Total": item.package?.price || item.total_amount || 0,
        "Status": item.status || '-'
      };
    });
    exportToExcel(data, "Package_Bookings");
  };

  const handleExportFoodOrders = () => {
    const data = reportData.foodOrders.map(item => ({
      "Room": item.room_number || item.room?.number || '-',
      "Items": item.item_count || (item.items?.length || 0),
      "Amount": item.amount,
      "Assigned To": item.employee_name || item.employee?.name || '-',
      "Status": item.status || '-',
      "Date": formatDate(item.created_at || item.createdAt)
    }));
    exportToExcel(data, "Food_Orders");
  };

  const handleExportServiceCharges = () => {
    const data = reportData.serviceCharges.map(item => ({
      "Room": item.room_number || '-',
      "Service": item.service_name || '-',
      "Amount": item.amount,
      "Assigned To": item.employee_name || '-',
      "Status": item.status || '-',
      "Date": formatDate(item.created_at)
    }));
    exportToExcel(data, "Service_Charges");
  };

  if (error) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center h-screen text-red-500 text-lg"><p>{error}</p></div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout>
      <div className="p-6 md:p-8 space-y-8 bg-gray-50 min-h-screen">
        <h1 className="text-3xl font-bold text-gray-800">Comprehensive Data Report</h1>

        {/* Date Filter Section */}
        <div className="bg-white p-4 rounded-lg shadow-md flex items-center gap-4">
          <div className="flex-1">
            <label htmlFor="from-date" className="block text-sm font-medium text-gray-700">From Date</label>
            <input type="date" id="from-date" value={fromDate} onChange={e => setFromDate(e.target.value)} className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm" />
          </div>
          <div className="flex-1">
            <label htmlFor="to-date" className="block text-sm font-medium text-gray-700">To Date</label>
            <input type="date" id="to-date" value={toDate} onChange={e => setToDate(e.target.value)} className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm" />
          </div>
          <button onClick={() => { setFromDate(""); setToDate(""); }} className="mt-5 px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-gray-600 hover:bg-gray-700">
            Clear
          </button>
        </div>

        <AnimatePresence>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {/* Check-ins by Employee */}
            <SectionCard title="Check-ins by Employee" icon={<UserCheck className="text-green-600" />} loading={loading} count={reportData.checkInByEmployee.length} onExport={handleExportCheckIns}>
              {reportData.checkInByEmployee.length === 0 ? (
                <div className="text-center py-8 text-gray-500">No check-in data available</div>
              ) : (
                <DataTable
                  headers={["Employee Name", "Guests Checked-in"]}
                  data={reportData.checkInByEmployee}
                  renderRow={(item, index) => (
                    <tr key={item.employee_name || `employee-${index}`} className="hover:bg-gray-50">
                      <td className="p-3 font-semibold">{item.employee_name || '-'}</td>
                      <td className="p-3 font-bold text-lg text-indigo-700">{item.checkin_count || 0}</td>
                    </tr>
                  )}
                />
              )}
            </SectionCard>

            {/* Employees */}
            <SectionCard title="Active Employees" icon={<Users className="text-blue-600" />} loading={loading} count={reportData.employees.length} onExport={handleExportEmployees}>
              <DataTable
                headers={["Name", "Role", "Salary", "Hire Date"]}
                data={reportData.employees}
                renderRow={(item) => (
                  <tr key={item.id} className="hover:bg-gray-50">
                    <td className="p-3 font-semibold">{item.name || '-'}</td>
                    <td className="p-3">{(item.role?.name || item.role) || '-'}</td>
                    <td className="p-3">{formatCurrency(item.salary)}</td>
                    <td className="p-3">{formatDate(item.join_date || item.hire_date)}</td>
                  </tr>
                )}
              />
            </SectionCard>

            {/* Expenses */}
            <SectionCard title="All Expenses" icon={<DollarSign className="text-red-600" />} loading={loading} count={reportData.expenses.length} onExport={handleExportExpenses}>
              <DataTable
                headers={["Category", "Description", "Amount", "Date"]}
                data={reportData.expenses}
                renderRow={(item) => (
                  <tr key={item.id} className="hover:bg-gray-50">
                    <td className="p-3 font-semibold">{item.category || '-'}</td>
                    <td className="p-3">{item.description || '-'}</td>
                    <td className="p-3">{formatCurrency(item.amount)}</td>
                    <td className="p-3">{formatDate(item.date || item.expense_date)}</td>
                  </tr>
                )}
              />
            </SectionCard>

            {/* Room Bookings */}
            <SectionCard title="Room Bookings" icon={<BedDouble className="text-purple-600" />} loading={loading} count={reportData.roomBookings.length} onExport={handleExportRoomBookings}>
              <DataTable
                headers={["ID", "Guest", "Rooms", "Check-in", "Check-out", "Status", "Total"]}
                data={reportData.roomBookings}
                renderRow={(item) => {
                  // Handle rooms - can be RoomOut[] (direct) or BookingRoom[] with nested room
                  const roomNumbers = item.rooms?.map(r => {
                    if (r.number) return r.number; // RoomOut
                    if (r.room?.number) return r.room.number; // BookingRoom with nested room
                    return null;
                  }).filter(Boolean).join(', ') || '-';
                  return (
                    <tr key={item.id} className="hover:bg-gray-50">
                      <td className="p-3 font-mono text-xs">{item.id}</td>
                      <td className="p-3 font-semibold">{item.guest_name || '-'}</td>
                      <td className="p-3">{roomNumbers}</td>
                      <td className="p-3">{formatDate(item.check_in)}</td>
                      <td className="p-3">{formatDate(item.check_out)}</td>
                      <td className="p-3">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${item.status === 'booked' ? 'bg-green-100 text-green-800' : item.status === 'checked_out' ? 'bg-blue-100 text-blue-800' : 'bg-yellow-100 text-yellow-800'}`}>
                          {item.status || '-'}
                        </span>
                      </td>
                      <td className="p-3">{formatCurrency(item.total_amount)}</td>
                    </tr>
                  );
                }}
              />
            </SectionCard>

            {/* Package Bookings */}
            <SectionCard title="Package Bookings" icon={<Package className="text-indigo-600" />} loading={loading} count={reportData.packageBookings.length} onExport={handleExportPackageBookings}>
              <DataTable
                headers={["Guest", "Package", "Rooms", "Guests", "Check-in", "Total", "Status"]}
                data={reportData.packageBookings}
                renderRow={(item) => {
                  // Handle rooms - PackageBookingRoomOut has room: Optional[RoomOut]
                  const roomNumbers = item.rooms?.map(r => r.room?.number).filter(Boolean).join(', ') || '-';
                  return (
                    <tr key={item.id} className="hover:bg-gray-50">
                      <td className="p-3 font-semibold">{item.guest_name || '-'}</td>
                      <td className="p-3">{item.package?.title || '-'}</td>
                      <td className="p-3">{roomNumbers}</td>
                      <td className="p-3">{`${item.adults || 0}A, ${item.children || 0}C`}</td>
                      <td className="p-3">{formatDate(item.check_in)}</td>
                      <td className="p-3">{formatCurrency(item.package?.price || item.total_amount || 0)}</td>
                      <td className="p-3">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${item.status === 'booked' ? 'bg-green-100 text-green-800' : item.status === 'checked_out' ? 'bg-blue-100 text-blue-800' : 'bg-yellow-100 text-yellow-800'}`}>
                          {item.status || '-'}
                        </span>
                      </td>
                    </tr>
                  );
                }}
              />
            </SectionCard>

            {/* Food Orders */}
            <SectionCard title="Food Orders" icon={<Utensils className="text-orange-600" />} loading={loading} count={reportData.foodOrders.length} onExport={handleExportFoodOrders}>
              <DataTable
                headers={["Room", "Items", "Amount", "Assigned To", "Status", "Date"]}
                data={reportData.foodOrders}
                renderRow={(item) => (
                  <tr key={item.id} className="hover:bg-gray-50">
                    <td className="p-3 font-semibold">{item.room_number || item.room?.number || '-'}</td>
                    <td className="p-3">{item.item_count || (item.items?.length || 0)}</td>
                    <td className="p-3">{formatCurrency(item.amount)}</td>
                    <td className="p-3">{item.employee_name || item.employee?.name || '-'}</td>
                    <td className="p-3">{item.status || '-'}</td>
                    <td className="p-3">{formatDate(item.created_at || item.createdAt)}</td>
                  </tr>
                )}
              />
            </SectionCard>

            {/* Service Charges */}
            <SectionCard title="Service Charges" icon={<ConciergeBell className="text-teal-600" />} loading={loading} count={reportData.serviceCharges.length} onExport={handleExportServiceCharges}>
              {reportData.serviceCharges.length === 0 ? (
                <div className="text-center py-8 text-gray-500">No service charges available</div>
              ) : (
                <DataTable
                  headers={["Room", "Service", "Amount", "Assigned To", "Status", "Date"]}
                  data={reportData.serviceCharges}
                  renderRow={(item) => (
                    <tr key={item.id} className="hover:bg-gray-50">
                      <td className="p-3 font-semibold">{item.room_number || '-'}</td>
                      <td className="p-3">{item.service_name || '-'}</td>
                      <td className="p-3">{formatCurrency(item.amount)}</td>
                      <td className="p-3">{item.employee_name || '-'}</td>
                      <td className="p-3">{item.status || '-'}</td>
                      <td className="p-3">{formatDate(item.created_at)}</td>
                    </tr>
                  )}
                />
              )}
            </SectionCard>
          </div>
        </AnimatePresence>
      </div>
    </DashboardLayout>
  );
}