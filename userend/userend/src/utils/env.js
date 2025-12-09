export const isLocalhost = () => {
  if (typeof window === "undefined") {
    return process.env.NODE_ENV !== "production";
  }
  const hostname = window.location.hostname;
  return hostname === "localhost" || 
         hostname === "127.0.0.1" || 
         hostname === "" ||
         hostname.startsWith("192.168.") ||
         hostname.startsWith("10.") ||
         hostname === "::1";
};

export const isPommaDeployment = () => {
  if (typeof window === "undefined") {
    return false;
  }
  // In localhost, not a Pomma deployment path-wise
  if (isLocalhost()) {
    return false;
  }
  const path = window.location.pathname || "";
  return path.startsWith("/pommaholidays") || path.startsWith("/pomma");
};

export const getMediaBaseUrl = () => {
  // Explicit env override
  if (process.env.REACT_APP_MEDIA_BASE_URL) {
    return process.env.REACT_APP_MEDIA_BASE_URL;
  }
  
  // For Pomma deployment in production
  if (typeof window !== "undefined" && isPommaDeployment()) {
    return `${window.location.origin}/pomma`;
  }
  
  // Default for development
  if (isLocalhost()) {
    return "http://localhost:8010";
  }
  
  // Default for production
  return "https://www.teqmates.com";
};

export const getApiBaseUrl = () => {
  // Prefer explicit env override
  if (process.env.REACT_APP_API_BASE_URL) {
    return process.env.REACT_APP_API_BASE_URL;
  }
  
  // For local development, always use localhost
  if (isLocalhost()) {
    return "http://localhost:8010/api";
  }
  
  // For Pomma deployment in production
  if (typeof window !== "undefined" && isPommaDeployment()) {
    return `${window.location.origin}/pommaapi/api`;
  }
  
  // Default for production
  return "https://www.teqmates.com/pommaapi/api";
};
