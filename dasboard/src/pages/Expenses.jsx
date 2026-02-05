import React, { useState, useEffect, useRef, useCallback } from "react";
import DashboardLayout from "../layout/DashboardLayout";
import API from "../services/api";
import { LineChart, Line, Tooltip, ResponsiveContainer } from "recharts";
import CountUp from "react-countup";
import { useInfiniteScroll } from "./useInfiniteScroll";
import { getMediaBaseUrl } from "../utils/env";
import { formatCompactNumber } from "../utils/currency";

const Expenses = () => {
  const [expenses, setExpenses] = useState([]);
  const [employees, setEmployees] = useState([]);
  const [imagePreview, setImagePreview] = useState(null);
  const [hoveredKPI, setHoveredKPI] = useState(null);
  const [hasMore, setHasMore] = useState(false);
  const [isFetchingMore, setIsFetchingMore] = useState(false);
  const [page, setPage] = useState(1);
  const [totalExpensesState, setTotalExpensesState] = useState(0); // Renamed to avoid collision with derived totalExpenses

  const [form, setForm] = useState({
    employee_id: "",
    category: "",
    amount: "",
    date: "",
    description: "",
    bill_image: null,
  });

  const fileInputRef = useRef(null);
  const mediaBaseUrl = getMediaBaseUrl();

  useEffect(() => {
    fetchEmployees();
  }, []);

  useEffect(() => {
    fetchExpenses(page);
  }, [page]);

  // const loadMoreExpenses = useCallback(async () => {}) // Removed in favor of direct page access

  // const loadMoreRef = useInfiniteScroll(loadMoreExpenses, hasMore, isFetchingMore); 

  const fetchExpenses = async (currentPage = 1) => {
    try {
      const skip = (currentPage - 1) * 20;
      const res = await API.get(`/expenses?skip=${skip}&limit=20`);

      let newExpenses = [];
      let total = 0;

      if (res.data.items) {
        newExpenses = res.data.items;
        total = res.data.total;
        setTotalExpensesState(res.data.total);
      } else {
        newExpenses = res.data;
        total = res.data.length;
        setTotalExpensesState(res.data.length);
      }

      const dataWithTrend = newExpenses.map((exp) => ({
        ...exp,
        trend: Array.from({ length: 30 }, () => Math.floor(Math.random() * 5000)),
      }));

      setExpenses(dataWithTrend);
      setHasMore(false); // Using explicit pagination controls
    } catch (error) {
      console.error("Error fetching expenses:", error);
      alert("Failed to fetch expenses");
    }
  };

  const fetchEmployees = async () => {
    try {
      const res = await API.get("/employees?limit=20"); // Fetch all for dropdown
      // Handle both paginated and non-paginated employee responses
      if (res.data?.items) {
        setEmployees(Array.isArray(res.data.items) ? res.data.items : []);
      } else {
        setEmployees(Array.isArray(res.data) ? res.data : []);
      }
    } catch (error) {
      console.error("Error fetching employees:", error);
      alert("Failed to fetch employees");
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const data = new FormData();
      data.append("employee_id", form.employee_id);
      data.append("category", form.category);
      data.append("amount", form.amount);
      data.append("date", form.date);
      data.append("description", form.description);
      if (form.bill_image) data.append("image", form.bill_image);

      await API.post("/expenses", data, {
        headers: { "Content-Type": "multipart/form-data" },
      });

      setForm({
        employee_id: "",
        category: "",
        amount: "",
        date: "",
        description: "",
        bill_image: null,
      });
      setImagePreview(null);
      fileInputRef.current.value = "";
      fetchExpenses(page);
    } catch (error) {
      console.error("Error submitting expense:", error);
      alert("Failed to submit expense");
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this expense?")) return;
    try {
      await API.delete(`/expenses/${id}`);
      fetchExpenses(page);
    } catch (error) {
      console.error("Delete failed:", error);
      alert("Failed to delete expense");
    }
  };

  // KPI Calculations (Note: This is now PER PAGE. TODO: Add backend KPI endpoints)
  const totalExpenses = totalExpensesState; // Use total from backed
  // We can't calculate total amount correctly for all pages without a new endpoint.
  // Converting totalAmount to be "Current Page Amount" for now.
  const totalAmount = expenses.reduce((acc, e) => acc + parseFloat(e.amount || 0), 0);
  const avgExpense = expenses.length ? Math.round(totalAmount / expenses.length) : 0; // Avg of current page

  const kpiData = [
    { label: "Total Expenses", value: totalExpenses, color: "#4f46e5", trend: expenses.map(e => parseFloat(e.amount || 0)) },
    { label: "Total Amount", value: totalAmount, color: "#16a34a", trend: expenses.map(e => parseFloat(e.amount || 0)) },
    { label: "Avg Expense", value: avgExpense, color: "#f59e0b", trend: expenses.map(e => parseFloat(e.amount || 0)) },
  ];

  return (
    <DashboardLayout>
      {/* Animated Background */}


      <h1 className="text-3xl font-bold mb-6 text-gray-800">Expense Management</h1>

      {/* KPI Row */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        {kpiData.map((kpi, idx) => (
          <div
            key={idx}
            className="relative bg-white p-5 rounded-xl shadow cursor-pointer hover:shadow-xl transition"
            onMouseEnter={() => setHoveredKPI(idx)}
            onMouseLeave={() => setHoveredKPI(null)}
          >
            <div className="flex flex-col items-center">
              <span className="text-gray-500">{kpi.label}</span>
              <span className="text-2xl font-bold" style={{ color: kpi.color }}>
                {kpi.value > 999 ? (
                  <span title={kpi.value.toLocaleString('en-IN')}>
                    {/* Prefix with ₹ for amount-related KPIs if needed, though label implies it */}
                    {kpi.label.includes("Amount") || kpi.label.includes("Expense") ? "₹" : ""}
                    {formatCompactNumber(kpi.value)}
                  </span>
                ) : (
                  <CountUp end={kpi.value} duration={1.5} separator="," prefix={kpi.label.includes("Amount") || kpi.label.includes("Expense") ? "₹" : ""} />
                )}
              </span>
            </div>

            {hoveredKPI === idx && (
              <div className="absolute inset-0 bg-white bg-opacity-95 flex items-center justify-center rounded-xl p-2 shadow-lg">
                <ResponsiveContainer width="100%" height={50}>
                  <LineChart data={kpi.trend.map((v, i) => ({ day: i + 1, value: v }))}>
                    <Line type="monotone" dataKey="value" stroke={kpi.color} strokeWidth={2} dot={false} />
                    <Tooltip contentStyle={{ fontSize: 12 }} formatter={(val) => [`₹${val}`, "Amount"]} />
                  </LineChart>
                </ResponsiveContainer>
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Add Expense Form - Centered & Modern */}
      <section className="flex justify-center mb-8">
        <form
          onSubmit={handleSubmit}
          className="bg-white p-8 rounded-3xl shadow-lg w-full max-w-4xl grid grid-cols-1 md:grid-cols-4 gap-6"
        >
          <select
            value={form.employee_id}
            onChange={(e) => setForm({ ...form, employee_id: e.target.value })}
            className="border p-3 rounded-xl focus:ring-2 focus:ring-indigo-500 w-full"
            required
          >
            <option value="">Select Employee</option>
            {employees.map((emp) => (
              <option key={emp.id} value={emp.id}>{emp.name}</option>
            ))}
          </select>

          <input
            type="text"
            placeholder="Category"
            value={form.category}
            onChange={(e) => setForm({ ...form, category: e.target.value })}
            className="border p-3 rounded-xl focus:ring-2 focus:ring-indigo-500 w-full"
            required
          />
          <input
            type="number"
            placeholder="Amount"
            value={form.amount}
            onChange={(e) => setForm({ ...form, amount: e.target.value })}
            className="border p-3 rounded-xl focus:ring-2 focus:ring-indigo-500 w-full"
            required
          />
          <input
            type="date"
            value={form.date}
            onChange={(e) => setForm({ ...form, date: e.target.value })}
            className="border p-3 rounded-xl focus:ring-2 focus:ring-indigo-500 w-full"
            required
          />
          <input
            type="text"
            placeholder="Description"
            value={form.description}
            onChange={(e) => setForm({ ...form, description: e.target.value })}
            className="border p-3 rounded-xl focus:ring-2 focus:ring-indigo-500 w-full md:col-span-2"
          />
          <input
            type="file"
            accept="image/*"
            ref={fileInputRef}
            onChange={(e) => {
              const file = e.target.files[0];
              if (file) {
                setForm({ ...form, bill_image: file });
                // Use FileReader for Base64 preview
                const reader = new FileReader();
                reader.onload = (e) => setImagePreview(e.target.result);
                reader.readAsDataURL(file);
              }
            }}
            className="border p-3 rounded-xl focus:ring-2 focus:ring-indigo-500 w-full"
          />

          {imagePreview && (
            <div className="md:col-span-4 flex justify-center">
              <img
                src={imagePreview}
                alt="Preview"
                className="h-24 rounded-xl border object-cover mt-2"
              />
            </div>
          )}

          <div className="md:col-span-4 flex justify-center">
            <button
              type="submit"
              className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white px-6 py-3 rounded-2xl hover:scale-105 transform transition shadow-lg"
            >
              Add Expense
            </button>
          </div>
        </form>
      </section>

      {/* Expense Table */}
      <section className="bg-white p-6 rounded-2xl shadow">
        <h2 className="text-xl font-semibold mb-4 text-gray-700">Expense List</h2>
        <div className="overflow-x-auto">
          <table className="min-w-full text-sm text-left border-collapse border border-gray-200">
            <thead className="bg-gray-100">
              <tr>
                <th className="p-3 border">#</th>
                <th className="p-3 border">Employee</th>
                <th className="p-3 border">Category</th>
                <th className="p-3 border">Amount</th>
                <th className="p-3 border">Date</th>
                <th className="p-3 border">Description</th>
                <th className="p-3 border">Bill</th>
                <th className="p-3 border">Action</th>
              </tr>
            </thead>
            <tbody>
              {expenses.length > 0 ? (
                expenses.map((exp, idx) => (
                  <tr key={exp.id} className="hover:bg-gray-50 border-b">
                    <td className="p-2">{idx + 1}</td>
                    <td className="p-2">{exp.employee_name || "N/A"}</td>
                    <td className="p-2">{exp.category}</td>
                    <td className="p-2 text-green-600 font-semibold">₹{exp.amount}</td>
                    <td className="p-2">{exp.date.includes("T") ? exp.date.split("T")[0] : exp.date}</td>
                    <td className="p-2">{exp.description}</td>
                    <td className="p-2">
                      {exp.image && (
                        <img
                          src={`${mediaBaseUrl}/${(exp.image || "").replace(/\\/g, "/").replace(/^\//, "")}`}
                          alt="Bill"
                          className="h-12 rounded"
                        />
                      )}
                    </td>
                    <td className="p-2">
                      <button
                        onClick={() => handleDelete(exp.id)}
                        className="text-red-500 hover:underline"
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="8" className="p-4 text-center text-gray-500">
                    No expenses found.
                  </td>
                </tr>
              )}
            </tbody>
            {totalExpenses > 20 && (
              <tbody>
                <tr>
                  <td colSpan="8">
                    <div className="flex justify-center items-center py-4 space-x-2">
                      <button
                        onClick={() => setPage(prev => Math.max(prev - 1, 1))}
                        disabled={page === 1}
                        className={`px-4 py-2 rounded-lg ${page === 1 ? 'bg-gray-200 text-gray-400 cursor-not-allowed' : 'bg-white text-indigo-600 hover:bg-indigo-50 border border-indigo-200'} transition-colors duration-200`}
                      >
                        Previous
                      </button>

                      <span className="text-gray-600 font-medium px-4">
                        Page {page} of {Math.ceil(totalExpenses / 20)}
                      </span>

                      <button
                        onClick={() => setPage(prev => (prev * 20 < totalExpenses ? prev + 1 : prev))}
                        disabled={page * 20 >= totalExpenses}
                        className={`px-4 py-2 rounded-lg ${page * 20 >= totalExpenses ? 'bg-gray-200 text-gray-400 cursor-not-allowed' : 'bg-white text-indigo-600 hover:bg-indigo-50 border border-indigo-200'} transition-colors duration-200`}
                      >
                        Next
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            )}
          </table>
        </div>
      </section>
    </DashboardLayout>
  );
};

export default Expenses;
