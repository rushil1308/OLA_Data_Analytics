create database Ola;
use Ola;
select * from bookings;

#1. Retrieve all successful bookings:
create view Successful_Booking as
select * from bookings where Booking_Status = 'Success';

Select * from Successful_Booking; 

#2. Find the average ride distance for each vehicle type:
create view avg_ride_distance as
select Vehicle_Type, avg(Ride_Distance)
as avg_distance from bookings
group by vehicle_type;

select * from avg_ride_distance;

#3. Get the total number of cancelled rides by customers:
create view cancelled_rides_by_customers as
select count(*) from bookings
where Booking_Status = "Canceled by Customer";

select * from cancelled_rides_by_customers;

#4. List the top 5 customers who booked the highest number of rides:
create view Top_5_Customers as
Select customer_id, count(booking_id) as total_rides
from bookings
group by customer_id
order by total_rides desc limit 5; 

select * from Top_5_Customers;

#5. Get the number of rides cancelled by drivers due to personal and car-related issues:
create view rides_cancelled_by_drivers as
select count(*) from bookings where Canceled_Rides_by_Driver = "Personal & Car related issue";

select * from rides_cancelled_by_drivers; 

#6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
create view maximum_and_minimum_driver_ratings_for_Prime_Sedan as
select max(Driver_Ratings) as max_rating,
min(Driver_Ratings) as min_rating
from bookings where Vehicle_Type = "Prime Sedan";

select * from maximum_and_minimum_driver_ratings_for_Prime_Sedan;

#7. Retrieve all rides where payment was made using UPI:
create view payment_by_UPI as
select * from bookings
where payment_method = "Upi";

select * from payment_by_UPI;

#8. Find the average customer rating per vehicle type:
create view avg_cust_rating as
select Vehicle_Type, avg(Customer_Rating) as avg_customer_rating
from bookings
group by Vehicle_Type;

select * from avg_cust_rating;

#9. Calculate the total booking value of rides completed successfully:
create view total_successfull_rides as
select sum(Booking_Value) as total_successful_ride_value
from bookings
where booking_status = "Success";

select * from total_successfull_rides;

#10. List all incomplete rides along with the reason:
create view incomplete_rides as
select booking_id, incomplete_rides_reason
from bookings
where incomplete_rides = "Yes";

select * from incomplete_rides;


#11. Identify the most consistent customers (who always give high ratings and rarely cancel)

create view consistent_customers as
select customer_id, 
       avg(Customer_Rating) as avg_rating,
       sum(case when Booking_Status = 'Canceled by Customer' then 1 else 0 end) as total_cancellations
from bookings
group by customer_id
having avg_rating > 4.5 and total_cancellations < 2;

select * from consistent_customers;

#12. Detect potential fraudulent behavior (many cancellations after booking within a short time)

create view potential_fraud_customers as
select customer_id, count(*) as suspicious_cancels
from bookings
where Booking_Status = 'Canceled by Customer'
  and timestampdiff(minute, Booking_Time, Cancellation_Time) <= 5
group by customer_id
having suspicious_cancels >= 3;

select * from potential_fraud_customers;


#13. Calculate driver performance consistency

create view driver_rating_stddev as
select Driver_ID,
       avg(Driver_Ratings) as avg_rating,
       stddev_pop(Driver_Ratings) as rating_variance
from bookings
group by Driver_ID
having count(*) >= 10;

select * from driver_rating_stddev;


#14. Time-based ride trend analysis

create view daily_successful_bookings as
select dayname(Booking_Time) as day_of_week,
       count(*) as total_successful
from bookings
where Booking_Status = 'Success'
group by day_of_week
order by total_successful desc;

select * from daily_successful_bookings;

#15. Vehicle type efficiency: Ride count vs. average cancellation

create view vehicle_efficiency_ratio as
select Vehicle_Type,
       sum(case when Booking_Status = 'Success' then 1 else 0 end) as success_count,
       sum(case when Booking_Status like 'Canceled%' then 1 else 0 end) as cancel_count,
       round(1.0 * sum(case when Booking_Status = 'Success' then 1 else 0 end) / 
             nullif(sum(case when Booking_Status like 'Canceled%' then 1 else 0 end), 0), 2) as success_to_cancel_ratio
from bookings
group by Vehicle_Type
having cancel_count > 0;

select * from vehicle_efficiency_ratio;

#16. Repeat customers for specific vehicle types

create view loyal_vehicle_customers as
select customer_id, Vehicle_Type, count(*) as total_bookings
from bookings
group by customer_id, Vehicle_Type
having total_bookings > 5;

select * from loyal_vehicle_customers;


#17. Booking value distribution by payment method

create view payment_method_value_distribution as
select payment_method,
       count(*) as total_rides,
       sum(Booking_Value) as total_value,
       avg(Booking_Value) as avg_value
from bookings
where Booking_Status = 'Success'
group by payment_method;

select * from payment_method_value_distribution;


#18. Peak hour booking analysis

create view peak_booking_hour as
select hour(Booking_Time) as hour_of_day, count(*) as total_bookings
from bookings
group by hour_of_day
order by total_bookings desc;

select * from peak_booking_hour;

#19. Customer churn prediction basis (no booking in last X days)

create view inactive_customers as
select distinct customer_id
from bookings
where customer_id not in (
    select customer_id
    from bookings
    where Booking_Time >= now() - interval 30 day
);

select * from inactive_customers;


#20. Driver utilization efficiency

create view driver_utilization as
select Driver_ID,
       date(Booking_Time) as ride_date,
       count(*) as rides_per_day
from bookings
where Booking_Status = 'Success'
group by Driver_ID, ride_date
order by rides_per_day desc;

select * from driver_utilization;



















