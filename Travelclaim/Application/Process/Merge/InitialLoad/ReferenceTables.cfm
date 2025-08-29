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
<cfsilent>
	 <proOwn></proOwn>
	 <proDes>Updating/creating ref tables </proDes>
	 <proCom>modified by MKM on 21/11/2008 to call PrepareStPersonNew.cfm instead of PrepareStPerson.cfm  </proCom>
</cfsilent>

<!--- select employees with an entry in ClaimRequest, provision for unique
personNo --->
<cfquery name="step" 
datasource="appsTravelClaim">
SELECT    MAX(PersonNo) AS PersonNo		  
INTO      tmp_Person
FROM      #employ#.Person
WHERE     (
          IndexNo  IN (SELECT f_prsn_index_num FROM IMP_CLAIMREQLINE) 
		  OR
          PersonNo IN (SELECT PersonNo FROM ClaimRequest)
		  )
AND       Category is null 
GROUP BY  IndexNo, LastName, FirstName, BirthDate, Nationality
</cfquery>

<cfquery name="step2" 
datasource="appsTravelClaim">
INSERT INTO  tmp_Person
SELECT  PersonNo
FROM    #employ#.Person
WHERE   PersonNo NOT IN
                 (SELECT   PersonNo
                  FROM     tmp_Person) 
	AND IndexNo IN
            (SELECT  f_prsn_index_num
             FROM    IMP_CLAIMREQLINE)


</cfquery>

<cfinclude template="PrepareStPersonNew.cfm">

<!--- prepare location codes for travel claim DSA table --->
<!--- Commentd By Joseph as asked by Karl Bringing in dates field also in the initial
upload ---->
<!---
<cfquery name="step" 
datasource="appsTravelClaim" >
INSERT INTO Ref_PayrollLocation
	      (LocationCode, 
		   LocationCountry, 
		   LocationCity, 
		   Description, 
		   OfficerUserId, 
		   OfficerLastName, 
		   OfficerFirstName)     
SELECT 	rtrim(f_cnty_id_code) + id_code, 
        f_cnty_id_code, 
	    id_code, 
	    name,'nova','Van Pelt','Hanno'
FROM    IMP_DSALocation
WHERE rtrim(f_cnty_id_code) + id_code NOT IN (SELECT LocationCode 
                                              FROM   Ref_PayrollLocation)
</cfquery>
---->
<!--- prepare location codes for travel claim DSA table added dateeffective min and max are used to get
the ref_payrollocation data if it is null insert 01/01/3099 date and then update it with NUll
because of the mysteries of sql JG3  --->

<cfquery name="step" 
datasource="appsTravelClaim" >
INSERT INTO Ref_PayrollLocation
	      (LocationCode, 
		   LocationCountry, 
		   LocationCity, 
		   Description, 
		   DateEffective,
		   DateExpiration,
		   OfficerUserId, 
		   OfficerLastName, 
		   OfficerFirstName)     
SELECT 	rtrim(A.f_cnty_id_code) + A.id_code, 
        A.f_cnty_id_code, 
	    A.id_code, 
		name,
          min(B.eff_date),
          max(isnull(B.term_date,'01/01/3099')) ,
           'nova','Van Pelt','Hanno'
FROM    IMP_DSALocation A, IMP_DSARATE B

where  rtrim(A.f_cnty_id_code) = rtrim(B.f_cnty_id_code)
and    rtrim(A.id_code) =rtrim(B.f_dsal_id_code)
and rtrim(A.f_cnty_id_code) + A.id_code NOT IN (SELECT LocationCode 
                                              FROM   Ref_PayrollLocation)		
group by A.f_cnty_id_code,A.id_code,name		
								  
</cfquery>

<cfquery name="stepupdate" 
datasource="appsTravelClaim" >

select max(isnull(term_date,'01/01/3099'))as max_date, rtrim(f_cnty_id_code) + f_dsal_id_code as temp_dsal
into temp_IMP_DSARATE
from IMP_DSARATE 
group by f_cnty_id_code,f_dsal_id_code
update temp_IMP_DSARATE
set max_date = NULL where max_date ='01/01/3099'

update Ref_PayrollLocation
set DateExpiration = isnull(max_date,NULL)
from Ref_PayrollLocation A,temp_IMP_DSARATE B
where A.locationCode = B.temp_dsal
								  
</cfquery>


<!--- prepare dsa rates --->

<cfquery name="ClearRates" 
datasource="appsTravelClaim" >
DELETE  FROM Ref_ClaimRates
WHERE   Source        = 'IMIS' 
AND     ClaimCategory = 'DSA'
</cfquery>

<cfquery name="InsertRates" 
datasource="appsTravelClaim" >
INSERT INTO Ref_ClaimRates
            (Source, 
			 ClaimCategory, 
			 AmountPeriod, 
			 ServiceLocation, 
			 RatePointer, 
			 DateEffective, 
			 DateExpiration, 
             PostGrade, 
			 AmountBase, 
			 Currency, 
			 Amount,
			 RoomRate, 
			 OfficerUserId)
SELECT       'IMIS' AS Expr1, 
             'DSA' AS Expr2, 
			 'DAY' AS Expr3, 
			 rtrim(IMP_DSARate.f_cnty_id_code) + IMP_DSARate.f_dsal_id_code AS LocationCode, 
			 stDSAPointer.Days,                      
			 IMP_DSARate.eff_date, 
			 IMP_DSARate.term_date, 
			 rtrim(IMP_DSARate.f_dssg_catg_id_code) + '-' + IMP_DSARate.f_dssg_grde_id_code AS PostGrade,    
             IMP_DSARate.usd_rate_amt, 
			 IMP_DSARate.f_curr_code, 
             IMP_DSARate.local_curr_rate_amt, 
			 IMP_DSARate.room_rate_pct, 
             'nova' AS Expr4
FROM         IMP_DSARate INNER JOIN stDSAPointer ON IMP_DSARate.Pointer = stDSAPointer.PointerDays
</cfquery>

<!--- currency table --->

<cfquery name="addcurrency" 
datasource="appsTravelClaim" >
INSERT INTO #ledger#.Currency (Currency, OfficerUserId)
SELECT   DISTINCT f_curr_code, 'nova' AS Expr1
FROM     IMP_EXCHANGE
WHERE    f_curr_code NOT IN         
             (SELECT     Currency FROM  #ledger#.Currency)
</cfquery>

<cfquery name="delete" 
datasource="appsTravelClaim" >
	DELETE FROM #ledger#.CurrencyExchange
	WHERE  Currency != 'USD'
</cfquery>

<cfquery name="addExchange" 
datasource="appsTravelClaim" >
INSERT INTO #ledger#.CurrencyExchange
       (Currency, 
		EffectiveDate, 
		ExchangeRate, 
		OfficerUserId)
SELECT  DISTINCT f_curr_code, 
        eff_date, 
		rate, 
		'nucleus' AS Expr4
FROM    IMP_Exchange INNER JOIN
        #ledger#.Currency C ON  IMP_Exchange.f_curr_code = C.Currency
AND     f_curr_code != 'USD'		
</cfquery>



