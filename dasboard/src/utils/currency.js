/**
 * Format amount with Indian Rupee symbol and comma separators
 * @param {number|string} amount - The amount to format
 * @param {boolean} showSymbol - Whether to show ₹ symbol (default: true)
 * @param {number} decimals - Number of decimal places (default: 2)
 * @returns {string} Formatted amount string like "₹10,000.00" or "1,000.00"
 */
export const formatCurrency = (amount, showSymbol = true, decimals = 2) => {
  // Convert to number if it's a string
  const numAmount = typeof amount === 'string' ? parseFloat(amount) || 0 : amount || 0;

  // Format with Indian numbering system (comma separators)
  const formatted = new Intl.NumberFormat('en-IN', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  }).format(numAmount);

  // Add Rupee symbol if requested
  return showSymbol ? `₹${formatted}` : formatted;
};

/**
 * Format amount without currency symbol (just comma separators)
 * @param {number|string} amount - The amount to format
 * @param {number} decimals - Number of decimal places (default: 2)
 * @returns {string} Formatted amount string like "10,000.00"
 */
export const formatAmount = (amount, decimals = 2) => {
  return formatCurrency(amount, false, decimals);
};


/**
 * Format large numbers with Indian suffixes (k, L, Cr)
 * @param {number|string} amount - The amount to format
 * @param {boolean} showSymbol - Whether to show ₹ symbol (default: false)
 * @param {number} decimals - Number of decimal places (default: 1)
 * @returns {string} Formatted string like "1.5k", "10L", "1.2Cr"
 */
export const formatCompactNumber = (amount, showSymbol = false, decimals = 1) => {
  const num = typeof amount === 'string' ? parseFloat(amount) || 0 : amount || 0;

  if (num === 0) return showSymbol ? "₹0" : "0";

  let val = num;
  let suffix = "";

  if (Math.abs(num) >= 10000000) { // 1 Crore
    val = num / 10000000;
    suffix = "Cr";
  } else if (Math.abs(num) >= 100000) { // 1 Lakh
    val = num / 100000;
    suffix = "L";
  } else if (Math.abs(num) >= 1000) { // 1 Thousand
    val = num / 1000;
    suffix = "k";
  }

  // Format the number with reduced decimals
  const formattedNum = new Intl.NumberFormat('en-IN', {
    minimumFractionDigits: 0,
    maximumFractionDigits: decimals,
  }).format(val);

  const result = `${formattedNum}${suffix}`;
  return showSymbol ? `₹${result}` : result;
};
