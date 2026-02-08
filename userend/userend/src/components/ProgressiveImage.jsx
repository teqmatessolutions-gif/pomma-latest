import React, { useState, useEffect, useRef } from 'react';
import { Image as ImageIcon } from 'lucide-react';

/* 
  ProgressiveImage Component
  --------------------------
  1. Loads a small thumbnail first.
  2. Loads the full resolution image in the background.
  3. Swaps them once the full image is ready.
  4. Handles errors by showing a fallback placeholder.
  5. Uses useRef to check for cached images that might miss the onLoad event.
*/
const ProgressiveImage = ({ src, alt, className = "", placeholderSrc = null, style = {} }) => {
    const [isLoaded, setIsLoaded] = useState(false);
    const [isError, setIsError] = useState(false);
    const imgRef = useRef(null);

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

        // Safety check for cached images
        // If the image is already loaded from cache, onLoad might not fire in some browsers
        // so we check the `complete` property.
        if (imgRef.current && imgRef.current.complete && imgRef.current.naturalWidth > 0) {
            setIsLoaded(true);
        }
    }, [src]);

    // Additional safety check on mount and update
    useEffect(() => {
        const timer = setTimeout(() => {
            if (imgRef.current && imgRef.current.complete && imgRef.current.naturalWidth > 0) {
                setIsLoaded(true);
            }
        }, 100);
        return () => clearTimeout(timer);
    }, [src]);

    const handleLoad = () => {
        setIsLoaded(true);
    };

    const handleError = () => {
        setIsError(true);
    };

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
            {thumbUrl && !isLoaded && !isError && (
                <img
                    src={thumbUrl}
                    alt={alt || "Thumbnail"}
                    className="absolute inset-0 w-full h-full object-cover"
                    style={{ transition: "opacity 0.5s ease-out" }}
                />
            )}

            {/* Full Image - Hidden until loaded via opacity */}
            <img
                ref={imgRef}
                src={src}
                alt={alt}
                className={`w-full h-full object-cover transition-opacity duration-500 ease-in-out ${isLoaded ? 'opacity-100' : 'opacity-0'}`}
                style={{ position: isLoaded ? 'relative' : 'absolute', top: 0, left: 0 }}
                onLoad={handleLoad}
                onError={handleError}
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
