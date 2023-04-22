/* 1) Which city has the best customers? We would like to throw a promotional
music festival in the city we made the most money. Write a query that returns 
one city that has the highest sum of invoice totals. Return both the city name 
& sum of all invoice totals*/
select Top 1 billing_city,cast(sum(total) as int) as Max_Invoice_Total from invoice
group by billing_city 
order by cast(sum(total) as int) desc

/* 2) Who is the best customer? The customer who has spent the most money will 
be declared the best customer. Write a query that retuens a person who has spent
most money*/
select Top 1 concat(c.first_name,' ',c.last_name) as Customer_Name,cast(Sum(i.total) as int)
Max_Sales from customer c 
inner join invoice i on c.customer_id = i.customer_id
group by concat(c.first_name,' ',c.last_name) 
order by cast(Sum(i.total) as int) desc

/* 3) Write query to return the email,first name,last name & genre of all rock music
listners. Return your list ordered alphabetically by email starting with "A"*/
select distinct c.first_name,c.last_name,c.email,g.Name from customer c 
inner join Invoice i on c.customer_id=i.customer_id
inner join invoice_line il on i.invoice_id= il.invoice_id
inner join Track t on t.track_id=il.track_id 
inner join Genre g on t.genre_id=g.genre_id
where g.name = 'Rock' order by c.email

/* 4) Lets invite the artists who have written the most rock music in our data set.
write a query that returns the artist name and total track count of the top 10
rock bands*/
select Top 10 a.name,count(*) as track_count from artist a 
inner join album al on a.artist_id=al.artist_id
inner join Track t on al.album_id=t.album_id
inner join genre g on g.genre_id=t.genre_id 
where g.name= 'Rock' group by a.name
order by count(*) desc

/* 5) Return all the track names that have a song length longer than the average
song length. Return the name and milli seconds for each track order by the song 
length with the longest songs listed first */
select Name,Milliseconds as length_of_song from track where Milliseconds
>(select AVG(Milliseconds) from Track) order by Milliseconds desc

/* 6) Find how much amount spent by each customer on artists? Write a query
to return customer name,artist name and total spent */
select concat(c.first_name,' ',c.last_name) as customer_name,a.name as artist_name,
cast(sum(il.unit_price*il.quantity) as int) as amount_spent
 from customer c inner join invoice i on c.customer_id=i.customer_id
inner join invoice_line il on i.invoice_id=il.invoice_id 
inner join Track t on t.track_id=il.track_id 
inner join album al on al.album_id=t.album_id 
inner join artist a on a.artist_id=al.artist_id 
group by concat(c.first_name,' ',c.last_name),
a.name order by cast(sum(il.unit_price*il.quantity) as int) desc

/* 7) We want to find out the most popular music genre for each country. We 
determine the most popular genre as the genre with the highest amount of purchases.
Write a query that returns each country along with the top genre. For countries 
where the maximum number of purchases is shared return all genre */
;with country_genre_table as 
(select i.billing_country as country,g.name as genrename,cast(sum(il.unit_price*il.quantity) as int) as Total_sales
from Invoice i 
inner join invoice_line il on i.invoice_id=il.invoice_id 
inner join track t on t.track_id = il.track_id
inner join genre g on g.genre_id=t.genre_id 
group by i.billing_country,g.name),
 rank_table as
 (select *,RANK() over(partition by country order by Total_sales desc)
 as rank_of_genre from country_genre_table)
 select country,genrename as top_genre from rank_table where rank_of_genre=1

 /* 8) Write a query that determines the customer that has spent the most on music
 for each country.Write a query that returns the country along with the top customer
 and how much they spent. For countries where the top amount spent is shared,provide
 all customers who spent this amount */
 select concat(c.first_name,' ',c.last_name) as customer_name,c.country,cast(sum(il.unit_price*il.quantity)
 as int) as amount_spent from customer c 
 inner join invoice i on c.customer_id=i.customer_id
 inner join invoice_line il on i.invoice_id = il.invoice_id
 group by concat(c.first_name,' ',c.last_name),c.country 
 order by cast(sum(il.unit_price*il.quantity) as int) desc
 
 /* 9) Who is the senior most employee based on job title? */
  select Top 1 * from employee order by levels desc

  /* 10) Which countries have the most invoices? */
  select Top 10 billing_country, count(invoice_id) as invoiceCount from invoice
  group by billing_country order by count(invoice_id) desc

  /* 11) What are Top 3 values of Total invoice? */
  select Top 3 total from invoice order by total desc
  

