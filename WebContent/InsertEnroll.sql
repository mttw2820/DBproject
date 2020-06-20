CREATE OR REPLACE PROCEDURE InsertEnroll (
	/* IN parameters: 학번, 과목번호, 분반 */
	sStudentId IN VARCHAR2,
	sCourseId IN VARCHAR2,
	nCourseIdNo IN NUMBER,
	/* OUT parameter: 입력 결과 메시지 */
	result OUT VARCHAR2 )
IS 
	/* EXCEPTION들 */
	too_many_sumCourseUnit EXCEPTION; -- 최대학점 초과
	too_many_courses EXCEPTION; -- 이미 등록된 과목 신청
	too_many_students EXCEPTION; -- 수강신청 인원 초과
	duplicate_time EXCEPTION; -- 이미 등록된 과목 중 중복되는 시간 존재
	/* 필요한 변수들 */
	nYear NUMBER;
	nSemester NUMBER;
	nSumCourseUnit NUMBER;
	nCourseUnit NUMBER;
	nCnt NUMBER;
	nTeachMax NUMBER;
	check_Collide NUMBER;
	/* 커서 */
	CURSOR enroll_cursor(enYear enroll.en_year%TYPE, enSem enroll.en_semester%TYPE) IS
		SELECT *
		FROM enroll
		WHERE en_sNUM = sStudentID and en_year = enYear and en_semester = enSem;
	
BEGIN
	result := '';
	DBMS_OUTPUT.put_line('#');
	DBMS_OUTPUT.put_line(sStudentId || '님이 과목번호 ' || sCourseId || ', 분반' || TO_CHAR(nCourseIdNo) || '의 수강 등록을 요청하였습니다.');
	
	/* 수강 년도와 학기 알아내기 */
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);

	/* 에러 처리 1: 최대학점 초과 여부 */
	SELECT SUM(c.c_grade)
	INTO nSumCourseUnit
	FROM class c, enroll e
	WHERE e.en_sNum = sStudentId and e.en_year = nYear and e.en_semester = nSemester and e.en_cNum = c.c_num and e.en_cDiv = c.c_div;

	SELECT c_grade
	INTO nCourseUnit
	FROM class
	WHERE c_num = sCourseId and c_div = nCourseIdNo;
	
	IF (nSumCourseUnit + nCourseUnit > 18)
	THEN
		RAISE too_many_sumCourseUnit;
	END IF;

	/* 에러 처리 2: 동일한 과목 신청 여부 */
	SELECT COUNT(*)
	INTO nCnt
	FROM enroll
	WHERE en_sNum = sStudentId and en_cNum = sCourseID;
	
	IF (nCnt > 0)
	THEN
		RAISE too_many_courses;
	END IF;

	/* 에러 처리 3: 수강신청 인원 초과 여부 */
	SELECT c_max_students
	INTO nTeachMax
	FROM class
	WHERE c_year = nYear and c_semester = nSemester and c_num = sCourseId and c_div = nCourseIdNo;

	SELECT COUNT(*)
	INTO nCnt
	FROM enroll
	WHERE en_year = nYear and en_semester = nSemester and en_cNum = sCourseId and en_cDiv = nCourseIdNo;

	IF (nCnt >= nTeachMax)
	THEN
		RAISE too_many_students;
	END IF;
	
	/* 에러 처리 4: 신청한 과목들 시간 중복 여부 */
	check_Collide := 0;
	FOR enroll_list IN enroll_cursor(nYear, nSemester) LOOP
		check_Collide := doesCollide(sCourseId, nCourseIdNo, enroll_list.en_cNum, enroll_list.en_cDiv);
		IF (check_Collide > 0)
		THEN
			RAISE duplicate_time;
		END IF;
	END LOOP;
	
	/* 수강 신청 등록 */
	INSERT INTO enroll(en_sNum, en_cNum, en_cDiv, en_year, en_semester)
	VALUES (sStudentId, sCourseId, nCourseIdNo, nYear, nSemester);
	
	COMMIT;
	result := '수강신청 등록이 완료되었습니다.';
	
EXCEPTION
	WHEN too_many_sumCourseUnit THEN
		result := '최대학점을 초과하였습니다.';
	WHEN too_many_courses THEN
		result := '이미 등록된 과목을 신청하였습니다.';
	WHEN too_many_students THEN
		result := '수강신청 인원이 초과되어 등록이 불가능합니다.';
	WHEN duplicate_time THEN
		result := '이미 등록된 과목 중 중복되는 시간이 존재합니다.';
	WHEN OTHERS THEN
		ROLLBACK;
		result := SQLCODE;
	END;
/
	
