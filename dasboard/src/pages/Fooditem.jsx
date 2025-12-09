import React, { useEffect, useState } from "react";
import DashboardLayout from "../layout/DashboardLayout";
import API from "../services/api";
import { getMediaBaseUrl } from "../utils/env";

// Helper function to construct image URLs
const getImageUrl = (imagePath) => {
  if (!imagePath) return 'https://placehold.co/400x300/e2e8f0/a0aec0?text=No+Image';
  if (imagePath.startsWith('http')) return imagePath;
  const baseUrl = getMediaBaseUrl();
  const path = imagePath.startsWith('/') ? imagePath : `/${imagePath}`;
  return `${baseUrl}${path}`;
};

const bgColors = [
  "bg-red-50",
  "bg-green-50",
  "bg-yellow-50",
  "bg-blue-100",
  "bg-purple-50",
  "bg-pink-50",
  "bg-orange-50",
];

const FoodItems = () => {
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [price, setPrice] = useState("");
  const [categories, setCategories] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState("");
  const [message, setMessage] = useState({ type: "", text: "" });
  const [images, setImages] = useState([]);
  const [imagePreviews, setImagePreviews] = useState([]);
  const [foodItems, setFoodItems] = useState([]);
  const [editingItemId, setEditingItemId] = useState(null);
  const [available, setAvailable] = useState(true);

  const token = localStorage.getItem("token");

  useEffect(() => {
    fetchCategories();
    fetchFoodItems();
  }, []);

  const fetchCategories = async () => {
    try {
      const res = await API.get("/food-categories", {
        headers: { Authorization: `Bearer ${token}` },
      });
      setCategories(res.data);
    } catch (err) {
      console.error("Failed to load categories:", err);
    }
  };

  const fetchFoodItems = async () => {
    try {
      const res = await API.get("/food-items", {
        headers: { Authorization: `Bearer ${token}` },
      });
      setFoodItems(res.data);
    } catch (err) {
      console.error("Failed to fetch items", err);
    }
  };

  const handleImageChange = (e) => {
    const newFiles = Array.from(e.target.files);
    setImages((prevImages) => [...prevImages, ...newFiles]);
    const newPreviews = newFiles.map((file) => URL.createObjectURL(file));
    setImagePreviews((prev) => [...prev, ...newPreviews]);
  };

  const handleRemoveImage = (index) => {
    setImages((prev) => prev.filter((_, i) => i !== index));
    setImagePreviews((prev) => prev.filter((_, i) => i !== index));
  };

  const handleEdit = (item) => {
    setEditingItemId(item.id);
    setName(item.name);
    setDescription(item.description);
    setPrice(item.price);
    setSelectedCategory(item.category_id);
    setAvailable(item.available);
    setImagePreviews(item.images?.map((img) => getImageUrl(img.image_url)) || []);
    setImages([]);
  };

  const resetForm = () => {
    setName("");
    setDescription("");
    setPrice("");
    setSelectedCategory("");
    setImages([]);
    setImagePreviews([]);
    setEditingItemId(null);
    setAvailable(true);
    setMessage({ type: "", text: "" });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Validation
    if (!name.trim()) {
      setMessage({ type: "error", text: "Please enter food item name" });
      return;
    }
    if (!description.trim()) {
      setMessage({ type: "error", text: "Please enter description" });
      return;
    }
    if (!price || parseFloat(price) <= 0) {
      setMessage({ type: "error", text: "Please enter a valid price" });
      return;
    }
    if (!selectedCategory) {
      setMessage({ type: "error", text: "Please select a category" });
      return;
    }
    
    const formData = new FormData();
    formData.append("name", name);
    formData.append("description", description);
    formData.append("price", price);
    formData.append("category_id", selectedCategory);
    formData.append("available", available);
    images.forEach((img) => formData.append("images", img));

    try {
      if (editingItemId) {
        await API.put(`/food-items/${editingItemId}`, formData, {
          headers: { Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data" },
        });
        setMessage({ type: "success", text: "Food item updated successfully!" });
      } else {
        await API.post("/food-items", formData, {
          headers: { Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data" },
        });
        setMessage({ type: "success", text: "Food item created successfully!" });
      }
      fetchFoodItems();
      resetForm();
      // Clear message after 3 seconds
      setTimeout(() => setMessage({ type: "", text: "" }), 3000);
    } catch (err) {
      console.error("Failed to save food item", err);
      const errorMsg = err.response?.data?.detail || err.message || "Failed to save food item. Please try again.";
      setMessage({ type: "error", text: errorMsg });
      // Clear error message after 5 seconds
      setTimeout(() => setMessage({ type: "", text: "" }), 5000);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this item?")) return;
    try {
      await API.delete(`/food-items/${id}`, { headers: { Authorization: `Bearer ${token}` } });
      setMessage({ type: "success", text: "Food item deleted successfully!" });
      fetchFoodItems();
      setTimeout(() => setMessage({ type: "", text: "" }), 3000);
    } catch (err) {
      console.error("Delete failed", err);
      const errorMsg = err.response?.data?.detail || "Failed to delete food item";
      setMessage({ type: "error", text: errorMsg });
      setTimeout(() => setMessage({ type: "", text: "" }), 5000);
    }
  };

  const toggleAvailability = async (item) => {
    try {
      await API.patch(
        `/food-items/${item.id}/toggle-availability?available=${!item.available}`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      const newStatus = !item.available ? "Available" : "Not Available";
      setMessage({ type: "success", text: `Food item marked as ${newStatus}` });
      fetchFoodItems();
      setTimeout(() => setMessage({ type: "", text: "" }), 3000);
    } catch (err) {
      console.error("Failed to toggle availability", err);
      const errorMsg = err.response?.data?.detail || "Failed to update availability";
      setMessage({ type: "error", text: errorMsg });
      setTimeout(() => setMessage({ type: "", text: "" }), 5000);
    }
  };

  return (
    <DashboardLayout>
      <div className="p-6 flex flex-col items-center gap-8">
        {/* Success/Error Message */}
        {message.text && (
          <div className={`w-full max-w-4xl p-4 rounded-lg text-center font-semibold ${
            message.type === "success" 
              ? "bg-green-100 text-green-800 border border-green-300" 
              : "bg-red-100 text-red-800 border border-red-300"
          }`}>
            {message.text}
          </div>
        )}
        
        {/* Food Item Form */}
        <form
          onSubmit={handleSubmit}
          className="bg-white shadow-xl rounded-3xl p-8 flex flex-col md:flex-row items-center gap-8 w-full max-w-4xl"
        >
          <div className="flex-1 w-full">
            <h2 className="text-2xl font-bold mb-6 text-gray-700 text-center md:text-left">
              {editingItemId ? "Edit Food Item" : "Add Food Item"}
            </h2>

            <input
              type="text"
              placeholder="Name"
              className="w-full border rounded-xl px-4 py-3 mb-4 focus:ring-2 focus:ring-indigo-500 transition"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
            <textarea
              placeholder="Description"
              className="w-full border rounded-xl px-4 py-3 mb-4 focus:ring-2 focus:ring-indigo-500 transition"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              required
            />
            <input
              type="number"
              placeholder="Price"
              className="w-full border rounded-xl px-4 py-3 mb-4 focus:ring-2 focus:ring-indigo-500 transition"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
              required
            />
            <select
              className="w-full border rounded-xl px-4 py-3 mb-4 focus:ring-2 focus:ring-indigo-500 transition"
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              required
            >
              <option value="">Select Category</option>
              {categories.map((cat) => (
                <option key={cat.id} value={cat.id}>
                  {cat.name}
                </option>
              ))}
            </select>
            <label className="flex items-center gap-2 mb-4">
              <input
                type="checkbox"
                checked={available}
                onChange={() => setAvailable(!available)}
              />
              Available
            </label>

            <input
              type="file"
              accept="image/*"
              multiple
              onChange={handleImageChange}
              className="border rounded-xl px-4 py-2 mb-4"
            />

            <div className="flex gap-4 flex-wrap mb-4">
              {imagePreviews.map((src, index) => (
                <div key={index} className="relative group">
                  <img
                    src={src}
                    alt={`Preview ${index}`}
                    className="w-[100px] h-[100px] object-cover border rounded-xl shadow"
                  />
                  <button
                    type="button"
                    onClick={() => handleRemoveImage(index)}
                    className="absolute top-1 right-1 bg-red-600 text-white rounded-full px-2 py-1 text-xs opacity-0 group-hover:opacity-100 transition"
                  >
                    ×
                  </button>
                </div>
              ))}
            </div>

            <button className="w-full bg-gradient-to-r from-green-500 to-green-700 text-white font-bold py-3 rounded-2xl shadow-lg hover:scale-105 transform transition">
              {editingItemId ? "Update Item" : "Add Item"}
            </button>
          </div>
        </form>

        {/* Food Items Grid */}
        <div className="w-full max-w-6xl">
          <h3 className="text-2xl font-semibold mb-6 text-gray-700 text-center">All Food Items</h3>
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
            {foodItems.map((item, index) => (
              <div
                key={item.id}
                className={`relative border rounded-2xl p-4 shadow hover:shadow-2xl transition ${bgColors[index % bgColors.length]} group`}
              >
                <h4 className="font-semibold text-lg">{item.name}</h4>
                <p className="text-sm text-gray-600">{item.description}</p>
                <p className="text-sm mt-1 font-medium">₹{item.price}</p>
                <p className="text-sm text-gray-700 mt-1">
                  Status:{" "}
                  <span className={item.available ? "text-green-600" : "text-red-500"}>
                    {item.available ? "Available" : "Not Available"}
                  </span>
                </p>

                <div className="flex gap-2 mt-2 flex-wrap">
                  {item.images?.map((img, idx) => (
                    <img
                      key={idx}
                      src={getImageUrl(img.image_url)}
                      alt={`Food ${idx}`}
                      className="w-[60px] h-[60px] object-cover border rounded-xl shadow-sm hover:scale-110 transition"
                    />
                  ))}
                </div>

                {/* Inline Buttons */}
                <div className="flex gap-2 mt-3">
                  <button
                    onClick={() => handleEdit(item)}
                    className="flex-1 px-3 py-1 text-sm bg-blue-600 text-white rounded-xl shadow hover:bg-blue-700 transition"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDelete(item.id)}
                    className="flex-1 px-3 py-1 text-sm bg-red-600 text-white rounded-xl shadow hover:bg-red-700 transition"
                  >
                    Delete
                  </button>
                  <button
                    onClick={() => toggleAvailability(item)}
                    className="flex-1 px-3 py-1 text-sm bg-yellow-600 text-white rounded-xl shadow hover:bg-yellow-700 transition"
                  >
                    Toggle Availability
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </DashboardLayout>
  );
};

export default FoodItems;
