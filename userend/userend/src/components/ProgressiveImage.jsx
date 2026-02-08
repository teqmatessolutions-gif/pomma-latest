import React, { useState, useEffect } from 'react';
import { Image as ImageIcon } from 'lucide-react';

/* 
  ProgressiveImage Component
  --------------------------
  1. Loads a small thumbnail first (blur effect).
  2. Loads the full resolution image in the background.
  3. Swaps them once the full image is ready.
  4. Handles errors by showing a fallback placeholder.
*/
const ProgressiveImage = ({ src, alt, className = "", placeholderSrc = null, style = {} }) => {
    const [isLoaded, setIsLoaded] = useState(false);
    const [isError, setIsError] = useState(false);

    // Derive thumbnail URL if not explicitly provided
    const thumbUrl = React.useMemo(() => {
        if (placeholderSrc) return placeholderSrc;
        if (!src) return null;
        if (src.includes("_thumb")) return src;

        try {
            const lastDotIndex = src.lastIndexOf('.');
            if (lastDotIndex === -1) return src;
            const basePath = src.substring(0, lastDotIndex);
            return `${basePath}_thumb.jpg?v=hq`;
        } catch (e) {
            return src;
        }
    }, [src, placeholderSrc]);

    // Reset state when src changes
    useEffect(() => {
        setIsLoaded(false);
        setIsError(false);
    }, [src]);

    if (!src) {
        return (
            <div className={`flex items-center justify-center bg-neutral-100 dark:bg-neutral-800 ${className}`} style={style}>
                <ImageIcon className="w-8 h-8 text-neutral-300 dark:text-neutral-600" />
            </div>
        );
    }

    return (
        <div className={`relative overflow-hidden ${className}`} style={style}>
            {/* Thumbnail - Always show if full image not loaded */}
            {thumbUrl && !isLoaded && (
                <img
                    src={thumbUrl}
                    alt={alt || "Thumbnail"}
                    className="absolute inset-0 w-full h-full object-cover"
                    style={{ transition: "opacity 0.5s ease-out" }}
                />
            )}

            {/* Full Image - Hidden until loaded via opacity */}
            <img
                src={src}
                alt={alt}
                className={`w-full h-full object-cover transition-opacity duration-500 ease-in-out ${isLoaded ? 'opacity-100' : 'opacity-0'}`}
                style={{ position: isLoaded ? 'relative' : 'absolute', top: 0, left: 0 }}
                onLoad={() => setIsLoaded(true)}
                onError={() => setIsError(true)}
            />

            {/* Error Placeholder if both failed (simplified) */}
            {isError && !isLoaded && (
                <div className="absolute inset-0 flex items-center justify-center bg-neutral-100 dark:bg-neutral-800">
                    <ImageIcon className="w-8 h-8 text-neutral-300 dark:text-neutral-600" />
                </div>
            )}
        </div>
    );
};

export default ProgressiveImage;
