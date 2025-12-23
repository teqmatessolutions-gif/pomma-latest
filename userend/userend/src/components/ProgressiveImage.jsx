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
    const [imgSrc, setImgSrc] = useState(placeholderSrc || src);
    const [isLoaded, setIsLoaded] = useState(false);
    const [isError, setIsError] = useState(false);

    // Derive thumbnail URL if not explicitly provided
    // Assumption: thumbnail is same name + "_thumb.jpg"
    const thumbUrl = React.useMemo(() => {
        if (placeholderSrc) return placeholderSrc;
        if (!src) return null;
        if (src.includes("_thumb")) return src; // Already a thumb

        // Replace extension or append _thumb
        // Example: /path/to/image.jpg -> /path/to/image_thumb.jpg
        try {
            const lastDotIndex = src.lastIndexOf('.');
            if (lastDotIndex === -1) return src; // No extension?
            const basePath = src.substring(0, lastDotIndex);
            // const ext = src.substring(lastDotIndex); // Keep extension? Force jpg?
            // Our backend saves thumbs as .jpg regardless of original extension
            return `${basePath}_thumb.jpg`;
        } catch (e) {
            return src;
        }
    }, [src, placeholderSrc]);

    useEffect(() => {
        if (!src) return;

        // Reset state when src changes
        setIsError(false);
        setIsLoaded(false);
        setImgSrc(thumbUrl);

        // Load full image
        const img = new Image();
        img.src = src;
        img.onload = () => {
            setImgSrc(src);
            setIsLoaded(true);
        };
        img.onerror = () => {
            // If full image fails, we might still have the thumb or break
            setIsError(true);
            // Try fallback if provided, or just stay on thumb if available?
            // Usually if full fails, we show error state.
        };
    }, [src, thumbUrl]);

    if (isError && !thumbUrl) {
        return (
            <div className={`flex items-center justify-center bg-neutral-100 ${className}`} style={style}>
                <ImageIcon className="w-8 h-8 text-neutral-300" />
            </div>
        );
    }

    return (
        <div className={`relative overflow-hidden ${className}`} style={style}>
            {/* Thumbnail (Optimized Image - Clear) */}
            <img
                src={thumbUrl}
                alt={alt}
                className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-500 ease-in-out ${isLoaded ? 'opacity-0' : 'opacity-100'}`}
            />

            {/* Full Image (Fade In) */}
            <img
                src={isLoaded ? src : thumbUrl} /* Keep thumb as src until loaded to prevent blank flash */
                alt={alt}
                className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-500 ease-in-out ${isLoaded ? 'opacity-100' : 'opacity-0'}`}
            />
        </div>
    );
};

export default ProgressiveImage;
