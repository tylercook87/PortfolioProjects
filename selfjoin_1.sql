--Your task is to produce a trips table that lists all the cheapest possible trips that can be done in two or fewer stops.
CREATE TABLE flights (
    id INTEGER PRIMARY KEY,
    origin TEXT NOT NULL,
    destination TEXT NOT NULL,
    cost INTEGER NOT NULL
);

-- Insert sample data
INSERT INTO flights (origin, destination, cost) VALUES
('SFO', 'JFK', 500),
('SFO', 'LAX', 150),
('LAX', 'JFK', 350),
('JFK', 'LAX', 400),
('JFK', 'SFO', 450),
('SFO', 'ORD', 200),
('ORD', 'JFK', 300),
('ORD', 'LAX', 250),
('LAX', 'ORD', 200),
('ORD', 'SFO', 350),

WITH
-- Step 1: Direct Flights
DirectFlights AS (
    SELECT 
        origin, 
        destination, 
        cost AS total_cost
    FROM flights
),
-- Step 2: One-stop Flights
OneStopFlights AS (
    SELECT 
        f1.origin, 
        f2.destination, 
        (f1.cost + f2.cost) AS total_cost
    FROM flights f1
    JOIN flights f2 ON f1.destination = f2.origin
    WHERE f1.origin <> f2.destination
),
-- Step 3: Two-stop Flights
TwoStopFlights AS (
    SELECT 
        f1.origin, 
        f3.destination, 
        (f1.cost + f2.cost + f3.cost) AS total_cost
    FROM flights f1
    JOIN flights f2 ON f1.destination = f2.origin
    JOIN flights f3 ON f2.destination = f3.origin
    WHERE f1.origin <> f3.destination
),
-- Combine all flights and find the cheapest one for each origin-destination pair
AllFlights AS (
    SELECT * FROM DirectFlights
    UNION ALL
    SELECT * FROM OneStopFlights
    UNION ALL
    SELECT * FROM TwoStopFlights
),
-- Select the cheapest flight for each origin-destination pair
CheapestTrips AS (
    SELECT 
        origin, 
        destination, 
        MIN(total_cost) AS total_cost
    FROM AllFlights
    GROUP BY origin, destination
)
-- Final output
SELECT 
    origin, 
    destination, 
    total_cost
FROM CheapestTrips
ORDER BY origin, destination;
