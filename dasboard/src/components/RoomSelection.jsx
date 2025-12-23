import React from 'react';
import { motion } from 'framer-motion';
import API from '../services/api';
import { formatCurrency } from '../utils/currency';
import ProgressiveImage from './ProgressiveImage';

const RoomSelection = React.memo(({ rooms, selectedRoomNumbers, onRoomToggle }) => {
    // Helper to construct image URL safely
    const getRoomImageUrl = (imagePath) => {
        if (!imagePath) return "https://placehold.co/600x400?text=No+Image";
        if (imagePath.startsWith("http")) return imagePath;

        // Cleanup API base URL to get the root server URL
        let baseUrl = API.defaults.baseURL;
        // Handle both /api and /api/v1 endings
        baseUrl = baseUrl.replace(/\/api\/v1\/?$/, "");
        baseUrl = baseUrl.replace(/\/api\/?$/, "");
        baseUrl = baseUrl.replace(/\/$/, "");

        return `${baseUrl}/${imagePath.startsWith("/") ? imagePath.slice(1) : imagePath}`;
    };

    return (
        <div className="flex flex-nowrap gap-4 p-1 overflow-x-auto pb-4 pt-2 scroll-smooth">
            {rooms.length > 0 ? (
                rooms.map((room) => {
                    const isSelected = selectedRoomNumbers.includes(room.number);
                    const imageUrl = room.image_url ? getRoomImageUrl(room.image_url) : (room.images && room.images.length > 0 ? getRoomImageUrl(room.images[0].image_url) : "https://placehold.co/600x400?text=Room");

                    return (
                        <motion.div
                            key={room.id}
                            whileHover={{ y: -5 }}
                            className={`
                relative flex-shrink-0 w-56 bg-white rounded-xl shadow-md border overflow-hidden transition-all duration-300
                ${isSelected ? 'border-green-600 ring-2 ring-green-500 ring-offset-1' : 'border-gray-200 hover:shadow-lg'}
              `}
                            onClick={() => onRoomToggle(room.number)}
                        >
                            {/* Room Image - Reduced Height */}
                            <div className="relative h-32 w-full overflow-hidden">
                                <ProgressiveImage
                                    src={imageUrl}
                                    alt={`Room ${room.number}`}
                                    className="w-full h-full object-cover transition-transform duration-500 hover:scale-110"
                                />
                                {/* Room Number Badge */}
                                <div className="absolute top-2 right-2 bg-white/90 backdrop-blur-sm px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider shadow-sm text-gray-800">
                                    Room #{room.number}
                                </div>
                                {/* Selection Overlay */}
                                {isSelected && (
                                    <div className="absolute inset-0 bg-green-900/20 flex items-center justify-center backdrop-blur-[1px]">
                                        <span className="bg-white text-green-700 px-3 py-1 rounded-full text-xs font-bold shadow-lg transform -rotate-3 border border-green-100 flex items-center gap-1">
                                            <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" /></svg>
                                            Selected
                                        </span>
                                    </div>
                                )}
                            </div>

                            {/* Content - Reduced Padding & Size */}
                            <div className="p-3 flex flex-col gap-2">
                                <div>
                                    <h4 className="text-sm font-bold text-gray-800 truncate" title={room.type}>
                                        {room.type}
                                    </h4>
                                    <div className="flex gap-1 mt-1">
                                        <div className="px-2 py-0.5 bg-gray-50 border border-gray-100 rounded text-[10px] font-semibold text-gray-600 flex items-center gap-1">
                                            <span>👥</span> {room.adults}
                                        </div>
                                        <div className="px-2 py-0.5 bg-gray-50 border border-gray-100 rounded text-[10px] font-semibold text-gray-600 flex items-center gap-1">
                                            <span>👶</span> {room.children}
                                        </div>
                                    </div>
                                </div>

                                <div className="space-y-0.5">
                                    <p className="text-[10px] text-gray-400 font-semibold uppercase tracking-wide">Start From</p>
                                    <div className="flex items-baseline gap-1">
                                        <span className="text-lg font-extrabold text-[#0f5132]">
                                            {formatCurrency(room.price)}
                                        </span>
                                        <span className="text-xs text-gray-500 font-medium">/night</span>
                                    </div>
                                </div>

                                <button
                                    className={`
                    w-full py-2 rounded-lg font-bold text-xs tracking-wider uppercase transition-all duration-200
                    ${isSelected
                                            ? 'bg-neutral-800 text-white hover:bg-black shadow-md'
                                            : 'bg-[#0f5132] text-white hover:bg-[#153a2c] shadow hover:shadow-md active:transform active:scale-95'
                                        }
                  `}
                                >
                                    {isSelected ? '✓ Selected' : 'Select Room'}
                                </button>
                            </div>
                        </motion.div>
                    );
                })
            ) : (
                <div className="w-full text-center py-6 px-4 bg-gray-50 border-2 border-dashed border-gray-200 rounded-2xl">
                    <div className="text-2xl mb-2 opacity-50">🛏️</div>
                    <h3 className="text-sm font-semibold text-gray-700">No rooms available</h3>
                    <p className="text-gray-500 text-xs mt-1">
                        Try adjusting your check-in/check-out dates.
                    </p>
                </div>
            )}
        </div>
    );
});

RoomSelection.displayName = 'RoomSelection';

export default RoomSelection;
