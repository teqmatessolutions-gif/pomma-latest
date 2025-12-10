import React, { useEffect, useState } from "react";
import DashboardLayout from "../layout/DashboardLayout";
import api from "../services/api";
import { toast } from "react-hot-toast";
import {
  Package,
  MapPin,
  ShoppingCart,
  UtensilsCrossed,
  FileText,
  TrendingDown,
  BarChart3,
  Plus,
  Edit,
  Trash2,
  Check,
  X,
  Search,
  Filter,
  Grid3x3,
  List,
  Bed,
  ChefHat,
  Wrench,
  FileText as ReportIcon,
  AlertTriangle,
  DollarSign,
  TrendingUp,
  Database,
  Tag,
  Ruler
} from "lucide-react";

const Inventory = () => {
  const [activeTab, setActiveTab] = useState("purchase");
  const [loading, setLoading] = useState(false);

  // Master Inventory State
  const [items, setItems] = useState([]);
  const [locations, setLocations] = useState([]);
  const [stockLevels, setStockLevels] = useState([]);
  const [categories, setCategories] = useState([]);
  const [uoms, setUoms] = useState([]);
  const [showCategoryForm, setShowCategoryForm] = useState(false);
  const [showUOMForm, setShowUOMForm] = useState(false);
  const [categoryForm, setCategoryForm] = useState({ name: "", description: "" });
  const [uomForm, setUomForm] = useState({ name: "", symbol: "", description: "" });
  const [itemForm, setItemForm] = useState({
    name: "",
    description: "",
    category_id: "",
    sku: "",
    hsn_code: "",
    gst_rate: 0,
    barcode: "",
    base_uom_id: "",
    unit_price: 0,
    selling_price: 0,
    min_stock_level: 0,
    max_stock_level: 0,
    track_expiry: false,
    track_serial: false,
    track_batch: false
  });
  const [editingItem, setEditingItem] = useState(null);
  const [showItemForm, setShowItemForm] = useState(false);
  const [showLocationForm, setShowLocationForm] = useState(false);
  const [locationForm, setLocationForm] = useState({
    name: "",
    code: "",
    location_type: "sub_store",
    parent_location_id: "",
    description: ""
  });
  const [selectedLocationForStock, setSelectedLocationForStock] = useState(null);

  // Room Inventory State
  const [rooms, setRooms] = useState([]);
  const [roomInventory, setRoomInventory] = useState({});
  const [selectedRoom, setSelectedRoom] = useState(null);
  const [auditForm, setAuditForm] = useState({});

  // Assets State
  const [roomAssets, setRoomAssets] = useState([]);
  const [selectedAssetRoom, setSelectedAssetRoom] = useState(null);
  const [showAssetForm, setShowAssetForm] = useState(false);
  const [assetForm, setAssetForm] = useState({
    room_id: "",
    item_id: "",
    asset_id: "",
    serial_number: "",
    purchase_date: "",
    purchase_price: 0
  });
  const [showInspectionForm, setShowInspectionForm] = useState(false);
  const [selectedAsset, setSelectedAsset] = useState(null);
  const [inspectionForm, setInspectionForm] = useState({
    status: "good",
    damage_description: "",
    charge_to_guest: false,
    charge_amount: 0,
    notes: ""
  });

  // Kitchen & Recipes State
  const [recipes, setRecipes] = useState([]);
  const [foodItems, setFoodItems] = useState([]);
  const [showRecipeForm, setShowRecipeForm] = useState(false);
  const [recipeForm, setRecipeForm] = useState({
    name: "",
    description: "",
    food_item_id: "",
    servings: 1,
    ingredients: []
  });
  const [newIngredient, setNewIngredient] = useState({
    item_id: "",
    quantity: 0,
    uom: "g"
  });
  const [kitchenStockLevels, setKitchenStockLevels] = useState([]);
  const [selectedKitchenLocation, setSelectedKitchenLocation] = useState(null);

  // Indents State
  const [indents, setIndents] = useState([]);
  const [showIndentForm, setShowIndentForm] = useState(false);
  const [indentForm, setIndentForm] = useState({
    requested_from_location_id: "",
    requested_to_location_id: "",
    items: [],
    notes: ""
  });
  const [newIndentItem, setNewIndentItem] = useState({
    item_id: "",
    quantity: 0,
    uom: "pieces"
  });
  const [selectedIndent, setSelectedIndent] = useState(null);
  const [showRoomInventorySetup, setShowRoomInventorySetup] = useState(false);
  const [roomInventorySetup, setRoomInventorySetup] = useState({
    room_id: "",
    item_id: "",
    par_stock: 0
  });

  // Dashboard Stats
  const [dashboardStats, setDashboardStats] = useState({
    total_items: 0,
    low_stock_items: 0,
    pending_indents: 0,
    total_stock_value: 0
  });

  useEffect(() => {
    fetchDashboardStats();
    fetchCategories();
    fetchUOMs();
    if (activeTab === "dashboard") {
      fetchItems();
      fetchLocations();
      fetchStockLevels();
    } else if (activeTab === "master-items") {
      fetchItems();
      fetchLocations();
    } else if (activeTab === "stock-management") {
      fetchStockLevels();
      fetchLocations();
    } else if (activeTab === "room-inventory") {
      fetchRooms();
      fetchItems();
    } else if (activeTab === "kitchen") {
      fetchRecipes();
      fetchFoodItems();
      fetchItems();
      fetchLocations();
      if (selectedKitchenLocation) {
        fetchKitchenStock();
      }
    } else if (activeTab === "store-room") {
      fetchIndents();
      fetchLocations();
      fetchItems();
    } else if (activeTab === "reports") {
      fetchItems();
      fetchStockLevels();
      fetchIndents();
    } else if (activeTab === "view-all") {
      fetchItems();
      fetchCategories();
      fetchUOMs();
    }
  }, [activeTab, selectedLocationForStock, selectedAssetRoom, selectedKitchenLocation]);

  const fetchDashboardStats = async () => {
    try {
      const res = await api.get("/inventory/dashboard");
      setDashboardStats(res.data);
    } catch (error) {
      console.error("Error fetching dashboard stats:", error);
    }
  };

  const fetchCategories = async () => {
    try {
      const res = await api.get("/inventory/categories");
      setCategories(res.data);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  };

  const fetchUOMs = async () => {
    try {
      const res = await api.get("/inventory/uoms");
      setUoms(res.data);
    } catch (error) {
      console.error("Error fetching UOMs:", error);
    }
  };

  const fetchItems = async () => {
    setLoading(true);
    try {
      const res = await api.get("/inventory/items?limit=1000");
      setItems(res.data);
    } catch (error) {
      toast.error("Failed to fetch items");
    } finally {
      setLoading(false);
    }
  };

  const fetchLocations = async () => {
    try {
      const res = await api.get("/inventory/locations");
      setLocations(res.data);
    } catch (error) {
      console.error("Error fetching locations:", error);
    }
  };

  const fetchStockLevels = async () => {
    try {
      const url = selectedLocationForStock 
        ? `/inventory/stock-levels?location_id=${selectedLocationForStock}`
        : "/inventory/stock-levels";
      const res = await api.get(url);
      setStockLevels(res.data);
    } catch (error) {
      console.error("Error fetching stock levels:", error);
    }
  };

  const handleCreateLocation = async (e) => {
    e.preventDefault();
    try {
      const payload = {
        ...locationForm,
        parent_location_id: locationForm.parent_location_id ? parseInt(locationForm.parent_location_id) : null
      };
      await api.post("/inventory/locations", payload);
      toast.success("Location created successfully");
      setShowLocationForm(false);
      setLocationForm({
        name: "",
        code: "",
        location_type: "sub_store",
        parent_location_id: "",
        description: ""
      });
      fetchLocations();
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to create location");
    }
  };

  const fetchRooms = async () => {
    try {
      const res = await api.get("/rooms?limit=1000");
      setRooms(res.data);
    } catch (error) {
      toast.error("Failed to fetch rooms");
    }
  };

  const fetchRoomInventory = async (roomId) => {
    try {
      const res = await api.get(`/inventory/room-inventory/${roomId}`);
      setRoomInventory(prev => ({ ...prev, [roomId]: res.data }));
    } catch (error) {
      console.error("Error fetching room inventory:", error);
    }
  };

  const fetchRecipes = async () => {
    try {
      const res = await api.get("/inventory/recipes");
      setRecipes(res.data);
    } catch (error) {
      console.error("Error fetching recipes:", error);
    }
  };

  const fetchFoodItems = async () => {
    try {
      const res = await api.get("/food-items?limit=1000");
      setFoodItems(res.data);
    } catch (error) {
      console.error("Error fetching food items:", error);
    }
  };

  const fetchIndents = async () => {
    try {
      const res = await api.get("/inventory/indents");
      setIndents(res.data);
    } catch (error) {
      console.error("Error fetching indents:", error);
    }
  };

  const fetchRoomAssets = async (roomId) => {
    try {
      const res = await api.get(`/inventory/room-assets/${roomId}`);
      setRoomAssets(res.data);
    } catch (error) {
      console.error("Error fetching room assets:", error);
    }
  };

  const fetchKitchenStock = async () => {
    if (!selectedKitchenLocation) return;
    try {
      const res = await api.get(`/inventory/stock-levels?location_id=${selectedKitchenLocation}`);
      setKitchenStockLevels(res.data);
    } catch (error) {
      console.error("Error fetching kitchen stock:", error);
    }
  };

  const handleCreateAsset = async (e) => {
    e.preventDefault();
    try {
      await api.post("/inventory/room-assets", assetForm);
      toast.success("Asset created successfully");
      setShowAssetForm(false);
      setAssetForm({
        room_id: "",
        item_id: "",
        asset_id: "",
        serial_number: "",
        purchase_date: "",
        purchase_price: 0
      });
      if (selectedAssetRoom) {
        fetchRoomAssets(selectedAssetRoom);
      }
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to create asset");
    }
  };

  const handleInspectAsset = async (e) => {
    e.preventDefault();
    try {
      await api.post(`/inventory/room-assets/${selectedAsset.id}/inspect`, inspectionForm);
      toast.success("Inspection logged successfully");
      setShowInspectionForm(false);
      setSelectedAsset(null);
      if (selectedAssetRoom) {
        fetchRoomAssets(selectedAssetRoom);
      }
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to log inspection");
    }
  };

  const handleCreateRecipe = async (e) => {
    e.preventDefault();
    if (recipeForm.ingredients.length === 0) {
      toast.error("Please add at least one ingredient");
      return;
    }
    try {
      await api.post("/inventory/recipes", recipeForm);
      toast.success("Recipe created successfully");
      setShowRecipeForm(false);
      setRecipeForm({
        name: "",
        description: "",
        food_item_id: "",
        servings: 1,
        ingredients: []
      });
      fetchRecipes();
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to create recipe");
    }
  };

  const handleAddIngredient = () => {
    if (!newIngredient.item_id || newIngredient.quantity <= 0) {
      toast.error("Please select item and enter quantity");
      return;
    }
    setRecipeForm({
      ...recipeForm,
      ingredients: [...recipeForm.ingredients, { ...newIngredient }]
    });
    setNewIngredient({ item_id: "", quantity: 0, uom: "g" });
  };

  const handleRemoveIngredient = (index) => {
    setRecipeForm({
      ...recipeForm,
      ingredients: recipeForm.ingredients.filter((_, i) => i !== index)
    });
  };

  const handleConsumeRecipe = async (recipeId, quantity) => {
    if (!selectedKitchenLocation) {
      toast.error("Please select a kitchen location first");
      return;
    }
    try {
      const res = await api.post(`/inventory/recipes/${recipeId}/consume`, {
        quantity,
        location_id: selectedKitchenLocation
      });
      toast.success("Ingredients consumed successfully");
      fetchKitchenStock();
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to consume ingredients");
    }
  };

  const handleCreateIndent = async (e) => {
    e.preventDefault();
    if (indentForm.items.length === 0) {
      toast.error("Please add at least one item");
      return;
    }
    try {
      await api.post("/inventory/indents", indentForm);
      toast.success("Indent created successfully");
      setShowIndentForm(false);
      setIndentForm({
        requested_from_location_id: "",
        requested_to_location_id: "",
        items: [],
        notes: ""
      });
      fetchIndents();
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to create indent");
    }
  };

  const handleAddIndentItem = () => {
    if (!newIndentItem.item_id || newIndentItem.quantity <= 0) {
      toast.error("Please select item and enter quantity");
      return;
    }
    setIndentForm({
      ...indentForm,
      items: [...indentForm.items, { ...newIndentItem }]
    });
    setNewIndentItem({ item_id: "", quantity: 0, uom: "pieces" });
  };

  const handleRemoveIndentItem = (index) => {
    setIndentForm({
      ...indentForm,
      items: indentForm.items.filter((_, i) => i !== index)
    });
  };

  const handleApproveIndent = async (indentId) => {
    try {
      const indent = indents.find(i => i.id === indentId);
      const approvedItems = indent.items.map(item => ({
        item_id: item.item_id,
        approved_quantity: item.requested_quantity
      }));
      await api.post(`/inventory/indents/${indentId}/approve`, approvedItems);
      toast.success("Indent approved successfully");
      fetchIndents();
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to approve indent");
    }
  };

  const handleSetupRoomInventory = async (e) => {
    e.preventDefault();
    try {
      await api.post("/inventory/room-inventory", roomInventorySetup);
      toast.success("Room inventory item added successfully");
      setShowRoomInventorySetup(false);
      setRoomInventorySetup({ room_id: "", item_id: "", par_stock: 0 });
      if (selectedRoom) {
        fetchRoomInventory(selectedRoom);
      }
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to setup room inventory");
    }
  };

  const handleCreateCategory = async (e) => {
    e.preventDefault();
    try {
      await api.post("/inventory/categories", categoryForm);
      toast.success("Category created successfully");
      setShowCategoryForm(false);
      setCategoryForm({ name: "", description: "" });
      fetchCategories();
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to create category");
    }
  };

  const handleCreateUOM = async (e) => {
    e.preventDefault();
    try {
      await api.post("/inventory/uoms", uomForm);
      toast.success("Unit of measurement created successfully");
      setShowUOMForm(false);
      setUomForm({ name: "", symbol: "", description: "" });
      fetchUOMs();
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to create unit");
    }
  };

  const handleCreateItem = async (e) => {
    e.preventDefault();
    try {
      // Ensure required fields are not empty
      if (!itemForm.sku || itemForm.sku.trim() === "") {
        toast.error("SKU is required");
        return;
      }
      if (!itemForm.hsn_code || itemForm.hsn_code.trim() === "") {
        toast.error("HSN Code is required");
        return;
      }
      if (itemForm.gst_rate === null || itemForm.gst_rate === undefined || itemForm.gst_rate < 0) {
        toast.error("GST Rate is required and must be 0 or greater");
        return;
      }
      
      const payload = {
        ...itemForm,
        category_id: parseInt(itemForm.category_id),
        base_uom_id: parseInt(itemForm.base_uom_id),
        sku: itemForm.sku.trim(),
        hsn_code: itemForm.hsn_code.trim(),
        gst_rate: parseFloat(itemForm.gst_rate) || 0,
        min_stock_level: parseFloat(itemForm.min_stock_level) || 0
      };
      if (editingItem) {
        await api.put(`/inventory/items/${editingItem.id}`, payload);
        toast.success("Item updated successfully");
      } else {
        await api.post("/inventory/items", payload);
        toast.success("Item created successfully");
      }
      setEditingItem(null);
      setItemForm({
        name: "",
        description: "",
        category_id: "",
        sku: "",
        hsn_code: "",
        gst_rate: 0,
        barcode: "",
        base_uom_id: "",
        unit_price: 0,
        selling_price: 0,
        min_stock_level: 0,
        max_stock_level: 0,
        track_expiry: false,
        track_serial: false,
        track_batch: false
      });
      fetchItems();
    } catch (error) {
      toast.error(error.response?.data?.detail || "Failed to save item");
    }
  };

  const handleEditItem = (item) => {
    setEditingItem(item);
    setItemForm({
      name: item.name,
      description: item.description || "",
      category_id: item.category_id || item.category?.id || "",
      sku: item.sku || "",
      hsn_code: item.hsn_code || "",
      gst_rate: item.gst_rate || 0,
      barcode: item.barcode || "",
      base_uom_id: item.base_uom_id || item.base_uom?.id || "",
      unit_price: item.unit_price,
      selling_price: item.selling_price,
      min_stock_level: item.min_stock_level,
      max_stock_level: item.max_stock_level,
      track_expiry: item.track_expiry,
      track_serial: item.track_serial,
      track_batch: item.track_batch
    });
  };

  const handleDeleteItem = async (itemId) => {
    if (!window.confirm("Are you sure you want to delete this item?")) return;
    try {
      await api.delete(`/inventory/items/${itemId}`);
      toast.success("Item deleted successfully");
      fetchItems();
    } catch (error) {
      toast.error("Failed to delete item");
    }
  };

  const handleRoomAudit = async (roomId, itemId, foundQuantity) => {
    try {
      const res = await api.post("/inventory/room-inventory/audit", {
        room_id: roomId,
        room_inventory_item_id: itemId,
        found_quantity: foundQuantity
      });
      toast.success(`Audit completed. Consumed: ${res.data.consumed}, Billed: ₹${res.data.billed_amount}`);
      fetchRoomInventory(roomId);
    } catch (error) {
      toast.error("Failed to complete audit");
    }
  };

  const TabButton = ({ id, label, icon, title }) => (
    <button
      onClick={() => setActiveTab(id)}
      className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-all ${
        activeTab === id
          ? "bg-indigo-600 text-white shadow-md"
          : "text-gray-600 hover:bg-gray-100"
      }`}
      title={title || label}
    >
      {icon}
      {label}
    </button>
  );

  // Combined render function for viewing all items, categories, and UOMs - VIEW ALL TAB
  const renderViewAll = () => {
    console.log("View All tab rendered");
    return (
    <div className="space-y-6">
      {/* Items Section */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold text-gray-800 flex items-center gap-2">
            <Package size={24} />
            All Items
          </h2>
          <div className="text-sm text-gray-500">Total: {items.length} items</div>
        </div>
        {loading ? (
          <div className="text-center py-12 text-gray-500">Loading...</div>
        ) : items.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <Package size={48} className="mx-auto mb-4 text-gray-300" />
            <p>No items found.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-semibold">NAME</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">CATEGORY</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">SKU</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">HSN CODE</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">GST RATE</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">UOM</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">LOW STOCK</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">STOCK</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">ACTIONS</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {items.map((item) => (
                  <tr key={item.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3 font-medium">{item.name}</td>
                    <td className="px-4 py-3">
                      <span className="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs">
                        {item.category?.name || item.category_ref?.name || "N/A"}
                      </span>
                    </td>
                    <td className="px-4 py-3">{item.sku || "-"}</td>
                    <td className="px-4 py-3">{item.hsn_code || "-"}</td>
                    <td className="px-4 py-3">{item.gst_rate ? `${item.gst_rate}%` : "0%"}</td>
                    <td className="px-4 py-3">{item.base_uom?.name || item.uom_ref?.name || "-"}</td>
                    <td className="px-4 py-3">
                      <span className={item.min_stock_level > 0 ? "text-gray-700" : "text-gray-400"}>
                        {item.min_stock_level || 0}
                      </span>
                    </td>
                    <td className="px-4 py-3">
                      <span className={item.total_stock <= item.min_stock_level ? "text-red-600 font-semibold" : "text-gray-700"}>
                        {item.total_stock || 0} {item.base_uom?.name || item.uom_ref?.name || ""}
                      </span>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex gap-2">
                        <button
                          onClick={() => handleEditItem(item)}
                          className="p-1 text-blue-600 hover:bg-blue-50 rounded"
                          title="Edit"
                        >
                          <Edit size={16} />
                        </button>
                        <button
                          onClick={() => handleDeleteItem(item.id)}
                          className="p-1 text-red-600 hover:bg-red-50 rounded"
                          title="Delete"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Categories Section */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold text-gray-800 flex items-center gap-2">
            <Tag size={24} />
            All Categories
          </h2>
          <div className="text-sm text-gray-500">Total: {categories.length} categories</div>
        </div>
        {categories.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <Tag size={48} className="mx-auto mb-4 text-gray-300" />
            <p>No categories found.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-semibold">NAME</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">DESCRIPTION</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">STATUS</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">ACTIONS</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {categories.map((category) => (
                  <tr key={category.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3 font-medium">{category.name}</td>
                    <td className="px-4 py-3 text-gray-600">{category.description || "-"}</td>
                    <td className="px-4 py-3">
                      <span className={`px-2 py-1 rounded text-xs ${
                        category.is_active !== false ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"
                      }`}>
                        {category.is_active !== false ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex gap-2">
                        <button
                          onClick={() => {
                            setCategoryForm({ name: category.name, description: category.description || "" });
                            setShowCategoryForm(true);
                          }}
                          className="p-1 text-blue-600 hover:bg-blue-50 rounded"
                          title="Edit"
                        >
                          <Edit size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* UOMs Section */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold text-gray-800 flex items-center gap-2">
            <Ruler size={24} />
            All Units of Measurement
          </h2>
          <div className="text-sm text-gray-500">Total: {uoms.length} UOMs</div>
        </div>
        {uoms.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <Ruler size={48} className="mx-auto mb-4 text-gray-300" />
            <p>No units of measurement found.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-semibold">NAME</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">SYMBOL</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">DESCRIPTION</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">STATUS</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">ACTIONS</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {uoms.map((uom) => (
                  <tr key={uom.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3 font-medium">{uom.name}</td>
                    <td className="px-4 py-3">
                      <span className="px-2 py-1 bg-purple-100 text-purple-800 rounded text-xs font-mono">
                        {uom.symbol || uom.abbreviation || "-"}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-600">{uom.description || "-"}</td>
                    <td className="px-4 py-3">
                      <span className={`px-2 py-1 rounded text-xs ${
                        uom.is_active !== false ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"
                      }`}>
                        {uom.is_active !== false ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex gap-2">
                        <button
                          onClick={() => {
                            setUomForm({ 
                              name: uom.name, 
                              symbol: uom.symbol || uom.abbreviation || "", 
                              description: uom.description || "" 
                            });
                            setShowUOMForm(true);
                          }}
                          className="p-1 text-blue-600 hover:bg-blue-50 rounded"
                          title="Edit"
                        >
                          <Edit size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
    );
  };

  const renderDashboard = () => {
    const lowStockItems = stockLevels.filter(stock => 
      stock.item && stock.quantity <= stock.item.min_stock_level
    );
    const totalAssetValue = items
      .filter(item => {
        const catName = item.category?.name || item.category_ref?.name || "";
        return catName.toLowerCase().includes("asset");
      })
      .reduce((sum, item) => sum + (item.unit_price || 0), 0);
    const totalConsumableValue = stockLevels
      .filter(stock => {
        const catName = stock.item?.category?.name || stock.item?.category_ref?.name || "";
        return catName.toLowerCase().includes("consumable");
      })
      .reduce((sum, stock) => sum + (stock.quantity * (stock.item?.unit_price || 0)), 0);
    
    // Calculate consumption rate (simplified - based on recent stock movements)
    const consumptionRate = "N/A"; // Would need stock movement data

    return (
      <div className="space-y-6">
        <div className="bg-white rounded-xl shadow-md p-6">
          <h2 className="text-xl font-bold text-gray-800 mb-4">Inventory Overview</h2>
          <p className="text-gray-600 mb-6">
            Dashboard with KPIs for stock levels, low-stock alerts, asset value, and consumption rates.
          </p>

          {/* KPI Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            <div className="bg-gradient-to-br from-blue-50 to-blue-100 p-6 rounded-lg border border-blue-200">
              <div className="flex items-center justify-between mb-2">
                <h3 className="text-sm font-medium text-gray-600">Total Items</h3>
                <Package className="text-blue-600" size={24} />
              </div>
              <p className="text-3xl font-bold text-blue-700">{dashboardStats.total_items}</p>
              <p className="text-xs text-gray-500 mt-1">Active inventory items</p>
            </div>

            <div className="bg-gradient-to-br from-red-50 to-red-100 p-6 rounded-lg border border-red-200">
              <div className="flex items-center justify-between mb-2">
                <h3 className="text-sm font-medium text-gray-600">Low Stock Alerts</h3>
                <AlertTriangle className="text-red-600" size={24} />
              </div>
              <p className="text-3xl font-bold text-red-700">{lowStockItems.length}</p>
              <p className="text-xs text-gray-500 mt-1">Items below threshold</p>
            </div>

            <div className="bg-gradient-to-br from-green-50 to-green-100 p-6 rounded-lg border border-green-200">
              <div className="flex items-center justify-between mb-2">
                <h3 className="text-sm font-medium text-gray-600">Asset Value</h3>
                <DollarSign className="text-green-600" size={24} />
              </div>
              <p className="text-3xl font-bold text-green-700">₹{totalAssetValue.toLocaleString()}</p>
              <p className="text-xs text-gray-500 mt-1">Total fixed assets</p>
            </div>

            <div className="bg-gradient-to-br from-purple-50 to-purple-100 p-6 rounded-lg border border-purple-200">
              <div className="flex items-center justify-between mb-2">
                <h3 className="text-sm font-medium text-gray-600">Stock Value</h3>
                <TrendingUp className="text-purple-600" size={24} />
              </div>
              <p className="text-3xl font-bold text-purple-700">₹{totalConsumableValue.toLocaleString()}</p>
              <p className="text-xs text-gray-500 mt-1">Consumable inventory</p>
            </div>
          </div>

          {/* Low Stock Alerts */}
          {lowStockItems.length > 0 && (
            <div className="mt-6">
              <h3 className="text-lg font-semibold text-gray-800 mb-4">Low Stock Alerts</h3>
              <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                <div className="space-y-2">
                  {lowStockItems.slice(0, 5).map((stock) => (
                    <div key={stock.id} className="flex items-center justify-between p-2 bg-white rounded">
                      <div>
                        <span className="font-medium">{stock.item?.name}</span>
                        <span className="text-sm text-gray-600 ml-2">
                          ({stock.location?.name}) - {stock.quantity} {stock.uom} remaining
                        </span>
                      </div>
                      <span className="px-2 py-1 bg-red-100 text-red-800 rounded text-xs">
                        Low Stock
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    );
  };

  const renderMasterInventory = () => (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      {/* Left Panel - Add New Item - All 7 Fields Required */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-bold text-gray-800 flex items-center gap-2">
            <Plus size={20} />
            Add New Item
          </h2>
        </div>

        <form onSubmit={handleCreateItem} className="space-y-4">
          {/* Item Name Field */}
          <div>
            <label className="block text-sm font-medium mb-1">Item Name *</label>
            <input
              type="text"
              value={itemForm.name}
              onChange={(e) => setItemForm({ ...itemForm, name: e.target.value })}
              className="w-full px-3 py-2 border rounded-lg"
              required
            />
          </div>
          
          {/* Category Field */}
          <div>
            <label className="block text-sm font-medium mb-1">Category *</label>
            <div className="flex gap-2">
              <select
                value={itemForm.category_id}
                onChange={(e) => setItemForm({ ...itemForm, category_id: e.target.value })}
                className="flex-1 px-3 py-2 border rounded-lg"
                required
              >
                <option value="">Select Category</option>
                {categories.map(cat => (
                  <option key={cat.id} value={cat.id}>{cat.name}</option>
                ))}
              </select>
              <button
                type="button"
                onClick={() => setShowCategoryForm(true)}
                className="px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm"
                title="Add New Category"
              >
                <Plus size={16} />
              </button>
            </div>
          </div>
          
          {/* SKU Field - REQUIRED */}
          <div>
            <label className="block text-sm font-medium mb-1 text-gray-700">SKU *</label>
            <input
              type="text"
              value={itemForm.sku || ""}
              onChange={(e) => setItemForm({ ...itemForm, sku: e.target.value })}
              className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500"
              placeholder="Stock Keeping Unit"
              required
            />
          </div>
          
          {/* HSN Code Field - REQUIRED */}
          <div>
            <label className="block text-sm font-medium mb-1 text-gray-700">HSN Code *</label>
            <input
              type="text"
              value={itemForm.hsn_code || ""}
              onChange={(e) => setItemForm({ ...itemForm, hsn_code: e.target.value })}
              className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500"
              placeholder="Harmonized System of Nomenclature Code"
              required
            />
          </div>
          
          {/* GST Rate Field - REQUIRED */}
          <div>
            <label className="block text-sm font-medium mb-1 text-gray-700">GST Rate (%) *</label>
            <input
              type="number"
              step="0.01"
              min="0"
              max="100"
              value={itemForm.gst_rate || 0}
              onChange={(e) => setItemForm({ ...itemForm, gst_rate: parseFloat(e.target.value) || 0 })}
              className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500"
              placeholder="0"
              required
            />
          </div>
          
          {/* UOM Field */}
          <div>
            <label className="block text-sm font-medium mb-1">Unit of Measurement (UOM) *</label>
            <div className="flex gap-2">
              <select
                value={itemForm.base_uom_id}
                onChange={(e) => setItemForm({ ...itemForm, base_uom_id: e.target.value })}
                className="flex-1 px-3 py-2 border rounded-lg"
                required
              >
                <option value="">Select UOM</option>
                {uoms.map(uom => (
                  <option key={uom.id} value={uom.id}>
                    {uom.name} {uom.symbol ? `(${uom.symbol})` : ""}
                  </option>
                ))}
              </select>
              <button
                type="button"
                onClick={() => setShowUOMForm(true)}
                className="px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm"
                title="Add New Unit"
              >
                <Plus size={16} />
              </button>
            </div>
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Low Stock Threshold *</label>
            <input
              type="number"
              step="0.01"
              min="0"
              value={itemForm.min_stock_level}
              onChange={(e) => setItemForm({ ...itemForm, min_stock_level: parseFloat(e.target.value) || 0 })}
              className="w-full px-3 py-2 border rounded-lg"
              required
            />
          </div>
          <div className="flex gap-2">
            <button
              type="submit"
              className="flex-1 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
            >
              {editingItem ? "Update Item" : "Save Item"}
            </button>
            {editingItem && (
              <button
                type="button"
                onClick={() => {
                  setEditingItem(null);
                  setItemForm({
                    name: "",
                    description: "",
                    category_id: "",
                    sku: "",
                    hsn_code: "",
                    gst_rate: 0,
                    barcode: "",
                    base_uom_id: "",
                    unit_price: 0,
                    selling_price: 0,
                    min_stock_level: 0,
                    max_stock_level: 0,
                    track_expiry: false,
                    track_serial: false,
                    track_batch: false
                  });
                }}
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
              >
                Cancel
              </button>
            )}
          </div>
        </form>
      </div>

      {/* Right Panel - Master Item Catalog */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <h2 className="text-xl font-bold text-gray-800 mb-4">Master Item Catalog</h2>
        {items.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <Package size={48} className="mx-auto mb-4 text-gray-300" />
            <p>No items created yet.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-semibold">NAME</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">CATEGORY</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">UOM</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">LOW STOCK</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">ACTIONS</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {items.map((item) => (
                  <tr key={item.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3">{item.name}</td>
                    <td className="px-4 py-3">
                      <span className="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs">
                        {item.category?.name || item.category_ref?.name || "N/A"}
                      </span>
                    </td>
                    <td className="px-4 py-3">{item.base_uom?.name || item.uom_ref?.name || "N/A"}</td>
                    <td className="px-4 py-3">{item.min_stock_level}</td>
                    <td className="px-4 py-3">
                      <div className="flex gap-2">
                        <button
                          onClick={() => handleEditItem(item)}
                          className="p-1 text-blue-600 hover:bg-blue-50 rounded"
                        >
                          <Edit size={16} />
                        </button>
                        <button
                          onClick={() => handleDeleteItem(item.id)}
                          className="p-1 text-red-600 hover:bg-red-50 rounded"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>


      <div className="bg-white rounded-xl shadow-md overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-3 text-left text-sm font-semibold">Name</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">Category</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">SKU</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">UOM</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">Selling Price</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {items.map((item) => (
                <tr key={item.id} className="hover:bg-gray-50">
                  <td className="px-4 py-3">{item.name}</td>
                  <td className="px-4 py-3">
                    <span className="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs">
                      {item.category?.name || item.category_ref?.name || "N/A"}
                    </span>
                  </td>
                  <td className="px-4 py-3">{item.sku || "-"}</td>
                  <td className="px-4 py-3">{item.base_uom?.name || item.uom_ref?.name || "N/A"}</td>
                  <td className="px-4 py-3">₹{item.selling_price}</td>
                  <td className="px-4 py-3">
                    <div className="flex gap-2">
                      <button
                        onClick={() => handleEditItem(item)}
                        className="p-1 text-blue-600 hover:bg-blue-50 rounded"
                      >
                        <Edit size={16} />
                      </button>
                      <button
                        onClick={() => handleDeleteItem(item.id)}
                        className="p-1 text-red-600 hover:bg-red-50 rounded"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Locations Section */}
      <div className="flex justify-between items-center mt-8">
        <h2 className="text-2xl font-bold text-gray-800">Locations</h2>
        <button
          onClick={() => setShowLocationForm(true)}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
        >
          <Plus size={18} />
          Add Location
        </button>
      </div>

      {showLocationForm && (
        <div className="bg-white p-6 rounded-xl shadow-md">
          <h3 className="text-lg font-semibold mb-4">Create Location</h3>
          <form onSubmit={handleCreateLocation} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Name *</label>
                <input
                  type="text"
                  value={locationForm.name}
                  onChange={(e) => setLocationForm({ ...locationForm, name: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Code</label>
                <input
                  type="text"
                  value={locationForm.code}
                  onChange={(e) => setLocationForm({ ...locationForm, code: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Location Type *</label>
                <select
                  value={locationForm.location_type}
                  onChange={(e) => setLocationForm({ ...locationForm, location_type: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                >
                  <option value="central_warehouse">Central Warehouse</option>
                  <option value="branch_store">Branch Store</option>
                  <option value="sub_store">Sub Store</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Parent Location</label>
                <select
                  value={locationForm.parent_location_id}
                  onChange={(e) => setLocationForm({ ...locationForm, parent_location_id: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                >
                  <option value="">None</option>
                  {locations.map(loc => (
                    <option key={loc.id} value={loc.id}>{loc.name}</option>
                  ))}
                </select>
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Description</label>
              <textarea
                value={locationForm.description}
                onChange={(e) => setLocationForm({ ...locationForm, description: e.target.value })}
                className="w-full px-3 py-2 border rounded-lg"
                rows="2"
              />
            </div>
            <div className="flex gap-2">
              <button type="submit" className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                Create
              </button>
              <button
                type="button"
                onClick={() => setShowLocationForm(false)}
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="bg-white rounded-xl shadow-md p-6">
        <h3 className="text-lg font-semibold mb-4">All Locations</h3>
        <div className="grid grid-cols-3 gap-4">
          {locations.map((loc) => (
            <div key={loc.id} className="p-4 border rounded-lg">
              <div className="font-medium">{loc.name}</div>
              <div className="text-sm text-gray-600">{loc.location_type}</div>
              {loc.code && <div className="text-sm text-gray-500">Code: {loc.code}</div>}
            </div>
          ))}
        </div>
      </div>

      {/* Stock Levels Section */}
      <div className="mt-8">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-2xl font-bold text-gray-800">Stock Levels</h2>
          <select
            value={selectedLocationForStock || ""}
            onChange={(e) => {
              setSelectedLocationForStock(e.target.value ? parseInt(e.target.value) : null);
              fetchStockLevels();
            }}
            className="px-3 py-2 border rounded-lg"
          >
            <option value="">All Locations</option>
            {locations.map(loc => (
              <option key={loc.id} value={loc.id}>{loc.name}</option>
            ))}
          </select>
        </div>
        <div className="bg-white rounded-xl shadow-md overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-semibold">Item</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">Location</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">Quantity</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">UOM</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {stockLevels.map((stock) => (
                  <tr key={stock.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3">{stock.item?.name || "Unknown"}</td>
                    <td className="px-4 py-3">{stock.location?.name || "Unknown"}</td>
                    <td className="px-4 py-3">{stock.quantity}</td>
                    <td className="px-4 py-3">{stock.uom}</td>
                    <td className="px-4 py-3">
                      {stock.item && stock.quantity <= stock.item.min_stock_level ? (
                        <span className="px-2 py-1 bg-red-100 text-red-800 rounded text-xs">Low Stock</span>
                      ) : (
                        <span className="px-2 py-1 bg-green-100 text-green-800 rounded text-xs">In Stock</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );

  const renderStockManagement = () => (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      {/* Left Panel - Current Stock Levels */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-bold text-gray-800">Current Stock Levels</h2>
          <button
            onClick={() => {
              // Open stock adjustment modal
              toast.info("Stock adjustment feature coming soon");
            }}
            className="flex items-center gap-2 px-3 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 text-sm"
          >
            <Wrench size={16} />
            Adjust Stock
          </button>
        </div>
        {stockLevels.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <ShoppingCart size={48} className="mx-auto mb-4 text-gray-300" />
            <p>No stock records found.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-semibold">ITEM</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">LOCATION</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">QUANTITY</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {stockLevels.map((stock) => (
                  <tr key={stock.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3">{stock.item?.name || "Unknown"}</td>
                    <td className="px-4 py-3">{stock.location?.name || "Unknown"}</td>
                    <td className="px-4 py-3">
                      <span className={`px-2 py-1 rounded text-xs ${
                        stock.item && stock.quantity <= stock.item.min_stock_level
                          ? "bg-red-100 text-red-800"
                          : "bg-green-100 text-green-800"
                      }`}>
                        {stock.quantity} {stock.uom}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Right Panel - Locations */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-bold text-gray-800">Locations</h2>
          <button
            onClick={() => setShowLocationForm(true)}
            className="flex items-center gap-2 px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm"
          >
            <MapPin size={16} />
            New
          </button>
        </div>
        {locations.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <MapPin size={48} className="mx-auto mb-4 text-gray-300" />
            <p>No locations created yet.</p>
          </div>
        ) : (
          <div className="space-y-2">
            {locations.map((loc) => (
              <div key={loc.id} className="p-3 border rounded-lg hover:bg-gray-50">
                <div className="font-medium">{loc.name}</div>
                <div className="text-sm text-gray-600">{loc.location_type}</div>
                {loc.code && <div className="text-xs text-gray-500">Code: {loc.code}</div>}
              </div>
            ))}
          </div>
        )}
      </div>

      {showLocationForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl shadow-lg p-6 max-w-md w-full mx-4">
            <h3 className="text-lg font-semibold mb-4">Create Location</h3>
            <form onSubmit={handleCreateLocation} className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-1">Name *</label>
                <input
                  type="text"
                  value={locationForm.name}
                  onChange={(e) => setLocationForm({ ...locationForm, name: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Code</label>
                <input
                  type="text"
                  value={locationForm.code}
                  onChange={(e) => setLocationForm({ ...locationForm, code: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Location Type *</label>
                <select
                  value={locationForm.location_type}
                  onChange={(e) => setLocationForm({ ...locationForm, location_type: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                >
                  <option value="central_warehouse">Central Warehouse</option>
                  <option value="branch_store">Branch Store</option>
                  <option value="sub_store">Sub Store</option>
                </select>
              </div>
              <div className="flex gap-2">
                <button type="submit" className="flex-1 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                  Create
                </button>
                <button
                  type="button"
                  onClick={() => setShowLocationForm(false)}
                  className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );

  const renderReports = () => (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-md p-6">
        <h2 className="text-xl font-bold text-gray-800 mb-4">Inventory Reports</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="p-4 border rounded-lg">
            <h3 className="font-semibold mb-2">Stock Summary</h3>
            <p className="text-sm text-gray-600">Total Items: {items.length}</p>
            <p className="text-sm text-gray-600">Total Locations: {locations.length}</p>
            <p className="text-sm text-gray-600">Total Stock Records: {stockLevels.length}</p>
          </div>
          <div className="p-4 border rounded-lg">
            <h3 className="font-semibold mb-2">Low Stock Items</h3>
            <p className="text-sm text-gray-600">
              {stockLevels.filter(s => s.item && s.quantity <= s.item.min_stock_level).length} items need restocking
            </p>
          </div>
          <div className="p-4 border rounded-lg">
            <h3 className="font-semibold mb-2">Pending Indents</h3>
            <p className="text-sm text-gray-600">
              {indents.filter(i => i.status === "pending").length} pending requests
            </p>
          </div>
          <div className="p-4 border rounded-lg">
            <h3 className="font-semibold mb-2">Category Distribution</h3>
            <div className="space-y-1 text-sm">
              <p className="text-gray-600">Consumables: {items.filter(i => {
                const catName = i.category?.name || i.category_ref?.name || "";
                return catName.toLowerCase().includes("consumable");
              }).length}</p>
              <p className="text-gray-600">Raw Materials: {items.filter(i => {
                const catName = i.category?.name || i.category_ref?.name || "";
                return catName.toLowerCase().includes("raw") || catName.toLowerCase().includes("material");
              }).length}</p>
              <p className="text-gray-600">Fixed Assets: {items.filter(i => {
                const catName = i.category?.name || i.category_ref?.name || "";
                return catName.toLowerCase().includes("asset");
              }).length}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  const renderRoomInventory = () => (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-md p-6">
        <h2 className="text-xl font-bold text-gray-800 mb-4">Room Inventory (Minibar & Assets)</h2>
        <p className="text-gray-600 mb-6">
          This module will be used by housekeeping to audit minibar consumption, which will trigger auto-billing and replenishment requests. It will also be used to track the condition of fixed assets in each room.
        </p>
        
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-semibold text-gray-800">Room Inventory Management</h3>
          <button
            onClick={() => setShowRoomInventorySetup(true)}
            className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
          >
            <Plus size={18} />
            Setup Room Inventory
          </button>
        </div>

      {showRoomInventorySetup && (
        <div className="bg-white p-6 rounded-xl shadow-md">
          <h3 className="text-lg font-semibold mb-4">Setup Room Inventory</h3>
          <form onSubmit={handleSetupRoomInventory} className="space-y-4">
            <div className="grid grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Room *</label>
                <select
                  value={roomInventorySetup.room_id}
                  onChange={(e) => setRoomInventorySetup({ ...roomInventorySetup, room_id: parseInt(e.target.value) })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                >
                  <option value="">Select Room</option>
                  {rooms.map(room => (
                    <option key={room.id} value={room.id}>Room {room.number}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Item *</label>
                <select
                  value={roomInventorySetup.item_id}
                  onChange={(e) => setRoomInventorySetup({ ...roomInventorySetup, item_id: parseInt(e.target.value) })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                >
                  <option value="">Select Item</option>
                  {items.filter(i => {
                    const catName = i.category?.name || i.category_ref?.name || "";
                    return catName.toLowerCase().includes("consumable");
                  }).map(item => (
                    <option key={item.id} value={item.id}>{item.name}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Par Stock *</label>
                <input
                  type="number"
                  step="0.01"
                  value={roomInventorySetup.par_stock}
                  onChange={(e) => setRoomInventorySetup({ ...roomInventorySetup, par_stock: parseFloat(e.target.value) || 0 })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                />
              </div>
            </div>
            <div className="flex gap-2">
              <button type="submit" className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                Add
              </button>
              <button
                type="button"
                onClick={() => setShowRoomInventorySetup(false)}
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}
      
      <div className="grid grid-cols-4 gap-4">
        {rooms.map((room) => (
          <div
            key={room.id}
            onClick={() => {
              setSelectedRoom(room.id);
              fetchRoomInventory(room.id);
            }}
            className={`p-4 rounded-lg border-2 cursor-pointer transition-all ${
              selectedRoom === room.id
                ? "border-indigo-600 bg-indigo-50"
                : "border-gray-200 hover:border-gray-300"
            }`}
          >
            <div className="font-semibold">Room {room.number}</div>
            <div className="text-sm text-gray-600">{room.type}</div>
          </div>
        ))}
      </div>

      {selectedRoom && roomInventory[selectedRoom] && (
        <div className="bg-white rounded-xl shadow-md p-6">
          <h3 className="text-lg font-semibold mb-4">
            Room {rooms.find(r => r.id === selectedRoom)?.number} - Minibar Items
          </h3>
          {roomInventory[selectedRoom].length === 0 ? (
            <p className="text-gray-500">No items configured for this room. Click "Setup Room Inventory" to add items.</p>
          ) : (
            <div className="space-y-4">
              {roomInventory[selectedRoom].map((item) => (
                <div key={item.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div>
                    <div className="font-medium">{item.item?.name || "Unknown"}</div>
                    <div className="text-sm text-gray-600">
                      Par Stock: {item.par_stock} | Current: {item.current_stock}
                    </div>
                  </div>
                  <div className="flex gap-2 items-center">
                    <input
                      type="number"
                      step="0.01"
                      placeholder="Found Qty"
                      className="w-24 px-3 py-2 border rounded-lg"
                      onBlur={(e) => {
                        const foundQty = parseFloat(e.target.value);
                        if (foundQty >= 0) {
                          handleRoomAudit(selectedRoom, item.id, foundQty);
                        }
                      }}
                    />
                    <button
                      onClick={() => {
                        const foundQty = parseFloat(prompt("Enter found quantity:", item.current_stock)) || 0;
                        if (foundQty >= 0) {
                          handleRoomAudit(selectedRoom, item.id, foundQty);
                        }
                      }}
                      className="px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm"
                    >
                      Audit
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );

  const renderAssets = () => (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold text-gray-800">Room Assets</h2>
        <button
          onClick={() => {
            setShowAssetForm(true);
            setAssetForm({
              room_id: selectedAssetRoom || "",
              item_id: "",
              asset_id: "",
              serial_number: "",
              purchase_date: "",
              purchase_price: 0
            });
          }}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
          disabled={!selectedAssetRoom}
        >
          <Plus size={18} />
          Add Asset
        </button>
      </div>

      <div className="grid grid-cols-4 gap-4">
        {rooms.map((room) => (
          <div
            key={room.id}
            onClick={() => {
              setSelectedAssetRoom(room.id);
              fetchRoomAssets(room.id);
            }}
            className={`p-4 rounded-lg border-2 cursor-pointer transition-all ${
              selectedAssetRoom === room.id
                ? "border-indigo-600 bg-indigo-50"
                : "border-gray-200 hover:border-gray-300"
            }`}
          >
            <div className="font-semibold">Room {room.number}</div>
            <div className="text-sm text-gray-600">{room.type}</div>
          </div>
        ))}
      </div>

      {showAssetForm && (
        <div className="bg-white p-6 rounded-xl shadow-md">
          <h3 className="text-lg font-semibold mb-4">Add Room Asset</h3>
          <form onSubmit={handleCreateAsset} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Room *</label>
                <select
                  value={assetForm.room_id}
                  onChange={(e) => setAssetForm({ ...assetForm, room_id: parseInt(e.target.value) })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                >
                  <option value="">Select Room</option>
                  {rooms.map(room => (
                    <option key={room.id} value={room.id}>Room {room.number}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Item *</label>
                <select
                  value={assetForm.item_id}
                  onChange={(e) => setAssetForm({ ...assetForm, item_id: parseInt(e.target.value) })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                >
                  <option value="">Select Item</option>
                  {items.filter(i => {
                    const catName = i.category?.name || i.category_ref?.name || "";
                    return catName.toLowerCase().includes("asset");
                  }).map(item => (
                    <option key={item.id} value={item.id}>{item.name}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Asset ID *</label>
                <input
                  type="text"
                  value={assetForm.asset_id}
                  onChange={(e) => setAssetForm({ ...assetForm, asset_id: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                  placeholder="e.g., TV-R101-Samsung"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Serial Number</label>
                <input
                  type="text"
                  value={assetForm.serial_number}
                  onChange={(e) => setAssetForm({ ...assetForm, serial_number: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Purchase Date</label>
                <input
                  type="date"
                  value={assetForm.purchase_date}
                  onChange={(e) => setAssetForm({ ...assetForm, purchase_date: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Purchase Price</label>
                <input
                  type="number"
                  step="0.01"
                  value={assetForm.purchase_price}
                  onChange={(e) => setAssetForm({ ...assetForm, purchase_price: parseFloat(e.target.value) || 0 })}
                  className="w-full px-3 py-2 border rounded-lg"
                />
              </div>
            </div>
            <div className="flex gap-2">
              <button type="submit" className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                Create
              </button>
              <button
                type="button"
                onClick={() => setShowAssetForm(false)}
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {selectedAssetRoom && (
        <div className="bg-white rounded-xl shadow-md p-6">
          <h3 className="text-lg font-semibold mb-4">
            Room {rooms.find(r => r.id === selectedAssetRoom)?.number} - Assets
          </h3>
          {roomAssets.length === 0 ? (
            <p className="text-gray-500">No assets registered for this room.</p>
          ) : (
            <div className="space-y-4">
              {roomAssets.map((asset) => (
                <div key={asset.id} className="p-4 border rounded-lg">
                  <div className="flex justify-between items-start">
                    <div>
                      <div className="font-medium">{asset.item?.name || "Unknown"}</div>
                      <div className="text-sm text-gray-600">Asset ID: {asset.asset_id}</div>
                      {asset.serial_number && (
                        <div className="text-sm text-gray-600">Serial: {asset.serial_number}</div>
                      )}
                      <div className="mt-2">
                        <span className={`px-2 py-1 rounded text-xs ${
                          asset.status === "good" ? "bg-green-100 text-green-800" :
                          asset.status === "damaged" ? "bg-red-100 text-red-800" :
                          "bg-yellow-100 text-yellow-800"
                        }`}>
                          {asset.status}
                        </span>
                      </div>
                    </div>
                    <button
                      onClick={() => {
                        setSelectedAsset(asset);
                        setInspectionForm({
                          status: asset.status,
                          damage_description: "",
                          charge_to_guest: false,
                          charge_amount: 0,
                          notes: ""
                        });
                        setShowInspectionForm(true);
                      }}
                      className="px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm"
                    >
                      Inspect
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {showInspectionForm && selectedAsset && (
        <div className="bg-white p-6 rounded-xl shadow-md">
          <h3 className="text-lg font-semibold mb-4">Inspect Asset: {selectedAsset.asset_id}</h3>
          <form onSubmit={handleInspectAsset} className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-1">Status *</label>
              <select
                value={inspectionForm.status}
                onChange={(e) => setInspectionForm({ ...inspectionForm, status: e.target.value })}
                className="w-full px-3 py-2 border rounded-lg"
                required
              >
                <option value="good">Good</option>
                <option value="damaged">Damaged</option>
                <option value="missing">Missing</option>
                <option value="maintenance">Maintenance</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Damage Description</label>
              <textarea
                value={inspectionForm.damage_description}
                onChange={(e) => setInspectionForm({ ...inspectionForm, damage_description: e.target.value })}
                className="w-full px-3 py-2 border rounded-lg"
                rows="3"
              />
            </div>
            <div className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={inspectionForm.charge_to_guest}
                onChange={(e) => setInspectionForm({ ...inspectionForm, charge_to_guest: e.target.checked })}
              />
              <label>Charge to Guest</label>
            </div>
            {inspectionForm.charge_to_guest && (
              <div>
                <label className="block text-sm font-medium mb-1">Charge Amount</label>
                <input
                  type="number"
                  step="0.01"
                  value={inspectionForm.charge_amount}
                  onChange={(e) => setInspectionForm({ ...inspectionForm, charge_amount: parseFloat(e.target.value) || 0 })}
                  className="w-full px-3 py-2 border rounded-lg"
                />
              </div>
            )}
            <div>
              <label className="block text-sm font-medium mb-1">Notes</label>
              <textarea
                value={inspectionForm.notes}
                onChange={(e) => setInspectionForm({ ...inspectionForm, notes: e.target.value })}
                className="w-full px-3 py-2 border rounded-lg"
                rows="2"
              />
            </div>
            <div className="flex gap-2">
              <button type="submit" className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                Log Inspection
              </button>
              <button
                type="button"
                onClick={() => {
                  setShowInspectionForm(false);
                  setSelectedAsset(null);
                }}
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );

  const renderKitchen = () => (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-md p-6">
        <h2 className="text-xl font-bold text-gray-800 mb-4">Kitchen & Recipe Management</h2>
        <p className="text-gray-600 mb-6">
          Manage kitchen raw materials, implement FIFO for expiry tracking, and define recipes. The system will automatically deduct ingredients from stock when a menu item is sold via the POS. Wastage tracking will also be handled here.
        </p>
        
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-semibold text-gray-800">Kitchen Operations</h3>
          <button
            onClick={() => {
              setShowRecipeForm(true);
              setRecipeForm({
                name: "",
                description: "",
                food_item_id: "",
                servings: 1,
                ingredients: []
              });
            }}
            className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
          >
            <Plus size={18} />
            Create Recipe
          </button>
        </div>

      {/* Kitchen Stock Selection */}
      <div className="bg-white p-4 rounded-xl shadow-md">
        <label className="block text-sm font-medium mb-2">Select Kitchen Location</label>
        <select
          value={selectedKitchenLocation || ""}
          onChange={(e) => {
            setSelectedKitchenLocation(parseInt(e.target.value));
            fetchKitchenStock();
          }}
          className="w-full max-w-md px-3 py-2 border rounded-lg"
        >
          <option value="">Select Location</option>
          {locations.filter(l => l.location_type === "sub_store" && l.name.toLowerCase().includes("kitchen")).map(loc => (
            <option key={loc.id} value={loc.id}>{loc.name}</option>
          ))}
        </select>
      </div>

      {selectedKitchenLocation && (
        <div className="bg-white rounded-xl shadow-md p-6">
          <h3 className="text-lg font-semibold mb-4">Kitchen Stock Levels</h3>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-semibold">Item</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">Quantity</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">UOM</th>
                  <th className="px-4 py-3 text-left text-sm font-semibold">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {kitchenStockLevels.map((stock) => (
                  <tr key={stock.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3">{stock.item?.name || "Unknown"}</td>
                    <td className="px-4 py-3">{stock.quantity}</td>
                    <td className="px-4 py-3">{stock.uom}</td>
                    <td className="px-4 py-3">
                      {stock.item && stock.quantity <= stock.item.min_stock_level ? (
                        <span className="px-2 py-1 bg-red-100 text-red-800 rounded text-xs">Low Stock</span>
                      ) : (
                        <span className="px-2 py-1 bg-green-100 text-green-800 rounded text-xs">In Stock</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {showRecipeForm && (
        <div className="bg-white p-6 rounded-xl shadow-md">
          <h3 className="text-lg font-semibold mb-4">Create Recipe</h3>
          <form onSubmit={handleCreateRecipe} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Recipe Name *</label>
                <input
                  type="text"
                  value={recipeForm.name}
                  onChange={(e) => setRecipeForm({ ...recipeForm, name: e.target.value })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Menu Item (Optional)</label>
                <select
                  value={recipeForm.food_item_id}
                  onChange={(e) => setRecipeForm({ ...recipeForm, food_item_id: e.target.value ? parseInt(e.target.value) : "" })}
                  className="w-full px-3 py-2 border rounded-lg"
                >
                  <option value="">None</option>
                  {foodItems.map(item => (
                    <option key={item.id} value={item.id}>{item.name}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Servings *</label>
                <input
                  type="number"
                  value={recipeForm.servings}
                  onChange={(e) => setRecipeForm({ ...recipeForm, servings: parseInt(e.target.value) || 1 })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                />
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Description</label>
              <textarea
                value={recipeForm.description}
                onChange={(e) => setRecipeForm({ ...recipeForm, description: e.target.value })}
                className="w-full px-3 py-2 border rounded-lg"
                rows="2"
              />
            </div>

            <div className="border-t pt-4">
              <h4 className="font-medium mb-3">Ingredients</h4>
              <div className="grid grid-cols-4 gap-2 mb-2">
                <select
                  value={newIngredient.item_id}
                  onChange={(e) => setNewIngredient({ ...newIngredient, item_id: parseInt(e.target.value) || "" })}
                  className="px-3 py-2 border rounded-lg"
                >
                  <option value="">Select Item</option>
                  {items.filter(i => {
                    const catName = i.category?.name || i.category_ref?.name || "";
                    return catName.toLowerCase().includes("raw") || catName.toLowerCase().includes("material");
                  }).map(item => (
                    <option key={item.id} value={item.id}>{item.name}</option>
                  ))}
                </select>
                <input
                  type="number"
                  step="0.01"
                  placeholder="Quantity"
                  value={newIngredient.quantity}
                  onChange={(e) => setNewIngredient({ ...newIngredient, quantity: parseFloat(e.target.value) || 0 })}
                  className="px-3 py-2 border rounded-lg"
                />
                <select
                  value={newIngredient.uom}
                  onChange={(e) => setNewIngredient({ ...newIngredient, uom: e.target.value })}
                  className="px-3 py-2 border rounded-lg"
                >
                  <option value="g">g</option>
                  <option value="kg">kg</option>
                  <option value="ml">ml</option>
                  <option value="liters">liters</option>
                  <option value="pieces">pieces</option>
                </select>
                <button
                  type="button"
                  onClick={handleAddIngredient}
                  className="px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700"
                >
                  Add
                </button>
              </div>
              <div className="space-y-2">
                {recipeForm.ingredients.map((ing, index) => {
                  const item = items.find(i => i.id === ing.item_id);
                  return (
                    <div key={index} className="flex items-center justify-between p-2 bg-gray-50 rounded">
                      <span>{item?.name || "Unknown"} - {ing.quantity} {ing.uom}</span>
                      <button
                        type="button"
                        onClick={() => handleRemoveIngredient(index)}
                        className="text-red-600 hover:text-red-800"
                      >
                        <X size={16} />
                      </button>
                    </div>
                  );
                })}
              </div>
            </div>

            <div className="flex gap-2">
              <button type="submit" className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                Create Recipe
              </button>
              <button
                type="button"
                onClick={() => setShowRecipeForm(false)}
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="bg-white rounded-xl shadow-md p-6">
        <h3 className="text-lg font-semibold mb-4">Recipes</h3>
        <div className="space-y-4">
          {recipes.map((recipe) => (
            <div key={recipe.id} className="p-4 border rounded-lg">
              <div className="flex justify-between items-start">
                <div>
                  <div className="font-medium">{recipe.name}</div>
                  {recipe.food_item && (
                    <div className="text-sm text-gray-600">Menu Item: {recipe.food_item.name}</div>
                  )}
                  <div className="text-sm text-gray-600">Servings: {recipe.servings}</div>
                  {recipe.description && (
                    <div className="text-sm text-gray-500 mt-1">{recipe.description}</div>
                  )}
                </div>
                <div className="flex gap-2">
                  <input
                    type="number"
                    min="1"
                    placeholder="Qty"
                    className="w-20 px-2 py-1 border rounded-lg"
                    defaultValue={1}
                    id={`recipe-qty-${recipe.id}`}
                  />
                  <button
                    onClick={() => {
                      const qty = parseInt(document.getElementById(`recipe-qty-${recipe.id}`).value) || 1;
                      handleConsumeRecipe(recipe.id, qty);
                    }}
                    className="px-3 py-1 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm"
                    disabled={!selectedKitchenLocation}
                  >
                    Consume
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );

  const renderIndents = () => (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-md p-6">
        <h2 className="text-xl font-bold text-gray-800 mb-4">Store Room & Indenting</h2>
        <p className="text-gray-600 mb-6">
          This section is for managing internal stock requests (indents) from various departments like the kitchen or housekeeping. It will also track maintenance inventory and tools, including a check-in/check-out system for staff.
        </p>
        
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-semibold text-gray-800">Indent Management</h3>
          <button
            onClick={() => {
              setShowIndentForm(true);
              setIndentForm({
                requested_from_location_id: "",
                requested_to_location_id: "",
                items: [],
                notes: ""
              });
            }}
            className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
          >
            <Plus size={18} />
            Create Indent
          </button>
        </div>

      {showIndentForm && (
        <div className="bg-white p-6 rounded-xl shadow-md">
          <h3 className="text-lg font-semibold mb-4">Create Indent</h3>
          <form onSubmit={handleCreateIndent} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Requesting From *</label>
                <select
                  value={indentForm.requested_from_location_id}
                  onChange={(e) => setIndentForm({ ...indentForm, requested_from_location_id: parseInt(e.target.value) })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                >
                  <option value="">Select Location</option>
                  {locations.map(loc => (
                    <option key={loc.id} value={loc.id}>{loc.name}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Requesting To (Store) *</label>
                <select
                  value={indentForm.requested_to_location_id}
                  onChange={(e) => setIndentForm({ ...indentForm, requested_to_location_id: parseInt(e.target.value) })}
                  className="w-full px-3 py-2 border rounded-lg"
                  required
                >
                  <option value="">Select Store</option>
                  {locations.filter(l => l.location_type === "branch_store" || l.location_type === "central_warehouse").map(loc => (
                    <option key={loc.id} value={loc.id}>{loc.name}</option>
                  ))}
                </select>
              </div>
            </div>

            <div className="border-t pt-4">
              <h4 className="font-medium mb-3">Items</h4>
              <div className="grid grid-cols-4 gap-2 mb-2">
                <select
                  value={newIndentItem.item_id}
                  onChange={(e) => setNewIndentItem({ ...newIndentItem, item_id: parseInt(e.target.value) || "" })}
                  className="px-3 py-2 border rounded-lg"
                >
                  <option value="">Select Item</option>
                  {items.map(item => (
                    <option key={item.id} value={item.id}>{item.name}</option>
                  ))}
                </select>
                <input
                  type="number"
                  step="0.01"
                  placeholder="Quantity"
                  value={newIndentItem.quantity}
                  onChange={(e) => setNewIndentItem({ ...newIndentItem, quantity: parseFloat(e.target.value) || 0 })}
                  className="px-3 py-2 border rounded-lg"
                />
                <select
                  value={newIndentItem.uom}
                  onChange={(e) => setNewIndentItem({ ...newIndentItem, uom: e.target.value })}
                  className="px-3 py-2 border rounded-lg"
                >
                  <option value="pieces">pieces</option>
                  <option value="kg">kg</option>
                  <option value="g">g</option>
                  <option value="liters">liters</option>
                  <option value="ml">ml</option>
                </select>
                <button
                  type="button"
                  onClick={handleAddIndentItem}
                  className="px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700"
                >
                  Add
                </button>
              </div>
              <div className="space-y-2">
                {indentForm.items.map((item, index) => {
                  const itemData = items.find(i => i.id === item.item_id);
                  return (
                    <div key={index} className="flex items-center justify-between p-2 bg-gray-50 rounded">
                      <span>{itemData?.name || "Unknown"} - {item.quantity} {item.uom}</span>
                      <button
                        type="button"
                        onClick={() => handleRemoveIndentItem(index)}
                        className="text-red-600 hover:text-red-800"
                      >
                        <X size={16} />
                      </button>
                    </div>
                  );
                })}
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium mb-1">Notes</label>
              <textarea
                value={indentForm.notes}
                onChange={(e) => setIndentForm({ ...indentForm, notes: e.target.value })}
                className="w-full px-3 py-2 border rounded-lg"
                rows="2"
              />
            </div>

            <div className="flex gap-2">
              <button type="submit" className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                Create Indent
              </button>
              <button
                type="button"
                onClick={() => setShowIndentForm(false)}
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="bg-white rounded-xl shadow-md p-6">
        <h3 className="text-lg font-semibold mb-4">All Indents</h3>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-3 text-left text-sm font-semibold">Indent Number</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">From</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">To</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">Status</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">Date</th>
                <th className="px-4 py-3 text-left text-sm font-semibold">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {indents.map((indent) => {
                const fromLoc = locations.find(l => l.id === indent.requested_from_location_id);
                const toLoc = locations.find(l => l.id === indent.requested_to_location_id);
                return (
                  <tr key={indent.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3">{indent.indent_number}</td>
                    <td className="px-4 py-3">{fromLoc?.name || "-"}</td>
                    <td className="px-4 py-3">{toLoc?.name || "-"}</td>
                    <td className="px-4 py-3">
                      <span className={`px-2 py-1 rounded text-xs ${
                        indent.status === "pending" ? "bg-yellow-100 text-yellow-800" :
                        indent.status === "approved" ? "bg-blue-100 text-blue-800" :
                        indent.status === "fulfilled" ? "bg-green-100 text-green-800" :
                        "bg-red-100 text-red-800"
                      }`}>
                        {indent.status}
                      </span>
                    </td>
                    <td className="px-4 py-3">
                      {new Date(indent.requested_date).toLocaleDateString()}
                    </td>
                    <td className="px-4 py-3">
                      {indent.status === "pending" && (
                        <button
                          onClick={() => handleApproveIndent(indent.id)}
                          className="px-3 py-1 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm"
                        >
                          Approve
                        </button>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <h1 className="text-3xl font-bold text-gray-800">Inventory Management</h1>

        {/* Dashboard Stats */}
        <div className="grid grid-cols-4 gap-4">
          <div className="bg-white p-6 rounded-xl shadow-md">
            <div className="text-sm text-gray-600">Total Items</div>
            <div className="text-2xl font-bold text-indigo-600">{dashboardStats.total_items}</div>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-md">
            <div className="text-sm text-gray-600">Low Stock Items</div>
            <div className="text-2xl font-bold text-red-600">{dashboardStats.low_stock_items}</div>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-md">
            <div className="text-sm text-gray-600">Pending Indents</div>
            <div className="text-2xl font-bold text-yellow-600">{dashboardStats.pending_indents}</div>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-md">
            <div className="text-sm text-gray-600">Total Stock Value</div>
            <div className="text-2xl font-bold text-green-600">₹{dashboardStats.total_stock_value.toFixed(2)}</div>
          </div>
        </div>

        {/* Tabs */}
        <div className="bg-white p-4 rounded-xl shadow-md">
          <div className="flex flex-wrap gap-2 border-b mb-4 pb-2">
            <TabButton id="purchase" label="Purchase" icon={<ShoppingCart size={18} />} />
            <TabButton id="master-items" label="Master Items" icon={<List size={18} />} />
            <TabButton id="view-all" label="View All" icon={<Database size={18} />} title="View All Items, Categories, and UOMs" />
            <TabButton id="stock-adjustment" label="Stock Adjustment" icon={<TrendingDown size={18} />} />
            <TabButton id="movement-history" label="Movement History" icon={<BarChart3 size={18} />} />
            <TabButton id="restock-alerts" label="Restock Alerts" icon={<AlertTriangle size={18} />} />
            <TabButton id="eod-audit" label="EOD Audit" icon={<FileText size={18} />} />
            <TabButton id="office-requisition" label="Office Requisition" icon={<Wrench size={18} />} />
            <TabButton id="linen-laundry" label="Linen & Laundry" icon={<Package size={18} />} />
            <TabButton id="fire-safety" label="Fire & Safety" icon={<AlertTriangle size={18} />} />
            <TabButton id="security-equipment" label="Security Equipment" icon={<Package size={18} />} />
            <TabButton id="gst-reports" label="GST Reports" icon={<ReportIcon size={18} />} />
            <TabButton id="asset-lifecycle" label="Asset Lifecycle" icon={<TrendingUp size={18} />} />
          </div>

          <div className="p-4">
            {activeTab === "purchase" && renderStockManagement()}
            {activeTab === "master-items" && renderMasterInventory()}
            {activeTab === "view-all" && renderViewAll()}
            {activeTab === "stock-adjustment" && renderStockManagement()}
            {activeTab === "movement-history" && renderDashboard()}
            {activeTab === "restock-alerts" && renderDashboard()}
            {activeTab === "eod-audit" && renderDashboard()}
            {activeTab === "office-requisition" && renderIndents()}
            {activeTab === "linen-laundry" && renderDashboard()}
            {activeTab === "fire-safety" && renderDashboard()}
            {activeTab === "security-equipment" && renderDashboard()}
            {activeTab === "gst-reports" && renderReports()}
            {activeTab === "asset-lifecycle" && renderDashboard()}
            {activeTab === "dashboard" && renderDashboard()}
            {activeTab === "stock-management" && renderStockManagement()}
            {activeTab === "room-inventory" && renderRoomInventory()}
            {activeTab === "kitchen" && renderKitchen()}
            {activeTab === "store-room" && renderIndents()}
            {activeTab === "reports" && renderReports()}
          </div>
        </div>
      </div>
    </DashboardLayout>
  );
};

export default Inventory;


