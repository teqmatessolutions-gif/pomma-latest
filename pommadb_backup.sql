--
-- PostgreSQL database dump
--

\restrict ksVezUUfvlSSW18KbqywD7L0VuGOrIQ3eOS5UJ1EzW36BzxaLf8fbmRRXQQczQ9

-- Dumped from database version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: servicestatus; Type: TYPE; Schema: public; Owner: pomma
--

CREATE TYPE public.servicestatus AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'cancelled'
);


ALTER TYPE public.servicestatus OWNER TO pomma;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO pomma;

--
-- Name: assigned_services; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.assigned_services (
    id integer NOT NULL,
    service_id integer,
    employee_id integer,
    room_id integer,
    assigned_at timestamp without time zone,
    status public.servicestatus,
    billing_status character varying
);


ALTER TABLE public.assigned_services OWNER TO pomma;

--
-- Name: assigned_services_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.assigned_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assigned_services_id_seq OWNER TO pomma;

--
-- Name: assigned_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.assigned_services_id_seq OWNED BY public.assigned_services.id;


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.attendances (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    date date NOT NULL,
    status character varying NOT NULL
);


ALTER TABLE public.attendances OWNER TO pomma;

--
-- Name: attendances_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.attendances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendances_id_seq OWNER TO pomma;

--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;


--
-- Name: booking_rooms; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.booking_rooms (
    id integer NOT NULL,
    booking_id integer,
    room_id integer
);


ALTER TABLE public.booking_rooms OWNER TO pomma;

--
-- Name: booking_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.booking_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.booking_rooms_id_seq OWNER TO pomma;

--
-- Name: booking_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.booking_rooms_id_seq OWNED BY public.booking_rooms.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    status character varying,
    guest_name character varying NOT NULL,
    guest_mobile character varying,
    guest_email character varying,
    check_in date NOT NULL,
    check_out date NOT NULL,
    adults integer,
    children integer,
    id_card_image_url character varying,
    guest_photo_url character varying,
    user_id integer,
    total_amount double precision
);


ALTER TABLE public.bookings OWNER TO pomma;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bookings_id_seq OWNER TO pomma;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: check_availability; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.check_availability (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100),
    phone character varying(20),
    check_in date,
    check_out date,
    guests integer,
    is_active boolean
);


ALTER TABLE public.check_availability OWNER TO pomma;

--
-- Name: check_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.check_availability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.check_availability_id_seq OWNER TO pomma;

--
-- Name: check_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.check_availability_id_seq OWNED BY public.check_availability.id;


--
-- Name: checkouts; Type: TABLE; Schema: public; Owner: pomma
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
    booking_id integer,
    package_booking_id integer,
    payment_status character varying
);


ALTER TABLE public.checkouts OWNER TO pomma;

--
-- Name: checkouts_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.checkouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checkouts_id_seq OWNER TO pomma;

--
-- Name: checkouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.checkouts_id_seq OWNED BY public.checkouts.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    name character varying,
    role character varying,
    salary double precision,
    join_date date,
    image_url character varying,
    user_id integer
);


ALTER TABLE public.employees OWNER TO pomma;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO pomma;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.expenses (
    id integer NOT NULL,
    category character varying NOT NULL,
    amount double precision NOT NULL,
    date date NOT NULL,
    description character varying,
    employee_id integer,
    image character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.expenses OWNER TO pomma;

--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.expenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.expenses_id_seq OWNER TO pomma;

--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.expenses_id_seq OWNED BY public.expenses.id;


--
-- Name: food_categories; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.food_categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    image character varying
);


ALTER TABLE public.food_categories OWNER TO resort_user;

--
-- Name: food_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.food_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_categories_id_seq OWNER TO resort_user;

--
-- Name: food_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.food_categories_id_seq OWNED BY public.food_categories.id;


--
-- Name: food_item_images; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.food_item_images (
    id integer NOT NULL,
    image_url character varying,
    item_id integer
);


ALTER TABLE public.food_item_images OWNER TO resort_user;

--
-- Name: food_item_images_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.food_item_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_item_images_id_seq OWNER TO resort_user;

--
-- Name: food_item_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.food_item_images_id_seq OWNED BY public.food_item_images.id;


--
-- Name: food_items; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.food_items (
    id integer NOT NULL,
    name character varying,
    description character varying,
    price integer,
    available character varying,
    category_id integer
);


ALTER TABLE public.food_items OWNER TO resort_user;

--
-- Name: food_items_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.food_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_items_id_seq OWNER TO resort_user;

--
-- Name: food_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.food_items_id_seq OWNED BY public.food_items.id;


--
-- Name: food_order_items; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.food_order_items (
    id integer NOT NULL,
    order_id integer,
    food_item_id integer,
    quantity integer
);


ALTER TABLE public.food_order_items OWNER TO pomma;

--
-- Name: food_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.food_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_order_items_id_seq OWNER TO pomma;

--
-- Name: food_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.food_order_items_id_seq OWNED BY public.food_order_items.id;


--
-- Name: food_orders; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.food_orders (
    id integer NOT NULL,
    room_id integer,
    amount double precision,
    assigned_employee_id integer,
    status character varying,
    billing_status character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.food_orders OWNER TO pomma;

--
-- Name: food_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.food_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_orders_id_seq OWNER TO pomma;

--
-- Name: food_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.food_orders_id_seq OWNED BY public.food_orders.id;


--
-- Name: gallery; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.gallery (
    id integer NOT NULL,
    image_url character varying(255),
    caption character varying(255),
    is_active boolean
);


ALTER TABLE public.gallery OWNER TO resort_user;

--
-- Name: gallery_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.gallery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gallery_id_seq OWNER TO resort_user;

--
-- Name: gallery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.gallery_id_seq OWNED BY public.gallery.id;


--
-- Name: guest_suggestions; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.guest_suggestions (
    id integer NOT NULL,
    guest_name character varying(100) NOT NULL,
    contact_info character varying(100),
    suggestion text NOT NULL,
    status character varying(50),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.guest_suggestions OWNER TO pomma;

--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.guest_suggestions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guest_suggestions_id_seq OWNER TO pomma;

--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.guest_suggestions_id_seq OWNED BY public.guest_suggestions.id;


--
-- Name: header_banner; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.header_banner (
    id integer NOT NULL,
    title character varying(255),
    subtitle text,
    image_url character varying(255),
    is_active boolean
);


ALTER TABLE public.header_banner OWNER TO resort_user;

--
-- Name: header_banner_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.header_banner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.header_banner_id_seq OWNER TO resort_user;

--
-- Name: header_banner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.header_banner_id_seq OWNED BY public.header_banner.id;


--
-- Name: leaves; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.leaves (
    id integer NOT NULL,
    employee_id integer,
    from_date date,
    to_date date,
    reason character varying,
    leave_type character varying,
    status character varying
);


ALTER TABLE public.leaves OWNER TO pomma;

--
-- Name: leaves_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.leaves_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leaves_id_seq OWNER TO pomma;

--
-- Name: leaves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.leaves_id_seq OWNED BY public.leaves.id;


--
-- Name: nearby_attraction_banners; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.nearby_attraction_banners (
    id integer NOT NULL,
    title character varying(255),
    subtitle text,
    image_url character varying(255),
    is_active boolean,
    map_link character varying(512)
);


ALTER TABLE public.nearby_attraction_banners OWNER TO resort_user;

--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.nearby_attraction_banners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nearby_attraction_banners_id_seq OWNER TO resort_user;

--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.nearby_attraction_banners_id_seq OWNED BY public.nearby_attraction_banners.id;


--
-- Name: nearby_attractions; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.nearby_attractions (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    is_active boolean,
    map_link character varying(512)
);


ALTER TABLE public.nearby_attractions OWNER TO resort_user;

--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.nearby_attractions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nearby_attractions_id_seq OWNER TO resort_user;

--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.nearby_attractions_id_seq OWNED BY public.nearby_attractions.id;


--
-- Name: package_booking_rooms; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.package_booking_rooms (
    id integer NOT NULL,
    package_booking_id integer,
    room_id integer
);


ALTER TABLE public.package_booking_rooms OWNER TO pomma;

--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.package_booking_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.package_booking_rooms_id_seq OWNER TO pomma;

--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.package_booking_rooms_id_seq OWNED BY public.package_booking_rooms.id;


--
-- Name: package_bookings; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.package_bookings (
    id integer NOT NULL,
    package_id integer,
    user_id integer,
    guest_name character varying NOT NULL,
    guest_email character varying,
    guest_mobile character varying,
    check_in date NOT NULL,
    check_out date NOT NULL,
    adults integer,
    children integer,
    id_card_image_url character varying,
    guest_photo_url character varying,
    status character varying
);


ALTER TABLE public.package_bookings OWNER TO pomma;

--
-- Name: package_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.package_bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.package_bookings_id_seq OWNER TO pomma;

--
-- Name: package_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.package_bookings_id_seq OWNED BY public.package_bookings.id;


--
-- Name: package_images; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.package_images (
    id integer NOT NULL,
    package_id integer,
    image_url character varying NOT NULL
);


ALTER TABLE public.package_images OWNER TO resort_user;

--
-- Name: package_images_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.package_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.package_images_id_seq OWNER TO resort_user;

--
-- Name: package_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.package_images_id_seq OWNED BY public.package_images.id;


--
-- Name: packages; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.packages (
    id integer NOT NULL,
    title character varying NOT NULL,
    description character varying,
    price double precision NOT NULL,
    room_type character varying,
    is_full_property boolean DEFAULT false NOT NULL,
    booking_type character varying(50) DEFAULT 'room'::character varying,
    room_types text
);


ALTER TABLE public.packages OWNER TO resort_user;

--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.packages_id_seq OWNER TO resort_user;

--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.packages_id_seq OWNED BY public.packages.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    booking_id integer,
    amount double precision,
    method character varying,
    status character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.payments OWNER TO pomma;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO pomma;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: plan_weddings; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.plan_weddings (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    is_active boolean
);


ALTER TABLE public.plan_weddings OWNER TO resort_user;

--
-- Name: plan_weddings_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.plan_weddings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plan_weddings_id_seq OWNER TO resort_user;

--
-- Name: plan_weddings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.plan_weddings_id_seq OWNED BY public.plan_weddings.id;


--
-- Name: resort_info; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.resort_info (
    id integer NOT NULL,
    name character varying(255),
    address text,
    facebook character varying(255),
    instagram character varying(255),
    twitter character varying(255),
    linkedin character varying(255),
    is_active boolean
);


ALTER TABLE public.resort_info OWNER TO resort_user;

--
-- Name: resort_info_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.resort_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resort_info_id_seq OWNER TO resort_user;

--
-- Name: resort_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.resort_info_id_seq OWNED BY public.resort_info.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    name character varying(100),
    comment text,
    rating integer,
    is_active boolean
);


ALTER TABLE public.reviews OWNER TO resort_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_id_seq OWNER TO resort_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying,
    permissions text
);


ALTER TABLE public.roles OWNER TO pomma;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO pomma;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.rooms (
    id integer NOT NULL,
    number character varying NOT NULL,
    type character varying,
    price double precision,
    status character varying,
    image_url character varying,
    adults integer,
    children integer,
    features jsonb DEFAULT '[]'::jsonb NOT NULL,
    air_conditioning boolean DEFAULT false,
    wifi boolean DEFAULT false,
    bathroom boolean DEFAULT false,
    living_area boolean DEFAULT false,
    terrace boolean DEFAULT false,
    parking boolean DEFAULT false,
    kitchen boolean DEFAULT false,
    family_room boolean DEFAULT false,
    bbq boolean DEFAULT false,
    garden boolean DEFAULT false,
    dining boolean DEFAULT false,
    breakfast boolean DEFAULT false
);


ALTER TABLE public.rooms OWNER TO resort_user;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rooms_id_seq OWNER TO resort_user;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: service_images; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.service_images (
    id integer NOT NULL,
    service_id integer,
    image_url character varying NOT NULL
);


ALTER TABLE public.service_images OWNER TO resort_user;

--
-- Name: service_images_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.service_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_images_id_seq OWNER TO resort_user;

--
-- Name: service_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.service_images_id_seq OWNED BY public.service_images.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.services (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    charges double precision NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.services OWNER TO resort_user;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.services_id_seq OWNER TO resort_user;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: signature_experiences; Type: TABLE; Schema: public; Owner: resort_user
--

CREATE TABLE public.signature_experiences (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    is_active boolean
);


ALTER TABLE public.signature_experiences OWNER TO resort_user;

--
-- Name: signature_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: resort_user
--

CREATE SEQUENCE public.signature_experiences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.signature_experiences_id_seq OWNER TO resort_user;

--
-- Name: signature_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resort_user
--

ALTER SEQUENCE public.signature_experiences_id_seq OWNED BY public.signature_experiences.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying,
    email character varying,
    hashed_password character varying,
    phone character varying,
    is_active boolean,
    role_id integer
);


ALTER TABLE public.users OWNER TO pomma;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO pomma;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vouchers; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.vouchers (
    id integer NOT NULL,
    code character varying,
    discount_percent double precision,
    expiry_date timestamp without time zone
);


ALTER TABLE public.vouchers OWNER TO pomma;

--
-- Name: vouchers_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vouchers_id_seq OWNER TO pomma;

--
-- Name: vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.vouchers_id_seq OWNED BY public.vouchers.id;


--
-- Name: working_logs; Type: TABLE; Schema: public; Owner: pomma
--

CREATE TABLE public.working_logs (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    date date NOT NULL,
    check_in_time time without time zone,
    check_out_time time without time zone,
    location character varying
);


ALTER TABLE public.working_logs OWNER TO pomma;

--
-- Name: working_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: pomma
--

CREATE SEQUENCE public.working_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.working_logs_id_seq OWNER TO pomma;

--
-- Name: working_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pomma
--

ALTER SEQUENCE public.working_logs_id_seq OWNED BY public.working_logs.id;


--
-- Name: assigned_services id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.assigned_services ALTER COLUMN id SET DEFAULT nextval('public.assigned_services_id_seq'::regclass);


--
-- Name: attendances id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);


--
-- Name: booking_rooms id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.booking_rooms ALTER COLUMN id SET DEFAULT nextval('public.booking_rooms_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: check_availability id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.check_availability ALTER COLUMN id SET DEFAULT nextval('public.check_availability_id_seq'::regclass);


--
-- Name: checkouts id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.checkouts ALTER COLUMN id SET DEFAULT nextval('public.checkouts_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.expenses ALTER COLUMN id SET DEFAULT nextval('public.expenses_id_seq'::regclass);


--
-- Name: food_categories id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.food_categories ALTER COLUMN id SET DEFAULT nextval('public.food_categories_id_seq'::regclass);


--
-- Name: food_item_images id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.food_item_images ALTER COLUMN id SET DEFAULT nextval('public.food_item_images_id_seq'::regclass);


--
-- Name: food_items id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.food_items ALTER COLUMN id SET DEFAULT nextval('public.food_items_id_seq'::regclass);


--
-- Name: food_order_items id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.food_order_items ALTER COLUMN id SET DEFAULT nextval('public.food_order_items_id_seq'::regclass);


--
-- Name: food_orders id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.food_orders ALTER COLUMN id SET DEFAULT nextval('public.food_orders_id_seq'::regclass);


--
-- Name: gallery id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.gallery ALTER COLUMN id SET DEFAULT nextval('public.gallery_id_seq'::regclass);


--
-- Name: guest_suggestions id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.guest_suggestions ALTER COLUMN id SET DEFAULT nextval('public.guest_suggestions_id_seq'::regclass);


--
-- Name: header_banner id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.header_banner ALTER COLUMN id SET DEFAULT nextval('public.header_banner_id_seq'::regclass);


--
-- Name: leaves id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.leaves ALTER COLUMN id SET DEFAULT nextval('public.leaves_id_seq'::regclass);


--
-- Name: nearby_attraction_banners id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.nearby_attraction_banners ALTER COLUMN id SET DEFAULT nextval('public.nearby_attraction_banners_id_seq'::regclass);


--
-- Name: nearby_attractions id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.nearby_attractions ALTER COLUMN id SET DEFAULT nextval('public.nearby_attractions_id_seq'::regclass);


--
-- Name: package_booking_rooms id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.package_booking_rooms ALTER COLUMN id SET DEFAULT nextval('public.package_booking_rooms_id_seq'::regclass);


--
-- Name: package_bookings id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.package_bookings ALTER COLUMN id SET DEFAULT nextval('public.package_bookings_id_seq'::regclass);


--
-- Name: package_images id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.package_images ALTER COLUMN id SET DEFAULT nextval('public.package_images_id_seq'::regclass);


--
-- Name: packages id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.packages ALTER COLUMN id SET DEFAULT nextval('public.packages_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: plan_weddings id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.plan_weddings ALTER COLUMN id SET DEFAULT nextval('public.plan_weddings_id_seq'::regclass);


--
-- Name: resort_info id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.resort_info ALTER COLUMN id SET DEFAULT nextval('public.resort_info_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: service_images id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.service_images ALTER COLUMN id SET DEFAULT nextval('public.service_images_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: signature_experiences id; Type: DEFAULT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.signature_experiences ALTER COLUMN id SET DEFAULT nextval('public.signature_experiences_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vouchers id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.vouchers ALTER COLUMN id SET DEFAULT nextval('public.vouchers_id_seq'::regclass);


--
-- Name: working_logs id; Type: DEFAULT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.working_logs ALTER COLUMN id SET DEFAULT nextval('public.working_logs_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.alembic_version (version_num) FROM stdin;
\.


--
-- Data for Name: assigned_services; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.assigned_services (id, service_id, employee_id, room_id, assigned_at, status, billing_status) FROM stdin;
9	4	1	7	2025-11-23 19:47:30.3799	completed	billed
\.


--
-- Data for Name: attendances; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.attendances (id, employee_id, date, status) FROM stdin;
\.


--
-- Data for Name: booking_rooms; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.booking_rooms (id, booking_id, room_id) FROM stdin;
19	18	7
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.bookings (id, status, guest_name, guest_mobile, guest_email, check_in, check_out, adults, children, id_card_image_url, guest_photo_url, user_id, total_amount) FROM stdin;
18	checked_out	alphi	8281837820	alphi@gmail.com	2025-11-23	2025-11-25	2	0	id_18_6161cc641c724db9ae30609b0a0c4bef.jpg	guest_18_2a8e7fc50697400192d240c13336c231.jpg	1	0
\.


--
-- Data for Name: check_availability; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.check_availability (id, name, email, phone, check_in, check_out, guests, is_active) FROM stdin;
\.


--
-- Data for Name: checkouts; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.checkouts (id, room_total, food_total, service_total, package_total, tax_amount, discount_amount, grand_total, guest_name, room_number, created_at, checkout_date, payment_method, booking_id, package_booking_id, payment_status) FROM stdin;
8	3800	800	1000	0	496	0	6096	alphi	003	2025-11-23 20:05:24.833096+00	2025-11-25 00:00:00	Card	18	\N	Paid
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.employees (id, name, role, salary, join_date, image_url, user_id) FROM stdin;
1	Dayon Mathew	Manager	1000	2025-11-14	uploads/WhatsApp Image 2025-11-09 at 10.58.20.jpeg	5
2	basil	Manager	100000	2025-11-14	uploads/WhatsApp Image 2025-11-09 at 10.58.20.jpeg	6
3	alphi	frontdesk	200000	2025-11-04	\N	13
4	ebil	Manager	700000	2025-11-03	\N	14
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.expenses (id, category, amount, date, description, employee_id, image, created_at) FROM stdin;
\.


--
-- Data for Name: food_categories; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.food_categories (id, name, image) FROM stdin;
3	Continental And Asian 	category_9a8a0091f2974d10815fcfaca8782560_pngtree-large-variety-of-chinese-dishes-are-on-wooden-table-with-dishes-picture-image_2782240.jpg
4	Luncheon	category_7c620fade6564736816795fc41da5f86_istockphoto-838927480-612x612.jpg
5	Breakfast	category_06f459106f4b4312b7f857c39f96f3e6_kerala-breakfast-food-appam-kadala-curry-kerala-india-appam-kerala-breakfast-food-kadala-curry-hot-spicy-chickpea-190408065.webp
\.


--
-- Data for Name: food_item_images; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.food_item_images (id, image_url, item_id) FROM stdin;
6	/uploads/food_items/food_77063ca9d74a439186750e93c5047a32_Lasagna.jpeg	6
7	/uploads/food_items/food_19bf9dcdffa24809a0b659ba909f4788_Penne Alfredo.jpg	7
8	/uploads/food_items/food_b4afdfd0874c4380b9bddbf23577a06b_coq-au-vin-recipe-24.jpg	8
9	/uploads/food_items/food_c7fb0fadc72747f1bedd9ea2507a6a60_SushiRamenCookingSakeTastingSetClassinTokyo!-KlookIndia.jpg	9
10	/uploads/food_items/food_4a7cce3a52934e8d8ae4e55749378f24_top-view-rice-with-carrot-cooked-with-lamb-served-with-yogurt-salad.jpg	10
11	/uploads/food_items/food_acee934584da466cbe1725d918dd52b2_gourmet-chicken-biryani-with-steamed-basmati-rice-generated-by-ai.jpg	11
12	/uploads/food_items/food_14a7d6c616be45588728006ebf813878_istockphoto-838927480-612x612.jpg	12
13	/uploads/food_items/food_008b6a299a204e8ba69e4088e3d16ec0_kerala-breakfast-food-appam-kadala-curry-kerala-india-appam-kerala-breakfast-food-kadala-curry-hot-spicy-chickpea-190408065.webp	13
14	/uploads/food_items/food_fbf66478aa244c1aa83b72e3e57122fe_cuisine-puttu-kadala-curry-1024-20250618081730882709.webp	14
\.


--
-- Data for Name: food_items; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.food_items (id, name, description, price, available, category_id) FROM stdin;
6	Lasagna	Layers of pasta, meat ragù, and béchamel/cheese sauce.	200	true	3
7	Penne Alfredo	Pasta in a rich, creamy butter and Parmesan sauce.	300	true	3
8	Coq au Vin	Chicken braised with wine, bacon, mushrooms, and garlic.	500	true	3
9	Sushi/Ramen	Cooked vinegar rice with seafood/Noodle soup with rich broth and toppings.	500	true	3
10	Beef Biriyani 	This Malabar variant is renowned for its use of short-grain, aromatic rice and a distinct, flavorful masala that relies less on chili powder and more on fresh ginger, garlic, and whole spices	200	true	4
11	Chicken Biriyani	This Malabar variant is renowned for its use of short-grain, aromatic rice and a distinct, flavorful masala that relies less on chili powder and more on fresh ginger, garlic, and whole spices	200	true	4
12	Kerla meals	this experience is often elevated with impeccable presentation, specialized regional recipes, and non-vegetarian options served alongside the traditional vegetarian spread	100	true	4
13	Appam Kadala Currry	The Appam (Palappam): This is the star—a delicate, lacy pancake made from a fermented batter of rice flour, coconut milk, and a touch of palm toddy (or yeast) for its distinct flavor.A rich and deeply flavored curry made from black chickpeas (kadala), cooked in a thick, fragrant gravy	100	true	5
14	Puttu Kadala	arm, earthy, and aromatic. The smell of steamed rice and fragrant coconut oil (mustard seed tempering) is comforting and instantly transports you to a traditional Kerala morning.	100	true	5
\.


--
-- Data for Name: food_order_items; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.food_order_items (id, order_id, food_item_id, quantity) FROM stdin;
9	9	9	1
10	9	7	1
\.


--
-- Data for Name: food_orders; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.food_orders (id, room_id, amount, assigned_employee_id, status, billing_status, created_at) FROM stdin;
9	7	800	1	completed	billed	2025-11-23 19:47:56.796722
\.


--
-- Data for Name: gallery; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.gallery (id, image_url, caption, is_active) FROM stdin;
6	/static/uploads/gallery_0059cb81ff044a868db69d33f9a357e5.jpg	Swimming pool	t
7	/static/uploads/gallery_9ffab41e5ae1431eb79bbbb4ae2060df.jpg	Cottages	t
8	/static/uploads/gallery_0d51d573b1464ca7b5be775a1503b53b.jpg	Restaurant	t
9	/static/uploads/gallery_252fcc0c4f164053861d48e8547be0a6.jpg	Hall	t
10	/static/uploads/gallery_7288925931c24f00ac94d47fce55ca43.jpg	Balcony 	t
\.


--
-- Data for Name: guest_suggestions; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.guest_suggestions (id, guest_name, contact_info, suggestion, status, created_at) FROM stdin;
\.


--
-- Data for Name: header_banner; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.header_banner (id, title, subtitle, image_url, is_active) FROM stdin;
7	Wild Where Luxury Meets	Pumma Holidays	/static/uploads/banner_04c3585aa867481d9b2678086eec5bf2.jpg	t
\.


--
-- Data for Name: leaves; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.leaves (id, employee_id, from_date, to_date, reason, leave_type, status) FROM stdin;
1	2	2025-11-16	2025-11-16	fever	Paid	pending
\.


--
-- Data for Name: nearby_attraction_banners; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.nearby_attraction_banners (id, title, subtitle, image_url, is_active, map_link) FROM stdin;
4	Pomma Holidays - Where Luxury Meets Wild	Tourist Places Near By\r\nPomma Holidays	/static/uploads/nearby_banner_42b6fc3ee2f04e5f8721066c1daba6ac.jpg	t	null
\.


--
-- Data for Name: nearby_attractions; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.nearby_attractions (id, title, description, image_url, is_active, map_link) FROM stdin;
6	Attractions near by Pommo Holidays	🏞️ Core Attractions & Natural Beauty\r\nTrekking & Peaks: The district is a trekker's haven. The most popular climb is Chembra Peak, the highest point in Wayanad, which features a natural, heart-shaped lake (Hridaya Saras) near the summit.\r\n\r\nWaterfalls: Wayanad is home to spectacular waterfalls like the three-tiered Soochipara Falls (Sentinel Rock Waterfalls) and the beautiful Meenmutty Falls, both requiring a jungle trek to reach.\r\n\r\nLakes & Dams: The largest earth dam in India, Banasura Sagar Dam, offers picturesque views and boating. The serene, perennial Pookode Lake, surrounded by thick forests, is another must-visit spot for a quiet nature experience.\r\n\r\nUnique Islands: Kuruva Island is a protected river delta on the Kabini River, known for its dense, uninhabited forests and unique biodiversity, perfect for nature walks and bird watching.\r\n\r\n🦁 Wildlife & Adventure\r\nWayanad is an integral part of the Nilgiri Biosphere Reserve and is a significant biodiversity hotspot.\r\n\r\nWayanad Wildlife Sanctuary (Muthanga & Tholpetty): These sanctuaries are home to a large population of elephants, as well as tigers, leopards, Indian Bison, and various species of deer and birds. Jeep safaris are popular here.\r\n\r\n🗿 History & Culture\r\nThe region is steeped in ancient history and has a strong tribal heritage.\r\n\r\nEdakkal Caves: This is the district's most significant historical site, featuring prehistoric rock engravings (pictographs) that date back over 6,000 years to the Neolithic era.\r\n\r\nAncient Temples: The Thirunelli Temple, an ancient Lord Vishnu shrine nestled in the Brahmagiri hills, is often called the 'Kashi of the South.'\r\n\r\nSpice & Tea Plantations: Wayanad is famous for its extensive plantations of coffee, tea, cardamom, pepper, and vanilla, offering visitors beautiful scenery and opportunities for plantation walks.\r\n\r\nIn essence, Wayanad offers a complete holiday experience—from the adrenaline rush of a mountain trek to the peace of a spice-scented forest, all against a backdrop of ancient geological and historical wonder.	/static/uploads/attraction_32ecc79dc2ca485f8b538f67475498b1.png	t	https://www.google.com/maps/search/wayanad+tourist+atractions/@11.6717679,76.2860728,12z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
7	Wayanad Tourist Itinerary	Wayanad Tourist Itinerary (3 Days)\r\nThis plan balances physical activity with relaxed sightseeing, with each day focusing on a different geographical zone of the district.\r\n\r\nDay 1: Peaks, Lakes, and Waterfalls (Kalpetta & Vythiri Region)\r\nThe first day is dedicated to the lush greenery and adventure spots near the district headquarters, Kalpetta.\r\n\r\nMorning (Adventure):\r\n\r\nStart early for a trek to Chembra Peak (the highest peak in Wayanad). The highlight is the heart-shaped lake, Hridaya Saras. Note: Trekking requires permission from the Forest Department and may take half a day.\r\n\r\nAlternative (If not trekking): Visit the majestic Soochipara Falls (Sentinel Rock Waterfalls). Enjoy the three-tiered waterfall after a short downhill trek.\r\n\r\nAfternoon (Nature & Views):\r\n\r\nRelax by the tranquil freshwater Pookode Lake. You can enjoy boating here (pedal boats are available) or a relaxing stroll around the perimeter.\r\n\r\nStop at the Lakkidi View Point, known as the gateway to Wayanad, for a panoramic view of the winding ghat road and the valleys below.\r\n\r\nEvening:\r\n\r\nCheck in to your hotel or homestay in the Kalpetta or Vythiri area.\r\n\r\nExplore a local spice or tea plantation walk near your accommodation.\r\n\r\nDay 2: History, Dams, and Views (Sulthan Bathery & Banasura Region)\r\nDay two focuses on prehistoric sites, man-made marvels, and eastern Wayanad.\r\n\r\nMorning (History & Climb):\r\n\r\nVisit the prehistoric Edakkal Caves on the Ambukuthi Hills. The site features ancient rock carvings and requires a climb (partially assisted by steps/railings) to reach the top.\r\n\r\nAfterward, explore the nearby town of Sulthan Bathery and its historical Jain Temple, which once served as an artillery battery for Tipu Sultan.\r\n\r\nAfternoon (Scenic Spot):\r\n\r\nHead to Banasura Sagar Dam, the largest earth dam in India. Enjoy the scenic reservoir, which is dotted with islands, and consider a boat ride or a mini-trek to the viewpoint.\r\n\r\nEvening:\r\n\r\nIf you have time, drive to Phantom Rock, a unique skull-shaped rock formation, for sunset views and photography before returning to your base.\r\n\r\nDay 3: Wildlife and Riverine Beauty (Mananthavady Region)\r\nThe final day takes you to the northern side, famous for its remote beauty and wildlife conservation efforts.\r\n\r\nMorning (Wildlife Safari):\r\n\r\nTake an early morning jeep safari at the Tholpetty Wildlife Sanctuary (or Muthanga Sanctuary) for the best chance of spotting elephants, deer, bison, and if lucky, a tiger or leopard.\r\n\r\nMid-Day (Nature Reserve):\r\n\r\nVisit Kuruva Island (Kuruvadweep). This protected, uninhabited river delta requires a bamboo raft crossing and is a wonderful place for a peaceful nature walk through the dense forest. Note: Kuruva Island has strict entry regulations and is closed during heavy monsoon or when the water level is too high.\r\n\r\nAfternoon (Spiritual Stop):\r\n\r\nVisit the ancient Thirunelli Temple, dedicated to Lord Vishnu, set amidst the Brahmagiri hills. It's a place of great natural beauty and spiritual significance.\r\n\r\nEvening:\r\n\r\nStart your journey back home.	/static/uploads/attraction_0618bab33415486384cfaf337b0a1d7e.png	t	https://www.google.com/maps/search/wayanad+tourist+atractions/@11.6717679,76.2860728,12z/data=!4m2!2m1!6e1?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
8	Muthanga Wildlife Sanctuary	In the heart of Kerala's lush embrace lies a sanctuary of untamed beauty and wild whispers – the Wayanad Wildlife Sanctuary.\r\n\r\nHere, amidst the verdant foliage and mist-kissed mountains, nature unveils its grandeur in a symphony of life. Here, amidst the dense forests and tranquil streams, elusive creatures find solace in their secluded havens.	/static/uploads/attraction_c24cf41f663448159276b484b2d37be3.jpg	t	https://www.google.com/maps/search/muthanga+wildlife+sanctuary/@11.6703451,76.3665063,17z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
9	Edakkal Cave	A trek up around 300 steps takes you to the Edakkal Caves. Despite the name, the place isn't really a cave, but more of a rock formation where a boulder wedged itself between two other boulders, creating an odd shelter like structure.\r\n\r\nThe name 'Edakkal' itself means 'Stone in between' in the Malayalam language, thus being appropriately named by the locals.	/static/uploads/attraction_c213b76829b148e2bd8297ae27769661.jpg	t	https://www.google.com/maps/place/Edakkal+Caves/@11.6268459,76.2294034,17z/data=!3m1!4b1!4m6!3m5!1s0x3ba60f22c50570e3:0xdb71297693a9e0df!8m2!3d11.6268407!4d76.234269!16s%2Fm%2F02pcdqs?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
10	Jain Temple	The temple's most famous historical anecdote is that it gave the modern town its name. Originally known as Ganapathi Vattam, the temple was used as an "ammunition battery" or storehouse for arms by the Mysore ruler Tipu Sultan during his invasion of the Malabar Coast in the 18th century. The English translation, "Sultan's Battery," eventually evolved into Sulthan Bathery.\r\n\r\n\r\nA Center of Change: Before becoming a military depot, the structure served several roles: it was a religious center during the peak of Jainism's influence in the 13th and 14th centuries, and later became a commercial center	/static/uploads/attraction_89d3fb91a2714bd5bca78dfd6a2f2a3d.jpg	t	https://www.google.com/maps/place/Jain+Temple,+Sulthan+Bathery/@11.6601715,76.248083,17z/data=!3m1!4b1!4m6!3m5!1s0x3ba608b91200a707:0x5bd3a9fcb48d4b0d!8m2!3d11.6601663!4d76.2506633!16s%2Fg%2F1thr5m10?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
11	Bandipur National Park and Tiger Reserve	Bandipur National Park and Tiger Reserve is a premier wildlife sanctuary located in the state of Karnataka, known for its significant populations of endangered species, including the Bengal Tiger and the Indian Elephant. It is a major component of the Nilgiri Biosphere Reserve.Bandipur is famous for its high density of wildlife, offering excellent sighting opportunities.\r\n\r\nMammals: Bengal Tiger, Asian Elephant, Indian Leopard, Gaur (Indian Bison), Dhole (Indian Wild Dog), Sloth Bear, Sambar Deer, Spotted Deer (Chital), and numerous primate species like Langurs and Macaques.\r\n\r\nBirds: Home to over 200 species, including the Indian Peafowl, Grey Junglefowl, various species of Vultures and Eagles, and the Malabar Pied Hornbill.\r\n\r\nReptiles: Species include the Indian Rock Python, King Cobra, and Monitor Lizards.	/static/uploads/attraction_300d842f110c4545bc5ec9778089b506.jpeg	t	https://www.google.com/maps/place/Bandipur+National+Park/@11.7787663,76.4621003,17z/data=!3m1!4b1!4m6!3m5!1s0x3ba8aaa8dde6363b:0x120624bbcf55937b!8m2!3d11.7787611!4d76.4646806!16zL20vMDNodzIx?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
12	Karapuzha Dam	The dam site has been extensively developed into a major tourism hub, often referred to as the Karapuzha Mega Tourism Project, which includes:\r\n\r\nKarapuzha Dam Adventure Park: This is the main attraction, featuring landscaped gardens and a wide range of thrilling activities.\r\n\r\nAdventure Activities: It is home to some major attractions, including the Longest Zipline in Kerala (stretching over 605 meters) and the South India's Biggest Giant Swing. Other rides include trampolines, space towers, flying chairs, and twisters.\r\n\r\n\r\nChildren's Park: A dedicated area with play equipment.\r\n\r\nScenic Views and Nature:\r\n\r\nBoating: Visitors can enjoy serene boat rides on the calm waters of the reservoir.\r\n\r\nGardens and Walkways: Beautifully maintained gardens (including a Rose Garden and bamboo park) and walkways provide perfect spots for leisurely strolls, picnics, and photography.\r\n\r\nWatchtower: A climb up the watchtower offers enchanting panoramic views of the dam, especially during sunset.\r\n\r\nBird Watching: The reservoir, with its calm waters and lush islands, is an ideal breeding ground and habitat, attracting a variety of aquatic and migratory birds.	/static/uploads/attraction_93de97c6480e4220aa1541bc8d2d18e3.jpg	t	https://www.google.com/maps/place/Karapuzha+Dam,+Kerala+673593/@11.6182165,76.1696349,17z/data=!3m1!4b1!4m6!3m5!1s0x3ba60c223345fd8f:0xa80b354b23984060!8m2!3d11.6182113!4d76.1722152!16s%2Fm%2F0rff9qj?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
13	Kanthanpara Waterfall 	Kanthanpara is a waterfall, dropping from a height of about 30 meters (100 feet), but it is prized for its serene and less-crowded atmosphere compared to other major falls in the area.\r\n\r\nEasy Access: One of the best features is its easy accessibility. It requires only a short and gentle walk from the nearest road, making it suitable for visitors of all ages, including families with children.\r\n\r\nSwimming & Wading: The pool at the base of the falls is shallow and safe for wading and a casual swim. Visitors frequently mention enjoying the cool, refreshing water.\r\n\r\nScenery: Surrounded by lush green bamboo gardens and tea plantations, the area offers excellent opportunities for photography and is a perfect spot for a relaxing picnic.\r\n\r\nActivities: You can enjoy soft trekking along the tea gardens, and the area is also noted as a good place for bird-watching.	/static/uploads/attraction_ef12f119ca954ec9b99dc76b97307cce.jpg	t	https://www.google.com/maps/place/Kanthanpara+Waterfalls/@11.5239348,76.1526896,17z/data=!3m1!4b1!4m6!3m5!1s0x3ba6727e18fa1623:0x5b1742bdde3e35ca!8m2!3d11.5239348!4d76.1526896!16s%2Fg%2F1wbfyvhd?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
14	Mudumalai Tiger Reserve (MTR)	The Mudumalai Tiger Reserve (MTR) is one of India's most important wildlife sanctuaries, situated at the unique tri-junction of three South Indian states: Tamil Nadu, Karnataka (where it borders Bandipur), and Kerala (where it borders Wayanad Wildlife Sanctuary).Flagship Species: The reserve is primarily known for its high population of Bengal Tigers and significant herds of Asian Elephants.\r\n\r\nBiodiversity Hotspot: It features diverse forest types, ranging from tropical evergreen to dry deciduous, supporting a rich variety of wildlife, including Indian Gaur (Bison), Leopards, Dhole (Wild Dog), Sambar Deer, and over 260 species of birds (8% of India's total bird species).\r\n\r\nThe Moyar River: This river flows through the reserve, acting as a vital lifeline for the wildlife, particularly during the dry season, and supporting unique flora and fauna.One of Mudumalai's most famous attractions is the Theppakadu Elephant Camp, one of Asia's oldest elephant camps.\r\n\r\nThe Elephant Whisperers: This camp gained international fame as the setting for the Oscar-winning documentary, The Elephant Whisperers.\r\n\r\nVisitor Opportunity: Visitors can watch the elephants being bathed, fed, and cared for, which is a key part of the eco-tourism program.\r\n\r\nFeeding Time: The evening feeding time, typically around 5:30 PM to 6:00 PM, is the most popular time for visitors.	/static/uploads/attraction_47d25481cf744bc39b0ed86a6650f20c.jpg	t	https://www.google.com/maps/place/Mudumalai+Tiger+Reserve/@11.5622819,76.5319418,17z/data=!3m1!4b1!4m6!3m5!1s0x3ba8a883ad22006b:0x95719e71c7f9c63!8m2!3d11.5622767!4d76.5345221!16zL20vMDhna2Rm?entry=ttu&g_ep=EgoyMDI1MTEwOS4wIKXMDSoASAFQAw%3D%3D
\.


--
-- Data for Name: package_booking_rooms; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.package_booking_rooms (id, package_booking_id, room_id) FROM stdin;
\.


--
-- Data for Name: package_bookings; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.package_bookings (id, package_id, user_id, guest_name, guest_email, guest_mobile, check_in, check_out, adults, children, id_card_image_url, guest_photo_url, status) FROM stdin;
\.


--
-- Data for Name: package_images; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.package_images (id, package_id, image_url) FROM stdin;
5	5	/uploads/packages/pkg_17f4c7a7f5234692adc84905d5357431_Ashaped.jpg
6	5	/uploads/packages/pkg_78f3eb3dafa741aeaafc097c63c56ee2_Ashapedinside.jpg
7	6	/uploads/packages/pkg_6ded5d6773354ba2b288300f90db2938_WhatsApp Image 2025-11-09 at 10.58.20.jpeg
8	7	/uploads/packages/pkg_3350119ebd454b13aa52ec0970886906_woman-taking-photo-morning-mist-phu-lang-ka-phayao-thailand.jpg
9	7	/uploads/packages/pkg_d5b67b8e28d3462e8e603f49e11242ca_backpacker-relaxing-hammock-with-view-sunset-mekong-river-laos.jpg
10	7	/uploads/packages/pkg_645faeb3e5244d4f884b568e912f3cb0_adnan-saifee-zmr9TeA7WjU-unsplash.jpg
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.packages (id, title, description, price, room_type, is_full_property, booking_type, room_types) FROM stdin;
5	Honey Moon (Couples Only)	Guaranteed stay in a premium, secluded villa (like the A-Frame cottage) with a private plunge pool and stunning views.\r\nDaily amenities include floral bed decoration, complimentary sparkling wine or juice upon arrival, and gourmet chocolates/fresh fruit baskets.\r\nIncludes at least one Private Candlelit Dinner (like the BBQ or a custom setup by the pool) and one Floating Breakfast served in the villa.A private, guided Sunset View Excursion or a scenic drive, often with a champagne picnic.A personalized welcome gift and a late check-out option (subject to availability).	10000	\N	f	room_type	Cottage
7	Adventure trekking with Pomma (₹5,000+ / Head)	Accommodation\t1 Night Stay at Pomma Holidays & Resorts or an affiliated homestay/farmhouse near Muthanga. This typically includes a Deluxe Room or a comfortable Family Room on a twin-sharing basis.\r\nFood & Meals\t1 Breakfast, 1 Dinner, and 1 Lunch (MAP Plan) or sometimes a full board (AP Plan). Meals would feature local Kerala and South Indian cuisine.\r\nVehicle / Transport\tDedicated vehicle (e.g., private AC cab or tourist tempo traveler for groups) for sightseeing and transfers as per the itinerary. Note: Pick-up and drop-off from a central point like Sulthan Bathery or Calicut might be included, or charged separately.\r\nAdventure & Activities\t\r\nThe core of the package, focusing on the Muthanga region:\r\n\r\n\r\n• Muthanga Wildlife Sanctuary: Entry to the sanctuary and the core Jeep Safari (mandatory vehicle for forest entry).\r\n\r\n\r\n• Trekking/Nature Walk: A guided nature walk or short trekking activity (e.g., to a nearby viewpoint or plantation).\r\n\r\n\r\n• Evening Activity: Campfire/Bonfire with light music (often on request).\r\n\r\nSightseeing (General)\t\r\nVisit to other popular nearby spots such as:\r\n\r\n\r\n• Edakkal Caves (Trekking/climbing)\r\n\r\n\r\n• Karappuzha Dam or Banasura Sagar Dam (Boating usually extra)\r\n\r\n\r\n• Soochipara Waterfalls (Seasonal - trekking access)\r\n\r\nExclusions\tEntrance Fees to all tourist spots (sanctuary, caves, dams), Boating charges, and Lunch (if only MAP plan is provided).	5000	AC Double Room with Balcony	f	room_type	AC Double Room with Balcony
6	Whole Property (Private Function)	A whole property private function booking (or exclusive resort buyout) means you secure the entire resort, or a dedicated and secluded part of it, for your exclusive use. This ensures maximum privacy and gives you control over the experience.\r\n\r\nKey Features You Can Expect:\r\nExclusive Use & Privacy: Your group is the only group staying on-site. You get private access to amenities like the spa, thermal pools, restaurants, and common areas without interruption from other guests.\r\n\r\nCustomized Itinerary: You gain the flexibility to set your own schedule for meals, activities, and facility use. This is crucial for events like weddings, retreats, or large family reunions.\r\n\r\nPersonalized Service: The resort assigns a dedicated events or group coordinator and staff to cater only to your party, allowing for highly customized menus, bar service, and theme décor.\r\n\r\nIdeal for: Large-scale private celebrations, destination weddings, major corporate retreats, and film/photo shoots requiring discretion.	15000	\N	t	whole_property	\N
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.payments (id, booking_id, amount, method, status, created_at) FROM stdin;
\.


--
-- Data for Name: plan_weddings; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.plan_weddings (id, title, description, image_url, is_active) FROM stdin;
3	Plan Your Party	Contact us :+(91) 8848 079 307	/static/uploads/wedding_581fa5a4be77408ea9cd123f44a4ed2a.jpg	t
\.


--
-- Data for Name: resort_info; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.resort_info (id, name, address, facebook, instagram, twitter, linkedin, is_active) FROM stdin;
1	Pomma Holidays Resort	Auro Beach Road, Puducherry, India	https://www.facebook.com/pommaholidays	https://www.instagram.com/pommaholidays	https://twitter.com/pommaholidays	https://www.linkedin.com/company/pommaholidays	t
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.reviews (id, name, comment, rating, is_active) FROM stdin;
1	Trisha Raman	Exceptional hospitality! The team customised our anniversary getaway flawlessly.	5	t
2	Deepak Varma	Loved the coastal cuisine tasting menu and evening live music.	4	t
3	Elena Mathew	The Ayurvedic wellness consultation was a highlight of my stay.	5	t
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.roles (id, name, permissions) FROM stdin;
1	admin	["/dashboard", "/account", "/bookings", "/rooms", "/services", "/food-orders", "/employee", "/roles", "/expenses", "/food-categories", "/billing", "/Userfrontend_data", "/package", "/report", "/guestprofiles"]
2	guest	[]
3	Manager	["/dashboard","/account","/bookings","/rooms","/Userfrontend_data","/roles","/employee","/billing","/guestprofiles","/report","/food-categories","/food-orders","/services","/expenses","/package"]
4	frontdesk	["/dashboard","/account","/bookings","/rooms","/services","/food-orders","/food-categories","/billing","/expenses","/package","/guestprofiles"]
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.rooms (id, number, type, price, status, image_url, adults, children, features, air_conditioning, wifi, bathroom, living_area, terrace, parking, kitchen, family_room, bbq, garden, dining, breakfast) FROM stdin;
5	001	Cottage	6000	Available	/static/rooms/room_516ee24b9dd441ce989a908fcc12558d.jpg	2	2	["Air Conditioning", "Free Wifi", "Private Bathroom", "Living Room", "Terrace", "Free Parking", "Kitchen", "Family Room", "BBQ", "Garden", "Dining Area", "Breakfast"]	t	t	t	t	t	t	t	t	t	t	t	t
6	002	AC Double Room with Balcony	2800	Available	/static/rooms/room_e9eff384e5d4470eba3e1fc6562eb377.jpg	2	2	["Air Conditioning", "Free Wifi", "Private Bathroom", "Living Room", "Terrace", "Free Parking", "Kitchen", "Family Room", "BBQ", "Garden", "Dining Area", "Breakfast"]	f	f	f	f	f	f	f	f	f	f	f	f
7	003	Non AC Double Room	1900	Available	/static/rooms/room_8020786d933b441790bcb14a9d061a89.jpg	2	2	["Air Conditioning", "Free Wifi", "Private Bathroom", "Living Room", "Terrace", "Free Parking", "Kitchen", "Family Room", "BBQ", "Garden", "Dining Area", "Breakfast"]	f	f	f	f	f	f	f	f	f	f	f	f
8	004	Twin Bed Room 	1500	Available	/static/rooms/room_06c3c403612d471582a666f353c7d841.jpg	2	2	["Air Conditioning", "Free Wifi", "Private Bathroom", "Living Room", "Terrace", "Free Parking", "Kitchen", "Family Room", "BBQ", "Garden", "Dining Area", "Breakfast"]	f	f	f	f	f	f	f	f	f	f	f	f
9	005	Cottage	6000	Available	/static/rooms/room_91b877e2c83d4abf905a0aaa7af85029.jpg	2	2	["Air Conditioning", "Free Wifi", "Private Bathroom", "Living Room", "Terrace", "Free Parking", "Kitchen", "Family Room", "BBQ", "Garden", "Dining Area", "Breakfast"]	f	f	f	f	f	f	f	f	f	f	f	f
\.


--
-- Data for Name: service_images; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.service_images (id, service_id, image_url) FROM stdin;
3	3	/uploads/services/svc_2016a3769af846d39b45f9bea81361cd__3ST7214 (1).jpg
4	4	/uploads/services/svc_e9d517b66f274d4f93f3f257eaded729_pexels-minan1398-1482803.jpg
5	5	/uploads/services/svc_4fe06221a1f94607b797f0b992b10b3a_DA4_0089_06-04-17-Freshkills-Discovery-e1561391355527.jpg
6	6	/uploads/services/svc_fc89bbadcbae4074bc4b8b1d72223600_women-meditating-nature-front-view-1-1024x554.jpg
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.services (id, name, description, charges, created_at) FROM stdin;
3	The Infinity Edge & Rainforest Plunge	This is a spectacular infinity-edge pool (or private plunge pool) where the water meets the horizon, creating the illusion of merging directly with the misty mountains, the tea gardens, or the forest canopy. The pool is often made of deep blue or dark stone tiles, reflecting the sky and the surrounding greenery	0	2025-11-11 10:48:44.804288
4	The Private Starry Skies BBQ	A dedicated resort chef and server will set up a compact, professional grill station on your deck. You choose between a Chef-Guided BBQ (where the chef handles all the grilling) or a Grill-Your-Own experience (where the chef prepares the cuts and marinades, and you enjoy the fun of cooking together, with assistance available).	1000	2025-11-11 10:51:35.272812
5	Guided Nature Walks	Gentle treks through the surrounding forests or plantations, focusing on identifying endemic flora and fauna, led by a local naturalist	0	2025-11-11 10:57:53.242136
6	Yoga & Meditation	Personalized programs based on the ancient practice of Ayurveda, which aims to harmonize the mind, body, and spirit.	0	2025-11-11 10:59:21.989672
\.


--
-- Data for Name: signature_experiences; Type: TABLE DATA; Schema: public; Owner: resort_user
--

COPY public.signature_experiences (id, title, description, image_url, is_active) FROM stdin;
4	Party 	A private guided tour or workshop reflecting the destination, like an interactive mixology masterclass with the head bartender, a hands-on local cooking class, or a behind-the-scenes wine cellar tasting	/static/uploads/sigexp_1a3d958bc5e043118098387a59eec8d5.webp	t
5	Alpine Vista A-Frame	An architecturally stunning A-Frame cabin defined by a dramatic, steeply pitched roof that flows almost to the ground. The most luxurious versions feature a floor-to-ceiling glass facade, often two stories high, that perfectly frames the exterior view. The interiors are finished with warm, local wood and minimalist, chic decor	/static/uploads/sigexp_d748157c31af491694ba973bd471919e.jpg	t
6	The Infinity Edge & Rainforest Plunge	This is a spectacular infinity-edge pool (or private plunge pool) where the water meets the horizon, creating the illusion of merging directly with the misty mountains, the tea gardens, or the forest canopy. The pool is often made of deep blue or dark stone tiles, reflecting the sky and the surrounding greenery	/static/uploads/sigexp_86685b47e30e4edf9bcc793447f42d05.jpg	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.users (id, name, email, hashed_password, phone, is_active, role_id) FROM stdin;
1	Pomma Admin	pomma@teqmates.com	$2b$12$CgqFaEddmV9HBy2rpKS3a.l737nez6WsfKpcVoMZuA7Z/O1mH0.8i	\N	t	1
2	Sunil Jose	sunil.sjk@gmail.com	$2b$12$xWyvJ/OPEZztS3k84v4nYOP/wMDwQWadMY3pFeOnpAqn6mpRqjLOe	07022123123	t	2
5	Dayon Mathew	a@teqmates.com	$2b$12$UkF0TU/Ibm33TmR/2pdBy.gwCVBzzTn1t/CMoYuZ1.xofkBJPo9hO	1234567890	t	3
6	basil	admin@teqmates.com	$2b$12$MbM6qIKPMYrvLQy0g6S8je6u8LmpQNhieHii1C5SFbxewMy4spFG2	90890987	t	3
9	Julie mathew	julie@Gmail.com	$2b$12$q8HN0MpoBYkv85rDzZFLtOtZxcHrGygd7Ooe3Dq7VGXIeOy8C7h0q	5879182091-	t	2
10	anusha	anusha@gmail.con	$2b$12$UiCBD/MfScKVKn94p.aeI.uuyWoQMj14r/CY3q1wfEm5x5d52OWxC	797917310	t	2
11	diya	diya@gmail.com	$2b$12$NKzkF6OyT1aoUwRHkGj9rOduTjP/8khkwtMk5z6u0ZoTNvEzSf0MG	738290229	t	2
12	alpi	alpi@gmail.com	$2b$12$ZNUAmdc6S/ahh8qM.zdl0uVS8WMJQxx/ExMpZMu4h21q8AqZrRhai	345678902	t	2
13	alphi	alphi@teqmates.com	$2b$12$k7nYQgBnlMJALrmILnmawe.isxqESoaq.RAVaABvA9cl4pTrwf0Ba	\N	t	4
14	ebil	ebil@teqmates.com	$2b$12$053KqoFxjR0e/mpd7tjRV.BMHxEKe4X5gKx3l5iv.Vl7Su7gtga0u	\N	t	3
15	Basil Abraham	basilabraham44@gmail.com	$2b$12$m7q6BzYlkR8ljUMRFtWszOXI0RubM3qv.YkRxl4m/G8xQKe2GYoaC	09605620416	t	2
16	dayon	admin@example.com	$2b$12$aPbfAcUe9E1g0Jr5FWnHY.BgEmv.vBRiKULx4h2UZUsYpZwVRVwfy	90909090	t	2
17	Anusha John	anushajohn119@gmail.com	$2b$12$/Y4ZWb0YPwSgGZ8PtDSk8Oy4kMt3IjkuQf30ZGISvO48ZP8HYxLeW	8078348516	t	2
18	dency	sa@gmail.com	$2b$12$48mRgCoSGTW0Saijr0CRX.VsaRv92nVcYo5/1/ij0nqiAm16ynSQ6	7890-0987654	t	2
19	Dayon Mathew	anish@gmail.com	$2b$12$V7zW3qY9B.LUZr/jiiKGietqryR2oTV41tHOEGYgS/Hfii09dIRxe	45678902222	t	2
8	basil	basil@gmail.com	$2b$12$xij7jClooOCZowMJAGOKLe1odx4xUzbDgR7UkcNf6Bw51CVOnPVK2	9912567865	t	2
7	kittu	kittu@gmail.com	$2b$12$FdykJCZZmWv2IwvEoKUoM.68lKrInUbx5WtiyLNYJ3UudGUEBQ7.G	4567890	t	2
20	Kunju	kunju@gmail.com	$2b$12$qDrHG2pjW5cYzrgB7O3NLen6Z5gOkGos1HWFvkcrZhcE0uRtFwdGK	90890887788	t	2
4	Daion Mathew	mathew@gmail.com	$2b$12$nc42rmFFxGoqTrTdxwpSe.R50BKUGkiQ2pbHeKawIqngYacXfRtC2	9961239861	t	2
21	Subin	subin@gmail.com	$2b$12$uBZkiTceFGCvRzM3KM0xXubr9Pjs0edp/pqc/y3NzXXyKNHYjciHy	8281111352	t	2
22	anusha	anush@gmail.com	$2b$12$Wy0dsrB2rsNCeIQQqbb9ueDZxjiB3M0GIIUNKEA00XS0Cwb/i6ndG	62662167	t	2
3	Dayon Mathew	arjun@gmail.com	$2b$12$3IBOaB49et5DOj/z3xdoeeSBPu3S.PoautNIaySWbLNU6S1wVox/O	99934567890	t	2
23	alphi	alphi@gmail.com	$2b$12$j5Xe7ZK4439zu/5pY0es1ebkMuFUsHm05UuKsdkVFYNYPtkaJl8G6	8281837820	t	2
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.vouchers (id, code, discount_percent, expiry_date) FROM stdin;
\.


--
-- Data for Name: working_logs; Type: TABLE DATA; Schema: public; Owner: pomma
--

COPY public.working_logs (id, employee_id, date, check_in_time, check_out_time, location) FROM stdin;
1	2	2025-11-14	09:51:06.10534	14:04:54.130945	Office
2	2	2025-11-16	14:06:50.92252	05:26:53.341371	Office
4	2	2025-11-16	05:26:03.026323	05:27:13.357243	Office
3	1	2025-11-17	14:07:05.025597	13:43:14.911774	Office
5	1	2025-11-17	05:27:30.440442	17:09:38.227512	Office
6	1	2025-11-17	17:09:43.375702	17:09:45.185038	Office
\.


--
-- Name: assigned_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.assigned_services_id_seq', 9, true);


--
-- Name: attendances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.attendances_id_seq', 1, false);


--
-- Name: booking_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.booking_rooms_id_seq', 19, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.bookings_id_seq', 18, true);


--
-- Name: check_availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.check_availability_id_seq', 1, false);


--
-- Name: checkouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.checkouts_id_seq', 8, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.employees_id_seq', 4, true);


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.expenses_id_seq', 1, true);


--
-- Name: food_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.food_categories_id_seq', 5, true);


--
-- Name: food_item_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.food_item_images_id_seq', 14, true);


--
-- Name: food_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.food_items_id_seq', 14, true);


--
-- Name: food_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.food_order_items_id_seq', 10, true);


--
-- Name: food_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.food_orders_id_seq', 9, true);


--
-- Name: gallery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.gallery_id_seq', 10, true);


--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.guest_suggestions_id_seq', 1, false);


--
-- Name: header_banner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.header_banner_id_seq', 7, true);


--
-- Name: leaves_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.leaves_id_seq', 1, true);


--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.nearby_attraction_banners_id_seq', 4, true);


--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.nearby_attractions_id_seq', 14, true);


--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.package_booking_rooms_id_seq', 34, true);


--
-- Name: package_bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.package_bookings_id_seq', 19, true);


--
-- Name: package_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.package_images_id_seq', 11, true);


--
-- Name: packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.packages_id_seq', 8, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Name: plan_weddings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.plan_weddings_id_seq', 3, true);


--
-- Name: resort_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.resort_info_id_seq', 1, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.reviews_id_seq', 3, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.rooms_id_seq', 9, true);


--
-- Name: service_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.service_images_id_seq', 6, true);


--
-- Name: services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.services_id_seq', 6, true);


--
-- Name: signature_experiences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resort_user
--

SELECT pg_catalog.setval('public.signature_experiences_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.users_id_seq', 23, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.vouchers_id_seq', 1, false);


--
-- Name: working_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pomma
--

SELECT pg_catalog.setval('public.working_logs_id_seq', 6, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: assigned_services assigned_services_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_pkey PRIMARY KEY (id);


--
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: booking_rooms booking_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: check_availability check_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.check_availability
    ADD CONSTRAINT check_availability_pkey PRIMARY KEY (id);


--
-- Name: checkouts checkouts_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_booking_id_key UNIQUE (booking_id);


--
-- Name: checkouts checkouts_package_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_package_booking_id_key UNIQUE (package_booking_id);


--
-- Name: checkouts checkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: employees employees_user_id_key; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_key UNIQUE (user_id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: food_categories food_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.food_categories
    ADD CONSTRAINT food_categories_pkey PRIMARY KEY (id);


--
-- Name: food_item_images food_item_images_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.food_item_images
    ADD CONSTRAINT food_item_images_pkey PRIMARY KEY (id);


--
-- Name: food_items food_items_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.food_items
    ADD CONSTRAINT food_items_pkey PRIMARY KEY (id);


--
-- Name: food_order_items food_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_pkey PRIMARY KEY (id);


--
-- Name: food_orders food_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_pkey PRIMARY KEY (id);


--
-- Name: gallery gallery_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.gallery
    ADD CONSTRAINT gallery_pkey PRIMARY KEY (id);


--
-- Name: guest_suggestions guest_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.guest_suggestions
    ADD CONSTRAINT guest_suggestions_pkey PRIMARY KEY (id);


--
-- Name: header_banner header_banner_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.header_banner
    ADD CONSTRAINT header_banner_pkey PRIMARY KEY (id);


--
-- Name: leaves leaves_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_pkey PRIMARY KEY (id);


--
-- Name: nearby_attraction_banners nearby_attraction_banners_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.nearby_attraction_banners
    ADD CONSTRAINT nearby_attraction_banners_pkey PRIMARY KEY (id);


--
-- Name: nearby_attractions nearby_attractions_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.nearby_attractions
    ADD CONSTRAINT nearby_attractions_pkey PRIMARY KEY (id);


--
-- Name: package_booking_rooms package_booking_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_pkey PRIMARY KEY (id);


--
-- Name: package_bookings package_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_pkey PRIMARY KEY (id);


--
-- Name: package_images package_images_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.package_images
    ADD CONSTRAINT package_images_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: plan_weddings plan_weddings_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.plan_weddings
    ADD CONSTRAINT plan_weddings_pkey PRIMARY KEY (id);


--
-- Name: resort_info resort_info_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.resort_info
    ADD CONSTRAINT resort_info_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_number_key; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_number_key UNIQUE (number);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: service_images service_images_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.service_images
    ADD CONSTRAINT service_images_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: signature_experiences signature_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.signature_experiences
    ADD CONSTRAINT signature_experiences_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_code_key; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_code_key UNIQUE (code);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (id);


--
-- Name: working_logs working_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.working_logs
    ADD CONSTRAINT working_logs_pkey PRIMARY KEY (id);


--
-- Name: ix_assigned_services_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_assigned_services_id ON public.assigned_services USING btree (id);


--
-- Name: ix_attendances_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_attendances_id ON public.attendances USING btree (id);


--
-- Name: ix_booking_rooms_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_booking_rooms_id ON public.booking_rooms USING btree (id);


--
-- Name: ix_bookings_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_bookings_id ON public.bookings USING btree (id);


--
-- Name: ix_check_availability_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_check_availability_id ON public.check_availability USING btree (id);


--
-- Name: ix_checkouts_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_checkouts_id ON public.checkouts USING btree (id);


--
-- Name: ix_employees_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_employees_id ON public.employees USING btree (id);


--
-- Name: ix_expenses_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_expenses_id ON public.expenses USING btree (id);


--
-- Name: ix_food_categories_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_food_categories_id ON public.food_categories USING btree (id);


--
-- Name: ix_food_item_images_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_food_item_images_id ON public.food_item_images USING btree (id);


--
-- Name: ix_food_items_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_food_items_id ON public.food_items USING btree (id);


--
-- Name: ix_food_order_items_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_food_order_items_id ON public.food_order_items USING btree (id);


--
-- Name: ix_food_orders_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_food_orders_id ON public.food_orders USING btree (id);


--
-- Name: ix_gallery_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_gallery_id ON public.gallery USING btree (id);


--
-- Name: ix_guest_suggestions_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_guest_suggestions_id ON public.guest_suggestions USING btree (id);


--
-- Name: ix_header_banner_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_header_banner_id ON public.header_banner USING btree (id);


--
-- Name: ix_leaves_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_leaves_id ON public.leaves USING btree (id);


--
-- Name: ix_nearby_attraction_banners_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_nearby_attraction_banners_id ON public.nearby_attraction_banners USING btree (id);


--
-- Name: ix_nearby_attractions_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_nearby_attractions_id ON public.nearby_attractions USING btree (id);


--
-- Name: ix_package_booking_rooms_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_package_booking_rooms_id ON public.package_booking_rooms USING btree (id);


--
-- Name: ix_package_bookings_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_package_bookings_id ON public.package_bookings USING btree (id);


--
-- Name: ix_package_images_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_package_images_id ON public.package_images USING btree (id);


--
-- Name: ix_packages_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_packages_id ON public.packages USING btree (id);


--
-- Name: ix_payments_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_payments_id ON public.payments USING btree (id);


--
-- Name: ix_plan_weddings_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_plan_weddings_id ON public.plan_weddings USING btree (id);


--
-- Name: ix_resort_info_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_resort_info_id ON public.resort_info USING btree (id);


--
-- Name: ix_reviews_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_reviews_id ON public.reviews USING btree (id);


--
-- Name: ix_roles_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_roles_id ON public.roles USING btree (id);


--
-- Name: ix_rooms_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_rooms_id ON public.rooms USING btree (id);


--
-- Name: ix_service_images_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_service_images_id ON public.service_images USING btree (id);


--
-- Name: ix_services_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_services_id ON public.services USING btree (id);


--
-- Name: ix_signature_experiences_id; Type: INDEX; Schema: public; Owner: resort_user
--

CREATE INDEX ix_signature_experiences_id ON public.signature_experiences USING btree (id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: pomma
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_vouchers_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_vouchers_id ON public.vouchers USING btree (id);


--
-- Name: ix_working_logs_id; Type: INDEX; Schema: public; Owner: pomma
--

CREATE INDEX ix_working_logs_id ON public.working_logs USING btree (id);


--
-- Name: assigned_services assigned_services_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: assigned_services assigned_services_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: assigned_services assigned_services_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: attendances attendances_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: booking_rooms booking_rooms_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: booking_rooms booking_rooms_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: checkouts checkouts_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: checkouts checkouts_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id);


--
-- Name: employees employees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: expenses expenses_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: food_item_images food_item_images_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.food_item_images
    ADD CONSTRAINT food_item_images_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.food_items(id);


--
-- Name: food_items food_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.food_items
    ADD CONSTRAINT food_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.food_categories(id);


--
-- Name: food_order_items food_order_items_food_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_food_item_id_fkey FOREIGN KEY (food_item_id) REFERENCES public.food_items(id);


--
-- Name: food_order_items food_order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.food_orders(id);


--
-- Name: food_orders food_orders_assigned_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_assigned_employee_id_fkey FOREIGN KEY (assigned_employee_id) REFERENCES public.employees(id);


--
-- Name: food_orders food_orders_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: leaves leaves_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: package_booking_rooms package_booking_rooms_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id) ON DELETE CASCADE;


--
-- Name: package_booking_rooms package_booking_rooms_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: package_bookings package_bookings_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id) ON DELETE CASCADE;


--
-- Name: package_bookings package_bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: package_images package_images_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.package_images
    ADD CONSTRAINT package_images_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id) ON DELETE CASCADE;


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: service_images service_images_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resort_user
--

ALTER TABLE ONLY public.service_images
    ADD CONSTRAINT service_images_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: working_logs working_logs_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pomma
--

ALTER TABLE ONLY public.working_logs
    ADD CONSTRAINT working_logs_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- PostgreSQL database dump complete
--

\unrestrict ksVezUUfvlSSW18KbqywD7L0VuGOrIQ3eOS5UJ1EzW36BzxaLf8fbmRRXQQczQ9

