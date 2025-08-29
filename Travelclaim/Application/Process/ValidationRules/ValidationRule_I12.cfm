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
<!--- 
Validation Rule :  I12
Name			:  Prevent early submission
Steps			:  Determine if current date lies after the expected return date
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
				
	<cfif diff lt 0>
	
	     <cfset submission = "0">
	
	  	<tr><td valign="top" bgcolor="C0C0C0"></td></tr>
		 <tr>
			  <td valign="top" bgcolor="FDDFDB">
			  <table width="94%" cellspacing="2" cellpadding="2" align="center">
			  <tr><td valign="top" height="30">
				  <font color="FF0000"><b>Problem</b></font> : You can NOT submit this claim.
				  <br>
				    <cfoutput>#MessagePerson#</cfoutput>
				   <br>
				  Please contact the office that issued the Travel Authorization.
				  </td></tr>
			  </table>
			  </td>	  
	     </tr>   
	
	</cfif>	

</cfif>