<!--
    Copyright Â© 2025 Promisan B.V.

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
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Memo field size check</proDes>
 <proCom></proCom>
 <proCM></proCM>
</cfsilent>

<!--- End Prosis template framework --->

<!--- manual claim --->

<cfparam name="Form.ClaimException" default="">  
<cfparam name="Form.OrgUnit" default="">

<cfif form.OrgUnit neq "">

	<cfquery name="Update" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE ClaimRequest
	 SET    OrgUnit = '#Form.OrgUnit#'   
	 WHERE  ClaimRequestId IN (SELECT  ClaimRequestId 
	                           FROM    Claim 
							   WHERE   ClaimId  = '#Form.Key4#')
	</cfquery>
	
	<cfquery name="Reset" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE OrganizationObject
		 SET    Operational = '0'
		 WHERE  ObjectKeyValue4 = '#Form.Key4#'
		 AND    Operational = '1'
	</cfquery>

</cfif>

<cfquery name="Claim" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * FROM Claim
		 WHERE  ClaimId = '#Form.Key4#'		
</cfquery>

<cfparam name="Form.PointerClaimFinal" 
         default="0">

<cfquery name="Manual" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
     UPDATE   CLAIM
	 SET  
	 	  
	 <cfif Form.PointerClaimFinal neq claim.PointerClaimFinal>   
		 PointerClaimFinal      = '#Form.PointerClaimFinal#', 
	   	 PointerClaimFinalActor = '#SESSION.acc#',	
	 </cfif>
	 
	 <cfif Form.ClaimException neq "">    
	 ClaimException    = '#Form.ClaimException#',	
		 <cfif Form.ClaimException eq "1">
			 ClaimExceptionActor = '#SESSION.acc#',
		 <cfelse>
			 ClaimExceptionActor = NULL,
		 </cfif>	
	 </cfif>		 
	 ActionStatus = ActionStatus	 
	 WHERE    ClaimId  = '#Form.Key4#'
</cfquery>

<cfparam name="Form.ClaimSection" default="">

<cfquery name="Problem" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE ClaimSection
	 SET    ProcessProblem = 0
	 WHERE  ClaimId = '#Form.Key4#'
</cfquery>	
	
<cfif Form.ClaimSection neq "">
	
	<cfquery name="Problem" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE ClaimSection
		 SET    ProcessProblem = 1,
		        ActionId = '#URL.ID#'   
		 WHERE  ClaimId = '#Form.Key4#'
		 AND    ClaimSection IN (#preserveSingleQuotes(Form.ClaimSection)#) 
	</cfquery>	
	
	<cfif form.claimsection neq "">
		
		<cfloop index="itm" list="#Form.ClaimSection#" delimiters=",">
		
			<cfset it = replace(itm,"'","","ALL")> 
		
			<cfset memo = evaluate("Form.#it#_Memo")>
						
			<cfif Len(memo) gt 400>
				 <cf_alert message = "Your entered a reason that exceeded the allowed size of 400 characters."
				  return = "back">
				  <cfabort>
			</cfif>
			
			<cfquery name="Update" 
				 datasource="appsTravelClaim" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 UPDATE ClaimSection
				 SET    ProcessProblemMemo = '#memo#'
				 WHERE  ClaimId = '#Form.Key4#'
				 AND    ClaimSection = '#it#' 
			</cfquery>		
		
		</cfloop>
	
	</cfif>

</cfif>
		