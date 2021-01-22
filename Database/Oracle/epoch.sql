CREATE OR REPLACE FUNCTION xxx."EPOCH_TO_ORA_DATE_FNC" (
IN_NUMBER IN NUMBER) RETURN DATE IS

V_DATE_OUT DATE;
c_Zero_Date DATE := to_date('01/01/1970','DD/MM/YYYY');
c_seconds_in_a_day NUMBER := 3600 * 24;

BEGIN

  -- Convert input number to a date
  V_DATE_OUT :=  c_Zero_Date + (IN_NUMBER/c_seconds_in_a_day);


  RETURN (V_DATE_OUT);
END REM_TO_ORA_DATE_FNC;
/



CREATE OR REPLACE FUNCTION XXX."ORA_TO_EPOCH_DATE_FNC" (IN_DATE IN DATE) RETURN NUMBER IS

V_NDATE_OUT NUMBER;
V_IN_DATE_GMT DATE;

c_Zero_Date DATE := to_date('01/01/1970','DD/MM/YYYY');
c_seconds_in_a_day NUMBER := 3600 * 24;
BEGIN


  V_NDATE_OUT := (IN_DATE - c_Zero_Date) * c_seconds_in_a_day ;

  RETURN (V_NDATE_OUT);
END ORA_TO_REM_DATE_FNC;
/
