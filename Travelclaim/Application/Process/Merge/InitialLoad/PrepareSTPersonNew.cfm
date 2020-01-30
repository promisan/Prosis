<cfsilent>
	 <proOwn>MKM</proOwn>
	 <proDes>Creation and update of Stperson (table of all persons with TVRQs)  </proDes>
	 <proCom> 21/11/2008: Update from IMIS data + Personno from system\usernames </proCom>
</cfsilent>

<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="stPerson">

<!--- generate stPerson table for travel claim --->
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">
SELECT DISTINCT P.*
INTO       	stPerson 
FROM       	IMP_Person P,
			IMP_CLAIMREQLINE C
WHERE      	C.f_prsn_index_num = P.indexno

</cfquery>
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

CREATE CLUSTERED INDEX IX_stPerson ON dbo.stPerson
	(
	PersonNo
	) ON [PRIMARY]
	
</cfquery>
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

CREATE NONCLUSTERED INDEX IX_stPerson_1 ON dbo.stPerson
	(
	IndexNo
	) ON [PRIMARY]
	
CREATE NONCLUSTERED INDEX IX_stPerson_2 ON dbo.stPerson
	(
	prsn_index_num
	) ON [PRIMARY]

</cfquery>

<!--- update grade --->

<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

UPDATE stPerson
SET    Grade = STFM.smgr_catg_grde_id_code
FROM   stPerson P,	IMP_StaffMember STFM
WHERE  P.IndexNo = STFM.IndexNo
AND STFM.smgr_catg_grde_id_code IS NOT NULL

</cfquery>

<!--- MKM - November 19, 2008 - Append the SM's ORGU from IMIS  ---> 

<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

UPDATE stPerson
SET    StaffMemberOrg = LTRIM(RTRIM(SMGR.post_f_orgu_id_code))
FROM   stPerson P,	IMP_StaffMember SMGR
WHERE  P.IndexNo = SMGR.IndexNo
AND SMGR.post_f_orgu_id_code IS NOT NULL

</cfquery>


<!--- MKM - November 19, 2008 - Append the email Address from IMIS  ---> 

<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

UPDATE stPerson
SET    EmailAddress = LTRIM(RTRIM(EML.email_addr))
FROM   stPerson P,	IMP_email_address EML
WHERE  P.IndexNo = EML.IndexNo

</cfquery>


<!--- update Other STFM Fields --->
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

UPDATE stPerson
SET    OrganizationStart = STFM.stfm_un_eod_date
FROM   stPerson P,	IMP_StaffMember STFM
WHERE  P.IndexNo = STFM.IndexNo

</cfquery>


<!--- determine on-payroll indicator --->

<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">
UPDATE    stPerson
SET       OnPayroll = 1
FROM      IMP_Paygroup INNER JOIN
          stPerson ON IMP_Paygroup.f_prsn_index_num = stPerson.prsn_index_num
WHERE     (IMP_Paygroup.eff_date < GetDate()) AND (IMP_Paygroup.exp_date IS NULL OR
           IMP_Paygroup.exp_date >= GetDate())
</cfquery>					  


<!--- MKM - November 19, 2008 - Append the PersonNo from the Nova System.UserNames table ---> 
<!--- Why exclude PersonNo 53818?  Only the Shaodow knows. It seems to be some kind of weird default. --->
<cfquery name="stPersonGenerate" 
datasource="appsTravelClaim">

UPDATE 	stPerson
SET    	PersonNo = UNME.PersonNo
FROM 	stPerson P,	
		System.dbo.UserNames UNME
WHERE  	P.IndexNo = UNME.IndexNo
AND UNME.PersonNo <> 'IND' + UNME.IndexNo
AND UNME.PersonNo <> '53818'
AND UNME.IndexNo IS NOT NULL
AND UNME.PersonNo IS NOT NULL
AND UNME.IndexNo <> ''
AND UNME.PersonNo <> ''

</cfquery>