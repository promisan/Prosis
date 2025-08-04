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

<cfparam name="URL.wcls"        default="normal">
<cfparam name="URL.Scope"       default="regular">
<cfparam name="URL.PersonNo"    default="">

<cfparam name="CLIENT.PersonNo" default="blank">
<cfparam name="URL.Code"        default="0">
<cfparam name="URL.ID"          default="PAS">
<cfparam name="URL.ID1"         default="{00000000-0000-0000-0000-000000000000}">

<!--- locate the contract/PAS --->

<cftry>

	<cfquery name="Contract" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Contract
		WHERE    ContractId = '#URL.ContractId#' 
	</cfquery>
	
		<cfcatch>
	
		<cf_message message="Problem, your PAR could not be located, please contact your administrator." return="No">
		<cfabort>
		
	</cfcatch>
	
</cftry>

<cfif URL.PersonNo eq "hyperlink" and URL.wcls neq "normal">

	<cfquery name="Entity" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_Entity 
		WHERE EntityCode = 'EntPas'
	</cfquery>	
	
	<cfif Entity.EnableEMailLogon eq "0">

	    <!--- match Logon with Contract holder, unsecure ---->
    	<cfset URL.PersonNo    = "#Contract.PersonNo#">
		<cfset CLIENT.PersonNo = "#Contract.PersonNo#">
	
	<cfelse>
	
		<!--- enforce a logon --->
		<cfset SESSION.authent= "0">		
				
	</cfif>
		
<cfelse>	

    <!--- not needed   <cfset CLIENT.PersonNo = "#URL.PersonNo#"> --->
	
</cfif>

<cfquery name="ContractAccess" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ContractActor
		WHERE    ContractId = '#URL.ContractId#' 
		AND      PersonNo   = '#CLIENT.PersonNo#' 
</cfquery>

<cfif ContractAccess.recordcount gte "1">
	<cfset URL.Scope = "regular">
</cfif>

<!--- 22/1/2018 reset if the navigation steps are reverted --->

<cfquery name="Check" 
datasource="appsEPas" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    TOP 1 *
	FROM      Ref_ContractSection R INNER JOIN
	          ContractSection C ON R.Code = C.ContractSection
	WHERE     R.TriggerGroup = 'Contract' 
	AND       C.ContractId = '#URL.ContractId#' 
	AND       C.ProcessStatus = '1'
	AND       C.Operational = 1
	ORDER BY  R.ListingOrder 
</cfquery>

<cfif check.recordcount eq "0">

	<cfquery name="reset" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE   Contract
		SET      ActionStatus = '0'
		WHERE    ContractId = '#URL.ContractId#'
	</cfquery>

</cfif>

<!--- populate the preparation flow --->

<cfquery name="Section" 
datasource="appsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ContractSection R 
	         LEFT OUTER JOIN ContractSection C ON R.Code = C.ContractSection AND C.ContractId = '#URL.ContractId#'
	WHERE    R.TriggerGroup = 'Contract'	
	AND      R.Operational = 1
	ORDER BY ListingOrder
</cfquery>
			
<cfloop query="Section">
			 	
		<cftry>
	
			<cfquery name="Insert" datasource="appsEPAS">
				INSERT INTO ContractSection (ContractId,ContractSection)
				VALUES ('#URL.ContractId#','#Code#')
			</cfquery> 
				
			<cfcatch></cfcatch>
	
		</cftry>
		
</cfloop>		

<cfquery name="Check" 
datasource="appsEPas" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    TOP 1 *
	FROM      Ref_ContractSection R INNER JOIN
	          ContractSection C ON R.Code = C.ContractSection
	WHERE     R.TriggerGroup = 'Contract' 
	AND       C.ContractId = '#URL.ContractId#' 
	AND       C.ProcessStatus = '0'
	AND       C.Operational = 1
	ORDER BY  R.ListingOrder 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Check" 
	datasource="appsePas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     Ref_ContractSection
		WHERE    TriggerGroup = 'Contract' 
		ORDER BY ListingOrder DESC 
	</cfquery>

</cfif>

<cfquery name="Employee" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM   Person
	    WHERE  PersonNo = '#Contract.PersonNo#'
</cfquery>

<cf_tl id="PAR" var="1">

<cf_screenTop height="100%" label="#lt_text#: #Employee.LastName#" layout="webapp" banner="gray" jquery="Yes">

<cf_panescript>	 
<cf_LayoutScript>
   
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	 
<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  

<cf_layout attributeCollection="#attrib#">

    <!---
	<cfif URL.scope neq "hyperlink">
    
	<cf_layoutarea 
	   	position  = "top"
	   	name      = "phptop"
	   	minsize	  = "10px"
		maxsize	  = "10px"
		style     = "border-bottom:1px solid 6688aa"
		size 	  = "15px">	
	
	   <table width="100%"  height="99%">	 
	    <tr><td valign="top" height="10" style="padding-top:3px"><cfinclude template="PASBanner.cfm"></td></tr>    
	   </table>
		 			  
	</cf_layoutarea>	
	
	</cfif>		
	
	--->	
	
	<cfparam name="url.owner" default="">
				
	<!--- validation is enabled for this source and enabled for the mission which is passed --->	
			
		<cfif URL.scope neq "hyperlink">
			 
			<cf_layoutarea 
			    position    = "left" 
				name        = "treebox" 
				maxsize     = "120" 		
				size        = "100" 
				minsize     = "100"
				style       = "border-right:1px solid 6688aa"
				collapsible = "true" 
				overflow    = "hidden"
				splitter    = "true">
				
				<table width="100%" height="100%"><tr><td align="center">	
				
				<iframe src="PASMenu.cfm?Section=#Check.code#&PersonNo=#URL.PersonNo#&Id=#URL.ContractId#"
		        name="left" id="left" width="100%" height="100%" style="overflow:hidden"
		        frameborder="0"></iframe>
				
				</td></tr>
				</table>
					
		     </cf_layoutarea>		
			
		</cfif>
		
		
	<cf_layoutarea position="center" name="box" style = "border-right:1px solid 6688aa">
				
`			<table width="100%" height="100%">
			<tr><td valign="top" style="padding-bottom:5px">	
			 			     					
				<iframe src="../#Check.TemplateURL#?Code=#URL.Code#&PersonNo=#URL.PersonNo#&Section=#Check.Code#&Topic=#Check.TemplateTopicId#&ContractId=#URL.ContractID##Check.TemplateCondition#&mid=#mid#"
		        name="right" id="right" width="100%" height="100%" scrolling="no"
		        frameborder="0"></iframe>
				
				</td>
			</tr>
			</table>
		
	</cf_layoutarea>	
	
					
</cf_layout>

</cfoutput>


<cf_screenbottom layout="webapp" html="no">
