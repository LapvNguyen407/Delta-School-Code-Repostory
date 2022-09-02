BEGIN TRANSACTION;

DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS exampletags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS examples;
DROP TABLE IF EXISTS users CASCADE;
DROP SEQUENCE IF EXISTS seq_user_id CASCADE;
DROP SEQUENCE IF EXISTS seq_example_id CASCADE;

CREATE SEQUENCE seq_user_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;

CREATE SEQUENCE seq_example_id
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE;


CREATE TABLE users (
	user_id int DEFAULT nextval('seq_user_id'::regclass) NOT NULL,
	username varchar(50) NOT NULL UNIQUE,
	password_hash varchar(200) NOT NULL,
	role varchar(50) NOT NULL,
  email varchar(64) NOT NULL,
	CONSTRAINT PK_user PRIMARY KEY (user_id)
);

CREATE TABLE subscriptions (
  subscriber_id int NOT NULL,
  creator_id int NOT NULL,

  CONSTRAINT PK_creator_subscriber PRIMARY KEY (creator_id, subscriber_id),
	CONSTRAINT FK_creatorid_users FOREIGN KEY(creator_id) REFERENCES users(user_id),
	CONSTRAINT FK_subscriberid_users FOREIGN KEY(subscriber_id) REFERENCES users(user_id)
);

CREATE TABLE examples (
	example_id int DEFAULT nextval('seq_example_id'::regclass) NOT NULL,
	title varchar(32) NOT NULL,
	code text,
	description text NOT NULL,
  language varchar(16) NOT NULL,
	user_id int NOT NULL,
	attribution varchar(32),
  status varchar(8) NOT NULL,
  image_link varchar (512),
  
	CONSTRAINT PK_example_id PRIMARY KEY (example_id),
	CONSTRAINT FK_user_id FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE tags (
	tag_id serial NOT NULL,
	name varchar(32) NOT NULL,
	CONSTRAINT PK_tag_id PRIMARY KEY (tag_id)
);

CREATE TABLE exampletags (
	example_id int NOT NULL,
	tag_id int NOT NULL,
	CONSTRAINT PK_example_tag PRIMARY KEY (example_id, tag_id),
	CONSTRAINT FK_exampleid_examples FOREIGN KEY(example_id) REFERENCES examples(example_id),
	CONSTRAINT FK_tagid_tags FOREIGN KEY(tag_id) REFERENCES tags(tag_id)
);



INSERT INTO users (username,password_hash,role, email) VALUES ('lappie','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_USER', 'big_lappie@yahoo.com');
INSERT INTO users (username,password_hash,role, email) VALUES ('admin','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_ADMIN', 'admin@deltaschools.com');
INSERT INTO users (username,password_hash,role, email) VALUES ('user3','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_USER', 'big_lappie@yahoo.com');
INSERT INTO users (username,password_hash,role, email) VALUES ('justin','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_USER', 'justinthomasdecker@gmail.com');


INSERT INTO tags(name)
VALUES ('data');

INSERT INTO tags(name)
VALUES ('formatting');

INSERT INTO tags(name)
VALUES ('variables');

INSERT INTO tags(name)
VALUES ('statements');

INSERT INTO tags(name)
VALUES ('operators');

INSERT INTO tags(name)
VALUES ('objects');

INSERT INTO tags(name)
VALUES ('limiters');

INSERT INTO tags(name)
VALUES ('default');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Java’s simplest data types',
'public class Main {
  public static void main(String[] args) {
    int myNum = 5;               // Integer (whole number) 
    float myFloatNum = 5.99f;    // Floating point number
    char myLetter = ''D'';         // Character
    boolean myBool = true;       // Boolean
    String myText = "Hello";     // String
    System.out.println(myNum);
    System.out.println(myFloatNum);
    System.out.println(myLetter);
    System.out.println(myBool);
    System.out.println(myText);
  }
}',
'These are the five most common data types you’ll work with in basic java. Int is used for store whole numbers, both negative and positive. Float is used for decimal aka floating point numbers. Char is for holding a single alphanumeric character or special character(such as ~). Boolean only holds one of two specific values, it can either be true or false. String is a more complex data type that holds a series, or array, of data that are the char data type.',
'Java',
'https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Using if/else in java',
'public class Main {
  public static void main(String[] args) {
    int time = 22;
    if (time < 10) {
      System.out.println("Good morning.");
    } else if (time < 20) {
      System.out.println("Good day.");
    } else {
      System.out.println("Good evening.");
    }
  }
}
// Outputs "Good evening."
',
'If/else is used in java to let your code make branching decisions. You start by adding an if followed by a statement that evaluates to either true or false. Then if the statement is true java will run the code within the brackets of the if statement. If the statement is not true then java will ignore whatever is in the brackets completely and instead check to see if there is an else or elseif immediately after the closing bracket. When there is an else if attached, java will evaluate that statement in the same way as before and either run the code or skip it and look for another elseif or else. An else statement has no associated true/false statement to check, so if java reaches that else then the code in the bracket will always run. ',
'Java',
'https://www.w3schools.com/', 2, 'PUBLIC');
INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Looping 10 times with a for loop','public class Main {
  public static void main(String[] args) {
    for (int i = 0; i <= 10; i++) {
      System.out.println(i);
    }
   }
}',
'In java if you want to run the same code a certain number of times, then instead of writing the same code over and over you will use a loop. One type of loop is the for loop. A for loop is made of three parts: an index, an exit condition, and an iterator. The index is a variable that keeps track of how many times the loop has run, and changes after every loop. The exit condition is a true/false statement that is checked after each cycle of the loop. If the exit condition is ever false then the loop ends and java proceeds through the code as normal. The iterator is the way the code changes after every time the loop runs. 
Here, our index is an integer named i which starts at 0. Our exit condition is when (i <= 10) is found to be false. Our iterator is i++, which is a bit of code that says to increase the value of i by 1. This can also be written as i = i+1. The code inside the loop is to print the value of i, so this loop will print the numbers 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10.',
'Java',
'https://www.w3schools.com/', 2, 'PUBLIC');
INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Using Maps in Java',
'// Import the HashMap class
import java.util.HashMap;

public class Main {
  public static void main(String[] args) {
    // Create a HashMap object called capitalCities
    HashMap<String, String> capitalCities = new HashMap<String, String>();

    // Add keys and values (Country, City)
    capitalCities.put("England", "London");
    capitalCities.put("Germany", "Berlin");
    capitalCities.put("Norway", "Oslo");
    capitalCities.put("USA", "Washington DC");
    System.out.println(capitalCities); //print every item

    capitalCities.get("England"); //access a single item
    capitalCities.remove("England"); //remove a single item
    capitalCities.clear();		//remove every item
    System.out.println(capitalCities); //print newly empty map
  }
}
',
'Maps are a complex data type in java that can associate a key with a value. It is often compared to a dictionary where the key is the word you’re looking up and the value is the definition. In this example it is used to store countries and their capitals. The key is the country and the city is the value. So by putting in the country you can find out the capital. You can add items to the map with put, you can look values up by putting the key into a get statement, and you can remove an item by providing the key to the remove method, and you can completely empty the map by using the clear method.',
'Java',
'https://www.w3schools.com/', 2, 'PUBLIC');
INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Using lists in Java',
'import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
    ArrayList<String> cars = new ArrayList<String>();
    cars.add("Volvo");
    cars.add("BMW");
    cars.add("Ford");
    cars.add("Mazda");
    System.out.println(cars); //prints out [Volvo, BMW, Ford, Mazda]

    cars.get(0);		//accesses the first item in the list
    cars.set(0, "Opel"); //changes the first item to be Opel
    cars.remove(0);		//removes the first item in the list
    cars.clear();		//removes all the items in the list
    System.out.println("Size of list: " + cars.size());	//reports the number of items in the list (which is 0 after the clear())

  }
}
',
'Lists in java are just what they sound like: a series of values of the same data type in a row. Lists can grow and shrink in size, and you can reassign and delete values in the list.',
'Java',
'https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status)
VALUES('Introduction',
			  'body {
  background-color: lightblue;
}

h1 {
  color: white;
  text-align: center;
}

p {
  font-family: verdana;
  font-size: 20px;
}',
'CSS stands for Cascading Style Sheets
CSS describes how HTML elements are to be displayed on screen, paper, or in other media
CSS saves a lot of work. It can control the layout of multiple web pages all at once
External stylesheets are stored in CSS files',
'CSS',
'https://www.w3schools.com/', 2, 'PUBLIC');


INSERT INTO examples(title, code, description, language, attribution, user_id, status)
VALUES ('Using Selectors In CSS',
'p {
  text-align: center;
  color: red;
}',
'CSS selectors are used to "find" (or select) the HTML elements you want to style.
We can divide CSS selectors into five categories:
Simple selectors (select elements based on name, id, class)
Combinator selectors (select elements based on a specific relationship between them)
Pseudo-class selectors (select elements based on a certain state)
Pseudo-elements selectors (select and style a part of an element)
Attribute selectors (select elements based on an attribute or attribute value)
This page will explain the most basic CSS selectors.',
'CSS',
'https://www.w3schools.com/', 2, 'PUBLIC'); 

INSERT INTO examples(title, code, description, language, attribution, user_id, status)
VALUES('CSS Colors',
'&lt;h1 style="background-color:DodgerBlue;"&gt;Hello World&lt;/h1&gt;
&lt;p style="background-color:Tomato;" &gt; Lorem ipsum... &lt;/p&gt;',
'You can set the background color for HTML elements:',
'CSS',
'https://www.w3schools.com/', 2, 'PUBLIC'); 


INSERT INTO examples(title, code, description, language, attribution, user_id, status)
VALUES('CSS Margins','p {
  margin-top: 100px;
  margin-bottom: 100px;
  margin-right: 150px;
  margin-left: 80px;
}',
'Margins are used to create space around elements, outside of any defined borders.
The CSS margin properties are used to create space around elements, outside of any defined borders.
With CSS, you have full control over the margins. There are properties for setting the margin for each side of an element (top, right, bottom, and left).
Margin - Individual Sides
CSS has properties for specifying the margin for each side of an element:
margin-top
margin-right
margin-bottom
margin-left
All the margin properties can have the following values:
auto - the browser calculates the margin
length - specifies a margin in px, pt, cm, etc.
% - specifies a margin in % of the width of the containing element
inherit - specifies that the margin should be inherited from the parent element
Tip: Negative values are allowed.',
'CSS',
'https://www.w3schools.com/', 2, 'PUBLIC'); 



INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES('Select', 'SELECT column_name(s)
FROM table_name;',
'When we use a SELECT statement, we want to be sure to indicate which table we are selecting from. To select multiple columns, separate them with commas. To select all columns from a table, use the "*" descriptor.',
'SQL',
'awahba', 2, 'PUBLIC');


INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES('Where', 'SELECT column_name(s)
FROM table_name
WHERE boolean_condition = true;', 'Sometimes we want to limit the number of rows we select from a table; the WHERE statement helps us with this. The WHERE statement must be a boolean condition such as "=" or "<". Note that in SQL, the "=" sign is used in place of an equality (as opposed to "==" in Java for example). The following are examples of boolean operators: <, >, =, <=, >=, !=. Note that "!=" works for numerical comparisons, but IS NOT is needed for varchar values.', 
	'SQL',
  'awahba', 2, 'PUBLIC');
	

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('And',
'SELECT column_name(s)
FROM table_name
WHERE boolean_condition AND another_boolean_condition;',' When needing to compare multiple boolean conditions at once, an AND operator may be used. In this case, both boolean conditions must be true for the select to return the desired rows from the table.',
  'SQL',
  'awahba', 2, 'PUBLIC');
	
INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Or','SELECT column_name(s)
FROM table_name
WHERE boolean_condition OR boolean_condition;','In the case where one of two boolean conditions needs to be true, an OR operator may be used. In this example, only one or both of the boolean conditions need be true to return the desired rows from the table. Only when both are false will the row not be returned.',
  'SQL',
  'awahba', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('In','SELECT column_name(s)
FROM table_name
WHERE column_name IN (value1, value2, ...);',' Similar to OR, IN allows you to select multiple values in a WHERE clause. IN is a shorthand for multiple OR statments. Note that the parenthesis around the values are mandatory. You can use NOT IN for the opposite selection.',
  'SQL',
  'awahba', 2, 'PUBLIC');


INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Like and ILike','SELECT column_name(s)
FROM table_name
WHERE column_to_select_from LIKE ''x''' ,' When using a search-like function, SQL allows the use of LIKE to select rows with values containing the result. The use of "%" can be used as a wildcard placeholder at the beginning or end of the selection to specify the search begins or ends with the element. For example, the selection ''%Smith'' will return all rows in the selected column where the value ends with "Smith". This will return elements such as "John Smith" or "WordSmith". You can include "%" before and after the element to search for internal terms. A search with "%or%" will return "Moreno". ILIKE functions as LIKE, but is case insensitive.',
  'SQL',
  'awahba', 2, 'PUBLIC');
	

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Between','SELECT column_name(s)
FROM table_name
WHERE column_to_search BETWEEN var1 AND var2;','Finds rows in the selected columns from the indicated table that are between var1 and var2 inclusively.',
  'SQL',
  'awahba', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Introduction','','JavaScript is the worlds most popular programming language.
JavaScript is the programming language of the Web.
JavaScript is easy to learn.
JavaScript is one of the 3 languages all web developers must learn:
   1. HTML to define the content of web pages
   2. CSS to specify the layout of web pages
   3. JavaScript to program the behavior of web pages',
   'JavaScript',
   'https://www.w3schools.com/', 2, 'PUBLIC');
   
   
   
   INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
   VALUES ('JavaScript Assignment','var x = 10;
x += 5;
console.log(x);
x -= 5;
console.log(x);
x *= 5;
console.log(x);
x /= 5;
console.log(x);
x = 6;
x %= 5;
console.log(x);','Assignment operators assign values to JavaScript variables. The += assignment operator adds a value to a variable. The -= assignment operator subtracts a value from a variable. The *= assignment operator multiplies a variable. The /= assignment divides a variable. The %= assignment operator assigns a remainder to a variable.',
'JavaScript',
'https://www.w3schools.com/', 2, 'PUBLIC');
   
   
   INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
   VALUES ('JavaScript Variables','var x = 5;
var y = 6;
var z = x + y;

console.log(z)','4 Ways to Declare a JavaScript Variable:
Using var
Using let
Using const
Using nothing

Always declare JavaScript variables with var,let, orconst.
The var keyword is used in all JavaScript code from 1995 to 2015.
The let and const keywords were added to JavaScript in 2015.
If you want your code to run in older browser, you must use var.',
'JavaScript',
'https://www.w3schools.com/', 2, 'PUBLIC');
   
   
   INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
   VALUES ('JavaScript Operators','let x = 5;
let y = 2;
let z = x + y;
console.log("x: " + x + ", y: " + y + ", z: " + z);

x = 3;
y = 6;
z = x * y;
console.log("x: " + x + ", y: " + y + ", z: " + z);','The assignment operator (=) assigns a value to a variable.
The addition operator (+) adds numbers:
The multiplication operator (*) multiplies numbers.',
'JavaScript',
'https://www.w3schools.com/', 2, 'PUBLIC');
   
   
   INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
   VALUES ('JavaScript Objects','const car = {
     type:"Fiat", model:"500", color:"white"
     }
     console.log(car.type);
     console.log(car.model);
     console.log(car.color);','Real Life Objects, Properties, and Methods
In real life, a car is an object.
A car has properties like weight and color, and methods like start and stop:
All cars have the same properties, but the property values differ from car to car.
All cars have the same methods, but the methods are performed at different times.
You have already learned that JavaScript variables are containers for data values.
This code assigns a simple value (Fiat) to a variable named car:',
'JavaScript',
'https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('SQL Joins','SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
FROM Orders
INNER JOIN Customers ON Orders.CustomerID=Customers.CustomerID;','A JOIN clause is used to combine rows from two or more tables, based on a related column between them.
Different Types of SQL JOINs
Here are the different types of the JOINs in SQL:
(INNER) JOIN: Returns records that have matching values in both tables
LEFT (OUTER) JOIN: Returns all records from the left table, and the matched records from the right table
RIGHT (OUTER) JOIN: Returns all records from the right table, and the matched records from the left table
FULL (OUTER) JOIN: Returns all records when there is a match in either left or right table', 'SQL','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('SQL PRIMARY KEY Constraint','CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (ID)
);','The PRIMARY KEY constraint uniquely identifies each record in a table.
Primary keys must contain UNIQUE values, and cannot contain NULL values.
A table can have only ONE primary key; and in the table, this primary key can consist of single or multiple columns (fields).
The following SQL creates a PRIMARY KEY on the "ID" column when the "Persons" table is created:','SQL','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description,language,attribution, user_id, status) 
VALUES ('SQL UPDATE Statement','UPDATE Customers
SET ContactName = "Alfred Schmidt", City= "Frankfurt"
WHERE CustomerID = 1;
WHERE condition;','The UPDATE statement is used to modify the existing records in a table.
Be careful when updating records in a table! Notice the WHERE clause in the UPDATE statement. The WHERE clause specifies which record(s) that should be updated. If you omit the WHERE clause, all records in the table will be updated!', 'SQL','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('SQL DELETE Statement','DELETE FROM Customers WHERE CustomerName="Alfreds Futterkiste";','The DELETE statement is used to delete existing records in a table.
It is possible to delete all rows in a table without deleting the table. This means that the table structure, attributes, and indexes will be intact:', 'SQL','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language,attribution,  user_id, status) 
VALUES ('JavaScript Let','let x = "John Doe";

let x = 0;

// SyntaxError: "x" has already been declared','The let keyword was introduced in ES6 (2015).
Variables defined with let cannot be Redeclared.
Variables defined with let must be Declared before use.
Variables defined with let have Block Scope.
Variables defined with let cannot be redeclared.
You cannot accidentally redeclare a variable.','JavaScript','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description,language,attribution, user_id, status)
VALUES ('JavaScript Arrays','const cars = [
 "Saab",
  "Volvo",
  "BMW"
  ]
  console.log(cars[0]) //Arrays start counting at 0, so this is the first entry
  console.log(cars[2])','Using an array literal is the easiest way to create a JavaScript Array.
It is a common practice to declare arrays with the const keyword.
Spaces and line breaks are not important. A declaration can span multiple lines:','JavaScript','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('JavaScript if, else, and else if','let hour = 22;
if (hour < 18) {
  greeting = "Good day";
} else {
  greeting = "Good evening";
}
console.log(greeting)','onditional statements are used to perform different actions based on different conditions.
Very often when you write code, you want to perform different actions for different decisions.
You can use conditional statements in your code to do this.
In JavaScript we have the following conditional statements:
Use if to specify a block of code to be executed, if a specified condition is true
Use else to specify a block of code to be executed, if the same condition is false
Use else if to specify a new condition to test, if the first condition is false
Use switch to specify many alternative blocks of code to be executed','JavaScript','https://www.w3schools.com/
', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('JavaScript Strings','let carName = "Volvo XC60"
console.log(carName.length) //print the length of the string
console.log(carName.slice(0,5)) //prints characters 0 - 5','A JavaScript string is zero or more characters written inside quotes. Strings have many built in functions such as length and slice.','JavaScript','https://www.w3schools.com/
', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Java Classes and Objects','public class Main {
  int x = 5;

  public static void main(String[] args) {
    Main myObj = new Main();
    System.out.println(myObj.x);
  }
}','Java is an object-oriented programming language.
Everything in Java is associated with classes and objects, along with its attributes and methods. For example: in real life, a car is an object. The car has attributes, such as weight and color, and methods, such as drive and brake.
A Class is like an object constructor, or a "blueprint" for creating objects.
To create a class, use the keyword class:
Create an Object
In Java, an object is created from a class. We have already created the class named Main, so now we can use this to create objects.
To create an object of Main, specify the class name, followed by the object name, and use the keyword new:','Java','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Java Methods','public class Main {
  static void myMethod() {
    System.out.println("I just got executed!");
  }

  public static void main(String[] args) {
    myMethod();
  }
}','A method is a block of code which only runs when it is called.
You can pass data, known as parameters, into a method.
Methods are used to perform certain actions, and they are also known as functions.
Why use methods? To reuse code: define the code once, and use it many times.
A method must be declared within a class. It is defined with the name of the method, followed by parentheses (). Java provides some pre-defined methods, such as System.out.println(), but you can also create your own methods to perform certain actions:
To call a method in Java, write the methods name followed by two parentheses () and a semicolon;
In the following example, myMethod() is used to print a text (the action), when it is called:','Java','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Java Booleans','public class Main {
  public static void main(String[] args) {
    boolean isJavaFun = true;
    boolean isFishTasty = false;
    System.out.println(isJavaFun);     // Outputs true
    System.out.println(isFishTasty);   // Outputs false
    int x = 10;
    int y = 9;
    System.out.println(x > y); // returns true, because 10 is higher than 9
    }
  }','Java Booleans
Very often, in programming, you will need a data type that can only have one of two values, like:
YES / NO
ON / OFF
TRUE / FALSE
For this, Java has a boolean data type, which can take the values true or false.
A boolean type is declared with the boolean keyword and can only take the values true or false:
A Boolean expression is a Java expression that returns a Boolean value: true or false.
You can use a comparison operator, such as the greater than (>) operator to find out if an expression (or a variable) is true:','Java','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Java Strings','public class Main {
  public static void main(String[] args) {
    String greeting = "Hello";
    String txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    System.out.println("The length of the txt string is: " + txt.length());
    }
  }','Strings are used for storing text.
A String variable contains a collection of characters surrounded by double quotes:
A String in Java is actually an object, which contain methods that can perform certain operations on strings. For example, the length of a string can be found with the length() method:','Java','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Java Constructors','// Create a Main class
public class Main {
  int x;  // Create a class attribute

  // Create a class constructor for the Main class
  public Main() {
    x = 5;  // Set the initial value for the class attribute x
  }

  public static void main(String[] args) {
    Main myObj = new Main(); // Create an object of class Main (This will call the constructor)
    System.out.println(myObj.x); // Print the value of x
  }
}
//Output 5','A constructor in Java is a special method that is used to initialize objects. The constructor is called when an object of a class is created. It can be used to set initial values for object attributes:','Java','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('CSS Text','body {
  background-color: lightgrey;
  color: blue;
}

h1 {
  background-color: black;
  color: white;
}

div {
  background-color: blue;
  color: white;
}','CSS has a lot of properties for formatting text.
The color property is used to set the color of the text. The color is specified by:
a color name - like "red"
a HEX value - like "#ff0000"
an RGB value - like "rgb(255,0,0)"
Look at CSS Color Values for a complete list of possible color values.

The PUBLIC text color for a page is defined in the body selector.','CSS','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('CSS Fonts','.p1 {
  font-family: "Times New Roman", Times, serif;
}

.p2 {
  font-family: Arial, Helvetica, sans-serif;
}

.p3 {
  font-family: "Lucida Console", "Courier New", monospace;
}','In CSS there are five generic font families:
Serif fonts have a small stroke at the edges of each letter. They create a sense of formality and elegance.
Sans-serif fonts have clean lines (no small strokes attached). They create a modern and minimalistic look.
Monospace fonts - here all the letters have the same fixed width. They create a mechanical look. 
Cursive fonts imitate human handwriting.
Fantasy fonts are decorative/playful fonts.
All the different font names belong to one of the generic font families. 
The font-family property should hold several font names as a "fallback" system, to ensure maximum compatibility between browsers/operating systems. Start with the font you want, and end with a generic family (to let the browser pick a similar font in the generic family, if no other fonts are available). The font names should be separated with comma.
Specify some different fonts for three paragraphs:','CSS','https://www.w3schools.com/
', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('CSS Lists','ul.a {
  list-style-type: circle;
}

ul.b {
  list-style-type: square;
}

ol.c {
  list-style-type: upper-roman;
}

ol.d {
  list-style-type: lower-alpha;
}','In HTML, there are two main types of lists:
unordered lists (<ul>) - the list items are marked with bullets
ordered lists (<ol>) - the list items are marked with numbers or letters
The CSS list properties allow you to:

Set different list item markers for ordered lists
Set different list item markers for unordered lists
Set an image as the list item marker
Add background colors to lists and list items
The list-style-type property specifies the type of list item marker.
The following example shows some of the available list item markers:','CSS','https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Introduction',
		'',
		'Java is a popular programming language, created in 1995.

It is owned by Oracle, and more than 3 billion devices run Java.

It is used for:
		Mobile applications (specially Android apps), Desktop applications, Web applications, Web servers and application servers, Games, Database connection, and much, much more!',
		'Java', 'https://www.w3schools.com/', 2, 'PUBLIC');
		
INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Introduction',
		'',
		'SQL is a standard language for accessing and manipulating databases.
		Although SQL is an ANSI/ISO standard, there are different versions of the SQL language.

However, to be compliant with the ANSI standard, they all support at least the major commands (such as SELECT, UPDATE, DELETE, INSERT, WHERE) in a similar manner.',
		'SQL', 'https://www.w3schools.com/', 2, 'PUBLIC');

INSERT INTO examples(title, code, description, language, attribution, user_id, status, image_link) 
VALUES ('Java While Loop','// Create a Main class
public class Main {
  public static void main(String[] args) {
    int num1 = 0;
    int num2 = 5;

    while(num1 < num2){
      num1 = num1 + 1;
      System.out.println(num1);
    }
    System.out.println("Finished with the while loop");
  }
}','A while loop is a loop that runs continuously until the boolean statement it is given is False.','Java','https://www.w3schools.com/', 1, 'PRIVATE', 'https://firebasestorage.googleapis.com/v0/b/deltaschools-30b88.appspot.com/o/image140.png?alt=media&token=4389a20f-cc1c-483b-89b8-9ddac99d27c6');

INSERT INTO examples(title, code, description, language, attribution, user_id, status) 
VALUES ('Java String Concatenation','// Create a Main class
public class Main {
  public static void main(String[] args) {
    String word1 = "One";
    String word2 = "Two";
    System.out.println(word1);
    System.out.println(word2);
    String word1andword2 = word1 + word2;
    System.out.println(word1andword2);
  }
}','In Java you can add strings together. This results in the second string being added to the end of the first string.','Java','https://www.w3schools.com/', 1, 'PENDING');

-- HERE BEGINS THE TAGGING --
INSERT INTO exampletags (example_id, tag_id)
VALUES (1,8),(2,8),(3,8),(4,8),(5,8),(6,8),(7,8),(8,8),(9,8),(10,8),
(11,8),(12,8),(13,8),(14,8),(15,8),(16,8),(17,8),(18,8),(19,8),(20,8),(21,8),(22,8),
(23,8),(24,8),(25,8),(26,8),(27,8),(28,8),(29,8),(30,8),(31,8),(32,8),(33,8),(34,8),
(35,8),(36,8),(37,8),(38,8),(39,8);

INSERT INTO exampletags (example_id, tag_id)
VALUES (1,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (1,6);

INSERT INTO exampletags (example_id, tag_id)
VALUES (2,4);

INSERT INTO exampletags (example_id, tag_id)
VALUES (2,5);

INSERT INTO exampletags (example_id, tag_id)
VALUES (3,5);

INSERT INTO exampletags (example_id, tag_id)
VALUES (3,3);

INSERT INTO exampletags (example_id, tag_id)
VALUES (4,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (4,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (4,3);

INSERT INTO exampletags (example_id, tag_id)
VALUES (5,5);

INSERT INTO exampletags (example_id, tag_id)
VALUES (5,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (6,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (6,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (7,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (7,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (8,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (9,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (10,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (11,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (12,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (13,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (14,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (15,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (15,4);

INSERT INTO exampletags (example_id, tag_id)
VALUES (16,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (16,4);

INSERT INTO exampletags (example_id, tag_id)
VALUES (17,5);

INSERT INTO exampletags (example_id, tag_id)
VALUES (17,4);

INSERT INTO exampletags (example_id, tag_id)
VALUES (17,3);

INSERT INTO exampletags (example_id, tag_id)
VALUES (17,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (18,4);

INSERT INTO exampletags (example_id, tag_id)
VALUES (18,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (18,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (19,3);

INSERT INTO exampletags (example_id, tag_id)
VALUES (19,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (19,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (20,5);

INSERT INTO exampletags (example_id, tag_id)
VALUES (20,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (20,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (21,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (21,6);

INSERT INTO exampletags (example_id, tag_id)
VALUES (21,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (22,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (23,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (24,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (25,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (26,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (26,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (26,3);

INSERT INTO exampletags (example_id, tag_id)
VALUES (27,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (28,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (28,3);

INSERT INTO exampletags (example_id, tag_id)
VALUES (28,5);

INSERT INTO exampletags (example_id, tag_id)
VALUES (29,3);

INSERT INTO exampletags (example_id, tag_id)
VALUES (29,4);

INSERT INTO exampletags (example_id, tag_id)
VALUES (29,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (30,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (30,4);

INSERT INTO exampletags (example_id, tag_id)
VALUES (31,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (31,3);

INSERT INTO exampletags (example_id, tag_id)
VALUES (31,6);

INSERT INTO exampletags (example_id, tag_id)
VALUES (32,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (32,4);

INSERT INTO exampletags (example_id, tag_id)
VALUES (33,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (33,7);

INSERT INTO exampletags (example_id, tag_id)
VALUES (34,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (35,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (36,2);

INSERT INTO exampletags (example_id, tag_id)
VALUES (37,1);

INSERT INTO exampletags (example_id, tag_id)
VALUES (37,2);

insert into subscriptions
(creator_id, subscriber_id)
values
(1,3), (1,4);
COMMIT TRANSACTION;
