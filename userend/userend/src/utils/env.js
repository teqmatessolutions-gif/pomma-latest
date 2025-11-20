export const isResortDeployment = () => {
  if (typeof window === "undefined") {
    return false;
  }
  const path = window.location.pathname || "";
  return path.startsWith("/resort") || path.startsWith("/resortadmin");
};

export const getMediaBaseUrl = () => {
  if (typeof window !== "undefined" && isResortDeployment()) {
    return `${window.location.origin}/resortfiles`;
  }
  if (process.env.REACT_APP_MEDIA_BASE_URL) {
    return process.env.REACT_APP_MEDIA_BASE_URL;
  }
  return process.env.NODE_ENV === "production"
    ? "https://www.teqmates.com"
    : "http://localhost:8012";
};

export const getApiBaseUrl = () => {
  // For local development, always use localhost:8012
  if (process.env.NODE_ENV !== "production") {
    return "http://localhost:8012/api";
  }
  
  if (typeof window !== "undefined" && isResortDeployment()) {
    return `${window.location.origin}/resoapi/api`;
  }
  if (process.env.REACT_APP_API_BASE_URL) {
    return process.env.REACT_APP_API_BASE_URL;
  }
  return "https://www.teqmates.com/resoapi/api";
};
