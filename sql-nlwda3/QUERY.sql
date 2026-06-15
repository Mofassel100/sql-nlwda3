DROP TABLE IF EXISTS Bookings;

DROP TABLE IF EXISTS Matches;

DROP TABLE IF EXISTS Users;

-- user create
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (
        role IN (
            'Ticket Manager',
            'Football Fan'
        )
    ),
    phone_number VARCHAR(20)
);
-- Matches table created
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    fixture VARCHAR(100) NOT NULL,
    tournament_category VARCHAR(50) NOT NULL,
    base_ticket_price DECIMAL(10, 2) NOT NULL CHECK (base_ticket_price >= 0),
    match_status VARCHAR(20) NOT NULL CHECK (
        match_status IN (
            'Available',
            'Selling Fast',
            'Sold Out',
            'Postponed'
        )
    )
);

-- booking table created
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    match_id INT NOT NULL,
    seat_number VARCHAR(10),
    payment_status VARCHAR(20) CHECK (
        payment_status IN (
            'Pending',
            'Confirmed',
            'Cancelled',
            'Refunded'
        )
    ),
    total_cost DECIMAL(10, 2) CHECK (total_cost >= 0),
    FOREIGN KEY (user_id) REFERENCES Users (user_id),
    FOREIGN KEY (match_id) REFERENCES Matches (match_id)
);
-- user data inserted
INSERT INTO
    Users (
        user_id,
        full_name,
        email,
        role,
        phone_number
    )
VALUES (
        1,
        'Tanvir Rahman',
        'tanvir@mail.com',
        'Football Fan',
        '+8801711111111'
    ),
    (
        2,
        'Asif Haque',
        'asif@mail.com',
        'Football Fan',
        '+8801722222222'
    ),
    (
        3,
        'Sajjad Rahman',
        'sajjad@mail.com',
        'Ticket Manager',
        '+8801733333333'
    ),
    (
        4,
        'Jannat Ara',
        'jannat@mail.com',
        'Football Fan',
        NULL
    );
-- Matches data inserted
INSERT INTO
    Matches (
        match_id,
        fixture,
        tournament_category,
        base_ticket_price,
        match_status
    )
VALUES (
        101,
        'Real Madrid vs Barcelona',
        'Champions League',
        150.00,
        'Available'
    ),
    (
        102,
        'Man City vs Liverpool',
        'Premier League',
        120.00,
        'Selling Fast'
    ),
    (
        103,
        'Bayern Munich vs PSG',
        'Champions League',
        130.00,
        'Available'
    ),
    (
        104,
        'AC Milan vs Inter Milan',
        'Serie A',
        90.00,
        'Sold Out'
    ),
    (
        105,
        'Juventus vs Roma',
        'Serie A',
        80.00,
        'Available'
    );
--  Booking data inserted
INSERT INTO
    Bookings (
        booking_id,
        user_id,
        match_id,
        seat_number,
        payment_status,
        total_cost
    )
VALUES (
        501,
        1,
        101,
        'A-12',
        'Confirmed',
        150.00
    ),
    (
        502,
        1,
        102,
        'B-04',
        'Confirmed',
        120.00
    ),
    (
        503,
        2,
        101,
        'A-13',
        'Confirmed',
        150.00
    ),
    (
        504,
        2,
        101,
        NULL,
        NULL,
        150.00
    ),
    (
        505,
        3,
        102,
        'C-20',
        'Pending',
        120.00
    );
--query 1
select
    match_id,
    fixture,
    base_ticket_price
from matches
where
    match_status = 'Available'

-- -- query 2
select user_id, full_name, email
from users
WHERE
    full_name Ilike 'Tanvir%'
    or full_name Ilike '%Haque%';

-- Query 3

select
    booking_id,
    user_id,
    match_id,
    COALESCE(
        payment_status,
        'Action Required'
    ) AS systematic_status
from bookings
where
    payment_status is null;

--Query 4:
select bo.booking_id, us.full_name, mat.fixture, bo.total_cost
from
    bookings bo
    inner join users us on bo.user_id = us.user_id
    inner join matches mat on bo.match_id = mat.match_id
order by bo.booking_id;

-- query 5
select us.user_id, us.full_name, book.booking_id
from users us full
    join bookings book on us.user_id = book.user_id;

-- query 6
select booking_id, match_id, total_cost
from bookings
where
    total_cost > (
        select avg(total_cost)
        from bookings
    )

-- query 7
select
    match_id,
    fixture,
    base_ticket_price
from matches
order by base_ticket_price desc
limit 2
offset
    1;