CREATE TABLE USER (
    _id VARCHAR(37),
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(60) NOT NULL,
    role ENUM('USER', 'TRAINER') DEFAULT 'USER',
    constraint pk_user primary key (_id)
);

CREATE TABLE COURSE (
    _id VARCHAR(37),
    name VARCHAR(50) NOT NULL,
    description TEXT,
    duration INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    mode ENUM('RECORDED','LIVE') NOT NULL,
    due_date DATE,
    constraint pk_course primary key (_id)
);

CREATE TABLE TRAINER_COURSE (
    _uid VARCHAR(37),
    _cid VARCHAR(37),
    constraint fk_user_id foreign key (_uid) references USER (_id) ON DELETE CASCADE, 
    constraint fk_course_id foreign key (_cid) references COURSE (_id) ON DELETE CASCADE, 
    constraint pk_trainer_course primary key (_uid,_cid)
);

CREATE TABLE API_KEYS (
    _id VARCHAR(37),
    _key VARCHAR(64) NOT NULL,
    constraint pk_apis primary key(_id)
);

CREATE TABLE ENROLEMENT (
    _id VARCHAR(37),
    _uid VARCHAR(37) NOT NULL,
    _cid VARCHAR(37) NOT NULL,
     constraint fk_enrol_user_id foreign key (_uid) references USER (_id) ON DELETE CASCADE, 
    constraint fk_enrol_course_id foreign key (_cid) references COURSE (_id) ON DELETE CASCADE,
    constraint pk_enrollement primary key (_id)
);

CREATE INDEX USER_IDX ON USER(email,password);
CREATE INDEX ENROLLMENT_IDX ON ENROLEMENT(_uid, _cid);
CREATE INDEX API_KEYS_IDX ON API_KEYS(_key);