import React, { useState, useEffect } from 'react';
import { Image as ImageIcon } from 'lucide-react';

/* 
  ProgressiveImage Component
  --------------------------
  1. Loads a small thumbnail first.
  2. Uses a detached Image object to preload the full resolution image.
  3. Sets state once the preloader confirms success or failure.
  4. This avoids DOM-related race conditions on mobile devices.
*/
const ProgressiveImage = ({ src, alt, className = "", placeholderSrc = null, style = {} }) => {
    const [loadingState, setLoadingState] = useState('loading'); // 'loading', 'loaded', 'error'

    // Derive thumbnail URL if not explicitly provided
    const thumbUrl = React.useMemo(() => {
        if (placeholderSrc) return placeholderSrc;
        if (!src) return null;
        if (src.includes("_thumb")) return src;

        try {
            const lastDotIndex = src.lastIndexOf('.');
            if (lastDotIndex === -1) return src;
            const basePath = src.substring(0, lastDotIndex);

            // If main image is webp, try webp thumbnail first if logic allows, 
            // but for now we stick to the backend generation logic which uses .jpg or .webp
            // The python script generates _thumb.jpg even for webp inputs usually, 
            // unless updated otherwise. Let's assume _thumb.jpg is the safe default for now 
            // or match the extension if the backend does. 
            // Previous logic forced .jpg. Let's keep it consistent with previous successful iterations
            // but allow flexibility if needed.
            return `${basePath}_thumb.jpg?v=hq`;
        } catch (e) {
            return src;
        }
    }, [src, placeholderSrc]);

    useEffect(() => {
        if (!src) {
            setLoadingState('error');
            return;
        }

        setLoadingState('loading');

        // Create detached image for preloading
        const img = new Image();
        img.src = src;

        const handleLoad = () => {
            setLoadingState('loaded');
        };

        const handleError = () => {
            // If manual load fails, we verify if the file actually exists by 
            // letting the error state persist.
            setLoadingState('error');
        };

        img.onload = handleLoad;
        img.onerror = handleError;

        // Check if already complete (cached)
        if (img.complete) {
            if (img.naturalWidth > 0) {
                handleLoad();
            } else {
                handleError(); // Complete but broken
            }
        }

        return () => {
            img.onload = null;
            img.onerror = null;
        };
    }, [src]);

    if (!src) {
        return (
            <div className={`flex items-center justify-center bg-neutral-100 dark:bg-neutral-800 ${className}`} style={style}>
                <ImageIcon className="w-8 h-8 text-neutral-300 dark:text-neutral-600" />
            </div>
        );
    }

    const isLoaded = loadingState === 'loaded';
    const isError = loadingState === 'error';

    return (
        <div className={`relative overflow-hidden ${className}`} style={style}>
            {/* Thumbnail - Show while loading and NOT error */}
            {thumbUrl && loadingState === 'loading' && (
                <img
                    src={thumbUrl}
                    alt={alt || "Thumbnail"}
                    className="absolute inset-0 w-full h-full object-cover blur-sm scale-110"
                    style={{ transition: "opacity 0.5s ease-out" }}
                />
            )}

            {/* Full Image - Show when loaded */}
            {isLoaded && (
                <img
                    src={src}
                    alt={alt}
                    className={`w-full h-full object-cover transition-opacity duration-500 ease-in-out opacity-100`}
                />
            )}

            {/* Error Placeholder */}
            {isError && (
                <div className="absolute inset-0 flex items-center justify-center bg-neutral-100 dark:bg-neutral-800">
                    <ImageIcon className="w-8 h-8 text-neutral-300 dark:text-neutral-600" />
                </div>
            )}
        </div>
    );
};

export default ProgressiveImage;
