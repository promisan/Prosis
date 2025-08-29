<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="step" 
datasource="appsTravelClaim" >
SELECT     C.PersonNo, 
           I.eff_date, 
		   I.expir_date,
		   I.f_curr_code, 
		   I.f_fnli_un_id_code, 
		   I.acct_num, 
		   I.AccountType, 
		   A.AccountId, 
		   I.name, 
		   I.strt_addr, 
		   I.city, 
		   I.f_cnty_id_code, 
           I.routing_num_int, 
		   I.seq_num
INTO       tmp_ref4
FROM       stPerson C INNER JOIN IMP_PERSONBANK I ON C.IndexNo = 
            I.f_prsn_index_num LEFT OUTER JOIN
            PersonAccount A ON I.f_fnli_un_id_code = A.BankCode 
			AND I.acct_num = A.AccountNo 
			AND C.PersonNo = A.PersonNo 
</cfquery>

<cfquery name="step" 
datasource="appsTravelClaim" >
	INSERT INTO Ref_Bank
	       (Code, Description, OfficerUserId)
	SELECT DISTINCT f_fnli_un_id_code, MAX(name) AS Name, 'Nucleus'
	FROM   tmp_ref4
	WHERE  (f_fnli_un_id_code NOT IN (SELECT  Code FROM Ref_Bank))
	GROUP BY f_fnli_un_id_code
</cfquery>

<cfquery name="INSERTAccount" 
datasource="appsTravelClaim" >
	INSERT INTO   PersonAccount
	       (PersonNo, Bankcode, BankName, AccountNo, AccountType, AccountCurrency, DateEffective, DateExpiration, Source, OfficerUserId,Created)
	SELECT PersonNo, f_fnli_un_id_code, left(name,80), acct_num, AccountType, f_curr_code, eff_date, expir_date, 'IMIS', 'Nucleus', getdate()
	FROM   tmp_ref4
	WHERE  AccountId is NULL
</cfquery>

<cfquery name="UPDATEACCOUNT" 
datasource="appsTravelClaim" >
UPDATE   PersonAccount
    SET  DateEffective = T.eff_date,
		 DateExpiration = T.expir_date,
         AccountType = T.AccountType,
         AccountCurrency = T.f_curr_code,
		 Operational = 1
FROM     PersonAccount S, tmp_ref4 T
WHERE    S.AccountId = T.AccountId
AND      T.AccountId is not NULL
</cfquery>

<cfquery name="step" 
datasource="appsTravelClaim" >
DELETE FROM PersonAccount
WHERE  AccountId NOT IN (SELECT   PersonAccount.AccountId 
		  			      FROM    tmp_ref4 INNER JOIN
					           	  PersonAccount ON tmp_ref4.PersonNo = PersonAccount.PersonNo 
						  AND     tmp_ref4.f_fnli_un_id_code = PersonAccount.BankCode 
						  AND     tmp_ref4.acct_num = PersonAccount.AccountNo)
AND AccountId NOT IN (SELECT FieldValue 
                      FROM   ClaimReimbursement	
					  WHERE  FieldName = 'Account' 
					  AND    FieldValue is not NULL)							
</cfquery>

<cfquery name="update" 
datasource="appsTravelClaim" >
UPDATE PersonAccount
SET Operational = 0
WHERE  AccountId NOT IN (SELECT   PersonAccount.AccountId 
		  			      FROM    tmp_ref4 INNER JOIN
					           	  PersonAccount ON tmp_ref4.PersonNo = PersonAccount.PersonNo 
						  AND     tmp_ref4.f_fnli_un_id_code = PersonAccount.BankCode 
						  AND     tmp_ref4.acct_num = PersonAccount.AccountNo)
AND AccountId IN (SELECT FieldValue 
                      FROM   ClaimReimbursement	
					  WHERE  FieldName = 'Account' 
					  AND    FieldValue is not NULL)							
</cfquery>

<cfquery name="update" 
datasource="appsTravelClaim" >
UPDATE PersonAccount
SET Operational = 0
WHERE  AccountId NOT IN (SELECT   PersonAccount.AccountId 
		  			      FROM    tmp_ref4 INNER JOIN
					           	  PersonAccount ON tmp_ref4.PersonNo = PersonAccount.PersonNo 
						  AND     tmp_ref4.f_fnli_un_id_code = PersonAccount.BankCode 
						  AND     tmp_ref4.acct_num = PersonAccount.AccountNo)
AND AccountId IN (SELECT FieldValue 
                      FROM   ClaimReimbursement	
					  WHERE  FieldName = 'Account' 
					  AND    FieldValue is not NULL)							
</cfquery>

<cfquery name="update" 
datasource="appsTravelClaim" >
UPDATE PersonAccount
SET Operational = 0
WHERE  DateExpiration < getDate()
</cfquery>
