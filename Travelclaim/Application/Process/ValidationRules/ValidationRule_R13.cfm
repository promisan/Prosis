<!--- 
Validation Rule :  R13
Name			:  Flag for accounts review if the DSA location is not in the travel request. Ignores locations within the same city.
Creation Date	:  29 October 2008
Created         : Huda Seid
---->

<cfset tcp_temp_R13_1 = 'TCP_R13_0'&RandRange(1,500)&RandRange(1,500)&RandRange(1,500)>
<!----Select all cities that are in the travel request ---->
<cfquery name="DSARequest" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT 	countrycityid
	INTO 	userquery.dbo.#tcp_temp_R13_1#
	FROM 	Ref_CountryCityLocation
	WHERE 	locationcode in (SELECT servicelocation 
							FROM ClaimRequestDSA
							WHERE ClaimRequestId = '#ClaimRequest.ClaimRequestId#')
</cfquery>
<!----select only those records when the locationcode is not in the city above excluding locations during annual leave ---->
<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT  *
    FROM    ClaimLineDSA
    WHERE   ClaimId = '#URL.ClaimId#'
    AND 	calendardate not in (SELECT calendardate 
			 					FROM dbo.ClaimLineDateIndicator 
			 					WHERE indicatorcode='P01' and claimid='#URL.ClaimId#')
    AND 	LocationCode NOT IN (SELECT locationcode 
	                         	from Ref_CountryCityLocation a,
									userquery.dbo.#tcp_temp_R13_1# b
							  	where a.countrycityid=b.countrycityid) 
	
</cfquery>	

<<cfif Check.recordcount gte "1">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfif>	 		