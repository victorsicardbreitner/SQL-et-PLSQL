--CREATE OR REPLACE Procedure calculTemps ( name_in IN varchar2 )

DROP VIEW vue_Poste_Installer_Logiciel;
CREATE VIEW vue_Poste_Installer_Logiciel AS
	SELECT l.dateAch, i.dateIns, p.nomPoste, p.nPoste, l.nomLog
FROM Poste p
LEFT JOIN Installer i ON p.nPoste = i.nPoste
LEFT JOIN Logiciel l ON l.nLog = i.nLog;

SELECT * FROM vue_Poste_Installer_Logiciel;

/*
CREATE VIEW Poste_0 AS
	SELECT p.nPoste, p.nomPoste, p.nSalle, p.typePoste, p.indIP, p.ad
    FROM Poste p
    LEFT JOIN Segment s ON p.indIP = s.indIP
    WHERE s.etage=0;	
*/		





SET serveroutput ON;
DECLARE 
	CURSOR cursor IS SELECT dateAch, dateIns, nomPoste, nPoste, nomLog FROM vue_Poste_Installer_Logiciel ORDER BY dateAch ASC;
	record_cur cursor%ROWTYPE;
BEGIN
	OPEN cursor;

	LOOP
		FETCH cursor INTO record_cur;
		dbms_output.put_line(
			'Logiciel ' ||  record_cur.nomLog ||
			' sur ' ||  record_cur.nomPoste ||
			' attente ' || ROUND(record_cur.dateIns - record_cur.dateAch) ||
			' jours'
		);
		--UPDATE Installer SET delai = (record_cur.dateIns - record_cur.dateAch)*24*60*60 DAY TO SECOND WHERE  nPoste =  record_cur.nPoste;
		--UPDATE Installer  SET delai = (record_cur.dateIns - record_cur.dateAch) DAY TO SECOND WHERE nPoste = record_cur.nPoste;
		UPDATE Installer  SET delai =  (record_cur.dateIns - record_cur.dateAch) DAY(5) TO SECOND(2) WHERE nPoste = record_cur.nPoste;
		EXIT WHEN cursor%NOTFOUND;
	END LOOP ;
	CLOSE cursor;
END;

/

/*
SELECT nLog, 
	abs( extract( SECOND FROM delai ) 
          + extract( MINUTE FROM delai ) * 60 
          + extract( HOUR FROM delai ) * 60 * 60 
          + extract( DAY FROM delai ) * 60 * 60 * 24
        ) AS delaisecond
	FROM Installer;
	*/

/*
SELECT nLog, nPoste,
	abs( extract( DAY FROM delai ) 
        ) AS delaisecond
	FROM Installer;


SELECT nLog, dateAch FROM Logiciel;
SELECT nLog, dateIns, nPoste FROM Installer;
*/




/*
DECLARE 
	CURSOR cursor IS SELECT l.dateAch, i.dateIns, p.nomPoste, l.nomLogiciel, p.nPoste FROM vue_Poste_Installer_Logiciel ORDER BY dateAch ASC;

	record_cur cursor%ROWTYPE;
	v_delai NUMBER;
BEGIN
	OPEN cursor;

	LOOP
		FETCH cursor INTO record_cur;
		EXIT WHEN cursor%NOTFOUND;

		IF record_cur.dateAch IS NULL THEN
			DBMS_OUTPUT.PUT_LINE('Date d''achat inconnue pour le logiciel '|| record_cur.nomLogiciel ||' sur Poste '|| record_cur.nPoste);
		ELSIF record_cur.dateIns IS NULL THEN
			DBMS_OUTPUT.PUT_LINE('Pas de date d''installation pour le logiciel '|| record_cur.nomLogiciel ||' sur Poste '|| record_cur.nPoste);
		ELSE
			v_delai := record_cur.dateIns - record_cur.dateAch;
			IF v_delai < 0 THEN
				DBMS_OUTPUT.PUT_LINE('Logiciel '|| record_cur.nomLogiciel ||' installé sur Poste '|| record_cur.nPoste ||' '|| ABS(v_delai) ||' jour (s) avant d''être acheté!');
			ELSE
				UPDATE Installer
				SET delai = v_delai
				WHERE  nPoste =  record_cur.nPoste;
				DBMS_OUTPUT.PUT_LINE('Logiciel '|| record_cur.nomLogiciel ||' sur Poste '|| record_cur.nPoste ||', attente '|| v_delai ||' jour (s).');
			END IF;
		END IF;
	END LOOP;
	
	CLOSE cursor;
END;
/
*/