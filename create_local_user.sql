-- Create local admin user for Pomma application
-- Run this SQL in pgAdmin Query Tool after restoring the database

-- Insert admin user
INSERT INTO users (
    username, 
    email, 
    hashed_password, 
    full_name, 
    is_active, 
    is_superuser,
    created_at
) VALUES (
    'admin',
    'admin@resort.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ND0dalV3cXfC', -- password: admin123
    'Admin User',
    true,
    true,
    NOW()
) ON CONFLICT (username) DO UPDATE 
SET email = EXCLUDED.email,
    hashed_password = EXCLUDED.hashed_password;

-- Create admin role if not exists
INSERT INTO roles (name, description, created_at)
VALUES ('Admin', 'Full system access', NOW())
ON CONFLICT (name) DO NOTHING;

-- Assign admin role to user
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'admin' AND r.name = 'Admin'
ON CONFLICT DO NOTHING;

-- Verify user was created
SELECT id, username, email, full_name, is_active, is_superuser 
FROM users 
WHERE username = 'admin';

