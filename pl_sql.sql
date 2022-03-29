-- PL/SQL 
-- SQL 만으로는 구현이 어렵거나 구현 불가능한 작업들을 수행하기 위해서 
-- 제공하는 프로그래밍 언어

-- 키워드 
-- DECLARE(선언부) : 변수,상수,커서 등을 선언(선택)
-- BEGIN(실행부) : 조건문,반복문,SELECT,DML(UPDATE,DELETE,INSERT),함수 등을 정의(필수)
-- EXCEPTION(예외처리부) : 오류(예외상황) 해결(선택) 

-- 실행 결과를 화면에 출력 
SET SERVEROUTPUT ON;

-- Hello 출력 
BEGIN
    dbms_output.put_line('Hello! PL/SQL');
END;
/

DECLARE
    -- 변수선언 
    v_empno NUMBER(4) := 7788;
    v_ename VARCHAR2(10);
BEGIN
    v_ename := 'SCOTT';
    dbms_output.put_line('V_EMPNO : ' || v_empno);
    dbms_output.put_line('V_ENAME : ' || v_ename);
END;
/

DECLARE
    -- 상수선언 
    v_tax CONSTANT NUMBER(1) := 3;
BEGIN
    dbms_output.put_line('V_TAX : ' || v_tax);
END;
/ 

-- 변수의 기본값 지정 
DECLARE
    v_deptno NUMBER(2) DEFAULT 10;
BEGIN
    dbms_output.put_line('V_DEPTNO : ' || v_deptno);
END;
/ 

-- NOT NULL 지정 
DECLARE
    v_deptno NUMBER(2) NOT NULL := 10;
--  V_DEPTNO NUMBER(2) NOT NULL DEFAULT 20;
BEGIN
    dbms_output.put_line('V_DEPTNO : ' || v_deptno);
END;
/ 







-- IF 조건문 
-- IF ~ THEN
-- IF ~ THEN ~ ELSE 
-- IF ~ THEN ~ ELSIF 

--V_NUMBER 변수 선언하고 13값을 할당한뒤 해당 변수가 홀,짝 출력 
DECLARE
    v_number NUMBER := 13;
BEGIN
    IF MOD(v_number, 2) = 1 THEN
        dbms_output.put_line('홀수');
    END IF;
END;
/

DECLARE
    v_number NUMBER := 14;
BEGIN
    IF MOD(v_number, 2) = 1 THEN
        dbms_output.put_line('홀수');
    ELSE
        dbms_output.put_line('짝수');
    END IF;
END;
/

DECLARE
    v_number NUMBER := 87;
BEGIN
    IF v_number >= 90 THEN
        dbms_output.put_line('A 학점');
    ELSIF v_number >= 80 THEN
        dbms_output.put_line('B 학점');
    ELSIF v_number >= 70 THEN
        dbms_output.put_line('C 학점');
    ELSIF v_number >= 60 THEN
        dbms_output.put_line('D 학점');
    ELSE
        dbms_output.put_line('E 학점');
    END IF;
END;
/

-- CASE ~ WITH 
DECLARE
    v_score NUMBER := 77;
BEGIN
    CASE trunc(v_score / 10)
        WHEN 10 THEN
            dbms_output.put_line('A 학점');
        WHEN 9 THEN
            dbms_output.put_line('B 학점');
        WHEN 8 THEN
            dbms_output.put_line('C 학점');
        WHEN 7 THEN
            dbms_output.put_line('D 학점');
        ELSE
            dbms_output.put_line('F 학점');
    END CASE;
END;
/

-- 반복문 
-- LOOP ~ END LOOP 
-- WHILE LOOP ~ END LOOP 
-- FOR LOOP 
-- Cursor For LOOP 
DECLARE
    v_deptno NUMBER := 0;
BEGIN
    LOOP
        dbms_output.put_line('현재 V_DEPTNO : ' || v_deptno);
        v_deptno := v_deptno + 1;
        EXIT WHEN v_deptno > 4;     --EXIT 는 break랑 비슷함 
    END LOOP;
END;
/

DECLARE
    v_deptno NUMBER := 0;
BEGIN
    WHILE v_deptno < 4 LOOP
        dbms_output.put_line('현재 V_DEPTNO : ' || v_deptno);
        v_deptno := v_deptno + 1;
    END LOOP;
END;
/ 


-- 시작값..종료값 : 반복문을 통해서 시작값 ~ 종료값을 사용 
BEGIN
    FOR i IN 0..4 LOOP
        dbms_output.put_line('현재 i : ' || i);
    END LOOP;
END;
/

BEGIN
    FOR i IN REVERSE 0..4 LOOP
        dbms_output.put_line('현재 i : ' || i);
    END LOOP;
END;
/ 

-- 숫자 1~10 까지 출력(홀수만) 
BEGIN
    FOR i IN 1..10 LOOP
        IF MOD(i, 2) = 1 THEN
            dbms_output.put_line('현재 i : ' || i);
        END IF;
    END LOOP;
END;
/

-- 변수 타입 선언시 특정 테이블의 컬럼 값 참조 
DECLARE
    v_deptno dept.deptno%TYPE := 50;
BEGIN
    dbms_output.put_line('V_DEPTNO : ' || v_deptno);
END;
/ 

-- 변수 타입 선언시 특정 테이블의 하나의 컬럼이 아니라 행 구조 전체 참조 
DECLARE
    v_dept_row dept%rowtype;
BEGIN
    SELECT
        deptno,
        dname,
        loc
    INTO v_dept_row
    FROM
        dept
    WHERE
        deptno = 40;

    dbms_output.put_line('DEPTNO : ' || v_dept_row.deptno);
    dbms_output.put_line('DNAME : ' || v_dept_row.dname);
    dbms_output.put_line('LOC : ' || v_dept_row.loc);
END;
/ 

-- 커서(CURSOR)
-- SELECT , DELETE , UPDATE ,INSERT  SQL 문 실행시 해당 SQL문을 처리하는 정보를 
-- 저장한 메모리 공간 

-- SELECT INTO 방식 : 결과값이 하나일때 사용 가능
-- 결과값이 몇 개 인지 알수 없을경우 CURSOR 사용 

-- 1) 명시적 커서 
-- declare : 커서 선언 
-- open : 커서 열기 
-- fetch : 커서에서 읽어온 데이터 사용 
-- close : 커서 닫기 


DECLARE
    -- 커서 데이터를 입력할 변수 선언 
    v_dept_row dept%rowtype;
    -- 명시적 커서 선언 
    CURSOR c1 IS
    SELECT
        deptno,
        dname,
        loc
    FROM
        dept
    WHERE
        deptno = 40;

BEGIN 
    -- 커서 열기 
    OPEN c1; 
    
    -- 읽어온 데이터 사용 
    FETCH c1 INTO v_dept_row;
    dbms_output.put_line('DEPTNO : ' || v_dept_row.deptno);
    dbms_output.put_line('DNAME : ' || v_dept_row.dname);
    dbms_output.put_line('LOC : ' || v_dept_row.loc);
    
    -- 커서 닫기 
    CLOSE c1;
END;
/

-- 여러 행이 조회되는 경우 
DECLARE
    -- 커서 데이터를 입력할 변수 선언 
    v_dept_row dept%rowtype;
    -- 명시적 커서 선언 
    CURSOR c1 IS
    SELECT
        deptno,
        dname,
        loc
    FROM
        dept;

BEGIN 
    -- 커서 열기 
    OPEN c1;
    LOOP 
      -- 읽어온 데이터 사용 
        FETCH c1 INTO v_dept_row;
        
        -- 커서에서 더이상 읽어올 행이 없을 때 까지         
        EXIT WHEN c1%notfound;
        dbms_output.put_line('DEPTNO : ' || v_dept_row.deptno);
        dbms_output.put_line('DNAME : ' || v_dept_row.dname);
        dbms_output.put_line('LOC : ' || v_dept_row.loc);
    END LOOP;
    
    -- 커서 닫기 
    CLOSE c1;
END;
/




-- CURSOR FOR ~ LOOP 
DECLARE
    -- 명시적 커서 선언 
    CURSOR c1 IS
    SELECT
        deptno,
        dname,
        loc
    FROM
        dept;

BEGIN 
    -- || : 연결 해준다 
    -- 자동 OPEN , FETCH , CLOSE
    FOR c1_rec IN c1 LOOP
        dbms_output.put_line('DEPTNO : '
                             || c1_rec.deptno
                             || ' DNAME : '
                             || c1_rec.dname
                             || ' LOC : '
                             || c1_rec.loc);
    END LOOP;
END;
/

DECLARE
    -- 사용자가 입력한 부서 번호를 저장하는 변수 선언 
    v_deptno dept.deptno%TYPE;  -- DEPT 테이블에 DEPTNO 타입으로 선언할것이다 

    -- 명시적 커서 선언 
    CURSOR c1 (
        p_deptno dept.deptno%TYPE
    ) IS
    SELECT
        deptno,
        dname,
        loc
    FROM
        dept
    WHERE
        deptno = p_deptno;

BEGIN 
    -- input_deptno 에 부서번호 입력받고 v_deptno에 대입
    v_deptno := &input_deptno;

    -- || : 연결 해준다 
    -- 자동 OPEN , FETCH , CLOSE
    FOR c1_rec IN c1(v_deptno) LOOP
        dbms_output.put_line('DEPTNO : '
                             || c1_rec.deptno
                             || ' DNAME : '
                             || c1_rec.dname
                             || ' LOC : '
                             || c1_rec.loc);
    END LOOP;

END;
/

-- 묵시적 커서 : 커서 선언 없이 사용 
-- SELECT ~ INTO  / DML(UPDATE/DELETE/INSERT) 
-- SQL%ROWCOUNT : 묵시적 커서 안에 추출된 행이 있으면 행의 수 출력 
-- SQL%FOUND : 묵시적 커서 안에 추출된 행이 있으면 TRUE , 없으면 FALSE 
-- SQL%ISOPEN : 자동으로 SQL문을 실행 한후 CLOSE 되기 때문에 항상 FALSE
-- SQL%NOTFOUND : 커서 안에 추출된 행이 있으면 TRUE , 없으면 FALSE 
BEGIN
    UPDATE dept_temp
    SET
        dname = 'DATABASE'
    WHERE
        deptno = 60;

    dbms_output.put_line('갱신된 행의 수 : ' || SQL%rowcount);
    IF SQL%found THEN
        dbms_output.put_line('갱신 대상 행 존재 여부 : TRUE');
    ELSE
        dbms_output.put_line('갱신 대상 행 존재 여부 : FALSE');
    END IF;

    IF SQL%isopen THEN
        dbms_output.put_line('커서의 OPEN 여부 : TRUE');
    ELSE
        dbms_output.put_line('커서의 OPEN 여부 : FALSE');
    END IF;

END;
/

-- 저장 서브 프로그램 (이름지정 , 저장 , 저장할 때 한 번 컴파일 , 공유해서 사용가능
-- 다른 응용프로그램에서 호출 가능 ) 
-- 1) 저장 프로시저 : SQL 문에서는 사용불가 
-- 2) 저장 함수 : SQL 문에서 사용 가능 
-- 3) 트리거 : 특정상황이 발생할 때 자동으로 연달아 수행할 기능을 구현하는데 사용 
-- 4) 패키지 : 저장서브 프로그램을 그룹화 할때 사용 

CREATE PROCEDURE pro_noparam IS
    v_empno NUMBER(4) := 7788;
    v_ename VARCHAR2(10);
BEGIN
    v_ename := 'SCOTT';
    dbms_output.put_line('V_EMPNO: ' || v_empno);
    dbms_output.put_line('V_ENAME: ' || v_ename);
END;
/

-- 프로시저 실행 
EXECUTE pro_noparam;

-- 다른 PL/SQL블록에서 프로시저 실행 
BEGIN
    pro_noparam;
END;
/

-- 프로시저 작성 시 파라미터가 존재하는 경우 
-- IN(기본값-생략가능)  
CREATE OR REPLACE PROCEDURE pro_param_in (
    param11 IN NUMBER,
    param12 NUMBER,
    param13 NUMBER := 3,
    param14 NUMBER DEFAULT 4
) IS
BEGIN
    dbms_output.put_line('param11: ' || param11);
    dbms_output.put_line('param12: ' || param12);
    dbms_output.put_line('param13: ' || param13);
    dbms_output.put_line('param14: ' || param14);
END;
/

-- 프로시저 실행 
EXECUTE pro_param_in(1,2);



EXECUTE pro_param_in(5,6,7,8);

EXECUTE pro_param_in(1);

-- OUT 모드 
CREATE OR REPLACE PROCEDURE pro_param_out (
    in_empno  IN emp.empno%TYPE,
    out_ename OUT emp.ename%TYPE,
    out_sal   OUT emp.sal%TYPE
) IS
BEGIN
    SELECT
        ename,
        sal
    INTO
        out_ename,
        out_sal
    FROM
        emp
    WHERE
        empno = in_empno;

END;
/


DECLARE
    v_ename emp.ename%TYPE;
    v_sal   emp.sal%TYPE;
BEGIN
    pro_param_out(7369, v_ename, v_sal);
    dbms_output.put_line('ename : ' || v_ename);
    dbms_output.put_line('sal : ' || v_sal);
END;
/


-- in_out 모드 
CREATE OR REPLACE PROCEDURE pro_param_in_out (
    in_out_no IN OUT NUMBER
) IS
BEGIN
    in_out_no := in_out_no * 2;
END;
/

DECLARE
    no NUMBER;
BEGIN
    no := 5;
    pro_param_in_out(no);
    dbms_output.put_line('no : ' || no);
END;
/

-- 트리거 
-- DML 트리거 
-- CREATE OR REPLACE trigger 트리거이름 
-- BEFORE | AFTER 
-- INSERT | UPDATE | DELETE ON 테이블이름 
-- DECLARE
-- BEGIN
-- END 

CREATE TABLE emp_trg
    AS
        SELECT
            *
        FROM
            emp;

-- emp_trg insert (주말에 사원정보 추가시 에러), update , delete 
CREATE OR REPLACE TRIGGER emp_trg_weekend BEFORE
    INSERT OR UPDATE OR DELETE ON emp_trg
BEGIN
    IF to_char(sysdate, 'DY') IN ( '토', '일' ) THEN
        IF inserting THEN
            raise_application_error(-30000, '주말 사원정보 추가 불가');
        ELSIF updating THEN
            raise_application_error(-30001, '주말 사원정보 수정 불가');
        ELSIF deleting THEN
            raise_application_error(-30002, '주말 사원정보 삭제 불가');
        ELSE
            raise_application_error(-30003, '주말 사원정보 변경 불가');
        END IF;

    END IF;
END;
/

UPDATE emp_trg
SET
    sal = 3500
WHERE
    empno = 7369;


-- 트리거 발생 저장 테이블 생성 
CREATE TABLE emp_trg_log (
    tablename   VARCHAR2(20), -- DML 이 수행된 테이블 이름
    dml_type    VARCHAR2(10),  -- DML 명령어 종류 
    empno       NUMBER(4),        -- DML 대상이 된 사원번호 
    user_name   VARCHAR2(30), -- DML 을 수행한 USER 명 
    change_date DATE
);      -- DML 시도 날짜 

CREATE OR REPLACE TRIGGER emp_trg_weekend_log 
AFTER
INSERT OR UPDATE OR DELETE ON emp_trg
FOR EACH ROW    -- 영향받는 모든 행별 실행 
BEGIN
    IF inserting THEN
        INSERT INTO emp_trg_log VALUES (
            'EMP_TRG',
            'INSERT',
            :new.empno,
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            sysdate
        );

    ELSIF updating THEN
        INSERT INTO emp_trg_log VALUES (
            'EMP_TRG',
            'UPDATE',
            :old.empno,
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            sysdate
        );

    ELSIF deleting THEN
        INSERT INTO emp_trg_log VALUES (
            'EMP_TRG',
            'DELETE',
            :old.empno,
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            sysdate
        );

    END IF;
END;
/
insert into emp_trg
values(9999,'test_tmp' , 'clerk' , 7788 , '2018-03-03' , 1200 , null , 20);

commit;

select * from emp_trg_log;

drop trigger emp_trg_weekend_log;