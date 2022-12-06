--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Debian 14.5-2.pgdg110+2)
-- Dumped by pg_dump version 14.5

-- Started on 2022-11-25 14:40:32 UTC

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
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: sail
--

CREATE SCHEMA if not exists public;


ALTER SCHEMA public OWNER TO sail;

--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: sail
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 236 (class 1255 OID 24905)
-- Name: emplacement_item(bigint); Type: FUNCTION; Schema: public; Owner: sail
--
-- Donne l'eplacement de l'item dont l'ID est passé en parametres
CREATE FUNCTION public.emplacement_item(bigint) RETURNS varchar
    LANGUAGE plpgsql
    AS $_$
declare emplacement varchar;
begin
	select emplacements.libelle from items
	join types on items.type_id = types.id
	join emplacements on types.emplacement_id = emplacements.id
	where items.id = $1 into emplacement;
	return emplacement;
end;
$_$;

--Donne le nb d'item à l'emplacement donné pour l'équipement donné
create function public.nb_item_emplacement_equipement(emplacement varchar, equipementid bigint)
    returns integer
as $$
declare nb integer;
begin
    select count(*) from equipement_item
                             join items on equipement_item.item_id = items.id
                             join types on items.type_id = types.id
                             join emplacements on types.emplacement_id = emplacements.id
    where equipement_id = $2 and emplacements.libelle = $1 into nb;
    return nb;
end;
$$
    LANGUAGE PLPGSQL;


--Détermine si l'emplacement de l'item passé en paramètre est bien disponible poour l'équipement donné
create function public.emplacement_libre(itemid bigint, equipementid bigint)
    returns bool
as $$
declare emplacement varchar;
    declare nb integer;
begin
    select emplacement_item($1) into emplacement;
    select nb_item_emplacement_equipement(emplacement, $2) into nb;
    case emplacement
        when 'Chapeau', 'Cape', 'Amulette', 'Corps à corps', 'Bouclier', 'Bottes', 'Ceinture', 'Familier' then
            return nb < 1;
        when 'Anneau' then
            return nb < 2;
        when 'Dofus' then
            return nb < 6;
        else
            raise exception 'Emplacement non trouvé';
        end case;
end;
$$
    LANGUAGE PLPGSQL;

--Vérifie qu'un item n'est pas déjà présent dans l'équipement
create function public.non_deja_equipe(itemid bigint, equipementid bigint)
    returns bool
as $$
declare ro equipements%rowtype;
begin
    select * from equipement_item where equipement_id = $2 and item_id = $1 into ro;
    if found then
        return false;
    else return true;
    end if;
end;
$$
    LANGUAGE PLPGSQL;

--Procédure appelée à chaque ajout dans la table emplacement_item
create function public.ajout_item()
    returns trigger
as $$
begin
    if(emplacement_libre(new.item_id, new.equipement_id)) then
        if(non_deja_equipe(new.item_id, new.equipement_id)) then
            return new;
        else raise exception 'Il n est pas possible d équiper deux fois le même item';
        end if;
    else
        raise exception 'Emplacement non disponible';
    end if;
end;
$$
    LANGUAGE PLPGSQL;


ALTER FUNCTION public.emplacement_item(bigint) OWNER TO sail;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 24785)
-- Name: classes; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.classes (
    id bigint NOT NULL,
    nom character varying(255) NOT NULL,
    image_path character varying(255) NOT NULL
);


ALTER TABLE public.classes OWNER TO sail;

--
-- TOC entry 220 (class 1259 OID 24784)
-- Name: classes_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classes_id_seq OWNER TO sail;

--
-- TOC entry 3472 (class 0 OID 0)
-- Dependencies: 220
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
-- TOC entry 219 (class 1259 OID 24774)
-- Name: emplacements; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.emplacements (
    id bigint NOT NULL,
    libelle character varying(255) NOT NULL,
    image_path character varying(255) NOT NULL
);


ALTER TABLE public.emplacements OWNER TO sail;

--
-- TOC entry 218 (class 1259 OID 24773)
-- Name: emplacements_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.emplacements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.emplacements_id_seq OWNER TO sail;

--
-- TOC entry 3473 (class 0 OID 0)
-- Dependencies: 218
-- Name: emplacements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.emplacements_id_seq OWNED BY public.emplacements.id;


--
-- TOC entry 235 (class 1259 OID 24888)
-- Name: equipement_item; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.equipement_item (
    id bigint NOT NULL,
    item_id bigint NOT NULL,
    equipement_id bigint NOT NULL
);


ALTER TABLE public.equipement_item OWNER TO sail;

--
-- TOC entry 234 (class 1259 OID 24887)
-- Name: equipement_item_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.equipement_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.equipement_item_id_seq OWNER TO sail;

--
-- TOC entry 3474 (class 0 OID 0)
-- Dependencies: 234
-- Name: equipement_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.equipement_item_id_seq OWNED BY public.equipement_item.id;


--
-- TOC entry 229 (class 1259 OID 24837)
-- Name: equipements; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.equipements (
    id bigint NOT NULL,
    nom character varying(255) NOT NULL,
    user_id bigint NOT NULL,
    classe_id bigint NOT NULL
);


ALTER TABLE public.equipements OWNER TO sail;

--
-- TOC entry 228 (class 1259 OID 24836)
-- Name: equipements_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.equipements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.equipements_id_seq OWNER TO sail;

--
-- TOC entry 3475 (class 0 OID 0)
-- Dependencies: 228
-- Name: equipements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.equipements_id_seq OWNED BY public.equipements.id;


--
-- TOC entry 215 (class 1259 OID 24750)
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO sail;

--
-- TOC entry 214 (class 1259 OID 24749)
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.failed_jobs_id_seq OWNER TO sail;

--
-- TOC entry 3476 (class 0 OID 0)
-- Dependencies: 214
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- TOC entry 231 (class 1259 OID 24854)
-- Name: item_statistique_bonus; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.item_statistique_bonus (
    id bigint NOT NULL,
    item_id bigint NOT NULL,
    statistique_id bigint NOT NULL,
    valeur integer NOT NULL
);


ALTER TABLE public.item_statistique_bonus OWNER TO sail;

--
-- TOC entry 230 (class 1259 OID 24853)
-- Name: item_statistique_bonus_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.item_statistique_bonus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_statistique_bonus_id_seq OWNER TO sail;

--
-- TOC entry 3477 (class 0 OID 0)
-- Dependencies: 230
-- Name: item_statistique_bonus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.item_statistique_bonus_id_seq OWNED BY public.item_statistique_bonus.id;


--
-- TOC entry 233 (class 1259 OID 24871)
-- Name: item_statistique_condition; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.item_statistique_condition (
    id bigint NOT NULL,
    item_id bigint NOT NULL,
    statistique_id bigint NOT NULL,
    valeur integer NOT NULL
);


ALTER TABLE public.item_statistique_condition OWNER TO sail;

--
-- TOC entry 232 (class 1259 OID 24870)
-- Name: item_statistique_condition_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.item_statistique_condition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_statistique_condition_id_seq OWNER TO sail;

--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 232
-- Name: item_statistique_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.item_statistique_condition_id_seq OWNED BY public.item_statistique_condition.id;


--
-- TOC entry 225 (class 1259 OID 24810)
-- Name: items; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.items (
    id bigint NOT NULL,
    libelle character varying(255) NOT NULL,
    niveau integer NOT NULL,
    image_path character varying(255) NOT NULL,
    type_id bigint NOT NULL
);


ALTER TABLE public.items OWNER TO sail;

--
-- TOC entry 224 (class 1259 OID 24809)
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_seq OWNER TO sail;

--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 224
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- TOC entry 210 (class 1259 OID 24726)
-- Name: migrations; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO sail;

--
-- TOC entry 209 (class 1259 OID 24725)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO sail;

--
-- TOC entry 3480 (class 0 OID 0)
-- Dependencies: 209
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 213 (class 1259 OID 24743)
-- Name: password_resets; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_resets OWNER TO sail;

--
-- TOC entry 217 (class 1259 OID 24762)
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO sail;

--
-- TOC entry 216 (class 1259 OID 24761)
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personal_access_tokens_id_seq OWNER TO sail;

--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 216
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- TOC entry 227 (class 1259 OID 24826)
-- Name: statistiques; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.statistiques (
    id bigint NOT NULL,
    libelle character varying(255) NOT NULL,
    image_path character varying(255) NOT NULL
);


ALTER TABLE public.statistiques OWNER TO sail;

--
-- TOC entry 226 (class 1259 OID 24825)
-- Name: statistiques_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.statistiques_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statistiques_id_seq OWNER TO sail;

--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 226
-- Name: statistiques_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.statistiques_id_seq OWNED BY public.statistiques.id;


--
-- TOC entry 223 (class 1259 OID 24796)
-- Name: types; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.types (
    id bigint NOT NULL,
    libelle character varying(255) NOT NULL,
    emplacement_id bigint NOT NULL
);


ALTER TABLE public.types OWNER TO sail;

--
-- TOC entry 222 (class 1259 OID 24795)
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.types_id_seq OWNER TO sail;

--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 222
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- TOC entry 212 (class 1259 OID 24733)
-- Name: users; Type: TABLE; Schema: public; Owner: sail
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO sail;

--
-- TOC entry 211 (class 1259 OID 24732)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: sail
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO sail;

--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sail
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3238 (class 2604 OID 24788)
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- TOC entry 3237 (class 2604 OID 24777)
-- Name: emplacements id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.emplacements ALTER COLUMN id SET DEFAULT nextval('public.emplacements_id_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 24891)
-- Name: equipement_item id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.equipement_item ALTER COLUMN id SET DEFAULT nextval('public.equipement_item_id_seq'::regclass);


--
-- TOC entry 3242 (class 2604 OID 24840)
-- Name: equipements id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.equipements ALTER COLUMN id SET DEFAULT nextval('public.equipements_id_seq'::regclass);


--
-- TOC entry 3234 (class 2604 OID 24753)
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 24857)
-- Name: item_statistique_bonus id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.item_statistique_bonus ALTER COLUMN id SET DEFAULT nextval('public.item_statistique_bonus_id_seq'::regclass);


--
-- TOC entry 3244 (class 2604 OID 24874)
-- Name: item_statistique_condition id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.item_statistique_condition ALTER COLUMN id SET DEFAULT nextval('public.item_statistique_condition_id_seq'::regclass);


--
-- TOC entry 3240 (class 2604 OID 24813)
-- Name: items id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- TOC entry 3232 (class 2604 OID 24729)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3236 (class 2604 OID 24765)
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- TOC entry 3241 (class 2604 OID 24829)
-- Name: statistiques id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.statistiques ALTER COLUMN id SET DEFAULT nextval('public.statistiques_id_seq'::regclass);


--
-- TOC entry 3239 (class 2604 OID 24799)
-- Name: types id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- TOC entry 3233 (class 2604 OID 24736)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3451 (class 0 OID 24785)
-- Dependencies: 221
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3449 (class 0 OID 24774)
-- Dependencies: 219
-- Data for Name: emplacements; Type: TABLE DATA; Schema: public; Owner: sail
--




--
-- TOC entry 3465 (class 0 OID 24888)
-- Dependencies: 235
-- Data for Name: equipement_item; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3459 (class 0 OID 24837)
-- Dependencies: 229
-- Data for Name: equipements; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3445 (class 0 OID 24750)
-- Dependencies: 215
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3461 (class 0 OID 24854)
-- Dependencies: 231
-- Data for Name: item_statistique_bonus; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3463 (class 0 OID 24871)
-- Dependencies: 233
-- Data for Name: item_statistique_condition; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3455 (class 0 OID 24810)
-- Dependencies: 225
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3440 (class 0 OID 24726)
-- Dependencies: 210
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: sail
--

INSERT INTO public.migrations (id, migration, batch) VALUES (1, '2014_10_12_000000_create_users_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (2, '2014_10_12_100000_create_password_resets_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (3, '2019_08_19_000000_create_failed_jobs_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (4, '2019_12_14_000001_create_personal_access_tokens_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (5, '2022_11_14_120022_initial', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (6, '2022_11_14_122933_test', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (7, '2022_11_21_154130_create_emplacements_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (8, '2022_11_21_154350_create_classes_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (9, '2022_11_22_153848_create_types_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (10, '2022_11_23_124359_create_items_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (11, '2022_11_23_154243_create_statistiques_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (12, '2022_11_23_154311_create_equipements_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (13, '2022_11_23_161740_create_item_statistique_bonus_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (14, '2022_11_25_091534_create_item_statistique_condition_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (15, '2022_11_25_091816_create_equipement_item_table', 1);


--
-- TOC entry 3443 (class 0 OID 24743)
-- Dependencies: 213
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3447 (class 0 OID 24762)
-- Dependencies: 217
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3457 (class 0 OID 24826)
-- Dependencies: 227
-- Data for Name: statistiques; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3453 (class 0 OID 24796)
-- Dependencies: 223
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3442 (class 0 OID 24733)
-- Dependencies: 212
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sail
--



--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 220
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.classes_id_seq', 1, false);


--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 218
-- Name: emplacements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.emplacements_id_seq', 1, false);


--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 234
-- Name: equipement_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.equipement_item_id_seq', 1, false);


--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 228
-- Name: equipements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.equipements_id_seq', 1, false);


--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 214
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 230
-- Name: item_statistique_bonus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.item_statistique_bonus_id_seq', 1, false);


--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 232
-- Name: item_statistique_condition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.item_statistique_condition_id_seq', 1, false);


--
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 224
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.items_id_seq', 1, false);


--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 209
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.migrations_id_seq', 15, true);


--
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 216
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 226
-- Name: statistiques_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.statistiques_id_seq', 1, false);


--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 222
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.types_id_seq', 1, false);


--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sail
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3267 (class 2606 OID 24794)
-- Name: classes classes_nom_unique; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_nom_unique UNIQUE (nom);


--
-- TOC entry 3269 (class 2606 OID 24792)
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- TOC entry 3263 (class 2606 OID 24783)
-- Name: emplacements emplacements_libelle_unique; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.emplacements
    ADD CONSTRAINT emplacements_libelle_unique UNIQUE (libelle);


--
-- TOC entry 3265 (class 2606 OID 24781)
-- Name: emplacements emplacements_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.emplacements
    ADD CONSTRAINT emplacements_pkey PRIMARY KEY (id);


--
-- TOC entry 3289 (class 2606 OID 24893)
-- Name: equipement_item equipement_item_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.equipement_item
    ADD CONSTRAINT equipement_item_pkey PRIMARY KEY (id);


--
-- TOC entry 3283 (class 2606 OID 24842)
-- Name: equipements equipements_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.equipements
    ADD CONSTRAINT equipements_pkey PRIMARY KEY (id);


--
-- TOC entry 3254 (class 2606 OID 24758)
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 3256 (class 2606 OID 24760)
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- TOC entry 3285 (class 2606 OID 24859)
-- Name: item_statistique_bonus item_statistique_bonus_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.item_statistique_bonus
    ADD CONSTRAINT item_statistique_bonus_pkey PRIMARY KEY (id);


--
-- TOC entry 3287 (class 2606 OID 24876)
-- Name: item_statistique_condition item_statistique_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.item_statistique_condition
    ADD CONSTRAINT item_statistique_condition_pkey PRIMARY KEY (id);


--
-- TOC entry 3275 (class 2606 OID 24824)
-- Name: items items_libelle_unique; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_libelle_unique UNIQUE (libelle);


--
-- TOC entry 3277 (class 2606 OID 24817)
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- TOC entry 3247 (class 2606 OID 24731)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3258 (class 2606 OID 24769)
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3260 (class 2606 OID 24772)
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- TOC entry 3279 (class 2606 OID 24835)
-- Name: statistiques statistiques_libelle_unique; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.statistiques
    ADD CONSTRAINT statistiques_libelle_unique UNIQUE (libelle);


--
-- TOC entry 3281 (class 2606 OID 24833)
-- Name: statistiques statistiques_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.statistiques
    ADD CONSTRAINT statistiques_pkey PRIMARY KEY (id);


--
-- TOC entry 3271 (class 2606 OID 24808)
-- Name: types types_libelle_unique; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_libelle_unique UNIQUE (libelle);


--
-- TOC entry 3273 (class 2606 OID 24801)
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- TOC entry 3249 (class 2606 OID 24742)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 3251 (class 2606 OID 24740)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3252 (class 1259 OID 24748)
-- Name: password_resets_email_index; Type: INDEX; Schema: public; Owner: sail
--

CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


--
-- TOC entry 3261 (class 1259 OID 24770)
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: sail
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- TOC entry 3299 (class 2606 OID 24899)
-- Name: equipement_item equipement_item_equipement_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.equipement_item
    ADD CONSTRAINT equipement_item_equipement_id_foreign FOREIGN KEY (equipement_id) REFERENCES public.equipements(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3298 (class 2606 OID 24894)
-- Name: equipement_item equipement_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.equipement_item
    ADD CONSTRAINT equipement_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.items(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3293 (class 2606 OID 24848)
-- Name: equipements equipements_classe_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.equipements
    ADD CONSTRAINT equipements_classe_id_foreign FOREIGN KEY (classe_id) REFERENCES public.classes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3292 (class 2606 OID 24843)
-- Name: equipements equipements_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.equipements
    ADD CONSTRAINT equipements_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3294 (class 2606 OID 24860)
-- Name: item_statistique_bonus item_statistique_bonus_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.item_statistique_bonus
    ADD CONSTRAINT item_statistique_bonus_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.items(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3295 (class 2606 OID 24865)
-- Name: item_statistique_bonus item_statistique_bonus_statistique_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.item_statistique_bonus
    ADD CONSTRAINT item_statistique_bonus_statistique_id_foreign FOREIGN KEY (statistique_id) REFERENCES public.statistiques(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3296 (class 2606 OID 24877)
-- Name: item_statistique_condition item_statistique_condition_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.item_statistique_condition
    ADD CONSTRAINT item_statistique_condition_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.items(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3297 (class 2606 OID 24882)
-- Name: item_statistique_condition item_statistique_condition_statistique_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.item_statistique_condition
    ADD CONSTRAINT item_statistique_condition_statistique_id_foreign FOREIGN KEY (statistique_id) REFERENCES public.statistiques(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3291 (class 2606 OID 24818)
-- Name: items items_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.types(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3290 (class 2606 OID 24802)
-- Name: types types_emplacement_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: sail
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_emplacement_id_foreign FOREIGN KEY (emplacement_id) REFERENCES public.emplacements(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2022-11-25 14:40:33 UTC

--
-- PostgreSQL database dump complete
--

create trigger emplacement_libre
    before insert or update on public.equipement_item
    for each row
execute procedure public.ajout_item();



INSERT INTO public.emplacements (id, libelle, image_path) VALUES (1, 'Chapeau', 'chapeau.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (2, 'Cape', 'cape.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (3, 'Corps à corps', 'cac.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (4, 'Anneau', 'anneau.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (5, 'Amulette', 'amuelette.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (6, 'Ceinture', 'ceinture.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (7, 'Bottes', 'bottes.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (8, 'Bouclier', 'bouclier.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (9, 'Familier', 'familier.jpg');
INSERT INTO public.emplacements (id, libelle, image_path) VALUES (10, 'Dofus', 'dofus.jpg');


INSERT INTO public.types (id, libelle, emplacement_id) VALUES (1, 'chapeau', 1);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (2, 'cape', 2);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (3, 'sac', 2);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (4, 'anneau', 4);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (5, 'amulette', 5);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (6, 'ceinture', 6);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (7, 'bottes', 7);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (8, 'bouclier', 8);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (9, 'familier', 9);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (10, 'dragodinde', 9);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (11, 'muldo', 9);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (12, 'montilier', 9);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (13, 'volkorne', 9);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (14, 'dofus', 10);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (15, 'trophée', 10);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (16, 'prysmaradite', 10);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (17, 'hache', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (18, 'arc', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (19, 'baguette', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (20, 'bâton', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (21, 'dague', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (22, 'épée', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (23, 'faux', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (24, 'marteau', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (25, 'outil', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (26, 'pelle', 3);
INSERT INTO public.types (id, libelle, emplacement_id) VALUES (27, 'pioche', 3);


INSERT INTO public.classes (id, nom, image_path) VALUES (1, 'Feca', 'classe/feca.png');
INSERT INTO public.classes (id, nom, image_path) VALUES (2, 'ecaflip', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (3, 'eniripsa', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (4, 'iop', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (5, 'cra', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (6, 'sacrieur', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (7, 'sadida', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (8, 'osamodas', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (9, 'enutrof', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (10, 'sram', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (11, 'xelor', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (12, 'pandawa', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (13, 'roublard', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (14, 'zobal', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (15, 'steamer', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (16, 'eliotrope', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (17, 'huppermage', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (18, 'ouginak', '');
INSERT INTO public.classes (id, nom, image_path) VALUES (19, 'forgelance', '');

INSERT INTO public.statistiques (id, libelle, image_path) VALUES (1, 'Force', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (2, 'Intelligence', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (3, 'Agilite', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (4, 'Portee', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (5, 'Coup critique', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (6, 'Invocation', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (7, 'Chance', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (8, 'Point de mouvement', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (9, 'Point d action', '');
INSERT INTO public.statistiques (id, libelle, image_path) VALUES (10, 'Vitalite', '');

INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (1, 'Coiffe du Comte Harebourg', 200, '', 1);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (2, 'Coiffe de Kolosso', 193, '', 1);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (3, 'Casque Dragoeuf', 129, '', 1);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (4, 'Coiffe du Kitsou', 61, '', 1);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (5, 'Choipo Podlard', 33, '', 1);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (6, 'Amulette d Hel Munster', 195, '', 5);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (7, 'Amulette Hale', 193, '', 5);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (8, 'Amulette Turquoise', 63, '', 5);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (9, 'Araknamu', 40, '', 5);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (10, 'Koliet Aclou', 1, '', 5);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (11, 'Croclier', 200, '', 8);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (12, 'Bouclier du Chouque', 85, '', 8);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (13, 'Bouclier du Bawbawe', 60, '', 8);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (14, 'Bouclier en Mousse', 25, '', 8);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (15, 'Bouclier du tournesol sauvage', 5, '', 8);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (16, 'Cape du Valet Veinard', 200, '', 2);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (17, 'Cape Surde', 176, '', 2);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (18, 'Cape du Mansot Royal', 144, '', 2);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (19, 'Cape Hucine', 71, '', 2);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (20, 'Cape Lumette', 38, '', 2);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (21, 'Bottes du Strigide', 200, '', 7);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (22, 'Pantoufles Émar', 196, '', 7);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (23, 'Bottes du Minotoror', 113, '', 7);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (24, 'Mawabottes', 57, '', 7);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (25, 'Dragoubottes Roses', 10, '', 7);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (26, 'Goulano', 200, '', 4);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (27, 'Alliance de Guten Tak', 173, '', 4);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (28, 'Bracelet Tmotiv', 104, '', 4);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (29, 'Anneau Ouroboulos', 80, '', 4);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (30, 'Anneau Forain', 44, '', 4);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (31, 'Ceinture de Kongoku', 200, '', 6);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (32, 'Ceinture des Matougarous', 160, '', 6);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (33, 'Pagne de Daïgoro', 82, '', 6);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (34, 'Ceinture des Grocoricos', 30, '', 6);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (35, 'Ceinture du Piou Jaune', 8, '', 6);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (36, 'Hache du Chaloeil', 200, '', 17);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (37, 'Épée d Otomaï', 196, '', 22);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (38, 'Dagues Ruik', 158, '', 21);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (39, 'Styx', 100, '', 26);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (40, 'Le Kikoularc', 79, '', 18);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (41, 'Dofus Nébuleux', 180, '', 14);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (42, 'Porteur majeur', 150, '', 15);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (43, 'Furibond majeur', 150, '', 15);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (44, 'Dofus Vulbis', 180, '', 14);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (45, 'Acrobate mineur', 50, '', 15);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (46, 'Dofus Cacao', 50, '', 14);
INSERT INTO public.items (id, libelle, niveau, image_path, type_id) VALUES (47, 'Nomoon', 100, '', 9);

INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (1, 1, 1, 100);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (2, 1, 10, 500);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (3, 2, 1, 40);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (4, 2, 10, 350);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (5, 3, 10, 200);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (6, 4, 10, 150);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (7, 5, 4, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (8, 6, 10, 300);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (9, 6, 7, 70);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (10, 6, 3, 70);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (11, 6, 9, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (12, 7, 2, 80);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (13, 7, 8, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (14, 8, 1, 90);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (15, 8, 10, 100);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (16, 8, 3, 90);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (17, 9, 2, 100);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (18, 9, 5, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (19, 9, 7, 60);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (20, 10, 4, 3);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (21, 10, 10, 200);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (22, 11, 1, 60);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (23, 11, 3, 50);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (24, 11, 9, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (25, 12, 2, 40);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (26, 12, 3, 50);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (27, 12, 6, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (28, 13, 1, 70);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (29, 13, 4, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (30, 14, 2, 70);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (31, 14, 3, 80);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (32, 14, 6, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (33, 15, 1, 90);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (34, 15, 8, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (35, 15, 4, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (36, 16, 1, 20);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (37, 16, 2, 10);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (38, 16, 7, 40);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (39, 17, 10, 260);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (40, 17, 9, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (41, 18, 8, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (42, 19, 2, 30);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (43, 19, 1, 20);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (44, 20, 6, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (45, 20, 10, 100);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (46, 44, 8, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (47, 43, 1, 80);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (48, 45, 3, 15);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (101, 21, 10, 400);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (102, 21, 8, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (103, 21, 9, 8);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (104, 22, 10, 300);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (105, 22, 2, 40);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (106, 22, 3, 40);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (107, 23, 10, 150);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (108, 23, 8, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (109, 24, 1, 500);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (110, 24, 2, 60);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (111, 24, 5, 4);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (112, 25, 1, 30);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (113, 26, 2, 50);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (114, 26, 9, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (115, 26, 8, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (116, 27, 10, 100);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (117, 27, 4, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (118, 27, 6, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (119, 28, 7, 3);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (120, 28, 10, 200);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (121, 28, 3, 20);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (122, 29, 2, 200);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (123, 29, 1, 50);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (124, 29, 8, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (125, 30, 1, 200);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (126, 30, 3, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (127, 30, 7, 10);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (128, 31, 4, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (129, 31, 5, 4);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (130, 31, 10, 200);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (131, 32, 2, 150);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (132, 32, 9, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (133, 32, 6, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (134, 33, 3, 20);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (135, 33, 7, 5);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (136, 33, 1, 200);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (137, 34, 5, 3);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (138, 34, 9, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (139, 34, 2, 300);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (140, 35, 7, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (141, 35, 6, 4);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (142, 35, 10, 175);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (143, 36, 1, 235);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (144, 36, 5, 5);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (145, 36, 9, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (146, 37, 10, 100);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (147, 37, 3, 5);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (148, 37, 6, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (149, 38, 2, 200);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (150, 38, 7, 2);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (151, 38, 8, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (152, 39, 3, 7);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (153, 39, 1, 172);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (154, 39, 9, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (155, 40, 6, 1);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (156, 40, 2, 60);
INSERT INTO public.item_statistique_bonus (id, item_id, statistique_id, valeur) VALUES (157, 40, 7, 10);


