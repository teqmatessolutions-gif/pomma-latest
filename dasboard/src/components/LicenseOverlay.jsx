import React, { useState, useEffect } from 'react';
import { getApiBaseUrl } from '../utils/env';

const LicenseOverlay = () => {
    const [status, setStatus] = useState(null);
    const [loading, setLoading] = useState(true);
    const [closed, setClosed] = useState(false);

    // Activation Form State
    const [activationKey, setActivationKey] = useState('');
    const [activationLoading, setActivationLoading] = useState(false);
    const [activationMsg, setActivationMsg] = useState('');

    useEffect(() => {
        const checkLicense = async () => {
            try {
                // Use fetch to bypass potential axios interceptors that might redirect
                const response = await fetch(`${getApiBaseUrl()}/health/license-status`);
                if (response.ok || response.status === 403) {
                    const data = await response.json();
                    setStatus(data);
                }
            } catch (error) {
                console.error("License check failed:", error);
            } finally {
                setLoading(false);
            }
        };

        checkLicense();
    }, []);

    const handleActivate = async (e) => {
        e.preventDefault();
        setActivationLoading(true);
        setActivationMsg('');

        try {
            const response = await fetch(`${getApiBaseUrl()}/health/activate`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ activation_key: activationKey })
            });

            const data = await response.json();

            if (response.ok) {
                setActivationMsg("Activation Successful! Reloading...");
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            } else {
                setActivationMsg(data.detail || "Activation Failed");
            }
        } catch (err) {
            setActivationMsg("Connection Error");
        } finally {
            setActivationLoading(false);
        }
    };

    if (loading || !status) return null;

    // 1. BLOCKING LOCK (Expired or Missing)
    if (status.status === 'EXPIRED' || status.status === 'MISSING_LICENSE' || status.status === 'ERROR') {
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
                <p style={{ fontSize: '1.2rem', maxWidth: '600px', marginBottom: '40px' }}>
                    Please contact Teqmates to renew your subscription.
                </p>

                {/* Activation Form */}
                <div style={{
                    padding: '30px',
                    backgroundColor: '#222',
                    borderRadius: '12px',
                    border: '1px solid #444',
                    width: '100%',
                    maxWidth: '400px'
                }}>
                    <h3 style={{ marginBottom: '15px' }}>Enter Activation Code</h3>
                    <form onSubmit={handleActivate} style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                        <input
                            type="text"
                            placeholder="TEQMATES-XXXX-XXXX"
                            value={activationKey}
                            onChange={(e) => setActivationKey(e.target.value)}
                            style={{
                                padding: '12px',
                                borderRadius: '6px',
                                border: '1px solid #555',
                                backgroundColor: '#333',
                                color: 'white',
                                fontSize: '1rem'
                            }}
                        />
                        <button
                            type="submit"
                            disabled={activationLoading || !activationKey}
                            style={{
                                padding: '12px',
                                borderRadius: '6px',
                                border: 'none',
                                backgroundColor: activationLoading ? '#555' : '#22c55e',
                                color: 'white',
                                fontWeight: 'bold',
                                cursor: activationLoading ? 'not-allowed' : 'pointer',
                                fontSize: '1rem',
                                transition: '0.2s'
                            }}
                        >
                            {activationLoading ? 'Verifying...' : 'Activate System'}
                        </button>
                    </form>
                    {activationMsg && (
                        <p style={{
                            marginTop: '15px',
                            color: activationMsg.includes('Success') ? '#4ade80' : '#ef4444',
                            fontWeight: 'bold'
                        }}>
                            {activationMsg}
                        </p>
                    )}
                </div>
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
