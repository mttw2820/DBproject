# CREATE TABLE ...

### STUDENT

![images/Untitled.png](images/Untitled.png)
primary key: s_num
```sql
CREATE TABLE STUDENT (
	s_num VARCHAR2(15),
	s_pwd VARCHAR2(30) NOT NULL,
	s_name VARCHAR2(10),
	CONSTRAINT STUDENT_PK PRIMARY KEY(s_num)
);

INSERT INTO STUDENT (s_num, s_pwd, s_total_grade, s_name) VALUES ('1111111', '1234', '고은서');
INSERT INTO STUDENT (s_num, s_pwd, s_total_grade, s_name) VALUES ('1111112', '2345', '이수현');
INSERT INTO STUDENT (s_num, s_pwd, s_total_grade, s_name) VALUES ('1111113', '3456', '조혜민');
```

### CLASS (초기 분반 최대인원은 모두 3명)

일주일에 한 번 수업이 있다 가정하고, 시작하는 시간의 시각(hour)과 분(minute), 요일(1 ~ 7)을 저장

![images/Untitled%201.png](images/Untitled%201.png)
primary key: c_num, c_div, c_year, c_semester
```sql
CREATE TABLE CLASS (
	c_num VARCHAR2(15),
	c_title VARCHAR2(50),
	c_div NUMBER,
	c_grade NUMBER,
	c_max_students NUMBER,
	c_year NUMBER,
	c_semester NUMBER,
	c_start_h NUMBER,
	c_start_m NUMBER,
	c_day NUMBER,
	c_lec_time NUMBER,
	CONSTRAINT CLASS_PK PRIMARY KEY(c_num, c_div, c_year, c_semester)
);

INSERT INTO CLASS VALUES ('C800', '데이터베이스 프로그래밍', 3, 3, 3, 2020, 2, 13, 30, 1, 75);
INSERT INTO CLASS VALUES ('C900', '객체지향 윈도우즈 프로그래밍', 3, 3, 3, 2020, 2, 10, 30, 3, 75);
INSERT INTO CLASS VALUES ('M100', '멀티미디어 개론', 3, 3, 3, 2020, 2, 9, 0, 2, 75);	
INSERT INTO CLASS VALUES ('M200', '선형대수', 3, 3, 3, 2020, 2, 10, 30, 3, 75);
INSERT INTO CLASS VALUES ('M300', '그래픽 활용', 3, 3, 3, 2020, 2, 10, 30, 2, 75);
INSERT INTO CLASS VALUES ('M400', '윈도우즈 프로그래밍', 3, 3, 3, 2020, 2, 12, 0, 4, 75);
INSERT INTO CLASS VALUES ('M500', '컴퓨터 그래픽스', 3, 3, 3, 2020, 2, 12, 0, 4, 75);
INSERT INTO CLASS VALUES ('M600', '멀티미디어 처리', 3, 3, 3, 2020, 2, 14, 0, 1, 120);
INSERT INTO CLASS VALUES ('M700', '게임 프로그래밍', 3, 3, 3, 2020, 2, 13, 30, 1, 75);
```

[과목 정보...](https://www.notion.so/4eb4c32c1983404c9bcfba8eb187641c)

### ENROLL

![images/Untitled%202.png](images/Untitled%202.png)
primary key: en_num
foreign key: en_cNum, en_cDiv, en_year, en_semester
```sql
CREATE TABLE ENROLL (
	en_num NUMBER PRIMARY KEY,
	en_year NUMBER,
	en_semester NUMBER,
	en_sNum VARCHAR2(15),
	en_cNum VARCHAR2(15),
	en_cDiv NUMBER,
	CONSTRAINT FK_SNUM FOREIGN KEY(en_sNum) REFERENCES STUDENT(s_num),
	CONSTRAINT FK_CLASS FOREIGN KEY(en_cNum, en_cDiv, en_year, en_semester) REFERENCES CLASS(c_num, c_div, c_year, c_semester)
);
```

### ENROLL_INFO (view)

`sid` | `cid` | `ctitle` | `cdiv` | `credit` | `cmaxnum` | `cyear` | `csemester` | `ctime_h` (수업 시작 시간 시각) | `ctime_m` (수업 시작 시간 분) | `cday` (수업 요일, 1~7) | `clectime` (수업 시간, 분 단위)

```sql
CREATE OR REPLACE VIEW enroll_info AS
SELECT e.en_sNum sid, c.c_num cid, c.c_title ctitle, c.c_div cdiv, c.c_grade credit, c.c_max_students cmaxnum, c.c_year cyear, c.c_semester csemester, c.c_start_h ctime_h, c.c_start_m ctime_m, c.c_day cday, c.c_lec_time clectime
FROM enroll e, class c
WHERE e.en_year = c.c_year and e.en_semester = c.c_semester and e.en_cNum = c.c_num and e.en_cDiv = c.c_div;
```
