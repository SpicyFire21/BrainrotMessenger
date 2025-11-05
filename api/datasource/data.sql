CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS loves CASCADE;
DROP TABLE IF EXISTS likes CASCADE;
DROP TABLE IF EXISTS saves CASCADE;
DROP TABLE IF EXISTS subscribe CASCADE;
DROP TABLE IF EXISTS follower CASCADE;
DROP TABLE IF EXISTS comments CASCADE;

CREATE TABLE IF NOT EXISTS users
(
    id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pseudo    VARCHAR(50) NOT NULL UNIQUE,
    realName  VARCHAR(50),
    email     VARCHAR(50),
    password  VARCHAR(255),
    bio       VARCHAR(255),
    avatar    BYTEA,
    createdAt TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS messages
(
    id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content    VARCHAR(255),
    createdAt  TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP,
    senderId   UUID NOT NULL,
    receiverId UUID NOT NULL,
    FOREIGN KEY (senderId) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (receiverId) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS posts
(
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    description VARCHAR(255),
    image       BYTEA,
    authorId    UUID NOT NULL,
    postedAt    TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (authorId) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS loves
(
    idpost UUID NOT NULL,
    iduser UUID NOT NULL,
    PRIMARY KEY (idpost, iduser),
    FOREIGN KEY (idpost) REFERENCES posts (id) ON DELETE CASCADE,
    FOREIGN KEY (iduser) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS likes
(
    idpost UUID NOT NULL,
    iduser UUID NOT NULL,
    PRIMARY KEY (idpost, iduser),
    FOREIGN KEY (idpost) REFERENCES posts (id) ON DELETE CASCADE,
    FOREIGN KEY (iduser) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS saves
(
    id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    idpost UUID NOT NULL,
    iduser UUID NOT NULL,
    FOREIGN KEY (idpost) REFERENCES posts (id) ON DELETE CASCADE,
    FOREIGN KEY (iduser) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS follower
(
    iduser   UUID NOT NULL,
    iduser_1 UUID NOT NULL,
    PRIMARY KEY (iduser, iduser_1),
    FOREIGN KEY (iduser) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (iduser_1) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS comments
(
    idcomment UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    iduser UUID NOT NULL,
    idpost UUID NOT NULL,
    comment VARCHAR(255),
    postedat  TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (iduser) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (idpost) REFERENCES posts (id) ON DELETE CASCADE

);

-- Insert users
INSERT INTO users (id, pseudo, realName, email, password, bio, avatar, createdAt)
VALUES ('1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0', 'Larry_Le_Malicieux', 'Larry', 'email@email.com', '1234',
        'Je vais te toucher la nuit 😈', NULL, '2025-02-13T12:00:00.000Z'),
       ('3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d', 'DrMad', 'Victor_Vile', 'email@email.com', '1234',
        'Docteur mais vendeur de virus', NULL, '2025-02-13T12:00:00.000Z'),
       ('74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a', 'The_Honored_One', 'Satoru_Gojo', 'email@email.com', '1234',
        'THROUGHOUT HEAVEN AND EARTH, I ALONE AM THE HONORED ONE 😌🤌🫴🟣', NULL, '2025-02-13T12:00:00.000Z'),
       ('ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8', 'Rivers_King', 'Tahm_Kench', 'email@email.com', '1234',
        'Démon de lavarice.', NULL, '2025-02-13T12:00:00.000Z'),
       ('1cfa873e-25d1-4e9f-b7c9-6e92d2b5a3f8', 'Gustave_Le_Rat', 'Gustave', 'email@email.com', '1234',
        'Le maitre des Rats', NULL, '2025-02-13T12:00:00.000Z'),
       ('9c90b4c8-8f85-45f5-a3b3-c372f65b9c4a', 'Le_Maitre_du_Mal', 'Veigar', 'email@email.com', '1234',
        'Sous 300 stack dAP',
        NULL, '2025-02-13T12:00:00.000Z'),
       ('86a2c8b4-e30e-4029-b0b0-7fd8f3b0cc1d', 'N1_sur_R34', 'Ahri', 'email@email.com', '1234',
        'Jai neuf "queues" et un nombre de vie infinies 😏', NULL, '2025-02-13T12:00:00.000Z'),
       ('a6c05755-0b6c-4677-b5a4-dc88cf8f2b73', 'Gobble', 'Gobble_Le_Squelette', 'email@email.com', '1234', 'Je suis Gobble;
)', NULL, '
2025-02-13T12:00:00.000Z'),
       ('c40fe5b5-67a5-4a5b-bfad-66e84602e374', 'La_Terreur_Noir', 'ChoGath', 'email@email.com', '1234',
        'MMMMH, Jai bien mangé 😋', NULL, '2025-02-13T12:00:00.000Z');

-- Insert posts
INSERT INTO posts (id, authorId, image, description)
VALUES ('e8384c6f-9ef5-4625-bb98-49bcb4768799', '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0', null, 'C''est moi 😏'),
       ('f7d95187-4c7d-47fa-a2fa-ef0b365b8820', '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d', null,
        'Le Crohn est disponible en vente 💊🦠'),
       ('f6893db9-5a57-4c3a-b5fc-604d4027d4d1', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a', null,
        'Vie dma mère, j''avais gagné...'),
       ('1d839dec-0600-45a9-9e8f-0b309540cd80', 'ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8', null,
        'En lane comme en cuisine, je suis le seul qui mérite de te bouffer le cul 👅'),
       ('b46093f4-6d0e-4fa0-96d5-bfb5cd1e73ff', '1cfa873e-25d1-4e9f-b7c9-6e92d2b5a3f8', null, 'Mortels 🥱🥱🥱'),
       ('5d6d35c0-13ad-433b-bd8d-e86c42c5bc65', '9c90b4c8-8f85-45f5-a3b3-c372f65b9c4a', null,
        'C''est TA end.... 😈'),
       ('7b402c6f-6493-4530-b5db-80b32c4089fe', '86a2c8b4-e30e-4029-b0b0-7fd8f3b0cc1d', null,
        'J''en connais qui aurait choisir Briar 😡'),
       ('918ce171-bad9-4848-b7ca-105f8fef4053', 'a6c05755-0b6c-4677-b5a4-dc88cf8f2b73', null,
        '❌ aura ✅ Gobble ❓ Squelette'),
       ('18f90f97-7e87-4975-a781-e1cc84f92967', 'c40fe5b5-67a5-4a5b-bfad-66e84602e374', null, '🐉');

-- Insert likes
INSERT INTO likes (idpost, iduser)
VALUES ('e8384c6f-9ef5-4625-bb98-49bcb4768799', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a'),
       ('f7d95187-4c7d-47fa-a2fa-ef0b365b8820', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a'),
       ('f6893db9-5a57-4c3a-b5fc-604d4027d4d1', '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0'),
       ('b46093f4-6d0e-4fa0-96d5-bfb5cd1e73ff', 'ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8'),
       ('7b402c6f-6493-4530-b5db-80b32c4089fe', 'a6c05755-0b6c-4677-b5a4-dc88cf8f2b73');

-- Insert loves
INSERT INTO loves (idpost, iduser)
VALUES ('e8384c6f-9ef5-4625-bb98-49bcb4768799', '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d'),
       ('f7d95187-4c7d-47fa-a2fa-ef0b365b8820', '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0'),
       ('f7d95187-4c7d-47fa-a2fa-ef0b365b8820', 'ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8'),
       ('1d839dec-0600-45a9-9e8f-0b309540cd80', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a'),
       ('b46093f4-6d0e-4fa0-96d5-bfb5cd1e73ff', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a');

-- Insert saves
INSERT INTO saves (idpost, iduser)
VALUES ('e8384c6f-9ef5-4625-bb98-49bcb4768799', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a'),
       ('f6893db9-5a57-4c3a-b5fc-604d4027d4d1', '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d'),
       ('b46093f4-6d0e-4fa0-96d5-bfb5cd1e73ff', '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0');

-- Insert Message
INSERT INTO messages (id, senderId, receiverId, content, createdAt)
VALUES ('b3a5f8cf-b0ac-4725-b7f1-3c72edb65b08', '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0',
        '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d', 'Salut Dr.Mad, comment ça va ?', '2025-02-14T14:00:00.000Z'),
       ('c17e1d1a-5156-46a3-9d91-b343c6f66e89', '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d',
        '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0', 'Bien et toi Larry ?', '2025-02-15T14:05:00.000Z'),
       ('f2685a7a-8a8e-4ff6-924a-4c5b9d3d4729', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a',
        'ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8', 'Yo Kench, toujours aussi gourmand ?', '2025-02-16T14:10:00.000Z'),
       ('41fd8cfe-dcb0-44e0-b7a7-3d3c9e4e4b65', 'ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8',
        '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a', 'Toujours, mon cher Gojo. Tu veux un contrat ?',
        '2025-02-17T14:15:00.000Z'),
       ('92a74e1b-c0f9-4a62-bf7b-8f7ac7023a21', '1cfa873e-25d1-4e9f-b7c9-6e92d2b5a3f8',
        '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d', 'Docteur, jai un rat enrhumé, un remède ?', '2025-02-18T14:20:00.000Z'),
       ('1bbd8bdf-e3ea-423d-9cf9-520b6b8eae57', '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d',
        '1cfa873e-25d1-4e9f-b7c9-6e92d2b5a3f8', 'Un virus en bouteille, ça tintéresse ?', '2025-02-19T14:25:00.000Z'),
       ('db34f577-97f0-4972-8b2f-f31c7fa327b6', '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0',
        '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a', 'Satoru, tes toujours le plus fort ?', '2025-02-20T14:30:00.000Z'),
       ('b132db0c-2f5a-4bdf-8c68-3f0d84f9a233', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a',
        '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0', 'Évidemment, qui pourrait me battre ?', '2025-02-21T14:35:00.000Z'),
       ('d8b9a8ac-0fd2-4569-bf8f-d6cc49cf3db1', 'ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8',
        '1cfa873e-25d1-4e9f-b7c9-6e92d2b5a3f8', 'Tas vu les dernières updates sur les rats ?',
        '2025-02-22T14:40:00.000Z'),
       ('d7b5686b-d998-4a71-a739-08f7c6e6f6f3', '1cfa873e-25d1-4e9f-b7c9-6e92d2b5a3f8',
        'ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8', 'Pas encore, mais je vais me renseigner.', '2025-02-23T14:45:00.000Z');

-- Insert Follower
INSERT INTO follower (iduser, iduser_1)
VALUES ('3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d', '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0'), -- Dr.Mad suit Larry
       ('74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a', '1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0'), -- The Honored One suit Larry
       ('1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0', '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d'), -- Larry suit Dr.Mad
       ('1cfa873e-25d1-4e9f-b7c9-6e92d2b5a3f8', '3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d'), -- Gustave suit Dr.Mad
       ('1f8d37d2-0f29-4fbd-8db4-8d5c9871aee0', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a'), -- Larry suit The Honored One
       ('3e1b9f66-87c2-4a4f-bb87-8c1e923b7f8d', '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a'), -- Dr.Mad suit The Honored One
       ('ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8',
        '74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a'),                                         -- Rivers King suit The Honored One
       ('74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a', '1cfa873e-25d1-4e9f-b7c9-6e92d2b5a3f8'), -- The Honored One suit Gustave
       ('74d2730e-51e5-4e42-a7d1-b91d1a6f3f1a',
        'ff9b8d21-3ea4-4f0a-bb8f-c3d2a6f491c8'); -- The Honored One suit Rivers King

