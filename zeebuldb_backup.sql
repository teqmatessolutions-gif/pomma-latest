--
-- PostgreSQL database dump
--

\restrict vEwEKfJw2Vwm70FudgJWyCU6N1bnfy7uuxOlQF1aibHiQvR8d3JwIte1nZS54ab

-- Dumped from database version 17.9 (Ubuntu 17.9-0ubuntu0.25.10.1)
-- Dumped by pg_dump version 17.9 (Ubuntu 17.9-0ubuntu0.25.10.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: accounttype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.accounttype AS ENUM (
    'REVENUE',
    'EXPENSE',
    'ASSET',
    'LIABILITY',
    'TAX'
);


ALTER TYPE public.accounttype OWNER TO postgres;

--
-- Name: notificationtype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notificationtype AS ENUM (
    'SERVICE',
    'BOOKING',
    'PACKAGE',
    'INVENTORY',
    'EXPENSE',
    'FOOD_ORDER',
    'SUCCESS',
    'ERROR',
    'INFO'
);


ALTER TYPE public.notificationtype OWNER TO postgres;

--
-- Name: servicestatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.servicestatus AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'cancelled'
);


ALTER TYPE public.servicestatus OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_groups (
    id integer NOT NULL,
    name character varying NOT NULL,
    account_type public.accounttype NOT NULL,
    description text,
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.account_groups OWNER TO postgres;

--
-- Name: account_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_groups_id_seq OWNER TO postgres;

--
-- Name: account_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_groups_id_seq OWNED BY public.account_groups.id;


--
-- Name: account_ledgers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_ledgers (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying,
    group_id integer NOT NULL,
    module character varying,
    description text,
    opening_balance double precision,
    balance_type character varying NOT NULL,
    is_active boolean NOT NULL,
    tax_type character varying,
    tax_rate double precision,
    bank_name character varying,
    account_number character varying,
    ifsc_code character varying,
    branch_name character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.account_ledgers OWNER TO postgres;

--
-- Name: account_ledgers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_ledgers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_ledgers_id_seq OWNER TO postgres;

--
-- Name: account_ledgers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_ledgers_id_seq OWNED BY public.account_ledgers.id;


--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    id integer NOT NULL,
    action character varying,
    method character varying,
    path character varying,
    status_code integer,
    client_ip character varying,
    user_id integer,
    details text,
    "timestamp" timestamp with time zone DEFAULT now(),
    branch_id integer DEFAULT 1
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activity_logs_id_seq OWNER TO postgres;

--
-- Name: activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_logs_id_seq OWNED BY public.activity_logs.id;


--
-- Name: asset_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_mappings (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    serial_number character varying,
    assigned_date timestamp without time zone NOT NULL,
    assigned_by integer,
    notes text,
    is_active boolean NOT NULL,
    unassigned_date timestamp without time zone,
    quantity double precision NOT NULL,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.asset_mappings OWNER TO postgres;

--
-- Name: asset_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_mappings_id_seq OWNER TO postgres;

--
-- Name: asset_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_mappings_id_seq OWNED BY public.asset_mappings.id;


--
-- Name: asset_registry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_registry (
    id integer NOT NULL,
    asset_tag_id character varying NOT NULL,
    item_id integer NOT NULL,
    serial_number character varying,
    current_location_id integer,
    status character varying NOT NULL,
    purchase_date date,
    warranty_expiry date,
    last_maintenance_date date,
    next_maintenance_due date,
    purchase_master_id integer,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.asset_registry OWNER TO postgres;

--
-- Name: asset_registry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_registry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_registry_id_seq OWNER TO postgres;

--
-- Name: asset_registry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_registry_id_seq OWNED BY public.asset_registry.id;


--
-- Name: assigned_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assigned_services (
    id integer NOT NULL,
    service_id integer,
    employee_id integer,
    room_id integer,
    booking_id integer,
    package_booking_id integer,
    assigned_at timestamp without time zone,
    status public.servicestatus,
    billing_status character varying,
    branch_id integer DEFAULT 1 NOT NULL,
    last_used_at timestamp without time zone,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    override_charges double precision
);


ALTER TABLE public.assigned_services OWNER TO postgres;

--
-- Name: assigned_services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assigned_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assigned_services_id_seq OWNER TO postgres;

--
-- Name: assigned_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assigned_services_id_seq OWNED BY public.assigned_services.id;


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendances (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    date date NOT NULL,
    status character varying NOT NULL,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.attendances OWNER TO postgres;

--
-- Name: attendances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendances_id_seq OWNER TO postgres;

--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;


--
-- Name: booking_rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_rooms (
    id integer NOT NULL,
    booking_id integer,
    room_id integer,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.booking_rooms OWNER TO postgres;

--
-- Name: booking_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.booking_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.booking_rooms_id_seq OWNER TO postgres;

--
-- Name: booking_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.booking_rooms_id_seq OWNED BY public.booking_rooms.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    display_id character varying,
    status character varying,
    guest_name character varying NOT NULL,
    guest_mobile character varying,
    guest_email character varying,
    check_in date NOT NULL,
    check_out date NOT NULL,
    checked_in_at timestamp without time zone,
    checked_out_at timestamp without time zone,
    adults integer,
    children integer,
    id_card_image_url character varying,
    guest_photo_url character varying,
    user_id integer,
    total_amount double precision,
    advance_deposit double precision,
    created_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL,
    room_type_id integer,
    num_rooms integer,
    external_id character varying,
    source character varying,
    package_name character varying,
    is_id_verified boolean,
    digital_signature_url character varying,
    special_requests character varying,
    preferences character varying,
    room_rate double precision DEFAULT 0.0,
    rate_plan_code character varying,
    is_confirmed boolean DEFAULT false,
    confirmed_at timestamp without time zone,
    confirmation_notes character varying
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_id_seq OWNER TO postgres;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: branches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branches (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    address text,
    phone character varying,
    email character varying,
    gst_number character varying,
    image_url character varying,
    facebook character varying,
    instagram character varying,
    twitter character varying,
    linkedin character varying,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.branches OWNER TO postgres;

--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branches_id_seq OWNER TO postgres;

--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;


--
-- Name: check_availability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.check_availability (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100),
    phone character varying(20),
    check_in date,
    check_out date,
    guests integer,
    is_active boolean,
    branch_id integer
);


ALTER TABLE public.check_availability OWNER TO postgres;

--
-- Name: check_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.check_availability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.check_availability_id_seq OWNER TO postgres;

--
-- Name: check_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.check_availability_id_seq OWNED BY public.check_availability.id;


--
-- Name: checkout_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checkout_payments (
    id integer NOT NULL,
    checkout_id integer NOT NULL,
    payment_method character varying NOT NULL,
    amount double precision NOT NULL,
    transaction_id character varying,
    notes character varying,
    created_at timestamp with time zone DEFAULT now(),
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.checkout_payments OWNER TO postgres;

--
-- Name: checkout_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.checkout_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.checkout_payments_id_seq OWNER TO postgres;

--
-- Name: checkout_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.checkout_payments_id_seq OWNED BY public.checkout_payments.id;


--
-- Name: checkout_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checkout_requests (
    id integer NOT NULL,
    booking_id integer,
    package_booking_id integer,
    room_number character varying NOT NULL,
    guest_name character varying NOT NULL,
    branch_id integer DEFAULT 1 NOT NULL,
    status character varying,
    requested_by character varying,
    requested_at timestamp with time zone DEFAULT now(),
    employee_id integer,
    inventory_checked boolean,
    inventory_checked_by character varying,
    inventory_checked_at timestamp without time zone,
    inventory_notes text,
    inventory_data json,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    checkout_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.checkout_requests OWNER TO postgres;

--
-- Name: checkout_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.checkout_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.checkout_requests_id_seq OWNER TO postgres;

--
-- Name: checkout_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.checkout_requests_id_seq OWNED BY public.checkout_requests.id;


--
-- Name: checkout_verifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checkout_verifications (
    id integer NOT NULL,
    checkout_id integer NOT NULL,
    checkout_request_id integer,
    room_number character varying NOT NULL,
    branch_id integer DEFAULT 1 NOT NULL,
    housekeeping_status character varying,
    housekeeping_notes text,
    housekeeping_approved_by character varying,
    housekeeping_approved_at timestamp without time zone,
    consumables_audit_data json,
    consumables_total_charge double precision,
    asset_damages json,
    asset_damage_total double precision,
    key_card_returned boolean,
    key_card_fee double precision,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.checkout_verifications OWNER TO postgres;

--
-- Name: checkout_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.checkout_verifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.checkout_verifications_id_seq OWNER TO postgres;

--
-- Name: checkout_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.checkout_verifications_id_seq OWNED BY public.checkout_verifications.id;


--
-- Name: checkouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checkouts (
    id integer NOT NULL,
    room_total double precision,
    food_total double precision,
    service_total double precision,
    package_total double precision,
    tax_amount double precision,
    discount_amount double precision,
    grand_total double precision,
    guest_name character varying,
    room_number character varying,
    created_at timestamp with time zone DEFAULT now(),
    checkout_date timestamp without time zone,
    payment_method character varying,
    late_checkout_fee double precision,
    consumables_charges double precision,
    inventory_charges double precision,
    asset_damage_charges double precision,
    key_card_fee double precision,
    advance_deposit double precision,
    tips_gratuity double precision,
    bill_details json,
    guest_gstin character varying,
    is_b2b boolean,
    invoice_number character varying,
    invoice_pdf_path character varying,
    gate_pass_path character varying,
    feedback_sent boolean,
    booking_id integer,
    package_booking_id integer,
    payment_status character varying,
    notes text,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.checkouts OWNER TO postgres;

--
-- Name: checkouts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.checkouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.checkouts_id_seq OWNER TO postgres;

--
-- Name: checkouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.checkouts_id_seq OWNED BY public.checkouts.id;


--
-- Name: day_audits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.day_audits (
    id integer NOT NULL,
    branch_id integer NOT NULL,
    business_date date NOT NULL,
    status character varying NOT NULL,
    opened_at timestamp with time zone,
    opened_by_id integer,
    opening_cash_balance double precision,
    opening_notes text,
    closed_at timestamp with time zone,
    closed_by_id integer,
    closing_cash_balance double precision,
    closing_notes text,
    total_room_revenue double precision,
    total_food_revenue double precision,
    total_service_revenue double precision,
    total_gst_collected double precision,
    total_payments_received double precision,
    total_expenses double precision,
    rooms_occupied integer,
    new_checkins integer,
    new_checkouts integer,
    audit_log json,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.day_audits OWNER TO postgres;

--
-- Name: day_audits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.day_audits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.day_audits_id_seq OWNER TO postgres;

--
-- Name: day_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.day_audits_id_seq OWNED BY public.day_audits.id;


--
-- Name: employee_inventory_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_inventory_assignments (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    assigned_service_id integer,
    item_id integer NOT NULL,
    quantity_assigned double precision NOT NULL,
    quantity_used double precision NOT NULL,
    quantity_returned double precision NOT NULL,
    status character varying,
    is_returned boolean,
    assigned_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL,
    returned_at timestamp without time zone,
    notes character varying
);


ALTER TABLE public.employee_inventory_assignments OWNER TO postgres;

--
-- Name: employee_inventory_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_inventory_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_inventory_assignments_id_seq OWNER TO postgres;

--
-- Name: employee_inventory_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_inventory_assignments_id_seq OWNED BY public.employee_inventory_assignments.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    name character varying,
    role character varying,
    salary double precision,
    join_date date,
    image_url character varying,
    daily_tasks character varying,
    paid_leave_balance integer,
    sick_leave_balance integer,
    long_leave_balance integer,
    wellness_leave_balance integer,
    user_id integer,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_id_seq OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.expenses (
    id integer NOT NULL,
    category character varying NOT NULL,
    amount double precision NOT NULL,
    date date NOT NULL,
    description character varying,
    employee_id integer,
    image character varying,
    department character varying,
    status character varying NOT NULL,
    created_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL,
    rcm_applicable boolean NOT NULL,
    rcm_tax_rate double precision,
    nature_of_supply character varying,
    original_bill_no character varying,
    self_invoice_number character varying,
    vendor_id integer,
    rcm_liability_date date,
    itc_eligible boolean NOT NULL
);


ALTER TABLE public.expenses OWNER TO postgres;

--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.expenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.expenses_id_seq OWNER TO postgres;

--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.expenses_id_seq OWNED BY public.expenses.id;


--
-- Name: food_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    image character varying,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.food_categories OWNER TO postgres;

--
-- Name: food_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.food_categories_id_seq OWNER TO postgres;

--
-- Name: food_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_categories_id_seq OWNED BY public.food_categories.id;


--
-- Name: food_item_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_item_images (
    id integer NOT NULL,
    image_url character varying,
    item_id integer
);


ALTER TABLE public.food_item_images OWNER TO postgres;

--
-- Name: food_item_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_item_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.food_item_images_id_seq OWNER TO postgres;

--
-- Name: food_item_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_item_images_id_seq OWNED BY public.food_item_images.id;


--
-- Name: food_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_items (
    id integer NOT NULL,
    name character varying,
    description character varying,
    price double precision,
    available boolean,
    category_id integer,
    branch_id integer DEFAULT 1 NOT NULL,
    available_from_time character varying,
    available_to_time character varying,
    always_available boolean,
    time_wise_prices character varying,
    room_service_price double precision,
    extra_inventory_items character varying
);


ALTER TABLE public.food_items OWNER TO postgres;

--
-- Name: food_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.food_items_id_seq OWNER TO postgres;

--
-- Name: food_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_items_id_seq OWNED BY public.food_items.id;


--
-- Name: food_order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_order_items (
    id integer NOT NULL,
    order_id integer,
    food_item_id integer,
    quantity integer,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.food_order_items OWNER TO postgres;

--
-- Name: food_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.food_order_items_id_seq OWNER TO postgres;

--
-- Name: food_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_order_items_id_seq OWNED BY public.food_order_items.id;


--
-- Name: food_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_orders (
    id integer NOT NULL,
    room_id integer,
    amount double precision,
    booking_id integer,
    package_booking_id integer,
    assigned_employee_id integer,
    status character varying,
    billing_status character varying,
    order_type character varying,
    delivery_request character varying,
    payment_method character varying,
    payment_time timestamp without time zone,
    gst_amount double precision,
    total_with_gst double precision,
    is_deleted boolean NOT NULL,
    created_by_id integer,
    prepared_by_id integer,
    created_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.food_orders OWNER TO postgres;

--
-- Name: food_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.food_orders_id_seq OWNER TO postgres;

--
-- Name: food_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_orders_id_seq OWNED BY public.food_orders.id;


--
-- Name: gallery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gallery (
    id integer NOT NULL,
    image_url character varying(255),
    caption character varying(255),
    is_active boolean,
    branch_id integer
);


ALTER TABLE public.gallery OWNER TO postgres;

--
-- Name: gallery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gallery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gallery_id_seq OWNER TO postgres;

--
-- Name: gallery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gallery_id_seq OWNED BY public.gallery.id;


--
-- Name: guest_suggestions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.guest_suggestions (
    id integer NOT NULL,
    guest_name character varying(100) NOT NULL,
    contact_info character varying(100),
    suggestion text NOT NULL,
    status character varying(50),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.guest_suggestions OWNER TO postgres;

--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.guest_suggestions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.guest_suggestions_id_seq OWNER TO postgres;

--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.guest_suggestions_id_seq OWNED BY public.guest_suggestions.id;


--
-- Name: header_banner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.header_banner (
    id integer NOT NULL,
    title character varying(255),
    subtitle text,
    image_url character varying(255),
    is_active boolean,
    branch_id integer
);


ALTER TABLE public.header_banner OWNER TO postgres;

--
-- Name: header_banner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.header_banner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.header_banner_id_seq OWNER TO postgres;

--
-- Name: header_banner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.header_banner_id_seq OWNED BY public.header_banner.id;


--
-- Name: inter_branch_transfers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inter_branch_transfers (
    id integer NOT NULL,
    transfer_number character varying NOT NULL,
    item_id integer NOT NULL,
    quantity double precision NOT NULL,
    source_branch_id integer NOT NULL,
    destination_branch_id integer NOT NULL,
    source_location_id integer NOT NULL,
    destination_location_id integer,
    status character varying NOT NULL,
    notes text,
    created_by integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.inter_branch_transfers OWNER TO postgres;

--
-- Name: inter_branch_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inter_branch_transfers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inter_branch_transfers_id_seq OWNER TO postgres;

--
-- Name: inter_branch_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inter_branch_transfers_id_seq OWNED BY public.inter_branch_transfers.id;


--
-- Name: inventory_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    parent_department character varying,
    gst_tax_rate double precision NOT NULL,
    classification character varying,
    hsn_sac_code character varying,
    default_gst_rate double precision NOT NULL,
    cess_percentage double precision NOT NULL,
    itc_eligibility character varying NOT NULL,
    is_capital_good boolean NOT NULL,
    is_perishable boolean NOT NULL,
    is_asset_fixed boolean NOT NULL,
    is_sellable boolean NOT NULL,
    track_laundry boolean NOT NULL,
    allow_partial_usage boolean NOT NULL,
    consumable_instant boolean NOT NULL,
    created_at timestamp without time zone,
    is_active boolean NOT NULL,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.inventory_categories OWNER TO postgres;

--
-- Name: inventory_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_categories_id_seq OWNER TO postgres;

--
-- Name: inventory_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_categories_id_seq OWNED BY public.inventory_categories.id;


--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_items (
    id integer NOT NULL,
    name character varying NOT NULL,
    item_code character varying,
    description text,
    category_id integer NOT NULL,
    sub_category character varying,
    hsn_code character varying,
    unit character varying NOT NULL,
    current_stock double precision NOT NULL,
    min_stock_level double precision NOT NULL,
    max_stock_level double precision,
    unit_price double precision NOT NULL,
    selling_price double precision,
    gst_rate double precision NOT NULL,
    location character varying,
    barcode character varying,
    image_path character varying,
    is_perishable boolean NOT NULL,
    track_serial_number boolean NOT NULL,
    is_sellable_to_guest boolean NOT NULL,
    track_laundry_cycle boolean NOT NULL,
    is_asset_fixed boolean NOT NULL,
    maintenance_schedule_days integer,
    complimentary_limit integer,
    ingredient_yield_percentage double precision,
    preferred_vendor_id integer,
    vendor_item_code character varying,
    lead_time_days integer,
    is_active boolean NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.inventory_items OWNER TO postgres;

--
-- Name: inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_items_id_seq OWNER TO postgres;

--
-- Name: inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_items_id_seq OWNED BY public.inventory_items.id;


--
-- Name: inventory_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_transactions (
    id integer NOT NULL,
    item_id integer NOT NULL,
    transaction_type character varying NOT NULL,
    quantity double precision NOT NULL,
    unit_price double precision,
    total_amount double precision,
    reference_number character varying,
    purchase_master_id integer,
    department character varying,
    notes text,
    created_by integer,
    source_location_id integer,
    destination_location_id integer,
    created_at timestamp without time zone NOT NULL,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.inventory_transactions OWNER TO postgres;

--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_transactions_id_seq OWNER TO postgres;

--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_transactions_id_seq OWNED BY public.inventory_transactions.id;


--
-- Name: journal_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journal_entries (
    id integer NOT NULL,
    entry_number character varying NOT NULL,
    entry_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_type character varying,
    reference_id integer,
    description text NOT NULL,
    total_amount double precision NOT NULL,
    created_by integer,
    notes text,
    is_reversed boolean,
    reversed_entry_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.journal_entries OWNER TO postgres;

--
-- Name: journal_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.journal_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.journal_entries_id_seq OWNER TO postgres;

--
-- Name: journal_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.journal_entries_id_seq OWNED BY public.journal_entries.id;


--
-- Name: journal_entry_lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journal_entry_lines (
    id integer NOT NULL,
    entry_id integer NOT NULL,
    debit_ledger_id integer,
    credit_ledger_id integer,
    amount double precision NOT NULL,
    description text,
    line_number integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.journal_entry_lines OWNER TO postgres;

--
-- Name: journal_entry_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.journal_entry_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.journal_entry_lines_id_seq OWNER TO postgres;

--
-- Name: journal_entry_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.journal_entry_lines_id_seq OWNED BY public.journal_entry_lines.id;


--
-- Name: laundry_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laundry_logs (
    id integer NOT NULL,
    item_id integer NOT NULL,
    source_location_id integer,
    room_number character varying,
    quantity double precision NOT NULL,
    status character varying NOT NULL,
    sent_at timestamp without time zone,
    washed_at timestamp without time zone,
    returned_at timestamp without time zone,
    created_by integer,
    notes text,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.laundry_logs OWNER TO postgres;

--
-- Name: laundry_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.laundry_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.laundry_logs_id_seq OWNER TO postgres;

--
-- Name: laundry_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.laundry_logs_id_seq OWNED BY public.laundry_logs.id;


--
-- Name: leaves; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leaves (
    id integer NOT NULL,
    employee_id integer,
    from_date date,
    to_date date,
    reason character varying,
    leave_type character varying,
    status character varying,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.leaves OWNER TO postgres;

--
-- Name: leaves_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leaves_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leaves_id_seq OWNER TO postgres;

--
-- Name: leaves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leaves_id_seq OWNED BY public.leaves.id;


--
-- Name: location_stocks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_stocks (
    id integer NOT NULL,
    location_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity double precision NOT NULL,
    last_updated timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.location_stocks OWNER TO postgres;

--
-- Name: location_stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_stocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.location_stocks_id_seq OWNER TO postgres;

--
-- Name: location_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.location_stocks_id_seq OWNED BY public.location_stocks.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    location_code character varying,
    name character varying NOT NULL,
    building character varying NOT NULL,
    floor character varying,
    room_area character varying NOT NULL,
    location_type character varying NOT NULL,
    parent_location_id integer,
    is_inventory_point boolean NOT NULL,
    description text,
    is_active boolean NOT NULL,
    created_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_seq OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: nearby_attraction_banners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nearby_attraction_banners (
    id integer NOT NULL,
    title character varying(255),
    subtitle text,
    image_url character varying(255),
    extra_images text,
    is_active boolean,
    map_link character varying(512),
    branch_id integer
);


ALTER TABLE public.nearby_attraction_banners OWNER TO postgres;

--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nearby_attraction_banners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nearby_attraction_banners_id_seq OWNER TO postgres;

--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nearby_attraction_banners_id_seq OWNED BY public.nearby_attraction_banners.id;


--
-- Name: nearby_attractions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nearby_attractions (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    extra_images text,
    is_active boolean,
    map_link character varying(512),
    branch_id integer
);


ALTER TABLE public.nearby_attractions OWNER TO postgres;

--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nearby_attractions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nearby_attractions_id_seq OWNER TO postgres;

--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nearby_attractions_id_seq OWNED BY public.nearby_attractions.id;


--
-- Name: night_charges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.night_charges (
    id integer NOT NULL,
    day_audit_id integer NOT NULL,
    booking_id integer,
    branch_id integer NOT NULL,
    business_date date NOT NULL,
    room_charge double precision,
    gst_rate_pct double precision,
    gst_amount double precision,
    total_charge double precision,
    is_reversed boolean,
    reversed_at timestamp with time zone,
    reversal_reason text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.night_charges OWNER TO postgres;

--
-- Name: night_charges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.night_charges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.night_charges_id_seq OWNER TO postgres;

--
-- Name: night_charges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.night_charges_id_seq OWNED BY public.night_charges.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    type public.notificationtype NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    is_read boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    read_at timestamp with time zone,
    entity_type character varying(50),
    entity_id integer,
    recipient_id integer,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: package_booking_rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.package_booking_rooms (
    id integer NOT NULL,
    package_booking_id integer,
    room_id integer,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.package_booking_rooms OWNER TO postgres;

--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.package_booking_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.package_booking_rooms_id_seq OWNER TO postgres;

--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.package_booking_rooms_id_seq OWNED BY public.package_booking_rooms.id;


--
-- Name: package_bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.package_bookings (
    id integer NOT NULL,
    display_id character varying,
    package_id integer,
    user_id integer,
    guest_name character varying NOT NULL,
    guest_email character varying,
    guest_mobile character varying,
    check_in date NOT NULL,
    check_out date NOT NULL,
    checked_in_at timestamp without time zone,
    checked_out_at timestamp without time zone,
    adults integer,
    children integer,
    id_card_image_url character varying,
    guest_photo_url character varying,
    num_rooms integer,
    status character varying,
    total_amount double precision,
    advance_deposit double precision,
    created_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL,
    food_preferences character varying,
    special_requests character varying,
    is_confirmed boolean DEFAULT false,
    confirmed_at timestamp without time zone,
    confirmation_notes character varying
);


ALTER TABLE public.package_bookings OWNER TO postgres;

--
-- Name: package_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.package_bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.package_bookings_id_seq OWNER TO postgres;

--
-- Name: package_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.package_bookings_id_seq OWNED BY public.package_bookings.id;


--
-- Name: package_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.package_images (
    id integer NOT NULL,
    package_id integer,
    image_url character varying NOT NULL
);


ALTER TABLE public.package_images OWNER TO postgres;

--
-- Name: package_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.package_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.package_images_id_seq OWNER TO postgres;

--
-- Name: package_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.package_images_id_seq OWNED BY public.package_images.id;


--
-- Name: packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.packages (
    id integer NOT NULL,
    title character varying NOT NULL,
    description character varying,
    price double precision NOT NULL,
    booking_type character varying,
    room_types character varying,
    status character varying,
    theme character varying,
    default_adults integer,
    default_children integer,
    max_stay_days integer,
    food_included character varying,
    food_timing character varying,
    complimentary character varying,
    created_at timestamp without time zone,
    branch_id integer NOT NULL
);


ALTER TABLE public.packages OWNER TO postgres;

--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.packages_id_seq OWNER TO postgres;

--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.packages_id_seq OWNED BY public.packages.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    booking_id integer,
    amount double precision,
    method character varying,
    status character varying,
    created_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL,
    package_booking_id integer
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: plan_weddings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan_weddings (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    extra_images text,
    is_active boolean,
    branch_id integer
);


ALTER TABLE public.plan_weddings OWNER TO postgres;

--
-- Name: plan_weddings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plan_weddings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plan_weddings_id_seq OWNER TO postgres;

--
-- Name: plan_weddings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plan_weddings_id_seq OWNED BY public.plan_weddings.id;


--
-- Name: pricing_calendar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pricing_calendar (
    id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    day_type character varying NOT NULL,
    description character varying
);


ALTER TABLE public.pricing_calendar OWNER TO postgres;

--
-- Name: pricing_calendar_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pricing_calendar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pricing_calendar_id_seq OWNER TO postgres;

--
-- Name: pricing_calendar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pricing_calendar_id_seq OWNED BY public.pricing_calendar.id;


--
-- Name: purchase_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_details (
    id integer NOT NULL,
    purchase_master_id integer NOT NULL,
    item_id integer NOT NULL,
    hsn_code character varying,
    quantity double precision NOT NULL,
    unit character varying NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    gst_rate numeric(5,2) NOT NULL,
    cgst_amount numeric(10,2) NOT NULL,
    sgst_amount numeric(10,2) NOT NULL,
    igst_amount numeric(10,2) NOT NULL,
    discount numeric(10,2) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    notes text
);


ALTER TABLE public.purchase_details OWNER TO postgres;

--
-- Name: purchase_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_details_id_seq OWNER TO postgres;

--
-- Name: purchase_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_details_id_seq OWNED BY public.purchase_details.id;


--
-- Name: purchase_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_masters (
    id integer NOT NULL,
    purchase_number character varying NOT NULL,
    vendor_id integer NOT NULL,
    purchase_date date NOT NULL,
    expected_delivery_date date,
    invoice_number character varying,
    invoice_date date,
    bill_file_url character varying,
    gst_number character varying,
    payment_terms character varying,
    payment_status character varying NOT NULL,
    payment_method character varying,
    sub_total numeric(10,2) NOT NULL,
    cgst numeric(10,2) NOT NULL,
    sgst numeric(10,2) NOT NULL,
    igst numeric(10,2) NOT NULL,
    discount numeric(10,2) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    notes text,
    status character varying NOT NULL,
    destination_location_id integer,
    created_by integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.purchase_masters OWNER TO postgres;

--
-- Name: purchase_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_masters_id_seq OWNER TO postgres;

--
-- Name: purchase_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_masters_id_seq OWNED BY public.purchase_masters.id;


--
-- Name: rate_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rate_plans (
    id integer NOT NULL,
    name character varying NOT NULL,
    room_type_id integer,
    occupancy integer,
    meal_plan character varying,
    channel_manager_id character varying,
    base_price double precision,
    weekend_price double precision,
    price_offset double precision,
    branch_id integer NOT NULL
);


ALTER TABLE public.rate_plans OWNER TO postgres;

--
-- Name: rate_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rate_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rate_plans_id_seq OWNER TO postgres;

--
-- Name: rate_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rate_plans_id_seq OWNED BY public.rate_plans.id;


--
-- Name: recipe_ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe_ingredients (
    id integer NOT NULL,
    recipe_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    quantity double precision NOT NULL,
    unit character varying NOT NULL,
    notes character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.recipe_ingredients OWNER TO postgres;

--
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipe_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_ingredients_id_seq OWNER TO postgres;

--
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipe_ingredients_id_seq OWNED BY public.recipe_ingredients.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipes (
    id integer NOT NULL,
    food_item_id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    servings integer,
    prep_time_minutes integer,
    cook_time_minutes integer,
    branch_id integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.recipes OWNER TO postgres;

--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_id_seq OWNER TO postgres;

--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: resort_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resort_info (
    id integer NOT NULL,
    name character varying(255),
    address text,
    facebook character varying(255),
    instagram character varying(255),
    twitter character varying(255),
    linkedin character varying(255),
    is_active boolean,
    branch_id integer
);


ALTER TABLE public.resort_info OWNER TO postgres;

--
-- Name: resort_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resort_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resort_info_id_seq OWNER TO postgres;

--
-- Name: resort_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resort_info_id_seq OWNED BY public.resort_info.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    name character varying(100),
    comment text,
    rating integer,
    is_active boolean,
    branch_id integer
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying,
    permissions text,
    branch_id integer
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: room_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.room_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    total_inventory integer,
    base_price double precision,
    weekend_price double precision,
    long_weekend_price double precision,
    holiday_price double precision,
    adults_capacity integer,
    children_capacity integer,
    channel_manager_id character varying,
    branch_id integer DEFAULT 1 NOT NULL,
    air_conditioning boolean,
    wifi boolean,
    bathroom boolean,
    image_url character varying,
    extra_images character varying,
    living_area boolean,
    terrace boolean,
    parking boolean,
    kitchen boolean,
    family_room boolean,
    bbq boolean,
    garden boolean,
    dining boolean,
    breakfast boolean,
    tv boolean,
    balcony boolean,
    mountain_view boolean,
    ocean_view boolean,
    private_pool boolean,
    hot_tub boolean,
    fireplace boolean,
    pet_friendly boolean,
    wheelchair_accessible boolean,
    safe_box boolean,
    room_service boolean,
    laundry_service boolean,
    gym_access boolean,
    spa_access boolean,
    housekeeping boolean,
    mini_bar boolean,
    online_inventory integer
);


ALTER TABLE public.room_types OWNER TO postgres;

--
-- Name: room_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.room_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.room_types_id_seq OWNER TO postgres;

--
-- Name: room_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.room_types_id_seq OWNED BY public.room_types.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    id integer NOT NULL,
    number character varying NOT NULL,
    room_type_id integer,
    status character varying,
    housekeeping_status character varying,
    housekeeping_updated_at timestamp without time zone,
    last_maintenance_date date,
    image_url character varying,
    extra_images character varying,
    inventory_location_id integer,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rooms_id_seq OWNER TO postgres;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: salary_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salary_payments (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    month character varying NOT NULL,
    year integer NOT NULL,
    month_number integer NOT NULL,
    basic_salary double precision NOT NULL,
    allowances double precision,
    deductions double precision,
    net_salary double precision NOT NULL,
    payment_date date,
    payment_method character varying,
    payment_status character varying,
    created_at timestamp without time zone,
    notes character varying,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.salary_payments OWNER TO postgres;

--
-- Name: salary_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salary_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salary_payments_id_seq OWNER TO postgres;

--
-- Name: salary_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.salary_payments_id_seq OWNED BY public.salary_payments.id;


--
-- Name: service_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_images (
    id integer NOT NULL,
    service_id integer,
    image_url character varying NOT NULL
);


ALTER TABLE public.service_images OWNER TO postgres;

--
-- Name: service_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_images_id_seq OWNER TO postgres;

--
-- Name: service_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_images_id_seq OWNED BY public.service_images.id;


--
-- Name: service_inventory_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_inventory_items (
    service_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    quantity double precision NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.service_inventory_items OWNER TO postgres;

--
-- Name: service_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_requests (
    id integer NOT NULL,
    food_order_id integer,
    room_id integer NOT NULL,
    employee_id integer,
    request_type character varying,
    description text,
    status character varying,
    billing_status character varying,
    refill_data text,
    image_path character varying,
    created_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    pickup_location_id integer
);


ALTER TABLE public.service_requests OWNER TO postgres;

--
-- Name: service_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_requests_id_seq OWNER TO postgres;

--
-- Name: service_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_requests_id_seq OWNED BY public.service_requests.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    charges double precision NOT NULL,
    gst_rate double precision,
    is_visible_to_guest boolean NOT NULL,
    average_completion_time character varying,
    branch_id integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_id_seq OWNER TO postgres;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: signature_experiences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.signature_experiences (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    extra_images text,
    is_active boolean,
    branch_id integer
);


ALTER TABLE public.signature_experiences OWNER TO postgres;

--
-- Name: signature_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.signature_experiences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.signature_experiences_id_seq OWNER TO postgres;

--
-- Name: signature_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.signature_experiences_id_seq OWNED BY public.signature_experiences.id;


--
-- Name: stock_issue_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_issue_details (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    item_id integer NOT NULL,
    issued_quantity double precision NOT NULL,
    batch_lot_number character varying,
    unit character varying NOT NULL,
    unit_price double precision,
    cost double precision,
    notes text,
    is_payable boolean,
    is_paid boolean,
    rental_price double precision,
    is_damaged boolean,
    damage_notes text
);


ALTER TABLE public.stock_issue_details OWNER TO postgres;

--
-- Name: stock_issue_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_issue_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_issue_details_id_seq OWNER TO postgres;

--
-- Name: stock_issue_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stock_issue_details_id_seq OWNED BY public.stock_issue_details.id;


--
-- Name: stock_issues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_issues (
    id integer NOT NULL,
    issue_number character varying NOT NULL,
    requisition_id integer,
    issued_by integer NOT NULL,
    source_location_id integer,
    destination_location_id integer,
    issue_date timestamp without time zone NOT NULL,
    notes text,
    booking_id integer,
    guest_id integer,
    created_at timestamp without time zone NOT NULL,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.stock_issues OWNER TO postgres;

--
-- Name: stock_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_issues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_issues_id_seq OWNER TO postgres;

--
-- Name: stock_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stock_issues_id_seq OWNED BY public.stock_issues.id;


--
-- Name: stock_requisition_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_requisition_details (
    id integer NOT NULL,
    requisition_id integer NOT NULL,
    item_id integer NOT NULL,
    requested_quantity double precision NOT NULL,
    approved_quantity double precision,
    unit character varying NOT NULL,
    notes text
);


ALTER TABLE public.stock_requisition_details OWNER TO postgres;

--
-- Name: stock_requisition_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_requisition_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_requisition_details_id_seq OWNER TO postgres;

--
-- Name: stock_requisition_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stock_requisition_details_id_seq OWNED BY public.stock_requisition_details.id;


--
-- Name: stock_requisitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_requisitions (
    id integer NOT NULL,
    requisition_number character varying NOT NULL,
    requested_by integer NOT NULL,
    destination_department character varying NOT NULL,
    date_needed date,
    priority character varying NOT NULL,
    status character varying NOT NULL,
    notes text,
    approved_by integer,
    approved_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.stock_requisitions OWNER TO postgres;

--
-- Name: stock_requisitions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_requisitions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_requisitions_id_seq OWNER TO postgres;

--
-- Name: stock_requisitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stock_requisitions_id_seq OWNED BY public.stock_requisitions.id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    description character varying(255),
    updated_at timestamp with time zone,
    branch_id integer
);


ALTER TABLE public.system_settings OWNER TO postgres;

--
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_id_seq OWNER TO postgres;

--
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying,
    email character varying,
    hashed_password character varying,
    phone character varying,
    is_active boolean,
    role_id integer,
    branch_id integer,
    is_superadmin boolean
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendors (
    id integer NOT NULL,
    name character varying NOT NULL,
    company_name character varying,
    gst_registration_type character varying,
    gst_number character varying,
    branch_id integer DEFAULT 1 NOT NULL,
    legal_name character varying,
    trade_name character varying,
    pan_number character varying,
    qmp_scheme boolean NOT NULL,
    msme_udyam_no character varying,
    contact_person character varying,
    email character varying,
    phone character varying,
    billing_address text,
    billing_state character varying,
    shipping_address text,
    distance_km double precision,
    address text,
    city character varying,
    state character varying,
    pincode character varying,
    country character varying,
    is_msme_registered boolean NOT NULL,
    tds_apply boolean NOT NULL,
    rcm_applicable boolean NOT NULL,
    payment_terms character varying,
    preferred_payment_method character varying,
    account_holder_name character varying,
    bank_name character varying,
    account_number character varying,
    ifsc_code character varying,
    branch_name character varying,
    upi_id character varying,
    upi_mobile_number character varying,
    notes text,
    is_active boolean NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.vendors OWNER TO postgres;

--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vendors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vendors_id_seq OWNER TO postgres;

--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vendors_id_seq OWNED BY public.vendors.id;


--
-- Name: vouchers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vouchers (
    id integer NOT NULL,
    code character varying,
    discount_percent double precision,
    expiry_date timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.vouchers OWNER TO postgres;

--
-- Name: vouchers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vouchers_id_seq OWNER TO postgres;

--
-- Name: vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vouchers_id_seq OWNED BY public.vouchers.id;


--
-- Name: waste_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.waste_logs (
    id integer NOT NULL,
    log_number character varying,
    item_id integer,
    food_item_id integer,
    is_food_item boolean NOT NULL,
    location_id integer,
    batch_number character varying,
    expiry_date date,
    quantity double precision NOT NULL,
    unit character varying NOT NULL,
    reason_code character varying NOT NULL,
    action_taken character varying,
    photo_path character varying,
    notes text,
    reported_by integer NOT NULL,
    waste_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    branch_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.waste_logs OWNER TO postgres;

--
-- Name: waste_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.waste_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.waste_logs_id_seq OWNER TO postgres;

--
-- Name: waste_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.waste_logs_id_seq OWNED BY public.waste_logs.id;


--
-- Name: working_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.working_logs (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    date date NOT NULL,
    check_in_time time without time zone,
    check_out_time time without time zone,
    location character varying,
    latitude double precision,
    longitude double precision,
    completed_tasks character varying,
    is_tasks_approved integer,
    tasks_approved_by_id integer,
    tasks_approved_at timestamp without time zone,
    branch_id integer DEFAULT 1 NOT NULL,
    clock_in_image text,
    clock_out_image text
);


ALTER TABLE public.working_logs OWNER TO postgres;

--
-- Name: working_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.working_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.working_logs_id_seq OWNER TO postgres;

--
-- Name: working_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.working_logs_id_seq OWNED BY public.working_logs.id;


--
-- Name: account_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_groups ALTER COLUMN id SET DEFAULT nextval('public.account_groups_id_seq'::regclass);


--
-- Name: account_ledgers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_ledgers ALTER COLUMN id SET DEFAULT nextval('public.account_ledgers_id_seq'::regclass);


--
-- Name: activity_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN id SET DEFAULT nextval('public.activity_logs_id_seq'::regclass);


--
-- Name: asset_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_mappings ALTER COLUMN id SET DEFAULT nextval('public.asset_mappings_id_seq'::regclass);


--
-- Name: asset_registry id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registry ALTER COLUMN id SET DEFAULT nextval('public.asset_registry_id_seq'::regclass);


--
-- Name: assigned_services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_services ALTER COLUMN id SET DEFAULT nextval('public.assigned_services_id_seq'::regclass);


--
-- Name: attendances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);


--
-- Name: booking_rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_rooms ALTER COLUMN id SET DEFAULT nextval('public.booking_rooms_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: branches id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);


--
-- Name: check_availability id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_availability ALTER COLUMN id SET DEFAULT nextval('public.check_availability_id_seq'::regclass);


--
-- Name: checkout_payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_payments ALTER COLUMN id SET DEFAULT nextval('public.checkout_payments_id_seq'::regclass);


--
-- Name: checkout_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_requests ALTER COLUMN id SET DEFAULT nextval('public.checkout_requests_id_seq'::regclass);


--
-- Name: checkout_verifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_verifications ALTER COLUMN id SET DEFAULT nextval('public.checkout_verifications_id_seq'::regclass);


--
-- Name: checkouts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkouts ALTER COLUMN id SET DEFAULT nextval('public.checkouts_id_seq'::regclass);


--
-- Name: day_audits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_audits ALTER COLUMN id SET DEFAULT nextval('public.day_audits_id_seq'::regclass);


--
-- Name: employee_inventory_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_inventory_assignments ALTER COLUMN id SET DEFAULT nextval('public.employee_inventory_assignments_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses ALTER COLUMN id SET DEFAULT nextval('public.expenses_id_seq'::regclass);


--
-- Name: food_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_categories ALTER COLUMN id SET DEFAULT nextval('public.food_categories_id_seq'::regclass);


--
-- Name: food_item_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_item_images ALTER COLUMN id SET DEFAULT nextval('public.food_item_images_id_seq'::regclass);


--
-- Name: food_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_items ALTER COLUMN id SET DEFAULT nextval('public.food_items_id_seq'::regclass);


--
-- Name: food_order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_order_items ALTER COLUMN id SET DEFAULT nextval('public.food_order_items_id_seq'::regclass);


--
-- Name: food_orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders ALTER COLUMN id SET DEFAULT nextval('public.food_orders_id_seq'::regclass);


--
-- Name: gallery id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery ALTER COLUMN id SET DEFAULT nextval('public.gallery_id_seq'::regclass);


--
-- Name: guest_suggestions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_suggestions ALTER COLUMN id SET DEFAULT nextval('public.guest_suggestions_id_seq'::regclass);


--
-- Name: header_banner id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.header_banner ALTER COLUMN id SET DEFAULT nextval('public.header_banner_id_seq'::regclass);


--
-- Name: inter_branch_transfers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inter_branch_transfers ALTER COLUMN id SET DEFAULT nextval('public.inter_branch_transfers_id_seq'::regclass);


--
-- Name: inventory_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_categories ALTER COLUMN id SET DEFAULT nextval('public.inventory_categories_id_seq'::regclass);


--
-- Name: inventory_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items ALTER COLUMN id SET DEFAULT nextval('public.inventory_items_id_seq'::regclass);


--
-- Name: inventory_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions ALTER COLUMN id SET DEFAULT nextval('public.inventory_transactions_id_seq'::regclass);


--
-- Name: journal_entries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entries ALTER COLUMN id SET DEFAULT nextval('public.journal_entries_id_seq'::regclass);


--
-- Name: journal_entry_lines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entry_lines ALTER COLUMN id SET DEFAULT nextval('public.journal_entry_lines_id_seq'::regclass);


--
-- Name: laundry_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laundry_logs ALTER COLUMN id SET DEFAULT nextval('public.laundry_logs_id_seq'::regclass);


--
-- Name: leaves id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaves ALTER COLUMN id SET DEFAULT nextval('public.leaves_id_seq'::regclass);


--
-- Name: location_stocks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_stocks ALTER COLUMN id SET DEFAULT nextval('public.location_stocks_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: nearby_attraction_banners id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nearby_attraction_banners ALTER COLUMN id SET DEFAULT nextval('public.nearby_attraction_banners_id_seq'::regclass);


--
-- Name: nearby_attractions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nearby_attractions ALTER COLUMN id SET DEFAULT nextval('public.nearby_attractions_id_seq'::regclass);


--
-- Name: night_charges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.night_charges ALTER COLUMN id SET DEFAULT nextval('public.night_charges_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: package_booking_rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_booking_rooms ALTER COLUMN id SET DEFAULT nextval('public.package_booking_rooms_id_seq'::regclass);


--
-- Name: package_bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_bookings ALTER COLUMN id SET DEFAULT nextval('public.package_bookings_id_seq'::regclass);


--
-- Name: package_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_images ALTER COLUMN id SET DEFAULT nextval('public.package_images_id_seq'::regclass);


--
-- Name: packages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packages ALTER COLUMN id SET DEFAULT nextval('public.packages_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: plan_weddings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_weddings ALTER COLUMN id SET DEFAULT nextval('public.plan_weddings_id_seq'::regclass);


--
-- Name: pricing_calendar id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing_calendar ALTER COLUMN id SET DEFAULT nextval('public.pricing_calendar_id_seq'::regclass);


--
-- Name: purchase_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_details ALTER COLUMN id SET DEFAULT nextval('public.purchase_details_id_seq'::regclass);


--
-- Name: purchase_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_masters ALTER COLUMN id SET DEFAULT nextval('public.purchase_masters_id_seq'::regclass);


--
-- Name: rate_plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate_plans ALTER COLUMN id SET DEFAULT nextval('public.rate_plans_id_seq'::regclass);


--
-- Name: recipe_ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients ALTER COLUMN id SET DEFAULT nextval('public.recipe_ingredients_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: resort_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resort_info ALTER COLUMN id SET DEFAULT nextval('public.resort_info_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: room_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_types ALTER COLUMN id SET DEFAULT nextval('public.room_types_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: salary_payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_payments ALTER COLUMN id SET DEFAULT nextval('public.salary_payments_id_seq'::regclass);


--
-- Name: service_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_images ALTER COLUMN id SET DEFAULT nextval('public.service_images_id_seq'::regclass);


--
-- Name: service_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests ALTER COLUMN id SET DEFAULT nextval('public.service_requests_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: signature_experiences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signature_experiences ALTER COLUMN id SET DEFAULT nextval('public.signature_experiences_id_seq'::regclass);


--
-- Name: stock_issue_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issue_details ALTER COLUMN id SET DEFAULT nextval('public.stock_issue_details_id_seq'::regclass);


--
-- Name: stock_issues id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issues ALTER COLUMN id SET DEFAULT nextval('public.stock_issues_id_seq'::regclass);


--
-- Name: stock_requisition_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisition_details ALTER COLUMN id SET DEFAULT nextval('public.stock_requisition_details_id_seq'::regclass);


--
-- Name: stock_requisitions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisitions ALTER COLUMN id SET DEFAULT nextval('public.stock_requisitions_id_seq'::regclass);


--
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors ALTER COLUMN id SET DEFAULT nextval('public.vendors_id_seq'::regclass);


--
-- Name: vouchers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vouchers ALTER COLUMN id SET DEFAULT nextval('public.vouchers_id_seq'::regclass);


--
-- Name: waste_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waste_logs ALTER COLUMN id SET DEFAULT nextval('public.waste_logs_id_seq'::regclass);


--
-- Name: working_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.working_logs ALTER COLUMN id SET DEFAULT nextval('public.working_logs_id_seq'::regclass);


--
-- Data for Name: account_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_groups (id, name, account_type, description, is_active, created_at, updated_at, branch_id) FROM stdin;
\.


--
-- Data for Name: account_ledgers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_ledgers (id, name, code, group_id, module, description, opening_balance, balance_type, is_active, tax_type, tax_rate, bank_name, account_number, ifsc_code, branch_name, created_at, updated_at, branch_id) FROM stdin;
\.


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (id, action, method, path, status_code, client_ip, user_id, details, "timestamp", branch_id) FROM stdin;
18600	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 18.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:13.909028+00	1
18601	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 34.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:13.920951+00	1
18602	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 10.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:26:14.216047+00	1
18603	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 15.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:26:14.261102+00	1
18604	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 11.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:14.525697+00	1
18605	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 15.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:14.536025+00	1
18606	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 12.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:26:14.578298+00	1
18607	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 15.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:14.770181+00	1
18608	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 15.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:26:14.776496+00	1
18609	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:26:15.09878+00	1
18610	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 20.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:24.21006+00	1
18611	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 23.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117183621"}	2026-05-07 01:26:24.219645+00	1
18612	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 40.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:26:32.187073+00	1
18613	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 50.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:26:32.196881+00	1
18614	Viewed/List Expenses	GET	/api/expenses	200	152.58.216.49	1	{"process_time_ms": 40.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:26:32.202598+00	1
18615	Viewed/List Rooms	GET	/api/rooms	200	152.58.216.49	1	{"process_time_ms": 60.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:26:32.207521+00	1
18616	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 66.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:32.216749+00	1
18617	Viewed/List Assigned	GET	/api/services/assigned	200	152.58.216.49	1	{"process_time_ms": 67.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:26:32.609382+00	1
18618	Viewed/List Food Items	GET	/api/food-items	200	152.58.216.49	1	{"process_time_ms": 83.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:26:32.61521+00	1
18619	Viewed/List Services	GET	/api/services	200	152.58.216.49	1	{"process_time_ms": 98.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:26:32.624702+00	1
18620	Viewed/List Food Orders	GET	/api/food-orders	200	152.58.216.49	1	{"process_time_ms": 93.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:26:32.632884+00	1
18621	Viewed/List Categories	GET	/api/inventory/categories	200	152.58.216.49	1	{"process_time_ms": 58.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:26:33.030083+00	1
18622	Viewed/List Packages	GET	/api/packages	200	152.58.216.49	1	{"process_time_ms": 70.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:26:33.043964+00	1
18623	Viewed/List Employees	GET	/api/employees	200	152.58.216.49	1	{"process_time_ms": 86.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:26:33.053777+00	1
18624	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 86.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:26:33.061411+00	1
18625	Viewed/List Checkouts	GET	/api/bill/checkouts	200	152.58.216.49	1	{"process_time_ms": 100.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:26:33.094326+00	1
18626	Viewed/List Summary	GET	/api/dashboard/summary	200	152.58.216.49	1	{"process_time_ms": 204.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-07 01:26:33.17977+00	1
18627	Viewed/List Kpis	GET	/api/dashboard/kpis	200	152.58.216.49	1	{"process_time_ms": 28.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:33.414236+00	1
18631	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 65.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:26:43.559541+00	1
18628	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 31.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:43.51882+00	1
18629	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 54.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:43.541424+00	1
18633	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 77.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:43.570326+00	1
18630	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 46.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:26:43.547132+00	1
18632	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 74.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:43.562912+00	1
18636	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:26:44.153772+00	1
18634	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 11.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:26:43.836499+00	1
18635	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 8.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:26:43.851179+00	1
18637	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 13.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:45.558766+00	1
18638	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 20.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117204975"}	2026-05-07 01:26:45.566068+00	1
18639	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 30.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:53.40416+00	1
18640	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 42.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:53.409787+00	1
18641	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 43.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:26:53.41637+00	1
18642	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 52.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:26:53.419654+00	1
18643	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 59.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:53.425225+00	1
18644	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 47.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:53.434701+00	1
18645	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 13.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:53.719213+00	1
18646	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 18.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:26:53.732975+00	1
18647	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 8.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:26:53.764272+00	1
18648	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:26:54.079089+00	1
18649	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 15.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:26:55.281424+00	1
18650	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 18.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117214701"}	2026-05-07 01:26:55.289789+00	1
18651	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 61.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:27:10.152073+00	1
18652	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 73.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:10.162544+00	1
18653	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 78.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:27:10.17276+00	1
18654	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 72.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:10.17584+00	1
18655	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 93.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:10.179746+00	1
18656	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 92.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:10.18647+00	1
18657	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 9.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:10.459175+00	1
18658	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 10.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:27:10.476007+00	1
18659	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 11.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:27:10.50116+00	1
18660	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:27:10.818368+00	1
18661	Viewed/List 	GET	/api/food-items/	200	152.58.216.49	1	{"process_time_ms": 27.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:17.895772+00	1
18669	Viewed/List 	GET	/api/gallery/	200	152.58.216.49	1	{"process_time_ms": 9.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:33.044742+00	1
18683	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:30:42.077933+00	1
18690	Viewed/List 	GET	/api/reviews/	200	152.58.216.49	\N	{"process_time_ms": 45.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468909"}	2026-05-07 01:31:09.536264+00	1
18662	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 30.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117237293"}	2026-05-07 01:27:17.902467+00	1
18673	Viewed/List 	GET	/api/nearby-attractions/	200	152.58.216.49	1	{"process_time_ms": 38.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:33.112355+00	1
18685	Viewed/List Branches	GET	/api/public/branches	200	152.58.216.49	\N	{"process_time_ms": 11.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:31:07.461019+00	1
18699	Viewed/List 	GET	/api/plan-weddings/	200	152.58.216.49	\N	{"process_time_ms": 19.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468910"}	2026-05-07 01:31:09.88836+00	1
18663	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 44.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:17.91082+00	1
18678	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 54.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:41.441937+00	1
18681	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 13.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:30:41.742702+00	1
18694	Viewed/List 	GET	/api/gallery/	200	152.58.216.49	\N	{"process_time_ms": 48.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468908"}	2026-05-07 01:31:09.550189+00	1
18698	Viewed/List 	GET	/api/nearby-attraction-banners/	200	152.58.216.49	\N	{"process_time_ms": 14.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468911"}	2026-05-07 01:31:09.885418+00	1
18664	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 47.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:17.917082+00	1
18667	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 11.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:32.577517+00	1
18670	Viewed/List 	GET	/api/reviews/	200	152.58.216.49	1	{"process_time_ms": 34.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:33.095621+00	1
18677	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 48.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:41.434667+00	1
18837	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 41.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:16:55.420126+00	1
18686	Viewed/List Bookings	GET	/api/public/bookings	200	152.58.216.49	\N	{"process_time_ms": 13.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778117467863"}	2026-05-07 01:31:08.438198+00	1
18665	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 14.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117238531"}	2026-05-07 01:27:19.120687+00	1
18666	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 19.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:27:19.12476+00	1
18668	Viewed/List 	GET	/api/header-banner/	200	152.58.216.49	1	{"process_time_ms": 9.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:32.894504+00	1
18672	Viewed/List 	GET	/api/signature-experiences/	200	152.58.216.49	1	{"process_time_ms": 34.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:33.103106+00	1
18674	Viewed/List 	GET	/api/nearby-attraction-banners/	200	152.58.216.49	1	{"process_time_ms": 9.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:33.21462+00	1
18675	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 30.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:30:41.425003+00	1
18676	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 40.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:30:41.430877+00	1
18679	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 64.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:41.451158+00	1
18680	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 61.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:41.454313+00	1
18682	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 19.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:30:41.753463+00	1
18684	Viewed/List Rooms	GET	/api/public/rooms	200	152.58.216.49	\N	{"process_time_ms": 11.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117466876"}	2026-05-07 01:31:07.456381+00	1
18692	Viewed/List Food Categories	GET	/api/public/food-categories	200	152.58.216.49	\N	{"process_time_ms": 41.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468907"}	2026-05-07 01:31:09.543105+00	1
18695	Viewed/List 	GET	/api/signature-experiences/	200	152.58.216.49	\N	{"process_time_ms": 9.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468910"}	2026-05-07 01:31:09.847372+00	1
18696	Viewed/List Services	GET	/api/public/services	200	152.58.216.49	\N	{"process_time_ms": 15.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468909"}	2026-05-07 01:31:09.851113+00	1
18671	Viewed/List 	GET	/api/plan-weddings/	200	152.58.216.49	1	{"process_time_ms": 30.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:30:33.099286+00	1
18688	Viewed/List 	GET	/api/resort-info/	200	152.58.216.49	\N	{"process_time_ms": 10.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468579"}	2026-05-07 01:31:09.155039+00	1
18691	Viewed/List 	GET	/api/header-banner/	200	152.58.216.49	\N	{"process_time_ms": 53.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468909"}	2026-05-07 01:31:09.539657+00	1
18687	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	152.58.216.49	\N	{"process_time_ms": 11.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778117468253"}	2026-05-07 01:31:08.835956+00	1
18689	Viewed/List Food Items	GET	/api/public/food-items	200	152.58.216.49	\N	{"process_time_ms": 38.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468906"}	2026-05-07 01:31:09.526887+00	1
18693	Viewed/List Packages	GET	/api/public/packages	200	152.58.216.49	\N	{"process_time_ms": 60.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468908"}	2026-05-07 01:31:09.54647+00	1
18697	Viewed/List 	GET	/api/nearby-attractions/	200	152.58.216.49	\N	{"process_time_ms": 13.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117468911"}	2026-05-07 01:31:09.877934+00	1
18700	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 16.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:32:39.009124+00	1
18701	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 39.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:32:39.027579+00	1
18702	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 9.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:32:39.319586+00	1
18703	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 9.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:32:39.335761+00	1
18704	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 8.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:32:39.569514+00	1
18705	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 22.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:32:39.633154+00	1
18706	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 18.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:32:39.645859+00	1
18707	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 14.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:32:39.865115+00	1
18708	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 15.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:32:39.872549+00	1
18709	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:32:40.193815+00	1
18710	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 30.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117562158"}	2026-05-07 01:32:42.758904+00	1
18711	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 39.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:32:42.765551+00	1
18712	Removed/Deleted 7	DELETE	/api/rooms/types/7	200	152.58.216.49	1	{"process_time_ms": 23.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:32:54.409676+00	1
18713	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 17.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:32:54.742702+00	1
18714	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 34.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:33:04.545661+00	1
18715	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 44.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:33:04.553559+00	1
18716	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 53.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:04.561548+00	1
18717	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 61.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:04.577873+00	1
18718	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 73.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:04.585459+00	1
18719	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 73.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:04.589287+00	1
18720	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 18.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:33:04.880396+00	1
18721	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 25.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:33:04.892199+00	1
18722	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 24.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:04.895733+00	1
18728	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 23.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117612371"}	2026-05-07 01:33:32.970259+00	1
18740	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 18.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:38.364624+00	1
18742	Viewed/List 	GET	/api/header-banner/	200	152.58.216.49	1	{"process_time_ms": 20.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:06.126384+00	1
18747	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 46.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:06.159767+00	1
18755	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 55.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.623204+00	1
18764	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 48.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.356845+00	1
18723	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:33:05.214147+00	1
18726	Removed/Deleted 5	DELETE	/api/rooms/types/5	200	152.58.216.49	1	{"process_time_ms": 18.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:17.804431+00	1
18729	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 27.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:32.974705+00	1
18730	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 38.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:36.588926+00	1
18734	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 76.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:36.622147+00	1
18738	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 17.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:33:36.932566+00	1
18745	Viewed/List 	GET	/api/plan-weddings/	200	152.58.216.49	1	{"process_time_ms": 42.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:06.149992+00	1
18751	Viewed/List 	GET	/api/reviews/	200	152.58.216.49	1	{"process_time_ms": 29.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.602932+00	1
18724	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 20.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:06.707912+00	1
18736	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 9.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:36.901133+00	1
18749	Viewed/List 	GET	/api/nearby-attraction-banners/	200	152.58.216.49	1	{"process_time_ms": 13.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:06.459368+00	1
18761	Viewed/List 	GET	/api/signature-experiences/	200	152.58.216.49	1	{"process_time_ms": 35.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.338687+00	1
18725	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 25.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117586103"}	2026-05-07 01:33:06.711432+00	1
18737	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 17.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:33:36.928875+00	1
18741	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 21.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117617778"}	2026-05-07 01:33:38.371985+00	1
18744	Viewed/List 	GET	/api/gallery/	200	152.58.216.49	1	{"process_time_ms": 31.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:06.135472+00	1
18750	Viewed/List 	GET	/api/header-banner/	200	152.58.216.49	1	{"process_time_ms": 19.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.591201+00	1
18752	Viewed/List 	GET	/api/signature-experiences/	200	152.58.216.49	1	{"process_time_ms": 35.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.60651+00	1
18756	Viewed/List 	GET	/api/plan-weddings/	200	152.58.216.49	1	{"process_time_ms": 5.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.892147+00	1
18766	Viewed/List 	GET	/api/nearby-attraction-banners/	200	152.58.216.49	1	{"process_time_ms": 10.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.641383+00	1
18727	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 14.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:18.109971+00	1
18733	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 50.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:36.6149+00	1
18743	Viewed/List 	GET	/api/signature-experiences/	200	152.58.216.49	1	{"process_time_ms": 29.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:06.130807+00	1
18753	Viewed/List 	GET	/api/gallery/	200	152.58.216.49	1	{"process_time_ms": 36.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.60982+00	1
18759	Viewed/List 	GET	/api/reviews/	200	152.58.216.49	1	{"process_time_ms": 21.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.324882+00	1
18762	Viewed/List 	GET	/api/plan-weddings/	200	152.58.216.49	1	{"process_time_ms": 34.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.344559+00	1
18731	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 46.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:33:36.595298+00	1
18735	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 64.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:33:36.627905+00	1
18739	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 10.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:33:37.261169+00	1
18746	Viewed/List 	GET	/api/reviews/	200	152.58.216.49	1	{"process_time_ms": 41.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:06.154061+00	1
18754	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 54.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.620088+00	1
18763	Viewed/List 	GET	/api/header-banner/	200	152.58.216.49	1	{"process_time_ms": 39.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.349191+00	1
18767	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 8.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.678496+00	1
18732	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 48.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:33:36.600601+00	1
18748	Viewed/List 	GET	/api/nearby-attractions/	200	152.58.216.49	1	{"process_time_ms": 7.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:06.455658+00	1
18758	Viewed/List 	GET	/api/nearby-attractions/	200	152.58.216.49	1	{"process_time_ms": 10.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.921583+00	1
18760	Viewed/List 	GET	/api/gallery/	200	152.58.216.49	1	{"process_time_ms": 29.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.334073+00	1
18757	Viewed/List 	GET	/api/nearby-attraction-banners/	200	152.58.216.49	1	{"process_time_ms": 8.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:10.917523+00	1
18765	Viewed/List 	GET	/api/nearby-attractions/	200	152.58.216.49	1	{"process_time_ms": 7.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:34:32.633667+00	1
18768	Viewed/List 	GET	/api/header-banner/	200	152.58.216.49	1	{"process_time_ms": 11.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:08.940873+00	1
18769	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 25.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:08.951949+00	1
18770	Viewed/List 	GET	/api/gallery/	200	152.58.216.49	1	{"process_time_ms": 6.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:09.251503+00	1
18771	Viewed/List 	GET	/api/reviews/	200	152.58.216.49	1	{"process_time_ms": 5.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:09.270549+00	1
18772	Viewed/List 	GET	/api/signature-experiences/	200	152.58.216.49	1	{"process_time_ms": 5.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:09.534301+00	1
18773	Viewed/List 	GET	/api/plan-weddings/	200	152.58.216.49	1	{"process_time_ms": 8.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:09.576736+00	1
18774	Viewed/List 	GET	/api/nearby-attractions/	200	152.58.216.49	1	{"process_time_ms": 10.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:09.580853+00	1
18775	Viewed/List 	GET	/api/nearby-attraction-banners/	200	152.58.216.49	1	{"process_time_ms": 8.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:09.83188+00	1
18776	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 19.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:09.839893+00	1
18777	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 34.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:38.775368+00	1
18778	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 44.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:37:38.792532+00	1
18779	Viewed/List Expenses	GET	/api/expenses	200	152.58.216.49	1	{"process_time_ms": 43.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:37:38.796464+00	1
18780	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 51.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:37:38.804307+00	1
18781	Viewed/List Rooms	GET	/api/rooms	200	152.58.216.49	1	{"process_time_ms": 61.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:37:38.807732+00	1
18782	Viewed/List Food Items	GET	/api/food-items	200	152.58.216.49	1	{"process_time_ms": 66.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:37:39.195868+00	1
18783	Viewed/List Assigned	GET	/api/services/assigned	200	152.58.216.49	1	{"process_time_ms": 74.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:37:39.2049+00	1
18784	Viewed/List Services	GET	/api/services	200	152.58.216.49	1	{"process_time_ms": 75.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:37:39.208578+00	1
18785	Viewed/List Food Orders	GET	/api/food-orders	200	152.58.216.49	1	{"process_time_ms": 87.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:37:39.211835+00	1
18786	Viewed/List Checkouts	GET	/api/bill/checkouts	200	152.58.216.49	1	{"process_time_ms": 38.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:37:39.567195+00	1
18787	Viewed/List Packages	GET	/api/packages	200	152.58.216.49	1	{"process_time_ms": 58.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:37:39.59206+00	1
18788	Viewed/List Categories	GET	/api/inventory/categories	200	152.58.216.49	1	{"process_time_ms": 69.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 01:37:39.599155+00	1
18789	Viewed/List Employees	GET	/api/employees	200	152.58.216.49	1	{"process_time_ms": 78.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:37:39.604577+00	1
18790	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 87.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 01:37:39.626793+00	1
18791	Viewed/List Summary	GET	/api/dashboard/summary	200	152.58.216.49	1	{"process_time_ms": 171.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-07 01:37:39.700982+00	1
18792	Viewed/List Kpis	GET	/api/dashboard/kpis	200	152.58.216.49	1	{"process_time_ms": 22.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:39.907234+00	1
18793	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 33.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:42.538746+00	1
18794	Viewed/List Employees	GET	/api/employees	200	152.58.216.49	1	{"process_time_ms": 37.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-07 01:37:42.554158+00	1
18801	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 45.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:45.536761+00	1
18804	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 17.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:37:45.864707+00	1
18807	Viewed/List 	GET	/api/food-items/	200	152.58.216.49	1	{"process_time_ms": 22.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:53.511992+00	1
18825	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 22.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117916426"}	2026-05-07 01:38:37.030651+00	1
18831	Updated/Modified 1	PUT	/api/rooms/types/1	200	152.58.216.49	1	{"process_time_ms": 801.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:41:53.949156+00	1
18795	Viewed/List Summary	GET	/api/dashboard/summary	200	152.58.216.49	1	{"process_time_ms": 41.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-07 01:37:42.558199+00	1
18800	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 46.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:45.531625+00	1
18816	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 60.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:38:11.211958+00	1
18796	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 56.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:42.566887+00	1
18803	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 71.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:45.561316+00	1
18817	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 75.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:38:11.222496+00	1
18797	Viewed/List Rooms	GET	/api/rooms	200	152.58.216.49	1	{"process_time_ms": 56.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-07 01:37:42.573113+00	1
18798	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 35.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:37:45.520752+00	1
18802	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 65.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:45.555268+00	1
18819	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 10.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:38:11.495325+00	1
18826	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 25.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:38:37.033977+00	1
18838	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 50.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:16:55.429597+00	1
18829	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 16.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778118082826"}	2026-05-07 01:41:24.061661+00	1
18799	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 31.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:37:45.527374+00	1
18820	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 14.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 01:38:11.52148+00	1
18824	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 28.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117892966"}	2026-05-07 01:38:13.576204+00	1
18830	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 14.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:41:24.281393+00	1
18832	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 13.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:41:54.320073+00	1
18805	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 18.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 01:37:45.868454+00	1
18808	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 32.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:53.521982+00	1
18811	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 21.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117881731"}	2026-05-07 01:38:02.331789+00	1
18823	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 20.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:38:13.569253+00	1
18806	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 9.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:37:46.196465+00	1
18810	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 44.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:37:53.536232+00	1
18815	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 48.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 01:38:11.199933+00	1
18828	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 26.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:39:08.51355+00	1
18809	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 39.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778117872914"}	2026-05-07 01:37:53.527802+00	1
18812	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 32.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:38:02.339912+00	1
18821	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 17.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:38:11.526435+00	1
18827	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 21.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778117947923"}	2026-05-07 01:39:08.510019+00	1
18813	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 32.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:38:11.179457+00	1
18814	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 40.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 01:38:11.193057+00	1
18818	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 66.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 01:38:11.226491+00	1
18822	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 01:38:11.835934+00	1
18833	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 106.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:16:54.613006+00	1
18834	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 94.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:16:55.040904+00	1
18835	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 32.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 02:16:55.105393+00	1
18836	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 15.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 02:16:55.366321+00	1
18839	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 56.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 02:16:55.452407+00	1
18840	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 78.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:16:55.460983+00	1
18841	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 56.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 02:16:55.46786+00	1
18842	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 10.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 02:16:55.798379+00	1
18843	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 23.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:17:00.552468+00	1
18844	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 38.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778120219578"}	2026-05-07 02:17:00.56605+00	1
18845	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 18.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778120270630"}	2026-05-07 02:17:52.184131+00	1
18846	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 14.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:17:52.441632+00	1
18847	Updated/Modified 3	PUT	/api/rooms/types/3	200	152.58.216.49	1	{"process_time_ms": 41.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:18:12.929797+00	1
18848	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 13.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:18:15.884873+00	1
18849	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 12.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:18:24.37908+00	1
18850	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 30.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:18:24.390279+00	1
18851	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 9.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 02:18:24.690686+00	1
18852	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 10.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 02:18:24.714872+00	1
18853	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 8.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:18:24.978714+00	1
18854	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 10.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:18:25.011178+00	1
18855	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 13.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:18:25.037785+00	1
18856	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 18.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 02:18:25.278917+00	1
18857	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 32.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 02:18:25.282763+00	1
18860	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 28.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:18:26.959205+00	1
18858	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 02:18:25.596134+00	1
18859	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 24.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778120305983"}	2026-05-07 02:18:26.951991+00	1
18861	Viewed/List Branches	GET	/api/public/branches	200	115.114.104.218	\N	{"process_time_ms": 79.08, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 02:54:12.188159+00	1
18862	Viewed/List Rooms	GET	/api/public/rooms	200	115.114.104.218	\N	{"process_time_ms": 44.25, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122451616"}	2026-05-07 02:54:12.51053+00	1
18863	Viewed/List Bookings	GET	/api/public/bookings	200	115.114.104.218	\N	{"process_time_ms": 34.2, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778122452316"}	2026-05-07 02:54:13.065015+00	1
18864	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	115.114.104.218	\N	{"process_time_ms": 30.71, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778122452873"}	2026-05-07 02:54:13.372725+00	1
18865	Viewed/List 	GET	/api/resort-info/	200	115.114.104.218	\N	{"process_time_ms": 28.15, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453180"}	2026-05-07 02:54:13.658766+00	1
18866	Viewed/List Food Categories	GET	/api/public/food-categories	200	115.114.104.218	\N	{"process_time_ms": 25.84, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:13.954976+00	1
18867	Viewed/List Food Items	GET	/api/public/food-items	200	115.114.104.218	\N	{"process_time_ms": 36.42, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:13.958903+00	1
18868	Viewed/List 	GET	/api/gallery/	200	115.114.104.218	\N	{"process_time_ms": 43.89, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:13.970426+00	1
18869	Viewed/List Packages	GET	/api/public/packages	200	115.114.104.218	\N	{"process_time_ms": 41.65, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:13.974014+00	1
18870	Viewed/List 	GET	/api/reviews/	200	115.114.104.218	\N	{"process_time_ms": 8.17, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:14.185131+00	1
18871	Viewed/List 	GET	/api/header-banner/	200	115.114.104.218	\N	{"process_time_ms": 16.14, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:14.228505+00	1
18872	Viewed/List Services	GET	/api/public/services	200	115.114.104.218	\N	{"process_time_ms": 18.76, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:14.233514+00	1
18873	Viewed/List 	GET	/api/plan-weddings/	200	115.114.104.218	\N	{"process_time_ms": 21.74, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:14.255422+00	1
18874	Viewed/List 	GET	/api/signature-experiences/	200	115.114.104.218	\N	{"process_time_ms": 36.92, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453465"}	2026-05-07 02:54:14.264364+00	1
18875	Viewed/List 	GET	/api/nearby-attractions/	200	115.114.104.218	\N	{"process_time_ms": 9.3, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453466"}	2026-05-07 02:54:14.446535+00	1
18876	Viewed/List 	GET	/api/nearby-attraction-banners/	200	115.114.104.218	\N	{"process_time_ms": 7.05, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122453466"}	2026-05-07 02:54:14.4919+00	1
18877	Viewed/List Rooms	GET	/api/public/rooms	200	115.114.104.218	\N	{"process_time_ms": 17.11, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122478418"}	2026-05-07 02:54:38.887948+00	1
18878	Viewed/List Bookings	GET	/api/public/bookings	200	115.114.104.218	\N	{"process_time_ms": 26.08, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=2&_t=1778122478694"}	2026-05-07 02:54:39.171829+00	1
18879	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	115.114.104.218	\N	{"process_time_ms": 16.65, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=2&_t=1778122478973"}	2026-05-07 02:54:39.440248+00	1
18880	Viewed/List 	GET	/api/resort-info/	200	115.114.104.218	\N	{"process_time_ms": 5.35, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778122479245"}	2026-05-07 02:54:39.701796+00	1
18881	Viewed/List Food Items	GET	/api/public/food-items	200	115.114.104.218	\N	{"process_time_ms": 34.91, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778122479505"}	2026-05-07 02:54:39.999835+00	1
18882	Viewed/List 	GET	/api/header-banner/	200	115.114.104.218	\N	{"process_time_ms": 42.37, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122479506"}	2026-05-07 02:54:40.004865+00	1
18883	Viewed/List 	GET	/api/reviews/	200	115.114.104.218	\N	{"process_time_ms": 45.94, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778122479505"}	2026-05-07 02:54:40.008552+00	1
18884	Viewed/List Food Categories	GET	/api/public/food-categories	200	115.114.104.218	\N	{"process_time_ms": 46.14, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778122479505"}	2026-05-07 02:54:40.012276+00	1
18885	Viewed/List 	GET	/api/gallery/	200	115.114.104.218	\N	{"process_time_ms": 52.1, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122479505"}	2026-05-07 02:54:40.017401+00	1
18888	Viewed/List 	GET	/api/nearby-attraction-banners/	200	115.114.104.218	\N	{"process_time_ms": 19.94, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778122479507"}	2026-05-07 02:54:40.293938+00	1
18898	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 11.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211250"}	2026-05-07 03:06:47.134282+00	1
18906	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 14.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211253"}	2026-05-07 03:06:47.700588+00	1
18910	Viewed/List Holidays	GET	/api/attendance/holidays	200	103.72.178.237	1	{"process_time_ms": 6.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:06:53.238519+00	1
18918	Viewed/List 	GET	/api/resort-info/	200	66.249.64.39	\N	{"process_time_ms": 5.29, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:56.144648+00	1
18927	Viewed/List Food Categories	GET	/api/public/food-categories	200	66.249.64.38	\N	{"process_time_ms": 4.4, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:00.536125+00	1
18886	Viewed/List Packages	GET	/api/public/packages	200	115.114.104.218	\N	{"process_time_ms": 45.15, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122479505"}	2026-05-07 02:54:40.027144+00	1
18890	Viewed/List 	GET	/api/nearby-attractions/	200	115.114.104.218	\N	{"process_time_ms": 27.26, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122479507"}	2026-05-07 02:54:40.301498+00	1
18895	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 8.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778123209627"}	2026-05-07 03:06:45.888601+00	1
18899	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 9.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211250"}	2026-05-07 03:06:47.414848+00	1
18903	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 19.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211253"}	2026-05-07 03:06:47.672925+00	1
18915	Viewed/List Rooms	GET	/api/public/rooms	200	66.249.64.38	\N	{"process_time_ms": 13.29, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:54.79332+00	1
18924	Viewed/List Packages	GET	/api/public/packages	200	66.249.64.38	\N	{"process_time_ms": 6.61, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:59.046017+00	1
18887	Viewed/List Services	GET	/api/public/services	200	115.114.104.218	\N	{"process_time_ms": 22.95, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122479506"}	2026-05-07 02:54:40.290229+00	1
18893	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 14.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123208388"}	2026-05-07 03:06:44.87728+00	1
18897	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 7.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211249"}	2026-05-07 03:06:47.130776+00	1
18907	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 6.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211254"}	2026-05-07 03:06:47.920737+00	1
18911	Viewed/List Today	GET	/api/attendance/status/today	200	103.72.178.237	1	{"process_time_ms": 18.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:06:53.384188+00	1
18919	Viewed/List Services	GET	/api/public/services	200	66.249.64.38	\N	{"process_time_ms": 7.11, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:56.620673+00	1
18928	Viewed/List 	GET	/api/signature-experiences/	200	66.249.64.38	\N	{"process_time_ms": 5.5, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:01.033358+00	1
18889	Viewed/List 	GET	/api/plan-weddings/	200	115.114.104.218	\N	{"process_time_ms": 23.1, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778122479507"}	2026-05-07 02:54:40.297083+00	1
18894	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 6.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778123209346"}	2026-05-07 03:06:45.22713+00	1
18902	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 11.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211253"}	2026-05-07 03:06:47.669306+00	1
18920	Viewed/List 	GET	/api/header-banner/	200	66.249.64.39	\N	{"process_time_ms": 5.82, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:57.09915+00	1
18929	Viewed/List Food Items	GET	/api/public/food-items	200	66.249.64.38	\N	{"process_time_ms": 5.89, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:01.537532+00	1
18891	Viewed/List 	GET	/api/signature-experiences/	200	115.114.104.218	\N	{"process_time_ms": 38.45, "user_agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778122479506"}	2026-05-07 02:54:40.308595+00	1
18900	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 13.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211252"}	2026-05-07 03:06:47.421642+00	1
18909	Viewed/List Aggregate	GET	/api/attendance/utilization/aggregate	200	103.72.178.237	1	{"process_time_ms": 22.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:06:53.177434+00	1
18917	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	66.249.64.39	\N	{"process_time_ms": 6.47, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-07 03:07:55.674943+00	1
18926	Viewed/List 	GET	/api/reviews/	200	66.249.64.38	\N	{"process_time_ms": 5.46, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:00.370303+00	1
18892	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 7.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 03:06:44.771087+00	1
18901	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 6.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211252"}	2026-05-07 03:06:47.646467+00	1
18905	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 7.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211253"}	2026-05-07 03:06:47.69626+00	1
18913	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 10.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:06:53.513519+00	1
18922	Viewed/List 	GET	/api/gallery/	200	66.249.64.39	\N	{"process_time_ms": 5.77, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:58.06512+00	1
18896	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 5.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123210962"}	2026-05-07 03:06:46.846505+00	1
18921	Viewed/List 	GET	/api/nearby-attraction-banners/	200	66.249.64.38	\N	{"process_time_ms": 5.38, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:57.580675+00	1
18904	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 21.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778123211253"}	2026-05-07 03:06:47.676894+00	1
18908	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 32.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:06:52.885234+00	1
18912	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 12.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:06:53.455943+00	1
18916	Viewed/List Bookings	GET	/api/public/bookings	200	66.249.64.39	\N	{"process_time_ms": 7.48, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-07 03:07:55.208481+00	1
18925	Viewed/List 	GET	/api/plan-weddings/	200	66.249.64.38	\N	{"process_time_ms": 5.3, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:59.537483+00	1
18914	Viewed/List Branches	GET	/api/public/branches	200	66.249.64.39	\N	{"process_time_ms": 6.69, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": ""}	2026-05-07 03:07:54.377792+00	1
18923	Viewed/List 	GET	/api/nearby-attractions/	200	66.249.64.38	\N	{"process_time_ms": 5.83, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:07:58.554253+00	1
18930	Viewed/List Rooms	GET	/api/public/rooms	200	66.249.64.38	\N	{"process_time_ms": 11.97, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:28.62706+00	1
18931	Viewed/List Branches	GET	/api/public/branches	200	66.249.64.38	\N	{"process_time_ms": 5.28, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": ""}	2026-05-07 03:08:29.126553+00	1
18932	Viewed/List Rooms	GET	/api/public/rooms	200	66.249.64.38	\N	{"process_time_ms": 12.3, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:29.638274+00	1
18933	Viewed/List Branches	GET	/api/public/branches	200	66.249.64.38	\N	{"process_time_ms": 5.06, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": ""}	2026-05-07 03:08:30.139361+00	1
18934	Viewed/List Bookings	GET	/api/public/bookings	200	66.249.64.38	\N	{"process_time_ms": 6.06, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-07 03:08:30.647276+00	1
18935	Viewed/List Bookings	GET	/api/public/bookings	200	66.249.64.38	\N	{"process_time_ms": 6.62, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-07 03:08:31.158005+00	1
18936	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	66.249.64.38	\N	{"process_time_ms": 6.69, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-07 03:08:31.668385+00	1
18937	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	66.249.64.38	\N	{"process_time_ms": 6.28, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-07 03:08:32.180901+00	1
18938	Viewed/List 	GET	/api/resort-info/	200	66.249.64.38	\N	{"process_time_ms": 5.22, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:32.69448+00	1
18939	Viewed/List 	GET	/api/resort-info/	200	66.249.64.38	\N	{"process_time_ms": 5.02, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:33.210006+00	1
18940	Viewed/List 	GET	/api/header-banner/	200	66.249.64.38	\N	{"process_time_ms": 5.9, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:33.727916+00	1
18941	Viewed/List 	GET	/api/gallery/	200	66.249.64.38	\N	{"process_time_ms": 12.18, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:34.253856+00	1
18942	Viewed/List 	GET	/api/reviews/	200	66.249.64.38	\N	{"process_time_ms": 5.99, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:34.767253+00	1
18943	Viewed/List 	GET	/api/nearby-attractions/	200	66.249.64.38	\N	{"process_time_ms": 6.51, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:35.294176+00	1
18944	Viewed/List 	GET	/api/nearby-attraction-banners/	200	66.249.64.38	\N	{"process_time_ms": 4.99, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:35.809863+00	1
18945	Viewed/List 	GET	/api/signature-experiences/	200	66.249.64.38	\N	{"process_time_ms": 5.44, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:36.333942+00	1
18946	Viewed/List Packages	GET	/api/public/packages	200	66.249.64.38	\N	{"process_time_ms": 6.43, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:36.860123+00	1
18947	Viewed/List 	GET	/api/gallery/	200	66.249.64.38	\N	{"process_time_ms": 5.17, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:37.385461+00	1
18948	Viewed/List Services	GET	/api/public/services	200	66.249.64.38	\N	{"process_time_ms": 6.02, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:37.91265+00	1
18949	Viewed/List Food Items	GET	/api/public/food-items	200	66.249.64.38	\N	{"process_time_ms": 6.31, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:38.447137+00	1
18958	Viewed/List Packages	GET	/api/public/packages	200	66.249.64.38	\N	{"process_time_ms": 6.47, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:43.226109+00	1
18970	Viewed/List Holidays	GET	/api/attendance/holidays	200	103.72.178.237	1	{"process_time_ms": 6.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:42.853038+00	1
19006	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 38.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:05.347902+00	1
19009	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 63.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:05.374204+00	1
19014	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 03:24:05.937163+00	1
18950	Viewed/List Services	GET	/api/public/services	200	66.249.64.38	\N	{"process_time_ms": 5.44, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:38.968852+00	1
18959	Viewed/List Food Categories	GET	/api/public/food-categories	200	66.249.64.38	\N	{"process_time_ms": 4.69, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:43.758598+00	1
18967	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 22.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:11:18.103561+00	1
18971	Viewed/List Today	GET	/api/attendance/status/today	200	103.72.178.237	1	{"process_time_ms": 12.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:42.916161+00	1
18977	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 64.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:44.075491+00	1
18981	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 28.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 03:18:44.365949+00	1
18999	Viewed/List Summary	GET	/api/dashboard/summary	200	103.72.178.237	1	{"process_time_ms": 166.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "period=all"}	2026-05-07 03:23:58.220561+00	1
19007	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 47.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 03:24:05.356886+00	1
19011	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 75.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:05.386241+00	1
18951	Viewed/List 	GET	/api/nearby-attractions/	200	66.249.64.38	\N	{"process_time_ms": 5.69, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:39.498403+00	1
18960	Viewed/List Food Items	GET	/api/public/food-items	200	66.249.64.38	\N	{"process_time_ms": 5.19, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:44.29599+00	1
18979	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 28.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:44.347194+00	1
18995	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 41.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:23:58.095681+00	1
18998	Viewed/List Rooms	GET	/api/rooms	200	103.72.178.237	1	{"process_time_ms": 98.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 03:23:58.16046+00	1
19012	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 16.24, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 03:24:05.642157+00	1
19015	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 23.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:06.764381+00	1
18952	Viewed/List 	GET	/api/header-banner/	200	66.249.64.38	\N	{"process_time_ms": 5.76, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:40.028874+00	1
18961	Viewed/List 	GET	/api/reviews/	200	66.249.64.38	\N	{"process_time_ms": 5.9, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:44.831774+00	1
18975	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 34.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:44.045728+00	1
18993	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 26.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 03:23:44.897255+00	1
19003	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 59.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:03.229993+00	1
19008	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 60.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:05.364793+00	1
19016	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 23.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778124250245"}	2026-05-07 03:24:06.767922+00	1
18953	Viewed/List Food Categories	GET	/api/public/food-categories	200	66.249.64.38	\N	{"process_time_ms": 4.96, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:40.559223+00	1
18962	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 16.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:11:17.304195+00	1
18973	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 16.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:43.141094+00	1
18976	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 54.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 03:18:44.066249+00	1
18984	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 35.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778123930883"}	2026-05-07 03:18:46.784739+00	1
18987	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 03:23:44.430244+00	1
18997	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 79.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:23:58.138908+00	1
19005	Viewed/List Rooms	GET	/api/rooms	200	103.72.178.237	1	{"process_time_ms": 68.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 03:24:03.244997+00	1
18954	Viewed/List 	GET	/api/nearby-attraction-banners/	200	66.249.64.38	\N	{"process_time_ms": 5.14, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:41.09109+00	1
18963	Viewed/List Aggregate	GET	/api/attendance/utilization/aggregate	200	103.72.178.237	1	{"process_time_ms": 19.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:11:17.586651+00	1
18966	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 20.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:11:18.099667+00	1
18988	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 10.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 03:23:44.650794+00	1
18991	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 19.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 03:23:44.881869+00	1
19004	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 62.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:03.23456+00	1
18955	Viewed/List 	GET	/api/plan-weddings/	200	66.249.64.38	\N	{"process_time_ms": 5.24, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/147.0.7727.116 Safari/537.36", "query_params": "_t=1778112000000"}	2026-05-07 03:08:41.623035+00	1
18964	Viewed/List Holidays	GET	/api/attendance/holidays	200	103.72.178.237	1	{"process_time_ms": 5.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:11:17.813668+00	1
18978	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 8.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:44.157307+00	1
18982	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 03:18:44.645009+00	1
18985	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 11.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:23:44.151082+00	1
19001	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 46.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:03.212677+00	1
19013	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 17.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 03:24:05.652819+00	1
18956	Viewed/List 	GET	/api/plan-weddings/	200	66.249.64.38	\N	{"process_time_ms": 5.3, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:42.157234+00	1
18965	Viewed/List Today	GET	/api/attendance/status/today	200	103.72.178.237	1	{"process_time_ms": 11.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:11:17.859989+00	1
18968	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 18.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:42.347846+00	1
18974	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 26.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 03:18:44.037565+00	1
18986	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 25.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:23:44.373201+00	1
18990	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 12.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:23:44.712646+00	1
18994	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 03:23:45.178869+00	1
18996	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 49.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 03:23:58.114953+00	1
19000	Viewed/List Summary	GET	/api/dashboard/summary	200	103.72.178.237	1	{"process_time_ms": 29.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "period=all"}	2026-05-07 03:24:03.203097+00	1
19002	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 47.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 03:24:03.21654+00	1
18957	Viewed/List 	GET	/api/signature-experiences/	200	66.249.64.38	\N	{"process_time_ms": 5.03, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.116 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 03:08:42.689629+00	1
18969	Viewed/List Aggregate	GET	/api/attendance/utilization/aggregate	200	103.72.178.237	1	{"process_time_ms": 19.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:42.636636+00	1
18972	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 16.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:43.13364+00	1
18980	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 36.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 03:18:44.358267+00	1
18983	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 26.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:18:46.776542+00	1
18989	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 7.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:23:44.664043+00	1
18992	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 25.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:23:44.893752+00	1
19010	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 66.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 03:24:05.377822+00	1
19017	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 82.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:26.616775+00	1
19018	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 143.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 03:24:26.643584+00	1
19019	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 165.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:26.653445+00	1
19020	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 171.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 03:24:26.671755+00	1
19021	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 183.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:26.681829+00	1
19022	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 189.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:26.6887+00	1
19023	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 12.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 03:24:26.897068+00	1
19024	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 15.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 03:24:26.939825+00	1
19025	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 20.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:26.949098+00	1
19026	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 10.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 03:24:27.226469+00	1
19027	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 22.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:27.988327+00	1
19028	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 32.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778124271469"}	2026-05-07 03:24:28.003004+00	1
19029	Viewed/List Assigned	GET	/api/services/assigned	200	103.72.178.237	1	{"process_time_ms": 39.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=100"}	2026-05-07 03:24:46.515098+00	1
19030	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 50.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:46.528297+00	1
19031	Viewed/List Services	GET	/api/services	200	103.72.178.237	1	{"process_time_ms": 57.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:46.535362+00	1
19032	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 55.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:46.539187+00	1
19033	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 72.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:46.550966+00	1
19034	Viewed/List Rooms	GET	/api/rooms	200	103.72.178.237	1	{"process_time_ms": 77.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:46.555146+00	1
19043	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 50.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 03:24:48.518644+00	1
19045	Viewed/List Summary	GET	/api/dashboard/summary	200	103.72.178.237	1	{"process_time_ms": 53.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "period=all"}	2026-05-07 03:24:50.121623+00	1
19050	Viewed/List Charts	GET	/api/dashboard/charts	200	103.72.178.237	1	{"process_time_ms": 109.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:50.170892+00	1
19054	Viewed/List Rooms	GET	/api/rooms	200	103.72.178.237	1	{"process_time_ms": 28.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=100"}	2026-05-07 03:24:50.468071+00	1
19056	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 47.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=50"}	2026-05-07 03:24:52.296979+00	1
19065	Viewed/List Summary	GET	/api/dashboard/summary	200	103.72.178.237	1	{"process_time_ms": 40.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "period=all"}	2026-05-07 03:24:52.950126+00	1
19073	Viewed/List Food Orders	GET	/api/reports/food-orders	200	103.72.178.237	1	{"process_time_ms": 51.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:56.21585+00	1
19088	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 11.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 03:24:58.1515+00	1
19095	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 54.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 03:25:23.057834+00	1
19111	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 66.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:26:13.625657+00	1
19115	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 03:26:14.162867+00	1
19035	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 10.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:46.793219+00	1
19039	Viewed/List Kpis	GET	/api/dashboard/kpis	200	103.72.178.237	1	{"process_time_ms": 88.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:47.189527+00	1
19042	Viewed/List Budgets	GET	/api/expenses/budgets	200	103.72.178.237	1	{"process_time_ms": 37.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:48.51486+00	1
19051	Viewed/List Expenses	GET	/api/reports/expenses	200	103.72.178.237	1	{"process_time_ms": 14.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:50.425069+00	1
19059	Viewed/List Rooms	GET	/api/rooms	200	103.72.178.237	1	{"process_time_ms": 62.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:52.320242+00	1
19070	Viewed/List Kpis	GET	/api/dashboard/kpis	200	103.72.178.237	1	{"process_time_ms": 5.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:53.223509+00	1
19072	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 50.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:56.210623+00	1
19085	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 69.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:57.879954+00	1
19089	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 03:24:58.433227+00	1
19097	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 73.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:25:23.072366+00	1
19101	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 03:25:23.631124+00	1
19105	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 47.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:25:55.116794+00	1
19106	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 27.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:26:13.582316+00	1
19109	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 54.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 03:26:13.61198+00	1
19113	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 20.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 03:26:13.883143+00	1
19036	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 16.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:46.826188+00	1
19037	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 22.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:46.832725+00	1
19048	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 92.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:50.153454+00	1
19052	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 24.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:50.435151+00	1
19060	Viewed/List Services	GET	/api/services	200	103.72.178.237	1	{"process_time_ms": 27.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:52.618163+00	1
19063	Viewed/List Food Orders	GET	/api/food-orders	200	103.72.178.237	1	{"process_time_ms": 50.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=50"}	2026-05-07 03:24:52.640245+00	1
19066	Viewed/List Packages	GET	/api/packages	200	103.72.178.237	1	{"process_time_ms": 42.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:52.953372+00	1
19077	Viewed/List Expenses	GET	/api/reports/expenses	200	103.72.178.237	1	{"process_time_ms": 22.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:56.509952+00	1
19082	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 43.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 03:24:57.860732+00	1
19083	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 48.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 03:24:57.864659+00	1
19087	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 10.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 03:24:58.134+00	1
19090	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 24.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778124303428"}	2026-05-07 03:24:59.948964+00	1
19094	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 53.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 03:25:23.049872+00	1
19098	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 15.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 03:25:23.331885+00	1
19100	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 28.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:25:23.353897+00	1
19103	Viewed/List 	GET	/api/food-items/	200	103.72.178.237	1	{"process_time_ms": 31.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:25:55.097556+00	1
19114	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 16.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:26:13.896587+00	1
19038	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 56.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=200"}	2026-05-07 03:24:47.161707+00	1
19047	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 74.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:50.142269+00	1
19075	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 71.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:56.235106+00	1
19079	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 37.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:56.52395+00	1
19086	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 68.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:57.888576+00	1
19117	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 28.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:26:15.387457+00	1
19040	Viewed/List Service Requests	GET	/api/service-requests	200	103.72.178.237	1	{"process_time_ms": 105.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100&include_checkout_requests=true"}	2026-05-07 03:24:47.209014+00	1
19044	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 44.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:48.521767+00	1
19046	Viewed/List Package Bookings	GET	/api/reports/package-bookings	200	103.72.178.237	1	{"process_time_ms": 59.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:50.131769+00	1
19057	Viewed/List Expenses	GET	/api/expenses	200	103.72.178.237	1	{"process_time_ms": 44.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=50"}	2026-05-07 03:24:52.303589+00	1
19067	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 55.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:52.959061+00	1
19076	Viewed/List Charts	GET	/api/dashboard/charts	200	103.72.178.237	1	{"process_time_ms": 79.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:56.242495+00	1
19080	Viewed/List Rooms	GET	/api/rooms	200	103.72.178.237	1	{"process_time_ms": 34.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=100"}	2026-05-07 03:24:56.539065+00	1
19081	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 30.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:57.850637+00	1
19102	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 24.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778124358564"}	2026-05-07 03:25:55.092975+00	1
19108	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 53.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 03:26:13.605881+00	1
19041	Viewed/List Expenses	GET	/api/expenses	200	103.72.178.237	1	{"process_time_ms": 30.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20"}	2026-05-07 03:24:48.504523+00	1
19049	Viewed/List Food Orders	GET	/api/reports/food-orders	200	103.72.178.237	1	{"process_time_ms": 91.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:50.159411+00	1
19055	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 40.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:52.292129+00	1
19058	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 54.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=50"}	2026-05-07 03:24:52.312469+00	1
19062	Viewed/List Food Items	GET	/api/food-items	200	103.72.178.237	1	{"process_time_ms": 39.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:52.629749+00	1
19064	Viewed/List Categories	GET	/api/inventory/categories	200	103.72.178.237	1	{"process_time_ms": 32.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=50"}	2026-05-07 03:24:52.945013+00	1
19069	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 63.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:52.970602+00	1
19071	Viewed/List Summary	GET	/api/dashboard/summary	200	103.72.178.237	1	{"process_time_ms": 35.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "period=all"}	2026-05-07 03:24:56.198046+00	1
19074	Viewed/List Package Bookings	GET	/api/reports/package-bookings	200	103.72.178.237	1	{"process_time_ms": 61.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=10"}	2026-05-07 03:24:56.230295+00	1
19078	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 25.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=50"}	2026-05-07 03:24:56.515189+00	1
19084	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 55.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:57.87555+00	1
19093	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 45.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:25:23.044468+00	1
19099	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 19.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 03:25:23.346927+00	1
19107	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 42.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:26:13.592453+00	1
19110	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 64.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:26:13.621266+00	1
19112	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 16.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 03:26:13.872078+00	1
19053	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 25.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=50"}	2026-05-07 03:24:50.459098+00	1
19061	Viewed/List Assigned	GET	/api/services/assigned	200	103.72.178.237	1	{"process_time_ms": 29.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=100"}	2026-05-07 03:24:52.625967+00	1
19068	Viewed/List Checkouts	GET	/api/bill/checkouts	200	103.72.178.237	1	{"process_time_ms": 53.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=50"}	2026-05-07 03:24:52.962015+00	1
19091	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 26.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:24:59.953131+00	1
19092	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 27.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:25:23.035916+00	1
19096	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 65.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:25:23.068965+00	1
19104	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 48.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 03:25:55.110377+00	1
19116	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 24.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778124378861"}	2026-05-07 03:26:15.379796+00	1
19118	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 6.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 03:27:09.817528+00	1
19119	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 11.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124432825"}	2026-05-07 03:27:09.858817+00	1
19120	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 7.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778124434089"}	2026-05-07 03:27:10.823101+00	1
19121	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 5.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778124434592"}	2026-05-07 03:27:11.608569+00	1
19122	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 5.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435378"}	2026-05-07 03:27:11.880858+00	1
19123	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 5.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435666"}	2026-05-07 03:27:12.172199+00	1
19124	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 4.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435668"}	2026-05-07 03:27:12.439699+00	1
19125	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 9.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435669"}	2026-05-07 03:27:12.688135+00	1
19126	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 13.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435669"}	2026-05-07 03:27:12.691991+00	1
19127	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 5.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435670"}	2026-05-07 03:27:12.704833+00	1
19128	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 4.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435670"}	2026-05-07 03:27:12.718774+00	1
19129	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 8.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435670"}	2026-05-07 03:27:12.96587+00	1
19130	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 11.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435671"}	2026-05-07 03:27:12.970018+00	1
19131	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 7.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435671"}	2026-05-07 03:27:12.984367+00	1
19132	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 11.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435671"}	2026-05-07 03:27:12.991968+00	1
19133	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 5.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778124435671"}	2026-05-07 03:27:13.239121+00	1
19134	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 81.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 04:30:55.055881+00	1
19135	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 47.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128258634"}	2026-05-07 04:30:55.39304+00	1
19136	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 33.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778128259361"}	2026-05-07 04:30:55.905521+00	1
19137	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 29.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778128259872"}	2026-05-07 04:30:56.222988+00	1
19138	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 28.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260188"}	2026-05-07 04:30:56.521162+00	1
19139	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 45.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260485"}	2026-05-07 04:30:56.831198+00	1
19140	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 47.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260485"}	2026-05-07 04:30:56.836696+00	1
19141	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 54.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260485"}	2026-05-07 04:30:56.844213+00	1
19142	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 30.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260485"}	2026-05-07 04:30:56.848623+00	1
19143	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 21.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260485"}	2026-05-07 04:30:57.131702+00	1
19144	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 20.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260485"}	2026-05-07 04:30:57.1405+00	1
19145	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 32.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260485"}	2026-05-07 04:30:57.145515+00	1
19146	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 32.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260485"}	2026-05-07 04:30:57.150152+00	1
19147	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 15.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260486"}	2026-05-07 04:30:57.435226+00	1
19150	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 20.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 04:34:10.196438+00	1
19151	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 39.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 04:34:10.503277+00	1
19153	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 13.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 04:34:10.783571+00	1
19154	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 17.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 04:34:10.998163+00	1
19157	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 12.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 04:34:11.062775+00	1
19158	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 9.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 04:34:11.28376+00	1
19159	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 04:34:11.340103+00	1
19148	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 173.24, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260486"}	2026-05-07 04:30:57.599893+00	1
19149	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 181.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778128260486"}	2026-05-07 04:30:57.604649+00	1
19152	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 11.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 04:34:10.711275+00	1
19155	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 33.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 04:34:11.026694+00	1
19156	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 49.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 04:34:11.03583+00	1
19160	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 111.66, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": ""}	2026-05-07 05:11:07.941072+00	1
19161	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 224.44, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130667268"}	2026-05-07 05:11:08.070934+00	1
19162	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 32.7, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "limit=500&skip=0&_t=1778130668525"}	2026-05-07 05:11:08.547027+00	1
19163	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 28.93, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "limit=500&skip=0&_t=1778130668846"}	2026-05-07 05:11:08.864212+00	1
19164	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 26.96, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669161"}	2026-05-07 05:11:09.161385+00	1
19165	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 15.28, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669457"}	2026-05-07 05:11:09.445538+00	1
19166	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 22.37, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669458"}	2026-05-07 05:11:09.457843+00	1
19167	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 23.53, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669458"}	2026-05-07 05:11:09.464493+00	1
19168	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 8.52, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669459"}	2026-05-07 05:11:09.721971+00	1
19169	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 14.09, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669459"}	2026-05-07 05:11:09.743603+00	1
19170	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 14.19, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669459"}	2026-05-07 05:11:09.747541+00	1
19171	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 13.19, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669463"}	2026-05-07 05:11:09.97985+00	1
19172	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 24.6, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669465"}	2026-05-07 05:11:09.995434+00	1
19173	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 30.44, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669464"}	2026-05-07 05:11:09.998961+00	1
19174	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 17.88, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669466"}	2026-05-07 05:11:10.008596+00	1
19175	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 6.24, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778130669467"}	2026-05-07 05:11:10.021549+00	1
19176	Viewed/List Branches	GET	/api/public/branches	200	157.51.227.235	\N	{"process_time_ms": 7.88, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": ""}	2026-05-07 05:19:37.648814+00	1
19177	Viewed/List Rooms	GET	/api/public/rooms	200	157.51.227.235	\N	{"process_time_ms": 13.88, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778131176328"}	2026-05-07 05:19:37.96425+00	1
19178	Viewed/List Bookings	GET	/api/public/bookings	200	157.51.227.235	\N	{"process_time_ms": 7.99, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "limit=500&skip=0&_t=1778131176953"}	2026-05-07 05:19:38.517798+00	1
19179	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	157.51.227.235	\N	{"process_time_ms": 7.63, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "limit=500&skip=0&_t=1778131177552"}	2026-05-07 05:19:38.862242+00	1
19180	Viewed/List 	GET	/api/resort-info/	200	157.51.227.235	\N	{"process_time_ms": 5.74, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778131177862"}	2026-05-07 05:19:39.170082+00	1
19184	Viewed/List 	GET	/api/gallery/	200	157.51.227.235	\N	{"process_time_ms": 8.32, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778131178180"}	2026-05-07 05:19:39.555267+00	1
19193	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 18.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692256"}	2026-05-07 05:28:08.363484+00	1
19208	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 43.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 05:37:20.932817+00	1
19181	Viewed/List Packages	GET	/api/public/packages	200	157.51.227.235	\N	{"process_time_ms": 12.37, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778131178180"}	2026-05-07 05:19:39.51455+00	1
19186	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 13.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:28:05.74874+00	1
19195	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 6.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692257"}	2026-05-07 05:28:08.636467+00	1
19199	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 9.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692258"}	2026-05-07 05:28:08.876207+00	1
19213	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 33.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778132242958"}	2026-05-07 05:37:24.069158+00	1
19182	Viewed/List Food Items	GET	/api/public/food-items	200	157.51.227.235	\N	{"process_time_ms": 18.62, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778131178178"}	2026-05-07 05:19:39.518326+00	1
19187	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 20.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131689136"}	2026-05-07 05:28:05.758216+00	1
19197	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 11.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692258"}	2026-05-07 05:28:08.656751+00	1
19204	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 11.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:37:20.588427+00	1
19183	Viewed/List Food Categories	GET	/api/public/food-categories	200	157.51.227.235	\N	{"process_time_ms": 20.0, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778131178178"}	2026-05-07 05:19:39.522021+00	1
19191	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 16.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692256"}	2026-05-07 05:28:08.351069+00	1
19206	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 32.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 05:37:20.897682+00	1
19185	Viewed/List 	GET	/api/reviews/	200	157.51.227.235	\N	{"process_time_ms": 11.81, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778131178181"}	2026-05-07 05:19:39.56275+00	1
19194	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 5.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692257"}	2026-05-07 05:28:08.496503+00	1
19210	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 12.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 05:37:20.976847+00	1
19188	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 7.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778131689984"}	2026-05-07 05:28:06.941507+00	1
19192	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 16.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692256"}	2026-05-07 05:28:08.354888+00	1
19196	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 10.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692257"}	2026-05-07 05:28:08.653249+00	1
19201	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 5.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692259"}	2026-05-07 05:28:08.910826+00	1
19207	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 31.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:37:20.903125+00	1
19211	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 9.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 05:37:21.303579+00	1
19214	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 15.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778132337394"}	2026-05-07 05:38:59.092061+00	1
19189	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 7.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778131691135"}	2026-05-07 05:28:07.743443+00	1
19198	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 5.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692258"}	2026-05-07 05:28:08.766802+00	1
19202	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 22.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:37:19.998043+00	1
19205	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 11.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 05:37:20.661361+00	1
19209	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 58.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:37:20.939531+00	1
19212	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 21.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:37:24.053934+00	1
19215	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 13.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:38:59.327882+00	1
19190	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 5.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131691943"}	2026-05-07 05:28:08.032716+00	1
19200	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 10.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778131692259"}	2026-05-07 05:28:08.879926+00	1
19203	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 43.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:37:20.348273+00	1
19216	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 48.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:43:09.237785+00	1
19858	Updated/Modified 3	PUT	/api/rooms/types/3	200	103.72.178.237	1	{"process_time_ms": 43.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:51:19.287117+00	1
19862	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 120.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:51:22.832854+00	1
19978	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.107	\N	{"process_time_ms": 27.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608092"}	2026-05-07 16:16:44.103775+00	1
20103	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.107	1	{"process_time_ms": 38.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-08 04:14:39.174264+00	1
20110	Updated/Modified 1	PUT	/api/rooms/types/1	200	103.72.178.107	1	{"process_time_ms": 76.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:15:46.026846+00	1
20123	Viewed/List 	GET	/api/header-banner/	200	180.178.127.178	\N	{"process_time_ms": 9.88, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693409"}	2026-05-08 04:31:33.223158+00	1
20204	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 8.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430515"}	2026-05-08 07:13:52.006384+00	1
20352	Viewed/List Service Requests	GET	/api/service-requests	200	205.254.184.6	1	{"process_time_ms": 34.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:58.027732+00	1
20354	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 56.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:58.438657+00	1
20366	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 74.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20"}	2026-05-08 09:21:01.150655+00	1
20388	Viewed/List 	GET	/api/header-banner/	200	205.254.184.6	1	{"process_time_ms": 57.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:09.336062+00	1
20396	Viewed/List 	GET	/api/nearby-attractions/	200	205.254.184.6	1	{"process_time_ms": 19.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:09.633283+00	1
20411	Viewed/List Package Bookings	GET	/api/reports/package-bookings	200	205.254.184.6	1	{"process_time_ms": 9.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 09:24:48.429815+00	1
20414	Viewed/List Ledgers	GET	/api/accounts/ledgers	200	205.254.184.6	1	{"process_time_ms": 22.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:24:51.548031+00	1
19217	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 662.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 05:51:09.368778+00	1
19225	Viewed/List Assigned	GET	/api/services/assigned	200	152.58.216.49	1	{"process_time_ms": 88.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 05:51:09.885883+00	1
19228	Viewed/List Checkouts	GET	/api/bill/checkouts	200	152.58.216.49	1	{"process_time_ms": 82.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 05:51:10.298686+00	1
19236	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 47.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 05:51:11.723697+00	1
19252	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 14.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 05:54:40.511631+00	1
19258	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	118.185.127.97	\N	{"process_time_ms": 31.54, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778138952317"}	2026-05-07 07:29:12.487788+00	1
19262	Viewed/List Packages	GET	/api/public/packages	200	118.185.127.97	\N	{"process_time_ms": 55.11, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.103605+00	1
19266	Viewed/List 	GET	/api/plan-weddings/	200	118.185.127.97	\N	{"process_time_ms": 21.32, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.377594+00	1
19270	Viewed/List 	GET	/api/nearby-attraction-banners/	200	118.185.127.97	\N	{"process_time_ms": 10.42, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952908"}	2026-05-07 07:29:13.610325+00	1
19274	Viewed/List 	GET	/api/resort-info/	200	118.185.127.97	\N	{"process_time_ms": 5.16, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139000112"}	2026-05-07 07:30:00.244041+00	1
19278	Viewed/List Packages	GET	/api/public/packages	200	118.185.127.97	\N	{"process_time_ms": 29.25, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139000436"}	2026-05-07 07:30:00.603238+00	1
19282	Viewed/List 	GET	/api/nearby-attractions/	200	118.185.127.97	\N	{"process_time_ms": 25.35, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139000437"}	2026-05-07 07:30:00.888897+00	1
19286	Viewed/List Rooms	GET	/api/public/rooms	200	118.185.127.97	\N	{"process_time_ms": 16.06, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139008267"}	2026-05-07 07:30:08.41523+00	1
19294	Viewed/List 	GET	/api/gallery/	200	118.185.127.97	\N	{"process_time_ms": 42.72, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139009431"}	2026-05-07 07:30:09.613648+00	1
19314	Viewed/List 	GET	/api/nearby-attraction-banners/	200	118.185.127.97	\N	{"process_time_ms": 22.18, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139016552"}	2026-05-07 07:30:17.013665+00	1
19317	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 41.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:36:36.725132+00	1
19324	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 41.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 07:36:37.254549+00	1
19337	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 27.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:37:09.077374+00	1
19344	Viewed/List Food Items	GET	/api/public/food-items	200	118.185.127.97	\N	{"process_time_ms": 15.9, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.343367+00	1
19360	Viewed/List 	GET	/api/header-banner/	200	66.249.65.70	\N	{"process_time_ms": 8.3, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:23.479977+00	1
19369	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 5.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144474738"}	2026-05-07 09:01:10.732647+00	1
19396	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 7.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:58.971944+00	1
19420	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 19.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 10:13:53.372896+00	1
19431	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 42.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 10:25:43.788626+00	1
19218	Viewed/List Expenses	GET	/api/expenses	200	152.58.216.49	1	{"process_time_ms": 691.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 05:51:09.389716+00	1
19221	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 707.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 05:51:09.408327+00	1
19227	Viewed/List Packages	GET	/api/packages	200	152.58.216.49	1	{"process_time_ms": 77.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 05:51:10.294971+00	1
19233	Viewed/List Summary	GET	/api/dashboard/summary	200	152.58.216.49	1	{"process_time_ms": 177.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-07 05:51:10.806946+00	1
19234	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 41.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:51:11.713537+00	1
19248	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	152.58.216.49	1	{"process_time_ms": 9.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 05:54:39.964759+00	1
19251	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 13.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:54:40.288775+00	1
19260	Viewed/List Food Items	GET	/api/public/food-items	200	118.185.127.97	\N	{"process_time_ms": 42.81, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.077245+00	1
19264	Viewed/List Services	GET	/api/public/services	200	118.185.127.97	\N	{"process_time_ms": 10.76, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.342294+00	1
19267	Viewed/List 	GET	/api/nearby-attractions/	200	118.185.127.97	\N	{"process_time_ms": 25.66, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.578938+00	1
19271	Viewed/List Rooms	GET	/api/public/rooms	200	118.185.127.97	\N	{"process_time_ms": 14.46, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138999217"}	2026-05-07 07:29:59.358483+00	1
19285	Viewed/List 	GET	/api/header-banner/	200	118.185.127.97	\N	{"process_time_ms": 5.23, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139000437"}	2026-05-07 07:30:01.208031+00	1
19289	Viewed/List 	GET	/api/resort-info/	200	118.185.127.97	\N	{"process_time_ms": 7.31, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778139009155"}	2026-05-07 07:30:09.292019+00	1
19291	Viewed/List Food Categories	GET	/api/public/food-categories	200	118.185.127.97	\N	{"process_time_ms": 34.68, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778139009431"}	2026-05-07 07:30:09.597523+00	1
19296	Viewed/List Services	GET	/api/public/services	200	118.185.127.97	\N	{"process_time_ms": 5.57, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139009431"}	2026-05-07 07:30:09.846716+00	1
19300	Viewed/List 	GET	/api/nearby-attraction-banners/	200	118.185.127.97	\N	{"process_time_ms": 5.53, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778139009431"}	2026-05-07 07:30:10.060432+00	1
19304	Viewed/List 	GET	/api/resort-info/	200	118.185.127.97	\N	{"process_time_ms": 5.62, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139016292"}	2026-05-07 07:30:16.423971+00	1
19306	Viewed/List 	GET	/api/reviews/	200	118.185.127.97	\N	{"process_time_ms": 26.34, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139016551"}	2026-05-07 07:30:16.71358+00	1
19316	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 21.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:36:36.414485+00	1
19319	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 35.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 07:36:36.955647+00	1
19322	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 12.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:36:37.216301+00	1
19326	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 40.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:37:06.99424+00	1
19328	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 75.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 07:37:07.03158+00	1
19345	Viewed/List Services	GET	/api/public/services	200	118.185.127.97	\N	{"process_time_ms": 8.25, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.59584+00	1
19219	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 699.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:51:09.397801+00	1
19230	Viewed/List Employees	GET	/api/employees	200	152.58.216.49	1	{"process_time_ms": 93.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 05:51:10.305862+00	1
19242	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 9.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 05:51:12.40309+00	1
19249	Viewed/List 	GET	/api/packages/	200	152.58.216.49	1	{"process_time_ms": 8.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:54:40.236582+00	1
19261	Viewed/List Food Categories	GET	/api/public/food-categories	200	118.185.127.97	\N	{"process_time_ms": 42.19, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.095+00	1
19277	Viewed/List 	GET	/api/gallery/	200	118.185.127.97	\N	{"process_time_ms": 20.53, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139000437"}	2026-05-07 07:30:00.600035+00	1
19281	Viewed/List 	GET	/api/plan-weddings/	200	118.185.127.97	\N	{"process_time_ms": 23.78, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139000437"}	2026-05-07 07:30:00.885123+00	1
19292	Viewed/List Packages	GET	/api/public/packages	200	118.185.127.97	\N	{"process_time_ms": 38.98, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139009431"}	2026-05-07 07:30:09.603119+00	1
19297	Viewed/List 	GET	/api/signature-experiences/	200	118.185.127.97	\N	{"process_time_ms": 8.38, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139009431"}	2026-05-07 07:30:09.872239+00	1
19301	Viewed/List Rooms	GET	/api/public/rooms	200	118.185.127.97	\N	{"process_time_ms": 11.96, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139015442"}	2026-05-07 07:30:15.584648+00	1
19309	Viewed/List Packages	GET	/api/public/packages	200	118.185.127.97	\N	{"process_time_ms": 37.22, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139016551"}	2026-05-07 07:30:16.72406+00	1
19312	Viewed/List 	GET	/api/plan-weddings/	200	118.185.127.97	\N	{"process_time_ms": 13.98, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139016551"}	2026-05-07 07:30:17.001953+00	1
19327	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 53.24, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 07:37:07.003659+00	1
19329	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 87.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:37:07.039691+00	1
19333	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 30.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 07:37:07.311517+00	1
19336	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 23.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778139433026"}	2026-05-07 07:37:09.073637+00	1
19346	Viewed/List 	GET	/api/signature-experiences/	200	118.185.127.97	\N	{"process_time_ms": 7.76, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.610283+00	1
19349	Viewed/List 	GET	/api/gallery/	200	118.185.127.97	\N	{"process_time_ms": 40.31, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.903967+00	1
19361	Viewed/List 	GET	/api/nearby-attractions/	200	66.249.65.68	\N	{"process_time_ms": 8.01, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:24.00904+00	1
19380	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 11.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.589299+00	1
19397	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 19.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:59.001423+00	1
19402	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 6.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:59.24843+00	1
19405	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 12.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 10:13:39.962398+00	1
19408	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 43.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:40.273152+00	1
19220	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 703.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:51:09.402363+00	1
19232	Viewed/List Kpis	GET	/api/dashboard/kpis	200	152.58.216.49	1	{"process_time_ms": 63.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:51:10.690008+00	1
19241	Viewed/List Locations	GET	/api/inventory/locations	200	152.58.216.49	1	{"process_time_ms": 13.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 05:51:12.066435+00	1
19244	Viewed/List Test	GET	/api/rooms/test	200	152.58.216.49	1	{"process_time_ms": 38.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778133078686"}	2026-05-07 05:51:19.81418+00	1
19247	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 05:54:39.929799+00	1
19254	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 8.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 05:54:40.839875+00	1
19279	Viewed/List Services	GET	/api/public/services	200	118.185.127.97	\N	{"process_time_ms": 11.64, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139000437"}	2026-05-07 07:30:00.865118+00	1
19283	Viewed/List 	GET	/api/nearby-attraction-banners/	200	118.185.127.97	\N	{"process_time_ms": 5.18, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139000437"}	2026-05-07 07:30:01.176303+00	1
19287	Viewed/List Bookings	GET	/api/public/bookings	200	118.185.127.97	\N	{"process_time_ms": 8.24, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=2&_t=1778139008548"}	2026-05-07 07:30:08.688811+00	1
19305	Viewed/List Food Items	GET	/api/public/food-items	200	118.185.127.97	\N	{"process_time_ms": 18.34, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139016551"}	2026-05-07 07:30:16.700426+00	1
19308	Viewed/List Food Categories	GET	/api/public/food-categories	200	118.185.127.97	\N	{"process_time_ms": 29.37, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139016551"}	2026-05-07 07:30:16.720722+00	1
19320	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 12.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:36:37.002447+00	1
19330	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 86.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:37:07.044421+00	1
19348	Viewed/List 	GET	/api/plan-weddings/	200	118.185.127.97	\N	{"process_time_ms": 39.83, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.8885+00	1
19362	Viewed/List 	GET	/api/nearby-attraction-banners/	200	66.249.65.69	\N	{"process_time_ms": 7.27, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:24.442506+00	1
19370	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 18.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475008"}	2026-05-07 09:01:11.019756+00	1
19374	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 8.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.312372+00	1
19383	Viewed/List 	GET	/api/resort-info/	200	66.249.65.70	\N	{"process_time_ms": 5.05, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:02:01.86219+00	1
19426	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 54.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:14:08.112661+00	1
19429	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 32.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:43.529406+00	1
19432	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 62.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:43.80331+00	1
19434	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 40.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 10:25:44.098687+00	1
19441	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 69.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:54.988604+00	1
19452	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 21.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149561612"}	2026-05-07 10:25:59.211503+00	1
19462	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 9.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565278"}	2026-05-07 10:26:01.261378+00	1
19222	Viewed/List Rooms	GET	/api/rooms	200	152.58.216.49	1	{"process_time_ms": 776.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 05:51:09.471485+00	1
19226	Viewed/List Services	GET	/api/services	200	152.58.216.49	1	{"process_time_ms": 89.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 05:51:09.889027+00	1
19229	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 90.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 05:51:10.302603+00	1
19243	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 27.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:51:19.801371+00	1
19245	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 19.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:54:39.616676+00	1
19295	Viewed/List 	GET	/api/header-banner/	200	118.185.127.97	\N	{"process_time_ms": 48.55, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139009431"}	2026-05-07 07:30:09.624822+00	1
19299	Viewed/List 	GET	/api/plan-weddings/	200	118.185.127.97	\N	{"process_time_ms": 174.8, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778139009431"}	2026-05-07 07:30:10.045881+00	1
19303	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	118.185.127.97	\N	{"process_time_ms": 7.22, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778139015983"}	2026-05-07 07:30:16.115982+00	1
19311	Viewed/List Services	GET	/api/public/services	200	118.185.127.97	\N	{"process_time_ms": 5.57, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139016551"}	2026-05-07 07:30:16.963973+00	1
19315	Viewed/List 	GET	/api/signature-experiences/	200	118.185.127.97	\N	{"process_time_ms": 22.68, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139016551"}	2026-05-07 07:30:17.016814+00	1
19321	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 20.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:36:37.122509+00	1
19334	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 22.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 07:37:07.323212+00	1
19353	Viewed/List 	GET	/api/nearby-attraction-banners/	200	118.185.127.97	\N	{"process_time_ms": 6.5, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716197"}	2026-05-07 07:58:37.202822+00	1
19386	HEAD .Env	HEAD	/api/v2/.env	404	213.209.159.175	\N	{"process_time_ms": 19.53, "user_agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36", "query_params": ""}	2026-05-07 10:02:17.994975+00	1
19395	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 37.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:58.715095+00	1
19407	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 16.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:40.241737+00	1
19433	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 14.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:43.812667+00	1
19436	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 53.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:44.106883+00	1
19438	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 10:25:44.476974+00	1
19447	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 31.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:55.294833+00	1
19449	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 26.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:56.460221+00	1
19453	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 6.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778149563912"}	2026-05-07 10:25:59.556448+00	1
19456	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 6.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565273"}	2026-05-07 10:26:00.912249+00	1
19460	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 8.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565277"}	2026-05-07 10:26:01.217436+00	1
19461	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 10.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565278"}	2026-05-07 10:26:01.225073+00	1
19223	Viewed/List Food Items	GET	/api/food-items	200	152.58.216.49	1	{"process_time_ms": 63.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-07 05:51:09.844097+00	1
19237	Viewed/List Bookings	GET	/api/bookings	200	152.58.216.49	1	{"process_time_ms": 50.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 05:51:11.726825+00	1
19240	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 12.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 05:51:12.043966+00	1
19250	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 14.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:54:40.26689+00	1
19332	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 22.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:37:07.305883+00	1
19354	Viewed/List Rooms	GET	/api/public/rooms	200	66.249.65.70	\N	{"process_time_ms": 107.07, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:20.370751+00	1
19363	Viewed/List 	GET	/api/plan-weddings/	200	66.249.65.68	\N	{"process_time_ms": 7.11, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:24.929529+00	1
19372	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 27.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.031855+00	1
19381	Viewed/List Bookings	GET	/api/public/bookings	200	66.249.65.68	\N	{"process_time_ms": 8.29, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-07 09:02:00.971906+00	1
19387	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 53.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 10:02:57.35812+00	1
19406	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 13.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 10:13:40.027598+00	1
19425	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 41.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:14:08.104389+00	1
19428	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 21.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778148865239"}	2026-05-07 10:14:22.341844+00	1
19430	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 26.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 10:25:43.779905+00	1
19440	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 51.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:54.976063+00	1
19443	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 84.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:55.004622+00	1
19444	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 73.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:55.007974+00	1
19448	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 10:25:55.564759+00	1
19451	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 8.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 10:25:59.204262+00	1
19455	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 4.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565000"}	2026-05-07 10:26:00.638416+00	1
19464	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 5.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565278"}	2026-05-07 10:26:01.449254+00	1
19475	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 8.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:19.103941+00	1
19476	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 10:26:19.218077+00	1
19479	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 48.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:31.673039+00	1
19482	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 68.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:31.692453+00	1
19483	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 12.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 10:26:31.926829+00	1
19224	Viewed/List Food Orders	GET	/api/food-orders	200	152.58.216.49	1	{"process_time_ms": 97.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 05:51:09.877101+00	1
19231	Viewed/List Categories	GET	/api/inventory/categories	200	152.58.216.49	1	{"process_time_ms": 91.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-07 05:51:10.308978+00	1
19238	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 65.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:51:11.737502+00	1
19338	Viewed/List Branches	GET	/api/public/branches	200	118.185.127.97	\N	{"process_time_ms": 55.65, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-07 07:58:34.812064+00	1
19350	Viewed/List 	GET	/api/reviews/	200	118.185.127.97	\N	{"process_time_ms": 43.96, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.907774+00	1
19355	Viewed/List Branches	GET	/api/public/branches	200	66.249.65.69	\N	{"process_time_ms": 27.16, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": ""}	2026-05-07 09:00:21.276419+00	1
19364	Viewed/List Food Categories	GET	/api/public/food-categories	200	66.249.65.68	\N	{"process_time_ms": 5.17, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:25.416556+00	1
19373	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 6.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.295577+00	1
19382	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	66.249.65.70	\N	{"process_time_ms": 6.27, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-07 09:02:01.412491+00	1
19388	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 90.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148181671"}	2026-05-07 10:02:57.401517+00	1
19401	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 7.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:59.189247+00	1
19404	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 40.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:39.751204+00	1
19411	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 12.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 10:13:40.522223+00	1
19435	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 33.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 10:25:44.102508+00	1
19439	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 42.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 10:25:54.968044+00	1
19442	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 60.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 10:25:54.995565+00	1
19445	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 26.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 10:25:55.281853+00	1
19454	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 5.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778149564710"}	2026-05-07 10:26:00.350665+00	1
19458	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 16.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565274"}	2026-05-07 10:26:00.951372+00	1
19463	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 11.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565278"}	2026-05-07 10:26:01.26814+00	1
19465	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 7.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565278"}	2026-05-07 10:26:01.490901+00	1
19468	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 30.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 10:26:18.614248+00	1
19472	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 29.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 10:26:18.920946+00	1
19477	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 32.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 10:26:31.649053+00	1
19480	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 53.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:31.677002+00	1
19235	Viewed/List Branches	GET	/api/branches	200	152.58.216.49	1	{"process_time_ms": 42.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:51:11.719267+00	1
19239	Viewed/List Types	GET	/api/rooms/types	200	152.58.216.49	1	{"process_time_ms": 20.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:51:11.831145+00	1
19246	Viewed/List 	GET	/api/rooms/	200	152.58.216.49	1	{"process_time_ms": 28.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 05:54:39.629598+00	1
19253	Viewed/List Items	GET	/api/inventory/items	200	152.58.216.49	1	{"process_time_ms": 24.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 05:54:40.515313+00	1
19339	Viewed/List Rooms	GET	/api/public/rooms	200	118.185.127.97	\N	{"process_time_ms": 29.7, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140713877"}	2026-05-07 07:58:35.264595+00	1
19343	Viewed/List Food Categories	GET	/api/public/food-categories	200	118.185.127.97	\N	{"process_time_ms": 10.46, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.336144+00	1
19356	Viewed/List 	GET	/api/signature-experiences/	200	66.249.65.69	\N	{"process_time_ms": 30.46, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:21.636455+00	1
19365	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 5.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 09:01:09.393365+00	1
19378	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 5.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.564157+00	1
19389	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 31.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778148182056"}	2026-05-07 10:02:57.721615+00	1
19392	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 21.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:58.695138+00	1
19414	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 51.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 10:13:53.087609+00	1
19417	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 81.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:53.111484+00	1
19421	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 9.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:53.393647+00	1
19424	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 34.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778148851881"}	2026-05-07 10:14:08.094735+00	1
19457	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 10.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565273"}	2026-05-07 10:26:00.94337+00	1
19466	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 11.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565278"}	2026-05-07 10:26:01.49479+00	1
19467	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 29.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 10:26:18.610804+00	1
19469	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 40.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:18.617831+00	1
19473	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 36.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 10:26:18.929716+00	1
19478	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 41.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 10:26:31.660485+00	1
19481	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 67.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:31.686739+00	1
19484	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 11.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 10:26:31.945709+00	1
19485	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 14.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:31.955061+00	1
19486	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 10:26:32.224921+00	1
19255	Viewed/List Branches	GET	/api/public/branches	200	118.185.127.97	\N	{"process_time_ms": 91.98, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-07 07:29:11.433537+00	1
19259	Viewed/List 	GET	/api/resort-info/	200	118.185.127.97	\N	{"process_time_ms": 13.41, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952618"}	2026-05-07 07:29:12.756549+00	1
19263	Viewed/List 	GET	/api/header-banner/	200	118.185.127.97	\N	{"process_time_ms": 14.02, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.296913+00	1
19272	Viewed/List Bookings	GET	/api/public/bookings	200	118.185.127.97	\N	{"process_time_ms": 13.92, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778138999498"}	2026-05-07 07:29:59.637518+00	1
19298	Viewed/List 	GET	/api/nearby-attractions/	200	118.185.127.97	\N	{"process_time_ms": 11.83, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139009431"}	2026-05-07 07:30:09.892177+00	1
19310	Viewed/List 	GET	/api/gallery/	200	118.185.127.97	\N	{"process_time_ms": 36.04, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139016551"}	2026-05-07 07:30:16.727479+00	1
19313	Viewed/List 	GET	/api/nearby-attractions/	200	118.185.127.97	\N	{"process_time_ms": 18.69, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139016552"}	2026-05-07 07:30:17.009431+00	1
19331	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 90.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 07:37:07.048383+00	1
19335	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 07:37:07.613211+00	1
19340	Viewed/List Bookings	GET	/api/public/bookings	200	118.185.127.97	\N	{"process_time_ms": 13.84, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778140715390"}	2026-05-07 07:58:35.534052+00	1
19347	Viewed/List Packages	GET	/api/public/packages	200	118.185.127.97	\N	{"process_time_ms": 28.76, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.884579+00	1
19352	Viewed/List 	GET	/api/nearby-attractions/	200	118.185.127.97	\N	{"process_time_ms": 43.93, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716197"}	2026-05-07 07:58:36.91698+00	1
19357	Viewed/List Food Items	GET	/api/public/food-items	200	66.249.65.69	\N	{"process_time_ms": 30.26, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:22.099905+00	1
19366	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 13.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144472850"}	2026-05-07 09:01:09.63208+00	1
19375	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 12.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.315918+00	1
19379	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 7.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.585827+00	1
19384	Viewed/List 	GET	/api/gallery/	200	66.249.65.68	\N	{"process_time_ms": 5.5, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:02:02.363085+00	1
19390	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 27.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778148182377"}	2026-05-07 10:02:58.122551+00	1
19394	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 45.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:58.710469+00	1
19399	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 26.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:59.015298+00	1
19403	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 21.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:39.443961+00	1
19410	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 20.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 10:13:40.307922+00	1
19418	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 76.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:53.118632+00	1
19422	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 9.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 10:13:53.644564+00	1
19256	Viewed/List Rooms	GET	/api/public/rooms	200	118.185.127.97	\N	{"process_time_ms": 42.57, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138951174"}	2026-05-07 07:29:11.864591+00	1
19268	Viewed/List 	GET	/api/reviews/	200	118.185.127.97	\N	{"process_time_ms": 27.1, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.588582+00	1
19275	Viewed/List Food Items	GET	/api/public/food-items	200	118.185.127.97	\N	{"process_time_ms": 18.55, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139000436"}	2026-05-07 07:30:00.58461+00	1
19290	Viewed/List Food Items	GET	/api/public/food-items	200	118.185.127.97	\N	{"process_time_ms": 24.09, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778139009431"}	2026-05-07 07:30:09.583004+00	1
19293	Viewed/List 	GET	/api/reviews/	200	118.185.127.97	\N	{"process_time_ms": 38.99, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778139009431"}	2026-05-07 07:30:09.606958+00	1
19302	Viewed/List Bookings	GET	/api/public/bookings	200	118.185.127.97	\N	{"process_time_ms": 6.74, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778139015711"}	2026-05-07 07:30:15.847155+00	1
19318	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 12.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 07:36:36.836125+00	1
19325	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 07:36:37.613869+00	1
19341	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	118.185.127.97	\N	{"process_time_ms": 10.95, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778140715660"}	2026-05-07 07:58:35.801935+00	1
19358	Viewed/List Services	GET	/api/public/services	200	66.249.65.69	\N	{"process_time_ms": 27.78, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:22.549906+00	1
19367	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 9.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778144473916"}	2026-05-07 09:01:09.91677+00	1
19371	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 17.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.027373+00	1
19376	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 5.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.51569+00	1
19385	Viewed/List Packages	GET	/api/public/packages	200	66.249.65.70	\N	{"process_time_ms": 5.83, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:02:02.864903+00	1
19391	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 8.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148182774"}	2026-05-07 10:02:58.399749+00	1
19400	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 6.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:59.04696+00	1
19412	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 8.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 10:13:41.414441+00	1
19413	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 39.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:53.071675+00	1
19415	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 58.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 10:13:53.100752+00	1
19419	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 15.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 10:13:53.361881+00	1
19427	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 14.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:14:22.068725+00	1
19437	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 39.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:25:44.117575+00	1
19450	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 34.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778149560799"}	2026-05-07 10:25:56.467791+00	1
19459	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 24.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778149565274"}	2026-05-07 10:26:00.954514+00	1
19257	Viewed/List Bookings	GET	/api/public/bookings	200	118.185.127.97	\N	{"process_time_ms": 48.04, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778138951994"}	2026-05-07 07:29:12.187026+00	1
19265	Viewed/List 	GET	/api/signature-experiences/	200	118.185.127.97	\N	{"process_time_ms": 19.11, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.371866+00	1
19269	Viewed/List 	GET	/api/gallery/	200	118.185.127.97	\N	{"process_time_ms": 30.68, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778138952907"}	2026-05-07 07:29:13.591886+00	1
19273	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	118.185.127.97	\N	{"process_time_ms": 11.87, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778138999812"}	2026-05-07 07:29:59.950114+00	1
19276	Viewed/List Food Categories	GET	/api/public/food-categories	200	118.185.127.97	\N	{"process_time_ms": 17.21, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139000436"}	2026-05-07 07:30:00.595536+00	1
19280	Viewed/List 	GET	/api/signature-experiences/	200	118.185.127.97	\N	{"process_time_ms": 19.13, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139000437"}	2026-05-07 07:30:00.877469+00	1
19284	Viewed/List 	GET	/api/reviews/	200	118.185.127.97	\N	{"process_time_ms": 5.48, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778139000437"}	2026-05-07 07:30:01.196679+00	1
19288	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	118.185.127.97	\N	{"process_time_ms": 6.88, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=2&_t=1778139008894"}	2026-05-07 07:30:09.027656+00	1
19307	Viewed/List 	GET	/api/header-banner/	200	118.185.127.97	\N	{"process_time_ms": 22.79, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778139016551"}	2026-05-07 07:30:16.717168+00	1
19323	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 21.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 07:36:37.246974+00	1
19342	Viewed/List 	GET	/api/resort-info/	200	118.185.127.97	\N	{"process_time_ms": 9.29, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140715929"}	2026-05-07 07:58:36.069644+00	1
19351	Viewed/List 	GET	/api/header-banner/	200	118.185.127.97	\N	{"process_time_ms": 47.48, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1", "query_params": "_t=1778140716196"}	2026-05-07 07:58:36.911044+00	1
19359	Viewed/List 	GET	/api/reviews/	200	66.249.65.70	\N	{"process_time_ms": 8.91, "user_agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-07 09:00:23.004277+00	1
19368	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 8.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778144474434"}	2026-05-07 09:01:10.433245+00	1
19377	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 5.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778144475009"}	2026-05-07 09:01:11.529828+00	1
19393	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 31.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:58.705523+00	1
19398	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 24.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778148183049"}	2026-05-07 10:02:59.006147+00	1
19409	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 35.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:40.277089+00	1
19416	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 62.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:13:53.105133+00	1
19423	Viewed/List 	GET	/api/food-items/	200	103.72.178.237	1	{"process_time_ms": 24.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:14:08.080174+00	1
19446	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 21.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 10:25:55.286115+00	1
19470	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 49.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:18.620979+00	1
19471	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 22.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:18.907044+00	1
19474	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 40.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:18.938744+00	1
19487	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 14.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:37.027581+00	1
19488	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 13.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778149599045"}	2026-05-07 10:26:37.286004+00	1
19489	Viewed/List Branches	GET	/api/public/branches	200	27.60.135.31	\N	{"process_time_ms": 4.95, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-07 10:26:41.309838+00	1
19490	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.135.31	\N	{"process_time_ms": 11.69, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149601156"}	2026-05-07 10:26:41.896871+00	1
19491	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.135.31	\N	{"process_time_ms": 7.11, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778149602334"}	2026-05-07 10:26:42.488165+00	1
19492	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.135.31	\N	{"process_time_ms": 5.48, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778149602637"}	2026-05-07 10:26:42.791541+00	1
19493	Viewed/List 	GET	/api/resort-info/	200	27.60.135.31	\N	{"process_time_ms": 5.03, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149602932"}	2026-05-07 10:26:43.083008+00	1
19494	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.135.31	\N	{"process_time_ms": 5.91, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603223"}	2026-05-07 10:26:43.376298+00	1
19495	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.135.31	\N	{"process_time_ms": 6.19, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603224"}	2026-05-07 10:26:43.391896+00	1
19496	Viewed/List Packages	GET	/api/public/packages	200	27.60.135.31	\N	{"process_time_ms": 13.38, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603224"}	2026-05-07 10:26:43.396392+00	1
19497	Viewed/List 	GET	/api/reviews/	200	27.60.135.31	\N	{"process_time_ms": 5.81, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603225"}	2026-05-07 10:26:43.475062+00	1
19498	Viewed/List 	GET	/api/header-banner/	200	27.60.135.31	\N	{"process_time_ms": 5.02, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603225"}	2026-05-07 10:26:43.680191+00	1
19499	Viewed/List Services	GET	/api/public/services	200	27.60.135.31	\N	{"process_time_ms": 7.18, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603226"}	2026-05-07 10:26:43.695127+00	1
19500	Viewed/List 	GET	/api/signature-experiences/	200	27.60.135.31	\N	{"process_time_ms": 13.03, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603226"}	2026-05-07 10:26:43.698949+00	1
19501	Viewed/List 	GET	/api/plan-weddings/	200	27.60.135.31	\N	{"process_time_ms": 5.15, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603226"}	2026-05-07 10:26:43.79469+00	1
19502	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.135.31	\N	{"process_time_ms": 5.31, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603227"}	2026-05-07 10:26:43.897306+00	1
19503	Viewed/List 	GET	/api/gallery/	200	27.60.135.31	\N	{"process_time_ms": 5.26, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603224"}	2026-05-07 10:26:43.962534+00	1
19504	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.135.31	\N	{"process_time_ms": 5.13, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149603227"}	2026-05-07 10:26:43.993802+00	1
19505	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.135.31	\N	{"process_time_ms": 11.46, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149606994"}	2026-05-07 10:26:48.508268+00	1
19506	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.135.31	\N	{"process_time_ms": 6.1, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778149608654"}	2026-05-07 10:26:48.820038+00	1
19507	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.135.31	\N	{"process_time_ms": 6.08, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778149608969"}	2026-05-07 10:26:49.127487+00	1
19508	Viewed/List 	GET	/api/resort-info/	200	27.60.135.31	\N	{"process_time_ms": 6.24, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149609269"}	2026-05-07 10:26:49.418832+00	1
19509	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.135.31	\N	{"process_time_ms": 14.35, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149609563"}	2026-05-07 10:26:49.731623+00	1
19510	Viewed/List 	GET	/api/gallery/	200	27.60.135.31	\N	{"process_time_ms": 23.16, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149609564"}	2026-05-07 10:26:49.735247+00	1
19513	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 21.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778149614186"}	2026-05-07 10:26:49.844313+00	1
19518	Viewed/List 	GET	/api/signature-experiences/	200	27.60.135.31	\N	{"process_time_ms": 19.83, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149609566"}	2026-05-07 10:26:50.062925+00	1
19527	Viewed/List Services	GET	/api/public/services	200	27.60.135.31	\N	{"process_time_ms": 5.57, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149660883"}	2026-05-07 10:27:41.355219+00	1
19536	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.135.31	\N	{"process_time_ms": 18.22, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149660883"}	2026-05-07 10:27:41.973531+00	1
19545	Viewed/List Services	GET	/api/public/services	200	27.60.135.31	\N	{"process_time_ms": 4.9, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149670017"}	2026-05-07 10:27:50.473932+00	1
19554	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.135.31	\N	{"process_time_ms": 6.38, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=2&_t=1778149674722"}	2026-05-07 10:27:54.883603+00	1
19576	Viewed/List 	GET	/api/header-banner/	200	27.60.134.255	\N	{"process_time_ms": 5.8, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:49.828286+00	1
19585	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.134.224	\N	{"process_time_ms": 7.32, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778149807701"}	2026-05-07 10:30:07.870199+00	1
19593	Viewed/List Packages	GET	/api/public/packages	200	27.60.134.224	\N	{"process_time_ms": 39.38, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149808681"}	2026-05-07 10:30:09.508746+00	1
19602	Viewed/List 	GET	/api/resort-info/	200	27.60.134.224	\N	{"process_time_ms": 4.66, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149810294"}	2026-05-07 10:30:10.453267+00	1
19605	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.134.224	\N	{"process_time_ms": 36.34, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149810599"}	2026-05-07 10:30:10.794314+00	1
19610	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.134.224	\N	{"process_time_ms": 14.77, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149810600"}	2026-05-07 10:30:11.115885+00	1
19619	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.135.26	\N	{"process_time_ms": 6.85, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849672"}	2026-05-07 10:30:49.834357+00	1
19628	Viewed/List 	GET	/api/gallery/	200	27.60.135.26	\N	{"process_time_ms": 28.89, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849673"}	2026-05-07 10:30:50.485253+00	1
19859	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 14.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:51:19.569232+00	1
19865	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 165.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:51:22.881868+00	1
19869	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 39.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 12:51:23.468933+00	1
19981	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 129.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:07:20.282896+00	1
19985	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 22.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:07:20.683658+00	1
19989	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 11.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:07:20.924208+00	1
19993	Created/Added Bookings	POST	/api/bookings	400	103.72.178.107	1	{"process_time_ms": 474.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:11:39.832079+00	1
20000	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 43.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:38.943778+00	1
20003	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 84.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 18:12:38.990708+00	1
19511	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.135.31	\N	{"process_time_ms": 21.97, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149609561"}	2026-05-07 10:26:49.744018+00	1
19515	Viewed/List 	GET	/api/reviews/	200	27.60.135.31	\N	{"process_time_ms": 5.25, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149609565"}	2026-05-07 10:26:50.034117+00	1
19524	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.135.31	\N	{"process_time_ms": 5.82, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=2&_t=1778149660224"}	2026-05-07 10:27:40.390084+00	1
19532	Viewed/List 	GET	/api/gallery/	200	27.60.135.31	\N	{"process_time_ms": 16.6, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149660883"}	2026-05-07 10:27:41.673995+00	1
19537	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.135.31	\N	{"process_time_ms": 10.73, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149668099"}	2026-05-07 10:27:48.858602+00	1
19556	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.135.31	\N	{"process_time_ms": 5.49, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149675334"}	2026-05-07 10:27:55.492898+00	1
19565	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.135.31	\N	{"process_time_ms": 6.63, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149675335"}	2026-05-07 10:27:56.425729+00	1
19572	Viewed/List 	GET	/api/resort-info/	200	27.60.134.255	\N	{"process_time_ms": 6.66, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789095"}	2026-05-07 10:29:49.25339+00	1
19581	Viewed/List 	GET	/api/reviews/	200	27.60.134.255	\N	{"process_time_ms": 6.29, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:50.146149+00	1
19592	Viewed/List 	GET	/api/reviews/	200	27.60.134.224	\N	{"process_time_ms": 34.06, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149808681"}	2026-05-07 10:30:09.50305+00	1
19597	Viewed/List 	GET	/api/gallery/	200	27.60.134.224	\N	{"process_time_ms": 40.73, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149808681"}	2026-05-07 10:30:09.533041+00	1
19604	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.134.224	\N	{"process_time_ms": 35.8, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149810599"}	2026-05-07 10:30:10.790476+00	1
19615	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.135.26	\N	{"process_time_ms": 11.06, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149847130"}	2026-05-07 10:30:48.45654+00	1
19860	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 70.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 12:51:22.795585+00	1
19861	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 102.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:51:22.821381+00	1
19982	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 141.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:07:20.393925+00	1
19990	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 21.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 18:07:21.112168+00	1
19994	Created/Added Bookings	POST	/api/bookings	400	103.72.178.107	1	{"process_time_ms": 474.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:11:48.028827+00	1
20009	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 18.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 18:12:39.560811+00	1
20022	Created/Added Bookings	POST	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 501.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:50.98313+00	1
20030	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.107	1	{"process_time_ms": 27.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 18:13:54.589428+00	1
20033	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 38.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:54.963997+00	1
20045	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 17.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:14:25.517738+00	1
20048	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 13.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:15:55.982215+00	1
19512	Viewed/List Packages	GET	/api/public/packages	200	27.60.135.31	\N	{"process_time_ms": 30.86, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149609564"}	2026-05-07 10:26:49.748409+00	1
19520	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.135.31	\N	{"process_time_ms": 8.02, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149609567"}	2026-05-07 10:26:50.365554+00	1
19540	Viewed/List 	GET	/api/resort-info/	200	27.60.135.31	\N	{"process_time_ms": 4.62, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149669702"}	2026-05-07 10:27:49.867693+00	1
19549	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.135.31	\N	{"process_time_ms": 5.23, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149670019"}	2026-05-07 10:27:50.764071+00	1
19558	Viewed/List 	GET	/api/signature-experiences/	200	27.60.135.31	\N	{"process_time_ms": 5.14, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149675334"}	2026-05-07 10:27:56.092573+00	1
19562	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.135.31	\N	{"process_time_ms": 20.66, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149675334"}	2026-05-07 10:27:56.140853+00	1
19573	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.134.255	\N	{"process_time_ms": 13.28, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:49.57628+00	1
19578	Viewed/List 	GET	/api/plan-weddings/	200	27.60.134.255	\N	{"process_time_ms": 8.62, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:49.899521+00	1
19583	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.134.255	\N	{"process_time_ms": 4.66, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:50.177309+00	1
19596	Viewed/List 	GET	/api/plan-weddings/	200	27.60.134.224	\N	{"process_time_ms": 45.75, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149808681"}	2026-05-07 10:30:09.525875+00	1
19601	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.134.224	\N	{"process_time_ms": 5.84, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=2&_t=1778149809985"}	2026-05-07 10:30:10.158763+00	1
19603	Viewed/List 	GET	/api/gallery/	200	27.60.134.224	\N	{"process_time_ms": 24.23, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149810599"}	2026-05-07 10:30:10.777119+00	1
19607	Viewed/List 	GET	/api/reviews/	200	27.60.134.224	\N	{"process_time_ms": 38.04, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149810600"}	2026-05-07 10:30:10.801155+00	1
19611	Viewed/List 	GET	/api/plan-weddings/	200	27.60.134.224	\N	{"process_time_ms": 22.43, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149810600"}	2026-05-07 10:30:11.128061+00	1
19616	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.135.26	\N	{"process_time_ms": 6.2, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778149848760"}	2026-05-07 10:30:48.914693+00	1
19863	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 119.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:51:22.847037+00	1
19867	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 31.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:51:23.141848+00	1
19983	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 55.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 18:07:20.642243+00	1
19987	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.107	1	{"process_time_ms": 39.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 18:07:20.796951+00	1
20018	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.107	1	{"process_time_ms": 8.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 18:12:43.004466+00	1
20031	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 24.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:54.598835+00	1
20049	Updated/Modified 3	PUT	/api/rooms/types/3	200	103.72.178.107	1	{"process_time_ms": 28.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:26.770653+00	1
20056	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 8.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:51.399946+00	1
20068	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.107	1	{"process_time_ms": 11.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 18:16:52.957249+00	1
19514	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 26.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:26:49.847779+00	1
19523	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.135.31	\N	{"process_time_ms": 6.04, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=2&_t=1778149659914"}	2026-05-07 10:27:40.071142+00	1
19533	Viewed/List 	GET	/api/signature-experiences/	200	27.60.135.31	\N	{"process_time_ms": 11.5, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149660883"}	2026-05-07 10:27:41.677645+00	1
19546	Viewed/List 	GET	/api/signature-experiences/	200	27.60.135.31	\N	{"process_time_ms": 4.88, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149670018"}	2026-05-07 10:27:50.505931+00	1
19550	Viewed/List 	GET	/api/header-banner/	200	27.60.135.31	\N	{"process_time_ms": 7.13, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149670017"}	2026-05-07 10:27:50.779149+00	1
19555	Viewed/List 	GET	/api/resort-info/	200	27.60.135.31	\N	{"process_time_ms": 4.76, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149675028"}	2026-05-07 10:27:55.188286+00	1
19564	Viewed/List 	GET	/api/plan-weddings/	200	27.60.135.31	\N	{"process_time_ms": 4.91, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149675334"}	2026-05-07 10:27:56.393508+00	1
19567	Created/Added Bookings	POST	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 1343.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:29:32.911508+00	1
19571	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.134.255	\N	{"process_time_ms": 6.03, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778149788795"}	2026-05-07 10:29:48.955023+00	1
19580	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.134.255	\N	{"process_time_ms": 6.57, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:50.133581+00	1
19589	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.134.224	\N	{"process_time_ms": 7.59, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149808680"}	2026-05-07 10:30:08.845804+00	1
19608	Viewed/List 	GET	/api/header-banner/	200	27.60.134.224	\N	{"process_time_ms": 40.89, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149810600"}	2026-05-07 10:30:10.804825+00	1
19612	Viewed/List 	GET	/api/signature-experiences/	200	27.60.134.224	\N	{"process_time_ms": 27.14, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149810600"}	2026-05-07 10:30:11.132227+00	1
19621	Viewed/List 	GET	/api/signature-experiences/	200	27.60.135.26	\N	{"process_time_ms": 5.76, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849675"}	2026-05-07 10:30:50.138806+00	1
19624	Viewed/List 	GET	/api/plan-weddings/	200	27.60.135.26	\N	{"process_time_ms": 19.22, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849675"}	2026-05-07 10:30:50.464067+00	1
19864	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 148.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 12:51:22.866808+00	1
19984	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 63.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 18:07:20.675053+00	1
19992	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 15.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:08:42.630323+00	1
19996	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.107	1	{"process_time_ms": 33.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778177523411"}	2026-05-07 18:11:58.717791+00	1
20020	Created/Added Bookings	POST	/api/bookings	400	103.72.178.107	1	{"process_time_ms": 471.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:23.439132+00	1
20034	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 47.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 18:13:54.971635+00	1
20064	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 28.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 18:16:52.695893+00	1
20105	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 23.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 04:14:39.476178+00	1
20561	Viewed/List Env	GET	/api/env	404	45.148.10.249	\N	{"process_time_ms": 1.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:34.697985+00	1
19516	Viewed/List 	GET	/api/header-banner/	200	27.60.135.31	\N	{"process_time_ms": 10.57, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149609565"}	2026-05-07 10:26:50.055073+00	1
19526	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.135.31	\N	{"process_time_ms": 7.19, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149660872"}	2026-05-07 10:27:41.047756+00	1
19530	Viewed/List 	GET	/api/reviews/	200	27.60.135.31	\N	{"process_time_ms": 27.03, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149660883"}	2026-05-07 10:27:41.652065+00	1
19534	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.135.31	\N	{"process_time_ms": 11.93, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149660883"}	2026-05-07 10:27:41.961261+00	1
19539	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.135.31	\N	{"process_time_ms": 6.35, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778149669334"}	2026-05-07 10:27:49.49326+00	1
19543	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.135.31	\N	{"process_time_ms": 21.86, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149670013"}	2026-05-07 10:27:50.196087+00	1
19548	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.135.31	\N	{"process_time_ms": 10.88, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149670019"}	2026-05-07 10:27:50.523459+00	1
19557	Viewed/List Services	GET	/api/public/services	200	27.60.135.31	\N	{"process_time_ms": 5.68, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149675334"}	2026-05-07 10:27:55.804159+00	1
19560	Viewed/List 	GET	/api/header-banner/	200	27.60.135.31	\N	{"process_time_ms": 25.52, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149675334"}	2026-05-07 10:27:56.133727+00	1
19566	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.135.31	\N	{"process_time_ms": 5.21, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149675335"}	2026-05-07 10:27:56.454765+00	1
19582	Viewed/List 	GET	/api/gallery/	200	27.60.134.255	\N	{"process_time_ms": 5.49, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:50.165014+00	1
19591	Viewed/List 	GET	/api/header-banner/	200	27.60.134.224	\N	{"process_time_ms": 16.84, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149808681"}	2026-05-07 10:30:09.165238+00	1
19594	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.134.224	\N	{"process_time_ms": 31.35, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149808681"}	2026-05-07 10:30:09.515513+00	1
19599	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.134.224	\N	{"process_time_ms": 26.23, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149808681"}	2026-05-07 10:30:09.838388+00	1
19614	Viewed/List Branches	GET	/api/public/branches	200	27.60.135.26	\N	{"process_time_ms": 5.73, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-07 10:30:47.878168+00	1
19623	Viewed/List 	GET	/api/header-banner/	200	27.60.135.26	\N	{"process_time_ms": 5.65, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849674"}	2026-05-07 10:30:50.434284+00	1
19627	Viewed/List Packages	GET	/api/public/packages	200	27.60.135.26	\N	{"process_time_ms": 36.47, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849673"}	2026-05-07 10:30:50.481622+00	1
19866	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 27.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 12:51:23.096511+00	1
19986	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.107	1	{"process_time_ms": 46.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 18:07:20.792387+00	1
19997	Updated/Modified 2	PUT	/api/rooms/types/2	200	103.72.178.107	1	{"process_time_ms": 39.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:22.159509+00	1
20002	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 69.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 18:12:38.97958+00	1
20006	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.107	1	{"process_time_ms": 14.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 18:12:39.242968+00	1
20015	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 78.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:42.736963+00	1
20562	Viewed/List Env	GET	/api/config/env	404	45.148.10.249	\N	{"process_time_ms": 1.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:34.814539+00	1
19517	Viewed/List Services	GET	/api/public/services	200	27.60.135.31	\N	{"process_time_ms": 18.31, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149609566"}	2026-05-07 10:26:50.059231+00	1
19522	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.135.31	\N	{"process_time_ms": 13.35, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149658999"}	2026-05-07 10:27:39.76413+00	1
19531	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.135.31	\N	{"process_time_ms": 24.5, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149660883"}	2026-05-07 10:27:41.658063+00	1
19535	Viewed/List 	GET	/api/plan-weddings/	200	27.60.135.31	\N	{"process_time_ms": 15.1, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149660883"}	2026-05-07 10:27:41.965196+00	1
19544	Viewed/List Packages	GET	/api/public/packages	200	27.60.135.31	\N	{"process_time_ms": 24.02, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149670015"}	2026-05-07 10:27:50.199452+00	1
19553	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.135.31	\N	{"process_time_ms": 6.07, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=2&_t=1778149674424"}	2026-05-07 10:27:54.574622+00	1
19561	Viewed/List Packages	GET	/api/public/packages	200	27.60.135.31	\N	{"process_time_ms": 34.98, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149675334"}	2026-05-07 10:27:56.137521+00	1
19569	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.134.255	\N	{"process_time_ms": 11.52, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149787591"}	2026-05-07 10:29:48.350269+00	1
19577	Viewed/List Services	GET	/api/public/services	200	27.60.134.255	\N	{"process_time_ms": 5.88, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:49.883981+00	1
19586	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.134.224	\N	{"process_time_ms": 7.09, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778149808027"}	2026-05-07 10:30:08.20072+00	1
19590	Viewed/List Services	GET	/api/public/services	200	27.60.134.224	\N	{"process_time_ms": 8.0, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149808681"}	2026-05-07 10:30:09.157708+00	1
19600	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.134.224	\N	{"process_time_ms": 19.41, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=2&_t=1778149808996"}	2026-05-07 10:30:09.845645+00	1
19609	Viewed/List Services	GET	/api/public/services	200	27.60.134.224	\N	{"process_time_ms": 6.19, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149810600"}	2026-05-07 10:30:11.083715+00	1
19618	Viewed/List 	GET	/api/resort-info/	200	27.60.135.26	\N	{"process_time_ms": 4.96, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849368"}	2026-05-07 10:30:49.524115+00	1
19626	Viewed/List 	GET	/api/nearby-attractions/	200	27.60.135.26	\N	{"process_time_ms": 22.4, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849676"}	2026-05-07 10:30:50.478209+00	1
19868	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 31.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 12:51:23.154727+00	1
19988	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 65.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:07:20.806448+00	1
19995	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 28.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:11:58.708682+00	1
20025	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 84.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:54.29465+00	1
20029	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.107	1	{"process_time_ms": 21.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 18:13:54.585472+00	1
20032	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 33.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:54.955035+00	1
20041	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 19.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 18:13:55.801581+00	1
20061	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 18.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:52.28027+00	1
20073	Created/Added Bookings	POST	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 495.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:17:35.457657+00	1
19519	Viewed/List 	GET	/api/plan-weddings/	200	27.60.135.31	\N	{"process_time_ms": 5.66, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149609567"}	2026-05-07 10:26:50.324279+00	1
19551	Viewed/List 	GET	/api/reviews/	200	27.60.135.31	\N	{"process_time_ms": 11.98, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149670016"}	2026-05-07 10:27:50.78236+00	1
19568	Viewed/List Branches	GET	/api/public/branches	200	27.60.134.255	\N	{"process_time_ms": 6.74, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-07 10:29:47.774072+00	1
19587	Viewed/List 	GET	/api/resort-info/	200	27.60.134.224	\N	{"process_time_ms": 6.06, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149808349"}	2026-05-07 10:30:08.519766+00	1
19595	Viewed/List 	GET	/api/signature-experiences/	200	27.60.134.224	\N	{"process_time_ms": 42.03, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149808681"}	2026-05-07 10:30:09.522106+00	1
19620	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.135.26	\N	{"process_time_ms": 11.27, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849671"}	2026-05-07 10:30:49.843315+00	1
19629	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.135.26	\N	{"process_time_ms": 5.51, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849676"}	2026-05-07 10:30:50.723624+00	1
19870	Viewed/List Branches	GET	/api/public/branches	200	205.169.39.107	\N	{"process_time_ms": 87.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": ""}	2026-05-07 13:25:23.258071+00	1
19884	Viewed/List 	GET	/api/nearby-attractions/	200	205.169.39.107	\N	{"process_time_ms": 43.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324945"}	2026-05-07 13:25:25.160149+00	1
19909	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.209	1	{"process_time_ms": 27.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 13:52:34.03687+00	1
19912	Viewed/List 	GET	/api/packages/	200	205.254.184.209	1	{"process_time_ms": 27.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161990662"}	2026-05-07 13:53:13.033396+00	1
19931	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 50.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:34.50111+00	1
19943	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.209	1	{"process_time_ms": 19.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 13:54:14.237313+00	1
19991	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.107	1	{"process_time_ms": 28.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778177326533"}	2026-05-07 18:08:42.34745+00	1
20012	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 71.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 18:12:42.720635+00	1
20016	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 15.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:42.984688+00	1
20037	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 26.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:55.264369+00	1
20052	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 14.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:50.858841+00	1
20060	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 8.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:52.162435+00	1
20063	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 20.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:52.676032+00	1
20072	Created/Added Bookings	POST	/api/bookings	400	103.72.178.107	1	{"process_time_ms": 472.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:17:13.561716+00	1
20108	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.107	1	{"process_time_ms": 23.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778213726630"}	2026-05-08 04:15:21.976247+00	1
20205	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 14.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430515"}	2026-05-08 07:13:52.014673+00	1
20361	Viewed/List Food Categories	GET	/api/food-categories	200	205.254.184.6	1	{"process_time_ms": 30.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:58.744482+00	1
20373	Viewed/List 	GET	/api/settings/	200	205.254.184.6	1	{"process_time_ms": 83.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:05.831846+00	1
19521	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.135.31	\N	{"process_time_ms": 10.69, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149609568"}	2026-05-07 10:26:50.371643+00	1
19529	Viewed/List 	GET	/api/header-banner/	200	27.60.135.31	\N	{"process_time_ms": 19.17, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149660883"}	2026-05-07 10:27:41.648832+00	1
19538	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.135.31	\N	{"process_time_ms": 5.94, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&branch_id=1&_t=1778149669006"}	2026-05-07 10:27:49.163055+00	1
19541	Viewed/List 	GET	/api/gallery/	200	27.60.135.31	\N	{"process_time_ms": 16.62, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149670015"}	2026-05-07 10:27:50.186371+00	1
19563	Viewed/List 	GET	/api/gallery/	200	27.60.135.31	\N	{"process_time_ms": 29.68, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149675334"}	2026-05-07 10:27:56.143944+00	1
19570	Viewed/List Bookings	GET	/api/public/bookings	200	27.60.134.255	\N	{"process_time_ms": 6.26, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778149788486"}	2026-05-07 10:29:48.648176+00	1
19574	Viewed/List Food Items	GET	/api/public/food-items	200	27.60.134.255	\N	{"process_time_ms": 20.63, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:49.580537+00	1
19579	Viewed/List 	GET	/api/signature-experiences/	200	27.60.134.255	\N	{"process_time_ms": 11.18, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:49.90358+00	1
19588	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.134.224	\N	{"process_time_ms": 15.11, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149808013"}	2026-05-07 10:30:08.768644+00	1
19598	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.134.224	\N	{"process_time_ms": 10.94, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149808681"}	2026-05-07 10:30:09.827206+00	1
19606	Viewed/List Packages	GET	/api/public/packages	200	27.60.134.224	\N	{"process_time_ms": 33.85, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149810599"}	2026-05-07 10:30:10.797817+00	1
19617	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	27.60.135.26	\N	{"process_time_ms": 5.79, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778149849061"}	2026-05-07 10:30:49.225478+00	1
19871	Viewed/List Rooms	GET	/api/public/rooms	200	205.169.39.107	\N	{"process_time_ms": 49.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160323110"}	2026-05-07 13:25:23.344374+00	1
19876	Viewed/List Food Items	GET	/api/public/food-items	200	205.169.39.107	\N	{"process_time_ms": 28.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324941"}	2026-05-07 13:25:24.987291+00	1
19907	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 23.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:52:33.996657+00	1
19944	Viewed/List Test	GET	/api/rooms/test	200	205.254.184.209	1	{"process_time_ms": 27.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778162080526"}	2026-05-07 13:54:42.891941+00	1
19947	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 16.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:55:06.424591+00	1
19998	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 14.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:22.438426+00	1
20028	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 96.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:54.309671+00	1
20038	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.107	1	{"process_time_ms": 12.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 18:13:55.443577+00	1
20044	Updated/Modified 2	PUT	/api/rooms/types/2	200	103.72.178.107	1	{"process_time_ms": 33.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:14:25.234827+00	1
20047	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.107	1	{"process_time_ms": 15.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778177760421"}	2026-05-07 18:15:55.706096+00	1
20057	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 8.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:51.645393+00	1
20069	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.107	1	{"process_time_ms": 9.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 18:16:52.972437+00	1
19525	Viewed/List 	GET	/api/resort-info/	200	27.60.135.31	\N	{"process_time_ms": 4.71, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149660553"}	2026-05-07 10:27:40.709893+00	1
19528	Viewed/List Packages	GET	/api/public/packages	200	27.60.135.31	\N	{"process_time_ms": 17.31, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149660883"}	2026-05-07 10:27:41.644243+00	1
19542	Viewed/List Food Categories	GET	/api/public/food-categories	200	27.60.135.31	\N	{"process_time_ms": 21.58, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149670014"}	2026-05-07 10:27:50.192982+00	1
19547	Viewed/List 	GET	/api/plan-weddings/	200	27.60.135.31	\N	{"process_time_ms": 7.51, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=1&_t=1778149670018"}	2026-05-07 10:27:50.520125+00	1
19552	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.135.31	\N	{"process_time_ms": 11.48, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149673529"}	2026-05-07 10:27:54.28338+00	1
19559	Viewed/List 	GET	/api/reviews/	200	27.60.135.31	\N	{"process_time_ms": 21.07, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149675334"}	2026-05-07 10:27:56.126368+00	1
19575	Viewed/List Packages	GET	/api/public/packages	200	27.60.134.255	\N	{"process_time_ms": 27.0, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149789400"}	2026-05-07 10:29:49.584078+00	1
19584	Viewed/List Rooms	GET	/api/public/rooms	200	27.60.134.224	\N	{"process_time_ms": 15.59, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149806632"}	2026-05-07 10:30:07.474123+00	1
19613	Viewed/List 	GET	/api/nearby-attraction-banners/	200	27.60.134.224	\N	{"process_time_ms": 30.27, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "branch_id=2&_t=1778149810600"}	2026-05-07 10:30:11.14242+00	1
19622	Viewed/List Services	GET	/api/public/services	200	27.60.135.26	\N	{"process_time_ms": 5.43, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849674"}	2026-05-07 10:30:50.151168+00	1
19625	Viewed/List 	GET	/api/reviews/	200	27.60.135.26	\N	{"process_time_ms": 25.91, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1", "query_params": "_t=1778149849674"}	2026-05-07 10:30:50.47423+00	1
19630	Viewed/List Branches	GET	/api/public/branches	200	223.181.11.146	\N	{"process_time_ms": 11.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:32:26.049241+00	1
19631	Viewed/List Rooms	GET	/api/public/rooms	200	223.181.11.146	\N	{"process_time_ms": 41.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149945320"}	2026-05-07 10:32:26.08259+00	1
19632	Viewed/List Bookings	GET	/api/public/bookings	200	223.181.11.146	\N	{"process_time_ms": 6.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&skip=0&_t=1778149945647"}	2026-05-07 10:32:26.598557+00	1
19633	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	223.181.11.146	\N	{"process_time_ms": 5.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&skip=0&_t=1778149946171"}	2026-05-07 10:32:26.90603+00	1
19634	Viewed/List 	GET	/api/resort-info/	200	223.181.11.146	\N	{"process_time_ms": 5.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946490"}	2026-05-07 10:32:27.219735+00	1
19635	Viewed/List Food Categories	GET	/api/public/food-categories	200	223.181.11.146	\N	{"process_time_ms": 7.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946785"}	2026-05-07 10:32:27.514468+00	1
19636	Viewed/List Food Items	GET	/api/public/food-items	200	223.181.11.146	\N	{"process_time_ms": 10.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946784"}	2026-05-07 10:32:27.517792+00	1
19637	Viewed/List Packages	GET	/api/public/packages	200	223.181.11.146	\N	{"process_time_ms": 5.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946785"}	2026-05-07 10:32:27.585319+00	1
19638	Viewed/List 	GET	/api/reviews/	200	223.181.11.146	\N	{"process_time_ms": 7.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946785"}	2026-05-07 10:32:27.822495+00	1
19639	Viewed/List 	GET	/api/gallery/	200	223.181.11.146	\N	{"process_time_ms": 11.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946785"}	2026-05-07 10:32:27.826076+00	1
19640	Viewed/List 	GET	/api/header-banner/	200	223.181.11.146	\N	{"process_time_ms": 5.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946785"}	2026-05-07 10:32:27.8928+00	1
19641	Viewed/List Services	GET	/api/public/services	200	223.181.11.146	\N	{"process_time_ms": 5.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946786"}	2026-05-07 10:32:28.063867+00	1
19642	Viewed/List 	GET	/api/plan-weddings/	200	223.181.11.146	\N	{"process_time_ms": 8.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946786"}	2026-05-07 10:32:28.149368+00	1
19643	Viewed/List 	GET	/api/signature-experiences/	200	223.181.11.146	\N	{"process_time_ms": 11.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946786"}	2026-05-07 10:32:28.15331+00	1
19872	Viewed/List Bookings	GET	/api/public/bookings	200	205.169.39.107	\N	{"process_time_ms": 32.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778160323632"}	2026-05-07 13:25:23.700095+00	1
19877	Viewed/List Packages	GET	/api/public/packages	200	205.169.39.107	\N	{"process_time_ms": 9.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324942"}	2026-05-07 13:25:25.017525+00	1
19886	Viewed/List Branches	GET	/api/public/branches	200	205.254.184.209	\N	{"process_time_ms": 37.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:52:24.696742+00	1
19905	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.209	1	{"process_time_ms": 87.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 13:52:33.730193+00	1
19908	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.209	1	{"process_time_ms": 41.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 13:52:34.023495+00	1
19916	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 24.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:13.966908+00	1
19929	Viewed/List 	GET	/api/food-items/	200	205.254.184.209	1	{"process_time_ms": 34.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:34.487556+00	1
19933	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 23.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:38.101032+00	1
19999	Created/Added Bookings	POST	/api/bookings	400	103.72.178.107	1	{"process_time_ms": 475.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:36.310957+00	1
20004	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 91.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:38.994302+00	1
20008	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 21.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:39.271792+00	1
20010	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 29.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:42.68709+00	1
20013	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 75.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:42.72464+00	1
20017	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.107	1	{"process_time_ms": 22.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 18:12:42.98815+00	1
20024	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 65.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 18:13:54.285934+00	1
20046	Created/Added Bookings	POST	/api/bookings	400	103.72.178.107	1	{"process_time_ms": 472.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:15:47.195022+00	1
20067	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 13.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:52.875139+00	1
20111	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 14.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:15:46.322683+00	1
20115	Viewed/List Rooms	GET	/api/public/rooms	200	180.178.127.178	\N	{"process_time_ms": 15.28, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214692081"}	2026-05-08 04:31:31.595986+00	1
20209	HEAD .Env	HEAD	/api/.env	404	213.209.159.175	\N	{"process_time_ms": 20.53, "user_agent": "Mozilla/5.0 (X11; NetBSD amd64; rv:16.0) Gecko/20121102 Firefox/16.0", "query_params": ""}	2026-05-08 07:52:20.122541+00	1
20365	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 57.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:21:01.137291+00	1
20381	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 9.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232067761"}	2026-05-08 09:21:08.655396+00	1
20413	Viewed/List Expenses	GET	/api/reports/expenses	200	205.254.184.6	1	{"process_time_ms": 8.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 09:24:48.549293+00	1
20416	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 11.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:26:21.768121+00	1
20424	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 8.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:26:22.850743+00	1
19644	Viewed/List 	GET	/api/nearby-attractions/	200	223.181.11.146	\N	{"process_time_ms": 6.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946786"}	2026-05-07 10:32:28.18809+00	1
19873	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	205.169.39.107	\N	{"process_time_ms": 27.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778160324430"}	2026-05-07 13:25:24.49362+00	1
19889	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	205.254.184.209	\N	{"process_time_ms": 7.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778161943106"}	2026-05-07 13:52:25.446143+00	1
19894	Viewed/List 	GET	/api/gallery/	200	205.254.184.209	\N	{"process_time_ms": 32.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943683"}	2026-05-07 13:52:26.053949+00	1
19899	Viewed/List 	GET	/api/plan-weddings/	200	205.254.184.209	\N	{"process_time_ms": 25.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943684"}	2026-05-07 13:52:26.353276+00	1
19911	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.209	1	{"process_time_ms": 9.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 13:52:34.319804+00	1
19932	Viewed/List Test	GET	/api/rooms/test	200	205.254.184.209	1	{"process_time_ms": 20.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778162015735"}	2026-05-07 13:53:38.088301+00	1
20001	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 48.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:38.956708+00	1
20005	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 92.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:39.002772+00	1
20021	Created/Added Bookings	POST	/api/bookings	400	103.72.178.107	1	{"process_time_ms": 465.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:44.627192+00	1
20026	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 84.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:54.303454+00	1
20035	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 14.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 18:13:55.238911+00	1
20043	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.107	1	{"process_time_ms": 38.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778177643487"}	2026-05-07 18:13:58.79225+00	1
20058	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 26.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:51.936781+00	1
20066	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 14.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:52.822728+00	1
20070	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 8.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:53.089777+00	1
20120	Viewed/List Food Categories	GET	/api/public/food-categories	200	180.178.127.178	\N	{"process_time_ms": 9.24, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693409"}	2026-05-08 04:31:32.960467+00	1
20125	Viewed/List Services	GET	/api/public/services	200	180.178.127.178	\N	{"process_time_ms": 7.26, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693410"}	2026-05-08 04:31:33.301813+00	1
20210	HEAD Test	HEAD	/api/test	404	213.209.159.175	\N	{"process_time_ms": 1.5, "user_agent": "Mozilla/5.0 (X11; NetBSD amd64; rv:16.0) Gecko/20121102 Firefox/16.0", "query_params": ""}	2026-05-08 07:52:32.294834+00	1
20374	Viewed/List Active Rooms	GET	/api/bill/active-rooms	200	205.254.184.6	1	{"process_time_ms": 97.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:05.841117+00	1
20379	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 13.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778232067177"}	2026-05-08 09:21:08.080163+00	1
20385	Viewed/List 	GET	/api/signature-experiences/	200	205.254.184.6	1	{"process_time_ms": 42.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:09.321143+00	1
20389	Viewed/List 	GET	/api/gallery/	200	205.254.184.6	1	{"process_time_ms": 62.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:09.341017+00	1
20398	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 21.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068044"}	2026-05-08 09:21:09.643999+00	1
20418	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 24.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 09:26:22.289008+00	1
19645	Viewed/List 	GET	/api/nearby-attraction-banners/	200	223.181.11.146	\N	{"process_time_ms": 4.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149946786"}	2026-05-07 10:32:28.348363+00	1
19874	Viewed/List 	GET	/api/resort-info/	200	205.169.39.107	\N	{"process_time_ms": 26.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324820"}	2026-05-07 13:25:24.881883+00	1
19879	Viewed/List 	GET	/api/reviews/	200	205.169.39.107	\N	{"process_time_ms": 22.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324943"}	2026-05-07 13:25:25.05791+00	1
19883	Viewed/List Services	GET	/api/public/services	200	205.169.39.107	\N	{"process_time_ms": 39.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324944"}	2026-05-07 13:25:25.150693+00	1
19888	Viewed/List Bookings	GET	/api/public/bookings	200	205.254.184.209	\N	{"process_time_ms": 7.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778161942748"}	2026-05-07 13:52:25.170686+00	1
19892	Viewed/List Packages	GET	/api/public/packages	200	205.254.184.209	\N	{"process_time_ms": 24.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943683"}	2026-05-07 13:52:26.039967+00	1
19896	Viewed/List Services	GET	/api/public/services	200	205.254.184.209	\N	{"process_time_ms": 18.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943684"}	2026-05-07 13:52:26.334402+00	1
19904	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.209	1	{"process_time_ms": 65.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 13:52:33.722961+00	1
19925	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.209	1	{"process_time_ms": 24.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 13:53:27.900172+00	1
19934	Viewed/List Branches	GET	/api/branches	200	205.254.184.209	1	{"process_time_ms": 9.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:54:13.138688+00	1
19938	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.209	1	{"process_time_ms": 10.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 13:54:13.681521+00	1
20007	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.107	1	{"process_time_ms": 27.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 18:12:39.263954+00	1
20011	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 40.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 18:12:42.695588+00	1
20014	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 76.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:12:42.732857+00	1
20019	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 19.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 18:12:43.305941+00	1
20023	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 51.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:54.276283+00	1
20027	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 92.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 18:13:54.306453+00	1
20036	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 16.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:55.24767+00	1
20040	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 8.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:55.526484+00	1
20051	Created/Added Bookings	POST	/api/bookings	400	103.72.178.107	1	{"process_time_ms": 471.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:40.395529+00	1
20055	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 10.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 18:16:51.384552+00	1
20059	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 35.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 18:16:51.944594+00	1
20071	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 25.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 18:16:53.267032+00	1
20130	Viewed/List Branches	GET	/api/public/branches	200	111.92.114.161	\N	{"process_time_ms": 111.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": ""}	2026-05-08 05:05:26.60802+00	1
20153	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 51.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216755026"}	2026-05-08 05:05:54.130053+00	1
19646	Viewed/List Rooms	GET	/api/public/rooms	200	223.181.11.146	\N	{"process_time_ms": 11.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149962466"}	2026-05-07 10:32:43.850133+00	1
19875	Viewed/List Food Categories	GET	/api/public/food-categories	200	205.169.39.107	\N	{"process_time_ms": 18.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324942"}	2026-05-07 13:25:24.980986+00	1
19902	Viewed/List 	GET	/api/packages/	200	205.254.184.209	1	{"process_time_ms": 49.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:52:33.697666+00	1
19915	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 51.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:13.050865+00	1
19921	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.209	1	{"process_time_ms": 83.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 13:53:27.629061+00	1
19926	Viewed/List Branches	GET	/api/branches	200	205.254.184.209	1	{"process_time_ms": 9.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:27.917176+00	1
19930	Viewed/List 	GET	/api/packages/	200	205.254.184.209	1	{"process_time_ms": 29.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778162012117"}	2026-05-07 13:53:34.490831+00	1
19937	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.209	1	{"process_time_ms": 19.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 13:54:13.665222+00	1
19941	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 31.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:54:13.940742+00	1
19945	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 32.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:54:42.89632+00	1
20039	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.107	1	{"process_time_ms": 8.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 18:13:55.512548+00	1
20042	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 25.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:13:58.785441+00	1
20050	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 18.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:27.055751+00	1
20053	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 28.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:50.871817+00	1
20062	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 9.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 18:16:52.542133+00	1
20131	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 159.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216727402"}	2026-05-08 05:05:26.647381+00	1
20211	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 656.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:36:17.890283+00	1
20212	User Login Attempt	POST	/api/auth/login	400	205.254.184.6	\N	{"process_time_ms": 9.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:37:32.933599+00	1
20213	User Login Attempt	POST	/api/auth/login	200	205.254.184.6	1	{"process_time_ms": 490.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:50.42149+00	1
20214	Viewed/List 	GET	/api/settings/	200	205.254.184.6	1	{"process_time_ms": 10.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:50.706635+00	1
20216	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 38.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:51.216044+00	1
20218	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 30.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 08:38:51.763914+00	1
20221	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 91.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 08:38:55.47536+00	1
20224	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 121.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 08:38:55.503175+00	1
20226	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 84.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 08:38:55.869908+00	1
20230	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 52.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 08:38:56.226797+00	1
19647	Viewed/List Bookings	GET	/api/public/bookings	200	223.181.11.146	\N	{"process_time_ms": 5.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&skip=0&branch_id=2&_t=1778149963444"}	2026-05-07 10:32:45.886118+00	1
19878	Viewed/List 	GET	/api/gallery/	200	205.169.39.107	\N	{"process_time_ms": 17.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324943"}	2026-05-07 13:25:25.050841+00	1
19882	Viewed/List 	GET	/api/nearby-attraction-banners/	200	205.169.39.107	\N	{"process_time_ms": 32.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324945"}	2026-05-07 13:25:25.14672+00	1
19891	Viewed/List Food Categories	GET	/api/public/food-categories	200	205.254.184.209	\N	{"process_time_ms": 18.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943683"}	2026-05-07 13:52:26.035247+00	1
19901	Viewed/List 	GET	/api/nearby-attraction-banners/	200	205.254.184.209	\N	{"process_time_ms": 5.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943684"}	2026-05-07 13:52:26.400979+00	1
19903	Viewed/List Branches	GET	/api/branches	200	205.254.184.209	1	{"process_time_ms": 70.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:52:33.708573+00	1
19920	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.209	1	{"process_time_ms": 69.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-07 13:53:27.623797+00	1
19928	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.209	1	{"process_time_ms": 26.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:34.482897+00	1
19936	Viewed/List 	GET	/api/rooms/	200	205.254.184.209	1	{"process_time_ms": 17.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:54:13.446402+00	1
19940	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.209	1	{"process_time_ms": 16.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-07 13:54:13.929312+00	1
20054	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 20.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 18:16:51.147+00	1
20065	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 14.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 18:16:52.813578+00	1
20132	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 35.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "limit=500&skip=0&_t=1778216727901"}	2026-05-08 05:05:28.085844+00	1
20135	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 32.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730244"}	2026-05-08 05:05:29.33321+00	1
20140	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 15.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730245"}	2026-05-08 05:05:29.630269+00	1
20157	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 16.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216755027"}	2026-05-08 05:05:54.425741+00	1
20215	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 35.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:51.211258+00	1
20217	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 147.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 08:38:51.630088+00	1
20219	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 305.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 08:38:51.783999+00	1
20222	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 107.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:55.483931+00	1
20227	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 96.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 08:38:55.884223+00	1
20243	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 14.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 08:38:58.908585+00	1
20245	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 23.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778229582963"}	2026-05-08 08:39:42.842087+00	1
20254	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 14.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:40:55.367923+00	1
20377	Viewed/List Branches	GET	/api/public/branches	200	111.92.114.161	\N	{"process_time_ms": 6.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:07.456835+00	1
20393	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 12.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068044"}	2026-05-08 09:21:09.518632+00	1
19648	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	223.181.11.146	\N	{"process_time_ms": 21.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&skip=0&branch_id=2&_t=1778149965447"}	2026-05-07 10:32:58.32271+00	1
19649	Viewed/List Rooms	GET	/api/public/rooms	200	223.181.11.146	\N	{"process_time_ms": 27.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149968314"}	2026-05-07 10:33:02.660609+00	1
19650	Viewed/List 	GET	/api/resort-info/	200	223.181.11.146	\N	{"process_time_ms": 21.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=2&_t=1778149977885"}	2026-05-07 10:33:02.739858+00	1
19651	Viewed/List Bookings	GET	/api/public/bookings	200	223.181.11.146	\N	{"process_time_ms": 23.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&skip=0&branch_id=1&_t=1778149982248"}	2026-05-07 10:33:03.055237+00	1
19652	Viewed/List Food Items	GET	/api/public/food-items	200	223.181.11.146	\N	{"process_time_ms": 21.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=2&_t=1778149982300"}	2026-05-07 10:33:03.575451+00	1
19653	Viewed/List Food Categories	GET	/api/public/food-categories	200	223.181.11.146	\N	{"process_time_ms": 4.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=2&_t=1778149982300"}	2026-05-07 10:33:03.968102+00	1
19654	Viewed/List Packages	GET	/api/public/packages	200	223.181.11.146	\N	{"process_time_ms": 6.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149982300"}	2026-05-07 10:33:03.98769+00	1
19655	Viewed/List 	GET	/api/gallery/	200	223.181.11.146	\N	{"process_time_ms": 9.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149982300"}	2026-05-07 10:33:04.343229+00	1
19656	Viewed/List 	GET	/api/reviews/	200	223.181.11.146	\N	{"process_time_ms": 13.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=2&_t=1778149982300"}	2026-05-07 10:33:04.347141+00	1
19657	Viewed/List 	GET	/api/header-banner/	200	223.181.11.146	\N	{"process_time_ms": 5.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149982300"}	2026-05-07 10:33:04.596716+00	1
19658	Viewed/List 	GET	/api/signature-experiences/	200	223.181.11.146	\N	{"process_time_ms": 10.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149982300"}	2026-05-07 10:33:04.701926+00	1
19659	Viewed/List Services	GET	/api/public/services	200	223.181.11.146	\N	{"process_time_ms": 11.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149982300"}	2026-05-07 10:33:04.705199+00	1
19660	Viewed/List 	GET	/api/plan-weddings/	200	223.181.11.146	\N	{"process_time_ms": 5.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=2&_t=1778149982300"}	2026-05-07 10:33:04.808001+00	1
19661	Viewed/List 	GET	/api/nearby-attractions/	200	223.181.11.146	\N	{"process_time_ms": 6.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149982300"}	2026-05-07 10:33:04.888958+00	1
19662	Viewed/List 	GET	/api/nearby-attraction-banners/	200	223.181.11.146	\N	{"process_time_ms": 5.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=2&_t=1778149982300"}	2026-05-07 10:33:05.011266+00	1
19663	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	223.181.11.146	\N	{"process_time_ms": 6.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&skip=0&branch_id=1&_t=1778149982783"}	2026-05-07 10:33:05.108893+00	1
19664	Viewed/List 	GET	/api/resort-info/	200	223.181.11.146	\N	{"process_time_ms": 5.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=1&_t=1778149984682"}	2026-05-07 10:33:06.111013+00	1
19665	Viewed/List Food Items	GET	/api/public/food-items	200	223.181.11.146	\N	{"process_time_ms": 7.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=1&_t=1778149985700"}	2026-05-07 10:33:06.674642+00	1
19666	Viewed/List Food Categories	GET	/api/public/food-categories	200	223.181.11.146	\N	{"process_time_ms": 5.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=1&_t=1778149985700"}	2026-05-07 10:33:06.72915+00	1
19667	Viewed/List Packages	GET	/api/public/packages	200	223.181.11.146	\N	{"process_time_ms": 10.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149985700"}	2026-05-07 10:33:07.029566+00	1
19668	Viewed/List 	GET	/api/gallery/	200	223.181.11.146	\N	{"process_time_ms": 13.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149985700"}	2026-05-07 10:33:07.036144+00	1
19669	Viewed/List 	GET	/api/header-banner/	200	223.181.11.146	\N	{"process_time_ms": 8.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149985700"}	2026-05-07 10:33:07.351736+00	1
19670	Viewed/List 	GET	/api/reviews/	200	223.181.11.146	\N	{"process_time_ms": 14.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=1&_t=1778149985700"}	2026-05-07 10:33:07.355546+00	1
20564	Viewed/List Env	GET	/api/v1/env	404	45.148.10.249	\N	{"process_time_ms": 1.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:35.033775+00	1
19671	Viewed/List 	GET	/api/signature-experiences/	200	223.181.11.146	\N	{"process_time_ms": 9.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149985700"}	2026-05-07 10:33:07.6836+00	1
19684	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 21.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 10:37:51.430824+00	1
19689	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 23.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 10:45:34.515833+00	1
19698	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 23.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740856"}	2026-05-07 10:45:36.7326+00	1
19702	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 18.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740856"}	2026-05-07 10:45:37.020375+00	1
19712	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 46.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:45:44.411549+00	1
19729	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 39.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763071"}	2026-05-07 11:02:38.964411+00	1
19880	Viewed/List 	GET	/api/header-banner/	200	205.169.39.107	\N	{"process_time_ms": 15.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324943"}	2026-05-07 13:25:25.071473+00	1
19885	Viewed/List 	GET	/api/signature-experiences/	200	205.169.39.107	\N	{"process_time_ms": 47.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324945"}	2026-05-07 13:25:25.164329+00	1
19890	Viewed/List 	GET	/api/resort-info/	200	205.254.184.209	\N	{"process_time_ms": 8.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943378"}	2026-05-07 13:52:25.723944+00	1
19895	Viewed/List 	GET	/api/reviews/	200	205.254.184.209	\N	{"process_time_ms": 6.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943683"}	2026-05-07 13:52:26.102123+00	1
19900	Viewed/List 	GET	/api/nearby-attractions/	200	205.254.184.209	\N	{"process_time_ms": 11.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943684"}	2026-05-07 13:52:26.363707+00	1
19906	Viewed/List 	GET	/api/rooms/	200	205.254.184.209	1	{"process_time_ms": 97.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:52:33.739549+00	1
19910	Viewed/List Branches	GET	/api/branches	200	205.254.184.209	1	{"process_time_ms": 29.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:52:34.0436+00	1
19914	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.209	1	{"process_time_ms": 37.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:13.04748+00	1
19924	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.209	1	{"process_time_ms": 14.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 13:53:27.893807+00	1
19935	Viewed/List Branches	GET	/api/branches	200	205.254.184.209	1	{"process_time_ms": 8.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:54:13.388619+00	1
20074	Viewed/List Health	GET	/api/health	404	96.62.228.100	\N	{"process_time_ms": 27.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0", "query_params": ""}	2026-05-07 21:01:34.225082+00	1
20133	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 30.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "limit=500&skip=0&_t=1778216729315"}	2026-05-08 05:05:28.41095+00	1
20137	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 46.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730244"}	2026-05-08 05:05:29.346595+00	1
20142	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 30.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730245"}	2026-05-08 05:05:29.659654+00	1
20148	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 7.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "limit=500&skip=0&branch_id=1&_t=1778216754464"}	2026-05-08 05:05:53.520362+00	1
20220	Viewed/List Expenses	GET	/api/expenses	200	205.254.184.6	1	{"process_time_ms": 45.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 08:38:55.445378+00	1
20225	Viewed/List Assigned	GET	/api/services/assigned	200	205.254.184.6	1	{"process_time_ms": 75.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 08:38:55.864855+00	1
20237	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 59.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 08:38:58.61699+00	1
20238	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 90.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:58.639825+00	1
19672	Viewed/List Services	GET	/api/public/services	200	223.181.11.146	\N	{"process_time_ms": 12.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149985700"}	2026-05-07 10:33:07.687835+00	1
19678	Viewed/List Food Items	GET	/api/food-items	200	103.72.178.237	1	{"process_time_ms": 15.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:35:01.14644+00	1
19690	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 22.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150738667"}	2026-05-07 10:45:34.525401+00	1
19699	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 7.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740856"}	2026-05-07 10:45:36.96804+00	1
19709	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 30.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:45:44.39394+00	1
19720	Updated/Modified 3	PUT	/api/rooms/types/3	200	103.72.178.237	1	{"process_time_ms": 132.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:55:44.595529+00	1
19723	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.237	\N	{"process_time_ms": 37.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151760812"}	2026-05-07 11:02:37.559797+00	1
19727	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 20.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763071"}	2026-05-07 11:02:38.940701+00	1
19736	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 28.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763072"}	2026-05-07 11:02:39.279852+00	1
19881	Viewed/List 	GET	/api/plan-weddings/	200	205.169.39.107	\N	{"process_time_ms": 27.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36", "query_params": "_t=1778160324945"}	2026-05-07 13:25:25.140446+00	1
19887	Viewed/List Rooms	GET	/api/public/rooms	200	205.254.184.209	\N	{"process_time_ms": 28.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161942309"}	2026-05-07 13:52:24.711453+00	1
19897	Viewed/List 	GET	/api/signature-experiences/	200	205.254.184.209	\N	{"process_time_ms": 18.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943684"}	2026-05-07 13:52:26.337892+00	1
19917	Viewed/List Test	GET	/api/rooms/test	200	205.254.184.209	1	{"process_time_ms": 28.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778161991605"}	2026-05-07 13:53:13.973359+00	1
19918	Viewed/List Branches	GET	/api/branches	200	205.254.184.209	1	{"process_time_ms": 42.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:27.590326+00	1
19922	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.209	1	{"process_time_ms": 90.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:27.636251+00	1
19927	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.209	1	{"process_time_ms": 19.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 13:53:28.18183+00	1
19939	Viewed/List 	GET	/api/packages/	200	205.254.184.209	1	{"process_time_ms": 7.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:54:13.729811+00	1
19946	Updated/Modified 2	PUT	/api/rooms/types/2	200	205.254.184.209	1	{"process_time_ms": 38.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:55:06.124194+00	1
20075	Viewed/List Openapi.Json	GET	/api/openapi.json	404	96.62.228.100	\N	{"process_time_ms": 88.46, "user_agent": "Mozilla/5.0 (Linux; Android 14; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36", "query_params": ""}	2026-05-07 21:01:34.263691+00	1
20134	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 27.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216729921"}	2026-05-08 05:05:29.015276+00	1
20139	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 48.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730244"}	2026-05-08 05:05:29.357557+00	1
20144	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 23.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730245"}	2026-05-08 05:05:29.667841+00	1
20149	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 4.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "branch_id=1&_t=1778216754745"}	2026-05-08 05:05:53.798837+00	1
20152	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 38.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "branch_id=1&_t=1778216755026"}	2026-05-08 05:05:54.126785+00	1
20158	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 18.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216755027"}	2026-05-08 05:05:54.430476+00	1
20223	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 119.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 08:38:55.495492+00	1
19673	Viewed/List 	GET	/api/plan-weddings/	200	223.181.11.146	\N	{"process_time_ms": 7.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=1&_t=1778149985700"}	2026-05-07 10:33:08.057677+00	1
19682	Viewed/List Bk 1 000041	GET	/api/bookings/details/BK-1-000041	200	103.72.178.237	1	{"process_time_ms": 22.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-07 10:37:51.108305+00	1
19686	Viewed/List Bk 1 000041	GET	/api/bookings/details/BK-1-000041	200	103.72.178.237	1	{"process_time_ms": 17.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-07 10:40:36.641839+00	1
19688	Created/Added Bookings	POST	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 496.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:42:13.182728+00	1
19692	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 7.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778150739420"}	2026-05-07 10:45:35.520755+00	1
19705	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 10.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:45:43.725005+00	1
19717	Created/Added Bookings	POST	/api/bookings	400	103.72.178.237	1	{"process_time_ms": 470.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:48:11.590059+00	1
19726	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 6.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151762797"}	2026-05-07 11:02:38.650209+00	1
19730	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 36.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763071"}	2026-05-07 11:02:38.968369+00	1
19734	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 17.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763072"}	2026-05-07 11:02:39.26715+00	1
19893	Viewed/List Food Items	GET	/api/public/food-items	200	205.254.184.209	\N	{"process_time_ms": 26.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943683"}	2026-05-07 13:52:26.046626+00	1
19898	Viewed/List 	GET	/api/header-banner/	200	205.254.184.209	\N	{"process_time_ms": 27.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778161943683"}	2026-05-07 13:52:26.341808+00	1
19913	Viewed/List 	GET	/api/food-items/	200	205.254.184.209	1	{"process_time_ms": 43.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:13.043236+00	1
19919	Viewed/List 	GET	/api/packages/	200	205.254.184.209	1	{"process_time_ms": 54.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:27.600615+00	1
19923	Viewed/List 	GET	/api/rooms/	200	205.254.184.209	1	{"process_time_ms": 101.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 13:53:27.640828+00	1
19942	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.209	1	{"process_time_ms": 14.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-07 13:54:13.950996+00	1
20076	Viewed/List Config	GET	/api/v1/config	404	96.62.228.100	\N	{"process_time_ms": 115.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0", "query_params": ""}	2026-05-07 21:01:34.296471+00	1
20136	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 44.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730244"}	2026-05-08 05:05:29.338685+00	1
20156	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 62.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216755024"}	2026-05-08 05:05:54.140871+00	1
20228	Viewed/List Services	GET	/api/services	200	205.254.184.6	1	{"process_time_ms": 100.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 08:38:55.887546+00	1
20229	Viewed/List Packages	GET	/api/packages	200	205.254.184.6	1	{"process_time_ms": 53.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 08:38:56.221939+00	1
20233	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 72.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 08:38:56.243118+00	1
20236	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 28.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:58.580956+00	1
20244	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 24.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 08:38:59.211094+00	1
20247	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 42.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:39:42.860505+00	1
20249	Viewed/List Test	GET	/api/rooms/test	200	205.254.184.6	1	{"process_time_ms": 23.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778229584274"}	2026-05-08 08:39:44.145116+00	1
19674	Viewed/List 	GET	/api/nearby-attractions/	200	223.181.11.146	\N	{"process_time_ms": 11.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778149985700"}	2026-05-07 10:33:08.061585+00	1
19680	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 20.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:35:01.439758+00	1
19693	Viewed/List 	GET	/api/resort-info/	200	103.72.178.237	\N	{"process_time_ms": 6.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740296"}	2026-05-07 10:45:36.407779+00	1
19697	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 28.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740856"}	2026-05-07 10:45:36.729355+00	1
19701	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	\N	{"process_time_ms": 16.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740857"}	2026-05-07 10:45:37.015073+00	1
19715	Created/Added Bookings	POST	/api/bookings	400	103.72.178.237	1	{"process_time_ms": 474.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:47:48.351604+00	1
19724	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 8.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778151762124"}	2026-05-07 11:02:38.099419+00	1
19948	Viewed/List .Env	GET	/api/.env	404	104.168.4.138	\N	{"process_time_ms": 20.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/146.0.3856.109", "query_params": ""}	2026-05-07 14:13:56.488368+00	1
19958	Created/Added Subscribe	POST	/api/subscribe	404	103.215.74.60	\N	{"process_time_ms": 1.61, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:10.466635+00	1
20077	Viewed/List Settings	GET	/api/v2/settings	404	96.62.228.100	\N	{"process_time_ms": 123.77, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 21:01:34.323775+00	1
20138	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 53.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730244"}	2026-05-08 05:05:29.353058+00	1
20143	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 28.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730245"}	2026-05-08 05:05:29.663834+00	1
20151	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 32.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216755026"}	2026-05-08 05:05:54.12113+00	1
20231	Viewed/List Categories	GET	/api/inventory/categories	200	205.254.184.6	1	{"process_time_ms": 56.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 08:38:56.230578+00	1
20235	Viewed/List Kpis	GET	/api/dashboard/kpis	200	205.254.184.6	1	{"process_time_ms": 25.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:56.536607+00	1
20255	Updated/Modified 3	PUT	/api/rooms/types/3	200	205.254.184.6	1	{"process_time_ms": 148.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:41:29.32203+00	1
20378	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 12.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232066151"}	2026-05-08 09:21:07.579817+00	1
20382	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 13.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068043"}	2026-05-08 09:21:08.950841+00	1
20390	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 58.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068043"}	2026-05-08 09:21:09.350107+00	1
20394	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 18.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068044"}	2026-05-08 09:21:09.526542+00	1
20399	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 5.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068045"}	2026-05-08 09:21:09.679879+00	1
20422	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.127	1	{"process_time_ms": 40.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:26:22.600879+00	1
20431	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.127	1	{"process_time_ms": 80.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-08 09:31:31.507099+00	1
20438	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 41.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:31:31.835955+00	1
20442	Viewed/List Bookings	GET	/api/public/bookings	200	122.171.20.183	\N	{"process_time_ms": 6.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778233136545"}	2026-05-08 09:38:55.935518+00	1
20445	Viewed/List Food Items	GET	/api/public/food-items	200	122.171.20.183	\N	{"process_time_ms": 18.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:56.797191+00	1
19675	Viewed/List 	GET	/api/nearby-attraction-banners/	200	223.181.11.146	\N	{"process_time_ms": 5.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "branch_id=1&_t=1778149985700"}	2026-05-07 10:33:08.391889+00	1
19681	Created/Added Bookings	POST	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 501.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:37:44.890005+00	1
19695	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.237	\N	{"process_time_ms": 11.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740850"}	2026-05-07 10:45:36.705757+00	1
19704	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 6.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740857"}	2026-05-07 10:45:37.209652+00	1
19706	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 48.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:45:44.028495+00	1
19713	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 9.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 10:45:44.673474+00	1
19949	Viewed/List Contact	GET	/api/contact	404	103.215.74.60	\N	{"process_time_ms": 19.23, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:09.588492+00	1
19959	Viewed/List User	GET	/api/user	404	103.215.74.60	\N	{"process_time_ms": 1.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:13.249973+00	1
20078	Viewed/List Account	GET	/api/account	404	96.62.228.100	\N	{"process_time_ms": 1.28, "user_agent": "Mozilla/5.0 (Linux; Android 14; SM-S921B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36", "query_params": ""}	2026-05-07 21:01:34.853894+00	1
20141	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 19.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730245"}	2026-05-08 05:05:29.636227+00	1
20146	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 15.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216753896"}	2026-05-08 05:05:52.958643+00	1
20155	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 41.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "branch_id=1&_t=1778216755024"}	2026-05-08 05:05:54.136322+00	1
20232	Viewed/List Checkouts	GET	/api/bill/checkouts	200	205.254.184.6	1	{"process_time_ms": 68.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 08:38:56.237848+00	1
20241	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 103.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:58.655707+00	1
20383	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 21.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068043"}	2026-05-08 09:21:08.955521+00	1
20427	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.127	1	{"process_time_ms": 18.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:31:04.676761+00	1
20429	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.127	1	{"process_time_ms": 19.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:31:27.799865+00	1
20430	Viewed/List 	GET	/api/packages/	200	103.72.178.127	1	{"process_time_ms": 40.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:31:31.469853+00	1
20432	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 92.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:31:31.518092+00	1
20435	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.127	1	{"process_time_ms": 45.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:31:31.697009+00	1
20446	Viewed/List Food Categories	GET	/api/public/food-categories	200	122.171.20.183	\N	{"process_time_ms": 19.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:56.80055+00	1
20450	Viewed/List 	GET	/api/reviews/	200	122.171.20.183	\N	{"process_time_ms": 21.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:57.099767+00	1
20465	Viewed/List 	GET	/api/header-banner/	200	122.171.20.183	\N	{"process_time_ms": 49.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233153015"}	2026-05-08 09:39:12.453625+00	1
20469	Viewed/List 	GET	/api/plan-weddings/	200	122.171.20.183	\N	{"process_time_ms": 20.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778233153015"}	2026-05-08 09:39:12.740271+00	1
20475	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	122.171.20.183	\N	{"process_time_ms": 31.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778235432251"}	2026-05-08 10:17:11.709104+00	1
20488	Viewed/List Rooms	GET	/api/public/rooms	200	122.171.20.183	\N	{"process_time_ms": 15.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235438671"}	2026-05-08 10:17:18.114047+00	1
19676	Created/Added Bookings	POST	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 500.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:34:20.310824+00	1
19700	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 6.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740856"}	2026-05-07 10:45:36.986975+00	1
19707	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 50.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 10:45:44.038281+00	1
19710	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 37.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:45:44.399069+00	1
19714	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 15.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 10:45:44.956202+00	1
19718	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 20.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778150916272"}	2026-05-07 10:48:32.120357+00	1
19725	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.237	\N	{"process_time_ms": 10.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778151762519"}	2026-05-07 11:02:38.374882+00	1
19728	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	\N	{"process_time_ms": 31.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763071"}	2026-05-07 11:02:38.957047+00	1
19737	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	\N	{"process_time_ms": 6.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763072"}	2026-05-07 11:02:39.493266+00	1
19950	Created/Added Contact	POST	/api/contact	404	103.215.74.60	\N	{"process_time_ms": 1.72, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:09.666295+00	1
19960	Viewed/List Admin	GET	/api/admin	404	103.215.74.60	\N	{"process_time_ms": 1.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:13.319618+00	1
20079	Viewed/List Env	GET	/api/env	404	96.62.228.100	\N	{"process_time_ms": 2.43, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 21:01:34.88664+00	1
20145	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 7.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216730244"}	2026-05-08 05:05:29.834492+00	1
20234	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 6.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 08:38:56.503994+00	1
20239	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 94.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 08:38:58.643267+00	1
20397	Viewed/List 	GET	/api/nearby-attraction-banners/	200	205.254.184.6	1	{"process_time_ms": 28.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:09.640097+00	1
20433	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 104.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 09:31:31.53708+00	1
20441	Viewed/List Rooms	GET	/api/public/rooms	200	122.171.20.183	\N	{"process_time_ms": 21.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233136253"}	2026-05-08 09:38:55.660837+00	1
20452	Viewed/List 	GET	/api/header-banner/	200	122.171.20.183	\N	{"process_time_ms": 25.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:57.105862+00	1
20470	Viewed/List 	GET	/api/nearby-attraction-banners/	200	122.171.20.183	\N	{"process_time_ms": 15.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778233153015"}	2026-05-08 09:39:12.747496+00	1
20476	Viewed/List 	GET	/api/resort-info/	200	122.171.20.183	\N	{"process_time_ms": 28.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432571"}	2026-05-08 10:17:12.007681+00	1
20480	Viewed/List 	GET	/api/reviews/	200	122.171.20.183	\N	{"process_time_ms": 43.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.334863+00	1
20484	Viewed/List 	GET	/api/plan-weddings/	200	122.171.20.183	\N	{"process_time_ms": 13.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.631553+00	1
20489	Viewed/List Bookings	GET	/api/public/bookings	200	122.171.20.183	\N	{"process_time_ms": 8.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=1&_t=1778235438983"}	2026-05-08 10:17:19.125156+00	1
20490	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	122.171.20.183	\N	{"process_time_ms": 7.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=1&_t=1778235439981"}	2026-05-08 10:17:19.465207+00	1
19677	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	103.72.178.237	1	{"process_time_ms": 112.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-07 10:35:00.845509+00	1
19696	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.237	\N	{"process_time_ms": 23.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740855"}	2026-05-07 10:45:36.724806+00	1
19733	Viewed/List Services	GET	/api/public/services	200	103.72.178.237	\N	{"process_time_ms": 7.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763072"}	2026-05-07 11:02:39.240254+00	1
19951	Created/Added Contact	POST	/api/contact	404	103.215.74.60	\N	{"process_time_ms": 1.49, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:09.730479+00	1
19961	Viewed/List Me	GET	/api/me	404	103.215.74.60	\N	{"process_time_ms": 1.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:13.357755+00	1
20080	Viewed/List Settings	GET	/api/v1/settings	404	96.62.228.100	\N	{"process_time_ms": 29.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0", "query_params": ""}	2026-05-07 21:01:34.910965+00	1
20147	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 8.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "limit=500&skip=0&branch_id=1&_t=1778216754184"}	2026-05-08 05:05:53.239522+00	1
20150	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 25.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "branch_id=1&_t=1778216755024"}	2026-05-08 05:05:54.102819+00	1
20154	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 45.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "_t=1778216755026"}	2026-05-08 05:05:54.133414+00	1
20160	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 22.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "branch_id=1&_t=1778216755027"}	2026-05-08 05:05:54.442854+00	1
20240	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 101.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:38:58.650639+00	1
20248	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 54.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:39:42.867968+00	1
20252	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 18.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:40:29.848459+00	1
20401	Viewed/List History	GET	/api/day-audit/history	200	205.254.184.6	1	{"process_time_ms": 33.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10"}	2026-05-08 09:21:21.069034+00	1
20408	Viewed/List Charts	GET	/api/dashboard/charts	200	205.254.184.6	1	{"process_time_ms": 99.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:24:48.265936+00	1
20439	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 20.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 09:31:32.105032+00	1
20443	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	122.171.20.183	\N	{"process_time_ms": 6.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778233136831"}	2026-05-08 09:38:56.219936+00	1
20447	Viewed/List 	GET	/api/gallery/	200	122.171.20.183	\N	{"process_time_ms": 20.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:56.804756+00	1
20449	Viewed/List 	GET	/api/signature-experiences/	200	122.171.20.183	\N	{"process_time_ms": 15.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:57.096204+00	1
20451	Viewed/List Services	GET	/api/public/services	200	122.171.20.183	\N	{"process_time_ms": 20.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:57.10292+00	1
20455	Viewed/List 	GET	/api/nearby-attraction-banners/	200	122.171.20.183	\N	{"process_time_ms": 6.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137398"}	2026-05-08 09:38:57.391287+00	1
20456	Viewed/List Rooms	GET	/api/public/rooms	200	122.171.20.183	\N	{"process_time_ms": 16.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233151860"}	2026-05-08 09:39:11.262508+00	1
20463	Viewed/List 	GET	/api/reviews/	200	122.171.20.183	\N	{"process_time_ms": 40.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778233153015"}	2026-05-08 09:39:12.444534+00	1
20467	Viewed/List 	GET	/api/signature-experiences/	200	122.171.20.183	\N	{"process_time_ms": 11.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233153015"}	2026-05-08 09:39:12.726822+00	1
20477	Viewed/List Food Items	GET	/api/public/food-items	200	122.171.20.183	\N	{"process_time_ms": 32.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432868"}	2026-05-08 10:17:12.313055+00	1
20482	Viewed/List 	GET	/api/header-banner/	200	122.171.20.183	\N	{"process_time_ms": 8.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.591127+00	1
19679	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 30.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 10:35:01.15523+00	1
19685	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 16.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:37:51.711582+00	1
19691	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.237	\N	{"process_time_ms": 7.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778150739118"}	2026-05-07 10:45:34.970792+00	1
19708	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 42.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 10:45:44.042478+00	1
19711	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 43.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 10:45:44.408234+00	1
19716	Created/Added Bookings	POST	/api/bookings	400	103.72.178.237	1	{"process_time_ms": 472.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:47:59.28771+00	1
19722	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.237	\N	{"process_time_ms": 23.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 11:02:37.292973+00	1
19731	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	\N	{"process_time_ms": 40.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763071"}	2026-05-07 11:02:38.971859+00	1
19735	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	\N	{"process_time_ms": 23.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763072"}	2026-05-07 11:02:39.271477+00	1
19952	Created/Added Contact	POST	/api/contact	404	103.215.74.60	\N	{"process_time_ms": 1.44, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:09.84399+00	1
19962	Viewed/List Session	GET	/api/auth/session	404	103.215.74.60	\N	{"process_time_ms": 1.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:13.717564+00	1
20081	Viewed/List Env	GET	/api/v1/env	404	96.62.228.100	\N	{"process_time_ms": 2.46, "user_agent": "Mozilla/5.0 (Linux; Android 14; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36", "query_params": ""}	2026-05-07 21:01:37.327606+00	1
20159	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 22.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0", "query_params": "branch_id=1&_t=1778216755027"}	2026-05-08 05:05:54.439391+00	1
20242	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 12.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 08:38:58.870706+00	1
20250	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 28.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:39:44.149284+00	1
20253	Updated/Modified 1	PUT	/api/rooms/types/1	200	205.254.184.6	1	{"process_time_ms": 29.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:40:55.038524+00	1
20402	Viewed/List Current	GET	/api/day-audit/current	200	205.254.184.6	1	{"process_time_ms": 38.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:21.076836+00	1
20420	Viewed/List 	GET	/api/packages/	200	103.72.178.127	1	{"process_time_ms": 21.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:26:22.574929+00	1
20437	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.127	1	{"process_time_ms": 24.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-08 09:31:31.81124+00	1
20440	Viewed/List Branches	GET	/api/public/branches	200	122.171.20.183	\N	{"process_time_ms": 14.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:38:55.651239+00	1
20453	Viewed/List 	GET	/api/plan-weddings/	200	122.171.20.183	\N	{"process_time_ms": 5.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:57.238232+00	1
20462	Viewed/List Food Items	GET	/api/public/food-items	200	122.171.20.183	\N	{"process_time_ms": 39.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778233153014"}	2026-05-08 09:39:12.440644+00	1
20466	Viewed/List Services	GET	/api/public/services	200	122.171.20.183	\N	{"process_time_ms": 5.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233153015"}	2026-05-08 09:39:12.709187+00	1
20471	Viewed/List .Env	GET	/api/.env	404	45.148.10.5	\N	{"process_time_ms": 1.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36", "query_params": ""}	2026-05-08 09:40:26.521224+00	1
20478	Viewed/List Food Categories	GET	/api/public/food-categories	200	122.171.20.183	\N	{"process_time_ms": 25.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.319295+00	1
20487	Viewed/List 	GET	/api/nearby-attraction-banners/	200	122.171.20.183	\N	{"process_time_ms": 7.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.817751+00	1
19683	Viewed/List Food Items	GET	/api/food-items	200	103.72.178.237	1	{"process_time_ms": 16.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:37:51.425922+00	1
19687	Updated/Modified Cancel	PUT	/api/bookings/BK-1-000041/cancel	200	103.72.178.237	1	{"process_time_ms": 23.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:40:36.929112+00	1
19694	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.237	\N	{"process_time_ms": 6.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740850"}	2026-05-07 10:45:36.687708+00	1
19703	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	\N	{"process_time_ms": 21.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778150740857"}	2026-05-07 10:45:37.025784+00	1
19719	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 14.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:48:32.395165+00	1
19721	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 13.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 10:55:44.883778+00	1
19732	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	\N	{"process_time_ms": 8.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778151763071"}	2026-05-07 11:02:39.223187+00	1
19738	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 44.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:03:03.704406+00	1
19739	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 42.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 11:03:04.033901+00	1
19740	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 111.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:03:04.097462+00	1
19741	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 21.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:03:04.17741+00	1
19742	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 34.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 11:03:04.187931+00	1
19743	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 36.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:03:04.199364+00	1
19744	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 9.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:03:04.374382+00	1
19745	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 16.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 11:03:04.460545+00	1
19746	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 18.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 11:03:04.470905+00	1
19747	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 16.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 11:03:05.334805+00	1
19748	Created/Added Bookings	POST	/api/bookings	400	103.72.178.237	1	{"process_time_ms": 473.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:04:37.142947+00	1
19749	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 27.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:04:56.366632+00	1
19750	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 37.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778151900490"}	2026-05-07 11:04:56.377369+00	1
19751	Created/Added Test	POST	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 96.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:05:51.017651+00	1
19752	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 15.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778151955442"}	2026-05-07 11:05:51.303747+00	1
19753	Created/Added Bookings	POST	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 502.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:06:17.865354+00	1
19754	Viewed/List Bk 1 000039	GET	/api/bookings/details/BK-1-000039	200	103.72.178.237	1	{"process_time_ms": 19.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-07 11:06:30.845358+00	1
19755	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 16.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 11:06:31.161107+00	1
19756	Viewed/List Food Items	GET	/api/food-items	200	103.72.178.237	1	{"process_time_ms": 10.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:06:31.435593+00	1
19759	Viewed/List Food Items	GET	/api/food-items	200	103.72.178.237	1	{"process_time_ms": 15.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:08:44.078579+00	1
19776	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 22.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:10:11.138464+00	1
19953	Created/Added Contact	POST	/api/contact	404	103.215.74.60	\N	{"process_time_ms": 1.42, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:10.035755+00	1
19963	Created/Added Contact	POST	/api/contact	404	103.215.74.60	\N	{"process_time_ms": 1.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:125.0) Gecko/20100101 Firefox/125.0", "query_params": ""}	2026-05-07 14:41:15.687097+00	1
20082	Viewed/List Config	GET	/api/config	404	96.62.228.100	\N	{"process_time_ms": 26.12, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 21:01:37.352728+00	1
20161	Viewed/List Branches	GET	/api/public/branches	200	66.249.65.69	\N	{"process_time_ms": 85.67, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": ""}	2026-05-08 06:47:24.916224+00	1
20166	Viewed/List 	GET	/api/plan-weddings/	200	66.249.65.69	\N	{"process_time_ms": 8.6, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:27.035967+00	1
20171	Viewed/List Food Items	GET	/api/public/food-items	200	66.249.65.68	\N	{"process_time_ms": 8.03, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:29.460793+00	1
20176	Viewed/List 	GET	/api/header-banner/	200	66.249.65.68	\N	{"process_time_ms": 7.04, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:31.952762+00	1
20246	Viewed/List 	GET	/api/food-items/	200	205.254.184.6	1	{"process_time_ms": 36.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:39:42.855256+00	1
20251	Updated/Modified 1	PUT	/api/rooms/types/1	200	205.254.184.6	1	{"process_time_ms": 617.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:40:29.559873+00	1
20403	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 41.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:21.083506+00	1
20421	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.127	1	{"process_time_ms": 31.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-08 09:26:22.58797+00	1
20434	Viewed/List 	GET	/api/rooms/	200	103.72.178.127	1	{"process_time_ms": 124.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:31:31.549482+00	1
20454	Viewed/List 	GET	/api/nearby-attractions/	200	122.171.20.183	\N	{"process_time_ms": 6.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:57.380376+00	1
20461	Viewed/List 	GET	/api/gallery/	200	122.171.20.183	\N	{"process_time_ms": 35.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233153015"}	2026-05-08 09:39:12.437577+00	1
20472	Viewed/List Branches	GET	/api/public/branches	200	122.171.20.183	\N	{"process_time_ms": 120.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 10:17:10.739322+00	1
20479	Viewed/List Packages	GET	/api/public/packages	200	122.171.20.183	\N	{"process_time_ms": 49.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.330358+00	1
20481	Viewed/List 	GET	/api/gallery/	200	122.171.20.183	\N	{"process_time_ms": 52.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.338049+00	1
20485	Viewed/List 	GET	/api/nearby-attractions/	200	122.171.20.183	\N	{"process_time_ms": 19.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.636698+00	1
20491	Viewed/List 	GET	/api/resort-info/	200	122.171.20.183	\N	{"process_time_ms": 5.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778235440334"}	2026-05-08 10:17:19.93384+00	1
20493	Viewed/List Food Categories	GET	/api/public/food-categories	200	122.171.20.183	\N	{"process_time_ms": 5.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778235440791"}	2026-05-08 10:17:20.483521+00	1
20494	Viewed/List Packages	GET	/api/public/packages	200	122.171.20.183	\N	{"process_time_ms": 7.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235440791"}	2026-05-08 10:17:20.524852+00	1
20497	Viewed/List 	GET	/api/header-banner/	200	122.171.20.183	\N	{"process_time_ms": 5.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235440791"}	2026-05-08 10:17:20.80156+00	1
19757	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 15.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:06:31.674873+00	1
19764	Viewed/List 	GET	/api/food-orders/	200	103.72.178.237	1	{"process_time_ms": 38.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000&room_id=26&booking_id=39"}	2026-05-07 11:09:39.565854+00	1
19771	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 25.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:10:10.000475+00	1
19775	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 22.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 11:10:10.482413+00	1
19954	Viewed/List Subscribe	GET	/api/subscribe	404	103.215.74.60	\N	{"process_time_ms": 1.48, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:10.145406+00	1
19964	Viewed/List .Env	GET	/api/.env	404	103.215.74.60	\N	{"process_time_ms": 1.37, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:17.434799+00	1
20083	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 115.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 03:26:50.056836+00	1
20087	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 19.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 03:26:50.381259+00	1
20091	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 17.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 03:26:50.67399+00	1
20162	Viewed/List Rooms	GET	/api/public/rooms	200	66.249.65.69	\N	{"process_time_ms": 43.01, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:25.209437+00	1
20167	Viewed/List Food Categories	GET	/api/public/food-categories	200	66.249.65.68	\N	{"process_time_ms": 6.11, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:27.513496+00	1
20172	Viewed/List 	GET	/api/gallery/	200	66.249.65.68	\N	{"process_time_ms": 8.35, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:29.954171+00	1
20256	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 14.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 08:41:29.625781+00	1
20404	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 11.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:24:47.869681+00	1
20412	Viewed/List Food Orders	GET	/api/reports/food-orders	200	205.254.184.6	1	{"process_time_ms": 15.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 09:24:48.492238+00	1
20419	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.127	1	{"process_time_ms": 23.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-08 09:26:22.353962+00	1
20423	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.127	1	{"process_time_ms": 12.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-08 09:26:22.635841+00	1
20426	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.127	1	{"process_time_ms": 28.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778232669125"}	2026-05-08 09:31:04.46126+00	1
20444	Viewed/List 	GET	/api/resort-info/	200	122.171.20.183	\N	{"process_time_ms": 5.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137115"}	2026-05-08 09:38:56.501894+00	1
20458	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	122.171.20.183	\N	{"process_time_ms": 12.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=1&_t=1778233152452"}	2026-05-08 09:39:11.848485+00	1
20460	Viewed/List Food Categories	GET	/api/public/food-categories	200	122.171.20.183	\N	{"process_time_ms": 26.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778233153014"}	2026-05-08 09:39:12.428737+00	1
20464	Viewed/List Packages	GET	/api/public/packages	200	122.171.20.183	\N	{"process_time_ms": 41.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233153014"}	2026-05-08 09:39:12.448083+00	1
20468	Viewed/List 	GET	/api/nearby-attractions/	200	122.171.20.183	\N	{"process_time_ms": 15.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233153015"}	2026-05-08 09:39:12.73678+00	1
20473	Viewed/List Rooms	GET	/api/public/rooms	200	122.171.20.183	\N	{"process_time_ms": 142.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235431168"}	2026-05-08 10:17:10.782386+00	1
20519	Viewed/List .Env	GET	/api/.env	404	45.148.10.5	\N	{"process_time_ms": 20.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36", "query_params": ""}	2026-05-08 11:22:15.314441+00	1
19758	Viewed/List Bk 1 000039	GET	/api/bookings/details/BK-1-000039	200	103.72.178.237	1	{"process_time_ms": 17.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-07 11:08:43.767763+00	1
19765	Viewed/List Assigned	GET	/api/services/assigned	200	103.72.178.237	1	{"process_time_ms": 21.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000&room_id=26&booking_id=39"}	2026-05-07 11:09:41.067179+00	1
19768	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 32.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 11:10:09.710531+00	1
19772	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 25.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 11:10:10.00981+00	1
19955	Created/Added Subscribe	POST	/api/subscribe	404	103.215.74.60	\N	{"process_time_ms": 1.59, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:10.221596+00	1
20084	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 102.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-08 03:26:50.304893+00	1
20088	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 18.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 03:26:50.60387+00	1
20163	Viewed/List Bookings	GET	/api/public/bookings	200	66.249.65.68	\N	{"process_time_ms": 32.31, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-08 06:47:25.663061+00	1
20168	Viewed/List Packages	GET	/api/public/packages	200	66.249.65.68	\N	{"process_time_ms": 9.21, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:27.998428+00	1
20173	Viewed/List 	GET	/api/signature-experiences/	200	66.249.65.68	\N	{"process_time_ms": 6.73, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:30.44993+00	1
20257	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 761.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:17:00.037103+00	1
20260	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 144.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:17:00.129456+00	1
20274	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 25.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:18:28.193847+00	1
20405	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 13.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 09:24:48.120227+00	1
20409	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 159.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 09:24:48.319059+00	1
20425	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 21.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 09:26:22.925029+00	1
20448	Viewed/List Packages	GET	/api/public/packages	200	122.171.20.183	\N	{"process_time_ms": 28.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778233137397"}	2026-05-08 09:38:56.812774+00	1
20457	Viewed/List Bookings	GET	/api/public/bookings	200	122.171.20.183	\N	{"process_time_ms": 12.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=1&_t=1778233152152"}	2026-05-08 09:39:11.548037+00	1
20474	Viewed/List Bookings	GET	/api/public/bookings	200	122.171.20.183	\N	{"process_time_ms": 36.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778235431827"}	2026-05-08 10:17:11.388818+00	1
20483	Viewed/List Services	GET	/api/public/services	200	122.171.20.183	\N	{"process_time_ms": 8.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.609324+00	1
20486	Viewed/List 	GET	/api/signature-experiences/	200	122.171.20.183	\N	{"process_time_ms": 28.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235432869"}	2026-05-08 10:17:12.643838+00	1
20492	Viewed/List Food Items	GET	/api/public/food-items	200	122.171.20.183	\N	{"process_time_ms": 6.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778235440791"}	2026-05-08 10:17:20.288436+00	1
20495	Viewed/List 	GET	/api/gallery/	200	122.171.20.183	\N	{"process_time_ms": 6.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235440791"}	2026-05-08 10:17:20.622401+00	1
20496	Viewed/List 	GET	/api/reviews/	200	122.171.20.183	\N	{"process_time_ms": 6.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778235440791"}	2026-05-08 10:17:20.754564+00	1
19760	Viewed/List Employees	GET	/api/employees	200	103.72.178.237	1	{"process_time_ms": 21.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=1000"}	2026-05-07 11:08:44.085582+00	1
19763	Viewed/List Bk 1 000039	GET	/api/bookings/details/BK-1-000039	200	103.72.178.237	1	{"process_time_ms": 58.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-07 11:09:30.687997+00	1
19766	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 22.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:10:09.415755+00	1
19770	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 10.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:10:09.911416+00	1
19777	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 39.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778152215272"}	2026-05-07 11:10:11.156457+00	1
19956	Created/Added Subscribe	POST	/api/subscribe	404	103.215.74.60	\N	{"process_time_ms": 1.48, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:10.285579+00	1
20085	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 164.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 03:26:50.350944+00	1
20164	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	66.249.65.68	\N	{"process_time_ms": 27.0, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "limit=500&skip=0&_t=1778112000000"}	2026-05-08 06:47:26.123873+00	1
20169	Viewed/List Services	GET	/api/public/services	200	66.249.65.69	\N	{"process_time_ms": 7.61, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:28.480894+00	1
20174	Viewed/List 	GET	/api/nearby-attractions/	200	66.249.65.68	\N	{"process_time_ms": 7.88, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:30.948464+00	1
20258	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 215.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 09:17:00.109488+00	1
20264	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 57.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 09:17:00.46569+00	1
20267	Viewed/List Test	GET	/api/rooms/test	200	205.254.184.6	1	{"process_time_ms": 30.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778231847156"}	2026-05-08 09:17:27.050055+00	1
20269	Updated/Modified 1	PUT	/api/rooms/types/1	200	205.254.184.6	1	{"process_time_ms": 129.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:17:47.511471+00	1
20275	Updated/Modified 2	PUT	/api/rooms/types/2	200	205.254.184.6	1	{"process_time_ms": 26.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:03.297358+00	1
20296	Viewed/List Checkouts	GET	/api/bill/checkouts	200	205.254.184.6	1	{"process_time_ms": 40.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 09:19:54.180291+00	1
20300	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 21.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 09:19:54.479999+00	1
20316	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 36.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:26.922371+00	1
20317	Viewed/List Services	GET	/api/services	200	205.254.184.6	1	{"process_time_ms": 44.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:20:42.1875+00	1
20320	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 64.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:20:42.215928+00	1
20328	Viewed/List Service Requests	GET	/api/service-requests	200	205.254.184.6	1	{"process_time_ms": 76.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100&include_checkout_requests=true"}	2026-05-08 09:20:42.861661+00	1
20332	Viewed/List Expenses	GET	/api/expenses	200	205.254.184.6	1	{"process_time_ms": 43.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20"}	2026-05-08 09:20:50.920734+00	1
20333	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 38.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:53.481043+00	1
20338	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 83.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:53.517712+00	1
20768	Created/Added Graphql	POST	/api/graphql	404	167.99.182.39	\N	{"process_time_ms": 20.33, "user_agent": "Mozilla/5.0 (l9scan/2.0.2353e20363e2236313e24333; +https://leakix.net)", "query_params": ""}	2026-05-08 16:54:55.15412+00	1
19761	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 21.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:08:44.367581+00	1
19957	Created/Added Subscribe	POST	/api/subscribe	404	103.215.74.60	\N	{"process_time_ms": 1.35, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 14:41:10.346121+00	1
20086	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 215.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 03:26:50.368615+00	1
20090	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.107	1	{"process_time_ms": 30.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-08 03:26:50.664178+00	1
20165	Viewed/List 	GET	/api/resort-info/	200	66.249.65.69	\N	{"process_time_ms": 26.54, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:26.5951+00	1
20170	Viewed/List 	GET	/api/reviews/	200	66.249.65.69	\N	{"process_time_ms": 7.59, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:28.96931+00	1
20175	Viewed/List 	GET	/api/nearby-attraction-banners/	200	66.249.65.68	\N	{"process_time_ms": 6.7, "user_agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7727.137 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", "query_params": "_t=1778112000000"}	2026-05-08 06:47:31.447842+00	1
20259	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 137.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 09:17:00.122741+00	1
20276	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 23.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:03.585864+00	1
20284	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 176.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 09:19:38.282181+00	1
20307	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 92.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:55.966684+00	1
20315	Viewed/List Test	GET	/api/rooms/test	200	205.254.184.6	1	{"process_time_ms": 28.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778232027019"}	2026-05-08 09:20:26.914791+00	1
20324	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 13.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:20:42.50299+00	1
20334	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 53.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:53.489586+00	1
20342	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 41.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:53.831357+00	1
20356	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 77.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20"}	2026-05-08 09:20:58.452233+00	1
20360	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 30.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 09:20:58.74146+00	1
20370	Viewed/List Service Requests	GET	/api/service-requests	200	205.254.184.6	1	{"process_time_ms": 42.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:21:01.445527+00	1
20372	Viewed/List Checkouts	GET	/api/bill/checkouts	200	205.254.184.6	1	{"process_time_ms": 45.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20"}	2026-05-08 09:21:05.792842+00	1
20375	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 109.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:05.84903+00	1
20384	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 23.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068043"}	2026-05-08 09:21:08.971211+00	1
20386	Viewed/List 	GET	/api/reviews/	200	205.254.184.6	1	{"process_time_ms": 47.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:09.32537+00	1
20391	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 82.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:09.355892+00	1
20400	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 5.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068045"}	2026-05-08 09:21:09.797968+00	1
20406	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 13.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=50"}	2026-05-08 09:24:48.150395+00	1
19762	Updated/Modified Check In	PUT	/api/bookings/BK-1-000039/check-in	200	103.72.178.237	1	{"process_time_ms": 732.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:09:20.92523+00	1
19774	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 18.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:10:10.204288+00	1
19965	Viewed/List Branches	GET	/api/public/branches	200	103.72.178.107	\N	{"process_time_ms": 91.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-07 16:16:42.075426+00	1
20089	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.107	1	{"process_time_ms": 26.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-08 03:26:50.645646+00	1
20177	Viewed/List Branches	GET	/api/public/branches	200	111.92.114.161	\N	{"process_time_ms": 23.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 07:13:42.789496+00	1
20202	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 37.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430515"}	2026-05-08 07:13:51.743142+00	1
20207	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 15.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430516"}	2026-05-08 07:13:52.037761+00	1
20261	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 709.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:17:00.17902+00	1
20263	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 44.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 09:17:00.458143+00	1
20273	Updated/Modified 2	PUT	/api/rooms/types/2	200	205.254.184.6	1	{"process_time_ms": 28.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:18:27.89791+00	1
20279	Updated/Modified 3	PUT	/api/rooms/types/3	200	205.254.184.6	1	{"process_time_ms": 43.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:33.507951+00	1
20281	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 20.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:37.613497+00	1
20283	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 38.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:19:38.229406+00	1
20293	Viewed/List Services	GET	/api/services	200	205.254.184.6	1	{"process_time_ms": 78.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:19:53.86432+00	1
20295	Viewed/List Packages	GET	/api/packages	200	205.254.184.6	1	{"process_time_ms": 32.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:19:54.176385+00	1
20310	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 20.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 09:19:56.499367+00	1
20314	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 62.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:25.964046+00	1
20326	Viewed/List Kpis	GET	/api/dashboard/kpis	200	205.254.184.6	1	{"process_time_ms": 49.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:42.838089+00	1
20350	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 84.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:57.744137+00	1
20355	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 68.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:58.446026+00	1
20367	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 79.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:21:01.155093+00	1
20376	Viewed/List Charts	GET	/api/dashboard/charts	200	205.254.184.6	1	{"process_time_ms": 117.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:05.857017+00	1
20395	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 18.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068044"}	2026-05-08 09:21:09.530184+00	1
20407	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 56.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=100"}	2026-05-08 09:24:48.20729+00	1
20415	Viewed/List Groups	GET	/api/accounts/groups	200	205.254.184.6	1	{"process_time_ms": 21.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:24:51.55122+00	1
20428	Updated/Modified 3	PUT	/api/rooms/types/3	200	103.72.178.127	1	{"process_time_ms": 29.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:31:27.5114+00	1
19767	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 32.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 11:10:09.426246+00	1
19966	Viewed/List Rooms	GET	/api/public/rooms	200	103.72.178.107	\N	{"process_time_ms": 44.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170606280"}	2026-05-07 16:16:42.425485+00	1
19977	Viewed/List Services	GET	/api/public/services	200	103.72.178.107	\N	{"process_time_ms": 25.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608091"}	2026-05-07 16:16:44.099012+00	1
20092	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 22.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 03:26:50.960127+00	1
20178	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 33.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224421560"}	2026-05-08 07:13:42.802314+00	1
20182	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 17.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422953"}	2026-05-08 07:13:44.154529+00	1
20187	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 6.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422953"}	2026-05-08 07:13:44.438092+00	1
20192	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 5.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422954"}	2026-05-08 07:13:44.675674+00	1
20197	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 5.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430238"}	2026-05-08 07:13:51.423704+00	1
20201	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 37.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430514"}	2026-05-08 07:13:51.739381+00	1
20206	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 11.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430515"}	2026-05-08 07:13:52.033621+00	1
20262	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 10.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:17:00.369915+00	1
20287	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 53.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 09:19:53.500719+00	1
20299	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 57.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:19:54.200301+00	1
20305	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 82.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 09:19:55.954648+00	1
20313	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 50.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:25.95993+00	1
20319	Viewed/List Assigned	GET	/api/services/assigned	200	205.254.184.6	1	{"process_time_ms": 65.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=100"}	2026-05-08 09:20:42.211935+00	1
20336	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 77.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:53.506925+00	1
20380	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 10.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778232067475"}	2026-05-08 09:21:08.373175+00	1
20387	Viewed/List 	GET	/api/plan-weddings/	200	205.254.184.6	1	{"process_time_ms": 50.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:09.329353+00	1
20392	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 5.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778232068044"}	2026-05-08 09:21:09.402865+00	1
20410	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 20.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 09:24:48.405095+00	1
20417	Viewed/List 	GET	/api/rooms/	200	103.72.178.127	1	{"process_time_ms": 28.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 09:26:22.061409+00	1
20436	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.127	1	{"process_time_ms": 20.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-08 09:31:31.775476+00	1
20459	Viewed/List 	GET	/api/resort-info/	200	122.171.20.183	\N	{"process_time_ms": 5.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778233152737"}	2026-05-08 09:39:12.125659+00	1
20555	Viewed/List Debug	GET	/api/admin/debug	404	45.148.10.249	\N	{"process_time_ms": 1.35, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:32.449735+00	1
19769	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 23.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 11:10:09.718016+00	1
19773	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 12.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 11:10:10.188151+00	1
19778	Updated/Modified 3	PUT	/api/rooms/types/3	200	103.72.178.237	1	{"process_time_ms": 210.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:03:28.476681+00	1
19779	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 62.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:03:28.834329+00	1
19780	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 20.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:04:32.490317+00	1
19781	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 36.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:04:32.736641+00	1
19782	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 27.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 12:04:32.783252+00	1
19783	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 14.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 12:04:32.994078+00	1
19784	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 9.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:04:33.011053+00	1
19785	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 13.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:04:33.062877+00	1
19786	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 22.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 12:04:33.238814+00	1
19787	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 33.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 12:04:33.242767+00	1
19788	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 15.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:04:33.262475+00	1
19789	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 18.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 12:04:33.537111+00	1
19790	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 28.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778155806212"}	2026-05-07 12:10:02.60246+00	1
19791	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 13.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:10:02.825187+00	1
19792	Created/Added Test	POST	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 53.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:11:25.058779+00	1
19793	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 16.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778155889507"}	2026-05-07 12:11:25.345008+00	1
19794	Created/Added Test	POST	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 34.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:11:50.411904+00	1
19795	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 14.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778155914861"}	2026-05-07 12:11:50.696609+00	1
19796	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 14.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778155923841"}	2026-05-07 12:11:59.678756+00	1
19797	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 12.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:11:59.958766+00	1
19798	Updated/Modified 28	PUT	/api/rooms/28	200	103.72.178.237	1	{"process_time_ms": 33.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:13:35.476141+00	1
19799	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 17.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778156019930"}	2026-05-07 12:13:35.769059+00	1
19800	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 35.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778156239895"}	2026-05-07 12:17:16.262637+00	1
19801	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 13.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:17:16.494507+00	1
19805	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 52.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:18:19.050628+00	1
19809	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 41.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:06.923714+00	1
19818	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	1	{"process_time_ms": 14.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:20.329202+00	1
19822	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	1	{"process_time_ms": 5.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:33.511808+00	1
19830	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	1	{"process_time_ms": 5.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:41.873654+00	1
19967	Viewed/List Bookings	GET	/api/public/bookings	200	103.72.178.107	\N	{"process_time_ms": 31.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778170607043"}	2026-05-07 16:16:42.761846+00	1
20093	Created/Added Webhook	POST	/api/channel-manager/webhook	401	139.59.43.51	\N	{"process_time_ms": 36.17, "user_agent": "unirest-java/1.3.11", "query_params": ""}	2026-05-08 04:12:04.54853+00	1
20112	Viewed/List Bk 1 000045	GET	/api/bookings/details/BK-1-000045	200	103.72.178.107	1	{"process_time_ms": 26.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-08 04:18:53.522888+00	1
20117	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	180.178.127.178	\N	{"process_time_ms": 7.8, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "limit=500&skip=0&_t=1778214692847"}	2026-05-08 04:31:32.385447+00	1
20122	Viewed/List 	GET	/api/gallery/	200	180.178.127.178	\N	{"process_time_ms": 7.75, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693409"}	2026-05-08 04:31:33.153116+00	1
20179	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 7.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778224422084"}	2026-05-08 07:13:43.289618+00	1
20195	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 6.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778224429682"}	2026-05-08 07:13:50.86925+00	1
20265	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 78.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:17:00.469585+00	1
20268	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 42.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:17:27.064708+00	1
20271	Updated/Modified 1	PUT	/api/rooms/types/1	200	205.254.184.6	1	{"process_time_ms": 29.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:18:13.17301+00	1
20277	Updated/Modified 3	PUT	/api/rooms/types/3	200	205.254.184.6	1	{"process_time_ms": 27.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:14.062186+00	1
20286	Viewed/List Expenses	GET	/api/expenses	200	205.254.184.6	1	{"process_time_ms": 31.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 09:19:53.476306+00	1
20288	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 60.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:53.503944+00	1
20298	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 51.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:19:54.196229+00	1
20308	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 11.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 09:19:56.192165+00	1
20318	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 65.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:42.207468+00	1
20323	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 9.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:20:42.472154+00	1
20327	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 64.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=200"}	2026-05-08 09:20:42.854843+00	1
20330	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 39.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:50.913464+00	1
20358	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 84.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:58.464199+00	1
19802	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 32.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:18:19.032643+00	1
19819	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	1	{"process_time_ms": 13.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:20.336536+00	1
19823	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	1	{"process_time_ms": 5.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:33.523958+00	1
19827	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 8.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:34.037276+00	1
19831	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	1	{"process_time_ms": 5.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:42.049029+00	1
19968	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.72.178.107	\N	{"process_time_ms": 27.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778170607378"}	2026-05-07 16:16:43.076236+00	1
19971	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.72.178.107	\N	{"process_time_ms": 44.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608091"}	2026-05-07 16:16:43.802283+00	1
20094	Created/Added Webhook	POST	/api/channel-manager/webhook	401	139.59.43.51	\N	{"process_time_ms": 2.93, "user_agent": "unirest-java/1.3.11", "query_params": ""}	2026-05-08 04:12:05.846729+00	1
20098	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.107	1	{"process_time_ms": 37.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 04:14:38.821109+00	1
20180	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 6.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778224422383"}	2026-05-08 07:13:43.573651+00	1
20184	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 31.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422953"}	2026-05-08 07:13:44.171368+00	1
20189	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 15.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422954"}	2026-05-08 07:13:44.465883+00	1
20194	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 19.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224429292"}	2026-05-08 07:13:50.50021+00	1
20266	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 22.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 09:17:00.768575+00	1
20270	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 24.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:17:47.836245+00	1
20278	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 24.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:14.357011+00	1
20289	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 65.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:19:53.511473+00	1
20292	Viewed/List Assigned	GET	/api/services/assigned	200	205.254.184.6	1	{"process_time_ms": 71.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:19:53.857649+00	1
20304	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 80.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:55.949915+00	1
20311	Viewed/List 	GET	/api/food-items/	200	205.254.184.6	1	{"process_time_ms": 25.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:25.93228+00	1
20331	Viewed/List Budgets	GET	/api/expenses/budgets	200	205.254.184.6	1	{"process_time_ms": 38.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:50.91699+00	1
20339	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 34.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:53.801478+00	1
20343	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 56.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:53.834669+00	1
20345	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 45.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:57.713001+00	1
20363	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 34.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:01.121701+00	1
20368	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 77.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:21:01.158933+00	1
19803	Viewed/List 	GET	/api/food-items/	200	103.72.178.237	1	{"process_time_ms": 41.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:18:19.037667+00	1
19807	Viewed/List 	GET	/api/food-items/	200	103.72.178.237	1	{"process_time_ms": 33.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:06.905849+00	1
19814	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	1	{"process_time_ms": 26.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:20.040895+00	1
19835	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	1	{"process_time_ms": 5.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:42.19524+00	1
19969	Viewed/List 	GET	/api/resort-info/	200	103.72.178.107	\N	{"process_time_ms": 25.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170607692"}	2026-05-07 16:16:43.389252+00	1
19973	Viewed/List 	GET	/api/header-banner/	200	103.72.178.107	\N	{"process_time_ms": 54.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608091"}	2026-05-07 16:16:43.817733+00	1
20095	Created/Added Webhook	POST	/api/channel-manager/webhook	401	139.59.43.51	\N	{"process_time_ms": 3.19, "user_agent": "unirest-java/1.3.11", "query_params": ""}	2026-05-08 04:12:07.131309+00	1
20102	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.107	1	{"process_time_ms": 34.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-08 04:14:39.1583+00	1
20106	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.107	1	{"process_time_ms": 25.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778213706463"}	2026-05-08 04:15:01.810773+00	1
20127	Viewed/List 	GET	/api/plan-weddings/	200	180.178.127.178	\N	{"process_time_ms": 10.7, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693410"}	2026-05-08 04:31:33.484108+00	1
20181	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 7.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422667"}	2026-05-08 07:13:43.858004+00	1
20186	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 36.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422953"}	2026-05-08 07:13:44.183841+00	1
20191	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 21.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422954"}	2026-05-08 07:13:44.479087+00	1
20196	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 7.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778224429959"}	2026-05-08 07:13:51.147809+00	1
20199	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 27.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430514"}	2026-05-08 07:13:51.724876+00	1
20272	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 21.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:18:13.482301+00	1
20280	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 25.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:33.801521+00	1
20282	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 8.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:37.887704+00	1
20285	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 16.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:19:38.446134+00	1
20291	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 40.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:19:53.831106+00	1
20301	Viewed/List Kpis	GET	/api/dashboard/kpis	200	205.254.184.6	1	{"process_time_ms": 34.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:54.491082+00	1
20321	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 81.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:20:42.226927+00	1
20329	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 25.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:50.905554+00	1
20337	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 78.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:53.513173+00	1
20340	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 46.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 09:20:53.818543+00	1
20348	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 64.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:57.726951+00	1
19804	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 33.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778156303178"}	2026-05-07 12:18:19.044277+00	1
19829	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 8.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:41.781888+00	1
19970	Viewed/List Food Items	GET	/api/public/food-items	200	103.72.178.107	\N	{"process_time_ms": 34.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608091"}	2026-05-07 16:16:43.795532+00	1
20096	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 70.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:14:38.509486+00	1
20100	Viewed/List 	GET	/api/packages/	200	103.72.178.107	1	{"process_time_ms": 12.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:14:39.005114+00	1
20104	Viewed/List Branches	GET	/api/branches	200	103.72.178.107	1	{"process_time_ms": 29.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:14:39.179736+00	1
20114	Viewed/List Branches	GET	/api/public/branches	200	180.178.127.178	\N	{"process_time_ms": 9.6, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": ""}	2026-05-08 04:31:31.567936+00	1
20119	Viewed/List Food Items	GET	/api/public/food-items	200	180.178.127.178	\N	{"process_time_ms": 8.51, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693408"}	2026-05-08 04:31:32.896085+00	1
20124	Viewed/List 	GET	/api/reviews/	200	180.178.127.178	\N	{"process_time_ms": 15.48, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693409"}	2026-05-08 04:31:33.227327+00	1
20129	Viewed/List 	GET	/api/nearby-attraction-banners/	200	180.178.127.178	\N	{"process_time_ms": 6.52, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693410"}	2026-05-08 04:31:33.563021+00	1
20183	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 26.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422952"}	2026-05-08 07:13:44.165768+00	1
20188	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 13.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422953"}	2026-05-08 07:13:44.460571+00	1
20193	Viewed/List Branches	GET	/api/public/branches	200	111.92.114.161	\N	{"process_time_ms": 8.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 07:13:50.489643+00	1
20203	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 44.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430514"}	2026-05-08 07:13:51.747107+00	1
20208	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 23.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430515"}	2026-05-08 07:13:52.046169+00	1
20290	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 71.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 09:19:53.516831+00	1
20294	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 90.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 09:19:53.871914+00	1
20297	Viewed/List Categories	GET	/api/inventory/categories	200	205.254.184.6	1	{"process_time_ms": 46.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 09:19:54.189797+00	1
20302	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 33.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 09:19:55.911621+00	1
20303	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 61.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:55.938565+00	1
20306	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 89.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:19:55.959189+00	1
20322	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 86.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:20:42.231323+00	1
20335	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 64.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20"}	2026-05-08 09:20:53.495565+00	1
20344	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 47.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 09:20:53.837779+00	1
20346	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 58.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20"}	2026-05-08 09:20:57.718888+00	1
20557	Viewed/List Health	GET	/api/v2/health	404	45.148.10.249	\N	{"process_time_ms": 1.33, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:32.664729+00	1
19806	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 21.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "_t=1778156351053"}	2026-05-07 12:19:06.892167+00	1
19808	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 39.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:06.909363+00	1
19811	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 21.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778156351727"}	2026-05-07 12:19:07.576001+00	1
19812	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	1	{"process_time_ms": 19.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:20.024903+00	1
19815	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 44.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:20.048021+00	1
19816	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	1	{"process_time_ms": 9.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:20.305221+00	1
19820	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 10.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:32.984306+00	1
19836	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	1	{"process_time_ms": 10.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:42.321276+00	1
19972	Viewed/List 	GET	/api/reviews/	200	103.72.178.107	\N	{"process_time_ms": 56.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608091"}	2026-05-07 16:16:43.805581+00	1
19976	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.107	\N	{"process_time_ms": 13.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608091"}	2026-05-07 16:16:44.091478+00	1
20097	Viewed/List 	GET	/api/rooms/	200	103.72.178.107	1	{"process_time_ms": 99.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:14:38.726309+00	1
20109	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 33.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:15:21.984023+00	1
20116	Viewed/List Bookings	GET	/api/public/bookings	200	180.178.127.178	\N	{"process_time_ms": 8.42, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "limit=500&skip=0&_t=1778214692403"}	2026-05-08 04:31:32.08109+00	1
20121	Viewed/List Packages	GET	/api/public/packages	200	180.178.127.178	\N	{"process_time_ms": 20.6, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693409"}	2026-05-08 04:31:32.969114+00	1
20126	Viewed/List 	GET	/api/signature-experiences/	200	180.178.127.178	\N	{"process_time_ms": 6.84, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693410"}	2026-05-08 04:31:33.410882+00	1
20185	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 35.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422953"}	2026-05-08 07:13:44.177313+00	1
20190	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 19.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224422954"}	2026-05-08 07:13:44.475791+00	1
20198	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 22.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430513"}	2026-05-08 07:13:51.718791+00	1
20309	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 9.24, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 09:19:56.211958+00	1
20312	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 38.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778232026034"}	2026-05-08 09:20:25.94229+00	1
20325	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 24.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 09:20:42.510051+00	1
20349	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 76.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:57.739967+00	1
20359	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 24.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:20:58.738098+00	1
20369	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 28.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 09:21:01.43776+00	1
20371	Viewed/List Kpis	GET	/api/dashboard/kpis	200	205.254.184.6	1	{"process_time_ms": 26.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 09:21:05.766881+00	1
20769	Created/Added Gql	POST	/api/gql	404	167.99.182.39	\N	{"process_time_ms": 1.42, "user_agent": "Mozilla/5.0 (l9scan/2.0.2353e20363e2236313e24333; +https://leakix.net)", "query_params": ""}	2026-05-08 16:54:55.679375+00	1
19810	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 17.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:07.558719+00	1
19813	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	1	{"process_time_ms": 28.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:20.029242+00	1
19817	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	1	{"process_time_ms": 16.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:20.314889+00	1
19821	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	1	{"process_time_ms": 7.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:33.255865+00	1
19824	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	1	{"process_time_ms": 5.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:33.76684+00	1
19825	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	1	{"process_time_ms": 9.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:33.79193+00	1
19828	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	1	{"process_time_ms": 5.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:34.065464+00	1
19832	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	1	{"process_time_ms": 5.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:42.149732+00	1
19833	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	1	{"process_time_ms": 5.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:42.167589+00	1
19837	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 8.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:42.427298+00	1
19974	Viewed/List 	GET	/api/gallery/	200	103.72.178.107	\N	{"process_time_ms": 55.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608091"}	2026-05-07 16:16:43.82075+00	1
19979	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.107	\N	{"process_time_ms": 13.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608092"}	2026-05-07 16:16:44.124564+00	1
20099	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.107	1	{"process_time_ms": 20.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-08 04:14:38.959383+00	1
20107	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 13.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:15:02.091693+00	1
20113	Viewed/List Bk 1 000043	GET	/api/bookings/details/BK-1-000043	200	103.72.178.107	1	{"process_time_ms": 19.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-08 04:19:23.230598+00	1
20118	Viewed/List 	GET	/api/resort-info/	200	180.178.127.178	\N	{"process_time_ms": 7.49, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693153"}	2026-05-08 04:31:32.643649+00	1
20128	Viewed/List 	GET	/api/nearby-attractions/	200	180.178.127.178	\N	{"process_time_ms": 12.94, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778214693410"}	2026-05-08 04:31:33.48854+00	1
20200	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 29.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778224430514"}	2026-05-08 07:13:51.735206+00	1
20341	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 54.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 09:20:53.822592+00	1
20347	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 49.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:57.723669+00	1
20351	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 27.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 09:20:58.020271+00	1
20353	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 34.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:58.422962+00	1
20357	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 78.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:58.458148+00	1
20362	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 29.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:20:58.756585+00	1
20364	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 48.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 09:21:01.131436+00	1
20989	Viewed/List .Env	GET	/api/.env	404	213.209.159.175	\N	{"process_time_ms": 2.11, "user_agent": "Mozilla/5.0 (X11; Linux i686; rv:40.0) Gecko/20100101 Firefox/40.0", "query_params": ""}	2026-05-08 20:15:52.755005+00	1
19826	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	1	{"process_time_ms": 13.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:33.799518+00	1
19834	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	1	{"process_time_ms": 4.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:19:42.178364+00	1
19838	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 116.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:26.640575+00	1
19839	Viewed/List 	GET	/api/header-banner/	200	103.72.178.237	1	{"process_time_ms": 28.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:26.966597+00	1
19840	Viewed/List 	GET	/api/gallery/	200	103.72.178.237	1	{"process_time_ms": 30.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.081765+00	1
19841	Viewed/List 	GET	/api/reviews/	200	103.72.178.237	1	{"process_time_ms": 32.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.287001+00	1
19842	Viewed/List 	GET	/api/signature-experiences/	200	103.72.178.237	1	{"process_time_ms": 8.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.315991+00	1
19843	Viewed/List 	GET	/api/plan-weddings/	200	103.72.178.237	1	{"process_time_ms": 7.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.370064+00	1
19844	Viewed/List 	GET	/api/nearby-attractions/	200	103.72.178.237	1	{"process_time_ms": 8.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.564235+00	1
19845	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.237	1	{"process_time_ms": 7.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.585585+00	1
19846	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 10.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.660419+00	1
19847	Viewed/List Branches	GET	/api/branches	200	103.72.178.237	1	{"process_time_ms": 10.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.840642+00	1
19848	Viewed/List 	GET	/api/rooms/	200	103.72.178.237	1	{"process_time_ms": 45.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:27.893017+00	1
19849	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 31.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-07 12:50:27.971029+00	1
19850	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.237	1	{"process_time_ms": 17.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-07 12:50:28.124551+00	1
19851	Viewed/List 	GET	/api/packages/	200	103.72.178.237	1	{"process_time_ms": 10.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:28.16607+00	1
19852	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.237	1	{"process_time_ms": 38.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-07 12:50:28.29489+00	1
19853	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 51.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:28.305111+00	1
19854	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.237	1	{"process_time_ms": 13.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-07 12:50:28.323597+00	1
19855	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.237	1	{"process_time_ms": 21.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-07 12:50:28.616192+00	1
19856	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.237	1	{"process_time_ms": 18.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-07 12:50:50.390357+00	1
19857	Viewed/List Test	GET	/api/rooms/test	200	103.72.178.237	1	{"process_time_ms": 32.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&_t=1778158254573"}	2026-05-07 12:50:50.417838+00	1
19975	Viewed/List Packages	GET	/api/public/packages	200	103.72.178.107	\N	{"process_time_ms": 59.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608091"}	2026-05-07 16:16:43.825431+00	1
19980	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.72.178.107	\N	{"process_time_ms": 13.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778170608092"}	2026-05-07 16:16:44.128106+00	1
20101	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.107	1	{"process_time_ms": 19.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-08 04:14:39.110776+00	1
20990	Viewed/List Test	GET	/api/test	404	213.209.159.175	\N	{"process_time_ms": 1.61, "user_agent": "Mozilla/5.0 (X11; Linux i686; rv:40.0) Gecko/20100101 Firefox/40.0", "query_params": ""}	2026-05-08 20:15:54.76159+00	1
20498	Viewed/List Services	GET	/api/public/services	200	122.171.20.183	\N	{"process_time_ms": 5.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235440791"}	2026-05-08 10:17:20.90166+00	1
20507	Viewed/List 	GET	/api/resort-info/	200	122.171.20.183	\N	{"process_time_ms": 8.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235559841"}	2026-05-08 10:19:19.263557+00	1
20511	Viewed/List 	GET	/api/gallery/	200	122.171.20.183	\N	{"process_time_ms": 8.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560128"}	2026-05-08 10:19:19.840532+00	1
20499	Viewed/List 	GET	/api/signature-experiences/	200	122.171.20.183	\N	{"process_time_ms": 5.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235440791"}	2026-05-08 10:17:21.022815+00	1
20503	Viewed/List Branches	GET	/api/public/branches	200	122.171.20.183	\N	{"process_time_ms": 15.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 10:19:18.093022+00	1
20512	Viewed/List 	GET	/api/reviews/	200	122.171.20.183	\N	{"process_time_ms": 15.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560128"}	2026-05-08 10:19:19.850808+00	1
20500	Viewed/List 	GET	/api/plan-weddings/	200	122.171.20.183	\N	{"process_time_ms": 5.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778235440792"}	2026-05-08 10:17:21.075103+00	1
20508	Viewed/List Food Categories	GET	/api/public/food-categories	200	122.171.20.183	\N	{"process_time_ms": 9.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560128"}	2026-05-08 10:19:19.553803+00	1
20513	Viewed/List 	GET	/api/header-banner/	200	122.171.20.183	\N	{"process_time_ms": 10.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560128"}	2026-05-08 10:19:19.857977+00	1
20501	Viewed/List 	GET	/api/nearby-attractions/	200	122.171.20.183	\N	{"process_time_ms": 6.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235440792"}	2026-05-08 10:17:21.181824+00	1
20510	Viewed/List Packages	GET	/api/public/packages	200	122.171.20.183	\N	{"process_time_ms": 17.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560128"}	2026-05-08 10:19:19.56572+00	1
20514	Viewed/List Services	GET	/api/public/services	200	122.171.20.183	\N	{"process_time_ms": 7.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560128"}	2026-05-08 10:19:20.060752+00	1
20502	Viewed/List 	GET	/api/nearby-attraction-banners/	200	122.171.20.183	\N	{"process_time_ms": 5.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778235440792"}	2026-05-08 10:17:21.291244+00	1
20516	Viewed/List 	GET	/api/plan-weddings/	200	122.171.20.183	\N	{"process_time_ms": 6.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560129"}	2026-05-08 10:19:20.077696+00	1
20504	Viewed/List Rooms	GET	/api/public/rooms	200	122.171.20.183	\N	{"process_time_ms": 22.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235557721"}	2026-05-08 10:19:18.104976+00	1
20505	Viewed/List Bookings	GET	/api/public/bookings	200	122.171.20.183	\N	{"process_time_ms": 7.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778235559196"}	2026-05-08 10:19:18.691449+00	1
20509	Viewed/List Food Items	GET	/api/public/food-items	200	122.171.20.183	\N	{"process_time_ms": 16.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560128"}	2026-05-08 10:19:19.55779+00	1
20518	Viewed/List 	GET	/api/nearby-attraction-banners/	200	122.171.20.183	\N	{"process_time_ms": 5.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560129"}	2026-05-08 10:19:20.132946+00	1
20506	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	122.171.20.183	\N	{"process_time_ms": 6.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778235559556"}	2026-05-08 10:19:18.975677+00	1
20515	Viewed/List 	GET	/api/signature-experiences/	200	122.171.20.183	\N	{"process_time_ms": 11.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560129"}	2026-05-08 10:19:20.067811+00	1
20517	Viewed/List 	GET	/api/nearby-attractions/	200	122.171.20.183	\N	{"process_time_ms": 5.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778235560129"}	2026-05-08 10:19:20.12119+00	1
20520	Viewed/List Branches	GET	/api/public/branches	200	111.92.114.161	\N	{"process_time_ms": 53.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:46:03.344486+00	1
20521	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 98.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240762150"}	2026-05-08 11:46:03.381043+00	1
20522	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 33.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778240762546"}	2026-05-08 11:46:03.704733+00	1
20523	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 27.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778240762872"}	2026-05-08 11:46:04.025172+00	1
20524	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 9.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763190"}	2026-05-08 11:46:04.309916+00	1
20525	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 22.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763564"}	2026-05-08 11:46:04.699244+00	1
20526	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 21.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763565"}	2026-05-08 11:46:04.705709+00	1
20527	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 20.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763565"}	2026-05-08 11:46:04.71563+00	1
20530	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 13.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763565"}	2026-05-08 11:46:05.01047+00	1
20531	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 17.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763565"}	2026-05-08 11:46:05.225989+00	1
20533	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 21.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763566"}	2026-05-08 11:46:05.23788+00	1
20534	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 11.37, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763566"}	2026-05-08 11:46:05.264707+00	1
20535	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 7.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763566"}	2026-05-08 11:46:05.288606+00	1
20537	Created/Added Contact	POST	/api/contact	404	45.148.10.249	\N	{"process_time_ms": 1.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:05.73502+00	1
20539	Viewed/List User	GET	/api/user	404	45.148.10.249	\N	{"process_time_ms": 1.3, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:10.101845+00	1
20540	Viewed/List Admin	GET	/api/admin	404	45.148.10.249	\N	{"process_time_ms": 1.37, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:10.218162+00	1
20542	Viewed/List Session	GET	/api/auth/session	404	45.148.10.249	\N	{"process_time_ms": 1.32, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:11.090624+00	1
20543	Created/Added Contact	POST	/api/contact	404	45.148.10.249	\N	{"process_time_ms": 1.36, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-08 11:48:13.108004+00	1
20544	Viewed/List .Env	GET	/api/.env	404	45.148.10.249	\N	{"process_time_ms": 1.29, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:16.835896+00	1
20546	Viewed/List Docs.Json	GET	/api/docs.json	404	45.148.10.249	\N	{"process_time_ms": 1.28, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-08 11:48:29.862564+00	1
20548	Viewed/List Debug	GET	/api/v1/debug	404	45.148.10.249	\N	{"process_time_ms": 1.28, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:31.553367+00	1
20549	Viewed/List Status	GET	/api/v1/status	404	45.148.10.249	\N	{"process_time_ms": 1.28, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:31.787784+00	1
20551	Viewed/List Status	GET	/api/v2/status	404	45.148.10.249	\N	{"process_time_ms": 1.29, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:32.017551+00	1
20552	Viewed/List Debug	GET	/api/debug	404	45.148.10.249	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:32.127542+00	1
20553	Viewed/List Status	GET	/api/status	404	45.148.10.249	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:32.234969+00	1
20528	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 8.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763565"}	2026-05-08 11:46:04.983912+00	1
20529	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 9.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763565"}	2026-05-08 11:46:05.001083+00	1
20532	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 17.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778240763566"}	2026-05-08 11:46:05.229656+00	1
20536	Viewed/List Contact	GET	/api/contact	404	45.148.10.249	\N	{"process_time_ms": 1.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:05.621373+00	1
20538	Created/Added Contact	POST	/api/contact	404	45.148.10.249	\N	{"process_time_ms": 1.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:05.84193+00	1
20541	Viewed/List Me	GET	/api/me	404	45.148.10.249	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:10.328116+00	1
20545	Viewed/List Documentation.Json	GET	/api/documentation.json	404	45.148.10.249	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-08 11:48:29.754658+00	1
20547	Viewed/List Api.Json	GET	/api/docs/api.json	404	45.148.10.249	\N	{"process_time_ms": 1.28, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-08 11:48:30.000693+00	1
20550	Viewed/List Debug	GET	/api/v2/debug	404	45.148.10.249	\N	{"process_time_ms": 1.34, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:31.899099+00	1
20554	Viewed/List Debug	GET	/api/internal/debug	404	45.148.10.249	\N	{"process_time_ms": 1.35, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:32.342817+00	1
20556	Viewed/List Health	GET	/api/v1/health	404	45.148.10.249	\N	{"process_time_ms": 1.3, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:32.55758+00	1
20559	Viewed/List Default	GET	/api/templates/default	404	45.148.10.249	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:34.480021+00	1
20563	Viewed/List Templates	GET	/api/v1/templates	404	45.148.10.249	\N	{"process_time_ms": 1.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:34.927269+00	1
20565	Viewed/List Inngest	GET	/api/inngest	404	45.148.10.249	\N	{"process_time_ms": 1.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:35.386469+00	1
20568	Viewed/List Handler	GET	/api/handler	404	45.148.10.249	\N	{"process_time_ms": 1.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:35.816851+00	1
20574	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 7.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778241300659"}	2026-05-08 11:55:01.7981+00	1
20576	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 5.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301235"}	2026-05-08 11:55:02.371106+00	1
20578	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 10.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301520"}	2026-05-08 11:55:02.670634+00	1
20587	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 5.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301523"}	2026-05-08 11:55:03.240656+00	1
20590	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 7.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=1&_t=1778241304147"}	2026-05-08 11:55:05.285097+00	1
20595	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 29.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778241304717"}	2026-05-08 11:55:05.893295+00	1
20604	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 7.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778241467770"}	2026-05-08 11:57:48.913773+00	1
20605	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 6.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778241468064"}	2026-05-08 11:57:49.206422+00	1
20614	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 13.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468638"}	2026-05-08 11:57:50.321027+00	1
20617	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 5.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468639"}	2026-05-08 11:57:50.562361+00	1
20558	Viewed/List Templates	GET	/api/templates	404	45.148.10.249	\N	{"process_time_ms": 1.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:34.366575+00	1
20567	Viewed/List Fn	GET	/api/fn	404	45.148.10.249	\N	{"process_time_ms": 1.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:35.697793+00	1
20583	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 5.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301522"}	2026-05-08 11:55:03.174573+00	1
20596	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 33.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241304717"}	2026-05-08 11:55:05.901667+00	1
20606	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 4.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468352"}	2026-05-08 11:57:49.49204+00	1
20615	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 4.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468638"}	2026-05-08 11:57:50.343805+00	1
20560	Viewed/List Env	GET	/api/templates/env	404	45.148.10.249	\N	{"process_time_ms": 1.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:34.588363+00	1
20569	Viewed/List Functions	GET	/api/functions	404	45.148.10.249	\N	{"process_time_ms": 1.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:35.925821+00	1
20579	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 16.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301521"}	2026-05-08 11:55:02.67662+00	1
20588	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 13.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241303565"}	2026-05-08 11:55:04.710236+00	1
20602	Viewed/List 	GET	/api/nearby-attraction-banners/	200	111.92.114.161	\N	{"process_time_ms": 10.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778241304719"}	2026-05-08 11:55:06.197505+00	1
20611	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 5.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468638"}	2026-05-08 11:57:50.289582+00	1
20566	Viewed/List Inngest	GET	/api/edge/inngest	404	45.148.10.249	\N	{"process_time_ms": 1.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:35.589379+00	1
20573	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 31.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241299755"}	2026-05-08 11:55:01.354529+00	1
20582	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 10.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301522"}	2026-05-08 11:55:02.96523+00	1
20591	Viewed/List 	GET	/api/resort-info/	200	111.92.114.161	\N	{"process_time_ms": 5.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778241304433"}	2026-05-08 11:55:05.569652+00	1
20594	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 40.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241304718"}	2026-05-08 11:55:05.887153+00	1
20599	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 14.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241304718"}	2026-05-08 11:55:06.171091+00	1
20608	Viewed/List Food Items	GET	/api/public/food-items	200	111.92.114.161	\N	{"process_time_ms": 5.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468637"}	2026-05-08 11:57:49.78198+00	1
20570	Viewed/List Events	GET	/api/events	404	45.148.10.249	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:36.031903+00	1
20575	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	111.92.114.161	\N	{"process_time_ms": 6.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778241300946"}	2026-05-08 11:55:02.083769+00	1
20584	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 5.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301522"}	2026-05-08 11:55:03.185982+00	1
20598	Viewed/List Services	GET	/api/public/services	200	111.92.114.161	\N	{"process_time_ms": 9.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241304718"}	2026-05-08 11:55:06.162009+00	1
20607	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 4.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468637"}	2026-05-08 11:57:49.768869+00	1
20616	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 5.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468638"}	2026-05-08 11:57:50.355323+00	1
20571	Viewed/List Handler	GET	/api/inngest/handler	404	45.148.10.249	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:48:36.13602+00	1
20580	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 5.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301521"}	2026-05-08 11:55:02.931992+00	1
20589	Viewed/List Bookings	GET	/api/public/bookings	200	111.92.114.161	\N	{"process_time_ms": 8.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=1&_t=1778241303859"}	2026-05-08 11:55:04.999158+00	1
20592	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 30.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778241304717"}	2026-05-08 11:55:05.87378+00	1
20597	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 36.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241304718"}	2026-05-08 11:55:05.904894+00	1
20601	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 12.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241304719"}	2026-05-08 11:55:06.190967+00	1
20610	Viewed/List 	GET	/api/gallery/	200	111.92.114.161	\N	{"process_time_ms": 5.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468637"}	2026-05-08 11:57:50.066538+00	1
20572	Viewed/List Branches	GET	/api/public/branches	200	111.92.114.161	\N	{"process_time_ms": 7.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 11:55:01.315115+00	1
20577	Viewed/List Food Categories	GET	/api/public/food-categories	200	111.92.114.161	\N	{"process_time_ms": 4.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301520"}	2026-05-08 11:55:02.652201+00	1
20581	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 8.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301521"}	2026-05-08 11:55:02.957355+00	1
20585	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 7.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301523"}	2026-05-08 11:55:03.206962+00	1
20586	Viewed/List 	GET	/api/nearby-attractions/	200	111.92.114.161	\N	{"process_time_ms": 10.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241301523"}	2026-05-08 11:55:03.214748+00	1
20593	Viewed/List 	GET	/api/reviews/	200	111.92.114.161	\N	{"process_time_ms": 33.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778241304718"}	2026-05-08 11:55:05.880196+00	1
20600	Viewed/List 	GET	/api/plan-weddings/	200	111.92.114.161	\N	{"process_time_ms": 11.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778241304718"}	2026-05-08 11:55:06.180654+00	1
20603	Viewed/List Rooms	GET	/api/public/rooms	200	111.92.114.161	\N	{"process_time_ms": 15.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241466767"}	2026-05-08 11:57:48.524431+00	1
20609	Viewed/List Packages	GET	/api/public/packages	200	111.92.114.161	\N	{"process_time_ms": 6.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468637"}	2026-05-08 11:57:50.042242+00	1
20612	Viewed/List 	GET	/api/header-banner/	200	111.92.114.161	\N	{"process_time_ms": 5.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468638"}	2026-05-08 11:57:50.301469+00	1
20613	Viewed/List 	GET	/api/signature-experiences/	200	111.92.114.161	\N	{"process_time_ms": 7.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36", "query_params": "_t=1778241468638"}	2026-05-08 11:57:50.317515+00	1
20618	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 101.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 12:23:53.6215+00	1
20619	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 90.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 12:23:53.927177+00	1
20620	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 148.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 12:23:53.958182+00	1
20621	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 141.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 12:23:53.979792+00	1
20622	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 59.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 12:23:54.001204+00	1
20623	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 194.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 12:23:54.010037+00	1
20624	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 62.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 12:23:54.299322+00	1
20625	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 80.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 12:23:54.314737+00	1
20626	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 23.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 12:23:54.638262+00	1
20627	Viewed/List Test	GET	/api/rooms/test	200	205.254.184.6	1	{"process_time_ms": 27.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778243034448"}	2026-05-08 12:23:55.311849+00	1
20628	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 36.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 12:23:55.321963+00	1
20629	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 13.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 12:26:26.227163+00	1
20630	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 23.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 12:26:26.41937+00	1
20631	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 30.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 12:26:26.482781+00	1
20632	Viewed/List Expenses	GET	/api/expenses	200	205.254.184.6	1	{"process_time_ms": 33.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 12:26:26.492746+00	1
20633	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 47.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 12:26:26.500424+00	1
20634	Viewed/List Assigned	GET	/api/services/assigned	200	205.254.184.6	1	{"process_time_ms": 42.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 12:26:26.873112+00	1
20638	Viewed/List Packages	GET	/api/packages	200	205.254.184.6	1	{"process_time_ms": 38.24, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 12:26:27.279438+00	1
20643	Viewed/List Kpis	GET	/api/dashboard/kpis	200	205.254.184.6	1	{"process_time_ms": 33.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 12:26:27.648547+00	1
20635	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 54.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 12:26:26.87767+00	1
20639	Viewed/List Categories	GET	/api/inventory/categories	200	205.254.184.6	1	{"process_time_ms": 50.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 12:26:27.285007+00	1
20644	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 118.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 12:26:27.732931+00	1
20636	Viewed/List Services	GET	/api/services	200	205.254.184.6	1	{"process_time_ms": 52.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 12:26:26.881729+00	1
20640	Viewed/List Checkouts	GET	/api/bill/checkouts	200	205.254.184.6	1	{"process_time_ms": 58.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 12:26:27.289095+00	1
20637	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 55.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 12:26:26.885307+00	1
20641	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 63.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 12:26:27.298545+00	1
20642	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 68.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 12:26:27.303675+00	1
20645	Viewed/List Branches	GET	/api/public/branches	200	103.181.40.115	\N	{"process_time_ms": 120.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 14:37:09.869817+00	1
20646	Viewed/List Rooms	GET	/api/public/rooms	200	103.181.40.115	\N	{"process_time_ms": 162.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251029343"}	2026-05-08 14:37:09.908999+00	1
20647	Viewed/List Bookings	GET	/api/public/bookings	200	103.181.40.115	\N	{"process_time_ms": 35.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778251029877"}	2026-05-08 14:37:10.515004+00	1
20648	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.181.40.115	\N	{"process_time_ms": 28.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778251030422"}	2026-05-08 14:37:10.830836+00	1
20649	Viewed/List 	GET	/api/resort-info/	200	103.181.40.115	\N	{"process_time_ms": 26.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251030738"}	2026-05-08 14:37:11.126651+00	1
20650	Viewed/List Packages	GET	/api/public/packages	200	103.181.40.115	\N	{"process_time_ms": 14.86, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.428903+00	1
20651	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.181.40.115	\N	{"process_time_ms": 30.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.433972+00	1
20652	Viewed/List Food Items	GET	/api/public/food-items	200	103.181.40.115	\N	{"process_time_ms": 41.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031033"}	2026-05-08 14:37:11.441826+00	1
20653	Viewed/List 	GET	/api/gallery/	200	103.181.40.115	\N	{"process_time_ms": 45.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.447365+00	1
20654	Viewed/List 	GET	/api/reviews/	200	103.181.40.115	\N	{"process_time_ms": 16.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.72075+00	1
20655	Viewed/List Services	GET	/api/public/services	200	103.181.40.115	\N	{"process_time_ms": 19.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.731701+00	1
20656	Viewed/List 	GET	/api/header-banner/	200	103.181.40.115	\N	{"process_time_ms": 29.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.737024+00	1
20657	Viewed/List 	GET	/api/signature-experiences/	200	103.181.40.115	\N	{"process_time_ms": 19.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.745809+00	1
20658	Viewed/List 	GET	/api/plan-weddings/	200	103.181.40.115	\N	{"process_time_ms": 6.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.94184+00	1
20659	Viewed/List 	GET	/api/nearby-attractions/	200	103.181.40.115	\N	{"process_time_ms": 8.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:11.999259+00	1
20660	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.181.40.115	\N	{"process_time_ms": 6.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251031034"}	2026-05-08 14:37:12.012858+00	1
20661	Viewed/List Rooms	GET	/api/public/rooms	200	103.181.40.115	\N	{"process_time_ms": 14.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251034328"}	2026-05-08 14:37:16.811498+00	1
20662	Viewed/List Bookings	GET	/api/public/bookings	200	103.181.40.115	\N	{"process_time_ms": 8.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=2&_t=1778251036715"}	2026-05-08 14:37:18.956287+00	1
20663	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.181.40.115	\N	{"process_time_ms": 7.22, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=2&_t=1778251038859"}	2026-05-08 14:37:19.516229+00	1
20664	Viewed/List 	GET	/api/resort-info/	200	103.181.40.115	\N	{"process_time_ms": 6.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251039421"}	2026-05-08 14:37:22.18327+00	1
20665	Viewed/List Food Items	GET	/api/public/food-items	200	103.181.40.115	\N	{"process_time_ms": 6.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251042090"}	2026-05-08 14:37:25.138092+00	1
20666	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.181.40.115	\N	{"process_time_ms": 4.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251042091"}	2026-05-08 14:37:25.406109+00	1
20667	Viewed/List Packages	GET	/api/public/packages	200	103.181.40.115	\N	{"process_time_ms": 6.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251042091"}	2026-05-08 14:37:25.675752+00	1
20676	Viewed/List Rooms	GET	/api/public/rooms	200	103.181.40.115	\N	{"process_time_ms": 13.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251070431"}	2026-05-08 14:37:50.805956+00	1
20691	Viewed/List Rooms	GET	/api/public/rooms	200	103.181.40.115	\N	{"process_time_ms": 14.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251136151"}	2026-05-08 14:38:56.53739+00	1
20700	Viewed/List Packages	GET	/api/public/packages	200	103.181.40.115	\N	{"process_time_ms": 43.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251137282"}	2026-05-08 14:38:57.700001+00	1
20704	Viewed/List 	GET	/api/plan-weddings/	200	103.181.40.115	\N	{"process_time_ms": 26.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778251137282"}	2026-05-08 14:38:57.988182+00	1
20709	Viewed/List 	GET	/api/resort-info/	200	103.181.40.115	\N	{"process_time_ms": 5.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251178783"}	2026-05-08 14:39:39.154017+00	1
20712	Viewed/List Food Items	GET	/api/public/food-items	200	103.181.40.115	\N	{"process_time_ms": 36.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251179059"}	2026-05-08 14:39:39.463135+00	1
20717	Viewed/List 	GET	/api/signature-experiences/	200	103.181.40.115	\N	{"process_time_ms": 14.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251179059"}	2026-05-08 14:39:39.753561+00	1
20721	Viewed/List Branches	GET	/api/public/branches	200	103.161.54.24	\N	{"process_time_ms": 12.95, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": ""}	2026-05-08 14:46:08.405974+00	1
20730	Viewed/List 	GET	/api/reviews/	200	103.161.54.24	\N	{"process_time_ms": 5.89, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570280"}	2026-05-08 14:46:12.557404+00	1
20668	Viewed/List 	GET	/api/gallery/	200	103.181.40.115	\N	{"process_time_ms": 5.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251042091"}	2026-05-08 14:37:25.94418+00	1
20677	Viewed/List Bookings	GET	/api/public/bookings	200	103.181.40.115	\N	{"process_time_ms": 7.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778251070710"}	2026-05-08 14:37:51.079097+00	1
20687	Viewed/List 	GET	/api/signature-experiences/	200	103.181.40.115	\N	{"process_time_ms": 10.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:52.198306+00	1
20705	Viewed/List 	GET	/api/nearby-attractions/	200	103.181.40.115	\N	{"process_time_ms": 27.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251137282"}	2026-05-08 14:38:57.991372+00	1
20716	Viewed/List Services	GET	/api/public/services	200	103.181.40.115	\N	{"process_time_ms": 5.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251179059"}	2026-05-08 14:39:39.721071+00	1
20725	Viewed/List 	GET	/api/resort-info/	200	103.161.54.24	\N	{"process_time_ms": 13.01, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251569984"}	2026-05-08 14:46:10.265675+00	1
20734	Viewed/List 	GET	/api/plan-weddings/	200	103.161.54.24	\N	{"process_time_ms": 4.76, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570282"}	2026-05-08 14:46:13.097748+00	1
20669	Viewed/List 	GET	/api/reviews/	200	103.181.40.115	\N	{"process_time_ms": 5.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251042091"}	2026-05-08 14:37:26.213191+00	1
20678	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.181.40.115	\N	{"process_time_ms": 6.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778251070982"}	2026-05-08 14:37:51.350445+00	1
20680	Viewed/List Food Items	GET	/api/public/food-items	200	103.181.40.115	\N	{"process_time_ms": 28.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:51.913709+00	1
20685	Viewed/List 	GET	/api/header-banner/	200	103.181.40.115	\N	{"process_time_ms": 44.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:51.936121+00	1
20689	Viewed/List 	GET	/api/nearby-attractions/	200	103.181.40.115	\N	{"process_time_ms": 13.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:52.221007+00	1
20694	Viewed/List 	GET	/api/resort-info/	200	103.181.40.115	\N	{"process_time_ms": 4.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778251137006"}	2026-05-08 14:38:57.381073+00	1
20697	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.181.40.115	\N	{"process_time_ms": 34.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778251137282"}	2026-05-08 14:38:57.682824+00	1
20726	Viewed/List Food Items	GET	/api/public/food-items	200	103.161.54.24	\N	{"process_time_ms": 6.18, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570278"}	2026-05-08 14:46:10.555425+00	1
20735	Viewed/List 	GET	/api/nearby-attractions/	200	103.161.54.24	\N	{"process_time_ms": 5.78, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570282"}	2026-05-08 14:46:13.351251+00	1
20670	Viewed/List 	GET	/api/header-banner/	200	103.181.40.115	\N	{"process_time_ms": 5.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251042091"}	2026-05-08 14:37:26.482223+00	1
20679	Viewed/List 	GET	/api/resort-info/	200	103.181.40.115	\N	{"process_time_ms": 5.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071252"}	2026-05-08 14:37:51.620095+00	1
20682	Viewed/List 	GET	/api/reviews/	200	103.181.40.115	\N	{"process_time_ms": 36.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:51.926846+00	1
20693	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.181.40.115	\N	{"process_time_ms": 6.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=1&_t=1778251136728"}	2026-05-08 14:38:57.104888+00	1
20695	Viewed/List 	GET	/api/reviews/	200	103.181.40.115	\N	{"process_time_ms": 25.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778251137282"}	2026-05-08 14:38:57.675531+00	1
20701	Viewed/List Services	GET	/api/public/services	200	103.181.40.115	\N	{"process_time_ms": 6.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251137282"}	2026-05-08 14:38:57.954977+00	1
20713	Viewed/List 	GET	/api/gallery/	200	103.181.40.115	\N	{"process_time_ms": 42.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251179059"}	2026-05-08 14:39:39.467647+00	1
20723	Viewed/List Bookings	GET	/api/public/bookings	200	103.161.54.24	\N	{"process_time_ms": 7.51, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "limit=500&skip=0&_t=1778251568677"}	2026-05-08 14:46:08.952687+00	1
20732	Viewed/List Services	GET	/api/public/services	200	103.161.54.24	\N	{"process_time_ms": 9.0, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570281"}	2026-05-08 14:46:13.067639+00	1
20671	Viewed/List Services	GET	/api/public/services	200	103.181.40.115	\N	{"process_time_ms": 5.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251042091"}	2026-05-08 14:37:26.750909+00	1
20684	Viewed/List 	GET	/api/gallery/	200	103.181.40.115	\N	{"process_time_ms": 39.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:51.933213+00	1
20688	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.181.40.115	\N	{"process_time_ms": 12.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:52.216797+00	1
20696	Viewed/List 	GET	/api/gallery/	200	103.181.40.115	\N	{"process_time_ms": 31.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251137282"}	2026-05-08 14:38:57.678947+00	1
20706	Viewed/List Rooms	GET	/api/public/rooms	200	103.181.40.115	\N	{"process_time_ms": 15.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251177919"}	2026-05-08 14:39:38.300839+00	1
20720	Viewed/List 	GET	/api/nearby-attractions/	200	103.181.40.115	\N	{"process_time_ms": 20.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251179059"}	2026-05-08 14:39:39.769652+00	1
20729	Viewed/List Packages	GET	/api/public/packages	200	103.161.54.24	\N	{"process_time_ms": 13.44, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570279"}	2026-05-08 14:46:10.893609+00	1
20672	Viewed/List 	GET	/api/signature-experiences/	200	103.181.40.115	\N	{"process_time_ms": 5.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251042091"}	2026-05-08 14:37:27.018797+00	1
20692	Viewed/List Bookings	GET	/api/public/bookings	200	103.181.40.115	\N	{"process_time_ms": 7.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=1&_t=1778251136439"}	2026-05-08 14:38:56.827461+00	1
20707	Viewed/List Bookings	GET	/api/public/bookings	200	103.181.40.115	\N	{"process_time_ms": 6.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=2&_t=1778251178206"}	2026-05-08 14:39:38.577523+00	1
20727	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.161.54.24	\N	{"process_time_ms": 4.49, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570279"}	2026-05-08 14:46:10.566433+00	1
20673	Viewed/List 	GET	/api/plan-weddings/	200	103.181.40.115	\N	{"process_time_ms": 5.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251042091"}	2026-05-08 14:37:27.286572+00	1
20686	Viewed/List Services	GET	/api/public/services	200	103.181.40.115	\N	{"process_time_ms": 8.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:52.190427+00	1
20699	Viewed/List Food Items	GET	/api/public/food-items	200	103.181.40.115	\N	{"process_time_ms": 31.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778251137282"}	2026-05-08 14:38:57.693943+00	1
20703	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.181.40.115	\N	{"process_time_ms": 16.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=1&_t=1778251137282"}	2026-05-08 14:38:57.984814+00	1
20711	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.181.40.115	\N	{"process_time_ms": 32.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251179059"}	2026-05-08 14:39:39.459642+00	1
20722	Viewed/List Rooms	GET	/api/public/rooms	200	103.161.54.24	\N	{"process_time_ms": 28.02, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251568127"}	2026-05-08 14:46:08.425613+00	1
20731	Viewed/List 	GET	/api/header-banner/	200	103.161.54.24	\N	{"process_time_ms": 5.53, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570281"}	2026-05-08 14:46:12.570758+00	1
20674	Viewed/List 	GET	/api/nearby-attractions/	200	103.181.40.115	\N	{"process_time_ms": 6.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251042091"}	2026-05-08 14:37:27.556079+00	1
20681	Viewed/List Packages	GET	/api/public/packages	200	103.181.40.115	\N	{"process_time_ms": 29.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:51.917593+00	1
20690	Viewed/List 	GET	/api/plan-weddings/	200	103.181.40.115	\N	{"process_time_ms": 18.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:52.224041+00	1
20698	Viewed/List 	GET	/api/header-banner/	200	103.181.40.115	\N	{"process_time_ms": 35.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251137282"}	2026-05-08 14:38:57.686453+00	1
20708	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.181.40.115	\N	{"process_time_ms": 6.8, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=2&_t=1778251178507"}	2026-05-08 14:39:38.878815+00	1
20710	Viewed/List 	GET	/api/reviews/	200	103.181.40.115	\N	{"process_time_ms": 24.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251179059"}	2026-05-08 14:39:39.450031+00	1
20714	Viewed/List Packages	GET	/api/public/packages	200	103.181.40.115	\N	{"process_time_ms": 36.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251179059"}	2026-05-08 14:39:39.470767+00	1
20718	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.181.40.115	\N	{"process_time_ms": 18.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251179059"}	2026-05-08 14:39:39.762111+00	1
20736	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.161.54.24	\N	{"process_time_ms": 5.51, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570283"}	2026-05-08 14:46:13.362067+00	1
20675	Viewed/List 	GET	/api/nearby-attraction-banners/	200	103.181.40.115	\N	{"process_time_ms": 5.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251042091"}	2026-05-08 14:37:27.825466+00	1
20683	Viewed/List Food Categories	GET	/api/public/food-categories	200	103.181.40.115	\N	{"process_time_ms": 33.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251071522"}	2026-05-08 14:37:51.93009+00	1
20702	Viewed/List 	GET	/api/signature-experiences/	200	103.181.40.115	\N	{"process_time_ms": 15.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251137282"}	2026-05-08 14:38:57.97598+00	1
20715	Viewed/List 	GET	/api/header-banner/	200	103.181.40.115	\N	{"process_time_ms": 37.75, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778251179059"}	2026-05-08 14:39:39.473901+00	1
20719	Viewed/List 	GET	/api/plan-weddings/	200	103.181.40.115	\N	{"process_time_ms": 22.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778251179059"}	2026-05-08 14:39:39.766304+00	1
20724	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	103.161.54.24	\N	{"process_time_ms": 7.7, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "limit=500&skip=0&_t=1778251569152"}	2026-05-08 14:46:09.857027+00	1
20728	Viewed/List 	GET	/api/gallery/	200	103.161.54.24	\N	{"process_time_ms": 7.72, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570280"}	2026-05-08 14:46:10.890231+00	1
20733	Viewed/List 	GET	/api/signature-experiences/	200	103.161.54.24	\N	{"process_time_ms": 11.07, "user_agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36", "query_params": "_t=1778251570282"}	2026-05-08 14:46:13.071553+00	1
20737	Viewed/List Branches	GET	/api/public/branches	200	223.185.130.213	\N	{"process_time_ms": 108.94, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 16:20:32.152944+00	1
20738	Viewed/List Rooms	GET	/api/public/rooms	200	223.185.130.213	\N	{"process_time_ms": 153.7, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257231850"}	2026-05-08 16:20:32.188137+00	1
20739	Viewed/List Bookings	GET	/api/public/bookings	200	223.185.130.213	\N	{"process_time_ms": 34.8, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778257232366"}	2026-05-08 16:20:32.566921+00	1
20740	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	223.185.130.213	\N	{"process_time_ms": 28.74, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778257232693"}	2026-05-08 16:20:32.917046+00	1
20741	Viewed/List 	GET	/api/resort-info/	200	223.185.130.213	\N	{"process_time_ms": 23.46, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233056"}	2026-05-08 16:20:33.239366+00	1
20742	Viewed/List Food Categories	GET	/api/public/food-categories	200	223.185.130.213	\N	{"process_time_ms": 23.66, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233412"}	2026-05-08 16:20:33.587926+00	1
20743	Viewed/List Packages	GET	/api/public/packages	200	223.185.130.213	\N	{"process_time_ms": 33.52, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233412"}	2026-05-08 16:20:33.599169+00	1
20744	Viewed/List Food Items	GET	/api/public/food-items	200	223.185.130.213	\N	{"process_time_ms": 27.73, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233412"}	2026-05-08 16:20:33.605662+00	1
20745	Viewed/List 	GET	/api/gallery/	200	223.185.130.213	\N	{"process_time_ms": 39.55, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233412"}	2026-05-08 16:20:33.609233+00	1
20746	Viewed/List 	GET	/api/reviews/	200	223.185.130.213	\N	{"process_time_ms": 7.8, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233412"}	2026-05-08 16:20:33.875015+00	1
20747	Viewed/List 	GET	/api/header-banner/	200	223.185.130.213	\N	{"process_time_ms": 13.22, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233412"}	2026-05-08 16:20:33.908997+00	1
20748	Viewed/List Services	GET	/api/public/services	200	223.185.130.213	\N	{"process_time_ms": 14.49, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233412"}	2026-05-08 16:20:33.918237+00	1
20749	Viewed/List 	GET	/api/signature-experiences/	200	223.185.130.213	\N	{"process_time_ms": 24.95, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233413"}	2026-05-08 16:20:33.922994+00	1
20750	Viewed/List 	GET	/api/plan-weddings/	200	223.185.130.213	\N	{"process_time_ms": 6.72, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233413"}	2026-05-08 16:20:33.937739+00	1
20751	Viewed/List 	GET	/api/nearby-attractions/	200	223.185.130.213	\N	{"process_time_ms": 8.01, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233413"}	2026-05-08 16:20:34.146094+00	1
20752	Viewed/List 	GET	/api/nearby-attraction-banners/	200	223.185.130.213	\N	{"process_time_ms": 6.78, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257233413"}	2026-05-08 16:20:34.158299+00	1
20991	Viewed/List About	GET	/api/v2/about	404	172.233.178.66	\N	{"process_time_ms": 2.02, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:18:43.600148+00	1
20753	Viewed/List Rooms	GET	/api/public/rooms	200	223.185.130.213	\N	{"process_time_ms": 12.75, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257239915"}	2026-05-08 16:20:40.089177+00	1
20762	Viewed/List 	GET	/api/reviews/	200	223.185.130.213	\N	{"process_time_ms": 5.74, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778257241440"}	2026-05-08 16:20:43.157093+00	1
20754	Viewed/List Bookings	GET	/api/public/bookings	200	223.185.130.213	\N	{"process_time_ms": 8.23, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=2&_t=1778257240223"}	2026-05-08 16:20:40.460738+00	1
20763	Viewed/List Services	GET	/api/public/services	200	223.185.130.213	\N	{"process_time_ms": 5.67, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257241440"}	2026-05-08 16:20:43.423121+00	1
20755	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	223.185.130.213	\N	{"process_time_ms": 7.89, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&branch_id=2&_t=1778257240586"}	2026-05-08 16:20:40.772225+00	1
20764	Viewed/List 	GET	/api/signature-experiences/	200	223.185.130.213	\N	{"process_time_ms": 5.72, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257241440"}	2026-05-08 16:20:43.5267+00	1
20756	Viewed/List 	GET	/api/resort-info/	200	223.185.130.213	\N	{"process_time_ms": 6.31, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778257240892"}	2026-05-08 16:20:41.312538+00	1
20757	Viewed/List Food Items	GET	/api/public/food-items	200	223.185.130.213	\N	{"process_time_ms": 7.08, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778257241440"}	2026-05-08 16:20:42.022776+00	1
20765	Viewed/List 	GET	/api/plan-weddings/	200	223.185.130.213	\N	{"process_time_ms": 5.98, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778257241440"}	2026-05-08 16:20:43.628868+00	1
20766	Viewed/List 	GET	/api/nearby-attractions/	200	223.185.130.213	\N	{"process_time_ms": 5.77, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257241440"}	2026-05-08 16:20:43.703151+00	1
20758	Viewed/List Food Categories	GET	/api/public/food-categories	200	223.185.130.213	\N	{"process_time_ms": 5.06, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778257241440"}	2026-05-08 16:20:42.302538+00	1
20767	Viewed/List 	GET	/api/nearby-attraction-banners/	200	223.185.130.213	\N	{"process_time_ms": 5.7, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "branch_id=2&_t=1778257241440"}	2026-05-08 16:20:43.813506+00	1
20759	Viewed/List Packages	GET	/api/public/packages	200	223.185.130.213	\N	{"process_time_ms": 6.62, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257241440"}	2026-05-08 16:20:42.584063+00	1
20760	Viewed/List 	GET	/api/gallery/	200	223.185.130.213	\N	{"process_time_ms": 5.65, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257241440"}	2026-05-08 16:20:42.865869+00	1
20761	Viewed/List 	GET	/api/header-banner/	200	223.185.130.213	\N	{"process_time_ms": 5.71, "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "_t=1778257241440"}	2026-05-08 16:20:43.1451+00	1
20770	Viewed/List Swagger.Json	GET	/api/swagger.json	404	167.99.182.39	\N	{"process_time_ms": 1.49, "user_agent": "Mozilla/5.0 (l9scan/2.0.2353e20363e2236313e24333; +https://leakix.net)", "query_params": ""}	2026-05-08 16:55:13.176397+00	1
20771	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 111.77, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:21:39.718661+00	1
20773	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 36.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 17:21:40.219009+00	1
20775	Viewed/List 	GET	/api/packages/	200	157.51.209.48	1	{"process_time_ms": 755.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:21:41.246554+00	1
20777	Viewed/List Types	GET	/api/rooms/types	200	157.51.209.48	1	{"process_time_ms": 785.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:21:41.28507+00	1
20778	Viewed/List Locations	GET	/api/inventory/locations	200	157.51.209.48	1	{"process_time_ms": 772.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 17:21:41.288202+00	1
20782	Viewed/List Types	GET	/api/rooms/types	200	157.51.209.48	1	{"process_time_ms": 21.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:23:18.80744+00	1
20786	Viewed/List Bk 1 000039	GET	/api/bookings/details/BK-1-000039	200	157.51.209.48	1	{"process_time_ms": 27.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:24:29.674034+00	1
20790	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 21.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:13.06353+00	1
20805	Viewed/List Summary	GET	/api/dashboard/summary	200	157.51.209.48	1	{"process_time_ms": 39.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 17:25:41.253662+00	1
20809	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 112.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 17:25:41.315932+00	1
20815	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 36.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:45.217791+00	1
20827	Viewed/List Summary	GET	/api/dashboard/summary	200	157.51.209.48	1	{"process_time_ms": 49.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 17:25:46.056025+00	1
20833	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 75.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:50.532552+00	1
20837	Viewed/List Locations	GET	/api/inventory/locations	200	157.51.209.48	1	{"process_time_ms": 13.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 17:25:50.871493+00	1
20842	Viewed/List Bk 1 000042	GET	/api/bookings/details/BK-1-000042	200	157.51.209.48	1	{"process_time_ms": 16.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:27:45.501977+00	1
20846	Viewed/List Today	GET	/api/attendance/status/today	200	157.51.209.48	1	{"process_time_ms": 25.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:28:42.91028+00	1
20851	Viewed/List 	GET	/api/packages/	200	157.51.209.48	1	{"process_time_ms": 31.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:29:05.841513+00	1
20854	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 74.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:29:05.884179+00	1
20772	Viewed/List 	GET	/api/rooms/	200	157.51.209.48	1	{"process_time_ms": 118.53, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:21:40.171151+00	1
20774	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	157.51.209.48	1	{"process_time_ms": 18.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 17:21:40.442921+00	1
20776	Viewed/List Items	GET	/api/inventory/items	200	157.51.209.48	1	{"process_time_ms": 777.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 17:21:41.273168+00	1
20779	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 58.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:21:41.294947+00	1
20780	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 23.85, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 17:21:41.715953+00	1
20781	Viewed/List Bk 1 000039	GET	/api/bookings/details/BK-1-000039	200	157.51.209.48	1	{"process_time_ms": 86.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:22:14.895017+00	1
20783	Viewed/List Test	GET	/api/rooms/test	200	157.51.209.48	1	{"process_time_ms": 24.92, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778260997237"}	2026-05-08 17:23:19.101001+00	1
20784	Viewed/List Bk 1 000039	GET	/api/bookings/details/BK-1-000039	200	157.51.209.48	1	{"process_time_ms": 30.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:23:45.497201+00	1
20787	Viewed/List Bk 1 000039	GET	/api/bookings/details/BK-1-000039	200	157.51.209.48	1	{"process_time_ms": 26.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:24:48.652624+00	1
20788	Viewed/List Items	GET	/api/inventory/locations/28/items	200	157.51.209.48	1	{"process_time_ms": 92.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000&booking_id=39"}	2026-05-08 17:24:49.159047+00	1
20791	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	157.51.209.48	1	{"process_time_ms": 9.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:13.31861+00	1
20792	Viewed/List Rooms	GET	/api/rooms	200	157.51.209.48	1	{"process_time_ms": 16.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:13.392178+00	1
20794	Viewed/List Food Orders	GET	/api/food-orders	200	157.51.209.48	1	{"process_time_ms": 49.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:14.1574+00	1
20795	Viewed/List Services	GET	/api/services	200	157.51.209.48	1	{"process_time_ms": 54.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:14.191755+00	1
20796	Viewed/List Assigned	GET	/api/services/assigned	200	157.51.209.48	1	{"process_time_ms": 59.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:14.196301+00	1
20798	Viewed/List Categories	GET	/api/inventory/categories	200	157.51.209.48	1	{"process_time_ms": 38.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:14.558375+00	1
20799	Viewed/List Packages	GET	/api/packages	200	157.51.209.48	1	{"process_time_ms": 45.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:14.562859+00	1
20803	Viewed/List Kpis	GET	/api/dashboard/kpis	200	157.51.209.48	1	{"process_time_ms": 47.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:15.263036+00	1
20804	Viewed/List Summary	GET	/api/dashboard/summary	200	157.51.209.48	1	{"process_time_ms": 149.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 17:25:15.354145+00	1
20806	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 90.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:41.286387+00	1
20808	Viewed/List Food Orders	GET	/api/reports/food-orders	200	157.51.209.48	1	{"process_time_ms": 92.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 17:25:41.305109+00	1
20811	Viewed/List Expenses	GET	/api/reports/expenses	200	157.51.209.48	1	{"process_time_ms": 8.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 17:25:41.600666+00	1
20817	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 58.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:45.245364+00	1
20818	Viewed/List Rooms	GET	/api/rooms	200	157.51.209.48	1	{"process_time_ms": 63.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:45.251588+00	1
20819	Viewed/List Expenses	GET	/api/expenses	200	157.51.209.48	1	{"process_time_ms": 49.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:45.259807+00	1
20821	Viewed/List Assigned	GET	/api/services/assigned	200	157.51.209.48	1	{"process_time_ms": 28.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:45.660967+00	1
20785	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	157.51.209.48	1	{"process_time_ms": 20.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:24:06.22663+00	1
20789	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 24.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:12.624882+00	1
20793	Viewed/List Expenses	GET	/api/expenses	200	157.51.209.48	1	{"process_time_ms": 11.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:13.706494+00	1
20797	Viewed/List Food Items	GET	/api/food-items	200	157.51.209.48	1	{"process_time_ms": 67.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:14.203893+00	1
20800	Viewed/List Items	GET	/api/inventory/items	200	157.51.209.48	1	{"process_time_ms": 51.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:14.569008+00	1
20801	Viewed/List Checkouts	GET	/api/bill/checkouts	200	157.51.209.48	1	{"process_time_ms": 51.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:14.573204+00	1
20802	Viewed/List Employees	GET	/api/employees	200	157.51.209.48	1	{"process_time_ms": 53.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:14.578729+00	1
20807	Viewed/List Package Bookings	GET	/api/reports/package-bookings	200	157.51.209.48	1	{"process_time_ms": 81.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 17:25:41.29321+00	1
20810	Viewed/List Charts	GET	/api/dashboard/charts	200	157.51.209.48	1	{"process_time_ms": 120.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:41.323755+00	1
20812	Viewed/List Employees	GET	/api/employees	200	157.51.209.48	1	{"process_time_ms": 10.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 17:25:41.640438+00	1
20813	Viewed/List Items	GET	/api/inventory/items	200	157.51.209.48	1	{"process_time_ms": 13.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=50"}	2026-05-08 17:25:41.685511+00	1
20814	Viewed/List Rooms	GET	/api/rooms	200	157.51.209.48	1	{"process_time_ms": 26.48, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=100"}	2026-05-08 17:25:41.694957+00	1
20816	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	157.51.209.48	1	{"process_time_ms": 41.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:45.22411+00	1
20820	Viewed/List Food Items	GET	/api/food-items	200	157.51.209.48	1	{"process_time_ms": 27.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:45.654632+00	1
20823	Viewed/List Food Orders	GET	/api/food-orders	200	157.51.209.48	1	{"process_time_ms": 41.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:45.6738+00	1
20825	Viewed/List Packages	GET	/api/packages	200	157.51.209.48	1	{"process_time_ms": 49.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:46.049297+00	1
20826	Viewed/List Categories	GET	/api/inventory/categories	200	157.51.209.48	1	{"process_time_ms": 39.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:46.052855+00	1
20829	Viewed/List Checkouts	GET	/api/bill/checkouts	200	157.51.209.48	1	{"process_time_ms": 62.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 17:25:46.06903+00	1
20834	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 72.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 17:25:50.536385+00	1
20835	Viewed/List 	GET	/api/rooms/	200	157.51.209.48	1	{"process_time_ms": 85.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:50.547916+00	1
20836	Viewed/List Types	GET	/api/rooms/types	200	157.51.209.48	1	{"process_time_ms": 94.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:50.55693+00	1
20838	Viewed/List Items	GET	/api/inventory/items	200	157.51.209.48	1	{"process_time_ms": 20.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 17:25:50.875362+00	1
20839	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 20.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 17:25:51.425847+00	1
20840	Viewed/List Bk 1 000042	GET	/api/bookings/details/BK-1-000042	200	157.51.209.48	1	{"process_time_ms": 16.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:26:58.816396+00	1
20843	Viewed/List Employees	GET	/api/employees	200	157.51.209.48	1	{"process_time_ms": 13.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:28:42.207853+00	1
20844	Viewed/List Aggregate	GET	/api/attendance/utilization/aggregate	200	157.51.209.48	1	{"process_time_ms": 20.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:28:42.535108+00	1
20822	Viewed/List Services	GET	/api/services	200	157.51.209.48	1	{"process_time_ms": 41.24, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:45.666105+00	1
20824	Viewed/List Items	GET	/api/inventory/items	200	157.51.209.48	1	{"process_time_ms": 41.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:46.044456+00	1
20830	Viewed/List Kpis	GET	/api/dashboard/kpis	200	157.51.209.48	1	{"process_time_ms": 5.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:46.381477+00	1
20831	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	157.51.209.48	1	{"process_time_ms": 52.82, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 17:25:50.509912+00	1
20832	Viewed/List 	GET	/api/packages/	200	157.51.209.48	1	{"process_time_ms": 65.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:25:50.527289+00	1
20841	Viewed/List Bk 1 000042	GET	/api/bookings/details/BK-1-000042	200	157.51.209.48	1	{"process_time_ms": 19.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:27:27.445803+00	1
20858	Viewed/List Items	GET	/api/inventory/items	200	157.51.209.48	1	{"process_time_ms": 22.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 17:29:06.353276+00	1
20828	Viewed/List Employees	GET	/api/employees	200	157.51.209.48	1	{"process_time_ms": 54.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 17:25:46.065358+00	1
20845	Viewed/List Holidays	GET	/api/attendance/holidays	200	157.51.209.48	1	{"process_time_ms": 15.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:28:42.905149+00	1
20849	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 20.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:28:46.847288+00	1
20857	Viewed/List Locations	GET	/api/inventory/locations	200	157.51.209.48	1	{"process_time_ms": 161.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 17:29:06.340791+00	1
20847	Viewed/List Branches	GET	/api/branches	200	157.51.209.48	1	{"process_time_ms": 9.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:28:43.316757+00	1
20848	Viewed/List Guest Suggestions	GET	/api/reports/guest-suggestions	200	157.51.209.48	1	{"process_time_ms": 15.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:28:46.840695+00	1
20860	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	157.51.209.48	1	{"process_time_ms": 16.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 17:29:22.193928+00	1
20850	Viewed/List Guest Profile	GET	/api/reports/guest-profile	200	157.51.209.48	1	{"process_time_ms": 28.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "guest_name=Dr.A.S+sanil&guest_email=orchidresort%40gmail.com&guest_mobile=9496368062"}	2026-05-08 17:28:49.645154+00	1
20852	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	157.51.209.48	1	{"process_time_ms": 54.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 17:29:05.870906+00	1
20856	Viewed/List Types	GET	/api/rooms/types	200	157.51.209.48	1	{"process_time_ms": 23.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:29:06.18395+00	1
20853	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 62.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 17:29:05.875309+00	1
20855	Viewed/List 	GET	/api/rooms/	200	157.51.209.48	1	{"process_time_ms": 81.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 17:29:05.887327+00	1
20859	Viewed/List Bookings	GET	/api/bookings	200	157.51.209.48	1	{"process_time_ms": 21.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 17:29:06.773454+00	1
20861	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 112.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:31.218232+00	1
20862	User Login Attempt	POST	/api/auth/login	200	205.254.184.6	1	{"process_time_ms": 526.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:51.663091+00	1
20863	Viewed/List 	GET	/api/settings/	200	205.254.184.6	1	{"process_time_ms": 34.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:52.000607+00	1
20864	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 71.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:52.495585+00	1
20865	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 101.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:52.512046+00	1
20866	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 117.59, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 18:25:52.529679+00	1
20867	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 214.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 18:25:52.608421+00	1
20868	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 14.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 18:25:52.790572+00	1
20869	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 61.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:58.073825+00	1
20870	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 74.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 18:25:58.082454+00	1
20871	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 90.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 18:25:58.095724+00	1
20872	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 67.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:58.098863+00	1
20873	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 101.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:58.103079+00	1
20874	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 32.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 18:25:58.396872+00	1
20875	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 31.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 18:25:58.414746+00	1
20876	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 57.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:25:58.425087+00	1
20877	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 21.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 18:25:58.729153+00	1
20878	Viewed/List Bk 1 000045	GET	/api/bookings/details/BK-1-000045	200	205.254.184.6	1	{"process_time_ms": 45.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:26:04.53532+00	1
20879	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	205.254.184.6	1	{"process_time_ms": 18.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:26:19.053376+00	1
20880	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 23.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:26:19.431968+00	1
20881	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 26.97, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 18:26:19.443262+00	1
20882	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 41.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:26:19.450588+00	1
20883	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	205.254.184.6	1	{"process_time_ms": 15.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:26:38.588001+00	1
20884	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 14.21, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 18:26:38.897937+00	1
20885	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 15.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:26:38.907916+00	1
20889	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	205.254.184.6	1	{"process_time_ms": 18.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:27:46.59474+00	1
20893	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	205.254.184.6	1	{"process_time_ms": 14.93, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:27:55.447106+00	1
20897	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 39.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:28:03.039582+00	1
20899	Viewed/List Food Orders	GET	/api/reports/food-orders	200	205.254.184.6	1	{"process_time_ms": 52.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:29:39.815875+00	1
20886	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 18.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:26:39.258225+00	1
20890	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 14.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 18:27:46.951618+00	1
20894	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	205.254.184.6	1	{"process_time_ms": 18.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:28:02.14078+00	1
20901	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 98.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:29:39.861313+00	1
20908	Viewed/List Ledgers	GET	/api/accounts/ledgers	200	205.254.184.6	1	{"process_time_ms": 17.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:29:42.232207+00	1
20887	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	205.254.184.6	1	{"process_time_ms": 14.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:26:53.154242+00	1
20903	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 179.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 18:29:39.930844+00	1
20907	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 29.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=100"}	2026-05-08 18:29:40.16914+00	1
20888	Viewed/List Bk 1 000040	GET	/api/bookings/details/BK-1-000040	200	205.254.184.6	1	{"process_time_ms": 20.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:27:41.138822+00	1
20891	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 16.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:27:46.962498+00	1
20892	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 15.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:27:47.239833+00	1
20895	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 25.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 18:28:03.023138+00	1
20906	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 23.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=50"}	2026-05-08 18:29:40.160402+00	1
20909	Viewed/List Groups	GET	/api/accounts/groups	200	205.254.184.6	1	{"process_time_ms": 21.98, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:29:42.236507+00	1
20896	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 25.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:28:03.035187+00	1
20898	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 11.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:29:39.443626+00	1
20900	Viewed/List Package Bookings	GET	/api/reports/package-bookings	200	205.254.184.6	1	{"process_time_ms": 68.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:29:39.831275+00	1
20902	Viewed/List Charts	GET	/api/dashboard/charts	200	205.254.184.6	1	{"process_time_ms": 120.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:29:39.876178+00	1
20904	Viewed/List Expenses	GET	/api/reports/expenses	200	205.254.184.6	1	{"process_time_ms": 14.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:29:40.124653+00	1
20905	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 18.89, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:29:40.130632+00	1
20910	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 11.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:32:59.757958+00	1
20911	Viewed/List 	GET	/api/settings/	200	205.254.184.6	1	{"process_time_ms": 8.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:00.045281+00	1
20912	Viewed/List 	GET	/api/settings/	200	205.254.184.6	1	{"process_time_ms": 7.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:01.492032+00	1
20913	Viewed/List 	GET	/api/legal/	404	205.254.184.6	1	{"process_time_ms": 4.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:24.486825+00	1
20914	Viewed/List 	GET	/api/calendar/	200	205.254.184.6	1	{"process_time_ms": 10.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:33.670145+00	1
20915	Viewed/List 	GET	/api/legal/	404	205.254.184.6	1	{"process_time_ms": 1.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:35.050897+00	1
20916	Viewed/List 	GET	/api/settings/	200	205.254.184.6	1	{"process_time_ms": 7.73, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:37.504923+00	1
20917	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 25.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:44.188998+00	1
20918	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 31.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 18:33:44.204308+00	1
20919	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 53.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 18:33:44.212639+00	1
20920	Viewed/List Expenses	GET	/api/expenses	200	205.254.184.6	1	{"process_time_ms": 11.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 18:33:44.485984+00	1
20921	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 26.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:44.509124+00	1
20922	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 29.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:44.837808+00	1
20923	Viewed/List Services	GET	/api/services	200	205.254.184.6	1	{"process_time_ms": 32.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:44.842814+00	1
20924	Viewed/List Assigned	GET	/api/services/assigned	200	205.254.184.6	1	{"process_time_ms": 39.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:44.852818+00	1
20925	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 45.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 18:33:44.867245+00	1
20926	Viewed/List Categories	GET	/api/inventory/categories	200	205.254.184.6	1	{"process_time_ms": 32.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 18:33:45.18001+00	1
20927	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 34.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:45.184661+00	1
20928	Viewed/List Packages	GET	/api/packages	200	205.254.184.6	1	{"process_time_ms": 41.71, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:45.18776+00	1
20929	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 46.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:45.197442+00	1
20930	Viewed/List Checkouts	GET	/api/bill/checkouts	200	205.254.184.6	1	{"process_time_ms": 46.87, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-08 18:33:45.203124+00	1
20931	Viewed/List Kpis	GET	/api/dashboard/kpis	200	205.254.184.6	1	{"process_time_ms": 32.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:45.489063+00	1
20932	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 106.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 18:33:45.559787+00	1
20933	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 32.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:46.079625+00	1
20934	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 31.38, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-08 18:33:46.085462+00	1
20935	Viewed/List Food Orders	GET	/api/reports/food-orders	200	205.254.184.6	1	{"process_time_ms": 53.52, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:33:46.114759+00	1
20936	Viewed/List Package Bookings	GET	/api/reports/package-bookings	200	205.254.184.6	1	{"process_time_ms": 61.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:33:46.121287+00	1
20947	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 82.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 18:33:47.928694+00	1
20957	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 74.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:50.499676+00	1
20966	Viewed/List Budgets	GET	/api/expenses/budgets	200	205.254.184.6	1	{"process_time_ms": 43.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:53.312136+00	1
20980	Viewed/List Bk 1 000045	GET	/api/bookings/details/BK-1-000045	200	205.254.184.6	1	{"process_time_ms": 14.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:38:38.205477+00	1
20937	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 77.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:33:46.137796+00	1
20950	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 16.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 18:33:48.205558+00	1
20952	Viewed/List Assigned	GET	/api/services/assigned	200	205.254.184.6	1	{"process_time_ms": 27.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=100"}	2026-05-08 18:33:50.448301+00	1
20954	Viewed/List Services	GET	/api/services	200	205.254.184.6	1	{"process_time_ms": 63.07, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:50.479993+00	1
20963	Viewed/List Service Requests	GET	/api/service-requests	200	205.254.184.6	1	{"process_time_ms": 53.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100&include_checkout_requests=true"}	2026-05-08 18:33:51.110377+00	1
20967	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 41.69, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:53.317523+00	1
20938	Viewed/List Charts	GET	/api/dashboard/charts	200	205.254.184.6	1	{"process_time_ms": 89.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:46.155173+00	1
20942	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 23.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=100"}	2026-05-08 18:33:46.415031+00	1
20951	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 21.03, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 18:33:48.519483+00	1
20964	Viewed/List Expenses	GET	/api/expenses	200	205.254.184.6	1	{"process_time_ms": 27.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20"}	2026-05-08 18:33:53.299474+00	1
20972	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 88.67, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-08 18:33:59.502803+00	1
20976	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 21.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-08 18:34:00.081597+00	1
20939	Viewed/List Expenses	GET	/api/reports/expenses	200	205.254.184.6	1	{"process_time_ms": 11.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:33:46.372518+00	1
20956	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 66.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:50.492181+00	1
20969	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 53.29, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 18:33:59.476234+00	1
20940	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 19.44, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=10"}	2026-05-08 18:33:46.379094+00	1
20949	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 13.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 18:33:48.193973+00	1
20955	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 59.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:50.486123+00	1
20959	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 14.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:50.765081+00	1
20970	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 65.16, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:59.47936+00	1
20978	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 24.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:38:20.28765+00	1
20941	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 13.64, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=50"}	2026-05-08 18:33:46.403199+00	1
20943	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 33.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:47.892252+00	1
20945	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 67.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-08 18:33:47.91517+00	1
20960	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 17.32, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:50.771461+00	1
20975	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 15.99, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-08 18:33:59.785066+00	1
20944	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 63.66, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:47.908633+00	1
20971	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 87.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:59.49837+00	1
20979	Viewed/List Bk 1 000045	GET	/api/bookings/details/BK-1-000045	200	205.254.184.6	1	{"process_time_ms": 16.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:38:29.997101+00	1
20946	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 82.01, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:47.924127+00	1
20953	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 42.65, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:50.473261+00	1
20961	Viewed/List Kpis	GET	/api/dashboard/kpis	200	205.254.184.6	1	{"process_time_ms": 13.09, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:51.065573+00	1
20974	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 14.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-08 18:33:59.773308+00	1
20982	Viewed/List Bk 1 000045	GET	/api/bookings/details/BK-1-000045	200	205.254.184.6	1	{"process_time_ms": 15.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:46:59.496698+00	1
20948	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 84.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:47.931687+00	1
20958	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 9.08, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-08 18:33:50.743238+00	1
20962	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 26.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=200"}	2026-05-08 18:33:51.077127+00	1
20965	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 37.34, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-08 18:33:53.304164+00	1
20968	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 59.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:59.471707+00	1
20973	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 97.19, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 18:33:59.511401+00	1
20977	Viewed/List Test	GET	/api/rooms/test	200	205.254.184.6	1	{"process_time_ms": 19.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&_t=1778265498602"}	2026-05-08 18:38:19.978107+00	1
20981	Viewed/List Bk 1 000044	GET	/api/bookings/details/BK-1-000044	200	205.254.184.6	1	{"process_time_ms": 19.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-08 18:46:50.444661+00	1
20983	Viewed/List .Env	GET	/api/.env	404	18.140.246.185	\N	{"process_time_ms": 20.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 20:11:04.667987+00	1
20984	Viewed/List .Env	GET	/api/v1/.env	404	18.140.246.185	\N	{"process_time_ms": 1.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 20:11:16.571386+00	1
20985	Viewed/List .Env	GET	/api/v2/.env	404	18.140.246.185	\N	{"process_time_ms": 1.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 20:11:16.821527+00	1
20986	Viewed/List .Env	GET	/api/v3/.env	404	18.140.246.185	\N	{"process_time_ms": 1.5, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 20:11:18.178512+00	1
20987	Viewed/List .Env	GET	/api/dev/.env	404	18.140.246.185	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 20:11:18.428373+00	1
20988	Viewed/List .Env	GET	/api/staging/.env	404	18.140.246.185	\N	{"process_time_ms": 1.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", "query_params": ""}	2026-05-08 20:11:18.679078+00	1
20992	Viewed/List Check Version	GET	/api/v1/check-version	404	172.233.178.66	\N	{"process_time_ms": 1.35, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:18:48.365656+00	1
20993	Viewed/List Version	GET	/api/version	404	172.233.178.66	\N	{"process_time_ms": 1.87, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:18:52.050203+00	1
20994	Viewed/List 1	GET	/api/vip/i18n/api/v2/translation/products/vRNIUI/versions/1	404	172.233.178.66	\N	{"process_time_ms": 1.61, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:18:53.815737+00	1
20995	Viewed/List Environment	GET	/api/v1.0/environment	404	172.233.178.66	\N	{"process_time_ms": 1.42, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:18:54.988687+00	1
20996	Viewed/List Meta	GET	/api/v3/meta	404	172.233.178.66	\N	{"process_time_ms": 1.82, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:18:57.255561+00	1
20997	Viewed/List Version	GET	/api/v1/version	404	172.233.178.66	\N	{"process_time_ms": 1.31, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:18:57.674741+00	1
21001	Viewed/List Systeminfo	GET	/api/v2.0/systeminfo	404	172.233.178.66	\N	{"process_time_ms": 1.42, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:19:03.65009+00	1
21002	Viewed/List Summary	GET	/api/v1/cluster/summary	404	172.233.178.66	\N	{"process_time_ms": 1.87, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:19:03.657251+00	1
21003	Viewed/List Status	GET	/api/system/status	404	172.233.178.66	\N	{"process_time_ms": 1.25, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:19:04.024767+00	1
20998	Viewed/List Version	GET	/api/v2/hoverfly/version	404	172.233.178.66	\N	{"process_time_ms": 1.27, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:18:59.883048+00	1
20999	Viewed/List Status	GET	/api/status	404	172.233.178.66	\N	{"process_time_ms": 2.6, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:19:00.088551+00	1
21000	Viewed/List Info	GET	/api/v1/info	404	172.233.178.66	\N	{"process_time_ms": 13.48, "user_agent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML", "query_params": ""}	2026-05-08 20:19:00.092547+00	1
21004	Viewed/List Branches	GET	/api/public/branches	200	5.61.122.221	\N	{"process_time_ms": 84.51, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": ""}	2026-05-08 22:05:11.151208+00	1
21005	Viewed/List Rooms	GET	/api/public/rooms	200	5.61.122.221	\N	{"process_time_ms": 49.67, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277910862"}	2026-05-08 22:05:11.329064+00	1
21006	Viewed/List Bookings	GET	/api/public/bookings	200	5.61.122.221	\N	{"process_time_ms": 31.59, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778277911289"}	2026-05-08 22:05:11.503165+00	1
21007	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	5.61.122.221	\N	{"process_time_ms": 29.56, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "limit=500&skip=0&_t=1778277911459"}	2026-05-08 22:05:11.66688+00	1
21008	Viewed/List 	GET	/api/resort-info/	200	5.61.122.221	\N	{"process_time_ms": 26.23, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911622"}	2026-05-08 22:05:11.812279+00	1
21009	Viewed/List Food Categories	GET	/api/public/food-categories	200	5.61.122.221	\N	{"process_time_ms": 32.38, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911768"}	2026-05-08 22:05:11.965534+00	1
21010	Viewed/List Food Items	GET	/api/public/food-items	200	5.61.122.221	\N	{"process_time_ms": 34.21, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911768"}	2026-05-08 22:05:11.97208+00	1
21011	Viewed/List Packages	GET	/api/public/packages	200	5.61.122.221	\N	{"process_time_ms": 41.68, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911768"}	2026-05-08 22:05:11.97837+00	1
21012	Viewed/List 	GET	/api/header-banner/	200	5.61.122.221	\N	{"process_time_ms": 26.67, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911768"}	2026-05-08 22:05:11.988001+00	1
21013	Viewed/List Services	GET	/api/public/services	200	5.61.122.221	\N	{"process_time_ms": 17.9, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911768"}	2026-05-08 22:05:12.1174+00	1
21014	Viewed/List 	GET	/api/plan-weddings/	200	5.61.122.221	\N	{"process_time_ms": 27.37, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911769"}	2026-05-08 22:05:12.128739+00	1
21015	Viewed/List 	GET	/api/signature-experiences/	200	5.61.122.221	\N	{"process_time_ms": 31.87, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911768"}	2026-05-08 22:05:12.133111+00	1
21016	Viewed/List 	GET	/api/nearby-attractions/	200	5.61.122.221	\N	{"process_time_ms": 30.01, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911769"}	2026-05-08 22:05:12.136359+00	1
21017	Viewed/List 	GET	/api/gallery/	200	5.61.122.221	\N	{"process_time_ms": 9.95, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911768"}	2026-05-08 22:05:12.205111+00	1
21018	Viewed/List 	GET	/api/reviews/	200	5.61.122.221	\N	{"process_time_ms": 13.74, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911768"}	2026-05-08 22:05:12.213424+00	1
21019	Viewed/List 	GET	/api/nearby-attraction-banners/	200	5.61.122.221	\N	{"process_time_ms": 6.59, "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/419.4.905781065 Mobile/15E148 Safari/604.1", "query_params": "_t=1778277911769"}	2026-05-08 22:05:12.241621+00	1
21020	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 116.33, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 03:15:33.635123+00	1
21021	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 108.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:28.285398+00	1
21022	User Login Attempt	POST	/api/auth/login	200	205.254.184.6	1	{"process_time_ms": 489.62, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:47.569616+00	1
21023	Viewed/List 	GET	/api/settings/	200	205.254.184.6	1	{"process_time_ms": 30.95, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:47.890881+00	1
21024	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 51.2, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:48.38228+00	1
21025	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 80.25, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:48.39659+00	1
21026	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 191.35, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-09 05:02:48.509871+00	1
21027	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 42.88, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-09 05:02:48.700419+00	1
21036	Viewed/List Services	GET	/api/services	200	205.254.184.6	1	{"process_time_ms": 49.78, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-09 05:02:57.030156+00	1
21039	Viewed/List Checkouts	GET	/api/bill/checkouts	200	205.254.184.6	1	{"process_time_ms": 51.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-09 05:02:57.367139+00	1
21044	Viewed/List Kpis	GET	/api/dashboard/kpis	200	205.254.184.6	1	{"process_time_ms": 19.91, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:57.668371+00	1
21028	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 27.94, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=1000"}	2026-05-09 05:02:48.710252+00	1
21029	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 51.57, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:56.645818+00	1
21030	Viewed/List Expenses	GET	/api/expenses	200	205.254.184.6	1	{"process_time_ms": 62.39, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-09 05:02:56.663911+00	1
21040	Viewed/List Employees	GET	/api/employees	200	205.254.184.6	1	{"process_time_ms": 48.68, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-09 05:02:57.373449+00	1
21046	Viewed/List 	GET	/api/rooms/	200	205.254.184.6	1	{"process_time_ms": 76.84, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:59.274886+00	1
21048	Viewed/List 	GET	/api/packages/	200	205.254.184.6	1	{"process_time_ms": 86.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:59.287152+00	1
21051	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 10.54, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500"}	2026-05-09 05:02:59.520315+00	1
21052	Viewed/List Locations	GET	/api/inventory/locations	200	205.254.184.6	1	{"process_time_ms": 13.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=10000"}	2026-05-09 05:02:59.575637+00	1
21031	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 72.81, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-09 05:02:56.667942+00	1
21049	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 95.1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-09 05:02:59.299522+00	1
21054	Viewed/List Bk 1 000045	GET	/api/bookings/details/BK-1-000045	200	205.254.184.6	1	{"process_time_ms": 23.47, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-09 05:03:09.58108+00	1
21032	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 84.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-09 05:02:56.683788+00	1
21037	Viewed/List Food Orders	GET	/api/food-orders	200	205.254.184.6	1	{"process_time_ms": 62.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-09 05:02:57.037397+00	1
21041	Viewed/List Items	GET	/api/inventory/items	200	205.254.184.6	1	{"process_time_ms": 53.51, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-09 05:02:57.379229+00	1
21050	Viewed/List Types	GET	/api/rooms/types	200	205.254.184.6	1	{"process_time_ms": 103.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:59.302723+00	1
21033	Viewed/List Rooms	GET	/api/rooms	200	205.254.184.6	1	{"process_time_ms": 92.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-09 05:02:56.687557+00	1
21034	Viewed/List Assigned	GET	/api/services/assigned	200	205.254.184.6	1	{"process_time_ms": 35.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-09 05:02:57.01294+00	1
21035	Viewed/List Food Items	GET	/api/food-items	200	205.254.184.6	1	{"process_time_ms": 44.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-09 05:02:57.024843+00	1
21038	Viewed/List Categories	GET	/api/inventory/categories	200	205.254.184.6	1	{"process_time_ms": 45.18, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=50"}	2026-05-09 05:02:57.362494+00	1
21042	Viewed/List Packages	GET	/api/packages	200	205.254.184.6	1	{"process_time_ms": 56.9, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=100"}	2026-05-09 05:02:57.382655+00	1
21043	Viewed/List Summary	GET	/api/dashboard/summary	200	205.254.184.6	1	{"process_time_ms": 6.43, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "period=all"}	2026-05-09 05:02:57.641995+00	1
21045	Viewed/List Branches	GET	/api/branches	200	205.254.184.6	1	{"process_time_ms": 38.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 05:02:59.227951+00	1
21047	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	205.254.184.6	1	{"process_time_ms": 77.6, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "skip=0&limit=500"}	2026-05-09 05:02:59.283382+00	1
21053	Viewed/List Bookings	GET	/api/bookings	200	205.254.184.6	1	{"process_time_ms": 20.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-09 05:02:59.878208+00	1
21055	Viewed/List .Env	GET	/api/.env	404	213.209.159.175	\N	{"process_time_ms": 20.1, "user_agent": "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0.514.0 Safari/534.7", "query_params": ""}	2026-05-09 06:26:55.880769+00	1
21056	Viewed/List Test	GET	/api/test	404	213.209.159.175	\N	{"process_time_ms": 1.4, "user_agent": "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0.514.0 Safari/534.7", "query_params": ""}	2026-05-09 06:26:57.936273+00	1
21057	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 160.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 08:36:27.415128+00	1
21058	Viewed/List 	GET	/api/rooms/	200	103.72.178.127	1	{"process_time_ms": 228.42, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 08:36:27.488299+00	1
21059	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 81.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-09 08:36:27.542218+00	1
21060	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.127	1	{"process_time_ms": 17.83, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-09 08:36:27.716854+00	1
21061	Viewed/List 	GET	/api/packages/	200	103.72.178.127	1	{"process_time_ms": 10.76, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 08:36:27.740102+00	1
21062	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.127	1	{"process_time_ms": 25.74, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 08:36:27.790985+00	1
21063	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.127	1	{"process_time_ms": 21.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-09 08:36:27.824444+00	1
21064	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.127	1	{"process_time_ms": 13.11, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-09 08:36:27.961076+00	1
21065	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 8.36, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 08:36:27.975778+00	1
21066	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 23.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-09 08:36:28.255873+00	1
21067	Viewed/List Bk 1 000045	GET	/api/bookings/details/BK-1-000045	200	205.254.184.6	1	{"process_time_ms": 27.31, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "query_params": "is_package=false"}	2026-05-09 09:02:51.580799+00	1
21068	Viewed/List Branches	GET	/api/public/branches	200	40.77.178.42	\N	{"process_time_ms": 114.44, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/136.0.0.0 Safari/537.36", "query_params": ""}	2026-05-09 09:33:02.158679+00	1
21069	Viewed/List Rooms	GET	/api/public/rooms	200	40.77.178.42	\N	{"process_time_ms": 161.34, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/136.0.0.0 Safari/537.36", "query_params": "_t=1778319181442"}	2026-05-09 09:33:02.199497+00	1
21070	Viewed/List Bookings	GET	/api/public/bookings	200	40.77.178.42	\N	{"process_time_ms": 32.7, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/136.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778319182558"}	2026-05-09 09:33:02.95+00	1
21071	Viewed/List Package Bookings	GET	/api/public/package-bookings	200	40.77.178.42	\N	{"process_time_ms": 28.4, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/136.0.0.0 Safari/537.36", "query_params": "limit=500&skip=0&_t=1778319183371"}	2026-05-09 09:33:05.319652+00	1
21072	Viewed/List 	GET	/api/resort-info/	200	40.77.178.42	\N	{"process_time_ms": 27.13, "user_agent": "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/136.0.0.0 Safari/537.36", "query_params": "_t=1778319185429"}	2026-05-09 09:33:05.652243+00	1
21074	Viewed/List 	GET	/api/rooms/	200	103.72.178.127	1	{"process_time_ms": 42.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:39:44.111272+00	1
21078	Viewed/List 	GET	/api/packages/	200	103.72.178.127	1	{"process_time_ms": 58.27, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:39:44.340085+00	1
21082	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 22.0, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-09 09:39:44.904999+00	1
21089	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.127	1	{"process_time_ms": 31.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:48:06.406634+00	1
21092	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 20.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-09 09:48:06.870706+00	1
21096	Viewed/List Bk 1 000046	GET	/api/bookings/details/BK-1-000046	200	103.72.178.127	1	{"process_time_ms": 18.28, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-09 09:51:06.636054+00	1
21098	Viewed/List 	GET	/api/rooms/	200	103.72.178.127	1	{"process_time_ms": 15.72, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:51:33.924542+00	1
21103	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.127	1	{"process_time_ms": 39.4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-09 09:51:34.741693+00	1
21073	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 24.12, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:39:43.792095+00	1
21075	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 38.55, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:39:44.3024+00	1
21076	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 64.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-09 09:39:44.331744+00	1
21079	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.127	1	{"process_time_ms": 26.63, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:39:44.412802+00	1
21081	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.127	1	{"process_time_ms": 12.13, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-09 09:39:44.615181+00	1
21084	Viewed/List 	GET	/api/rooms/	200	103.72.178.127	1	{"process_time_ms": 75.05, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:48:05.828284+00	1
21086	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.127	1	{"process_time_ms": 23.02, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-09 09:48:06.117214+00	1
21099	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 22.96, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-09 09:51:34.210729+00	1
21100	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.127	1	{"process_time_ms": 10.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-09 09:51:34.464703+00	1
21102	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.127	1	{"process_time_ms": 20.23, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-09 09:51:34.729007+00	1
21104	Viewed/List Types	GET	/api/rooms/types	200	103.72.178.127	1	{"process_time_ms": 50.7, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:51:34.748862+00	1
21077	Viewed/List Bookingsall	GET	/api/packages/bookingsall	200	103.72.178.127	1	{"process_time_ms": 60.24, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=500"}	2026-05-09 09:39:44.336283+00	1
21080	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.127	1	{"process_time_ms": 17.61, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-09 09:39:44.582925+00	1
21083	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 40.15, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:48:05.802044+00	1
21085	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 26.04, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "skip=0&limit=20&order_by=id&order=desc"}	2026-05-09 09:48:06.103078+00	1
21087	Viewed/List 	GET	/api/packages/	200	103.72.178.127	1	{"process_time_ms": 8.56, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:48:06.262471+00	1
21088	Viewed/List Branches	GET	/api/branches	200	103.72.178.127	1	{"process_time_ms": 20.41, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:48:06.400598+00	1
21090	Viewed/List Items	GET	/api/inventory/items	200	103.72.178.127	1	{"process_time_ms": 18.45, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500"}	2026-05-09 09:48:06.546721+00	1
21093	Created/Added Bookings	POST	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 852.26, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:49:40.409106+00	1
21094	Viewed/List Bk 1 000046	GET	/api/bookings/details/BK-1-000046	200	103.72.178.127	1	{"process_time_ms": 28.14, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-09 09:50:07.73195+00	1
21095	Viewed/List Bk 1 000043	GET	/api/bookings/details/BK-1-000043	200	103.72.178.127	1	{"process_time_ms": 19.3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-09 09:50:54.131744+00	1
21097	Created/Added Confirm	POST	/api/bookings/46/confirm	200	103.72.178.127	1	{"process_time_ms": 25.58, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:51:33.64047+00	1
21101	Viewed/List 	GET	/api/packages/	200	103.72.178.127	1	{"process_time_ms": 7.49, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:51:34.480871+00	1
21105	Viewed/List Bookings	GET	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 24.06, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=500&order_by=id&order=desc"}	2026-05-09 09:51:35.036098+00	1
21107	Viewed/List Bk 1 000047	GET	/api/bookings/details/BK-1-000047	200	103.72.178.127	1	{"process_time_ms": 19.46, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "is_package=false"}	2026-05-09 09:54:14.490143+00	1
21091	Viewed/List Locations	GET	/api/inventory/locations	200	103.72.178.127	1	{"process_time_ms": 9.79, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": "limit=10000"}	2026-05-09 09:48:06.577465+00	1
21106	Created/Added Bookings	POST	/api/bookings	200	103.72.178.127	1	{"process_time_ms": 498.17, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0", "query_params": ""}	2026-05-09 09:54:09.525187+00	1
\.


--
-- Data for Name: asset_mappings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_mappings (id, item_id, location_id, serial_number, assigned_date, assigned_by, notes, is_active, unassigned_date, quantity, branch_id) FROM stdin;
\.


--
-- Data for Name: asset_registry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_registry (id, asset_tag_id, item_id, serial_number, current_location_id, status, purchase_date, warranty_expiry, last_maintenance_date, next_maintenance_due, purchase_master_id, notes, created_at, updated_at, branch_id) FROM stdin;
\.


--
-- Data for Name: assigned_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assigned_services (id, service_id, employee_id, room_id, booking_id, package_booking_id, assigned_at, status, billing_status, branch_id, last_used_at, started_at, completed_at, override_charges) FROM stdin;
\.


--
-- Data for Name: attendances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendances (id, employee_id, date, status, branch_id) FROM stdin;
\.


--
-- Data for Name: booking_rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking_rooms (id, booking_id, room_id, branch_id) FROM stdin;
5	39	26	1
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, display_id, status, guest_name, guest_mobile, guest_email, check_in, check_out, checked_in_at, checked_out_at, adults, children, id_card_image_url, guest_photo_url, user_id, total_amount, advance_deposit, created_at, branch_id, room_type_id, num_rooms, external_id, source, package_name, is_id_verified, digital_signature_url, special_requests, preferences, room_rate, rate_plan_code, is_confirmed, confirmed_at, confirmation_notes) FROM stdin;
40	BK-1-000040	Booked	Partha sarathy	8754476030	orchidresort@gmail.com	2026-05-08	2026-05-10	\N	\N	2	1	\N	\N	23	19000	0	2026-05-07 10:34:20.284066	1	3	1	\N	Admin	\N	f	\N	\N	\N	9500	\N	f	\N	\N
41	BK-1-000041	cancelled	Dr.A.S sanil	9496368062	orchidresort@gmail.com	2026-05-08	2026-05-10	\N	\N	14	2	\N	\N	23	210800	0	2026-05-07 10:37:44.861464	1	3	4	\N	Admin	\N	f	\N	\N	\N	26350	\N	f	\N	\N
42	BK-1-000042	Booked	Dr.A.S sanil	9496368062	orchidresort@gmail.com	2026-05-09	2026-05-10	\N	\N	14	2	\N	\N	23	105400	0	2026-05-07 10:42:13.157413	1	3	4	\N	Admin	\N	f	\N	\N	\N	26350	\N	f	\N	\N
43	BK-1-000043	Booked	Muhammed M K	8590155002	orchidresort@gmail.com	2026-05-09	2026-05-10	\N	\N	6	1	\N	\N	23	40500	0	2026-05-07 11:06:17.834065	1	3	3	\N	Admin	\N	f	\N	\N	\N	13500	\N	f	\N	\N
39	BK-1-000039	checked-in	Shubha	9900513006	orchidresort@gmail.com	2026-05-07	2026-05-09	2026-05-07 11:09:20.904836	\N	1	0	id_39_f113b900408a4ecbbe6b33f4141d8247.jpg	guest_39_d590b85cdba24b03bc3a73f71275fb74.jpg	1	20000	0	2026-05-07 10:29:32.163804	1	3	1	\N	Admin	\N	f	\N	\N	\N	10000	\N	f	\N	\N
44	BK-1-000044	Booked	Sirajudeen 	9867330043	orchidresort@gmail.com	2026-05-09	2026-05-10	\N	\N	4	3	\N	\N	23	13000	0	2026-05-07 18:13:50.953534	1	2	2	\N	Admin	\N	f	\N	\N	\N	6500	\N	f	\N	\N
45	BK-1-000045	Booked	Sirajudeen 	9867330043	orchidresort@gmail.com	2026-05-09	2026-05-10	\N	\N	2	0	\N	\N	23	10000	0	2026-05-07 18:17:35.430778	1	1	2	\N	Admin	\N	f	\N	\N	\N	5000	\N	f	\N	\N
46	BK-1-000046	Booked	Mohamed Ali	97471100440	orchidresort@gmail.com	2026-05-21	2026-05-24	\N	\N	2	2	\N	\N	23	54000	0	2026-05-09 09:49:40.343764	1	2	1	\N	Admin	\N	f	\N	\N	\N	18000	\N	t	2026-05-09 09:51:33.624686	
47	BK-1-000047	Booked	Achuthanandha	9964344448	orchidresort@gmail.com	2026-05-21	2026-05-23	\N	\N	2	2	\N	\N	23	10000	0	2026-05-09 09:54:09.500517	1	3	1	\N	Admin	\N	f	\N	\N	\N	5000	\N	f	\N	\N
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branches (id, name, code, address, phone, email, gst_number, image_url, facebook, instagram, twitter, linkedin, is_active, created_at) FROM stdin;
1	Orchid	ZEEBULL		+918075019543	info@zeebull.com		/uploads/branch_3a04052f31ee448b8453fbbadec52595.jpeg					t	2026-04-08 05:10:33.506413
2	Zeebull Wild villa	ORCHID		0987654321	info@zeebull.com		/uploads/branch_c140f9b91f684979bed4f6a8498f9e0a.jpeg					t	2026-04-08 06:28:38.812266
\.


--
-- Data for Name: check_availability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.check_availability (id, name, email, phone, check_in, check_out, guests, is_active, branch_id) FROM stdin;
\.


--
-- Data for Name: checkout_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checkout_payments (id, checkout_id, payment_method, amount, transaction_id, notes, created_at, branch_id) FROM stdin;
\.


--
-- Data for Name: checkout_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checkout_requests (id, booking_id, package_booking_id, room_number, guest_name, branch_id, status, requested_by, requested_at, employee_id, inventory_checked, inventory_checked_by, inventory_checked_at, inventory_notes, inventory_data, started_at, completed_at, checkout_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: checkout_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checkout_verifications (id, checkout_id, checkout_request_id, room_number, branch_id, housekeeping_status, housekeeping_notes, housekeeping_approved_by, housekeeping_approved_at, consumables_audit_data, consumables_total_charge, asset_damages, asset_damage_total, key_card_returned, key_card_fee, created_at) FROM stdin;
\.


--
-- Data for Name: checkouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checkouts (id, room_total, food_total, service_total, package_total, tax_amount, discount_amount, grand_total, guest_name, room_number, created_at, checkout_date, payment_method, late_checkout_fee, consumables_charges, inventory_charges, asset_damage_charges, key_card_fee, advance_deposit, tips_gratuity, bill_details, guest_gstin, is_b2b, invoice_number, invoice_pdf_path, gate_pass_path, feedback_sent, booking_id, package_booking_id, payment_status, notes, branch_id) FROM stdin;
\.


--
-- Data for Name: day_audits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.day_audits (id, branch_id, business_date, status, opened_at, opened_by_id, opening_cash_balance, opening_notes, closed_at, closed_by_id, closing_cash_balance, closing_notes, total_room_revenue, total_food_revenue, total_service_revenue, total_gst_collected, total_payments_received, total_expenses, rooms_occupied, new_checkins, new_checkouts, audit_log, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: employee_inventory_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_inventory_assignments (id, employee_id, assigned_service_id, item_id, quantity_assigned, quantity_used, quantity_returned, status, is_returned, assigned_at, branch_id, returned_at, notes) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id, name, role, salary, join_date, image_url, daily_tasks, paid_leave_balance, sick_leave_balance, long_leave_balance, wellness_leave_balance, user_id, branch_id) FROM stdin;
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expenses (id, category, amount, date, description, employee_id, image, department, status, created_at, branch_id, rcm_applicable, rcm_tax_rate, nature_of_supply, original_bill_no, self_invoice_number, vendor_id, rcm_liability_date, itc_eligible) FROM stdin;
\.


--
-- Data for Name: food_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.food_categories (id, name, image, branch_id) FROM stdin;
\.


--
-- Data for Name: food_item_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.food_item_images (id, image_url, item_id) FROM stdin;
\.


--
-- Data for Name: food_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.food_items (id, name, description, price, available, category_id, branch_id, available_from_time, available_to_time, always_available, time_wise_prices, room_service_price, extra_inventory_items) FROM stdin;
\.


--
-- Data for Name: food_order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.food_order_items (id, order_id, food_item_id, quantity, branch_id) FROM stdin;
\.


--
-- Data for Name: food_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.food_orders (id, room_id, amount, booking_id, package_booking_id, assigned_employee_id, status, billing_status, order_type, delivery_request, payment_method, payment_time, gst_amount, total_with_gst, is_deleted, created_by_id, prepared_by_id, created_at, branch_id) FROM stdin;
\.


--
-- Data for Name: gallery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gallery (id, image_url, caption, is_active, branch_id) FROM stdin;
1	/uploads/gallery_015dee72c901439f8862815538ee37ee.jpg	Restaurant	t	2
2	/uploads/gallery_2246d4ff78fd4c52af3fc5d22b8534b9.jpg	main entrance	t	2
3	/uploads/gallery_e44474693ad745419cde485623111aa9.jpg	Entrance	t	2
4	/uploads/gallery_ce0f64f795f44ab893f6dffe627a018b.jpg	Play Area	t	2
5	/uploads/gallery_5bde13e196ba431d9c08432de72fdd02.jpeg	Reception	t	2
\.


--
-- Data for Name: guest_suggestions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.guest_suggestions (id, guest_name, contact_info, suggestion, status, created_at) FROM stdin;
\.


--
-- Data for Name: header_banner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.header_banner (id, title, subtitle, image_url, is_active, branch_id) FROM stdin;
3	Orchid	Eco friendly stay	/uploads/banner_e7c6927d7d764968a646c8f680771536.jpg	t	2
4	Orchid	Zeebull Hospitality	/uploads/banner_2e535b55cf6a4d43b2a41d9ff9e478ff.jpg	t	2
5	Orchid	orchid	/uploads/banner_18a224dbff6047ac850fb57f0c9e5f38.jpg	t	2
6	Orchid Trails	Zeebull Hospitality	/uploads/banner_a9267b98b36a49d7a3b93f3bde6f0be3.jpg	t	2
7	Orchid	Zeebull Hospitality	/uploads/banner_0d6e3dbb70dc411a98b08a36798bf329.jpg	t	2
8	Orchid	Sky view 	/uploads/banner_d47e5b30a0bd4125804ae669e97a32c7.jpg	t	2
\.


--
-- Data for Name: inter_branch_transfers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inter_branch_transfers (id, transfer_number, item_id, quantity, source_branch_id, destination_branch_id, source_location_id, destination_location_id, status, notes, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_categories (id, name, description, parent_department, gst_tax_rate, classification, hsn_sac_code, default_gst_rate, cess_percentage, itc_eligibility, is_capital_good, is_perishable, is_asset_fixed, is_sellable, track_laundry, allow_partial_usage, consumable_instant, created_at, is_active, branch_id) FROM stdin;
\.


--
-- Data for Name: inventory_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_items (id, name, item_code, description, category_id, sub_category, hsn_code, unit, current_stock, min_stock_level, max_stock_level, unit_price, selling_price, gst_rate, location, barcode, image_path, is_perishable, track_serial_number, is_sellable_to_guest, track_laundry_cycle, is_asset_fixed, maintenance_schedule_days, complimentary_limit, ingredient_yield_percentage, preferred_vendor_id, vendor_item_code, lead_time_days, is_active, created_at, updated_at, branch_id) FROM stdin;
\.


--
-- Data for Name: inventory_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_transactions (id, item_id, transaction_type, quantity, unit_price, total_amount, reference_number, purchase_master_id, department, notes, created_by, source_location_id, destination_location_id, created_at, branch_id) FROM stdin;
\.


--
-- Data for Name: journal_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journal_entries (id, entry_number, entry_date, reference_type, reference_id, description, total_amount, created_by, notes, is_reversed, reversed_entry_id, created_at, updated_at, branch_id) FROM stdin;
\.


--
-- Data for Name: journal_entry_lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journal_entry_lines (id, entry_id, debit_ledger_id, credit_ledger_id, amount, description, line_number, created_at, branch_id) FROM stdin;
\.


--
-- Data for Name: laundry_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laundry_logs (id, item_id, source_location_id, room_number, quantity, status, sent_at, washed_at, returned_at, created_by, notes, branch_id) FROM stdin;
\.


--
-- Data for Name: leaves; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leaves (id, employee_id, from_date, to_date, reason, leave_type, status, branch_id) FROM stdin;
\.


--
-- Data for Name: location_stocks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_stocks (id, location_id, item_id, quantity, last_updated, branch_id) FROM stdin;
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, location_code, name, building, floor, room_area, location_type, parent_location_id, is_inventory_point, description, is_active, created_at, branch_id) FROM stdin;
1	LOC-RM-001	Room 001	Main Building	\N	Room 001	GUEST_ROOM	\N	f	Guest room 001 - Zeebull Cottage	t	2026-04-08 09:05:11.805194	2
2	LOC-RM-101	Room 101	Main Building	\N	Room 101	GUEST_ROOM	\N	f	Guest room 101 - Zeebull-Heritage	t	2026-04-08 09:06:01.541772	2
3	LOC-RM-201	Room 201	Main Building	\N	Room 201	GUEST_ROOM	\N	f	Guest room 201 - Zeebull - Standard Room	t	2026-04-08 09:06:33.548224	2
4	LOC-RM-301	Room 301	Main Building	\N	Room 301	GUEST_ROOM	\N	f	Guest room 301 - Zeebull-Club Room	t	2026-04-08 09:07:06.016591	2
5	LOC-RM-222	Room 222	Main Building	\N	Room 222	GUEST_ROOM	\N	f	Guest room 222 - DORMITORY FOR 10-15 GUESTS	t	2026-04-10 06:14:33.716477	1
6	LOC-RM-6	Room 101	Main Building	\N	Room 101	GUEST_ROOM	\N	f	Guest room 101 - Twin Oaks Sanctuary	t	2026-04-10 06:25:34.173558	1
7	LOC-WH-7	Main	Main		Main	WAREHOUSE	\N	t		t	2026-04-10 11:17:49.59874	2
8	LOC-LNDRY-8	laundry	laun	l	laia	LAUNDRY	\N	t		t	2026-04-10 11:18:03.947976	2
9	LOC-WH-9	MAin	main	asjklsaj	lkjslk	WAREHOUSE	\N	t		t	2026-04-10 11:21:07.221687	1
10	LOC-RM-501	Room 501	Main Building	\N	Room 501	GUEST_ROOM	\N	f	Guest room 501 - Zeebull-Club Room	t	2026-04-27 05:56:39.4711	2
11	LOC-RM-502	Room 502	Main Building	\N	Room 502	GUEST_ROOM	\N	f	Guest room 502 - Zeebull-Club Room	t	2026-04-27 06:05:40.344167	2
12	LOC-RM-503	Room 503	Main Building	\N	Room 503	GUEST_ROOM	\N	f	Guest room 503 - Zeebull-Club Room	t	2026-04-27 06:06:04.860523	2
13	LOC-RM-504	Room 504	Main Building	\N	Room 504	GUEST_ROOM	\N	f	Guest room 504 - Zeebull-Club Room	t	2026-04-27 06:06:27.69371	2
14	LOC-RM-505	Room 505	Main Building	\N	Room 505	GUEST_ROOM	\N	f	Guest room 505 - Zeebull-Club Room	t	2026-04-27 06:06:46.411288	2
15	LOC-RM-506	Room 506	Main Building	\N	Room 506	GUEST_ROOM	\N	f	Guest room 506 - Zeebull-Club Room	t	2026-04-27 06:17:42.350855	2
16	LOC-RM-507	Room 507	Main Building	\N	Room 507	GUEST_ROOM	\N	f	Guest room 507 - Zeebull-Club Room	t	2026-04-28 04:15:59.018111	2
17	LOC-RM-1000	Room 1000	Main Building	\N	Room 1000	GUEST_ROOM	\N	f	Guest room 1000 - test	t	2026-05-04 07:45:35.409783	2
18	LOC-RM-102	Room 102	Main Building	\N	Room 102	GUEST_ROOM	\N	f	Guest room 102 - Zeebull-Heritage room	t	2026-05-04 08:53:26.907223	1
19	LOC-RM-103	Room 103	Main Building	\N	Room 103	GUEST_ROOM	\N	f	Guest room 103 - Zeebull-Heritage room	t	2026-05-04 08:54:29.710288	1
20	LOC-RM-20	Room twin rooms	Main Building	\N	Room twin rooms	GUEST_ROOM	\N	f	Guest room twin rooms - Twin Oaks Sanctuary	t	2026-05-04 10:03:04.251773	2
28	LOC-RM-508	Room 508	Main Building	\N	Room 508	GUEST_ROOM	\N	f	Guest room 508 - Zeebull-Club Room	t	2026-05-07 11:05:50.996049	1
29	LOC-RM-22	Room 301	Main Building	\N	Room 301	GUEST_ROOM	\N	f	Guest room 301 - Zeebull Honeymoon Cottage	t	2026-05-07 12:11:25.041529	1
30	LOC-RM-302	Room 302	Main Building	\N	Room 302	GUEST_ROOM	\N	f	Guest room 302 - Zeebull Honeymoon Cottage	t	2026-05-07 12:11:50.396627	1
\.


--
-- Data for Name: nearby_attraction_banners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nearby_attraction_banners (id, title, subtitle, image_url, extra_images, is_active, map_link, branch_id) FROM stdin;
1	Nearby Atractions 	Zeebull Hospitality 	/uploads/nearby_banner_7e531165d0114467b3a31e2a1afc6616.webp	\N	t	\N	2
\.


--
-- Data for Name: nearby_attractions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nearby_attractions (id, title, description, image_url, extra_images, is_active, map_link, branch_id) FROM stdin;
1	Edakkal Caves	The Edakkal caves are two natural caves at a remote location in sultan bathery in the Wayanad district of Kerala in India. They lie 1,200 m above sea level on Ambukutty Mala, near an ancient trade route connecting the high mountains of Mysore to the ports of the Malabar Coast	/uploads/attraction_f02c17cbfd064af983a7ecbfb5d367a5.jpg	\N	t	https://www.google.com/maps?s=web&rlz=1C1GCEA_enIN1120IN1120&sca_esv=361b3c874f40828a&lqi=CiFuZWFyYnkgYXR0cmFjdGlvbiBtdXRoYWdhIG1hcCB1cmxI2OXWKlorEAEQAhADEAQiIW5lYXJieSBhdHRyYWN0aW9uIG11dGhhZ2EgbWFwIHVybJIBC3NjZW5pY19zcG90&phdesc=5hlPW_eZfzA&vet=12ahUKEwj99vz52N2TAxXXR2wGHf9rOqsQ1YkKegQIGxAB..i&cs=1&um=1&ie=UTF-8&fb=1&gl=in&sa=X&geocode=KeNwBcUiD6Y7Md_gqZN2KXHb&daddr=Nenmeni,+Kerala+673593	2
2	Kuruva Island	Kuruvadweep is a 950-acre (3.8 km2) protected river delta in the Indian state of Kerala. It comprises three densely wooded uninhabited islands and a few submergible satellite islands which lies on the banks of the tributaries of Kabini River in the Wayanad district of the state.It is uninhabited island, which is home to rare species of birds and insects like the Malabar trogon or the Disparoneura apicalis.	/uploads/attraction_7f686f8503974522ab61f1821e58c2e2.webp	\N	t	https://www.google.com/maps/dir/Sultan+Bathery/Kozhikode+Kerala/data=!4m2!4m1!3e0?ved=1t:153865&ictx=111	2
3	Bandipur National Park	Bandipur National Park, an 874-sq.-km forested reserve in the southern Indian state of Karnataka, is known for its small population of tigers. Once the private hunting ground of the Maharajas of Mysore, the park also harbors Indian elephants, spotted deer, gaurs (bison), antelopes and numerous other native species. The 14th-century Himavad Gopalaswamy Temple offers views from the park's highest peak.	/uploads/attraction_471149a35a78449f8d1102c59c96607a.jpeg	\N	t	https://www.google.com/maps?rlz=1C1GCEA_enIN1120IN1120&biw=1920&bih=945&sca_esv=361b3c874f40828a&sxsrf=ANbL-n42zQK3JwDFuhUzAv1RDNbsgKtZKA:1775632465381&um=1&ie=UTF-8&fb=1&gl=in&sa=X&geocode=KTs25t2oqqg7MXuTVc-7JAYS&daddr=Karnataka	2
\.


--
-- Data for Name: night_charges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.night_charges (id, day_audit_id, booking_id, branch_id, business_date, room_charge, gst_rate_pct, gst_amount, total_charge, is_reversed, reversed_at, reversal_reason, created_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, type, title, message, is_read, created_at, read_at, entity_type, entity_id, recipient_id, branch_id) FROM stdin;
\.


--
-- Data for Name: package_booking_rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.package_booking_rooms (id, package_booking_id, room_id, branch_id) FROM stdin;
\.


--
-- Data for Name: package_bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.package_bookings (id, display_id, package_id, user_id, guest_name, guest_email, guest_mobile, check_in, check_out, checked_in_at, checked_out_at, adults, children, id_card_image_url, guest_photo_url, num_rooms, status, total_amount, advance_deposit, created_at, branch_id, food_preferences, special_requests, is_confirmed, confirmed_at, confirmation_notes) FROM stdin;
\.


--
-- Data for Name: package_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.package_images (id, package_id, image_url) FROM stdin;
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.packages (id, title, description, price, booking_type, room_types, status, theme, default_adults, default_children, max_stay_days, food_included, food_timing, complimentary, created_at, branch_id) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, booking_id, amount, method, status, created_at, branch_id, package_booking_id) FROM stdin;
\.


--
-- Data for Name: plan_weddings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plan_weddings (id, title, description, image_url, extra_images, is_active, branch_id) FROM stdin;
1	Plan Your Private Party	Plan All type of private party with zeebull hospitality	/uploads/wedding_77c6c15679c54844a6dd040176f6c40e.jpg	\N	t	2
\.


--
-- Data for Name: pricing_calendar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pricing_calendar (id, start_date, end_date, day_type, description) FROM stdin;
8	2026-05-20	2026-05-30	HOLIDAY	
\.


--
-- Data for Name: purchase_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_details (id, purchase_master_id, item_id, hsn_code, quantity, unit, unit_price, gst_rate, cgst_amount, sgst_amount, igst_amount, discount, total_amount, notes) FROM stdin;
\.


--
-- Data for Name: purchase_masters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_masters (id, purchase_number, vendor_id, purchase_date, expected_delivery_date, invoice_number, invoice_date, bill_file_url, gst_number, payment_terms, payment_status, payment_method, sub_total, cgst, sgst, igst, discount, total_amount, notes, status, destination_location_id, created_by, created_at, updated_at, branch_id) FROM stdin;
\.


--
-- Data for Name: rate_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rate_plans (id, name, room_type_id, occupancy, meal_plan, channel_manager_id, base_price, weekend_price, price_offset, branch_id) FROM stdin;
645	single	3	1	CP	zeebull-club-room-s-cp	0	\N	0	1
646	double 	3	2	CP	zeebull-club-room-d-cp	0	\N	0	1
647	triple	3	3	CP	zeebull-club-room-t-cp	0	\N	4375	1
648		3	2	CP		0	\N	0	1
625	single	1	1	CP	zeebull-heritage-room-s-cp	0	\N	0	1
626	double	1	2	CP	zeebull-heritage-room-d-cp	0	\N	0	1
627	triple	1	3	CP	zeebull-heritage-room-t-cp	0	\N	3969	1
628	FOUR	1	4	CP	zeebull-heritage-room-q-cp	0	\N	5688	1
633	single	2	1	CP	zeebull-family-cottage-s-cp	0	\N	0	1
634	double	2	2	CP	zeebull-family-cottage-d-cp	0	\N	0	1
635	triple	2	3	CP	zeebull-family-cottage-t-cp	-1	\N	3656	1
636	quater	2	4	CP	zeebull-family-cottage-q-cp	0	\N	10844	1
\.


--
-- Data for Name: recipe_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipe_ingredients (id, recipe_id, inventory_item_id, quantity, unit, notes, created_at) FROM stdin;
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipes (id, food_item_id, name, description, servings, prep_time_minutes, cook_time_minutes, branch_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: resort_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resort_info (id, name, address, facebook, instagram, twitter, linkedin, is_active, branch_id) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (id, name, comment, rating, is_active, branch_id) FROM stdin;
1	Basil P Abraham 	Best for Family 	4	t	2
2	SHARUN	I recently stayed at this resort and had a wonderful experience. The rooms were spacious and well-maintained, the staff were polite, and the ambiance was relaxing. The property is beautifully landscaped, and the pool area is especially impressive. Overall, it’s a great place for a peaceful and comfortable getaway	5	t	1
3	Farheen Khan	I recently had the pleasure of spending two days at this resort, and overall, it was a refreshing and memorable experience.\n\nFrom the moment I arrived, the atmosphere felt calm and welcoming. The check-in process was smooth, and the staff were so polite, friendly and attentive.\n\nThe property itself is well-maintained, with clean surroundings and a layout that makes it easy to relax. The room was spacious, tidy, and comfortable, with all the basic amenities in place.\n\nThe breakfast was flavorful and offered in a good variety, catering to different tastes.\nThe dining area was also clean and had a pleasant ambiance.\n\nThe resort offers a decent range of activities to keep guests engaged. Whether you prefer simply relaxing by the pool or participating in recreational activities, there’s enough to make your stay enjoyable without feeling rushed.\n\nOverall, the two-day stay was relaxing and worth it. It’s a great place to take a break from routine, especially for a short getaway. I would definitely consider visiting again in the future.	5	t	1
4	Shuaib Khan	Orchid Trails is truly one of the best resorts in Wayanad! I’d happily give them a 5-star rating for their outstanding service and warm hospitality. Surrounded by nature, the place feels incredibly refreshing and peaceful.\nWhat makes it even more special is the staff—they treat you like family. Everyone is well-organized, disciplined, and highly professional, yet they make sure you never feel like just a guest.\nI highly recommend visiting this resort with your family or friends—you’ll definitely return with beautiful memories.\nMiss you all already! Thank you so much for your kindness and support during our stay. Wishing you continued success and many more milestones ahead!	5	t	1
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, permissions, branch_id) FROM stdin;
1	admin	["all"]	\N
2	guest	[]	\N
3	waiter 	["dashboard:view","bookings:view","bookings:create","bookings:edit","bookings:delete","rooms:view","rooms:create","rooms:edit","rooms:delete","services:view","services:create","services:edit","services:delete","services_dashboard:view","services_create:view","services_create:create","services_create:edit","services_create:delete","services_assign:view","services_assign:create","services_assign:edit","services_assign:delete","services_assigned:view","services_requests:view","services_requests:edit","services_report:view","food_orders:view","food_orders:create","food_orders:edit","food_orders:delete","food_orders_dashboard:view","food_orders_list:view","food_orders_list:create","food_orders_list:edit","food_orders_list:delete","food_orders_requests:view","food_orders_requests:edit","food_orders_management:view","food_orders_management:create","food_orders_management:edit","food_orders_management:delete","expenses:view","expenses:create","expenses:edit","expenses:delete","billing:view","billing:create","billing:edit","billing:delete","billing_checkout:view","billing_checkout:create","billing_history:view"]	\N
4	Manager	["dashboard:view","account:view","account:create","account:edit","account:delete","account_reports:view","account_chart:view","account_chart:create","account_chart:edit","account_chart:delete","account_journal:view","account_journal:create","account_journal:edit","account_journal:delete","account_trial:view","account_auto_report:view","account_comprehensive_report:view","account_gst_reports:view","bookings:view","bookings:create","bookings:edit","bookings:delete","rooms:view","rooms:create","rooms:edit","rooms:delete","services:view","services:create","services:edit","services:delete","services_dashboard:view","services_create:view","services_create:create","services_create:edit","services_create:delete","services_assign:view","services_assign:create","services_assign:edit","services_assign:delete","services_assigned:view","services_requests:view","services_requests:edit","services_report:view","food_orders:view","food_orders:create","food_orders:edit","food_orders:delete","food_orders_dashboard:view","food_orders_list:view","food_orders_list:create","food_orders_list:edit","food_orders_list:delete","food_orders_requests:view","food_orders_requests:edit","food_orders_management:view","food_orders_management:create","food_orders_management:edit","food_orders_management:delete","employee_management:view","employee_management:create","employee_management:edit","employee_management:delete","employee_overview:view","employee_directory:view","employee_directory:create","employee_directory:edit","employee_directory:delete","employee_attendance:view","employee_attendance:edit","employee_leave:view","employee_leave:create","employee_leave:edit","employee_reports:view","employee_status:view","employee_status:edit","employee_activity:view","roles:view","roles:create","roles:edit","roles:delete","expenses:view","expenses:create","expenses:edit","expenses:delete","food_inventory:view","food_inventory:create","food_inventory:edit","food_inventory:delete","food_categories:view","food_categories:create","food_categories:edit","food_categories:delete","food_items:view","food_items:create","food_items:edit","food_items:delete","billing:view","billing:create","billing:edit","billing:delete","billing_checkout:view","billing_checkout:create","billing_history:view","web_management:view","web_management:create","web_management:edit","web_management:delete","web_banners:view","web_banners:edit","web_gallery:view","web_gallery:edit","web_reviews:view","web_reviews:edit","web_resort_info:view","web_resort_info:edit","web_experiences:view","web_experiences:edit","web_weddings:view","web_weddings:edit","web_attractions:view","web_attractions:edit","web_attraction_banners:view","web_attraction_banners:edit","packages:view","packages:create","packages:edit","packages:delete","reports_global:view","guest_profiles:view","guest_profiles:create","guest_profiles:edit","guest_profiles:delete","inventory:view","inventory:create","inventory:edit","inventory:delete","inventory_items:view","inventory_items:create","inventory_items:edit","inventory_items:delete","inventory_categories:view","inventory_categories:create","inventory_categories:edit","inventory_categories:delete","inventory_vendors:view","inventory_vendors:create","inventory_vendors:edit","inventory_vendors:delete","inventory_purchases:view","inventory_purchases:create","inventory_purchases:edit","inventory_purchases:delete","inventory_transactions:view","inventory_requisitions:view","inventory_requisitions:create","inventory_requisitions:edit","inventory_issues:view","inventory_issues:create","inventory_waste:view","inventory_waste:create","inventory_waste:delete","inventory_locations:view","inventory_locations:create","inventory_locations:edit","inventory_locations:delete","inventory_assets:view","inventory_assets:create","inventory_assets:edit","inventory_assets:delete","inventory_location_stock:view","inventory_recipe:view","inventory_recipe:create","inventory_recipe:edit","inventory_recipe:delete","inventory_laundry:view","inventory_laundry:create","inventory_laundry:edit","inventory_laundry:delete","inventory_transfer:view","inventory_transfer:create","inventory_transfer:edit","inventory_transfer:delete","settings_group:view","settings_group:create","settings_group:edit","settings_group:delete","settings_system:view","settings_system:edit","settings_legal:view","settings_legal:edit"]	\N
5	kitchen	["food_orders:view","food_orders:create","food_orders:edit","food_orders:delete","food_orders_dashboard:view","food_orders_list:view","food_orders_list:create","food_orders_list:edit","food_orders_list:delete","food_orders_requests:view","food_orders_requests:edit","food_orders_management:view","food_orders_management:create","food_orders_management:edit","food_orders_management:delete"]	\N
6	operation manager	["bookings:view","bookings:create","bookings:edit","bookings:delete","rooms:view","rooms:create","rooms:edit","rooms:delete","services:view","services:create","services:edit","services:delete","services_dashboard:view","services_create:view","services_create:create","services_create:edit","services_create:delete","services_assign:view","services_assign:create","services_assign:edit","services_assign:delete","services_assigned:view","services_requests:view","services_requests:edit","services_report:view","food_orders:view","food_orders:create","food_orders:edit","food_orders:delete","food_orders_dashboard:view","food_orders_list:view","food_orders_list:create","food_orders_list:edit","food_orders_list:delete","food_orders_requests:view","food_orders_requests:edit","food_orders_management:view","food_orders_management:create","food_orders_management:edit","food_orders_management:delete","employee_leave:view","employee_leave:create","employee_leave:edit","employee_attendance:view","employee_attendance:edit","employee_status:view","employee_status:edit","employee_activity:view","expenses:view","expenses:create","expenses:edit","expenses:delete","food_inventory:view","food_inventory:create","food_inventory:edit","food_inventory:delete","food_categories:view","food_categories:create","food_categories:edit","food_categories:delete","food_items:view","food_items:create","food_items:edit","food_items:delete","billing:view","billing:create","billing:edit","billing:delete","billing_checkout:view","billing_checkout:create","billing_history:view","packages:view","packages:create","packages:edit","packages:delete","guest_profiles:view","guest_profiles:create","guest_profiles:edit","guest_profiles:delete","settings_system:view","settings_system:edit","settings_legal:view","settings_legal:edit"]	\N
\.


--
-- Data for Name: room_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.room_types (id, name, total_inventory, base_price, weekend_price, long_weekend_price, holiday_price, adults_capacity, children_capacity, channel_manager_id, branch_id, air_conditioning, wifi, bathroom, image_url, extra_images, living_area, terrace, parking, kitchen, family_room, bbq, garden, dining, breakfast, tv, balcony, mountain_view, ocean_view, private_pool, hot_tub, fireplace, pet_friendly, wheelchair_accessible, safe_box, room_service, laundry_service, gym_access, spa_access, housekeeping, mini_bar, online_inventory) FROM stdin;
4	Zeebull - Standard Room	1	3000	\N	\N	\N	2	0	\N	1	f	t	f	/uploads/rooms/roomtype_d14a6e81755242f38a63f1e5a4cfe3bc.jpeg	["/uploads/rooms/roomtype_2c2fe54559b44555ab842a51b86ce92a.jpeg", "/uploads/rooms/roomtype_e19c7ae0f4a7424eafd9bd21f906a38f.jpeg", "/uploads/rooms/roomtype_e2d25431c00c4e2f9c2e41d63c504b87.jpeg", "/uploads/rooms/roomtype_720027e89e8340e38c112be49cad0227.jpeg", "/uploads/rooms/roomtype_a2ae889a49884dc0a76178f86ad5f59a.jpeg", "/uploads/rooms/roomtype_8bf4c5fea72940ceafe9531c51754cd6.jpeg", "/uploads/rooms/roomtype_b51a670533ff408191eac059b249d4ad.jpeg"]	f	f	f	f	f	f	f	t	t	t	f	f	f	f	f	f	f	f	t	t	t	f	f	t	f	\N
9	Dormitory 	1	6300	7000	7000	7000	9	5	\N	2	f	t	t	\N	\N	f	f	f	f	t	t	t	t	t	f	f	t	f	f	f	f	t	f	f	t	f	f	f	t	f	\N
8	Twin Oaks Sanctuary	0	6500	7000	7000	7500	4	2	\N	2	f	t	t	/uploads/rooms/roomtype_3f817674f163456cb90dda6e6d085afc.jpeg	["/uploads/rooms/roomtype_73405dd80d5c4d06aa86092861781dfd.jpeg", "/uploads/rooms/roomtype_21c1e6959fe443139f128505a5f32973.jpeg", "/uploads/rooms/roomtype_30ba3c36ad9041f8ac75e3f3465bc61a.jpeg"]	t	t	t	t	t	t	t	t	t	t	t	t	f	f	f	f	t	f	f	t	f	f	f	t	f	\N
3	Zeebull-Club Room	8	5000	5500	5500	5500	4	2	zeebull-club-room	1	t	t	t	/uploads/rooms/roomtype_5dc7b981d16e4fcdafdafee2f2349931.jpeg	["/uploads/rooms/roomtype_44192a1f451c46f8be9aa91be3c91efa.jpeg", "/uploads/rooms/roomtype_bafba59722ac41cb9ea0e384f675c652.jpeg", "/uploads/rooms/roomtype_e5b7b7f0357249b0a051e9ddbaaea4e9.jpeg", "/uploads/rooms/roomtype_8291f506338646b7964c59446794832f.jpeg", "/uploads/rooms/roomtype_a6fe66592b6f4b41a9293fbf6dc861f7.jpeg", "/uploads/rooms/roomtype_9eb65498e1ef49a5b1c05935744bf85b.jpeg", "/uploads/rooms/roomtype_ec8d506808ff4adab891b94792f3a923.jpeg", "/uploads/rooms/roomtype_3cdca6f3a26848b195c19744c204c942.jpeg"]	f	t	t	f	t	t	t	f	t	t	t	f	f	f	f	f	t	f	f	t	t	f	f	t	f	2
2	Zeebull Honeymoon Cottage	2	6500	7000	7000	7000	2	2	zeebull-family-cottage	1	t	t	t	/uploads/rooms/roomtype_6582210e020b455fa73027967a23185a.jpeg	["/uploads/rooms/roomtype_0a6229dd4fa04f6e8c381a94575e2dbc.jpeg", "/uploads/rooms/roomtype_c9ac1e7711a544e6bb3498b075178467.jpeg", "/uploads/rooms/roomtype_f1ac8e5142ee4ceeba65e8f569fc1d6b.jpeg", "/uploads/rooms/roomtype_b1b5b459a609411d86cf1cfc3a1aec2a.jpeg", "/uploads/rooms/roomtype_0890cc7fdb56440eb19dbb5547a9b524.jpeg", "/uploads/rooms/roomtype_08ecd98f6bbb46e398d6eaf463ab74f7.jpeg", "/uploads/rooms/roomtype_2502da25ba2e4af09277fea558afa850.jpeg", "/uploads/rooms/roomtype_b8dbe72bcc534eababac4d34faea2877.jpeg", "/uploads/rooms/roomtype_9219f1b9741b455cadebf89e5385ca86.jpeg", "/uploads/rooms/roomtype_9aa58e02dcc64d1894f8217b9dc54008.jpeg", "/uploads/rooms/roomtype_24d6430b75ca4f408e1e3201c182749f.jpeg", "/uploads/rooms/roomtype_ef379b47f1074e2aa809a1fc101bc684.jpeg", "/uploads/rooms/roomtype_6a292108236e47928280d7452b48f446.jpeg", "/uploads/rooms/roomtype_5f14e50a9448423a84750867f7d42a9e.jpeg", "/uploads/rooms/roomtype_7e4d489b840b4360adbdc2885dcdf833.jpeg"]	t	t	t	f	t	t	t	t	t	t	t	f	f	f	f	f	t	f	f	t	t	f	f	t	f	2
1	Zeebull-Heritage room	2	4000	4000	4000	4000	2	0	zeebull-heritage-room	1	f	t	f	/uploads/rooms/roomtype_46bbeb54031849bbaf023d098390dd5d.jpeg	["/uploads/rooms/roomtype_0aeb3e348a0d4238b91129680f8b29c7.jpeg", "/uploads/rooms/roomtype_31467983196a47b68307136d24316025.jpeg", "/uploads/rooms/roomtype_abab8cb472bb493d95340ba4842e8d57.jpeg", "/uploads/rooms/roomtype_5c51865b30a647c1805d5e9c3be54c04.jpeg", "/uploads/rooms/roomtype_ddd0eae5e6604a27b8fbb7656053a7eb.jpeg", "/uploads/rooms/roomtype_84b2596dfd89436aa8192461ed0aefec.jpeg", "/uploads/rooms/roomtype_b5fa57162bdb4a7d89b8f46bce964af0.jpeg", "/uploads/rooms/roomtype_1aa1224286944cc5b7d8fdd22f42dc7a.jpeg", "/uploads/rooms/roomtype_c1779b5779c041529b5df4536bc51553.jpeg", "/uploads/rooms/roomtype_78816661df4b425097e5f061bf96a5e0.jpeg", "/uploads/rooms/roomtype_4603a516a7db43cfbe8c3ca1ce951ade.jpeg"]	f	f	t	f	f	f	f	f	t	f	f	f	f	f	f	f	f	t	f	f	f	f	f	f	f	0
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (id, number, room_type_id, status, housekeeping_status, housekeeping_updated_at, last_maintenance_date, image_url, extra_images, inventory_location_id, branch_id) FROM stdin;
3	201	4	Available	Clean	\N	\N	/uploads/rooms/room_f669a67e36124d9489909f469f0584ed.jpeg	["/uploads/rooms/room_06363905819c4ac4a611e54d2fb89964.jpeg", "/uploads/rooms/room_3976f2c23edd4c33bdae8f4c87819b6a.jpeg", "/uploads/rooms/room_54cbb9c77f7d47f99357c00072fde237.jpeg", "/uploads/rooms/room_30800cdebad44228a4530b4012a1d03a.jpeg", "/uploads/rooms/room_64722a73bfd14d8f9b14fb1e467e2e72.jpeg"]	3	1
16	103	1	Available	Clean	\N	\N	/uploads/rooms/room_abedbc39c46d4e07ba7b22f6dc2e53dc.jpeg	["/uploads/rooms/room_9059a2460e8645d19c4b79985a2e9ae6.jpeg", "/uploads/rooms/room_cb0d99a3a98248098314bdb9996edf3e.jpeg", "/uploads/rooms/room_856b80bdf2c740c5af43bf03d4a56869.jpeg", "/uploads/rooms/room_5cf8e22601aa47ceb86d8f467f414df4.jpeg"]	19	1
17	twin rooms	8	Available	Clean	\N	\N	\N	\N	20	2
7	501	3	Available	Clean	\N	\N	\N	\N	10	1
8	502	3	Available	Clean	\N	\N	\N	\N	11	1
9	503	3	Available	Clean	\N	\N	\N	\N	12	1
10	504	3	Available	Clean	\N	\N	\N	\N	13	1
11	505	3	Available	Clean	\N	\N	\N	\N	14	1
12	506	3	Available	Clean	\N	\N	\N	\N	15	1
13	507	3	Available	Clean	\N	\N	\N	\N	16	1
15	102	1	Available	Clean	\N	\N	/uploads/rooms/room_514b7fd9f39649d784c83603068d8dca.jpeg	["/uploads/rooms/room_1c6f78547c8043e28992a5276f91050e.jpeg", "/uploads/rooms/room_5a9366115a944a42a42f0d203caf6737.jpeg", "/uploads/rooms/room_489353cb2b924a188ca4d8de4f87d237.jpeg", "/uploads/rooms/room_3a72ad044e7a4ac99207390838148fa4.jpeg", "/uploads/rooms/room_99b66765b1b94b3486a0be038e237458.jpeg"]	18	1
26	508	3	Checked-in	Clean	\N	\N	\N	\N	28	1
27	301	2	Available	Clean	\N	\N	\N	\N	29	1
28	302	2	Available	Clean	\N	\N	/uploads/rooms/room_61a4a5a417974110af0deb6975166112.jpeg	["/uploads/rooms/room_162e84671bf9429397736d5d9ce3f2f9.jpeg"]	30	1
\.


--
-- Data for Name: salary_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salary_payments (id, employee_id, month, year, month_number, basic_salary, allowances, deductions, net_salary, payment_date, payment_method, payment_status, created_at, notes, branch_id) FROM stdin;
\.


--
-- Data for Name: service_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_images (id, service_id, image_url) FROM stdin;
\.


--
-- Data for Name: service_inventory_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_inventory_items (service_id, inventory_item_id, quantity, created_at) FROM stdin;
\.


--
-- Data for Name: service_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_requests (id, food_order_id, room_id, employee_id, request_type, description, status, billing_status, refill_data, image_path, created_at, branch_id, started_at, completed_at, pickup_location_id) FROM stdin;
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, name, description, charges, gst_rate, is_visible_to_guest, average_completion_time, branch_id, created_at) FROM stdin;
\.


--
-- Data for Name: signature_experiences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.signature_experiences (id, title, description, image_url, extra_images, is_active, branch_id) FROM stdin;
3	Feel The Nature	At our resort, we invite you to lose track of time. Whether you are watching the sun dip behind the coconut groves or feeling the cool water at your feet, every moment is a return to a simpler, more grounded way of life.	/uploads/sigexp_4f98d0e0a00949b6bbf4b309fea207af.jpeg	\N	t	\N
4	Swimming Pool 	Swimming Pool 	/uploads/sigexp_22694c20d99a4e8697c55bc83d48ff4a.jpeg	\N	t	\N
\.


--
-- Data for Name: stock_issue_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_issue_details (id, issue_id, item_id, issued_quantity, batch_lot_number, unit, unit_price, cost, notes, is_payable, is_paid, rental_price, is_damaged, damage_notes) FROM stdin;
\.


--
-- Data for Name: stock_issues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_issues (id, issue_number, requisition_id, issued_by, source_location_id, destination_location_id, issue_date, notes, booking_id, guest_id, created_at, branch_id) FROM stdin;
\.


--
-- Data for Name: stock_requisition_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_requisition_details (id, requisition_id, item_id, requested_quantity, approved_quantity, unit, notes) FROM stdin;
\.


--
-- Data for Name: stock_requisitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_requisitions (id, requisition_number, requested_by, destination_department, date_needed, priority, status, notes, approved_by, approved_at, created_at, updated_at, branch_id) FROM stdin;
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, key, value, description, updated_at, branch_id) FROM stdin;
1	resort_name	Zeebull Hospitality	\N	2026-04-08 05:07:33.6273+00	\N
2	resort_address	Authorized Client Location	\N	2026-04-08 05:07:33.6273+00	\N
3	currency	INR	\N	2026-04-08 05:07:33.6273+00	\N
4	tax_rate	18	\N	2026-04-08 05:07:33.6273+00	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, hashed_password, phone, is_active, role_id, branch_id, is_superadmin) FROM stdin;
1	Zeebull Administrator	admin@orchid.com	$2b$12$wIA4MdIMv3EjL0nYhKC9n./r5b10jba2TFJaruHeBOrSIqDebPNzS	\N	t	1	\N	t
2	bgb	anan@gmail.com	$2b$12$cI/3RJ9U65CDL6ALO0P8c.5Ae8YruwSEpq4a.FmncYbHrMXAxQtqq	8527522532	t	2	1	f
4	basil	basil@gmail.com	$2b$12$rHzOwibhGvsKZKhxQHmN3e4CGdxJautcsidUF2ONmGZfSocbs.5yu	546789	t	4	2	f
5	alphi	alphi@gmail.com	$2b$12$nLORyFVHgbT.eWRbrHaSpeZnmJVabJDY5xJ9J61pJ6xn9v4vIsUy2	56378291y71	t	3	2	f
6	appu	appu@gmail.com	$2b$12$/abfCBbWxeBb87sEHUdcoOovqioyZnB8wZXh9FiMfSeX48ELhaxFm	234567890	t	5	2	f
7	sasaas	guest_aadds@temp.com	$2b$12$sPxKepxX73QVW/s/pm52weWujcCWeIborsUqhRNUC.HP5EQLiuPKG	aadds	t	2	2	f
3	daion	daion@gmail.com	$2b$12$NMN2fshUF9wlmnZRdhLaFOd3xumLEbwMNzays1DeXlxGuCo.0LUgO	9961239861	t	2	2	f
8	alphi	ahghdg@gmail.com	$2b$12$bfx5T/ZSucObNN.tPBjoq.VIYQlcCdPF5ZCA0xFPwBwQvAPtE9ClO	8888888888	t	2	\N	f
9	Varsha	varshavshroff@gmail.com	$2b$12$7efmj4YXP4j1Kyx1Zjtssej1z7sPNTntH0O8ha7WloOAWNgi.wwaG	7044841420	t	2	2	f
10	Akshay Kumar	akshaykumar@gmail.com	$2b$12$WOKahKG9B8gMYXQY92bJjeRyeUyr2StGKz3LvgR9g5W7nc46qg0om	9988776655	t	2	1	f
11	Dharshan	guest_959595956@temp.com	$2b$12$lZan1reBZwdc4hXWpo1qou7iROcA7mSF3LoWVxaTxxq20UpC4Zm4e	959595956	t	2	1	f
13	Aruljothi Devaraju	adevar.855942@guest.booking.com	$2b$12$v7JgE1iwylwz6hXv1TjgwuNjjxFyLIA2WW3EEGjA1yKA3N4AF098i	+91 97400 57488	t	2	1	f
14	Kanhaiya	kkanhaiya.kk@gmail.com	$2b$12$IVRgYf1PTQvrZNq4UXV4yun9NoSkv9c07QDXaxJkPfgLadAuUqET.	8010637510	t	2	2	f
15	Raghavendra MB	mb.raghavendra2017@outlook.com	$2b$12$LUVrvlw0lY2mbKhZCSmZaOCjX1R3F9NjeOXVTEQp1PCqdWeJjvP4K	8861779219	t	2	1	f
16	Satya Sagar K	satyaksagar@gmail.com	$2b$12$z6NsG.wfwiT.EAgCmOxcQe3Lo2H7ZfMBV3E6eG99yNrJv1RZU8.Oa	9739122427	t	2	2	f
17	Naveen Prabhakaran	naveen.prabhakaran89@gmail.com	$2b$12$XrzvDcj5Agm4WcbcIkoXJertlxlBADMDc3ERDUKJgGh36.e.RqApK	9902381316	t	2	2	f
12	Suthan M	ba.616760@guest.booking.com	$2b$12$eb5bFvmC6IR4Kcxhz2hdGONt93AtMcRUkDWkprLM5.eIRB2PMUfJC	+91 97919 56810	t	2	1	f
18	Vishnu	guest_8891292321@temp.com	$2b$12$wygwdcZqegAJ780YJ9/dk.ncTHap2HnOFQ51DV.fkZyGXbN6LXTuG	8891292321	t	2	1	f
19	Aruljothi	guest_9740057488@temp.com	$2b$12$uXI4MwziEaE47RgjQcsrPeHF.ZE0O3zHrI5q/pNH.Q1OPNiAZSYRO	9740057488	t	2	1	f
20	daion	mathe@gmsa.com	$2b$12$ZYM0xjnYmD3A4H2sNqTo5ucW35pK2.cCnsUS7hjYEbm26IbPq8rg6	9989987262	t	2	1	f
21	bas	daion499@gmail.com	$2b$12$Q23apxorNGUhnMk5mXaGF.iYRbWVJ/dKgW5/owlCyw3LDGd6D4CPi	8866663711	t	2	1	f
22	sanith ps	sanithsanu.ss@gmail.com	$2b$12$tAxjTLS43XVrl8VaJmsiaO33nXvi09uSbaPTb/rFxLaWAjJAYsm4O	9567015996	t	6	2	f
23	Sajith	orchidresort@gmail.com	$2b$12$TLDBUE9ohIq8DF.OKBLfmO1aDkRLG88bBB10XFAcApik/4umJwgjS	9880075277	t	2	2	f
24	Vasundhara Hegde	vhegde.343744@guest.booking.com	$2b$12$0wR2x1J97BzHVTur2cxD8uqVQ8k3FSKrmP4i08PDwsYWMs6p8rnU6	+91 78298 46204	t	2	1	f
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendors (id, name, company_name, gst_registration_type, gst_number, branch_id, legal_name, trade_name, pan_number, qmp_scheme, msme_udyam_no, contact_person, email, phone, billing_address, billing_state, shipping_address, distance_km, address, city, state, pincode, country, is_msme_registered, tds_apply, rcm_applicable, payment_terms, preferred_payment_method, account_holder_name, bank_name, account_number, ifsc_code, branch_name, upi_id, upi_mobile_number, notes, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vouchers (id, code, discount_percent, expiry_date, branch_id) FROM stdin;
\.


--
-- Data for Name: waste_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waste_logs (id, log_number, item_id, food_item_id, is_food_item, location_id, batch_number, expiry_date, quantity, unit, reason_code, action_taken, photo_path, notes, reported_by, waste_date, created_at, branch_id) FROM stdin;
\.


--
-- Data for Name: working_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.working_logs (id, employee_id, date, check_in_time, check_out_time, location, latitude, longitude, completed_tasks, is_tasks_approved, tasks_approved_by_id, tasks_approved_at, branch_id, clock_in_image, clock_out_image) FROM stdin;
\.


--
-- Name: account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_groups_id_seq', 17, true);


--
-- Name: account_ledgers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_ledgers_id_seq', 41, true);


--
-- Name: activity_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_logs_id_seq', 21107, true);


--
-- Name: asset_mappings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_mappings_id_seq', 1, false);


--
-- Name: asset_registry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_registry_id_seq', 1, false);


--
-- Name: assigned_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assigned_services_id_seq', 1, true);


--
-- Name: attendances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendances_id_seq', 1, false);


--
-- Name: booking_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.booking_rooms_id_seq', 5, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_id_seq', 47, true);


--
-- Name: branches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branches_id_seq', 2, true);


--
-- Name: check_availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.check_availability_id_seq', 1, false);


--
-- Name: checkout_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.checkout_payments_id_seq', 1, true);


--
-- Name: checkout_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.checkout_requests_id_seq', 2, true);


--
-- Name: checkout_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.checkout_verifications_id_seq', 1, false);


--
-- Name: checkouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.checkouts_id_seq', 1, true);


--
-- Name: day_audits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.day_audits_id_seq', 1, false);


--
-- Name: employee_inventory_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_inventory_assignments_id_seq', 1, false);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_id_seq', 4, true);


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expenses_id_seq', 1, false);


--
-- Name: food_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_categories_id_seq', 1, true);


--
-- Name: food_item_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_item_images_id_seq', 2, true);


--
-- Name: food_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_items_id_seq', 1, true);


--
-- Name: food_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_order_items_id_seq', 1, true);


--
-- Name: food_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_orders_id_seq', 1, true);


--
-- Name: gallery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gallery_id_seq', 5, true);


--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.guest_suggestions_id_seq', 1, false);


--
-- Name: header_banner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.header_banner_id_seq', 8, true);


--
-- Name: inter_branch_transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inter_branch_transfers_id_seq', 1, true);


--
-- Name: inventory_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_categories_id_seq', 4, true);


--
-- Name: inventory_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_items_id_seq', 6, true);


--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_transactions_id_seq', 4, true);


--
-- Name: journal_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.journal_entries_id_seq', 1, false);


--
-- Name: journal_entry_lines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.journal_entry_lines_id_seq', 1, false);


--
-- Name: laundry_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.laundry_logs_id_seq', 1, false);


--
-- Name: leaves_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leaves_id_seq', 1, false);


--
-- Name: location_stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.location_stocks_id_seq', 2, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locations_id_seq', 30, true);


--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nearby_attraction_banners_id_seq', 1, true);


--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nearby_attractions_id_seq', 3, true);


--
-- Name: night_charges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.night_charges_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 10, true);


--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.package_booking_rooms_id_seq', 1, false);


--
-- Name: package_bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.package_bookings_id_seq', 1, false);


--
-- Name: package_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.package_images_id_seq', 16, true);


--
-- Name: packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.packages_id_seq', 1, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Name: plan_weddings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plan_weddings_id_seq', 1, true);


--
-- Name: pricing_calendar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pricing_calendar_id_seq', 9, true);


--
-- Name: purchase_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_details_id_seq', 1, false);


--
-- Name: purchase_masters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_masters_id_seq', 1, false);


--
-- Name: rate_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rate_plans_id_seq', 648, true);


--
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipe_ingredients_id_seq', 2, true);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_id_seq', 1, true);


--
-- Name: resort_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resort_info_id_seq', 1, false);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 4, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 6, true);


--
-- Name: room_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.room_types_id_seq', 9, true);


--
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_id_seq', 28, true);


--
-- Name: salary_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salary_payments_id_seq', 1, false);


--
-- Name: service_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_images_id_seq', 6, true);


--
-- Name: service_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_requests_id_seq', 3, true);


--
-- Name: services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_id_seq', 5, true);


--
-- Name: signature_experiences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.signature_experiences_id_seq', 4, true);


--
-- Name: stock_issue_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_issue_details_id_seq', 1, true);


--
-- Name: stock_issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_issues_id_seq', 1, true);


--
-- Name: stock_requisition_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_requisition_details_id_seq', 1, false);


--
-- Name: stock_requisitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_requisitions_id_seq', 1, false);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 24, true);


--
-- Name: vendors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vendors_id_seq', 2, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vouchers_id_seq', 1, false);


--
-- Name: waste_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.waste_logs_id_seq', 1, false);


--
-- Name: working_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.working_logs_id_seq', 2, true);


--
-- Name: account_groups account_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_groups
    ADD CONSTRAINT account_groups_pkey PRIMARY KEY (id);


--
-- Name: account_ledgers account_ledgers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_ledgers
    ADD CONSTRAINT account_ledgers_pkey PRIMARY KEY (id);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: asset_mappings asset_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_pkey PRIMARY KEY (id);


--
-- Name: asset_registry asset_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_pkey PRIMARY KEY (id);


--
-- Name: assigned_services assigned_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_pkey PRIMARY KEY (id);


--
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: booking_rooms booking_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: check_availability check_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_availability
    ADD CONSTRAINT check_availability_pkey PRIMARY KEY (id);


--
-- Name: checkout_payments checkout_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_payments
    ADD CONSTRAINT checkout_payments_pkey PRIMARY KEY (id);


--
-- Name: checkout_requests checkout_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_pkey PRIMARY KEY (id);


--
-- Name: checkout_verifications checkout_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_verifications
    ADD CONSTRAINT checkout_verifications_pkey PRIMARY KEY (id);


--
-- Name: checkouts checkouts_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_booking_id_key UNIQUE (booking_id);


--
-- Name: checkouts checkouts_package_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_package_booking_id_key UNIQUE (package_booking_id);


--
-- Name: checkouts checkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_pkey PRIMARY KEY (id);


--
-- Name: day_audits day_audits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_audits
    ADD CONSTRAINT day_audits_pkey PRIMARY KEY (id);


--
-- Name: employee_inventory_assignments employee_inventory_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: employees employees_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_key UNIQUE (user_id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: food_categories food_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_categories
    ADD CONSTRAINT food_categories_pkey PRIMARY KEY (id);


--
-- Name: food_item_images food_item_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_item_images
    ADD CONSTRAINT food_item_images_pkey PRIMARY KEY (id);


--
-- Name: food_items food_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_items
    ADD CONSTRAINT food_items_pkey PRIMARY KEY (id);


--
-- Name: food_order_items food_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_pkey PRIMARY KEY (id);


--
-- Name: food_orders food_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_pkey PRIMARY KEY (id);


--
-- Name: gallery gallery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery
    ADD CONSTRAINT gallery_pkey PRIMARY KEY (id);


--
-- Name: guest_suggestions guest_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_suggestions
    ADD CONSTRAINT guest_suggestions_pkey PRIMARY KEY (id);


--
-- Name: header_banner header_banner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.header_banner
    ADD CONSTRAINT header_banner_pkey PRIMARY KEY (id);


--
-- Name: inter_branch_transfers inter_branch_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inter_branch_transfers
    ADD CONSTRAINT inter_branch_transfers_pkey PRIMARY KEY (id);


--
-- Name: inventory_categories inventory_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_categories
    ADD CONSTRAINT inventory_categories_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- Name: inventory_transactions inventory_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_pkey PRIMARY KEY (id);


--
-- Name: journal_entries journal_entries_entry_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_entry_number_key UNIQUE (entry_number);


--
-- Name: journal_entries journal_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_pkey PRIMARY KEY (id);


--
-- Name: journal_entry_lines journal_entry_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_pkey PRIMARY KEY (id);


--
-- Name: laundry_logs laundry_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_pkey PRIMARY KEY (id);


--
-- Name: leaves leaves_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_pkey PRIMARY KEY (id);


--
-- Name: location_stocks location_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_stocks
    ADD CONSTRAINT location_stocks_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: nearby_attraction_banners nearby_attraction_banners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nearby_attraction_banners
    ADD CONSTRAINT nearby_attraction_banners_pkey PRIMARY KEY (id);


--
-- Name: nearby_attractions nearby_attractions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nearby_attractions
    ADD CONSTRAINT nearby_attractions_pkey PRIMARY KEY (id);


--
-- Name: night_charges night_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.night_charges
    ADD CONSTRAINT night_charges_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: package_booking_rooms package_booking_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_pkey PRIMARY KEY (id);


--
-- Name: package_bookings package_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_pkey PRIMARY KEY (id);


--
-- Name: package_images package_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_images
    ADD CONSTRAINT package_images_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: plan_weddings plan_weddings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_weddings
    ADD CONSTRAINT plan_weddings_pkey PRIMARY KEY (id);


--
-- Name: pricing_calendar pricing_calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing_calendar
    ADD CONSTRAINT pricing_calendar_pkey PRIMARY KEY (id);


--
-- Name: purchase_details purchase_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT purchase_details_pkey PRIMARY KEY (id);


--
-- Name: purchase_masters purchase_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_masters
    ADD CONSTRAINT purchase_masters_pkey PRIMARY KEY (id);


--
-- Name: rate_plans rate_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate_plans
    ADD CONSTRAINT rate_plans_pkey PRIMARY KEY (id);


--
-- Name: recipe_ingredients recipe_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: resort_info resort_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resort_info
    ADD CONSTRAINT resort_info_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: room_types room_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_types
    ADD CONSTRAINT room_types_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: salary_payments salary_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_payments
    ADD CONSTRAINT salary_payments_pkey PRIMARY KEY (id);


--
-- Name: service_images service_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_images
    ADD CONSTRAINT service_images_pkey PRIMARY KEY (id);


--
-- Name: service_inventory_items service_inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_inventory_items
    ADD CONSTRAINT service_inventory_items_pkey PRIMARY KEY (service_id, inventory_item_id);


--
-- Name: service_requests service_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: signature_experiences signature_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signature_experiences
    ADD CONSTRAINT signature_experiences_pkey PRIMARY KEY (id);


--
-- Name: stock_issue_details stock_issue_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issue_details
    ADD CONSTRAINT stock_issue_details_pkey PRIMARY KEY (id);


--
-- Name: stock_issues stock_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_pkey PRIMARY KEY (id);


--
-- Name: stock_requisition_details stock_requisition_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisition_details
    ADD CONSTRAINT stock_requisition_details_pkey PRIMARY KEY (id);


--
-- Name: stock_requisitions stock_requisitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisitions
    ADD CONSTRAINT stock_requisitions_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: day_audits uix_day_audit_branch_date; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_audits
    ADD CONSTRAINT uix_day_audit_branch_date UNIQUE (branch_id, business_date);


--
-- Name: food_categories uix_food_category_name_branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_categories
    ADD CONSTRAINT uix_food_category_name_branch UNIQUE (name, branch_id);


--
-- Name: food_items uix_food_item_name_branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_items
    ADD CONSTRAINT uix_food_item_name_branch UNIQUE (name, branch_id);


--
-- Name: inventory_categories uix_inventory_category_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_categories
    ADD CONSTRAINT uix_inventory_category_name UNIQUE (name);


--
-- Name: inventory_items uix_inventory_item_barcode; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT uix_inventory_item_barcode UNIQUE (barcode);


--
-- Name: inventory_items uix_inventory_item_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT uix_inventory_item_code UNIQUE (item_code);


--
-- Name: inventory_items uix_inventory_item_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT uix_inventory_item_name UNIQUE (name);


--
-- Name: recipes uix_recipe_name_branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT uix_recipe_name_branch UNIQUE (name, branch_id);


--
-- Name: rooms uix_room_number_branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT uix_room_number_branch UNIQUE (number, branch_id);


--
-- Name: system_settings uix_setting_key_branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT uix_setting_key_branch UNIQUE (key, branch_id);


--
-- Name: vendors uix_vendor_gst_branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT uix_vendor_gst_branch UNIQUE (gst_number, branch_id);


--
-- Name: vendors uix_vendor_name_branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT uix_vendor_name_branch UNIQUE (name, branch_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_code_key UNIQUE (code);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (id);


--
-- Name: waste_logs waste_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_pkey PRIMARY KEY (id);


--
-- Name: working_logs working_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.working_logs
    ADD CONSTRAINT working_logs_pkey PRIMARY KEY (id);


--
-- Name: ix_account_groups_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_account_groups_branch_id ON public.account_groups USING btree (branch_id);


--
-- Name: ix_account_groups_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_account_groups_id ON public.account_groups USING btree (id);


--
-- Name: ix_account_ledgers_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_account_ledgers_branch_id ON public.account_ledgers USING btree (branch_id);


--
-- Name: ix_account_ledgers_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_account_ledgers_id ON public.account_ledgers USING btree (id);


--
-- Name: ix_activity_logs_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_activity_logs_action ON public.activity_logs USING btree (action);


--
-- Name: ix_activity_logs_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_activity_logs_branch_id ON public.activity_logs USING btree (branch_id);


--
-- Name: ix_activity_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_activity_logs_id ON public.activity_logs USING btree (id);


--
-- Name: ix_asset_mappings_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_asset_mappings_branch_id ON public.asset_mappings USING btree (branch_id);


--
-- Name: ix_asset_mappings_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_asset_mappings_id ON public.asset_mappings USING btree (id);


--
-- Name: ix_asset_registry_asset_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_asset_registry_asset_tag_id ON public.asset_registry USING btree (asset_tag_id);


--
-- Name: ix_asset_registry_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_asset_registry_branch_id ON public.asset_registry USING btree (branch_id);


--
-- Name: ix_asset_registry_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_asset_registry_id ON public.asset_registry USING btree (id);


--
-- Name: ix_assigned_services_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_assigned_services_branch_id ON public.assigned_services USING btree (branch_id);


--
-- Name: ix_assigned_services_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_assigned_services_id ON public.assigned_services USING btree (id);


--
-- Name: ix_attendances_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_attendances_branch_id ON public.attendances USING btree (branch_id);


--
-- Name: ix_attendances_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_attendances_id ON public.attendances USING btree (id);


--
-- Name: ix_booking_rooms_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_booking_rooms_branch_id ON public.booking_rooms USING btree (branch_id);


--
-- Name: ix_booking_rooms_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_booking_rooms_id ON public.booking_rooms USING btree (id);


--
-- Name: ix_bookings_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_bookings_branch_id ON public.bookings USING btree (branch_id);


--
-- Name: ix_bookings_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_bookings_display_id ON public.bookings USING btree (display_id);


--
-- Name: ix_bookings_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_bookings_id ON public.bookings USING btree (id);


--
-- Name: ix_branches_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_branches_code ON public.branches USING btree (code);


--
-- Name: ix_branches_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_branches_id ON public.branches USING btree (id);


--
-- Name: ix_check_availability_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_check_availability_id ON public.check_availability USING btree (id);


--
-- Name: ix_checkout_payments_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_checkout_payments_branch_id ON public.checkout_payments USING btree (branch_id);


--
-- Name: ix_checkout_payments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_checkout_payments_id ON public.checkout_payments USING btree (id);


--
-- Name: ix_checkout_requests_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_checkout_requests_branch_id ON public.checkout_requests USING btree (branch_id);


--
-- Name: ix_checkout_requests_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_checkout_requests_id ON public.checkout_requests USING btree (id);


--
-- Name: ix_checkout_verifications_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_checkout_verifications_branch_id ON public.checkout_verifications USING btree (branch_id);


--
-- Name: ix_checkout_verifications_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_checkout_verifications_id ON public.checkout_verifications USING btree (id);


--
-- Name: ix_checkouts_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_checkouts_branch_id ON public.checkouts USING btree (branch_id);


--
-- Name: ix_checkouts_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_checkouts_id ON public.checkouts USING btree (id);


--
-- Name: ix_checkouts_invoice_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_checkouts_invoice_number ON public.checkouts USING btree (invoice_number);


--
-- Name: ix_day_audits_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_day_audits_branch_id ON public.day_audits USING btree (branch_id);


--
-- Name: ix_day_audits_business_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_day_audits_business_date ON public.day_audits USING btree (business_date);


--
-- Name: ix_day_audits_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_day_audits_id ON public.day_audits USING btree (id);


--
-- Name: ix_employee_inventory_assignments_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_employee_inventory_assignments_branch_id ON public.employee_inventory_assignments USING btree (branch_id);


--
-- Name: ix_employee_inventory_assignments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_employee_inventory_assignments_id ON public.employee_inventory_assignments USING btree (id);


--
-- Name: ix_employees_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_employees_branch_id ON public.employees USING btree (branch_id);


--
-- Name: ix_employees_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_employees_id ON public.employees USING btree (id);


--
-- Name: ix_expenses_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_expenses_branch_id ON public.expenses USING btree (branch_id);


--
-- Name: ix_expenses_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_expenses_id ON public.expenses USING btree (id);


--
-- Name: ix_expenses_self_invoice_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_expenses_self_invoice_number ON public.expenses USING btree (self_invoice_number);


--
-- Name: ix_food_categories_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_categories_branch_id ON public.food_categories USING btree (branch_id);


--
-- Name: ix_food_categories_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_categories_id ON public.food_categories USING btree (id);


--
-- Name: ix_food_item_images_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_item_images_id ON public.food_item_images USING btree (id);


--
-- Name: ix_food_items_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_items_branch_id ON public.food_items USING btree (branch_id);


--
-- Name: ix_food_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_items_id ON public.food_items USING btree (id);


--
-- Name: ix_food_order_items_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_order_items_branch_id ON public.food_order_items USING btree (branch_id);


--
-- Name: ix_food_order_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_order_items_id ON public.food_order_items USING btree (id);


--
-- Name: ix_food_orders_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_orders_branch_id ON public.food_orders USING btree (branch_id);


--
-- Name: ix_food_orders_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_food_orders_id ON public.food_orders USING btree (id);


--
-- Name: ix_gallery_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_gallery_id ON public.gallery USING btree (id);


--
-- Name: ix_guest_suggestions_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_guest_suggestions_id ON public.guest_suggestions USING btree (id);


--
-- Name: ix_header_banner_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_header_banner_id ON public.header_banner USING btree (id);


--
-- Name: ix_inter_branch_transfers_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inter_branch_transfers_id ON public.inter_branch_transfers USING btree (id);


--
-- Name: ix_inter_branch_transfers_transfer_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_inter_branch_transfers_transfer_number ON public.inter_branch_transfers USING btree (transfer_number);


--
-- Name: ix_inventory_categories_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_categories_branch_id ON public.inventory_categories USING btree (branch_id);


--
-- Name: ix_inventory_categories_hsn_sac_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_categories_hsn_sac_code ON public.inventory_categories USING btree (hsn_sac_code);


--
-- Name: ix_inventory_categories_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_categories_id ON public.inventory_categories USING btree (id);


--
-- Name: ix_inventory_categories_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_categories_name ON public.inventory_categories USING btree (name);


--
-- Name: ix_inventory_items_barcode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_items_barcode ON public.inventory_items USING btree (barcode);


--
-- Name: ix_inventory_items_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_items_branch_id ON public.inventory_items USING btree (branch_id);


--
-- Name: ix_inventory_items_hsn_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_items_hsn_code ON public.inventory_items USING btree (hsn_code);


--
-- Name: ix_inventory_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_items_id ON public.inventory_items USING btree (id);


--
-- Name: ix_inventory_items_item_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_items_item_code ON public.inventory_items USING btree (item_code);


--
-- Name: ix_inventory_items_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_items_name ON public.inventory_items USING btree (name);


--
-- Name: ix_inventory_transactions_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_transactions_branch_id ON public.inventory_transactions USING btree (branch_id);


--
-- Name: ix_inventory_transactions_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_transactions_id ON public.inventory_transactions USING btree (id);


--
-- Name: ix_journal_entries_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_journal_entries_branch_id ON public.journal_entries USING btree (branch_id);


--
-- Name: ix_journal_entries_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_journal_entries_id ON public.journal_entries USING btree (id);


--
-- Name: ix_journal_entry_lines_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_journal_entry_lines_branch_id ON public.journal_entry_lines USING btree (branch_id);


--
-- Name: ix_journal_entry_lines_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_journal_entry_lines_id ON public.journal_entry_lines USING btree (id);


--
-- Name: ix_laundry_logs_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_laundry_logs_branch_id ON public.laundry_logs USING btree (branch_id);


--
-- Name: ix_laundry_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_laundry_logs_id ON public.laundry_logs USING btree (id);


--
-- Name: ix_leaves_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_leaves_branch_id ON public.leaves USING btree (branch_id);


--
-- Name: ix_leaves_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_leaves_id ON public.leaves USING btree (id);


--
-- Name: ix_location_stocks_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_location_stocks_branch_id ON public.location_stocks USING btree (branch_id);


--
-- Name: ix_location_stocks_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_location_stocks_id ON public.location_stocks USING btree (id);


--
-- Name: ix_locations_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_locations_branch_id ON public.locations USING btree (branch_id);


--
-- Name: ix_locations_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_locations_id ON public.locations USING btree (id);


--
-- Name: ix_locations_location_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_locations_location_code ON public.locations USING btree (location_code);


--
-- Name: ix_nearby_attraction_banners_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_nearby_attraction_banners_id ON public.nearby_attraction_banners USING btree (id);


--
-- Name: ix_nearby_attractions_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_nearby_attractions_id ON public.nearby_attractions USING btree (id);


--
-- Name: ix_night_charges_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_night_charges_branch_id ON public.night_charges USING btree (branch_id);


--
-- Name: ix_night_charges_business_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_night_charges_business_date ON public.night_charges USING btree (business_date);


--
-- Name: ix_night_charges_day_audit_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_night_charges_day_audit_id ON public.night_charges USING btree (day_audit_id);


--
-- Name: ix_night_charges_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_night_charges_id ON public.night_charges USING btree (id);


--
-- Name: ix_notifications_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notifications_branch_id ON public.notifications USING btree (branch_id);


--
-- Name: ix_notifications_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notifications_id ON public.notifications USING btree (id);


--
-- Name: ix_package_booking_rooms_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_package_booking_rooms_branch_id ON public.package_booking_rooms USING btree (branch_id);


--
-- Name: ix_package_booking_rooms_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_package_booking_rooms_id ON public.package_booking_rooms USING btree (id);


--
-- Name: ix_package_bookings_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_package_bookings_branch_id ON public.package_bookings USING btree (branch_id);


--
-- Name: ix_package_bookings_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_package_bookings_display_id ON public.package_bookings USING btree (display_id);


--
-- Name: ix_package_bookings_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_package_bookings_id ON public.package_bookings USING btree (id);


--
-- Name: ix_package_images_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_package_images_id ON public.package_images USING btree (id);


--
-- Name: ix_packages_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_packages_branch_id ON public.packages USING btree (branch_id);


--
-- Name: ix_packages_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_packages_id ON public.packages USING btree (id);


--
-- Name: ix_payments_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_branch_id ON public.payments USING btree (branch_id);


--
-- Name: ix_payments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_id ON public.payments USING btree (id);


--
-- Name: ix_plan_weddings_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_plan_weddings_id ON public.plan_weddings USING btree (id);


--
-- Name: ix_pricing_calendar_end_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pricing_calendar_end_date ON public.pricing_calendar USING btree (end_date);


--
-- Name: ix_pricing_calendar_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pricing_calendar_id ON public.pricing_calendar USING btree (id);


--
-- Name: ix_pricing_calendar_start_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pricing_calendar_start_date ON public.pricing_calendar USING btree (start_date);


--
-- Name: ix_purchase_details_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_details_id ON public.purchase_details USING btree (id);


--
-- Name: ix_purchase_masters_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_masters_branch_id ON public.purchase_masters USING btree (branch_id);


--
-- Name: ix_purchase_masters_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_masters_id ON public.purchase_masters USING btree (id);


--
-- Name: ix_purchase_masters_invoice_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_masters_invoice_number ON public.purchase_masters USING btree (invoice_number);


--
-- Name: ix_purchase_masters_purchase_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_purchase_masters_purchase_number ON public.purchase_masters USING btree (purchase_number);


--
-- Name: ix_rate_plans_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_rate_plans_branch_id ON public.rate_plans USING btree (branch_id);


--
-- Name: ix_rate_plans_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_rate_plans_id ON public.rate_plans USING btree (id);


--
-- Name: ix_recipe_ingredients_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_recipe_ingredients_id ON public.recipe_ingredients USING btree (id);


--
-- Name: ix_recipes_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_recipes_branch_id ON public.recipes USING btree (branch_id);


--
-- Name: ix_recipes_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_recipes_id ON public.recipes USING btree (id);


--
-- Name: ix_resort_info_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_resort_info_id ON public.resort_info USING btree (id);


--
-- Name: ix_reviews_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_reviews_id ON public.reviews USING btree (id);


--
-- Name: ix_roles_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_roles_id ON public.roles USING btree (id);


--
-- Name: ix_room_types_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_room_types_branch_id ON public.room_types USING btree (branch_id);


--
-- Name: ix_room_types_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_room_types_id ON public.room_types USING btree (id);


--
-- Name: ix_rooms_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_rooms_branch_id ON public.rooms USING btree (branch_id);


--
-- Name: ix_rooms_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_rooms_id ON public.rooms USING btree (id);


--
-- Name: ix_salary_payments_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_salary_payments_branch_id ON public.salary_payments USING btree (branch_id);


--
-- Name: ix_salary_payments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_salary_payments_id ON public.salary_payments USING btree (id);


--
-- Name: ix_service_images_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_service_images_id ON public.service_images USING btree (id);


--
-- Name: ix_service_requests_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_service_requests_branch_id ON public.service_requests USING btree (branch_id);


--
-- Name: ix_service_requests_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_service_requests_id ON public.service_requests USING btree (id);


--
-- Name: ix_services_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_services_branch_id ON public.services USING btree (branch_id);


--
-- Name: ix_services_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_services_id ON public.services USING btree (id);


--
-- Name: ix_signature_experiences_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_signature_experiences_id ON public.signature_experiences USING btree (id);


--
-- Name: ix_stock_issue_details_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_issue_details_id ON public.stock_issue_details USING btree (id);


--
-- Name: ix_stock_issues_booking_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_issues_booking_id ON public.stock_issues USING btree (booking_id);


--
-- Name: ix_stock_issues_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_issues_branch_id ON public.stock_issues USING btree (branch_id);


--
-- Name: ix_stock_issues_guest_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_issues_guest_id ON public.stock_issues USING btree (guest_id);


--
-- Name: ix_stock_issues_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_issues_id ON public.stock_issues USING btree (id);


--
-- Name: ix_stock_issues_issue_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_stock_issues_issue_number ON public.stock_issues USING btree (issue_number);


--
-- Name: ix_stock_requisition_details_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_requisition_details_id ON public.stock_requisition_details USING btree (id);


--
-- Name: ix_stock_requisitions_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_requisitions_branch_id ON public.stock_requisitions USING btree (branch_id);


--
-- Name: ix_stock_requisitions_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_requisitions_id ON public.stock_requisitions USING btree (id);


--
-- Name: ix_stock_requisitions_requisition_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_stock_requisitions_requisition_number ON public.stock_requisitions USING btree (requisition_number);


--
-- Name: ix_system_settings_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_system_settings_id ON public.system_settings USING btree (id);


--
-- Name: ix_system_settings_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_system_settings_key ON public.system_settings USING btree (key);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_vendors_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendors_branch_id ON public.vendors USING btree (branch_id);


--
-- Name: ix_vendors_gst_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendors_gst_number ON public.vendors USING btree (gst_number);


--
-- Name: ix_vendors_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendors_id ON public.vendors USING btree (id);


--
-- Name: ix_vendors_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendors_name ON public.vendors USING btree (name);


--
-- Name: ix_vendors_pan_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendors_pan_number ON public.vendors USING btree (pan_number);


--
-- Name: ix_vouchers_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vouchers_branch_id ON public.vouchers USING btree (branch_id);


--
-- Name: ix_vouchers_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vouchers_id ON public.vouchers USING btree (id);


--
-- Name: ix_waste_logs_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_waste_logs_branch_id ON public.waste_logs USING btree (branch_id);


--
-- Name: ix_waste_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_waste_logs_id ON public.waste_logs USING btree (id);


--
-- Name: ix_waste_logs_log_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_waste_logs_log_number ON public.waste_logs USING btree (log_number);


--
-- Name: ix_working_logs_branch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_working_logs_branch_id ON public.working_logs USING btree (branch_id);


--
-- Name: ix_working_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_working_logs_id ON public.working_logs USING btree (id);


--
-- Name: account_groups account_groups_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_groups
    ADD CONSTRAINT account_groups_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: account_ledgers account_ledgers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_ledgers
    ADD CONSTRAINT account_ledgers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: account_ledgers account_ledgers_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_ledgers
    ADD CONSTRAINT account_ledgers_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.account_groups(id);


--
-- Name: activity_logs activity_logs_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: asset_mappings asset_mappings_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- Name: asset_mappings asset_mappings_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: asset_mappings asset_mappings_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: asset_mappings asset_mappings_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: asset_registry asset_registry_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: asset_registry asset_registry_current_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_current_location_id_fkey FOREIGN KEY (current_location_id) REFERENCES public.locations(id);


--
-- Name: asset_registry asset_registry_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: asset_registry asset_registry_purchase_master_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_purchase_master_id_fkey FOREIGN KEY (purchase_master_id) REFERENCES public.purchase_masters(id);


--
-- Name: assigned_services assigned_services_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: assigned_services assigned_services_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: assigned_services assigned_services_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: assigned_services assigned_services_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id);


--
-- Name: assigned_services assigned_services_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: assigned_services assigned_services_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: attendances attendances_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: attendances attendances_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: booking_rooms booking_rooms_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: booking_rooms booking_rooms_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: booking_rooms booking_rooms_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: bookings bookings_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: bookings bookings_room_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES public.room_types(id);


--
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: check_availability check_availability_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_availability
    ADD CONSTRAINT check_availability_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: checkout_payments checkout_payments_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_payments
    ADD CONSTRAINT checkout_payments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: checkout_payments checkout_payments_checkout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_payments
    ADD CONSTRAINT checkout_payments_checkout_id_fkey FOREIGN KEY (checkout_id) REFERENCES public.checkouts(id);


--
-- Name: checkout_requests checkout_requests_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: checkout_requests checkout_requests_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: checkout_requests checkout_requests_checkout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_checkout_id_fkey FOREIGN KEY (checkout_id) REFERENCES public.checkouts(id);


--
-- Name: checkout_requests checkout_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: checkout_requests checkout_requests_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id);


--
-- Name: checkout_verifications checkout_verifications_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_verifications
    ADD CONSTRAINT checkout_verifications_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: checkout_verifications checkout_verifications_checkout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_verifications
    ADD CONSTRAINT checkout_verifications_checkout_id_fkey FOREIGN KEY (checkout_id) REFERENCES public.checkouts(id);


--
-- Name: checkout_verifications checkout_verifications_checkout_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkout_verifications
    ADD CONSTRAINT checkout_verifications_checkout_request_id_fkey FOREIGN KEY (checkout_request_id) REFERENCES public.checkout_requests(id);


--
-- Name: checkouts checkouts_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: checkouts checkouts_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: checkouts checkouts_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id);


--
-- Name: day_audits day_audits_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_audits
    ADD CONSTRAINT day_audits_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: day_audits day_audits_closed_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_audits
    ADD CONSTRAINT day_audits_closed_by_id_fkey FOREIGN KEY (closed_by_id) REFERENCES public.users(id);


--
-- Name: day_audits day_audits_opened_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_audits
    ADD CONSTRAINT day_audits_opened_by_id_fkey FOREIGN KEY (opened_by_id) REFERENCES public.users(id);


--
-- Name: employee_inventory_assignments employee_inventory_assignments_assigned_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_assigned_service_id_fkey FOREIGN KEY (assigned_service_id) REFERENCES public.assigned_services(id);


--
-- Name: employee_inventory_assignments employee_inventory_assignments_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: employee_inventory_assignments employee_inventory_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: employee_inventory_assignments employee_inventory_assignments_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: employees employees_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: employees employees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: expenses expenses_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: expenses expenses_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: expenses expenses_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: food_categories food_categories_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_categories
    ADD CONSTRAINT food_categories_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: food_item_images food_item_images_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_item_images
    ADD CONSTRAINT food_item_images_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.food_items(id);


--
-- Name: food_items food_items_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_items
    ADD CONSTRAINT food_items_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: food_items food_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_items
    ADD CONSTRAINT food_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.food_categories(id);


--
-- Name: food_order_items food_order_items_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: food_order_items food_order_items_food_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_food_item_id_fkey FOREIGN KEY (food_item_id) REFERENCES public.food_items(id);


--
-- Name: food_order_items food_order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.food_orders(id);


--
-- Name: food_orders food_orders_assigned_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_assigned_employee_id_fkey FOREIGN KEY (assigned_employee_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: food_orders food_orders_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: food_orders food_orders_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: food_orders food_orders_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: food_orders food_orders_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id);


--
-- Name: food_orders food_orders_prepared_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_prepared_by_id_fkey FOREIGN KEY (prepared_by_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: food_orders food_orders_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: gallery gallery_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery
    ADD CONSTRAINT gallery_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: header_banner header_banner_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.header_banner
    ADD CONSTRAINT header_banner_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: inter_branch_transfers inter_branch_transfers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inter_branch_transfers
    ADD CONSTRAINT inter_branch_transfers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: inter_branch_transfers inter_branch_transfers_destination_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inter_branch_transfers
    ADD CONSTRAINT inter_branch_transfers_destination_branch_id_fkey FOREIGN KEY (destination_branch_id) REFERENCES public.branches(id);


--
-- Name: inter_branch_transfers inter_branch_transfers_destination_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inter_branch_transfers
    ADD CONSTRAINT inter_branch_transfers_destination_location_id_fkey FOREIGN KEY (destination_location_id) REFERENCES public.locations(id);


--
-- Name: inter_branch_transfers inter_branch_transfers_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inter_branch_transfers
    ADD CONSTRAINT inter_branch_transfers_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: inter_branch_transfers inter_branch_transfers_source_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inter_branch_transfers
    ADD CONSTRAINT inter_branch_transfers_source_branch_id_fkey FOREIGN KEY (source_branch_id) REFERENCES public.branches(id);


--
-- Name: inter_branch_transfers inter_branch_transfers_source_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inter_branch_transfers
    ADD CONSTRAINT inter_branch_transfers_source_location_id_fkey FOREIGN KEY (source_location_id) REFERENCES public.locations(id);


--
-- Name: inventory_categories inventory_categories_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_categories
    ADD CONSTRAINT inventory_categories_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: inventory_items inventory_items_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: inventory_items inventory_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.inventory_categories(id);


--
-- Name: inventory_items inventory_items_preferred_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_preferred_vendor_id_fkey FOREIGN KEY (preferred_vendor_id) REFERENCES public.vendors(id);


--
-- Name: inventory_transactions inventory_transactions_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: inventory_transactions inventory_transactions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: inventory_transactions inventory_transactions_destination_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_destination_location_id_fkey FOREIGN KEY (destination_location_id) REFERENCES public.locations(id);


--
-- Name: inventory_transactions inventory_transactions_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: inventory_transactions inventory_transactions_purchase_master_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_purchase_master_id_fkey FOREIGN KEY (purchase_master_id) REFERENCES public.purchase_masters(id);


--
-- Name: inventory_transactions inventory_transactions_source_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_source_location_id_fkey FOREIGN KEY (source_location_id) REFERENCES public.locations(id);


--
-- Name: journal_entries journal_entries_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: journal_entries journal_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: journal_entries journal_entries_reversed_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_reversed_entry_id_fkey FOREIGN KEY (reversed_entry_id) REFERENCES public.journal_entries(id);


--
-- Name: journal_entry_lines journal_entry_lines_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: journal_entry_lines journal_entry_lines_credit_ledger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_credit_ledger_id_fkey FOREIGN KEY (credit_ledger_id) REFERENCES public.account_ledgers(id);


--
-- Name: journal_entry_lines journal_entry_lines_debit_ledger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_debit_ledger_id_fkey FOREIGN KEY (debit_ledger_id) REFERENCES public.account_ledgers(id);


--
-- Name: journal_entry_lines journal_entry_lines_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES public.journal_entries(id);


--
-- Name: laundry_logs laundry_logs_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: laundry_logs laundry_logs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: laundry_logs laundry_logs_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: laundry_logs laundry_logs_source_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_source_location_id_fkey FOREIGN KEY (source_location_id) REFERENCES public.locations(id);


--
-- Name: leaves leaves_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: leaves leaves_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: location_stocks location_stocks_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_stocks
    ADD CONSTRAINT location_stocks_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: location_stocks location_stocks_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_stocks
    ADD CONSTRAINT location_stocks_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: location_stocks location_stocks_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_stocks
    ADD CONSTRAINT location_stocks_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: locations locations_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: locations locations_parent_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_parent_location_id_fkey FOREIGN KEY (parent_location_id) REFERENCES public.locations(id);


--
-- Name: nearby_attraction_banners nearby_attraction_banners_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nearby_attraction_banners
    ADD CONSTRAINT nearby_attraction_banners_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: nearby_attractions nearby_attractions_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nearby_attractions
    ADD CONSTRAINT nearby_attractions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: night_charges night_charges_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.night_charges
    ADD CONSTRAINT night_charges_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: night_charges night_charges_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.night_charges
    ADD CONSTRAINT night_charges_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: night_charges night_charges_day_audit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.night_charges
    ADD CONSTRAINT night_charges_day_audit_id_fkey FOREIGN KEY (day_audit_id) REFERENCES public.day_audits(id);


--
-- Name: notifications notifications_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: package_booking_rooms package_booking_rooms_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: package_booking_rooms package_booking_rooms_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id) ON DELETE CASCADE;


--
-- Name: package_booking_rooms package_booking_rooms_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: package_bookings package_bookings_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: package_bookings package_bookings_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id);


--
-- Name: package_bookings package_bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: package_images package_images_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_images
    ADD CONSTRAINT package_images_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id);


--
-- Name: packages packages_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: payments payments_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: payments payments_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id);


--
-- Name: plan_weddings plan_weddings_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_weddings
    ADD CONSTRAINT plan_weddings_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: purchase_details purchase_details_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT purchase_details_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: purchase_details purchase_details_purchase_master_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT purchase_details_purchase_master_id_fkey FOREIGN KEY (purchase_master_id) REFERENCES public.purchase_masters(id);


--
-- Name: purchase_masters purchase_masters_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_masters
    ADD CONSTRAINT purchase_masters_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: purchase_masters purchase_masters_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_masters
    ADD CONSTRAINT purchase_masters_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: purchase_masters purchase_masters_destination_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_masters
    ADD CONSTRAINT purchase_masters_destination_location_id_fkey FOREIGN KEY (destination_location_id) REFERENCES public.locations(id);


--
-- Name: purchase_masters purchase_masters_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_masters
    ADD CONSTRAINT purchase_masters_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: rate_plans rate_plans_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate_plans
    ADD CONSTRAINT rate_plans_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: rate_plans rate_plans_room_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate_plans
    ADD CONSTRAINT rate_plans_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES public.room_types(id);


--
-- Name: recipe_ingredients recipe_ingredients_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: recipe_ingredients recipe_ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id);


--
-- Name: recipes recipes_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: recipes recipes_food_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_food_item_id_fkey FOREIGN KEY (food_item_id) REFERENCES public.food_items(id);


--
-- Name: resort_info resort_info_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resort_info
    ADD CONSTRAINT resort_info_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: reviews reviews_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: roles roles_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: room_types room_types_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_types
    ADD CONSTRAINT room_types_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: rooms rooms_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: rooms rooms_inventory_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_inventory_location_id_fkey FOREIGN KEY (inventory_location_id) REFERENCES public.locations(id);


--
-- Name: rooms rooms_room_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES public.room_types(id);


--
-- Name: salary_payments salary_payments_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_payments
    ADD CONSTRAINT salary_payments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: salary_payments salary_payments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_payments
    ADD CONSTRAINT salary_payments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: service_images service_images_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_images
    ADD CONSTRAINT service_images_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: service_inventory_items service_inventory_items_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_inventory_items
    ADD CONSTRAINT service_inventory_items_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: service_inventory_items service_inventory_items_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_inventory_items
    ADD CONSTRAINT service_inventory_items_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: service_requests service_requests_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: service_requests service_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: service_requests service_requests_food_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_food_order_id_fkey FOREIGN KEY (food_order_id) REFERENCES public.food_orders(id);


--
-- Name: service_requests service_requests_pickup_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_pickup_location_id_fkey FOREIGN KEY (pickup_location_id) REFERENCES public.locations(id);


--
-- Name: service_requests service_requests_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: services services_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: signature_experiences signature_experiences_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signature_experiences
    ADD CONSTRAINT signature_experiences_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: stock_issue_details stock_issue_details_issue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issue_details
    ADD CONSTRAINT stock_issue_details_issue_id_fkey FOREIGN KEY (issue_id) REFERENCES public.stock_issues(id);


--
-- Name: stock_issue_details stock_issue_details_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issue_details
    ADD CONSTRAINT stock_issue_details_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: stock_issues stock_issues_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: stock_issues stock_issues_destination_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_destination_location_id_fkey FOREIGN KEY (destination_location_id) REFERENCES public.locations(id);


--
-- Name: stock_issues stock_issues_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: stock_issues stock_issues_requisition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_requisition_id_fkey FOREIGN KEY (requisition_id) REFERENCES public.stock_requisitions(id);


--
-- Name: stock_issues stock_issues_source_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_source_location_id_fkey FOREIGN KEY (source_location_id) REFERENCES public.locations(id);


--
-- Name: stock_requisition_details stock_requisition_details_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisition_details
    ADD CONSTRAINT stock_requisition_details_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: stock_requisition_details stock_requisition_details_requisition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisition_details
    ADD CONSTRAINT stock_requisition_details_requisition_id_fkey FOREIGN KEY (requisition_id) REFERENCES public.stock_requisitions(id);


--
-- Name: stock_requisitions stock_requisitions_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisitions
    ADD CONSTRAINT stock_requisitions_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: stock_requisitions stock_requisitions_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisitions
    ADD CONSTRAINT stock_requisitions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: stock_requisitions stock_requisitions_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_requisitions
    ADD CONSTRAINT stock_requisitions_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- Name: system_settings system_settings_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: users users_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: vendors vendors_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: vouchers vouchers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: waste_logs waste_logs_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: waste_logs waste_logs_food_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_food_item_id_fkey FOREIGN KEY (food_item_id) REFERENCES public.food_items(id);


--
-- Name: waste_logs waste_logs_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: waste_logs waste_logs_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: waste_logs waste_logs_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.users(id);


--
-- Name: working_logs working_logs_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.working_logs
    ADD CONSTRAINT working_logs_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: working_logs working_logs_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.working_logs
    ADD CONSTRAINT working_logs_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: working_logs working_logs_tasks_approved_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.working_logs
    ADD CONSTRAINT working_logs_tasks_approved_by_id_fkey FOREIGN KEY (tasks_approved_by_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict vEwEKfJw2Vwm70FudgJWyCU6N1bnfy7uuxOlQF1aibHiQvR8d3JwIte1nZS54ab

