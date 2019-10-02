CREATE PROCEDURE typeInheritance()
BEGIN
    DECLARE toProcess INT DEFAULT 0;
    SET @total = '""';
    SET @aux = '';

    SELECT GROUP_CONCAT(CONCAT('"', derived, '"')) INTO @aux FROM inheritance WHERE base IN ('Number');
    SET toProcess = (SELECT ROW_COUNT());
    SELECT CONCAT(@total, ',', @aux) INTO @total;
    SET @acc = @aux;

    WHILE toProcess > 0 AND @aux IS NOT NULL DO
        SET @qq = CONCAT('SELECT GROUP_CONCAT(CONCAT(\'"\', derived, \'"\')) INTO @aux FROM inheritance WHERE base IN (', @acc, ')' );
        PREPARE smt FROM @qq;
        EXECUTE smt;
        SET toProcess = (SELECT ROW_COUNT());
        DEALLOCATE PREPARE smt;

        IF @aux IS NOT NULL THEN
            SELECT CONCAT(@total, ',', @aux) INTO @total;
            SET @acc = @aux;
        END IF;


    END WHILE;

    SET @qq = CONCAT('SELECT var_name , type var_type FROM `variables` v WHERE type IN (', @total, ')' );
    PREPARE smt FROM @qq;
    EXECUTE smt;
END