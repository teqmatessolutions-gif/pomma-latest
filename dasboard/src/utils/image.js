import { getMediaBaseUrl } from './env';

/**
 * Generates a full URL for an image path, optionally using a thumbnail.
 * @param {string} imageUrl - The relative or absolute path to the image.
 * @param {boolean} [thumbnail=false] - Whether to request the thumbnail version.
 * @returns {string} The full URL to the image.
 */
export const getImageUrl = (imageUrl, thumbnail = false) => {
    if (!imageUrl) return 'https://placehold.co/400x300/e2e8f0/a0aec0?text=No+Image';
    if (imageUrl.startsWith('http')) return imageUrl; // Already a full URL

    let path = imageUrl;

    // If thumbnail requested and it's an image file
    if (thumbnail) {
        if (path.toLowerCase().match(/\.(jpg|jpeg|png)$/)) {
            const parts = path.split('.');
            const ext = parts.pop();
            const base = parts.join('.');
            path = `${base}_thumb.jpg`;
        }
    }

    const baseUrl = getMediaBaseUrl();
    const normalized = path.startsWith('/') ? path : `/${path}`;
    try {
        const urlObj = new URL(normalized, baseUrl);
        return urlObj.href;
    } catch (e) {
        console.error("URL generation error:", e);
        return `${baseUrl}${encodeURI(normalized)}`; // Fallback
    }
};
