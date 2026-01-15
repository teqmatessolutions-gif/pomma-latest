import React, { useEffect, useState } from "react";
import { formatCurrency } from '../utils/currency';
import DashboardLayout from "../layout/DashboardLayout";
import API from "../services/api";
import { motion, AnimatePresence } from "framer-motion";
import { DollarSign, Users, Calendar, BedDouble, Briefcase, Package, Utensils, ConciergeBell, UserCheck, Download, FileText, ChevronDown } from "lucide-react";
import * as XLSX from 'xlsx';
import jsPDF from 'jspdf';
import 'jspdf-autotable';

const SectionCard = ({ title, icon, children, loading, count, onExport }) => {
  const [showExportMenu, setShowExportMenu] = useState(false);

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
            <div className="relative">
              <button
                onClick={() => setShowExportMenu(!showExportMenu)}
                className="flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-indigo-600 bg-indigo-50 hover:bg-indigo-100 rounded-lg transition-colors"
                title="Export Data"
              >
                <Download size={16} />
                <span>Export</span>
                <ChevronDown size={14} />
              </button>
              {showExportMenu && (
                <div className="absolute right-0 mt-2 w-40 bg-white rounded-lg shadow-lg border border-gray-200 z-10">
                  <button
                    onClick={() => { onExport('excel'); setShowExportMenu(false); }}
                    className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 rounded-t-lg flex items-center gap-2"
                  >
                    <FileText size={14} />
                    Excel (.xlsx)
                  </button>
                  <button
                    onClick={() => { onExport('csv'); setShowExportMenu(false); }}
                    className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 flex items-center gap-2"
                  >
                    <FileText size={14} />
                    CSV (.csv)
                  </button>
                  <button
                    onClick={() => { onExport('pdf'); setShowExportMenu(false); }}
                    className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 rounded-b-lg flex items-center gap-2"
                  >
                    <FileText size={14} />
                    PDF (.pdf)
                  </button>
                </div>
              )}
            </div>
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

const DataTable = ({ headers, data, renderRow, footer }) => (
  <table className="w-full text-sm text-left">
    <thead className="text-gray-600 uppercase tracking-wider bg-gray-50 sticky top-0">
      <tr>
        {headers.map((h) => <th key={h} className="p-3">{h}</th>)}
      </tr>
    </thead>
    <tbody className="divide-y divide-gray-200">
      {data.map((item, index) => renderRow(item, index))}
    </tbody>
    {footer && (
      <tfoot className="bg-gray-100 font-bold sticky bottom-0">
        {footer}
      </tfoot>
    )}
  </table>
);

const formatDate = (dateString) => dateString ? new Date(dateString).toLocaleDateString() : '-';

const exportToExcel = (data, fileName) => {
  const worksheet = XLSX.utils.json_to_sheet(data);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");
  XLSX.writeFile(workbook, `${fileName}_${new Date().toISOString().split('T')[0]}.xlsx`);
};

const exportToCSV = (data, fileName) => {
  if (!data || data.length === 0) {
    console.error('No data to export');
    return;
  }

  try {
    // Use XLSX library to export CSV (same library as Excel export)
    const worksheet = XLSX.utils.json_to_sheet(data);
    const csvOutput = XLSX.utils.sheet_to_csv(worksheet);

    // Create blob and download
    const blob = new Blob([csvOutput], { type: 'text/csv;charset=utf-8;' });
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `${fileName}_${new Date().toISOString().split('T')[0]}.csv`;
    link.click();
    window.URL.revokeObjectURL(url);
  } catch (error) {
    console.error('Error exporting CSV:', error);
  }
};

const exportToPDF = (data, fileName, title) => {
  if (!data || data.length === 0) return;

  const headers = Object.keys(data[0]);
  const rows = data.map(row => headers.map(header => {
    const value = row[header];
    // Format numbers and dates nicely
    if (typeof value === 'number') return value.toLocaleString();
    return String(value || '-');
  }));

  // Use landscape for tables with many columns
  const orientation = headers.length > 6 ? 'landscape' : 'portrait';
  const doc = new jsPDF(orientation);

  // Add title
  doc.setFontSize(18);
  doc.setTextColor(79, 70, 229);
  doc.text(title, 14, 15);

  // Add date range
  doc.setFontSize(10);
  doc.setTextColor(100, 100, 100);
  doc.text(`Generated: ${new Date().toLocaleDateString()}`, 14, 23);

  // Add table with better formatting
  doc.autoTable({
    head: [headers],
    body: rows,
    startY: 30,
    styles: {
      fontSize: 9,
      cellPadding: 3,
      overflow: 'linebreak',
      cellWidth: 'wrap'
    },
    headStyles: {
      fillColor: [79, 70, 229],
      textColor: 255,
      fontStyle: 'bold',
      halign: 'center'
    },
    alternateRowStyles: {
      fillColor: [248, 250, 252]
    },
    columnStyles: {
      // Auto-adjust column widths based on content
    },
    margin: { top: 30, right: 14, bottom: 14, left: 14 },
    tableWidth: 'auto',
    theme: 'grid'
  });

  doc.save(`${fileName}_${new Date().toISOString().split('T')[0]}.pdf`);
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
    employees: [],
    checkInByEmployee: [],
    checkouts: [], // New for GST Report
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
          checkoutsRes, // New fetch
        ] = await Promise.all([
          API.get("/expenses", { params }),
          API.get("/food-orders", { params }),
          API.get("/bookings", { params }),
          API.get("/packages/bookingsall", { params: { ...params, skip: 0, limit: 1000 } }).catch(() => ({ data: [] })),
          API.get("/employees", { params }),
          API.get("/reports/checkin-by-employee", { params }).catch(() => ({ data: [] })),
          API.get("/reports/service-charges", { params: { ...params, skip: 0, limit: 1000 } }).catch(() => ({ data: [] })),
          API.get("/bill/checkouts", { params: { ...params, skip: 0, limit: 1000 } }).catch(() => ({ data: [] })),
        ]);

        setReportData({
          expenses: expensesRes.data || [],
          serviceCharges: serviceChargesRes.data || [],
          foodOrders: foodOrdersRes.data || [],
          roomBookings: roomBookingsRes.data?.bookings || roomBookingsRes.data || [],
          packageBookings: packageBookingsRes.data || [],
          employees: employeesRes.data || [],
          employees: employeesRes.data || [],
          checkInByEmployee: checkInByEmployeeRes.data || [],
          checkouts: checkoutsRes.data || [],
        });
      } catch (err) {
        console.error("Failed to fetch comprehensive report data:", err);
        setError("Failed to load report data. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    const params = {};
    if (fromDate) {
      params.from_date = fromDate;
      params.start_date = fromDate; // Force both
    }
    if (toDate) {
      params.to_date = toDate;
      params.end_date = toDate; // Force both
    }
    params._t = new Date().getTime(); // Cache buster

    console.log("DEBUG: Fetching Report Data with params:", params);

    fetchAllData(params);
  }, [fromDate, toDate]);

  const handleExportCheckIns = (format = 'excel') => {
    const data = reportData.checkInByEmployee.map(item => ({
      "Employee Name": item.employee_name || '-',
      "Guests Checked-in": item.checkin_count || 0
    }));
    if (format === 'excel') exportToExcel(data, "CheckIns_By_Employee");
    else if (format === 'csv') exportToCSV(data, "CheckIns_By_Employee");
    else if (format === 'pdf') exportToPDF(data, "CheckIns_By_Employee", "Check-ins by Employee");
  };

  const handleExportEmployees = (format = 'excel') => {
    const data = reportData.employees.map(item => ({
      "Name": item.name || '-',
      "Role": (item.role?.name || item.role) || '-',
      "Salary": item.salary,
      "Hire Date": formatDate(item.join_date || item.hire_date)
    }));
    if (format === 'excel') exportToExcel(data, "Active_Employees");
    else if (format === 'csv') exportToCSV(data, "Active_Employees");
    else if (format === 'pdf') exportToPDF(data, "Active_Employees", "Active Employees");
  };

  const handleExportExpenses = (format = 'excel') => {
    const data = reportData.expenses.map(item => ({
      "Category": item.category || '-',
      "Description": item.description || '-',
      "Amount": item.amount,
      "Date": formatDate(item.date || item.expense_date)
    }));
    if (format === 'excel') exportToExcel(data, "All_Expenses");
    else if (format === 'csv') exportToCSV(data, "All_Expenses");
    else if (format === 'pdf') exportToPDF(data, "All_Expenses", "All Expenses");
  };

  const handleExportRoomBookings = (format = 'excel') => {
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
    if (format === 'excel') exportToExcel(data, "Room_Bookings");
    else if (format === 'csv') exportToCSV(data, "Room_Bookings");
    else if (format === 'pdf') exportToPDF(data, "Room_Bookings", "Room Bookings");
  };

  const handleExportPackageBookings = (format = 'excel') => {
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
    if (format === 'excel') exportToExcel(data, "Package_Bookings");
    else if (format === 'csv') exportToCSV(data, "Package_Bookings");
    else if (format === 'pdf') exportToPDF(data, "Package_Bookings", "Package Bookings");
  };

  const handleExportFoodOrders = (format = 'excel') => {
    const data = reportData.foodOrders.map(item => ({
      "Room": item.room_number || item.room?.number || '-',
      "Items": item.item_count || (item.items?.length || 0),
      "Amount": item.amount,
      "Assigned To": item.employee_name || item.employee?.name || '-',
      "Status": item.status || '-',
      "Date": formatDate(item.created_at || item.createdAt)
    }));
    if (format === 'excel') exportToExcel(data, "Food_Orders");
    else if (format === 'csv') exportToCSV(data, "Food_Orders");
    else if (format === 'pdf') exportToPDF(data, "Food_Orders", "Food Orders");
  };

  const handleExportServiceCharges = (format = 'excel') => {
    const data = reportData.serviceCharges.map(item => ({
      "Room": item.room_number || '-',
      "Service": item.service_name || '-',
      "Amount": item.amount,
      "Assigned To": item.employee_name || '-',
      "Status": item.status || '-',
      "Date": formatDate(item.created_at)
    }));
    if (format === 'excel') exportToExcel(data, "Service_Charges");
    else if (format === 'csv') exportToCSV(data, "Service_Charges");
    else if (format === 'pdf') exportToPDF(data, "Service_Charges", "Service Charges");
  };

  const handleExportGST = (format = 'excel') => {
    const gstData = checkouts.filter(c => (c.charges?.total_gst || 0) > 0).map(c => {
      const roomAmt = (c.charges?.room_charges || 0) + (c.charges?.package_charges || 0);
      const roomCgst = (c.charges?.room_cgst || 0) + (c.charges?.package_cgst || 0);
      const roomSgst = (c.charges?.room_sgst || 0) + (c.charges?.package_sgst || 0);
      const foodAmt = c.charges?.food_charges || 0;
      const foodCgst = c.charges?.food_cgst || 0;
      const foodSgst = c.charges?.food_sgst || 0;
      const svcAmt = c.charges?.service_charges || 0;
      const svcCgst = c.charges?.service_cgst || 0;
      const svcSgst = c.charges?.service_sgst || 0;

      return {
        "Invoice No": c.id,
        "Date": formatDate(c.checkout_date || c.created_at),
        "Customer": c.guest_name,
        "Room Amount": roomAmt,
        "Room CGST": roomCgst,
        "Room CGST %": roomAmt > 0 ? ((roomCgst / roomAmt) * 100).toFixed(2) : 0,
        "Room SGST": roomSgst,
        "Room SGST %": roomAmt > 0 ? ((roomSgst / roomAmt) * 100).toFixed(2) : 0,
        "Food Amount": foodAmt,
        "Food CGST": foodCgst,
        "Food CGST %": foodAmt > 0 ? ((foodCgst / foodAmt) * 100).toFixed(2) : 0,
        "Food SGST": foodSgst,
        "Food SGST %": foodAmt > 0 ? ((foodSgst / foodAmt) * 100).toFixed(2) : 0,
        "Service Amount": svcAmt,
        "Service CGST": svcCgst,
        "Service CGST %": svcAmt > 0 ? ((svcCgst / svcAmt) * 100).toFixed(2) : 0,
        "Service SGST": svcSgst,
        "Service SGST %": svcAmt > 0 ? ((svcSgst / svcAmt) * 100).toFixed(2) : 0,
        "Total GST": c.charges?.total_gst || 0
      };
    });
    if (format === 'excel') exportToExcel(gstData, "GST_Consolidated_Report");
    else if (format === 'csv') exportToCSV(gstData, "GST_Consolidated_Report");
    else if (format === 'pdf') exportToPDF(gstData, "GST_Consolidated_Report", "GST Consolidated Report");
  };

  // --- GST REPORT FILTERING ---
  const checkouts = reportData.checkouts || [];

  // 1. Room/Package GST
  const roomGstData = checkouts.filter(c => (c.charges?.room_charges > 0 || c.charges?.package_charges > 0));
  const roomGstTotal = roomGstData.reduce((acc, c) => ({
    rent: acc.rent + (c.charges?.room_charges || 0) + (c.charges?.package_charges || 0),
    cgst: acc.cgst + (c.charges?.room_cgst || 0) + (c.charges?.package_cgst || 0),
    sgst: acc.sgst + (c.charges?.room_sgst || 0) + (c.charges?.package_sgst || 0),
    total: acc.total + (c.charges?.room_gst || 0) + (c.charges?.package_gst || 0),
  }), { rent: 0, cgst: 0, sgst: 0, total: 0 });

  // 2. Food GST
  const foodGstData = checkouts.filter(c => c.charges?.food_charges > 0);
  const foodGstTotal = foodGstData.reduce((acc, c) => ({
    amount: acc.amount + (c.charges?.food_charges || 0),
    cgst: acc.cgst + (c.charges?.food_cgst || 0),
    sgst: acc.sgst + (c.charges?.food_sgst || 0),
    total: acc.total + (c.charges?.food_gst || 0),
  }), { amount: 0, cgst: 0, sgst: 0, total: 0 });

  // 3. Service GST
  const serviceGstData = checkouts.filter(c => c.charges?.service_charges > 0);
  const serviceGstTotal = serviceGstData.reduce((acc, c) => ({
    amount: acc.amount + (c.charges?.service_charges || 0),
    cgst: acc.cgst + (c.charges?.service_cgst || 0),
    sgst: acc.sgst + (c.charges?.service_sgst || 0),
    total: acc.total + (c.charges?.service_gst || 0),
  }), { amount: 0, cgst: 0, sgst: 0, total: 0 });

  // Grand Total
  const grandTotalGST = roomGstTotal.total + foodGstTotal.total + serviceGstTotal.total;

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
          {/* Debug Display Removed */}
          <button
            onClick={() => { setFromDate(""); setToDate(""); }}
            className="bg-gray-800 text-white px-4 py-2 rounded-md text-sm hover:bg-gray-700 transition"
          >
            Clear
          </button>
        </div>

        <AnimatePresence>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-10">
            {/* GST REPORT SECTION */}
            <div className="col-span-1 lg:col-span-2 space-y-6">
              <div className="flex items-center">
                <FileText className="text-purple-600 w-8 h-8 mr-2" />
                <h2 className="text-2xl font-bold text-gray-800">GST Analysis</h2>
              </div>

              {/* Consolidated GST Table */}
              <SectionCard title="Consolidated GST Report" icon={<FileText className="text-purple-600" />} loading={loading} count={checkouts.length} className="col-span-1 lg:col-span-2" onExport={handleExportGST}>
                {checkouts.length === 0 ? <div className="text-center py-8 text-gray-500">No data available</div> :
                  <DataTable
                    headers={[
                      "Inv#", "Date", "Customer",
                      "Room Amt", "Rm CGST", "Rm CGST %", "Rm SGST", "Rm SGST %",
                      "Food Amt", "Fd CGST", "Fd CGST %", "Fd SGST", "Fd SGST %",
                      "Svc Amt", "Svc CGST", "Svc CGST %", "Svc SGST", "Svc SGST %",
                      "Total GST"
                    ]}
                    data={checkouts.filter(c => (c.charges?.total_gst || 0) > 0)}
                    renderRow={(c) => (
                      <tr key={c.id} className="hover:bg-gray-50 text-xs">
                        <td className="p-3 font-mono">{c.id}</td>
                        <td className="p-3 whitespace-nowrap">{formatDate(c.checkout_date || c.created_at)}</td>
                        <td className="p-3">{c.guest_name}</td>

                        {/* Room */}
                        <td className="p-3 text-gray-900 font-medium">{formatCurrency((c.charges?.room_charges || 0) + (c.charges?.package_charges || 0))}</td>
                        <td className="p-3 text-indigo-600 font-medium">{formatCurrency((c.charges?.room_cgst || 0) + (c.charges?.package_cgst || 0))}</td>
                        <td className="p-3 text-indigo-500 text-xs">{(() => { const amt = (c.charges?.room_charges || 0) + (c.charges?.package_charges || 0); const tax = (c.charges?.room_cgst || 0) + (c.charges?.package_cgst || 0); return amt > 0 ? `${((tax / amt) * 100).toFixed(2)}%` : '-'; })()}</td>
                        <td className="p-3 text-indigo-600 font-medium">{formatCurrency((c.charges?.room_sgst || 0) + (c.charges?.package_sgst || 0))}</td>
                        <td className="p-3 text-indigo-500 text-xs">{(() => { const amt = (c.charges?.room_charges || 0) + (c.charges?.package_charges || 0); const tax = (c.charges?.room_sgst || 0) + (c.charges?.package_sgst || 0); return amt > 0 ? `${((tax / amt) * 100).toFixed(2)}%` : '-'; })()}</td>

                        {/* Food */}
                        <td className="p-3 text-gray-900 font-medium">{formatCurrency(c.charges?.food_charges || 0)}</td>
                        <td className="p-3 text-orange-600 font-medium">{formatCurrency(c.charges?.food_cgst || 0)}</td>
                        <td className="p-3 text-orange-500 text-xs">{(() => { const amt = c.charges?.food_charges || 0; const tax = c.charges?.food_cgst || 0; return amt > 0 ? `${((tax / amt) * 100).toFixed(2)}%` : '-'; })()}</td>
                        <td className="p-3 text-orange-600 font-medium">{formatCurrency(c.charges?.food_sgst || 0)}</td>
                        <td className="p-3 text-orange-500 text-xs">{(() => { const amt = c.charges?.food_charges || 0; const tax = c.charges?.food_sgst || 0; return amt > 0 ? `${((tax / amt) * 100).toFixed(2)}%` : '-'; })()}</td>

                        {/* Service */}
                        <td className="p-3 text-gray-900 font-medium">{formatCurrency(c.charges?.service_charges || 0)}</td>
                        <td className="p-3 text-teal-600 font-medium">{formatCurrency(c.charges?.service_cgst || 0)}</td>
                        <td className="p-3 text-teal-500 text-xs">{(() => { const amt = c.charges?.service_charges || 0; const tax = c.charges?.service_cgst || 0; return amt > 0 ? `${((tax / amt) * 100).toFixed(2)}%` : '-'; })()}</td>
                        <td className="p-3 text-teal-600 font-medium">{formatCurrency(c.charges?.service_sgst || 0)}</td>
                        <td className="p-3 text-teal-500 text-xs">{(() => { const amt = c.charges?.service_charges || 0; const tax = c.charges?.service_sgst || 0; return amt > 0 ? `${((tax / amt) * 100).toFixed(2)}%` : '-'; })()}</td>

                        {/* Total */}
                        <td className="p-3 font-bold text-green-700">{formatCurrency(c.charges?.total_gst || 0)}</td>
                      </tr>
                    )}
                    footer={
                      <tr className="bg-gray-100 text-xs font-semibold">
                        <td colSpan="3" className="p-3 text-right">Grand Totals:</td>
                        <td className="p-3">{formatCurrency(roomGstTotal.rent)}</td>
                        <td className="p-3 text-indigo-700">{formatCurrency(roomGstTotal.cgst)}</td>
                        <td className="p-3 text-indigo-600">{roomGstTotal.rent > 0 ? `${((roomGstTotal.cgst / roomGstTotal.rent) * 100).toFixed(2)}%` : '-'}</td>
                        <td className="p-3 text-indigo-700">{formatCurrency(roomGstTotal.sgst)}</td>
                        <td className="p-3 text-indigo-600">{roomGstTotal.rent > 0 ? `${((roomGstTotal.sgst / roomGstTotal.rent) * 100).toFixed(2)}%` : '-'}</td>

                        <td className="p-3">{formatCurrency(foodGstTotal.amount)}</td>
                        <td className="p-3 text-orange-700">{formatCurrency(foodGstTotal.cgst)}</td>
                        <td className="p-3 text-orange-600">{foodGstTotal.amount > 0 ? `${((foodGstTotal.cgst / foodGstTotal.amount) * 100).toFixed(2)}%` : '-'}</td>
                        <td className="p-3 text-orange-700">{formatCurrency(foodGstTotal.sgst)}</td>
                        <td className="p-3 text-orange-600">{foodGstTotal.amount > 0 ? `${((foodGstTotal.sgst / foodGstTotal.amount) * 100).toFixed(2)}%` : '-'}</td>

                        <td className="p-3">{formatCurrency(serviceGstTotal.amount)}</td>
                        <td className="p-3 text-teal-700">{formatCurrency(serviceGstTotal.cgst)}</td>
                        <td className="p-3 text-teal-600">{serviceGstTotal.amount > 0 ? `${((serviceGstTotal.cgst / serviceGstTotal.amount) * 100).toFixed(2)}%` : '-'}</td>
                        <td className="p-3 text-teal-700">{formatCurrency(serviceGstTotal.sgst)}</td>
                        <td className="p-3 text-teal-600">{serviceGstTotal.amount > 0 ? `${((serviceGstTotal.sgst / serviceGstTotal.amount) * 100).toFixed(2)}%` : '-'}</td>

                        <td className="p-3 text-green-700 text-sm">{formatCurrency(grandTotalGST)}</td>
                      </tr>
                    }
                  />
                }
              </SectionCard>

              {/* Grand Total Summary Cards */}
              <div className="col-span-1 lg:col-span-2 grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="bg-white p-6 rounded-xl shadow-md border-l-4 border-indigo-500">
                  <div className="text-gray-500 text-sm font-medium uppercase">Total Room GST</div>
                  <div className="text-2xl font-bold text-gray-800 mt-2">{formatCurrency(roomGstTotal.total)}</div>
                  <div className="text-xs text-gray-400 mt-1">CGST: {formatCurrency(roomGstTotal.cgst)} | SGST: {formatCurrency(roomGstTotal.sgst)}</div>
                </div>
                <div className="bg-white p-6 rounded-xl shadow-md border-l-4 border-orange-500">
                  <div className="text-gray-500 text-sm font-medium uppercase">Total Food GST</div>
                  <div className="text-2xl font-bold text-gray-800 mt-2">{formatCurrency(foodGstTotal.total)}</div>
                  <div className="text-xs text-gray-400 mt-1">CGST: {formatCurrency(foodGstTotal.cgst)} | SGST: {formatCurrency(foodGstTotal.sgst)}</div>
                </div>
                <div className="bg-white p-6 rounded-xl shadow-md border-l-4 border-teal-500">
                  <div className="text-gray-500 text-sm font-medium uppercase">Total Service GST</div>
                  <div className="text-2xl font-bold text-gray-800 mt-2">{formatCurrency(serviceGstTotal.total)}</div>
                  <div className="text-xs text-gray-400 mt-1">CGST: {formatCurrency(serviceGstTotal.cgst)} | SGST: {formatCurrency(serviceGstTotal.sgst)}</div>
                </div>
              </div>

              <motion.div
                className="col-span-1 lg:col-span-2 bg-gradient-to-r from-gray-800 to-gray-900 rounded-2xl shadow-xl p-8 text-white flex justify-between items-center"
                initial={{ opacity: 0, scale: 0.95 }}
                animate={{ opacity: 1, scale: 1 }}
              >
                <div>
                  <h3 className="text-2xl font-bold mb-2">Grand Total GST Collected</h3>
                  <p className="text-gray-300">Sum of all GST components</p>
                </div>
                <div className="text-4xl font-extrabold text-green-400">
                  {formatCurrency(grandTotalGST)}
                </div>
              </motion.div>
            </div>
          </div>
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