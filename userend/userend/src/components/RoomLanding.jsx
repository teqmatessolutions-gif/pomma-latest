import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Utensils, ConciergeBell, Home, ArrowRight } from 'lucide-react';
import localLogo from '../assets/logo.png';

const RoomLanding = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [animate, setAnimate] = useState(false);

    useEffect(() => {
        setAnimate(true);
    }, []);

    const handleNavigation = (action) => {
        // Navigate to home with room_id and action param
        // The App component will read these and open the appropriate modal
        let url = `/?room_id=${id}`;
        if (action) {
            url += `&action=${action}`;
        }
        navigate(url);
    };

    return (
        <div className="min-h-screen bg-[#f9f4ea] text-[#153a2c] font-sans overflow-hidden relative">
            {/* Background Decor */}
            <div className="absolute top-0 left-0 w-full h-64 bg-gradient-to-b from-[#0f5132] to-[#1a7042] rounded-b-[3rem] z-0"></div>

            <div className="relative z-10 container mx-auto px-4 py-8 flex flex-col items-center min-h-screen">
                {/* Logo */}
                <div className={`transition-all duration-1000 transform ${animate ? 'translate-y-0 opacity-100' : '-translate-y-10 opacity-0'}`}>
                    <div className="w-24 h-24 bg-white rounded-full shadow-xl flex items-center justify-center mb-6 p-2 mx-auto">
                        <img src={localLogo} alt="Pomma Holidays" className="w-full h-full object-contain" />
                    </div>
                </div>

                {/* Welcome Text */}
                <div className={`text-center mb-10 transition-all duration-1000 delay-300 transform ${animate ? 'translate-y-0 opacity-100' : 'translate-y-10 opacity-0'}`}>
                    <h1 className="text-white text-3xl font-serif font-bold mb-2 text-shadow-sm">Welcome to</h1>
                    <div className="bg-white/10 backdrop-blur-md px-8 py-2 rounded-full inline-block border border-white/20">
                        <h2 className="text-4xl md:text-5xl font-bold text-[#f9f4ea] tracking-wider">Room {id}</h2>
                    </div>
                    <p className="text-[#f9f4ea]/80 mt-4 text-sm font-medium tracking-widest uppercase">Your Personalized Stay Experience</p>
                </div>

                {/* Main Actions */}
                <div className={`w-full max-w-md grid grid-cols-1 gap-4 transition-all duration-1000 delay-500 transform ${animate ? 'translate-y-0 opacity-100' : 'translate-y-20 opacity-0'}`}>

                    {/* Order Food */}
                    <button
                        onClick={() => handleNavigation('food')}
                        className="group relative bg-white hover:bg-[#f1e7d8] p-6 rounded-2xl shadow-xl transition-all duration-300 transform hover:-translate-y-1 hover:shadow-2xl flex items-center justify-between border border-[#e2d6c0]"
                    >
                        <div className="flex items-center space-x-4">
                            <div className="w-12 h-12 bg-[#fff8e1] rounded-full flex items-center justify-center text-amber-600 group-hover:scale-110 transition-transform duration-300">
                                <Utensils size={24} />
                            </div>
                            <div className="text-left">
                                <h3 className="font-bold text-lg text-[#153a2c]">Order Food</h3>
                                <p className="text-xs text-[#4f6f62]">Delicious meals delivered to your room</p>
                            </div>
                        </div>
                        <div className="bg-[#153a2c] text-white p-2 rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-300 transform translate-x-2 group-hover:translate-x-0">
                            <ArrowRight size={16} />
                        </div>
                    </button>

                    {/* Book Service */}
                    <button
                        onClick={() => handleNavigation('service')}
                        className="group relative bg-white hover:bg-[#f1e7d8] p-6 rounded-2xl shadow-xl transition-all duration-300 transform hover:-translate-y-1 hover:shadow-2xl flex items-center justify-between border border-[#e2d6c0]"
                    >
                        <div className="flex items-center space-x-4">
                            <div className="w-12 h-12 bg-[#e0f2f1] rounded-full flex items-center justify-center text-teal-600 group-hover:scale-110 transition-transform duration-300">
                                <ConciergeBell size={24} />
                            </div>
                            <div className="text-left">
                                <h3 className="font-bold text-lg text-[#153a2c]">Book Service</h3>
                                <p className="text-xs text-[#4f6f62]">Housekeeping, spa, and more</p>
                            </div>
                        </div>
                        <div className="bg-[#153a2c] text-white p-2 rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-300 transform translate-x-2 group-hover:translate-x-0">
                            <ArrowRight size={16} />
                        </div>
                    </button>

                    {/* View All */}
                    <button
                        onClick={() => handleNavigation(null)}
                        className="mt-4 bg-[#153a2c] hover:bg-[#0f2e22] text-white py-4 px-6 rounded-xl shadow-lg transition-colors flex items-center justify-center space-x-2 font-medium"
                    >
                        <Home size={18} />
                        <span>Explore Resort & Amenities</span>
                    </button>
                </div>

                {/* Footer */}
                <div className="mt-auto pt-8 pb-4 text-center opacity-60">
                    <p className="text-xs text-[#153a2c]">© 2025 Pomma Holidays</p>
                </div>
            </div>
        </div>
    );
};

export default RoomLanding;
