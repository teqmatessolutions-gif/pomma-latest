import React, { useState, useMemo } from 'react';
import { Image as ImageIcon } from 'lucide-react';

/* 
  ProgressiveImage Component
  --------------------------
  SIMPLIFIED VERSION FOR STABILITY
  1. Main Image is ALWAYS rendered with opacity-100 (Visible).
  2. Thumbnail is rendered ABSOLUTE behind the main image.
  3. No 'onLoad' state is required for visibility.
  4. This guarantees the image shows up if the browser has it.
*/
const ProgressiveImage = ({ src, alt, className = "", placeholderSrc = null, style = {} }) => {
    const [isError, setIsError] = useState(false);

    // Derive thumbnail URL if not explicitly provided
    const thumbUrl = useMemo(() => {
        if (placeholderSrc) return placeholderSrc;
        if (!src) return null;
        if (src.includes("_thumb")) return src;

        try {
            const lastDotIndex = src.lastIndexOf('.');
            if (lastDotIndex === -1) return src;
            const basePath = src.substring(0, lastDotIndex);
            // Default to _thumb.jpg
            return `${basePath}_thumb.jpg?v=hq`;
        } catch (e) {
            return src;
        }
    }, [src, placeholderSrc]);

    const handleError = () => {
        setIsError(true);
    };

    // If src is missing, show error placeholder immediately
    if (!src) {
        return (
            <div className={`flex items-center justify-center bg-neutral-100 dark:bg-neutral-800 ${className}`} style={style}>
                <ImageIcon className="w-8 h-8 text-neutral-300 dark:text-neutral-600" />
            </div>
        );
    }

    return (
        <div className={`relative overflow-hidden ${className}`} style={style}>
            {/* Thumbnail - Absolute, Background, Z-0 */}
            {/* We keep it visible so if main image has transparency or hasn't painted, this shows. */}
            {!isError && thumbUrl && (
                <img
                    src={thumbUrl}
                    alt={alt || "Thumbnail"}
                    className="absolute inset-0 w-full h-full object-cover blur-sm scale-110 z-0"
                    loading="lazy"
                    decoding="async"
                />
            )}

            {/* Main Image - Relative, Z-10, ALWAYS VISIBLE */}
            {!isError && (
                <img
                    src={src}
                    alt={alt}
                    className="relative w-full h-full object-cover z-10"
                    onError={handleError}
                    loading="lazy"
                    decoding="async"
                />
            )}

            {/* Error Placeholder */}
            {isError && (
                <div className="absolute inset-0 flex items-center justify-center bg-neutral-100 dark:bg-neutral-800 z-20">
                    <ImageIcon className="w-8 h-8 text-neutral-300 dark:text-neutral-600" />
                </div>
            )}
        </div>
    );
};

export default ProgressiveImage;
