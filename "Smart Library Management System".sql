create database library_management;
use library_management;
create table authors (
    author_id int primary key,
    name varchar(20),
    email varchar(30)
);

create table Books (
    book_id int primary key,
    title varchar(50),
    author_id int,
    category varchar(30),
    isbn varchar(20),
    published_date date,
    price decimal(10,2),
    available_copies int,
    foreign key (author_id) references authors(author_id)
);

create table Members (
    member_id int primary key,
    name varchar(20),
    email varchar(30),
    phone_number varchar(15),
    membership_date date
);

create table Transactions (
    transaction_id int primary key,
    member_id int,
    book_id int,
    borrow_date date,
    return_date date,
    fine_amount decimal(10,2),
    foreign key (member_id) references Members(member_id),
    foreign key (book_id) references Books(book_id)
);
INSERT INTO authors VALUES
(1, 'J.K. Rowling', 'jk@example.com'),
(2, 'George Orwell', 'orwell@example.com'),
(3, 'Dan Brown', NULL);

INSERT INTO Books VALUES
(101, 'Harry Potter', 1, 'Fantasy', '1111', '2000-07-01', 500, 5),
(102, '1984', 2, 'Science', '2222', '1949-06-08', 300, 2),
(103, 'Da Vinci Code', 3, 'Thriller', '3333', '2003-03-18', 450, 0);

INSERT INTO Members VALUES
(201, 'Alice', 'alice@mail.com', '1234567890', '2021-01-10'),
(202, 'Bob', NULL, '9876543210', '2019-05-15'),
(203, 'Charlie', 'charlie@mail.com', '5555555555', '2023-02-20');

INSERT INTO Transactions VALUES
(301, 201, 101, '2024-01-01', '2024-01-10', 0),
(302, 202, 102, '2024-02-01', NULL, 50),
(303, 201, 102, '2024-03-01', '2024-03-10', 0);

##Insert a new member
insert into Members values(204, 'David', 'david@mail.com', '7877606885' ,CURDATE());

##Update available copies of a book
Update Books
set available_copies = available_copies - 1 
where book_id = 101;

##Delete inactive members (no borrow in last 1 year)
delete from Members
where member_id not in (select distinct member_id from Transactions
where borrow_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

##Retrieve all available books
select * from Books where available_copies > 0;

##Retrieve books published before 2015
select * from Books 
where published_date < '2015-01-01';

##Retrieve top 5 most expensive books
select * from Books order by
price desc
limit 5;

##Retrieve members who joined before 2022
select * from Members 
where membership_date < '2022-01-01';

##Retrieve science books with price less than 500
select * from books 
where category = 'science' and price < 500;


##Retrieve books that are out of stock
select * from books 
where available_copies = 0;

##Retrieve members who joined after 2020 or have more than 3 books
select * from members 
where membership_date > '2020-01-01' 
or member_id in (select member_id from transactions group by member_id 
having count(*) > 3
);

##Display all books sorted by title
select * from books order by title asc;

##Count total books borrowed by each member
select member_id, count(*) as total_books
from transactions
group by member_id;

##Count total books in each category
select category, count(*) as total_books
from books
group by category;

##Count total books in each category
select category, count(*) from books group by category;


##Calculate average price of books
select avg(price) from books;

##Find the most borrowed book
select book_id, count(*) as borrow_count
from transactions
group by book_id
order by borrow_count desc
limit 1;

##Calculate total fine collected
select sum(fine_amount) from transactions;

##Retrieve book titles with author names
select b.title, a.name
from books b
inner join authors a on b.author_id = a.author_id;

##Retrieve all members with their borrowed books
select m.name, t.book_id
from members m
left join transactions t on m.member_id = t.member_id;

##Retrieve books that were never borrowed
select b.title
from transactions t
right join books b on t.book_id = b.book_id
where t.book_id is null;

##Retrieve members who never borrowed books
select m.name
from members m
left join transactions t 
on m.member_id = t.member_id
where t.member_id is null;

##Find the book with highest number of borrowings
select book_id
from transactions
group by book_id
order by count(*) desc
limit 1;

##Retrieve members who never borrowed books
select * from members
where member_id not in (select member_id from transactions);

##Count books published each year
select year(published_date), count(*)
from books
group by year(published_date);

##Calculate days between borrow and return
select datediff(return_date, borrow_date) as days_borrowed
from transactions;

##Format borrow date
select date_format(borrow_date, '%d-%m-%Y')
from transactions;

##Convert book titles to uppercase
select UPPER(title) from Books;

##Remove extra spaces from author names
select trim(name) from authors;

##Replace NULL emails with 'Not Provided'
select ifnull(email, 'Not Provided') from authors;

##Rank books based on borrow count
select book_id,
rank() over (order by count(*) desc) as rank_no
from transactions
group by book_id;

##Count total books per member
select member_id,
count(*) over (partition by member_id) as total_books
from transactions;

##Calculate average borrow count
select book_id,
avg(count(*)) over ()
from transactions
group by book_id;

##Classify members as active or inactive
select member_id,
case 
    when max(borrow_date) >= date_sub(curdate(), interval 6 month)
    then 'active'
    else 'inactive'
end as status
from transactions
group by member_id;

##Categorize books
select title,
case 
    when year(published_date) > 2020 then 'new arrival'
    when year(published_date) < 2000 then 'classic'
    else 'regular'
end as category_type
from books;