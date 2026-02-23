import React, { useState, useEffect, useRef, useCallback } from 'react';
import { getApiBaseUrl } from '../utils/env';

const LicenseOverlay = () => {
    const [status, setStatus] = useState(null);
    const [loading, setLoading] = useState(true);
    const [closed, setClosed] = useState(false);
    const [urgentDismissed, setUrgentDismissed] = useState(false);

    // Activation Form State
    const [activationKey, setActivationKey] = useState('');
    const [activationLoading, setActivationLoading] = useState(false);
    const [activationMsg, setActivationMsg] = useState('');

    const pollRef = useRef(null);

    const checkLicense = useCallback(async () => {
        try {
            const response = await fetch(`${getApiBaseUrl()}/health/license-status`, {
                cache: 'no-store'
            });
            if (response.ok) {
                const data = await response.json();
                setStatus(data);
                // Reset urgentDismissed if status has changed away from EXPIRING_SOON
                if (data.status !== 'EXPIRING_SOON') {
                    setUrgentDismissed(false);
                }
            } else if (response.status === 403) {
                // Backend locked via kill-switch
                const data = await response.json().catch(() => ({}));
                setStatus({ status: 'EXPIRED', message: data.message || 'Access suspended.' });
            }
        } catch (err) {
            console.error('[LicenseOverlay] Check failed:', err);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        // Initial check immediately
        checkLicense();

        // Poll every 10 seconds for real-time expiry detection
        pollRef.current = setInterval(() => {
            checkLicense();
        }, 10000);

        return () => {
            if (pollRef.current) clearInterval(pollRef.current);
        };
    }, [checkLicense]);

    const handleActivate = async (e) => {
        e.preventDefault();
        setActivationLoading(true);
        setActivationMsg('');

        try {
            const response = await fetch(`${getApiBaseUrl()}/health/activate`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ activation_key: activationKey })
            });

            const data = await response.json();

            if (response.ok) {
                setActivationMsg('✅ Activation Successful! Reloading...');
                // Re-check right away so UI updates instantly
                await checkLicense();
                setTimeout(() => { window.location.reload(); }, 1500);
            } else {
                setActivationMsg(data.detail || 'Activation Failed');
            }
        } catch (err) {
            setActivationMsg('Connection Error');
        } finally {
            setActivationLoading(false);
        }
    };

    if (loading) return null;

    // ── 1. BLOCKING LOCK (Expired / Missing / Error) ─────────────────────────
    if (!status || ['EXPIRED', 'MISSING_LICENSE', 'ERROR'].includes(status.status)) {
        return (
            <div style={{
                position: 'fixed', top: 0, left: 0,
                width: '100vw', height: '100vh',
                backgroundColor: 'rgba(0,0,0,0.97)',
                color: 'white', zIndex: 99999,
                display: 'flex', flexDirection: 'column',
                alignItems: 'center', justifyContent: 'center', textAlign: 'center',
                padding: '20px'
            }}>
                <div style={{ fontSize: '4rem', marginBottom: '16px' }}>🔒</div>
                <h1 style={{ color: '#ff4444', fontSize: '2.5rem', marginBottom: '12px', fontWeight: 'bold' }}>
                    SYSTEM SUSPENDED
                </h1>
                <h2 style={{ color: '#fca5a5', marginBottom: '12px', fontWeight: '400' }}>
                    {status?.message || 'License activation required.'}
                </h2>
                <p style={{ fontSize: '1rem', maxWidth: '520px', marginBottom: '36px', color: '#9ca3af' }}>
                    Please contact Teqmates to renew your subscription.
                </p>

                {/* Activation Form */}
                <div style={{
                    padding: '28px 32px', backgroundColor: '#1e1e1e',
                    borderRadius: '14px', border: '1px solid #3f3f3f',
                    width: '100%', maxWidth: '420px'
                }}>
                    <h3 style={{ marginBottom: '16px', fontSize: '1.1rem', color: '#e5e7eb' }}>
                        Enter Activation Code
                    </h3>
                    <form onSubmit={handleActivate} style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                        <input
                            type="text"
                            placeholder="TEQMATES-XXXX-XXXX-XXXX"
                            value={activationKey}
                            onChange={(e) => setActivationKey(e.target.value)}
                            autoFocus
                            style={{
                                padding: '13px 16px', borderRadius: '8px',
                                border: '1px solid #4b5563', backgroundColor: '#2d2d2d',
                                color: 'white', fontSize: '1rem', outline: 'none',
                                letterSpacing: '1px'
                            }}
                        />
                        <button
                            type="submit"
                            disabled={activationLoading || !activationKey.trim()}
                            style={{
                                padding: '13px', borderRadius: '8px', border: 'none',
                                backgroundColor: activationLoading || !activationKey.trim() ? '#374151' : '#22c55e',
                                color: 'white', fontWeight: 'bold',
                                cursor: activationLoading || !activationKey.trim() ? 'not-allowed' : 'pointer',
                                fontSize: '1rem', transition: 'background 0.2s'
                            }}
                        >
                            {activationLoading ? '⏳ Verifying...' : '🔓 Activate System'}
                        </button>
                    </form>
                    {activationMsg && (
                        <p style={{
                            marginTop: '14px',
                            color: activationMsg.includes('✅') ? '#4ade80' : '#f87171',
                            fontWeight: '600', fontSize: '0.95rem'
                        }}>
                            {activationMsg}
                        </p>
                    )}
                </div>
            </div>
        );
    }

    // ── 2. URGENT ALERT — ≤ 60 seconds to expiry ────────────────────────────
    if (status.status === 'EXPIRING_SOON' && !urgentDismissed) {
        return (
            <div style={{
                position: 'fixed', top: 0, left: 0,
                width: '100vw', height: '100vh',
                backgroundColor: 'rgba(0,0,0,0.80)',
                zIndex: 99998,
                display: 'flex', alignItems: 'center', justifyContent: 'center'
            }}>
                <div style={{
                    backgroundColor: '#1a1a1a',
                    border: '2px solid #dc2626',
                    borderRadius: '18px',
                    padding: '44px 48px',
                    maxWidth: '480px', width: '90%',
                    textAlign: 'center', color: 'white',
                    boxShadow: '0 0 60px rgba(220,38,38,0.6)'
                }}>
                    <style>{`
                        @keyframes blink { 0%,100% { opacity:1; transform:scale(1); } 50% { opacity:0.4; transform:scale(1.25); } }
                    `}</style>
                    <div style={{ fontSize: '3.5rem', marginBottom: '16px', display: 'inline-block', animation: 'blink 0.8s ease-in-out infinite' }}>
                        🔴
                    </div>
                    <h2 style={{ color: '#ff4444', fontSize: '1.9rem', fontWeight: 'bold', marginBottom: '10px' }}>
                        ⚠️ LICENSE EXPIRING!
                    </h2>
                    <p style={{ fontSize: '1.15rem', color: '#fca5a5', fontWeight: '600', marginBottom: '8px' }}>
                        {status.message}
                    </p>
                    <p style={{ fontSize: '0.9rem', color: '#6b7280', marginBottom: '28px' }}>
                        The system will auto-suspend when the timer hits zero.
                    </p>
                    <button
                        onClick={() => setUrgentDismissed(true)}
                        style={{
                            padding: '10px 28px', borderRadius: '8px',
                            border: '1px solid #4b5563', backgroundColor: 'transparent',
                            color: '#9ca3af', cursor: 'pointer', fontWeight: '600',
                            fontSize: '0.9rem', transition: 'border-color 0.2s'
                        }}
                    >
                        Dismiss
                    </button>
                </div>
            </div>
        );
    }

    // ── 3. WARNING BANNER — active but less than 1 day ───────────────────────
    if (status.status === 'WARNING' && !closed) {
        return (
            <div style={{
                position: 'fixed', bottom: 0, left: 0, width: '100%',
                backgroundColor: '#d97706', color: 'white',
                padding: '14px 20px', zIndex: 9999,
                display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '20px',
                boxShadow: '0 -4px 12px rgba(0,0,0,0.25)'
            }}>
                <span style={{ fontSize: '1rem', fontWeight: '600' }}>
                    ⚠️ LICENSE WARNING: {status.message}
                </span>
                <button
                    onClick={() => setClosed(true)}
                    style={{
                        background: 'transparent', border: '1px solid rgba(255,255,255,0.7)',
                        color: 'white', padding: '5px 16px',
                        cursor: 'pointer', borderRadius: '6px', fontWeight: 'bold'
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
