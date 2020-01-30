
<!--- 
Validation Rule :  I13
Name			:  Prevent claim submission after 366 days after actual return date
Steps			:  Determine actual return date vs current date
Date			:  05 April 2006
Last date		:  15 June 2006
--->


<cfquery name="Parameter" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Parameter
</cfquery>	

<cfquery name="Check" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  MAX(ClaimEventTrip.ClaimTripDate) AS TripDate
	FROM    ClaimEventTrip INNER JOIN
            ClaimEvent ON ClaimEventTrip.ClaimEventId = ClaimEvent.ClaimEventId
	WHERE   ClaimId = '#IdClaim#'			  
</cfquery>	

<cfif #Check.TripDate# neq "">
	
	<!--- date within 366 days after return date --->
	
	<cfset diff = DateDiff("d", "#Check.TripDate#", "#now()#")>
			
	<cfif diff gt #Parameter.DaysExpiration#>
	
	     <cfset submission = "0">
	
	  	<tr><td valign="top" bgcolor="C0C0C0"></td></tr>
		 <tr>
			  <td valign="top" bgcolor="FDDFDB">
			  <table width="94%" cellspacing="2" cellpadding="2" align="center">
			  <tr><td valign="top" height="30">
				  <font color="FF0000"><b>Problem</b></font> : You CANNOT submit this claim.
				  <br>
				  <cfoutput>#MessagePerson#</cfoutput>
				  <br>
				  </td>
			  </tr>
			  </table>
			  </td>	  
	     </tr>   
	
	</cfif>	

</cfif>