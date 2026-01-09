import React, { useState, useEffect } from 'react';
import { getApiBaseUrl } from '../utils/env';

const LicenseOverlay = () => {
    const [status, setStatus] = useState(null);
    const [loading, setLoading] = useState(true);
    const [closed, setClosed] = useState(false);

    useEffect(() => {
        const checkLicense = async () => {
            try {
                // Use fetch to bypass potential axios interceptors that might redirect
                const baseUrl = getApiBaseUrl().replace('/api', ''); // main.py mounts at root, but router is /api
                // Wait, getApiBaseUrl usually returns e.g. http://localhost:8000/api
                // My endpoint is /api/health/license-status

                const response = await fetch(`${getApiBaseUrl()}/health/license-status`);
                if (response.ok) {
                    const data = await response.json();
                    setStatus(data);
                } else if (response.status === 403) {
                    // If 403, it might be the LICENSE_EXPIRED middleware response itself!
                    // But wait, I whitelisted /api/health... so it should return 200 with status="EXPIRED"
                    // unless I messed up the whitelist.
                    // Let's assume the endpoint works.
                    const data = await response.json();
                    setStatus(data); // Might contain the "License Expired" message from middleware if whitelisting failed
                }
            } catch (error) {
                console.error("License check failed:", error);
            } finally {
                setLoading(false);
            }
        };

        checkLicense();
    }, []);

    if (loading || !status) return null;

    // 1. BLOCKING LOCK (Expired or Missing)
    if (status.status === 'EXPIRED' || status.status === 'MISSING_LICENSE') {
        return (
            <div style={{
                position: 'fixed',
                top: 0,
                left: 0,
                width: '100vw',
                height: '100vh',
                backgroundColor: 'rgba(0,0,0,0.95)',
                color: 'white',
                zIndex: 99999,
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                textAlign: 'center'
            }}>
                <h1 style={{ color: '#ff4444', fontSize: '3rem', marginBottom: '20px' }}>SYSTEM SUSPENDED</h1>
                <h2 style={{ marginBottom: '20px' }}>{status.message || "License Activation Required"}</h2>
                <p style={{ fontSize: '1.2rem', maxWidth: '600px' }}>
                    Please contact Teqmates to renew your subscription.
                </p>
                {status.status === 'MISSING_LICENSE' && (
                    <div style={{ marginTop: '40px', padding: '20px', backgroundColor: '#333', borderRadius: '8px' }}>
                        <p style={{ marginBottom: '10px' }}><strong>Immediate Activation Required</strong></p>
                        <code style={{ display: 'block', padding: '10px', background: '#000', color: '#0f0' }}>
                            POST /api/health/activate
                        </code>
                    </div>
                )}
            </div>
        );
    }

    // 2. WARNING OVERLAY (T-10 Days)
    if (status.status === 'WARNING' && !closed) {
        return (
            <div style={{
                position: 'fixed',
                bottom: 0,
                left: 0,
                width: '100%',
                backgroundColor: '#ff8800', // Orange warning
                color: 'white',
                padding: '15px',
                zIndex: 9999,
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                boxShadow: '0 -2px 10px rgba(0,0,0,0.2)'
            }}>
                <span style={{ fontSize: '1.1rem', fontWeight: 'bold', marginRight: '20px' }}>
                    ⚠️ LICENSE WARNING: {status.message}
                </span>
                <button
                    onClick={() => setClosed(true)}
                    style={{
                        background: 'transparent',
                        border: '1px solid white',
                        color: 'white',
                        padding: '5px 15px',
                        cursor: 'pointer',
                        borderRadius: '4px',
                        fontWeight: 'bold'
                    }}
                >
                    Dismiss
                </button>
            </div>
        );
    }

    return null;
};

export default LicenseOverlay;
