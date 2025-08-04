<!--
    Copyright © 2025 Promisan

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

<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="stPerson">


<!--- generate stPerson table for travel claim --->
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">
SELECT     P.*, 
		   'undefined' as Grade, 
		   '0' as OnPayroll,
		   CONVERT(VARCHAR(4), NULL) AS StaffMemberOrg
INTO       stPerson
FROM       #employ#.Person P
WHERE      PersonNo IN (SELECT PersonNo 
                        FROM tmp_Person)
</cfquery>


<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">
DELETE FROM stPerson
WHERE IndexNo IN (SELECT IndexNo
					FROM         stPerson
					GROUP BY IndexNo
					HAVING      (COUNT(*) > 1)
				)
</cfquery>

<!--- update grade --->

<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">
UPDATE stPerson
SET    Grade = c.ContractLevel
FROM   stPerson P,	#employ#.PersonContract C
WHERE  P.PersonNo = C.PersonNo
</cfquery>

<!--- MKM - June 27, 2008 - Added additional query to get the Grade from IMIS  ---> 
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

UPDATE stPerson
SET    Grade = SMGR.smgr_catg_grde_id_code
FROM   stPerson P,	IMP_StaffMember SMGR
WHERE  P.IndexNo = SMGR.IndexNo
AND SMGR.smgr_catg_grde_id_code IS NOT NULL

</cfquery>
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

UPDATE stPerson
SET    StaffMemberOrg = LTRIM(RTRIM(SMGR.post_f_orgu_id_code))
FROM   stPerson P,	IMP_StaffMember SMGR
WHERE  P.IndexNo = SMGR.IndexNo
AND SMGR.post_f_orgu_id_code IS NOT NULL

</cfquery>


<!--- MKM - November 19, 2008 - Append the email Address from IMIS  ---> 

<!--- The default is only 50 characters. That's too small. --->
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

ALTER TABLE stPerson ALTER COLUMN EmailAddress VARCHAR(150) NULL

</cfquery>

<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

UPDATE stPerson
SET    EmailAddress = LTRIM(RTRIM(EML.email_addr))
FROM   stPerson P,	IMP_email_address EML
WHERE  P.IndexNo = EML.IndexNo

</cfquery>


<!--- determine on-payroll indicator --->

<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">
UPDATE    stPerson
SET       OnPayroll = 1
FROM      IMP_Paygroup INNER JOIN
          stPerson ON IMP_Paygroup.f_prsn_index_num = stPerson.IndexNo
WHERE     (IMP_Paygroup.eff_date < GETDATE()) AND (IMP_Paygroup.exp_date IS NULL OR
           IMP_Paygroup.exp_date >= GETDATE())
</cfquery>					  