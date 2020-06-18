CREATE OR REPLACE FUNCTION Date2EnrollYear(in_date IN DATE)
RETURN NUMBER
IS
  nYear       NUMBER;
  sMonth      VARCHAR2(2);
BEGIN
  /* 11월 ~ 4월 : 1학기, 5월 ~ 10월 : 2학기 */
  SELECT TO_NUMBER(TO_CHAR(in_date, 'YYYY')), TO_CHAR(in_date, 'MM') 
  INTO nYear, sMonth 
  FROM DUAL;

  IF (sMonth ='11' or sMonth='12') THEN
     nYear := nYear + 1;
  END IF; 
  
  RETURN nYear;
END;
/

CREATE OR REPLACE FUNCTION Date2EnrollSemester(in_date IN DATE)
RETURN NUMBER
IS
  nSemester   NUMBER;
  sMonth      VARCHAR2(2);
BEGIN
  /* 11월 ~ 4월 : 1학기, 5월 ~ 10월 : 2학기 */
  SELECT TO_CHAR(in_date, 'MM') 
  INTO sMonth 
  FROM DUAL;

  IF ( (sMonth='11' or sMonth='12') or (sMonth >='01' and sMonth <= '04') ) THEN 
      nSemester := 1;
  ELSE
      nSemester := 2;
  END IF;
  
  RETURN nSemester;
 END;
/