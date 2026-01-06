import React from 'react';

const LockScreen = () => {
    return (
        <div className="fixed inset-0 z-[99999] bg-gray-900 flex flex-col items-center justify-center text-center p-6">
            <div className="bg-white p-10 rounded-3xl shadow-2xl max-w-md w-full">
                <div className="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
                    <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="h-10 w-10 text-red-600"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                    >
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                    </svg>
                </div>

                <h1 className="text-3xl font-bold text-gray-800 mb-4">
                    Service Suspended
                </h1>

                <p className="text-gray-600 mb-8 leading-relaxed">
                    This application has been temporarily suspended due to a licensing or billing issue.
                    Please contact the system administrator or support team to restore access.
                </p>

                <div className="text-sm text-gray-400 border-t border-gray-100 pt-6">
                    Error Code: SYS_LOCK_001
                </div>
            </div>
        </div>
    );
};

export default LockScreen;
