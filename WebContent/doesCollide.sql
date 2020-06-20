CREATE OR REPLACE FUNCTION doesCollide (
	a_class_id IN VARCHAR,
	a_class_id_no IN NUMBER,
	b_class_id IN VARCHAR,
	b_class_id_no IN NUMBER
)
RETURN NUMBER
IS
	checkCollide NUMBER;
	a_start_time NUMBER;
	a_end_time NUMBER;
	b_start_time NUMBER;
	b_end_time NUMBER;
	class_a class%ROWTYPE;
	class_b class%ROWTYPE;
BEGIN
	/* 첫 번째 class의 정보를 변수에 넣기 */
	SELECT c_day, c_start_h, c_start_m, c_lec_time
	INTO class_a.c_day, class_a.c_start_h, class_a.c_start_m, class_a.c_lec_time
	FROM class
	WHERE c_num = a_class_id and c_div = a_class_id_no;
	
	/* 두 번째 class의 정보를 변수에 넣기 */
	SELECT c_day, c_start_h, c_start_m, c_lec_time
	INTO class_b.c_day, class_b.c_start_h, class_b.c_start_m, class_b.c_lec_time
	FROM class
	WHERE c_num = b_class_id and c_div = b_class_id_no;
	
	checkCollide := 0;
	
	/* 분으로 모두 환산한 시간 계산 */
	a_start_time := (60 * class_a.c_start_h) + class_a.c_start_m;
	a_end_time := a_start_time + class_a.c_lec_time;
	b_start_time := (60 * class_b.c_start_h) + class_b.c_start_m;
	b_end_time := b_start_time + class_b.c_lec_time;

	/* 시간이 충돌하는지 검사 */
	IF (class_a.c_day = class_b.c_day) THEN
		IF (a_start_time = b_start_time) THEN
			checkCollide := 1;
		ELSIF (a_start_time > b_start_time) THEN
			IF (b_end_time > a_start_time) THEN
				checkCollide := 1;
			END IF;
		ELSIF (a_start_time < b_start_time) THEN
			IF (a_end_time > b_start_time) THEN
				checkCollide := 1;
			END IF;
		END IF;
	END IF;
	COMMIT;
	RETURN checkCollide;
END;
/
