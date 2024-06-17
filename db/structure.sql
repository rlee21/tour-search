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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tours (
    id bigint NOT NULL,
    external_id character varying NOT NULL,
    name character varying NOT NULL,
    days integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    start_city character varying NOT NULL,
    end_city character varying NOT NULL,
    seats_available integer,
    seats_booked integer,
    seats_maximum integer,
    status integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tours_id_seq OWNED BY public.tours.id;


--
-- Name: tours id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tours ALTER COLUMN id SET DEFAULT nextval('public.tours_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tours tours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tours
    ADD CONSTRAINT tours_pkey PRIMARY KEY (id);


--
-- Name: index_tours_on_days; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tours_on_days ON public.tours USING btree (days);


--
-- Name: index_tours_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tours_on_name ON public.tours USING btree (name);


--
-- Name: index_tours_on_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tours_on_start_date ON public.tours USING btree (start_date);


--
-- Name: index_tours_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tours_on_status ON public.tours USING btree (status);


--
-- Name: unique_external_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_external_ids ON public.tours USING btree (external_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240617175722'),
('20240606190355');

