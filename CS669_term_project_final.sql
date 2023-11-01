--Database implemented in PostgresQL
DROP VIEW IF EXISTS daily_nutrition;

DROP TABLE IF EXISTS Password_hist;
DROP TABLE IF EXISTS AT_template_day;
DROP TABLE IF EXISTS ST_template_day;
DROP TABLE IF EXISTS Template_day;
DROP TABLE IF EXISTS Template_hist;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS PB_hist;
DROP TABLE IF EXISTS Nutrition;
DROP TABLE IF EXISTS User_stats_hist;
DROP TABLE IF EXISTS Workout_exercise;
DROP TABLE IF EXISTS Workout;
DROP TABLE IF EXISTS User_account;
DROP TABLE IF EXISTS Statistic;
DROP TABLE IF EXISTS Food;
DROP TABLE IF EXISTS Template;
DROP TABLE IF EXISTS Exercise;


DROP SEQUENCE IF EXISTS password_hist_seq;
DROP SEQUENCE IF EXISTS exercise_seq;
DROP SEQUENCE IF EXISTS template_seq;
DROP SEQUENCE IF EXISTS food_seq;
DROP SEQUENCE IF EXISTS statistic_seq;
DROP SEQUENCE IF EXISTS user_seq;
DROP SEQUENCE IF EXISTS workout_seq;
DROP SEQUENCE IF EXISTS workout_exercise_seq;
DROP SEQUENCE IF EXISTS user_stats_hist_seq;
DROP SEQUENCE IF EXISTS nutrition_seq;
DROP SEQUENCE IF EXISTS pb_hist_seq;
DROP SEQUENCE IF EXISTS review_seq;
DROP SEQUENCE IF EXISTS template_hist_seq;
DROP SEQUENCE IF EXISTS template_day_seq;
DROP SEQUENCE IF EXISTS st_template_day_seq;
DROP SEQUENCE IF EXISTS at_template_day_seq;


CREATE TABLE Exercise (
	exercise_ID DECIMAL(12) PRIMARY KEY,
	exercise_name VARCHAR(25) NOT NULL,
	exercise_description VARCHAR(250) NOT NULL,
	exercise_tut_link VARCHAR(150)
);

CREATE TABLE Template (
	template_ID DECIMAL(12) PRIMARY KEY,
	template_name VARCHAR(25) NOT NULL,
	template_description VARCHAR(250) NOT NULL
);

CREATE TABLE Food (
	food_ID DECIMAL(12) PRIMARY KEY,
	food_name VARCHAR(50) NOT NULL,
	calories DECIMAL(4) NOT NULL,
	serving_size VARCHAR(20) NOT NULL,
	protein DECIMAL(3) NOT NULL,
	carbohydrate DECIMAL(3) NOT NULL,
	fat DECIMAL(3) NOT NULL,
	saturated_fat DECIMAL(3),
	trans_fat DECIMAL(3),
	fiber DECIMAL(3)
);

CREATE TABLE Statistic (
	statistic_ID DECIMAL(12) PRIMARY KEY,
	statistic_name VARCHAR(25) NOT NULL,
	statistic_description VARCHAR(250) NOT NULL
);

CREATE TABLE User_account (
	user_ID DECIMAL(12) PRIMARY KEY,
	template_ID DECIMAL(12),
	user_fname VARCHAR(25) NOT NULL,
	user_lname VARCHAR(25) NOT NULL,
	user_email VARCHAR(50) NOT NULL,
	username VARCHAR(50) NOT NULL,
	password VARCHAR(25) NOT NULL,
	CONSTRAINT user_template_FK 
		FOREIGN KEY(template_ID) REFERENCES Template (template_ID)
);

CREATE TABLE Workout (
	workout_ID DECIMAL(12) PRIMARY KEY,
	user_ID DECIMAL(12) NOT NULL,
	workout_date DATE NOT NULL,
	workout_notes VARCHAR(250),
	CONSTRAINT workout_user_FK
		FOREIGN KEY(user_ID) REFERENCES User_account(user_ID)
);

CREATE TABLE Workout_exercise (
	workout_exercise_ID DECIMAL(12) PRIMARY KEY,
	exercise_ID DECIMAL(12) NOT NULL,
	workout_ID DECIMAL(12) NOT NULL,
	number_of_sets DECIMAL(2),
	number_of_reps DECIMAL(2),
	weight DECIMAL(3),
	intensity DECIMAL(2),
	duration DECIMAL(2),
	CONSTRAINT we_exercise_FK
		FOREIGN KEY(exercise_ID) REFERENCES Exercise(exercise_ID),
	CONSTRAINT we_workout_FK
		FOREIGN KEY(workout_ID) REFERENCES Workout(workout_ID)
);

CREATE TABLE User_stats_hist (
	user_stats_hist_ID DECIMAL(12) PRIMARY KEY,
	user_ID DECIMAL(12) NOT NULL,
	statistic_ID DECIMAL(12) NOT NULL,
	old_value DECIMAL(4,1),
	new_value DECIMAL(4,1) NOT NULL,
	change_date DATE,
	CONSTRAINT ush_user_FK
		FOREIGN KEY (user_ID) REFERENCES User_account(user_ID),
	CONSTRAINT ush_statistic_FK
		FOREIGN KEY (statistic_ID) REFERENCES Statistic(statistic_ID)
);

CREATE TABLE Nutrition (
	nutrition_ID DECIMAL(12) PRIMARY KEY,
	user_ID DECIMAL(12) NOT NULL,
	food_ID DECIMAL(12) NOT NULL,
	meal VARCHAR(25),
	number_of_servings DECIMAL(2),
	date DATE,
	CONSTRAINT nutrition_user_fk
		FOREIGN KEY(user_ID) REFERENCES User_account(user_ID),
	CONSTRAINT nutrition_food_fk
		FOREIGN KEY(food_ID) REFERENCES Food(food_ID),
	CONSTRAINT valid_meal_check
		CHECK (meal IN ('breakfast', 'lunch', 'dinner', 'morning snack', 'afternoon snack', 'evening snack'))
);

CREATE TABLE PB_hist (
	pb_hist_ID DECIMAL(12) PRIMARY KEY,
	user_ID DECIMAL(12) NOT NULL,
	exercise_ID DECIMAL(12) NOT NULL,
	old_value DECIMAL(3),
	new_value DECIMAL(3) NOT NULL,
	change_date DATE,
	CONSTRAINT pbh_user_fk
		FOREIGN KEY(user_ID) REFERENCES User_account(user_ID),
	CONSTRAINT pbh_exercise_fk
		FOREIGN KEY(exercise_ID) REFERENCES Exercise(exercise_ID)
);

CREATE TABLE Review (
	review_ID DECIMAL(12) PRIMARY KEY,
	user_ID DECIMAL(12) NOT NULL,
	template_ID DECIMAL(12) NOT NULL,
	star_rating DECIMAL(2,1) NOT NULL,
	review VARCHAR(500) NOT NULL,
	CONSTRAINT review_user_fk
		FOREIGN KEY(user_ID) REFERENCES User_account(user_ID),
	CONSTRAINT review_template_fk
		FOREIGN KEY(template_ID) REFERENCES Template(template_ID)
);

CREATE TABLE Template_hist(
	template_hist_ID DECIMAL(12) PRIMARY KEY,
	user_ID DECIMAL(12) NOT NULL,
	old_template DECIMAL(12),
	new_template DECIMAL(12) NOT NULL,
	change_date DATE NOT NULL,
	CONSTRAINT th_user_fk
		FOREIGN KEY(user_ID) REFERENCES User_account(user_ID),
	CONSTRAINT th_old_template_fk
		FOREIGN KEY(old_template) REFERENCES Template(template_ID),
	CONSTRAINT th_new_template_fk
		FOREIGN KEY(new_template) REFERENCES Template(template_ID)
);

CREATE TABLE Template_day (
	template_day_ID DECIMAL(12) PRIMARY KEY,
	template_ID DECIMAL(12) NOT NULL,
	template_week DECIMAL(2) NOT NULL,
	template_day DECIMAL(1) NOT NULL,
	template_type VARCHAR(1),
	CONSTRAINT td_template_fk
		FOREIGN KEY(template_ID) REFERENCES Template(template_ID),
	CONSTRAINT valid_subtype_discriminator
		CHECK (template_type IN ('S', 'A'))
);

CREATE TABLE ST_template_day (
	template_day_ID DECIMAL(12) PRIMARY KEY,
	squat_sets DECIMAL(2),
	squat_reps DECIMAL(2),
	squat_multiplier DECIMAL(3,2),
	bench_sets DECIMAL(2),
	bench_reps DECIMAL(2),
	bench_multiplier DECIMAL(3,2),
	deadlift_sets DECIMAL(2),
	deadlift_reps DECIMAL(2),
	deadlift_multiplier DECIMAL(3,2),
	front_squat_sets DECIMAL(2),
	front_squat_reps DECIMAL(2),
	front_squat_multiplier DECIMAL(3,2),
	rom_deadlift_sets DECIMAL(2),
	rom_deadlift_reps DECIMAL(2),
	rom_deadlift_multiplier DECIMAL(3,2),
	barbell_row_sets DECIMAL(2),
	barbell_row_reps DECIMAL(2),
	barbell_row_multiplier DECIMAL(3,2),
	lat_pulldown_sets DECIMAL(2),
	lat_pulldown_reps DECIMAL(2),
	lat_pulldown_multiplier DECIMAL(3,2),
	barbell_curl_sets DECIMAL(2),
	barbell_curl_reps DECIMAL(2),
	barbell_curl_multiplier DECIMAL(3,2),
	dumbbell_curl_sets DECIMAL(2),
	dumbbell_curl_reps DECIMAL(2),
	dumbbell_curl_multiplier DECIMAL(3,2),
	CONSTRAINT ST_template_day_fk
		FOREIGN KEY(template_day_ID) REFERENCES Template_day(template_day_ID)
);

CREATE TABLE AT_template_day (
	template_day_ID DECIMAL(12) PRIMARY KEY,
	walking_duration DECIMAL(3),
	walking_RPE DECIMAL(2),
	running_duration DECIMAL(3),
	running_RPE DECIMAL(2),
	exercise_bike_duration DECIMAL(3),
	exercise_bike_RPE DECIMAL(2),
	jumping_rope_duration DECIMAL(3),
	jumping_rope_RPE DECIMAL(2),
	swimming_duration DECIMAL(3),
	swimming_RPE DECIMAL(2),
	elliptical_duration DECIMAL(3),
	elliptical_RPE DECIMAL(2),
	martial_arts_duration DECIMAL(3),
	martial_arts_RPE DECIMAL(2),
	dance_class_duration DECIMAL(3),
	dance_class_RPE DECIMAL(2),
	CONSTRAINT AT_template_day_fk
		FOREIGN KEY (template_day_ID) REFERENCES Template_day(template_day_ID)
);

CREATE TABLE Password_hist (
	password_hist_ID DECIMAL(12) PRIMARY KEY,
	user_ID DECIMAL(12) NOT NULL,
	old_value VARCHAR(25),
	new_value VARCHAR(25),
	change_date DATE,
	CONSTRAINT pw_hist_use_fk
		FOREIGN KEY (user_ID) REFERENCES User_account (user_ID)
);


CREATE SEQUENCE password_hist_seq START WITH 1;
CREATE SEQUENCE exercise_seq START WITH 1;
CREATE SEQUENCE template_seq START WITH 1;
CREATE SEQUENCE food_seq START WITH 1;
CREATE SEQUENCE statistic_seq START WITH 1;
CREATE SEQUENCE user_seq START WITH 1;
CREATE SEQUENCE workout_seq START WITH 1;
CREATE SEQUENCE workout_exercise_seq START WITH 1;
CREATE SEQUENCE user_stats_hist_seq START WITH 1;
CREATE SEQUENCE nutrition_seq START WITH 1;
CREATE SEQUENCE pb_hist_seq START WITH 1;
CREATE SEQUENCE review_seq START WITH 1;
CREATE SEQUENCE template_hist_seq START WITH 1;
CREATE SEQUENCE template_day_seq START WITH 1;
CREATE SEQUENCE st_template_day_seq START WITH 1;
CREATE SEQUENCE at_template_day_seq START WITH 1;

--Non-Transaction Insertions---------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
INSERT INTO TEMPLATE (template_id, template_name, template_description)
VALUES
	(nextval('template_seq'), 'Unleash the Beast', 'A basic 12-week powerlifting peaking program.'),
	(nextval('template_seq'), 'Muscle Blast', 'An 8-week program for adding muscle mass.'),
	(nextval('template_seq'), 'Couch to 5k', 'A 12-week program for running your first 5k.'),
	(nextval('template_seq'), 'Get fit!', 'A 12-week program to increase general cardiovascular fitness.'),
	(nextval('template_seq'), 'Stage Ready', 'A 16-week bodybuilding program to get into stage-ready shape.');

INSERT INTO User_account (user_ID, template_ID, user_fname, user_lname, user_email, username, password)
VALUES
  (nextval('user_seq'), NULL, 'John', 'Doe', 'john.doe@gmail.com', 'ironguy', 'pw1234'),
  (nextval('user_seq'), NULL, 'Jane', 'Smith', 'smithja@gmail.com', 'irongal', '98765'),
  (nextval('user_seq'), NULL, 'Robert', 'Johnson', 'bluesguy@outlook.com', 'HereIrun', 'password'),
  (nextval('user_seq'), NULL, 'Emily', 'Davis', 'e_davis@gmail.com', 'fitkid', 'dontask'),
  (nextval('user_seq'), NULL, 'Michael', 'Williams', 'iamme@yahoo.com', 'will_i_ams', 'password'),
  (nextval('user_seq'), NULL, 'Sarah', 'Brown', 'sarahbrown@alterra.com', 'sarahbrown', 'secret'),
  (nextval('user_seq'), NULL, 'David', 'Lee', 'leeleelee@bienvenudo.com', 'leeleelee', '1234!'),
  (nextval('user_seq'), NULL, 'Olivia', 'Anderson', 'o_m_anderson@example.com', 'olivesandiron', 'password8'),
  (nextval('user_seq'), NULL, 'James', 'Wilson', 'wilson@gmail.com', 'Iliftthingsup', '99999'),
  (nextval('user_seq'), NULL, 'Sophia', 'Martinez', 'coolgirlsophia@example.com', 'sophiamartinez', 'ilovethespicegirls');

INSERT INTO Food (food_ID, food_name, calories, serving_size, protein, carbohydrate, fat, saturated_fat, trans_fat, fiber)
VALUES
  (nextval('food_seq'), 'Chicken Breast', 165, '3 oz', 31, 0, 3, 1, 0, 0),
  (nextval('food_seq'), 'Salmon', 206, '3 oz', 22, 0, 13, 3, 0, 0),
  (nextval('food_seq'), 'Brown Rice', 215, '1 cup cooked', 5, 45, 1, 0, 0, 3),
  (nextval('food_seq'), 'Broccoli', 55, '1 cup cooked', 3, 11, 0, 0, 0, 5),
  (nextval('food_seq'), 'Avocado', 234, '1 avocado', 2, 12, 21, 3, 0, 10),
  (nextval('food_seq'), 'Oatmeal', 147, '1 cup cooked', 5, 25, 2, 0, 0, 4),
  (nextval('food_seq'), 'Spinach', 7, '1 cup cooked', 0, 1, 0, 0, 0, 0),
  (nextval('food_seq'), 'Almonds', 7, '1 oz (23 almonds)', 6, 6, 14, 1, 0, 3),
  (nextval('food_seq'), 'Greek Yogurt', 150, '6 oz', 15, 7, 8, 4, 0, 0),
  (nextval('food_seq'), 'Eggs', 68, '1 large egg', 5, 0, 5, 1, 0, 0),
  (nextval('food_seq'), 'Quinoa', 222, '1 cup cooked', 8, 39, 3, 0, 0, 5),
  (nextval('food_seq'), 'Banana', 105, '1 medium banana', 1, 27, 0, 0, 0, 3),
  (nextval('food_seq'), 'Grilled Cheese Sandwich', 352, '1 sandwich', 15, 30, 19, 9, 0, 2),
  (nextval('food_seq'), 'Pasta (Spaghetti)', 221, '1 cup cooked', 8, 43, 1, 0, 0, 2),
  (nextval('food_seq'), 'Apple', 95, '1 medium apple', 0, 25, 0, 0, 0, 4),
  (nextval('food_seq'), 'Carrots', 41, '1 cup raw', 0, 10, 0, 0, 0, 3),
  (nextval('food_seq'), 'Chocolate Chip Cookie', 49, '1 cookie', 0, 7, 2, 1, 0, 0),
  (nextval('food_seq'), 'Grilled Chicken Sandwich', 319, '1 sandwich', 32, 36, 4, 1, 0, 2),
  (nextval('food_seq'), 'Potato (Baked)', 161, '1 medium potato', 4, 37, 0, 0, 0, 4),
  (nextval('food_seq'), 'Milk (2% Fat)', 122, '1 cup', 8, 12, 5, 3, 0, 0),
  (nextval('food_seq'), 'Orange Juice', 112, '1 cup', 1, 26, 0, 0, 0, 0),
  (nextval('food_seq'), 'Tomato', 18, '1 medium tomato', 0, 3, 0, 0, 0, 1),
  (nextval('food_seq'), 'Peanut Butter', 188, '2 tbsp', 8, 6, 16, 3, 0, 2),
  (nextval('food_seq'), 'Strawberries', 49, '1 cup', 1, 12, 0, 0, 0, 3),
  (nextval('food_seq'), 'Lettuce', 5, '1 cup shredded', 0, 1, 0, 0, 0, 0);


INSERT INTO Exercise (exercise_ID, exercise_name, exercise_description, exercise_tut_link)
VALUES
  (nextval('exercise_seq'), 'Squat', 
   'Compound lower-body exercise. Squat down and stand back up with a barbell on your back.', 
   'https://www.youtube.com/watch?v=ZZRxPiKvoxY'),
  (nextval('exercise_seq'), 'Bench Press', 
   'Upper-body strength exercise. Lift a barbell from your chest to arms extended.', 
   'https://www.youtube.com/watch?v=rT7DgCr-3pg'),
  (nextval('exercise_seq'), 'Deadlift', 
   'Full-body compound exercise. Lift a barbell from the ground to a standing position.', 
   'https://www.youtube.com/shorts/McCDaAsSeRc'),
  (nextval('exercise_seq'), 'Front Squat', 
   'Compound lower-body exercise. Squat down with a barbell in front of your chest.', 
   'https://www.youtube.com/watch?v=v-mQm_droHg'),
  (nextval('exercise_seq'), 'Romanian Deadlift', 
   'Lower back and hamstring exercise. Hinge at the hips to lower and lift a barbell.', 
   'https://www.youtube.com/watch?v=_oyxCn2iSjU'),
  (nextval('exercise_seq'), 'Barbell Row', 
   'Upper back and bicep exercise. Bend over and row a barbell to your lower ribcage.', 
   'https://www.youtube.com/watch?v=FWJR5Ve8bnQ'),
  (nextval('exercise_seq'), 'Lat Pulldown', 
   'Upper back and bicep exercise. Pull a bar down to your chest from an overhead position.', 
   'https://www.youtube.com/watch?v=43hWj8mfYGY'),
  (nextval('exercise_seq'), 'Barbell Curl', 
   'Bicep isolation exercise. Curl a barbell with both hands to work your biceps.', 
   'https://www.youtube.com/watch?v=kwG2ipFRgfo'),
  (nextval('exercise_seq'), 'Dumbbell Curl', 
   'Bicep isolation exercise. Curl dumbbells to work your biceps.', NULL),
  (nextval('exercise_seq'), 'Running', 
   'Cardiovascular exercise. Run at a steady pace to improve cardiovascular fitness.', 
   'https://www.youtube.com/watch?v=brFHyOtTwH4'),
  (nextval('exercise_seq'), 'Walking', 'Low-impact cardiovascular exercise. Walk at a brisk pace to improve fitness.', NULL),
  (nextval('exercise_seq'), 'Stationary Bike', 
   'Indoor cycling exercise. Pedal on a stationary bike for a low-impact workout.', NULL),
  (nextval('exercise_seq'), 'Jumping Rope', 
   'Cardiovascular exercise. Jump rope for a high-intensity workout.', 'https://www.youtube.com/watch?v=FJmRQ5iTXKE'),
  (nextval('exercise_seq'), 'Swimming', 
   'Full-body cardiovascular exercise. Swim in a pool for a low-impact workout.', 
   'https://www.youtube.com/watch?v=pFN2n7CRqhw'),
  (nextval('exercise_seq'), 'Elliptical', 
   'Low-impact cardiovascular exercise. Use an elliptical machine for a full-body workout.', NULL),
  (nextval('exercise_seq'), 'Martial Arts', 
   'Various martial arts disciplines. Learn self-defense and discipline through training.', NULL),
  (nextval('exercise_seq'), 'Dance', 
   'Various dance styles. Enjoy dancing for fitness and self-expression.', 'https://www.youtube.com/watch?v=MwHtUKyLrac');

INSERT INTO Nutrition (nutrition_ID, user_ID, food_ID, meal, number_of_servings, date)
VALUES
  (nextval('nutrition_seq'), 1, 1, 'breakfast', 2, '2023-10-01'),
  (nextval('nutrition_seq'), 1, 4, 'lunch', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 1, 6, 'dinner', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 1, 7, 'morning snack', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 1, 2, 'afternoon snack', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 1, 3, 'breakfast', 1, '2023-10-02'),
  (nextval('nutrition_seq'), 1, 5, 'lunch', 2, '2023-10-02'),
  (nextval('nutrition_seq'), 1, 8, 'dinner', 1, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 2, 'breakfast', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 2, 7, 'lunch', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 2, 9, 'dinner', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 2, 8, 'morning snack', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 2, 4, 'afternoon snack', 1, '2023-10-01'),
  (nextval('nutrition_seq'), 2, 1, 'breakfast', 2, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 3, 'lunch', 1, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 5, 'dinner', 1, '2023-10-02'),
  (nextval('nutrition_seq'), 3, 3, 'breakfast', 2, '2023-10-03'),
  (nextval('nutrition_seq'), 3, 5, 'lunch', 1, '2023-10-03'),
  (nextval('nutrition_seq'), 3, 8, 'dinner', 1, '2023-10-03'),
  (nextval('nutrition_seq'), 3, 9, 'morning snack', 1, '2023-10-03'),
  (nextval('nutrition_seq'), 3, 2, 'afternoon snack', 1, '2023-10-03'),
  (nextval('nutrition_seq'), 3, 4, 'breakfast', 1, '2023-10-04'),
  (nextval('nutrition_seq'), 3, 6, 'lunch', 1, '2023-10-04'),
  (nextval('nutrition_seq'), 3, 10, 'dinner', 1, '2023-10-04'),
  (nextval('nutrition_seq'), 4, 4, 'breakfast', 1, '2023-10-05'),
  (nextval('nutrition_seq'), 4, 7, 'lunch', 1, '2023-10-05'),
  (nextval('nutrition_seq'), 4, 10, 'dinner', 1, '2023-10-05'),
  (nextval('nutrition_seq'), 4, 1, 'morning snack', 1, '2023-10-05'),
  (nextval('nutrition_seq'), 4, 2, 'afternoon snack', 1, '2023-10-05'),
  (nextval('nutrition_seq'), 4, 3, 'breakfast', 2, '2023-10-06'),
  (nextval('nutrition_seq'), 4, 5, 'lunch', 1, '2023-10-06'),
  (nextval('nutrition_seq'), 4, 8, 'dinner', 1, '2023-10-06'),
  (nextval('nutrition_seq'), 5, 5, 'breakfast', 1, '2023-10-07'),
  (nextval('nutrition_seq'), 5, 7, 'lunch', 2, '2023-10-07'),
  (nextval('nutrition_seq'), 5, 9, 'dinner', 1, '2023-10-07'),
  (nextval('nutrition_seq'), 5, 6, 'morning snack', 1, '2023-10-07'),
  (nextval('nutrition_seq'), 5, 10, 'afternoon snack', 1, '2023-10-07'),
  (nextval('nutrition_seq'), 5, 1, 'breakfast', 1, '2023-10-08'),
  (nextval('nutrition_seq'), 5, 3, 'lunch', 2, '2023-10-08'),
  (nextval('nutrition_seq'), 5, 8, 'dinner', 1, '2023-10-08'),
  (nextval('nutrition_seq'), 1, 1, 'lunch', 2, '2022-10-25'),
  (nextval('nutrition_seq'), 1, 4, 'lunch', 2, '2022-10-25'),
  (nextval('nutrition_seq'), 1, 2, 'lunch', 1, '2022-10-25'),
  (nextval('nutrition_seq'), 1, 1, 'dinner', 2, '2022-10-25'),
  (nextval('nutrition_seq'), 1, 5, 'dinner', 1, '2022-10-25'),
  (nextval('nutrition_seq'), 1, 7, 'dinner', 2, '2022-10-25'),
  (nextval('nutrition_seq'), 1, 1, 'breakfast', 2, '2023-02-13'),
  (nextval('nutrition_seq'), 1, 3, 'breakfast', 2, '2023-02-13'),
  (nextval('nutrition_seq'), 1, 1, 'lunch', 2, '2023-02-13'),
  (nextval('nutrition_seq'), 1, 4, 'lunch', 2, '2023-02-13'),
  (nextval('nutrition_seq'), 1, 5, 'dinner', 2, '2023-02-13'),
  (nextval('nutrition_seq'), 1, 7, 'dinner', 1, '2023-02-13'),
  (nextval('nutrition_seq'), 1, 3, 'dinner', 1, '2023-02-13'),
  (nextval('nutrition_seq'), 2, 1, 'breakfast', 3, CURRENT_DATE),
  (nextval('nutrition_seq'), 2, 3, 'breakfast', 2, CURRENT_DATE),
  (nextval('nutrition_seq'), 2, 1, 'lunch', 1, CURRENT_DATE),
  (nextval('nutrition_seq'), 2, 4, 'lunch', 3, CURRENT_DATE),
  (nextval('nutrition_seq'), 2, 5, 'dinner', 2, CURRENT_DATE),
  (nextval('nutrition_seq'), 2, 7, 'dinner', 3, CURRENT_DATE),
  (nextval('nutrition_seq'), 2, 3, 'dinner', 1, CURRENT_DATE), 
  (nextval('nutrition_seq'), 2, 1, 'breakfast', 3, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 3, 'breakfast', 2, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 1, 'lunch', 1, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 4, 'lunch', 3, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 5, 'dinner', 2, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 7, 'dinner', 3, '2023-10-02'),
  (nextval('nutrition_seq'), 2, 3, 'dinner', 1, '2023-10-02'),  
  (nextval('nutrition_seq'), 2, 1, 'breakfast', 3, '2023-10-03'),
  (nextval('nutrition_seq'), 2, 3, 'breakfast', 2, '2023-10-03'),
  (nextval('nutrition_seq'), 2, 4, 'breakfast', 1, '2023-10-03'),
  (nextval('nutrition_seq'), 2, 1, 'lunch', 2, '2023-10-03'),
  (nextval('nutrition_seq'), 2, 4, 'lunch', 3, '2023-10-03'),
  (nextval('nutrition_seq'), 2, 5, 'dinner', 2, '2023-10-03'),
  (nextval('nutrition_seq'), 2, 7, 'dinner', 3, '2023-10-03'),
  (nextval('nutrition_seq'), 2, 3, 'dinner', 1, '2023-10-03'),  
  (nextval('nutrition_seq'), 2, 1, 'breakfast', 3, '2023-10-04'),
  (nextval('nutrition_seq'), 2, 3, 'breakfast', 3, '2023-10-04'),
  (nextval('nutrition_seq'), 2, 1, 'lunch', 1, '2023-10-04'),
  (nextval('nutrition_seq'), 2, 4, 'lunch', 3, '2023-10-04'),
  (nextval('nutrition_seq'), 2, 8, 'lunch', 2, '2023-10-04'),
  (nextval('nutrition_seq'), 2, 5, 'dinner', 2, '2023-10-04'),
  (nextval('nutrition_seq'), 2, 7, 'dinner', 3, '2023-10-04'),
  (nextval('nutrition_seq'), 2, 3, 'dinner', 3, '2023-10-04'), 
  (nextval('nutrition_seq'), 2, 1, 'breakfast', 3, '2023-10-05'),
  (nextval('nutrition_seq'), 2, 3, 'breakfast', 2, '2023-10-05'),
  (nextval('nutrition_seq'), 2, 7, 'breakfast', 2, '2023-10-05'),
  (nextval('nutrition_seq'), 2, 1, 'lunch', 1, '2023-10-05'),
  (nextval('nutrition_seq'), 2, 4, 'lunch', 3, '2023-10-05'),
  (nextval('nutrition_seq'), 2, 5, 'dinner', 2, '2023-10-05'),
  (nextval('nutrition_seq'), 2, 7, 'dinner', 3, '2023-10-05'),
  (nextval('nutrition_seq'), 2, 3, 'dinner', 1, '2023-10-05'),
  (nextval('nutrition_seq'), 2, 1, 'lunch', 1, '2023-10-06'),
  (nextval('nutrition_seq'), 2, 4, 'lunch', 3, '2023-10-06'),
  (nextval('nutrition_seq'), 2, 5, 'dinner', 2, '2023-10-06'),
  (nextval('nutrition_seq'), 2, 7, 'dinner', 3, '2023-10-06'),
  (nextval('nutrition_seq'), 2, 3, 'dinner', 1, '2023-10-06'),
  (nextval('nutrition_seq'), 2, 1, 'breakfast', 3, '2023-10-07'),
  (nextval('nutrition_seq'), 2, 3, 'breakfast', 2, '2023-10-07'),
  (nextval('nutrition_seq'), 2, 1, 'lunch', 2, '2023-10-07'),
  (nextval('nutrition_seq'), 2, 4, 'lunch', 3, '2023-10-07'),
  (nextval('nutrition_seq'), 2, 5, 'dinner', 2, '2023-10-07'),
  (nextval('nutrition_seq'), 2, 7, 'dinner', 3, '2023-10-07'),
  (nextval('nutrition_seq'), 2, 3, 'dinner', 1, '2023-10-07'),
  (nextval('nutrition_seq'), 2, 1, 'dinner', 3, '2023-10-07');

INSERT INTO Workout (workout_ID, user_ID, workout_date, workout_notes)
VALUES
  (nextval('workout_seq'), 1, '2023-09-05', 'Feeling tired today.'),
  (nextval('workout_seq'), 1, '2023-09-12', 'Had a great workout!'),
  (nextval('workout_seq'), 1, '2023-09-19', 'Short workout today'),
  (nextval('workout_seq'), 2, '2023-09-06', 'Feeling energized!'),
  (nextval('workout_seq'), 2, '2023-09-13', 'Solid workout session.'),
  (nextval('workout_seq'), 2, '2023-09-20', 'Did not get enough sleep last night.'),
  (nextval('workout_seq'), 3, '2023-09-07', 'Took it easy today.'),
  (nextval('workout_seq'), 3, '2023-09-14', 'Feeling sore from yesterday.'),
  (nextval('workout_seq'), 3, '2023-09-21', 'Pushed myself to the limit!'),
  (nextval('workout_seq'), 4, '2023-09-08', 'Quick workout before work.'),
  (nextval('workout_seq'), 4, '2023-09-15', 'Not much time today.'),
  (nextval('workout_seq'), 5, '2023-09-09', 'Morning workout routine.'),
  (nextval('workout_seq'), 5, '2023-09-16', 'Had a great workout!'),
  (nextval('workout_seq'), 6, '2023-09-10', 'Feeling sluggish today.'),
  (nextval('workout_seq'), 7, '2023-09-11', 'Short and intense workout.'),
  (nextval('workout_seq'), 8, '2023-09-17', 'Focused on cardio today.'),
  (nextval('workout_seq'), 9, '2023-09-18', 'Working on strength training.'),
  (nextval('workout_seq'), 10, '2023-09-22', 'Feeling motivated!'),
  (nextval('workout_seq'), 10, '2023-09-23', 'Solid progress today.'),
  (nextval('workout_seq'), 10, '2023-09-24', 'Leg day!'),
  (nextval('workout_seq'), 10, '2023-09-27', 'Cardio and core workout.'),
  (nextval('workout_seq'), 10, '2023-09-29', 'Quick workout session.'),
  (nextval('workout_seq'), 10, '2023-10-01', 'Feeling strong and energetic!'),
  (nextval('workout_seq'), 10, '2023-10-03', 'High-intensity interval training.'),
  (nextval('workout_seq'), 10, '2023-10-05', 'Focused on flexibility today.');

INSERT INTO Workout_Exercise (workout_exercise_ID, exercise_ID, workout_ID, number_of_sets, number_of_reps, weight, intensity, 
							  duration)
VALUES
  (nextval('workout_exercise_seq'), 1, 1, 3, 10, 165, NULL, NULL),
  (nextval('workout_exercise_seq'), 2, 1, 4, 12, 150, NULL, NULL),
  (nextval('workout_exercise_seq'), 3, 2, 3, 10, 135, NULL, NULL),
  (nextval('workout_exercise_seq'), 4, 2, 4, 12, 125, NULL, NULL),
  (nextval('workout_exercise_seq'), 5, 3, 3, 10, 275, NULL, NULL),
  (nextval('workout_exercise_seq'), 6, 3, 4, 12, 250, NULL, NULL),
  (nextval('workout_exercise_seq'), 7, 4, 3, 10, 115, NULL, NULL),
  (nextval('workout_exercise_seq'), 8, 4, 4, 12, 95, NULL, NULL),
  (nextval('workout_exercise_seq'), 9, 5, 3, 10, 155, NULL, NULL),
  (nextval('workout_exercise_seq'), 1, 5, 4, 12, 135, NULL, NULL),
  (nextval('workout_exercise_seq'), 2, 6, 3, 10, 85, NULL, NULL),
  (nextval('workout_exercise_seq'), 3, 6, 4, 12, 75, NULL, NULL),
  (nextval('workout_exercise_seq'), 4, 7, 3, 10, 115, NULL, NULL),
  (nextval('workout_exercise_seq'), 5, 7, 4, 12, 100, NULL, NULL),
  (nextval('workout_exercise_seq'), 6, 8, 3, 10, 45, NULL, NULL),
  (nextval('workout_exercise_seq'), 7, 8, 4, 12, 35, NULL, NULL),
  (nextval('workout_exercise_seq'), 8, 9, 3, 10, NULL, NULL, NULL),
  (nextval('workout_exercise_seq'), 9, 9, 4, 12, NULL, NULL, NULL),
  (nextval('workout_exercise_seq'), 1, 10, 3, 10, NULL, NULL, NULL),
  (nextval('workout_exercise_seq'), 2, 10, 4, 12, NULL, NULL, NULL),
  (nextval('workout_exercise_seq'), 10, 11, NULL, NULL, NULL,  7, 45),
  (nextval('workout_exercise_seq'), 11, 11, NULL, NULL, NULL, 6, 30),
  (nextval('workout_exercise_seq'), 12, 12, NULL, NULL, NULL, 8, 60),
  (nextval('workout_exercise_seq'), 13, 12, NULL, NULL, NULL, 9, 75),
  (nextval('workout_exercise_seq'), 14, 13, NULL, NULL, NULL, 5, 40),
  (nextval('workout_exercise_seq'), 15, 13, NULL, NULL, NULL, 7, 55),
  (nextval('workout_exercise_seq'), 16, 14, NULL, NULL, NULL, 6, 35),
  (nextval('workout_exercise_seq'), 17, 14, NULL, NULL, NULL, 8, 50),
  (nextval('workout_exercise_seq'), 10, 15, NULL, NULL, NULL, 7, 45),
  (nextval('workout_exercise_seq'), 11, 15, NULL, NULL, NULL, 6, 30),
  (nextval('workout_exercise_seq'), 12, 16, NULL, NULL, NULL, 8, 60),
  (nextval('workout_exercise_seq'), 13, 16, NULL, NULL, NULL, 9, 75),
  (nextval('workout_exercise_seq'), 14, 17, NULL, NULL, NULL, 5, 40),
  (nextval('workout_exercise_seq'), 15, 17, NULL, NULL, NULL, 7, 55);

INSERT INTO Statistic (statistic_ID, statistic_name, statistic_description)
VALUES
	(nextval('statistic_seq'), 'height', 'Measure while standing upright with good posture.'),
	(nextval('statistic_seq'), 'weight', 'Weigh yourself first thing in the morning after using the bathroom.'),
	(nextval('statistic_seq'), 'chest', 'Measure chest at nipple level without flexing your chest or lats.'),
	(nextval('statistic_seq'), 'bicep', 'Measure your around your arm midway between shoulder and elbow.'),
	(nextval('statistic_seq'), 'waist', 'Measure waist a navel without sucking in or flexing abs.'),
	(nextval('statistic_seq'), 'quadriceps', 'Measure thigh midway between hip bone and knee.'),
	(nextval('statistic_seq'), 'calf', 'Measure calf at the widest point.');

INSERT INTO User_stats_hist (user_stats_hist_ID, user_ID, statistic_ID, old_value, new_value, change_date)
VALUES
  (nextval('user_stats_hist_seq'), 1, 1, NULL, 69.0, '2023-09-05'),
  (nextval('user_stats_hist_seq'), 1, 2, NULL, 205.5, '2021-09-06'),
  (nextval('user_stats_hist_seq'), 1, 2, 205.5, 195, '2021-10-05'),
  (nextval('user_stats_hist_seq'), 2, 3, 42.0, 42.5, '2023-09-15'),
  (nextval('user_stats_hist_seq'), 2, 4, 16.0, 16.5, '2023-09-20'),
  (nextval('user_stats_hist_seq'), 3, 5, 34.0, 33.5, '2023-09-25'),
  (nextval('user_stats_hist_seq'), 3, 5, 34.0, 32.0, '2023-11-25'),
  (nextval('user_stats_hist_seq'), 3, 6, NULL, 22.5, '2023-09-30'),
  (nextval('user_stats_hist_seq'), 1, 2, 195, 189, '2021-11-15'),
  (nextval('user_stats_hist_seq'), 1, 2, 189, 188, '2021-12-15'),
  (nextval('user_stats_hist_seq'), 1, 2, 189, 193, '2022-01-15'),
  (nextval('user_stats_hist_seq'), 1, 2, 193, 186, '2022-02-20'),
  (nextval('user_stats_hist_seq'), 1, 2, 189, 170, '2022-06-01'),
  (nextval('user_stats_hist_seq'), 1, 2, 170, 165, '2022-09-15'),
  (nextval('user_stats_hist_seq'), 1, 2, 165, 163, '2022-12-15'),
  (nextval('user_stats_hist_seq'), 1, 2, 163, 170, '2023-01-10'),
  (nextval('user_stats_hist_seq'), 1, 2, 170, 165, '2023-04-22'),
  (nextval('user_stats_hist_seq'), 1, 2, 165, 172, '2023-06-05'),
  (nextval('user_stats_hist_seq'), 1, 2, 172, 163, '2023-09-15'),
  (nextval('user_stats_hist_seq'), 1, 2, 163, 155, '2023-12-15'),
  (nextval('user_stats_hist_seq'), 4, 7, 15.5, 17.0, '2023-10-05'),
  (nextval('user_stats_hist_seq'), 4, 2, 150.0, 148.5, '2023-10-10'),
  (nextval('user_stats_hist_seq'), 5, 1, NULL, 70.5, '2023-10-15'),
  (nextval('user_stats_hist_seq'), 5, 3, 43.5, 45.0, '2023-10-20'), 
  (nextval('user_stats_hist_seq'), 6, 4, 17.0, 17.5, '2023-10-25'),
  (nextval('user_stats_hist_seq'), 6, 4, 17.5, 18.0, '2023-11-10'),
  (nextval('user_stats_hist_seq'), 6, 5, 33.0, 32.5, '2023-10-30'),
  (nextval('user_stats_hist_seq'), 6, 4, 18.0, 18.5, '2023-12-25'),
  (nextval('user_stats_hist_seq'), 7, 6, 22.0, 21.5, '2023-11-05'), 
  (nextval('user_stats_hist_seq'), 7, 7, 14.5, 14.0, '2023-11-10'), 
  (nextval('user_stats_hist_seq'), 8, 2, 155.0, 154.5, '2023-11-15'), 
  (nextval('user_stats_hist_seq'), 8, 1, NULL, 70.0, '2023-11-20'), 
  (nextval('user_stats_hist_seq'), 9, 3, 44.0, 43.5, '2023-11-25'), 
  (nextval('user_stats_hist_seq'), 9, 4, 17.5, 17.0, '2023-11-30'), 
  (nextval('user_stats_hist_seq'), 10, 5, 32.5, 32.0, '2023-12-05'), 
  (nextval('user_stats_hist_seq'), 10, 6, 21.0, 20.5, '2023-12-10');

INSERT INTO PB_hist (pb_hist_id, user_ID, exercise_ID, old_value, new_value, change_date)
VALUES
  (nextval('pb_hist_seq'), 1, 1, NULL, 135.0, '2021-09-06'),
  (nextval('pb_hist_seq'), 1, 1, 170.0, 195.0, '2021-12-15'), 
  (nextval('pb_hist_seq'), 1, 1, 195.0, 210.0, '2022-01-25'),
  (nextval('pb_hist_seq'), 1, 1, 210.0, 240.0, '2022-04-05'), 	
  (nextval('pb_hist_seq'), 1, 1, 240.0, 260.0, '2022-06-13'),
  (nextval('pb_hist_seq'), 1, 1, 260.0, 275.0, '2022-08-03'),
  (nextval('pb_hist_seq'), 1, 1, 275.0, 285.0, '2022-09-05'), 
  (nextval('pb_hist_seq'), 2, 2, 315.0, 325.0, '2022-09-10'), 
  (nextval('pb_hist_seq'), 3, 4, NULL, 160.0, '2022-09-15'), 
  (nextval('pb_hist_seq'), 4, 5, 135.0, 140.0, '2022-09-20'), 
  (nextval('pb_hist_seq'), 5, 7, 80.0, 85.0, '2022-09-25'), 
  (nextval('pb_hist_seq'), 6, 8, 75.0, 80.0, '2022-09-30'), 
  (nextval('pb_hist_seq'), 7, 9, 40.0, 42.0, '2022-10-05'), 
  (nextval('pb_hist_seq'), 8, 10, 20.0, 22.0, '2022-10-10'), 
  (nextval('pb_hist_seq'), 9, 12, 35.0, 45.0, '2022-10-15'), 
  (nextval('pb_hist_seq'), 10, 12, 60.0, 70.0, '2022-10-20'),
  (nextval('pb_hist_seq'), 1, 1, 285.0, 290.0, '2022-10-25'), 
  (nextval('pb_hist_seq'), 2, 2, 325.0, 330.0, '2022-10-30'), 
  (nextval('pb_hist_seq'), 3, 4, 160.0, 165.0, '2022-11-05'), 
  (nextval('pb_hist_seq'), 4, 5, 140.0, 145.0, '2022-11-10'), 
  (nextval('pb_hist_seq'), 5, 7, 85.0, 90.0, '2022-11-15'), 
  (nextval('pb_hist_seq'), 6, 8, 80.0, 85.0, '2022-11-20'), 
  (nextval('pb_hist_seq'), 7, 9, 42.0, 45.0, '2022-11-25'), 
  (nextval('pb_hist_seq'), 8, 10, 22.0, 24.0, '2022-11-30'), 
  (nextval('pb_hist_seq'), 9, 12, 37.0, 39.0, '2022-12-05'), 
  (nextval('pb_hist_seq'), 10, 12, 70.0, 80.0, '2022-12-10'),
  (nextval('pb_hist_seq'), 1, 1, 290, 315.0, '2023-02-10'),
  (nextval('pb_hist_seq'), 1, 1, 315, 320.0, '2023-03-25'),
  (nextval('pb_hist_seq'), 1, 1, 320, 340.0, '2023-07-06'),
  (nextval('pb_hist_seq'), 1, 1, 340, 350.0, '2023-10-10'),
  (nextval('pb_hist_seq'), 1, 1, 290, 355.0, '2023-12-18'),
  (nextval('pb_hist_seq'), 1, 2, NULL, 215, '2022-10-25'),
  (nextval('pb_hist_seq'), 1, 2, 215, 225, '2023-02-13'),
  (nextval('pb_hist_seq'), 1, 2, NULL, 115.0, '2021-12-15'), 
  (nextval('pb_hist_seq'), 1, 2, 115.0, 120.0, '2022-01-25'),
  (nextval('pb_hist_seq'), 1, 2, 120.0, 125.0, '2022-04-05'), 	
  (nextval('pb_hist_seq'), 1, 2, 125.0, 135.0, '2022-06-13'),
  (nextval('pb_hist_seq'), 1, 2, 135.0, 150.0, '2022-08-03'),
  (nextval('pb_hist_seq'), 1, 2, 150.0, 165.0, '2022-09-05'),
  (nextval('pb_hist_seq'), 1, 2, 165.0, 180.0, '2023-02-10'),
  (nextval('pb_hist_seq'), 1, 2, 180.0, 190.0, '2023-03-25'),
  (nextval('pb_hist_seq'), 1, 2, 190.0, 165.0, '2023-07-06'),
  (nextval('pb_hist_seq'), 1, 2, 165.0, 180.0, '2023-10-10'),
  (nextval('pb_hist_seq'), 1, 2, 180.0, 200.0, '2023-12-18'),
  (nextval('pb_hist_seq'), 1, 2, 200.0, 205.0, '2022-10-25'),
  (nextval('pb_hist_seq'), 1, 2, 205.0, 225.0, '2023-02-13'),
  (nextval('pb_hist_seq'), 1, 3, NULL, 195.0, '2021-12-15'), 
  (nextval('pb_hist_seq'), 1, 3, 195.0, 225.0, '2022-01-25'),
  (nextval('pb_hist_seq'), 1, 3, 225.0, 250.0, '2022-04-05'), 	
  (nextval('pb_hist_seq'), 1, 3, 250.0, 280.0, '2022-06-13'),
  (nextval('pb_hist_seq'), 1, 3, 280.0, 305.0, '2022-08-03'),
  (nextval('pb_hist_seq'), 1, 3, 305.0, 315.0, '2022-09-05'),
  (nextval('pb_hist_seq'), 1, 3, 315.0, 270.0, '2023-02-10'),
  (nextval('pb_hist_seq'), 1, 3, 270.0, 275.0, '2023-03-25'),
  (nextval('pb_hist_seq'), 1, 3, 275.0, 285.0, '2023-07-06'),
  (nextval('pb_hist_seq'), 1, 3, 285.0, 305.0, '2023-10-10'),
  (nextval('pb_hist_seq'), 1, 3, 305.0, 330.0, '2023-12-18'),
  (nextval('pb_hist_seq'), 1, 3, 330.0, 335.0, '2022-10-25'),
  (nextval('pb_hist_seq'), 1, 3, 335.0, 365.0, '2023-02-13');

INSERT INTO Review (review_ID, user_ID, template_ID, star_rating, review)
VALUES
  (nextval('review_seq'), 1, 1, 4.0, 
  	'I enjoyed the "Unleash the Beast" program. It helped me hit PRs in the squat, bench, and deadlift.'),
  (nextval('review_seq'), 2, 2, 5.0, 'Muscle Blast is amazing! I gained significant muscle mass with this program.'),
  (nextval('review_seq'), 3, 3, 3.0, 'Couch to 5k was a great starting point for my running journey.'),
  (nextval('review_seq'), 4, 4, 4.0, 'Get fit! is an effective program for improving cardiovascular fitness.'),
  (nextval('review_seq'), 5, 5, 4.5, 'Stage Ready helped me get into incredible shape for my bodybuilding competition.'),
  (nextval('review_seq'), 1, 2, 3.5, 'I also tried Muscle Blast and loved it! Great for muscle growth.'),
  (nextval('review_seq'), 2, 1, 4.0, 'Unleash the Beast is a solid powerlifting program.'),
  (nextval('review_seq'), 3, 4, 2.0, 'Get fit! was okay, but I prefer more intense workouts.'),
  (nextval('review_seq'), 4, 3, 4.0, 'Couch to 5k was perfect for beginners like me.'),
  (nextval('review_seq'), 5, 2, 5, 'Muscle Blast is the best muscle-building program I have tried.');

--Stored Procedures-------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

--Adds a single day of a strength template, performing insertions in both the 
--TEMPLATE_DAY and ST_TEMPLATE_DAY tables.  
CREATE OR REPLACE PROCEDURE add_st_template_day 
	(templateID IN DECIMAL, week IN DECIMAL,  day IN DECIMAL, squatSets IN DECIMAL, squatReps IN DECIMAL, 
	 squatMultiplier IN DECIMAL, benchSets IN DECIMAL, benchReps IN DECIMAL, benchMultiplier IN DECIMAL,
	 deadliftSets IN DECIMAL, deadliftReps IN DECIMAL, deadliftMultiplier IN DECIMAL, frontSquatSets IN DECIMAL,
 	 frontSquatReps IN DECIMAL, frontSquatMultiplier DECIMAL, romDeadliftSets IN DECIMAL, romDeadliftReps IN DECIMAL,
 	 romDeadliftMultiplier IN DECIMAL, barbellRowSets IN DECIMAL, barbellRowReps IN DECIMAL, barbellRowMultiplier IN DECIMAL,
 	 latPulldownSets IN DECIMAL, latPulldownReps IN DECIMAL, latPulldownMultiplier IN DECIMAL, barbellCurlSets IN DECIMAL,
 	 barbellCurlReps IN DECIMAL, barbellCurlMultiplier IN DECIMAL, dumbbellCurlSets IN DECIMAL, dumbbellCurlReps IN DECIMAL,
 	 dumbbellCurlMultiplier IN DECIMAL, subtype IN VARCHAR)
AS 
$st_transaction$
BEGIN
	INSERT INTO TEMPLATE_DAY (template_day_ID, template_ID, template_week, template_day, template_type)
	VALUES
		(nextval('template_day_seq'), templateID, week, day, subtype);

	INSERT INTO ST_TEMPLATE_DAY
	VALUES (currval('template_day_seq'), squatSets, squatReps,
	 squatMultiplier, benchSets, benchReps, benchMultiplier,
	 deadliftSets, deadliftReps, deadliftMultiplier, frontSquatSets,
 	 frontSquatReps, frontSquatMultiplier, romDeadliftSets, romDeadliftReps,
 	 romDeadliftMultiplier, barbellRowSets, barbellRowReps, barbellRowMultiplier,
 	 latPulldownSets, latPulldownReps, latPulldownMultiplier, barbellCurlSets,
 	 barbellCurlReps, barbellCurlMultiplier, dumbbellCurlSets, dumbbellCurlReps,
 	 dumbbellCurlMultiplier);
END;
$st_transaction$ LANGUAGE plpgsql;

-- --Adds a single day of a aerobic template, performing insertions in both the 
-- --TEMPLATE_DAY and ST_TEMPLATE_DAY tables.  

CREATE OR REPLACE PROCEDURE add_at_template_day 
	(templateID IN DECIMAL, week IN DECIMAL, day IN DECIMAL, walkingDuration IN DECIMAL, walkingRPE IN DECIMAL,
	runningDuration IN DECIMAL, runningRPE IN DECIMAL, exerciseBikeDuration IN DECIMAL, exerciseBikeRPE IN DECIMAL,
	jumpingRopeDuration IN DECIMAL, jumpingRopeRPE IN DECIMAL, swimmingDuration IN DECIMAL, swimmingRPE IN DECIMAL,
	ellipticalDuration IN DECIMAL, ellipticalRPE IN DECIMAL, martialArtsDuration IN DECIMAL, martialArtsRPE IN DECIMAL,
	danceClassDuration IN DECIMAL, danceClassRPE IN DECIMAL, subtype IN VARCHAR)
AS 
$at_transaction$
BEGIN
	INSERT INTO TEMPLATE_DAY (template_day_ID, template_ID, template_week, template_day, template_type)
	VALUES
		(nextval('template_day_seq'), templateID, week, day, subtype);

	INSERT INTO AT_TEMPLATE_DAY
	VALUES (currval('template_day_seq'), walkingDuration, walkingRPE, runningDuration, runningRPE, exerciseBikeDuration, 
			exerciseBikeRPE, jumpingRopeDuration, jumpingRopeRPE, swimmingDuration, swimmingRPE, ellipticalDuration, ellipticalRPE, 
			martialArtsDuration, martialArtsRPE, danceClassDuration, danceClassRPE);
END;
$at_transaction$ LANGUAGE plpgsql;

-- --Adds a template to a user, and creates an corresponding entry into Template_hist
CREATE OR REPLACE PROCEDURE add_template_to_user (userID IN DECIMAL, templateID IN DECIMAL)
AS
$template_user_transaction$
DECLARE 
	old_value DECIMAL(12);
BEGIN

	--update the value in the associated with the user
	UPDATE User_account
	SET template_ID = templateID
	WHERE user_ID = userID;

	--if the user has chosen a template before... 
	IF EXISTS (SELECT 1 from Template_hist WHERE user_ID = userID) THEN
		--...get the most recent template to be the old value in the new entry
		SELECT new_template 
		INTO old_value 
		FROM Template_hist
		WHERE user_ID = userID
		ORDER BY change_date DESC
		LIMIT 1;

		INSERT INTO Template_hist (template_hist_ID, user_ID, old_template, new_template, change_date)
		VALUES (nextval('template_hist_seq'), userID, old_value, templateID, CURRENT_DATE);
	ELSE
		--if this is the user's first template, the old_value will be NULL
		INSERT INTO Template_hist (template_hist_ID, user_ID, old_template, new_template, change_date)
		VALUES (nextval('template_hist_seq'), userID, NULL, templateID, CURRENT_DATE);
	END IF;
END;
$template_user_transaction$ LANGUAGE plpgsql;

--Insert values using stored procedures--------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

--user 1 adds template 1. This is his first template, so old_value in Template_hist should be NULL
START TRANSACTION;
DO
	$$
	BEGIN
		CALL add_template_to_user(1, 1);
	END
	$$;
COMMIT TRANSACTION;

--user 1 transitions to template 3. should be two entries in Template_hist after this, reflecting the change
START TRANSACTION;
DO
	$$
	BEGIN
		CALL add_template_to_user(1, 3);
	END
	$$;
COMMIT TRANSACTION;

--Insert multiple days for a strength training template

START TRANSACTION;
DO
$$
BEGIN
    CALL add_st_template_day
        (1, 1, 1, 3, 10, 0.5, 3, 10, 0.5, NULL, NULL, NULL, NULL, NULL, NULL, 3, 6, 0.7, 3, 12, 0.4, NULL, NULL, 
		 NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S');
END
$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
$$
BEGIN
    CALL add_st_template_day
        (1, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, 3, 8, 0.7, 3, 10, 0.6, NULL, NULL, NULL, NULL, NULL, NULL, 
		 NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S');
END
$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
$$
BEGIN
    CALL add_st_template_day
        (1, 2, 1, 3, 8, 0.7, 3, 8, 0.7, NULL, NULL, NULL, NULL, NULL, NULL, 3, 6, 0.8, 3, 12, 0.5, NULL, NULL, NULL, 
		 NULL, NULL, NULL, NULL, NULL, NULL, 'S');
END
$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
$$
BEGIN
    CALL add_st_template_day
        (1, 2, 2, NULL, NULL, NULL, NULL, NULL, NULL, 3, 8, 0.8, 3, 8, 0.8, NULL, NULL, NULL, NULL, NULL, NULL, 
		 NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S');
END
$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
$$
BEGIN
    CALL add_st_template_day
        (1, 3, 1, 4, 8, 0.8, 4, 8, 0.8, NULL, NULL, NULL, NULL, NULL, NULL, 3, 8, 0.8, 3, 8, 0.7, NULL, NULL, NULL, 
		 NULL, NULL, NULL, NULL, NULL, NULL, 'S');
END
$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
$$
BEGIN
    CALL add_st_template_day
        (1, 3, 2, NULL, NULL, NULL, NULL, NULL, NULL, 3, 8, 0.9, 3, 8, 0.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
		 NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S');
END
$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
$$
BEGIN
    CALL add_st_template_day
        (1, 4, 1, 4, 6, 0.9, 4, 6, 0.9, NULL, NULL, NULL, NULL, NULL, NULL, 4, 6, 0.8, 4, 6, 0.9, NULL, NULL, NULL, 
		 NULL, NULL, NULL, NULL, NULL, NULL, 'S');
END
$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
$$
BEGIN
    CALL add_st_template_day
        (1, 4, 2, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, 0.9, 3, 10, 0.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
		 NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S');
END
$$;
COMMIT TRANSACTION;

--Add multiple days for an aerobic workout

START TRANSACTION;
DO
	$$
	BEGIN
		CALL add_at_template_day(3, 1, 1, NULL, NULL, 20, 5, NULL, NULL, NULL, NULL, NULL, NULL, 
								 NULL, NULL, NULL, NULL, NULL, NULL, 'A');
	END
	$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
	$$
	BEGIN
		CALL add_at_template_day(3, 1, 2, 45, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
								 NULL, NULL, NULL, NULL, NULL, NULL, 'A');
	END
	$$;
COMMIT TRANSACTION;


START TRANSACTION;
DO
	$$
	BEGIN
		CALL add_at_template_day(3, 1, 3, NULL, NULL, 30, 7, NULL, NULL, NULL, NULL, NULL, NULL, 
								 NULL, NULL, NULL, NULL, NULL, NULL, 'A');
	END
	$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
	$$
	BEGIN
		CALL add_at_template_day(3, 2, 1, NULL, NULL, 25, 5, NULL, NULL, NULL, NULL, NULL, NULL, 
								 NULL, NULL, NULL, NULL, NULL, NULL, 'A');
	END
	$$;
COMMIT TRANSACTION;

START TRANSACTION;
DO
	$$
	BEGIN
		CALL add_at_template_day(3, 2, 2, 45, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
								 NULL, NULL, NULL, NULL, NULL, NULL, 'A');
	END
	$$;
COMMIT TRANSACTION;


START TRANSACTION;
DO
	$$
	BEGIN
		CALL add_at_template_day(3, 2, 3, NULL, NULL, 40, 7, NULL, NULL, NULL, NULL, NULL, NULL, 
								 NULL, NULL, NULL, NULL, NULL, NULL, 'A');
	END
	$$;
COMMIT TRANSACTION;

--Queries------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

--Query 1 - How many calories did a user eat on a day when they set a new personal best?
SELECT 
	(user_fname || ' ' || user_lname) as user_name, change_date, exercise_name, new_value, 
	SUM(calories * number_of_servings) as calories 
FROM User_account
JOIN PB_Hist ON PB_Hist.user_ID = User_account.user_ID
JOIN Exercise ON Exercise.exercise_ID = PB_Hist.exercise_ID
JOIN Nutrition ON Nutrition.date = PB_Hist.change_date
JOIN Food ON Food.food_ID = Nutrition.food_ID
WHERE User_account.user_ID = 1
GROUP BY (user_fname || ' ' || user_lname), change_date, exercise_name, new_value;

--Query 2 - What exercises and set/rep scheme should a user do on a given day based on their
--chosen template?
SELECT (user_fname || ' ' || user_lname) as user_name, template_name, 
		template_week as week, template_day as day, AT_template_day.*
FROM User_account
JOIN Template ON User_account.template_ID = Template.template_ID
JOIN Template_day ON Template_day.template_ID = Template.template_ID
JOIN AT_Template_day ON AT_template_day.template_day_ID = Template_day.template_day_ID
WHERE user_ID = 1 AND template_week = 2 AND template_day = 1;

--Query 3 - creates a view to display a user's nutrition for the current day. 
CREATE VIEW daily_nutrition 
AS
	SELECT (user_fname || ' ' || user_lname) as user_name, 
	SUM(calories * number_of_servings) AS calories,
	SUM(protein * number_of_servings) AS protein,
	SUM(carbohydrate * number_of_servings) AS carbohydrate,
	SUM(fat * number_of_servings) AS fat,
	SUM(saturated_fat * number_of_servings) AS saturated_fat,
	SUM(trans_fat * number_of_servings) AS trans_fat,
	SUM(fiber * number_of_servings) AS fiber

FROM User_account
JOIN Nutrition ON Nutrition.user_ID = User_account.user_ID
JOIN Food ON Food.food_ID = Nutrition.food_ID
WHERE User_account.user_ID = 2 AND date = CURRENT_DATE
GROUP BY (user_fname || ' ' || user_lname), date;

--Indexes-----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--Foreign Keys
CREATE INDEX we_exercise_idx
ON Workout_exercise(exercise_ID);

CREATE INDEX we_workout_idx
ON Workout_exercise(workout_ID);

CREATE INDEX ush_user_idx
ON User_stats_hist(user_ID);

CREATE INDEX ush_statistic_idx
ON User_stats_hist(statistic_ID);

CREATE INDEX nutrition_user_idx
ON Nutrition(user_ID);

CREATE INDEX nutrition_food_idx
ON Nutrition(food_ID);

CREATE INDEX pbh_user_idx
ON PB_hist(user_ID);

CREATE INDEX pbh_exercise_idx
ON PB_hist(exercise_ID);

CREATE INDEX review_user_idx
ON Review(user_ID);

CREATE INDEX review_template_idx
ON Review(template_ID);

CREATE INDEX th_user_idx
ON Template_hist(user_ID);

CREATE INDEX th_old_idx
ON Template_hist(old_template);

CREATE INDEX th_new_idx
ON Template_hist(new_template);

CREATE INDEX td_template_idx
ON Template_day(template_ID);

--Other Indexes
CREATE INDEX nutrition_date_idx
ON Nutrition(date);

CREATE INDEX food_cals_idx
ON Food(calories);

CREATE INDEX food_protein_idx
ON Food(protein);

CREATE INDEX food_carbohydrate_idx
ON Food(carbohydrate);

CREATE INDEX food_fat_idx
ON Food(fat);

CREATE INDEX td_week_idx
ON Template_day(template_week);

CREATE INDEX td_day_idx
ON Template_day(template_day);

--Triggers and associated functions-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

--Adds an entry to the Password_hist if a user updates their password. First checks that the password hasn't
--been used before.
CREATE OR REPLACE FUNCTION pw_change_function()
RETURNS TRIGGER LANGUAGE plpgsql
AS
$pwfunc$
	BEGIN
		IF NEW.password NOT IN (
			SELECT old_value FROM Password_hist WHERE Password_hist.user_ID = NEW.user_ID
			UNION 
			SELECT new_value FROM password_hist WHERE Password_hist.user_ID = NEW.user_ID)
		THEN
			INSERT INTO Password_hist (password_hist_ID, user_ID, old_value, new_value, change_date)
			VALUES (nextval('password_hist_seq'), NEW.user_ID, OLD.password, NEW.password, CURRENT_DATE);
			RETURN NEW;
		ELSE
			RAISE EXCEPTION USING MESSAGE = 'Cannot reuse old passwords. Please try again with a new password.',
			ERRCODE = 22000;
		END IF;
	END;
$pwfunc$;

CREATE TRIGGER pw_change_trigger
BEFORE UPDATE OF password ON User_account
FOR EACH ROW EXECUTE PROCEDURE pw_change_function();

--Adds an entry to the Template_hist table if a user changes their template. Checks to make sure the template is different
CREATE OR REPLACE FUNCTION template_change_function()
RETURNS TRIGGER LANGUAGE plpgsql
AS

$temp_change_func$
	BEGIN
		IF NEW.template_ID = OLD.template_ID THEN
			RAISE EXCEPTION USING MESSAGE = 'New template must be different than old template.',
			ERRCODE = 22000;
		ELSE
			INSERT INTO Template_hist (template_hist_id, user_ID, old_template, new_template, change_date)
			VALUES (nextval('template_hist_seq'), NEW.user_ID, OLD.template_ID, NEW.template_ID, CURRENT_DATE);
		END IF;
		RETURN NEW;
	END;
$temp_change_func$;

CREATE TRIGGER template_change_trigger
BEFORE UPDATE OF template_ID ON User_account
FOR EACH ROW EXECUTE PROCEDURE template_change_function();

--PB_Hist trigger. When a user enters a new exercise in the Workout_exercise table, checks the PB_hist table to see
--if this is a new personal best based on duration for aerobic exercises and weight for barbell exercises. If it is
--a new personal best, add a new entry to PB_Hist

CREATE OR REPLACE FUNCTION personal_bests_function()
RETURNS TRIGGER LANGUAGE plpgsql
AS 
$pb_func$
DECLARE
	userID DECIMAL(12);
	old_best DECIMAL(3);
BEGIN
  --Need the user_ID from the workout table
  userID := (SELECT user_ID FROM Workout WHERE workout_ID = NEW.workout_ID);
  
  --Check if it's an aerobic exercise (weight is NULL)
  IF NEW.weight IS NULL THEN
    --If a previous best exists for this exercise...
    IF EXISTS (SELECT 1 FROM PB_Hist WHERE exercise_ID = NEW.exercise_ID AND user_ID = userID) THEN
		--...get the old_best and check if new is > old...
		SELECT MAX(new_value)
		INTO old_best
		FROM PB_Hist WHERE exercise_ID = NEW.exercise_ID AND user_ID = userID
		GROUP BY exercise_ID;
	
		IF NEW.duration > old_best 
				THEN
			  --...insert a new PB_Hist entry with duration as new_value and the previous duration as old_value
			  INSERT INTO PB_Hist (pb_hist_ID, user_ID, exercise_ID, old_value, new_value, change_date)
			  VALUES (nextval('pb_hist_seq'), userID, NEW.exercise_ID, old_best, NEW.duration, CURRENT_DATE);
		END IF;
	ELSE
		--If now entry, enter new best asnew_value and the NULL as old_value
		INSERT INTO PB_Hist (pb_hist_ID, user_ID, exercise_ID, old_value, new_value, change_date)
		VALUES (nextval('pb_hist_seq'), userID, NEW.exercise_ID, NULL, NEW.duration, CURRENT_DATE);	
    END IF;
  --If it is not aerobic, it must be a strength exercise (reps must = 1, see definition of personal best)
  ELSIF NEW.weight IS NOT NULL AND NEW.number_of_reps = 1 THEN
    --If a personal best entry exists for this exercise...
    IF EXISTS (SELECT 1 FROM PB_Hist WHERE exercise_ID = NEW.exercise_ID AND user_ID = userID) THEN
      --...get old best and check if the new weight is greater than the old personal best
	  SELECT MAX(new_value)
	  INTO old_best
	  FROM PB_Hist WHERE exercise_ID = NEW.exercise_ID AND user_ID = userID
	  GROUP BY exercise_ID;
	  
      IF NEW.weight > old_best
		THEN
        --...and insert a new PB_Hist entry 
        INSERT INTO PB_Hist (pb_hist_ID, user_ID, exercise_ID, old_value, new_value, change_date)
        VALUES(nextval('pb_hist_seq'), userID, NEW.exercise_ID, old_best, NEW.weight, CURRENT_DATE);
      END IF;
	ELSE
		--If not prior entry, make new entry with new best as new_value and NULL as old_value 
        INSERT INTO PB_Hist (pb_hist_ID, user_ID, exercise_ID, old_value, new_value, change_date)
        VALUES(nextval('pb_hist_seq'), userID, NEW.exercise_ID, NULL, NEW.weight, CURRENT_DATE);
    END IF;
  END IF;
  RETURN NEW;
END;
$pb_func$;

CREATE TRIGGER personal_bests_trigger
AFTER INSERT ON workout_exercise
FOR EACH ROW
EXECUTE FUNCTION personal_bests_function();





--password trigger testing-----------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

--tests are commented out so failures don't prevent the entire script from running

-- UPDATE User_account
-- SET password = 'new_password' --this should work because it is a new password
-- WHERE user_ID = 1;

-- UPDATE User_account
-- SET password = 'new_password' --this should fail because it attempts to reuse the last password
-- WHERE user_ID = 1;

--template trigger testing---------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- UPDATE User_account
-- SET template_ID = 5 --this should work
-- WHERE user_ID = 1;

-- SELECT * FROM Template_hist;

-- UPDATE User_account
-- SET template_ID = 5 --this should fail because it's the same template
-- WHERE user_ID = 1;

--PB_Hist trigger testing ----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

--This is associated with a workout from User 1. The exercise is the squat, in which his previous best was 365.
--This should enter a new PB_Hist as the number of reps = 1 and the weight is greater than the previous best.
INSERT INTO Workout_exercise 
	(workout_exercise_ID, exercise_ID, workout_ID, number_of_sets, number_of_reps, weight, intensity, duration)
VALUES
	(nextval('workout_exercise_seq'), 3, 3, 1, 1, 405, NUlL, NULL);

--This should enter a new PB_Hist for this user whose previous duration for this exercise was 45 minutes
INSERT INTO Workout_exercise 
	(workout_exercise_ID, exercise_ID, workout_ID, number_of_sets, number_of_reps, weight, intensity, duration)
VALUES
	(nextval('workout_exercise_seq'), 9, 15, NULL, NULL, NULL, 9, 50);

--inserts an exercise (elliptical) for user 2 who does not have a personal best. Should result in PB_Hist entry with 
--NULL for old_value
INSERT INTO Workout_exercise 
	(workout_exercise_ID, exercise_ID, workout_ID, number_of_sets, number_of_reps, weight, intensity, duration)
VALUES
	(nextval('workout_exercise_seq'), 15, 5, NULL, NULL, NULL, 7, 30);


--Visualization Queries-----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Query 1 pulls the data for personal bests in the squat, bench, and deadlift for user 1 and compares with their
--bodyweight for progress over time.

SELECT * 
FROM 
	(SELECT 'PB_hist' AS source,
		   exercise_ID,
		   new_value AS value,
		   change_date
	FROM PB_hist
	WHERE exercise_ID IN (1, 2, 3)
	UNION ALL
	SELECT 'User_stats_hist' AS source,
		   statistic_ID AS exercise_ID,
		   new_value AS value,
		   change_date
	FROM User_stats_hist
	WHERE statistic_ID = 2
	ORDER BY change_date) AS result
ORDER BY source, exercise_ID, change_date;

--Query 2 pulls from the daily_nutrition view to ascertain the total calories and percentage of calories 
--from each of the macronutrients, for use in a pie chart that can be presented to a user

SELECT 
	calories,
	(protein * 4) AS pro_cals,
	(fat * 9) AS Unsaturated_fat_cals,
	(saturated_fat * 9) AS saturated_fat_cals,
	(carbohydrate * 4) AS nonfiber_carb_cals,
	(fiber * 4) AS fiber_cals
FROM daily_nutrition;

--Query 3 shows the average calories per meal for a user during a given week 

SELECT 
	meal, 
	ROUND(AVG(meal_calories)) as average_calories,
	ROUND(AVG(meal_protein)) as average_protein,
	ROUND(AVG(meal_fat)) as average_fat,
	ROUND(AVG(meal_carbohydrates)) as average_carbohydrates
FROM 
	(SELECT date, meal, 
	 SUM(number_of_servings * calories) AS meal_calories,
	 SUM(number_of_servings * protein) AS meal_protein,
	 SUM(number_of_servings * fat) AS meal_fat,
	 SUM(number_of_servings * carbohydrate) AS meal_carbohydrates
	FROM Nutrition
	JOIN Food ON Food.food_ID = Nutrition.food_ID
	WHERE user_ID = 2 AND date BETWEEN '2023-10-01' AND '2023-10-07'
	GROUP BY date, meal
	ORDER BY date) as result
GROUP BY meal;


SELECT * FROM AT_template_day;













