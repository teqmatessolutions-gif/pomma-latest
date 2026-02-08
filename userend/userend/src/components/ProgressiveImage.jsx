import React, { useState, useMemo } from 'react';
import { Image as ImageIcon } from 'lucide-react';

/* 
  ProgressiveImage Component
  --------------------------
  1. Renders the main image immediately but hides it (opacity: 0).
  2. Uses native onLoad/onError events from the DOM element.
  3. Shows thumbnail/placeholder while main image renders.
  4. Best for browser compatibility and caching.
*/
const ProgressiveImage = ({ src, alt, className = "", placeholderSrc = null, style = {} }) => {
    const [status, setStatus] = useState('loading'); // 'loading', 'loaded', 'error'

    // Derive thumbnail URL if not explicitly provided
    const thumbUrl = useMemo(() => {
        if (placeholderSrc) return placeholderSrc;
        if (!src) return null;
        if (src.includes("_thumb")) return src;

        try {
            const lastDotIndex = src.lastIndexOf('.');
            if (lastDotIndex === -1) return src;
            const basePath = src.substring(0, lastDotIndex);

            // Allow both jpg and webp thumbnails based on what the backend likely generated
            // For now, defaulting to .jpg as per previous working logic
            return `${basePath}_thumb.jpg?v=hq`;
        } catch (e) {
            return src;
        }
    }, [src, placeholderSrc]);

    const handleLoad = () => {
        setStatus('loaded');
    };

    const handleError = (e) => {
        // Only set error if we are not already loaded (prevents race conditions)
        if (status !== 'loaded') {
            console.warn("Image validation failed:", src);
            setStatus('error');
        }
    };

    // If src is missing, show error placeholder immediately
    if (!src) {
        return (
            <div className={`flex items-center justify-center bg-neutral-100 dark:bg-neutral-800 ${className}`} style={style}>
                <ImageIcon className="w-8 h-8 text-neutral-300 dark:text-neutral-600" />
            </div>
        );
    }

    const isLoaded = status === 'loaded';
    const isError = status === 'error';

    return (
        <div className={`relative overflow-hidden ${className}`} style={style}>
            {/* Thumbnail - Visible only while loading */}
            {thumbUrl && !isLoaded && !isError && (
                <img
                    src={thumbUrl}
                    alt={alt || "Thumbnail"}
                    className="absolute inset-0 w-full h-full object-cover blur-sm scale-110"
                    style={{ transition: "opacity 0.5s ease-out" }}
                />
            )}

            {/* Main Image - Always in DOM to ensure browser prioritizes it */}
            {!isError && (
                <img
                    src={src}
                    alt={alt}
                    className={`w-full h-full object-cover transition-opacity duration-500 ease-in-out ${isLoaded ? 'opacity-100' : 'opacity-0'}`}
                    style={{ position: isLoaded ? 'relative' : 'absolute', top: 0, left: 0 }}
                    onLoad={handleLoad}
                    onError={handleError}
                />
            )}

            {/* Error Placeholder - Only shows on actual error */}
            {isError && (
                <div className="absolute inset-0 flex items-center justify-center bg-neutral-100 dark:bg-neutral-800">
                    <ImageIcon className="w-8 h-8 text-neutral-300 dark:text-neutral-600" />
                </div>
            )}
        </div>
    );
};

export default ProgressiveImage;
