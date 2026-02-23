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
  if (isLocalhost()) {
    return false;
  }
  const hostname = window.location.hostname;
  // pommaholidays.com domain OR numeric IP address (testing)
  return hostname === "pommaholidays.com" ||
    hostname === "www.pommaholidays.com" ||
    hostname === "teqmates.com" ||
    hostname === "www.teqmates.com" ||
    /^\d+\.\d+\.\d+\.\d+$/.test(hostname);
};

export const getMediaBaseUrl = () => {
  if (process.env.REACT_APP_MEDIA_BASE_URL) {
    return process.env.REACT_APP_MEDIA_BASE_URL;
  }
  if (typeof window !== "undefined" && isPommaDeployment()) {
    return `${window.location.origin}`;
  }
  if (isLocalhost()) {
    return "http://localhost:8000";
  }
  return "https://pommaholidays.com";
};

export const getApiBaseUrl = () => {
  if (process.env.REACT_APP_API_BASE_URL) {
    return process.env.REACT_APP_API_BASE_URL;
  }
  if (isLocalhost()) {
    return "http://localhost:8000/api";
  }
  if (typeof window !== "undefined" && isPommaDeployment()) {
    return `${window.location.origin}/api`;
  }
  return "https://pommaholidays.com/api";
};
