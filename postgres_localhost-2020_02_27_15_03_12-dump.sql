--
-- PostgreSQL database dump
--

-- Dumped from database version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)

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
-- Name: aidus; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE aidus WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'ru_RU.UTF-8' LC_CTYPE = 'ru_RU.UTF-8';


ALTER DATABASE aidus OWNER TO postgres;

\connect aidus

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: event_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.event_type AS ENUM (
    'opened',
    'accepted',
    'redirect',
    'fix_used',
    'closed',
    'declined'
);


ALTER TYPE public.event_type OWNER TO postgres;

--
-- Name: severity; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.severity AS ENUM (
    'low',
    'medium',
    'high'
);


ALTER TYPE public.severity OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    login text NOT NULL,
    name text,
    surname text,
    patronymic text,
    is_admin boolean,
    password text,
    group_id integer NOT NULL,
    fcm_token text
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id uuid NOT NULL,
    issue_id uuid NOT NULL,
    owner_id bigint NOT NULL,
    type public.event_type NOT NULL,
    info text,
    date_time timestamp with time zone NOT NULL
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issues (
    id uuid NOT NULL,
    title text NOT NULL,
    service_id uuid NOT NULL,
    severity public.severity NOT NULL,
    labels jsonb
);


ALTER TABLE public.issues OWNER TO postgres;

--
-- Name: parent_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parent_services (
    id uuid NOT NULL,
    url text NOT NULL
);


ALTER TABLE public.parent_services OWNER TO postgres;

--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id uuid NOT NULL,
    group_id integer NOT NULL,
    parent_service_id uuid
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (id, login, name, surname, patronymic, is_admin, password, group_id, fcm_token) FROM stdin;
10	frosreroto	Мария	Кравченко		f	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	10	\N
11	tyrer	Максим	Егороков	Алексеевич	t	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	10	\N
14	nonoko	Петр	Обухов		f	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	11	\N
17	oloptu	Дарья	Ховатова		f	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	13	\N
18	zasrew	Алексей	Куровпатов		t	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	13	\N
19	balog	Татьяна	Гошинко		t	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	14	\N
20	urequ	Руслан	Горшков		f	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	14	\N
16	niegk	Федор	Щавелев		f	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	12	\N
1	admin				t	$2a$10$7mR.gCU1c6gQ.y8tyrHabu9O/PgaDh.lT0TL.mRE/imszvd85VIlC	1	\N
13	ionolo	Евгения	Гормова	Петровна	t	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	11	\N
15	retumer	Валентина	Котикова		t	$2a$10$GpYQM2xNf2KHRGNJE056rugAjIrSb2pFpmOuuoounfQifCu.yQgwm	12	\N
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, issue_id, owner_id, type, info, date_time) FROM stdin;
747fdc86-d9d9-401e-bd99-50b3324658ad	a7a9d3e6-0f84-4c41-a5ad-621b62d978fc	11	opened	Very important redis container down	2020-02-26 23:47:56.393207+03
7bc726bb-4c1c-48bc-ac30-ea0ef8da5da9	4741bcfe-d8d0-4e25-9d64-5c6ccedca00c	11	opened	Very important lookker container down	2020-02-26 23:51:03.658228+03
f47a0719-d151-43bd-8818-281e0e7c2222	df166907-311e-40f3-ae30-3b5eb1d12e98	11	opened	Very important other container down	2020-02-26 23:52:22.007099+03
6656da93-f9c0-4615-b3c4-c40d9761b360	a79a862f-9001-43b6-9e0b-9d6376a6a04a	11	opened	Very important other container down	2020-02-27 14:22:17.028597+03
2afddc40-6e7f-4452-837e-f39d7c7dcd3a	d6251fbc-f78c-4ca3-8604-af2dec9e2605	11	opened	Very important other container down	2020-02-27 14:26:21.151082+03
f4e2898d-d5a5-435c-a58f-c64a520e970d	c1adea84-caed-483e-9a2b-54e54f813052	11	opened	Very important other container down	2020-02-27 14:30:15.414417+03
450d7d4a-8c5d-46ed-ba11-fa7a425e22d0	7b948a52-992f-4928-80aa-de57b89a15d1	11	opened	Very important other container down	2020-02-27 14:30:25.501388+03
30563c3e-bd29-4491-af5e-121eff0d1c79	dd908684-346c-4110-8d4a-1e65f11e39d5	11	opened	Very important other container down	2020-02-27 14:30:26.056663+03
c5bd40f9-80bc-499f-be2e-a5a812d29c8c	42d4fda8-82a9-4b89-9041-7be5851f8f39	11	opened	Very important other container down	2020-02-27 14:30:26.781791+03
743e26a4-9895-48ab-9497-90c8bbe32b43	4220ef41-cf71-405a-b34d-65993640446b	11	opened	Very important other container down	2020-02-27 14:30:27.374672+03
7b2249b0-02f9-4462-85f4-bbdbac530756	1cad9a71-691a-4554-bd73-09a8b9f01bee	11	opened	Very important other container down	2020-02-27 14:30:28.118015+03
10e2c076-0d24-4586-9982-f323257b15ba	4ee71193-8cd0-4aaa-b5ff-a420b82c1d9a	11	opened	Very important other container down	2020-02-27 14:30:28.826019+03
b885b856-1a5b-4e40-a6ea-b7f08aad67ef	77d64260-d83d-4df7-bbec-6296c0ac00e5	12	opened	Very important other container down	2020-02-27 14:31:46.986405+03
b02f0068-e857-4149-91eb-c127cbddad3e	a50e3ea1-cb6e-423b-b6aa-c2bd58c2b462	12	opened	Very important other container down	2020-02-27 14:31:47.52707+03
ef73a740-25b2-46cc-91c6-451dd16ae37f	91ade438-8ecf-46dd-adab-d9c0c59b9171	12	opened	Very important other container down	2020-02-27 14:31:48.576893+03
0fba588b-da09-4f39-88d5-c171285638e6	606ea2da-9de0-4d4a-8019-a0f8d9857869	12	opened	Very important other container down	2020-02-27 14:31:49.288035+03
b67ddfbd-4b48-4fdc-a376-a580ff6ac14d	59ad2b99-fad5-4d45-86c5-3a04f8ad7c19	12	opened	Very important other container down	2020-02-27 14:31:50.11574+03
9775ca5c-27d4-4c44-b204-f137e041d165	8e7d4086-dac5-4cb2-979d-3b8ab064205d	12	opened	Very important other container down	2020-02-27 14:31:51.145466+03
3fb1a98c-6910-4f72-85b1-64016e5399e9	e8a4dd69-3aea-48e7-98d7-0ca86af666dc	12	opened	Very important other container down	2020-02-27 14:31:52.101404+03
3af1a695-959d-4722-875e-315889c1ac73	afcd36a9-adc2-49e3-85c0-5c088a524b0c	12	opened	Very important other container down	2020-02-27 14:31:54.915625+03
12e9816c-0748-4687-9035-77e8b1ed7531	9b9780e8-845f-44b3-a0da-310b79d155f0	12	opened	Very important other container down	2020-02-27 14:31:55.688572+03
bee299a1-bff9-4457-9c85-5ac14d0857bd	11f793b4-5201-4fdb-bdf3-1251bbc686da	12	opened	Very important other container down	2020-02-27 14:31:56.327585+03
b64686d6-81c1-4cea-a308-fac699d69092	0851856e-24b4-4690-afec-32eabf58d111	12	opened	Very important other container down	2020-02-27 14:31:57.131892+03
5a7314ff-8d1c-4bca-9e0e-6149c02a2cc2	8f2187bc-a033-44f9-bbe5-9fc5f3a27ab9	12	opened	Very important other container down	2020-02-27 14:31:57.822762+03
3bf44523-8865-4184-9112-2539df85341b	d93d1a2c-29cd-490e-b7f2-3f77935c9248	12	opened	Very important other container down	2020-02-27 14:31:58.759579+03
54afc55f-a270-46cf-8d7a-416eb498a833	bcbd76f9-c0e6-48c7-a0cd-a33f8a526194	12	opened	Very important other container down	2020-02-27 14:31:59.665095+03
ba59ef56-8345-4e8c-901a-14ef813a046e	9ab8c0a4-9419-4f28-a665-bed404ff3d9b	11	opened	Very important other container down	2020-02-27 14:37:09.920541+03
6783e0fa-766e-40af-8e34-37a260261304	4ec508d0-3540-46f2-9621-7a0b52ed28a8	11	opened	Very important other container down	2020-02-27 14:37:10.979136+03
b58592f7-75a9-4b48-a691-a3d6ff13f527	7bb3ba29-fa72-41d8-ae8c-e145036ab355	11	opened	Very important other container down	2020-02-27 14:37:11.653633+03
bf3301e7-aa30-481a-a96b-83fbc8a680c0	41f3b6ee-6a22-4010-ba8c-0f0b05f00fbf	11	opened	Very important other container down	2020-02-27 14:37:12.499122+03
08f3b2cc-5392-4819-862c-fd72624256d4	c4249789-e390-4087-aaef-463499bd212f	11	opened	Very important other container down	2020-02-27 14:37:13.173695+03
536034b7-b75c-4451-9ce9-fef0209e9f7e	34b75acf-518f-4eb0-bcde-c1443c0baa9b	11	opened	Very important other container down	2020-02-27 14:37:13.850313+03
e54a3f26-c911-472b-bb5b-193ee7df0d87	1faadbc9-3d45-4058-8664-8eae9c578bba	11	opened	Very important other container down	2020-02-27 14:37:14.528909+03
bc2c8a04-c659-4952-822d-622cca38caaf	e92dc295-b0aa-49c8-9e2f-cede3ad4d224	11	opened	Very important other container down	2020-02-27 14:37:15.355992+03
f8d281a3-86da-4742-a90d-7314b67b858e	5e2aa736-8385-4b4f-a4b3-f35dfe9f0829	11	opened	Very important other container down	2020-02-27 14:37:16.020074+03
4c168b01-8428-446b-8e1f-b1eb2b64539c	071a38b5-37c2-48f0-9aa4-48f31629eddd	11	opened	Very important other container down	2020-02-27 14:37:16.721744+03
1e14b602-a24a-47e3-8a8a-eaaf84d0ba9e	9336fb93-e040-461e-9d1e-14b728d58e73	11	opened	Very important other container down	2020-02-27 14:37:17.447954+03
19ad3451-096a-4da5-8574-9dbb64aab99e	62d2a242-8db8-47f1-a59f-6786abeda8e2	11	opened	Very important other container down	2020-02-27 14:37:18.145771+03
30addbb4-03bb-4025-8fca-ce2c7c9e6a1e	dd063ab1-0e7f-4d89-92f7-e1ba1a432d63	11	opened	Very important other container down	2020-02-27 14:37:18.887202+03
35a341a0-0111-43ec-8c0e-1e01f43463d2	a7a9d3e6-0f84-4c41-a5ad-621b62d978fc	13	accepted		2020-02-27 14:39:40.551836+03
eeb8701b-c2ca-4d33-96b8-de27cd805b9f	df166907-311e-40f3-ae30-3b5eb1d12e98	13	accepted		2020-02-27 14:50:00.685463+03
d129b7c5-1173-42f1-868f-74322657a846	4741bcfe-d8d0-4e25-9d64-5c6ccedca00c	13	accepted		2020-02-27 14:54:17.259175+03
2f55d67f-651e-49a2-8c71-a16b94b41d81	4741bcfe-d8d0-4e25-9d64-5c6ccedca00c	13	closed	 Some fix	2020-02-27 14:54:49.744945+03
50447830-c339-45ba-8641-89f81f035261	59ad2b99-fad5-4d45-86c5-3a04f8ad7c19	15	accepted		2020-02-27 14:56:58.204206+03
c0d81f2f-ef6f-46ea-bb15-7041d864ff62	59ad2b99-fad5-4d45-86c5-3a04f8ad7c19	13	redirect	Need more info	2020-02-27 14:58:37.37596+03
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, name) FROM stdin;
10	tester_1
11	tester_2
12	front_1
13	back_1
14	devops_1
1	default
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issues (id, title, service_id, severity, labels) FROM stdin;
a7a9d3e6-0f84-4c41-a5ad-621b62d978fc	Instance  down	4d948a25-d67f-4bf6-a88e-e72e1803505d	high	{"name": "redis", "alertname": "container_down"}
4741bcfe-d8d0-4e25-9d64-5c6ccedca00c	Instance  down	4d948a25-d67f-4bf6-a88e-e72e1803505d	high	{"name": "Lookker", "alertname": "container_down"}
df166907-311e-40f3-ae30-3b5eb1d12e98	Instance  down	4d948a25-d67f-4bf6-a88e-e72e1803505d	high	{"name": "Puppy", "alertname": "container_down"}
a79a862f-9001-43b6-9e0b-9d6376a6a04a	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
d6251fbc-f78c-4ca3-8604-af2dec9e2605	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
c1adea84-caed-483e-9a2b-54e54f813052	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
7b948a52-992f-4928-80aa-de57b89a15d1	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
dd908684-346c-4110-8d4a-1e65f11e39d5	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
42d4fda8-82a9-4b89-9041-7be5851f8f39	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
4220ef41-cf71-405a-b34d-65993640446b	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
1cad9a71-691a-4554-bd73-09a8b9f01bee	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
4ee71193-8cd0-4aaa-b5ff-a420b82c1d9a	Any event	4d948a25-d67f-4bf6-a88e-e72e1803505d	medium	{"name": "Puppy", "alertname": "container_down"}
77d64260-d83d-4df7-bbec-6296c0ac00e5	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
a50e3ea1-cb6e-423b-b6aa-c2bd58c2b462	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
91ade438-8ecf-46dd-adab-d9c0c59b9171	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
606ea2da-9de0-4d4a-8019-a0f8d9857869	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
59ad2b99-fad5-4d45-86c5-3a04f8ad7c19	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
8e7d4086-dac5-4cb2-979d-3b8ab064205d	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
e8a4dd69-3aea-48e7-98d7-0ca86af666dc	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
afcd36a9-adc2-49e3-85c0-5c088a524b0c	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
9b9780e8-845f-44b3-a0da-310b79d155f0	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
11f793b4-5201-4fdb-bdf3-1251bbc686da	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
0851856e-24b4-4690-afec-32eabf58d111	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
8f2187bc-a033-44f9-bbe5-9fc5f3a27ab9	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
d93d1a2c-29cd-490e-b7f2-3f77935c9248	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
bcbd76f9-c0e6-48c7-a0cd-a33f8a526194	Any other event	8d575480-9096-43e2-85c3-37d1f0b1b280	low	{"name": "Puppy", "alertname": "container_down"}
9ab8c0a4-9419-4f28-a665-bed404ff3d9b	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
4ec508d0-3540-46f2-9621-7a0b52ed28a8	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
7bb3ba29-fa72-41d8-ae8c-e145036ab355	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
41f3b6ee-6a22-4010-ba8c-0f0b05f00fbf	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
c4249789-e390-4087-aaef-463499bd212f	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
34b75acf-518f-4eb0-bcde-c1443c0baa9b	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
1faadbc9-3d45-4058-8664-8eae9c578bba	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
e92dc295-b0aa-49c8-9e2f-cede3ad4d224	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
5e2aa736-8385-4b4f-a4b3-f35dfe9f0829	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
071a38b5-37c2-48f0-9aa4-48f31629eddd	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
9336fb93-e040-461e-9d1e-14b728d58e73	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
62d2a242-8db8-47f1-a59f-6786abeda8e2	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
dd063ab1-0e7f-4d89-92f7-e1ba1a432d63	Any other event	4d948a25-d67f-4bf6-a88e-e72e1803505d	low	{"name": "Puppy", "alertname": "container_down"}
\.


--
-- Data for Name: parent_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parent_services (id, url) FROM stdin;
e37b7467-ae57-4df1-90d7-5951e2c1571b	fakeurl
f9b81b1b-b569-4e4c-9cdd-9c9b855b3f2d	otherfakeurl
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, group_id, parent_service_id) FROM stdin;
14188bc9-51aa-4de4-ae4c-35c3cd56c4ee	10	e37b7467-ae57-4df1-90d7-5951e2c1571b
4cc5ab16-87a1-4efd-bf3b-5f4ccf39e7ba	10	e37b7467-ae57-4df1-90d7-5951e2c1571b
4d948a25-d67f-4bf6-a88e-e72e1803505d	11	f9b81b1b-b569-4e4c-9cdd-9c9b855b3f2d
15963eb0-3f1e-49e6-ac59-c64557a994c9	13	f9b81b1b-b569-4e4c-9cdd-9c9b855b3f2d
8d575480-9096-43e2-85c3-37d1f0b1b280	12	\N
07371c35-f29b-4a2c-a692-f2fdea646693	14	\N
4bd2600b-8650-45c0-80a1-76c3166d1163	14	\N
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_id_seq', 20, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 14, true);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: parent_services parent_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_services
    ADD CONSTRAINT parent_services_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: accounts_login_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX accounts_login_uindex ON public.accounts USING btree (login);


--
-- Name: groups_name_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX groups_name_uindex ON public.groups USING btree (name);


--
-- Name: accounts accounts_groups_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_groups_id_fk FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: events events_issues_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_issues_id_fk FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: issues issues_services_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_services_id_fk FOREIGN KEY (service_id) REFERENCES public.services(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: services services_parent_services_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_parent_services_id_fk FOREIGN KEY (parent_service_id) REFERENCES public.parent_services(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

