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

<cfsilent>
  <proUsr>Neemalagm Eswaran + Huda Seid </proUsr>
  <proOwn>Neemalagm Eswaran + Huda Seid</proOwn>
 <proDes>Validation Rule X02 for disabling claims as non-express</proDes>
 <proCom>HS: New Validation put in place for issue #8 and issue # 62 in the TCP_issues.xls document to pick travel requests with the below issues:
 			1. If the DSA dates are within the Itinerary dates 
			2. If the dsa locations are in line with the Itinerary locations
			3. Check if the number of dsa days is greater than the number of days in the itinerary line. 
			FDT 12/08/2008: validation 3. above not implemented pending further review.
 </proCom>
</cfsilent>
<!---------------------------------------------------------------------------------------------------------
Validation Rule :  X02    By NE1 18th June 2008 
Name		:  verify if express claim can be shown
	   1. Only allow express claim if the DSA dates are within the Itinerary dates 
	   i.e. the DSA begin date cannot be earlier than the ITN departure date and the DSA end date
	    cannot be later than the TVRQ return date.  (Issue# 62)

		Added by HS (28/07/2008)
		Added condition to:
		1. Check if the location in the DSA detail is in line with the location in the itinerary.
		2. Check if the number of days in itinerary is equal to the number of day in the DSA details.
		
		If not, the claim would be flagged as non-Express and those inconsistencies would be picked up by the already
		existing validations i.e.R03,R04,R05 
   
------------------------------------------------------------------------------------------------------------->
<!---<cfoutput>#URL.RequestId#</cfoutput> <cfabort> 
 condition 1 

<cfset My_IP_address = '#CGI.REMOTE_ADDR#' >

<cfif #MY_IP_ADDRESS# eq '157.150.104.144' or #MY_IP_ADDRESS# eq '157.150.104.143'> ---->

<!----Check if this claim is already disabled as express claim ---------------------->
<cfquery name="Check_express" 	datasource="appsTravelClaim" username="#SESSION.login#"  password="#SESSION.dbpw#">
				SELECT    DISTINCT Req.ClaimRequestId
				FROM      ClaimRequestLine Req,
						  Ref_ClaimCategory R
				WHERE     Req.ClaimCategory = R.Code
				AND       R.DisableExpress = '1'
				AND       Req.ClaimRequestId = '#URL.RequestId#'
</cfquery>
		
<cfif #check_express.recordcount# gt "0">
				   <cfset express = 0>
				
</cfif>
<!-----------------Check if the validation is operational--------------------------------->
<cfquery name="RulesEnforce"  datasource="appsTravelClaim">
	SELECT  * 
	FROM    Ref_Validation 
    WHERE   ValidationClass ='Express' 
	AND     operational = 1 
	AND    code ='X02'
	        
</cfquery>

<cfif RulesEnforce.recordcount neq  0>

	<cfif '#URL.RequestId#' NEQ "">

	  <cfquery name="Condition1_ITIN" 	datasource="appsTravelClaim" 	username="#SESSION.login#" 	password="#SESSION.dbpw#">
		SELECT     Min(DateDeparture) as DateDep,Max(DateReturn) as DateRet 
		FROM     ClaimRequestItinerary Itin 
		WHERE  	 ClaimRequestId = '#URL.RequestId#'
	    </cfquery>
		
		<!--- FDT/Kirk 12/08/2008 : comparing date transformed in String is incorrect 
		<cfset ITIN_DateDep = #DateFormat(#Condition1_ITIN.DateDep#,"dd/mm/yyyy")# >
		<cfset ITIN_DateRet = #DateFormat(#Condition1_ITIN.DateRet#,"dd/mm/yyyy")# > 
		--->
			
		<cfquery name="Condition1_DSA" 	datasource="appsTravelClaim" 	username="#SESSION.login#" 	password="#SESSION.dbpw#">
		SELECT    Min(DateEffective) DateDep,Max(DateExpiration) as DateRet
		FROM      ClaimRequestDSA 
		WHERE  	 ClaimRequestId = '#URL.RequestId#'
 	    </cfquery>
		
		<!--- FDT/Kirk 12/08/2008 : comparing date transformed in String is incorrect 		
		<cfset DSA_DateDep = #DateFormat(#Condition1_DSA.DateDep#,"dd/mm/yyyy")#>
		<cfset DSA_DateRet = #DateFormat(#Condition1_DSA.DateRet#,"dd/mm/yyyy")#> 
		
		<cfif #DSA_DateDep# LT #ITIN_DateDep# OR #DSA_DateRet# GT #ITIN_DateRet# >
				<cfset express = 0>
		</cfif>    
		--->
		<!---DSA/ITN Date Check end if   isNull(Max(DateReturn),'01/01/2000') as DateRet  --->
		
		<!--- FDT/Kirk 12/08/2008 : We compare the dates as dates and not as string --->
		<cfif #Condition1_DSA.DateDep# LT #Condition1_ITIN.DateDep# OR #Condition1_DSA.DateRet# GT #Condition1_ITIN.DateRet# >
				<cfset express = 0>
		</cfif>    
		
<!--------------------------------------Added by Huda Seid (28/07/2008) Issue # 8----------------------------------------------------------------->
<!--------1. Check if the location in the travel request dsa line is as in location in the travel request itinerary--------------->
		<cfif express eq "1">
			<cfquery name="Condition2" 	datasource="appsTravelClaim" 	username="#SESSION.login#" 	password="#SESSION.dbpw#">
				 SELECT  *
				 FROM     	ClaimRequestDSA CLMDSA
				 WHERE 		claimrequestid='#URL.RequestId#' and
							servicelocation not in (SELECT locationcode 
												FROM dbo.ClaimRequestItinerary CLMIT,dbo.Ref_CountryCityLocation RFCL
												WHERE CLMIT.countrycityid=RFCL.countrycityid and 
														CLMIT.claimrequestid=CLMDSA.claimrequestid)
			</cfquery>
			<cfif #condition2.recordcount# gt "0"> 
						 <cfset express = 0>
				
			</cfif> 
		
		</cfif>	
		
		
		
	</cfif>	  <!--- URL Request End if --->
	
</cfif>   <!--- Rule Enforce End if --->




