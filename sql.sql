CREATE TABLE CLIENTS (
    ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    TYPES VARCHAR2(256) NOT NULL,
	FULL_NAME VARCHAR2(50) NOT NULL,
    ADDRESS VARCHAR2(100) NOT NULL,
    PHONE VARCHAR2(12) UNIQUE,
    EMAIL VARCHAR2(320) UNIQUE,
    BIRTHDAY TIMESTAMP,
    PRIMARY KEY (ID)
);
CREATE INDEX IDX_CLIENT_FULL_NAME ON CLIENTS (FULL_NAME) PARALLEL 8 ONLINE;

CREATE TABLE ACCOUNTS (
  ACCOUNT_NUMBER NUMBER GENERATED BY DEFAULT AS IDENTITY,
  OWNER NUMBER NOT NULL,
  ACCOUNT NUMBER NOT NULL,
  DATE_OPEN TIMESTAMP NOT NULL,
  VALIDITY_PERIOD TIMESTAMP,
  AMOUNT DECIMAL NOT NULL,
  FOREIGN KEY (OWNER) REFERENCES CLIENTS(ID),
  PRIMARY KEY (ACCOUNT_NUMBER)
);
CREATE INDEX IDX_ACCOUNT_ACCOUNT ON ACCOUNTS (ACCOUNT);

CREATE TABLE TRANSACTIONS (
  ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
  ACCOUNT_FROM_ID NUMBER NOT NULL,
  ACCOUNT_TO_ID NUMBER NOT NULL,
  AMOUNT DECIMAL NOT NULL,
  DATA_TIME TIMESTAMP NOT NULL,
  TRANSACTION_TYPE VARCHAR2(30) NOT NULL,
  PRIMARY KEY (ID)
);

CREATE TABLE BALANCE (
    ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    ACCOUNT_ID NUMBER UNIQUE,
    BALANCE DECIMAL,
	CURRENCY_CODE VARCHAR2(30) NOT NULL,
    FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS (ACCOUNT_NUMBER),
    PRIMARY KEY (ID)
);

CREATE TABLE PAYMENT_REQUEST (
  ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
  CLIENT_ID NUMBER NOT NULL,
  ACCOUNT_FROM_ID NUMBER NOT NULL,
  ACCOUNT_TO_ID NUMBER NOT NULL,
  BILLING_AMOUNT DECIMAL NOT NULL,
  REQUEST_DATE TIMESTAMP NOT NULL,
  PAYMENT_TEMPLATE_ID NUMBER NOT NULL,
  FOREIGN KEY (CLIENT_ID) REFERENCES CLIENTS (ID),
  FOREIGN KEY (ACCOUNT_FROM_ID) REFERENCES ACCOUNTS (ACCOUNT_NUMBER),
  FOREIGN KEY (ACCOUNT_TO_ID) REFERENCES ACCOUNTS (ACCOUNT_NUMBER),
  PRIMARY KEY (ID)
);

 CREATE TABLE PAYMENT_TEMPLATE (
  ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
  CLIENT_ID NUMBER NOT NULL,
  ACCOUNT_FROM_ID NUMBER NOT NULL,
  ACCOUNT_TO_ID NUMBER NOT NULL,
  BILLING_AMOUNT DECIMAL NOT NULL,
  FOREIGN KEY (CLIENT_ID) REFERENCES CLIENTS (ID),
  FOREIGN KEY (ACCOUNT_FROM_ID) REFERENCES ACCOUNTS (ACCOUNT_NUMBER),
  FOREIGN KEY (ACCOUNT_TO_ID) REFERENCES ACCOUNTS (ACCOUNT_NUMBER),
  PRIMARY KEY (ID)
);

CREATE TABLE PAYMENT_STATUS (
    ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    PREVIOUS_PAYMENT_STATUS_ID NUMBER NOT NULL,
    PAYMENT_REQUEST_ID NUMBER NOT NULL,
    ACCOUNT_FROM_ID NUMBER NOT NULL,
    ACCOUNT_TO_ID NUMBER NOT NULL,
    AMOUNT DECIMAL NOT NULL,
    PAYMENT_STATE NUMBER NOT NULL,
    TRANSACTION_ID NUMBER,
    DATE_CHANGE_STATUS TIMESTAMP NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE AUDIT_PAYMENT (
    ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    PAYMENT_STATUS_ID NUMBER NOT NULL,
    DATE_EVENT TIMESTAMP NOT NULL,
    TYPE_ID NUMBER NOT NULL,
    MESSAGE VARCHAR2(300),
    FOREIGN KEY (PAYMENT_STATUS_ID) REFERENCES PAYMENT_STATUS (ID),
    PRIMARY KEY (ID)
);
