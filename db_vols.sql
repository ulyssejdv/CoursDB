CREATE TABLE AEROPORT (
    codeAeroport varchar(15) primary key not null,
    nom varchar(40), 
    ville varchar(40),
    pays varchar(40)
);

    CREATE TABLE VOL (
    numVol int primary key not null, 
    compagnie varchar(40), 
    periodeVol varchar(30)
);

CREATE TABLE ESCALE (
    numVol int not null, 
    numEscale int not null, 
    aeroportDepart varchar(15) references AEROPORT,
    aeroportArrivee varchar(15) references AEROPORT, 
    heureDepartPrevue int,
    minuteDepartPrevue int, 
    heureArriveePrevue int,
    minuteArriveePrevue int,
    primary key (numVol, numEscale)
);

CREATE TABLE TYPE_AVION (
    nomType varchar(40) primary key not null, 
    maxSieges int,
    nomConstructeur varchar (40)
);

CREATE TABLE AVION (
    idAvion int primary key not null, 
    totalSieges int, 
    nomTypeAvion varchar(40)
);

CREATE TABLE INSTANCE_ESCALE (
    numVol int not null, 
    numEscale int not null, 
    dateEscale date not null,
    nbreSieges int, 
    idAvion int, 
    dateDepartEffectuee date,
    dateArriveeEffectuee date, 
    idEquipe int,
    primary key (numVol, numEscale, dateEscale)
);

CREATE TABLE PEUT_ATTERRIR (
    nomTypeAvion varchar(40) not null, 
    codeAeroport varchar(15) not null,
    primary key (nomTypeAvion, codeAeroport)
);

CREATE TABLE PERSONNEL (
    idPersonne int primary key not null, 
    Nom varchar(40), 
    Prenom varchar(40),
    Fonction varchar(40)
);

CREATE TABLE EQUIPAGE (
    idEquipe int primary key not null, 
    numVol int, 
    numEscale int, 
    dateEscale date,
    idPilote int, 
    idCoPilote int, 
    idChefCabine int
);

CREATE TABLE HOTESSE_EQUIPAGE (
    idEquipe int not null, 
    idPersonne int not null,
    primary key (idEquipe, idPersonne)
);


alter table ESCALE
add constraint fk_vol foreign key (numVol) references VOL(numVol);
alter table ESCALE
add constraint fk_aeroportDepart foreign key (aeroportDepart) references AEROPORT(codeAeroport);
alter table ESCALE
add constraint fk_aeroportArrivee foreign key (aeroportArrivee) references AEROPORT(codeAeroport);
alter table AVION
add constraint fk_nomTypeAvion foreign key (nomTypeAvion) references TYPE_AVION(nomType);
alter table INSTANCE_ESCALE
add constraint fk_escale foreign key (numVol, numEscale) references ESCALE(numVol, numEscale);
alter table INSTANCE_ESCALE
add constraint fk_avion foreign key (idAvion) references AVION(idAvion);
alter table INSTANCE_ESCALE
add constraint fk_idEquipe foreign key (idEquipe) references EQUIPAGE(idEquipe);
alter table PEUT_ATTERRIR
add constraint fk_type_avion foreign key (nomTypeAvion) references TYPE_AVION(nomType);
alter table PEUT_ATTERRIR
add constraint fk_codeAeroport foreign key (codeAeroport) references AEROPORT(codeAeroport);
alter table EQUIPAGE
add constraint fk_instance_escale foreign key (numVol, numEscale, dateEscale) references INSTANCE_ESCALE(numVol, numEscale, dateEscale);
alter table EQUIPAGE
add constraint fk_idPilote foreign key (idPilote) references PERSONNEL(idPersonne);
alter table EQUIPAGE
add constraint fk_idCoPilote foreign key (idCoPilote) references PERSONNEL(idPersonne);
alter table EQUIPAGE
add constraint fk_idChefCabine foreign key (idChefCabine) references PERSONNEL(idPersonne);
alter table HOTESSE_EQUIPAGE
add constraint fk_idEquipe foreign key (idEquipe) references EQUIPAGE(idEquipe);
alter table HOTESSE_EQUIPAGE
add constraint fk_idPersonne foreign key (idPersonne) references PERSONNEL(idPersonne);

ALTER TABLE AEROPORT
ADD CONSTRAINT unique_nom_ville_pays UNIQUE (nom, ville, pays);

ALTER TABLE ESCALE
ADD CONSTRAINT check_numEscale CHECK (numEscale > 0 AND numEscale <= 20),
ADD CONSTRAINT check_aeroports_differents CHECK (aeroportDepart != aeroportArrivee),
ADD CONSTRAINT check_heureDepartPrevue CHECK (heureDepartPrevue >= 0 AND heureDepartPrevue < 24),
ADD CONSTRAINT check_minuteDepartPrevue CHECK (minuteDepartPrevue >= 0 AND minuteDepartPrevue < 60),
ADD CONSTRAINT check_heureArriveePrevue CHECK (heureArriveePrevue >= 0 AND heureArriveePrevue < 24),
ADD CONSTRAINT check_minuteArriveePrevue CHECK (minuteArriveePrevue >= 0 AND minuteArriveePrevue < 60);

ALTER TABLE INSTANCE_ESCALE
ADD CONSTRAINT check_dateDepartEffectuee CHECK (dateDepartEffectuee < dateArriveeEffectuee);


-- Tests

-- Insérer une ligne valide
INSERT INTO AEROPORT (codeAeroport, nom, ville, pays)
VALUES ('CDG', 'Charles de Gaulle', 'Paris', 'France');

-- Essayer d'insérer une ligne avec une clé primaire dupliquée
INSERT INTO AEROPORT (codeAeroport, nom, ville, pays)
VALUES ('CDG', 'Aéroport de Duplication', 'Paris', 'France');

-- Essayer d'insérer une ligne avec une valeur nulle pour la clé primaire
INSERT INTO AEROPORT (codeAeroport, nom, ville, pays)
VALUES (NULL, 'Aéroport Null', 'Ville Null', 'Pays Null');

-- Essayer d'insérer une ligne avec des valeurs dupliquées pour (nom, ville, pays)
INSERT INTO AEROPORT (codeAeroport, nom, ville, pays)
VALUES ('ORY', 'Charles de Gaulle', 'Paris', 'France');


-- Insérer deux tuples valides dans AEROPORT
INSERT INTO AEROPORT (codeAeroport, nom, ville, pays)
VALUES ('CDG', 'Charles de Gaulle', 'Paris', 'France');

INSERT INTO AEROPORT (codeAeroport, nom, ville, pays)
VALUES ('JFK', 'John F. Kennedy', 'New York', 'USA');

-- Insérer deux tuples valides dans TYPE_AVION
INSERT INTO TYPE_AVION (nomType, maxSieges, nomConstructeur)
VALUES ('Boeing 747', 416, 'Boeing');

INSERT INTO TYPE_AVION (nomType, maxSieges, nomConstructeur)
VALUES ('Airbus A380', 525, 'Airbus');

-- Insérer un tuple valide dans PEUT_ATTERRIR
INSERT INTO PEUT_ATTERRIR (nomTypeAvion, codeAeroport)
VALUES ('Boeing 747', 'CDG');

-- Essayer d'insérer un tuple qui ne respecte pas les contraintes référentielles
INSERT INTO PEUT_ATTERRIR (nomTypeAvion, codeAeroport)
VALUES ('Boeing 747', 'XYZ'); -- 'XYZ' n'existe pas dans AEROPORT

-- Essayer de supprimer un tuple de AEROPORT qui est référencé par PEUT_ATTERRIR
DELETE FROM AEROPORT
WHERE codeAeroport = 'CDG';
