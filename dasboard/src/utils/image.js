import { getMediaBaseUrl } from './env';

/**
 * Generates a full URL for an image path, optionally using a thumbnail.
 * @param {string} imageUrl - The relative or absolute path to the image.
 * @param {boolean} [thumbnail=false] - Whether to request the thumbnail version.
 * @returns {string} The full URL to the image.
 */
export const getImageUrl = (imageUrl, thumbnail = false) => {
    if (!imageUrl) return 'https://placehold.co/400x300/e2e8f0/a0aec0?text=No+Image';
    if (imageUrl.startsWith('http')) return imageUrl;

    let path = imageUrl.replace(/\\/g, '/');

    // Normalize: remove leading slash for consistency when joining with baseUrl
    if (path.startsWith('/')) {
        path = path.substring(1);
    }

    // Normalize legacy paths
    if (path.startsWith('static/uploads/')) {
        path = path.replace('static/uploads/', 'uploads/');
    }

    // Handle thumbnail
    if (thumbnail) {
        if (path.toLowerCase().match(/\.(jpg|jpeg|png)$/)) {
            const parts = path.split('.');
            const ext = parts.pop();
            const base = parts.join('.');
            path = `${base}_thumb.jpg`;
        }
    }

    const baseUrl = getMediaBaseUrl();
    const baseUrlWithSlash = baseUrl.endsWith('/') ? baseUrl : baseUrl + '/';

    return `${baseUrlWithSlash}${encodeURI(path)}`;
};
