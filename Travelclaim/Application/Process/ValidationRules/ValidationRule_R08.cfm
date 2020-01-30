<!--- 
Validation Rule :  R08
Name 			:  Meals and accomodation is different from travel request
Steps 			:  Check claim indicator with request indicator
Date 			:  15 November 2007

---------------------Modification-----------------------------

Last Modified 	:  24/08/2008
Last Modfied By :  Huda Seid
Change Made 	:  Made changes to flag claims for EO Review if the meals and/or accommodation is flagged on the TVRQ then
					check if either breakfast, lunch or dinner is unmarked in the claim or if accommodation is unchecked in the claim --->


<!----Check if meals indicator is turned on in TVRQ --->
<cfquery name='mealsinrequest' 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#"> 

Select 	*
from 	ClaimRequestLineIndicator
where 	indicatorcode in ('T04')
		AND ClaimRequestid  = '#ClaimRequest.ClaimRequestId#'

</cfquery>
<!----Check if accommodation indicator is turned on in TVRQ --->
<cfquery name='accinrequest' 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#"> 
Select 	*
from 	ClaimRequestLineIndicator
where 	indicatorcode in ('T03')
	AND ClaimRequestid  = '#ClaimRequest.ClaimRequestId#'
</cfquery>

<!----If either meals or accommodation indicator is turned on then proceed to check --->
<cfif accinrequest.recordcount gte 1 or mealsinrequest.recordcount gte 1>

<!---Create temporary tables and hence pre-define them here--->

<cfset tcp_temp_R08_1 = 'TCP_R08_0'&RandRange(1,500)&RandRange(1,500)&RandRange(1,500)>
<cfset tcp_temp_R08_2 = 'TCP_R08_1'&RandRange(1,500)&RandRange(1,500)&RandRange(1,500)>

<!----Get in a temp table all DSA days of the claim when meals is turned on in the travel request ---->
	<cfquery name="DSADayswithmeals" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#"> 
			select a.*,
					b.dateeffective,
					b.dateexpiration,
					indicatorcode as reqindicator
			Into	userquery.dbo.#tcp_temp_R08_1# 
			from 	claimlinedsa a,
					dbo.ClaimRequestLineIndicator b
			where 	a.claimrequestid=b.claimrequestid and
					a.claimrequestid='#ClaimRequest.ClaimRequestId#' and
					a.calendardate >= b.dateeffective and 
					a.calendardate <= b.dateexpiration and
					b.indicatorcode='T04'
	</cfquery> 
	<!---For all the dsa days where meal is turned on in the request, check to see if all the three meals are not provided --->
	<cfquery name="checkmeals" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#"> 
		 
		  	select a.calendardate
			from 	userquery.dbo.#tcp_temp_R08_1# a, 
					claimlinedateindicator b
			where 	a.calendardate=b.calendardate and 
					b.claimid='#URL.ClaimId#' and
				  	b.indicatorcode in ('T041','T042','T043') 
			group by a.calendardate
			having count(*) <3
	</cfquery>

<!----Get in a temp table all DSA days of the claim when accomodation indicator is turned on in the travel request ---->
<cfquery name="DSADayswithacc" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#"> 
			select 	a.*,
					b.dateeffective,
					b.dateexpiration,
					indicatorcode as reqindicator
			Into	userquery.dbo.#tcp_temp_R08_2# 
			from 	claimlinedsa a,
					dbo.ClaimRequestLineIndicator b
			where 	a.claimrequestid=b.claimrequestid and
					a.claimrequestid='#ClaimRequest.ClaimRequestId#' and
					a.calendardate >= b.dateeffective and 
					a.calendardate <= b.dateexpiration and
					b.indicatorcode='T03' 
	</cfquery> 
	
<!----Get DSA days in claim when accomodation is turned on in travel request (temp table) and not in claim ---->
	<cfquery name="checkacc" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#"> 
		 	
			<!--- FDT 29/10/08: I did not change the query but I don't see use of a.reqindicator='T03' --->
			select 	* 
			from 	userquery.dbo.#tcp_temp_R08_2#  a 
			where	a.reqindicator='T03' and
					a.calendardate not in (select calendardate
							 				from 	claimlinedateindicator b
											where indicatorcode ='T03' and 
											claimid='#URL.Claimid#')				
	</cfquery>
	<!---If either meals or accommodation indicator is turned off in the claim while turned in the claim request then flag claim--->
	
	<cfif checkmeals.recordcount gt 0 or checkacc.recordcount gt 0>
		<cf_ValidationInsert
		 ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
		
	</cfif>
	
	<!--- FDT 29/10/08: error on the drop corrected --->
	Drop table userquery.dbo.#tcp_temp_R08_1# 
	Drop table userquery.dbo.#tcp_temp_R08_2# 
</cfif>



<!------------------------------------------------------------------------------------
----------------------------PREVIOUS CODE--------------------------------------------
<cfquery name="Dates" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
	SELECT  DISTINCT CalendarDate
	FROM    ClaimLineDateIndicator I INNER JOIN
	        Ref_Indicator R ON I.IndicatorCode = R.Code
	WHERE   I.ClaimId = '#URL.ClaimId#'
	AND     R.ParentCode not in ('P01','P02') <!--- personal days, DSA LOCATION --->
</cfquery> 

<cfset diff = 0>

<cfloop query="Dates">
	
	<cfif diff eq "0">
	
		<cfquery name="ClaimNotInRequest" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT   *
		FROM     ClaimLineDateIndicator I INNER JOIN
		             Ref_Indicator R ON I.IndicatorCode = R.Code
		WHERE    I.ClaimId = '#URL.ClaimId#'
		AND     I.CalendarDate = '#dateformat(CalendarDate,CLIENT.DateSQL)#'
		AND     R.ParentCode not in ('P01','P02') <!--- personal days, DSA LOCATION ---> 
		AND     R.ParentCode NOT IN
		                          (SELECT   IndicatorCode
		                            FROM    ClaimRequestLineIndicator
		                            WHERE   ClaimRequestid  = '#ClaimRequest.ClaimRequestId#' 
		AND     DateEffective  <= '#dateformat(CalendarDate,CLIENT.DateSQL)#'
		AND     DateExpiration >= '#dateformat(CalendarDate,CLIENT.DateSQL)#' 
		  ) 
		</cfquery> 
		
		<cfquery name="RequestNotClaimed" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT   IndicatorCode
		    FROM     ClaimRequestLineIndicator
		    WHERE    ClaimRequestid = '#ClaimRequest.ClaimRequestId#'
		AND      DateEffective  <= '#dateformat(CalendarDate,CLIENT.DateSQL)#'
		AND      DateExpiration >= '#dateformat(CalendarDate,CLIENT.DateSQL)#' 
		AND      IndicatorCode NOT IN (SELECT R.ParentCode
		   FROM   ClaimLineDateIndicator I INNER JOIN
		                                          Ref_Indicator R ON I.IndicatorCode = R.Code
		   WHERE  I.ClaimId = '#URL.ClaimId#'
		   AND    I.CalendarDate = '#dateformat(CalendarDate,CLIENT.DateSQL)#'
		  ) 
		</cfquery> 
		
		<cfif ClaimNotInrequest.recordcount gte "1" or RequestNotClaimed.recordcount gte "1">
		   <cfset diff = 1> 
		</cfif> 
	
	</cfif>

</cfloop> 

<cfif diff eq "1">
	
	<cf_ValidationInsert
	    ClaimId        = "#URL.ClaimId#"
	ClaimLineNo    = ""
	CalculationId  = "#rowguid#"
	ValidationCode = "#code#"
	ValidationMemo = "#Description#"
	Mission        = "#ClaimRequest.Mission#">

</cfif> 

-------------------------------------------------------------------------------------------------->

	
	
	
	
	
	
	