import React, { useEffect, useState } from "react";
import { getImageUrl } from "../utils/image";
import DashboardLayout from "../layout/DashboardLayout";
import API from "../services/api";
import { toast } from "react-hot-toast";
import { motion } from "framer-motion";
import { Edit, Trash2 } from "lucide-react";
import { getMediaBaseUrl } from "../utils/env";
import Modal from "../components/Modal";

// Helper function to get correct image URL based on environment


// KPI Card for quick stats
const KpiCard = ({ title, value, icon, color }) => (
  <div className={`p-6 rounded-2xl text-white shadow-lg flex items-center justify-between transition-transform duration-300 transform hover:scale-105 ${color}`}>
    <div>
      <h4 className="text-lg font-medium">{title}</h4>
      <p className="text-3xl font-bold mt-1">{value}</p>
    </div>
    <div className="text-4xl opacity-80">{icon}</div>
  </div>
);

const FoodManagement = () => {
  // === State for UI/UX enhancements ===
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);
  // === State for Food Items ===
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [price, setPrice] = useState("");
  const [images, setImages] = useState([]); // New image files to upload
  const [existingImages, setExistingImages] = useState([]); // Existing image objects from DB
  const [imagePreviews, setImagePreviews] = useState([]); // All previews (existing + new)
  const [foodItems, setFoodItems] = useState([]);
  const [editingItemId, setEditingItemId] = useState(null);
  const [available, setAvailable] = useState(true);
  const [filters, setFilters] = useState({ search: "", category: "all", availability: "all" });
  const [isFoodItemModalOpen, setIsFoodItemModalOpen] = useState(false);

  // Pagination State
  const [currentPage, setCurrentPage] = useState(1);
  const [itemsPerPage] = useState(20);
  const [totalItems, setTotalItems] = useState(0);

  // === State for Food Categories ===
  const [categoryName, setCategoryName] = useState("");

  const [categories, setCategories] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState("");
  const [editCategoryId, setEditCategoryId] = useState(null);

  const token = localStorage.getItem("token");

  // === Data Fetching Functions ===
  const fetchData = async () => {
    setIsLoading(true);
    setError(null);
    try {
      await fetchCategories();
      await fetchFoodItems(currentPage);
    } catch (err) {
      setError("Failed to load data. Please try again later.");
      toast.error("Failed to load data.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  useEffect(() => {
    fetchFoodItems(currentPage);
  }, [currentPage]); // Fetch whenever page changes

  const fetchCategories = async () => {
    try {
      const res = await API.get("/food-categories", {
        headers: { Authorization: `Bearer ${token}` },
      });
      setCategories(res.data);
    } catch (err) {
      console.error("Failed to load categories:", err);
      throw err;
    }
  };

  const fetchFoodItems = async (page = 1) => {
    try {
      const skip = (page - 1) * itemsPerPage;
      const res = await API.get(`/food-items?skip=${skip}&limit=${itemsPerPage}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      // Handle new backend structure { items, total, page, limit }
      if (res.data.items) {
        setFoodItems(res.data.items);
        setTotalItems(res.data.total);
      } else {
        // Fallback if backend not ready (though we just updated it)
        setFoodItems(res.data);
      }
    } catch (err) {
      console.error("Failed to fetch items", err);
      throw err;
    }
  };

  // === Food Item Handlers ===
  const handleImageChange = (e) => {
    const newFiles = Array.from(e.target.files);
    setImages((prevImages) => [...prevImages, ...newFiles]);
    const newPreviews = newFiles.map((file) => URL.createObjectURL(file));
    setImagePreviews((prev) => [...prev, ...newPreviews]);
  };

  const handleRemoveImage = (index) => {
    // Determine if we are removing an existing image or a new one
    if (index < existingImages.length) {
      // Removing an existing image
      setExistingImages((prev) => prev.filter((_, i) => i !== index));
    } else {
      // Removing a newly added image
      // The index in the 'images' array is offset by existingImages.length
      const newImageIndex = index - existingImages.length;
      setImages((prev) => prev.filter((_, i) => i !== newImageIndex));
    }
    // Always remove from the unified previews list
    setImagePreviews((prev) => prev.filter((_, i) => i !== index));
  };

  const handleEdit = (item) => {
    setEditingItemId(item.id);
    setName(item.name);
    setDescription(item.description);
    setPrice(item.price);
    setSelectedCategory(item.category_id);
    setAvailable(item.available);

    // Store existing images
    setExistingImages(item.images || []);

    // Create previews correctly: existing URLs first
    const existingPreviews = (item.images || []).map((img) => getImageUrl(img.image_url));
    setImagePreviews(existingPreviews);

    // Reset new images
    setImages([]);

    setIsFoodItemModalOpen(true);
  };

  const resetForm = () => {
    setName("");
    setDescription("");
    setPrice("");
    setSelectedCategory("");
    setImages([]);
    setExistingImages([]);
    setImagePreviews([]);
    setEditingItemId(null);
    setAvailable(true);
    setIsFoodItemModalOpen(false);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    const formData = new FormData();
    formData.append("name", name);
    formData.append("description", description);
    formData.append("price", price);
    formData.append("category_id", selectedCategory);
    formData.append("available", available);

    // Append new images
    images.forEach((img) => formData.append("images", img));

    // Append IDs of existing images to keep
    if (editingItemId) {
      const keepIds = existingImages.map(img => img.id).join(",");
      formData.append("keep_image_ids", keepIds);
    }

    try {
      if (editingItemId) {
        await API.put(`/food-items/${editingItemId}`, formData, {
          headers: { Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data" },
        });
        toast.success("Food item updated successfully!");
      } else {
        await API.post("/food-items", formData, {
          headers: { Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data" },
        });
        toast.success("Food item added successfully!");
      }
      fetchFoodItems(currentPage);
      resetForm();
      setIsFoodItemModalOpen(false);
    } catch (err) {
      console.error("Failed to save food item", err);
      toast.error("Failed to save food item.");
    } finally {
      setIsLoading(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this item?")) return;
    setIsLoading(true);
    try {
      await API.delete(`/food-items/${id}`, { headers: { Authorization: `Bearer ${token}` } });
      fetchFoodItems(currentPage);
      toast.success("Food item deleted successfully!");
    } catch (err) {
      console.error("Delete failed", err);
      toast.error("Failed to delete food item.");
    } finally {
      setIsLoading(false);
    }
  };

  const toggleAvailability = async (item) => {
    setIsLoading(true);
    try {
      await API.patch(
        `/food-items/${item.id}/toggle-availability?available=${!item.available}`,
        null,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      fetchFoodItems(currentPage);
      toast.success(`Item status toggled to ${item.available ? 'Not Available' : 'Available'}`);
    } catch (err) {
      console.error("Failed to toggle availability", err);
      toast.error("Failed to toggle availability.");
    } finally {
      setIsLoading(false);
    }
  };

  // === Food Category Handlers ===


  const handleCategorySubmit = async (e) => {
    e.preventDefault();
    if (!categoryName) {
      toast.error("Please fill in the category name.");
      return;
    }
    setIsLoading(true);

    const formData = new FormData();
    formData.append("name", categoryName);


    try {
      if (editCategoryId) {
        await API.put(`/food-categories/${editCategoryId}`, formData, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setEditCategoryId(null);
        toast.success("Category updated successfully!");
      } else {

        await API.post("/food-categories", formData, {
          headers: { Authorization: `Bearer ${token}` },
        });
        toast.success("Category added successfully!");
      }
      setCategoryName("");

      fetchCategories();
    } catch (err) {
      console.error("Failed to save category:", err);
      const errorMessage = err.response?.data?.detail || err.response?.data?.message || err.message || "Failed to save category.";
      toast.error(`Failed to save category: ${errorMessage}`);
    } finally {
      setIsLoading(false);
    }
  };

  const handleCategoryEdit = (cat) => {
    setEditCategoryId(cat.id);
    setCategoryName(cat.name);

  };

  const handleCategoryDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this category?")) return;
    setIsLoading(true);
    try {
      await API.delete(`/food-categories/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      fetchCategories();
      toast.success("Category deleted successfully!");
    } catch (err) {
      console.error("Failed to delete:", err);
      toast.error("Failed to delete category. Check if it's in use.");
    } finally {
      setIsLoading(false);
    }
  };

  // Derived State & Calculations
  // totalItems is now a state variable managed by pagination
  const totalCategories = categories.length;
  // NOTE: availableItemsCount currently only counts items on the displayed page
  const availableItemsCount = foodItems.filter(item => item.available).length;

  const filteredFoodItems = foodItems.filter(item => {
    const searchMatch = item.name.toLowerCase().includes(filters.search.toLowerCase());
    const categoryMatch = filters.category === 'all' || item.category_id === parseInt(filters.category);
    const availabilityMatch = filters.availability === 'all' ||
      (filters.availability === 'available' && item.available) ||
      (filters.availability === 'unavailable' && !item.available);

    return searchMatch && categoryMatch && availabilityMatch;
  });

  if (isLoading) {
    return (
      <DashboardLayout>
        <div className="flex justify-center items-center h-screen">
          <div className="animate-spin rounded-full h-32 w-32 border-t-2 border-b-2 border-indigo-500"></div>
          <p className="ml-4 text-gray-600">Loading...</p>
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout>
      <div className="p-6 space-y-12">
        <h1 className="text-3xl font-bold text-gray-800">Food & Beverage Management</h1>
        {error && <div className="p-4 mb-4 text-center text-red-700 bg-red-100 border border-red-200 rounded-lg">{error}</div>}

        {/* KPI Section */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          <KpiCard title="Total Food Items" value={totalItems} color="bg-gradient-to-r from-green-500 to-green-700" icon={<i className="fas fa-utensils"></i>} />
          <KpiCard title="Item Categories" value={totalCategories} color="bg-gradient-to-r from-blue-500 to-blue-700" icon={<i className="fas fa-tags"></i>} />
          <KpiCard title="Items Available" value={availableItemsCount} color="bg-gradient-to-r from-purple-500 to-purple-700" icon={<i className="fas fa-check-circle"></i>} />
        </div>

        {/* ====================================================== */}
        {/* Food Item Management Section */}
        {/* ====================================================== */}
        {/* ====================================================== */}
        {/* Food Item Management Section */}
        {/* ====================================================== */}

        {/* Header with Add Button */}
        <div className="flex justify-between items-center bg-white p-6 rounded-2xl shadow-lg mb-8">
          <h2 className="text-2xl font-bold text-gray-800">🍽️ Food Item Management</h2>
          <button
            onClick={() => {
              resetForm();
              setIsFoodItemModalOpen(true);
            }}
            className="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-xl shadow-lg hover:scale-105 transform transition flex items-center gap-2"
          >
            <i className="fas fa-plus"></i> Add New Food Item
          </button>
        </div>

        <div className="mt-8">
          <div className="flex flex-wrap gap-4 justify-between items-center mb-6">
            <h3 className="text-2xl font-bold text-gray-700">All Food Items</h3>
            <div className="flex flex-wrap gap-4">
              <input
                type="text"
                placeholder="Search by name..."
                value={filters.search}
                onChange={(e) => setFilters(prev => ({ ...prev, search: e.target.value }))}
                className="p-2 border border-gray-300 rounded-lg"
              />
              <select value={filters.category} onChange={(e) => setFilters(prev => ({ ...prev, category: e.target.value }))} className="p-2 border border-gray-300 rounded-lg">
                <option value="all">All Categories</option>
                {categories.map(cat => <option key={cat.id} value={cat.id}>{cat.name}</option>)}
              </select>
              <select value={filters.availability} onChange={(e) => setFilters(prev => ({ ...prev, availability: e.target.value }))} className="p-2 border border-gray-300 rounded-lg">
                <option value="all">All Statuses</option>
                <option value="available">Available</option>
                <option value="unavailable">Unavailable</option>
              </select>
            </div>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {filteredFoodItems.map((item) => (
              <motion.div
                key={item.id}
                className="bg-gray-50 rounded-2xl shadow-md hover:shadow-xl transition-all duration-300 flex flex-col"
                whileHover={{ y: -5 }}
              >
                <div className="relative">
                  <img
                    src={item.images?.[0] ? getImageUrl(item.images[0].image_url, true) : 'https://placehold.co/400x300/e2e8f0/a0aec0?text=No+Image'}
                    alt={item.name}
                    className="h-48 w-full object-cover rounded-t-2xl"
                  />
                  <span className={`absolute top-2 right-2 px-3 py-1 text-xs font-semibold text-white rounded-full ${item.available ? "bg-green-500" : "bg-red-500"}`}>
                    {item.available ? "Available" : "Unavailable"}
                  </span>
                </div>
                <div className="p-5 flex flex-col flex-grow">
                  <div className="flex justify-between items-start">
                    <h4 className="font-bold text-lg text-gray-800">{item.name}</h4>
                    <p className="text-indigo-600 font-bold text-xl">₹{item.price}</p>
                  </div>
                  <p className="text-sm text-gray-500 mb-2">{categories.find(c => c.id === item.category_id)?.name || 'Uncategorized'}</p>
                  <p className="text-sm text-gray-600 flex-grow">{item.description}</p>
                  <div className="mt-auto pt-4 border-t border-gray-200 flex flex-col gap-2">
                    <div className="flex justify-between gap-2">
                      <button onClick={() => handleEdit(item)} className="w-1/2 bg-blue-100 text-blue-700 text-sm font-semibold py-2 rounded-lg hover:bg-blue-200 transition">Edit</button>
                      <button onClick={() => handleDelete(item.id)} className="w-1/2 bg-red-100 text-red-700 text-sm font-semibold py-2 rounded-lg hover:bg-red-200 transition">Delete</button>
                    </div>
                    <button onClick={() => toggleAvailability(item)} className="w-full bg-yellow-100 text-yellow-800 text-sm font-semibold py-2 rounded-lg hover:bg-yellow-200 transition">Toggle Status</button>
                  </div>
                </div>
              </motion.div>
            ))}
            {filteredFoodItems.length === 0 && (
              <p className="text-center text-gray-500 mt-4 col-span-full">No food items match the current filters.</p>
            )}
          </div>
        </div>


        {/* ====================================================== */}
        {/* Food Category Management Section */}
        {/* ====================================================== */}
        <div className="bg-white p-8 rounded-2xl shadow-lg">
          <h2 className="text-2xl font-bold mb-6 text-gray-800">🏷️ Food Category Management</h2>
          <form
            onSubmit={handleCategorySubmit}
            className="grid grid-cols-1 md:grid-cols-3 gap-8 items-center"
          >
            <div className="md:col-span-2">
              <h3 className="text-xl font-semibold mb-4 text-gray-700">
                {editCategoryId ? "Edit Food Category" : "Add New Food Category"}
              </h3>
              <input
                type="text"
                placeholder="Category Name"
                value={categoryName}
                onChange={(e) => setCategoryName(e.target.value)}
                className="w-full border border-gray-300 rounded-xl px-4 py-3 mb-4 focus:ring-2 focus:ring-indigo-500 transition duration-200"
                required
              />

              <button
                type="submit"
                className="w-full bg-indigo-600 text-white font-bold py-3 mt-8 rounded-xl shadow-lg hover:bg-indigo-700 transition duration-300"
                disabled={isLoading}
              >
                {editCategoryId ? "Update Category" : "Add Category"}
              </button>
              {editCategoryId && (
                <button
                  onClick={() => { setEditCategoryId(null); setCategoryName(""); }}
                  className="w-full mt-3 py-3 rounded-xl border border-gray-300 text-gray-600 font-semibold hover:bg-gray-100 transition-all duration-300"
                  type="button"
                >
                  Cancel Edit
                </button>
              )}
            </div>


          </form>

          <div className="mt-12">
            <h3 className="text-xl font-bold mb-6 text-gray-700">All Categories</h3>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6">
              {categories.map((cat) => (
                <motion.div
                  key={cat.id}
                  className="bg-gray-50 rounded-2xl shadow-md p-4 flex flex-col items-center hover:shadow-lg transition-all"
                  whileHover={{ y: -5 }}
                >
                  <img
                    src={getImageUrl(cat.image ? `static/food_categories/${cat.image}` : "")}
                    alt={cat.name}
                    className="w-24 h-24 object-cover rounded-full mb-3 border-4 border-white shadow-lg"
                  />
                  <p className="font-bold text-lg text-gray-800 mb-3">{cat.name}</p>

                  <div className="flex gap-3 mt-auto">
                    <button
                      onClick={() => handleCategoryEdit(cat)}
                      className="bg-blue-100 text-blue-600 p-2 rounded-full hover:bg-blue-200 transition-colors"
                      title="Edit Category"
                    >
                      <Edit size={18} />
                    </button>
                    <button
                      onClick={() => handleCategoryDelete(cat.id)}
                      className="bg-red-100 text-red-600 p-2 rounded-full hover:bg-red-200 transition-colors"
                      title="Delete Category"
                    >
                      <Trash2 size={18} />
                    </button>
                  </div>
                </motion.div>
              ))}
              {categories.length === 0 && (
                <p className="text-center text-gray-500 mt-4 col-span-full">No categories found.</p>
              )}
            </div>


          </div>
        </div>
      </div>
      {/* Food Item Modal */}
      < Modal
        isOpen={isFoodItemModalOpen}
        onClose={resetForm}
        title={editingItemId ? "Edit Food Item" : "Add New Food Item"}
      >
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Name</label>
              <input
                type="text"
                placeholder="Food Item Name"
                className="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 transition duration-200"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
              <textarea
                placeholder="Description"
                className="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 transition duration-200"
                rows="3"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                required
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Price (₹)</label>
                <input
                  type="number"
                  placeholder="Price"
                  className="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 transition duration-200"
                  value={price}
                  onChange={(e) => setPrice(e.target.value)}
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Category</label>
                <select
                  className="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 transition duration-200"
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
              </div>
            </div>

            <label className="flex items-center gap-2 cursor-pointer bg-gray-50 p-3 rounded-xl border">
              <input
                type="checkbox"
                className="form-checkbox h-5 w-5 text-indigo-600 rounded"
                checked={available}
                onChange={() => setAvailable(!available)}
              />
              <span className="text-gray-700 font-medium">Available for Order</span>
            </label>
          </div>

          {/* Image Upload for Modal */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Upload Images</label>
            <input
              type="file"
              accept="image/*"
              multiple
              onChange={handleImageChange}
              className="w-full border border-gray-300 rounded-xl px-4 py-2 bg-gray-50"
            />
            {imagePreviews.length > 0 && (
              <div className="grid grid-cols-4 gap-2 mt-4">
                {imagePreviews.map((src, index) => (
                  <div key={index} className="relative group aspect-square">
                    <img
                      src={src}
                      alt={`Preview ${index}`}
                      className="w-full h-full object-cover rounded-lg border border-gray-200"
                    />
                    <button
                      type="button"
                      onClick={() => handleRemoveImage(index)}
                      className="absolute -top-1 -right-1 bg-red-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs opacity-0 group-hover:opacity-100 transition duration-200 shadow-sm"
                    >
                      ×
                    </button>
                  </div>
                ))}
              </div>
            )}
          </div>

          <div className="flex gap-3 pt-4 border-t mt-4">
            <button
              type="button"
              onClick={resetForm}
              className="flex-1 px-4 py-3 bg-gray-100 text-gray-700 font-bold rounded-xl hover:bg-gray-200 transition"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isLoading}
              className="flex-1 px-4 py-3 bg-gradient-to-r from-indigo-600 to-indigo-700 text-white font-bold rounded-xl shadow-lg hover:shadow-xl hover:-translate-y-0.5 transform transition"
            >
              {editingItemId ? "Update Item" : "Create Item"}
            </button>
            {/* Pagination Controls */}
            {totalItems > itemsPerPage && (
              <div className="flex justify-center items-center mt-8 space-x-2">
                <button
                  onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
                  disabled={currentPage === 1}
                  className={`px-4 py-2 rounded-lg ${currentPage === 1 ? 'bg-gray-200 text-gray-400 cursor-not-allowed' : 'bg-white text-indigo-600 hover:bg-indigo-50 border border-indigo-200'} transition-colors duration-200`}
                >
                  Previous
                </button>

                <span className="text-gray-600 font-medium px-4">
                  Page {currentPage} of {Math.ceil(totalItems / itemsPerPage)}
                </span>

                <button
                  onClick={() => setCurrentPage(prev => (prev * itemsPerPage < totalItems ? prev + 1 : prev))}
                  disabled={currentPage * itemsPerPage >= totalItems}
                  className={`px-4 py-2 rounded-lg ${currentPage * itemsPerPage >= totalItems ? 'bg-gray-200 text-gray-400 cursor-not-allowed' : 'bg-white text-indigo-600 hover:bg-indigo-50 border border-indigo-200'} transition-colors duration-200`}
                >
                  Next
                </button>
              </div>
            )}
          </div>
        </form>
      </Modal >

    </DashboardLayout >
  );
};

export default FoodManagement;